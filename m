From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 03/22] KVM: ARM64: Add offset defines for PMU registers
Date: Fri, 11 Sep 2015 16:54:56 +0800
Message-ID: <1441961715-11688-4-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DBA2E412EF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Wq13QsvFCaQ8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:30 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 49E1240FB3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:28 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

We are about to trap and emulate acccesses to each PMU register
individually. This adds the context offsets for the AArch64 PMU
registers and their AArch32 counterparts.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/kvm_asm.h | 59 +++++++++++++++++++++++++++++++++++-----
 1 file changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 3c5fe68..3a1df48 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -56,14 +56,36 @@
 #define DBGWVR15_EL1	86
 #define MDCCINT_EL1	87	/* Monitor Debug Comms Channel Interrupt Enable Reg */
 
+/* Performance Monitors Registers */
+#define PMCR_EL0	88	/* Control Register */
+#define PMOVSSET_EL0	89	/* Overflow Flag Status Set Register */
+#define PMOVSCLR_EL0	90	/* Overflow Flag Status Clear Register */
+#define PMSELR_EL0	91	/* Event Counter Selection Register */
+#define PMCEID0_EL0	92	/* Common Event Identification Register 0 */
+#define PMCEID1_EL0	93	/* Common Event Identification Register 1 */
+#define PMEVCNTR0_EL0	94	/* Event Counter Register (0-30) */
+#define PMEVCNTR30_EL0	124
+#define PMCCNTR_EL0	125	/* Cycle Counter Register */
+#define PMEVTYPER0_EL0	126	/* Event Type Register (0-30) */
+#define PMEVTYPER30_EL0	156
+#define PMCCFILTR_EL0	157	/* Cycle Count Filter Register */
+#define PMXEVCNTR_EL0	158	/* Selected Event Count Register */
+#define PMXEVTYPER_EL0	159	/* Selected Event Type Register */
+#define PMCNTENSET_EL0	160	/* Count Enable Set Register */
+#define PMCNTENCLR_EL0	161	/* Count Enable Clear Register */
+#define PMINTENSET_EL1	162	/* Interrupt Enable Set Register */
+#define PMINTENCLR_EL1	163	/* Interrupt Enable Clear Register */
+#define PMUSERENR_EL0	164	/* User Enable Register */
+#define PMSWINC_EL0	165	/* Software Increment Register */
+
 /* 32bit specific registers. Keep them at the end of the range */
-#define	DACR32_EL2	88	/* Domain Access Control Register */
-#define	IFSR32_EL2	89	/* Instruction Fault Status Register */
-#define	FPEXC32_EL2	90	/* Floating-Point Exception Control Register */
-#define	DBGVCR32_EL2	91	/* Debug Vector Catch Register */
-#define	TEECR32_EL1	92	/* ThumbEE Configuration Register */
-#define	TEEHBR32_EL1	93	/* ThumbEE Handler Base Register */
-#define	NR_SYS_REGS	94
+#define	DACR32_EL2	166	/* Domain Access Control Register */
+#define	IFSR32_EL2	167	/* Instruction Fault Status Register */
+#define	FPEXC32_EL2	168	/* Floating-Point Exception Control Register */
+#define	DBGVCR32_EL2	169	/* Debug Vector Catch Register */
+#define	TEECR32_EL1	170	/* ThumbEE Configuration Register */
+#define	TEEHBR32_EL1	171	/* ThumbEE Handler Base Register */
+#define	NR_SYS_REGS	172
 
 /* 32bit mapping */
 #define c0_MPIDR	(MPIDR_EL1 * 2)	/* MultiProcessor ID Register */
@@ -85,6 +107,24 @@
 #define c6_IFAR		(c6_DFAR + 1)	/* Instruction Fault Address Register */
 #define c7_PAR		(PAR_EL1 * 2)	/* Physical Address Register */
 #define c7_PAR_high	(c7_PAR + 1)	/* PAR top 32 bits */
+
+/* Performance Monitors*/
+#define c9_PMCR		(PMCR_EL0 * 2)
+#define c9_PMOVSSET	(PMOVSSET_EL0 * 2)
+#define c9_PMOVSCLR	(PMOVSCLR_EL0 * 2)
+#define c9_PMCCNTR	(PMCCNTR_EL0 * 2)
+#define c9_PMSELR	(PMSELR_EL0 * 2)
+#define c9_PMCEID0	(PMCEID0_EL0 * 2)
+#define c9_PMCEID1	(PMCEID1_EL0 * 2)
+#define c9_PMXEVCNTR	(PMXEVCNTR_EL0 * 2)
+#define c9_PMXEVTYPER	(PMXEVTYPER_EL0 * 2)
+#define c9_PMCNTENSET	(PMCNTENSET_EL0 * 2)
+#define c9_PMCNTENCLR	(PMCNTENCLR_EL0 * 2)
+#define c9_PMINTENSET	(PMINTENSET_EL1 * 2)
+#define c9_PMINTENCLR	(PMINTENCLR_EL1 * 2)
+#define c9_PMUSERENR	(PMUSERENR_EL0 * 2)
+#define c9_PMSWINC	(PMSWINC_EL0 * 2)
+
 #define c10_PRRR	(MAIR_EL1 * 2)	/* Primary Region Remap Register */
 #define c10_NMRR	(c10_PRRR + 1)	/* Normal Memory Remap Register */
 #define c12_VBAR	(VBAR_EL1 * 2)	/* Vector Base Address Register */
@@ -96,6 +136,11 @@
 #define c10_AMAIR1	(c10_AMAIR0 + 1)/* Aux Memory Attr Indirection Reg */
 #define c14_CNTKCTL	(CNTKCTL_EL1 * 2) /* Timer Control Register (PL1) */
 
+/* Performance Monitors*/
+#define c14_PMEVCNTR0	(PMEVCNTR0_EL0 * 2)
+#define c14_PMEVTYPER0	(PMEVTYPER0_EL0 * 2)
+#define c14_PMCCFILTR	(PMCCFILTR_EL0 * 2)
+
 #define cp14_DBGDSCRext	(MDSCR_EL1 * 2)
 #define cp14_DBGBCR0	(DBGBCR0_EL1 * 2)
 #define cp14_DBGBVR0	(DBGBVR0_EL1 * 2)
-- 
2.0.4
