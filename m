From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v7 11/11] arm/arm64: gic: don't just use zero
Date: Wed, 23 Nov 2016 17:54:06 +0100
Message-ID: <20161123165406.32661-12-drjones@redhat.com>
References: <20161123165406.32661-1-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A12640D56
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:54:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rjV9GmBZyxbN for <kvmarm@lists.cs.columbia.edu>;
 Wed, 23 Nov 2016 11:53:59 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5E2B940D14
 for <kvmarm@lists.cs.columbia.edu>; Wed, 23 Nov 2016 11:53:59 -0500 (EST)
In-Reply-To: <20161123165406.32661-1-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, pbonzini@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

Allow user to select who sends ipis and with which irq,
rather than just always sending irq=0 from cpu0.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v7: cleanup cmdline parsing and add complain on bad args [Eric]
v6:
 - make sender/irq names more future-proof [drew]
 - sanity check inputs [drew]
 - introduce check_sender/irq and bad_sender/irq to more
   cleanly do checks [drew]
 - default sender and irq to 1, instead of still zero [drew]
v4: improve structure and make sure spurious checking is
    done even when the sender isn't cpu0
v2: actually check that the irq received was the irq sent,
    and (for gicv2) that the sender is the expected one.
---
 arm/gic.c | 143 ++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 120 insertions(+), 23 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 23c1860a49d9..88c5f49d807d 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -11,6 +11,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <util.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/gic.h>
@@ -27,6 +28,8 @@ struct gic {
 
 static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
+static int bad_sender[NR_CPUS], bad_irq[NR_CPUS];
+static int cmdl_sender = 1, cmdl_irq = 1;
 static cpumask_t ready;
 
 static void nr_cpu_check(int nr)
@@ -42,10 +45,23 @@ static void wait_on_ready(void)
 		cpu_relax();
 }
 
+static void stats_reset(void)
+{
+	int i;
+
+	for (i = 0; i < nr_cpus; ++i) {
+		acked[i] = 0;
+		bad_sender[i] = -1;
+		bad_irq[i] = -1;
+	}
+	smp_wmb();
+}
+
 static void check_acked(cpumask_t *mask)
 {
 	int missing = 0, extra = 0, unexpected = 0;
 	int nr_pass, cpu, i;
+	bool bad = false;
 
 	/* Wait up to 5s for all interrupts to be delivered */
 	for (i = 0; i < 50; ++i) {
@@ -55,9 +71,21 @@ static void check_acked(cpumask_t *mask)
 			smp_rmb();
 			nr_pass += cpumask_test_cpu(cpu, mask) ?
 				acked[cpu] == 1 : acked[cpu] == 0;
+
+			if (bad_sender[cpu] != -1) {
+				printf("cpu%d received IPI from wrong sender %d\n",
+					cpu, bad_sender[cpu]);
+				bad = true;
+			}
+
+			if (bad_irq[cpu] != -1) {
+				printf("cpu%d received wrong irq %d\n",
+					cpu, bad_irq[cpu]);
+				bad = true;
+			}
 		}
 		if (nr_pass == nr_cpus) {
-			report("Completed in %d ms", true, ++i * 100);
+			report("Completed in %d ms", !bad, ++i * 100);
 			return;
 		}
 	}
@@ -90,6 +118,22 @@ static void check_spurious(void)
 	}
 }
 
