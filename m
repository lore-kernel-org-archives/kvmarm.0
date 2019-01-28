From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH v5 3/5] arm64/kvm: context-switch ptrauth registers
Date: Mon, 28 Jan 2019 14:25:06 +0000
Message-ID: <5a1c670c-700f-b3c3-6981-7ebb37b0d49a@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-4-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1548658727-14271-4-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Amit,

On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work, with
> a semi-lazy context switch of the pointer auth state.
> 
> Pointer authentication feature is only enabled when VHE is built
> into the kernel and present into CPU implementation so only VHE code
> paths are modified.
> 
> When we schedule a vcpu, we disable guest usage of pointer
> authentication instructions and accesses to the keys. While these are
> disabled, we avoid context-switching the keys. When we trap the guest
> trying to use pointer authentication functionality, we change to eagerly
> context-switching the keys, and enable the feature. The next time the
> vcpu is scheduled out/in, we start again.
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
> supports the relevant feature). When the guest is scheduled on a
> physical CPU lacking the feature, these attempts will result in an UNDEF
> being taken by the guest.
> 
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Kristina Martsenko <kristina.martsenko@arm.com>
> Cc: kvmarm@lists.cs.columbia.edu
> Cc: Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/include/asm/kvm_host.h     |  1 +
>  arch/arm64/include/asm/cpufeature.h |  5 +++++
>  arch/arm64/include/asm/kvm_host.h   | 24 ++++++++++++++++++++
>  arch/arm64/include/asm/kvm_hyp.h    |  7 ++++++
>  arch/arm64/kernel/traps.c           |  1 +
>  arch/arm64/kvm/handle_exit.c        | 23 +++++++++++--------
>  arch/arm64/kvm/hyp/Makefile         |  1 +
>  arch/arm64/kvm/hyp/ptrauth-sr.c     | 44 +++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/switch.c         |  4 ++++
>  arch/arm64/kvm/sys_regs.c           | 40 ++++++++++++++++++++++++++-------
>  virt/kvm/arm/arm.c                  |  2 ++
>  11 files changed, 135 insertions(+), 17 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index 704667e..b200c14 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -345,6 +345,7 @@ static inline int kvm_arm_have_ssbd(void)
>  
>  static inline void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu) {}
>  
>  #define __KVM_HAVE_ARCH_VM_ALLOC
>  struct kvm *kvm_arch_alloc_vm(void);
> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
> index dfcfba7..e1bf2a5 100644
> --- a/arch/arm64/include/asm/cpufeature.h
> +++ b/arch/arm64/include/asm/cpufeature.h
> @@ -612,6 +612,11 @@ static inline bool system_supports_generic_auth(void)
>  		 cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_IMP_DEF));
>  }
>  
> +static inline bool kvm_supports_ptrauth(void)
> +{
> +	return system_supports_address_auth() && system_supports_generic_auth();
> +}
> +
>  #define ARM64_SSBD_UNKNOWN		-1
>  #define ARM64_SSBD_FORCE_DISABLE	0
>  #define ARM64_SSBD_KERNEL		1
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 1f2d237..c798d0c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -146,6 +146,18 @@ enum vcpu_sysreg {
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
> @@ -439,6 +451,18 @@ static inline bool kvm_arch_requires_vhe(void)
>  	return false;
>  }
>  
> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
> +
> +static inline void kvm_arm_vcpu_ptrauth_reset(struct kvm_vcpu *vcpu)
> +{
> +	/* Disable ptrauth and use it in a lazy context via traps */
> +	if (has_vhe() && kvm_supports_ptrauth())

Since we state that our support of ptrauth for kvm guests depends on
vhe, maybe it would make sense to put has_vhe() inside
kvm_supports_ptrauth(). This way the dependency is explicitly expressed
in the code.

> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
> +}
> +
> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> +
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index 6e65cad..e559836 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -153,6 +153,13 @@ bool __fpsimd_enabled(void);
>  void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
>  void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
>  
> +void __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> +			       struct kvm_cpu_context *host_ctxt,
> +			       struct kvm_cpu_context *guest_ctxt);
> +void __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> +			      struct kvm_cpu_context *host_ctxt,
> +			      struct kvm_cpu_context *guest_ctxt);
> +
>  u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>  void __noreturn __hyp_do_panic(unsigned long, ...);
>  
> diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> index 4e2fb87..5cac605 100644
> --- a/arch/arm64/kernel/traps.c
> +++ b/arch/arm64/kernel/traps.c
> @@ -749,6 +749,7 @@ static const char *esr_class_str[] = {
>  	[ESR_ELx_EC_CP14_LS]		= "CP14 LDC/STC",
>  	[ESR_ELx_EC_FP_ASIMD]		= "ASIMD",
>  	[ESR_ELx_EC_CP10_ID]		= "CP10 MRC/VMRS",
> +	[ESR_ELx_EC_PAC]		= "Pointer authentication trap",
>  	[ESR_ELx_EC_CP14_64]		= "CP14 MCRR/MRRC",
>  	[ESR_ELx_EC_ILL]		= "PSTATE.IL",
>  	[ESR_ELx_EC_SVC32]		= "SVC (AArch32)",
> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
> index 0b79834..5b980e7 100644
> --- a/arch/arm64/kvm/handle_exit.c
> +++ b/arch/arm64/kvm/handle_exit.c
> @@ -174,19 +174,24 @@ static int handle_sve(struct kvm_vcpu *vcpu, struct kvm_run *run)
>  }
>  
>  /*
> + * Handle the guest trying to use a ptrauth instruction, or trying to access a
> + * ptrauth register.
> + */
> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu)

