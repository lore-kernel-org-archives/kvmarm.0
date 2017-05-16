From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 5/5] KVM: arm/arm64: Allow setting the timer IRQ numbers
 from userspace
Date: Tue, 16 May 2017 12:38:39 +0200
Message-ID: <20170516103839.GC5259@cbox>
References: <20170503183300.4618-1-cdall@linaro.org>
 <20170503183300.4618-6-cdall@linaro.org>
 <b08c50b4-6aba-1a59-80f4-343cd906f1fa@arm.com>
 <20170504095918.GJ5923@cbox>
 <79ec69f2-d727-46ec-b1d5-4c535a904e63@arm.com>
 <20170504112225.GM5923@cbox> <20170516065421.GE18755@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE0BD40BD2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 06:35:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GtoA9cnueoie for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 May 2017 06:35:22 -0400 (EDT)
Received: from mail-qk0-f179.google.com (mail-qk0-f179.google.com
 [209.85.220.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 633B740625
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 06:35:21 -0400 (EDT)
Received: by mail-qk0-f179.google.com with SMTP id a72so123686059qkj.2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 May 2017 03:38:49 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170516065421.GE18755@cbox>
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
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 16, 2017 at 08:54:21AM +0200, Christoffer Dall wrote:
> Hi Marc,
> 
> On Thu, May 04, 2017 at 01:22:25PM +0200, Christoffer Dall wrote:
> > On Thu, May 04, 2017 at 11:54:06AM +0100, Marc Zyngier wrote:
> > > On 04/05/17 10:59, Christoffer Dall wrote:
> > > > On Thu, May 04, 2017 at 10:34:32AM +0100, Marc Zyngier wrote:
> > > >> On 03/05/17 19:33, Christoffer Dall wrote:
> > > >>> First we define an ABI using the vcpu devices that lets userspace set
> > > >>> the interrupt numbers for the various timers on both the 32-bit and
> > > >>> 64-bit KVM/ARM implementations.
> > > >>>
> > > >>> Second, we add the definitions for the groups and attributes introduced
> > > >>> by the above ABI.  (We add the PMU define on the 32-bit side as well for
> > > >>> symmetry and it may get used some day.)
> > > >>>
> > > >>> Third, we set up the arch-specific vcpu device operation handlers to
> > > >>> call into the timer code for anything related to the
> > > >>> KVM_ARM_VCPU_TIMER_CTRL group.
> > > >>>
> > > >>> Fourth, we implement support for getting and setting the timer interrupt
> > > >>> numbers using the above defined ABI in the arch timer code.
> > > >>>
> > > >>> Fifth, we introduce error checking upon enabling the arch timer (which
> > > >>> is called when first running a VCPU) to check that all VCPUs are
> > > >>> configured to use the same PPI for the timer (as mandated by the
> > > >>> architecture) and that the virtual and physical timers are not
> > > >>> configured to use the same IRQ number.
> > > >>>
> > > >>> Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > > >>> ---
> > > >>>  Documentation/virtual/kvm/devices/vcpu.txt |  25 +++++++
> > > >>>  arch/arm/include/uapi/asm/kvm.h            |   8 +++
> > > >>>  arch/arm/kvm/guest.c                       |   9 +++
> > > >>>  arch/arm64/include/uapi/asm/kvm.h          |   3 +
> > > >>>  arch/arm64/kvm/guest.c                     |   9 +++
> > > >>>  include/kvm/arm_arch_timer.h               |   4 ++
> > > >>>  virt/kvm/arm/arch_timer.c                  | 104 +++++++++++++++++++++++++++++
> > > >>>  7 files changed, 162 insertions(+)
> > > >>>
> > > >>> diff --git a/Documentation/virtual/kvm/devices/vcpu.txt b/Documentation/virtual/kvm/devices/vcpu.txt
> > > >>> index 352af6e..013e3f1 100644
> > > >>> --- a/Documentation/virtual/kvm/devices/vcpu.txt
> > > >>> +++ b/Documentation/virtual/kvm/devices/vcpu.txt
> > > >>> @@ -35,3 +35,28 @@ Returns: -ENODEV: PMUv3 not supported or GIC not initialized
> > > >>>  Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
> > > >>>  virtual GIC implementation, this must be done after initializing the in-kernel
> > > >>>  irqchip.
> > > >>> +
> > > >>> +
> > > >>> +2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
> > > >>> +Architectures: ARM,ARM64
> > > >>> +
> > > >>> +2.1. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_VTIMER
> > > >>> +2.2. ATTRIBUTE: KVM_ARM_VCPU_TIMER_IRQ_PTIMER
> > > >>> +Parameters: in kvm_device_attr.addr the address for the timer interrupt is a
> > > >>> +            pointer to an int
> > > >>> +Returns: -EINVAL: Invalid timer interrupt number
> > > >>> +         -EBUSY:  One or more VCPUs has already run
> > > >>> +
> > > >>> +A value describing the architected timer interrupt number when connected to an
> > > >>> +in-kernel virtual GIC.  These must be a PPI (16 <= intid < 32).  If an
> > > >>> +attribute is not set, a default value is applied (see below).
> > > >>> +
> > > >>> +KVM_ARM_VCPU_TIMER_IRQ_VTIMER: The EL1 virtual timer intid (default: 27)
> > > >>> +KVM_ARM_VCPU_TIMER_IRQ_PTIMER: The EL1 physical timer intid (default: 30)
> > > >>
> > > >> uber nit: my reading of the code is that the default is set at VCPU
> > > >> creation time. So setting the attribute overrides the default, not that
> > > >> the default is applied if no attribute is set (i.e. there is always a
> > > >> valid value).
> > > >>
> > > > 
> > > > uh, right, I don't see the distinction though, so not sure how to
> > > > correct the text.
> > > > 
> > > > Would "Setting the attribute overrides the default values (see below)."
> > > > work instead?
> > > 
> > > Looks good to me.
> > > 
> > > [...]
> > > 
> > > >>
> > > >> Another issue that just popped in my head: how do we ensure that we
> > > >> don't clash between the PMU and the timers? Yes, that's a foolish thing
> > > >> to do, but that's no different from avoiding the same interrupt on the
> > > >> timers...
> > > >>
> > > > Argh, good point.
> > > > 
> > > > So actually, nothing *really bad* happens from using the same IRQ number
> > > > except that the VM gets confused.  However, it's living life dangerously
> > > > because we use the HW bit for the vtimer, so we if ever start using it
> > > > for other timers or the PMU, then you could end up in a situation where
> > > > you unmap the phys mapping on behalf of another device, and the physical
> > > > interrupt could be left in an active state.
> > > > 
> > > > On the other hand, the vtimer currently belongs only to VMs and we set
> > > > the required physical active state before entering the VM, so maybe it
> > > > doesn't matter.
> > > 
> > > So far, we always assume that there is never more than a single source
> > > per interrupt. We'll end-up with weird behaviours because our line_level
> > > field is not an OR of the various inputs, but a direct assignment
> > > (device A and B raise the line, then A drops it -> B's interrupt is gone).
> > > 
> > > I think that only the guest will be confused by it, but accepting it may
> > > be interpreted as "this should work correctly". Would documenting that
> > > it is a bad idea be enough?
> > > 
> > > > Should we just forego these checks and let the user shoot itself in the
> > > > foot if he/she wants to?
> > > 
> > > If the documentation is enough, why not. Otherwise, we need some form of
> > > allocator. Boring. ;-)
> > > 
> > 
> > Well, it's not that bad really (untested):
> > 
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index 1541f5d..122f9d3 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -121,6 +121,9 @@ struct vgic_irq {
> >  	u8 source;			/* GICv2 SGIs only */
> >  	u8 priority;
> >  	enum vgic_irq_config config;	/* Level or edge */
> > +
> > +	void *owner;			/* Opaque pointer to reserve an interrupt
> > +					   for in-kernel devices. */
> >  };
> >  
> >  struct vgic_register_region;
> > diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> > index 3d0979c..7561d2d 100644
> > --- a/virt/kvm/arm/vgic/vgic.c
> > +++ b/virt/kvm/arm/vgic/vgic.c
> > @@ -429,6 +429,42 @@ int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq)
> >  }
> >  
> >  /**
> > + * kvm_vgic_set_owner - Set the owner of an interrupt for a VM
> > + *
> > + * @kvm:    Pointer to the VM structure
> > + * @intid:  The virtual INTID identifying the interrupt (PPI or SPI)
> > + * @owner:  Opaque pointer to the owner
> > + *
> > + * Returns 0 if intid is not already used by another in-kernel device and the
> > + * owner is set, otherwise returns an error code.
> > + *
> > + * We only set the owner for VCPU 0 for PPIs.
> > + */
> > +int kvm_vgic_set_owner(struct kvm *kvm, unsigned int intid, void *owner)
> > +{
> > +	struct vgic_irq *irq;
> > +	struct kvm_vcpu *vcpu = kvm_get_vcpu(kvm, 0);
> > +	int ret = 0;
> > +
> > +	if (!vgic_initialized(kvm))
> > +		return -EAGAIN;
> > +
> > +	/* SGIs and LPIs cannot be wired up to any device */
> > +	if (!irq_is_ppi(intid) && !vgic_valid_spi(kvm, intid))
> > +		return -EINVAL;
> > +
> > +	irq = vgic_get_irq(kvm, vcpu, intid);
> > +	spin_lock(&irq->irq_lock);
> > +	if (irq->owner && irq->owner != owner)
> > +		ret = -EEXIST;
> > +	else
> > +		irq->owner = owner;
> > +	spin_unlock(&irq->irq_lock);
> > +
> > +	return ret;
> > +}
> > +
> > +/**
> >   * vgic_prune_ap_list - Remove non-relevant interrupts from the list
> >   *
> >   * @vcpu: The VCPU pointer
> > 
> > The problem is that it doesn't help that much, because userspace can
> > still change the level of an IRQ which is connected to an in-kernel
> > device, unless we also introduce checking the owner field in the
> > injection path.
> > 
> > I don't see it blowing up the host with/without an allocator, so I'm
> > fine with documentation, but I can also include the above.
> > 
> > Thoughts?
> > 
> 
> I think we lost track of this series because it got stuck here.  I'm
> tempted to just apply the series with the comment and without the owner
> stuff posted above, and then we can fix it up later if it turns out
> there's a problem.
> 

Actually, since people didn't formally ack these patches, I'm going to
simply send out a new series.

Thanks,
-Christoffer
