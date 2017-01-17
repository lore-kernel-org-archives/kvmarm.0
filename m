From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [RFC PATCH 21/33] irqchip/gic-v3-its: Add VPE irq domain
 allocation/teardown
Date: Tue, 17 Jan 2017 10:20:42 +0000
Message-ID: <1484648454-21216-22-git-send-email-marc.zyngier@arm.com>
References: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 303654069B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id friNwUHn9Swq for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Jan 2017 05:19:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF06340666
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Jan 2017 05:19:52 -0500 (EST)
In-Reply-To: <1484648454-21216-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>
List-Id: kvmarm@lists.cs.columbia.edu

When creating a VM, the low level GICv4 code is responsible for:
- allocating each VPE a unique VPEID
- allocating a doorbell interrupt for each VPE
- allocating the pending tables for each VPE
- allocating the property table for the VM

This of course has to be reversed when the VM is brought down.

All of this is wired into the irq domain alloc/free methods.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 174 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 174 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index ddd8096..54d0075 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -139,6 +139,7 @@ static struct rdists *gic_rdists;
 static struct irq_domain *its_parent;
 
 static unsigned long its_list_map;
+static DEFINE_IDA(its_vpeid_ida);
 
 #define gic_data_rdist()		(raw_cpu_ptr(gic_rdists->rdist))
 #define gic_data_rdist_rd_base()	(gic_data_rdist()->rd_base)
@@ -1146,6 +1147,11 @@ static struct page *its_allocate_prop_table(gfp_t gfp_flags)
 	return prop_page;
 }
 
+static void its_free_prop_table(struct page *prop_page)
+{
+	free_pages((unsigned long)page_address(prop_page),
+		   get_order(LPI_PROPBASE_SZ));
+}
 
 static int __init its_alloc_lpi_tables(void)
 {
@@ -1444,6 +1450,12 @@ static struct page *its_allocate_pending_table(gfp_t gfp_flags)
 	return pend_page;
 }
 
+static void its_free_pending_table(struct page *pt)
+{
+	free_pages((unsigned long)page_address(pt),
+		   get_order(max(LPI_PENDBASE_SZ, SZ_64K)));
+}
+
 static void its_cpu_init_lpis(void)
 {
 	void __iomem *rbase = gic_data_rdist_rd_base();
@@ -1666,6 +1678,34 @@ static bool its_alloc_device_table(struct its_node *its, u32 dev_id)
 	return its_alloc_table_entry(baser, dev_id);
 }
 
