From: Alexander Graf <agraf@suse.de>
Subject: Re: [PATCH v4 2/2] KVM: arm/arm64: Route vtimer events to user space
Date: Thu, 22 Sep 2016 13:17:03 +0200
Message-ID: <57E3BDAF.8070805@suse.de>
References: <1474283695-212421-1-git-send-email-agraf@suse.de>
 <1474283695-212421-3-git-send-email-agraf@suse.de> <57DFFAD3.3080009@arm.com>
 <0960d2a7-6100-3212-c544-d5377df34d57@suse.de> <57E0FF95.7040305@arm.com>
 <580a8a26-ca8f-a08a-a9da-d19d1a595cb6@suse.de> <57E103E8.7040506@arm.com>
 <57E109CF.8030705@suse.de> <57E10F37.3030002@arm.com>
 <57E12A02.7020907@suse.de> <57E12D98.6080008@arm.com>
 <57E14829.3060406@suse.de> <57E166F9.8080109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86EDD49B36
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 07:08:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RTZkefy8H5sY for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Sep 2016 07:07:58 -0400 (EDT)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E26B49B35
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Sep 2016 07:07:57 -0400 (EDT)
In-Reply-To: <57E166F9.8080109@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On 09/20/2016 06:42 PM, Marc Zyngier wrote:
> On 20/09/16 15:31, Alexander Graf wrote:
>> On 09/20/2016 02:37 PM, Marc Zyngier wrote:
> [...]
>
>>>>>> We also need to know "timer line low + timer line masked", as otherwise
>>>>>> we might get spurious interrupts in the guest, no?
>>>>> Yes. Though you can't really know about this one, and you'll have to
>>>>> wait until the next natural exit to find out. As long as the spurious is
>>>> We can provoke a special exit for it, no?
>>> How? The guest decides to disable its timer. That doesn't trigger any
>>> exit whatsoever. You'll have to wait until the next exit from the guest
>>> to notice it.
>> Before we inject a timer interrupt, we can check whether the pending
>> semantics of user space / kernel space match. If they don't match, we
>> can exit before we inject the interrupt and allow user space to disable
>> the pending state again.
> Let's rewind a bit, because I've long lost track of what you're trying
> to do to handle what.
>
> You need two signals:
>
> (1) TIMER_LEVEL: the output of the timer line, having accounted for the
> IMASK bit. This is conveniently the value of timer->irq.level.
>
> (2) TIMER_IRQ_MASK: an indication from userspace that a timer interrupt
> is pending, and that the physical line should be masked.
>
> You need a number of rules:
>
> (a) On exit to userspace, the kernel always exposes the value of
> TIMER_LEVEL.
>
> (b) On kernel entry, userspace always exposes the required
> TIMER_IRQ_MASK, depending on what has been exposed to it by TIMER_LEVEL.
>
> (c) If on guest exit, TIMER_LEVEL==1 and TIMER_IRQ_MASK==0, perform a
> userspace exit, because the emulated GIC needs to make the interrupt
> pending.

This should be "before guest entry", because the timer might have 
expired in between.

> (d) If on guest exit, TIMER_LEVEL==0 and TIMER_IRQ_MASK==1, perform a
> userspace exit, because the guest has disabled its timer before taking
> the interrupt, and the emulated GIC needs to retire the pending state.
>
> and that's it. Nothing else. The kernel tells userspace the state of the
> timer, and userspace drives the masking of the physical interrupt.
> Conveniently, this matches what the current code does.

Yup. It seems to work. It also does feel slower than the previous code, 
but maybe that's just me. It definitely is way more correct.

I'll trace around a bit more to see whether I can spot any obviously low 
hanging performance fruits, then prettify the patches and send them out :).


Alex
