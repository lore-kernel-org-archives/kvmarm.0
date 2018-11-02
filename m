From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v3 2/7] arm64/kvm: context-switch ptrauth registers
Date: Fri, 2 Nov 2018 09:37:25 +0100
Message-ID: <20181102083725.GV12057@e113682-lin.lund.arm.com>
References: <1539773280-4159-1-git-send-email-amit.kachhap@arm.com>
 <1539773280-4159-3-git-send-email-amit.kachhap@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1539773280-4159-3-git-send-email-amit.kachhap@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Oct 17, 2018 at 04:17:55PM +0530, Amit Daniel Kachhap wrote:
> From: Mark Rutland <mark.rutland@arm.com>
> 
> When pointer authentication is supported, a guest may wish to use it.
> This patch adds the necessary KVM infrastructure for this to work.
> 
> When we schedule a vcpu, we enable guest usage of pointer
> authentication instructions and accesses to the keys. After these are
> enabled, we allow context-switching the keys.
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
> Cc: kvmarm@lists.cs.columbia.edu
> ---
>  arch/arm/include/asm/kvm_host.h     |  2 +
>  arch/arm64/include/asm/cpufeature.h |  6 +++
>  arch/arm64/include/asm/kvm_host.h   | 29 +++++++++++++++
>  arch/arm64/include/asm/kvm_hyp.h    |  7 ++++
>  arch/arm64/kernel/traps.c           |  1 +
>  arch/arm64/kvm/handle_exit.c        | 24 +++++++-----
>  arch/arm64/kvm/hyp/Makefile         |  1 +
>  arch/arm64/kvm/hyp/ptrauth-sr.c     | 73 +++++++++++++++++++++++++++++++++++++
>  arch/arm64/kvm/hyp/switch.c         |  8 ++++
>  arch/arm64/kvm/sys_regs.c           | 40 ++++++++++++++++----
>  virt/kvm/arm/arm.c                  |  3 ++
>  11 files changed, 177 insertions(+), 17 deletions(-)
>  create mode 100644 arch/arm64/kvm/hyp/ptrauth-sr.c
> 

[...]

> diff --git a/arch/arm64/kvm/hyp/ptrauth-sr.c b/arch/arm64/kvm/hyp/ptrauth-sr.c
> new file mode 100644
> index 0000000..6e96908
> --- /dev/null
> +++ b/arch/arm64/kvm/hyp/ptrauth-sr.c
> @@ -0,0 +1,73 @@
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
> +	return vcpu->arch.hcr_el2 & (HCR_API | HCR_APK);
> +}
> +
> +#define __ptrauth_save_key(regs, key)						\
> +({										\
> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
> +static __always_inline void __hyp_text __ptrauth_save_state(struct kvm_cpu_context *ctxt)
> +{
> +	__ptrauth_save_key(ctxt->sys_regs, APIA);
> +	__ptrauth_save_key(ctxt->sys_regs, APIB);
> +	__ptrauth_save_key(ctxt->sys_regs, APDA);
> +	__ptrauth_save_key(ctxt->sys_regs, APDB);
> +	__ptrauth_save_key(ctxt->sys_regs, APGA);
> +}
> +
> +#define __ptrauth_restore_key(regs, key) 					\
> +({										\
> +	write_sysreg_s(regs[key ## KEYLO_EL1], SYS_ ## key ## KEYLO_EL1);	\
> +	write_sysreg_s(regs[key ## KEYHI_EL1], SYS_ ## key ## KEYHI_EL1);	\
> +})
> +
> +static __always_inline void __hyp_text __ptrauth_restore_state(struct kvm_cpu_context *ctxt)
> +{
> +	__ptrauth_restore_key(ctxt->sys_regs, APIA);
> +	__ptrauth_restore_key(ctxt->sys_regs, APIB);
> +	__ptrauth_restore_key(ctxt->sys_regs, APDA);
> +	__ptrauth_restore_key(ctxt->sys_regs, APDB);
> +	__ptrauth_restore_key(ctxt->sys_regs, APGA);
> +}
> +
> +void __no_ptrauth __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
> +					  struct kvm_cpu_context *host_ctxt,
> +					  struct kvm_cpu_context *guest_ctxt)
> +{
> +	if (!__ptrauth_is_enabled(vcpu))
> +		return;
> +
> +	__ptrauth_save_state(host_ctxt);
> +	__ptrauth_restore_state(guest_ctxt);
> +}
> +
> +void __no_ptrauth __hyp_text __ptrauth_switch_to_host(struct kvm_vcpu *vcpu,
> +					 struct kvm_cpu_context *host_ctxt,
> +					 struct kvm_cpu_context *guest_ctxt)
> +{
> +	if (!__ptrauth_is_enabled(vcpu))
> +		return;
> +
> +	__ptrauth_save_state(guest_ctxt);
> +	__ptrauth_restore_state(host_ctxt);
> +}
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index fa7dab9..714ee5b 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -508,6 +508,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  	sysreg_restore_guest_state_vhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> +	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
> +
>  	__set_guest_arch_workaround_state(vcpu);
>  
>  	do {
> @@ -519,6 +521,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	__set_host_arch_workaround_state(vcpu);
>  
> +	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
> +
>  	sysreg_save_guest_state_vhe(guest_ctxt);
>  
>  	__deactivate_traps(vcpu);
> @@ -562,6 +566,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  	__sysreg_restore_state_nvhe(guest_ctxt);
>  	__debug_switch_to_guest(vcpu);
>  
> +	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
> +
>  	__set_guest_arch_workaround_state(vcpu);
>  
>  	do {
> @@ -573,6 +579,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  
>  	__set_host_arch_workaround_state(vcpu);
>  
> +	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
> +
>  	__sysreg_save_state_nvhe(guest_ctxt);
>  	__sysreg32_save_state(vcpu);
>  	__timer_disable_traps(vcpu);

Two questions:

 - Can we limit all ptrauth functionality to VHE systems so that we
   don't need to touch the non-VHE path and so that we don't need any of
   the __hyp_text stuff?

 - Can we move all the save/restore logic to vcpu load/put as long as
   the host kernel itself isn't using ptrauth, and if the host kernel at
   some point begins to use ptrauth, can we have a hook to save/restore
   at that time (similar to what we do for FPSIMD) to avoid this
   overhead on every switch?


Thanks,

    Christoffer
