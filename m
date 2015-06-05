From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 7/8] arm: add support for supplying GICv3 redistributor addresses
Date: Fri,  5 Jun 2015 09:37:52 +0100
Message-ID: <1433493473-4002-8-git-send-email-andre.przywara@arm.com>
References: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1433493473-4002-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com, penberg@kernel.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The code currently is assuming fixed sized memory regions for the
distributor and CPU interface. GICv3 needs a dynamic allocation of
its redistributor region, since its size depends on the number of
vCPUs.
Also add the necessary code to create a GICv3 IRQ chip instance.
This contains some defines which are not (yet) in the (32 bit) header
files to allow compilation for ARM.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                         | 37 +++++++++++++++++++++++++++++++++++--
 arm/include/arm-common/gic.h      |  2 +-
 arm/include/arm-common/kvm-arch.h | 18 ++++++++++++++----
 arm/kvm-cpu.c                     |  4 +++-
 4 files changed, 53 insertions(+), 8 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 0ce40e4..c50d662 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -9,13 +9,24 @@
 #include <linux/kernel.h>
 #include <linux/kvm.h>
 
+/* Those names are not defined for ARM (yet) */
+#ifndef KVM_VGIC_V3_ADDR_TYPE_DIST
+#define KVM_VGIC_V3_ADDR_TYPE_DIST 2
+#endif
+
+#ifndef KVM_VGIC_V3_ADDR_TYPE_REDIST
+#define KVM_VGIC_V3_ADDR_TYPE_REDIST 3
+#endif
+
 static int gic_fd = -1;
+static int nr_redists;
 
 static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
 	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
 	u64 dist_addr = ARM_GIC_DIST_BASE;
+	u64 redist_addr = dist_addr - nr_redists * ARM_GIC_REDIST_SIZE;
 	struct kvm_create_device gic_device = {
 		.flags	= 0,
 	};
@@ -28,11 +39,19 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
 		.addr	= (u64)(unsigned long)&dist_addr,
 	};
+	struct kvm_device_attr redist_attr = {
+		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
+		.attr	= KVM_VGIC_V3_ADDR_TYPE_REDIST,
+		.addr	= (u64)(unsigned long)&redist_addr,
+	};
 
 	switch (type) {
 	case IRQCHIP_GICV2:
 		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
 		break;
+	case IRQCHIP_GICV3:
+		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V3;
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -48,6 +67,10 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		dist_attr.attr = KVM_VGIC_V2_ADDR_TYPE_DIST;
 		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
 		break;
+	case IRQCHIP_GICV3:
+		dist_attr.attr = KVM_VGIC_V3_ADDR_TYPE_DIST;
+		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &redist_attr);
+		break;
 	default:
 		return -ENODEV;
 	}
@@ -55,6 +78,8 @@ static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 		return err;
 
 	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &dist_attr);
+	if (err)
+		return err;
 
 	return err;
 }
@@ -162,17 +187,25 @@ void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
 	u64 reg_prop[] = {
 		cpu_to_fdt64(ARM_GIC_DIST_BASE),
 		cpu_to_fdt64(ARM_GIC_DIST_SIZE),
-		cpu_to_fdt64(ARM_GIC_CPUI_BASE),
-		cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
+		0, 0,				/* to be filled */
 	};
 
 	switch (type) {
 	case IRQCHIP_GICV2:
 		compatible = "arm,cortex-a15-gic";
+		reg_prop[2] = ARM_GIC_CPUI_BASE;
+		reg_prop[3] = ARM_GIC_CPUI_SIZE;
+		break;
+	case IRQCHIP_GICV3:
+		compatible = "arm,gic-v3";
+		reg_prop[2] = ARM_GIC_DIST_BASE - nr_redists * ARM_GIC_REDIST_SIZE;
+		reg_prop[3] = ARM_GIC_REDIST_SIZE * nr_redists;
 		break;
 	default:
 		return;
 	}
