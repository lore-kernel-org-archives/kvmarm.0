From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 24/29] irqchip/gic-v3: Gather all ACPI specific data in a
 single structure
Date: Wed, 11 May 2016 15:30:17 +0200
Message-ID: <1462973422-10021-25-git-send-email-christoffer.dall@linaro.org>
References: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D50C4011D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DINCEXYdEG0I for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 May 2016 09:29:22 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6C0D949B47
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 09:29:16 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id e201so219202945wme.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 May 2016 06:32:14 -0700 (PDT)
In-Reply-To: <1462973422-10021-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Julien Grall <julien.grall@arm.com>

The ACPI code requires to use global variables in order to collect
information from the tables.

To make clear those variables are ACPI specific, gather all of them in a
single structure.

Furthermore, even if some of the variables are not marked with
__initdata, they are all only used during the initialization. Therefore,
the new variable, which hold the structure, can be marked with
__initdata.

Signed-off-by: Julien Grall <julien.grall@arm.com>
Acked-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 drivers/irqchip/irq-gic-v3.c | 60 ++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6dc6f03..6a9f5ff 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -970,19 +970,22 @@ out_unmap_dist:
 IRQCHIP_DECLARE(gic_v3, "arm,gic-v3", gic_of_init);
 
 #ifdef CONFIG_ACPI
-static void __iomem *dist_base;
-static struct redist_region *redist_regs __initdata;
-static u32 nr_redist_regions __initdata;
-static bool single_redist;
+static struct
+{
+	void __iomem *dist_base;
+	struct redist_region *redist_regs;
+	u32 nr_redist_regions;
+	bool single_redist;
+} acpi_data __initdata;
 
 static void __init
 gic_acpi_register_redist(phys_addr_t phys_base, void __iomem *redist_base)
 {
 	static int count = 0;
 
-	redist_regs[count].phys_base = phys_base;
-	redist_regs[count].redist_base = redist_base;
-	redist_regs[count].single_redist = single_redist;
+	acpi_data.redist_regs[count].phys_base = phys_base;
+	acpi_data.redist_regs[count].redist_base = redist_base;
+	acpi_data.redist_regs[count].single_redist = acpi_data.single_redist;
 	count++;
 }
 
@@ -1010,7 +1013,7 @@ gic_acpi_parse_madt_gicc(struct acpi_subtable_header *header,
 {
 	struct acpi_madt_generic_interrupt *gicc =
 				(struct acpi_madt_generic_interrupt *)header;
-	u32 reg = readl_relaxed(dist_base + GICD_PIDR2) & GIC_PIDR2_ARCH_MASK;
+	u32 reg = readl_relaxed(acpi_data.dist_base + GICD_PIDR2) & GIC_PIDR2_ARCH_MASK;
 	u32 size = reg == GIC_PIDR2_ARCH_GICv4 ? SZ_64K * 4 : SZ_64K * 2;
 	void __iomem *redist_base;
 
@@ -1027,7 +1030,7 @@ static int __init gic_acpi_collect_gicr_base(void)
 	acpi_tbl_entry_handler redist_parser;
 	enum acpi_madt_type type;
 
-	if (single_redist) {
+	if (acpi_data.single_redist) {
 		type = ACPI_MADT_TYPE_GENERIC_INTERRUPT;
 		redist_parser = gic_acpi_parse_madt_gicc;
 	} else {
@@ -1078,14 +1081,14 @@ static int __init gic_acpi_count_gicr_regions(void)
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_REDISTRIBUTOR,
 				      gic_acpi_match_gicr, 0);
 	if (count > 0) {
-		single_redist = false;
+		acpi_data.single_redist = false;
 		return count;
 	}
 
 	count = acpi_table_parse_madt(ACPI_MADT_TYPE_GENERIC_INTERRUPT,
 				      gic_acpi_match_gicc, 0);
 	if (count > 0)
-		single_redist = true;
+		acpi_data.single_redist = true;
 
 	return count;
 }
@@ -1105,7 +1108,7 @@ static bool __init acpi_validate_gic_table(struct acpi_subtable_header *header,
 	if (count <= 0)
 		return false;
 
-	nr_redist_regions = count;
+	acpi_data.nr_redist_regions = count;
 	return true;
 }
 
@@ -1116,25 +1119,28 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 {
 	struct acpi_madt_generic_distributor *dist;
 	struct fwnode_handle *domain_handle;
+	size_t size;
 	int i, err;
 
 	/* Get distributor base address */
 	dist = (struct acpi_madt_generic_distributor *)header;
-	dist_base = ioremap(dist->base_address, ACPI_GICV3_DIST_MEM_SIZE);
-	if (!dist_base) {
+	acpi_data.dist_base = ioremap(dist->base_address,
+				      ACPI_GICV3_DIST_MEM_SIZE);
+	if (!acpi_data.dist_base) {
 		pr_err("Unable to map GICD registers\n");
 		return -ENOMEM;
 	}
 
-	err = gic_validate_dist_version(dist_base);
+	err = gic_validate_dist_version(acpi_data.dist_base);
 	if (err) {
-		pr_err("No distributor detected at @%p, giving up", dist_base);
+		pr_err("No distributor detected at @%p, giving up",
+		       acpi_data.dist_base);
 		goto out_dist_unmap;
 	}
 
-	redist_regs = kzalloc(sizeof(*redist_regs) * nr_redist_regions,
-			      GFP_KERNEL);
-	if (!redist_regs) {
+	size = sizeof(*acpi_data.redist_regs) * acpi_data.nr_redist_regions;
+	acpi_data.redist_regs = kzalloc(size, GFP_KERNEL);
+	if (!acpi_data.redist_regs) {
 		err = -ENOMEM;
 		goto out_dist_unmap;
 	}
@@ -1143,14 +1149,14 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 	if (err)
 		goto out_redist_unmap;
 
-	domain_handle = irq_domain_alloc_fwnode(dist_base);
+	domain_handle = irq_domain_alloc_fwnode(acpi_data.dist_base);
 	if (!domain_handle) {
 		err = -ENOMEM;
 		goto out_redist_unmap;
 	}
 
-	err = gic_init_bases(dist_base, redist_regs, nr_redist_regions, 0,
-			     domain_handle);
+	err = gic_init_bases(acpi_data.dist_base, acpi_data.redist_regs,
+			     acpi_data.nr_redist_regions, 0, domain_handle);
 	if (err)
 		goto out_fwhandle_free;
 
@@ -1160,12 +1166,12 @@ gic_acpi_init(struct acpi_subtable_header *header, const unsigned long end)
 out_fwhandle_free:
 	irq_domain_free_fwnode(domain_handle);
 out_redist_unmap:
-	for (i = 0; i < nr_redist_regions; i++)
-		if (redist_regs[i].redist_base)
-			iounmap(redist_regs[i].redist_base);
-	kfree(redist_regs);
+	for (i = 0; i < acpi_data.nr_redist_regions; i++)
+		if (acpi_data.redist_regs[i].redist_base)
+			iounmap(acpi_data.redist_regs[i].redist_base);
+	kfree(acpi_data.redist_regs);
 out_dist_unmap:
-	iounmap(dist_base);
+	iounmap(acpi_data.dist_base);
 	return err;
 }
 IRQCHIP_ACPI_DECLARE(gic_v3, ACPI_MADT_TYPE_GENERIC_DISTRIBUTOR,
-- 
2.1.2.330.g565301e.dirty
