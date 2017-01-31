From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 07/13] arm64: kvm: add SYS_DESC()
Date: Tue, 31 Jan 2017 18:05:45 +0000
Message-ID: <1485885951-2747-8-git-send-email-mark.rutland@arm.com>
References: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2740A40967
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:59 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qAf+cuxKjJjF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:58 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4353540194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:58 -0500 (EST)
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

This patch adds a macro enabling us to initialise sys_reg_desc
structures based on common sysreg encoding definitions in
<asm/sysreg.h>. Subsequent patches will use this to simplify the KVM
code.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/sys_regs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index dbbb01c..aca681d 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -143,4 +143,9 @@ static inline int cmp_sys_reg(const struct sys_reg_desc *i1,
 #define CRm(_x) 	.CRm = _x
 #define Op2(_x) 	.Op2 = _x
 
+#define SYS_DESC(reg)					\
+	Op0(sys_reg_Op0(reg)), Op1(sys_reg_Op1(reg)),	\
+	CRn(sys_reg_CRn(reg)), CRm(sys_reg_CRm(reg)),	\
+	Op2(sys_reg_Op2(reg))
+
 #endif /* __ARM64_KVM_SYS_REGS_LOCAL_H__ */
-- 
1.9.1
