From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH kvm-unit-tests 3/3] arm64: timer: Add support for phys timer
 testing
Date: Thu, 13 Jul 2017 21:20:09 +0200
Message-ID: <20170713192009.10069-4-cdall@linaro.org>
References: <20170713192009.10069-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF30A40D29
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 15:19:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yiuDgCnZqCdb for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jul 2017 15:19:46 -0400 (EDT)
Received: from mail-wm0-f54.google.com (mail-wm0-f54.google.com [74.125.82.54])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2177F49C09
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 15:19:44 -0400 (EDT)
Received: by mail-wm0-f54.google.com with SMTP id w126so1940171wme.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jul 2017 12:20:24 -0700 (PDT)
In-Reply-To: <20170713192009.10069-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <cdall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Rearrange the code to be able to reuse as much as posible and add
support for testing the physical timer as well.

Also change the default unittests configuration to run a separate vtimer
and ptimer test so that older kernels without ptimer support just show a
failure.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 arm/timer.c       | 199 ++++++++++++++++++++++++++++++++++++++++++++++--------
 arm/unittests.cfg |   9 ++-
 2 files changed, 177 insertions(+), 31 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index 77d257c..33dfc6f 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -11,34 +11,119 @@
 #include <asm/gic.h>
 #include <asm/io.h>
 
-#define CNTV_CTL_ENABLE  (1 << 0)
-#define CNTV_CTL_IMASK   (1 << 1)
-#define CNTV_CTL_ISTATUS (1 << 2)
+#define ARCH_TIMER_CTL_ENABLE  (1 << 0)
+#define ARCH_TIMER_CTL_IMASK   (1 << 1)
+#define ARCH_TIMER_CTL_ISTATUS (1 << 2)
 
-static u32 vtimer_irq, vtimer_irq_flags;
 static void *gic_ispendr;
-static bool vtimer_irq_received;
+
+static u64 read_vtimer_counter(void)
+{
+	return read_sysreg(cntvct_el0);
+}
+
+static u64 read_vtimer_cval(void)
+{
+	return read_sysreg(cntv_cval_el0);
+}
+
+static void write_vtimer_cval(u64 val)
+{
+	write_sysreg(val, cntv_cval_el0);
+}
+
+static u64 read_vtimer_ctl(void)
+{
+	return read_sysreg(cntv_ctl_el0);
+}
+
+static void write_vtimer_ctl(u64 val)
+{
+	write_sysreg(val, cntv_ctl_el0);
+}
+
+static u64 read_ptimer_counter(void)
+{
+	return read_sysreg(cntpct_el0);
+}
+
+static u64 read_ptimer_cval(void)
+{
+	return read_sysreg(cntp_cval_el0);
+}
+
+static void write_ptimer_cval(u64 val)
+{
+	write_sysreg(val, cntp_cval_el0);
+}
+
+static u64 read_ptimer_ctl(void)
+{
+	return read_sysreg(cntp_ctl_el0);
+}
+
+static void write_ptimer_ctl(u64 val)
+{
+	write_sysreg(val, cntp_ctl_el0);
+}
+
+struct timer_info {
+	u32 irq;
+	u32 irq_flags;
+	bool irq_received;
+	u64 (*read_counter)(void);
+	u64 (*read_cval)(void);
+	void (*write_cval)(u64);
+	u64 (*read_ctl)(void);
+	void (*write_ctl)(u64);
+};
+
+static struct timer_info vtimer_info = {
+	.irq_received = false,
+	.read_counter = read_vtimer_counter,
+	.read_cval = read_vtimer_cval,
+	.write_cval = write_vtimer_cval,
+	.read_ctl = read_vtimer_ctl,
+	.write_ctl = write_vtimer_ctl,
+};
+
+static struct timer_info ptimer_info = {
+	.irq_received = false,
+	.read_counter = read_ptimer_counter,
+	.read_cval = read_ptimer_cval,
+	.write_cval = write_ptimer_cval,
+	.read_ctl = read_ptimer_ctl,
+	.write_ctl = write_ptimer_ctl,
+};
 
 static void irq_handler(struct pt_regs *regs)
 {
+	struct timer_info *info;
 	u32 irqstat = gic_read_iar();
 	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr != GICC_INT_SPURIOUS)
 		gic_write_eoir(irqstat);
 
