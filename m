From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH 2/4] KVM: arm/arm64: vgic: Support level-triggered
 mapped interrupts
Date: Wed, 30 Aug 2017 14:03:02 +0200
Message-ID: <20170830120302.GH24522@cbox>
References: <20170829093902.15379-1-cdall@linaro.org>
 <20170829093902.15379-3-cdall@linaro.org>
 <428bb30a-4d3d-d983-e1d1-8f160da846c5@redhat.com>
 <20170830092026.GC24522@cbox>
 <c1a89a51-2869-5f16-a971-071146fa2c18@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c1a89a51-2869-5f16-a971-071146fa2c18@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 12:13:32PM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 30/08/2017 11:20, Christoffer Dall wrote:
> > On Wed, Aug 30, 2017 at 10:19:38AM +0200, Auger Eric wrote:
> >> Hi Christoffer,
> >>
> >> On 29/08/2017 11:39, Christoffer Dall wrote:
> >>> Level-triggered mapped IRQs are special because we only observe rising
> >>> edges as input to the VGIC, and we don't set the EOI flag and therefore
> >>> are not told when the level goes down, so that we can re-queue a new
> >>> interrupt when the level goes up.
> >>>
> >>> One way to solve this problem is to side-step the logic of the VGIC and
> >>> special case the validation in the injection path, but it has the
> >>> unfortunate drawback of having to peak into the physical GIC state
> >>> whenever we want to know if the interrupt is pending on the virtual
> >>> distributor.
> >>>
> >>> Instead, we can maintain the current semantics of a level triggered
> >>> interrupt by sort of treating it as an edge-triggered interrupt,
> >>> following from the fact that we only observe an asserting edge.  This
> >>> requires us to be a bit careful when populating the LRs and when folding
> >>> the state back in though:
> >>>
> >>>  * We lower the line level when populating the LR, so that when
> >>>    subsequently observing an asserting edge, the VGIC will do the right
> >>>    thing.
> >>>
> >>>  * If the guest never acked the interrupt while running (for example if
> >>>    it had masked interrupts at the CPU level while running), we have
> >>>    to preserve the pending state of the LR and move it back to the
> >>>    line_level field of the struct irq when folding LR state.
> >>>
> >>>    If the guest never acked the interrupt while running, but changed the
> >>>    device state and lowered the line (again with interrupts masked) then
> >>>    we need to observe this change in the line_level.
> >>>
> >>>    Both of the above situations are solved by sampling the physical line
> >>>    and set the line level when folding the LR back.
> >>>
> >>>  * Finally, if the guest never acked the interrupt while running and
> >>>    sampling the line reveals that the device state has changed and the
> >>>    line has been lowered, we must clear the physical active state, since
> >>>    we will otherwise never be told when the interrupt becomes asserted
> >>>    again.
> >>>
> >>> This has the added benefit of making the timer optimization patches
> >>> (https://lists.cs.columbia.edu/pipermail/kvmarm/2017-July/026343.html) a
> >>> bit simpler, because the timer code doesn't have to clear the active
> >>> state on the sync anymore.  It also potentially improves the performance
> >>> of the timer implementation because the GIC knows the state or the LR
> >>> and only needs to clear the
> >>> active state when the pending bit in the LR is still set, where the
> >>> timer has to always clear it when returning from running the guest with
> >>> an injected timer interrupt.
> >>>
> >>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> >>> ---
> >>>  virt/kvm/arm/vgic/vgic-v2.c | 29 +++++++++++++++++++++++++++++
> >>>  virt/kvm/arm/vgic/vgic-v3.c | 29 +++++++++++++++++++++++++++++
> >>>  virt/kvm/arm/vgic/vgic.c    | 23 +++++++++++++++++++++++
> >>>  virt/kvm/arm/vgic/vgic.h    |  7 +++++++
> >>>  4 files changed, 88 insertions(+)
> >>>
> >>> diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> >>> index e4187e5..f7c5cb5 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-v2.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-v2.c
> >>> @@ -104,6 +104,26 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
> >>>  				irq->pending_latch = false;
> >>>  		}
> >>>  
> >>> +		/*
> >>> +		 * Level-triggered mapped IRQs are special because we only
> >>> +		 * observe rising edges as input to the VGIC.
> >>> +		 *
> >>> +		 * If the guest never acked the interrupt we have to sample
> >>> +		 * the physical line and set the line level, because the
> >>> +		 * device state could have changed or we simply need to
> >>> +		 * process the still pending interrupt later.
> >>> +		 *
> >>> +		 * If this causes us to lower the level, we have to also clear
> >>> +		 * the physical active state, since we will otherwise never be
> >>> +		 * told when the interrupt becomes asserted again.
> >>> +		 */
> >>> +		if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT)) {
> >>> +			irq->line_level = vgic_irq_line_level(irq);
> >>> +
> >>> +			if (!irq->line_level)
> >>> +				vgic_irq_clear_phys_active(irq);
> >>> +		}
> >>> +
> >>>  		spin_unlock(&irq->irq_lock);
> >>>  		vgic_put_irq(vcpu->kvm, irq);
> >>>  	}
> >>> @@ -161,6 +181,15 @@ void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr)
> >>>  			val |= GICH_LR_EOI;
> >>>  	}
> >>>  
> >>> +	/*
> >>> +	 * Level-triggered mapped IRQs are special because we only observe
> >>> +	 * rising edges as input to the VGIC.  We therefore lower the line
> >>> +	 * level here, so that we can take new virtual IRQs.  See
> >>> +	 * vgic_v2_fold_lr_state for more info.
> >>> +	 */
> >>> +	if (vgic_irq_is_mapped_level(irq) && (val & GICH_LR_PENDING_BIT))
> >>> +		irq->line_level = false;
> >>> +
> >>>  	/* The GICv2 LR only holds five bits of priority. */
> >>>  	val |= (irq->priority >> 3) << GICH_LR_PRIORITY_SHIFT;
> >>>  
> >>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >>> index 96ea597..e377036 100644
> >>> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >>> @@ -94,6 +94,26 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
> >>>  				irq->pending_latch = false;
> >>>  		}
> >>>  
> >>> +		/*
> >>> +		 * Level-triggered mapped IRQs are special because we only
> >>> +		 * observe rising edges as input to the VGIC.
> >>> +		 *
> >>> +		 * If the guest never acked the interrupt we have to sample
> >>> +		 * the physical line and set the line level, because the
> >>> +		 * device state could have changed or we simply need to
> >>> +		 * process the still pending interrupt later.
> >>> +		 *
> >>> +		 * If this causes us to lower the level, we have to also clear
> >>> +		 * the physical active state, since we will otherwise never be
> >>> +		 * told when the interrupt becomes asserted again.
> >>> +		 */
> >>> +		if (vgic_irq_is_mapped_level(irq) && (val & ICH_LR_PENDING_BIT)) {
> >>> +			irq->line_level = vgic_irq_line_level(irq);
> >>
> >> I don't see anything related to the GICD_ISPENDING/ICPENDING.
> > 
> > vgic_irq_line_level() reads GICD_ISPEND.  Not sure what you mean?
> > 
> >> In the
> >> last thread, we said we were obliged to set the pending bit on the
> >> physical distributor to avoid the guest deactivating a non active
> >> physical IRQ.
> > 
> > Did we?  I don't remember this, and this doesn't make sense to me.  The
> > only constraint I think we have is that when setting the HW bit in the
> > LR, the interrupt must be active on the physical side, so that a
> > deactivate by the guest is also a deactivate on the physical side.
> 
> That what I understood from this thread:
> https://lkml.org/lkml/2017/7/25/534

Right, but that was specific to how we handle the guest writing to
PEND/ACT on the virtual distributor.

> 
> At the moment the LR HW bit is set whatever the source of the IRQ I
> think, HW driven or ISPENDRn driven (we only test irq->hw)
> 

Ah, I didn't actually consider that we could special-case the
pending_latch for a HW interrupt.  I suppose we should actually consider
that if someone tries to map an edge-triggered SPI.  Let me have a look
at that.

> 
> > 
> >> If we still intend to do so, with that addition, aren't we
> >> likely to deactivate the physical IRQ before the guest?
> > 
> > Do you mean if it's pending+active in the LR?  That can never happen for
> > a mapped (HW bit set) interrupt.
> > 
> > So this particular code sequence means that
> >     (val & ICH_LR_STATE) == ICH_LR_PENDING_BIT
> > 
> > and we never clear the physical active state while the virtual interrupt
> > is active.
> 
> No my scenario was:
> IRQ originates from a ISPENDRn.

virtual IRQ from a write to the VGIC ISPENDRn, correct?

> I Thought we set the physical
> distributor state accordingly. pIRQ is active. vIRQ is pending. On fold
> we detect the line is low and we deactivate the pIRQ. pending_latch is
> still true. The vIRQ will be processed but its physical IRQ has been
> deactivated.
> 

As long as we properly handle pending_latch and guest writes to the VGIC
PEND/ACT registers, I don't see a problem with this code.

> > There is an interesting point in terms of handling guest accesses to the
> > virtual distributor GICD_ISPENDR, GICD_ICPENDR, GICD_ISACTIVER, and
> > GICD_ICACTIVER where we must also propogate those changes to the
> > physical side.
> > 
> > Was this what you meant?
> yes I think we also need to address this to get the whole picture.
> 

Yes, I'll respin.

Thanks,
-Christoffer