+static bool its_alloc_vpe_table(u32 vpe_id)
+{
+	struct its_node *its;
+
+	/*
+	 * Make sure the L2 tables are allocated on *all* v4 ITSs. We
+	 * could try and only do it on ITSs corresponding to devices
+	 * that have interrupts targeted at this VPE, but the
+	 * complexity becomes crazy (and you have tons of memory
+	 * anyway, right?).
+	 */
+	list_for_each_entry(its, &its_nodes, entry) {
+		struct its_baser *baser;
+
+		if (!its->is_v4)
+			continue;
+
+		baser = its_get_baser(its, GITS_BASER_TYPE_VCPU);
+		if (!baser)
+			return false;
+
+		if (!its_alloc_table_entry(baser, vpe_id))
+			return false;
+	}
+
+	return true;
+}
+
 static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 					    int nvecs)
 {
@@ -1922,7 +1962,141 @@ static struct irq_chip its_vpe_irq_chip = {
 	.name			= "GICv4-vpe",
 };
 
+static int its_vpe_id_alloc(void)
+{
+	return ida_simple_get(&its_vpeid_ida, 0, 1 << 16, GFP_KERNEL);
+}
+
+static void its_vpe_id_free(u16 id)
+{
+	ida_simple_remove(&its_vpeid_ida, id);
+}
+
+static int its_vpe_init(struct its_vpe *vpe)
+{
+	struct page *vpt_page;
+	int vpe_id;
+
+	/* Allocate vpe_id */
+	vpe_id = its_vpe_id_alloc();
+	if (vpe_id < 0)
+		return vpe_id;
+
+	/* Allocate VPT */
+	vpt_page = its_allocate_pending_table(GFP_KERNEL);
+	if (vpt_page) {
+		its_vpe_id_free(vpe_id);
+		return -ENOMEM;
+	}
+
+	if (!its_alloc_vpe_table(vpe_id)) {
+		its_vpe_id_free(vpe_id);
+		its_free_pending_table(vpe->vpt_page);
+		return -ENOMEM;
+	}
+
+	vpe->vpe_id = vpe_id;
+	vpe->vpt_page = vpt_page;
+
+	return 0;
+}
+
+static void its_vpe_teardown(struct its_vpe *vpe)
+{
+	its_vpe_id_free(vpe->vpe_id);
+	its_free_pending_table(vpe->vpt_page);
+}
+
+static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq,
+				    unsigned int nr_irqs, void *args)
+{
+	msi_alloc_info_t *info = args;
+	struct its_vpe **vpes = info->scratchpad[0].ptr;
+	struct its_vm *vm = vpes[0]->its_vm;
+	unsigned long *bitmap;
+	struct page *vprop_page;
+	int base, nr_ids, i, err = 0;
+
+	bitmap = its_lpi_alloc_chunks(nr_irqs, &base, &nr_ids);
+	if (!bitmap)
+		return -ENOMEM;
+
+	if (nr_ids < nr_irqs) {
+		its_lpi_free_chunks(bitmap, base, nr_ids);
+		return -ENOMEM;
+	}
+
+	vprop_page = its_allocate_prop_table(GFP_KERNEL);
+	if (!vprop_page) {
+		its_lpi_free_chunks(bitmap, base, nr_ids);
+		return ENOMEM;
+	}
+
+	for (i = 0; i < nr_irqs; i++) {
+		vpes[i]->vpe_db_lpi = base + i;
+		err = its_vpe_init(vpes[i]);
+		if (err)
+			break;
+		irq_domain_set_hwirq_and_chip(domain,
+					      virq + i, vpes[i]->vpe_db_lpi,
+					      &its_vpe_irq_chip, vpes[i]);
+		set_bit(i, bitmap);
+	}
+
+	if (err) {
+		while (--i >= 0) {
+			its_vpe_teardown(vpes[i]);
+			clear_bit(i, bitmap);
+		}
+
+		its_lpi_free_chunks(bitmap, base, nr_ids);
+		its_free_prop_table(vprop_page);
+
+		return err;
+	}
+
+	vm->db_bitmap = bitmap;
+	vm->db_lpi_base = base;
+	vm->nr_db_lpis = nr_ids;
+	vm->vprop_page = vprop_page;
+
+	return 0;
+}
+
+static void its_vpe_irq_domain_free(struct irq_domain *domain,
+				    unsigned int virq,
+				    unsigned int nr_irqs)
+{
+	struct its_vm *vm = NULL;
+	int i;
+
+	for (i = 0; i < nr_irqs; i++) {
+		struct irq_data *data = irq_domain_get_irq_data(domain, virq);
+		struct its_vpe *vpe = irq_data_get_irq_chip_data(data);
+
+		BUG_ON(vm && vm != vpe->its_vm);
+		if (!vm)
+			vm = vpe->its_vm;
+
+		clear_bit(vpe->vpe_db_lpi - vm->db_lpi_base, vm->db_bitmap);
+		its_vpe_teardown(vpe);
+		irq_domain_reset_irq_data(data);
+	}
+
+	if (!vm)
+		return;
+
+	if (bitmap_empty(vm->db_bitmap, vm->nr_db_lpis)) {
+		its_lpi_free_chunks(vm->db_bitmap, vm->db_lpi_base, vm->nr_db_lpis);
+		its_free_prop_table(vm->vprop_page);
+	}
+
+	irq_domain_free_irqs_parent(domain, virq, nr_irqs);
+}
+
 static const struct irq_domain_ops its_vpe_domain_ops = {
+	.alloc			= its_vpe_irq_domain_alloc,
+	.free			= its_vpe_irq_domain_free,
 };
 
 static int its_force_quiescent(void __iomem *base)
-- 
2.1.4
