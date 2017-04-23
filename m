From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 03/79] arm64: sysreg: add performance monitor registers
Date: Sun, 23 Apr 2017 19:08:13 +0200
Message-ID: <20170423170929.27334-4-cdall@linaro.org>
References: <20170423170929.27334-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB0DF49C41
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 177Va+t3A5HL for <kvmarm@lists.cs.columbia.edu>;
 Sun, 23 Apr 2017 13:06:47 -0400 (EDT)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 95DD649C44
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 13:06:47 -0400 (EDT)
Received: by mail-wm0-f47.google.com with SMTP id r190so50444493wme.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 23 Apr 2017 10:09:34 -0700 (PDT)
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
2.9.0
