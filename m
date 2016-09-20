From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Tue, 20 Sep 2016 17:42:33 +0100
Message-ID: <57E166F9.8080109@arm.com>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
 <0960d2a7-6100-3212-c544-d5377df34d57@suse.de> <57E0FF95.7040305@arm.com>
 <580a8a26-ca8f-a08a-a9da-d19d1a595cb6@suse.de> <57E103E8.7040506@arm.com>
 <57E109CF.8030705@suse.de> <57E10F37.3030002@arm.com>
 <57E12A02.7020907@suse.de> <57E12D98.6080008@arm.com>
 <57E14829.3060406@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57E14829.3060406@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com, drjones@redhat.com, christoffer.dall@linaro.org, peter.maydell@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

On 20/09/16 15:31, Alexander Graf wrote:
> On 09/20/2016 02:37 PM, Marc Zyngier wrote:

[...]

>>>>> We also need to know "timer line low + timer line masked", as otherwise
>>>>> we might get spurious interrupts in the guest, no?
>>>> Yes. Though you can't really know about this one, and you'll have to
>>>> wait until the next natural exit to find out. As long as the spurious is
>>> We can provoke a special exit for it, no?
>> How? The guest decides to disable its timer. That doesn't trigger any
>> exit whatsoever. You'll have to wait until the next exit from the guest
>> to notice it.
> 
> Before we inject a timer interrupt, we can check whether the pending 
> semantics of user space / kernel space match. If they don't match, we 
> can exit before we inject the interrupt and allow user space to disable 
> the pending state again.

Let's rewind a bit, because I've long lost track of what you're trying
to do to handle what.

You need two signals:

(1) TIMER_LEVEL: the output of the timer line, having accounted for the
IMASK bit. This is conveniently the value of timer->irq.level.

(2) TIMER_IRQ_MASK: an indication from userspace that a timer interrupt
is pending, and that the physical line should be masked.

You need a number of rules:

(a) On exit to userspace, the kernel always exposes the value of
TIMER_LEVEL.

(b) On kernel entry, userspace always exposes the required
TIMER_IRQ_MASK, depending on what has been exposed to it by TIMER_LEVEL.

(c) If on guest exit, TIMER_LEVEL==1 and TIMER_IRQ_MASK==0, perform a
userspace exit, because the emulated GIC needs to make the interrupt
pending.

(d) If on guest exit, TIMER_LEVEL==0 and TIMER_IRQ_MASK==1, perform a
userspace exit, because the guest has disabled its timer before taking
the interrupt, and the emulated GIC needs to retire the pending state.

and that's it. Nothing else. The kernel tells userspace the state of the
timer, and userspace drives the masking of the physical interrupt.
Conveniently, this matches what the current code does.

> 
>>
>>>> "spurious in the GIC sense" (hence returning 0x3ff) and not a spurious
>>>> timer interrupt being presented, you're fine.
>>> Imagine
>>>
>>>     * guest configures timer to fire
>>>     * kvm exits to user space because lines mismatch now
>> I suppose you mean timer fired + physical interrupt for the virtual enabled?
> 
> In this scheme, I would simply say "user space thinks it's pending" == 
> "host vtimer irq is masked". So because user space thinks that no timer 
> is pending and the guest managed to trigger a vtimer irq on the host, 
> the guest exited on a physical vtimer irq. Kvm then checks whether the 
> timer expired and sets the vcpu timer pending status to 1. User space 
> status is still 0, so kvm exits to user space to update the status.
> 
>>
>>>     * user space sets gic line up, setting vcpu irq line high
>>>     * guest runs, handles IRQ, calls EOI with IRQs disabled on the core
>> Same thing: you mean physical interrupt for the virtual timer disabled?
>> or something else?
> 
> I mean the guest sets pstate.I = 0.

The I bit is a mask, just like any other exception bit in PSTATE. So
you're *enabling* interrupts here. But let's assume the interrupts are
disabled, as they are in an interrupt handler.

> 
>>
>>>     * user space handles EOI, but still leaves the vcpu line high
>> If there is another pending interrupt, sure. Otherwise, that's a bug.
> 
> Why is that a bug? The line really is still pending at this point.

So what is this "vcpu line"? HCR_EL2.VI? The timer interrupt through the
GIC? The timer output line?

> 
>>
>>>     * guest runs, sets cval, enables IRQs on the core
>> What is that interrupt? Please name things, because that's very confusing.
> 
> The guest sets pstate.I=1.

And?

> 
>>
>>>     * kvm injects a timer interrupt into the guest
>> Why? Has the timer fired?
> 
> cntv.ctl.imask = 0 here, but user space doesn't know that yet. So the 
> "pending" state is still active.

Rule (a) should apply, always. Whether it is pending or not depends on
what userspace decides to do. If userspace doesn't play ball, the guest
will keep exiting.

> 
>>
>>> At this point, the pending state from user space is bogus, as the line
>>> really isn't pending anymore. However, when the guest asks the GIC at
>>> that point what interrupt is pending, the line down state will have
>>> populated into user space before the mmio request gets processed. So you
>>> will see a 0x3ff return I guess.
>>>
>>> Is that reasonable?
>> I'm sorry, but you need to put names on things and precisely describe
>> the various events. because from the above script, I can derive twenty
>> different scenarios...
> 
> I'm sure one of them has to be racy? :)
> 
> (in fact, there are probably more than what I came up with that really 
> are...)

At this stage, I don't have any understanding of what you're trying to
do. I've given you what I think needs to be implemented, please let me
know if that matches your understanding.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
