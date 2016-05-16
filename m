From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 35/56] KVM: arm/arm64: vgic-new: Add GICv3 redistributor
 IIDR and TYPER handler
Date: Mon, 16 May 2016 10:53:23 +0100
Message-ID: <1463392481-26583-36-git-send-email-andre.przywara@arm.com>
References: <1463392481-26583-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3A2549AF5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:51:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l9vPX6aEUZEA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 05:51:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05FD8412DD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 05:51:59 -0400 (EDT)
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

The redistributor TYPER tells the OS about the associated MPIDR,
also the LAST bit is crucial to determine the number of redistributors.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

Changelog v3 .. v4:
- specify accessor width
- add extract_bytes() as static (moved from an earlier patch)
- replace one extract_bytes() access with a simple return

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index f11ef46..28de16a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -22,6 +22,13 @@
 #include "vgic.h"
 #include "vgic-mmio.h"
 
+/* extract @num bytes at @offset bytes offset in data */
+static unsigned long extract_bytes(unsigned long data, unsigned int offset,
+				   unsigned int num)
+{
+	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
+}
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -68,6 +75,27 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 	}
 }
 
+static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
+					      gpa_t addr, unsigned int len)
+{
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	int target_vcpu_id = vcpu->vcpu_id;
+	u64 value;
+
+	value = (mpidr & GENMASK(23, 0)) << 32;
+	value |= ((target_vcpu_id & 0xffff) << 8);
+	if (target_vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
+		value |= GICR_TYPER_LAST;
+
+	return extract_bytes(value, addr & 7, len);
+}
+
+static unsigned long vgic_mmio_read_v3r_iidr(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
+{
+	return (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -142,10 +170,10 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
+		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
-- 
2.8.2
