From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 37/57] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Thu, 19 May 2016 19:08:16 +0100
Message-ID: <1463681316-23039-38-git-send-email-andre.przywara@arm.com>
References: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6938149B8A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:06:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ACytb-3r2RZ6 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2016 14:06:27 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B77349B88
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2016 14:05:49 -0400 (EDT)
In-Reply-To: <1463681316-23039-1-git-send-email-andre.przywara@arm.com>
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
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

We implement the only one ID register that is required by the
architecture, also this is the one that Linux actually checks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 16942e8..abf0d8d 100644
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
2.8.2
