From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v4 08/10] arm: prepare for instantiating different IRQ chip devices
Date: Fri, 26 Jun 2015 14:16:16 +0100
Message-ID: <1435324578-21832-9-git-send-email-andre.przywara@arm.com>
References: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1435324578-21832-1-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: will.deacon@arm.com, marc.zyngier@arm.com
Cc: penberg@kernel.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Extend the vGIC handling code to potentially deal with different IRQ
chip devices instead of hard-coding the GICv2 in.
We extend most vGIC functions to take a type parameter, but still put
GICv2 in at the top for the time being.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arm/aarch32/arm-cpu.c        |  2 +-
 arm/aarch64/arm-cpu.c        |  2 +-
 arm/gic.c                    | 44 +++++++++++++++++++++++++++++++++++---------
 arm/include/arm-common/gic.h |  8 ++++++--
 arm/kvm.c                    |  2 +-
 5 files changed, 44 insertions(+), 14 deletions(-)

diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
index 946e443..d8d6293 100644
--- a/arm/aarch32/arm-cpu.c
+++ b/arm/aarch32/arm-cpu.c
@@ -12,7 +12,7 @@ static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, gic_phandle);
+	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index 8efe877..f702b9e 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -12,7 +12,7 @@
 static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
-	gic__generate_fdt_nodes(fdt, gic_phandle);
+	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/gic.c b/arm/gic.c
index 05f85a2..b6c5868 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -11,13 +11,13 @@
 
 static int gic_fd = -1;
 
-static int gic__create_device(struct kvm *kvm)
+static int gic__create_device(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
 	u64 cpu_if_addr = ARM_GIC_CPUI_BASE;
 	u64 dist_addr = ARM_GIC_DIST_BASE;
 	struct kvm_create_device gic_device = {
-		.type	= KVM_DEV_TYPE_ARM_VGIC_V2,
+		.flags	= 0,
 	};
 	struct kvm_device_attr cpu_if_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -26,17 +26,27 @@ static int gic__create_device(struct kvm *kvm)
 	};
 	struct kvm_device_attr dist_attr = {
 		.group	= KVM_DEV_ARM_VGIC_GRP_ADDR,
-		.attr	= KVM_VGIC_V2_ADDR_TYPE_DIST,
 		.addr	= (u64)(unsigned long)&dist_addr,
 	};
 
+	switch (type) {
+	case IRQCHIP_GICV2:
+		gic_device.type = KVM_DEV_TYPE_ARM_VGIC_V2;
+		dist_attr.attr  = KVM_VGIC_V2_ADDR_TYPE_DIST;
+		break;
+	}
+
 	err = ioctl(kvm->vm_fd, KVM_CREATE_DEVICE, &gic_device);
 	if (err)
 		return err;
 
 	gic_fd = gic_device.fd;
 
-	err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
+	switch (type) {
+	case IRQCHIP_GICV2:
+		err = ioctl(gic_fd, KVM_SET_DEVICE_ATTR, &cpu_if_attr);
+		break;
+	}
 	if (err)
 		goto out_err;
 
@@ -80,13 +90,20 @@ static int gic__create_irqchip(struct kvm *kvm)
 	return err;
 }
 
-int gic__create(struct kvm *kvm)
+int gic__create(struct kvm *kvm, enum irqchip_type type)
 {
 	int err;
 
+	switch (type) {
+	case IRQCHIP_GICV2:
+		break;
+	default:
+		return -ENODEV;
+	}
+
 	/* Try the new way first, and fallback on legacy method otherwise */
-	err = gic__create_device(kvm);
-	if (err)
+	err = gic__create_device(kvm, type);
+	if (err && type == IRQCHIP_GICV2)
 		err = gic__create_irqchip(kvm);
 
 	return err;
@@ -134,15 +151,24 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
-void gic__generate_fdt_nodes(void *fdt, u32 phandle)
+void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
 {
+	const char *compatible;
 	u64 reg_prop[] = {
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		cpu_to_fdt64(ARM_GIC_CPUI_BASE), cpu_to_fdt64(ARM_GIC_CPUI_SIZE),
 	};
 
+	switch (type) {
+	case IRQCHIP_GICV2:
+		compatible = "arm,cortex-a15-gic";
+		break;
+	default:
+		return;
+	}
+
 	_FDT(fdt_begin_node(fdt, "intc"));
-	_FDT(fdt_property_string(fdt, "compatible", "arm,cortex-a15-gic"));
+	_FDT(fdt_property_string(fdt, "compatible", compatible));
 	_FDT(fdt_property_cell(fdt, "#interrupt-cells", GIC_FDT_IRQ_NUM_CELLS));
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index 44859f7..d524f55 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -21,10 +21,14 @@
 #define GIC_MAX_CPUS			8
 #define GIC_MAX_IRQ			255
 
+enum irqchip_type {
+	IRQCHIP_GICV2,
+};
+
 struct kvm;
 
 int gic__alloc_irqnum(void);
-int gic__create(struct kvm *kvm);
-void gic__generate_fdt_nodes(void *fdt, u32 phandle);
+int gic__create(struct kvm *kvm, enum irqchip_type type);
+void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type);
 
 #endif /* ARM_COMMON__GIC_H */
diff --git a/arm/kvm.c b/arm/kvm.c
index bcd2533..f9685c2 100644
--- a/arm/kvm.c
+++ b/arm/kvm.c
@@ -82,6 +82,6 @@ void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
 		MADV_MERGEABLE | MADV_HUGEPAGE);
 
 	/* Create the virtual GIC. */
-	if (gic__create(kvm))
+	if (gic__create(kvm, IRQCHIP_GICV2))
 		die("Failed to create virtual GIC");
 }
-- 
2.3.5

