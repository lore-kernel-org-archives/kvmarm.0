From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v1 1/2] KVM: arm64: handle single-stepping trapped
 instructions
Date: Fri, 6 Oct 2017 13:46:05 +0100
Message-ID: <789ebd83-6ece-027d-a623-067187b9d7df@arm.com>
References: <20171006113921.24880-1-alex.bennee@linaro.org>
 <20171006113921.24880-2-alex.bennee@linaro.org>
 <d95a7ce1-1996-b0c6-4a2d-64af011c0c79@arm.com>
 <49ddad48-d3ce-43e2-7aae-f6cc66ef1fad@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <49ddad48-d3ce-43e2-7aae-f6cc66ef1fad@arm.com>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Julien Thierry <julien.thierry@arm.com>, =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, open list <linux-kernel@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 06/10/17 13:34, Julien Thierry wrote:
> 
> 
> On 06/10/17 13:27, Marc Zyngier wrote:
>> On 06/10/17 12:39, Alex Bennée wrote:
>>> If we are using guest debug to single-step the guest we need to ensure
>>> we exit after emulating the instruction. This only affects
>>> instructions completely emulated by the kernel. For userspace emulated
>>> instructions we need to exit and return to complete the emulation.
>>>
>>> We fake debug.arch.hsr to contain ESR_ELx_EC_SOFTSTP_LOW so QEMU knows
>>> it was a single-step event (and without altering the userspace ABI).
>>>
>>> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
>>> ---
>>>   arch/arm64/kvm/handle_exit.c | 48 +++++++++++++++++++++++++++++++-------------
>>>   1 file changed, 34 insertions(+), 14 deletions(-)
>>>
>>> diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
>>> index 7debb74843a0..c918d291cb58 100644
>>> --- a/arch/arm64/kvm/handle_exit.c
>>> +++ b/arch/arm64/kvm/handle_exit.c
>>> @@ -178,6 +178,39 @@ static exit_handle_fn kvm_get_exit_handler(struct kvm_vcpu *vcpu)
>>>   	return arm_exit_handlers[hsr_ec];
>>>   }
>>>   
>>> +/*
>>> + * When handling traps we need to ensure exit the guest if we
>>> + * completely emulated the instruction while single-stepping. Stuff to
>>> + * be emulated in userspace needs to complete that first.
>>> + */
>>> +
>>> +static int handle_trap_exceptions(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>> +{
>>> +	int handled;
>>> +
>>> +	/*
>>> +	 * See ARM ARM B1.14.1: "Hyp traps on instructions
>>> +	 * that fail their condition code check"
>>> +	 */
>>> +	if (!kvm_condition_valid(vcpu)) {
>>> +		kvm_skip_instr(vcpu, kvm_vcpu_trap_il_is32bit(vcpu));
>>> +		handled = 1;
>>> +	} else {
>>> +		exit_handle_fn exit_handler;
>>> +
>>> +		exit_handler = kvm_get_exit_handler(vcpu);
>>> +		handled = exit_handler(vcpu, run);
>>> +	}
>>> +
>>> +	if (handled && (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
>>> +		handled = 0;
>>> +		run->exit_reason = KVM_EXIT_DEBUG;
>>> +		run->debug.arch.hsr = ESR_ELx_EC_SOFTSTP_LOW << ESR_ELx_EC_SHIFT;
>>> +	}
>>
>> Doesn't this break an MMIO read? The registers haven't been updated yet,
>> and the debugger may not see the right thing...
>>
>> How about something like:
>>
>> 	if (handled && (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)) {
>> 		if (run->exit_reason == KVM_EXIT_MMIO)
>> 			kvm_handle_mmio_return(vcpu, run);
>> 		[...]
>> 	}
>>
>> Or am I missing something?
> 
> If the MMIO was not handled by the kernel, exit_handler will return 0, 
> so handled will be false and we won't pretend we have a debug exception 
> (but will still return to userland with KVM_EXIT_MMIO).
> 
> I think the second patch takes care of properly handling single step for 
> userland MMIO.

Indeed, I was just confused. We do have a kvm_handle_mmio_return in the
vgic emulation, so it is all taken care off at this stage. Blimey.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
