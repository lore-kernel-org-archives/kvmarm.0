From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH] KVM: arm/arm64: new-vgic: add proper GICv2 CPU interface userland access
Date: Tue,  3 May 2016 17:07:29 +0100
Message-ID: <1462291649-9906-1-git-send-email-andre.przywara@arm.com>
References: <57287A89.9010809@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <57287A89.9010809@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Although the actual register access was wired, the availability check
for the GICv2 CPU interface register interface was not - leading to
any attempt of saving or restoring GICv2 CPU i/f registers to fail.

This patch fixes this by modelling the CPU i/f registers similarily to
the distributor registers, thereby piggy backing on the existing
distributor save/restore code to do the heavy lifting.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi,

this is a fix for the missing CPU i/f migration that Marc spotted.
In a repost I will merge this somehow into the existing patches, but
for now this goes on top of the series.
Can any of you have a look whether this is the right way to go?

Cheers,
Andre.

 virt/kvm/arm/vgic/vgic-kvm-device.c |  71 +--------------------
 virt/kvm/arm/vgic/vgic-mmio-v2.c    | 122 +++++++++++++++++++++++++++++++++---
 virt/kvm/arm/vgic/vgic.h            |   2 +
 3 files changed, 115 insertions(+), 80 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index eaf5c1d..657552d 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -20,8 +20,6 @@
 #include <linux/irqchip/arm-gic.h>
 #include "vgic.h"
 
-#define GICC_ARCH_VERSION_V2		0x2
-
 /* common helpers */
 
 static int vgic_ioaddr_overlap(struct kvm *kvm)
@@ -255,69 +253,6 @@ void kvm_register_vgic_device(unsigned long type)
 	}
 }
 
-static u32 vgic_read_vcpuif(struct kvm_vcpu *vcpu, int offset)
-{
-	struct vgic_vmcr vmcr;
-	u32 *field;
-
-	switch (offset) {
-	case GIC_CPU_CTRL:
-		field = &vmcr.ctlr;
-		break;
-	case GIC_CPU_PRIMASK:
-		field = &vmcr.pmr;
-		break;
-	case GIC_CPU_BINPOINT:
-		field = &vmcr.bpr;
-		break;
-	case GIC_CPU_ALIAS_BINPOINT:
-		field = &vmcr.abpr;
-		break;
-	case GIC_CPU_IDENT:
-		return (PRODUCT_ID_KVM << 20) |
-		       (GICC_ARCH_VERSION_V2 << 16) |
-		       (IMPLEMENTER_ARM << 0);
-	default:
-		return 0;
-	}
-
-	vgic_get_vmcr(vcpu, &vmcr);
-
-	return *field;
-}
-
-static bool vgic_write_vcpuif(struct kvm_vcpu *vcpu, int offset, u32 value)
-{
-	struct vgic_vmcr vmcr;
-	u32 *field;
-
-	switch (offset) {
-	case GIC_CPU_CTRL:
-		field = &vmcr.ctlr;
-		break;
-	case GIC_CPU_PRIMASK:
-		field = &vmcr.pmr;
-		break;
-	case GIC_CPU_BINPOINT:
-		field = &vmcr.bpr;
-		break;
-	case GIC_CPU_ALIAS_BINPOINT:
-		field = &vmcr.abpr;
-		break;
-	default:
-		return false;
-	}
-
-	vgic_get_vmcr(vcpu, &vmcr);
-	if (*field == value)
-		return false;
-
-	*field = value;
-	vgic_set_vmcr(vcpu, &vmcr);
-
-	return true;
-}
-
 /** vgic_attr_regs_access: allows user space to read/write VGIC registers
  *
  * @dev: kvm device handle
@@ -366,11 +301,7 @@ static int vgic_attr_regs_access(struct kvm_device *dev,
 
 	switch (attr->group) {
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		ret = 0;
-		if (is_write)
-			vgic_write_vcpuif(vcpu, addr, *reg);
-		else
-			*reg = vgic_read_vcpuif(vcpu, addr);
+		ret = vgic_v2_cpuif_uaccess(vcpu, is_write, addr, reg);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_DIST_REGS:
 		ret = vgic_v2_dist_uaccess(vcpu, is_write, addr, reg);
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
index f2a8efe..276c3a0 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
@@ -206,6 +206,74 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
 	}
 }
 
+#define GICC_ARCH_VERSION_V2	0x2
+
+/* These are for userland accesses only, there is no guest-facing emulation. */
+static unsigned long vgic_mmio_read_vcpuif(struct kvm_vcpu *vcpu,
+					   gpa_t addr, unsigned int len)
+{
+	struct vgic_vmcr vmcr;
+	u32 *field;
+
+	switch (addr & 0xff) {
+	case GIC_CPU_CTRL:
+		field = &vmcr.ctlr;
+		break;
+	case GIC_CPU_PRIMASK:
+		field = &vmcr.pmr;
+		break;
+	case GIC_CPU_BINPOINT:
+		field = &vmcr.bpr;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		field = &vmcr.abpr;
+		break;
+	case GIC_CPU_IDENT:
+		return extract_bytes((PRODUCT_ID_KVM << 20) |
+				     (GICC_ARCH_VERSION_V2 << 16) |
+				     (IMPLEMENTER_ARM << 0),
+				     addr & 3, len);
+	default:
+		return 0;
+	}
+
+	vgic_get_vmcr(vcpu, &vmcr);
+
+	return extract_bytes(*field, addr & 3, len);
+}
+
+static void vgic_mmio_write_vcpuif(struct kvm_vcpu *vcpu,
+				   gpa_t addr, unsigned int len,
+				   unsigned long val)
+{
+	struct vgic_vmcr vmcr;
+	u32 *field;
+
+	switch (addr & 0xff) {
+	case GIC_CPU_CTRL:
+		field = &vmcr.ctlr;
+		break;
+	case GIC_CPU_PRIMASK:
+		field = &vmcr.pmr;
+		break;
+	case GIC_CPU_BINPOINT:
+		field = &vmcr.bpr;
+		break;
+	case GIC_CPU_ALIAS_BINPOINT:
+		field = &vmcr.abpr;
+		break;
+	default:
+		return;
+	}
+
+	vgic_get_vmcr(vcpu, &vmcr);
+	if (*field == val)
+		return;
+
+	*field = val;
+	vgic_set_vmcr(vcpu, &vmcr);
+}
+
 static const struct vgic_register_region vgic_v2_dist_registers[] = {
 	REGISTER_DESC_WITH_LENGTH(GIC_DIST_CTRL,
 		vgic_mmio_read_v2_misc, vgic_mmio_write_v2_misc, 12),
@@ -237,6 +305,21 @@ static const struct vgic_register_region vgic_v2_dist_registers[] = {
 		vgic_mmio_read_sgipend, vgic_mmio_write_sgipends, 16),
 };
 
