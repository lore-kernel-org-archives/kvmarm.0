From: fu.wei@linaro.org
Subject: [PATCH v3 3/6] clocksource: add memory-mapped timer support in arm_arch_timer.c
Date: Tue,  2 Feb 2016 04:26:55 +0800
Message-ID: <1454358418-5157-4-git-send-email-fu.wei@linaro.org>
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

The patch add memory-mapped timer register support for arm_arch_timer d=
river
by using the information provided by the new GTDT driver of ACPI.

Signed-off-by: Fu Wei <fu.wei@linaro.org>
---
 drivers/clocksource/arm_arch_timer.c | 136 +++++++++++++++++++++++++++=
++++++++
 1 file changed, 136 insertions(+)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource=
/arm_arch_timer.c
index 87d6bae..3792fd6 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -666,6 +666,15 @@ arch_timer_needs_probing(int type, const struct of=
_device_id *matches)
 		needs_probing =3D true;
 	of_node_put(dn);
=20
+#ifdef CONFIG_ACPI_GTDT
+	/*
+	 * Check if we have timer in GTDT table
+	 */
+	if (!acpi_disabled && gtdt_timer_is_available(type) &&
+	    !(arch_timers_present & type))
+		needs_probing =3D true;
+#endif
+
 	return needs_probing;
 }
=20
@@ -835,4 +844,131 @@ static int __init arch_timer_acpi_init(struct acp=
i_table_header *table)
 	return 0;
 }
 CLOCKSOURCE_ACPI_DECLARE(arch_timer, ACPI_SIG_GTDT, arch_timer_acpi_in=
it);
+
+static u32 __init arch_timer_mem_cnttidr(struct acpi_gtdt_timer_block =
*gt_block)
+{
+	phys_addr_t cntctlbase_phy;
+	void __iomem *cntctlbase;
+	u32 cnttidr;
+
+	cntctlbase_phy =3D (phys_addr_t)gtdt_gt_cntctlbase(gt_block);
+	if (!cntctlbase_phy) {
+		pr_err("arch_timer: Can't find CNTCTLBase.\n");
+		return 0;
+	}
+
+	/*
+	 * According to ARMv8 Architecture Reference Manual(ARM),
+	 * the size of CNTCTLBase frame of memory-mapped timer
+	 * is SZ_4K(Offset 0x000 =E2=80=93 0xFFF).
+	 */
+	cntctlbase =3D ioremap(cntctlbase_phy, SZ_4K);
+	if (!cntctlbase) {
+		pr_err("arch_timer: Can't map CNTCTLBase\n");
+		return 0;
+	}
+	cnttidr =3D readl_relaxed(cntctlbase + CNTTIDR);
+	iounmap(cntctlbase);
+
+	return cnttidr;
+}
+
+static int __init arch_timer_mem_best_frame(struct acpi_table_header *=
table,
+					    struct arch_timer_mem_data *data)
+{
+	struct acpi_gtdt_timer_block *gt_block;
+	u32 frame_number, timer_count, cnttidr;
+	int i;
+
+	gt_block =3D gtdt_gt_block(table, 0);
+	if (!gt_block) {
+		pr_err("arch_timer: Can't find GT Block.\n");
+		return -EINVAL;
+	}
+
+	timer_count =3D gtdt_gt_timer_count(gt_block);
+	if (!timer_count) {
+		pr_err("arch_timer: Can't find GT frame number.\n");
+		return -EINVAL;
+	}
+
+	if (gtdt_gt_timer_data(gt_block, 0, false, data)) {
+		pr_err("arch_timer: Can't get first phy timer.\n");
+		return -EINVAL;
+	}
+
+	/*
+	 * Get Generic Timer Counter-timer Timer ID Register
+	 * for Virtual Timer Capability info
+	 */
+	cnttidr =3D arch_timer_mem_cnttidr(gt_block);
+
+	/*
+	 * Try to find a virtual capable frame.
+	 * Otherwise fall back to the first physical capable frame.
+	 */
+	for (i =3D 0; i < timer_count; i++) {
+		frame_number =3D gtdt_gt_frame_number(gt_block, i);
+		if (frame_number < ARCH_TIMER_MEM_MAX_FRAME &&
+		    cnttidr & CNTTIDR_VIRT(frame_number)) {
+			if (!gtdt_gt_timer_data(gt_block, i, true, data)) {
+				arch_timer_mem_use_virtual =3D true;
+				return 0;
+			}
+			pr_warn("arch_timer: Can't get virt timer.\n");
+		}
+	}
+
+	return 0;
+}
+
+/* Initialize memory-mapped timer(wake-up timer) */
+static int __init arch_timer_mem_acpi_init(struct acpi_table_header *t=
able)
+{
+	struct arch_timer_mem_data data;
+	void __iomem *cntbase;
+
+	if (arch_timers_present & ARCH_MEM_TIMER) {
+		pr_warn("arch_timer_mem: already initialized, skipping\n");
+		return -EINVAL;
+	}
+	arch_timers_present |=3D ARCH_MEM_TIMER;
+
+	if (arch_timer_mem_best_frame(table, &data))
+		return -EINVAL;
+
+	/*
+	 * According to ARMv8 Architecture Reference Manual(ARM),
+	 * the size of CNTBaseN frames of memory-mapped timer
+	 * is SZ_4K(Offset 0x000 =E2=80=93 0xFFF).
+	 */
+	cntbase =3D ioremap(data.cntbase_phy, SZ_4K);
+	if (!cntbase) {
+		pr_err("arch_timer: Can't map CntBase.\n");
+		return -EINVAL;
+	}
+	arch_counter_base =3D cntbase;
+
+	if (!data.irq) {
+		pr_err("arch_timer: Frame missing %s irq",
+		       arch_timer_mem_use_virtual ? "virt" : "phys");
+		return -EINVAL;
+	}
+
+	/*
+	 * Because in a system that implements both Secure and
+	 * Non-secure states, CNTFRQ is only accessible in Secure state.
+	 * So we try to get the system counter frequency from cntfrq_el0
+	 * (system coprocessor register) here just like arch_timer.
+	 */
+	arch_timer_detect_rate(NULL, NULL);
+
+	arch_timer_mem_register(cntbase, data.irq);
+	arch_timer_common_init();
+
+	return 0;
+}
+
+CLOCKSOURCE_ACPI_DECLARE(arch_timer_mem, ACPI_SIG_GTDT,
+			 arch_timer_mem_acpi_init);
 #endif
--=20
2.5.0
