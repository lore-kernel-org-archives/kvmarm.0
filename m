From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 3/3] arm/arm64: KVM: Fix disabled distributor operation
Date: Tue, 20 Oct 2015 19:44:34 +0200
Message-ID: <56267D82.9010708@linaro.org>
References: <1445113822-7831-1-git-send-email-christoffer.dall@linaro.org>
 <1445113822-7831-4-git-send-email-christoffer.dall@linaro.org>
 <5626049C.3000005@linaro.org> <20151020094434.GC9457@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20151020094434.GC9457@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 10/20/2015 11:44 AM, Christoffer Dall wrote:
> On Tue, Oct 20, 2015 at 11:08:44AM +0200, Eric Auger wrote:
>> Hi Christoffer,
>> On 10/17/2015 10:30 PM, Christoffer Dall wrote:
>>> We currently do a single update of the vgic state when the distrbutor
>> distributor
>>> enable/disable control register is accessed and then bypass updating the
>>> state for as long as the distributor remains disabled.
>>>
>>> This is incorrect, because updating the state does not consider the
>>> distributor enable bit, and this you can end up in a situation where an
>>> interrupt is marked as pending on the CPU interface, but not pending on
>>> the distributor, which is an impossible state to be in, and triggers a
>>> warning.  Consider for example the following sequence of events:
>>>
>>> 1. An interrupt is marked as pending on the distributor
>>>    - the interrupt is also forwarded to the CPU interface
>>> 2. The guest turns off the distributor (it's about to do a reboot)
>>>    - we stop updating the CPU interface state from now on
>>> 3. The guest disables the pending interrupt
>>>    - we remove the pending state from the distributor, but don't touch
>>>      the CPU interface, see point 2.
>>>
>>> Since the distributor disable bit really means that no interrupts should
>>> be forwarded to the CPU interface, we modify the code to keep updating
>>> the internal VGIC state, but always set the CPU interface pending bits
>>> to zero when the distributor is disabled.
>>>
>>> Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
>>> ---
>>>  virt/kvm/arm/vgic.c | 11 ++++++-----
>>>  1 file changed, 6 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>>> index 58b1256..66c6616 100644
>>> --- a/virt/kvm/arm/vgic.c
>>> +++ b/virt/kvm/arm/vgic.c
>>> @@ -1012,6 +1012,12 @@ static int compute_pending_for_cpu(struct kvm_vcpu *vcpu)
>>>  	pend_percpu = vcpu->arch.vgic_cpu.pending_percpu;
>>>  	pend_shared = vcpu->arch.vgic_cpu.pending_shared;
>>>  
>>> +	if (!dist->enabled) {
>>> +		bitmap_zero(pend_percpu, VGIC_NR_PRIVATE_IRQS);
>>> +		bitmap_zero(pend_shared, nr_shared);
>>> +		return 0;
>>> +	}
>>> +
>>>  	pending = vgic_bitmap_get_cpu_map(&dist->irq_pending, vcpu_id);
>>>  	enabled = vgic_bitmap_get_cpu_map(&dist->irq_enabled, vcpu_id);
>>>  	bitmap_and(pend_percpu, pending, enabled, VGIC_NR_PRIVATE_IRQS);
>>> @@ -1039,11 +1045,6 @@ void vgic_update_state(struct kvm *kvm)
>>>  	struct kvm_vcpu *vcpu;
>>>  	int c;
>>>  
>>> -	if (!dist->enabled) {
>>> -		set_bit(0, dist->irq_pending_on_cpu);
>>> -		return;
>> I am confused. Don't you want to clear the whole bitmap?
> 
> So the first line used to set irq_pending_on_cpu for VCPU0 when the
> distributor was disabled, which I think basically worked around the
> guest kernel expecting to see a timer interrupt during boot when doing a
> WFI.  Now when that's fixed, we don't need this (gigantuous hack) anymore.
> 
> The return statement was also weird and buggy, because it never
> prevented anything from going to the CPU interface, it just stopped
> updating things.

Yeah sorry I read it as an addition so I didn't understand that code but
I definitively understand you remove it. Sorry - tired.

Best Regards

Eric
> 
> 
>>
>> Shouldn't we also handle interrupts programmed in the LR. Spec says any
>> ack should return a spurious ID. Is it what is going to happen with the
>> current implementation?
>>
> 
> yes, we really should.  We should unqueue them, but I haven't seen any
> bugs from this, and I feel like we're already changing a lot with short
> notice, so I'd rather not distrupt anything more right now.
> 
> Besides, when we get around to redesigning this whole thing, the concept
> of unqueueing goes away.
> 
> I know it sucks reviewing fixes that only fix a subset of a bad
> implementation, but I'm aiming for 'slightly better than current state'
> right now :)
> 
> -Christoffer
> 
> 
>>> -	}
>>> -
>>>  	kvm_for_each_vcpu(c, vcpu, kvm) {
>>>  		if (compute_pending_for_cpu(vcpu))
>>>  			set_bit(c, dist->irq_pending_on_cpu);
>>>
>>

