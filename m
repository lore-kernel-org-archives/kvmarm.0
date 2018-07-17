From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64: Fix emulated physical timer IRQ injection
Date: Tue, 17 Jul 2018 12:34:58 +0100
Message-ID: <0acb919d-04d2-66f9-5281-ddcae5342578@arm.com>
References: <20180716172357.6121-1-andre.przywara@arm.com>
 <20180717101040.GE30570@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180717101040.GE30570@e113682-lin.lund.arm.com>
Content-Language: en-GB
Sender: stable-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Stable <stable@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 17/07/18 11:10, Christoffer Dall wrote:
> On Mon, Jul 16, 2018 at 06:23:57PM +0100, Andre Przywara wrote:
>> When KVM emulates a physical timer, we keep track of the interrupt
>> condition and try to inject an IRQ to the guest when needed.
>> This works if the timer expires when either the guest is running or KVM
>> does work on behalf of it, since it calls kvm_timer_update_state().
>> However when the guest's VCPU is not scheduled (for instance because
>> the guest issued a WFI instruction before), we miss injecting the interrupt
>> when the VCPU's state gets restored back in kvm_timer_vcpu_load().
>>
>> Fix this by moving the interrupt injection check into the
>> phys_timer_emulate() function, so that all possible paths of execution
>> are covered.
>>
>> This fixes the physical timer emulation, which broke when it got changed
>> in the 4.15 merge window.
>> The respective kvm-unit-test check has been posted already.
>>
>> Cc: Stable <stable@vger.kernel.org> # 4.15+
>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>> ---
>>  virt/kvm/arm/arch_timer.c | 21 +++++++++++++--------
>>  1 file changed, 13 insertions(+), 8 deletions(-)
>>
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index bd3d57f40f1b..1949fb0b80a4 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -294,17 +294,26 @@ static void phys_timer_emulate(struct kvm_vcpu *vcpu)
>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>  	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>  
>> +	/* If the timer cannot fire at all, then we don't need a soft timer. */
>> +	if (!kvm_timer_irq_can_fire(ptimer)) {
>> +		soft_timer_cancel(&timer->phys_timer, NULL);
>> +		kvm_timer_update_irq(vcpu, false, ptimer);
>> +		return;
>> +	}
> 
> This stuff is breaking what the intention is with the
> phys_timer_emulate() function.  See the comment above the function,
> which says that this is about scheduling the background soft timer, and
> not about managing the rest of the state.
> 
> At least that function needs updating.

Well, my naive understanding of "phys_timer_emulate()" was that it takes
care of the whole task, and injecting the IRQ is an integral part of the
package. As it stands with your patches now, the caller of
phys_timer_emulate() has to take care of the IRQ injection, which smells
a bit fragile. So since we have this "phys_timer_emulate(); if()
kvm_timer_update_irq() ...;" sequence now exactly twice, I found it more
logical to move that into the function.
But I don't really care (or we wrap this once more as Marc suggested).
And as your version also works (tested with both kvm-unit-tests and by
running a hacked Linux guest which always uses the physical timer), feel
free to send your patches. You might want to declare ptimer in
kvm_timer_vcpu_load() though ;-) and also amend this comment in
phys_timer_emulate().
I think having this separate bites me a bit in the nested virt rework
(because it's more than one timer to emulate), but I can fix this there.

>> +
>>  	/*
>> -	 * If the timer can fire now we have just raised the IRQ line and we
>> -	 * don't need to have a soft timer scheduled for the future.  If the
>> -	 * timer cannot fire at all, then we also don't need a soft timer.
>> +	 * If the timer can fire now, we don't need to have a soft timer
>> +	 * scheduled for the future, as we also raise the IRQ line.
>>  	 */
>> -	if (kvm_timer_should_fire(ptimer) || !kvm_timer_irq_can_fire(ptimer)) {
>> +	if (kvm_timer_should_fire(ptimer)) {
>>  		soft_timer_cancel(&timer->phys_timer, NULL);
>> +		kvm_timer_update_irq(vcpu, true, ptimer);
>> +
>>  		return;
>>  	}
>>  
>>  	soft_timer_start(&timer->phys_timer, kvm_timer_compute_delta(ptimer));
>> +	kvm_timer_update_irq(vcpu, false, ptimer);
> 
> This is clearly racy as you'll lower the interrupt that may have just
> fired between these two lines.

True, Marc pointed that out already and I fixed in in v2.

Cheers,
Andre.

>>  }
>>  
>>  /*
>> @@ -316,7 +325,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>>  {
>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>  	struct arch_timer_context *vtimer = vcpu_vtimer(vcpu);
>> -	struct arch_timer_context *ptimer = vcpu_ptimer(vcpu);
>>  	bool level;
>>  
>>  	if (unlikely(!timer->enabled))
>> @@ -332,9 +340,6 @@ static void kvm_timer_update_state(struct kvm_vcpu *vcpu)
>>  	level = kvm_timer_should_fire(vtimer);
>>  	kvm_timer_update_irq(vcpu, level, vtimer);
>>  
>> -	if (kvm_timer_should_fire(ptimer) != ptimer->irq.level)
>> -		kvm_timer_update_irq(vcpu, !ptimer->irq.level, ptimer);
>> -
>>  	phys_timer_emulate(vcpu);
>>  }
>>  
>> -- 
>> 2.14.4
>>
> 
