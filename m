From: Andre Przywara <andre.przywara@arm.com>
Subject: [kvmtool PATCH v10 10/15] arm: FDT: create MSI controller DT node
Date: Tue, 25 Apr 2017 15:39:27 +0100
Message-ID: <20170425143932.17235-11-andre.przywara@arm.com>
References: <20170425143932.17235-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D2540EFD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Bl9CJ-qS4QUW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 10:34:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DC4E40DA6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 10:34:50 -0400 (EDT)
In-Reply-To: <20170425143932.17235-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
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
index 95e26a9..056fd09 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -251,7 +251,8 @@ late_init(gic__init_gic)
 
 void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 {
-	const char *compatible;
+	const char *compatible, *msi_compatible = NULL;
+	u64 msi_prop[2];
 	u64 reg_prop[] = {
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
@@ -263,6 +264,9 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
 		reg_prop[3] = cpu_to_fdt64(ARM_GIC_CPUI_SIZE);
 		break;
+	case IRQCHIP_GICV3_ITS:
+		msi_compatible = "arm,gic-v3-its";
+		/* fall-through */
 	case IRQCHIP_GICV3:
 		compatible = "arm,gic-v3";
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
@@ -278,6 +282,22 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
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
index d393c46..813df26 100644
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
 
@@ -65,6 +67,7 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
+	_FDT(fdt_property_cell(fdt, "msi-parent", PHANDLE_MSI));
 
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
@@ -85,6 +88,8 @@ void pci__generate_fdt_nodes(void *fdt)
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
