From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 38/59] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register handler
Date: Tue, 24 May 2016 11:09:32 +0200
Message-ID: <1464080993-10884-39-git-send-email-christoffer.dall@linaro.org>
References: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464080993-10884-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

We implement the only one ID register that is required by the
architecture, also this is the one that Linux actually checks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 64edd23..22e512c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -96,6 +96,18 @@ static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
 }
 
+static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
+					      gpa_t addr, unsigned int len)
+{
+	switch (addr & 0xffff) {
+	case GICD_PIDR2:
+		/* report a GICv3 compliant implementation */
+		return 0x3b;
+	}
+
+	return 0;
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -161,7 +173,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 64,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 48,
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
 };
 
@@ -182,7 +194,7 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 48,
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
 		VGIC_ACCESS_32bit),
 };
 
-- 
2.1.2.330.g565301e.dirty

