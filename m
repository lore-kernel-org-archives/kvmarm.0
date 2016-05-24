From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 31/59] KVM: arm/arm64: vgic-new: Add CONFIG registers handlers
Date: Tue, 24 May 2016 11:09:25 +0200
Message-ID: <1464080993-10884-32-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

The config register handlers are shared between the v2 and v3
emulation, so their implementation goes into vgic-mmio.c, to be
easily referenced from the v3 emulation as well later.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v2.c |  2 +-
 virt/kvm/arm/vgic/vgic-mmio.c    | 47 ++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic/vgic-mmio.h    |  7 ++++++
 3 files changed, 55 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index d564a30..bb7389e 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -96,7 +96,7 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_CONFIG,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 2,
+		vgic_mmio_read_config, vgic_mmio_write_config, 2,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_SOFTINT,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 6f4e05b..9de80be 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -276,6 +276,53 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 	}
 }
 
+unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
+	u32 value = 0;
+	int i;
+
+	for (i = 0; i < len * 4; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		if (irq->config == VGIC_CONFIG_EDGE)
+			value |= (2U << (i * 2));
+	}
+
+	return value;
+}
+
+void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
+			    gpa_t addr, unsigned int len,
+			    unsigned long val)
+{
+	u32 intid = VGIC_ADDR_TO_INTID(addr, 2);
+	int i;
+
+	for (i = 0; i < len * 4; i++) {
+		struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
+
+		/*
+		 * The configuration cannot be changed for SGIs in general,
+		 * for PPIs this is IMPLEMENTATION DEFINED. The arch timer
+		 * code relies on PPIs being level triggered, so we also
+		 * make them read-only here.
+		 */
+		if (intid + i < VGIC_NR_PRIVATE_IRQS)
+			continue;
+
+		spin_lock(&irq->irq_lock);
+		if (test_bit(i * 2 + 1, &val)) {
+			irq->config = VGIC_CONFIG_EDGE;
+		} else {
+			irq->config = VGIC_CONFIG_LEVEL;
+			irq->pending = irq->line_level | irq->soft_pending;
+		}
+		spin_unlock(&irq->irq_lock);
+	}
+}
+
 static int match_region(const void *key, const void *elt)
 {
 	const unsigned int offset = (unsigned long)key;
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 7e73f10..d1348ac 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -136,6 +136,13 @@ void vgic_mmio_write_priority(struct kvm_vcpu *vcpu,
 			      gpa_t addr, unsigned int len,
 			      unsigned long val);
 
+unsigned long vgic_mmio_read_config(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len);
+
+void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
+			    gpa_t addr, unsigned int len,
+			    unsigned long val);
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 #endif
-- 
2.1.2.330.g565301e.dirty

