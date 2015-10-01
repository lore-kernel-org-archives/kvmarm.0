From: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Subject: [PATCH v3 1/6] arm64: GICv3: refactor the AArch64 specific parts
Date: Thu,  1 Oct 2015 13:47:14 +0100
Message-ID: <1443703639-3730-2-git-send-email-jean-philippe.brucker@arm.com>
References: <1443703639-3730-1-git-send-email-jean-philippe.brucker@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 110E5412D6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZU2G5z8Lz1Dg for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Oct 2015 08:46:43 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E80C413E2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Oct 2015 08:46:43 -0400 (EDT)
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

This patch moves the GICv3 system register access helpers to
arch/arm64/. Their 32bit counterparts will need to use mrc/mcr accesses
instead of mrs_s/msr_s.

Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h |  140 +++++++++++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v3.c        |   38 +---------
 include/linux/irqchip/arm-gic-v3.h  |   69 +----------------
 3 files changed, 144 insertions(+), 103 deletions(-)
 create mode 100644 arch/arm64/include/asm/arch_gicv3.h

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
new file mode 100644
index 0000000..e6b68a8
--- /dev/null
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -0,0 +1,140 @@
+/*
+ * arch/arm64/include/asm/arch_gicv3.h
+ *
+ * Copyright (C) 2015 ARM Ltd.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#ifndef __ASM_ARCH_GICV3_H
+#define __ASM_ARCH_GICV3_H
+
+#include <asm/sysreg.h>
+
+#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
+#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
+#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
+#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
+#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+#define ICC_CTLR_EL1			sys_reg(3, 0, 12, 12, 4)
+#define ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
+#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
+
+#define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
+
+/*
+ * System register definitions
+ */
+#define ICH_VSEIR_EL2			sys_reg(3, 4, 12, 9, 4)
+#define ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
+#define ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
+#define ICH_MISR_EL2			sys_reg(3, 4, 12, 11, 2)
+#define ICH_EISR_EL2			sys_reg(3, 4, 12, 11, 3)
+#define ICH_ELSR_EL2			sys_reg(3, 4, 12, 11, 5)
+#define ICH_VMCR_EL2			sys_reg(3, 4, 12, 11, 7)
+
+#define __LR0_EL2(x)			sys_reg(3, 4, 12, 12, x)
+#define __LR8_EL2(x)			sys_reg(3, 4, 12, 13, x)
+
+#define ICH_LR0_EL2			__LR0_EL2(0)
+#define ICH_LR1_EL2			__LR0_EL2(1)
+#define ICH_LR2_EL2			__LR0_EL2(2)
+#define ICH_LR3_EL2			__LR0_EL2(3)
+#define ICH_LR4_EL2			__LR0_EL2(4)
+#define ICH_LR5_EL2			__LR0_EL2(5)
+#define ICH_LR6_EL2			__LR0_EL2(6)
+#define ICH_LR7_EL2			__LR0_EL2(7)
+#define ICH_LR8_EL2			__LR8_EL2(0)
+#define ICH_LR9_EL2			__LR8_EL2(1)
+#define ICH_LR10_EL2			__LR8_EL2(2)
+#define ICH_LR11_EL2			__LR8_EL2(3)
+#define ICH_LR12_EL2			__LR8_EL2(4)
+#define ICH_LR13_EL2			__LR8_EL2(5)
+#define ICH_LR14_EL2			__LR8_EL2(6)
+#define ICH_LR15_EL2			__LR8_EL2(7)
+
+#define __AP0Rx_EL2(x)			sys_reg(3, 4, 12, 8, x)
+#define ICH_AP0R0_EL2			__AP0Rx_EL2(0)
+#define ICH_AP0R1_EL2			__AP0Rx_EL2(1)
+#define ICH_AP0R2_EL2			__AP0Rx_EL2(2)
+#define ICH_AP0R3_EL2			__AP0Rx_EL2(3)
+
+#define __AP1Rx_EL2(x)			sys_reg(3, 4, 12, 9, x)
+#define ICH_AP1R0_EL2			__AP1Rx_EL2(0)
+#define ICH_AP1R1_EL2			__AP1Rx_EL2(1)
+#define ICH_AP1R2_EL2			__AP1Rx_EL2(2)
+#define ICH_AP1R3_EL2			__AP1Rx_EL2(3)
+
+#ifndef __ASSEMBLY__
+
+#include <linux/stringify.h>
+
+/* Low level accessors */
+
+static inline void gic_write_eoir(u64 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" (irq));
+	isb();
+}
+
+static inline void gic_write_dir(u64 irq)
+{
+	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
+	isb();
+}
+
+static inline u64 gic_read_iar(void)
+{
+	u64 irqstat;
+
+	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
+	return irqstat;
+}
+
+static inline void gic_write_pmr(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" (val));
+}
+
+static inline void gic_write_ctlr(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" (val));
+	isb();
+}
+
+static inline void gic_write_grpen1(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" (val));
+	isb();
+}
+
+static inline void gic_write_sgi1r(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
+}
+
+static inline u64 gic_read_sre(void)
+{
+	u64 val;
+
+	asm volatile("mrs_s %0, " __stringify(ICC_SRE_EL1) : "=r" (val));
+	return val;
+}
+
+static inline void gic_write_sre(u64 val)
+{
+	asm volatile("msr_s " __stringify(ICC_SRE_EL1) ", %0" : : "r" (val));
+	isb();
+}
+
+#endif /* __ASSEMBLY__ */
+#endif /* __ASM_ARCH_GICV3_H */
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 36ecfc8..a08eda8 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -108,45 +108,13 @@ static void gic_redist_wait_for_rwp(void)
 	gic_do_wait_for_rwp(gic_data_rdist_rd_base());
 }
 
