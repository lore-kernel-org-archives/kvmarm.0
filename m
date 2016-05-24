From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 36/59] KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR, TYPER handlers
Date: Tue, 24 May 2016 11:09:30 +0200
Message-ID: <1464080993-10884-37-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

As in the GICv2 emulation we handle those three registers in one
function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 48 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h         |  1 +
 2 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 83a6654..bd062b8 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -22,6 +22,52 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
+					    gpa_t addr, unsigned int len)
+{
+	u32 value = 0;
+
+	switch (addr & 0x0c) {
+	case GICD_CTLR:
+		if (vcpu->kvm->arch.vgic.enabled)
+			value |= GICD_CTLR_ENABLE_SS_G1;
+		value |= GICD_CTLR_ARE_NS | GICD_CTLR_DS;
+		break;
+	case GICD_TYPER:
+		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+		value = (value >> 5) - 1;
+		value |= (INTERRUPT_ID_BITS_SPIS - 1) << 19;
+		break;
+	case GICD_IIDR:
+		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+		break;
+	default:
+		return 0;
+	}
+
+	return value;
+}
+
+static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	bool was_enabled = dist->enabled;
+
+	switch (addr & 0x0c) {
+	case GICD_CTLR:
+		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
+
+		if (!was_enabled && dist->enabled)
+			vgic_kick_vcpus(vcpu->kvm);
+		break;
+	case GICD_TYPER:
+	case GICD_IIDR:
+		return;
+	}
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -48,7 +94,7 @@
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16,
+		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 6742b11..44c6a1b 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -19,6 +19,7 @@
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
+#define INTERRUPT_ID_BITS_SPIS	10
 #define VGIC_PRI_BITS		5
 
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
-- 
2.1.2.330.g565301e.dirty

