From: Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH v6 10/11] arm/arm64: gicv3: add an IPI test
Date: Mon, 14 Nov 2016 22:08:38 +0100
Message-ID: <1479157719-31021-11-git-send-email-drjones@redhat.com>
References: <1479157719-31021-1-git-send-email-drjones@redhat.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1479157719-31021-1-git-send-email-drjones@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, qemu-arm@nongnu.org
Cc: pbonzini@redhat.com, andre.przywara@arm.com, peter.maydell@linaro.org, alex.bennee@linaro.org, marc.zyngier@arm.com, eric.auger@redhat.com, christoffer.dall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>

---
v6: move most gicv2/gicv3 wrappers to common code [Alex]
v5:
 - fix copy+paste error in gicv3_write_eoir [drew]
 - use modern register names [Andre]
v4:
 - heavily comment gicv3_ipi_send_tlist() [Eric]
 - changes needed for gicv2 iar/irqstat fix to other patch
v2:
 - use IRM for gicv3 broadcast
---
 arm/gic.c                  |  97 +++++++++++++++++++++++++-----
 arm/unittests.cfg          |   6 ++
 lib/arm/asm/arch_gicv3.h   |  23 +++++++
 lib/arm/asm/gic-v3.h       |  10 +++-
 lib/arm/asm/gic.h          |  60 +++++++++++++++++++
 lib/arm/gic.c              | 145 ++++++++++++++++++++++++++++++++++++++++++---
 lib/arm64/asm/arch_gicv3.h |  22 +++++++
 7 files changed, 338 insertions(+), 25 deletions(-)

diff --git a/arm/gic.c b/arm/gic.c
index b42c2b1ca1e1..d954a3775c26 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -3,6 +3,8 @@
  *
  * GICv2
  *   + test sending/receiving IPIs
+ * GICv3
+ *   + test sending/receiving IPIs
  *
  * Copyright (C) 2016, Red Hat Inc, Andrew Jones <drjones@redhat.com>
  *
@@ -16,7 +18,15 @@
 #include <asm/barrier.h>
 #include <asm/io.h>
 
-static int gic_version;
+struct gic {
+	struct {
+		void (*send_self)(void);
+		void (*send_tlist)(cpumask_t *mask, int irq);
+		void (*send_broadcast)(void);
+	} ipi;
+};
+
+static struct gic *gic;
 static int acked[NR_CPUS], spurious[NR_CPUS];
 static cpumask_t ready;
 
@@ -83,11 +93,11 @@ static void check_spurious(void)
 
 static void ipi_handler(struct pt_regs *regs __unused)
 {
-	u32 irqstat = readl(gicv2_cpu_base() + GICC_IAR);
-	u32 irqnr = irqstat & GICC_IAR_INT_ID_MASK;
+	u32 irqstat = gic_read_iar();
+	u32 irqnr = gic_iar_irqnr(irqstat);
 
 	if (irqnr != GICC_INT_SPURIOUS) {
-		writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
+		gic_write_eoir(irqstat);
 		smp_rmb(); /* pairs with wmb in ipi_test functions */
 		++acked[smp_processor_id()];
 		smp_wmb(); /* pairs with rmb in check_acked */
@@ -97,6 +107,38 @@ static void ipi_handler(struct pt_regs *regs __unused)
 	}
 }
 
+static void gicv2_ipi_send_self(void)
+{
+	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
+}
+
+static void gicv2_ipi_send_tlist(cpumask_t *mask, int irq __unused)
+{
+	u8 tlist = (u8)cpumask_bits(mask)[0];
+
+	writel(tlist << 16, gicv2_dist_base() + GICD_SGIR);
+}
+
+static void gicv2_ipi_send_broadcast(void)
+{
+	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
+}
+
+static void gicv3_ipi_send_self(void)
+{
+	cpumask_t mask;
+
+	cpumask_clear(&mask);
+	cpumask_set_cpu(smp_processor_id(), &mask);
+	gicv3_ipi_send_tlist(&mask, 0);
+}
+
+static void gicv3_ipi_send_broadcast(void)
+{
+	gicv3_write_sgi1r(1ULL << 40);
+	isb();
+}
+
 static void ipi_test_self(void)
 {
 	cpumask_t mask;
@@ -106,7 +148,7 @@ static void ipi_test_self(void)
 	smp_wmb();
 	cpumask_clear(&mask);
 	cpumask_set_cpu(0, &mask);
-	writel(2 << 24, gicv2_dist_base() + GICD_SGIR);
+	gic->ipi.send_self();
 	check_acked(&mask);
 	report_prefix_pop();
 }
