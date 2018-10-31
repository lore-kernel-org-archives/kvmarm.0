From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v2] KVM: arm/arm64: Check memslot bounds before mapping
 hugepages
Date: Wed, 31 Oct 2018 17:00:49 +0100
Message-ID: <20181031160049.GF12057@e113682-lin.lund.arm.com>
References: <20180926151135.16083-1-koomi@moshbit.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180926151135.16083-1-koomi@moshbit.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Braun <koomi@moshbit.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Ralph Palutke <ralph.palutke@fau.de>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Sep 26, 2018 at 05:11:35PM +0200, Lukas Braun wrote:
> Userspace can create a memslot with memory backed by (transparent)
> hugepages, but with bounds that do not align with hugepages.
> In that case, we cannot map the entire region in the guest as hugepages
> without exposing additional host memory to the guest and potentially
> interfering with other memslots.
> Consequently, this patch adds a bounds check when populating guest page
> tables and forces the creation of regular PTEs if mapping an entire
> hugepage would violate the memslots bounds.
> 
> Signed-off-by: Lukas Braun <koomi@moshbit.net>

It took me fairly long to understand why we didn't catch that when we
introduced the 'offset check', which indicates that this function is
just getting too long to read.

I don't absolutely mind the fix below, but it does pile on to the
complexity.

Here's an alternative approach (untested, of course), but it slightly
limits the functionality we have today, in favor of simplicitly.  (Also
not sure if it's too large for cc'ing stable).


Thanks,

    Christoffer


diff --git a/arch/arm64/include/asm/stage2_pgtable.h b/arch/arm64/include/asm/stage2_pgtable.h
index 8b68099348e5..ccb003dfdb97 100644
--- a/arch/arm64/include/asm/stage2_pgtable.h
+++ b/arch/arm64/include/asm/stage2_pgtable.h
@@ -119,6 +119,11 @@ static inline phys_addr_t stage2_pmd_addr_end(phys_addr_t addr, phys_addr_t end)
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
 
+static inline bool stage2_pmd_aligned(phys_addr_t addr)
+{
+	return !!(addr & ~S2_PMD_MASK);
+}
+
 #endif		/* STAGE2_PGTABLE_LEVELS > 2 */
 
 #define stage2_pte_table_empty(ptep)			kvm_page_empty(ptep)
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index ed162a6c57c5..e5709ccee224 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1466,6 +1466,22 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 	send_sig_info(SIGBUS, &info, current);
 }
 
+static bool memslot_supports_pmd_mappings(struct kvm_memory_slot *memslot)
+{
+	gpa_t gpa_start, gpa_end;
+	hva_t hva_start, hva_end;
+	size_t size;
+
+	size = memslot->npages * PAGE_SIZE;
+	gpa_start = memslot->base_gfn << PAGE_SHIFT;
+	gpa_end = gpa_start + size;
+	hva_start = memslot->userspace_addr;
+	hva_end = hva_start + size;
+
+	return stage2_pmd_aligned(gpa_start) && stage2_pmd_aligned(gpa_end) &&
+	       stage2_pmd_aligned(hva_start) && stage2_pmd_aligned(hva_end);
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1491,6 +1507,22 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	/*
+	 * We limit PMD-size mappings to situations where both the userspace
+	 * region and GPA region is aligned to the stage2 pmd size and is a
+	 * multiple of the stage2 pmd size in total size.  This ensures
+	 * that we won't map unintended host memory and that we'll map the
+	 * intended user pages (not skewed by mismatching PMD offsets).
+	 *
+	 * We miss out on the opportunity to map non-edge PMD regions in
+	 * unaligned memslots.  Oh well...
+	 */
+	if (!memslot_supports_pmd_mappings(memslot))
+		force_pte = true;
+
+	if (logging_active)
+		force_pte = true;
+
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma_intersection(current->mm, hva, hva + 1);
@@ -1500,22 +1532,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
-	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
+	if (vma_kernel_pagesize(vma) == PMD_SIZE && !force_pte) {
 		hugetlb = true;
 		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
-	} else {
-		/*
-		 * Pages belonging to memslots that don't have the same
-		 * alignment for userspace and IPA cannot be mapped using
-		 * block descriptors even if the pages belong to a THP for
-		 * the process, because the stage-2 block descriptor will
-		 * cover more than a single THP and we loose atomicity for
-		 * unmapping, updates, and splits of the THP or other pages
-		 * in the stage-2 block range.
-		 */
-		if ((memslot->userspace_addr & ~PMD_MASK) !=
-		    ((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK))
-			force_pte = true;
 	}
 	up_read(&current->mm->mmap_sem);
 
@@ -1554,7 +1573,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * should not be mapped with huge pages (it introduces churn
 		 * and performance degradation), so force a pte mapping.
 		 */
-		force_pte = true;
 		flags |= KVM_S2_FLAG_LOGGING_ACTIVE;
 
 		/*
