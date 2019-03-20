From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v7 7/10] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 20 Mar 2019 12:13:04 +0000
Message-ID: <a3252299-b1ac-3d39-31a4-ca653daa815f@arm.com>
References: <1552984243-7689-1-git-send-email-amit.kachhap@arm.com>
 <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552984243-7689-8-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 19/03/2019 08:30, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work, with
> a semi-lazy context switch of the pointer auth state.
> 
> Pointer authentication feature is only enabled when VHE is built
> in the kernel and present in the CPU implementation so only VHE code
> paths are modified.
> 
> When we schedule a vcpu, we disable guest usage of pointer
> authentication instructions and accesses to the keys. While these are
> disabled, we avoid context-switching the keys. When we trap the guest
> trying to use pointer authentication functionality, we change to eagerly
> context-switching the keys, and enable the feature. The next time the
> vcpu is scheduled out/in, we start again. However the host key save is
> optimized and implemented inside ptrauth instruction/register access
> trap.
> 
> Pointer authentication consists of address authentication and generic
> authentication, and CPUs in a system might have varied support for
> either. Where support for either feature is not uniform, it is hidden
> from guests via ID register emulation, as a result of the cpufeature
> framework in the host.
> 
> Unfortunately, address authentication and generic authentication cannot
> be trapped separately, as the architecture provides a single EL2 trap
> covering both. If we wish to expose one without the other, we cannot
> prevent a (badly-written) guest from intermittently using a feature
> which is not uniformly supported (when scheduled on a physical CPU which
> supports the relevant feature). Hence, this patch expects both type of
> authentication to be present in a cpu.
> 
> This switch of key is done from guest enter/exit assembly as preperation
> for the upcoming in-kernel pointer authentication support. Hence, these
> key switching routines are not implemented in C code as they may cause
> pointer authentication key signing error in some situations.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
> , save host key in ptrauth exception trap]
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm64/include/asm/kvm_host.h        |  17 ++++++
>  arch/arm64/include/asm/kvm_ptrauth_asm.h | 100 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/asm-offsets.c          |   6 ++
>  arch/arm64/kvm/guest.c                   |  14 +++++
>  arch/arm64/kvm/handle_exit.c             |  24 +++++---
>  arch/arm64/kvm/hyp/entry.S               |   7 +++
>  arch/arm64/kvm/reset.c                   |   7 +++
>  arch/arm64/kvm/sys_regs.c                |  46 +++++++++++++-
>  virt/kvm/arm/arm.c                       |   2 +
>  9 files changed, 212 insertions(+), 11 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_ptrauth_asm.h
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 9dd2918..61239a6 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -152,6 +152,18 @@ enum vcpu_sysreg {
>  	PMSWINC_EL0,	/* Software Increment Register */
>  	PMUSERENR_EL0,	/* User Enable Register */
>  
> +	/* Pointer Authentication Registers */
> +	APIAKEYLO_EL1,
> +	APIAKEYHI_EL1,
> +	APIBKEYLO_EL1,
> +	APIBKEYHI_EL1,
> +	APDAKEYLO_EL1,
> +	APDAKEYHI_EL1,
> +	APDBKEYLO_EL1,
> +	APDBKEYHI_EL1,
> +	APGAKEYLO_EL1,
> +	APGAKEYHI_EL1,
> +
>  	/* 32bit specific registers. Keep them at the end of the range */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
> @@ -497,6 +509,11 @@ static inline bool kvm_arch_requires_vhe(void)
>  		test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) && \
>  		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features))
>  
> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> +
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/arm64/include/asm/kvm_ptrauth_asm.h b/arch/arm64/include/asm/kvm_ptrauth_asm.h
> new file mode 100644
> index 0000000..97bb040
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_ptrauth_asm.h
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: GPL-2.0
> + * arch/arm64/include/asm/kvm_ptrauth_asm.h: Guest/host ptrauth save/restore
> + * Copyright 2019 Arm Limited
> + * Author: Mark Rutland <mark.rutland@arm.com>
> + *         Amit Daniel Kachhap <amit.kachhap@arm.com>
> + */
> +
> +#ifndef __ASM_KVM_ASM_PTRAUTH_H
> +#define __ASM_KVM_ASM_PTRAUTH_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#define __ptrauth_save_key(regs, key)						\
> +({										\
> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
> +#define __ptrauth_save_state(ctxt)						\
> +({										\
> +	__ptrauth_save_key(ctxt->sys_regs, APIA);				\
> +	__ptrauth_save_key(ctxt->sys_regs, APIB);				\
> +	__ptrauth_save_key(ctxt->sys_regs, APDA);				\
> +	__ptrauth_save_key(ctxt->sys_regs, APDB);				\
> +	__ptrauth_save_key(ctxt->sys_regs, APGA);				\
> +})
> +
> +#else /* __ASSEMBLY__ */
> +
> +#include <asm/sysreg.h>
> +
> +#ifdef	CONFIG_ARM64_PTR_AUTH
> +
> +#define PTRAUTH_REG_OFFSET(x)	(x - CPU_APIAKEYLO_EL1)

I don't really see the point of this macro. You move the pointers of
kvm_cpu_contexts to point to where the ptr auth registers are (which is
in the middle of an array) by adding the offset of APIAKEYLO and then we
have to recompute all offsets with this macro.

Why not just pass the kvm_cpu_context pointers to
ptrauth_save/restore_state and use the already defined offsets
(CPU_AP*_EL1) directly?

I think this would also allow to use one less register for the
ptrauth_switch_to_* macros.

> +
> +.macro	ptrauth_save_state base, reg1, reg2
> +	mrs_s	\reg1, SYS_APIAKEYLO_EL1
> +	mrs_s	\reg2, SYS_APIAKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
> +	mrs_s	\reg1, SYS_APIBKEYLO_EL1
> +	mrs_s	\reg2, SYS_APIBKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
> +	mrs_s	\reg1, SYS_APDAKEYLO_EL1
> +	mrs_s	\reg2, SYS_APDAKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
> +	mrs_s	\reg1, SYS_APDBKEYLO_EL1
> +	mrs_s	\reg2, SYS_APDBKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
> +	mrs_s	\reg1, SYS_APGAKEYLO_EL1
> +	mrs_s	\reg2, SYS_APGAKEYHI_EL1
> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
> +.endm
> +
> +.macro	ptrauth_restore_state base, reg1, reg2
> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
> +	msr_s	SYS_APIAKEYLO_EL1, \reg1
> +	msr_s	SYS_APIAKEYHI_EL1, \reg2
> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
> +	msr_s	SYS_APIBKEYLO_EL1, \reg1
> +	msr_s	SYS_APIBKEYHI_EL1, \reg2
> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
> +	msr_s	SYS_APDAKEYLO_EL1, \reg1
> +	msr_s	SYS_APDAKEYHI_EL1, \reg2
> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
> +	msr_s	SYS_APDBKEYLO_EL1, \reg1
> +	msr_s	SYS_APDBKEYHI_EL1, \reg2
> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
> +	msr_s	SYS_APGAKEYLO_EL1, \reg1
> +	msr_s	SYS_APGAKEYHI_EL1, \reg2
> +	.endm

Nit: Bad indentation.

> +
> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> +	ldr	\reg1, [\g_ctxt, #CPU_HCR_EL2]
> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> +	cbz	\reg1, skip_switch_to_guest
> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_restore_state	\reg1, \reg2, \reg3

As mentioned we probably can get rid of one temporary register and
directly pass g_ctxt here.

> +skip_switch_to_guest:

I believe you should use numbered labels for assembly macros, otherwise
multiple references to that macros will lead to symbol redefinitions.

> +.endm
> +
> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
> +	ldr	\reg1, [\g_ctxt, #CPU_HCR_EL2]
> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> +	cbz	\reg1, skip_switch_to_host
> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_save_state	\reg1, \reg2, \reg3
> +	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_restore_state	\reg1, \reg2, \reg3
> +	isb
> +skip_switch_to_host:

Same.

Cheers,

Julien

> +.endm
> +
> +#else /* !CONFIG_ARM64_PTR_AUTH */
> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> +.endm
> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
> +.endm
> +#endif /* CONFIG_ARM64_PTR_AUTH */
> +#endif /* __ASSEMBLY__ */
> +#endif /* __ASM_KVM_ASM_PTRAUTH_H */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 7f40dcb..12ca916 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -126,6 +126,12 @@ int main(void)
>    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
>    DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
>    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
> +  DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
> +  DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
> +  DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
> +  DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
> +  DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
> +  DEFINE(CPU_HCR_EL2,		offsetof(struct kvm_cpu_context, hcr_el2));
>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
>    DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
>  #endif
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index e2f0268..9f591ad 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -544,3 +544,17 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  
>  	return ret;
>  }
> +
> +/**
> + * kvm_arm_vcpu_ptrauth_setup_lazy - setup lazy ptrauth for vcpu schedule
> + *
> + * @vcpu: The VCPU pointer
> + *
> + * This function may be used to disable ptrauth and use it in a lazy context
> + * via traps.
> + */
> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_has_ptrauth(vcpu))
> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
> +}
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 0b79834..5838ff9 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -30,6 +30,7 @@
>  #include <asm/kvm_coproc.h>
>  #include <asm/kvm_emulate.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_ptrauth_asm.h>
>  #include <asm/debug-monitors.h>
>  #include <asm/traps.h>
>  
> @@ -174,19 +175,26 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  }
>  
>  /*
> + * Handle the guest trying to use a ptrauth instruction, or trying to access a
> + * ptrauth register.
> + */
> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)
> +{
> +	if (vcpu_has_ptrauth(vcpu)) {
> +		kvm_arm_vcpu_ptrauth_enable(vcpu);
> +		__ptrauth_save_state(vcpu->arch.host_cpu_context);
> +	} else {
> +		kvm_inject_undefined(vcpu);
> +	}
> +}
> +
> +/*
>   * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
>   * a NOP).
>   */
>  static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  {
> -	/*
> -	 * We don't currently support ptrauth in a guest, and we mask the ID
> -	 * registers to prevent well-behaved guests from trying to make use of
> -	 * it.
> -	 *
> -	 * Inject an UNDEF, as if the feature really isn't present.
> -	 */
> -	kvm_inject_undefined(vcpu);
> +	kvm_arm_vcpu_ptrauth_trap(vcpu);
>  	return 1;
>  }
>  
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index 675fdc1..3a70213 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -24,6 +24,7 @@
>  #include <asm/kvm_arm.h>
>  #include <asm/kvm_asm.h>
>  #include <asm/kvm_mmu.h>
> +#include <asm/kvm_ptrauth_asm.h>
>  
>  #define CPU_GP_REG_OFFSET(x)	(CPU_GP_REGS + x)
>  #define CPU_XREG_OFFSET(x)	CPU_GP_REG_OFFSET(CPU_USER_PT_REGS + 8*x)
> @@ -64,6 +65,9 @@ ENTRY(__guest_enter)
>  
>  	add	x18, x0, #VCPU_CONTEXT
>  
> +	// Macro ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3).
> +	ptrauth_switch_to_guest x18, x0, x1, x2
> +
>  	// Restore guest regs x0-x17
>  	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
>  	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
> @@ -118,6 +122,9 @@ ENTRY(__guest_exit)
>  
>  	get_host_ctxt	x2, x3
>  
> +	// Macro ptrauth_switch_to_host(guest cxt, host cxt, tmp1, tmp2, tmp3).
> +	ptrauth_switch_to_host x1, x2, x3, x4, x5
> +
>  	// Now restore the host regs
>  	restore_callee_saved_regs x2
>  
> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
> index f16a5f8..00f0639 100644
> --- a/arch/arm64/kvm/reset.c
> +++ b/arch/arm64/kvm/reset.c
> @@ -128,6 +128,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
>  	if (loaded)
>  		kvm_arch_vcpu_put(vcpu);
>  
> +	if (test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
> +		test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features)) {
> +		/* Verify that KVM startup matches the conditions for ptrauth */
> +		if (WARN_ON(!vcpu_has_ptrauth(vcpu)))
> +			return -EINVAL;
> +	}
> +
>  	switch (vcpu->arch.target) {
>  	default:
>  		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 75942f6..ed6613e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1007,6 +1007,38 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.ctxt.hcr_el2 |= (HCR_API | HCR_APK);
> +}
> +
> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.ctxt.hcr_el2 &= ~(HCR_API | HCR_APK);
> +}
> +
> +static bool trap_ptrauth(struct kvm_vcpu *vcpu,
> +			 struct sys_reg_params *p,
> +			 const struct sys_reg_desc *rd)
> +{
> +	kvm_arm_vcpu_ptrauth_trap(vcpu);
> +	return false;
> +}
> +
> +static unsigned int ptrauth_restrictions(const struct kvm_vcpu *vcpu,
> +			const struct sys_reg_desc *rd)
> +{
> +	return vcpu_has_ptrauth(vcpu) ? 0 : REG_NO_USER | REG_NO_GUEST;
> +}
> +
> +#define __PTRAUTH_KEY(k)						\
> +	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k,		\
> +	.restrictions = ptrauth_restrictions}
> +
> +#define PTRAUTH_KEY(k)							\
> +	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
> +	__PTRAUTH_KEY(k ## KEYHI_EL1)
> +
>  static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  			      struct sys_reg_params *p,
>  			      const struct sys_reg_desc *r)
> @@ -1061,9 +1093,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
>  					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
>  					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> -		if (val & ptrauth_mask)
> -			kvm_debug("ptrauth unsupported for guests, suppressing\n");
> -		val &= ~ptrauth_mask;
> +		if (!vcpu_has_ptrauth(vcpu)) {
> +			if (val & ptrauth_mask)
> +				kvm_debug("ptrauth unsupported for guests, suppressing\n");
> +			val &= ~ptrauth_mask;
> +		}
>  	}
>  
>  	return val;
> @@ -1387,6 +1421,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	{ SYS_DESC(SYS_TTBR1_EL1), access_vm_reg, reset_unknown, TTBR1_EL1 },
>  	{ SYS_DESC(SYS_TCR_EL1), access_vm_reg, reset_val, TCR_EL1, 0 },
>  
> +	PTRAUTH_KEY(APIA),
> +	PTRAUTH_KEY(APIB),
> +	PTRAUTH_KEY(APDA),
> +	PTRAUTH_KEY(APDB),
> +	PTRAUTH_KEY(APGA),
> +
>  	{ SYS_DESC(SYS_AFSR0_EL1), access_vm_reg, reset_unknown, AFSR0_EL1 },
>  	{ SYS_DESC(SYS_AFSR1_EL1), access_vm_reg, reset_unknown, AFSR1_EL1 },
>  	{ SYS_DESC(SYS_ESR_EL1), access_vm_reg, reset_unknown, ESR_EL1 },
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 58de0ca..50ae066 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -385,6 +385,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		vcpu_clear_wfe_traps(vcpu);
>  	else
>  		vcpu_set_wfe_traps(vcpu);
> +
> +	kvm_arm_vcpu_ptrauth_setup_lazy(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> 

-- 
Julien Thierry