-	if (irqnr == PPI(vtimer_irq)) {
-		write_sysreg(CNTV_CTL_IMASK | CNTV_CTL_ENABLE, cntv_ctl_el0);
-		++vtimer_irq_received;
+	if (irqnr == PPI(vtimer_info.irq)) {
+		info = &vtimer_info;
+	} else if (irqnr == PPI(ptimer_info.irq)) {
+		info = &ptimer_info;
+	} else {
+		report_info("Unexpected interrupt: %d\n", irqnr);
+		return;
 	}
+
+	info->write_ctl(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE);
+	info->irq_received = true;
 }
 
-static bool gic_vtimer_pending(void)
+static bool gic_timer_pending(struct timer_info *info)
 {
-	return readl(gic_ispendr) & (1 << PPI(vtimer_irq));
+	return readl(gic_ispendr) & (1 << PPI(info->irq));
 }
 
-static bool test_cval_10msec(void)
+static bool test_cval_10msec(struct timer_info *info)
 {
 	u64 time_10ms = read_sysreg(cntfrq_el0) / 100;
 	u64 time_1us = time_10ms / 10000;
@@ -46,15 +131,15 @@ static bool test_cval_10msec(void)
 	s64 difference;
 
 	/* Program timer to fire in 10 ms */
-	before_timer = read_sysreg(cntvct_el0);
-	write_sysreg(before_timer + time_10ms, cntv_cval_el0);
+	before_timer = info->read_counter();
+	info->write_cval(before_timer + time_10ms);
 
 	/* Wait for the timer to fire */
-	while (!(read_sysreg(cntv_ctl_el0) & CNTV_CTL_ISTATUS))
+	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
 		;
 
 	/* It fired, check how long it took */
-	after_timer = read_sysreg(cntvct_el0);
+	after_timer = info->read_counter();
 	difference = after_timer - (before_timer + time_10ms);
 
 	report_info("After timer: 0x%016lx", after_timer);
@@ -62,32 +147,43 @@ static bool test_cval_10msec(void)
 	report_info("Difference : %ld us", difference / time_1us);
 
 	if (difference < 0) {
-		printf("CNTV_CTL_EL0.ISTATUS set too early\n");
+		printf("ISTATUS set too early\n");
 		return false;
 	}
 	return difference < time_10ms;
 }
 
-static void test_vtimer(void)
+static void test_timer(struct timer_info *info)
 {
 	u64 now = read_sysreg(cntvct_el0);
 	u64 time_10s = read_sysreg(cntfrq_el0) * 10;
 	u64 later = now + time_10s;
 
-	report_prefix_push("vtimer-busy-loop");
 
 	/* Enable the timer, but schedule it for much later*/
-	write_sysreg(later, cntv_cval_el0);
+	info->write_cval(later);
 	isb();
-	write_sysreg(CNTV_CTL_ENABLE, cntv_ctl_el0);
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 
-	report("not pending before", !gic_vtimer_pending());
-	report("latency within 10 ms", test_cval_10msec());
-	report("interrupt received", vtimer_irq_received);
+	report("not pending before", !gic_timer_pending(info));
+	report("latency within 10 ms", test_cval_10msec(info));
+	report("interrupt received", info->irq_received);
 
 	/* Disable the timer again */
-	write_sysreg(0, cntv_ctl_el0);
+	info->write_ctl(0);
+}
+
+static void test_vtimer(void)
+{
+	report_prefix_push("vtimer-busy-loop");
+	test_timer(&vtimer_info);
+	report_prefix_pop();
+}
 
+static void test_ptimer(void)
+{
+	report_prefix_push("ptimer-busy-loop");
+	test_timer(&ptimer_info);
 	report_prefix_pop();
 }
 
@@ -102,20 +198,26 @@ static void test_init(void)
 	assert(node >= 0);
 	prop = fdt_get_property(fdt, node, "interrupts", &len);
 	assert(prop && len == (4 * 3 * sizeof(u32)));