@@ -114,14 +156,15 @@ static void ipi_test_self(void)
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
-	writel((u8)tlist << 16, gicv2_dist_base() + GICD_SGIR);
+	cpumask_copy(&mask, &cpu_present_mask);
+	for (i = 0; i < nr_cpus; i += 2)
+		cpumask_clear_cpu(i, &mask);
+	gic->ipi.send_tlist(&mask, 0);
 	check_acked(&mask);
 	report_prefix_pop();
 
@@ -130,14 +173,14 @@ static void ipi_test_smp(void)
 	smp_wmb();
 	cpumask_copy(&mask, &cpu_present_mask);
 	cpumask_clear_cpu(0, &mask);
-	writel(1 << 24, gicv2_dist_base() + GICD_SGIR);
+	gic->ipi.send_broadcast();
 	check_acked(&mask);
 	report_prefix_pop();
 }
 
 static void ipi_enable(void)
 {
-	gicv2_enable_defaults();
+	gic_enable_defaults();
 #ifdef __arm__
 	install_exception_handler(EXCPTN_IRQ, ipi_handler);
 #else
@@ -154,18 +197,42 @@ static void ipi_recv(void)
 		wfi();
 }
 
+static struct gic gicv2 = {
+	.ipi = {
+		.send_self = gicv2_ipi_send_self,
+		.send_tlist = gicv2_ipi_send_tlist,
+		.send_broadcast = gicv2_ipi_send_broadcast,
+	},
+};
+
+static struct gic gicv3 = {
+	.ipi = {
+		.send_self = gicv3_ipi_send_self,
+		.send_tlist = gicv3_ipi_send_tlist,
+		.send_broadcast = gicv3_ipi_send_broadcast,
+	},
+};
+
 int main(int argc, char **argv)
 {
 	char pfx[8];
 	int cpu;
 
-	gic_version = gic_init();
-	if (!gic_version)
-		report_abort("No gic present!");
+	if (!gic_init())
+		report_abort("No supported gic present!");
 
-	snprintf(pfx, sizeof(pfx), "gicv%d", gic_version);
+	snprintf(pfx, sizeof(pfx), "gicv%d", gic_version());
 	report_prefix_push(pfx);
 
+	switch (gic_version()) {
+	case 2:
+		gic = &gicv2;
+		break;
+	case 3:
+		gic = &gicv3;
+		break;
+	}
+
 	if (argc < 2) {
 
 		report_prefix_push("ipi");
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index e631c35e2bbb..c7392c747f98 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -66,3 +66,9 @@ file = gic.flat
 smp = $((($MAX_SMP < 8)?$MAX_SMP:8))
 extra_params = -machine gic-version=2 -append 'ipi'
 groups = gic
+
+[gicv3-ipi]
+file = gic.flat
+smp = $MAX_SMP
+extra_params = -machine gic-version=3 -append 'ipi'
+groups = gic
diff --git a/lib/arm/asm/arch_gicv3.h b/lib/arm/asm/arch_gicv3.h
index 276577452a14..b47cd2e0090b 100644
--- a/lib/arm/asm/arch_gicv3.h
+++ b/lib/arm/asm/arch_gicv3.h
@@ -16,10 +16,28 @@
 #define __stringify xstr
 
 #define __ACCESS_CP15(CRn, Op1, CRm, Op2)	p15, Op1, %0, CRn, CRm, Op2
+#define __ACCESS_CP15_64(Op1, CRm)		p15, Op1, %Q0, %R0, CRm
 
+#define ICC_EOIR1			__ACCESS_CP15(c12, 0, c12, 1)
+#define ICC_IAR1			__ACCESS_CP15(c12, 0, c12, 0)
+#define ICC_SGI1R			__ACCESS_CP15_64(0, c12)
 #define ICC_PMR				__ACCESS_CP15(c4, 0, c6, 0)
 #define ICC_IGRPEN1			__ACCESS_CP15(c12, 0, c12, 7)
 
+static inline void gicv3_write_eoir(u32 irq)
+{
+	asm volatile("mcr " __stringify(ICC_EOIR1) : : "r" (irq));
+	isb();
+}
+
+static inline u32 gicv3_read_iar(void)
+{
+	u32 irqstat;
+	asm volatile("mrc " __stringify(ICC_IAR1) : "=r" (irqstat));
+	dsb(sy);
+	return irqstat;
+}
+
 static inline void gicv3_write_pmr(u32 val)
 {
 	asm volatile("mcr " __stringify(ICC_PMR) : : "r" (val));
@@ -31,6 +49,11 @@ static inline void gicv3_write_grpen1(u32 val)
 	isb();
 }
 
+static inline void gicv3_write_sgi1r(u64 val)
+{
+	asm volatile("mcrr " __stringify(ICC_SGI1R) : : "r" (val));
+}
+
 /*
  * We may access GICR_TYPER and GITS_TYPER by reading both the TYPER
  * offset and the following offset (+ 4) and then combining them to
diff --git a/lib/arm/asm/gic-v3.h b/lib/arm/asm/gic-v3.h
index 73ade4681d21..43f9ffce56de 100644
--- a/lib/arm/asm/gic-v3.h
+++ b/lib/arm/asm/gic-v3.h
@@ -33,12 +33,19 @@
 #define GICR_ISENABLER0			GICD_ISENABLER
 #define GICR_IPRIORITYR0		GICD_IPRIORITYR
 
+#define ICC_SGI1R_AFFINITY_1_SHIFT	16
+#define ICC_SGI1R_AFFINITY_2_SHIFT	32
+#define ICC_SGI1R_AFFINITY_3_SHIFT	48
+#define MPIDR_TO_SGI_AFFINITY(cluster_id, level) \
+	(MPIDR_AFFINITY_LEVEL(cluster_id, level) << ICC_SGI1R_AFFINITY_## level ## _SHIFT)
+
 #include <asm/arch_gicv3.h>
 
 #ifndef __ASSEMBLY__
 #include <asm/setup.h>
-#include <asm/smp.h>
 #include <asm/processor.h>
+#include <asm/cpumask.h>
+#include <asm/smp.h>
 #include <asm/io.h>
 
 struct gicv3_data {
@@ -55,6 +62,7 @@ extern struct gicv3_data gicv3_data;
 extern int gicv3_init(void);
 extern void gicv3_enable_defaults(void);
 extern void gicv3_set_redist_base(size_t stride);
+extern void gicv3_ipi_send_tlist(cpumask_t *mask, int irq);
 
 static inline void gicv3_do_wait_for_rwp(void *base)
 {
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index 21511997f2a9..c2267b6b3937 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -42,5 +42,65 @@
  */
 extern int gic_init(void);
 
+/*
+ * gic_common_ops collects some functions that we provide unit
+ * tests that don't care which gic version they're using.
+ */
+struct gic_common_ops {
+	int gic_version;
+	u32 (*read_iar)(void);
+	u32 (*iar_irqnr)(u32 iar);
+	void (*write_eoir)(u32 irqstat);
+	void (*ipi_send)(int cpu, int irq);
+};
+
+extern struct gic_common_ops *gic_common_ops;
+
+static inline int gic_version(void)
+{
+	assert(gic_common_ops);
+	return gic_common_ops->gic_version;
+}
+
+static inline u32 gic_read_iar(void)
+{
+	assert(gic_common_ops && gic_common_ops->read_iar);
+	return gic_common_ops->read_iar();
+}
+
+static inline u32 gic_iar_irqnr(u32 iar)
+{
+	assert(gic_common_ops && gic_common_ops->iar_irqnr);
+	return gic_common_ops->iar_irqnr(iar);
+}
+
+static inline void gic_write_eoir(u32 irqstat)
+{
+	assert(gic_common_ops && gic_common_ops->write_eoir);
+	gic_common_ops->write_eoir(irqstat);
+}
+
+static inline void gic_ipi_send(int cpu, int irq)
+{
+	assert(gic_common_ops && gic_common_ops->ipi_send);
+	gic_common_ops->ipi_send(cpu, irq);
+}
+
+static inline void gic_enable_defaults(void)
+{
+	switch (gic_version()) {
+	case 2:
+		gicv2_enable_defaults();
+		break;
+	case 3:
+		gicv3_enable_defaults();
+		break;
+	default:
+		printf("%s: Unknown gic version %d\n", __func__,
+			gic_version());
+		abort();
+	}
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index d703ad96a37e..4f67363e073b 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -56,15 +56,6 @@ int gicv3_init(void)
 			&gicv3_data.redist_base[0]);
 }
 
-int gic_init(void)
-{
-	if (gicv2_init())
-		return 2;
-	else if (gicv3_init())
-		return 3;
-	return 0;
-}
-
 void gicv2_enable_defaults(void)
 {
 	void *dist = gicv2_dist_base();
@@ -85,6 +76,28 @@ void gicv2_enable_defaults(void)
 	writel(GICC_ENABLE, cpu_base + GICC_CTLR);
 }
 
+static u32 gicv2_read_iar(void)
+{
+	return readl(gicv2_cpu_base() + GICC_IAR);
+}
+
+static u32 gicv2_iar_irqnr(u32 iar)
+{
+	return iar & GICC_IAR_INT_ID_MASK;
+}
+
+static void gicv2_write_eoir(u32 irqstat)
+{
+	writel(irqstat, gicv2_cpu_base() + GICC_EOIR);
+}
+
+static void gicv2_ipi_send(int cpu, int irq)
+{
+	assert(cpu < 8);
+	assert(irq < 16);
+	writel(1 << (cpu + 16) | irq, gicv2_dist_base() + GICD_SGIR);
+}
+
 void gicv3_set_redist_base(size_t stride)
 {
 	u32 aff = mpidr_compress(get_mpidr());
@@ -138,3 +151,117 @@ void gicv3_enable_defaults(void)
 	gicv3_write_pmr(GICC_INT_PRI_THRESHOLD);
 	gicv3_write_grpen1(1);
 }
+
+static u32 gicv3_iar_irqnr(u32 iar)
+{
+	return iar;
+}
+
+void gicv3_ipi_send_tlist(cpumask_t *mask, int irq)
+{
+	u16 tlist;
+	int cpu;
+
+	assert(irq < 16);
+
+	/*
+	 * For each cpu in the mask collect its peers, which are also in
+	 * the mask, in order to form target lists.
+	 */
+	for_each_cpu(cpu, mask) {
+		u64 mpidr = cpus[cpu], sgi1r;
+		u64 cluster_id;
+
+		/*
+		 * GICv3 can send IPIs to up 16 peer cpus with a single
+		 * write to ICC_SGI1R_EL1 (using the target list). Peers
+		 * are cpus that have nearly identical MPIDRs, the only
+		 * difference being Aff0. The matching upper affinity
+		 * levels form the cluster ID.
+		 */
+		cluster_id = mpidr & ~0xffUL;
+		tlist = 0;
+
+		/*
+		 * Sort of open code for_each_cpu in order to have a
+		 * nested for_each_cpu loop.
+		 */
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
+				/*
+				 * The next cpu isn't in our cluster. Roll
+				 * back the cpu index allowing the outer
+				 * for_each_cpu to find it again with
+				 * cpumask_next
+				 */
+				--cpu;
+				break;
+			}
+		}
+
+		/* Send the IPIs for the target list of this cluster */
+		sgi1r = (MPIDR_TO_SGI_AFFINITY(cluster_id, 3)	|
+			 MPIDR_TO_SGI_AFFINITY(cluster_id, 2)	|
+			 irq << 24				|
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
+static void gicv3_ipi_send(int cpu, int irq)
+{
+	cpumask_t mask;
+
+	cpumask_clear(&mask);
+	cpumask_set_cpu(cpu, &mask);
+	gicv3_ipi_send_tlist(&mask, irq);
+}
+
+static struct gic_common_ops gicv2_common_ops = {
+	.gic_version = 2,
+	.read_iar = gicv2_read_iar,
+	.iar_irqnr = gicv2_iar_irqnr,
+	.write_eoir = gicv2_write_eoir,
+	.ipi_send = gicv2_ipi_send,
+};
+
+static struct gic_common_ops gicv3_common_ops = {
+	.gic_version = 3,
+	.read_iar = gicv3_read_iar,
+	.iar_irqnr = gicv3_iar_irqnr,
+	.write_eoir = gicv3_write_eoir,
+	.ipi_send = gicv3_ipi_send,
+};
+
+struct gic_common_ops *gic_common_ops;
+
+int gic_init(void)
+{
+	if (gicv2_init()) {
+		gic_common_ops = &gicv2_common_ops;
+		return 2;
+	} else if (gicv3_init()) {
+		gic_common_ops = &gicv3_common_ops;
+		return 3;
+	}
+	return 0;
+}
diff --git a/lib/arm64/asm/arch_gicv3.h b/lib/arm64/asm/arch_gicv3.h
index 6d353567f56a..874775828016 100644
--- a/lib/arm64/asm/arch_gicv3.h
+++ b/lib/arm64/asm/arch_gicv3.h
@@ -10,6 +10,9 @@
 
 #include <asm/sysreg.h>
 
+#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
+#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
 #define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 #define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
 
@@ -27,6 +30,20 @@
  * sets the GP register's most significant bits to 0 with an explicit cast.
  */
 
+static inline void gicv3_write_eoir(u32 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
+	isb();
+}
+
+static inline u32 gicv3_read_iar(void)
+{
+	u64 irqstat;
+	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
+	dsb(sy);
+	return (u64)irqstat;
+}
+
 static inline void gicv3_write_pmr(u32 val)
 {
 	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
@@ -38,6 +55,11 @@ static inline void gicv3_write_grpen1(u32 val)
 	isb();
 }
 
+static inline void gicv3_write_sgi1r(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
+}
+
 #define gicv3_read_typer(c)		readq(c)
 
 #endif /* __ASSEMBLY__ */
-- 
2.7.4

