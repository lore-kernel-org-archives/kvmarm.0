From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v5] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 10:57:46 +0200
Message-ID: <63a1e3a2-f551-017f-b6be-593b53a0b407@redhat.com>
References: <1474548769-195643-1-git-send-email-agraf@suse.de>
 <20160922212831.GD9101@cbox> <d90f04d4-b29f-f08e-df39-ec307af44225@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <d90f04d4-b29f-f08e-df39-ec307af44225@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, marc.zyngier@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/09/2016 09:14, Alexander Graf wrote:
>>> +/*
>>> + * Synchronize the timer IRQ state with the interrupt controller.
>>> + */
>>>  static void kvm_timer_update_irq(struct kvm_vcpu *vcpu, bool new_level)
>>>  {
>>>  	int ret;
>>>  	struct arch_timer_cpu *timer = &vcpu->arch.timer_cpu;
>>>  
>>>  	timer->active_cleared_last = false;
>>>  	timer->irq.level = new_level;
>>> -	trace_kvm_timer_update_irq(vcpu->vcpu_id, timer->irq.irq,
>>> +	trace_kvm_timer_update_irq(vcpu->vcpu_id, host_vtimer_irq,
>>>  				   timer->irq.level);
>>> +	[...]
>>> +		struct kvm_sync_regs *regs = &vcpu->run->s.regs;
>>> +
>>> +		/* Populate the timer bitmap for user space */
>>> +		regs->kernel_timer_pending &= ~KVM_ARM_TIMER_VTIMER;
>>> +		if (new_level)
>>> +			regs->kernel_timer_pending |= KVM_ARM_TIMER_VTIMER;
>>
>> I think if you got here, it means you have to exit to userspace to
>> update it of the new state.  If you don't want to propagate a return
> 
> Yes, but we can't exit straight away with our own exit reason because we
> might be inside an MMIO exit path here which already occupies the
> exit_reason.

So the idea is that whenever you're here you have one of the following
cases:

- are coming from kvm_timer_flush_hwstate, and then you exit immediately
with KVM_EXIT_INTR if needed

- you are coming from the kvm_timer_sync_hwstate just before
handle_exit.  Then if there's a vmexit you have already set
regs->kernel_timer_pending, if not you'll do a kvm_timer_flush_hwstate soon.

- you are coming from the kvm_timer_sync_hwstate in the middle of
kvm_arch_vcpu_ioctl_run, and then "continue" will either exit the loop
immediately (if ret <= 0) or go to kvm_timer_flush_hwstate as in the
previous case

Right?

>> Maybe I'm misunderstanding and user_timer_pending is just a cached
>> verison of what you said last, but as I said above, I think you can just
>> compare timer->irq.level with the last value the kvm_run struct, and if
>> something changed, you have to exit.
> 
> So how would user space know whether the line went up or down? Or didn't
> change at all (if we coalesce with an MMIO exit)?

It would save the status of the line somewhere in its own variable,
without introducing a relatively delicate API between kernel and user.

I agree that you cannot update kernel_timer_pending only in
flush_hwstate; otherwise you miss on case (2) when there is a vmexit.
That has to stay in kvm_timer_sync_hwstate (or it could become a new
function called at the very end of kvm_arch_vcpu_ioctl_run).

However, I'm not sure why user_timer_pending is necessary.  If it is
just the value you assigned to regs->kernel_timer_pending at the time of
the previous vmexit, can kvm_timer_flush_hwstate just do

   if (timer->prev_kernel_timer_pending != regs->kernel_timer_pending) {
       timer->prev_kernel_timer_pending = regs->kernel_timer_pending;
       return 1;
   }

?  Or even

   if (timer->prev_irq_level != timer->irq.level) {
       timer->prev_irq_level = regs->irq.level;
       return 1;
   }

so that regs->kernel_timer_pending remains exclusively
kvm_timer_sync_hwstate's business?

Thanks,

Paolo

>>
>>> +
>>> +		/*
>>> +		 * As long as user space is aware that the timer is pending,
>>> +		 * we do not need to get new host timer events.
>>> +		 */
>>
>> yes, correct, but I don't think this concept was clearly reflected in
>> your API text above.
>>
>>> +		if (timer->irq.level)
>>> +			disable_percpu_irq(host_vtimer_irq);
>>> +		else
>>> +			enable_percpu_irq(host_vtimer_irq, 0);
>>> +	}
>>
>> could we move these two blocks into their own functions instead?  That
>> would also give nice names to the huge chunk of complicated
>> functionality, e.g. flush_timer_state_to_user() and
>> flush_timer_state_to_vgic().
> 
> That's probably a very useful cleanup, yes :).
> 
> 
> Alex
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