+
 	data = (u32 *)prop->data;
+	assert(fdt32_to_cpu(data[3]) == 1);
+	ptimer_info.irq = fdt32_to_cpu(data[4]);
+	ptimer_info.irq_flags = fdt32_to_cpu(data[5]);
 	assert(fdt32_to_cpu(data[6]) == 1);
-	vtimer_irq = fdt32_to_cpu(data[7]);
-	vtimer_irq_flags = fdt32_to_cpu(data[8]);
+	vtimer_info.irq = fdt32_to_cpu(data[7]);
+	vtimer_info.irq_flags = fdt32_to_cpu(data[8]);
 
 	gic_enable_defaults();
 
 	switch (gic_version()) {
 	case 2:
-		writel(1 << PPI(vtimer_irq), gicv2_dist_base() + GICD_ISENABLER + 0);
+		writel(1 << PPI(vtimer_info.irq), gicv2_dist_base() + GICD_ISENABLER + 0);
+		writel(1 << PPI(ptimer_info.irq), gicv2_dist_base() + GICD_ISENABLER + 0);
 		gic_ispendr = gicv2_dist_base() + GICD_ISPENDR;
 		break;
 	case 3:
-		writel(1 << PPI(vtimer_irq), gicv3_sgi_base() + GICR_ISENABLER0);
+		writel(1 << PPI(vtimer_info.irq), gicv3_sgi_base() + GICR_ISENABLER0);
+		writel(1 << PPI(ptimer_info.irq), gicv3_sgi_base() + GICR_ISENABLER0);
 		gic_ispendr = gicv3_sgi_base() + GICD_ISPENDR;
 		break;
 	}
@@ -124,15 +226,52 @@ static void test_init(void)
 	local_irq_enable();
 }
 
-int main(void)
+static void print_vtimer_info(void)
 {
 	printf("CNTFRQ_EL0   : 0x%016lx\n", read_sysreg(cntfrq_el0));
 	printf("CNTVCT_EL0   : 0x%016lx\n", read_sysreg(cntvct_el0));
 	printf("CNTV_CTL_EL0 : 0x%016lx\n", read_sysreg(cntv_ctl_el0));
 	printf("CNTV_CVAL_EL0: 0x%016lx\n", read_sysreg(cntv_cval_el0));
+}
+
+static void print_ptimer_info(void)
+{
+	printf("CNTPCT_EL0   : 0x%016lx\n", read_sysreg(cntpct_el0));
+	printf("CNTP_CTL_EL0 : 0x%016lx\n", read_sysreg(cntp_ctl_el0));
+	printf("CNTP_CVAL_EL0: 0x%016lx\n", read_sysreg(cntp_cval_el0));
+}
+
+
+int main(int argc, char **argv)
+{
+	bool run_ptimer_test = false;
+	bool run_vtimer_test = false;
+
+	/* Check if we should also check the physical timer */
+	if (argc > 1) {
+		if (strcmp(argv[1], "vtimer") == 0) {
+			run_vtimer_test = true;
+		} else if (strcmp(argv[1], "ptimer") == 0) {
+			run_ptimer_test = true;
+		} else {
+			report_abort("Unknown option '%s'", argv[1]);
+		}
+	} else {
+		run_vtimer_test = true;
+	}
+
+	if (run_vtimer_test)
+		print_vtimer_info();
+	else if (run_ptimer_test)
+		print_ptimer_info();
 
 	test_init();
-	test_vtimer();
+
+	if (run_vtimer_test)
+		test_vtimer();
+	else if (run_ptimer_test)
+		test_ptimer();
+
 
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bdfedf8..d55e52e 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -111,7 +111,14 @@ smp = $MAX_SMP
 groups = psci
 
 # Timer tests
-[timer]
+[vtimer]
 file = timer.flat
+extra_params = -append 'vtimer'
+groups = timer
+timeout = 2s
+
+[ptimer]
+file = timer.flat
+extra_params = -append 'ptimer'
 groups = timer
 timeout = 2s
-- 
2.9.0
