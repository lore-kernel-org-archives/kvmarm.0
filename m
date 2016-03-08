From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH v3 6/9] irqchip/gic-v3: Parse and export virtual GIC
 information
Date: Tue,  8 Mar 2016 11:29:30 +0000
Message-ID: <1457436573-6180-7-git-send-email-julien.grall@arm.com>
References: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8974C49B21
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 06:30:28 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y2ogKh+Mip9S for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Mar 2016 06:30:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30F8049B3B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Mar 2016 06:30:27 -0500 (EST)
In-Reply-To: <1457436573-6180-1-git-send-email-julien.grall@arm.com>
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
Cc: al.stone@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, fu.wei@linaro.org, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

Fill up the recently introduced gic_kvm_info with the virtual GIC
information.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Marc Zyngier <marc.zyngier@arm.com>

---
    Changes in v3:
        - Add ACPI support

    Changes in v2:
        - Use 0 rather than a negative value to know when the maintenance IRQ
        is not present.
        - Use resource for vcpu and vctrl
---
 drivers/irqchip/irq-gic-v3.c           | 85 +++++++++++++++++++++++++++++++++-
 include/linux/irqchip/arm-gic-common.h |  1 +
 2 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 50e87e6..6ae25120 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -28,6 +28,7 @@
 #include <linux/slab.h>
 
 #include <linux/irqchip.h>
+#include <linux/irqchip/arm-gic-common.h>
 #include <linux/irqchip/arm-gic-v3.h>
 
 #include <asm/cputype.h>
@@ -56,6 +57,8 @@ struct gic_chip_data {
 static struct gic_chip_data gic_data __read_mostly;
 static struct static_key supports_deactivate = STATIC_KEY_INIT_TRUE;
 
+static struct gic_kvm_info gic_v3_kvm_info;
+
 #define gic_data_rdist()		(this_cpu_ptr(gic_data.rdists.rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
 #define gic_data_rdist_sgi_base()	(gic_data_rdist_rd_base() + SZ_64K)
@@ -901,6 +904,37 @@ static int __init gic_validate_dist_version(void __iomem *dist_base)
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
+
+	if (of_property_read_u32(node, "#redistributor-regions",
+				 &gicv_idx))
+		gicv_idx = 1;
+
+	gicv_idx += 3;	/* Also skip GICD, GICC, GICH */
+	ret = of_address_to_resource(node, gicv_idx, &r);
+	if (!ret) {
+		if (!PAGE_ALIGNED(r.start))
+			pr_warn("GICV physical address 0x%llx not page aligned\n",
+				(unsigned long long)r.start);
+		else if (!PAGE_ALIGNED(resource_size(&r)))
+			pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
+				(unsigned long long)resource_size(&r),
+				PAGE_SIZE);
+		else
+			gic_v3_kvm_info.vcpu = r;
+	}
+
+	gic_set_kvm_info(&gic_v3_kvm_info);
+}
+
 static int __init gic_of_init(struct device_node *node, struct device_node *parent)
 {
 	void __iomem *dist_base;
@@ -952,8 +986,10 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 
 	err = gic_init_bases(dist_base, rdist_regs, nr_redist_regions,
 			     redist_stride, &node->fwnode);
-	if (!err)
+	if (!err) {
+		gic_of_setup_kvm_info(node);
 		return 0;
+	}
 
 out_unmap_rdist:
 	for (i = 0; i < nr_redist_regions; i++)
@@ -974,6 +1010,10 @@ static struct
 	struct redist_region *redist_regs;
 	u32 nr_redist_regions;
 	bool single_redist;
+	u32 maint_irq;
+	int maint_irq_mode;
+	phys_addr_t vctrl_base;
+	phys_addr_t vcpu_base;
 } acpi_data __initdata;
 
 static void __init
@@ -1020,6 +1060,13 @@ gic_acpi_parse_madt_gicc(struct acpi_subtable_header *header,
 		return -ENOMEM;
 
 	gic_acpi_register_redist(gicc->gicr_base_address, redist_base);
+
+	acpi_data.maint_irq = gicc->vgic_interrupt;
+	acpi_data.maint_irq_mode = (gicc->flags & ACPI_MADT_VGIC_IRQ_MODE) ?
+				    ACPI_EDGE_SENSITIVE : ACPI_LEVEL_SENSITIVE;
+	acpi_data.vctrl_base = gicc->gich_base_address;
+	acpi_data.vcpu_base = gicc->gicv_base_address;
+
 	return 0;
 }
 
@@ -1111,6 +1158,40 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
 }
 
 #define ACPI_GICV3_DIST_MEM_SIZE (SZ_64K)
+#define ACPI_GICV2_VCTRL_MEM_SIZE	(SZ_4K)
+#define ACPI_GICV2_VCPU_MEM_SIZE	(SZ_8K)
+
+static void __init gic_acpi_setup_kvm_info(void)
+{
+	int irq;
+
+	gic_v3_kvm_info.type = GIC_V3;
+
+	irq = acpi_register_gsi(NULL, acpi_data.maint_irq,
+				acpi_data.maint_irq_mode,
+				ACPI_ACTIVE_HIGH);
+	if (irq > 0)
+		gic_v3_kvm_info.maint_irq = irq;
+
+	if (acpi_data.vctrl_base) {
+		struct resource *vctrl = &gic_v3_kvm_info.vctrl;
+
+		vctrl->flags = IORESOURCE_MEM;
+		vctrl->start = acpi_data.vctrl_base;
+		vctrl->end = vctrl->start + ACPI_GICV2_VCTRL_MEM_SIZE - 1;
+	}
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
+
 
 static int __init
 gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
@@ -1159,6 +1240,8 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 		goto out_fwhandle_free;
 
 	acpi_set_irq_model(ACPI_IRQ_MODEL_GIC, domain_handle);
+	gic_acpi_setup_kvm_info();
+
 	return 0;
 
 out_fwhandle_free:
diff --git a/include/linux/irqchip/arm-gic-common.h b/include/linux/irqchip/arm-gic-common.h
index f7723b9..15d68c6 100644
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
