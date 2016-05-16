From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 28/56] KVM: arm/arm64: vgic-new: Add PRIORITY registers
 handlers
Date: Mon, 16 May 2016 10:54:13 +0100
Message-ID: <1463392481-26583-86-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C09349C54
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id efaui1i75EeF for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:14 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F069F49C5E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:13 -0400 (EDT)
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

The priority register handlers are shared between the v2 and v3
emulation, so their implementation goes into vgic-mmio.c, to be
easily referenced from the v3 emulation as well later.
There is a corner case when we change the priority of a pending
interrupt which we don't handle at the moment.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width
- use IRQ number accessor macro

 virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
 virt/kvm/arm/vgic/vgic-mmio.c    | 40 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  7 +++++++
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 4 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index 12e101b..d564a30 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -90,7 +90,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_active, vgic_mmio_write_cactive, 1,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_PRI,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_priority, vgic_mmio_write_priority, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_TARGET,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 74d140e..5c8af05 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -237,6 +237,46 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 	}
 }
 
+unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
+	int i;
+	u64 val = 0;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		val |= (u64)irq->priority << (i * 8);
+	}
+
+	return val;
+}
+
+/*
+ * We currently don't handle changing the priority of an interrupt that
+ * is already pending on a VCPU. If there is a need for this, we would
+ * need to make this VCPU exit and re-evaluate the priorities, potentially
+ * leading to this interrupt getting presented now to the guest (if it has
+ * been masked by the priority mask before).
+ */
+void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 8);
+	int i;
+
+	for (i = 0; i < len; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		spin_lock(&irq->irq_lock);
+		/* Narrow the priority range to what we actually support */
+		irq->priority = (val >> (i * 8)) & GENMASK(7, 8 - VGIC_PRI_BITS);
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index dd96a71..6983922 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -117,6 +117,13 @@ void vgic_mmio_write_sactive(struct kvm_vcpu *vcpu,
 			     gpa_t addr, unsigned int len,
 			     unsigned long val);
 
+unsigned long vgic_mmio_read_priority(struct kvm_vcpu *vcpu,
+				      gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
+			      gpa_t addr, unsigned int len,
+			      unsigned long val);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 #endif
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index cf62015..e57f8d5 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -19,6 +19,8 @@
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
+#define VGIC_PRI_BITS		5
+
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
-- 
2.8.2
