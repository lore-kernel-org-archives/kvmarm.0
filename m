Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0EDFC282DA
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 09:09:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3B37E2173C
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 09:09:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B37E2173C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B000D4A4BD;
	Wed, 17 Apr 2019 05:09:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id JE6tvA6-pA5l; Wed, 17 Apr 2019 05:09:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 943C74A502;
	Wed, 17 Apr 2019 05:09:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 682CB4A4BD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 05:09:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fgkF-lxX0asz for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 05:09:17 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2FF804A4BB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 05:09:17 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A2F66374;
 Wed, 17 Apr 2019 02:09:16 -0700 (PDT)
Received: from [10.1.196.92] (usa-sjc-imap-foss1.foss.arm.com [10.72.51.249])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 BC99D3F690; Wed, 17 Apr 2019 02:09:12 -0700 (PDT)
Subject: Re: [PATCH v9 2/5] KVM: arm/arm64: context-switch ptrauth registers
To: Amit Daniel Kachhap <amit.kachhap@arm.com>,
 linux-arm-kernel@lists.infradead.org
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-3-git-send-email-amit.kachhap@arm.com>
From: Marc Zyngier <marc.zyngier@arm.com>
Openpgp: preference=signencrypt
Autocrypt: addr=marc.zyngier@arm.com; prefer-encrypt=mutual; keydata=
 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
Organization: ARM Ltd
Message-ID: <46605d92-7651-f917-f65b-d36f721468fc@arm.com>
Date: Wed, 17 Apr 2019 10:09:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1555039236-10608-3-git-send-email-amit.kachhap@arm.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190417090910.M7JH6qeya8eqeabJ5aNN0v_kITel9hGr2jts-_Q2sps@z>

Hi Amit,

On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
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
> This switch of key is done from guest enter/exit assembly as preparation
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
> 
> Changes since v9:
> * Used high order number for branching in assembly macros. [Kristina Martsenko]
> * Taken care of different offset for hcr_el2 now.
> 
>  arch/arm/include/asm/kvm_host.h          |   1 +
>  arch/arm64/Kconfig                       |   5 +-
>  arch/arm64/include/asm/kvm_host.h        |  17 +++++
>  arch/arm64/include/asm/kvm_ptrauth_asm.h | 106 +++++++++++++++++++++++++++++++
>  arch/arm64/kernel/asm-offsets.c          |   6 ++
>  arch/arm64/kvm/guest.c                   |  14 ++++
>  arch/arm64/kvm/handle_exit.c             |  24 ++++---
>  arch/arm64/kvm/hyp/entry.S               |   7 ++
>  arch/arm64/kvm/sys_regs.c                |  46 +++++++++++++-
>  virt/kvm/arm/arm.c                       |   2 +
>  10 files changed, 215 insertions(+), 13 deletions(-)
>  create mode 100644 arch/arm64/include/asm/kvm_ptrauth_asm.h
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index e80cfc1..7a5c7f8 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -363,6 +363,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>  static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
>  static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
> +static inline void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
>  
>  static inline void kvm_arm_vhe_guest_enter(void) {}
>  static inline void kvm_arm_vhe_guest_exit(void) {}
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 7e34b9e..9e8506e 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
>  	  context-switched along with the process.
>  
>  	  The feature is detected at runtime. If the feature is not present in
> -	  hardware it will not be advertised to userspace nor will it be
> -	  enabled.
> +	  hardware it will not be advertised to userspace/KVM guest nor will it
> +	  be enabled. However, KVM guest also require CONFIG_ARM64_VHE=y to use
> +	  this feature.

Not only does it require CONFIG_ARM64_VHE, but it more importantly
requires a VHE system!

>  
>  endmenu
>  
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 31dbc7c..a585d82 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -161,6 +161,18 @@ enum vcpu_sysreg {
>  	PMSWINC_EL0,	/* Software Increment Register */
>  	PMUSERENR_EL0,	/* User Enable Register */
>  
> +	/* Pointer Authentication Registers in a strict increasing order. */
> +	APIAKEYLO_EL1,
> +	APIAKEYHI_EL1 = APIAKEYLO_EL1 + 1,
> +	APIBKEYLO_EL1 = APIAKEYLO_EL1 + 2,
> +	APIBKEYHI_EL1 = APIAKEYLO_EL1 + 3,
> +	APDAKEYLO_EL1 = APIAKEYLO_EL1 + 4,
> +	APDAKEYHI_EL1 = APIAKEYLO_EL1 + 5,
> +	APDBKEYLO_EL1 = APIAKEYLO_EL1 + 6,
> +	APDBKEYHI_EL1 = APIAKEYLO_EL1 + 7,
> +	APGAKEYLO_EL1 = APIAKEYLO_EL1 + 8,
> +	APGAKEYHI_EL1 = APIAKEYLO_EL1 + 9,

Why do we need these explicit +1, +2...? Being an part of an enum
already guarantees this.

> +
>  	/* 32bit specific registers. Keep them at the end of the range */
>  	DACR32_EL2,	/* Domain Access Control Register */
>  	IFSR32_EL2,	/* Instruction Fault Status Register */
> @@ -529,6 +541,11 @@ static inline bool kvm_arch_requires_vhe(void)
>  	return false;
>  }
>  
> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu);
> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
> +
>  static inline void kvm_arch_hardware_unsetup(void) {}
>  static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>  static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
> diff --git a/arch/arm64/include/asm/kvm_ptrauth_asm.h b/arch/arm64/include/asm/kvm_ptrauth_asm.h
> new file mode 100644
> index 0000000..8142521
> --- /dev/null
> +++ b/arch/arm64/include/asm/kvm_ptrauth_asm.h

