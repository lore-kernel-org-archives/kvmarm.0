From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 03/45] KVM: arm/arm64: pmu: abstract access to number of SPIs
Date: Fri, 15 Apr 2016 18:11:14 +0100
Message-ID: <1460740316-8755-4-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently the PMU uses a member of the struct vgic_dist directly,
which not only breaks abstraction, but will fail with the new VGIC.
Abstract this access in the VGIC header file.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h | 2 ++
 virt/kvm/arm/pmu.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 452bb85..472d556 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,6 +347,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
+#define vgic_valid_spi(k,i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
+				 ((i) < (k)->arch.vgic.nr_irqs))
 
 int vgic_v2_probe(struct device_node *vgic_node,
 		  const struct vgic_ops **ops,
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index b5754c6..0b2c1fa 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -476,7 +476,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		 * the interrupt number is the same for all vcpus, while as an
 		 * SPI it must be a separate number per vcpu.
 		 */
-		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
+		if (irq < VGIC_NR_SGIS || !vgic_valid_spi(vcpu->kvm, irq) ||
 		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
 			return -EINVAL;
 
-- 
2.7.3

