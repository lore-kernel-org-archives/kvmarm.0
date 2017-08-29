From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 6/8] KVM: arm/arm64: vgic: Implement forwarding setting
Date: Tue, 29 Aug 2017 09:08:11 +0200
Message-ID: <20170829070811.GS24649@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-7-git-send-email-eric.auger@redhat.com>
 <20170721131346.GH16350@cbox>
 <04c0ed5f-40b3-b0bf-cdf3-8bccbe2430d0@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <04c0ed5f-40b3-b0bf-cdf3-8bccbe2430d0@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Auger Eric <eric.auger@redhat.com>
Cc: eric.auger.pro@gmail.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, alex.williamson@redhat.com, b.reynal@virtualopensystems.com, pbonzini@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 23, 2017 at 10:58:38AM +0200, Auger Eric wrote:
> Hi Christoffer,
> 
> On 21/07/2017 15:13, Christoffer Dall wrote:
> > On Thu, Jun 15, 2017 at 02:52:38PM +0200, Eric Auger wrote:
> >> Implements kvm_vgic_[set|unset]_forwarding.
> >>
> >> Handle low-level VGIC programming and consistent irqchip
> >> programming.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> >>
> >> ---
> >>
> >> v1 -> v2:
> >> - change the parameter names used in the declaration
> >> - use kvm_vgic_map/unmap_phys_irq and handle their returned value
> >> ---
> >>  include/kvm/arm_vgic.h   |  5 +++
> >>  virt/kvm/arm/vgic/vgic.c | 88 ++++++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 93 insertions(+)
> >>
> >> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> >> index cceb31d..5064a57 100644
> >> --- a/include/kvm/arm_vgic.h
> >> +++ b/include/kvm/arm_vgic.h
> >> @@ -343,4 +343,9 @@ int kvm_send_userspace_msi(struct kvm *kvm, struct kvm_msi *msi);
> >>   */
> >>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm);
> >>  
> >> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
> >> +			    unsigned int vintid);
> >> +void kvm_vgic_unset_forwarding(struct kvm *kvm, unsigned int host_irq,
> >> +			       unsigned int vintid);
> >> +
> >>  #endif /* __KVM_ARM_VGIC_H */
> >> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
> >> index 2e35ac7..9ee3e77 100644
> >> --- a/virt/kvm/arm/vgic/vgic.c
> >> +++ b/virt/kvm/arm/vgic/vgic.c
> >> @@ -781,3 +781,91 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int vintid)
> >>  	return map_is_active;
> >>  }
> >>  
> >> +/**
> >> + * kvm_vgic_set_forwarding - Set IRQ forwarding
> >> + *
> >> + * @kvm: kvm handle
> >> + * @host_irq: the host linux IRQ
> >> + * @vintid: the virtual INTID
> >> + *
> >> + * This function must be called when the IRQ is not active:
> >> + * ie. not active at GIC level and not currently under injection
> >> + * into the guest using the unforwarded mode. The physical IRQ must
> >> + * be disabled and all vCPUs must have been exited and prevented
> >> + * from being re-entered.
> >> + */
> >> +int kvm_vgic_set_forwarding(struct kvm *kvm, unsigned int host_irq,
> >> +			    unsigned int vintid)
> >> +{
> >> +	struct kvm_vcpu *vcpu;
> >> +	struct vgic_irq *irq;
> >> +	int ret;
> >> +
> >> +	kvm_debug("%s host_irq=%d vintid=%d\n", __func__, host_irq, vintid);
> > 
> > do you need to check if the vgic is initialized etc. here?
> yes
> > 
> >> +
> >> +	if (!vgic_valid_spi(kvm, vintid))
> >> +		return -EINVAL;
> >> +
> >> +	irq = vgic_get_irq(kvm, NULL, vintid);
> >> +	spin_lock(&irq->irq_lock);
> >> +
> >> +	if (irq->hw) {
> >> +		ret = -EINVAL;
> > 
> > is this because it's already forwarded?  How about EBUSY or EEXIST
> > instead then?
> OK
> > 
> >> +		goto unlock;
> >> +	}
> >> +	vcpu = irq->target_vcpu;
> >> +	if (!vcpu) {
> >> +		ret = -EAGAIN;
> > 
> > what is this case exactly?
> This was discussed previously with Marc
> (https://patchwork.kernel.org/patch/9746841/). In GICv3 case the vcpu
> parameter is not used in irq_set_vcpu_affinity. What this function does
> is tell the GIC not to DIR the physical IRQ.
> 
> So in my case I just need a non NULL vcpu passed as parameter of
> irq_set_vcpu_affinity. kvm_vgic_map_irq is not using it because we are
> handling SPIs. But in GICv4 the actual target vpcu will be needed so I
> decided to use this latter and return an error in case it is not known.

Right, but my comment was to the fact that I don't think
irq->target_vcpu could ever be NULL, and I think if you want to simply
assert this, you should instead do:

BUG_ON(!vcpu);

> > 
> >> +		goto unlock;
> >> +	}
> >> +	
> >> +	ret = kvm_vgic_map_irq(vcpu, irq, host_irq);
> >> +	if (!ret)
> >> +		irq_set_vcpu_affinity(host_irq, vcpu);
> > 
> > so this is essentially map + set_vcpu_affinity.  Why do we want the GIC
> > to do this in one go as opposed to leaving it up to the caller?
> The VGIC code already use some genirq functions like
> irq_set/get_irqchip_state. Using the irq->lock prevents the 2 actions
> from being raced with an kvm_vgic_unset_forwarding(). Both the GIC and
> VGIC programming must be consistent.
> 

ok, I guess this makes sense.

Thanks,
-Christoffer
