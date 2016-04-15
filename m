From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 26/45] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Fri, 15 Apr 2016 18:11:37 +0100
Message-ID: <1460740316-8755-27-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D82BA49C1E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WVcgwoPIlzYN for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EEB049C04
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:40 -0400 (EDT)
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
 virt/kvm/arm/vgic/vgic_mmio.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 7d275a7..dafa235 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -784,6 +784,23 @@ static int vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *dev,
+				    gpa_t addr, int len, void *val)
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
+	write_mask32(reg , addr & 3, len, val);
+	return 0;
+}
 #endif
 
 /*
@@ -860,7 +877,7 @@ struct vgic_register_region vgic_v3_dist_registers[] = {
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IROUTER,
 		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 64),
 	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
-		vgic_mmio_read_nyi, vgic_mmio_write_wi, 48),
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 struct vgic_register_region vgic_v3_redist_registers[] = {
@@ -875,7 +892,7 @@ struct vgic_register_region vgic_v3_redist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
-		vgic_mmio_read_nyi, vgic_mmio_write_wi, 48),
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 struct vgic_register_region vgic_v3_private_registers[] = {
-- 
2.7.3