-/* Low level accessors */
-static u64 __maybe_unused gic_read_iar(void)
-{
-	u64 irqstat;
-
-	asm volatile("mrs_s %0, " __stringify(ICC_IAR1_EL1) : "=r" (irqstat));
-	return irqstat;
-}
-
-static void __maybe_unused gic_write_pmr(u64 val)
-{
-	asm volatile("msr_s " __stringify(ICC_PMR_EL1) ", %0" : : "r" (val));
-}
-
-static void __maybe_unused gic_write_ctlr(u64 val)
-{
-	asm volatile("msr_s " __stringify(ICC_CTLR_EL1) ", %0" : : "r" (val));
-	isb();
-}
-
-static void __maybe_unused gic_write_grpen1(u64 val)
-{
-	asm volatile("msr_s " __stringify(ICC_GRPEN1_EL1) ", %0" : : "r" (val));
-	isb();
-}
-
-static void __maybe_unused gic_write_sgi1r(u64 val)
-{
-	asm volatile("msr_s " __stringify(ICC_SGI1R_EL1) ", %0" : : "r" (val));
-}
-
 static void gic_enable_sre(void)
 {
 	u64 val;
 
-	asm volatile("mrs_s %0, " __stringify(ICC_SRE_EL1) : "=r" (val));
+	val = gic_read_sre();
 	val |= ICC_SRE_EL1_SRE;
-	asm volatile("msr_s " __stringify(ICC_SRE_EL1) ", %0" : : "r" (val));
-	isb();
+	gic_write_sre(val);
 
 	/*
 	 * Need to check that the SRE bit has actually been set. If
@@ -155,7 +123,7 @@ static void gic_enable_sre(void)
 	 *
 	 * Kindly inform the luser.
 	 */
-	asm volatile("mrs_s %0, " __stringify(ICC_SRE_EL1) : "=r" (val));
+	val = gic_read_sre();
 	if (!(val & ICC_SRE_EL1_SRE))
 		pr_err("GIC: unable to set SRE (disabled at EL2), panic ahead\n");
 }
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 9eeeb95..5ab6e37 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -18,8 +18,6 @@
 #ifndef __LINUX_IRQCHIP_ARM_GIC_V3_H
 #define __LINUX_IRQCHIP_ARM_GIC_V3_H
 
