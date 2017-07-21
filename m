From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Fri, 21 Jul 2017 15:03:31 +0200
Message-ID: <20170721130331.GG16350@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
 <f21e17b7-9437-ca96-6847-91e7ecee3af4@arm.com>
 <6a177b08-1871-c5b1-6ece-404017dfd23c@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6a177b08-1871-c5b1-6ece-404017dfd23c@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Jul 07, 2017 at 09:41:42AM +0200, Auger Eric wrote:
> Hi Marc,
> 
> On 04/07/2017 14:15, Marc Zyngier wrote:
> > Hi Eric,
> > 
> > On 15/06/17 13:52, Eric Auger wrote:
> >> Currently, the line level of unmapped level sensitive SPIs is
> >> toggled down by the maintenance IRQ handler/resamplefd mechanism.
> >>
> >> As mapped SPI completion is not trapped, we cannot rely on this
> >> mechanism and the line level needs to be observed at distributor
> >> level instead.
> >>
> >> This patch handles the physical IRQ case in vgic_validate_injection
> >> and get the line level of a mapped SPI at distributor level.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v1 -> v2:
> >> - renamed is_unshared_mapped into is_mapped_spi
> >> - changes to kvm_vgic_map_phys_irq moved in the previous patch
> >> - make vgic_validate_injection more readable
> >> - reword the commit message
> >> ---
> >>  virt/kvm/arm/vgic/vgic.c | 16 ++++++++++++++--
> >>  virt/kvm/arm/vgic/vgic.h |  7 ++++++-
> >>  2 files changed, 20 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index 075f073..2e35ac7 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -139,6 +139,17 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>  	kfree(irq);
> >>  }
> >>  
> >> +bool irq_line_level(struct vgic_irq *irq)
> >> +{
> >> +	bool line_level = irq->line_level;
> >> +
> >> +	if (unlikely(is_mapped_spi(irq)))
> >> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> >> +					      IRQCHIP_STATE_PENDING,
> >> +					      &line_level));
> >> +	return line_level;
> >> +}
> >> +
> >>  /**
> >>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
> >>   *
> >> @@ -236,13 +247,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
> >>  
> >>  /*
> >>   * Only valid injection if changing level for level-triggered IRQs or for a
> >> - * rising edge.
> >> + * rising edge. Injection of virtual interrupts associated to physical
> >> + * interrupts always is valid.
> >>   */
> >>  static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
> >>  {
> >>  	switch (irq->config) {
> >>  	case VGIC_CONFIG_LEVEL:
> >> -		return irq->line_level != level;
> >> +		return (irq->line_level != level || unlikely(is_mapped_spi(irq)));
> >>  	case VGIC_CONFIG_EDGE:
> >>  		return level;
> >>  	}
> >> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> >> index bba7fa2..da254ae 100644
> >> --- a/virt/kvm/arm/vgic/vgic.h
> >> +++ b/virt/kvm/arm/vgic/vgic.h
> >> @@ -96,14 +96,19 @@
> >>  /* we only support 64 kB translation table page size */
> >>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
> >>  
> >> +bool irq_line_level(struct vgic_irq *irq);
> >> +
> >>  static inline bool irq_is_pending(struct vgic_irq *irq)
> >>  {
> >>  	if (irq->config == VGIC_CONFIG_EDGE)
> >>  		return irq->pending_latch;
> >>  	else
> >> -		return irq->pending_latch || irq->line_level;
> >> +		return irq->pending_latch || irq_line_level(irq);
> > 
> > I'm a bit concerned that an edge interrupt doesn't take the distributor
> > state into account here. Why is that so? Once an SPI is forwarded to a
> > guest, a large part of the edge vs level differences move into the HW,
> > and are not that different anymore from a SW PoV.
> 
> As pointed out by Christoffer in https://lkml.org/lkml/2017/6/8/322,
> isn't it a bit risky in general to poke the physical state instead of
> the virtual state. For level sensitive, to me we don't really have many
> other alternatives. For edge, we are not obliged to.

I think we need to be clear on the fundamental question of whether or
not we consider pending_latch and/or line_level for mapped interrupts.

I can definitely see the argument that the pending state is kept in
hardware, so if you want to know that for a mapped interrupt, ask the
hardware.

The upside of this appraoch is a clean separation of state and we avoid
any logic to synchronize a virtual state with the physical state.

The downside is that it's slower to peek into the physical GIC than to
read a variable from memory, and we need to special case the validate
path (which I now understand).

If we move to keeping the state in HW, how do we deal with GICD_SPENDR ?
Does that mean we will forward a from the VM handled by the VGIC to the
physical GIC?

> 
> Don't we have situations, due to the lazy disable approach, where the
> physical IRQ hits, enters the genirq handler and the actual handler is
> not called, ie. the virtual IRQ is not injected?
> 

I'm not sure I remember what these situations were, specifically, but
certainly if we ever have a situation where a mapped irq's pending state
should be different from that of the physical one, then it doesn't work.

Thanks,
-Christoffer
