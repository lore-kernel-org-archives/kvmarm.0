Return-Path: <SRS0=odEw=I6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4435C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 13:55:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CFF0C6127A
	for <kvmarm@archiver.kernel.org>; Thu,  1 Apr 2021 13:55:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CFF0C6127A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 695CD4B692;
	Thu,  1 Apr 2021 09:55:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XRHBk4uIT18g; Thu,  1 Apr 2021 09:55:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 115CA4B695;
	Thu,  1 Apr 2021 09:55:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 192914B67C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:55:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rqE69RLKeDjO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Apr 2021 09:55:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACF094B67B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Apr 2021 09:55:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2B2EE31B;
 Thu,  1 Apr 2021 06:55:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9E3D23F719;
 Thu,  1 Apr 2021 06:55:24 -0700 (PDT)
Subject: Re: [PATCH v2] KVM: arm64: Initialize VCPU mdcr_el2 before loading it
To: Marc Zyngier <maz@kernel.org>
References: <20210323180057.263356-1-alexandru.elisei@arm.com>
 <87sg4dq83r.wl-maz@kernel.org> <5cfd4870-db31-cd7d-699f-bd70a1ab90fe@arm.com>
 <5c90a3b2-c9a8-640b-fb6a-7a09d397ba7f@arm.com> <87lfa4fm8u.wl-maz@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <d3f6cd69-42c8-0199-c7cd-56e1789ac141@arm.com>
