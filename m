From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 9/9] KVM: arm/arm64: Don't assume initialized vgic
 when setting PMU IRQ
Date: Thu, 8 Jun 2017 17:18:18 +0200
Message-ID: <20170608151818.GB6378@cbox>
References: <20170608133446.3875-1-cdall@linaro.org>
 <20170608133446.3875-10-cdall@linaro.org>
 <87y3t2h7ja.fsf@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y3t2h7ja.fsf@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 08, 2017 at 03:35:05PM +0100, Marc Zyngier wrote:
> On Thu, Jun 08 2017 at  3:34:46 pm BST, Christoffer Dall <cdall@linaro.org> wrote:
> > The PMU IRQ number is set through the VCPU device's KVM_SET_DEVICE_ATTR
> > ioctl handler for the KVM_ARM_VCPU_PMU_V3_IRQ attribute, but there is no
> > enforced or stated requirement that this must happen after initializing
> > the VGIC.  As a result, calling vgic_valid_spi() which relies on the
> > nr_spis being set during the VGIC init can incorrectly fail.
> >
> > Introduce irq_is_spi, which determines if an IRQ number is within the
> > SPI range without verifying it against the actual VGIC properties.
> >
> > Signed-off-by: Christoffer Dall <cdall@linaro.org>
> > ---
> >  include/kvm/arm_vgic.h | 2 ++
> >  virt/kvm/arm/pmu.c     | 2 +-
> >  2 files changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
> > index 131668f..a2ae9d2 100644
> > --- a/include/kvm/arm_vgic.h
> > +++ b/include/kvm/arm_vgic.h
> > @@ -39,6 +39,8 @@
> >  #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
> >  
> >  #define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
> > +#define irq_is_spi(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
> > +			 (irq) <= VGIC_MAX_SPI)
> >  
> >  enum vgic_type {
> >  	VGIC_V2,		/* Good ol' GICv2 */
> > diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
> > index 26a42a9..87cb325 100644
> > --- a/virt/kvm/arm/pmu.c
> > +++ b/virt/kvm/arm/pmu.c
> > @@ -547,7 +547,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
> >  			return -EFAULT;
> >  
> >  		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
> > -		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
> > +		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
> >  			return -EINVAL;
> >  
> >  		if (!pmu_irq_is_valid(vcpu->kvm, irq))
> 
> Does it mean that we can now fail an injection if the SPI is out of the
> range of configured SPIs?
> 
> If that's the case, the WARN_ON() in kvm_pmu_update_state() is going to
> fire badly, and that's going to be ugly. Should we add a check for this
> case in kvm_arm_pmu_v3_init()?
> 

Yes, we should.  How about this fixup?


diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 5dbaa2c7..fc8a723 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -458,10 +458,24 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 	/*
 	 * A valid interrupt configuration for the PMU is either to have a
 	 * properly configured interrupt number and using an in-kernel
-	 * irqchip, or to neither set an IRQ nor create an in-kernel irqchip.
+	 * irqchip, or to not have an in-kernel GIC and not set an IRQ.
 	 */
-	if (kvm_arm_pmu_irq_initialized(vcpu) != irqchip_in_kernel(vcpu->kvm))
-		return -EINVAL;
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int irq = vcpu->arch.pmu.irq_num;
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -EINVAL;
+
+		/*
+		 * If we are using an in-kernel vgic, at this point we know
+		 * the vgic will be initialized, so we can check the PMU irq
+		 * number against the dimensions of the vgic and make sure
+		 * it's valid.
+		 */
+		if (!irq_is_ppi(irq) && !vgic_valid_spi(vcpu->kvm, irq))
+			return -EINVAL;
+	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
+		   return -EINVAL;
+	}
 
 	kvm_pmu_vcpu_reset(vcpu);
 	vcpu->arch.pmu.ready = true;


If you're happy with that, I'll just squash that into the current patch
before applying the series.

Thanks,
-Christoffer
