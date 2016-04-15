From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 16/45] KVM: arm/arm64: vgic-new: Add PENDING registers handlers
Date: Fri, 15 Apr 2016 18:11:27 +0100
Message-ID: <1460740316-8755-17-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A71749C05
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vDyGZagR3vtC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0AE149C3F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:25 -0400 (EDT)
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

Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Changelog RFC..v1:
- remove IRQ lock from read handler
- remove TODO from clear pending handler
---
 virt/kvm/arm/vgic/vgic_mmio.c | 84 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 82 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index b9850eb..7010b15 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -214,6 +214,86 @@ static int vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *dev,
+				  gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	u32 value = 0;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	/* Loop over all IRQs affected by this read */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->pending)
+			value |= (1U << i);
+	}
+
+	write_mask32(value, addr & 3, len, val);
+	return 0;
+}
+
+static int vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for_each_set_bit(i, val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = true;
+		if (irq->config == VGIC_CONFIG_LEVEL)
+			irq->soft_pending = true;
+
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	}
+
+	return 0;
+}
+
+static int vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for_each_set_bit(i, val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+
+		if (irq->config == VGIC_CONFIG_LEVEL) {
+			irq->soft_pending = false;
+			irq->pending = irq->line_level;
+		} else {
+			irq->pending = false;
+		}
+
+		spin_unlock(&irq->irq_lock);
+	}
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -224,9 +304,9 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
-- 
2.7.3
