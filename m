From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 05/15] arm64: sysreg: add physical timer registers
Date: Thu,  9 Mar 2017 17:07:17 +0000
Message-ID: <1489079247-31092-6-git-send-email-mark.rutland@arm.com>
References: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A729940A7F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HSBnw2ovSRrO for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 12:07:06 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DDE9E40A7B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:07:06 -0500 (EST)
In-Reply-To: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
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

This patch adds sysreg definitions for system registers used to control
the architected physical timer. Subsequent patches will make use of
these definitions.

The encodings were taken from ARM DDI 0487A.k_iss10775, Table C5-6.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 9dc30bc..3e281b1 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -182,6 +182,10 @@
 
 #define SYS_CNTFRQ_EL0			sys_reg(3, 3, 14, 0, 0)
 
+#define SYS_CNTP_TVAL_EL0		sys_reg(3, 3, 14, 2, 0)
+#define SYS_CNTP_CTL_EL0		sys_reg(3, 3, 14, 2, 1)
+#define SYS_CNTP_CVAL_EL0		sys_reg(3, 3, 14, 2, 2)
+
 #define __PMEV_op2(n)			((n) & 0x7)
 #define __CNTR_CRm(n)			(0x8 | (((n) >> 3) & 0x3))
 #define SYS_PMEVCNTRn_EL0(n)		sys_reg(3, 3, 14, __CNTR_CRm(n), __PMEV_op2(n))
-- 
1.9.1
