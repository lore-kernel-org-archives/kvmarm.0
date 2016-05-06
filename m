From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 33/55] KVM: arm/arm64: vgic-new: Add GICv3 CTLR, IIDR,
 TYPER handlers
Date: Fri,  6 May 2016 11:45:46 +0100
Message-ID: <1462531568-9799-34-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B3649C4A
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fMvqBMT457sG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA91C49C3C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:49 -0400 (EDT)
In-Reply-To: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
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

As in the GICv2 emulation we handle those three registers in one
function.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog RFC..v1:
- kick VCPUs if distributor gets enabled

Changelog v1 .. v2:
- rewrite write handler to use switch statement

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 50 +++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic.h         |  2 ++
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 06c7ec5..5f4558c 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -22,6 +22,54 @@
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
+	return extract_bytes(value, addr & 3, len);
+}
+
+static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
+				    gpa_t addr, unsigned int len,
+				    unsigned long val)
+{
+	switch (addr & 0x0c) {
+	case GICD_CTLR:
+		if (!(addr & 1)) {
+			struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+			bool was_enabled = dist->enabled;
+
+			dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
+
+			if (!was_enabled && dist->enabled)
+				vgic_kick_vcpus(vcpu->kvm);
+		}
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
@@ -46,7 +94,7 @@
 
 static const struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICD_CTLR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
+		vgic_mmio_read_v3_misc, vgic_mmio_write_v3_misc, 16),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGROUPR,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_ISENABLER,
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 39a8a65..635e2e2 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -19,6 +19,8 @@
 #define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
 #define IMPLEMENTER_ARM		0x43b
 
+#define INTERRUPT_ID_BITS_SPIS	10
+
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
-- 
2.7.3
