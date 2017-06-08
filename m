From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 3/9] KVM: arm/arm64: Move irq_is_ppi() to header file
Date: Thu,  8 Jun 2017 15:34:40 +0200
Message-ID: <20170608133446.3875-4-cdall@linaro.org>
References: <20170608133446.3875-1-cdall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170608133446.3875-1-cdall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We are about to need this define in the arch timer code as well so move
it to a common location.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h | 2 ++
 virt/kvm/arm/pmu.c     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 97b8d37..dde59fb 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -38,6 +38,8 @@
 #define VGIC_MIN_LPI		8192
 #define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
 
+#define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
+
 enum vgic_type {
 	VGIC_V2,		/* Good ol' GICv2 */
 	VGIC_V3,		/* New fancy GICv3 */
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 96a9cab..574feff 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -496,8 +496,6 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
-#define irq_is_ppi(irq) ((irq) >= VGIC_NR_SGIS && (irq) < VGIC_NR_PRIVATE_IRQS)
-
 /*
  * For one VM the interrupt type must be same for each vcpu.
  * As a PPI, the interrupt number is the same for all vcpus,
-- 
2.9.0
