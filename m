From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 11/55] KVM: arm/arm64: pmu: abstract access to number of
 SPIs
Date: Fri,  6 May 2016 11:45:24 +0100
Message-ID: <1462531568-9799-12-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9C5B349BD3
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cb4KB2jnZwEZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A93F49BB7
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:16 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
index 452bb85..c14ff77 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -347,6 +347,8 @@ bool kvm_vgic_map_is_active(struct kvm_vcpu *vcpu, unsigned int virt_irq);
 #define irqchip_in_kernel(k)	(!!((k)->arch.vgic.in_kernel))
 #define vgic_initialized(k)	(!!((k)->arch.vgic.nr_cpus))
 #define vgic_ready(k)		((k)->arch.vgic.ready)
+#define vgic_valid_spi(k, i)	(((i) >= VGIC_NR_PRIVATE_IRQS) && \
+				 ((i) < (k)->arch.vgic.nr_irqs))
 
 int vgic_v2_probe(struct device_node *vgic_node,
 		  const struct vgic_ops **ops,
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 575c7aa..bd2e872 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -477,7 +477,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		 * the interrupt number is the same for all vcpus, while as an
 		 * SPI it must be a separate number per vcpu.
 		 */
-		if (irq < VGIC_NR_SGIS || irq >= vcpu->kvm->arch.vgic.nr_irqs ||
+		if (irq < VGIC_NR_SGIS || !vgic_valid_spi(vcpu->kvm, irq) ||
 		    !irq_is_valid(vcpu->kvm, irq, irq < VGIC_NR_PRIVATE_IRQS))
 			return -EINVAL;
 
-- 
2.7.3
