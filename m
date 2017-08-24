From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2 5/8] KVM: arm/arm64: vgic: Handle mapped level
 sensitive SPIs
Date: Thu, 24 Aug 2017 07:56:50 -0700
Message-ID: <20170824145650.GA2150@lvm>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-6-git-send-email-eric.auger@redhat.com>
 <f21e17b7-9437-ca96-6847-91e7ecee3af4@arm.com>
 <6a177b08-1871-c5b1-6ece-404017dfd23c@redhat.com>
 <20170721130331.GG16350@cbox>
 <b396c691-13d6-d17f-570e-7787970e759f@arm.com>
 <20170725144835.GD1588@lvm>
 <c2b481d0-3094-8a19-6257-da4927af014e@arm.com>
 <ea3d3821-a3ec-dae4-9633-0cbf65afe057@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ea3d3821-a3ec-dae4-9633-0cbf65afe057@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <cdall@linaro.org>, eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 22, 2017 at 04:35:26PM +0200, Auger Eric wrote:
> Hi,
> 
> On 25/07/2017 17:41, Marc Zyngier wrote:
> > On 25/07/17 15:48, Christoffer Dall wrote:
> >> On Tue, Jul 25, 2017 at 02:47:55PM +0100, Marc Zyngier wrote:
> >>> On 21/07/17 14:03, Christoffer Dall wrote:
> >>>> On Fri, Jul 07, 2017 at 09:41:42AM +0200, Auger Eric wrote:
> >>>>> Hi Marc,
> >>>>>
> >>>>> On 04/07/2017 14:15, Marc Zyngier wrote:
> >>>>>> Hi Eric,
> >>>>>>
> >>>>>> On 15/06/17 13:52, Eric Auger wrote:
> >>>>>>> Currently, the line level of unmapped level sensitive SPIs is
> >>>>>>> toggled down by the maintenance IRQ handler/resamplefd mechanism.
> >>>>>>>
> >>>>>>> As mapped SPI completion is not trapped, we cannot rely on this
> >>>>>>> mechanism and the line level needs to be observed at distributor
> >>>>>>> level instead.
> >>>>>>>
> >>>>>>> This patch handles the physical IRQ case in vgic_validate_injection
> >>>>>>> and get the line level of a mapped SPI at distributor level.
> >>>>>>>
> >>>>>>> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>>>>>>
> >>>>>>> ---
> >>>>>>>
> >>>>>>> v1 -> v2:
> >>>>>>> - renamed is_unshared_mapped into is_mapped_spi
> >>>>>>> - changes to kvm_vgic_map_phys_irq moved in the previous patch
> >>>>>>> - make vgic_validate_injection more readable
> >>>>>>> - reword the commit message
> >>>>>>> ---
> >>>>>>>  virt/kvm/arm/vgic/vgic.c | 16 ++++++++++++++--
> >>>>>>>  virt/kvm/arm/vgic/vgic.h |  7 ++++++-
> >>>>>>>  2 files changed, 20 insertions(+), 3 deletions(-)
> >>>>>>>
> >>>>>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >>>>>>> index 075f073..2e35ac7 100644
> >>>>>>> --- a/virt/kvm/arm/vgic/vgic.c
> >>>>>>> +++ b/virt/kvm/arm/vgic/vgic.c
> >>>>>>> @@ -139,6 +139,17 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>>>>>>  	kfree(irq);
> >>>>>>>  }
> >>>>>>>  
> >>>>>>> +bool irq_line_level(struct vgic_irq *irq)
> >>>>>>> +{
> >>>>>>> +	bool line_level = irq->line_level;
> >>>>>>> +
> >>>>>>> +	if (unlikely(is_mapped_spi(irq)))
> >>>>>>> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> >>>>>>> +					      IRQCHIP_STATE_PENDING,
> >>>>>>> +					      &line_level));
> >>>>>>> +	return line_level;
> >>>>>>> +}
> >>>>>>> +
> >>>>>>>  /**
> >>>>>>>   * kvm_vgic_target_oracle - compute the target vcpu for an irq
> >>>>>>>   *
> >>>>>>> @@ -236,13 +247,14 @@ static void vgic_sort_ap_list(struct kvm_vcpu *vcpu)
> >>>>>>>  
> >>>>>>>  /*
> >>>>>>>   * Only valid injection if changing level for level-triggered IRQs or for a
> >>>>>>> - * rising edge.
> >>>>>>> + * rising edge. Injection of virtual interrupts associated to physical
> >>>>>>> + * interrupts always is valid.
> >>>>>>>   */
> >>>>>>>  static bool vgic_validate_injection(struct vgic_irq *irq, bool level)
> >>>>>>>  {
> >>>>>>>  	switch (irq->config) {
> >>>>>>>  	case VGIC_CONFIG_LEVEL:
> >>>>>>> -		return irq->line_level != level;
> >>>>>>> +		return (irq->line_level != level || unlikely(is_mapped_spi(irq)));
> >>>>>>>  	case VGIC_CONFIG_EDGE:
> >>>>>>>  		return level;
> >>>>>>>  	}
> >>>>>>> diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> >>>>>>> index bba7fa2..da254ae 100644
> >>>>>>> --- a/virt/kvm/arm/vgic/vgic.h
> >>>>>>> +++ b/virt/kvm/arm/vgic/vgic.h
> >>>>>>> @@ -96,14 +96,19 @@
> >>>>>>>  /* we only support 64 kB translation table page size */
> >>>>>>>  #define KVM_ITS_L1E_ADDR_MASK		GENMASK_ULL(51, 16)
> >>>>>>>  
> >>>>>>> +bool irq_line_level(struct vgic_irq *irq);
> >>>>>>> +
> >>>>>>>  static inline bool irq_is_pending(struct vgic_irq *irq)
> >>>>>>>  {
> >>>>>>>  	if (irq->config == VGIC_CONFIG_EDGE)
> >>>>>>>  		return irq->pending_latch;
> >>>>>>>  	else
> >>>>>>> -		return irq->pending_latch || irq->line_level;
> >>>>>>> +		return irq->pending_latch || irq_line_level(irq);
> >>>>>>
> >>>>>> I'm a bit concerned that an edge interrupt doesn't take the distributor
> >>>>>> state into account here. Why is that so? Once an SPI is forwarded to a
> >>>>>> guest, a large part of the edge vs level differences move into the HW,
> >>>>>> and are not that different anymore from a SW PoV.
> >>>>>
> >>>>> As pointed out by Christoffer in https://lkml.org/lkml/2017/6/8/322,
> >>>>> isn't it a bit risky in general to poke the physical state instead of
> >>>>> the virtual state. For level sensitive, to me we don't really have many
> >>>>> other alternatives. For edge, we are not obliged to.
> >>>>
> >>>> I think we need to be clear on the fundamental question of whether or
> >>>> not we consider pending_latch and/or line_level for mapped interrupts.
> >>>>
> >>>> I can definitely see the argument that the pending state is kept in
> >>>> hardware, so if you want to know that for a mapped interrupt, ask the
> >>>> hardware.
> >>>>
> >>>> The upside of this appraoch is a clean separation of state and we avoid
> >>>> any logic to synchronize a virtual state with the physical state.
> >>>>
> >>>> The downside is that it's slower to peek into the physical GIC than to
> >>>> read a variable from memory, and we need to special case the validate
> >>>> path (which I now understand).
> >>>>
> >>>> If we move to keeping the state in HW, how do we deal with GICD_SPENDR ?
> >>>> Does that mean we will forward a from the VM handled by the VGIC to the
> >>>> physical GIC?
> >>>
> >>> Sounds like it to me. Otherwise, we start loosing some state. 
> >>
> >> How do we loose state?  Is it not more a question of complexity to make
> >> sure the 'cached' vgic state is up to date with the real state?  (like
> >> what we currently do for the timer mapped interrupt).
> > 
> > Sorry, I was very imprecise here. It is not so much that we'd loose
> > state, but that we'd have some state at the wrong location. If we have a
> > guest playing with the pending state, we need to make sure the physical
> > side is up to date. Otherwise, we can end-up in situations where we'd
> > inject an interrupt for the guest based on a pending state that only
> > exists in the virtual distributor, and yet the virtual CPUIF is going to
> > try and deactivate it in the physical side on EOI.
> 
> At the moment the write to GICD_ISPENDR (vgic_mmio_write_spending) sets
> the pending_latch virtual state.
> 
> and the read uses irq_is_pending() new wrapper which looks at both the
> physical state and the pending_latch virtual state in case of physically
> mapped irq (irq_is_pending).
> 
> But As Marc mentioned, as I don't propagate the pending_latch to the
> physical distributor, effectively we can have a guest "DIR" that tries
> to complete a physical IRQ that is not active and that's wrong.
> 
> > 
> >> On GICv2 this is likely going to make injecting timer interrupts slower,
> >> because we'll check the pending state of whatever's in the AP list on
> >> entry to the guest and peek into the physical GIC again.
> aren't timer interrupts PPIs? My series only affect the state machine
> for physically mapped SPIs so this shouldn't have any impact, no?
> 
That's true.  I guess we got lucky.

Thanks,
-Christoffer
