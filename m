From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] kvm: arm: Fix handling of stage2 huge mappings
Date: Wed, 20 Mar 2019 10:11:26 +0000
Message-ID: <20190320101126.11ff63af@why.wild-wind.fr.eu.org>
References: <25971fd5-3774-3389-a82a-04707480c1e0@huawei.com>
        <1553004668-23296-1-git-send-email-suzuki.poulose@arm.com>
        <86d0mmynaz.wl-marc.zyngier@arm.com>
        <5e7e40b4-7983-4440-179a-6f107cee5994@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5e7e40b4-7983-4440-179a-6f107cee5994@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry@arm.com, wanghaibin.wang@huawei.com, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, zhengxiang9@huawei.com, yuzenghui@huawei.com, christoffer.dall@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 20 Mar 2019 09:44:38 +0000
Suzuki K Poulose <suzuki.poulose@arm.com> wrote:

> Hi Marc,
> 
> On 20/03/2019 08:15, Marc Zyngier wrote:
> > Hi Suzuki,
> > 
> > On Tue, 19 Mar 2019 14:11:08 +0000,
> > Suzuki K Poulose <suzuki.poulose@arm.com> wrote:  
> >>
> >> We rely on the mmu_notifier call backs to handle the split/merge
> >> of huge pages and thus we are guaranteed that, while creating a
> >> block mapping, either the entire block is unmapped at stage2 or it
> >> is missing permission.
> >>
> >> However, we miss a case where the block mapping is split for dirty
> >> logging case and then could later be made block mapping, if we cancel the
> >> dirty logging. This not only creates inconsistent TLB entries for
> >> the pages in the the block, but also leakes the table pages for
> >> PMD level.
> >>
> >> Handle this corner case for the huge mappings at stage2 by
> >> unmapping the non-huge mapping for the block. This could potentially
> >> release the upper level table. So we need to restart the table walk
> >> once we unmap the range.
> >>
> >> Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
> >> Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
> >> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> >> Cc: Zhengui Yu <yuzenghui@huawei.com>
> >> Cc: Marc Zyngier <marc.zyngier@arm.com>
> >> Cc: Christoffer Dall <christoffer.dall@arm.com>
> >> Signed-off-by: Suzuki K Poulose ...  
> 
> >> +retry:
> >>   	pmd = stage2_get_pmd(kvm, cache, addr);
> >>   	VM_BUG_ON(!pmd);
> >>   ...  
> 
> >>   	if (pmd_present(old_pmd)) {
> >>   		/*
> >> -		 * Multiple vcpus faulting on the same PMD entry, can
> >> -		 * lead to them sequentially updating the PMD with the
> >> -		 * same value. Following the break-before-make
> >> -		 * (pmd_clear() followed by tlb_flush()) process can
> >> -		 * hinder forward progress due to refaults generated
> >> -		 * on missing translations.
> >> +		 * If we already have PTE level mapping for this block,
> >> +		 * we must unmap it to avoid inconsistent TLB state and
> >> +		 * leaking the table page. We could end up in this situation
> >> +		 * if the memory slot was marked for dirty logging and was
> >> +		 * reverted, leaving PTE level mappings for the pages accessed
> >> +		 * during the period. So, unmap the PTE level mapping for this
> >> +		 * block and retry, as we could have released the upper level
> >> +		 * table in the process.
> >>   		 *
> >> -		 * Skip updating the page table if the entry is
> >> -		 * unchanged.
> >> +		 * Normal THP split/merge follows mmu_notifier callbacks and do
> >> +		 * get handled accordingly.
> >>   		 */
> >> -		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> >> -			return 0;
> >> -
> >> +		if (!pmd_thp_or_huge(old_pmd)) {
> >> +			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
> >> +			goto retry;  
> > 
> > This looks slightly dodgy. Doing this retry results in another call to
> > stage2_get_pmd(), which may or may not result in allocating a PUD. I
> > think this is safe as if we managed to get here, it means the whole
> > hierarchy was already present and nothing was allocated in the first
> > round.
> > 
> > Somehow, I would feel more comfortable with just not even trying.
> > Unmap, don't fix the fault, let the vcpu come again for additional
> > punishment. But this is probably more invasive, as none of the
> > stage2_set_p*() return value is ever evaluated. Oh well.
> >   
> 
> Yes. The other option was to unmap_stage2_ptes() and get the page refcount
> on the new pmd. But that kind of makes it a bit difficult to follow the
> code.
> 
> >>   	if (stage2_pud_present(kvm, old_pud)) {
> >> -		stage2_pud_clear(kvm, pudp);
> >> -		kvm_tlb_flush_vmid_ipa(kvm, addr);
> >> +		/*
> >> +		 * If we already have table level mapping for this block, unmap
> >> +		 * the range for this block and retry.
> >> +		 */
> >> +		if (!stage2_pud_huge(kvm, old_pud)) {
> >> +			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);  
> > 
> > This broke 32bit. I've added the following hunk to fix it:  
> 
> Grrr! Sorry about that.
> 
> > 
> > diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
> > index de2089501b8b..b8f21088a744 100644
> > --- a/arch/arm/include/asm/stage2_pgtable.h
> > +++ b/arch/arm/include/asm/stage2_pgtable.h
> > @@ -68,6 +68,9 @@ stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> >   #define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
> >   #define stage2_pud_table_empty(kvm, pudp)	false  
> >   > +#define S2_PUD_MASK				PGDIR_MASK  
> > +#define S2_PUD_SIZE				PGDIR_SIZE
> > +  
> 
> We should really get rid of the S2_P{U/M}D_* definitions, as they are
> always the same as the host. The only thing that changes is the PGD size
> which varies according to the IPA and the concatenation.
> 
> >   static inline bool kvm_stage2_has_pud(struct kvm *kvm)
> >   {
> >   	return false;
> >   
> >> +			goto retry;
> >> +		} else {
> >> +			WARN_ON_ONCE(pud_pfn(old_pud) != pud_pfn(*new_pudp));
> >> +			stage2_pud_clear(kvm, pudp);
> >> +			kvm_tlb_flush_vmid_ipa(kvm, addr);
> >> +		}  
> > 
> > The 'else' line could go, and would make the code similar to the PMD path.
> >   
> 
> Yep. I think the pud_pfn() may not be defined for some configs, if the hugetlbfs
> is not selected on arm32. So, we should move them to kvm_pud_pfn() instead.
> 
> 
> >>   	} else {
> >>   		get_page(virt_to_page(pudp));
> >>   	}  
> >> -- >> 2.7.4  
> >>  
> > 
> > If you're OK with the above nits, I'll squash them into the patch.  
> 
> With the kvm_pud_pfn() changes, yes. Alternately, I could resend the updated
> patch, fixing the typo in Zenghui's name. Let me know.

Sure, feel free to send a fixed version. I'll drop the currently queued
patch.

Thanks,

	M.
-- 
Without deviation from the norm, progress is not possible.
