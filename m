From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 2/3] arm/arm64: KVM: Implement Stage-2 page aging
Date: Thu, 12 Mar 2015 12:40:17 +0100
Message-ID: <20150312114017.GB28863@cbox>
References: <1421865733-20034-1-git-send-email-marc.zyngier@arm.com>
 <1421865733-20034-3-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1421865733-20034-3-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Steve Capper <steve.capper@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Jan 21, 2015 at 06:42:12PM +0000, Marc Zyngier wrote:
> Until now, KVM/arm didn't care much for page aging (who was swapping
> anyway?), and simply provided empty hooks to the core KVM code. With
> server-type systems now being available, things are quite different.
> 
> This patch implements very simple support for page aging, by clearing
> the Access flag in the Stage-2 page tables. On access fault, the current
> fault handling will write the PTE or PMD again, putting the Access flag
> back on.
> 
> It should be possible to implement a much faster handling for Access
> faults, but that's left for a later patch.
> 
> With this in place, performance in VMs is degraded much more gracefully.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 13 ++-------
>  arch/arm/kvm/mmu.c                | 59 ++++++++++++++++++++++++++++++++++++++-
>  arch/arm/kvm/trace.h              | 33 ++++++++++++++++++++++
>  arch/arm64/include/asm/kvm_arm.h  |  1 +
>  arch/arm64/include/asm/kvm_host.h | 13 ++-------
>  5 files changed, 96 insertions(+), 23 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 04b4ea0..d6b5b85 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -163,19 +163,10 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
>  
>  unsigned long kvm_arm_num_regs(struct kvm_vcpu *vcpu);
>  int kvm_arm_copy_reg_indices(struct kvm_vcpu *vcpu, u64 __user *indices);
> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  
>  /* We do not have shadow page tables, hence the empty hooks */
> -static inline int kvm_age_hva(struct kvm *kvm, unsigned long start,
> -			      unsigned long end)
> -{
> -	return 0;
> -}
> -
> -static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
> -{
> -	return 0;
> -}
> -
>  static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>  							 unsigned long address)
>  {
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index e163a45..ffe89a0 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1068,6 +1068,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  
>  out_unlock:
>  	spin_unlock(&kvm->mmu_lock);
> +	kvm_set_pfn_accessed(pfn);
>  	kvm_release_pfn_clean(pfn);
>  	return ret;
>  }
> @@ -1102,7 +1103,8 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  
>  	/* Check the stage-2 fault is trans. fault or write fault */
>  	fault_status = kvm_vcpu_trap_get_fault_type(vcpu);
> -	if (fault_status != FSC_FAULT && fault_status != FSC_PERM) {
> +	if (fault_status != FSC_FAULT && fault_status != FSC_PERM &&
> +	    fault_status != FSC_ACCESS) {
>  		kvm_err("Unsupported FSC: EC=%#x xFSC=%#lx ESR_EL2=%#lx\n",
>  			kvm_vcpu_trap_get_class(vcpu),
>  			(unsigned long)kvm_vcpu_trap_get_fault(vcpu),
> @@ -1237,6 +1239,61 @@ void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  	handle_hva_to_gpa(kvm, hva, end, &kvm_set_spte_handler, &stage2_pte);
>  }
>  
> +static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> +{
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pmd = stage2_get_pmd(kvm, NULL, gpa);
> +	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +		return 0;
> +
> +	if (kvm_pmd_huge(*pmd)) {	/* THP, HugeTLB */
> +		*pmd = pmd_mkold(*pmd);
> +		goto tlbi;

so in this case we'll loop over a huge pmd on a page-by-page basis,
invalidating the tlb each time, right?

Would it be worth checking of the access flag is already clear
(!pmd_young()) and in that case exit without doing tlb invalidation?

In fact, shouldn't we only return 1 if the pmd is indeed young and then
the tlb invalidation will be done once by kvm_flush_remote_tlbs() in
kvm_mmu_notifier_clear_flush_young() ?

I got a little lost looking at how the core mm code uses the return
value, but if I read the x86 and powerpc code correctly, they use it the
way I suggest.  Did I get this all wrong?

> +	}
> +
> +	pte = pte_offset_kernel(pmd, gpa);
> +	if (pte_none(*pte))
> +		return 0;
> +
> +	*pte = pte_mkold(*pte);		/* Just a page... */

same with checking if it's young or not... ?

> +tlbi:
> +	kvm_tlb_flush_vmid_ipa(kvm, gpa);
> +	return 1;
> +}
> +
> +static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, void *data)
> +{
> +	pmd_t *pmd;
> +	pte_t *pte;
> +
> +	pmd = stage2_get_pmd(kvm, NULL, gpa);
> +	if (!pmd || pmd_none(*pmd))	/* Nothing there */
> +		return 0;
> +
> +	if (kvm_pmd_huge(*pmd))		/* THP, HugeTLB */
> +		return pmd_young(*pmd);
> +
> +	pte = pte_offset_kernel(pmd, gpa);
> +	if (!pte_none(*pte))		/* Just a page... */
> +		return pte_young(*pte);
> +
> +	return 0;
> +}
> +
> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> +{
> +	trace_kvm_age_hva(start, end);
> +	return handle_hva_to_gpa(kvm, start, end, kvm_age_hva_handler, NULL);
> +}
> +
> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
> +{
> +	trace_kvm_test_age_hva(hva);
> +	return handle_hva_to_gpa(kvm, hva, hva, kvm_test_age_hva_handler, NULL);
> +}
> +
>  void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
>  	mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> diff --git a/arch/arm/kvm/trace.h b/arch/arm/kvm/trace.h
> index b6a6e71..364b5382 100644
> --- a/arch/arm/kvm/trace.h
> +++ b/arch/arm/kvm/trace.h
> @@ -203,6 +203,39 @@ TRACE_EVENT(kvm_set_spte_hva,
>  	TP_printk("mmu notifier set pte hva: %#08lx", __entry->hva)
>  );
>  
> +TRACE_EVENT(kvm_age_hva,
> +	TP_PROTO(unsigned long start, unsigned long end),
> +	TP_ARGS(start, end),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	start		)
> +		__field(	unsigned long,	end		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->start		= start;
> +		__entry->end		= end;
> +	),
> +
> +	TP_printk("mmu notifier age hva: %#08lx -- %#08lx",
> +		  __entry->start, __entry->end)
> +);
> +
> +TRACE_EVENT(kvm_test_age_hva,
> +	TP_PROTO(unsigned long hva),
> +	TP_ARGS(hva),
> +
> +	TP_STRUCT__entry(
> +		__field(	unsigned long,	hva		)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->hva		= hva;
> +	),
> +
> +	TP_printk("mmu notifier test age hva: %#08lx", __entry->hva)
> +);
> +
>  TRACE_EVENT(kvm_hvc,
>  	TP_PROTO(unsigned long vcpu_pc, unsigned long r0, unsigned long imm),
>  	TP_ARGS(vcpu_pc, r0, imm),
> diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
> index 8afb863..0d738f2 100644
> --- a/arch/arm64/include/asm/kvm_arm.h
> +++ b/arch/arm64/include/asm/kvm_arm.h
> @@ -212,6 +212,7 @@
>  
>  
>  #define FSC_FAULT	(0x04)
> +#define FSC_ACCESS	(0x08)
>  #define FSC_PERM	(0x0c)
>  
>  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index acd101a..b831710 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -173,19 +173,10 @@ int kvm_unmap_hva(struct kvm *kvm, unsigned long hva);
>  int kvm_unmap_hva_range(struct kvm *kvm,
>  			unsigned long start, unsigned long end);
>  void kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte);
> +int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end);
> +int kvm_test_age_hva(struct kvm *kvm, unsigned long hva);
>  
>  /* We do not have shadow page tables, hence the empty hooks */
> -static inline int kvm_age_hva(struct kvm *kvm, unsigned long start,
> -			      unsigned long end)
> -{
> -	return 0;
> -}
> -
> -static inline int kvm_test_age_hva(struct kvm *kvm, unsigned long hva)
> -{
> -	return 0;
> -}
> -
>  static inline void kvm_arch_mmu_notifier_invalidate_page(struct kvm *kvm,
>  							 unsigned long address)
>  {
> -- 
> 2.1.4
> 
Otherwise, this looks good.

Thanks,
-Christoffer
