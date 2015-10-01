From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v3 2/6] arm64: GICv3: change unsigned types for AArch32
 compatibility
Date: Thu,  1 Oct 2015 13:47:15 +0100
Message-ID: <1443703639-3730-3-git-send-email-jean-philippe.brucker@arm.com>
References: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B740D41451
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c0Bl0wPEyNrW for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2015 08:46:46 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F08CF41390
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:44 -0400 (EDT)
In-Reply-To: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jason Cooper <jason@lakedaemon.net>, Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

This patch does a few simple compatibility-related changes:
- change the system register access prototypes to their actual size,
- homogenise mpidr accesses with unsigned long,
- force the 64bit register values to unsigned long long.

Note: the list registers are 64bit on GICv3, but the AArch32 vGIC driver
will need to split their values into two 32bit registers: LRn and LRCn.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |   35 ++++++++++++++++++++---------------
 drivers/irqchip/irq-gic-v3.c        |   25 ++++++++++++-------------
 include/linux/irqchip/arm-gic-v3.h  |   18 +++++++++---------
 3 files changed, 41 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index e6b68a8..bd8f005 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -78,21 +78,26 @@
 
 #include <linux/stringify.h>
 
-/* Low level accessors */
+/*
+ * Low-level accessors
+ *
+ * These system registers are 32 bits, but we make sure that the compiler
+ * sets the GP register's most significant bits to 0 with an explicit cast.
+ */
 
-static inline void gic_write_eoir(u64 irq)
+static inline void gic_write_eoir(u32 irq)
 {
-	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" (irq));
+	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" ((u64)irq));
 	isb();
 }
 
-static inline void gic_write_dir(u64 irq)
+static inline void gic_write_dir(u32 irq)
 {
-	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
+	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" ((u64)irq));
 	isb();
 }
 
-static inline u64 gic_read_iar(void)
+static inline u32 gic_read_iar(void)
 {
 	u64 irqstat;
 
@@ -100,20 +105,20 @@ static inline u64 gic_read_iar(void)
 	return irqstat;
 }
 
-static inline void gic_write_pmr(u64 val)
+static inline void gic_write_pmr(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" (val));
+	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" ((u64)val));
 }
 
-static inline void gic_write_ctlr(u64 val)
+static inline void gic_write_ctlr(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" (val));
+	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" ((u64)val));
 	isb();
 }
 
-static inline void gic_write_grpen1(u64 val)
+static inline void gic_write_grpen1(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" (val));
+	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" ((u64)val));
 	isb();
 }
 
@@ -122,7 +127,7 @@ static inline void gic_write_sgi1r(u64 val)
 	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
 }
 
-static inline u64 gic_read_sre(void)
+static inline u32 gic_read_sre(void)
 {
 	u64 val;
 
@@ -130,9 +135,9 @@ static inline u64 gic_read_sre(void)
 	return val;
 }
 
-static inline void gic_write_sre(u64 val)
+static inline void gic_write_sre(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_SRE_EL1) ", %0" : : "r" (val));
+	asm volatile("msr_s " __stringify(ICC_SRE_EL1) ", %0" : : "r" ((u64)val));
 	isb();
 }
 
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index a08eda8..0fb8d6d 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -327,11 +327,11 @@ static int gic_irq_set_vcpu_affinity(struct irq_data *d, void *vcpu)
 	return 0;
 }
 
