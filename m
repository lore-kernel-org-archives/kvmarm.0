From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Fix unintended stage 2 PMD mappings
Date: Fri, 2 Nov 2018 14:43:04 +0100
Message-ID: <20181102134304.GX12057@e113682-lin.lund.arm.com>
References: <20181102075322.20549-1-christoffer.dall@arm.com>
 <9ed2e006-2233-bde9-ab2f-46cd6cddb321@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41AEC4A2BA
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 09:43:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xsa5gLcgt5Pv for <kvmarm@lists.cs.columbia.edu>;
 Fri,  2 Nov 2018 09:43:07 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81EE54A236
 for <kvmarm@lists.cs.columbia.edu>; Fri,  2 Nov 2018 09:43:07 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <9ed2e006-2233-bde9-ab2f-46cd6cddb321@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Ralph Palutke <ralph.palutke@fau.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 02, 2018 at 10:26:37AM +0000, Suzuki K Poulose wrote:
> Hi Christoffer,
> 
> On 02/11/18 07:53, Christoffer Dall wrote:
> >There are two things we need to take care of when we create block
> >mappings in the stage 2 page tables:
> >
> >   (1) The alignment within a PMD between the host address range and the
> >   guest IPA range must be the same, since otherwise we end up mapping
> >   pages with the wrong offset.
> >
> >   (2) The head and tail of a memory slot may not cover a full block
> >   size, and we have to take care to not map those with block
> >   descriptors, since we could expose memory to the guest that the host
> >   did not intend to expose.
> >
> >So far, we have been taking care of (1), but not (2), and our commentary
> >describing (1) was somewhat confusing.
> >
> >This commit attempts to factor out the checks of both into a common
> >function, and if we don't pass the check, we won't attempt any PMD
> >mappings for neither hugetlbfs nor THP.
> >
> >Note that we used to only check the alignment for THP, not for
> >hugetlbfs, but as far as I can tell the check needs to be applied to
> >both scenarios.
> >
> >Cc: Ralph Palutke <ralph.palutke@fau.de>
> >Cc: Lukas Braun <koomi@moshbit.net>
> >Reported-by: Lukas Braun <koomi@moshbit.net>
> >Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> >---
> >  virt/kvm/arm/mmu.c | 79 +++++++++++++++++++++++++++++++++++++---------
> >  1 file changed, 64 insertions(+), 15 deletions(-)
> >
> >diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> >index 5eca48bdb1a6..4e7572656b5c 100644
> >--- a/virt/kvm/arm/mmu.c
> >+++ b/virt/kvm/arm/mmu.c
> >@@ -1470,6 +1470,63 @@ static void kvm_send_hwpoison_signal(unsigned long address,
> >  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
> >  }
> >+static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
> >+					       unsigned long hva)
> >+{
> >+	gpa_t gpa_start, gpa_end;
> >+	hva_t uaddr_start, uaddr_end;
> >+	size_t size;
> >+
> >+	size = memslot->npages * PAGE_SIZE;
> >+
> >+	gpa_start = memslot->base_gfn << PAGE_SHIFT;
> >+	gpa_end = gpa_start + size;
> >+
> >+	uaddr_start = memslot->userspace_addr;
> >+	uaddr_end = uaddr_start + size;
> >+
> >+	/*
> >+	 * Pages belonging to memslots that don't have the same alignment
> >+	 * within a PMD for userspace and IPA cannot be mapped with stage-2
> >+	 * PMD entries, because we'll end up mapping the wrong pages.
> >+	 *
> >+	 * Consider a layout like the following:
> >+	 *
> >+	 *    memslot->userspace_addr:
> >+	 *    +-----+--------------------+--------------------+---+
> >+	 *    |abcde|fgh  Stage-1 PMD    |    Stage-1 PMD   tv|xyz|
> >+	 *    +-----+--------------------+--------------------+---+
> >+	 *
> >+	 *    memslot->base_gfn << PAGE_SIZE:
> >+	 *      +---+--------------------+--------------------+-----+
> >+	 *      |abc|def  Stage-2 PMD    |    Stage-2 PMD     |tvxyz|
> >+	 *      +---+--------------------+--------------------+-----+
> >+	 *
> >+	 * If we create those stage-2 PMDs, we'll end up with this incorrect
> >+	 * mapping:
> >+	 *   d -> f
> >+	 *   e -> g
> >+	 *   f -> h
> >+	 */
> 
> Nice ! The comment makes it so easy to understand the problem.
> 
> >+	if ((gpa_start & ~S2_PMD_MASK) != (uaddr_start & ~S2_PMD_MASK))
> >+		return false;
> >+
> >+	/*
> >+	 * Next, let's make sure we're not trying to map anything not covered
> >+	 * by the memslot. This means we have to prohibit PMD size mappings
> >+	 * for the beginning and end of a non-PMD aligned and non-PMD sized
> >+	 * memory slot (illustrated by the head and tail parts of the
> >+	 * userspace view above containing pages 'abcde' and 'xyz',
> >+	 * respectively).
> >+	 *
> >+	 * Note that it doesn't matter if we do the check using the
> >+	 * userspace_addr or the base_gfn, as both are equally aligned (per
> >+	 * the check above) and equally sized.
> >+	 */
> >+	return (hva & S2_PMD_MASK) >= uaddr_start &&
> >+	       (hva & S2_PMD_MASK) + S2_PMD_SIZE <= uaddr_end;
> 
> Shouldn't this be :
> 
> 		(hva & S2_PMD_MASK) + S2_PMD_SIZE < uaddr_end;
> 
> 		or
> 
> 		(hva & S2_PMD_MASK) + S2_PMD_SIZE <= (uaddr_end - 1);

Let's consider an example.  Imagine a 4MB region (1024 4K pages) start
at 0, and we want to ensure that the address is within one of the 2MB
pages.

That means, size will be:

  size = 1024 * 4096 = 4194304
  uaddr_start = 0
  uaddr_end = 0 + 4194304 = 4194304

and the comparison check for anything in the first 2MB region becomes

      return 0 >= 0 && 2097152 <= 4194304;

which is what we want.

The comparison check for anything in the second 2MB region becomes

      return 2097152 >= 0 && 4194304 <= 4194304;

which is also what we want.

If we had done a stricly less than or subtracted one from uaddr_end this
check would fail, which we don't want.

Am I missing something?

> 
> >+}
> >+
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  			  struct kvm_memory_slot *memslot, unsigned long hva,
> >  			  unsigned long fault_status)
> >@@ -1495,6 +1552,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  		return -EFAULT;
> >  	}
> >+	if (!fault_supports_stage2_pmd_mappings(memslot, hva))
> >+		force_pte = true;
> >+
> >+	if (logging_active)
> >+		force_pte = true;
> 
> super minor nit: If we combine the checks, may be we could skip checking
> the  alignments, when logging is active.
> 
> 	if (logging_active ||
> 	    !fault_supports_stage2_pmd_mappings(memslot, hva))
> 		force_pte = true;
> 

