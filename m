From: fu.wei@linaro.org
Subject: [PATCH v3 1/6] ACPI: add GTDT table parse driver into ACPI driver
Date: Tue,  2 Feb 2016 04:26:53 +0800
Message-ID: <1454358418-5157-2-git-send-email-fu.wei@linaro.org>
References: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454358418-5157-1-git-send-email-fu.wei@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: rjw@rjwysocki.net, lenb@kernel.org, daniel.lezcano@linaro.org, tglx@linutronix.de, christoffer.dall@linaro.org, marc.zyngier@arm.com, gleb@kernel.org, pbonzini@redhat.com, hanjun.guo@linaro.org, wei@redhat.com, a.spyridakis@virtualopensystems.com
Cc: linaro-acpi@lists.linaro.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, al.stone@linaro.org, graeme.gregory@linaro.org, davem@davemloft.net, jeffrey.t.kirsher@intel.com, richardcochran@gmail.com, arnd@arndb.de, wim@iguana.be, jcm@redhat.com, leo.duran@amd.com, mark.rutland@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Suravee.Suthikulpanit@amd.com, robherring2@gmail.com, Fu Wei <fu.wei@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

=46rom: Fu Wei <fu.wei@linaro.org>

This driver adds support for parsing all kinds of timer in GTDT:
(1)arch timer: provide a kernel API to parse all the PPIs and
always-on info in GTDT and export them by arch_timer_data struct.

(2)memory-mapped timer: provide several kernel APIs to parse
GT Block Structure in GTDT, export those info by return value
and arch_timer_mem_data struct.

(3)SBSA Generic Watchdog: parse all info in SBSA Generic Watchdog
Structure in GTDT, and creating a platform device with that
information. This allows the operating system to obtain device
data from the resource of platform device.
The platform device named "sbsa-gwdt" can be used by the ARM SBSA
Generic Watchdog driver.

By this driver, we can simplify all the relevant drivers, and
separate all the ACPI GTDT knowledge from them.

Signed-off-by: Fu Wei <fu.wei@linaro.org>
Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 drivers/acpi/Kconfig                 |   9 +
 drivers/acpi/Makefile                |   1 +
 drivers/acpi/gtdt.c                  | 375 +++++++++++++++++++++++++++=
++++++++
 drivers/clocksource/arm_arch_timer.c |   2 -
 include/clocksource/arm_arch_timer.h |  19 ++
 include/linux/acpi.h                 |  17 ++
 6 files changed, 421 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 5eef4cb..e2bfad1 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -510,4 +510,13 @@ config XPOWER_PMIC_OPREGION
=20
 endif
=20
+config ACPI_GTDT
+	bool "ACPI GTDT Support"
+	depends on ARM64
+	help
+	  GTDT (Generic Timer Description Table) provides information
+	  for per-processor timers and Platform (memory-mapped) timers
+	  for ARM platforms. Select this option to provide information
+	  needed for the timers init.
+
 endif	# ACPI
diff --git a/drivers/acpi/Makefile b/drivers/acpi/Makefile
index 675eaf3..ac42e31 100644
--- a/drivers/acpi/Makefile
+++ b/drivers/acpi/Makefile
@@ -96,5 +96,6 @@ obj-$(CONFIG_ACPI_EXTLOG)	+=3D acpi_extlog.o
 obj-$(CONFIG_PMIC_OPREGION)	+=3D pmic/intel_pmic.o
 obj-$(CONFIG_CRC_PMIC_OPREGION) +=3D pmic/intel_pmic_crc.o
 obj-$(CONFIG_XPOWER_PMIC_OPREGION) +=3D pmic/intel_pmic_xpower.o
+obj-$(CONFIG_ACPI_GTDT)		+=3D gtdt.o
=20
 video-objs			+=3D acpi_video.o video_detect.o
