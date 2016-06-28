From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 08/17] KVM: arm64: handle ITS related GICv3 redistributor
 registers
Date: Tue, 28 Jun 2016 13:32:21 +0100
Message-ID: <20160628123230.26255-9-andre.przywara@arm.com>
References: <20160628123230.26255-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A0C49B75
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DGGdK9heOn0p for <kvmarm@lists.cs.columbia.edu>;
 Tue, 28 Jun 2016 08:26:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A01FB49B77
 for <kvmarm@lists.cs.columbia.edu>; Tue, 28 Jun 2016 08:26:53 -0400 (EDT)
In-Reply-To: <20160628123230.26255-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In the GICv3 redistributor there are the PENDBASER and PROPBASER
registers which we did not emulate so far, as they only make sense
when having an ITS. In preparation for that emulate those MMIO
accesses by storing the 64-bit data written into it into a variable
which we later read in the ITS emulation.
We also sanitise the registers, making sure RES0 regions are respected
and checking for valid memory attributes.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/vgic/vgic.h          |  13 ++++
 virt/kvm/arm/vgic-v3.c           |  11 ++-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 143 ++++++++++++++++++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-mmio.h    |   8 +++
 4 files changed, 171 insertions(+), 4 deletions(-)

diff --git a/include/kvm/vgic/vgic.h b/include/kvm/vgic/vgic.h
index a296d94..c56331c 100644
--- a/include/kvm/vgic/vgic.h
+++ b/include/kvm/vgic/vgic.h
@@ -146,6 +146,14 @@ struct vgic_dist {
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
@@ -200,6 +208,11 @@ struct vgic_cpu {
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
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 75b02fa..5c8b2d1 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -166,6 +166,11 @@ static void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
 	vcpu->arch.vgic_cpu.vgic_v3.vgic_vmcr = vmcr;
 }
 
+#define INITIAL_PENDBASER_VALUE						  \
+	(GIC_BASER_CACHEABILITY(GICR_PENDBASER, INNER, RaWb)		| \
+	GIC_BASER_CACHEABILITY(GICR_PENDBASER, OUTER, SameAsInner)	| \
+	GIC_BASER_SHAREABILITY(GICR_PENDBASER, InnerShareable))
+
 static void vgic_v3_enable(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *vgic_v3 = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -183,10 +188,12 @@ static void vgic_v3_enable(struct kvm_vcpu *vcpu)
 	 * way, so we force SRE to 1 to demonstrate this to the guest.
 	 * This goes with the spec allowing the value to be RAO/WI.
 	 */
-	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
+	if (vcpu->kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
 		vgic_v3->vgic_sre = ICC_SRE_EL1_SRE;
-	else
+		vcpu->arch.vgic_cpu->pendbaser = INITIAL_PENDBASER_VALUE;
+	} else {
 		vgic_v3->vgic_sre = 0;
+	}
 
 	/* Get the show on the road... */
 	vgic_v3->vgic_hcr = ICH_HCR_EN;
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 829909e..7268c61 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -29,6 +29,19 @@ static unsigned long extract_bytes(unsigned long data, unsigned int offset,
 	return (data >> (offset * 8)) & GENMASK_ULL(num * 8 - 1, 0);
 }
 
+/* allows updates of any half of a 64-bit register (or the whole thing) */
+static u64 update_64bit_reg(u64 reg, unsigned int offset, unsigned int len,
+			    unsigned long val)
+{
+	int lower = (offset & 4) * 8;
+	int upper = lower + 8 * len - 1;
+
+	reg &= ~GENMASK_ULL(upper, lower);
+	val &= GENMASK_ULL(len * 8 - 1, 0);
+
+	return reg | ((u64)val << lower);
+}
+
 static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 					    gpa_t addr, unsigned int len)
 {
@@ -150,6 +163,132 @@ static unsigned long vgic_mmio_read_v3_idregs(struct kvm_vcpu *vcpu,
 	return 0;
 }
 
+/* We want to avoid outer shareable. */
+u64 vgic_sanitise_shareability(u64 reg)
+{
+	switch (reg & GIC_BASER_SHAREABILITY_MASK) {
+	case GIC_BASER_OuterShareable:
+		return GIC_BASER_InnerShareable;
+	default:
+		return reg;
+	}
+}
+
+/* Non-cacheable or same-as-inner are OK. */
+u64 vgic_sanitise_outer_cacheability(u64 reg)
+{
+	switch (reg & GIC_BASER_CACHE_MASK) {
+	case GIC_BASER_CACHE_SameAsInner:
+	case GIC_BASER_CACHE_nC:
+		return reg;
+	default:
+		return GIC_BASER_CACHE_nC;
+	}
+}
+
+/* Avoid any inner non-cacheable mapping. */
+u64 vgic_sanitise_inner_cacheability(u64 reg)
+{
+	switch (reg & GIC_BASER_CACHE_MASK) {
+	case GIC_BASER_CACHE_nCnB:
+	case GIC_BASER_CACHE_nC:
+		return GIC_BASER_CACHE_RaWb;
+	default:
+		return reg;
+	}
+}
+
+u64 vgic_sanitise_field(u64 reg, int field_shift, u64 field_mask,
+			u64 (*sanitise_fn)(u64))
+{
+	u64 field = (reg >> field_shift) & field_mask;
+
+	field = sanitise_fn(field) << field_shift;
+	return (reg & ~(field_mask << field_shift)) | field;
+}
+
+static u64 vgic_sanitise_pendbaser(u64 reg)
+{
+	reg = vgic_sanitise_field(reg, GICR_PENDBASER_SHAREABILITY_SHIFT,
+				  GIC_BASER_SHAREABILITY_MASK,
+				  vgic_sanitise_shareability);
+	reg = vgic_sanitise_field(reg, GICR_PENDBASER_INNER_CACHEABILITY_SHIFT,
+				  GIC_BASER_CACHE_MASK,
+				  vgic_sanitise_inner_cacheability);
+	reg = vgic_sanitise_field(reg, GICR_PENDBASER_OUTER_CACHEABILITY_SHIFT,
+				  GIC_BASER_CACHE_MASK,
+				  vgic_sanitise_outer_cacheability);
+	return reg;
+}
+
+static u64 vgic_sanitise_propbaser(u64 reg)
+{
+	reg = vgic_sanitise_field(reg, GICR_PROPBASER_SHAREABILITY_SHIFT,
+				  GIC_BASER_SHAREABILITY_MASK,
+				  vgic_sanitise_shareability);
+	reg = vgic_sanitise_field(reg, GICR_PROPBASER_INNER_CACHEABILITY_SHIFT,
+				  GIC_BASER_CACHE_MASK,
+				  vgic_sanitise_inner_cacheability);
+	reg = vgic_sanitise_field(reg, GICR_PROPBASER_OUTER_CACHEABILITY_SHIFT,
+				  GIC_BASER_CACHE_MASK,
+				  vgic_sanitise_outer_cacheability);
+	return reg;
+}
+
+#define PROPBASER_RES0_MASK						\
+	(GENMASK_ULL(63, 59) | GENMASK_ULL(55, 52) | GENMASK_ULL(6, 5))
+#define PENDBASER_RES0_MASK						\
+	(BIT_ULL(63) | GENMASK_ULL(61, 59) | GENMASK_ULL(55, 52) |	\
+	 GENMASK_ULL(15, 12) | GENMASK_ULL(6, 0))
+
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
+	dist->propbaser &= ~PROPBASER_RES0_MASK;
+	dist->propbaser = vgic_sanitise_propbaser(dist->propbaser);
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
+	vgic_cpu->pendbaser &= ~PENDBASER_RES0_MASK;
+	vgic_cpu->pendbaser = vgic_sanitise_pendbaser(vgic_cpu->pendbaser);
+}
+
 /*
  * The GICv3 per-IRQ registers are split to control PPIs and SGIs in the
  * redistributors, while SPIs are covered by registers in the distributor
@@ -230,10 +369,10 @@ static const struct vgic_register_region vgic_v3_rdbase_registers[] = {
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
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 8509014..e863ccc 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -147,4 +147,12 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev);
 
 unsigned int vgic_v3_init_dist_iodev(struct vgic_io_device *dev);
 
+#ifdef CONFIG_KVM_ARM_VGIC_V3
+u64 vgic_sanitise_outer_cacheability(u64 reg);
+u64 vgic_sanitise_inner_cacheability(u64 reg);
+u64 vgic_sanitise_shareability(u64 reg);
+u64 vgic_sanitise_field(u64 reg, int field_shift, u64 field_mask,
+			u64 (*sanitise_fn)(u64));
+#endif
+
 #endif
-- 
2.9.0
