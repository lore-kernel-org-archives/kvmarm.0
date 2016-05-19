From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 31/57] KVM: arm/arm64: vgic-new: Add TARGET registers handlers
Date: Thu, 19 May 2016 19:08:10 +0100
Message-ID: <1463681316-23039-32-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The target register handlers are v2 emulation specific, so their
implementation lives entirely in vgic-mmio-v2.c.
We copy the old VGIC behaviour of assigning an IRQ to the first VCPU
set in the target mask instead of making it possibly pending on
multiple VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
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

