From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 04/13] arm64: sysreg: subsume GICv3 sysreg definitions
Date: Tue, 31 Jan 2017 18:05:42 +0000
Message-ID: <1485885951-2747-5-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 853D3408E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:54 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MM+o6J8YroRl for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:53 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A29BF40A7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:52 -0500 (EST)
In-Reply-To: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Unlike most sysreg defintiions, the GICv3 definitions don't have a SYS_
prefix, and they don't live in <asm/sysreg.h>. Additionally, some
definitions are duplicated elsewhere (e.g. in the KVM save/restore
code).

For consistency, and to make it possible to share a common definition
for these sysregs, this patch moves the definitions to <asm/sysreg.h>,
adding a SYS_ prefix, and sorting the registers per their encoding.
Existing users of the definitions are fixed up so that this change is
not problematic.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/arch_gicv3.h | 81 ++++++-------------------------------
 arch/arm64/include/asm/sysreg.h     | 52 ++++++++++++++++++++++++
 arch/arm64/kernel/head.S            |  8 ++--
 3 files changed, 69 insertions(+), 72 deletions(-)

diff --git a/arch/arm64/include/asm/arch_gicv3.h b/arch/arm64/include/asm/arch_gicv3.h
index f37e3a2..1a98bc8 100644
--- a/arch/arm64/include/asm/arch_gicv3.h
+++ b/arch/arm64/include/asm/arch_gicv3.h
@@ -20,69 +20,14 @@
 
 #include <asm/sysreg.h>
 
-#define ICC_EOIR1_EL1			sys_reg(3, 0, 12, 12, 1)
-#define ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
-#define ICC_IAR1_EL1			sys_reg(3, 0, 12, 12, 0)
-#define ICC_SGI1R_EL1			sys_reg(3, 0, 12, 11, 5)
-#define ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
-#define ICC_CTLR_EL1			sys_reg(3, 0, 12, 12, 4)
-#define ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
-#define ICC_GRPEN1_EL1			sys_reg(3, 0, 12, 12, 7)
-#define ICC_BPR1_EL1			sys_reg(3, 0, 12, 12, 3)
-
-#define ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
-
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
-
 #ifndef __ASSEMBLY__
 
 #include <linux/stringify.h>
 #include <asm/barrier.h>
 #include <asm/cacheflush.h>
 
