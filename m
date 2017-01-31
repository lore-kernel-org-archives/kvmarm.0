From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 06/13] arm64: sysreg: add Set/Way sys encodings
Date: Tue, 31 Jan 2017 18:05:44 +0000
Message-ID: <1485885951-2747-7-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B561C40194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ONk62yC-7WKv for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:57 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6900B40A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:56 -0500 (EST)
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

Cache maintenance ops fall in the SYS instruction class, and KVM needs
to handle them. So as to keep all SYS encodings in one place, this
patch adds them to sysreg.h.

The encodings were taken from ARM DDI 0487A.k_iss10775, Table C5-2.

To make it clear that these are instructions ratehr than registers, and
to allow us to change the way these are handled in future, a new
sys_insn() alias for sys_reg() is added and used for these new
definitions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index eb6662a..cba9e8e 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -48,6 +48,8 @@
 	 ((crn) << CRn_shift) | ((crm) << CRm_shift) | \
 	 ((op2) << Op2_shift))
 
+#define sys_insn	sys_reg
+
 #define sys_reg_Op0(id)	(((id) >> Op0_shift) & Op0_mask)
 #define sys_reg_Op1(id)	(((id) >> Op1_shift) & Op1_mask)
 #define sys_reg_CRn(id)	(((id) >> CRn_shift) & CRn_mask)
@@ -89,6 +91,10 @@
 #define SET_PSTATE_UAO(x) __emit_inst(0xd5000000 | REG_PSTATE_UAO_IMM |	\
 				      (!!x)<<8 | 0x1f)
 
+#define SYS_DC_ISW			sys_insn(1, 0, 7, 6, 2)
+#define SYS_DC_CSW			sys_insn(1, 0, 7, 10, 2)
+#define SYS_DC_CISW			sys_insn(1, 0, 7, 14, 2)
+
 #define SYS_OSDTRRX_EL1			sys_reg(2, 0, 0, 0, 2)
 #define SYS_MDCCINT_EL1			sys_reg(2, 0, 0, 2, 0)
 #define SYS_MDSCR_EL1			sys_reg(2, 0, 0, 2, 2)
-- 
1.9.1
