From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v2 9/9] KVM: arm/arm64: Don't assume initialized vgic when setting PMU IRQ
Date: Tue, 16 May 2017 20:45:56 +0200
Message-ID: <20170516184556.26785-10-cdall@linaro.org>
References: <20170516184556.26785-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170516184556.26785-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

The PMU IRQ number is set through the VCPU device's KVM_SET_DEVICE_ATTR
ioctl handler for the KVM_ARM_VCPU_PMU_V3_IRQ attribute, but there is no
enforced or stated requirement that this must happen after initializing
the VGIC.  As a result, calling vgic_valid_spi() which relies on the
nr_spis being set during the VGIC init can incorrectly fail.

Introduce irq_is_spi, which determines if an IRQ number is within the
SPI range without verifying it against the actual VGIC properties.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 include/kvm/arm_vgic.h | 2 ++
 virt/kvm/arm/pmu.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 131668f..a2ae9d2 100644
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
index 006a033..9b30b10 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -532,7 +532,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 			return -EFAULT;
 
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
+		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
 			return -EINVAL;
 
 		if (!pmu_irq_is_valid(vcpu->kvm, irq))
-- 
2.9.0
