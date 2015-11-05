From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Thu, 5 Nov 2015 15:48:48 +0100
Message-ID: <20151105144848.GC5819@cbox>
References: <1446242193-8424-1-git-send-email-m.smarduch@samsung.com>
 <1446242193-8424-3-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1446242193-8424-3-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, antonios.motakis@huawei.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 30, 2015 at 02:56:32PM -0700, Mario Smarduch wrote:
> This patch tracks vfp/simd hardware state with a vcpu lazy flag. vCPU lazy 
> flag is set on guest access and traps to vfp/simd hardware switch handler. On 
> vm-enter if lazy flag is set skip trap enable and save host fpexc. On 
> vm-exit if flag is set skip hardware context switch and return to host with 
> guest context. In vcpu_put check if vcpu lazy flag is set, and execute a 
> hardware context switch to restore host.
> 
> Also some arm64 field and empty function are added to compile for arm64.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/include/asm/kvm_host.h   |  1 +
>  arch/arm/kvm/arm.c                |  6 ++++
>  arch/arm/kvm/interrupts.S         | 60 ++++++++++++++++++++++++++++-----------
>  arch/arm/kvm/interrupts_head.S    | 14 +++++----
>  arch/arm64/include/asm/kvm_host.h |  4 +++
>  5 files changed, 63 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index f1bf551..a9e86e0 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -227,6 +227,7 @@ int kvm_perf_teardown(void);
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> +void kvm_restore_host_vfp_state(struct kvm_vcpu *);
>  
>  static inline void kvm_arch_hardware_disable(void) {}
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index dc017ad..11a56fe 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -296,6 +296,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
>  	/*
> +	 * If fp/simd registers are dirty save guest, restore host before

If the fp/simd registers are dirty, then restore the host state before

> +	 * releasing the cpu.
> +	 */
> +	if (vcpu->arch.vfp_dirty)
> +		kvm_restore_host_vfp_state(vcpu);
> +	/*
>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
>  	 * optimized make_all_cpus_request path.
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 900ef6d..ca25314 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -28,6 +28,32 @@
>  #include "interrupts_head.S"
>  
>  	.text
> +/**
> + * void kvm_restore_host_vfp_state(struct vcpu *vcpu) - Executes lazy

nit: Can you move the multi-line description of the function into a
separate paragraph?

> + * 	fp/simd switch, saves the guest, restores host. Called from host
> + *	mode, placed outside of hyp region start/end.

Put the description in a separate paragraph and get rid of the "executes
lazy fp/simd swithch" part, that doesn't help understanding.  Just say
that this funciton restores the host state.

> + */
> +ENTRY(kvm_restore_host_vfp_state)
> +#ifdef CONFIG_VFPv3
> +	push    {r4-r7}
> +
> +	add     r7, vcpu, #VCPU_VFP_GUEST
> +	store_vfp_state r7
> +
> +	add     r7, vcpu, #VCPU_VFP_HOST
> +	ldr     r7, [r7]
> +	restore_vfp_state r7
> +
> +	ldr     r3, [vcpu, #VCPU_VFP_HOST_FPEXC]
> +	VFPFMXR FPEXC, r3
> +
> +	mov     r3, #0
> +	strb    r3, [vcpu, #VCPU_VFP_DIRTY]
> +
> +	pop     {r4-r7}
> +#endif
> +	bx      lr
> +ENDPROC(kvm_restore_host_vfp_state)
>  
>  __kvm_hyp_code_start:
>  	.globl __kvm_hyp_code_start
> @@ -119,11 +145,16 @@ ENTRY(__kvm_vcpu_run)
>  	@ If the host kernel has not been configured with VFPv3 support,
>  	@ then it is safer if we deny guests from using it as well.
>  #ifdef CONFIG_VFPv3
> -	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
> +	@ fp/simd register file has already been accessed, so skip host fpexc
> +	@ save and access trap enable.
> +	vfp_inlazy_mode r7, skip_guest_vfp_trap

So, why do we need to touch this register at all on every CPU exit?

Is it not true that we can only be in one of two state:
 1) The register file is not dirty (not touched by the guest) and we
    should trap
 2) The register file is dirty, and we should not trap to EL2?

Only in the first case do we need to set the FPEXC, and couldn't we just
do that on vcpu_load and git rid of all this?  (except HCPTR_TCP which
we still need to adjust).

