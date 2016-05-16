From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 36/56] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Mon, 16 May 2016 10:54:21 +0100
Message-ID: <1463392481-26583-94-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B7C449BAD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7E9miXe+Dn4x for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:53:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC2B449B80
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:53:25 -0400 (EDT)
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

We implement the only one ID register that is required by the
architecture, also this is the one that Linux actually checks.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 28de16a..b893284 100644
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
