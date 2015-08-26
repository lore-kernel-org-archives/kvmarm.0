From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: BUG: Fix losing level-sensitive
 interrupts
Date: Wed, 26 Aug 2015 09:27:21 +0100
Message-ID: <20150826092721.43e8cbfd@arm.com>
References: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1440571563-7004-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>, Alex =?ISO-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, 26 Aug 2015 09:46:03 +0300
Pavel Fedin <p.fedin@samsung.com> wrote:

Hi Pavel,

> Commit 71760950bf3dc796e5e53ea3300dec724a09f593
> ("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn") introduced
> vgic_queue_irq_to_lr() function which checks vgic_dist_irq_is_pending()
> before setting LR_STATE_PENDING bit. However, in some cases, the following
> race condition is possible:
> 1. Userland injects an IRQ with level == 1, this ends up in
>    vgic_update_irq_pending(), which in turn calls
>    vgic_dist_irq_set_pending() for this IRQ.
> 2. vCPU gets kicked. But kernel does not manage to reschedule it quickly
>    (!!!)
> 3. Userland quickly resets the IRQ to level == 0. vgic_update_irq_pending()
>    in this case will call vgic_dist_irq_clear_pending() and reset the
>    pending flag.

So userspace drops the line to 0 *before* the guest had a chance to do
anything? Well, this is not the expected behaviour for a level
triggered interrupt, which should look like this:

- device raises the interrupt line
- guest takes the interrupt
- guest pokes the device to clear the interrupt condition
- device lowers the line

The behaviour you describe is that of an edge triggered interrupt, and
it is not surprising at all that you loose interrupts.

This really feels like a userspace bug to me (I vaguely remember some
QEMU issues regarding this a while ago, but my memory is a bit hazy).
Christoffer?

	M.
-- 
Jazz is not dead. It just smells funny.
