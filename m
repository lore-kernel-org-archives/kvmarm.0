From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 19/45] KVM: arm/arm64: vgic-new: Add CONFIG registers handlers
Date: Fri, 15 Apr 2016 18:11:30 +0100
Message-ID: <1460740316-8755-20-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 04F9F49C14
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id N9ai9g7oY4HT for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:30 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 35E4B49C4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:30 -0400 (EDT)
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
---
 virt/kvm/arm/vgic/vgic_mmio.c | 62 ++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 61 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 3c3dbce..a8a96c8 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -477,6 +477,66 @@ static int vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_config(struct kvm_vcpu *vcpu,
+				 struct kvm_io_device *dev,
+				 gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0xff) * 4;
+	u32 value = 0;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for (i = 0; i < len * 4; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->config == VGIC_CONFIG_EDGE)
+			value |= (2U << (i * 2));
+	}
+
+	write_mask32(value, addr & 3, len, val);
+	return 0;
+}
+
+static int vgic_mmio_write_config(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *dev,
+				  gpa_t addr, int len, const void *val)
+{
+	struct vgic_io_device *iodev = container_of(dev,
+						    struct vgic_io_device, dev);
+	u32 intid = (addr & 0xff) * 4;
+	int i;
+
+	if (iodev->redist_vcpu)
+		vcpu = iodev->redist_vcpu;
+
+	for (i = 0; i < len * 4; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (intid + i < 16)
+			continue;
+
+		/*
+		 * The spec says that interrupts must be disabled before
+		 * changing the configuration to avoid UNDEFINED behaviour.
+		 */
+
+		spin_lock(&irq->irq_lock);
+		if (test_bit(i * 2 + 1, val)) {
+			irq->config = VGIC_CONFIG_EDGE;
+		} else {
+			irq->config = VGIC_CONFIG_LEVEL;
+			irq->pending = irq->line_level | irq->soft_pending;
+		}
+		spin_unlock(&irq->irq_lock);
+	}
+
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -499,7 +559,7 @@ struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
 		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 8),
+		vgic_mmio_read_config, vgic_mmio_write_config, 2),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
 		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 4),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SGI_PENDING_CLEAR,
-- 
2.7.3
