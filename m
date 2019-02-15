From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH v5 3/5] arm64/kvm: context-switch ptrauth register
Date: Fri, 15 Feb 2019 09:30:30 +0530
Message-ID: <7a7f0b78-19b6-3953-fdce-4d173b2d69b9@arm.com>
References: <1548658727-14271-1-git-send-email-amit.kachhap@arm.com>
 <1548658727-14271-4-git-send-email-amit.kachhap@arm.com>
 <d862316b-5b2e-8187-04e0-c0be350c1624@arm.com>
 <9d4b5ac7-9d89-b6a0-cfa2-4eab81ff157a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A367C4A319
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 23:00:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QPgcy6Gu1F2f for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 Feb 2019 23:00:37 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F309640493
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 Feb 2019 23:00:36 -0500 (EST)
In-Reply-To: <9d4b5ac7-9d89-b6a0-cfa2-4eab81ff157a@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Kristina Martsenko <kristina.martsenko@arm.com>, James Morse <james.morse@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Dave Martin <Dave.Martin@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 2/13/19 11:05 PM, Kristina Martsenko wrote:
> On 31/01/2019 16:25, James Morse wrote:
>> Hi Amit,
>>
>> On 28/01/2019 06:58, Amit Daniel Kachhap wrote:
>>> When pointer authentication is supported, a guest may wish to use it.
>>> This patch adds the necessary KVM infrastructure for this to work, with
>>> a semi-lazy context switch of the pointer auth state.
> 
> [...]
> 
>>> +void __no_ptrauth __hyp_text __ptrauth_switch_to_guest(struct kvm_vcpu *vcpu,
>>> +					  struct kvm_cpu_context *host_ctxt,
>>> +					  struct kvm_cpu_context *guest_ctxt)
>>> +{
>>> +	if (!__ptrauth_is_enabled(vcpu))
>>> +		return;
>>> +
>>
>>> +	ptrauth_keys_store((struct ptrauth_keys *) &host_ctxt->sys_regs[APIAKEYLO_EL1]);
>>
>> We can't cast part of an array to a structure like this. What happens if the
>> compiler inserts padding in struct-ptrauth_keys, or the struct randomization
>> thing gets hold of it: https://lwn.net/Articles/722293/
>>
>> If we want to use the helpers that take a struct-ptrauth_keys, we need to keep
>> the keys in a struct-ptrauth_keys. To do this we'd need to provide accessors so
>> that GET_ONE_REG() of APIAKEYLO_EL1 comes from the struct-ptrauth_keys, instead
>> of the sys_reg array.
> 
> If I've understood correctly, the idea is to have a struct ptrauth_keys
> in struct kvm_vcpu_arch, instead of having the keys in the
> kvm_cpu_context->sys_regs array. This is to avoid having similar code in
> __ptrauth_key_install/ptrauth_keys_switch and
> __ptrauth_restore_key/__ptrauth_restore_state, and so that future
> patches (that add pointer auth in the kernel) would only need to update
> one place instead of two.
Yes your observation is correct.
> 
> But it also means we'll have to special case pointer auth in
> kvm_arm_sys_reg_set_reg/kvm_arm_sys_reg_get_reg and kvm_vcpu_arch. Is it
> worth it? I'd prefer to keep the slight code duplication but avoid the
> special casing.
In my local implementation I implemented above by separating ptrauth 
registers from sys registers but if I use the new way suggested by Dave
[1] then those things are not possible as reg ID is used for matching 
entries.

So I will stick to the single sys_reg list for next iteration using [1].

[1]: 
https://lore.kernel.org/linux-arm-kernel/1547757219-19439-11-git-send-email-Dave.Martin@arm.com/
> 
>>
>>
>> Wouldn't the host keys be available somewhere else? (they must get transfer to
>> secondary CPUs somehow). Can we skip the save step when switching from the host?
>>
>>
>>> +	ptrauth_keys_switch((struct ptrauth_keys *) &guest_ctxt->sys_regs[APIAKEYLO_EL1]);
>>> +}
>>
> 
> [...]
> 
>>
>>> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
>>> index 03b36f1..301d332 100644
>>> --- a/arch/arm64/kvm/hyp/switch.c
>>> +++ b/arch/arm64/kvm/hyp/switch.c
>>> @@ -483,6 +483,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>   	sysreg_restore_guest_state_vhe(guest_ctxt);
>>>   	__debug_switch_to_guest(vcpu);
>>>   
>>> +	__ptrauth_switch_to_guest(vcpu, host_ctxt, guest_ctxt);
>>> +
>>>   	__set_guest_arch_workaround_state(vcpu);
>>>   
>>>   	do {
>>> @@ -494,6 +496,8 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>>>   
>>>   	__set_host_arch_workaround_state(vcpu);
>>>   
>>> +	__ptrauth_switch_to_host(vcpu, host_ctxt, guest_ctxt);
>>> +
>>>   	sysreg_save_guest_state_vhe(guest_ctxt);
>>>   
>>>   	__deactivate_traps(vcpu);
>>
>> ...This makes me nervous...
>>
>> __guest_enter() is a function that (might) change the keys, then we change them
>> again here. We can't have any signed return address between these two points. I
>> don't trust the compiler not to generate any.
>>
>> ~
>>
>> I had a chat with some friendly compiler folk... because there are two identical
>> sequences in kvm_vcpu_run_vhe() and __kvm_vcpu_run_nvhe(), the compiler could
>> move the common code to a function it then calls. Apparently this is called
>> 'function outlining'.
>>
>> If the compiler does this, and the guest changes the keys, I think we would fail
>> the return address check.
>>
>> Painting the whole thing with no_prauth would solve this, but this code then
>> becomes a target.
>> Because the compiler can't anticipate the keys changing, we ought to treat them
>> the same way we do the callee saved registers, stack-pointer etc, and
>> save/restore them in the __guest_enter() assembly code.
>>
>> (we can still keep the save/restore in C, but call it from assembly so we know
>> nothing new is going on the stack).
> 
> I agree that this should be called from assembly if we were building the
> kernel with pointer auth. But as we are not doing that yet in this
> series, can't we keep the calls in kvm_vcpu_run_vhe for now?
Well if we keep them in kvm_vcpu_run_vhe then there is not much issue 
also in calling those C functions from assembly guest_enter/guest_exit. 
It works fine in my local implementation. This will also save code 
churning again when kernel ptrauth support is added. The only extra 
change required to be done is to assign attribute _noptrauth to those 
functions. I will add these comments properly in function description.
> 
> In general I would prefer if the keys were switched in
> kvm_arch_vcpu_load/put for now, since the keys are currently only used
> in userspace. Once in-kernel pointer auth support comes along, it can
> move the switch into kvm_vcpu_run_vhe or __guest_enter/__guest_exit as
> required.
Yes it is possible but then there are other benefits in doing this way. 
It will be always ptrauth registers save/restore if inside 
kvm_arch_vcpu_load/put even if userspace does not use it. The current 
way does save/restore dynamically when userspace uses ptrauth 
instructions by trapping first time.
Some discussion happened on it earlier between Mark and Cristopher and 
they seem to agree on it [2].

[2]: https://lore.kernel.org/lkml/20180409125818.GE10904@cbox/

Thanks,
Amit D
> 
> Thanks,
> Kristina
> 
