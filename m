From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic-v2: Expose the correct GICC_PMR
 values to userspace
Date: Mon, 20 Mar 2017 19:31:29 +0100
Message-ID: <20170320183129.GA32242@cbox>
References: <20170316114535.25233-1-marc.zyngier@arm.com>
 <20170316114535.25233-2-marc.zyngier@arm.com>
 <20170320142425.GB20711@cbox>
 <3fb0ff07-7191-b814-b7d6-5165de97a805@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 491FC40BE3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:29:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4RfbZDOI8F2q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 14:29:46 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E9CE40AE8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 14:29:46 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id n11so71707104wma.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 11:31:31 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <3fb0ff07-7191-b814-b7d6-5165de97a805@arm.com>
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
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 20, 2017 at 03:12:05PM +0000, Marc Zyngier wrote:
> On 20/03/17 14:24, Christoffer Dall wrote:
> > On Thu, Mar 16, 2017 at 11:45:34AM +0000, Marc Zyngier wrote:
> >> We allow userspace to save/restore the GICC_PMR values in order
> >> to allow migration. This value is extracted from GICH_PMCR, where
> >> it occupies a 5 bit field. But the canonical PMR is an 8 bit
> >> value and we fail to shift the virtual priority, resulting in
> >> a non-sensical value being reported to userspace.
> >>
> >> Fixing it once and for all would be ideal, but that would break
> >> migration of guest from old to new kernels. We thus introduce
> >> a new GICv2 attribute (KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR)
> >> that allows userspace to register its interest for the one true
> >> representation of PMR.
> > 
> > Thinking about this some more, I think we should just leave the ABI as
> > is without introducing the flag, because we do not loose any information
> > by doing so, and we can completely leave it up to userspace to work
> > around our funny ABI.
> 
> Right. That's the other option. Do we have any use case where we'd like
> to expose the real thing to userspace? 

My stand here is that we *are* exposing the real thing - we just decided
to use a funny format.  If anything relied on the format being exported
as reading the GICC_PMR directly, then their code would be already
broken, and I don't think we care about supporting an already-broken
non-functional userspace.  The ABI is already what it is - not
beautiful - but functionally just fine.


> This would impact migration from
> KVM to "something else", but I'm not sure we ever want to consider this
> seriously.
> 

I don't think it really impacts anything.  For example, KVM to TCG will
still work, it just requires userspace to do the wrangling of shifting
the PMR 3 bits left and right, but it knows all about the versions it's
dealing with etc. so that can be solved in userspace as well.

And also, you're right, nobody is doing anything like this in userspace
in the moment, so let's just clarify our bad ABI and declare success ;)



> > In the end, considering my comments on the next patch, the result would
> > be amusing, and look something like this patch instead:
> > 
> > 
> > diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > index 76e61c8..b2f60ca 100644
> > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > @@ -83,6 +83,12 @@ Groups:
> >  
> >      Bits for undefined preemption levels are RAZ/WI.
> >  
> > +    For historical reasons and to provide ABI compatibility with userspace we
> > +    export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
> > +    field in the lower 5 bits of a word, meaning that userspace must always
> > +    use the lower 5 bits to communicate with the KVM device and must shift the
> > +    value left by 3 places to obtain the actual priority mask level.
> > +
> >    Limitations:
> >      - Priorities are not implemented, and registers are RAZ/WI
> >      - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index a3ad7ff..7b7ecac 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -229,7 +229,14 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
> >  		val = vmcr.ctlr;
> >  		break;
> >  	case GIC_CPU_PRIMASK:
> > -		val = vmcr.pmr;
> > +		/*
> > +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> > +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> > +		 * GICC_PMR.Priority, so we expose the upper five bits of
> > +		 * priority mask to userspace using the lower bits in the
> > +		 * unsigned long.
> > +		 */
> > +		val = vmcr.pmr >> 3;
> >  		break;
> >  	case GIC_CPU_BINPOINT:
> >  		val = vmcr.bpr;
> > @@ -262,7 +269,14 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
> >  		vmcr.ctlr = val;
> >  		break;
> >  	case GIC_CPU_PRIMASK:
> > -		vmcr.pmr = val;
> > +		/*
> > +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> > +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> > +		 * GICC_PMR.Priority, so we expose the upper five bits of
> > +		 * priority mask to userspace using the lower bits in the
> > +		 * unsigned long.
> > +		 */
> > +		vmcr.pmr = val << 3;
> 
> By just looking at the code, I understand that you have struct vmcr
> carrying PMR using its architectural representation? That's cunning indeed.
> 

Yeah, so that's the idea.  My thought is that we either (a) don't use
the intermediate struct vmcr representation for PMR at all, or (b)
clearly define why we need to intermediate data structure and which
format it should be in (the architectural one).

If there's a better case for (a), we can do that too, but I found this
one easily explainable with the comments I suggested.

> >  		break;
> >  	case GIC_CPU_BINPOINT:
> >  		vmcr.bpr = val;
> > diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> > index b834ecd..95739cc 100644
> > --- a/virt/kvm/arm/vgic/vgic-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-v2.c
> > @@ -191,7 +191,7 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  		GICH_VMCR_ALIAS_BINPOINT_MASK;
> >  	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
> >  		GICH_VMCR_BINPOINT_MASK;
> > -	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
> > +	vmcr |= ((vmcrp->pmr >> 3) << GICH_VMCR_PRIMASK_SHIFT) &
> >  		GICH_VMCR_PRIMASK_MASK;
> >  
> >  	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
> > @@ -207,8 +207,8 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
> >  	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
> >  			GICH_VMCR_BINPOINT_SHIFT;
> > -	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
> > -			GICH_VMCR_PRIMASK_SHIFT;
> > +	vmcrp->pmr  = ((vmcr & GICH_VMCR_PRIMASK_MASK) >>
> > +			GICH_VMCR_PRIMASK_SHIFT) << 3;
> >  }
> >  
> >  void vgic_v2_enable(struct kvm_vcpu *vcpu)
> > diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> > index db28f7c..64b70b4 100644
> > --- a/virt/kvm/arm/vgic/vgic.h
> > +++ b/virt/kvm/arm/vgic/vgic.h
> > @@ -85,7 +85,8 @@ struct vgic_vmcr {
> >  	u32	ctlr;
> >  	u32	abpr;
> >  	u32	bpr;
> > -	u32	pmr;
> > +	u32	pmr;  /* Priority mask field in the GICC_PMR and
> > +		       * ICC_PMR_EL1 priority field format */
> >  	/* Below member variable are valid only for GICv3 */
> >  	u32	grpen0;
> >  	u32	grpen1;
> > 
> > 
> > Let me know what you think.
> 
> If everybody is happy with it, then so am I.
> 


Cool.  Would you like me to send a proper patch, or do you prefer to
take care of this one on your end?

Thanks,
-Christoffer
