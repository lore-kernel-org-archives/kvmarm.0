From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 03/13] arm64: sysreg: add performance monitor registers
Date: Tue, 31 Jan 2017 18:05:41 +0000
Message-ID: <1485885951-2747-4-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 87F0940A3D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eEgvXxqgBGPp for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B539340A7B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:50 -0500 (EST)
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

This patch adds sysreg definitions for system registers which are part
of the performance monitors extension. Subsequent patches will make use
of these definitions.

The set of registers is described in ARM DDI 0487A.k_iss10775, Table
D5-9. The encodings were taken from Table C5-6 in the same document.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index b54f8a4..3498d02 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -149,11 +149,36 @@
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
 #define SYS_ID_AA64MMFR2_EL1		sys_reg(3, 0, 0, 7, 2)
 
+#define SYS_PMINTENSET_EL1		sys_reg(3, 0, 9, 14, 1)
+#define SYS_PMINTENCLR_EL1		sys_reg(3, 0, 9, 14, 2)
+
 #define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
 #define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
 
+#define SYS_PMCR_EL0			sys_reg(3, 3, 9, 12, 0)
+#define SYS_PMCNTENSET_EL0		sys_reg(3, 3, 9, 12, 1)
+#define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
+#define SYS_PMOVSCLR_EL0		sys_reg(3, 3, 9, 12, 3)
+#define SYS_PMSWINC_EL0			sys_reg(3, 3, 9, 12, 4)
+#define SYS_PMSELR_EL0			sys_reg(3, 3, 9, 12, 5)
+#define SYS_PMCEID0_EL0			sys_reg(3, 3, 9, 12, 6)
+#define SYS_PMCEID1_EL0			sys_reg(3, 3, 9, 12, 7)
+#define SYS_PMCCNTR_EL0			sys_reg(3, 3, 9, 13, 0)
+#define SYS_PMXEVTYPER_EL0		sys_reg(3, 3, 9, 13, 1)
+#define SYS_PMXEVCNTR_EL0		sys_reg(3, 3, 9, 13, 2)
+#define SYS_PMUSERENR_EL0		sys_reg(3, 3, 9, 14, 0)
+#define SYS_PMOVSSET_EL0		sys_reg(3, 3, 9, 14, 3)
+
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
+#define __PMEV_op2(n)			((n) & 0x7)
+#define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
+#define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
+#define __TYPER_CRm(n)			(0xc | (((n) >> 3) & 0x3))
+#define SYS_PMEVTYPERn_EL0(n)		sys_reg(3, 3, 14, __TYPER_CRm(n), __PMEV_op2(n))
+
+#define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
+
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
 #define SCTLR_ELx_I	(1 << 12)
-- 
1.9.1