+static void check_ipi_sender(u32 irqstat)
+{
+	if (gic_version() == 2) {
+		int src = (irqstat >> 10) & 7;
+
+		if (src != cmdl_sender)
+			bad_sender[smp_processor_id()] = src;
+	}
+}
+
+static void check_irqnr(u32 irqnr)
+{
+	if (irqnr != (u32)cmdl_irq)
+		bad_irq[smp_processor_id()] = irqnr;
+}
+
 static void ipi_handler(struct pt_regs *regs __unused)
 {
 	u32 irqstat = gic_read_iar();
@@ -97,8 +141,10 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic_write_eoir(irqstat);
-		smp_rmb(); /* pairs with wmb in ipi_test functions */
+		smp_rmb(); /* pairs with wmb in stats_reset */
 		++acked[smp_processor_id()];
+		check_ipi_sender(irqstat);
+		check_irqnr(irqnr);
 		smp_wmb(); /* pairs with rmb in check_acked */
 	} else {
 		++spurious[smp_processor_id()];
@@ -108,22 +154,22 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 static void gicv2_ipi_send_self(void)
 {
-	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
+	writel(2 << 24 | cmdl_irq, gicv2_dist_base() + GICD_SGIR);
 }
 
 static void gicv2_ipi_send_broadcast(void)
 {
-	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
+	writel(1 << 24 | cmdl_irq, gicv2_dist_base() + GICD_SGIR);
 }
 
 static void gicv3_ipi_send_self(void)
 {
-	gic_ipi_send_single(0, smp_processor_id());
+	gic_ipi_send_single(cmdl_irq, smp_processor_id());
 }
 
 static void gicv3_ipi_send_broadcast(void)
 {
-	gicv3_write_sgi1r(1ULL << 40);
+	gicv3_write_sgi1r(1ULL << 40 | cmdl_irq << 24);
 	isb();
 }
 
@@ -132,10 +178,9 @@ static void ipi_test_self(void)
 	cpumask_t mask;
 
 	report_prefix_push("self");
-	memset(acked, 0, sizeof(acked));
-	smp_wmb();
+	stats_reset();
 	cpumask_clear(&mask);
-	cpumask_set_cpu(0, &mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_self();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -147,20 +192,18 @@ static void ipi_test_smp(void)
 	int i;
 
 	report_prefix_push("target-list");
-	memset(acked, 0, sizeof(acked));
-	smp_wmb();
+	stats_reset();
 	cpumask_copy(&mask, &cpu_present_mask);
-	for (i = 0; i < nr_cpus; i += 2)
+	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
 		cpumask_clear_cpu(i, &mask);
-	gic_ipi_send_mask(0, &mask);
+	gic_ipi_send_mask(cmdl_irq, &mask);
 	check_acked(&mask);
 	report_prefix_pop();
 
 	report_prefix_push("broadcast");
-	memset(acked, 0, sizeof(acked));
-	smp_wmb();
+	stats_reset();
 	cpumask_copy(&mask, &cpu_present_mask);
-	cpumask_clear_cpu(0, &mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_broadcast();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -177,6 +220,16 @@ static void ipi_enable(void)
 	local_irq_enable();
 }
 
+static void ipi_send(void)
+{
+	ipi_enable();
+	wait_on_ready();
+	ipi_test_self();
+	ipi_test_smp();
+	check_spurious();
+	exit(report_summary());
+}
+
 static void ipi_recv(void)
 {
 	ipi_enable();
@@ -185,6 +238,54 @@ static void ipi_recv(void)
 		wfi();
 }
 
+static void ipi_test(void)
+{
+	if (smp_processor_id() == cmdl_sender)
+		ipi_send();
+	else
+		ipi_recv();
+}
+
+#define CMDL_IPI_USAGE "usage: gic ipi [sender=<cpu#>] [irq=<sgi#>]"
+
+static void cmdl_ipi_set_sender(int sender)
+{
+	if (sender < nr_cpus) {
+		cmdl_sender = sender;
+		return;
+	}
+	report_abort("invalid sender %d, nr_cpus=%d", sender, nr_cpus);
+}
+
+static void cmdl_ipi_set_irq(int irq)
+{
+	if (irq < 16) {
+		cmdl_irq = irq;
+		return;
+	}
+	report_abort("invalid irq %d, SGI must be < 16", irq);
+}
+
+static void cmdl_ipi_get_inputs(int argc, char **argv)
+{
+	int off, i = 1;
+	long val;
+
+	while (--argc != 1) {
+		off = parse_keyval(argv[++i], &val);
+		if (off == -1)
+			report_abort(CMDL_IPI_USAGE);
+		argv[i][off] = '\0';
+
+		if (strcmp(argv[i], "sender") == 0)
+			cmdl_ipi_set_sender(val);
+		else if (strcmp(argv[i], "irq") == 0)
+			cmdl_ipi_set_irq(val);
+		else
+			report_abort(CMDL_IPI_USAGE);
+	}
+}
+
 static struct gic gicv2 = {
 	.ipi = {
 		.send_self = gicv2_ipi_send_self,
@@ -230,19 +331,15 @@ int main(int argc, char **argv)
 	} else if (strcmp(argv[1], "ipi") == 0) {
 
 		report_prefix_push(argv[1]);
+		cmdl_ipi_get_inputs(argc, argv);
 		nr_cpu_check(2);
 
 		for_each_present_cpu(cpu) {
 			if (cpu == 0)
 				continue;
-			smp_boot_secondary(cpu, ipi_recv);
+			smp_boot_secondary(cpu, ipi_test);
 		}
-		ipi_enable();
-		wait_on_ready();
-		ipi_test_self();
-		ipi_test_smp();
-		check_spurious();
-		report_prefix_pop();
+		ipi_test();
 
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
-- 
2.9.3