+	reg_prop[2] = cpu_to_fdt64(reg_prop[2]);
+	reg_prop[3] = cpu_to_fdt64(reg_prop[3]);
 
 	_FDT(fdt_begin_node(fdt, "intc"));
 	_FDT(fdt_property_string(fdt, "compatible", compatible));
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index f5f6707..8d6ab01 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -21,7 +21,7 @@
 #define GIC_MAX_CPUS			8
 #define GIC_MAX_IRQ			255
 
-enum irqchip_type {IRQCHIP_DEFAULT, IRQCHIP_GICV2};
+enum irqchip_type {IRQCHIP_DEFAULT, IRQCHIP_GICV2, IRQCHIP_GICV3};
 
 struct kvm;
 
diff --git a/arm/include/arm-common/kvm-arch.h b/arm/include/arm-common/kvm-arch.h
index 082131d..be66a76 100644
--- a/arm/include/arm-common/kvm-arch.h
+++ b/arm/include/arm-common/kvm-arch.h
@@ -17,10 +17,8 @@
 
 #define ARM_GIC_DIST_BASE	(ARM_AXI_AREA - ARM_GIC_DIST_SIZE)
 #define ARM_GIC_CPUI_BASE	(ARM_GIC_DIST_BASE - ARM_GIC_CPUI_SIZE)
-#define ARM_GIC_SIZE		(ARM_GIC_DIST_SIZE + ARM_GIC_CPUI_SIZE)
 
 #define ARM_IOPORT_SIZE		(ARM_MMIO_AREA - ARM_IOPORT_AREA)
-#define ARM_VIRTIO_MMIO_SIZE	(ARM_AXI_AREA - (ARM_MMIO_AREA + ARM_GIC_SIZE))
 #define ARM_PCI_CFG_SIZE	(1ULL << 24)
 #define ARM_PCI_MMIO_SIZE	(ARM_MEMORY_AREA - \
 				(ARM_AXI_AREA + ARM_PCI_CFG_SIZE))
@@ -30,6 +28,13 @@
 #define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + ARM_PCI_CFG_SIZE)
 #define KVM_VIRTIO_MMIO_AREA	ARM_MMIO_AREA
 
+/*
+ * On a GICv3 there must be one redistributor per vCPU.
+ * The value here is the size for one, we multiply this at runtime with
+ * the number of requested vCPUs to get the actual size.
+ */
+#define ARM_GIC_REDIST_SIZE	0x20000
+
 #define KVM_IRQ_OFFSET		GIC_SPI_IRQ_BASE
 
 #define KVM_VM_TYPE		0
@@ -45,9 +50,14 @@ static inline bool arm_addr_in_ioport_region(u64 phys_addr)
 	return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
 }
 
-static inline bool arm_addr_in_virtio_mmio_region(u64 phys_addr)
+static inline bool arm_addr_in_virtio_mmio_region(int nr_redists, u64 phys_addr)
 {
-	u64 limit = KVM_VIRTIO_MMIO_AREA + ARM_VIRTIO_MMIO_SIZE;
+	u64 limit = ARM_AXI_AREA - ARM_GIC_DIST_SIZE;
+
+	if (nr_redists)
+		limit -= ARM_GIC_REDIST_SIZE * nr_redists;
+	else
+		limit -= ARM_GIC_CPUI_SIZE;
 	return phys_addr >= KVM_VIRTIO_MMIO_AREA && phys_addr < limit;
 }
 
diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index ab08815..a3344fa 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -142,7 +142,9 @@ bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
 bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr, u8 *data,
 			   u32 len, u8 is_write)
 {
-	if (arm_addr_in_virtio_mmio_region(phys_addr)) {
+	int nr_redists = 0;
+
+	if (arm_addr_in_virtio_mmio_region(nr_redists, phys_addr)) {
 		return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
 	} else if (arm_addr_in_ioport_region(phys_addr)) {
 		int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
-- 
2.3.5

