From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 30/56] KVM: arm/arm64: vgic-new: Add TARGET registers
 handlers
Date: Mon, 16 May 2016 10:54:15 +0100
Message-ID: <1463392481-26583-88-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1804C49C6C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p1Xz6zRkRiBH for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:17 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA08B49C69
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:16 -0400 (EDT)
In-Reply-To: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
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

Changelog v3 .. v4:
- specify accessor width
- use IRQ number accessor macro

 virt/kvm/arm/vgic/vgic-mmio-v2.c | 43 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index bb7389e..52389ff 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -64,6 +64,47 @@ static void vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static unsigned long vgic_mmio_read_target(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
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
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
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
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12,
@@ -93,7 +134,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_target, vgic_mmio_write_target, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
 		vgic_mmio_read_config, vgic_mmio_write_config, 2,
-- 
2.8.2
