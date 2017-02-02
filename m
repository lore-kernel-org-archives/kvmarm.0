From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v9 10/15] arm: FDT: create MSI controller DT node
Date: Thu,  2 Feb 2017 16:32:18 +0000
Message-ID: <20170202163223.15372-11-andre.przywara@arm.com>
References: <20170202163223.15372-1-andre.przywara@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170202163223.15372-1-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS requires a separate device tree node to describe
the ITS. Add this as a child to the GIC interrupt controller node
to let a guest discover and use the ITS if the user requests it.
Since we now need to specify #address-cells for the GIC node, we
have to add two zeroes to the interrupt map to match that.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c                         | 22 +++++++++++++++++++++-
 arm/include/arm-common/fdt-arch.h |  2 +-
 arm/pci.c                         |  5 +++++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 78fd583..c8478a3 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -250,7 +250,8 @@ late_init(gic__init_gic)
 
 void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 {
-	const char *compatible;
+	const char *compatible, *msi_compatible = NULL;
+	u64 msi_prop[2];
 	u64 reg_prop[] = {
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
@@ -262,6 +263,9 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
 		reg_prop[3] = cpu_to_fdt64(ARM_GIC_CPUI_SIZE);
 		break;
+	case IRQCHIP_GICV3_ITS:
+		msi_compatible = "arm,gic-v3-its";
+		/* fall-through */
 	case IRQCHIP_GICV3:
 		compatible = "arm,gic-v3";
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
@@ -277,6 +281,22 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
 	_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_GIC));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+
+	if (msi_compatible) {
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_begin_node(fdt, "msic"));
+		_FDT(fdt_property_string(fdt, "compatible", msi_compatible));
+		_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+		_FDT(fdt_property_cell(fdt, "phandle", PHANDLE_MSI));
+		msi_prop[0] = cpu_to_fdt64(gic_msi_base);
+		msi_prop[1] = cpu_to_fdt64(gic_msi_size);
+		_FDT(fdt_property(fdt, "reg", msi_prop, sizeof(msi_prop)));
+		_FDT(fdt_end_node(fdt));
+	}
+
 	_FDT(fdt_end_node(fdt));
 }
 
diff --git a/arm/include/arm-common/fdt-arch.h b/arm/include/arm-common/fdt-arch.h
index 53ba633..60c2d40 100644
--- a/arm/include/arm-common/fdt-arch.h
+++ b/arm/include/arm-common/fdt-arch.h
@@ -1,6 +1,6 @@
 #ifndef ARM__FDT_H
 #define ARM__FDT_H
 
-enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLES_MAX};
+enum phandles {PHANDLE_RESERVED = 0, PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
 
 #endif /* ARM__FDT_H */
diff --git a/arm/pci.c b/arm/pci.c
index 2bc718e..37145cc 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -18,6 +18,8 @@ struct of_gic_irq {
 struct of_interrupt_map_entry {
 	struct of_pci_irq_mask		pci_irq_mask;
 	u32				gic_phandle;
+	u32				gic_addr_hi;
+	u32				gic_addr_lo;
 	struct of_gic_irq		gic_irq;
 } __attribute__((packed));
 
@@ -64,6 +66,7 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
+	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
@@ -84,6 +87,8 @@ void pci__generate_fdt_nodes(void *fdt)
 				.pci_pin	= cpu_to_fdt32(pin),
 			},
 			.gic_phandle	= cpu_to_fdt32(PHANDLE_GIC),
+			.gic_addr_hi	= 0,
+			.gic_addr_lo	= 0,
 			.gic_irq = {
 				.type	= cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
 				.num	= cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
-- 
2.9.0
