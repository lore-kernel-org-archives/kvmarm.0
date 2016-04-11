From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v6 07/10] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Mon, 11 Apr 2016 16:32:57 +0100
Message-ID: <1460388780-914-8-git-send-email-julien.grall@arm.com>
References: <1460388780-914-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B9CF40F77
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:52 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oD0J6eoHHADA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Apr 2016 11:31:51 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A4AB499A1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Apr 2016 11:31:50 -0400 (EDT)
In-Reply-To: <1460388780-914-1-git-send-email-julien.grall@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: al.stone@linaro.org, kvm@vger.kernel.org, hanjun.guo@linaro.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>, linux-arm-kernel@lists.infradead.org, gg@slimlogic.co.uk
List-Id: kvmarm@lists.cs.columbia.edu

Fill up the recently introduced gic_kvm_info with the hardware
information used for virtualization.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>

---
    Changes in v6:
        - Skip unusable CPUs

    Changes in v5:
        - Remove the alignment check for GICV. It's already done in the
        KVM code.
        - Fix initialization of KVM with ACPI.

    Changes in v4:
        - Change the flow to call gic_kvm_set_info only when all the
        mandatory information are valid.
        - Remove unecessary code in ACPI parsing (the virtual control
        interface doesn't exist for GICv3).
        - Rework commit message
        - Rework the ACPI support as it didn't collect hardware info for
        virtualization when there is more than 1 redistributor region

    Changes in v3:
        - Add ACPI support

    Changes in v2:
        - Use 0 rather than a negative value to know when the maintenance IRQ
        is not present.
        - Use resource for vcpu and vctrl
---
 drivers/irqchip/irq-gic-v3.c           | 114 ++++++++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-common.h |   1 +
 2 files changed, 114 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6a9f5ff..05a8560 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -30,6 +30,7 @@
 #include <linux/slab.h>
 
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-gic-common.h>
 #include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/cputype.h>
@@ -58,6 +59,8 @@ struct gic_chip_data {
 static struct gic_chip_data gic_data __read_mostly;
 static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
 
+static struct gic_kvm_info gic_v3_kvm_info;
+
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
@@ -903,6 +906,30 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
 	return 0;
 }
 
+static void __init gic_of_setup_kvm_info(struct device_node *node)
+{
+	int ret;
+	struct resource r;
+	u32 gicv_idx;
+
+	gic_v3_kvm_info.type = GIC_V3;
+
+	gic_v3_kvm_info.maint_irq = irq_of_parse_and_map(node, 0);
+	if (!gic_v3_kvm_info.maint_irq)
+		return;
+
+	if (of_property_read_u32(node, "#redistributor-regions",
+				 &gicv_idx))
+		gicv_idx = 1;
+
+	gicv_idx += 3;	/* Also skip GICD, GICC, GICH */
+	ret = of_address_to_resource(node, gicv_idx, &r);
+	if (!ret)
+		gic_v3_kvm_info.vcpu = r;
+
+	gic_set_kvm_info(&gic_v3_kvm_info);
+}
+
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *dist_base;
@@ -954,8 +981,10 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 
 	err = gic_init_bases(dist_base, rdist_regs, nr_redist_regions,
 			     redist_stride, &node->fwnode);
-	if (!err)
+	if (!err) {
+		gic_of_setup_kvm_info(node);
 		return 0;
+	}
 
 out_unmap_rdist:
 	for (i = 0; i < nr_redist_regions; i++)
@@ -976,6 +1005,9 @@ static struct
 	struct redist_region *redist_regs;
 	u32 nr_redist_regions;
 	bool single_redist;
+	u32 maint_irq;
+	int maint_irq_mode;
+	phys_addr_t vcpu_base;
 } acpi_data __initdata;
 
 static void __init
@@ -1112,7 +1144,85 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
 	return true;
 }
 
+static int __init gic_acpi_parse_virt_madt_gicc(struct acpi_subtable_header *header,
+						const unsigned long end)
+{
+	struct acpi_madt_generic_interrupt *gicc =
+		(struct acpi_madt_generic_interrupt *)header;
+	int maint_irq_mode;
+	static int first_madt = true;
+
+	/* Skip unusable CPUs */
+	if (!(gicc->flags & ACPI_MADT_ENABLED))
+		return 0;
+
+	maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+		ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+
+	if (first_madt) {
+		first_madt = false;
+
+		acpi_data.maint_irq = gicc->vgic_interrupt;
+		acpi_data.maint_irq_mode = maint_irq_mode;
+		acpi_data.vcpu_base = gicc->gicv_base_address;
+
+		return 0;
+	}
+
+	/*
+	 * The maintenance interrupt and GICV should be the same for every CPU
+	 */
+	if ((acpi_data.maint_irq != gicc->vgic_interrupt) ||
+	    (acpi_data.maint_irq_mode != maint_irq_mode) ||
+	    (acpi_data.vcpu_base != gicc->gicv_base_address))
+		return -EINVAL;
+
+	return 0;
+}
+
+static bool __init gic_acpi_collect_virt_info(void)
+{
+	int count;
+
+	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
+				      gic_acpi_parse_virt_madt_gicc, 0);
+
+	return (count > 0);
+}
+
 #define ACPI_GICV3_DIST_MEM_SIZE (SZ_64K)
+#define ACPI_GICV2_VCTRL_MEM_SIZE	(SZ_4K)
+#define ACPI_GICV2_VCPU_MEM_SIZE	(SZ_8K)
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	int irq;
+
+	if (!gic_acpi_collect_virt_info()) {
+		pr_warn("Unable to get hardware information used for virtualization\n");
+		return;
+	}
+
+	gic_v3_kvm_info.type = GIC_V3;
+
+	irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
+				acpi_data.maint_irq_mode,
+				ACPI_ACTIVE_HIGH);
+	if (irq <= 0)
+		return;
+
+	gic_v3_kvm_info.maint_irq = irq;
+
+	if (acpi_data.vcpu_base) {
+		struct resource *vcpu = &gic_v3_kvm_info.vcpu;
+
+		vcpu->flags = IORESOURCE_MEM;
+		vcpu->start = acpi_data.vcpu_base;
+		vcpu->end = vcpu->start + ACPI_GICV2_VCPU_MEM_SIZE - 1;
+	}
+
+	gic_set_kvm_info(&gic_v3_kvm_info);
+}
 
 static int __init
 gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
@@ -1161,6 +1271,8 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 		goto out_fwhandle_free;
 
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC, domain_handle);
+	gic_acpi_setup_kvm_info();
+
 	return 0;
 
 out_fwhandle_free:
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index ef34f6f..c647b05 100644
--- a/include/linux/irqchip/arm-gic-common.h
+++ b/include/linux/irqchip/arm-gic-common.h
@@ -15,6 +15,7 @@
 
 enum gic_type {
 	GIC_V2,
+	GIC_V3,
 };
 
 struct gic_kvm_info {
-- 
1.9.1
