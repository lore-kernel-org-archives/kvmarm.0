From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: BUG FIX: Do not inject spurious
 interrupts
Date: Tue, 29 Sep 2015 09:25:18 +0200
Message-ID: <20150929072518.GC9002@cbox>
References: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1443189629-8744-1-git-send-email-p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, 'Marc Zyngier' <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 25, 2015 at 05:00:29PM +0300, Pavel Fedin wrote:
> Commit 71760950bf3dc796e5e53ea3300dec724a09f593
> ("arm/arm64: KVM: add a common vgic_queue_irq_to_lr fn") introduced
> vgic_queue_irq_to_lr() function with additional vgic_dist_irq_is_pending()
> check before setting LR_STATE_PENDING bit. In some cases it started
> causing the following situation if the userland quickly drops a
> level-sensitive IRQ back to inactive state for some reason:
> 1. Userland injects an IRQ with level == 1, this ends up in
>    vgic_update_irq_pending(), which in turn calls
>    vgic_dist_irq_set_pending() for this IRQ.
> 2. vCPU gets kicked. But kernel does not manage to reschedule it quickly
>    (!!!)
> 3. Userland quickly resets the IRQ to level == 0. vgic_update_irq_pending()
>    in this case will call vgic_dist_irq_clear_pending() and reset the
>    pending flag.
> 4. vCPU finally wakes up. It successfully rolls through through
>    __kvm_vgic_flush_hwstate(), which populates vGIC registers. However,
>    since neither pending nor active flags are now set for this IRQ,
>    vgic_queue_irq_to_lr() does not set any state bits on this LR at all.
>    Since this is level-sensitive IRQ, we end up in LR containing only
>    LR_EOI_INT bit, causing unnecessary immediate exit from the guest.
> 
> This patch fixes the problem by adding forgotten vgic_cpu_irq_clear().
> This causes the IRQ not to be included into any lists, if it has been
> picked up after getting dropped to inactive level. Since this is a
> level-sensitive IRQ, this is correct behavior. Additionally,
> irq_pending_on_cpu will also be reset if this was the only pending
> interrupt, saving us from unnecessary wakeups.
> 
> The bug was caught on ARM64 kernel v4.1.6, running qemu "virt" guest,
> where it was caused by emulated pl011.
> 
> Signed-off-by: Pavel Fedin <p.fedin@samsung.com>

I reworked the commit message and applied this patch.

Thanks,
-Christoffer
