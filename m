Return-Path: <SRS0=DM5G=KP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326E6C433ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 15:22:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A827C611ED
	for <kvmarm@archiver.kernel.org>; Thu, 20 May 2021 15:22:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A827C611ED
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0201A4B3F1;
	Thu, 20 May 2021 11:22:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fCJe6y+lxVow; Thu, 20 May 2021 11:22:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B3E84B418;
	Thu, 20 May 2021 11:22:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FE714B3F1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 11:22:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lFvmbh47HO36 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 20 May 2021 11:22:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D26614B3D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 20 May 2021 11:22:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51A4F101E;
 Thu, 20 May 2021 08:22:05 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 872653F73B;
 Thu, 20 May 2021 08:22:02 -0700 (PDT)
Subject: Re: [PATCH v12 5/8] arm64: kvm: Save/restore MTE registers
To: Marc Zyngier <maz@kernel.org>
References: <20210517123239.8025-1-steven.price@arm.com>
 <20210517123239.8025-6-steven.price@arm.com> <87v97hth3i.wl-maz@kernel.org>
 <097f5f5e-b287-3c9e-1f11-e0212601ddd2@arm.com> <874kexvitk.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <06bf0309-6b48-de35-c200-f624f130d940@arm.com>
Date: Thu, 20 May 2021 16:21:57 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <874kexvitk.wl-maz@kernel.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
 kvmarm@lists.cs.columbia.edu
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 20/05/2021 10:46, Marc Zyngier wrote:
> On Wed, 19 May 2021 14:04:20 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> On 17/05/2021 18:17, Marc Zyngier wrote:
>>> On Mon, 17 May 2021 13:32:36 +0100,
>>> Steven Price <steven.price@arm.com> wrote:
>>>>
>>>> Define the new system registers that MTE introduces and context switch
>>>> them. The MTE feature is still hidden from the ID register as it isn't
>>>> supported in a VM yet.
>>>>
>>>> Signed-off-by: Steven Price <steven.price@arm.com>
>>>> ---
>>>>  arch/arm64/include/asm/kvm_host.h          |  6 ++
>>>>  arch/arm64/include/asm/kvm_mte.h           | 66 ++++++++++++++++++++++
>>>>  arch/arm64/include/asm/sysreg.h            |  3 +-
>>>>  arch/arm64/kernel/asm-offsets.c            |  3 +
>>>>  arch/arm64/kvm/hyp/entry.S                 |  7 +++
>>>>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 21 +++++++
>>>>  arch/arm64/kvm/sys_regs.c                  | 22 ++++++--
>>>>  7 files changed, 123 insertions(+), 5 deletions(-)
>>>>  create mode 100644 arch/arm64/include/asm/kvm_mte.h
>>>>
>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>> index afaa5333f0e4..309e36cc1b42 100644
>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>> @@ -208,6 +208,12 @@ enum vcpu_sysreg {
>>>>  	CNTP_CVAL_EL0,
>>>>  	CNTP_CTL_EL0,
>>>>  
>>>> +	/* Memory Tagging Extension registers */
>>>> +	RGSR_EL1,	/* Random Allocation Tag Seed Register */
>>>> +	GCR_EL1,	/* Tag Control Register */
>>>> +	TFSR_EL1,	/* Tag Fault Status Register (EL1) */
>>>> +	TFSRE0_EL1,	/* Tag Fault Status Register (EL0) */
>>>> +
>>>>  	/* 32bit specific registers. Keep them at the end of the range */
>>>>  	DACR32_EL2,	/* Domain Access Control Register */
>>>>  	IFSR32_EL2,	/* Instruction Fault Status Register */
>>>> diff --git a/arch/arm64/include/asm/kvm_mte.h b/arch/arm64/include/asm/kvm_mte.h
>>>> new file mode 100644
>>>> index 000000000000..6541c7d6ce06
>>>> --- /dev/null
>>>> +++ b/arch/arm64/include/asm/kvm_mte.h
>>>> @@ -0,0 +1,66 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 */
>>>> +/*
>>>> + * Copyright (C) 2020 ARM Ltd.
>>>> + */
>>>> +#ifndef __ASM_KVM_MTE_H
>>>> +#define __ASM_KVM_MTE_H
>>>> +
>>>> +#ifdef __ASSEMBLY__
>>>> +
>>>> +#include <asm/sysreg.h>
>>>> +
>>>> +#ifdef CONFIG_ARM64_MTE
>>>> +
>>>> +.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
>>>> +alternative_if_not ARM64_MTE
>>>> +	b	.L__skip_switch\@
>>>> +alternative_else_nop_endif
>>>> +	mrs	\reg1, hcr_el2
>>>> +	and	\reg1, \reg1, #(HCR_ATA)
>>>> +	cbz	\reg1, .L__skip_switch\@
>>>> +
>>>> +	mrs_s	\reg1, SYS_RGSR_EL1
>>>> +	str	\reg1, [\h_ctxt, #CPU_RGSR_EL1]
>>>> +	mrs_s	\reg1, SYS_GCR_EL1
>>>> +	str	\reg1, [\h_ctxt, #CPU_GCR_EL1]
>>>> +
>>>> +	ldr	\reg1, [\g_ctxt, #CPU_RGSR_EL1]
>>>> +	msr_s	SYS_RGSR_EL1, \reg1
>>>> +	ldr	\reg1, [\g_ctxt, #CPU_GCR_EL1]
>>>> +	msr_s	SYS_GCR_EL1, \reg1
>>>> +
>>>> +.L__skip_switch\@:
>>>> +.endm
>>>> +
>>>> +.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
>>>> +alternative_if_not ARM64_MTE
>>>> +	b	.L__skip_switch\@
>>>> +alternative_else_nop_endif
>>>> +	mrs	\reg1, hcr_el2
>>>> +	and	\reg1, \reg1, #(HCR_ATA)
>>>> +	cbz	\reg1, .L__skip_switch\@
>>>> +
>>>> +	mrs_s	\reg1, SYS_RGSR_EL1
>>>> +	str	\reg1, [\g_ctxt, #CPU_RGSR_EL1]
>>>> +	mrs_s	\reg1, SYS_GCR_EL1
>>>> +	str	\reg1, [\g_ctxt, #CPU_GCR_EL1]
>>>> +
>>>> +	ldr	\reg1, [\h_ctxt, #CPU_RGSR_EL1]
>>>> +	msr_s	SYS_RGSR_EL1, \reg1
>>>> +	ldr	\reg1, [\h_ctxt, #CPU_GCR_EL1]
>>>> +	msr_s	SYS_GCR_EL1, \reg1
>>>
>>> What is the rational for not having any synchronisation here? It is
>>> quite uncommon to allocate memory at EL2, but VHE can perform all kind
>>> of tricks.
>>
>> I don't follow. This is part of the __guest_exit path and there's an ISB
>> at the end of that - is that not sufficient? I don't see any possibility
>> for allocating memory before that. What am I missing?
> 
> Which ISB?  We have a few in the SError handling code, but that's
> conditioned on not having RAS. With any RAS-enabled CPU, we return to
> C code early, since we don't need any extra synchronisation (see the
> comment about the absence of ISB on this path).

Ah, I clearly didn't read the code (or comment) carefully enough -
indeed with RAS we're potentially skipping the ISB.

> I would really like to ensure that we return to C code in the exact
> state we left it.

Agreed, I'll stick an ISB at the end of mte_switch_to_hyp. Although
there's clearly room for optimisation here as ptrauth_switch_to_hyp has
a similar ISB.

>>
>>>> +
>>>> +.L__skip_switch\@:
>>>> +.endm
>>>> +
>>>> +#else /* CONFIG_ARM64_MTE */
>>>> +
>>>> +.macro mte_switch_to_guest g_ctxt, h_ctxt, reg1
>>>> +.endm
>>>> +
>>>> +.macro mte_switch_to_hyp g_ctxt, h_ctxt, reg1
>>>> +.endm
>>>> +
>>>> +#endif /* CONFIG_ARM64_MTE */
>>>> +#endif /* __ASSEMBLY__ */
>>>> +#endif /* __ASM_KVM_MTE_H */
>>>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>>>> index 65d15700a168..347ccac2341e 100644
>>>> --- a/arch/arm64/include/asm/sysreg.h
>>>> +++ b/arch/arm64/include/asm/sysreg.h
>>>> @@ -651,7 +651,8 @@
>>>>  
>>>>  #define INIT_SCTLR_EL2_MMU_ON						\
>>>>  	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
>>>> -	 SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 | SCTLR_EL2_RES1)
>>>> +	 SCTLR_ELx_IESB | SCTLR_ELx_WXN | ENDIAN_SET_EL2 |		\
>>>> +	 SCTLR_ELx_ITFSB | SCTLR_EL2_RES1)
>>>>  
>>>>  #define INIT_SCTLR_EL2_MMU_OFF \
>>>>  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
>>>> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
>>>> index 0cb34ccb6e73..6b489a8462f0 100644
>>>> --- a/arch/arm64/kernel/asm-offsets.c
>>>> +++ b/arch/arm64/kernel/asm-offsets.c
>>>> @@ -111,6 +111,9 @@ int main(void)
>>>>    DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
>>>>    DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
>>>>    DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
>>>> +  DEFINE(CPU_RGSR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[RGSR_EL1]));
>>>> +  DEFINE(CPU_GCR_EL1,		offsetof(struct kvm_cpu_context, sys_regs[GCR_EL1]));
>>>> +  DEFINE(CPU_TFSRE0_EL1,	offsetof(struct kvm_cpu_context, sys_regs[TFSRE0_EL1]));
>>>
>>> TFSRE0_EL1 is never accessed from assembly code. Leftover from a
>>> previous version?
>>
>> Indeed, I will drop it.
>>
>>>>    DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
>>>>    DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
>>>>    DEFINE(CPU_APDAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APDAKEYLO_EL1]));
>>>> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
>>>> index e831d3dfd50d..435346ea1504 100644
>>>> --- a/arch/arm64/kvm/hyp/entry.S
>>>> +++ b/arch/arm64/kvm/hyp/entry.S
>>>> @@ -13,6 +13,7 @@
>>>>  #include <asm/kvm_arm.h>
>>>>  #include <asm/kvm_asm.h>
>>>>  #include <asm/kvm_mmu.h>
>>>> +#include <asm/kvm_mte.h>
>>>>  #include <asm/kvm_ptrauth.h>
>>>>  
>>>>  	.text
>>>> @@ -51,6 +52,9 @@ alternative_else_nop_endif
>>>>  
>>>>  	add	x29, x0, #VCPU_CONTEXT
>>>>  
>>>> +	// mte_switch_to_guest(g_ctxt, h_ctxt, tmp1)
>>>> +	mte_switch_to_guest x29, x1, x2
>>>> +
>>>>  	// Macro ptrauth_switch_to_guest format:
>>>>  	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
>>>>  	// The below macro to restore guest keys is not implemented in C code
>>>> @@ -142,6 +146,9 @@ SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
>>>>  	// when this feature is enabled for kernel code.
>>>>  	ptrauth_switch_to_hyp x1, x2, x3, x4, x5
>>>>  
>>>> +	// mte_switch_to_hyp(g_ctxt, h_ctxt, reg1)
>>>> +	mte_switch_to_hyp x1, x2, x3
>>>> +
>>>>  	// Restore hyp's sp_el0
>>>>  	restore_sp_el0 x2, x3
>>>>  
>>>> diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
>>>> index cce43bfe158f..de7e14c862e6 100644
>>>> --- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
>>>> +++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
>>>> @@ -14,6 +14,7 @@
>>>>  #include <asm/kvm_asm.h>
>>>>  #include <asm/kvm_emulate.h>
>>>>  #include <asm/kvm_hyp.h>
>>>> +#include <asm/kvm_mmu.h>
>>>>  
>>>>  static inline void __sysreg_save_common_state(struct kvm_cpu_context *ctxt)
>>>>  {
>>>> @@ -26,6 +27,16 @@ static inline void __sysreg_save_user_state(struct kvm_cpu_context *ctxt)
>>>>  	ctxt_sys_reg(ctxt, TPIDRRO_EL0)	= read_sysreg(tpidrro_el0);
>>>>  }
>>>>  
>>>> +static inline bool ctxt_has_mte(struct kvm_cpu_context *ctxt)
>>>> +{
>>>> +	struct kvm_vcpu *vcpu = ctxt->__hyp_running_vcpu;
>>>> +
>>>> +	if (!vcpu)
>>>> +		vcpu = container_of(ctxt, struct kvm_vcpu, arch.ctxt);
>>>> +
>>>> +	return kvm_has_mte(kern_hyp_va(vcpu->kvm));
>>>> +}
>>>> +
>>>>  static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>>>>  {
>>>>  	ctxt_sys_reg(ctxt, CSSELR_EL1)	= read_sysreg(csselr_el1);
>>>> @@ -46,6 +57,11 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
>>>>  	ctxt_sys_reg(ctxt, PAR_EL1)	= read_sysreg_par();
>>>>  	ctxt_sys_reg(ctxt, TPIDR_EL1)	= read_sysreg(tpidr_el1);
>>>>  
>>>> +	if (ctxt_has_mte(ctxt)) {
>>>> +		ctxt_sys_reg(ctxt, TFSR_EL1) = read_sysreg_el1(SYS_TFSR);
>>>> +		ctxt_sys_reg(ctxt, TFSRE0_EL1) = read_sysreg_s(SYS_TFSRE0_EL1);
>>>> +	}
>>>
>>> I remember suggesting that this is slightly heavier than necessary.
>>>
>>> On nVHE, TFSRE0_EL1 could be moved to load/put, as we never run
>>> userspace with a vcpu loaded. The same holds of course for VHE, but we
>>> also can move TFSR_EL1 to load/put, as the host uses TFSR_EL2.
>>>
>>> Do you see any issue with that?
>>
>> The comment[1] I made before was:
> 
> Ah, I totally missed this email (or can't remember reading it, which
> amounts to the same thing). Apologies for that.
> 
>>   For TFSR_EL1 + VHE I believe it is synchronised only on vcpu_load/put -
>>   __sysreg_save_el1_state() is called from kvm_vcpu_load_sysregs_vhe().
>>
>>   TFSRE0_EL1 potentially could be improved. I have to admit I was unsure
>>   if it should be in __sysreg_save_user_state() instead. However AFAICT
>>   that is called at the same time as __sysreg_save_el1_state() and there's
>>   no optimisation for nVHE. And given it's an _EL1 register this seemed
>>   like the logic place.
>>
>>   Am I missing something here? Potentially there are other registers to be
>>   optimised (TPIDRRO_EL0 looks like a possiblity), but IMHO that doesn't
>>   belong in this series.
>>
>> For VHE TFSR_EL1 is already only saved/restored on load/put
>> (__sysreg_save_el1_state() is called from kvm_vcpu_put_sysregs_vhe()).
>>
>> TFSRE0_EL1 could be moved, but I'm not sure where it should live as I
>> mentioned above.
> 
> Yeah, this looks fine, please ignore my rambling.

No problem!

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
