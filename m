From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH v3 9/9] KVM: arm/arm64: Don't assume initialized vgic when
 setting PMU IRQ
Date: Thu,  8 Jun 2017 15:34:46 +0200
Message-ID: <20170608133446.3875-10-cdall@linaro.org>
References: <20170608133446.3875-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3FAC408EB
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SMYe0ZVYXDba for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Jun 2017 09:30:53 -0400 (EDT)
Received: from mail-wm0-f52.google.com (mail-wm0-f52.google.com [74.125.82.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BBA2B40D38
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Jun 2017 09:30:50 -0400 (EDT)
Received: by mail-wm0-f52.google.com with SMTP id d73so31216080wma.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 08 Jun 2017 06:35:00 -0700 (PDT)
In-Reply-To: <20170608133446.3875-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvm@vger.kernel.org, Christoffer Dall <cdall@linaro.org>
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
index 26a42a9..87cb325 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -547,7 +547,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 			return -EFAULT;
 
 		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(irq) || vgic_valid_spi(vcpu->kvm, irq)))
+		if (!(irq_is_ppi(irq) || irq_is_spi(irq)))
 			return -EINVAL;
 
 		if (!pmu_irq_is_valid(vcpu->kvm, irq))
-- 
2.9.0
