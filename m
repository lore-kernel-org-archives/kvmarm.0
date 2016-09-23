From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v6] KVM: arm/arm64: Route vtimer events to user space
Date: Fri, 23 Sep 2016 16:42:44 +0200
Message-ID: <3f14f9f4-a408-4e16-9fcf-608c2809401d@redhat.com>
References: <1474628854-69945-1-git-send-email-agraf@suse.de>
 <dd9267b6-2323-2d74-0553-71a89d05a654@redhat.com>
 <20160923124048.GI9101@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160923124048.GI9101@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, marc.zyngier@arm.com, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu



On 23/09/2016 14:40, Christoffer Dall wrote:
> On Fri, Sep 23, 2016 at 02:11:41PM +0200, Paolo Bonzini wrote:
>>
>>
>> On 23/09/2016 13:07, Alexander Graf wrote:
>>> +		timer_ret = kvm_timer_sync_hwstate(vcpu);
>>>  
>>>  		kvm_vgic_sync_hwstate(vcpu);
>>>  
>>>  		preempt_enable();
>>>  
>>>  		ret = handle_exit(vcpu, run, ret);
>>> +
>>> +		if ((ret == 1) && timer_ret) {
>>> +			/*
>>> +			 * We have to exit straight away to ensure that we only
>>> +			 * ever notify user space once about a level change
>>> +			 */
>>
>> Is this really a requirement?  It complicates the logic noticeably.
>>
> 
> If we skip this, then we have to somehow remember that the sync may have
> updated the line level when we reach the flush state (and didn't exit),
> and I would like maintaining that state even less than doing this check.
> 
> What we could do is to compare the timer->irq.level with the kvm_run
> state outside of the run loop (on the way to userspace) and update the
> kvm_run state if there's a discrepancy.  That way, we can maintain the
> 'timer->irq.level != kvm_run' means, we have to exit, and whenever we
> are exiting, we are reporting the most recent state to user space
> anyway.
> 
> Would that work?

It seems clearer at least.

> (By the way, the check should be via a call into the arch timer code,
> kvm_timer_update_user_state() or something like that).

Makes sense.

Paolo

> Also, the comment above is confusing, because that's not why this check
> is here, the check is here so that we don't loose track of the timer
> output level change if there's no exit to userspace.
> 
> Thanks,
> -Christoffer
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
