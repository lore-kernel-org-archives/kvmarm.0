From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 01/79] arm64: sysreg: sort by encoding
Date: Sun, 23 Apr 2017 19:08:11 +0200
Message-ID: <20170423170929.27334-2-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACC3F49C48
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IkhpTISJcXk3 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:45 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 838D449C35
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:45 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r190so50444101wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:31 -0700 (PDT)
In-Reply-To: <20170423170929.27334-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

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
2.9.0