Date: Thu, 1 Apr 2021 14:55:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <87lfa4fm8u.wl-maz@kernel.org>
Content-Language: en-US
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On 3/30/21 8:57 PM, Marc Zyngier wrote:
> On Tue, 30 Mar 2021 18:49:54 +0100,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>> Hi Marc,
>>
>> On 3/30/21 6:13 PM, Alexandru Elisei wrote:
>>> [..]
>>>>> +}
>>>>> +
>>>>>  /**
>>>>>   * kvm_arm_reset_debug_ptr - reset the debug ptr to point to the vcpu state
>>>>>   */
>>>>> @@ -83,12 +137,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
>>>>>   * @vcpu:	the vcpu pointer
>>>>>   *
>>>>>   * This is called before each entry into the hypervisor to setup any
>>>>> - * debug related registers. Currently this just ensures we will trap
>>>>> - * access to:
>>>>> - *  - Performance monitors (MDCR_EL2_TPM/MDCR_EL2_TPMCR)
>>>>> - *  - Debug ROM Address (MDCR_EL2_TDRA)
>>>>> - *  - OS related registers (MDCR_EL2_TDOSA)
>>>>> - *  - Statistical profiler (MDCR_EL2_TPMS/MDCR_EL2_E2PB)
>>>>> + * debug related registers.
>>>>>   *
>>>>>   * Additionally, KVM only traps guest accesses to the debug registers if
>>>>>   * the guest is not actively using them (see the KVM_ARM64_DEBUG_DIRTY
>>>>> @@ -100,27 +149,14 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
>>>>>  
>>>>>  void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>>>>  {
>>>>> -	bool trap_debug = !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY);
>>>>>  	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
>>>>>  
>>>>>  	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
>>>>>  
>>>>> -	/*
>>>>> -	 * This also clears MDCR_EL2_E2PB_MASK to disable guest access
>>>>> -	 * to the profiling buffer.
>>>>> -	 */
>>>>> -	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
>>>>> -	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
>>>>> -				MDCR_EL2_TPMS |
>>>>> -				MDCR_EL2_TPMCR |
>>>>> -				MDCR_EL2_TDRA |
>>>>> -				MDCR_EL2_TDOSA);
>>>>> +	kvm_arm_setup_mdcr_el2(vcpu, __this_cpu_read(mdcr_el2));
>>>>>  
>>>>>  	/* Is Guest debugging in effect? */
>>>>>  	if (vcpu->guest_debug) {
>>>>> -		/* Route all software debug exceptions to EL2 */
>>>>> -		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
>>>>> -
>>>>>  		/* Save guest debug state */
>>>>>  		save_guest_debug_regs(vcpu);
>>>>>  
>>>>> @@ -174,7 +210,6 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
>>>>>  
>>>>>  			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
>>>>>  			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
>>>>> -			trap_debug = true;
>>>> There is something that slightly worries me here: there is now a
>>>> disconnect between flagging debug as dirty and setting the
>>>> trapping. And actually, you now check for KVM_ARM64_DEBUG_DIRTY and
>>>> set the trap bits *before* setting the dirty bit itself.
>>>>
>>>> Here, I believe you end up with guest/host confusion of breakpoints,
>>>> which isn't great. Or did I miss something?
>>> I'm sorry, but I don't understand what you mean. This is my understanding of what
>>> is happening.
>>>
>>> Without this patch, trap_debug is set to true and the KVM_ARM64_DEBUG_DIRTY flag
>>> is set if vcpu->guest_debug & KVM_GUESTDBG_USE_HW. Further down, trap debug is
>>> only used when computing mdcr_el2.
>>>
>>> With this patch, trap_debug is set to true if vcpu->guest_debug &
>>> KVM_GUESTDBG_USE_HW and it's also used for computing mdcr_el2, but this happens in
>>> kvm_arm_setup_mdcr_el2(), which is called at the start of kvm_arm_setup_debug().
>>> The KVM_ARM_DEBUG_DIRTY flags is still set in kvm_arm_setup_debug() if
>>> vcpu->guest_debug & KVM_GUESTDBG_USE_HW, like before.
>>>
>>> The guest never runs with the value computed in kvm_vcpu_first_run_init() unless
>>> it's identical with the value recomputed in kvm_arm_setup_debug().
>>>
>>> The only difference I see is that mdcr_el2 is computed at the start of
>>> kvm_arm_setup_debug(). I get the feeling I'm also missing something.
>> I think I understand what you mean, you are worried that we won't
>> set the bit in mdcr_el2 to trap debug in the same place where we set
>> the debug dirty flag.
> Yes, that's what I mean. The code is conceptually as such ATM:
>
> 	debug_trap = (something based on vcpu->flags);
> 	if (something else) {
> 		check stuff;
> 		vcpu->flags |= stuff;
> 		debug_trap = true;
> 	}
>
> 	if (debug_trap)
> 		set trap conditions;
>
> You are turning this into:
>
> 	debug_trap = (something based on vcpu->flags);
> 	if (debug_trap) {
> 		set trap conditions;
> 	}
> 	if (something else) {
> 		check stuff;
> 		vcpu->flags |= stuff;
> 	}
>
> which isn't the same thing. In your case, it probably works because of
> KVM_GUESTDBG_USE_HW, but that's really hard to follow, and we have had
> so many bugs in the debug code that it really needs to be kept as
> stupid as possible.
>
>> If that's the case, then I can move kvm_arm_setup_mdcr_el2 right
>> after the BUG_ON() and remove the KVM_GUESTDBG_USE_HW check because
>> the KVM_ARM_DEBUG_DIRTY would be already set.
> Yes, I think that'd be better.
>
Had another go at this, and as I was looking at the code, I realized that
conceptually, trapping debug registers access (MDCR_EL2.TDA) is tied to:

- KVM_ARM64_DEBUG_DIRTY *not* being set (guest is debugging itself and KVM will
world-switch the debug registers).

- KVM_GUESTDBG_USE_HW being set, which also *sets* KVM_ARM64_DEBUG_DIRTY (host is
debugging the guest using hardware breakpoints).

So I cannot set the MDCR_EL2.TDA bit based on KVM_ARM64_DEBUG_DIRTY, because I
would lose one of the two cases. It looks to me that keeping
kvm_arm_setup_mdcr_el2() unchanged and calling it at the start of
kvm_arm_setup_debug() is the way to go here.

Thanks,

Alex

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
