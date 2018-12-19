From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/28] KVM: arm/arm64: Fix unintended stage 2 PMD mappings
Date: Wed, 19 Dec 2018 18:03:46 +0000
Message-ID: <20181219180349.242681-26-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 707F64A352
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IJ7WfzkYiGIh for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:19 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CE264A37B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:19 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <christoffer.dall@arm.com>

There are two things we need to take care of when we create block
mappings in the stage 2 page tables:

  (1) The alignment within a PMD between the host address range and the
  guest IPA range must be the same, since otherwise we end up mapping
  pages with the wrong offset.

  (2) The head and tail of a memory slot may not cover a full block
  size, and we have to take care to not map those with block
  descriptors, since we could expose memory to the guest that the host
  did not intend to expose.

So far, we have been taking care of (1), but not (2), and our commentary
describing (1) was somewhat confusing.

This commit attempts to factor out the checks of both into a common
function, and if we don't pass the check, we won't attempt any PMD
mappings for neither hugetlbfs nor THP.

Note that we used to only check the alignment for THP, not for
hugetlbfs, but as far as I can tell the check needs to be applied to
both scenarios.

Cc: Ralph Palutke <ralph.palutke@fau.de>
Cc: Lukas Braun <koomi@moshbit.net>
Reported-by: Lukas Braun <koomi@moshbit.net>
Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/mmu.c | 86 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 64 insertions(+), 22 deletions(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index f605514395a1..dee3dbd98712 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1595,6 +1595,63 @@ static void kvm_send_hwpoison_signal(unsigned long address,
 	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
 }
 
+static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
+					       unsigned long hva)
+{
+	gpa_t gpa_start, gpa_end;
+	hva_t uaddr_start, uaddr_end;
+	size_t size;
+
+	size = memslot->npages * PAGE_SIZE;
+
+	gpa_start = memslot->base_gfn << PAGE_SHIFT;
+	gpa_end = gpa_start + size;
+
+	uaddr_start = memslot->userspace_addr;
+	uaddr_end = uaddr_start + size;
+
+	/*
+	 * Pages belonging to memslots that don't have the same alignment
+	 * within a PMD for userspace and IPA cannot be mapped with stage-2
+	 * PMD entries, because we'll end up mapping the wrong pages.
+	 *
+	 * Consider a layout like the following:
+	 *
+	 *    memslot->userspace_addr:
+	 *    +-----+--------------------+--------------------+---+
+	 *    |abcde|fgh  Stage-1 PMD    |    Stage-1 PMD   tv|xyz|
+	 *    +-----+--------------------+--------------------+---+
+	 *
+	 *    memslot->base_gfn << PAGE_SIZE:
+	 *      +---+--------------------+--------------------+-----+
+	 *      |abc|def  Stage-2 PMD    |    Stage-2 PMD     |tvxyz|
+	 *      +---+--------------------+--------------------+-----+
+	 *
+	 * If we create those stage-2 PMDs, we'll end up with this incorrect
+	 * mapping:
+	 *   d -> f
+	 *   e -> g
+	 *   f -> h
+	 */
+	if ((gpa_start & ~S2_PMD_MASK) != (uaddr_start & ~S2_PMD_MASK))
+		return false;
+
+	/*
+	 * Next, let's make sure we're not trying to map anything not covered
+	 * by the memslot. This means we have to prohibit PMD size mappings
+	 * for the beginning and end of a non-PMD aligned and non-PMD sized
+	 * memory slot (illustrated by the head and tail parts of the
+	 * userspace view above containing pages 'abcde' and 'xyz',
+	 * respectively).
+	 *
+	 * Note that it doesn't matter if we do the check using the
+	 * userspace_addr or the base_gfn, as both are equally aligned (per
+	 * the check above) and equally sized.
+	 */
+	return (hva & S2_PMD_MASK) >= uaddr_start &&
+	       (hva & S2_PMD_MASK) + S2_PMD_SIZE <= uaddr_end;
+}
+
 static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 			  struct kvm_memory_slot *memslot, unsigned long hva,
 			  unsigned long fault_status)
@@ -1621,6 +1678,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		return -EFAULT;
 	}
 
+	if (!fault_supports_stage2_pmd_mappings(memslot, hva))
+		force_pte = true;
+
+	if (logging_active)
+		force_pte = true;
+
 	/* Let's check if we will get back a huge page backed by hugetlbfs */
 	down_read(&current->mm->mmap_sem);
 	vma = find_vma_intersection(current->mm, hva, hva + 1);
@@ -1637,28 +1700,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	 */
 	if ((vma_pagesize == PMD_SIZE ||
 	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pud(kvm))) &&
-	    !logging_active) {
+	    !force_pte) {
 		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
-	} else {
-		/*
-		 * Fallback to PTE if it's not one of the Stage 2
-		 * supported hugepage sizes or the corresponding level
-		 * doesn't exist
-		 */
-		vma_pagesize = PAGE_SIZE;
-
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
 
@@ -1697,7 +1740,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		 * should not be mapped with huge pages (it introduces churn
 		 * and performance degradation), so force a pte mapping.
 		 */
-		force_pte = true;
 		flags |= KVM_S2_FLAG_LOGGING_ACTIVE;
 
 		/*
-- 
2.19.2