-#include <asm/sysreg.h>
-
 /*
  * Distributor registers. We assume we're running non-secure, with ARE
  * being set. Secure-only and non-ARE registers are not described.
@@ -292,19 +290,8 @@
 #define ICH_VMCR_PMR_SHIFT		24
 #define ICH_VMCR_PMR_MASK		(0xffUL << ICH_VMCR_PMR_SHIFT)
 
-#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
-#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
-#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
-#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
-#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
-#define ICC_CTLR_EL1			sys_reg(3, 0, 12, 12, 4)
-#define ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
-#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
-
 #define ICC_IAR1_EL1_SPURIOUS		0x3ff
 
-#define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-
 #define ICC_SRE_EL2_SRE			(1 << 0)
 #define ICC_SRE_EL2_ENABLE		(1 << 3)
 
@@ -320,52 +307,10 @@
 #define ICC_SGI1R_AFFINITY_3_SHIFT	48
 #define ICC_SGI1R_AFFINITY_3_MASK	(0xffULL << ICC_SGI1R_AFFINITY_1_SHIFT)
 
-/*
- * System register definitions
- */
-#define ICH_VSEIR_EL2			sys_reg(3, 4, 12, 9, 4)
-#define ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
-#define ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
-#define ICH_MISR_EL2			sys_reg(3, 4, 12, 11, 2)
-#define ICH_EISR_EL2			sys_reg(3, 4, 12, 11, 3)
-#define ICH_ELSR_EL2			sys_reg(3, 4, 12, 11, 5)
-#define ICH_VMCR_EL2			sys_reg(3, 4, 12, 11, 7)
-
-#define __LR0_EL2(x)			sys_reg(3, 4, 12, 12, x)
-#define __LR8_EL2(x)			sys_reg(3, 4, 12, 13, x)
-
-#define ICH_LR0_EL2			__LR0_EL2(0)
-#define ICH_LR1_EL2			__LR0_EL2(1)
-#define ICH_LR2_EL2			__LR0_EL2(2)
-#define ICH_LR3_EL2			__LR0_EL2(3)
-#define ICH_LR4_EL2			__LR0_EL2(4)
-#define ICH_LR5_EL2			__LR0_EL2(5)
-#define ICH_LR6_EL2			__LR0_EL2(6)
-#define ICH_LR7_EL2			__LR0_EL2(7)
-#define ICH_LR8_EL2			__LR8_EL2(0)
-#define ICH_LR9_EL2			__LR8_EL2(1)
-#define ICH_LR10_EL2			__LR8_EL2(2)
-#define ICH_LR11_EL2			__LR8_EL2(3)
-#define ICH_LR12_EL2			__LR8_EL2(4)
-#define ICH_LR13_EL2			__LR8_EL2(5)
-#define ICH_LR14_EL2			__LR8_EL2(6)
-#define ICH_LR15_EL2			__LR8_EL2(7)
-
-#define __AP0Rx_EL2(x)			sys_reg(3, 4, 12, 8, x)
-#define ICH_AP0R0_EL2			__AP0Rx_EL2(0)
-#define ICH_AP0R1_EL2			__AP0Rx_EL2(1)
-#define ICH_AP0R2_EL2			__AP0Rx_EL2(2)
-#define ICH_AP0R3_EL2			__AP0Rx_EL2(3)
-
-#define __AP1Rx_EL2(x)			sys_reg(3, 4, 12, 9, x)
-#define ICH_AP1R0_EL2			__AP1Rx_EL2(0)
-#define ICH_AP1R1_EL2			__AP1Rx_EL2(1)
-#define ICH_AP1R2_EL2			__AP1Rx_EL2(2)
-#define ICH_AP1R3_EL2			__AP1Rx_EL2(3)
+#include <asm/arch_gicv3.h>
 
 #ifndef __ASSEMBLY__
 
-#include <linux/stringify.h>
 #include <asm/msi.h>
 
 /*
@@ -385,18 +330,6 @@ struct rdists {
 	u64			flags;
 };
 
-static inline void gic_write_eoir(u64 irq)
-{
-	asm volatile("msr_s " __stringify(ICC_EOIR1_EL1) ", %0" : : "r" (irq));
-	isb();
-}
-
-static inline void gic_write_dir(u64 irq)
-{
-	asm volatile("msr_s " __stringify(ICC_DIR_EL1) ", %0" : : "r" (irq));
-	isb();
-}
-
 struct irq_domain;
 int its_cpu_init(void);
 int its_init(struct device_node *node, struct rdists *rdists,
-- 
1.7.9.5
