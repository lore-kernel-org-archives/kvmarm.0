From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v9 2/5] KVM: arm/arm64: context-switch ptrauth registers
Date: Wed, 17 Apr 2019 15:39:17 +0100
Message-ID: <da636628-a605-5d51-2a31-71b2ddbf5989@arm.com>
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-3-git-send-email-amit.kachhap@arm.com>
 <46605d92-7651-f917-f65b-d36f721468fc@arm.com>
 <4e0699fe-77d5-b65b-8237-ebb8a9bd3e2e@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4e0699fe-77d5-b65b-8237-ebb8a9bd3e2e@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Daniel Kachhap <amit.kachhap@arm.com>, linux-arm-kernel@lists.infradead.org
Cc: Christoffer Dall <christoffer.dall@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andrew Jones <drjones@redhat.com>, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, Kristina Martsenko <kristina.martsenko@arm.com>, linux-kernel@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, Julien Thierry <julien.thierry@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 17/04/2019 15:24, Amit Daniel Kachhap wrote:
> Hi Marc,
> 
> On 4/17/19 2:39 PM, Marc Zyngier wrote:
>> Hi Amit,
>>
>> On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
>>> From: Mark Rutland <mark.rutland@arm.com>
>>>
>>> When pointer authentication is supported, a guest may wish to use it.
>>> This patch adds the necessary KVM infrastructure for this to work, with
>>> a semi-lazy context switch of the pointer auth state.
>>>
>>> Pointer authentication feature is only enabled when VHE is built
>>> in the kernel and present in the CPU implementation so only VHE code
>>> paths are modified.
>>>
>>> When we schedule a vcpu, we disable guest usage of pointer
>>> authentication instructions and accesses to the keys. While these are
>>> disabled, we avoid context-switching the keys. When we trap the guest
>>> trying to use pointer authentication functionality, we change to eagerly
>>> context-switching the keys, and enable the feature. The next time the
>>> vcpu is scheduled out/in, we start again. However the host key save is
>>> optimized and implemented inside ptrauth instruction/register access
>>> trap.
>>>
>>> Pointer authentication consists of address authentication and generic
>>> authentication, and CPUs in a system might have varied support for
>>> either. Where support for either feature is not uniform, it is hidden
>>> from guests via ID register emulation, as a result of the cpufeature
>>> framework in the host.
>>>
>>> Unfortunately, address authentication and generic authentication cannot
>>> be trapped separately, as the architecture provides a single EL2 trap
>>> covering both. If we wish to expose one without the other, we cannot
>>> prevent a (badly-written) guest from intermittently using a feature
>>> which is not uniformly supported (when scheduled on a physical CPU which
>>> supports the relevant feature). Hence, this patch expects both type of
>>> authentication to be present in a cpu.
>>>
>>> This switch of key is done from guest enter/exit assembly as preparation
>>> for the upcoming in-kernel pointer authentication support. Hence, these
>>> key switching routines are not implemented in C code as they may cause
>>> pointer authentication key signing error in some situations.
>>>
>>> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
>>> [Only VHE, key switch in full assembly, vcpu_has_ptrauth checks
>>> , save host key in ptrauth exception trap]
>>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>>> Reviewed-by: Julien Thierry <julien.thierry@arm.com>
>>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>>> Cc: kvmarm@lists.cs.columbia.edu
>>> ---
>>>
>>> Changes since v9:
>>> * Used high order number for branching in assembly macros. [Kristina Martsenko]
>>> * Taken care of different offset for hcr_el2 now.
>>>
>>>   arch/arm/include/asm/kvm_host.h          |   1 +
>>>   arch/arm64/Kconfig                       |   5 +-
>>>   arch/arm64/include/asm/kvm_host.h        |  17 +++++
>>>   arch/arm64/include/asm/kvm_ptrauth_asm.h | 106 +++++++++++++++++++++++++++++++
>>>   arch/arm64/kernel/asm-offsets.c          |   6 ++
>>>   arch/arm64/kvm/guest.c                   |  14 ++++
>>>   arch/arm64/kvm/handle_exit.c             |  24 ++++---
>>>   arch/arm64/kvm/hyp/entry.S               |   7 ++
>>>   arch/arm64/kvm/sys_regs.c                |  46 +++++++++++++-
>>>   virt/kvm/arm/arm.c                       |   2 +
>>>   10 files changed, 215 insertions(+), 13 deletions(-)
>>>   create mode 100644 arch/arm64/include/asm/kvm_ptrauth_asm.h
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index e80cfc1..7a5c7f8 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -363,6 +363,7 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>>   static inline void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu) {}
>>>   static inline void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu) {}
>>>   static inline void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu) {}
>>> +static inline void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu) {}
>>>   
>>>   static inline void kvm_arm_vhe_guest_enter(void) {}
>>>   static inline void kvm_arm_vhe_guest_exit(void) {}
>>> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
>>> index 7e34b9e..9e8506e 100644
>>> --- a/arch/arm64/Kconfig
>>> +++ b/arch/arm64/Kconfig
>>> @@ -1301,8 +1301,9 @@ config ARM64_PTR_AUTH
>>>   	  context-switched along with the process.
>>>   
>>>   	  The feature is detected at runtime. If the feature is not present in
>>> -	  hardware it will not be advertised to userspace nor will it be
>>> -	  enabled.
>>> +	  hardware it will not be advertised to userspace/KVM guest nor will it
>>> +	  be enabled. However, KVM guest also require CONFIG_ARM64_VHE=y to use
>>> +	  this feature.
>>
>> Not only does it require CONFIG_ARM64_VHE, but it more importantly
>> requires a VHE system!
> Yes will update.
>>
>>>   
>>>   endmenu
>>>   
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 31dbc7c..a585d82 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -161,6 +161,18 @@ enum vcpu_sysreg {
>>>   	PMSWINC_EL0,	/* Software Increment Register */
>>>   	PMUSERENR_EL0,	/* User Enable Register */
>>>   
>>> +	/* Pointer Authentication Registers in a strict increasing order. */
>>> +	APIAKEYLO_EL1,
>>> +	APIAKEYHI_EL1 = APIAKEYLO_EL1 + 1,
>>> +	APIBKEYLO_EL1 = APIAKEYLO_EL1 + 2,
>>> +	APIBKEYHI_EL1 = APIAKEYLO_EL1 + 3,
>>> +	APDAKEYLO_EL1 = APIAKEYLO_EL1 + 4,
>>> +	APDAKEYHI_EL1 = APIAKEYLO_EL1 + 5,
>>> +	APDBKEYLO_EL1 = APIAKEYLO_EL1 + 6,
>>> +	APDBKEYHI_EL1 = APIAKEYLO_EL1 + 7,
>>> +	APGAKEYLO_EL1 = APIAKEYLO_EL1 + 8,
>>> +	APGAKEYHI_EL1 = APIAKEYLO_EL1 + 9,
>>
>> Why do we need these explicit +1, +2...? Being an part of an enum
>> already guarantees this.
> Yes enums are increasing. But upcoming struct/enums randomization stuffs 
> may break the ptrauth register offset calculation logic in the later 
> part so explicitly made this to increasing order.

Enum randomization? well, the whole of KVM would break spectacularly,
not to mention most of the kernel.

So no, this isn't a concern, please drop this.

> 
> 
>>
>>> +
>>>   	/* 32bit specific registers. Keep them at the end of the range */
>>>   	DACR32_EL2,	/* Domain Access Control Register */
>>>   	IFSR32_EL2,	/* Instruction Fault Status Register */
>>> @@ -529,6 +541,11 @@ static inline bool kvm_arch_requires_vhe(void)
>>>   	return false;
>>>   }
>>>   
>>> +void kvm_arm_vcpu_ptrauth_enable(struct kvm_vcpu *vcpu);
>>> +void kvm_arm_vcpu_ptrauth_disable(struct kvm_vcpu *vcpu);
>>> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu);
>>> +void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
>>> +
>>>   static inline void kvm_arch_hardware_unsetup(void) {}
>>>   static inline void kvm_arch_sync_events(struct kvm *kvm) {}
>>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>>> diff --git a/arch/arm64/include/asm/kvm_ptrauth_asm.h b/arch/arm64/include/asm/kvm_ptrauth_asm.h
>>> new file mode 100644
>>> index 0000000..8142521
>>> --- /dev/null
>>> +++ b/arch/arm64/include/asm/kvm_ptrauth_asm.h
>>
>> nit: this should be named kvm_ptrauth.h. The asm suffix doesn't bring
>> anything to the game, and is somewhat misleading (there are C macros in
>> this file).
>>
>>> @@ -0,0 +1,106 @@
>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>> +/* arch/arm64/include/asm/kvm_ptrauth_asm.h: Guest/host ptrauth save/restore
>>> + * Copyright 2019 Arm Limited
>>> + * Author: Mark Rutland <mark.rutland@arm.com>
>>
>> nit: Authors
> ok.
>>
>>> + *         Amit Daniel Kachhap <amit.kachhap@arm.com>
>>> + */
>>> +
>>> +#ifndef __ASM_KVM_PTRAUTH_ASM_H
>>> +#define __ASM_KVM_PTRAUTH_ASM_H
>>> +
>>> +#ifndef __ASSEMBLY__
>>> +
>>> +#define __ptrauth_save_key(regs, key)						\
>>> +({										\
>>> +	regs[key ## KEYLO_EL1] = read_sysreg_s(SYS_ ## key ## KEYLO_EL1);	\
>>> +	regs[key ## KEYHI_EL1] = read_sysreg_s(SYS_ ## key ## KEYHI_EL1);	\
>>> +})
>>> +
>>> +#define __ptrauth_save_state(ctxt)						\
>>> +({										\
>>> +	__ptrauth_save_key(ctxt->sys_regs, APIA);				\
>>> +	__ptrauth_save_key(ctxt->sys_regs, APIB);				\
>>> +	__ptrauth_save_key(ctxt->sys_regs, APDA);				\
>>> +	__ptrauth_save_key(ctxt->sys_regs, APDB);				\
>>> +	__ptrauth_save_key(ctxt->sys_regs, APGA);				\
>>> +})
>>> +
>>> +#else /* __ASSEMBLY__ */
>>> +
>>> +#include <asm/sysreg.h>
>>> +
>>> +#ifdef	CONFIG_ARM64_PTR_AUTH
>>> +
>>> +#define PTRAUTH_REG_OFFSET(x)	(x - CPU_APIAKEYLO_EL1)
>>> +
>>> +/*
>>> + * CPU_AP*_EL1 values exceed immediate offset range (512) for stp instruction
>>> + * so below macros takes CPU_APIAKEYLO_EL1 as base and calculates the offset of
>>> + * the keys from this base to avoid an extra add instruction. These macros
>>> + * assumes the keys offsets are aligned in a specific increasing order.
>>> + */
>>> +.macro	ptrauth_save_state base, reg1, reg2
>>> +	mrs_s	\reg1, SYS_APIAKEYLO_EL1
>>> +	mrs_s	\reg2, SYS_APIAKEYHI_EL1
>>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
>>> +	mrs_s	\reg1, SYS_APIBKEYLO_EL1
>>> +	mrs_s	\reg2, SYS_APIBKEYHI_EL1
>>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
>>> +	mrs_s	\reg1, SYS_APDAKEYLO_EL1
>>> +	mrs_s	\reg2, SYS_APDAKEYHI_EL1
>>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
>>> +	mrs_s	\reg1, SYS_APDBKEYLO_EL1
>>> +	mrs_s	\reg2, SYS_APDBKEYHI_EL1
>>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
>>> +	mrs_s	\reg1, SYS_APGAKEYLO_EL1
>>> +	mrs_s	\reg2, SYS_APGAKEYHI_EL1
>>> +	stp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
>>> +.endm
>>> +
>>> +.macro	ptrauth_restore_state base, reg1, reg2
>>> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIAKEYLO_EL1)]
>>> +	msr_s	SYS_APIAKEYLO_EL1, \reg1
>>> +	msr_s	SYS_APIAKEYHI_EL1, \reg2
>>> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APIBKEYLO_EL1)]
>>> +	msr_s	SYS_APIBKEYLO_EL1, \reg1
>>> +	msr_s	SYS_APIBKEYHI_EL1, \reg2
>>> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDAKEYLO_EL1)]
>>> +	msr_s	SYS_APDAKEYLO_EL1, \reg1
>>> +	msr_s	SYS_APDAKEYHI_EL1, \reg2
>>> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APDBKEYLO_EL1)]
>>> +	msr_s	SYS_APDBKEYLO_EL1, \reg1
>>> +	msr_s	SYS_APDBKEYHI_EL1, \reg2
>>> +	ldp	\reg1, \reg2, [\base, #PTRAUTH_REG_OFFSET(CPU_APGAKEYLO_EL1)]
>>> +	msr_s	SYS_APGAKEYLO_EL1, \reg1
>>> +	msr_s	SYS_APGAKEYHI_EL1, \reg2
>>> +.endm
>>> +
>>> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
>>> +	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
>>
>> Given that 100% of the current HW doesn't have ptrauth at all, this
>> becomes an instant and pointless overhead.
>>
>> It could easily be avoided by turning this into:
>>
>> alternative_if_not ARM64_HAS_GENERIC_AUTH_ARCH
>> 	b	1000f
>> alternative_else
>> 	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
>> alternative_endif
> yes sure. will check.
>>
>>> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
>>> +	cbz	\reg1, 1000f
>>> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>>> +	ptrauth_restore_state	\reg1, \reg2, \reg3
>>> +1000:
>>> +.endm
>>> +
>>> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
>>> +	ldr	\reg1, [\g_ctxt, #(VCPU_HCR_EL2 - VCPU_CONTEXT)]
>>
>> Same thing here.
>>
>>> +	and	\reg1, \reg1, #(HCR_API | HCR_APK)
>>> +	cbz	\reg1, 1001f
>>> +	add	\reg1, \g_ctxt, #CPU_APIAKEYLO_EL1
>>> +	ptrauth_save_state	\reg1, \reg2, \reg3
>>> +	add	\reg1, \h_ctxt, #CPU_APIAKEYLO_EL1
>>> +	ptrauth_restore_state	\reg1, \reg2, \reg3
>>> +	isb
>>> +1001:
>>> +.endm
>>> +
>>> +#else /* !CONFIG_ARM64_PTR_AUTH */
>>> +.macro ptrauth_switch_to_guest g_ctxt, reg1, reg2, reg3
>>> +.endm
>>> +.macro ptrauth_switch_to_host g_ctxt, h_ctxt, reg1, reg2, reg3
>>> +.endm
>>> +#endif /* CONFIG_ARM64_PTR_AUTH */
>>> +#endif /* __ASSEMBLY__ */
>>> +#endif /* __ASM_KVM_PTRAUTH_ASM_H */
>>> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
>>> index 7f40dcb..8178330 100644
>>> --- a/arch/arm64/kernel/asm-offsets.c
>>> +++ b/arch/arm64/kernel/asm-offsets.c
>>> @@ -125,7 +125,13 @@ int main(void)
>>>     DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
>>>     DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
>>>     DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
>>> +  DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>>>     DEFINE(CPU_GP_REGS,		offsetof(struct kvm_cpu_context, gp_regs));
>>> +  DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
>>> +  DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
>>> +  DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
>>> +  DEFINE(CPU_APDBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDBKEYLO_EL1]));
>>> +  DEFINE(CPU_APGAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APGAKEYLO_EL1]));
>>>     DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_regs, regs));
>>>     DEFINE(HOST_CONTEXT_VCPU,	offsetof(struct kvm_cpu_context, __hyp_running_vcpu));
>>>   #endif
>>> diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
>>> index 4f7b26b..e07f763 100644
>>> --- a/arch/arm64/kvm/guest.c
>>> +++ b/arch/arm64/kvm/guest.c
>>> @@ -878,3 +878,17 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
>>>   
>>>   	return ret;
>>>   }
>>> +
>>> +/**
>>> + * kvm_arm_vcpu_ptrauth_setup_lazy - setup lazy ptrauth for vcpu schedule
>>> + *
>>> + * @vcpu: The VCPU pointer
>>> + *
>>> + * This function may be used to disable ptrauth and use it in a lazy context
>>> + * via traps.
>>> + */
>>> +void kvm_arm_vcpu_ptrauth_setup_lazy(struct kvm_vcpu *vcpu)
>>> +{
>>> +	if (vcpu_has_ptrauth(vcpu))
>>> +		kvm_arm_vcpu_ptrauth_disable(vcpu);
>>> +}
>>
>> Why does this live in guest.c?
> Many global functions used in virt/kvm/arm/arm.c are implemented here.

None that are used on vcpu_load().

> 
> However some similar kinds of function are in asm/kvm_emulate.h so can 
> be moved there as static inline.

Exactly.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
