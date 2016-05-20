From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v2] KVM: arm/arm64: vgic-new: Synchronize changes to
 active state
Date: Fri, 20 May 2016 16:14:59 +0200
Message-ID: <20160520141459.GB10370@cbox>
References: <1463751027-17517-1-git-send-email-christoffer.dall@linaro.org>
 <1463752410-3800-1-git-send-email-christoffer.dall@linaro.org>
 <573F1A3D.7050808@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <573F1A3D.7050808@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, Eric Auger <eric.auger@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, May 20, 2016 at 03:07:57PM +0100, Marc Zyngier wrote:
> On 20/05/16 14:53, Christoffer Dall wrote:
> > When modifying the active state of an interrupt via the MMIO interface,
> > we should ensure that the write has the intended effect.
> > 
> > If a guest sets an interrupt to active, but that interrupt is already
> > flushed into a list register on a running VCPU, then that VCPU will
> > write the active state back into the struct vgic_irq upon returning from
> > the guest and syncing its state.  This is a non-benign race, because the
> > guest can observe that an interrupt is not active, and it can have a
> > reasonable expectations that other VCPUs will not ack any IRQs, and then
> > set the state to active, and expect it to stay that way.  Currently we
> > are not honoring this case.
> > 
> > Thefore, change both the SACTIVE and CACTIVE mmio handlers to stop the
> > world, change the irq state, potentially queue the irq if we're setting
> > it to active, and then continue.
> > 
> > We take this chance to slightly optimize these functions by not stopping
> > the world when touching private interrupts where there is inherently no
> > possible race.
> > 
> > Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
> > ---
> > Changes since v1:
> >  - Dont' stop the world for private IRQs
> > 
> >  virt/kvm/arm/vgic/vgic-mmio.c | 87 ++++++++++++++++++++++++-------------------
> >  1 file changed, 48 insertions(+), 39 deletions(-)
> > 
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > index 4ef3571..b014c8c 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > @@ -173,6 +173,36 @@ unsigned long vgic_mmio_read_active(struct kvm_vcpu *vcpu,
> >  	return value;
> >  }
> >  
> > +static void vgic_mmio_change_active(struct kvm_vcpu *vcpu, struct vgic_irq *irq,
> > +				    bool new_active_state)
> > +{
> > +	spin_lock(&irq->irq_lock);
> > +	/*
> > +	 * If this virtual IRQ was written into a list register, we
> > +	 * have to make sure the CPU that runs the VCPU thread has
> > +	 * synced back LR state to the struct vgic_irq.  We can only
> > +	 * know this for sure, when either this irq is not assigned to
> > +	 * anyone's AP list anymore, or the VCPU thread is not
> > +	 * running on any CPUs.
> > +	 *
> > +	 * In the opposite case, we know the VCPU thread may be on its
> > +	 * way back from the guest and still has to sync back this
> > +	 * IRQ, so we release and re-acquire the spin_lock to let the
> > +	 * other thread sync back the IRQ.
> > +	 */
> > +	while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> > +	       irq->vcpu->cpu != -1) { /* VCPU thread is running */
> > +		BUG_ON(irq->intid < VGIC_NR_PRIVATE_IRQS);
> > +		cond_resched_lock(&irq->irq_lock);
> > +	}
> > +
> > +	irq->active = new_active_state;
> > +	if (new_active_state)
> > +		vgic_queue_irq_unlock(vcpu->kvm, irq);
> > +	else
> > +		spin_unlock(&irq->irq_lock);
> > +}
> > +
> >  void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >  			     gpa_t addr, unsigned int len,
> >  			     unsigned long val)
> > @@ -180,32 +210,18 @@ void vgic_mmio_write_cactive(struct kvm_vcpu *vcpu,
> >  	u32 intid = VGIC_ADDR_TO_INTID(addr, 1);
> >  	int i;
> >  
> > -	kvm_arm_halt_guest(vcpu->kvm);
> > +	/* Only the VCPU itself can access its active state regs */
> 
> I'm afraid this is not true for GICv3 (the private interrupts are
> handled by the redistributors, which are not banked).
> 
> > +	if (intid >= VGIC_NR_PRIVATE_IRQS)
> > +		kvm_arm_halt_guest(vcpu->kvm);
> 	else {
> 		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid);
> 		irq->target_vcpu.arch.pause = true;
> 		kvm_make_request(irq->target_vcpu, KVM_REQ_VCPU_EXIT);
> 		/* and then it is a bit complicated... */
> 	}
> > +
> >  	for_each_set_bit(i, &val, len * 8) {
> >  		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> > -
> > -		spin_lock(&irq->irq_lock);
> > -		/*
> > -		 * If this virtual IRQ was written into a list register, we
> > -		 * have to make sure the CPU that runs the VCPU thread has
> > -		 * synced back LR state to the struct vgic_irq.  We can only
> > -		 * know this for sure, when either this irq is not assigned to
> > -		 * anyone's AP list anymore, or the VCPU thread is not
> > -		 * running on any CPUs.
> > -		 *
> > -		 * In the opposite case, we know the VCPU thread may be on its
> > -		 * way back from the guest and still has to sync back this
> > -		 * IRQ, so we release and re-acquire the spin_lock to let the
> > -		 * other thread sync back the IRQ.
> > -		 */
> > -		while (irq->vcpu && /* IRQ may have state in an LR somewhere */
> > -		       irq->vcpu->cpu != -1) /* VCPU thread is running */
> > -			cond_resched_lock(&irq->irq_lock);
> > -
> > -		irq->active = false;
> > -		spin_unlock(&irq->irq_lock);
> > +		vgic_mmio_change_active(vcpu, irq, false);
> >  	}
> > -	kvm_arm_resume_guest(vcpu->kvm);
> > +
> > +	/* Only the VCPU itself can access its active state regs */
> > +	if (intid >= VGIC_NR_PRIVATE_IRQS)
> > +		kvm_arm_resume_guest(vcpu->kvm);
> >  }
> 
> I though we had a way to stop a single vcpu without too much hassle,
> but I'm not seeing any standard way to do that. Grmbl...
> 
You can pause it and kick it, I think that should work... Let me have a
look.  Otherwise we'll fall back to v1 and optimize this later.

-Christoffer
