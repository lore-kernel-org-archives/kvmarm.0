From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 02/13] arm64: sysreg: add debug system registers
Date: Tue, 31 Jan 2017 18:05:40 +0000
Message-ID: <1485885951-2747-3-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B8FC40296
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:49 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vLA0F8Mt-vp5 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:48 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3CC4096E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:48 -0500 (EST)
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

This patch adds sysreg definitions for system registers in the debug and
trace system register encoding space. Subsequent patches will make use
of these definitions.

The encodings were taken from ARM DDI 0487A.k_iss10775, Table C5-5.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e6498ac..b54f8a4 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -89,6 +89,29 @@
 #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
 				      (!!x)<<8 | 0x1f)
 
+#define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
+#define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
+#define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
+#define SYS_OSDTRTX_EL1			sys_reg(2, 0, 0, 3, 2)
+#define SYS_OSECCR_EL1			sys_reg(2, 0, 0, 6, 2)
+#define SYS_DBGBVRn_EL1(n)		sys_reg(2, 0, 0, n, 4)
+#define SYS_DBGBCRn_EL1(n)		sys_reg(2, 0, 0, n, 5)
+#define SYS_DBGWVRn_EL1(n)		sys_reg(2, 0, 0, n, 6)
+#define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
+#define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
+#define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
+#define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
+#define SYS_OSDLR_EL1			sys_reg(2, 0, 1, 3, 4)
+#define SYS_DBGPRCR_EL1			sys_reg(2, 0, 1, 4, 4)
+#define SYS_DBGCLAIMSET_EL1		sys_reg(2, 0, 7, 8, 6)
+#define SYS_DBGCLAIMCLR_EL1		sys_reg(2, 0, 7, 9, 6)
+#define SYS_DBGAUTHSTATUS_EL1		sys_reg(2, 0, 7, 14, 6)
+#define SYS_MDCCSR_EL0			sys_reg(2, 3, 0, 1, 0)
+#define SYS_DBGDTR_EL0			sys_reg(2, 3, 0, 4, 0)
+#define SYS_DBGDTRRX_EL0		sys_reg(2, 3, 0, 5, 0)
+#define SYS_DBGDTRTX_EL0		sys_reg(2, 3, 0, 5, 0)
+#define SYS_DBGVCR32_EL2		sys_reg(2, 4, 0, 7, 0)
+
 #define SYS_MIDR_EL1			sys_reg(3, 0, 0, 0, 0)
 #define SYS_MPIDR_EL1			sys_reg(3, 0, 0, 0, 5)
 #define SYS_REVIDR_EL1			sys_reg(3, 0, 0, 0, 6)
-- 
1.9.1
