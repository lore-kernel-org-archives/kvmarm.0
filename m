From: Alexander Graf <agraf@suse.de>
Subject: Re: [RFC 2/2] ARM: KVM: Enable in-kernel timers with user space gic
Date: Thu, 3 Nov 2016 10:06:54 +0100
Message-ID: <581AFE2E.2040008@suse.de>
References: <1477775449-115472-1-git-send-email-agraf@suse.de>
 <1477775449-115472-2-git-send-email-agraf@suse.de>
 <CAFEAcA9ABvy52WDX++ACUQNo+UiRJkyC+X_mT+QhMxqE154Nqw@mail.gmail.com>
 <581A08F3.1050501@suse.de> <20161102161943.GA11122@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20161102161943.GA11122@cbox>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini <pbonzini@redhat.com>, qemu-arm <qemu-arm@nongnu.org>, QEMU Developers <qemu-devel@nongnu.org>, kvm-devel <kvm@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On 11/02/2016 05:19 PM, Christoffer Dall wrote:
> On Wed, Nov 02, 2016 at 04:40:35PM +0100, Alexander Graf wrote:
>> On 11/01/2016 12:35 PM, Peter Maydell wrote:
>>> On 29 October 2016 at 22:10, Alexander Graf <agraf@suse.de> wrote:
> [...]
>
>>>> +        cpu->timer_irq_level = run->s.regs.timer_irq_level;
>>>> +    }
>>>> +
>>>>       return MEMTXATTRS_UNSPECIFIED;
>>>>   }
>>> Does this code do the right thing across a vcpu reset or
>>> a full-system reset?
>> Good question. I'm not 100% sure - but I don't know for sure whether
>> it's guaranteed without user space irqchip even.
>>
>> In essence, the code above merely synchronizes kvm state to qemu
>> state and is fully unaffected from any reset sequence. This is good,
>> as the line status is transient. So from a QEMU pov, we really only
>> copy the state of the vcpu interrupt line into the QEMU interrupt
>> line. Pulling that line down would be responsibility of the
>> KVM_ARM_VCPU_INIT ioctl if it also clears the timer registers I
>> guess.
>>
>> However, I don't see any clearing of cntv_ctrl inside KVM or from
>> QEMU. How do we ensure that the irq active bit is off on reset?
>
> In kvm_timer_vcpu_reset we cset cntv_ctl = 0, and that function gets
> called from the PSCI handler or whenever userspace calls the set target
> ioctl thingy.

Ah, ok, that should pull the "run" line down automatically.

>
>> The other part that could get in the way of working system reset is
>> the interrupt controller emulation itself which resets all internal
>> irq line state. So on reset we'd always end up with the irq line
>> down from a gic pov, but with the vtimer line pending or not pending
>> depending on previous state. I doubt it's really going to hurt
>> though.
> I suppose it should resample the line, but if the GIC clears everything
> and the arch timer line goes down, you're in the right starting state
> again.  Right?

Yup, I don't see any reason it wouldn't work :). Even if the GIC didn't 
clear everything things should still just work as long as the timer 
reset function gets called, as it unconditionally synchronizes the state.


Alex

