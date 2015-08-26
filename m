From: Pavel Fedin <p.fedin@samsung.com>
Subject: RE: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive interrupts
Date: Wed, 26 Aug 2015 13:58:47 +0300
Message-ID: <00d701d0dfee$2f464810$8dd2d830$@samsung.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
 <20150826092721.43e8cbfd@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-reply-to: <20150826092721.43e8cbfd@arm.com>
Content-language: ru
Sender: kvm-owner@vger.kernel.org
To: 'Marc Zyngier' <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Christoffer Dall' <christoffer.dall@linaro.org>, =?ISO-8859-1?Q?'Alex_Benn=E9e'?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

 Hello!

> So userspace drops the line to 0 *before* the guest had a chance to do
> anything? Well, this is not the expected behaviour for a level
> triggered interrupt

 I know. But, still...
 Imagine that we have misconfigured the HW for some reason. The device pulses an IRQ line, but we
think it's a level IRQ. What will happen in a real hardware? Not much, the interrupt will still be
sampled.
 So, for better modelling the hardware, shouldn't we improve KVM's behavior here? Especially if
before v4.1 it actually did not have this problem.

> This really feels like a userspace bug to me (I vaguely remember some
> QEMU issues regarding this a while ago, but my memory is a bit hazy).

 You know, may be it's really qemu's problem, to tell the truth i'm lazy to read the whole PL011
spec, but qemu appears to pulse the line without PL011 interrupt servicing at all. I know this
because my kernel is patched, it uses software emulation of vCPU interface, because vGIC is broken
on ThunderX. And LR state change and all the maintenance is done upon EOIR write (which is trapped).
With this change consequences of losing an interrupt are much more severe, the IRQ line get stuck
and stops working at all. Subsequent injections are blocked by vgic_can_sample_irq(), which returns
false because vgic_irq_is_queued() returns true. Because vgic_irq_clear_queued() is called during
maintenance procedure, which in this case never happens, because the interrupt is never EOIed,
because it was never made PENDING in the LR. Actually that's how i found this.
 So, here is why i am describing these unrelated things here: with IRQ line processing completely
locked up, line switches between 1 and 0 is still injected (vgic_update_irq_pending() is called with
both values, i added some debug output in order to see this). The guest successfully boots up to a
login prompt, everything is fine, just i cannot type anything on the console because serial port's
interrupt is locked up. I suppose that this pulsing has to do with output FIFO. Could this be some
bug in kernel's pl011 driver itself, which does something wrong and does not handle interrupts in a
proper way during output?

Kind regards,
Pavel Fedin
Expert Engineer
Samsung Electronics Research center Russia


