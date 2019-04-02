From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH 5/8] KVM: arm/arm64: Enforce PTE mappings at stage2 when
 needed
Date: Tue, 2 Apr 2019 10:47:16 +0100
Message-ID: <20190402094716.GA1082@en101>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
 <20190328133608.110805-6-marc.zyngier@arm.com>
 <496ad70d-eaa5-c46e-ddf0-d07607522eeb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7252A4A41A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 05:47:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U888bFrnBSEK for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Apr 2019 05:47:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C36934A34E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Apr 2019 05:47:27 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <496ad70d-eaa5-c46e-ddf0-d07607522eeb@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 01, 2019 at 07:10:37PM +0200, Auger Eric wrote:
> Hi Suzuki,
> 
> On 3/28/19 2:36 PM, Marc Zyngier wrote:
> > From: Suzuki K Poulose <suzuki.poulose@arm.com>
> > 
> > commit 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> > made the checks to skip huge mappings, stricter. However it introduced
> > a bug where we still use huge mappings, ignoring the flag to
> > use PTE mappings, by not reseting the vma_pagesize to PAGE_SIZE.
> > 
> > Also, the checks do not cover the PUD huge pages, that was
> > under review during the same period. This patch fixes both
> > the issues.
> 
> I face a regression with this patch. My guest gets stuck. I am running
> on AMD Seattle. Reverting the patch makes things work again for me. I
> run with qemu. In this scenario I don't use hugepages. I use 64kB page
> size for both the host and guest.

Hi Eric,

Thanks for the testing. Does the following patch fix the issue for you ?


---8>---
kvm: arm: Skip transparent huge pages in unaligned memslots

We silently create stage2 huge mappings for a memslot with
unaligned IPA and user address.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 virt/kvm/arm/mmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 27c9583..4a22f5b 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -1412,7 +1412,9 @@ static bool transparent_hugepage_adjust(kvm_pfn_t *pfnp, phys_addr_t *ipap)
 		 * page accordingly.
 		 */
 		mask = PTRS_PER_PMD - 1;
