From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH 05/13] KVM: arm64: handle ITS related GICv3 redistributor registers
Date: Fri, 29 May 2015 10:53:21 +0100
Message-ID: <1432893209-27313-6-git-send-email-andre.przywara@arm.com>
References: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432893209-27313-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: christoffer.dall@linaro.org, marc.zyngier@arm.com
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

In the GICv3 redistributor there are the PENDBASER and PROPBASER
registers which we did not emulate so far, as they only make sense
when having an ITS. In preparation for that emulate those MMIO
accesses by storing the 64-bit data written into it into a variable
which we later read in the ITS emulation.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 include/kvm/arm_vgic.h      |  4 ++++
 virt/kvm/arm/vgic-v3-emul.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic.c         | 35 +++++++++++++++++++++++++++++++++++
 virt/kvm/arm/vgic.h         |  4 ++++
 4 files changed, 86 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 37725bb..9ea0b3b 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -256,6 +256,10 @@ struct vgic_dist {
 	struct vgic_vm_ops	vm_ops;
 	struct vgic_io_device	dist_iodev;
 	struct vgic_io_device	*redist_iodevs;
+
+	u64			propbaser;
+	u64			*pendbaser;
+	bool			lpis_enabled;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 16c6d8a..04f3aed 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -607,6 +607,37 @@ static bool handle_mmio_cfg_reg_redist(struct kvm_vcpu *vcpu,
 	return vgic_handle_cfg_reg(reg, mmio, offset);
 }
 
+/* We don't trigger any actions here, just store the register value */
+static bool handle_mmio_propbaser_redist(struct kvm_vcpu *vcpu,
+					 struct kvm_exit_mmio *mmio,
+					 phys_addr_t offset)
+{
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	int mode = ACCESS_READ_VALUE;
+
+	mode |= dist->lpis_enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
+	vgic_handle_base_register(vcpu, mmio, offset, &dist->propbaser, mode);
+
+	return false;
+}
+
+/* We don't trigger any actions here, just store the register value */
+static bool handle_mmio_pendbaser_redist(struct kvm_vcpu *vcpu,
+					 struct kvm_exit_mmio *mmio,
+					 phys_addr_t offset)
+{
+	struct kvm_vcpu *rdvcpu = mmio->private;
+	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
+	int mode = ACCESS_READ_VALUE;
+
+	/* Storing a value with LPIs already enabled is undefined */
+	mode |= dist->lpis_enabled ? ACCESS_WRITE_IGNORED : ACCESS_WRITE_VALUE;
+	vgic_handle_base_register(vcpu, mmio, offset,
+				  &dist->pendbaser[rdvcpu->vcpu_id], mode);
+
+	return false;
+}
+
 #define SGI_base(x) ((x) + SZ_64K)
 
 static const struct vgic_io_range vgic_redist_ranges[] = {
@@ -635,6 +666,18 @@ static const struct vgic_io_range vgic_redist_ranges[] = {
 		.handle_mmio    = handle_mmio_raz_wi,
 	},
 	{
+		.base		= GICR_PENDBASER,
+		.len		= 0x08,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_pendbaser_redist,
+	},
+	{
+		.base		= GICR_PROPBASER,
+		.len		= 0x08,
+		.bits_per_irq	= 0,
+		.handle_mmio	= handle_mmio_propbaser_redist,
+	},
+	{
 		.base           = GICR_IDREGS,
 		.len            = 0x30,
 		.bits_per_irq   = 0,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 2e9723aa..0a9236d 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -448,6 +448,41 @@ void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
 	}
 }
 
+/* handle a 64-bit register access */
+void vgic_handle_base_register(struct kvm_vcpu *vcpu,
+			       struct kvm_exit_mmio *mmio,
+			       phys_addr_t offset, u64 *basereg,
+			       int mode)
+{
+	u32 reg;
+	u64 breg;
+
+	switch (offset & ~3) {
+	case 0x00:
+		breg = *basereg;
+		reg = lower_32_bits(breg);
+		vgic_reg_access(mmio, &reg, offset & 3, mode);
+		if (mmio->is_write && (mode & ACCESS_WRITE_VALUE)) {
+			breg &= GENMASK_ULL(63, 32);
+			breg |= reg;
+			*basereg = breg;
+		}
+		break;
+	case 0x04:
+		breg = *basereg;
+		reg = upper_32_bits(breg);
+		vgic_reg_access(mmio, &reg, offset & 3, mode);
+		if (mmio->is_write && (mode & ACCESS_WRITE_VALUE)) {
+			breg  = lower_32_bits(breg);
+			breg |= (u64)reg << 32;
+			*basereg = breg;
+		}
+		break;
+	}
+}
+
+
+
 bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
 			phys_addr_t offset)
 {
diff --git a/virt/kvm/arm/vgic.h b/virt/kvm/arm/vgic.h
index a093f5c..b2d791c 100644
--- a/virt/kvm/arm/vgic.h
+++ b/virt/kvm/arm/vgic.h
@@ -71,6 +71,10 @@ void vgic_reg_access(struct kvm_exit_mmio *mmio, u32 *reg,
 		     phys_addr_t offset, int mode);
 bool handle_mmio_raz_wi(struct kvm_vcpu *vcpu, struct kvm_exit_mmio *mmio,
 			phys_addr_t offset);
+void vgic_handle_base_register(struct kvm_vcpu *vcpu,
+			       struct kvm_exit_mmio *mmio,
+			       phys_addr_t offset, u64 *basereg,
+			       int mode);
 
 static inline
 u32 mmio_data_read(struct kvm_exit_mmio *mmio, u32 mask)
-- 
2.3.5

