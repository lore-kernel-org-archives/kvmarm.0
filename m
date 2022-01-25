Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25941C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 18:19:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8276749AF9;
	Tue, 25 Jan 2022 13:19:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wvh8XbilHIoB; Tue, 25 Jan 2022 13:19:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B91D49ED1;
	Tue, 25 Jan 2022 13:19:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7AB49AF9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:19:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gzg3cBb60LWZ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 13:19:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 004E949ED9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 13:19:51 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 27C631FB;
 Tue, 25 Jan 2022 10:19:51 -0800 (PST)
Received: from [10.1.196.218] (eglon.cambridge.arm.com [10.1.196.218])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18C6E3F7D8;
 Tue, 25 Jan 2022 10:19:49 -0800 (PST)
Subject: Re: [PATCH 4/4] KVM: arm64: Workaround Cortex-A510's single-step and
 PAC trap errata
To: Marc Zyngier <maz@kernel.org>
References: <20220125153803.549084-1-james.morse@arm.com>
 <20220125153803.549084-5-james.morse@arm.com> <87mtjj7o7y.wl-maz@kernel.org>
From: James Morse <james.morse@arm.com>
Message-ID: <711e16a1-c853-10e8-43d5-31890f0d4c7c@arm.com>
Date: Tue, 25 Jan 2022 18:19:45 +0000
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <87mtjj7o7y.wl-maz@kernel.org>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On 25/01/2022 16:51, Marc Zyngier wrote:
> On Tue, 25 Jan 2022 15:38:03 +0000,
> James Morse <james.morse@arm.com> wrote:
>>
>> Cortex-A510's erratum #2077057 causes SPSR_EL2 to be corrupted when
>> single-stepping authenticated ERET instructions. A single step is
>> expected, but a pointer authentication trap is taken instead. The
>> erratum causes SPSR_EL1 to be copied to SPSR_EL2, which could allow
>> EL1 to cause a return to EL2 with a guest controlled ELR_EL2.
>>
>> Because the conditions require an ERET into active-not-pending state,
>> this is only a problem for the EL2 when EL2 is stepping EL1. In this case
>> the previous SPSR_EL2 value is preserved in struct kvm_vcpu, and can be
>> restored.

> Urgh. That's pretty nasty :-(.

>> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> index 331dd10821df..93bf140cc972 100644
>> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
>> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
>> @@ -440,6 +442,22 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>>  			write_sysreg_el2(read_sysreg_el2(SYS_ELR) - 4, SYS_ELR);
>>  	}
>>  
>> +	/*
>> +	 * Check for the conditions of Cortex-A510's #2077057. When these occur
>> +	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
>> +	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
>> +	 * Did we just take a PAC exception when a step exception was expected?
>> +	 */
>> +	if (IS_ENABLED(CONFIG_ARM64_ERRATUM_2077057) &&
> 
> nit: we can drop this IS_ENABLED()...

Hmmm, I thought dead code elimination was a good thing!
Without the cpu_errata.c match, (which is also guarded by #ifdef), the cap will never be
true, even if an affected CPU showed up. This way the compiler knows it can remove all this.


>> +	    cpus_have_const_cap(ARM64_WORKAROUND_2077057) &&
> 
> and make this a final cap. Being a ARM64_CPUCAP_LOCAL_CPU_ERRATUM, we
> won't accept late CPUs on a system that wasn't affected until then.
> 
>> +	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ &&
>> +	    esr_ec == ESR_ELx_EC_PAC &&
>> +	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP) {
>> +		/* Active-not-pending? */
>> +		if (*vcpu_cpsr(vcpu) & DBG_SPSR_SS)
>> +			write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> 
> Err... Isn't this way too late? The function starts with:
> 
> 	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
> 
> which is just another way to write:
> 
> 	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> 
> By that time, the vcpu's PSTATE is terminally corrupted.

Yes -  bother. Staring at it didn't let me spot that!
I can hit the conditions to test this, but due to lack of imagination the model doesn't
corrupt the SPSR.


> I think you need to hoist this workaround way up, before we call into
> early_exit_filter() as it will assume that the guest pstate is correct
> (this is used by both pKVM and the NV code).
> 
> Something like this (untested):
> 
> diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
> index 93bf140cc972..a8a1502db237 100644
> --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> @@ -402,6 +402,26 @@ static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	return false;
>  }
>  
> +static inline void synchronize_vcpu_pstate(struct kvm_vcpu *vcpu,
> +					   u64 *exit_code)
> +{
> +	/*
> +	 * Check for the conditions of Cortex-A510's #2077057. When these occur
> +	 * SPSR_EL2 can't be trusted, but isn't needed either as it is
> +	 * unchanged from the value in vcpu_gp_regs(vcpu)->pstate.
> +	 * Did we just take a PAC exception when a step exception (being in the
> +	 * Active-not-pending state) was expected?
> +	 */
> +	if (cpus_have_final_cap(ARM64_WORKAROUND_2077057)	&&
> +	    ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ	&&

> +	    kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_PAC	&&

The vcpu's esr_el2 isn't yet set:
| ESR_ELx_EC(read_sysreg_el2(SYS_ESR)) == ESR_ELx_EC_PAC

(and I'll shuffle the order so this is last as its an extra sysreg read)


> +	    vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP		&&
> +	    *vcpu_cpsr(vcpu) & DBG_SPSR_SS)
> +		write_sysreg_el2(*vcpu_cpsr(vcpu), SYS_SPSR);
> +
> +	*vcpu_cpsr(vcpu) = read_sysreg_el2(SYS_SPSR);
> +}
> +
>  /*
>   * Return true when we were able to fixup the guest exit and should return to
>   * the guest, false when we should restore the host state and return to the
> @@ -415,7 +435,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
>  	 * Save PSTATE early so that we can evaluate the vcpu mode
>  	 * early on.
>  	 */
> -	vcpu->arch.ctxt.regs.pstate = read_sysreg_el2(SYS_SPSR);
> +	synchronize_vcpu_pstate(vcpu, exit_code);

Even better, that saves the noise from moving esr_ec around!


> Other than that, I'm happy to take the series as a whole ASAP, if only
> for the two pretty embarrassing bug fixes. If you can respin it
> shortly and address the comments above, I'd like it into -rc2.

Will do. Shout if you strongly care about the IS_ENABLED().


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
