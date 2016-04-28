From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 25/54] KVM: arm/arm64: vgic-new: Add PENDING registers
 handlers
Date: Thu, 28 Apr 2016 17:45:44 +0100
Message-ID: <1461861973-26464-26-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C75E49B40
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kD7400gI8nMs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:44:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EE3749B5A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:13 -0400 (EDT)
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

The pending register handlers are shared between the v2 and v3
emulation, so their implementation goes into vgic-mmio.c, to be easily
referenced from the v3 emulation as well later.
For level triggered interrupts the real line level is unaffected by
this write, so we keep this state separate and combine it with the
device's level to get the actual pending state.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- remove IRQ lock from read handler
- remove TODO from clear pending handler

Changelog v1 .. v2:
- adapt to new MMIO framework

 virt/kvm/arm/vgic/vgic-mmio-v2.c |  4 +--
 virt/kvm/arm/vgic/vgic-mmio.c    | 60 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    | 12 ++++++++
 3 files changed, 74 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index d5eafe9..4797203 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -76,9 +76,9 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_CLEAR,
 		vgic_mmio_read_enable, vgic_mmio_write_cenable, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_SET,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+		vgic_mmio_read_pending, vgic_mmio_write_spending, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PENDING_CLEAR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+		vgic_mmio_read_pending, vgic_mmio_write_cpending, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_SET,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ACTIVE_CLEAR,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 120eb25..223cc84 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -102,6 +102,66 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 	}
 }
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len)
+{
+	u32 intid = (addr & 0x7f) * 8;
+	u32 value = 0;
+	int i;
+
+	/* Loop over all IRQs affected by this read */
+	for (i = 0; i < len * 8; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->pending)
+			value |= (1U << i);
+	}
+
+	return extract_bytes(value, addr & 3, len);
+}
+
+void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val)
+{
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	for_each_set_bit(i, &val, len * 8) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		irq->pending = true;
+		if (irq->config == VGIC_CONFIG_LEVEL)
+			irq->soft_pending = true;
+
+		vgic_queue_irq_unlock(vcpu->kvm, irq);
+	}
+}
+
+void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val)
+{
+	u32 intid = (addr & 0x7f) * 8;
+	int i;
+
+	for_each_set_bit(i, &val, len * 8) {
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
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 188909a..d4fc029 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -85,6 +85,18 @@ void vgic_mmio_write_cenable(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
+unsigned long vgic_mmio_read_pending(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_spending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val);
+
+void vgic_mmio_write_cpending(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val);
+
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 #endif
-- 
2.7.3
