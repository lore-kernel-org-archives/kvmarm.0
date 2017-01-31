From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 05/13] arm64: sysreg: add register encodings used by KVM
Date: Tue, 31 Jan 2017 18:05:43 +0000
Message-ID: <1485885951-2747-6-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F18040B5B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:55 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xv8icgxKoTYd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:54 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7D2FE40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:54 -0500 (EST)
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

This patch adds sysreg definitions for registers which KVM needs the
encodings for, which are not currently describe in <asm/sysregs.h>.
Subsequent patches will make use of these definitions.

The encodings were taken from ARM DDI 0487A.k_iss10775, Table C5-6, but
this is not an exhaustive addition. Additions are only made for
regsiteres used today by KVM.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9dc30bc..eb6662a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -119,6 +119,7 @@
 #define SYS_ID_PFR0_EL1			sys_reg(3, 0, 0, 1, 0)
 #define SYS_ID_PFR1_EL1			sys_reg(3, 0, 0, 1, 1)
 #define SYS_ID_DFR0_EL1			sys_reg(3, 0, 0, 1, 2)
+#define SYS_ID_AFR0_EL1			sys_reg(3, 0, 0, 1, 3)
 #define SYS_ID_MMFR0_EL1		sys_reg(3, 0, 0, 1, 4)
 #define SYS_ID_MMFR1_EL1		sys_reg(3, 0, 0, 1, 5)
 #define SYS_ID_MMFR2_EL1		sys_reg(3, 0, 0, 1, 6)
@@ -149,11 +150,30 @@
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
 #define SYS_ID_AA64MMFR2_EL1		sys_reg(3, 0, 0, 7, 2)
 
+#define SYS_SCTLR_EL1			sys_reg(3, 0, 1, 0, 0)
+#define SYS_ACTLR_EL1			sys_reg(3, 0, 1, 0, 1)
+#define SYS_CPACR_EL1			sys_reg(3, 0, 1, 0, 2)
+
+#define SYS_TTBR0_EL1			sys_reg(3, 0, 2, 0, 0)
+#define SYS_TTBR1_EL1			sys_reg(3, 0, 2, 0, 1)
+#define SYS_TCR_EL1			sys_reg(3, 0, 2, 0, 2)
+
 #define SYS_ICC_PMR_EL1			sys_reg(3, 0, 4, 6, 0)
 
+#define SYS_AFSR0_EL1			sys_reg(3, 0, 5, 1, 0)
+#define SYS_AFSR1_EL1			sys_reg(3, 0, 5, 1, 1)
+#define SYS_ESR_EL1			sys_reg(3, 0, 5, 2, 0)
+#define SYS_FAR_EL1			sys_reg(3, 0, 6, 0, 0)
+#define SYS_PAR_EL1			sys_reg(3, 0, 7, 4, 0)
+
 #define SYS_PMINTENSET_EL1		sys_reg(3, 0, 9, 14, 1)
 #define SYS_PMINTENCLR_EL1		sys_reg(3, 0, 9, 14, 2)
 
+#define SYS_MAIR_EL1			sys_reg(3, 0, 10, 2, 0)
+#define SYS_AMAIR_EL1			sys_reg(3, 0, 10, 3, 0)
+
+#define SYS_VBAR_EL1			sys_reg(3, 0, 12, 0, 0)
+
 #define SYS_ICC_DIR_EL1			sys_reg(3, 0, 12, 11, 1)
 #define SYS_ICC_SGI1R_EL1		sys_reg(3, 0, 12, 11, 5)
 #define SYS_ICC_IAR1_EL1		sys_reg(3, 0, 12, 12, 0)
@@ -163,6 +183,16 @@
 #define SYS_ICC_SRE_EL1			sys_reg(3, 0, 12, 12, 5)
 #define SYS_ICC_GRPEN1_EL1		sys_reg(3, 0, 12, 12, 7)
 
+#define SYS_CONTEXTIDR_EL1		sys_reg(3, 0, 13, 0, 1)
+#define SYS_TPIDR_EL1			sys_reg(3, 0, 13, 0, 4)
+
+#define SYS_CNTKCTL_EL1			sys_reg(3, 0, 14, 1, 0)
+
+#define SYS_CLIDR_EL1			sys_reg(3, 1, 0, 0, 1)
+#define SYS_AIDR_EL1			sys_reg(3, 1, 0, 0, 7)
+
+#define SYS_CSSELR_EL1			sys_reg(3, 2, 0, 0, 0)
+
 #define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
 #define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
 
@@ -180,6 +210,9 @@
 #define SYS_PMUSERENR_EL0		sys_reg(3, 3, 9, 14, 0)
 #define SYS_PMOVSSET_EL0		sys_reg(3, 3, 9, 14, 3)
 
+#define SYS_TPIDR_EL0			sys_reg(3, 3, 13, 0, 2)
+#define SYS_TPIDRRO_EL0			sys_reg(3, 3, 13, 0, 3)
+
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 #define __PMEV_op2(n)			((n) & 0x7)
@@ -190,6 +223,10 @@
 
 #define SYS_PMCCFILTR_EL0		sys_reg (3, 3, 14, 15, 7)
 
+#define SYS_DACR32_EL2			sys_reg(3, 4, 3, 0, 0)
+#define SYS_IFSR32_EL2			sys_reg(3, 4, 5, 0, 1)
+#define SYS_FPEXC32_EL2			sys_reg(3, 4, 5, 3, 0)
+
 #define __SYS__AP0Rx_EL2(x)		sys_reg(3, 4, 12, 8, x)
 #define SYS_ICH_AP0R0_EL2		__SYS__AP0Rx_EL2(0)
 #define SYS_ICH_AP0R1_EL2		__SYS__AP0Rx_EL2(1)
-- 
1.9.1
