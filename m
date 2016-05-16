From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 09/10] arm/arm64: gicv3: add an IPI test
Date: Mon, 16 May 2016 09:57:23 +0200
Message-ID: <1463385444-12916-10-git-send-email-drjones@redhat.com>
References: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1463385444-12916-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org
Cc: christoffer.dall@linaro.org, marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c         | 160 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 arm/unittests.cfg |   6 ++
 2 files changed, 157 insertions(+), 9 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index 24be9e0ade369..ec8e0a26ff724 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -3,6 +3,8 @@
  *
  * GICv2
  *   . test sending/receiving IPIs
+ * GICv3
+ *   . test sending/receiving IPIs
  *
  * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -16,6 +18,18 @@
 #include <asm/barrier.h>
 #include <asm/io.h>
 
+struct gic {
+	struct {
+		void (*enable)(void);
+		void (*send_self)(void);
+		void (*send_tlist)(cpumask_t *);
+		void (*send_broadcast)(void);
+	} ipi;
+	u32 (*read_iar)(void);
+	void (*write_eoi)(u32);
+};
+
+static struct gic *gic;
 static int gic_version;
 static int acked[NR_CPUS];
 static cpumask_t ready;
@@ -54,18 +68,114 @@ static void check_acked(cpumask_t *mask)
 	report("timed-out (5s timeout)", false);
 }
 
+static u32 gicv2_read_iar(void)
+{
+	return readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+}
+
+static void gicv2_write_eoi(u32 irq)
+{
+	writel(irq, gicv2_cpu_base() + GIC_CPU_EOI);
+}
+
 static void ipi_handler(struct pt_regs *regs __unused)
 {
-	u32 iar = readl(gicv2_cpu_base() + GIC_CPU_INTACK);
+	u32 iar = gic->read_iar();
 
 	if (iar != GICC_INT_SPURIOUS) {
-		writel(iar, gicv2_cpu_base() + GIC_CPU_EOI);
+		gic->write_eoi(iar);
 		smp_rmb();
 		++acked[smp_processor_id()];
 		smp_wmb();
 	}
 }
 
