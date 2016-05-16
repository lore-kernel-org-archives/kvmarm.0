From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 10/10] arm/arm64: gic: don't just use zero
Date: Mon, 16 May 2016 09:57:24 +0200
Message-ID: <1463385444-12916-11-git-send-email-drjones@redhat.com>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7BA749B37
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 03:54:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kZ1y6rJgEn9Q for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 May 2016 03:54:42 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D1FFE40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 May 2016 03:54:42 -0400 (EDT)
In-Reply-To: <1463385444-12916-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Allow user to select who sends ipis and with which irq, rather
than just always sending irq=0 from cpu0.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c | 53 ++++++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index ec8e0a26ff724..b76b946f2c106 100644
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
@@ -31,6 +32,7 @@ struct gic {
 
 static struct gic *gic;
 static int gic_version;
+static int sender, irq;
 static int acked[NR_CPUS];
 static cpumask_t ready;
 
@@ -92,19 +94,19 @@ static void ipi_handler(struct pt_regs *regs __unused)
 
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
@@ -147,7 +149,7 @@ static void gicv3_ipi_send_tlist(cpumask_t *mask)
 
 		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
 			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
-			 /* irq << 24				| */
+			 irq << 24				|
 			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
 			 tlist);
 
@@ -184,7 +186,7 @@ static void ipi_test_self(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_clear(&mask);
-	cpumask_set_cpu(0, &mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_self();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -199,7 +201,7 @@ static void ipi_test_smp(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
-	for (i = 0; i < nr_cpus; i += 2)
+	for (i = smp_processor_id() & 1; i < nr_cpus; i += 2)
 		cpumask_clear_cpu(i, &mask);
 	gic->ipi.send_tlist(&mask);
 	check_acked(&mask);
@@ -209,7 +211,7 @@ static void ipi_test_smp(void)
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
-	cpumask_clear_cpu(0, &mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
 	gic->ipi.send_broadcast();
 	check_acked(&mask);
 	report_prefix_pop();
@@ -226,6 +228,15 @@ static void ipi_enable(void)
 	local_irq_enable();
 }
 
+static void ipi_send(void)
+{
+	ipi_enable();
+	wait_on_ready();
+	ipi_test_self();
+	ipi_test_smp();
+	exit(report_summary());
+}
+
 static void ipi_recv(void)
 {
 	ipi_enable();
@@ -284,6 +295,19 @@ int main(int argc, char **argv)
 		ipi_test_self();
 
 	} else if (!strcmp(argv[0], "ipi")) {
+		int off, i = 0;
+		long val;
+
+		while (--argc) {
+			off = parse_keyval(argv[++i], &val);
+			if (off == -1)
+				continue;
+			argv[i][off] = '\0';
+			if (strcmp(argv[i], "sender") == 0)
+				sender = val;
+			else if (strcmp(argv[i], "irq") == 0)
+				irq = val;
+		}
 
 		report_prefix_push(argv[0]);
 		nr_cpu_check(2);
@@ -292,11 +316,18 @@ int main(int argc, char **argv)
 		for_each_present_cpu(cpu) {
 			if (cpu == 0)
 				continue;
-			smp_boot_secondary(cpu, ipi_recv);
+			if (cpu == sender)
+				smp_boot_secondary(cpu, ipi_send);
+			else
+				smp_boot_secondary(cpu, ipi_recv);
+		}
+		if (sender == 0)  {
+			wait_on_ready();
+			ipi_test_self();
+			ipi_test_smp();
+		} else {
+			ipi_recv();
 		}
-		wait_on_ready();
-		ipi_test_self();
-		ipi_test_smp();
 		report_prefix_pop();
 
 	} else {
-- 
2.4.11