nit: this should be named kvm_ptrauth.h. The asm suffix doesn't bring
anything to the game, and is somewhat misleading (there are C macros in
this file).

> @@ -0,0 +1,106 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* arch/arm64/include/asm/kvm_ptrauth_asm.h: Guest/host ptrauth save/restore
> + * Copyright 2019 Arm Limited
> + * Author: Mark Rutland <mark.rutland@arm.com>

nit: Authors

> + *         Amit Daniel Kachhap <amit.kachhap@arm.com>
> + */
> +
> +#ifndef __ASM_KVM_PTRAUTH_ASM_H
> +#define __ASM_KVM_PTRAUTH_ASM_H
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
> +
> +/*
> + * CPU_AP*_EL1 values exceed immediate offset range (512) for stp instruction
> + * so below macros takes CPU_APIAKEYLO_EL1 as base and calculates the offset of
> + * the keys from this base to avoid an extra add instruction. These macros
> + * assumes the keys offsets are aligned in a specific increasing order.
> + */
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
> +.endm
> +
> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> +	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]

Given that 100% of the current HW doesn't have ptrauth at all, this
becomes an instant and pointless overhead.

It could easily be avoided by turning this into:

alternative_if_not ARM64_HAS_GENERIC_AUTH_ARCH
	b	1000f
alternative_else
	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
alternative_endif

> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> +	cbz	\reg1, 1000f
> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_restore_state	\reg1, \reg2, \reg3
> +1000:
> +.endm
> +
> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
> +	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]

Same thing here.

> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
> +	cbz	\reg1, 1001f
> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_save_state	\reg1, \reg2, \reg3
> +	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
> +	ptrauth_restore_state	\reg1, \reg2, \reg3
> +	isb
> +1001:
> +.endm
> +
> +#else /* !CONFIG_ARM64_PTR_AUTH */
> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
> +.endm
> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
> +.endm
> +#endif /* CONFIG_ARM64_PTR_AUTH */
> +#endif /* __ASSEMBLY__ */
> +#endif /* __ASM_KVM_PTRAUTH_ASM_H */
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 7f40dcb..8178330 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -125,7 +125,13 @@ int main(void)
>    DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
>    DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
>    DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
> +  DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>    DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
> +  DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
> +  DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
> +  DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
> +  DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
> +  DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
>    DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
>  #endif
> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
> index 4f7b26b..e07f763 100644
> --- a/arch/arm64/kvm/guest.c
> +++ b/arch/arm64/kvm/guest.c
> @@ -878,3 +878,17 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
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

Why does this live in guest.c?

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

It is odd that the enable function is placed in sys_regs.c, and only
used here. You could either just inline it here, or make it a static
inline in kvm_host.h.

> +		__ptrauth_save_state(vcpu->arch.host_cpu_context);

You could expand the __ptrauth_save_state macro here. It is only used
once, and one less level of obfuscation will help grepping.

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

This comment doesn't tell us much. What we really need is a comment
explaining *why* this needs to be an inline macro. Otherwise, someone
will one day move it back to some C code and things will randomly break.

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
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 09e9b06..4a98b5c 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1007,6 +1007,38 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	{ SYS_DESC(SYS_PMEVTYPERn_EL0(n)),					\
>  	  access_pmu_evtyper, reset_unknown, (PMEVTYPER0_EL0 + n), }
>  
> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
> +}
> +
> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
> +}

As mentionned above, these could be moved as static inline to an include
file, of even directly inlined in the code that use it.

> +
> +static bool trap_ptrauth(struct kvm_vcpu *vcpu,
> +			 struct sys_reg_params *p,
> +			 const struct sys_reg_desc *rd)
> +{
> +	kvm_arm_vcpu_ptrauth_trap(vcpu);
> +	return false;

We need a comment explaining why we return false: Either ptrauth is on,
and we re-execute the same instruction, or it is off, and we have
injected an UNDEF. In both cases, we don't advance the guest's PC.

> +}
> +
> +static unsigned int ptrauth_visibility(const struct kvm_vcpu *vcpu,
> +			const struct sys_reg_desc *rd)
> +{
> +	return vcpu_has_ptrauth(vcpu) ? 0 : REG_HIDDEN_USER | REG_HIDDEN_GUEST;
> +}
> +
> +#define __PTRAUTH_KEY(k)						\
> +	{ SYS_DESC(SYS_## k), trap_ptrauth, reset_unknown, k,		\
> +	.visibility = ptrauth_visibility}
> +
> +#define PTRAUTH_KEY(k)							\
> +	__PTRAUTH_KEY(k ## KEYLO_EL1),					\
> +	__PTRAUTH_KEY(k ## KEYHI_EL1)
> +
>  static bool access_arch_timer(struct kvm_vcpu *vcpu,
>  			      struct sys_reg_params *p,
>  			      const struct sys_reg_desc *r)
> @@ -1058,9 +1090,11 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
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
> @@ -1460,6 +1494,12 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
> index 9edbf0f..8d1b73c 100644
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

Despite all the comments, the code looks in good shape, and I trust it
shouldn't take you long to refactor it, retest it and send an updated
version once we've settled on the ABI part which is the most contentious.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
