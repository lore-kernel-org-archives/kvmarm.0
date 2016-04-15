From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 22/45] KVM: arm/arm64: vgic-new: Add SGIPENDR register handlers
Date: Fri, 15 Apr 2016 18:11:33 +0100
Message-ID: <1460740316-8755-23-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1CE749BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6uiVpt7bbjbH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A1B7149BFA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:34 -0400 (EDT)
In-Reply-To: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Changelog RFC..v1:
- remove IRQ lock from read handler
- update pending bit on setting the first / clearing the last bit
- queue virtual IRQ if necessary
---
 virt/kvm/arm/vgic/vgic_mmio.c | 64 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 62 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 83641b3..daa2e00 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -624,6 +624,66 @@ static int vgic_mmio_write_sgir(struct kvm_vcpu *source_vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_sgipend(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *dev,
+				  gpa_t addr, int len, void *val)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		((u8 *)val)[i] = irq->source;
+	}
+	return 0;
+}
+
+static int vgic_mmio_write_sgipendc(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, const void *val)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		irq->source &= ~((u8 *)val)[i];
+		if (!irq->source)
+			irq->pending = false;
+
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
+static int vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, const void *val)
+{
+	u32 intid = addr & 0x0f;
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		irq->source |= ((u8 *)val)[i];
+
+		if (irq->source) {
+			irq->pending = true;
+			vgic_queue_irq_unlock(vcpu->kvm, irq);
+		} else {
+			spin_unlock(&irq->irq_lock);
+		}
+	}
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -650,9 +710,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
 		vgic_mmio_read_raz, vgic_mmio_write_sgir, 4),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipendc, 16),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_SET,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 16),
+		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
 /* Find the proper register handler entry given a certain address offset. */
-- 
2.7.3