+static void gicv2_ipi_send_self(void)
+{
+	writel(2 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+}
+
+static void gicv2_ipi_send_tlist(cpumask_t *mask)
+{
+	u8 tlist = (u8)cpumask_bits(mask)[0];
+
+	writel(tlist << 16, gicv2_dist_base() + GIC_DIST_SOFTINT);
+}
+
+static void gicv2_ipi_send_broadcast(void)
+{
+	writel(1 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+}
+
+#define ICC_SGI1R_AFFINITY_1_SHIFT	16
+#define ICC_SGI1R_AFFINITY_2_SHIFT	32
+#define ICC_SGI1R_AFFINITY_3_SHIFT	48
+#define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
+	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
+
+static void gicv3_ipi_send_tlist(cpumask_t *mask)
+{
+	u16 tlist;
+	int cpu;
+
+	for_each_cpu(cpu, mask) {
+		u64 mpidr = cpus[cpu], sgi1r;
+		u64 cluster_id = mpidr & ~0xffUL;
+
+		tlist = 0;
+
+		while (cpu < nr_cpus) {
+			if ((mpidr & 0xff) >= 16) {
+				printf("cpu%d MPIDR:aff0 is %d (>= 16)!\n",
+					cpu, (int)(mpidr & 0xff));
+				break;
+			}
+
+			tlist |= 1 << (mpidr & 0xf);
+
+			cpu = cpumask_next(cpu, mask);
+			if (cpu >= nr_cpus)
+				break;
+
+			mpidr = cpus[cpu];
+
+			if (cluster_id != (mpidr & ~0xffUL)) {
+				--cpu;
+				break;
+			}
+		}
+
+		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
+			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
+			 /* irq << 24				| */
+			 MPIDR_TO_SGI_AFFINITY(cluster_id, 1)	|
+			 tlist);
+
+		gicv3_write_sgi1r(sgi1r);
+	}
+
+	/* Force the above writes to ICC_SGI1R_EL1 to be executed */
+	isb();
+}
+
+static void gicv3_ipi_send_self(void)
+{
+	cpumask_t mask;
+
+	cpumask_clear(&mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
+	gicv3_ipi_send_tlist(&mask);
+}
+
+static void gicv3_ipi_send_broadcast(void)
+{
+	cpumask_t mask;
+
+	cpumask_copy(&mask, &cpu_present_mask);
+	cpumask_clear_cpu(smp_processor_id(), &mask);
+	gicv3_ipi_send_tlist(&mask);
+}
+
 static void ipi_test_self(void)
 {
 	cpumask_t mask;
@@ -75,7 +185,7 @@ static void ipi_test_self(void)
 	smp_wmb();
 	cpumask_clear(&mask);
 	cpumask_set_cpu(0, &mask);
-	writel(2 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	gic->ipi.send_self();
 	check_acked(&mask);
 	report_prefix_pop();
 }
@@ -83,14 +193,15 @@ static void ipi_test_self(void)
 static void ipi_test_smp(void)
 {
 	cpumask_t mask;
-	unsigned long tlist;
+	int i;
 
 	report_prefix_push("target-list");
 	memset(acked, 0, sizeof(acked));
 	smp_wmb();
-	tlist = cpumask_bits(&cpu_present_mask)[0] & 0xaa;
-	cpumask_bits(&mask)[0] = tlist;
-	writel((u8)tlist << 16, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	cpumask_copy(&mask, &cpu_present_mask);
+	for (i = 0; i < nr_cpus; i += 2)
+		cpumask_clear_cpu(i, &mask);
+	gic->ipi.send_tlist(&mask);
 	check_acked(&mask);
 	report_prefix_pop();
 
@@ -99,14 +210,14 @@ static void ipi_test_smp(void)
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
 	cpumask_clear_cpu(0, &mask);
-	writel(1 << 24, gicv2_dist_base() + GIC_DIST_SOFTINT);
+	gic->ipi.send_broadcast();
 	check_acked(&mask);
 	report_prefix_pop();
 }
 
 static void ipi_enable(void)
 {
-	gicv2_enable_defaults();
+	gic->ipi.enable();
 #ifdef __arm__
 	install_exception_handler(EXCPTN_IRQ, ipi_handler);
 #else
@@ -123,6 +234,28 @@ static void ipi_recv(void)
 		wfi();
 }
 
+struct gic gicv2 = {
+	.ipi = {
+		.enable = gicv2_enable_defaults,
+		.send_self = gicv2_ipi_send_self,
+		.send_tlist = gicv2_ipi_send_tlist,
+		.send_broadcast = gicv2_ipi_send_broadcast,
+	},
+	.read_iar = gicv2_read_iar,
+	.write_eoi = gicv2_write_eoi,
+};
+
+struct gic gicv3 = {
+	.ipi = {
+		.enable = gicv3_enable_defaults,
+		.send_self = gicv3_ipi_send_self,
+		.send_tlist = gicv3_ipi_send_tlist,
+		.send_broadcast = gicv3_ipi_send_broadcast,
+	},
+	.read_iar = gicv3_read_iar,
+	.write_eoi = gicv3_write_eoir,
+};
+
 int main(int argc, char **argv)
 {
 	char pfx[8];
@@ -135,6 +268,15 @@ int main(int argc, char **argv)
 	snprintf(pfx, 8, "gicv%d", gic_version);
 	report_prefix_push(pfx);
 
+	switch (gic_version) {
+	case 2:
+		gic = &gicv2;
+		break;
+	case 3:
+		gic = &gicv3;
+		break;
+	}
+
 	if (argc == 0) {
 
 		report_prefix_push("ipi");
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bb364675043f0..043a20e26e98c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -58,3 +58,9 @@ file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'ipi'
 groups = gic
+
+[gicv3-ipi]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'ipi'
+groups = gic
-- 
2.4.11

