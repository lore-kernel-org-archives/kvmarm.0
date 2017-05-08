From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v3 09/10] KVM: arm/arm64: use vcpu requests for irq
 injection
Date: Mon, 8 May 2017 10:48:57 +0200
Message-ID: <74607682-1da8-8299-900c-de5137e0b7f5@redhat.com>
References: <20170503160635.21669-1-drjones@redhat.com>
 <20170503160635.21669-10-drjones@redhat.com>
 <f5fbaba8-911e-7c2f-ba15-eca21b1f751a@redhat.com>
 <20170506184923.GE5923@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170506184923.GE5923@cbox>
Content-Language: en-US
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <cdall@linaro.org>
Cc: Andrew Jones <drjones@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, rkrcmar@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu



On 06/05/2017 20:49, Christoffer Dall wrote:
> On Thu, May 04, 2017 at 01:47:41PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 03/05/2017 18:06, Andrew Jones wrote:
>>> Don't use request-less VCPU kicks when injecting IRQs, as a VCPU
>>> kick meant to trigger the interrupt injection could be sent while
>>> the VCPU is outside guest mode, which means no IPI is sent, and
>>> after it has called kvm_vgic_flush_hwstate(), meaning it won't see
>>> the updated GIC state until its next exit some time later for some
>>> other reason.  The receiving VCPU only needs to check this request
>>> in VCPU RUN to handle it.  By checking it, if it's pending, a
>>> memory barrier will be issued that ensures all state is visible.
>>> We still create a vcpu_req_irq_pending() function (which is a nop),
>>> though, in order to allow us to use the standard request checking
>>> pattern.
>>
>> I wonder if you aren't just papering over this race:
>>
>>         /*
>>          * If there are no virtual interrupts active or pending for this
>>          * VCPU, then there is no work to do and we can bail out without
>>          * taking any lock.  There is a potential race with someone injecting
>>          * interrupts to the VCPU, but it is a benign race as the VCPU will
>>          * either observe the new interrupt before or after doing this check,
>>          * and introducing additional synchronization mechanism doesn't change
>>          * this.
>>          */
>>         if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
>>                 return;
>>
>>         spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
>>         vgic_flush_lr_state(vcpu);
>>         spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>>
>> not being so "benign" after all. :)  Maybe you can remove the if (list_empty()),
>> and have kvm_arch_vcpu_ioctl_run do this instead:
> 
> I don't see how removing this shortcut improves anything.  You'd still
> have the same window where you could loose an interrupt right after the
> spin_unlock.

It's not removing it that matters; it's just unnecessary if you add
KVM_REQ_IRQ_PENDING and you key the call to kvm_vgic_flush_hwstate on it.

Paolo