diff --git a/drivers/acpi/gtdt.c b/drivers/acpi/gtdt.c
new file mode 100644
index 0000000..047fea1
--- /dev/null
+++ b/drivers/acpi/gtdt.c
@@ -0,0 +1,375 @@
+/*
+ * ARM Specific GTDT table Support
+ *
+ * Copyright (C) 2015, Linaro Ltd.
+ * Author: Fu Wei <fu.wei@linaro.org>
+ *         Hanjun Guo <hanjun.guo@linaro.org>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/acpi.h>
+#include <linux/device.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+
+#include <clocksource/arm_arch_timer.h>
+
+#undef pr_fmt
+#define pr_fmt(fmt) "GTDT: " fmt
+
+static u32 platform_timer_count __initdata;
+static int gtdt_timers_existence __initdata;
+
+/*
+ * Get some basic info from GTDT table, and init the global variables =
above
+ * for all timers initialization of Generic Timer.
+ * This function does some validation on GTDT table, and will be run o=
nly once.
+ */
+static void __init *platform_timer_info_init(struct acpi_table_header =
*table)
+{
+	void *gtdt_end, *platform_timer_struct, *platform_timer;
+	struct acpi_gtdt_header *header;
+	struct acpi_table_gtdt *gtdt;
+	u32 i;
+
+	gtdt =3D container_of(table, struct acpi_table_gtdt, header);
+	if (!gtdt) {
+		pr_err("table pointer error.\n");
+		return NULL;
+	}
+	gtdt_end =3D (void *)table + table->length;
+	gtdt_timers_existence |=3D ARCH_CP15_TIMER;
+
+	if (table->revision < 2) {
+		pr_info("Revision:%d doesn't support Platform Timers.\n",
+			table->revision);
+		return NULL;
+	}
+
+	platform_timer_count =3D gtdt->platform_timer_count;
+	if (!platform_timer_count) {
+		pr_info("No Platform Timer structures.\n");
+		return NULL;
+	}
+
+	platform_timer_struct =3D (void *)gtdt + gtdt->platform_timer_offset;
+	if (platform_timer_struct < (void *)table +
+				    sizeof(struct acpi_table_gtdt)) {
+		pr_err(FW_BUG "Platform Timer pointer error.\n");
+		return NULL;
+	}
+
+	platform_timer =3D platform_timer_struct;
+	for (i =3D 0; i < platform_timer_count; i++) {
+		if (platform_timer > gtdt_end) {
+			pr_err(FW_BUG "subtable pointer overflows.\n");
+			platform_timer_count =3D i;
+			break;
+		}
+		header =3D (struct acpi_gtdt_header *)platform_timer;
+		if (header->type =3D=3D ACPI_GTDT_TYPE_TIMER_BLOCK)
+			gtdt_timers_existence |=3D ARCH_MEM_TIMER;
+		else if (header->type =3D=3D ACPI_GTDT_TYPE_WATCHDOG)
+			gtdt_timers_existence |=3D ARCH_WD_TIMER;
+		platform_timer +=3D header->length;
+	}
+
+	return platform_timer_struct;
+}
+
+static int __init map_generic_timer_interrupt(u32 interrupt, u32 flags=
)
+{
+	int trigger, polarity;
+
+	if (!interrupt)
+		return 0;
+
+	trigger =3D (flags & ACPI_GTDT_INTERRUPT_MODE) ? ACPI_EDGE_SENSITIVE
+			: ACPI_LEVEL_SENSITIVE;
+
+	polarity =3D (flags & ACPI_GTDT_INTERRUPT_POLARITY) ? ACPI_ACTIVE_LOW
+			: ACPI_ACTIVE_HIGH;
+
+	return acpi_register_gsi(NULL, interrupt, trigger, polarity);
+}
+
+/*
+ * Get the necessary info of arch_timer from GTDT table.
+ */
+int __init gtdt_arch_timer_data_init(struct acpi_table_header *table,
+				     struct arch_timer_data *data)
+{
+	struct acpi_table_gtdt *gtdt;
+
+	if (acpi_disabled || !data)
+		return -EINVAL;
+
+	if (!table) {
+		if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_GTDT, 0, &table)))
+			return -EINVAL;
+	}
+
+	if (!gtdt_timers_existence)
+		platform_timer_info_init(table);
+
+	gtdt =3D container_of(table, struct acpi_table_gtdt, header);
+
+	data->phys_secure_ppi =3D
+		map_generic_timer_interrupt(gtdt->secure_el1_interrupt,
+					    gtdt->secure_el1_flags);
+
+	data->phys_nonsecure_ppi =3D
+		map_generic_timer_interrupt(gtdt->non_secure_el1_interrupt,
+					    gtdt->non_secure_el1_flags);
+
+	data->virt_ppi =3D
+		map_generic_timer_interrupt(gtdt->virtual_timer_interrupt,
+					    gtdt->virtual_timer_flags);
+
+	data->hyp_ppi =3D
+		map_generic_timer_interrupt(gtdt->non_secure_el2_interrupt,
+					    gtdt->non_secure_el2_flags);
+
+	data->c3stop =3D !(gtdt->non_secure_el1_flags & ACPI_GTDT_ALWAYS_ON);
+
+	return 0;
+}
+
+bool __init gtdt_timer_is_available(int type)
+{
+	return gtdt_timers_existence | type;
+}
+
+/*
+ * Helper function for getting the pointer of platform_timer_struct.
+ */
+static void __init *get_platform_timer_struct(struct acpi_table_header=
 *table)