-#define read_gicreg			read_sysreg_s
-#define write_gicreg			write_sysreg_s
+#define read_gicreg(r)			read_sysreg_s(SYS_ ## r)
+#define write_gicreg(v, r)		write_sysreg_s(v, SYS_ ## r)
 
 /*
  * Low-level accessors
@@ -93,13 +38,13 @@
 
 static inline void gic_write_eoir(u32 irq)
 {
-	write_sysreg_s(irq, ICC_EOIR1_EL1);
+	write_sysreg_s(irq, SYS_ICC_EOIR1_EL1);
 	isb();
 }
 
 static inline void gic_write_dir(u32 irq)
 {
-	write_sysreg_s(irq, ICC_DIR_EL1);
+	write_sysreg_s(irq, SYS_ICC_DIR_EL1);
 	isb();
 }
 
@@ -107,7 +52,7 @@ static inline u64 gic_read_iar_common(void)
 {
 	u64 irqstat;
 
-	irqstat = read_sysreg_s(ICC_IAR1_EL1);
+	irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
 	dsb(sy);
 	return irqstat;
 }
@@ -124,7 +69,7 @@ static inline u64 gic_read_iar_cavium_thunderx(void)
 	u64 irqstat;
 
 	nops(8);
-	irqstat = read_sysreg_s(ICC_IAR1_EL1);
+	irqstat = read_sysreg_s(SYS_ICC_IAR1_EL1);
 	nops(4);
 	mb();
 
@@ -133,40 +78,40 @@ static inline u64 gic_read_iar_cavium_thunderx(void)
 
 static inline void gic_write_pmr(u32 val)
 {
-	write_sysreg_s(val, ICC_PMR_EL1);
+	write_sysreg_s(val, SYS_ICC_PMR_EL1);
 }
 
 static inline void gic_write_ctlr(u32 val)
 {
-	write_sysreg_s(val, ICC_CTLR_EL1);
+	write_sysreg_s(val, SYS_ICC_CTLR_EL1);
 	isb();
 }
 
 static inline void gic_write_grpen1(u32 val)
 {
-	write_sysreg_s(val, ICC_GRPEN1_EL1);
+	write_sysreg_s(val, SYS_ICC_GRPEN1_EL1);
 	isb();
 }
 
 static inline void gic_write_sgi1r(u64 val)
 {
-	write_sysreg_s(val, ICC_SGI1R_EL1);
+	write_sysreg_s(val, SYS_ICC_SGI1R_EL1);
 }
 
 static inline u32 gic_read_sre(void)
 {
-	return read_sysreg_s(ICC_SRE_EL1);
+	return read_sysreg_s(SYS_ICC_SRE_EL1);
 }
 
 static inline void gic_write_sre(u32 val)
 {
-	write_sysreg_s(val, ICC_SRE_EL1);
+	write_sysreg_s(val, SYS_ICC_SRE_EL1);
 	isb();
 }
 
 static inline void gic_write_bpr1(u32 val)
 {
-	asm volatile("msr_s " __stringify(ICC_BPR1_EL1) ", %0" : : "r" (val));
+	write_sysreg_s(val, SYS_ICC_BPR1_EL1);
 }
 
 #define gic_read_typer(c)		readq_relaxed(c)
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 3498d02..9dc30bc 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -149,9 +149,20 @@
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
 #define SYS_ID_AA64MMFR2_EL1		sys_reg(3, 0, 0, 7, 2)
 
+#define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
+
 #define SYS_PMINTENSET_EL1		sys_reg(3, 0, 9, 14, 1)
 #define SYS_PMINTENCLR_EL1		sys_reg(3, 0, 9, 14, 2)
 
+#define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
+#define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
+#define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
+#define SYS_ICC_EOIR1_EL1		sys_reg(3, 0, 12, 12, 1)
+#define SYS_ICC_BPR1_EL1		sys_reg(3, 0, 12, 12, 3)
+#define SYS_ICC_CTLR_EL1		sys_reg(3, 0, 12, 12, 4)
+#define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
+#define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
+
 #define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
 #define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
 
@@ -179,6 +190,47 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
 
+#define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
+#define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
+#define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
+#define SYS_ICH_AP0R2_EL2		__SYS__AP0Rx_EL2(2)
+#define SYS_ICH_AP0R3_EL2		__SYS__AP0Rx_EL2(3)
+
+#define __SYS__AP1Rx_EL2(x)		sys_reg(3, 4, 12, 9, x)
+#define SYS_ICH_AP1R0_EL2		__SYS__AP1Rx_EL2(0)
+#define SYS_ICH_AP1R1_EL2		__SYS__AP1Rx_EL2(1)
+#define SYS_ICH_AP1R2_EL2		__SYS__AP1Rx_EL2(2)
+#define SYS_ICH_AP1R3_EL2		__SYS__AP1Rx_EL2(3)
+
+#define SYS_ICH_VSEIR_EL2		sys_reg(3, 4, 12, 9, 4)
+#define SYS_ICC_SRE_EL2			sys_reg(3, 4, 12, 9, 5)
+#define SYS_ICH_HCR_EL2			sys_reg(3, 4, 12, 11, 0)
+#define SYS_ICH_VTR_EL2			sys_reg(3, 4, 12, 11, 1)
+#define SYS_ICH_MISR_EL2		sys_reg(3, 4, 12, 11, 2)
+#define SYS_ICH_EISR_EL2		sys_reg(3, 4, 12, 11, 3)
+#define SYS_ICH_ELSR_EL2		sys_reg(3, 4, 12, 11, 5)
+#define SYS_ICH_VMCR_EL2		sys_reg(3, 4, 12, 11, 7)
+
+#define __SYS__LR0_EL2(x)		sys_reg(3, 4, 12, 12, x)
+#define SYS_ICH_LR0_EL2			__SYS__LR0_EL2(0)
+#define SYS_ICH_LR1_EL2			__SYS__LR0_EL2(1)
+#define SYS_ICH_LR2_EL2			__SYS__LR0_EL2(2)
+#define SYS_ICH_LR3_EL2			__SYS__LR0_EL2(3)
+#define SYS_ICH_LR4_EL2			__SYS__LR0_EL2(4)
+#define SYS_ICH_LR5_EL2			__SYS__LR0_EL2(5)
+#define SYS_ICH_LR6_EL2			__SYS__LR0_EL2(6)
+#define SYS_ICH_LR7_EL2			__SYS__LR0_EL2(7)
+
+#define __SYS__LR8_EL2(x)		sys_reg(3, 4, 12, 13, x)
+#define SYS_ICH_LR8_EL2			__SYS__LR8_EL2(0)
+#define SYS_ICH_LR9_EL2			__SYS__LR8_EL2(1)
+#define SYS_ICH_LR10_EL2		__SYS__LR8_EL2(2)
+#define SYS_ICH_LR11_EL2		__SYS__LR8_EL2(3)
+#define SYS_ICH_LR12_EL2		__SYS__LR8_EL2(4)
+#define SYS_ICH_LR13_EL2		__SYS__LR8_EL2(5)
+#define SYS_ICH_LR14_EL2		__SYS__LR8_EL2(6)
+#define SYS_ICH_LR15_EL2		__SYS__LR8_EL2(7)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_I	(1 << 12)
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index d3b8f92..8f1298a 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -549,14 +549,14 @@ set_hcr:
 	cmp	x0, #1
 	b.ne	3f
 
-	mrs_s	x0, ICC_SRE_EL2
+	mrs_s	x0, SYS_ICC_SRE_EL2
 	orr	x0, x0, #ICC_SRE_EL2_SRE	// Set ICC_SRE_EL2.SRE==1
 	orr	x0, x0, #ICC_SRE_EL2_ENABLE	// Set ICC_SRE_EL2.Enable==1
-	msr_s	ICC_SRE_EL2, x0
+	msr_s	SYS_ICC_SRE_EL2, x0
 	isb					// Make sure SRE is now set
-	mrs_s	x0, ICC_SRE_EL2			// Read SRE back,
+	mrs_s	x0, SYS_ICC_SRE_EL2		// Read SRE back,
 	tbz	x0, #0, 3f			// and check that it sticks
-	msr_s	ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
+	msr_s	SYS_ICH_HCR_EL2, xzr		// Reset ICC_HCR_EL2 to defaults
 
 3:
 #endif
-- 
1.9.1
