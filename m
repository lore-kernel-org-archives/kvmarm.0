From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v4 11/11] arm/arm64: gic: don't just use zero
Date: Tue,  8 Nov 2016 21:21:39 +0100
Message-ID: <1478636499-14339-12-git-send-email-drjones@redhat.com>
References: <1478636499-14339-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1478636499-14339-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org, Andrew Jones <drjones@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Allow user to select who sends ipis and with which irq,
rather than just always sending irq=0 from cpu0.

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v4: improve structure and make sure spurious checking is
    done even when the sender isn't cpu0
v2: actually check that the irq received was the irq sent,
    and (for gicv2) that the sender is the expected one.
---
 arm/gic.c | 99 ++++++++++++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 73 insertions(+), 26 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index d98ca6b9efd5..8e50bc1b35e0 100644
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
@@ -34,6 +35,8 @@ static struct gic *gic;
 static int gic_version;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static cpumask_t ready;
+static int sender;
+static u32 irq;
 
 static void nr_cpu_check(int nr)
 {
@@ -86,7 +89,16 @@ static void check_acked(cpumask_t *mask)
 
 static u32 gicv2_read_iar(void)
 {
-	return readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+	u32 iar = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+	int src = (iar >> 10) & 7;
+
+	if (src != sender) {
+		report("cpu%d received IPI from unexpected source cpu%d "
+		       "(expected cpu%d)",
+		       false, smp_processor_id(), src, sender);
+	}
+
+	return iar;
 }
 
 static u32 gicv2_irqnr(u32 iar)
@@ -111,9 +123,15 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 	if (irqnr != GICC_INT_SPURIOUS) {
 		gic->write_eoi(irqstat);
-		smp_rmb(); /* pairs with wmb in ipi_test functions */
-		++acked[smp_processor_id()];
-		smp_wmb(); /* pairs with rmb in check_acked */
+		if (irqnr == irq) {
+			smp_rmb(); /* pairs with wmb in ipi_test functions */
+			++acked[smp_processor_id()];
+			smp_wmb(); /* pairs with rmb in check_acked */
+		} else {
+			report("cpu%d received unexpected irq %u "
+			       "(expected %u)",
+			       false, smp_processor_id(), irqnr, irq);
+		}
 	} else {
 		++spurious[smp_processor_id()];
 		smp_wmb();
@@ -122,19 +140,19 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
 static void gicv2_ipi_send_self(void)
 {
-	writel(2 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	writel(2 << 24 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
 }
 
 static void gicv2_ipi_send_tlist(cpumask_t *mask)
 {
 	u8 tlist = (u8)cpumask_bits(mask)[0];
 
-	writel(tlist << 16, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	writel(tlist << 16 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
 }
 
 static void gicv2_ipi_send_broadcast(void)
 {
-	writel(1 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	writel(1 << 24 | irq, gicv2_dist_base() + GIC_DIST_SOFTINT);
 }
 
 #define ICC_SGI1R_AFFINITY_1_SHIFT	16
@@ -200,7 +218,7 @@ static void gicv3_ipi_send_tlist(cpumask_t *mask)
 		/* Send the IPIs for the target list of this cluster */
 		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
 			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
-			 /* irq << 24				| */
+			 irq << 24				|
 			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
 			 tlist);
 
@@ -222,7 +240,7 @@ static void gicv3_ipi_send_self(void)
 
 static void gicv3_ipi_send_broadcast(void)
 {
-	gicv3_write_sgi1r(1ULL << 40);
+	gicv3_write_sgi1r(1ULL << 40 | irq << 24);
 	isb();
 }
 
@@ -234,7 +252,7 @@ static void ipi_test_self(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_clear(&mask);
-	cpumask_set_cpu(0, &mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_self();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -249,7 +267,7 @@ static void ipi_test_smp(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
-	for (i = 0; i < nr_cpus; i += 2)
+	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
 		cpumask_clear_cpu(i, &mask);
 	gic->ipi.send_tlist(&mask);
 	check_acked(&mask);
@@ -259,7 +277,7 @@ static void ipi_test_smp(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
-	cpumask_clear_cpu(0, &mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_broadcast();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -276,6 +294,27 @@ static void ipi_enable(void)
 	local_irq_enable();
 }
 
+static void ipi_send(void)
+{
+	int cpu;
+
+	ipi_enable();
+	wait_on_ready();
+	ipi_test_self();
+	ipi_test_smp();
+
+	smp_rmb();
+	for_each_present_cpu(cpu) {
+		if (spurious[cpu]) {
+			printf("ipi: WARN: cpu%d got %d spurious "
+			       "interrupts\n",
+			       spurious[cpu], smp_processor_id());
+		}
+	}
+
+	exit(report_summary());
+}
+
 static void ipi_recv(void)
 {
 	ipi_enable();
@@ -284,6 +323,14 @@ static void ipi_recv(void)
 		wfi();
 }
 
+static void ipi_test(void)
+{
+	if (smp_processor_id() == sender)
+		ipi_send();
+	else
+		ipi_recv();
+}
+
 struct gic gicv2 = {
 	.ipi = {
 		.enable = gicv2_enable_defaults,
@@ -337,30 +384,30 @@ int main(int argc, char **argv)
 		report_prefix_pop();
 
 	} else if (!strcmp(argv[1], "ipi")) {
+		int off, i = 1;
+		long val;
 
 		report_prefix_push(argv[1]);
 		nr_cpu_check(2);
 
-		for_each_present_cpu(cpu) {
-			if (cpu == 0)
+		while (--argc != 1) {
+			off = parse_keyval(argv[++i], &val);
+			if (off == -1)
 				continue;
-			smp_boot_secondary(cpu, ipi_recv);
+			argv[i][off] = '\0';
+			if (strcmp(argv[i], "sender") == 0)
+				sender = val;
+			else if (strcmp(argv[i], "irq") == 0)
+				irq = val;
 		}
-		ipi_enable();
-		wait_on_ready();
-		ipi_test_self();
-		ipi_test_smp();
 
-		smp_rmb();
 		for_each_present_cpu(cpu) {
-			if (spurious[cpu]) {
-				printf("ipi: WARN: cpu%d got %d spurious "
-				       "interrupts\n",
-				       spurious[cpu], smp_processor_id());
-			}
+			if (cpu == 0)
+				continue;
+			smp_boot_secondary(cpu, ipi_test);
 		}
 
-		report_prefix_pop();
+		ipi_test();
 
 	} else {
 		report_abort("Unknown subtest '%s'", argv[1]);
-- 
2.7.4