I prefer the way the code is written now, because logging active is a
logically very separate concept from checking the boundaries, and this
is realy the slow path anyway, so not sure there's any measurable
benefit.

More generally, I'd like user_mem_abort() to become more like:

if (check1())
   conditionr1 = value;
if (check2())
   condition2 = value;
if (check3())
   condition3 = value;

manipulate_page_tables(condition1, condition2, condition3, ...);

And I'll have a got at that following Punit's PUD huge pages.

> >+
> >  	/* Let's check if we will get back a huge page backed by hugetlbfs */
> >  	down_read(&current->mm->mmap_sem);
> >  	vma = find_vma_intersection(current->mm, hva, hva + 1);
> >@@ -1504,22 +1567,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  		return -EFAULT;
> >  	}
> >-	if (vma_kernel_pagesize(vma) == PMD_SIZE && !logging_active) {
> >+	if (vma_kernel_pagesize(vma) == PMD_SIZE && !force_pte) {
> >  		hugetlb = true;
> >  		gfn = (fault_ipa & PMD_MASK) >> PAGE_SHIFT;
> >-	} else {
> >-		/*
> >-		 * Pages belonging to memslots that don't have the same
> >-		 * alignment for userspace and IPA cannot be mapped using
> >-		 * block descriptors even if the pages belong to a THP for
> >-		 * the process, because the stage-2 block descriptor will
> >-		 * cover more than a single THP and we loose atomicity for
> >-		 * unmapping, updates, and splits of the THP or other pages
> >-		 * in the stage-2 block range.
> >-		 */
> >-		if ((memslot->userspace_addr & ~PMD_MASK) !=
> >-		    ((memslot->base_gfn << PAGE_SHIFT) & ~PMD_MASK))
> >-			force_pte = true;
> >  	}
> >  	up_read(&current->mm->mmap_sem);
> >@@ -1558,7 +1608,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  		 * should not be mapped with huge pages (it introduces churn
> >  		 * and performance degradation), so force a pte mapping.
> >  		 */
> >-		force_pte = true;
> >  		flags |= KVM_S2_FLAG_LOGGING_ACTIVE;
> 
> Otherwise looks good to me.
> 

Thanks!

    Christoffer
