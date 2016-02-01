From: fu.wei@linaro.org
Subject: [PATCH v3 2/6] clocksource: simplify ACPI code in arm_arch_timer.c
Date: Tue,  2 Feb 2016 04:26:54 +0800
Message-ID: <1454358418-5157-3-git-send-email-fu.wei@linaro.org>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Sender: linux-acpi-owner@vger.kernel.org
To: rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, al.stone@linaro.org, graeme.gregory@linaro.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, arnd@arndb.de, wim@iguana.be, jcm@redhat.com, leo.duran@amd.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Suravee.Suthikulpanit@amd.com, robherring2@gmail.com, Fu Wei <fu.wei@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Fu Wei <fu.wei@linaro.org>

The patch update arm_arch_timer driver to use the function
provided by the new GTDT driver of ACPI.
By this way, arm_arch_timer.c can be simplified, and separate
all the ACPI GTDT knowledge from this timer driver.

Signed-off-by: Fu Wei <fu.wei@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/clocksource/Kconfig          |  1 +
 drivers/clocksource/arm_arch_timer.c | 48 ++++++++----------------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfig
index 2eb5f0e..445c7cb 100644
--- a/drivers/clocksource/Kconfig
+++ b/drivers/clocksource/Kconfig
@@ -8,6 +8,7 @@ config CLKSRC_OF
 config CLKSRC_ACPI
 	bool
 	select CLKSRC_PROBE
+	select ACPI_GTDT
 
 config CLKSRC_PROBE
 	bool
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index e16fdad..87d6bae 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -806,60 +806,32 @@ static void __init arch_timer_mem_init(struct device_node *np)
 CLOCKSOURCE_OF_DECLARE(armv7_arch_timer_mem, "arm,armv7-timer-mem",
 		       arch_timer_mem_init);
 
-#ifdef CONFIG_ACPI
-static int __init map_generic_timer_interrupt(u32 interrupt, u32 flags)
-{
-	int trigger, polarity;
-
-	if (!interrupt)
-		return 0;
-
-	trigger = (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
-			: ACPI_LEVEL_SENSITIVE;
-
-	polarity = (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
-			: ACPI_ACTIVE_HIGH;
-
-	return acpi_register_gsi(NULL, interrupt, trigger, polarity);
-}
-
+#ifdef CONFIG_ACPI_GTDT
 /* Initialize per-processor generic timer */
 static int __init arch_timer_acpi_init(struct acpi_table_header *table)
 {
-	struct acpi_table_gtdt *gtdt;
+	struct arch_timer_data data;
 
 	if (arch_timers_present & ARCH_CP15_TIMER) {
 		pr_warn("arch_timer: already initialized, skipping\n");
 		return -EINVAL;
 	}
 
-	gtdt = container_of(table, struct acpi_table_gtdt, header);
-
 	arch_timers_present |= ARCH_CP15_TIMER;
 
-	arch_timer_ppi[PHYS_SECURE_PPI] =
-		map_generic_timer_interrupt(gtdt->secure_el1_interrupt,
-		gtdt->secure_el1_flags);
-
-	arch_timer_ppi[PHYS_NONSECURE_PPI] =
-		map_generic_timer_interrupt(gtdt->non_secure_el1_interrupt,
-		gtdt->non_secure_el1_flags);
-
-	arch_timer_ppi[VIRT_PPI] =
-		map_generic_timer_interrupt(gtdt->virtual_timer_interrupt,
-		gtdt->virtual_timer_flags);
+	if (gtdt_arch_timer_data_init(table, &data))
+		return -EINVAL;
 
-	arch_timer_ppi[HYP_PPI] =
-		map_generic_timer_interrupt(gtdt->non_secure_el2_interrupt,
-		gtdt->non_secure_el2_flags);
+	arch_timer_ppi[PHYS_SECURE_PPI] = data.phys_secure_ppi;
+	arch_timer_ppi[PHYS_NONSECURE_PPI] = data.phys_nonsecure_ppi;
+	arch_timer_ppi[VIRT_PPI] = data.virt_ppi;
+	arch_timer_ppi[HYP_PPI] = data.hyp_ppi;
+	arch_timer_c3stop = data.c3stop; /* Always-on capability */
 
 	/* Get the frequency from CNTFRQ */
 	arch_timer_detect_rate(NULL, NULL);
-
-	/* Always-on capability */
-	arch_timer_c3stop = !(gtdt->non_secure_el1_flags & ACPI_GTDT_ALWAYS_ON);
-
 	arch_timer_init();
+
 	return 0;
 }
 CLOCKSOURCE_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_init);
-- 
2.5.0

