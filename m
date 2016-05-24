From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 32/59] KVM: arm/arm64: vgic-new: Add TARGET registers handlers
Date: Tue, 24 May 2016 11:09:26 +0200
Message-ID: <1464080993-10884-33-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EB6349C44
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:07:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lcWe8dJ7o+DK for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 May 2016 05:07:00 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C852449C1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 05:06:54 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id n129so118551821wmn.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 May 2016 02:10:28 -0700 (PDT)
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The target register handlers are v2 emulation specific, so their
implementation lives entirely in vgic-mmio-v2.c.
We copy the old VGIC behaviour of assigning an IRQ to the first VCPU
set in the target mask instead of making it possibly pending on
multiple VCPUs.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
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
2.1.2.330.g565301e.dirty
