From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 34/55] KVM: arm/arm64: vgic-new: Add GICv3 redistributor
 IIDR and TYPER handler
Date: Fri,  6 May 2016 11:45:47 +0100
Message-ID: <1462531568-9799-35-git-send-email-andre.przywara@arm.com>
References: <1462531568-9799-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 175EF49C10
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fR3JgZiC7OUN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  6 May 2016 06:43:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FD6349C53
 for <kvmarm@lists.cs.columbia.edu>; Fri,  6 May 2016 06:43:51 -0400 (EDT)
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

The redistributor TYPER tells the OS about the associated MPIDR,
also the LAST bit is crucial to determine the number of redistributors.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v1 .. v2:
- adapt to new MMIO framework

 virt/kvm/arm/vgic/vgic-mmio-v3.c | 44 ++++++++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 5f4558c..d137242 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -71,6 +71,46 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 }
 
 /*
+ * We use a compressed version of the MPIDR (all 32 bits in one 32-bit word)
+ * when we store the target MPIDR written by the guest.
+ */
+static u32 compress_mpidr(unsigned long mpidr)
+{
+	u32 ret;
+
+	ret = MPIDR_AFFINITY_LEVEL(mpidr, 0);
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8;
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16;
+	ret |= MPIDR_AFFINITY_LEVEL(mpidr, 3) << 24;
+
+	return ret;
+}
+
+static unsigned long vgic_mmio_read_v3r_typer(struct kvm_vcpu *vcpu,
+					      gpa_t addr, unsigned int len)
+{
+	unsigned long mpidr = kvm_vcpu_get_mpidr_aff(vcpu);
+	int target_vcpu_id = vcpu->vcpu_id;
+	u64 value;
+
+	value = (u64)compress_mpidr(mpidr) << 32;
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
+	u32 value;
+
+	value = (PRODUCT_ID_KVM << 24) | (IMPLEMENTER_ARM << 0);
+	return extract_bytes(value, addr & 3, len);
+}
+
+/*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
  * block. Trying to set private IRQs in this block gets ignored.
@@ -127,9 +167,9 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GICR_CTLR,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
 	REGISTER_DESC_WITH_LENGTH(GICR_IIDR,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 4),
+		vgic_mmio_read_v3r_iidr, vgic_mmio_write_wi, 4),
 	REGISTER_DESC_WITH_LENGTH(GICR_TYPER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
+		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8),
 	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 8),
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
-- 
2.7.3
