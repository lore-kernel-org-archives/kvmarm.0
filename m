From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 08/10] KVM: arm/arm64: vgic: Handle unshared mapped
 interrupts
Date: Thu, 8 Jun 2017 12:11:53 +0200
Message-ID: <20170608101153.GB7657@cbox>
References: <1495656803-28011-1-git-send-email-eric.auger@redhat.com>
 <1495656803-28011-9-git-send-email-eric.auger@redhat.com>
 <20170602133301.GD397@cbox>
 <379c9829-492c-edb0-aa07-7471ec56b3a5@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <379c9829-492c-edb0-aa07-7471ec56b3a5@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 08, 2017 at 10:49:12AM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 02/06/2017 15:33, Christoffer Dall wrote:
> > On Wed, May 24, 2017 at 10:13:21PM +0200, Eric Auger wrote:
> >> Virtual interrupts directly mapped to physical interrupts require
> >> some special care. Their pending and active state must be observed
> >> at distributor level and not in the list register.
> > 
> > This is not entirely true.  There's a dependency, but there is also
> > separate virtual vs. physical state, see below.
> > 
> >>
> >> Also a level sensitive interrupt's level is not toggled down by any
> >> maintenance IRQ handler as the EOI is not trapped.
> >>
> >> This patch adds an host_irq field in vgic_irq struct to easily
> >> get the irqchip state of the host irq. We also handle the
> >> physical IRQ case in vgic_validate_injection and add helpers to
> >> get the line level and active state.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >> ---
> >>  include/kvm/arm_vgic.h    |  4 +++-
> >>  virt/kvm/arm/arch_timer.c |  3 ++-
> >>  virt/kvm/arm/vgic/vgic.c  | 44 ++++++++++++++++++++++++++++++++++++++------
> >>  virt/kvm/arm/vgic/vgic.h  |  9 ++++++++-
> >>  4 files changed, 51 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index ef71858..695ebc7 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -112,6 +112,7 @@ struct vgic_irq {
> >>  	bool hw;			/* Tied to HW IRQ */
> >>  	struct kref refcount;		/* Used for LPIs */
> >>  	u32 hwintid;			/* HW INTID number */
> >> +	unsigned int host_irq;		/* linux irq corresponding to hwintid */
> >>  	union {
> >>  		u8 targets;			/* GICv2 target VCPUs mask */
> >>  		u32 mpidr;			/* GICv3 target VCPU */
> >> @@ -301,7 +302,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>  			bool level);
> >>  int kvm_vgic_inject_mapped_irq(struct kvm *kvm, int cpuid, unsigned int intid,
> >>  			       bool level);
> >> -int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, u32 virt_irq, u32 phys_irq);
> >> +int kvm_vgic_map_phys_irq(struct kvm_vcpu *vcpu, unsigned int host_irq,
> >> +			  u32 virt_irq, u32 phys_irq);
> >>  int kvm_vgic_unmap_phys_irq(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >>  bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
> >>  
> >> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> >> index 5976609..45f4779 100644
> >> --- a/virt/kvm/arm/arch_timer.c
> >> +++ b/virt/kvm/arm/arch_timer.c
> >> @@ -651,7 +651,8 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
> >>  	 * Tell the VGIC that the virtual interrupt is tied to a
> >>  	 * physical interrupt. We do that once per VCPU.
> >>  	 */
> >> -	ret = kvm_vgic_map_phys_irq(vcpu, vtimer->irq.irq, phys_irq);
> >> +	ret = kvm_vgic_map_phys_irq(vcpu, host_vtimer_irq,
> >> +				    vtimer->irq.irq, phys_irq);
> >>  	if (ret)
> >>  		return ret;
> >>  
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index 83b24d2..aa0618c 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -137,6 +137,28 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
> >>  	kfree(irq);
> >>  }
> >>  
> >> +bool irq_line_level(struct vgic_irq *irq)
> >> +{
> >> +	bool line_level = irq->line_level;
> >> +
> >> +	if (unlikely(is_unshared_mapped(irq)))
> >> +		WARN_ON(irq_get_irqchip_state(irq->host_irq,
> >> +					      IRQCHIP_STATE_PENDING,
> >> +					      &line_level));
> >> +	return line_level;
> >> +}
> > 
> > This really looks fishy.  When do we need this exactly?
> > 
> > I feel like we should treat this more like everything else and set the
> > line_level on the irq even for forwarded interrupts, and then you don't
> > need changes to validate injection.
> > 
> > The challenge, then, is how to re-sample the line and lower the
> > line_level field when necessary.  Can't we simply do this in
> > vgic_fold_lr_state(), and if you have a forwarded interrupt which is
> > level triggered and the level is high,
> Didn't you mean level is low? When the level is low you would trigger
> the resamplefd? Doesn't it bring a useless overhead?

No, I meant high.

So the idea would be that (for example) VFIO gets notified when the
level goes up, and can forward this information to KVM at that time, but
neither VFIO nor KVM get notified when the level lowers again.  The idea
would then be that we only care about this change when we're done with
the virtual interrupt, so if the line_level is already high, we should
do the resample trick to get VFIO to lower the line - sort of the
opposite from the non-forwarding case.

But I'm now realizing that this doesn't work as easily as I thought,
because then you would have to change the injection path to IPI the VM
when setting the line_level to high when it's already high, and the
interrupt is a forwarded one.

> 
> So yes I was confused by the spec and I thought the pending and active
> bit*s* were not reliable in the LRs and instead stared at the
> distributor state.

Been there done that.

> 
> That being said, as you mention, the line level is difficult to model as
> the resamplefd is not called so why not directly looking at the physical
> distributor state (pending bit?). The impact on the SM is reduced to
> irq_line_level() and validate_injection() which is always true for
> forwarded interrupts.
> 

Because the virtual state is in fact decoupled from the physical state,
so it feels wrong to me to start peeking into the physical GIC for our
emulated model.


Thanks,
-Christoffer
