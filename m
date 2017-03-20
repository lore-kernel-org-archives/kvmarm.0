From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic-v2: Expose the correct GICC_PMR
 values to userspace
Date: Mon, 20 Mar 2017 19:55:11 +0100
Message-ID: <20170320185511.GB32242@cbox>
References: <20170316114535.25233-1-marc.zyngier@arm.com>
 <20170316114535.25233-2-marc.zyngier@arm.com>
 <20170320142425.GB20711@cbox>
 <3fb0ff07-7191-b814-b7d6-5165de97a805@arm.com>
 <20170320183129.GA32242@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170320183129.GA32242@cbox>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Peter Maydell <peter.maydell@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Mar 20, 2017 at 07:31:29PM +0100, Christoffer Dall wrote:
> On Mon, Mar 20, 2017 at 03:12:05PM +0000, Marc Zyngier wrote:
> > On 20/03/17 14:24, Christoffer Dall wrote:
> > > On Thu, Mar 16, 2017 at 11:45:34AM +0000, Marc Zyngier wrote:
> > >> We allow userspace to save/restore the GICC_PMR values in order
> > >> to allow migration. This value is extracted from GICH_PMCR, where
> > >> it occupies a 5 bit field. But the canonical PMR is an 8 bit
> > >> value and we fail to shift the virtual priority, resulting in
> > >> a non-sensical value being reported to userspace.
> > >>
> > >> Fixing it once and for all would be ideal, but that would break
> > >> migration of guest from old to new kernels. We thus introduce
> > >> a new GICv2 attribute (KVM_DEV_ARM_VGIC_CTRL_CANONICAL_PMR)
> > >> that allows userspace to register its interest for the one true
> > >> representation of PMR.
> > > 
> > > Thinking about this some more, I think we should just leave the ABI as
> > > is without introducing the flag, because we do not loose any information
> > > by doing so, and we can completely leave it up to userspace to work
> > > around our funny ABI.
> > 
> > Right. That's the other option. Do we have any use case where we'd like
> > to expose the real thing to userspace? 
> 
> My stand here is that we *are* exposing the real thing - we just decided
> to use a funny format.  If anything relied on the format being exported
> as reading the GICC_PMR directly, then their code would be already
> broken, and I don't think we care about supporting an already-broken
> non-functional userspace.  The ABI is already what it is - not
> beautiful - but functionally just fine.
> 
> 
> > This would impact migration from
> > KVM to "something else", but I'm not sure we ever want to consider this
> > seriously.
> > 
> 
> I don't think it really impacts anything.  For example, KVM to TCG will
> still work, it just requires userspace to do the wrangling of shifting
> the PMR 3 bits left and right, but it knows all about the versions it's
> dealing with etc. so that can be solved in userspace as well.
> 
> And also, you're right, nobody is doing anything like this in userspace
> in the moment, so let's just clarify our bad ABI and declare success ;)
> 
> 
> 
> > > In the end, considering my comments on the next patch, the result would
> > > be amusing, and look something like this patch instead:
> > > 
> > > 
> > > diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > > index 76e61c8..b2f60ca 100644
> > > --- a/Documentation/virtual/kvm/devices/arm-vgic.txt
> > > +++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
> > > @@ -83,6 +83,12 @@ Groups:
> > >  
> > >      Bits for undefined preemption levels are RAZ/WI.
> > >  
> > > +    For historical reasons and to provide ABI compatibility with userspace we
> > > +    export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
> > > +    field in the lower 5 bits of a word, meaning that userspace must always
> > > +    use the lower 5 bits to communicate with the KVM device and must shift the
> > > +    value left by 3 places to obtain the actual priority mask level.
> > > +
> > >    Limitations:
> > >      - Priorities are not implemented, and registers are RAZ/WI
> > >      - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
> > > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > > index a3ad7ff..7b7ecac 100644
> > > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > > @@ -229,7 +229,14 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
> > >  		val = vmcr.ctlr;
> > >  		break;
> > >  	case GIC_CPU_PRIMASK:
> > > -		val = vmcr.pmr;
> > > +		/*
> > > +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> > > +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> > > +		 * GICC_PMR.Priority, so we expose the upper five bits of
> > > +		 * priority mask to userspace using the lower bits in the
> > > +		 * unsigned long.
> > > +		 */
> > > +		val = vmcr.pmr >> 3;
> > >  		break;
> > >  	case GIC_CPU_BINPOINT:
> > >  		val = vmcr.bpr;
> > > @@ -262,7 +269,14 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
> > >  		vmcr.ctlr = val;
> > >  		break;
> > >  	case GIC_CPU_PRIMASK:
> > > -		vmcr.pmr = val;
> > > +		/*
> > > +		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
> > > +		 * the PMR field as GICH_VMCR.VMPriMask rather than
> > > +		 * GICC_PMR.Priority, so we expose the upper five bits of
> > > +		 * priority mask to userspace using the lower bits in the
> > > +		 * unsigned long.
> > > +		 */
> > > +		vmcr.pmr = val << 3;
> > 
> > By just looking at the code, I understand that you have struct vmcr
> > carrying PMR using its architectural representation? That's cunning indeed.
> > 
> 
> Yeah, so that's the idea.  My thought is that we either (a) don't use
> the intermediate struct vmcr representation for PMR at all, or (b)
> clearly define why we need to intermediate data structure and which
> format it should be in (the architectural one).
> 
> If there's a better case for (a), we can do that too, but I found this
> one easily explainable with the comments I suggested.
> 

Just for reference, this is what the other solution looks like
(untested, of course).  I prefer my first version, but I don't feel
strongly about it:


