From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/58] KVM: arm/arm64: Don't assume initialized vgic when
 setting PMU IRQ
Date: Fri, 30 Jun 2017 09:44:42 +0100
Message-ID: <20170630084514.6779-27-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BE3E840DAC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TtCQQJSaGO9Z for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:46:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1DD440D7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:46:39 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

The PMU IRQ number is set through the VCPU device's KVM_SET_DEVICE_ATTR
ioctl handler for the KVM_ARM_VCPU_PMU_V3_IRQ attribute, but there is no
enforced or stated requirement that this must happen after initializing
the VGIC.  As a result, calling vgic_valid_spi() which relies on the
nr_spis being set during the VGIC init can incorrectly fail.

Introduce irq_is_spi, which determines if an IRQ number is within the
SPI range without verifying it against the actual VGIC properties.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h |  2 ++
 virt/kvm/arm/pmu.c     | 22 ++++++++++++++++++----
 2 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 131668f8599c..a2ae9d2de21f 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -39,6 +39,8 @@
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
 #define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
+#define irq_is_spi(irq) ((irq) >= VGIC_NR_PRIVATE_IRQS && \
+			 (irq) <= VGIC_MAX_SPI)
 
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 9923eb90cdc7..fc8a723ff387 100644
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
@@ -547,7 +561,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 			return -EFAULT;
 
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
+		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
 			return -EINVAL;
 
 		if (!pmu_irq_is_valid(vcpu->kvm, irq))
-- 
2.11.0
