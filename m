From: Wei Huang <wei@redhat.com>
Subject: [PATCH V1 1/5] kvm: arm64: Enable ACPI support for virt arch timer
Date: Thu, 28 May 2015 01:34:30 -0400
Message-ID: <1432791274-15242-2-git-send-email-wei@redhat.com>
References: <1432791274-15242-1-git-send-email-wei@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1432791274-15242-1-git-send-email-wei@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, hanjun.guo@linaro.org, a.spyridakis@virtualopensystems.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

This patches enables ACPI support for KVM virtual arch timer. It allows
KVM to parse ACPI table for arch timer PPI when DT table is not present.

Signed-off-by: Alexander Spyridaki <a.spyridakis@virtualopensystems.com>
Signed-off-by: Wei Huang <wei@redhat.com>
---
 virt/kvm/arm/arch_timer.c | 64 +++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 13 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 98c95f2..7da9eb3 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -21,6 +21,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/interrupt.h>
+#include <linux/acpi.h>
 
 #include <clocksource/arm_arch_timer.h>
 #include <asm/arch_timer.h>
@@ -274,9 +275,46 @@ static const struct of_device_id arch_timer_of_match[] = {
 	{},
 };
 
-int kvm_timer_hyp_init(void)
+static int kvm_timer_ppi_dt_parse(unsigned int *ppi)
 {
 	struct device_node *np;
+
+	np = of_find_matching_node(NULL, arch_timer_of_match);
+	if (!np)
+		return -ENODEV;
+
+	*ppi = irq_of_parse_and_map(np, 2);
+	if (*ppi == 0) {
+		of_node_put(np);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_ACPI
+struct acpi_table_gtdt *gtdt_acpi;
+static void arch_timer_acpi_parse(struct acpi_table_header *table)
+{
+	gtdt_acpi = container_of(table, struct acpi_table_gtdt, header);
+}
+
+static int kvm_timer_ppi_acpi_parse(unsigned int *ppi)
+{
+	/* Get the interrupt number from the GTDT table */
+	acpi_table_parse(ACPI_SIG_GTDT,
+			 (acpi_tbl_table_handler)arch_timer_acpi_parse);
+
+	if (!gtdt_acpi->virtual_timer_interrupt)
+		return -EINVAL;
+
+	*ppi = gtdt_acpi->virtual_timer_interrupt;
+	return 0;
+}
+#endif
+
+int kvm_timer_hyp_init(void)
+{
 	unsigned int ppi;
 	int err;
 
@@ -284,19 +322,20 @@ int kvm_timer_hyp_init(void)
 	if (!timecounter)
 		return -ENODEV;
 
-	np = of_find_matching_node(NULL, arch_timer_of_match);
-	if (!np) {
-		kvm_err("kvm_arch_timer: can't find DT node\n");
-		return -ENODEV;
-	}
+	/* PPI parsing: try DT first, then ACPI */
+	err = kvm_timer_ppi_dt_parse(&ppi);
+#ifdef CONFIG_ACPI
+	if (err && !acpi_disabled)
+		err = kvm_timer_ppi_acpi_parse(&ppi);
+#endif
 
-	ppi = irq_of_parse_and_map(np, 2);
-	if (!ppi) {
-		kvm_err("kvm_arch_timer: no virtual timer interrupt\n");
-		err = -EINVAL;
-		goto out;
+	if (err) {
+		kvm_err("kvm_arch_timer: can't find virtual timer info or "
+			"config virtual timer interrupt\n");
+		return err;
 	}
 
+	/* configure IRQ handler */
 	err = request_percpu_irq(ppi, kvm_arch_timer_handler,
 				 "kvm guest timer", kvm_get_running_vcpus());
 	if (err) {
@@ -319,14 +358,13 @@ int kvm_timer_hyp_init(void)
 		goto out_free;
 	}
 
-	kvm_info("%s IRQ%d\n", np->name, ppi);
+	kvm_info("timer IRQ%d\n", ppi);
 	on_each_cpu(kvm_timer_init_interrupt, NULL, 1);
 
 	goto out;
 out_free:
 	free_percpu_irq(ppi, kvm_get_running_vcpus());
 out:
-	of_node_put(np);
 	return err;
 }
 
-- 
1.8.3.1