> I think the race that this comment discusses is indeed benign, but the
> overall guarantees that our vgic injection relies on is flawed and can
> be solved by either doing requests as Drew does here, or moving the
> vgic_flush inside a region that has both mode == IN_GUEST_MODE and
> interrupts disabled.  Note that for other purposes I'm planning to move
> the flush functions inside the interrupts disabled region later anyhow.
> 
> I don't see a problem with Drew's patch actually.
> 
> Thanks,
> -Christoffer
> 
>>
>>  		if (kvm_request_pending(vcpu)) {
>>  			if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
>>  				vcpu_req_sleep(vcpu);
>> 		}
>>
>>                 preempt_disable();
>>
>>                 kvm_pmu_flush_hwstate(vcpu);
>>                 kvm_timer_flush_hwstate(vcpu);
>>
>> 		if (kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu))
>> 			kvm_vgic_flush_hwstate(vcpu);
>>
>> ?
>>
>> Paolo
>>
>>> Signed-off-by: Andrew Jones <drjones@redhat.com>
>>> ---
>>>  arch/arm/include/asm/kvm_host.h   |  1 +
>>>  arch/arm/kvm/arm.c                | 12 ++++++++++++
>>>  arch/arm64/include/asm/kvm_host.h |  1 +
>>>  virt/kvm/arm/arch_timer.c         |  1 +
>>>  virt/kvm/arm/vgic/vgic.c          |  9 +++++++--
>>>  5 files changed, 22 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
>>> index 41669578b3df..7bf90aaf2e87 100644
>>> --- a/arch/arm/include/asm/kvm_host.h
>>> +++ b/arch/arm/include/asm/kvm_host.h
>>> @@ -47,6 +47,7 @@
>>>  
>>>  #define KVM_REQ_SLEEP \
>>>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
>>> +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>>>  
>>>  u32 *kvm_vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num, u32 mode);
>>>  int __attribute_const__ kvm_target_cpu(void);
>>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>>> index d62e99885434..330064475914 100644
>>> --- a/arch/arm/kvm/arm.c
>>> +++ b/arch/arm/kvm/arm.c
>>> @@ -581,6 +581,15 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
>>>  				       (!vcpu->arch.pause)));
>>>  }
>>>  
>>> +static void vcpu_req_irq_pending(struct kvm_vcpu *vcpu)
>>> +{
>>> +	/*
>>> +	 * Nothing to do here. kvm_check_request() already issued a memory
>>> +	 * barrier that pairs with kvm_make_request(), so all hardware state
>>> +	 * we need to flush should now be visible.
>>> +	 */
>>> +}
>>> +
>>>  static int kvm_vcpu_initialized(struct kvm_vcpu *vcpu)
>>>  {
>>>  	return vcpu->arch.target >= 0;
>>> @@ -634,6 +643,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
>>>  		if (kvm_request_pending(vcpu)) {
>>>  			if (kvm_check_request(KVM_REQ_SLEEP, vcpu))
>>>  				vcpu_req_sleep(vcpu);
>>> +			if (kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu))
>>> +				vcpu_req_irq_pending(vcpu);
>>>  		}
>>>  
>>>  		/*
>>> @@ -777,6 +788,7 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
>>>  	 * trigger a world-switch round on the running physical CPU to set the
>>>  	 * virtual IRQ/FIQ fields in the HCR appropriately.
>>>  	 */
>>> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>  	kvm_vcpu_kick(vcpu);
>>>  
>>>  	return 0;
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>> index 04c0f9d37386..2c33fef945fe 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -44,6 +44,7 @@
>>>  
>>>  #define KVM_REQ_SLEEP \
>>>  	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_NO_WAKEUP | KVM_REQUEST_WAIT)
>>> +#define KVM_REQ_IRQ_PENDING	KVM_ARCH_REQ(1)
>>>  
>>>  int __attribute_const__ kvm_target_cpu(void);
>>>  int kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>>> index 5976609ef27c..469b43315c0a 100644
>>> --- a/virt/kvm/arm/arch_timer.c
>>> +++ b/virt/kvm/arm/arch_timer.c
>>> @@ -95,6 +95,7 @@ static void kvm_timer_inject_irq_work(struct work_struct *work)
>>>  	 * If the vcpu is blocked we want to wake it up so that it will see
>>>  	 * the timer has expired when entering the guest.
>>>  	 */
>>> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>  	kvm_vcpu_kick(vcpu);
>>>  }
>>>  
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index 3d0979c30721..bdd4b3a953b5 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -283,8 +283,10 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
>>>  		 * won't see this one until it exits for some other
>>>  		 * reason.
>>>  		 */
>>> -		if (vcpu)
>>> +		if (vcpu) {
>>> +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>  			kvm_vcpu_kick(vcpu);
>>> +		}
>>>  		return false;
>>>  	}
>>>  
>>> @@ -330,6 +332,7 @@ bool vgic_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq)
>>>  	spin_unlock(&irq->irq_lock);
>>>  	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
>>>  
>>> +	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>  	kvm_vcpu_kick(vcpu);
>>>  
>>>  	return true;
>>> @@ -719,8 +722,10 @@ void vgic_kick_vcpus(struct kvm *kvm)
>>>  	 * a good kick...
>>>  	 */
>>>  	kvm_for_each_vcpu(c, vcpu, kvm) {
>>> -		if (kvm_vgic_vcpu_pending_irq(vcpu))
>>> +		if (kvm_vgic_vcpu_pending_irq(vcpu)) {
>>> +			kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
>>>  			kvm_vcpu_kick(vcpu);
>>> +		}
>>>  	}
>>>  }
>>>  
>>>
