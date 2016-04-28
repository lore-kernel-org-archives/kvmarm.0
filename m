From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 29/54] KVM: arm/arm64: vgic-new: Add TARGET registers
 handlers
Date: Thu, 28 Apr 2016 17:45:48 +0100
Message-ID: <1461861973-26464-30-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B84449BC8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TMAc43irCNAt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:44:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4129949B9D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:19 -0400 (EDT)
In-Reply-To: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
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

The target register handlers are v2 emulation specific, so their
implementation lives entirely in vgic-mmio-v2.c.
We copy the old VGIC behaviour of assigning an IRQ to the first VCPU
set in the target mask instead of making it possibly pending on
multiple VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- remove runtime VCPU determination from this v2-only register
- fold in implementation of vgic_v2_irq_change_affinity()
- replace ffs() with __ffs()

Changelog v1 .. v2:
- adapt to new MMIO framework

 virt/kvm/arm/vgic/vgic-mmio-v2.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 008a466..7364fd7 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -66,6 +66,47 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len)
+{
+	u32 intid = addr & 0x3ff;
+	int i;
+	u64 val = 0;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		val |= (u64)irq->targets << (i * 8);
+	}
+
+	return val;
+}
+
+static void vgic_mmio_write_target(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len,
+				   unsigned long val)
+{
+	u32 intid = addr & 0x3ff;
+	int i;
+
+	/* GICD_ITARGETSR[0-7] are read-only */
+	if (intid < VGIC_NR_PRIVATE_IRQS)
+		return;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, NULL, intid + i);
+		int target;
+
+		spin_lock(&irq->irq_lock);
+
+		irq->targets = (val >> (i * 8)) & 0xff;
+		target = irq->targets ? __ffs(irq->targets) : 0;
+		irq->target_vcpu = kvm_get_vcpu(vcpu->kvm, target);
+
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -86,7 +127,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 8),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+		vgic_mmio_read_target, vgic_mmio_write_target, 8),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
 		vgic_mmio_read_config, vgic_mmio_write_config, 2),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
-- 
2.7.3
