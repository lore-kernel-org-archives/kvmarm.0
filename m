From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [RFC PATCH 2/4] KVM: arm/arm64: vgic: Support level-triggered
 mapped interrupts
Date: Sat, 02 Sep 2017 12:04:06 +0100
Message-ID: <867exhuztl.fsf@arm.com>
References: <20170829093902.15379-1-cdall@linaro.org>
 <20170829093902.15379-3-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C127049C13
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Sep 2017 07:01:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id C0+BIL2qxop2 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  2 Sep 2017 07:01:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7178740C5A
 for <kvmarm@lists.cs.columbia.edu>; Sat,  2 Sep 2017 07:01:54 -0400 (EDT)
In-Reply-To: <20170829093902.15379-3-cdall@linaro.org> (Christoffer Dall's
 message of "Tue, 29 Aug 2017 11:39:00 +0200")
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 29 2017 at 11:39:00 am BST, Christoffer Dall <cdall@linaro.org> wrote:
> Level-triggered mapped IRQs are special because we only observe rising
> edges as input to the VGIC, and we don't set the EOI flag and therefore
> are not told when the level goes down, so that we can re-queue a new
> interrupt when the level goes up.
>
> One way to solve this problem is to side-step the logic of the VGIC and
> special case the validation in the injection path, but it has the
> unfortunate drawback of having to peak into the physical GIC state
> whenever we want to know if the interrupt is pending on the virtual
> distributor.
>
> Instead, we can maintain the current semantics of a level triggered
> interrupt by sort of treating it as an edge-triggered interrupt,
> following from the fact that we only observe an asserting edge.  This
> requires us to be a bit careful when populating the LRs and when folding
> the state back in though:
>
>  * We lower the line level when populating the LR, so that when
>    subsequently observing an asserting edge, the VGIC will do the right
>    thing.
>
>  * If the guest never acked the interrupt while running (for example if
>    it had masked interrupts at the CPU level while running), we have
>    to preserve the pending state of the LR and move it back to the
>    line_level field of the struct irq when folding LR state.
>
>    If the guest never acked the interrupt while running, but changed the
>    device state and lowered the line (again with interrupts masked) then
>    we need to observe this change in the line_level.
>
>    Both of the above situations are solved by sampling the physical line
>    and set the line level when folding the LR back.
>
>  * Finally, if the guest never acked the interrupt while running and
>    sampling the line reveals that the device state has changed and the
>    line has been lowered, we must clear the physical active state, since
>    we will otherwise never be told when the interrupt becomes asserted
>    again.
>
> This has the added benefit of making the timer optimization patches
> (https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026343.html) a
> bit simpler, because the timer code doesn't have to clear the active
> state on the sync anymore.  It also potentially improves the performance
> of the timer implementation because the GIC knows the state or the LR
> and only needs to clear the
> active state when the pending bit in the LR is still set, where the
> timer has to always clear it when returning from running the guest with
> an injected timer interrupt.
>
> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> ---
>  virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic-v3.c | 29 +++++++++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.c    | 23 +++++++++++++++++++++++
>  virt/kvm/arm/vgic/vgic.h    |  7 +++++++
>  4 files changed, 88 insertions(+)
>
> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> index e4187e5..f7c5cb5 100644
> --- a/virt/kvm/arm/vgic/vgic-v2.c
> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> @@ -104,6 +104,26 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
>  				irq->pending_latch = false;
>  		}
>  
> +		/*
> +		 * Level-triggered mapped IRQs are special because we only
> +		 * observe rising edges as input to the VGIC.
> +		 *
> +		 * If the guest never acked the interrupt we have to sample
> +		 * the physical line and set the line level, because the
> +		 * device state could have changed or we simply need to
> +		 * process the still pending interrupt later.
> +		 *
> +		 * If this causes us to lower the level, we have to also clear
> +		 * the physical active state, since we will otherwise never be
> +		 * told when the interrupt becomes asserted again.
> +		 */
> +		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {

I've just had a worrying though. Here, we're looking at the guest's view
of the trigger. But shouldn't that be the *host's*? We're assuming that
the two should match, and while they certainly do for the timer, this is
not something that can be enforced for SPIs.

What do you think?

	M.
-- 
Jazz is not dead. It just smells funny.
