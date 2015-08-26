From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 12:13:31 +0100
Message-ID: <55DD9F5B.4080602@arm.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com> <20150826092721.43e8cbfd@arm.com> <00d701d0dfee$2f464810$8dd2d830$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <00d701d0dfee$2f464810$8dd2d830$@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>, =?windows-1252?Q?=27Alex_Benn=E9e=27?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On 26/08/15 11:58, Pavel Fedin wrote:
>  Hello!
> 
>> So userspace drops the line to 0 *before* the guest had a chance to do
>> anything? Well, this is not the expected behaviour for a level
>> triggered interrupt
> 
>  I know. But, still...
>  Imagine that we have misconfigured the HW for some reason. The device pulses an IRQ line, but we
> think it's a level IRQ. What will happen in a real hardware? Not much, the interrupt will still be
> sampled.
>  So, for better modelling the hardware, shouldn't we improve KVM's behavior here? Especially if
> before v4.1 it actually did not have this problem.

I'm sorry, but that's actually a very accurate model of the HW. You
misconfigure the line trigger, you loose interrupts. This happens on
real HW all the time. And if you haven't seen that before, you haven't
tried very hard.

As for v4.1 not having that problem, the pl011 driver has gone though a
lot if rework lately, and I wouldn't be surprised if it now exhibited a
different behaviour thanks to the broken userspace behaviour.

> 
>> This really feels like a userspace bug to me (I vaguely remember some
>> QEMU issues regarding this a while ago, but my memory is a bit hazy).
> 
>  You know, may be it's really qemu's problem, to tell the truth i'm lazy to read the whole PL011
> spec, but qemu appears to pulse the line without PL011 interrupt servicing at all. I know this
> because my kernel is patched, it uses software emulation of vCPU interface, because vGIC is broken
> on ThunderX. And LR state change and all the maintenance is done upon EOIR write (which is trapped).
> With this change consequences of losing an interrupt are much more severe, the IRQ line get stuck
> and stops working at all. Subsequent injections are blocked by vgic_can_sample_irq(), which returns
> false because vgic_irq_is_queued() returns true. Because vgic_irq_clear_queued() is called during
> maintenance procedure, which in this case never happens, because the interrupt is never EOIed,
> because it was never made PENDING in the LR. Actually that's how i found this.

TL;DR.

You're using a different code base, broken HW, and what is apparently a
buggy userspace. Sorry, but I don't really want to introduce another bug
in the VGIC code (we have too many already). And what you're suggesting
is to actually introduce a bug.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
