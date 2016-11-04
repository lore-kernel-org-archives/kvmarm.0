From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3] arm/arm64: KVM: Perform local TLB invalidation when
 multiplexing vcpus on a single CPU
Date: Fri, 4 Nov 2016 11:47:34 +0100
Message-ID: <20161104104734.GC11122@cbox>
References: <20161103222706.24129-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F1C1402A2
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 06:47:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LWmUwfk71wnS for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 06:47:28 -0400 (EDT)
Received: from mail-lf0-f43.google.com (mail-lf0-f43.google.com
 [209.85.215.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A096A40290
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 06:47:28 -0400 (EDT)
Received: by mail-lf0-f43.google.com with SMTP id c13so60614683lfg.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 04 Nov 2016 03:47:43 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20161103222706.24129-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 03, 2016 at 10:27:06PM +0000, Marc Zyngier wrote:
> Architecturally, TLBs are private to the (physical) CPU they're
> associated with. But when multiple vcpus from the same VM are
> being multiplexed on the same CPU, the TLBs are not private
> to the vcpus (and are actually shared across the VMID).
> 
> Let's consider the following scenario:
> 
> - vcpu-0 maps PA to VA
> - vcpu-1 maps PA' to VA
> 
> If run on the same physical CPU, vcpu-1 can hit TLB entries generated
> by vcpu-0 accesses, and access the wrong physical page.
> 
> The solution to this is to keep a per-VM map of which vcpu ran last
> on each given physical CPU, and invalidate local TLBs when switching
> to a different vcpu from the same VM.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> ---
> - From v2:
>   * Fixed the horrible sched_in vs load bug
>   * Now performing immediate invalidation instead of defering it
>   * Squashed a buglet in the kern_hyp_va macro
>   * Dropped Mark's RB since the code has substantially changed
>   * Only lightly tested on 32bit (I'm travelling)
> 
>  arch/arm/include/asm/kvm_asm.h    |  1 +
>  arch/arm/include/asm/kvm_host.h   |  3 +++
>  arch/arm/include/asm/kvm_hyp.h    |  1 +
>  arch/arm/kvm/arm.c                | 27 ++++++++++++++++++++++++++-
>  arch/arm/kvm/hyp/tlb.c            | 15 +++++++++++++++
>  arch/arm64/include/asm/kvm_asm.h  |  1 +
>  arch/arm64/include/asm/kvm_host.h |  3 +++
>  arch/arm64/include/asm/kvm_mmu.h  |  2 +-
>  arch/arm64/kvm/hyp/tlb.c          | 15 +++++++++++++++
>  9 files changed, 66 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
> index d7ea6bcb29bf..8ef05381984b 100644
> --- a/arch/arm/include/asm/kvm_asm.h
> +++ b/arch/arm/include/asm/kvm_asm.h
> @@ -66,6 +66,7 @@ extern char __kvm_hyp_vector[];
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
> +extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 2d19e02d03fd..d5423ab15ed5 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -57,6 +57,9 @@ struct kvm_arch {
>  	/* VTTBR value associated with below pgd and vmid */
>  	u64    vttbr;
>  
> +	/* The last vcpu id that ran on each physical CPU */
> +	int __percpu *last_vcpu_ran;
> +
>  	/* Timer */
>  	struct arch_timer_kvm	timer;
>  
> diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
> index 343135ede5fa..58508900c4bb 100644
> --- a/arch/arm/include/asm/kvm_hyp.h
> +++ b/arch/arm/include/asm/kvm_hyp.h
> @@ -71,6 +71,7 @@
>  #define ICIALLUIS	__ACCESS_CP15(c7, 0, c1, 0)
>  #define ATS1CPR		__ACCESS_CP15(c7, 0, c8, 0)
>  #define TLBIALLIS	__ACCESS_CP15(c8, 0, c3, 0)
> +#define TLBIALL		__ACCESS_CP15(c8, 0, c7, 0)
>  #define TLBIALLNSNHIS	__ACCESS_CP15(c8, 4, c3, 4)
>  #define PRRR		__ACCESS_CP15(c10, 0, c2, 0)
>  #define NMRR		__ACCESS_CP15(c10, 0, c2, 1)
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 08bb84f2ad58..19b5f5c1c0ff 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -114,11 +114,18 @@ void kvm_arch_check_processor_compat(void *rtn)
>   */
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  {
> -	int ret = 0;
> +	int ret, cpu;
>  
>  	if (type)
>  		return -EINVAL;
>  
> +	kvm->arch.last_vcpu_ran = alloc_percpu(typeof(*kvm->arch.last_vcpu_ran));
> +	if (!kvm->arch.last_vcpu_ran)
> +		return -ENOMEM;
> +
> +	for_each_possible_cpu(cpu)
> +		*per_cpu_ptr(kvm->arch.last_vcpu_ran, cpu) = -1;
> +
>  	ret = kvm_alloc_stage2_pgd(kvm);
>  	if (ret)
>  		goto out_fail_alloc;
> @@ -141,6 +148,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  out_free_stage2_pgd:
>  	kvm_free_stage2_pgd(kvm);
>  out_fail_alloc:
> +	free_percpu(kvm->arch.last_vcpu_ran);
> +	kvm->arch.last_vcpu_ran = NULL;
>  	return ret;
>  }
>  
> @@ -168,6 +177,9 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  	int i;
>  
> +	free_percpu(kvm->arch.last_vcpu_ran);
> +	kvm->arch.last_vcpu_ran = NULL;
> +
>  	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
>  		if (kvm->vcpus[i]) {
>  			kvm_arch_vcpu_free(kvm->vcpus[i]);
> @@ -312,6 +324,19 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
>  
>  void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  {
> +	int *last_ran;
> +
> +	last_ran = this_cpu_ptr(vcpu->kvm->arch.last_vcpu_ran);
> +
> +	/*
> +	 * We might get preempted before the vCPU actually runs, but
> +	 * over-invalidation doesn't affect correctness.
> +	 */
> +	if (*last_ran != vcpu->vcpu_id) {
> +		kvm_call_hyp(__kvm_tlb_flush_local_vmid, vcpu);
> +		*last_ran = vcpu->vcpu_id;
> +	}
> +
>  	vcpu->cpu = cpu;
>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
>  
> diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
> index 729652854f90..6d810af2d9fd 100644
> --- a/arch/arm/kvm/hyp/tlb.c
> +++ b/arch/arm/kvm/hyp/tlb.c
> @@ -55,6 +55,21 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa)
>  	__kvm_tlb_flush_vmid(kvm);
>  }
>  
> +void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
> +
> +	/* Switch to requested VMID */
> +	write_sysreg(kvm->arch.vttbr, VTTBR);
> +	isb();
> +
> +	write_sysreg(0, TLBIALL);
> +	dsb(nsh);
> +	isb();
> +
> +	write_sysreg(0, VTTBR);
> +}
> +
>  void __hyp_text __kvm_flush_vm_context(void)
>  {
>  	write_sysreg(0, TLBIALLNSNHIS);
> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
> index 18f746551bf6..ec3553eb9349 100644
> --- a/arch/arm64/include/asm/kvm_asm.h
> +++ b/arch/arm64/include/asm/kvm_asm.h
> @@ -54,6 +54,7 @@ extern char __kvm_hyp_vector[];
>  extern void __kvm_flush_vm_context(void);
>  extern void __kvm_tlb_flush_vmid_ipa(struct kvm *kvm, phys_addr_t ipa);
>  extern void __kvm_tlb_flush_vmid(struct kvm *kvm);
> +extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
>  
>  extern int __kvm_vcpu_run(struct kvm_vcpu *vcpu);
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index bd94e6766759..e5050388e062 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -62,6 +62,9 @@ struct kvm_arch {
>  	/* VTTBR value associated with above pgd and vmid */
>  	u64    vttbr;
>  
> +	/* The last vcpu id that ran on each physical CPU */
> +	int __percpu *last_vcpu_ran;
> +
>  	/* The maximum number of vCPUs depends on the used GIC model */
>  	int max_vcpus;
>  
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index a79b969c26fc..6f72fe8b0e3e 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -128,7 +128,7 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>  	return v;
>  }
>  
> -#define kern_hyp_va(v) 	(typeof(v))(__kern_hyp_va((unsigned long)(v)))
> +#define kern_hyp_va(v) 	((typeof(v))(__kern_hyp_va((unsigned long)(v))))
>  
>  /*
>   * We currently only support a 40bit IPA.
> diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
> index 9cc0ea784ae6..88e2f2b938f0 100644
> --- a/arch/arm64/kvm/hyp/tlb.c
> +++ b/arch/arm64/kvm/hyp/tlb.c
> @@ -64,6 +64,21 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm *kvm)
>  	write_sysreg(0, vttbr_el2);
>  }
>  
> +void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
> +
> +	/* Switch to requested VMID */
> +	write_sysreg(kvm->arch.vttbr, vttbr_el2);
> +	isb();
> +
> +	asm volatile("tlbi vmalle1" : : );
> +	dsb(nsh);
> +	isb();
> +
> +	write_sysreg(0, vttbr_el2);
> +}
> +
>  void __hyp_text __kvm_flush_vm_context(void)
>  {
>  	dsb(ishst);
> -- 
> 2.10.1
> 