> +
>  	VFPFMRX r2, FPEXC		@ VMRS
> -	push	{r2}
> +	str     r2, [vcpu, #VCPU_VFP_HOST_FPEXC]
>  	orr	r2, r2, #FPEXC_EN
>  	VFPFMXR FPEXC, r2		@ VMSR
> +	set_hcptr vmentry, (HCPTR_TCP(10) | HCPTR_TCP(11))
> +skip_guest_vfp_trap:
>  #endif
>  
>  	@ Configure Hyp-role
> @@ -131,7 +162,7 @@ ENTRY(__kvm_vcpu_run)
>  
>  	@ Trap coprocessor CRx accesses
>  	set_hstr vmentry
> -	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
> +	set_hcptr vmentry, (HCPTR_TTA)

based on the above I think you can rework this to set the mask based on
the dirty flag and only hit the HCPTR once.

>  	set_hdcr vmentry
>  
>  	@ Write configured ID register into MIDR alias
> @@ -170,22 +201,15 @@ __kvm_vcpu_return:
>  	@ Don't trap coprocessor accesses for host kernel
>  	set_hstr vmexit
>  	set_hdcr vmexit
> -	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
> +	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>  
>  #ifdef CONFIG_VFPv3
> -	@ Switch VFP/NEON hardware state to the host's
> -	add	r7, vcpu, #VCPU_VFP_GUEST
> -	store_vfp_state r7
> -	add	r7, vcpu, #VCPU_VFP_HOST
> -	ldr	r7, [r7]
> -	restore_vfp_state r7
> -
> -after_vfp_restore:
> -	@ Restore FPEXC_EN which we clobbered on entry
> -	pop	{r2}
> +	@ If fp/simd not dirty, restore FPEXC which we clobbered on entry.
> +	@ Otherwise return with guest FPEXC, later saved in vcpu_put.
> +	vfp_inlazy_mode r2, skip_restore_host_fpexc
> +	ldr     r2, [vcpu, #VCPU_VFP_HOST_FPEXC]

I think you should always just restore in this in vcpu_put instead of
hitting on this all the time.

>  	VFPFMXR FPEXC, r2
> -#else
> -after_vfp_restore:
> +skip_restore_host_fpexc:
>  #endif
>  
>  	@ Reset Hyp-role
> @@ -485,6 +509,10 @@ switch_to_guest_vfp:
>  	@ NEON/VFP used.  Turn on VFP access.
>  	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
>  
> +	@ set lazy mode flag, switch hardware context on vcpu_put
> +	mov     r1, #1
> +	strb    r1, [vcpu, #VCPU_VFP_DIRTY]
> +
>  	@ Switch VFP/NEON hardware state to the guest's
>  	add	r7, r0, #VCPU_VFP_HOST
>  	ldr	r7, [r7]
> diff --git a/arch/arm/kvm/interrupts_head.S b/arch/arm/kvm/interrupts_head.S
> index 51a5950..34e71ee 100644
> --- a/arch/arm/kvm/interrupts_head.S
> +++ b/arch/arm/kvm/interrupts_head.S
> @@ -593,10 +593,8 @@ ARM_BE8(rev	r6, r6  )
>   * (hardware reset value is 0). Keep previous value in r2.
>   * An ISB is emited on vmexit/vmtrap, but executed on vmexit only if
>   * VFP wasn't already enabled (always executed on vmtrap).
> - * If a label is specified with vmexit, it is branched to if VFP wasn't
> - * enabled.
>   */
> -.macro set_hcptr operation, mask, label = none
> +.macro set_hcptr operation, mask
>  	mrc	p15, 4, r2, c1, c1, 2
>  	ldr	r3, =\mask
>  	.if \operation == vmentry
> @@ -611,13 +609,17 @@ ARM_BE8(rev	r6, r6  )
>  	beq	1f
>  	.endif
>  	isb
> -	.if \label != none
> -	b	\label
> -	.endif
>  1:
>  	.endif
>  .endm
>  
> +/* Checks if VFP/SIMD dirty flag is set, if it is branch to label. */
> +.macro vfp_inlazy_mode, reg, label

Again, I don't find this "in lazy mode" to mean that we've now switched
to the guest's VFP state intuitive or logical.

How about vfp_skip_if_dirty ?

> +	ldr	\reg, [vcpu, #VCPU_VFP_DIRTY]
> +	cmp	\reg, #1
> +	beq	\label
> +.endm
> +
>  /* Configures the HDCR (Hyp Debug Configuration Register) on entry/return
>   * (hardware reset value is 0) */
>  .macro set_hdcr operation
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 4562459..26a2347 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -157,6 +157,9 @@ struct kvm_vcpu_arch {
>  	/* Interrupt related fields */
>  	u64 irq_lines;		/* IRQ and FIQ levels */
>  
> +	/* fp/simd dirty flag true if guest accessed register file */
> +	bool    vfp_dirty;
> +
>  	/* Cache some mmu pages needed inside spinlock regions */
>  	struct kvm_mmu_memory_cache mmu_page_cache;
>  
> @@ -248,6 +251,7 @@ static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> +static inline void kvm_restore_host_vfp_state(struct kvm_vcpu *vcpu) {}
>  
>  void kvm_arm_init_debug(void);
>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
> -- 
> 1.9.1
> 
