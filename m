Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 936CDC282DD
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 04:39:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 30E7720880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 04:39:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 30E7720880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A66F64A479;
	Mon,  8 Apr 2019 00:39:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Veke7n5+7cc2; Mon,  8 Apr 2019 00:39:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DD184A47E;
	Mon,  8 Apr 2019 00:39:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DDEA4A479
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 00:39:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jtcndWUxiey0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 00:39:11 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65DC04A3BB
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 00:39:11 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D0A9A15BF;
 Sun,  7 Apr 2019 21:39:10 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D459E3F718;
 Sun,  7 Apr 2019 21:39:07 -0700 (PDT)
Subject: Re: [PATCH v8 5/9] KVM: arm/arm64: preserve host MDCR_EL2 value
To: Dave Martin <Dave.Martin@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-6-git-send-email-amit.kachhap@arm.com>
 <20190405110237.GS3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <98786a02-8faf-4858-92c2-01eb5580ab3d@arm.com>
Date: Mon, 8 Apr 2019 10:09:05 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190405110237.GS3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190408043905.s8hcJpf6RpPvuQuedoY5jQE_TpIqXd-NkG7w3IxYQeM@z>

Hi,

On 4/5/19 4:32 PM, Dave Martin wrote:
> On Tue, Apr 02, 2019 at 07:57:13AM +0530, Amit Daniel Kachhap wrote:
>> Save host MDCR_EL2 value during kvm HYP initialisation and restore
>> after every switch from host to guest. There should not be any
>> change in functionality due to this.
>>
>> The value of mdcr_el2 is now stored in struct kvm_cpu_context as
>> both host and guest can now use this field in a common way.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Acked-by: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v7:
>> * Removed unused function __kvm_get_mdcr_el2 [Kristina].
>>
>>   arch/arm/include/asm/kvm_host.h   |  1 -
>>   arch/arm64/include/asm/kvm_asm.h  |  2 --
>>   arch/arm64/include/asm/kvm_host.h |  6 ++----
>>   arch/arm64/include/asm/kvm_hyp.h  |  2 +-
>>   arch/arm64/kvm/debug.c            | 28 ++++++----------------------
>>   arch/arm64/kvm/hyp/debug-sr.c     |  5 -----
>>   arch/arm64/kvm/hyp/switch.c       | 18 +++++-------------
>>   arch/arm64/kvm/hyp/sysreg-sr.c    |  8 +++++++-
>>   virt/kvm/arm/arm.c                |  1 -
>>   9 files changed, 21 insertions(+), 50 deletions(-)
>>
>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>> index 6d0aac4..a928565 100644
>> --- a/arch/arm/include/asm/kvm_host.h
>> +++ b/arch/arm/include/asm/kvm_host.h
>> @@ -343,7 +343,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>>   static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>>   
>> -static inline void kvm_arm_init_debug(void) {}
>>   static inline void kvm_arm_setup_debug(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arm_clear_debug(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu) {}
>> diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
>> index a68205c..a15ba55 100644
>> --- a/arch/arm64/include/asm/kvm_asm.h
>> +++ b/arch/arm64/include/asm/kvm_asm.h
>> @@ -78,8 +78,6 @@ extern u64 __vgic_v3_read_vmcr(void);
>>   extern void __vgic_v3_write_vmcr(u32 vmcr);
>>   extern void __vgic_v3_init_lrs(void);
>>   
>> -extern u32 __kvm_get_mdcr_el2(void);
>> -
>>   extern void __kvm_populate_host_regs(void);
>>   
>>   /*
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 3b09fd0..e3ccd7b 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -211,6 +211,8 @@ struct kvm_cpu_context {
>>   
>>   	/* HYP host/guest configuration */
>>   	u64 hcr_el2;
>> +	u32 mdcr_el2;
>> +
>>   	struct kvm_vcpu *__hyp_running_vcpu;
>>   };
>>   
>> @@ -226,9 +228,6 @@ struct vcpu_reset_state {
>>   struct kvm_vcpu_arch {
>>   	struct kvm_cpu_context ctxt;
>>   
>> -	/* HYP configuration */
>> -	u32 mdcr_el2;
>> -
>>   	/* Exception Information */
>>   	struct kvm_vcpu_fault_info fault;
>>   
>> @@ -498,7 +497,6 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
>>   static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>>   static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
>>   
>> -void kvm_arm_init_debug(void);
>>   void kvm_arm_setup_debug(struct kvm_vcpu *vcpu);
>>   void kvm_arm_clear_debug(struct kvm_vcpu *vcpu);
>>   void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu);
>> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
>> index 4da765f..7fcde8a 100644
>> --- a/arch/arm64/include/asm/kvm_hyp.h
>> +++ b/arch/arm64/include/asm/kvm_hyp.h
>> @@ -152,7 +152,7 @@ void __fpsimd_restore_state(struct user_fpsimd_state *fp_regs);
>>   bool __fpsimd_enabled(void);
>>   
>>   void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
>> -void deactivate_traps_vhe_put(void);
>> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
>>   
>>   u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
>>   void __noreturn __hyp_do_panic(unsigned long, ...);
>> diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
>> index fd917d6..99dc0a4 100644
>> --- a/arch/arm64/kvm/debug.c
>> +++ b/arch/arm64/kvm/debug.c
>> @@ -32,8 +32,6 @@
>>   				DBG_MDSCR_KDE | \
>>   				DBG_MDSCR_MDE)
>>   
>> -static DEFINE_PER_CPU(u32, mdcr_el2);
>> -
>>   /**
>>    * save/restore_guest_debug_regs
>>    *
>> @@ -65,21 +63,6 @@ static void restore_guest_debug_regs(struct kvm_vcpu *vcpu)
>>   }
>>   
>>   /**
>> - * kvm_arm_init_debug - grab what we need for debug
>> - *
>> - * Currently the sole task of this function is to retrieve the initial
>> - * value of mdcr_el2 so we can preserve MDCR_EL2.HPMN which has
>> - * presumably been set-up by some knowledgeable bootcode.
>> - *
>> - * It is called once per-cpu during CPU hyp initialisation.
>> - */
>> -
>> -void kvm_arm_init_debug(void)
>> -{
>> -	__this_cpu_write(mdcr_el2, kvm_call_hyp_ret(__kvm_get_mdcr_el2));
>> -}
>> -
>> -/**
>>    * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
>>    */
>>   
>> @@ -111,6 +94,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
>>   
>>   void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>   {
>> +	kvm_cpu_context_t *host_cxt = this_cpu_ptr(&kvm_host_cpu_state);
>>   	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
>>   	unsigned long mdscr;
>>   
>> @@ -120,8 +104,8 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>   	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
>>   	 * to the profiling buffer.
>>   	 */
>> -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
>> -	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>> +	vcpu->arch.ctxt.mdcr_el2 = host_cxt->mdcr_el2 & MDCR_EL2_HPMN_MASK;
>> +	vcpu->arch.ctxt.mdcr_el2 |= (MDCR_EL2_TPM |
>>   				MDCR_EL2_TPMS |
>>   				MDCR_EL2_TPMCR |
>>   				MDCR_EL2_TDRA |
>> @@ -130,7 +114,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>   	/* Is Guest debugging in effect? */
>>   	if (vcpu->guest_debug) {
>>   		/* Route all software debug exceptions to EL2 */
>> -		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
>> +		vcpu->arch.ctxt.mdcr_el2 |= MDCR_EL2_TDE;
>>   
>>   		/* Save guest debug state */
>>   		save_guest_debug_regs(vcpu);
>> @@ -202,13 +186,13 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>   
>>   	/* Trap debug register access */
>>   	if (trap_debug)
>> -		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
>> +		vcpu->arch.ctxt.mdcr_el2 |= MDCR_EL2_TDA;
>>   
>>   	/* If KDE or MDE are set, perform a full save/restore cycle. */
>>   	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
>>   		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
>>   
>> -	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
>> +	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.ctxt.mdcr_el2);
>>   	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
>>   }
>>   
>> diff --git a/arch/arm64/kvm/hyp/debug-sr.c b/arch/arm64/kvm/hyp/debug-sr.c
>> index 5000976..f49a3f7 100644
>> --- a/arch/arm64/kvm/hyp/debug-sr.c
>> +++ b/arch/arm64/kvm/hyp/debug-sr.c
>> @@ -198,8 +198,3 @@ void __hyp_text __debug_switch_to_host(struct kvm_vcpu *vcpu)
>>   
>>   	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
>>   }
>> -
>> -u32 __hyp_text __kvm_get_mdcr_el2(void)
>> -{
>> -	return read_sysreg(mdcr_el2);
>> -}
>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>> index f5cefa1..fe76e24 100644
>> --- a/arch/arm64/kvm/hyp/switch.c
>> +++ b/arch/arm64/kvm/hyp/switch.c
>> @@ -84,7 +84,7 @@ static void __hyp_text __activate_traps_common(struct kvm_vcpu *vcpu)
>>   	 */
>>   	write_sysreg(0, pmselr_el0);
>>   	write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
>> -	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
>> +	write_sysreg(vcpu->arch.ctxt.mdcr_el2, mdcr_el2);
>>   }
>>   
>>   static void __hyp_text __deactivate_traps_common(void)
>> @@ -161,15 +161,11 @@ NOKPROBE_SYMBOL(deactivate_traps_vhe);
>>   
>>   static void __hyp_text __deactivate_traps_nvhe(struct kvm_cpu_context *host_ctxt)
>>   {
>> -	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>>   	struct kvm_cpu_context *hyp_host_ctxt = kern_hyp_va(host_ctxt);
>>   
>>   	__deactivate_traps_common();
>>   
>> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
>> -	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
>> -
>> -	write_sysreg(mdcr_el2, mdcr_el2);
>> +	write_sysreg(hyp_host_ctxt->mdcr_el2, mdcr_el2);
>>   	write_sysreg(hyp_host_ctxt->hcr_el2, hcr_el2);
>>   	write_sysreg(CPTR_EL2_DEFAULT, cptr_el2);
>>   }
>> @@ -199,15 +195,11 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
>>   	__activate_traps_common(vcpu);
>>   }
>>   
>> -void deactivate_traps_vhe_put(void)
>> +void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
>>   {
>> -	u64 mdcr_el2 = read_sysreg(mdcr_el2);
>> -
>> -	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
>> -		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
>> -		    MDCR_EL2_TPMS;
>> +	struct kvm_cpu_context *host_ctxt = vcpu->arch.host_cpu_context;
>>   
>> -	write_sysreg(mdcr_el2, mdcr_el2);
>> +	write_sysreg(host_ctxt->mdcr_el2, mdcr_el2);
>>   
>>   	__deactivate_traps_common();
>>   }
>> diff --git a/arch/arm64/kvm/hyp/sysreg-sr.c b/arch/arm64/kvm/hyp/sysreg-sr.c
>> index 277f82b..6afd309 100644
>> --- a/arch/arm64/kvm/hyp/sysreg-sr.c
>> +++ b/arch/arm64/kvm/hyp/sysreg-sr.c
>> @@ -298,7 +298,7 @@ void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu)
>>   	if (!has_vhe())
>>   		return;
>>   
>> -	deactivate_traps_vhe_put();
>> +	deactivate_traps_vhe_put(vcpu);
>>   
>>   	__sysreg_save_el1_state(guest_ctxt);
>>   	__sysreg_save_user_state(guest_ctxt);
>> @@ -333,4 +333,10 @@ void __hyp_text __kvm_populate_host_regs(void)
>>   
>>   	host_ctxt = __hyp_this_cpu_ptr(kvm_host_cpu_state);
>>   	host_ctxt->hcr_el2 = read_sysreg(hcr_el2);
>> +	/*
>> +	 * Retrieve the initial value of mdcr_el2 so we can preserve
>> +	 * MDCR_EL2.HPMN which has presumably been set-up by some
>> +	 * knowledgeable bootcode.
>> +	 */
>> +	host_ctxt->mdcr_el2 = read_sysreg(mdcr_el2);
>>   }
>> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
>> index e8c2ee6..58de0ca 100644
>> --- a/virt/kvm/arm/arm.c
>> +++ b/virt/kvm/arm/arm.c
>> @@ -1322,7 +1322,6 @@ static void cpu_hyp_reinit(void)
>>   	else
>>   		cpu_init_hyp_mode(NULL);
>>   
>> -	kvm_arm_init_debug();
>>   	cpu_init_host_ctxt();
>>   
>>   	if (vgic_present)
> 
> Looks reasonable overall.
> 
> I was wondering whether it would make sense to move some masking into
> __kvm_populate_host_regs(), but probably not.
> 
> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
Thanks for the review.

Thanks,
Amit D.
> 
> Cheers
> ---Dave
> 
> 
>> -- 
>> 2.7.4
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
