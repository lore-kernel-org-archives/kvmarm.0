From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 35/54] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Thu, 28 Apr 2016 17:45:54 +0100
Message-ID: <1461861973-26464-36-git-send-email-andre.przywara@arm.com>
References: <1461861973-26464-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 312FE49B7B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lLlRFD7wTox9 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Apr 2016 12:44:28 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B8549BDC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Apr 2016 12:44:27 -0400 (EDT)
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

We implement the only one ID register that is required by the
architecture, also this is the one that Linux actually checks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 5029281..e6f2607 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -110,6 +110,22 @@ static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 	return extract_bytes(value, addr & 3, len);
 }
 
+static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
+					      gpa_t addr, unsigned int len)
+{
+	u32 regnr = (addr & 0x3f) - (GICD_IDREGS & 0x3f);
+	u32 reg = 0;
+
+	switch (regnr + GICD_IDREGS) {
+	case GICD_PIDR2:
+		/* report a GICv3 compliant implementation */
+		reg = 0x3b;
+		break;
+	}
+
+	return extract_bytes(reg, addr & 3, len);
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -160,7 +176,7 @@ static const struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 64),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 static const struct vgic_register_region vgic_v3_redist_registers[] = {
@@ -175,7 +191,7 @@ static const struct vgic_register_region vgic_v3_redist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 48),
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 static const struct vgic_register_region vgic_v3_private_registers[] = {
-- 
2.7.3