+static const struct vgic_register_region vgic_v2_cpu_registers[] = {
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_CTRL,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_PRIMASK,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ALIAS_BINPOINT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_ACTIVEPRIO,
+		vgic_mmio_read_raz, vgic_mmio_write_wi, 16),
+	REGISTER_DESC_WITH_LENGTH(GIC_CPU_IDENT,
+		vgic_mmio_read_vcpuif, vgic_mmio_write_vcpuif, 4),
+};
+
 unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
 {
 	dev->regions = vgic_v2_dist_registers;
@@ -253,23 +336,18 @@ unsigned int vgic_v2_init_dist_iodev(struct vgic_io_device *dev)
  * have to set up a buffer similar to what would have happened if a guest MMIO
  * access occurred, including doing endian conversions on BE systems.
  */
-int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
-			int offset, u32 *val)
+static int vgic_uaccess(struct kvm_vcpu *vcpu, struct vgic_io_device *dev,
+			bool is_write, int offset, u32 *val)
 {
 	unsigned int len = 4;
 	u8 buf[4];
 	int ret;
 
-	struct vgic_io_device dev = {
-		.regions = vgic_v2_dist_registers,
-		.nr_regions = ARRAY_SIZE(vgic_v2_dist_registers),
-	};
-
 	if (is_write) {
 		vgic_data_host_to_mmio_bus(buf, len, *val);
-		ret = kvm_io_gic_ops.write(vcpu, &dev.dev, offset, len, buf);
+		ret = kvm_io_gic_ops.write(vcpu, &dev->dev, offset, len, buf);
 	} else {
-		ret = kvm_io_gic_ops.read(vcpu, &dev.dev, offset, len, buf);
+		ret = kvm_io_gic_ops.read(vcpu, &dev->dev, offset, len, buf);
 		if (!ret)
 			*val = vgic_data_mmio_bus_to_host(buf, len);
 	}
@@ -277,6 +355,28 @@ int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 	return ret;
 }
 
+int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v2_cpu_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers),
+	};
+
+	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
+}
+
+int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			 int offset, u32 *val)
+{
+	struct vgic_io_device dev = {
+		.regions = vgic_v2_dist_registers,
+		.nr_regions = ARRAY_SIZE(vgic_v2_dist_registers),
+	};
+
+	return vgic_uaccess(vcpu, &dev, is_write, offset, val);
+}
+
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 {
 	int nr_irqs = dev->kvm->arch.vgic.nr_spis + VGIC_NR_PRIVATE_IRQS;
@@ -292,7 +392,9 @@ int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
 		nr_regions = ARRAY_SIZE(vgic_v2_dist_registers);
 		break;
 	case KVM_DEV_ARM_VGIC_GRP_CPU_REGS:
-		return -ENXIO;		/* TODO: describe CPU i/f regs also */
+		regions = vgic_v2_cpu_registers;
+		nr_regions = ARRAY_SIZE(vgic_v2_cpu_registers);
+		break;
 	default:
 		return -ENXIO;
 	}
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f970e3e..d1de87f 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -38,6 +38,8 @@ void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
+int vgic_v2_cpuif_uaccess(struct kvm_vcpu *vcpu, bool is_write,
+			  int offset, u32 *val);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 void vgic_v2_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v2_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
-- 
2.7.3

