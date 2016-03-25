From: Andre Przywara <andre.przywara@arm.com>
Subject: [RFC PATCH 26/45] KVM: arm/arm64: vgic-new: Add GICv3 IDREGS register
 handler
Date: Fri, 25 Mar 2016 02:04:49 +0000
Message-ID: <1458871508-17279-27-git-send-email-andre.przywara@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D8A40BDA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l09GjXrB3MJt for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Mar 2016 22:05:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F41B4412A6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Mar 2016 22:05:03 -0400 (EDT)
In-Reply-To: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 virt/kvm/arm/vgic/vgic_mmio.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 6d74b00..544ba31 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -744,6 +744,26 @@ static int vgic_mmio_write_v3r_pendbase(struct kvm_vcpu *vcpu,
 	/* TODO: implement */
 	return 0;
 }
+
+static int vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
+				    struct kvm_io_device *this,
+				    gpa_t addr, int len, void *val)
+{
+	struct vgic_io_device *iodev = container_of(this,
+						    struct vgic_io_device, dev);
+	u32 regnr = (addr - iodev->base_addr);
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
@@ -817,6 +837,8 @@ struct vgic_register_region vgic_v3_dist_registers[] = {
 		vgic_mmio_read_config, vgic_mmio_write_config, 2),
 	REGISTER_DESC_WITH_BITS_PER_IRQ_SHARED(GICD_IGRPMODR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 1),
+	REGISTER_DESC_WITH_LENGTH(GICD_IDREGS,
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 struct vgic_register_region vgic_v3_redist_registers[] = {
@@ -830,6 +852,8 @@ struct vgic_register_region vgic_v3_redist_registers[] = {
 		vgic_mmio_read_v3r_propbase, vgic_mmio_write_v3r_propbase, 8),
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
 		vgic_mmio_read_v3r_pendbase, vgic_mmio_write_v3r_pendbase, 8),
+	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
+		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48),
 };
 
 struct vgic_register_region vgic_v3_private_registers[] = {
-- 
2.7.3
