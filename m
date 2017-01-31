From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 01/13] arm64: sysreg: sort by encoding
Date: Tue, 31 Jan 2017 18:05:39 +0000
Message-ID: <1485885951-2747-2-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BF1F40969
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:47 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id a00elsWwCa61 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:46 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA20D408E9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:46 -0500 (EST)
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

Out sysreg definitions are largely (but not entirely) in ascending order
of op0:op1:CRn:CRm:op2.

It would be preferable to enforce this sort, as this makes it easier to
verify the set of encodings against documentation, and provides an
obvious location for each addition in future, minimising conflicts.

This patch enforces this order, by moving the few items that break it.
There should be no functional change.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ac24b6e..e6498ac 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -81,6 +81,14 @@
 
 #endif	/* CONFIG_BROKEN_GAS_INST */
 
+#define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
+#define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
+
+#define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
+				      (!!x)<<8 | 0x1f)
+#define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
+				      (!!x)<<8 | 0x1f)
+
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
@@ -118,17 +126,10 @@
 #define SYS_ID_AA64MMFR1_EL1		sys_reg(3, 0, 0, 7, 1)
 #define SYS_ID_AA64MMFR2_EL1		sys_reg(3, 0, 0, 7, 2)
 
-#define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 #define SYS_CTR_EL0			sys_reg(3, 3, 0, 0, 1)
 #define SYS_DCZID_EL0			sys_reg(3, 3, 0, 0, 7)
 
-#define REG_PSTATE_PAN_IMM		sys_reg(0, 0, 4, 0, 4)
-#define REG_PSTATE_UAO_IMM		sys_reg(0, 0, 4, 0, 3)
-
-#define SET_PSTATE_PAN(x) __emit_inst(0xd5000000 | REG_PSTATE_PAN_IMM |	\
-				      (!!x)<<8 | 0x1f)
-#define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
-				      (!!x)<<8 | 0x1f)
+#define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
-- 
1.9.1
