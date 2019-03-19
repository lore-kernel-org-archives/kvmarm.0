From: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH] kvm: arm: Fix handling of stage2 huge mappings
Date: Wed, 20 Mar 2019 00:02:52 +0800
Message-ID: <57ffd415-a2ce-4a82-79e9-9565e1c29071@huawei.com>
References: <25971fd5-3774-3389-a82a-04707480c1e0@huawei.com>
 <1553004668-23296-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1553004668-23296-1-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, will.deacon@arm.com, catalin.marinas@arm.com, james.morse@arm.com, julien.thierry@arm.com, wanghaibin.wang@huawei.com, lious.lilei@hisilicon.com, lishuo1@hisilicon.com, zhengxiang9@huawei.com, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On 2019/3/19 22:11, Suzuki K Poulose wrote:
> We rely on the mmu_notifier call backs to handle the split/merge
> of huge pages and thus we are guaranteed that, while creating a
> block mapping, either the entire block is unmapped at stage2 or it
> is missing permission.
> 
> However, we miss a case where the block mapping is split for dirty
> logging case and then could later be made block mapping, if we cancel the
> dirty logging. This not only creates inconsistent TLB entries for
> the pages in the the block, but also leakes the table pages for
> PMD level.
> 
> Handle this corner case for the huge mappings at stage2 by
> unmapping the non-huge mapping for the block. This could potentially
> release the upper level table. So we need to restart the table walk
> once we unmap the range.
> 
> Fixes : ad361f093c1e31d ("KVM: ARM: Support hugetlbfs backed huge pages")
> Reported-by: Zheng Xiang <zhengxiang9@huawei.com>
> Cc: Zheng Xiang <zhengxiang9@huawei.com>
> Cc: Zhengui Yu <yuzenghui@huawei.com>

Sorry to bother you, but this should be "Zenghui Yu", thanks!


zenghui

> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>   virt/kvm/arm/mmu.c | 63 ++++++++++++++++++++++++++++++++++++++----------------
>   1 file changed, 45 insertions(+), 18 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index fce0983..6ad6f19d 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1060,25 +1060,43 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   {
>   	pmd_t *pmd, old_pmd;
>   
> +retry:
>   	pmd = stage2_get_pmd(kvm, cache, addr);
>   	VM_BUG_ON(!pmd);
>   
>   	old_pmd = *pmd;
> +	/*
> +	 * Multiple vcpus faulting on the same PMD entry, can
> +	 * lead to them sequentially updating the PMD with the
> +	 * same value. Following the break-before-make
> +	 * (pmd_clear() followed by tlb_flush()) process can
> +	 * hinder forward progress due to refaults generated
> +	 * on missing translations.
> +	 *
> +	 * Skip updating the page table if the entry is
> +	 * unchanged.
> +	 */
> +	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> +		return 0;
> +
>   	if (pmd_present(old_pmd)) {
>   		/*
> -		 * Multiple vcpus faulting on the same PMD entry, can
> -		 * lead to them sequentially updating the PMD with the
> -		 * same value. Following the break-before-make
> -		 * (pmd_clear() followed by tlb_flush()) process can
> -		 * hinder forward progress due to refaults generated
> -		 * on missing translations.
> +		 * If we already have PTE level mapping for this block,
> +		 * we must unmap it to avoid inconsistent TLB state and
> +		 * leaking the table page. We could end up in this situation
> +		 * if the memory slot was marked for dirty logging and was
> +		 * reverted, leaving PTE level mappings for the pages accessed
> +		 * during the period. So, unmap the PTE level mapping for this
> +		 * block and retry, as we could have released the upper level
> +		 * table in the process.
>   		 *
> -		 * Skip updating the page table if the entry is
> -		 * unchanged.
> +		 * Normal THP split/merge follows mmu_notifier callbacks and do
> +		 * get handled accordingly.
>   		 */
> -		if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> -			return 0;
> -
> +		if (!pmd_thp_or_huge(old_pmd)) {
> +			unmap_stage2_range(kvm, addr & S2_PMD_MASK, S2_PMD_SIZE);
> +			goto retry;
> +		}
>   		/*
>   		 * Mapping in huge pages should only happen through a
>   		 * fault.  If a page is merged into a transparent huge
> @@ -1090,8 +1108,7 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   		 * should become splitting first, unmapped, merged,
>   		 * and mapped back in on-demand.
>   		 */
> -		VM_BUG_ON(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
> -
> +		WARN_ON_ONCE(pmd_pfn(old_pmd) != pmd_pfn(*new_pmd));
>   		pmd_clear(pmd);
>   		kvm_tlb_flush_vmid_ipa(kvm, addr);
>   	} else {
> @@ -1107,6 +1124,7 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
>   {
>   	pud_t *pudp, old_pud;
>   
> +retry:
>   	pudp = stage2_get_pud(kvm, cache, addr);
>   	VM_BUG_ON(!pudp);
>   
> @@ -1114,16 +1132,25 @@ static int stage2_set_pud_huge(struct kvm *kvm, struct kvm_mmu_memory_cache *cac
>   
>   	/*
>   	 * A large number of vcpus faulting on the same stage 2 entry,
> -	 * can lead to a refault due to the
> -	 * stage2_pud_clear()/tlb_flush(). Skip updating the page
> -	 * tables if there is no change.
> +	 * can lead to a refault due to the stage2_pud_clear()/tlb_flush().
> +	 * Skip updating the page tables if there is no change.
>   	 */
>   	if (pud_val(old_pud) == pud_val(*new_pudp))
>   		return 0;
>   
>   	if (stage2_pud_present(kvm, old_pud)) {
> -		stage2_pud_clear(kvm, pudp);
> -		kvm_tlb_flush_vmid_ipa(kvm, addr);
> +		/*
> +		 * If we already have table level mapping for this block, unmap
> +		 * the range for this block and retry.
> +		 */
> +		if (!stage2_pud_huge(kvm, old_pud)) {
> +			unmap_stage2_range(kvm, addr & S2_PUD_MASK, S2_PUD_SIZE);
> +			goto retry;
> +		} else {
> +			WARN_ON_ONCE(pud_pfn(old_pud) != pud_pfn(*new_pudp));
> +			stage2_pud_clear(kvm, pudp);
> +			kvm_tlb_flush_vmid_ipa(kvm, addr);
> +		}
>   	} else {
>   		get_page(virt_to_page(pudp));
>   	}
> 