diff --git a/Documentation/virtual/kvm/devices/arm-vgic.txt b/Documentation/virtual/kvm/devices/arm-vgic.txt
index 76e61c8..b2f60ca 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic.txt
@@ -83,6 +83,12 @@ Groups:
 
     Bits for undefined preemption levels are RAZ/WI.
 
+    For historical reasons and to provide ABI compatibility with userspace we
+    export the GICC_PMR register in the format of the GICH_VMCR.VMPriMask
+    field in the lower 5 bits of a word, meaning that userspace must always
+    use the lower 5 bits to communicate with the KVM device and must shift the
+    value left by 3 places to obtain the actual priority mask level.
+
   Limitations:
     - Priorities are not implemented, and registers are RAZ/WI
     - Currently only implemented for KVM_DEV_TYPE_ARM_VGIC_V2.
diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
index 79f37e3..5befc53 100644
--- a/arch/arm64/kvm/vgic-sys-reg-v3.c
+++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
@@ -95,14 +95,18 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_gic_pmr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	struct vgic_vmcr vmcr;
+	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
+		u32 pmr;
 
-	vgic_get_vmcr(vcpu, &vmcr);
 	if (p->is_write) {
-		vmcr.pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
-		vgic_set_vmcr(vcpu, &vmcr);
+		pmr = (p->regval & ICC_PMR_EL1_MASK) >> ICC_PMR_EL1_SHIFT;
+		vgic_v3->vgic_vmcr &= ~ICH_VMCR_PMR_MASK;
+		vgic_v3->vgic_vmcr |= (pmr << ICH_VMCR_PMR_SHIFT)
+			& ICH_VMCR_PMR_MASK;
 	} else {
-		p->regval = (vmcr.pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
+		pmr = (vgic_v3->vgic_vmcr & ICH_VMCR_PMR_MASK) >>
+			ICH_VMCR_PMR_SHIFT;
+		p->regval = (pmr << ICC_PMR_EL1_SHIFT) & ICC_PMR_EL1_MASK;
 	}
 
 	return true;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index a3ad7ff..41c413b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -219,6 +219,7 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 					   gpa_t addr, unsigned int len)
 {
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_vmcr vmcr;
 	u32 val;
 
@@ -229,7 +230,15 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
 		val = vmcr.ctlr;
 		break;
 	case GIC_CPU_PRIMASK:
-		val = vmcr.pmr;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we expose the upper five bits of
+		 * priority mask to userspace using the lower bits in the
+		 * 32-bit word provided by userspace.
+		 */
+		val = (cpuif->vgic_vmcr & GICH_VMCR_PRIMASK_MASK) >>
+			GICH_VMCR_PRIMASK_SHIFT;
 		break;
 	case GIC_CPU_BINPOINT:
 		val = vmcr.bpr;
@@ -253,6 +262,7 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 				   gpa_t addr, unsigned int len,
 				   unsigned long val)
 {
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
 	struct vgic_vmcr vmcr;
 
 	vgic_get_vmcr(vcpu, &vmcr);
@@ -262,7 +272,16 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
 		vmcr.ctlr = val;
 		break;
 	case GIC_CPU_PRIMASK:
-		vmcr.pmr = val;
+		/*
+		 * Our KVM_DEV_TYPE_ARM_VGIC_V2 device ABI exports the
+		 * the PMR field as GICH_VMCR.VMPriMask rather than
+		 * GICC_PMR.Priority, so we expose the upper five bits of
+		 * priority mask to userspace using the lower bits in the
+		 * 32-bit word provided by userspace.
+		 */
+		cpuif->vgic_vmcr &= ~GICH_VMCR_PRIMASK_MASK;
+		cpuif->vgic_vmcr |= (val << GICH_VMCR_PRIMASK_SHIFT) &
+			GICH_VMCR_PRIMASK_MASK;
 		break;
 	case GIC_CPU_BINPOINT:
 		vmcr.bpr = val;
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index b834ecd..cc85bbf 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -191,8 +191,6 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 		GICH_VMCR_ALIAS_BINPOINT_MASK;
 	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
 		GICH_VMCR_BINPOINT_MASK;
-	vmcr |= (vmcrp->pmr << GICH_VMCR_PRIMASK_SHIFT) &
-		GICH_VMCR_PRIMASK_MASK;
 
 	vcpu->arch.vgic_cpu.vgic_v2.vgic_vmcr = vmcr;
 }
@@ -207,8 +205,6 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
 	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
 			GICH_VMCR_BINPOINT_SHIFT;
-	vmcrp->pmr  = (vmcr & GICH_VMCR_PRIMASK_MASK) >>
-			GICH_VMCR_PRIMASK_SHIFT;
 }
 
 void vgic_v2_enable(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index edc6ee2..bcc5434 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -184,7 +184,6 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
 	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
 	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
-	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
 	vmcr |= (vmcrp->grpen0 << ICH_VMCR_ENG0_SHIFT) & ICH_VMCR_ENG0_MASK;
 	vmcr |= (vmcrp->grpen1 << ICH_VMCR_ENG1_SHIFT) & ICH_VMCR_ENG1_MASK;
 
@@ -204,7 +203,6 @@ void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
 	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
 	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
-	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
 	vmcrp->grpen0 = (vmcr & ICH_VMCR_ENG0_MASK) >> ICH_VMCR_ENG0_SHIFT;
 	vmcrp->grpen1 = (vmcr & ICH_VMCR_ENG1_MASK) >> ICH_VMCR_ENG1_SHIFT;
 }
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index db28f7c..9886be3 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -85,7 +85,6 @@ struct vgic_vmcr {
 	u32	ctlr;
 	u32	abpr;
 	u32	bpr;
-	u32	pmr;
 	/* Below member variable are valid only for GICv3 */
 	u32	grpen0;
 	u32	grpen1;


Thanks,
-Christoffer
