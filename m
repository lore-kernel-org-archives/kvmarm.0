From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 14/45] KVM: arm/arm64: vgic-new: Add CTLR,
 TYPER and IIDR handlers
Date: Fri, 15 Apr 2016 18:11:25 +0100
Message-ID: <1460740316-8755-15-git-send-email-andre.przywara@arm.com>
References: <1460740316-8755-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 33B8349C34
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:25 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZrT3lN4k2xsZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Apr 2016 13:10:24 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C944C49C0D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Apr 2016 13:10:22 -0400 (EDT)
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

Changelog RFC..v1:
- kick VCPUs is the distributor gets enabled
- improve comment
---
 virt/kvm/arm/vgic/vgic.h      |  3 +++
 virt/kvm/arm/vgic/vgic_mmio.c | 50 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 52 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 8f5d50a..59fddbf 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -16,6 +16,9 @@
 #ifndef __KVM_ARM_VGIC_NEW_H__
 #define __KVM_ARM_VGIC_NEW_H__
 
+#define PRODUCT_ID_KVM		0x4b	/* ASCII code K */
+#define IMPLEMENTER_ARM		0x43b
+
 #define vgic_irq_is_sgi(intid) ((intid) < VGIC_NR_SGIS)
 
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, struct kvm_vcpu *vcpu,
diff --git a/virt/kvm/arm/vgic/vgic_mmio.c b/virt/kvm/arm/vgic/vgic_mmio.c
index 21c78a7..8ef1902 100644
--- a/virt/kvm/arm/vgic/vgic_mmio.c
+++ b/virt/kvm/arm/vgic/vgic_mmio.c
@@ -90,9 +90,57 @@ static int vgic_mmio_write_nyi(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static int vgic_mmio_read_v2_misc(struct kvm_vcpu *vcpu,
+				  struct kvm_io_device *dev,
+				  gpa_t addr, int len, void *val)
+{
+	u32 value;
+
+	switch (addr & 0x0c) {
+	case 0x0:
+		value = vcpu->kvm->arch.vgic.enabled ? GICD_ENABLE : 0;
+		break;
+	case 0x4:
+		value = vcpu->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
+		value = (value >> 5) - 1;
+		value |= (atomic_read(&vcpu->kvm->online_vcpus) - 1) << 5;
+		break;
+	case 0x8:
+		value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+		break;
+	default:
+		return 0;
+	}
+
+	write_mask32(value, addr & 3, len, val);
+	return 0;
+}
+
+static int vgic_mmio_write_v2_misc(struct kvm_vcpu *vcpu,
+				   struct kvm_io_device *dev,
+				   gpa_t addr, int len, const void *val)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	bool was_enabled = dist->enabled;
+
+	/*
+	 * GICD_TYPER and GICD_IIDR are read-only, the upper three bytes of
+	 * GICD_CTLR are reserved.
+	 */
+	if ((addr & 0x0f) >= 1)
+		return 0;
+
+	vcpu->kvm->arch.vgic.enabled = (*(u32 *)val) ? true : false;
+
+	if (!was_enabled && dist->enabled)
+		vgic_kick_vcpus(vcpu->kvm);
+
+	return 0;
+}
+
 struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
-		vgic_mmio_read_nyi, vgic_mmio_write_nyi, 12),
+		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_IGROUP,
 		vgic_mmio_read_rao, vgic_mmio_write_wi, 1),
 	REGISTER_DESC_WITH_BITS_PER_IRQ(GIC_DIST_ENABLE_SET,
-- 
2.7.3
