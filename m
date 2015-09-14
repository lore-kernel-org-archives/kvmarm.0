From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 09/10] KVM: arm/arm64: vgic: forwarding control
Date: Mon, 14 Sep 2015 13:24:12 +0200
Message-ID: <20150914112412.GG15712@cbox>
References: <1439212864-12954-1-git-send-email-eric.auger@linaro.org>
 <1439212864-12954-10-git-send-email-eric.auger@linaro.org>
 <20150902195825.GW10991@cbox> <55F6937E.2060605@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5038C412EF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:21:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 20aNr+b63hjW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Sep 2015 07:21:37 -0400 (EDT)
Received: from mail-lb0-f172.google.com (mail-lb0-f172.google.com
 [209.85.217.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6ED9C41291
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 07:21:37 -0400 (EDT)
Received: by lbcao8 with SMTP id ao8so65377751lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Sep 2015 04:22:29 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <55F6937E.2060605@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, feng.wu@intel.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 14, 2015 at 11:29:34AM +0200, Eric Auger wrote:
> Christoffer,
> On 09/02/2015 09:58 PM, Christoffer Dall wrote:
> > On Mon, Aug 10, 2015 at 03:21:03PM +0200, Eric Auger wrote:
> >> Implements kvm_vgic_[set|unset]_forward.
> >>
> >> Handle low-level VGIC programming: physical IRQ/guest IRQ mapping,
> >> list register cleanup, VGIC state machine. Also interacts with
> >> the irqchip.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >>
> >> ---
> >>
> >> v2 -> v3:
> >> - on unforward, we do not compute & output the active state anymore.
> >>   This means if the unforward happens while the physical IRQ is
> >>   active, we will not VFIO mask the IRQ while deactiving it. If a
> >>   new physical IRQ hits, the corresponding virtual IRQ might not
> >>   be injected (hence lost) due to VGIC state machine.
> >>
> >> bypass rfc v2:
> >> - use irq_set_vcpu_affinity API
> >> - use irq_set_irqchip_state instead of chip->irq_eoi
> >>
> >> bypass rfc:
> >> - rename kvm_arch_{set|unset}_forward into
> >>   kvm_vgic_{set|unset}_forward. Remove __KVM_HAVE_ARCH_HALT_GUEST.
> >>   The function is bound to be called by ARM code only.
> >>
> >> v4 -> v5:
> >> - fix arm64 compilation issues, ie. also defines
> >>   __KVM_HAVE_ARCH_HALT_GUEST for arm64
> >>
> >> v3 -> v4:
> >> - code originally located in kvm_vfio_arm.c
> >> - kvm_arch_vfio_{set|unset}_forward renamed into
> >>   kvm_arch_{set|unset}_forward
> >> - split into 2 functions (set/unset) since unset does not fail anymore
> >> - unset can be invoked at whatever time. Extra care is taken to handle
> >>   transition in VGIC state machine, LR cleanup, ...
> >>
> >> v2 -> v3:
> >> - renaming of kvm_arch_set_fwd_state into kvm_arch_vfio_set_forward
> >> - takes a bool arg instead of kvm_fwd_irq_action enum
> >> - removal of KVM_VFIO_IRQ_CLEANUP
> >> - platform device check now happens here
> >> - more precise errors returned
> >> - irq_eoi handled externally to this patch (VGIC)
> >> - correct enable_irq bug done twice
> >> - reword the commit message
> >> - correct check of platform_bus_type
> >> - use raw_spin_lock_irqsave and check the validity of the handler
> >> ---
> >>  include/kvm/arm_vgic.h |   6 ++
> >>  virt/kvm/arm/vgic.c    | 149 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 155 insertions(+)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index 7ef9ce0..409ac0f 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -363,6 +363,12 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, struct irq_phys_map *map);
> >>  bool kvm_vgic_get_phys_irq_active(struct irq_phys_map *map);
> >>  void kvm_vgic_set_phys_irq_active(struct irq_phys_map *map, bool active);
> >>  
> >> +int kvm_vgic_set_forward(struct kvm *kvm,
> >> +			 unsigned int host_irq, unsigned int guest_irq);
> >> +
> >> +void kvm_vgic_unset_forward(struct kvm *kvm,
> >> +			    unsigned int host_irq, unsigned int guest_irq);
> >> +
> >>  #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
> >>  #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
> >>  #define vgic_ready(k)		((k)->arch.vgic.ready)
> >> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> >> index 03a85b3..b15999a 100644
> >> --- a/virt/kvm/arm/vgic.c
> >> +++ b/virt/kvm/arm/vgic.c
> >> @@ -2551,3 +2551,152 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> >>  {
> >>  	return 0;
> >>  }
> >> +
> >> +/**
> >> + * kvm_vgic_set_forward - Set IRQ forwarding
> >> + *
> >> + * @kvm: handle to the VM
> >> + * @host_irq: physical IRQ number
> >> + * @guest_irq: virtual IRQ number
> >> + *
> >> + * This function is supposed to be called only if the IRQ
> >> + * is not in progress: ie. not active at GIC level and not
> >> + * currently under injection in the guest. The physical IRQ must
> >> + * also be disabled and the guest must have been exited and
> > 
> > when you say the guest you mean all VCPUs, right?
> 
> yes that's correct.
> > 
> >> + * prevented from being re-entered.
> >> + */
> >> +int kvm_vgic_set_forward(struct kvm *kvm,
> >> +			 unsigned int host_irq,
> >> +			 unsigned int guest_irq)
> >> +{
> >> +	struct irq_phys_map *map = NULL;
> >> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
> >> +	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
> >> +
> >> +	kvm_debug("%s host_irq=%d guest_irq=%d\n",
> >> +		__func__, host_irq, guest_irq);
> >> +
> >> +	if (!vcpu)
> >> +		return 0;
> >> +
> >> +	irq_set_vcpu_affinity(host_irq, vcpu);
> > 
> > why are we hard-coding this to vcpu 0 ?
> is that OK if I use dist->irq_spi_target[guest_irq]

I would think so, yes.  Be careful about locking/barriers and
initialization, though.

> > 
> > missing white space before the code block.  Where does the code block
> > belong exactly?
> > 
> >> +	/*
> >> +	 * next physical IRQ will be be handled as forwarded
> > 
> > what do you mean with 'next' here?
> I mean the next occurrence of the same physical IRQ

Then I suggest wording it something like:

>From this point, this physical IRQ will be handled as forwarded.

> > 
> >> +	 * by the host (priority drop only)
> >> +	 */
> >> +
> >> +	map = kvm_vgic_map_phys_irq(vcpu, spi_id, host_irq, false);
> >> +	/*
> >> +	 * next guest_irq injection will be considered as
> >> +	 * forwarded and next flush will program LR
> >> +	 * without maintenance IRQ but with HW bit set
> >> +	 */
> > 
> > also here, I don't understand what you mean by next.
> I meant the next occurrence of the same IRQ injection into the guest

hmm, I find it a little hard to understand.

> > 
> > Perhaps these comments were supposed to come before the function calls?
> OK I see what you mean, I will rephrase to set comments before the
> function calls.

Sounds good, I'll have a look when it has been reworked.

> > 
> >> +	return !map;
> >> +}
> >> +
> >> +/**
> >> + * kvm_vgic_unset_forward - Unset IRQ forwarding
> >> + *
> >> + * @kvm: handle to the VM
> >> + * @host_irq: physical IRQ number
> >> + * @guest_irq: virtual IRQ number
> >> + *
> >> + * This function must be called when the host_irq is disabled
> >> + * and guest has been exited and prevented from being re-entered.
> >> + *
> > 
> > extra white space here
> OK
> > 
> >> + */
> >> +void kvm_vgic_unset_forward(struct kvm *kvm,
> >> +			    unsigned int host_irq,
> >> +			    unsigned int guest_irq)
> >> +{
> >> +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
> >> +	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >> +	struct vgic_dist *dist = &kvm->arch.vgic;
> >> +	int ret, lr;
> >> +	struct vgic_lr vlr;
> >> +	int spi_id = guest_irq + VGIC_NR_PRIVATE_IRQS;
> >> +	bool queued = false, needs_deactivate = true;
> >> +	struct irq_phys_map *map;
> >> +	bool active;
> >> +
> >> +	kvm_debug("%s host_irq=%d guest_irq=%d\n",
> >> +		__func__, host_irq, guest_irq);
> >> +
> >> +	spin_lock(&dist->lock);
> >> +
> >> +	irq_get_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, &active);
> >> +
> >> +	if (!vcpu)
> >> +		goto out;
> >> +
> >> +	map = vgic_irq_map_search(vcpu, spi_id);
> >> +	BUG_ON(!map);
> >> +	ret = kvm_vgic_unmap_phys_irq(vcpu, map);
> >> +	BUG_ON(ret);
> >> +	/*
> >> +	 * subsequent update_irq_pending or flush will handle this
> >> +	 * irq as not forwarded
> >> +	 */
> > 
> > missing white space before this comment block as well, also here with
> > 'subsequent' do you mean "At this point" ?
> I mean any new execution of update_irq_pending/flush will handle this
> irq as not forwarded. Since the state machine for forwarded IRQ and non
> forwarded IRQ is different, we need to convert the states into the new
> state machine's ones.

Ok, perhaps this comment is more clear if it simply states:

At this point the IRQ is marked as non-forwarded.

> > 
> >> +	if (likely(!(active))) {
> >> +		/*
> >> +		 * the IRQ was not active. let's simply prepare the states
> >> +		 * for subsequent non forwarded injection.
> >> +		 */
> >> +		vgic_dist_irq_clear_level(vcpu, spi_id);
> >> +		vgic_dist_irq_clear_pending(vcpu, spi_id);
> >> +		vgic_irq_clear_queued(vcpu, spi_id);
> >> +		needs_deactivate = false;
> >> +		goto out;
> >> +	}
> >> +
> >> +	/* is there any list register with valid state? */
> >> +	lr = vgic_cpu->vgic_irq_lr_map[spi_id];
> >> +	if (lr != LR_EMPTY) {
> >> +		vlr = vgic_get_lr(vcpu, lr);
> >> +		if (vlr.state & LR_STATE_MASK)
> >> +			queued = true;
> >> +	}
> >> +
> >> +	if (!queued) {
> >> +		vgic_irq_clear_queued(vcpu, spi_id);
> >> +		if (vgic_dist_irq_is_pending(vcpu, spi_id)) {
> >> +			/*
> >> +			 * IRQ is injected but not yet queued. LR will be
> >> +			 * written with EOI_INT and process_maintenance will
> >> +			 * reset the states: queued, level(resampler). Pending
> >> +			 * will be reset on flush.
> >> +			 */
> >> +			vgic_dist_irq_set_level(vcpu, spi_id);
> > 
> > so this is all only valid for level-triggered interrupts?  Do we check
> > this somewhere along the call path?
> Up to now I only tested with level-sensitive IRQs. Now I have the means
> I will also test with non shared edge-sensitive mapped IRQs.

I don't think we should ever set the level field for edge-triggered
IRQs.

> > 
> >> +		} else {
> >> +			/*
> >> +			 * We are somewhere before the update_irq_pending.
> >> +			 * we can't be sure the virtual IRQ will ever be
> >> +			 * injected (due to previous disable_irq).
> > 
> > I don't understand this.  Do we somehow know at this point that there is
> > a pending IRQ to inject as a virtual IRQ?
> No we just know the physical IRQ is active at physical distributor level.

how do we know this?

> 
> There can be a long path before the virtual IRQ gets injected into the
> guest:
> phys IRQ hits (1) -> genirq handler(2) -> VFIO handler(3) ->
> update_irq_pending in irqfd thread (4) -> flush (LR programming,5) ->
> guest deactivates the virq/pirq (6)
> 
> There is no valid state LR. There is no pending state recorded. So we
> are between (1) an (4) excluded.

you can also be before (1), no ?

> 
> 
> However we cannot be sure a virtual IRQ will ever be injected. Typically
> since the physical IRQ was disabled previously, it might happen that the
> VFIO physical handler is never reached and irqfd is never signalled.
> (genirq handler never calls the VFIO handler)

Isn't the point here simply that if you disconnect the virtual IRQ from
the that of the physical device, then you reset the state by clearing
the LR and if this virtual IRQ is to be used again as a purely virtual
IRQ or forwarding is configured again, then it must be re-injected?

If so, I think the comment can simply be:

Since we are changing this IRQ from fowarded to non-fowarded, reset its
state.

> > 
> >> +			 * Let's simply clear the level which was not correctly
> >> +			 * modelled in forwarded state.
> >> +			 */
> >> +			vgic_dist_irq_clear_level(vcpu, spi_id);
> >> +		}
> >> +		goto out;
> >> +	}
> >> +
> >> +	/*
> >> +	 * the virtual IRQ is queued and a valid LR exists, let's patch it so
> >> +	 * that when EOI happens a maintenance IRQ gets triggered
> >> +	 */
> >> +	vlr.state |= LR_EOI_INT;
> >> +	vgic_set_lr(vcpu, lr, vlr);
> >> +
> >> +	vgic_dist_irq_set_level(vcpu, spi_id);
> >> +	vgic_dist_irq_set_pending(vcpu, spi_id);
> > 
> > how do you know this is the case?  couldn't it be active in the LR?
> for a level sensitive IRQ the pending state stays active until the EOI
> maintenance gets called right? pending is set by vgic_queue_hwirq and
> reset by process_queued_irq?

ok, fair enough for the pending state (deserves a comment though), but I
don't see why you'd need to set the level field?  If there is no
connected virtual device that lowers the line afterwards, you'll keep
injecting this IRQ indefinitely I think.

> > 
> >> +	vgic_irq_set_queued(vcpu, spi_id);
> >> +	 /* The maintenance IRQ will reset all states above */

is this actually true for the level field?  It shouldn't, should it?

> > 
> > then why do we bother setting them to anything here?
> well isn't it cleaner? What if somebody else queries those values before
> the EOI maintenance gets called, a new injection for instance?

I guess, but then the comment could say that, "make sure this looks like
a regular virtual interrupt" or something like that.

> > 
> >> +
> >> +out:
> >> +	irq_set_irqchip_state(host_irq, IRQCHIP_STATE_ACTIVE, false);
> >> +	irq_set_vcpu_affinity(host_irq, NULL);
> >> +	/* next occurrence will be deactivated by the host */
> > 
> > I'm beginning to understand what you mean by 'next' here.
> 
> > 
> > Can you make it more explicit by saying "After this function returns, a
> > physical IRQ will be..." ?
> 
> yes. I was failing finding the appropriate wording I aknowledge.
> 
me too, it's hard.

Thanks,
-Christoffer