+{
+	struct acpi_table_gtdt *gtdt;
+
+	if (!table) {
+		pr_err("table pointer error.\n");
+		return NULL;
+	}
+
+	gtdt =3D container_of(table, struct acpi_table_gtdt, header);
+
+	return (void *)gtdt + gtdt->platform_timer_offset;
+}
+
+ /*
+ * Get the pointer of GT Block Structure in GTDT table
+ */
+void __init *gtdt_gt_block(struct acpi_table_header *table, int index)
+{
+	struct acpi_gtdt_header *header;
+	void *platform_timer;
+	int i, j;
+
+	if (!gtdt_timers_existence)
+		platform_timer =3D platform_timer_info_init(table);
+	else
+		platform_timer =3D get_platform_timer_struct(table);
+
+	if (!gtdt_timer_is_available(ARCH_MEM_TIMER))
+		return NULL;
+
+	for (i =3D 0, j =3D 0; i < platform_timer_count; i++) {
+		header =3D (struct acpi_gtdt_header *)platform_timer;
+		if (header->type =3D=3D ACPI_GTDT_TYPE_TIMER_BLOCK && j++ =3D=3D ind=
ex)
+			return platform_timer;
+		platform_timer +=3D header->length;
+	}
+
+	return NULL;
+}
+
+/*
+ * Get the timer_count(the number of timer frame) of a GT Block in GTD=
T table
+ */
+u32 __init gtdt_gt_timer_count(struct acpi_gtdt_timer_block *gt_block)
+{
+	if (!gt_block) {
+		pr_err("invalid GT Block baseaddr.\n");
+		return 0;
+	}
+
+	return gt_block->timer_count;
+}
+
+/*
+ * Get the physical address of GT Block in GTDT table
+ */
+void __init *gtdt_gt_cntctlbase(struct acpi_gtdt_timer_block *gt_block=
)
+{
+	if (!gt_block) {
+		pr_err("invalid GT Block baseaddr.\n");
+		return NULL;
+	}
+
+	return (void *)gt_block->block_address;
+}
+
+/*
+ * Helper function for getting the pointer of a timer frame in GT bloc=
k.
+ */
+static void __init *gtdt_gt_timer_frame(struct acpi_gtdt_timer_block *=
gt_block,
+					int index)
+{
+	void *timer_frame;
+
+	if (!(gt_block && gt_block->timer_count))
+		return NULL;
+
+	timer_frame =3D (void *)gt_block + gt_block->timer_offset +
+		      sizeof(struct acpi_gtdt_timer_entry) * index;
+
+	if (timer_frame <=3D (void *)gt_block + gt_block->header.length -
+			   sizeof(struct acpi_gtdt_timer_entry))
+		return timer_frame;
+
+	pr_err(FW_BUG "invalid GT Block timer frame entry addr.\n");
+
+	return NULL;
+}
+
+/*
+ * Get the GT timer Frame Number(ID) in a GT Block Timer Structure.
+ * The maximum Frame Number(ID) is (ARCH_TIMER_MEM_MAX_FRAME - 1),
+ * so returning ARCH_TIMER_MEM_MAX_FRAME means error.
+ */
+u32 __init gtdt_gt_frame_number(struct acpi_gtdt_timer_block *gt_block=
,
+				int index)
+{
+	struct acpi_gtdt_timer_entry *frame;
+
+	frame =3D (struct acpi_gtdt_timer_entry *)gtdt_gt_timer_frame(gt_bloc=
k,
+								    index);
+	if (frame)
+		return frame->frame_number;
+
+	return ARCH_TIMER_MEM_MAX_FRAME;
+}
+
+/*
+ * Get the GT timer Frame data in a GT Block Timer Structure
+ */
+int __init gtdt_gt_timer_data(struct acpi_gtdt_timer_block *gt_block,
+			      int index, bool virt,
+			      struct arch_timer_mem_data *data)
+{
+	struct acpi_gtdt_timer_entry *frame;
+
+	frame =3D (struct acpi_gtdt_timer_entry *)gtdt_gt_timer_frame(gt_bloc=
k,
+								    index);
+	if (!frame)
+		return -EINVAL;
+
+	data->cntbase_phy =3D (phys_addr_t)frame->base_address;
+	if (virt)
+		data->irq =3D map_generic_timer_interrupt(
+				frame->virtual_timer_interrupt,
+				frame->virtual_timer_flags);
+	else
+		data->irq =3D map_generic_timer_interrupt(frame->timer_interrupt,
+							frame->timer_flags);
+
+	return 0;
+}
+
+/*
+ * Initialize a SBSA generic Watchdog platform device info from GTDT
+ */
+static int __init gtdt_import_sbsa_gwdt(struct acpi_gtdt_watchdog *wd,
+					int index)
+{
+	struct platform_device *pdev;
+	int irq =3D map_generic_timer_interrupt(wd->timer_interrupt,
+					      wd->timer_flags);
+
+	/*
+	 * According to SBSA specification the size of refresh and control
+	 * frames of SBSA Generic Watchdog is SZ_4K(Offset 0x000 =E2=80=93 0x=
=46FF).
+	 */
+	struct resource res[] =3D {
+		DEFINE_RES_IRQ(irq),
+		DEFINE_RES_MEM(wd->control_frame_address, SZ_4K),
+		DEFINE_RES_MEM(wd->refresh_frame_address, SZ_4K),
+	};
+
+	pr_debug("a Watchdog GT(0x%llx/0x%llx gsi:%u flags:0x%x).\n",
+		 wd->refresh_frame_address, wd->control_frame_address,
+		 wd->timer_interrupt, wd->timer_flags);
+
+	if (!(wd->refresh_frame_address &&
+	      wd->control_frame_address &&
+	      wd->timer_interrupt)) {
+		pr_err(FW_BUG "failed geting the device info.\n");
+		return -EINVAL;
+	}
+
+	if (irq < 0) {
+		pr_err("failed to register GSI of the Watchdog GT.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Add a platform device named "sbsa-gwdt" to match the platform driv=
er.
+	 * "sbsa-gwdt": SBSA(Server Base System Architecture) Generic Watchdo=
g
+	 * The platform driver (like drivers/watchdog/sbsa_gwdt.c)can get dev=
ice
+	 * info below by matching this name.
+	 */
+	pdev =3D platform_device_register_simple("sbsa-gwdt", index, res,
+					       ARRAY_SIZE(res));
+	if (IS_ERR(pdev)) {
+		acpi_unregister_gsi(wd->timer_interrupt);
+		return PTR_ERR(pdev);
+	}
+
+	return 0;
+}
+
+static int __init gtdt_sbsa_gwdt_init(void)
+{
+	struct acpi_table_header *table;
+	struct acpi_gtdt_header *header;
+	void *platform_timer;
+	int i, gwdt_index;
+	int ret =3D 0;
+
+	if (acpi_disabled)
+		return 0;
+
+	if (ACPI_FAILURE(acpi_get_table(ACPI_SIG_GTDT, 0, &table)))
+		return -EINVAL;
+
+	/*
+	 * At this proint, we have got and validate some info about platform
+	 * timer in platform_timer_info_init.
+	 */
+	if (!gtdt_timer_is_available(ARCH_WD_TIMER))
+		return -EINVAL;
+
+	platform_timer =3D get_platform_timer_struct(table);
+
+	for (i =3D 0, gwdt_index =3D 0; i < platform_timer_count; i++) {
+		header =3D (struct acpi_gtdt_header *)platform_timer;
+		if (header->type =3D=3D ACPI_GTDT_TYPE_WATCHDOG) {
+			ret =3D gtdt_import_sbsa_gwdt(platform_timer, gwdt_index);
+			if (ret)
+				pr_err("failed to import subtable %d.\n", i);
+			else
+				gwdt_index++;
+		}
+		platform_timer +=3D header->length;
+	}
+
+	return ret;
+}
+
+device_initcall(gtdt_sbsa_gwdt_init);
diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource=
/arm_arch_timer.c
index c64d543..e16fdad 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -40,8 +40,6 @@
 #define CNTV_TVAL	0x38
 #define CNTV_CTL	0x3c
=20
-#define ARCH_CP15_TIMER	BIT(0)
-#define ARCH_MEM_TIMER	BIT(1)
 static unsigned arch_timers_present __initdata;
=20
 static void __iomem *arch_counter_base;
diff --git a/include/clocksource/arm_arch_timer.h b/include/clocksource=
/arm_arch_timer.h
index 9916d0e..7a6d6dc 100644
--- a/include/clocksource/arm_arch_timer.h
+++ b/include/clocksource/arm_arch_timer.h
@@ -19,6 +19,10 @@
 #include <linux/timecounter.h>
 #include <linux/types.h>
=20
+#define ARCH_CP15_TIMER	BIT(0)
+#define ARCH_MEM_TIMER	BIT(1)
+#define ARCH_WD_TIMER	BIT(2)
+
 #define ARCH_TIMER_CTRL_ENABLE		(1 << 0)
 #define ARCH_TIMER_CTRL_IT_MASK		(1 << 1)
 #define ARCH_TIMER_CTRL_IT_STAT		(1 << 2)
@@ -33,6 +37,8 @@ enum arch_timer_reg {
 #define ARCH_TIMER_MEM_PHYS_ACCESS	2
 #define ARCH_TIMER_MEM_VIRT_ACCESS	3
=20
+#define ARCH_TIMER_MEM_MAX_FRAME	8
+
 #define ARCH_TIMER_USR_PCT_ACCESS_EN	(1 << 0) /* physical counter */
 #define ARCH_TIMER_USR_VCT_ACCESS_EN	(1 << 1) /* virtual counter */
 #define ARCH_TIMER_VIRT_EVT_EN		(1 << 2)
@@ -43,6 +49,19 @@ enum arch_timer_reg {
=20
 #define ARCH_TIMER_EVT_STREAM_FREQ	10000	/* 100us */
=20
+struct arch_timer_data {
+	int phys_secure_ppi;
+	int phys_nonsecure_ppi;
+	int virt_ppi;
+	int hyp_ppi;
+	bool c3stop;
+};
+
+struct arch_timer_mem_data {
+	phys_addr_t cntbase_phy;
+	int irq;
+};
+
 #ifdef CONFIG_ARM_ARCH_TIMER
=20
 extern u32 arch_timer_get_rate(void);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 1991aea..2cec0c9 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -468,6 +468,23 @@ void acpi_walk_dep_device_list(acpi_handle handle)=
;
 struct platform_device *acpi_create_platform_device(struct acpi_device=
 *);
 #define ACPI_PTR(_ptr)	(_ptr)
=20
+#ifdef CONFIG_ACPI_GTDT
+bool __init gtdt_timer_is_available(int type);
+
+struct arch_timer_data;
+int __init gtdt_arch_timer_data_init(struct acpi_table_header *table,
+				     struct arch_timer_data *data);
+struct arch_timer_mem_data;
+void __init *gtdt_gt_block(struct acpi_table_header *table, int index)=
;
+u32 __init gtdt_gt_timer_count(struct acpi_gtdt_timer_block *gt_block)=
;
+void __init *gtdt_gt_cntctlbase(struct acpi_gtdt_timer_block *gt_block=
);
+u32 __init gtdt_gt_frame_number(struct acpi_gtdt_timer_block *gt_block=
,
+				int index);
+int __init gtdt_gt_timer_data(struct acpi_gtdt_timer_block *gt_block,
+			      int index, bool virt,
+			      struct arch_timer_mem_data *data);
+#endif
+
 #else	/* !CONFIG_ACPI */
=20
 #define acpi_disabled 1
--=20
2.5.0