-		VM_BUG_ON((gfn & mask) != (pfn & mask));
+		/* Skip memslots with unaligned IPA and user address */
+		if ((gfn & mask) != (pfn & mask))
+			return false;
 		if (pfn & mask) {
 			*ipap &= PMD_MASK;
 			kvm_release_pfn_clean(pfn);
-- 
2.7.4


Kind regards
Suzuki


> 
> Thanks
> 
> Eric
> > 
> > Fixes : 6794ad5443a2118 ("KVM: arm/arm64: Fix unintended stage 2 PMD mappings")
> > Reported-by: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Zenghui Yu <yuzenghui@huawei.com>
> > Cc: Christoffer Dall <christoffer.dall@arm.com>
> > Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> > Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> > ---
> >  virt/kvm/arm/mmu.c | 43 +++++++++++++++++++++----------------------
> >  1 file changed, 21 insertions(+), 22 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> > index ffd7acdceac7..bcdf978c0d1d 100644
> > --- a/virt/kvm/arm/mmu.c
> > +++ b/virt/kvm/arm/mmu.c
> > @@ -1594,8 +1594,9 @@ static void kvm_send_hwpoison_signal(unsigned long address,
> >  	send_sig_mceerr(BUS_MCEERR_AR, (void __user *)address, lsb, current);
> >  }
> >  
> > -static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
> > -					       unsigned long hva)
> > +static bool fault_supports_stage2_huge_mapping(struct kvm_memory_slot *memslot,
> > +					       unsigned long hva,
> > +					       unsigned long map_size)
> >  {
> >  	gpa_t gpa_start;
> >  	hva_t uaddr_start, uaddr_end;
> > @@ -1610,34 +1611,34 @@ static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
> >  
> >  	/*
> >  	 * Pages belonging to memslots that don't have the same alignment
> > -	 * within a PMD for userspace and IPA cannot be mapped with stage-2
> > -	 * PMD entries, because we'll end up mapping the wrong pages.
> > +	 * within a PMD/PUD for userspace and IPA cannot be mapped with stage-2
> > +	 * PMD/PUD entries, because we'll end up mapping the wrong pages.
> >  	 *
> >  	 * Consider a layout like the following:
> >  	 *
> >  	 *    memslot->userspace_addr:
> >  	 *    +-----+--------------------+--------------------+---+
> > -	 *    |abcde|fgh  Stage-1 PMD    |    Stage-1 PMD   tv|xyz|
> > +	 *    |abcde|fgh  Stage-1 block  |    Stage-1 block tv|xyz|
> >  	 *    +-----+--------------------+--------------------+---+
> >  	 *
> >  	 *    memslot->base_gfn << PAGE_SIZE:
> >  	 *      +---+--------------------+--------------------+-----+
> > -	 *      |abc|def  Stage-2 PMD    |    Stage-2 PMD     |tvxyz|
> > +	 *      |abc|def  Stage-2 block  |    Stage-2 block   |tvxyz|
> >  	 *      +---+--------------------+--------------------+-----+
> >  	 *
> > -	 * If we create those stage-2 PMDs, we'll end up with this incorrect
> > +	 * If we create those stage-2 blocks, we'll end up with this incorrect
> >  	 * mapping:
> >  	 *   d -> f
> >  	 *   e -> g
> >  	 *   f -> h
> >  	 */
> > -	if ((gpa_start & ~S2_PMD_MASK) != (uaddr_start & ~S2_PMD_MASK))
> > +	if ((gpa_start & (map_size - 1)) != (uaddr_start & (map_size - 1)))
> >  		return false;
> >  
> >  	/*
> >  	 * Next, let's make sure we're not trying to map anything not covered
> > -	 * by the memslot. This means we have to prohibit PMD size mappings
> > -	 * for the beginning and end of a non-PMD aligned and non-PMD sized
> > +	 * by the memslot. This means we have to prohibit block size mappings
> > +	 * for the beginning and end of a non-block aligned and non-block sized
> >  	 * memory slot (illustrated by the head and tail parts of the
> >  	 * userspace view above containing pages 'abcde' and 'xyz',
> >  	 * respectively).
> > @@ -1646,8 +1647,8 @@ static bool fault_supports_stage2_pmd_mappings(struct kvm_memory_slot *memslot,
> >  	 * userspace_addr or the base_gfn, as both are equally aligned (per
> >  	 * the check above) and equally sized.
> >  	 */
> > -	return (hva & S2_PMD_MASK) >= uaddr_start &&
> > -	       (hva & S2_PMD_MASK) + S2_PMD_SIZE <= uaddr_end;
> > +	return (hva & ~(map_size - 1)) >= uaddr_start &&
> > +	       (hva & ~(map_size - 1)) + map_size <= uaddr_end;
> >  }
> >  
> >  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> > @@ -1676,12 +1677,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  		return -EFAULT;
> >  	}
> >  
> > -	if (!fault_supports_stage2_pmd_mappings(memslot, hva))
> > -		force_pte = true;
> > -
> > -	if (logging_active)
> > -		force_pte = true;
> > -
> >  	/* Let's check if we will get back a huge page backed by hugetlbfs */
> >  	down_read(&current->mm->mmap_sem);
> >  	vma = find_vma_intersection(current->mm, hva, hva + 1);
> > @@ -1692,6 +1687,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	}
> >  
> >  	vma_pagesize = vma_kernel_pagesize(vma);
> > +	if (logging_active ||
> > +	    !fault_supports_stage2_huge_mapping(memslot, hva, vma_pagesize)) {
> > +		force_pte = true;
> > +		vma_pagesize = PAGE_SIZE;
> > +	}
> > +
> >  	/*
> >  	 * The stage2 has a minimum of 2 level table (For arm64 see
> >  	 * kvm_arm_setup_stage2()). Hence, we are guaranteed that we can
> > @@ -1699,11 +1700,9 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
> >  	 * As for PUD huge maps, we must make sure that we have at least
> >  	 * 3 levels, i.e, PMD is not folded.
> >  	 */
> > -	if ((vma_pagesize == PMD_SIZE ||
> > -	     (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm))) &&
> > -	    !force_pte) {
> > +	if (vma_pagesize == PMD_SIZE ||
> > +	    (vma_pagesize == PUD_SIZE && kvm_stage2_has_pmd(kvm)))
> >  		gfn = (fault_ipa & huge_page_mask(hstate_vma(vma))) >> PAGE_SHIFT;
> > -	}
> >  	up_read(&current->mm->mmap_sem);
> >  
> >  	/* We need minimum second+third level pages */
> > 
