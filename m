From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [RFC PATCH] kvm: arm: vgic-v3: add the emulate GICC_CTLR layout
 support for vmcr ctlr field.
Date: Tue, 23 May 2017 18:55:43 +0200
Message-ID: <20170523165543.GA602@cbox>
References: <1494897566-11744-1-git-send-email-wanghaibin.wang@huawei.com>
 <20170520121704.GB6319@cbox>
 <4bad8907-3ead-151d-66a2-6ca8769a2f1a@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A7304095A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 May 2017 12:52:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FwVHUkkR+2w3 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 23 May 2017 12:52:16 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 72ADF40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 May 2017 12:52:16 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id 7so31989565wmo.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 23 May 2017 09:55:57 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4bad8907-3ead-151d-66a2-6ca8769a2f1a@arm.com>
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
Cc: kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, May 23, 2017 at 05:33:46PM +0100, Marc Zyngier wrote:
> On 20/05/17 13:17, Christoffer Dall wrote:
> > Hi Wanghaibin,
> > 
> > On Tue, May 16, 2017 at 09:19:26AM +0800, wanghaibin wrote:
> >> Boot a virtual machine with the emulated GICv2 on the GICv3 hardware.
> >> Migrate the virtual machine will be successful, but the virtual machine will
> >> hang at the destination.
> >>
> >> The GICC_CTLR and ICC_CTLR_EL1 have the different layout. Currently, the set/get
> >> the VMCR interface just take vmcr ctlr field as the ICC_CTLR_EL1 layout.
> >> Should we consider the GICC_CTLR layout to avoid this problem?
> >>
> >> Signed-off-by: wanghaibin <wanghaibin.wang@huawei.com>
> > 
> > Nice find.
> > 
> > I agree with the problem, but I don't agree with your solution, because
> > it's really hard to figure out the mappings, I think.
> > 
> > How about this (untested) patch instead?  Could you test the migration
> > on your setup?
> > 
> > commit 7c94545b6801840364647d5deb81f47da5e1f547 (HEAD -> vmcr-gicv2on3-cleanup, kernelorg/vmcr-gicv2on3-cleanup)
> > Author: Christoffer Dall <cdall@linaro.org>
> > Date:   Sat May 20 14:12:34 2017 +0200
> > 
> >     KVM: arm/arm64: Fix isues with GICv2 on GICv3 migration
> >     
> >     We have been a little loose with our intermediate VMCR representation
> >     where we had a 'ctlr' field, but we failed to differentiate between the
> >     GICv2 GICC_CTLR and ICC_CTLR_EL1 layouts, and therefore ended up mapping
> >     the wrong bits into the individual fields of the ICH_VMCR_EL2 when
> >     emulating a GICv2 on a GICv3 system.
> >     
> >     Fix this by using explicit fields for the VMCR bits instead.
> >     
> >     Cc: Marc Zyngier <marc.zyngier@arm.com>
> >     Cc: Eric Auger <eric.auger@redhat.com>
> >     Reported-by: wanghaibin <wanghaibin.wang@huawei.com>
> >     Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > 
> > diff --git a/arch/arm64/kvm/vgic-sys-reg-v3.c b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > index 79f37e3..6260b69 100644
> > --- a/arch/arm64/kvm/vgic-sys-reg-v3.c
> > +++ b/arch/arm64/kvm/vgic-sys-reg-v3.c
> > @@ -65,8 +65,8 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		 * Here set VMCR.CTLR in ICC_CTLR_EL1 layout.
> >  		 * The vgic_set_vmcr() will convert to ICH_VMCR layout.
> >  		 */
> > -		vmcr.ctlr = val & ICC_CTLR_EL1_CBPR_MASK;
> > -		vmcr.ctlr |= val & ICC_CTLR_EL1_EOImode_MASK;
> > +		vmcr.cbpr = (val & ICC_CTLR_EL1_CBPR_MASK) >> ICC_CTLR_EL1_CBPR_SHIFT;
> > +		vmcr.eoim = (val & ICC_CTLR_EL1_EOImode_MASK) >> ICC_CTLR_EL1_EOImode_SHIFT;
> >  		vgic_set_vmcr(vcpu, &vmcr);
> >  	} else {
> >  		val = 0;
> > @@ -83,8 +83,8 @@ static bool access_gic_ctlr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		 * The VMCR.CTLR value is in ICC_CTLR_EL1 layout.
> >  		 * Extract it directly using ICC_CTLR_EL1 reg definitions.
> >  		 */
> > -		val |= vmcr.ctlr & ICC_CTLR_EL1_CBPR_MASK;
> > -		val |= vmcr.ctlr & ICC_CTLR_EL1_EOImode_MASK;
> > +		val |= (vmcr.cbpr << ICC_CTLR_EL1_CBPR_SHIFT) & ICC_CTLR_EL1_CBPR_MASK;
> > +		val |= (vmcr.eoim << ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
> >  
> >  		p->regval = val;
> >  	}
> > @@ -135,7 +135,7 @@ static bool access_gic_bpr1(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> >  		p->regval = 0;
> >  
> >  	vgic_get_vmcr(vcpu, &vmcr);
> > -	if (!((vmcr.ctlr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT)) {
> > +	if (!vmcr.cbpr) {
> >  		if (p->is_write) {
> >  			vmcr.abpr = (p->regval & ICC_BPR1_EL1_MASK) >>
> >  				     ICC_BPR1_EL1_SHIFT;
> > diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> > index fffb912..1fa293a 100644
> > --- a/include/linux/irqchip/arm-gic-v3.h
> > +++ b/include/linux/irqchip/arm-gic-v3.h
> > @@ -417,6 +417,10 @@
> >  #define ICH_HCR_EN			(1 << 0)
> >  #define ICH_HCR_UIE			(1 << 1)
> >  
> > +#define ICH_VMCR_ACK_CTL_SHIFT		2
> > +#define ICH_VMCR_ACK_CTL_MASK		(1 << ICH_VMCR_ACK_CTL_SHIFT)
> > +#define ICH_VMCR_FIQ_EN_SHIFT		3
> > +#define ICH_VMCR_FIQ_EN_MASK		(1 << ICH_VMCR_FIQ_EN_SHIFT)
> >  #define ICH_VMCR_CBPR_SHIFT		4
> >  #define ICH_VMCR_CBPR_MASK		(1 << ICH_VMCR_CBPR_SHIFT)
> >  #define ICH_VMCR_EOIM_SHIFT		9
> > diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
> > index dc30f3d..0baebcb 100644
> > --- a/include/linux/irqchip/arm-gic.h
> > +++ b/include/linux/irqchip/arm-gic.h
> > @@ -25,6 +25,11 @@
> >  #define GICC_ENABLE			0x1
> >  #define GICC_INT_PRI_THRESHOLD		0xf0
> >  
> > +#define GIC_CPU_CTRL_EnableGrp0		(1 << 0)
> > +#define GIC_CPU_CTRL_EnableGrp1		(1 << 1)
> > +#define GIC_CPU_CTRL_AckCtl		(1 << 2)
> > +#define GIC_CPU_CTRL_FIQEn		(1 << 3)
> > +#define GIC_CPU_CTRL_CBPR		(1 << 4)
> >  #define GIC_CPU_CTRL_EOImodeNS		(1 << 9)
> >  
> >  #define GICC_IAR_INT_ID_MASK		0x3ff
> > @@ -84,8 +89,19 @@
> >  #define GICH_LR_EOI			(1 << 19)
> >  #define GICH_LR_HW			(1 << 31)
> >  
> > -#define GICH_VMCR_CTRL_SHIFT		0
> > -#define GICH_VMCR_CTRL_MASK		(0x21f << GICH_VMCR_CTRL_SHIFT)
> > +#define GICH_VMCR_ENABLE_GRP0_SHIFT	0
> > +#define GICH_VMCR_ENABLE_GRP0_MASK	(1 << GICH_VMCR_ENABLE_GRP0_SHIFT)
> > +#define GICH_VMCR_ENABLE_GRP1_SHIFT	1
> > +#define GICH_VMCR_ENABLE_GRP1_MASK	(1 << GICH_VMCR_ENABLE_GRP1_SHIFT)
> > +#define GICH_VMCR_ACK_CTL_SHIFT		2
> > +#define GICH_VMCR_ACK_CTL_MASK		(1 << GICH_VMCR_ACK_CTL_SHIFT)
> > +#define GICH_VMCR_FIQ_EN_SHIFT		3
> > +#define GICH_VMCR_FIQ_EN_MASK		(1 << GICH_VMCR_FIQ_EN_SHIFT)
> > +#define GICH_VMCR_CBPR_SHIFT		4
> > +#define GICH_VMCR_CBPR_MASK		(1 << GICH_VMCR_CBPR_SHIFT)
> > +#define GICH_VMCR_EOI_MODE_SHIFT	9
> > +#define GICH_VMCR_EOI_MODE_MASK		(1 << GICH_VMCR_EOI_MODE_SHIFT)
> > +
> >  #define GICH_VMCR_PRIMASK_SHIFT		27
> >  #define GICH_VMCR_PRIMASK_MASK		(0x1f << GICH_VMCR_PRIMASK_SHIFT)
> >  #define GICH_VMCR_BINPOINT_SHIFT	21
> > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > index 0a4283e..0b71a46 100644
> > --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> > @@ -226,7 +226,13 @@ static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
> >  
> >  	switch (addr & 0xff) {
> >  	case GIC_CPU_CTRL:
> > -		val = vmcr.ctlr;
> > +		val = vmcr.grpen0 << __ffs(GIC_CPU_CTRL_EnableGrp0);
> > +		val |= vmcr.grpen1 << __ffs(GIC_CPU_CTRL_EnableGrp1);
> > +		val |= vmcr.ackctl << __ffs(GIC_CPU_CTRL_AckCtl);
> > +		val |= vmcr.fiqen << __ffs(GIC_CPU_CTRL_FIQEn);
> > +		val |= vmcr.cbpr << __ffs(GIC_CPU_CTRL_CBPR);
> > +		val |= vmcr.eoim << __ffs(GIC_CPU_CTRL_EOImodeNS);
> 
> Funky ;-) Should we try to standardize on one way or another of
> expressing the shift?
> 

I wouldn't mind that, but because the existing v2 definition for
EOImodeNS was defined differently from the existing v3 definitions, and
this is fixing a real problem, I decdied to keep the consistency in the
definitions and work around it in the code that uses it.

But as always, I'm open to suggestions.  Do you think we should change
the way the GICv2 define is done?

> > +
> >  		break;
> >  	case GIC_CPU_PRIMASK:
> >  		/*
> > @@ -267,7 +273,13 @@ static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
> >  
> >  	switch (addr & 0xff) {
> >  	case GIC_CPU_CTRL:
> > -		vmcr.ctlr = val;
> > +		vmcr.grpen0 = !!(val & GIC_CPU_CTRL_EnableGrp0);
> > +		vmcr.grpen1 = !!(val & GIC_CPU_CTRL_EnableGrp1);
> > +		vmcr.ackctl = !!(val & GIC_CPU_CTRL_AckCtl);
> > +		vmcr.fiqen = !!(val & GIC_CPU_CTRL_FIQEn);
> > +		vmcr.cbpr = !!(val & GIC_CPU_CTRL_CBPR);
> > +		vmcr.eoim = !!(val & GIC_CPU_CTRL_EOImodeNS);
> > +
> >  		break;
> >  	case GIC_CPU_PRIMASK:
> >  		/*
> > diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
> > index 504b4bd..e4187e5 100644
> > --- a/virt/kvm/arm/vgic/vgic-v2.c
> > +++ b/virt/kvm/arm/vgic/vgic-v2.c
> > @@ -177,7 +177,18 @@ void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  	struct vgic_v2_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v2;
> >  	u32 vmcr;
> >  
> > -	vmcr  = (vmcrp->ctlr << GICH_VMCR_CTRL_SHIFT) & GICH_VMCR_CTRL_MASK;
> > +	vmcr = (vmcrp->grpen0 << GICH_VMCR_ENABLE_GRP0_SHIFT) &
> > +		GICH_VMCR_ENABLE_GRP0_MASK;
> > +	vmcr |= (vmcrp->grpen1 << GICH_VMCR_ENABLE_GRP1_SHIFT) &
> > +		GICH_VMCR_ENABLE_GRP1_MASK;
> > +	vmcr |= (vmcrp->ackctl << GICH_VMCR_ACK_CTL_SHIFT) &
> > +		GICH_VMCR_ACK_CTL_MASK;
> > +	vmcr |= (vmcrp->fiqen << GICH_VMCR_FIQ_EN_SHIFT) &
> > +		GICH_VMCR_FIQ_EN_MASK;
> > +	vmcr |= (vmcrp->cbpr << GICH_VMCR_CBPR_SHIFT) &
> > +		GICH_VMCR_CBPR_MASK;
> > +	vmcr |= (vmcrp->eoim << GICH_VMCR_EOI_MODE_SHIFT) &
> > +		GICH_VMCR_EOI_MODE_MASK;
> >  	vmcr |= (vmcrp->abpr << GICH_VMCR_ALIAS_BINPOINT_SHIFT) &
> >  		GICH_VMCR_ALIAS_BINPOINT_MASK;
> >  	vmcr |= (vmcrp->bpr << GICH_VMCR_BINPOINT_SHIFT) &
> > @@ -195,8 +206,19 @@ void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  
> >  	vmcr = cpu_if->vgic_vmcr;
> >  
> > -	vmcrp->ctlr = (vmcr & GICH_VMCR_CTRL_MASK) >>
> > -			GICH_VMCR_CTRL_SHIFT;
> > +	vmcrp->grpen0 = (vmcr & GICH_VMCR_ENABLE_GRP0_MASK) >>
> > +		GICH_VMCR_ENABLE_GRP0_SHIFT;
> > +	vmcrp->grpen1 = (vmcr & GICH_VMCR_ENABLE_GRP1_MASK) >>
> > +		GICH_VMCR_ENABLE_GRP1_SHIFT;
> > +	vmcrp->ackctl = (vmcr & GICH_VMCR_ACK_CTL_MASK) >>
> > +		GICH_VMCR_ACK_CTL_SHIFT;
> > +	vmcrp->fiqen = (vmcr & GICH_VMCR_FIQ_EN_MASK) >>
> > +		GICH_VMCR_FIQ_EN_SHIFT;
> > +	vmcrp->cbpr = (vmcr & GICH_VMCR_CBPR_MASK) >>
> > +		GICH_VMCR_CBPR_SHIFT;
> > +	vmcrp->eoim = (vmcr & GICH_VMCR_EOI_MODE_MASK) >>
> > +		GICH_VMCR_EOI_MODE_SHIFT;
> > +
> >  	vmcrp->abpr = (vmcr & GICH_VMCR_ALIAS_BINPOINT_MASK) >>
> >  			GICH_VMCR_ALIAS_BINPOINT_SHIFT;
> >  	vmcrp->bpr  = (vmcr & GICH_VMCR_BINPOINT_MASK) >>
> > diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> > index 6fe3f00..051cbde 100644
> > --- a/virt/kvm/arm/vgic/vgic-v3.c
> > +++ b/virt/kvm/arm/vgic/vgic-v3.c
> > @@ -159,15 +159,24 @@ void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr)
> >  void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  {
> >  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > -	u32 vmcr;
> > +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> > +	u32 vmcr = 0;
> 
> nit: drop the initialization...
> 

right

> >  
> > -	/*
> > -	 * Ignore the FIQen bit, because GIC emulation always implies
> > -	 * SRE=1 which means the vFIQEn bit is also RES1.
> > -	 */
> > -	vmcr = ((vmcrp->ctlr >> ICC_CTLR_EL1_EOImode_SHIFT) <<
> > -		 ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
> > -	vmcr |= (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
> > +	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> > +		vmcr |= (vmcrp->ackctl << ICH_VMCR_ACK_CTL_SHIFT) &
> > +			ICH_VMCR_ACK_CTL_MASK;
> 
> ... and make this a strict assignment instead of an or?
> 

yes

> > +		vmcr |= (vmcrp->fiqen << ICH_VMCR_FIQ_EN_SHIFT) &
> > +			ICH_VMCR_FIQ_EN_MASK;
> > +	} else {
> > +		/*
> > +		 * When emulating GICv3 on GICv3 with SRE=1 on the
> > +		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
> > +		 */
> > +		vmcr = ICH_VMCR_FIQ_EN_MASK;
> > +	}
> > +
> > +	vmcr |= (vmcrp->cbpr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
> > +	vmcr |= (vmcrp->eoim << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
> >  	vmcr |= (vmcrp->abpr << ICH_VMCR_BPR1_SHIFT) & ICH_VMCR_BPR1_MASK;
> >  	vmcr |= (vmcrp->bpr << ICH_VMCR_BPR0_SHIFT) & ICH_VMCR_BPR0_MASK;
> >  	vmcr |= (vmcrp->pmr << ICH_VMCR_PMR_SHIFT) & ICH_VMCR_PMR_MASK;
> > @@ -180,17 +189,27 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >  {
> >  	struct vgic_v3_cpu_if *cpu_if = &vcpu->arch.vgic_cpu.vgic_v3;
> > +	u32 model = vcpu->kvm->arch.vgic.vgic_model;
> >  	u32 vmcr;
> >  
> >  	vmcr = cpu_if->vgic_vmcr;
> >  
> > -	/*
> > -	 * Ignore the FIQen bit, because GIC emulation always implies
> > -	 * SRE=1 which means the vFIQEn bit is also RES1.
> > -	 */
> > -	vmcrp->ctlr = ((vmcr >> ICH_VMCR_EOIM_SHIFT) <<
> > -			ICC_CTLR_EL1_EOImode_SHIFT) & ICC_CTLR_EL1_EOImode_MASK;
> > -	vmcrp->ctlr |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
> > +	if (model == KVM_DEV_TYPE_ARM_VGIC_V2) {
> > +		vmcrp->ackctl = (vmcr & ICH_VMCR_ACK_CTL_MASK) >>
> > +			ICH_VMCR_ACK_CTL_SHIFT;
> > +		vmcrp->fiqen = (vmcr & ICH_VMCR_FIQ_EN_MASK) >>
> > +			ICH_VMCR_FIQ_EN_SHIFT;
> > +	} else {
> > +		/*
> > +		 * When emulating GICv3 on GICv3 with SRE=1 on the
> > +		 * VFIQEn bit is RES1 and the VAckCtl bit is RES0.
> > +		 */
> > +		vmcrp->fiqen = 1;
> > +		vmcrp->ackctl = 0;
> > +	}
> > +
> > +	vmcrp->cbpr = (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
> > +	vmcrp->eoim = (vmcr & ICH_VMCR_EOIM_MASK) >> ICH_VMCR_EOIM_SHIFT;
> >  	vmcrp->abpr = (vmcr & ICH_VMCR_BPR1_MASK) >> ICH_VMCR_BPR1_SHIFT;
> >  	vmcrp->bpr  = (vmcr & ICH_VMCR_BPR0_MASK) >> ICH_VMCR_BPR0_SHIFT;
> >  	vmcrp->pmr  = (vmcr & ICH_VMCR_PMR_MASK) >> ICH_VMCR_PMR_SHIFT;
> > diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
> > index da83e4c..bba7fa2 100644
> > --- a/virt/kvm/arm/vgic/vgic.h
> > +++ b/virt/kvm/arm/vgic/vgic.h
> > @@ -111,14 +111,18 @@ static inline bool irq_is_pending(struct vgic_irq *irq)
> >   * registers regardless of the hardware backed GIC used.
> >   */
> >  struct vgic_vmcr {
> > -	u32	ctlr;
> > +	u32	grpen0;
> > +	u32	grpen1;
> > +
> > +	u32	ackctl;
> > +	u32	fiqen;
> > +	u32	cbpr;
> > +	u32	eoim;
> > +
> >  	u32	abpr;
> >  	u32	bpr;
> >  	u32	pmr;  /* Priority mask field in the GICC_PMR and
> >  		       * ICC_PMR_EL1 priority field format */
> > -	/* Below member variable are valid only for GICv3 */
> > -	u32	grpen0;
> > -	u32	grpen1;
> >  };
> >  
> >  struct vgic_reg_attr {
> 
> Other than the couple of nits above, this looks pretty good. I've given
> it a go on my LS2085 with both v2 and v3 guests, save/restoring in a
> loop, and it worked nicely enough. Worth backporting to 4.11-stable.
> 
> Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
> Tested-by: Marc Zyngier <marc.zyngier@arm.com>
> 

Thanks!

Let me know if you'd like me to fix up the definitions.  I did remember
you talking about making all this (naming etc.) consistent some time,
and I figured we may be able to fix these up then as well?

-Christoffer
