From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v5 05/13] KVM: arm64: handle ITS related GICv3 redistributor registers
Date: Fri,  3 Jun 2016 15:02:44 +0100
Message-ID: <1464962572-3925-6-git-send-email-andre.przywara@arm.com>
References: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1464962572-3925-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

In the GICv3 redistributor there are the PENDBASER and PROPBASER
registers which we did not emulate so far, as they only make sense
when having an ITS. In preparation for that emulate those MMIO
accesses by storing the 64-bit data written into it into a variable
which we later read in the ITS emulation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h          | 13 +++++++++
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 58 ++++++++++++++++++++++++++++++++++++++--
 2 files changed, 69 insertions(+), 2 deletions(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index 2f26f37..896175b 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -145,6 +145,14 @@ struct vgic_dist {
 	struct vgic_irq		*spis;
 
 	struct vgic_io_device	dist_iodev;
+
+	/*
+	 * Contains the address of the LPI configuration table.
+	 * Since we report GICR_TYPER.CommonLPIAff as 0b00, we can share
+	 * one address across all redistributors.
+	 * GICv3 spec: 6.1.2 "LPI Configuration tables"
+	 */
+	u64			propbaser;
 };
 
 struct vgic_v2_cpu_if {
@@ -199,6 +207,11 @@ struct vgic_cpu {
 	 */
 	struct vgic_io_device	rd_iodev;
 	struct vgic_io_device	sgi_iodev;
+
+	/* Points to the LPI pending tables for the redistributor */
+	u64 pendbaser;
+
+	bool lpis_enabled;
 };
 
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index fc7b6c9..6293b36 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -29,6 +29,16 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
 	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
 }
 
+/* allows updates of any half of a 64-bit register (or the whole thing) */
+static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
+			    unsigned long val)
+{
+	offset &= 4;
+	reg &= GENMASK_ULL(len * 8 - 1, 0) << ((len - offset) * 8);
+
+	return reg | ((u64)val << (offset * 8));
+}
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -147,6 +157,50 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+static unsigned long vgic_mmio_read_propbase(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+
+	return extract_bytes(dist->propbaser, addr & 7, len);
+}
+
+static void vgic_mmio_write_propbase(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	/* Storing a value with LPIs already enabled is undefined */
+	if (vgic_cpu->lpis_enabled)
+		return;
+
+	dist->propbaser = update_64bit_reg(dist->propbaser, addr & 4, len, val);
+}
+
+static unsigned long vgic_mmio_read_pendbase(struct kvm_vcpu *vcpu,
+					     gpa_t addr, unsigned int len)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	return extract_bytes(vgic_cpu->pendbaser, addr & 7, len);
+}
+
+static void vgic_mmio_write_pendbase(struct kvm_vcpu *vcpu,
+				     gpa_t addr, unsigned int len,
+				     unsigned long val)
+{
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+	/* Storing a value with LPIs already enabled is undefined */
+	if (vgic_cpu->lpis_enabled)
+		return;
+
+	vgic_cpu->pendbaser = update_64bit_reg(vgic_cpu->pendbaser,
+					       addr & 4, len, val);
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -227,10 +281,10 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
 		vgic_mmio_read_v3r_typer, vgic_mmio_write_wi, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_PROPBASER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_propbase, vgic_mmio_write_propbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_PENDBASER,
-		vgic_mmio_read_raz, vgic_mmio_write_wi, 8,
+		vgic_mmio_read_pendbase, vgic_mmio_write_pendbase, 8,
 		VGIC_ACCESS_64bit | VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IDREGS,
 		vgic_mmio_read_v3_idregs, vgic_mmio_write_wi, 48,
-- 
2.8.2

