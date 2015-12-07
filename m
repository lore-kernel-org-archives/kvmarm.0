From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 01/22] arm64: Add macros to read/write system registers
Date: Mon,  7 Dec 2015 10:53:17 +0000
Message-ID: <1449485618-9443-2-git-send-email-marc.zyngier@arm.com>
References: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1449485618-9443-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Steve Capper <Steve.Capper@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Rather than crafting custom macros for reading/writing each system
register provide generics accessors, read_sysreg and write_sysreg, for
this purpose.

Unlike read_cpuid, calls to read_exception_reg are never expected
to be optimized away or replaced with synthetic values.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d48ab5b..c9c283a 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -20,6 +20,8 @@
 #ifndef __ASM_SYSREG_H
 #define __ASM_SYSREG_H
 
+#include <linux/stringify.h>
+
 #include <asm/opcodes.h>
 
 /*
@@ -208,6 +210,8 @@
 
 #else
 
+#include <linux/types.h>
+
 asm(
 "	.irp	num,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30\n"
 "	.equ	__reg_num_x\\num, \\num\n"
@@ -232,6 +236,19 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 	val |= set;
 	asm volatile("msr sctlr_el1, %0" : : "r" (val));
 }
+
+#define read_sysreg(r) ({					\
+	u64 __val;						\
+	asm volatile("mrs %0, " __stringify(r) : "=r" (__val));	\
+	__val;							\
+})
+
+#define write_sysreg(v, r) do {					\
+	u64 __val = (u64)v;					\
+	asm volatile("msr " __stringify(r) ", %0"		\
+		     : : "r" (__val));				\
+} while (0)
+
 #endif
 
 #endif	/* __ASM_SYSREG_H */
-- 
2.1.4

