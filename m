From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v7 02/15] arm: use new phandle allocation functions
Date: Wed, 20 Jul 2016 18:04:22 +0100
Message-ID: <20160720170435.28090-3-andre.przywara@arm.com>
References: <20160720170435.28090-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20160720170435.28090-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

To refer to the GIC FDT node, we used to pass the GIC phandle to most
of the functions dealing with FDT nodes.
Since we now have a global phandle reference, use that to refer to the
GIC handle in various places and get rid of the now unneeded parameter
passing.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/aarch32/arm-cpu.c                 | 4 ++--
 arm/aarch64/arm-cpu.c                 | 5 +++--
 arm/fdt.c                             | 6 +++---
 arm/gic.c                             | 2 +-
 arm/include/arm-common/gic.h          | 2 +-
 arm/include/arm-common/kvm-cpu-arch.h | 3 +--
 arm/include/arm-common/pci.h          | 2 +-
 arm/pci.c                             | 3 ++-
 8 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/arm/aarch32/arm-cpu.c b/arm/aarch32/arm-cpu.c
index d8d6293..27a8e17 100644
--- a/arm/aarch32/arm-cpu.c
+++ b/arm/aarch32/arm-cpu.c
@@ -8,11 +8,11 @@
 #include <linux/byteorder.h>
 #include <linux/types.h>
 
-static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
+static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
 
-	gic__generate_fdt_nodes(fdt, gic_phandle, IRQCHIP_GICV2);
+	gic__generate_fdt_nodes(fdt, IRQCHIP_GICV2);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 }
 
diff --git a/arm/aarch64/arm-cpu.c b/arm/aarch64/arm-cpu.c
index c21c0bb..d7572b7 100644
--- a/arm/aarch64/arm-cpu.c
+++ b/arm/aarch64/arm-cpu.c
@@ -10,10 +10,11 @@
 #include <linux/byteorder.h>
 #include <linux/types.h>
 
-static void generate_fdt_nodes(void *fdt, struct kvm *kvm, u32 gic_phandle)
+static void generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	int timer_interrupts[4] = {13, 14, 11, 10};
-	gic__generate_fdt_nodes(fdt, gic_phandle, kvm->cfg.arch.irqchip);
+
+	gic__generate_fdt_nodes(fdt, kvm->cfg.arch.irqchip);
 	timer__generate_fdt_nodes(fdt, kvm, timer_interrupts);
 	pmu__generate_fdt_nodes(fdt, kvm);
 }
diff --git a/arm/fdt.c b/arm/fdt.c
index 8bcfffb..f6c8a4c 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -125,7 +125,7 @@ static int setup_fdt(struct kvm *kvm)
 						     kvm->arch.dtb_guest_start);
 	void (*generate_mmio_fdt_nodes)(void *, struct device_header *,
 					void (*)(void *, u8, enum irq_type));
-	void (*generate_cpu_peripheral_fdt_nodes)(void *, struct kvm *, u32)
+	void (*generate_cpu_peripheral_fdt_nodes)(void *, struct kvm *)
 					= kvm->cpus[0]->generate_fdt_nodes;
 
 	/* Create new tree without a reserve map */
@@ -166,7 +166,7 @@ static int setup_fdt(struct kvm *kvm)
 	/* CPU and peripherals (interrupt controller, timers, etc) */
 	generate_cpu_nodes(fdt, kvm);
 	if (generate_cpu_peripheral_fdt_nodes)
-		generate_cpu_peripheral_fdt_nodes(fdt, kvm, gic_phandle);
+		generate_cpu_peripheral_fdt_nodes(fdt, kvm);
 
 	/* Virtio MMIO devices */
 	dev_hdr = device__first_dev(DEVICE_BUS_MMIO);
@@ -185,7 +185,7 @@ static int setup_fdt(struct kvm *kvm)
 	}
 
 	/* PCI host controller */
-	pci__generate_fdt_nodes(fdt, gic_phandle);
+	pci__generate_fdt_nodes(fdt);
 
 	/* PSCI firmware */
 	_FDT(fdt_begin_node(fdt, "psci"));
diff --git a/arm/gic.c b/arm/gic.c
index b60437e..2c1a547 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -194,7 +194,7 @@ static int gic__init_gic(struct kvm *kvm)
 }
 late_init(gic__init_gic)
 
-void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type)
+void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 {
 	const char *compatible;
 	u64 reg_prop[] = {
diff --git a/arm/include/arm-common/gic.h b/arm/include/arm-common/gic.h
index 4fde5ac..b43a180 100644
--- a/arm/include/arm-common/gic.h
+++ b/arm/include/arm-common/gic.h
@@ -30,6 +30,6 @@ struct kvm;
 
 int gic__alloc_irqnum(void);
 int gic__create(struct kvm *kvm, enum irqchip_type type);
-void gic__generate_fdt_nodes(void *fdt, u32 phandle, enum irqchip_type type);
+void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type);
 
 #endif /* ARM_COMMON__GIC_H */
diff --git a/arm/include/arm-common/kvm-cpu-arch.h b/arm/include/arm-common/kvm-cpu-arch.h
index 8a6a6e7..923d2c4 100644
--- a/arm/include/arm-common/kvm-cpu-arch.h
+++ b/arm/include/arm-common/kvm-cpu-arch.h
@@ -25,8 +25,7 @@ struct kvm_cpu {
 
 	struct kvm_coalesced_mmio_ring	*ring;
 
-	void		(*generate_fdt_nodes)(void *fdt, struct kvm* kvm,
-					      u32 gic_phandle);
+	void		(*generate_fdt_nodes)(void *fdt, struct kvm* kvm);
 };
 
 struct kvm_arm_target {
diff --git a/arm/include/arm-common/pci.h b/arm/include/arm-common/pci.h
index ee87725..9008a0e 100644
--- a/arm/include/arm-common/pci.h
+++ b/arm/include/arm-common/pci.h
@@ -1,6 +1,6 @@
 #ifndef ARM_COMMON__PCI_H
 #define ARM_COMMON__PCI_H
 
-void pci__generate_fdt_nodes(void *fdt, u32 gic_phandle);
+void pci__generate_fdt_nodes(void *fdt);
 
 #endif /* ARM_COMMON__PCI_H */
diff --git a/arm/pci.c b/arm/pci.c
index 99a8130..9630657 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -21,11 +21,12 @@ struct of_interrupt_map_entry {
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
-void pci__generate_fdt_nodes(void *fdt, u32 gic_phandle)
+void pci__generate_fdt_nodes(void *fdt)
 {
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
 	unsigned nentries = 0;
+	u32 gic_phandle = fdt__get_phandle(PHANDLE_GIC);
 	/* Bus range */
 	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
 	/* Configuration Space */
-- 
2.9.0

