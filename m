From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: Skip updating page table entry if no
 change
Date: Fri, 10 Aug 2018 12:27:24 +0100
Message-ID: <23d3c76f-e839-dbab-227c-f6bc068d3ba0@arm.com>
References: <20180810111300.17144-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180810111300.17144-1-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/10/2018 12:13 PM, Punit Agrawal wrote:
> Contention on updating a page table entry by a large number of vcpus
> can lead to duplicate work when handling stage 2 page faults. As the
> page table update follows the break-before-make requirement of the
> architecture, it can lead to repeated refaults due to clearing the
> entry and flushing the tlbs.
> 
> This problem is more likely when -
> 
> * there are large number of vcpus
> * the mapping is large block mapping
> 
> such as when using PMD hugepages (512MB) with 64k pages.
> 
> Fix this by skipping the page table update if there is no change in
> the entry being updated.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Suzuki Poulose <suzuki.poulose@arm.com>
> --


>   virt/kvm/arm/mmu.c | 16 ++++++++++++++++
>   1 file changed, 16 insertions(+)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 1d90d79706bd..a66a5441ca2f 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1027,6 +1027,18 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>   	VM_BUG_ON(pmd_present(*pmd) && pmd_pfn(*pmd) != pmd_pfn(*new_pmd));
>   
>   	old_pmd = *pmd;
> +	/*
> +	 * Multiple vcpus faulting on the same PMD entry, can lead to
> +	 * them sequentially updating the PMD with the same
> +	 * value. Following the break-before-make (pmd_clear()
> +	 * followed by tlb_flush()) process can hinder forward
> +	 * progress due to refaults generated on missing translations.
> +	 *
> +	 * Skip updating the page table if the entry is unchanged.
> +	 */
> +	if (pmd_val(old_pmd) == pmd_val(*new_pmd))
> +		return 0;
> +
>   	if (pmd_present(old_pmd)) {
>   		pmd_clear(pmd);
>   		kvm_tlb_flush_vmid_ipa(kvm, addr);
> @@ -1101,6 +1113,10 @@ static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>   
>   	/* Create 2nd stage page table mapping - Level 3 */
>   	old_pte = *pte;
> +	/* Skip page table update if there is no change */
> +	if (pte_val(old_pte) == pte_val(*new_pte))
> +		return 0;
> +
>   	if (pte_present(old_pte)) {
>   		kvm_set_pte(pte, __pte(0));
>   		kvm_tlb_flush_vmid_ipa(kvm, addr);
> 

Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
