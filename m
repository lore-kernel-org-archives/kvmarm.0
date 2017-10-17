From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 07/10] KVM: arm/arm64: Preserve Exec permission across R/W
 permission faults
Date: Tue, 17 Oct 2017 16:04:19 +0100
Message-ID: <86f238ce-d799-d1ea-b85a-5dae76a36856@arm.com>
References: <20171009152032.27804-1-marc.zyngier@arm.com>
 <20171009152032.27804-8-marc.zyngier@arm.com> <20171016200824.GI1845@lvm>
 <9f1e5366-fe47-69e9-8df9-31105c39094f@arm.com> <20171017144621.GJ5886@lvm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A493240D25
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:03:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id obWmrPa3465t for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Oct 2017 11:03:25 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 29A7E40638
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Oct 2017 11:03:25 -0400 (EDT)
In-Reply-To: <20171017144621.GJ5886@lvm>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 17/10/17 15:46, Christoffer Dall wrote:
> On Tue, Oct 17, 2017 at 12:22:08PM +0100, Marc Zyngier wrote:
>> On 16/10/17 21:08, Christoffer Dall wrote:
>>> On Mon, Oct 09, 2017 at 04:20:29PM +0100, Marc Zyngier wrote:
>>>> So far, we loose the Exec property whenever we take permission
>>>> faults, as we always reconstruct the PTE/PMD from scratch. This
>>>> can be counter productive as we can end-up with the following
>>>> fault sequence:
>>>>
>>>> 	X -> RO -> ROX -> RW -> RWX
>>>>
>>>> Instead, we can lookup the existing PTE/PMD and clear the XN bit in the
>>>> new entry if it was already cleared in the old one, leadig to a much
>>>> nicer fault sequence:
>>>>
>>>> 	X -> ROX -> RWX
>>>>
>>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>>> ---
>>>>  arch/arm/include/asm/kvm_mmu.h   | 10 ++++++++++
>>>>  arch/arm64/include/asm/kvm_mmu.h | 10 ++++++++++
>>>>  virt/kvm/arm/mmu.c               | 25 +++++++++++++++++++++++++
>>>>  3 files changed, 45 insertions(+)
>>>>
>>>> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
>>>> index bf76150aad5f..ad442d86c23e 100644
>>>> --- a/arch/arm/include/asm/kvm_mmu.h
>>>> +++ b/arch/arm/include/asm/kvm_mmu.h
>>>> @@ -107,6 +107,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
>>>>  	return (pte_val(*pte) & L_PTE_S2_RDWR) == L_PTE_S2_RDONLY;
>>>>  }
>>>>  
>>>> +static inline bool kvm_s2pte_exec(pte_t *pte)
>>>> +{
>>>> +	return !(pte_val(*pte) & L_PTE_XN);
>>>> +}
>>>> +
>>>>  static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
>>>>  {
>>>>  	pmd_val(*pmd) = (pmd_val(*pmd) & ~L_PMD_S2_RDWR) | L_PMD_S2_RDONLY;
>>>> @@ -117,6 +122,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>>>>  	return (pmd_val(*pmd) & L_PMD_S2_RDWR) == L_PMD_S2_RDONLY;
>>>>  }
>>>>  
>>>> +static inline bool kvm_s2pmd_exec(pmd_t *pmd)
>>>> +{
>>>> +	return !(pmd_val(*pmd) & PMD_SECT_XN);
>>>> +}
>>>> +
>>>>  static inline bool kvm_page_empty(void *ptr)
>>>>  {
>>>>  	struct page *ptr_page = virt_to_page(ptr);
>>>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
>>>> index 60c420a5ac0d..e7af74b8b51a 100644
>>>> --- a/arch/arm64/include/asm/kvm_mmu.h
>>>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>>>> @@ -203,6 +203,11 @@ static inline bool kvm_s2pte_readonly(pte_t *pte)
>>>>  	return (pte_val(*pte) & PTE_S2_RDWR) == PTE_S2_RDONLY;
>>>>  }
>>>>  
>>>> +static inline bool kvm_s2pte_exec(pte_t *pte)
>>>> +{
>>>> +	return !(pte_val(*pte) & PTE_S2_XN);
>>>> +}
>>>> +
>>>>  static inline void kvm_set_s2pmd_readonly(pmd_t *pmd)
>>>>  {
>>>>  	kvm_set_s2pte_readonly((pte_t *)pmd);
>>>> @@ -213,6 +218,11 @@ static inline bool kvm_s2pmd_readonly(pmd_t *pmd)
>>>>  	return kvm_s2pte_readonly((pte_t *)pmd);
>>>>  }
>>>>  
>>>> +static inline bool kvm_s2pmd_exec(pmd_t *pmd)
>>>> +{
>>>> +	return !(pmd_val(*pmd) & PMD_S2_XN);
>>>> +}
>>>> +
>>>>  static inline bool kvm_page_empty(void *ptr)
>>>>  {
>>>>  	struct page *ptr_page = virt_to_page(ptr);
>>>> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
>>>> index 1911fadde88b..ccc6106764a6 100644
>>>> --- a/virt/kvm/arm/mmu.c
>>>> +++ b/virt/kvm/arm/mmu.c
>>>> @@ -926,6 +926,17 @@ static int stage2_set_pmd_huge(struct kvm *kvm, struct kvm_mmu_memory_cache
>>>>  	return 0;
>>>>  }
>>>>  
>>>> +static pte_t *stage2_get_pte(struct kvm *kvm, phys_addr_t addr)
>>>> +{
>>>> +	pmd_t *pmdp;
>>>> +
>>>> +	pmdp = stage2_get_pmd(kvm, NULL, addr);
>>>> +	if (!pmdp || pmd_none(*pmdp))
>>>> +		return NULL;
>>>> +
>>>> +	return pte_offset_kernel(pmdp, addr);
>>>> +}
>>>> +
>>>
>>> nit, couldn't you change this to be
>>>
>>>     stage2_is_exec(struct kvm *kvm, phys_addr_t addr)
>>>
>>> Which, if the pmd is a section mapping just checks that, and if we find
>>> a pte, we check that, and then we can have a simpler one-line call and
>>> check from both the pte and pmd paths below?
>>
>> Yes, that's pretty neat. I've folded that in.
>>
>>>
>>>>  static int stage2_set_pte(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
>>>>  			  phys_addr_t addr, const pte_t *new_pte,
>>>>  			  unsigned long flags)
>>>> @@ -1407,6 +1418,13 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>>>  		if (exec_fault) {
>>>>  			new_pmd = kvm_s2pmd_mkexec(new_pmd);
>>>>  			coherent_icache_guest_page(vcpu, pfn, PMD_SIZE);
>>>> +		} else if (fault_status == FSC_PERM) {
>>>> +			/* Preserve execute if XN was already cleared */
>>>> +			pmd_t *old_pmdp = stage2_get_pmd(kvm, NULL, fault_ipa);
>>>> +
>>>> +			if (old_pmdp && pmd_present(*old_pmdp) &&
>>>> +			    kvm_s2pmd_exec(old_pmdp))
>>>> +				new_pmd = kvm_s2pmd_mkexec(new_pmd);
>>>
>>> Is the reverse case not also possible then?  That is, if we have an
>>> exec_fault, we could check if the entry is already writable and maintain
>>> the property as well.  Not sure how often that would get hit though, as
>>> a VM would only execute instructions on a page that has been written to,
>>> but is somehow read-only at stage2, meaning the host must have marked
>>> the page as read-only since content was written.  I think this could be
>>> a somewhat common pattern with something like KSM though?
>>
>> I think this is already the case, because we always build the PTE/PMD as
>> either ROXN or RWXN, and only later clear the XN bit (see the
>> unconditional call to gfn_to_pfn_prot which should tell us whether to
>> map the page as writable or not). Or am I missing your point entirely?
>>
> 
> I am worried about the flow where we map the page as RWXN, then execute
> some code on it, so it becomes RW, then make it read-only as ROXN.
> Shouldn't we we should preserve the exec state here?

I think that for this situation to happen (RW -> ROXN), we must
transition via an unmap. At that stage, there is nothing to preserve.

> I'm guessing that something like KSM will want to make pages read-only
> to support COW, but perhaps that's always done by copying the content to
> a new page and redirecting the old mapping to a new mapping (something
> that calls kvm_set_spte_hva()) and in that case we do probably really
> want the XN bit to be set again so that we can do the necessary
> maintenance.

Exactly. New mapping, fresh caches.

> However, we shouldn't try to optimize for something we don't know to be
> a problem, so as long as it's functionally correct, which I think it is,
> we should be fine.

Agreed.

	M.
-- 
Jazz is not dead. It just smells funny...
