From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 2/3] KVM/arm/arm64: enable enhanced armv7 fp/simd lazy
 switch
Date: Thu, 03 Dec 2015 15:58:34 +0000
Message-ID: <566066AA.7000204@arm.com>
References: <1447539130-4613-1-git-send-email-m.smarduch@samsung.com> <1447539130-4613-3-git-send-email-m.smarduch@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1447539130-4613-3-git-send-email-m.smarduch@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Mario Smarduch <m.smarduch@samsung.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, antonios.motakis@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 14/11/15 22:12, Mario Smarduch wrote:
> This patch tracks armv7 fp/simd hardware state with a vcpu lazy flag.
> On vcpu_load saves host fpexc and enables FP access, and later enables fp/simd
> trapping if lazy flag is not set. On first fp/simd access trap to handler 
> to save host and restore guest context, disable trapping and set vcpu lazy 
> flag. On vcpu_put if flag is set save guest and restore host context and 
> always restore host fpexc.
> 
> Signed-off-by: Mario Smarduch <m.smarduch@samsung.com>
> ---
>  arch/arm/include/asm/kvm_host.h   | 33 ++++++++++++++++++++++
>  arch/arm/kvm/arm.c                | 12 ++++++++
>  arch/arm/kvm/interrupts.S         | 58 +++++++++++++++++++++++----------------
>  arch/arm/kvm/interrupts_head.S    | 26 +++++++++++++-----
>  arch/arm64/include/asm/kvm_host.h |  6 ++++
>  5 files changed, 104 insertions(+), 31 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index f1bf551..8fc7a59 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -40,6 +40,38 @@
>  
>  #define KVM_MAX_VCPUS VGIC_V2_MAX_CPUS
>  
> +/*
> + * Reads the host FPEXC register, saves it to vcpu context and enables the
> + * FP/SIMD unit.
> + */
> +#ifdef CONFIG_VFPv3
> +#define kvm_enable_fpexc(vcpu) {			\
> +	u32 fpexc = 0;					\
> +	asm volatile(					\
> +	"mrc p10, 7, %0, cr8, cr0, 0\n"			\
> +	"str %0, [%1]\n"				\
> +	"orr %0, %0, #(1 << 30)\n"			\
> +	"mcr p10, 7, %0, cr8, cr0, 0\n"			\

Don't you need an ISB here? Also, it would be a lot nicer if this was a
real function (possibly inlined). I don't see any real reason to make
this a #define.

Also, you're preserving a lot of the host's FPEXC bits. Is that safe?

> +	: "+r" (fpexc)					\
> +	: "r" (&vcpu->arch.host_fpexc)			\
> +	);						\
> +}
> +#else
> +#define kvm_enable_fpexc(vcpu)
> +#endif
> +
> +/* Restores host FPEXC register */
> +#ifdef CONFIG_VFPv3
> +#define kvm_restore_host_fpexc(vcpu) {			\
> +	asm volatile(					\
> +		"mcr p10, 7, %0, cr8, cr0, 0\n"		\
> +		: : "r" (vcpu->arch.host_fpexc)		\
> +	);						\
> +}
> +#else
> +#define kvm_restore_host_fpexc(vcpu)
> +#endif
> +
>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>  int __attribute_const__ kvm_target_cpu(void);
>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
> @@ -227,6 +259,7 @@ int kvm_perf_teardown(void);
>  void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot);
>  
>  struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr);
> +void kvm_restore_host_vfp_state(struct kvm_vcpu *);
>  
>  static inline void kvm_arch_hardware_disable(void) {}
>  static inline void kvm_arch_hardware_unsetup(void) {}
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index dc017ad..cfc348a 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -291,10 +291,22 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  	vcpu->arch.host_cpu_context = this_cpu_ptr(kvm_host_cpu_state);
>  
>  	kvm_arm_set_running_vcpu(vcpu);
> +
> +	/* Save and enable FPEXC before we load guest context */
> +	kvm_enable_fpexc(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
>  {
> +	/* If the fp/simd registers are dirty save guest, restore host. */
> +	if (vcpu->arch.vfp_dirty) {

See my previous comment about the dirty state.

> +		kvm_restore_host_vfp_state(vcpu);
> +		vcpu->arch.vfp_dirty = 0;
> +	}
> +
> +	/* Restore host FPEXC trashed in vcpu_load */
> +	kvm_restore_host_fpexc(vcpu);
> +
>  	/*
>  	 * The arch-generic KVM code expects the cpu field of a vcpu to be -1
>  	 * if the vcpu is no longer assigned to a cpu.  This is used for the
> diff --git a/arch/arm/kvm/interrupts.S b/arch/arm/kvm/interrupts.S
> index 900ef6d..1ddaa89 100644
> --- a/arch/arm/kvm/interrupts.S
> +++ b/arch/arm/kvm/interrupts.S
> @@ -28,6 +28,26 @@
>  #include "interrupts_head.S"
>  
>  	.text
> +/**
> + * void kvm_restore_host_vfp_state(struct vcpu *vcpu) -
> + *	This function is called from host to save the guest, and restore host
> + *	fp/simd hardware context. It's placed outside of hyp start/end region.
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
> +	pop     {r4-r7}
> +#endif
> +	bx      lr
> +ENDPROC(kvm_restore_host_vfp_state)
>  

Please don't mix things that are part of the HYP code and things that
are not in the same file. This is just asking for trouble. If that's not
mapped into HYP, put it in a separate file.

>  __kvm_hyp_code_start:
>  	.globl __kvm_hyp_code_start
> @@ -116,22 +136,22 @@ ENTRY(__kvm_vcpu_run)
>  	read_cp15_state store_to_vcpu = 0
>  	write_cp15_state read_from_vcpu = 1
>  
> +	set_hcptr_bits set, r4, (HCPTR_TTA)
>  	@ If the host kernel has not been configured with VFPv3 support,
>  	@ then it is safer if we deny guests from using it as well.
>  #ifdef CONFIG_VFPv3
> -	@ Set FPEXC_EN so the guest doesn't trap floating point instructions
> -	VFPFMRX r2, FPEXC		@ VMRS
> -	push	{r2}
> -	orr	r2, r2, #FPEXC_EN
> -	VFPFMXR FPEXC, r2		@ VMSR
> +	@ fp/simd register file has already been accessed, so skip trap enable.
> +	vfp_skip_if_dirty r7, skip_guest_vfp_trap
> +	set_hcptr_bits orr, r4, (HCPTR_TCP(10) | HCPTR_TCP(11))
> +skip_guest_vfp_trap:
>  #endif
> +	set_hcptr vmentry, r4
>  
>  	@ Configure Hyp-role
>  	configure_hyp_role vmentry
>  
>  	@ Trap coprocessor CRx accesses
>  	set_hstr vmentry
> -	set_hcptr vmentry, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
>  	set_hdcr vmentry
>  
>  	@ Write configured ID register into MIDR alias
> @@ -170,23 +190,8 @@ __kvm_vcpu_return:
>  	@ Don't trap coprocessor accesses for host kernel
>  	set_hstr vmexit
>  	set_hdcr vmexit
> -	set_hcptr vmexit, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11)), after_vfp_restore
> -
> -#ifdef CONFIG_VFPv3
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
> -	VFPFMXR FPEXC, r2
> -#else
> -after_vfp_restore:
> -#endif
> +	set_hcptr_bits clear, r4, (HCPTR_TTA | HCPTR_TCP(10) | HCPTR_TCP(11))
> +	set_hcptr vmexit, r4
>  
>  	@ Reset Hyp-role
>  	configure_hyp_role vmexit
> @@ -483,7 +488,12 @@ switch_to_guest_vfp:
>  	push	{r3-r7}
>  
>  	@ NEON/VFP used.  Turn on VFP access.
> -	set_hcptr vmtrap, (HCPTR_TCP(10) | HCPTR_TCP(11))
> +	set_hcptr_bits clear, r4, (HCPTR_TCP(10) | HCPTR_TCP(11))
> +	set_hcptr vmtrap, r4
> +
> +	@ set lazy mode flag, switch hardware context on vcpu_put
> +	mov     r1, #1
> +	strb    r1, [vcpu, #VCPU_VFP_DIRTY]

You are assuming that a boolean is a byte. That's wrong, and not endian
safe. If you want to have such a flag in a structure, use a sized type
(u8, u16, u32). But again, I think we should rely on the trap flags to
make decisions outside of the HYP code.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