-static u64 gic_mpidr_to_affinity(u64 mpidr)
+static u64 gic_mpidr_to_affinity(unsigned long mpidr)
 {
 	u64 aff;
 
-	aff = (MPIDR_AFFINITY_LEVEL(mpidr, 3) << 32 |
+	aff = ((u64)MPIDR_AFFINITY_LEVEL(mpidr, 3) << 32 |
 	       MPIDR_AFFINITY_LEVEL(mpidr, 2) << 16 |
 	       MPIDR_AFFINITY_LEVEL(mpidr, 1) << 8  |
 	       MPIDR_AFFINITY_LEVEL(mpidr, 0));
@@ -341,7 +341,7 @@ static u64 gic_mpidr_to_affinity(u64 mpidr)
 
 static asmlinkage void __exception_irq_entry gic_handle_irq(struct pt_regs *regs)
 {
-	u64 irqnr;
+	u32 irqnr;
 
 	do {
 		irqnr = gic_read_iar();
@@ -405,7 +405,7 @@ static void __init gic_dist_init(void)
 
 static int gic_populate_rdist(void)
 {
-	u64 mpidr = cpu_logical_map(smp_processor_id());
+	unsigned long mpidr = cpu_logical_map(smp_processor_id());
 	u64 typer;
 	u32 aff;
 	int i;
@@ -436,10 +436,9 @@ static int gic_populate_rdist(void)
 				u64 offset = ptr - gic_data.redist_regions[i].redist_base;
 				gic_data_rdist_rd_base() = ptr;
 				gic_data_rdist()->phys_base = gic_data.redist_regions[i].phys_base + offset;
-				pr_info("CPU%d: found redistributor %llx region %d:%pa\n",
-					smp_processor_id(),
-					(unsigned long long)mpidr,
-					i, &gic_data_rdist()->phys_base);
+				pr_info("CPU%d: found redistributor %lx region %d:%pa\n",
+					smp_processor_id(), mpidr, i,
+					&gic_data_rdist()->phys_base);
 				return 0;
 			}
 
@@ -454,8 +453,8 @@ static int gic_populate_rdist(void)
 	}
 
 	/* We couldn't even deal with ourselves... */
-	WARN(true, "CPU%d: mpidr %llx has no re-distributor!\n",
-	     smp_processor_id(), (unsigned long long)mpidr);
+	WARN(true, "CPU%d: mpidr %lx has no re-distributor!\n",
+	     smp_processor_id(), mpidr);
 	return -ENODEV;
 }
 
@@ -525,10 +524,10 @@ static struct notifier_block gic_cpu_notifier = {
 };
 
 static u16 gic_compute_target_list(int *base_cpu, const struct cpumask *mask,
-				   u64 cluster_id)
+				   unsigned long cluster_id)
 {
 	int cpu = *base_cpu;
-	u64 mpidr = cpu_logical_map(cpu);
+	unsigned long mpidr = cpu_logical_map(cpu);
 	u16 tlist = 0;
 
 	while (cpu < nr_cpu_ids) {
@@ -589,7 +588,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
 	smp_wmb();
 
 	for_each_cpu(cpu, mask) {
-		u64 cluster_id = cpu_logical_map(cpu) & ~0xffUL;
+		unsigned long cluster_id = cpu_logical_map(cpu) & ~0xffUL;
 		u16 tlist;
 
 		tlist = gic_compute_target_list(&cpu, mask, cluster_id);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 5ab6e37..47663c6 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -264,16 +264,16 @@
 /*
  * Hypervisor interface registers (SRE only)
  */
-#define ICH_LR_VIRTUAL_ID_MASK		((1UL << 32) - 1)
-
-#define ICH_LR_EOI			(1UL << 41)
-#define ICH_LR_GROUP			(1UL << 60)
-#define ICH_LR_HW			(1UL << 61)
-#define ICH_LR_STATE			(3UL << 62)
-#define ICH_LR_PENDING_BIT		(1UL << 62)
-#define ICH_LR_ACTIVE_BIT		(1UL << 63)
+#define ICH_LR_VIRTUAL_ID_MASK		((1ULL << 32) - 1)
+
+#define ICH_LR_EOI			(1ULL << 41)
+#define ICH_LR_GROUP			(1ULL << 60)
+#define ICH_LR_HW			(1ULL << 61)
+#define ICH_LR_STATE			(3ULL << 62)
+#define ICH_LR_PENDING_BIT		(1ULL << 62)
+#define ICH_LR_ACTIVE_BIT		(1ULL << 63)
 #define ICH_LR_PHYS_ID_SHIFT		32
-#define ICH_LR_PHYS_ID_MASK		(0x3ffUL << ICH_LR_PHYS_ID_SHIFT)
+#define ICH_LR_PHYS_ID_MASK		(0x3ffULL << ICH_LR_PHYS_ID_SHIFT)
 
 #define ICH_MISR_EOI			(1 << 0)
 #define ICH_MISR_U			(1 << 1)
-- 
1.7.9.5
