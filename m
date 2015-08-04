From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 11/11] KVM: arm/arm64: vgic: Allow HW interrupts for
 non-shared devices
Date: Tue, 4 Aug 2015 20:07:49 +0200
Message-ID: <20150804180749.GJ29335@cbox>
References: <1437753309-17989-1-git-send-email-marc.zyngier@arm.com>
 <1437753309-17989-12-git-send-email-marc.zyngier@arm.com>
 <20150804143209.GD29335@cbox> <55C0F1A5.1070204@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D643459FB9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 13:54:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JptvOlwU-fQU for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Aug 2015 13:54:21 -0400 (EDT)
Received: from mail-la0-f46.google.com (mail-la0-f46.google.com
 [209.85.215.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 726A159B51
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Aug 2015 13:54:21 -0400 (EDT)
Received: by lady2 with SMTP id y2so8906935lad.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Aug 2015 11:07:06 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55C0F1A5.1070204@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, Andre Przywara <Andre.Przywara@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 04, 2015 at 06:08:53PM +0100, Marc Zyngier wrote:
> On 04/08/15 15:32, Christoffer Dall wrote:
> > On Fri, Jul 24, 2015 at 04:55:09PM +0100, Marc Zyngier wrote:
> >> So far, the only use of the HW interrupt facility is the timer,
> >> implying that the active state is context-switched for each vcpu,
> >> as the device is is shared across all vcpus.
> >>
> >> This does not work for a device that has been assigned to a VM,
> >> as the guest is entierely in control of that device (the HW is
> >> not shared). In that case, it makes sense to bypass the whole
> >> active state switching, and only track the deactivation of the
> >> interrupt.
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  include/kvm/arm_vgic.h    |  6 ++--
> >>  virt/kvm/arm/arch_timer.c |  3 +-
> >>  virt/kvm/arm/vgic.c       | 73 +++++++++++++++++++++++++++++++++++++----------
> >>  3 files changed, 64 insertions(+), 18 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index f6bfd79..6f0a4e1 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -164,7 +164,8 @@ struct irq_phys_map {
> >>  	u32			phys_irq;
> >>  	u32			irq;
> >>  	bool			deleted;
> >> -	bool			active;
> >> +	bool			shared;
> >> +	bool			active; /* Only valid if shared */
> >>  };
> >>  
> >>  struct irq_phys_map_entry {
> >> @@ -357,7 +358,8 @@ void vgic_v3_dispatch_sgi(struct kvm_vcpu *vcpu, u64 reg);
> >>  int kvm_vgic_vcpu_pending_irq(struct kvm_vcpu *vcpu);
> >>  int kvm_vgic_vcpu_active_irq(struct kvm_vcpu *vcpu);
> >>  struct irq_phys_map *kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu,
> >> -					   int virt_irq, int irq);
> >> +					   int virt_irq, int irq,
> >> +					   bool shared);
> >>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> >>  bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
> >>  void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 76e38d2..db21d8f 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -203,7 +203,8 @@ int kvm_timer_vcpu_reset(struct kvm_vcpu *vcpu,
> >>  	 * Tell the VGIC that the virtual interrupt is tied to a
> >>  	 * physical interrupt. We do that once per VCPU.
> >>  	 */
> >> -	map = kvm_vgic_map_phys_irq(vcpu, irq->irq, host_vtimer_irq);
> >> +	map = kvm_vgic_map_phys_irq(vcpu, irq->irq,
> >> +				    host_vtimer_irq, true);
> >>  	if (WARN_ON(IS_ERR(map)))
> >>  		return PTR_ERR(map);
> >>  
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index e40ef70..5e6b816 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -1128,19 +1128,25 @@ static void vgic_queue_irq_to_lr(struct kvm_vcpu *vcpu, int irq,
> >>  		 * active in the physical world. Otherwise the
> >>  		 * physical interrupt will fire and the guest will
> >>  		 * exit before processing the virtual interrupt.
> >> +		 *
> >> +		 * This is of course only valid for a shared
> >> +		 * interrupt. A non shared interrupt should already be
> >> +		 * active.
> >>  		 */
> >>  		if (map) {
> >> -			int ret;
> >> -
> >> -			BUG_ON(!map->active);
> >>  			vlr.hwirq = map->phys_irq;
> >>  			vlr.state |= LR_HW;
> >>  			vlr.state &= ~LR_EOI_INT;
> >>  
> >> -			ret = irq_set_irqchip_state(map->irq,
> >> -						    IRQCHIP_STATE_ACTIVE,
> >> -						    true);
> >> -			WARN_ON(ret);
> >> +			if (map->shared) {
> >> +				int ret;
> >> +
> >> +				BUG_ON(!map->active);
> >> +				ret = irq_set_irqchip_state(map->irq,
> >> +							    IRQCHIP_STATE_ACTIVE,
> >> +							    true);
> >> +				WARN_ON(ret);
> >> +			}
> >>  
> >>  			/*
> >>  			 * Make sure we're not going to sample this
> >> @@ -1383,21 +1389,41 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
> >>  static int vgic_sync_hwirq(struct kvm_vcpu *vcpu, struct vgic_lr vlr)
> >>  {
> >>  	struct irq_phys_map *map;
> >> +	bool active;
> >>  	int ret;
> >>  
> >>  	if (!(vlr.state & LR_HW))
> >>  		return 0;
> >>  
> >>  	map = vgic_irq_map_search(vcpu, vlr.irq);
> >> -	BUG_ON(!map || !map->active);
> >> +	BUG_ON(!map);
> >> +	BUG_ON(map->shared && !map->active);
> >>  
> >>  	ret = irq_get_irqchip_state(map->irq,
> >>  				    IRQCHIP_STATE_ACTIVE,
> >> -				    &map->active);
> >> +				    &active);
> >>  
> >>  	WARN_ON(ret);
> >>  
> >> -	if (map->active) {
> >> +	/*
> >> +	 * For a non-shared interrupt, we have to cater for two
> >> +	 * possible deactivation conditions:
> >> +	 *
> >> +	 * - the physical interrupt is now inactive (EOIed from the
> >> +         *   guest)
> > 
> > nit: whitespace funkyness
> > 
> >> +	 * - the physical interrupt is still active, but its virtual
> >> +	 *   counterpart is flagged as "not queued", indicating another
> >> +	 *   interrupt has fired between the EOI and the guest exit.
> >> +	 *
> >> +	 * Also, we are not reactivating a non-shared interrupt
> > 
> > what does reactivating mean? did you mean deactivate?
> 
> Deactivate indeed.
> 
> >> +	 * ourselves. This is always left to the guest.
> > 
> > In which case, add ", because the device is solely owned by the guest."
> 
> Sure.
> 
> >> +	 */
> >> +	if (!map->shared)
> >> +		return !active || !vgic_irq_is_queued(vcpu, vlr.irq);
> > 
> > do you really need the second part of the disjunction?
> > 
> > The effect seems to be that we clear the queued flag once again, and
> > clear the LR.  If we don't do this, won't we simply pick up the pending
> > flag next time we're about to run this VCPU and piggy-back on the
> > existing LR.  Perhaps this is a weird flow though?
> 
> Crucially, we free the LR in this case (the set_bit on elrsr_ptr). If we
> don't do this, we're indeed going to schedule the vcpu (it has something
> to process), but we never allow piggy-backing on level interrupts. We'd
> need some special hack to handle this.
> 
> I definitely feel more comfortable reporting that the interrupt has been
> deactivated (which is the case), and let the normal flow pick up the
> next injected interrupt.
> 
Yes, you're right, it's much better this way.

I assume you'll still wait with this stuff until the priority drop / EOI
stuff is in, so I'll do a formal review again once all the dependencies
are there.

But this looks good to me.

-Christoffer