Nit: I was wondering whether it would make more sense as static inline
in the same header as "kvm_arm_vcpu_ptrauth_reset()"

> +{
> +	if (has_vhe() && kvm_supports_ptrauth())> +		kvm_arm_vcpu_ptrauth_enable(vcpu);
> +	else
> +		kvm_inject_undefined(vcpu);
> +}
> +
> +/*
>   * Guest usage of a ptrauth instruction (which the guest EL1 did not turn into
> - * a NOP).
> + * a NOP), or guest EL1 access to a ptrauth register.

Nit: This comment becomes a bit redundant with the one above, don't know
whether that's a bad thing.


Otherwise things look good to me:

Reviewed-by: Julien Thierry <julien.thierry@arm.com>

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
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index 82d1904..17cec99 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -19,6 +19,7 @@ obj-$(CONFIG_KVM_ARM_HOST) += switch.o
>  obj-$(CONFIG_KVM_ARM_HOST) += fpsimd.o
>  obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
>  obj-$(CONFIG_KVM_ARM_HOST) += hyp-entry.o
> +obj-$(CONFIG_KVM_ARM_HOST) += ptrauth-sr.o
>  
>  # KVM code is run at a different exception code with a different map, so
>  # compiler instrumentation that inserts callbacks or checks into the code may
> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> new file mode 100644
> index 0000000..0576c01
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -0,0 +1,44 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * arch/arm64/kvm/hyp/ptrauth-sr.c: Guest/host ptrauth save/restore
> + *
> + * Copyright 2018 Arm Limited
> + * Author: Mark Rutland <mark.rutland@arm.com>
> + *         Amit Daniel Kachhap <amit.kachhap@arm.com>
> + */
> +#include <linux/compiler.h>
> +#include <linux/kvm_host.h>
> +
> +#include <asm/cpucaps.h>
> +#include <asm/cpufeature.h>
> +#include <asm/kvm_asm.h>
> +#include <asm/kvm_hyp.h>
> +#include <asm/pointer_auth.h>
> +
> +static __always_inline bool __hyp_text __ptrauth_is_enabled(struct kvm_vcpu *vcpu)
> +{
> +	return IS_ENABLED(CONFIG_ARM64_PTR_AUTH) &&
> +			vcpu->arch.ctxt.hcr_el2 & (HCR_API | HCR_APK);
> +}
> +
> +void __no_ptrauth __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> +					  struct kvm_cpu_context *host_ctxt,
> +					  struct kvm_cpu_context *guest_ctxt)
> +{
> +	if (!__ptrauth_is_enabled(vcpu))
> +		return;
> +
> +	ptrauth_keys_store((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
> +	ptrauth_keys_switch((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
> +}
> +
> +void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> +					 struct kvm_cpu_context *host_ctxt,
> +					 struct kvm_cpu_context *guest_ctxt)
> +{
> +	if (!__ptrauth_is_enabled(vcpu))
> +		return;
> +
> +	ptrauth_keys_store((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
> +	ptrauth_keys_switch((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
> +}
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index 03b36f1..301d332 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -483,6 +483,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> +	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
> +
>  	__set_guest_arch_workaround_state(vcpu);
>  
>  	do {
> @@ -494,6 +496,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	__set_host_arch_workaround_state(vcpu);
>  
> +	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
> +
>  	sysreg_save_guest_state_vhe(guest_ctxt);
>  
>  	__deactivate_traps(vcpu);
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e3e3722..2546a65 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -986,6 +986,32 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> +
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
> +#define __PTRAUTH_KEY(k)						\
> +	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k }
> +
> +#define PTRAUTH_KEY(k)							\
> +	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
> +	__PTRAUTH_KEY(k ## KEYHI_EL1)
> +
>  static bool access_cntp_tval(struct kvm_vcpu *vcpu,
>  		struct sys_reg_params *p,
>  		const struct sys_reg_desc *r)
> @@ -1040,14 +1066,6 @@ static u64 read_id_reg(struct sys_reg_desc const *r, bool raz)
>  			kvm_debug("SVE unsupported for guests, suppressing\n");
>  
>  		val &= ~(0xfUL << ID_AA64PFR0_SVE_SHIFT);
> -	} else if (id == SYS_ID_AA64ISAR1_EL1) {
> -		const u64 ptrauth_mask = (0xfUL << ID_AA64ISAR1_APA_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_API_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_GPA_SHIFT) |
> -					 (0xfUL << ID_AA64ISAR1_GPI_SHIFT);
> -		if (val & ptrauth_mask)
> -			kvm_debug("ptrauth unsupported for guests, suppressing\n");
> -		val &= ~ptrauth_mask;
>  	} else if (id == SYS_ID_AA64MMFR1_EL1) {
>  		if (val & (0xfUL << ID_AA64MMFR1_LOR_SHIFT))
>  			kvm_debug("LORegions unsupported for guests, suppressing\n");
> @@ -1316,6 +1334,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
> index 2d65ada..6d377d3 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -388,6 +388,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
>  		vcpu_clear_wfe_traps(vcpu);
>  	else
>  		vcpu_set_wfe_traps(vcpu);
> +
> +	kvm_arm_vcpu_ptrauth_reset(vcpu);
>  }
>  
>  void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> 

-- 
Julien Thierry
