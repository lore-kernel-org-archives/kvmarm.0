From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v8 10/16] arm: FDT: create MSI controller DT node
Date: Fri,  4 Nov 2016 17:31:57 +0000
Message-ID: <20161104173203.21168-11-andre.przywara@arm.com>
References: <20161104173203.21168-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E31740457
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LtzH8TxdXnKX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Nov 2016 13:31:36 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8566F4055D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Nov 2016 13:31:35 -0400 (EDT)
In-Reply-To: <20161104173203.21168-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS requires a separate device tree node to describe
the ITS. Add this as a child to the GIC interrupt controller node
to let a guest discover and use the ITS if the user requests it.
Since we now need to specify #address-cells for the GIC node, we
have to add two zeroes to the interrupt map to match that.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/gic.c         | 23 ++++++++++++++++++++++-
 arm/pci.c         | 12 ++++++++++--
 include/kvm/fdt.h |  2 +-
 3 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ed9016d..44f9365 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -267,7 +267,8 @@ late_init(gic__init_gic)
 
 void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 {
-	const char *compatible;
+	const char *compatible, *msi_compatible = NULL;
+	u64 msi_prop[2];
 	u64 reg_prop[] = {
 		cpu_to_fdt64(ARM_GIC_DIST_BASE), cpu_to_fdt64(ARM_GIC_DIST_SIZE),
 		0, 0,				/* to be filled */
@@ -279,6 +280,9 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 		reg_prop[2] = cpu_to_fdt64(ARM_GIC_CPUI_BASE);
 		reg_prop[3] = cpu_to_fdt64(ARM_GIC_CPUI_SIZE);
 		break;
+	case IRQCHIP_GICV3_ITS:
+		msi_compatible = "arm,gic-v3-its";
+		/* fall-through */
 	case IRQCHIP_GICV3:
 		compatible = "arm,gic-v3";
 		reg_prop[2] = cpu_to_fdt64(gic_redists_base);
@@ -294,6 +298,23 @@ void gic__generate_fdt_nodes(void *fdt, enum irqchip_type type)
 	_FDT(fdt_property(fdt, "interrupt-controller", NULL, 0));
 	_FDT(fdt_property(fdt, "reg", reg_prop, sizeof(reg_prop)));
 	_FDT(fdt_property_cell(fdt, "phandle", fdt__get_phandle(PHANDLE_GIC)));
+	_FDT(fdt_property_cell(fdt, "#address-cells", 2));
+	_FDT(fdt_property_cell(fdt, "#size-cells", 2));
+
+	if (msi_compatible) {
+		_FDT(fdt_property(fdt, "ranges", NULL, 0));
+
+		_FDT(fdt_begin_node(fdt, "msic"));
+		_FDT(fdt_property_string(fdt, "compatible", msi_compatible));
+		_FDT(fdt_property(fdt, "msi-controller", NULL, 0));
+		_FDT(fdt_property_cell(fdt, "phandle",
+				       fdt__get_phandle(PHANDLE_MSI)));
+		msi_prop[0] = cpu_to_fdt64(gic_msi_base);
+		msi_prop[1] = cpu_to_fdt64(gic_msi_size);
+		_FDT(fdt_property(fdt, "reg", msi_prop, sizeof(msi_prop)));
+		_FDT(fdt_end_node(fdt));
+	}
+
 	_FDT(fdt_end_node(fdt));
 }
 
diff --git a/arm/pci.c b/arm/pci.c
index 9630657..104349a 100644
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
 
@@ -26,7 +28,7 @@ void pci__generate_fdt_nodes(void *fdt)
 	struct device_header *dev_hdr;
 	struct of_interrupt_map_entry irq_map[OF_PCI_IRQ_MAP_MAX];
 	unsigned nentries = 0;
-	u32 gic_phandle = fdt__get_phandle(PHANDLE_GIC);
+	u32 phandle;
 	/* Bus range */
 	u32 bus_range[] = { cpu_to_fdt32(0), cpu_to_fdt32(1), };
 	/* Configuration Space */
@@ -65,7 +67,11 @@ void pci__generate_fdt_nodes(void *fdt)
 	_FDT(fdt_property(fdt, "bus-range", bus_range, sizeof(bus_range)));
 	_FDT(fdt_property(fdt, "reg", &cfg_reg_prop, sizeof(cfg_reg_prop)));
 	_FDT(fdt_property(fdt, "ranges", ranges, sizeof(ranges)));
+	phandle = fdt__get_phandle(PHANDLE_MSI);
+	if (FDT_IS_VALID_PHANDLE(phandle))
+		_FDT(fdt_property_cell(fdt, "msi-parent", phandle));
 
+	phandle = fdt__get_phandle(PHANDLE_GIC);
 	/* Generate the interrupt map ... */
 	dev_hdr = device__first_dev(DEVICE_BUS_PCI);
 	while (dev_hdr && nentries < ARRAY_SIZE(irq_map)) {
@@ -84,7 +90,9 @@ void pci__generate_fdt_nodes(void *fdt)
 				},
 				.pci_pin	= cpu_to_fdt32(pin),
 			},
-			.gic_phandle	= cpu_to_fdt32(gic_phandle),
+			.gic_phandle	= cpu_to_fdt32(phandle),
+			.gic_addr_hi	= 0,
+			.gic_addr_lo	= 0,
 			.gic_irq = {
 				.type	= cpu_to_fdt32(GIC_FDT_IRQ_TYPE_SPI),
 				.num	= cpu_to_fdt32(irq - GIC_SPI_IRQ_BASE),
diff --git a/include/kvm/fdt.h b/include/kvm/fdt.h
index cd2bb72..8006e8f 100644
--- a/include/kvm/fdt.h
+++ b/include/kvm/fdt.h
@@ -11,7 +11,7 @@
 #define FDT_INVALID_PHANDLE 0
 #define FDT_IS_VALID_PHANDLE(phandle) ((phandle) != FDT_INVALID_PHANDLE)
 
-enum phandles {PHANDLE_GIC, PHANDLES_MAX};
+enum phandles {PHANDLE_GIC, PHANDLE_MSI, PHANDLES_MAX};
 
 /* Those definitions are generic FDT values for specifying IRQ
  * types and are used in the Linux kernel internally as well as in
-- 
2.9.0
