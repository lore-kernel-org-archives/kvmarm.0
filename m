From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 03/31] arm64: Add macros to read/write system registers
Date: Thu, 24 Dec 2015 11:12:11 +0000
Message-ID: <1450955559-15639-4-git-send-email-marc.zyngier@arm.com>
References: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450955559-15639-1-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Gleb Natapov <gleb@kernel.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Amit Singh Tomar <amittomer25@gmail.com>, Christoffer Dall <christoffer.dall@linaro.org>, David Binderman <dcb314@hotmail.com>, Fengguang Wu <fengguang.wu@intel.com>, Jisheng Zhang <jszhang@marvell.com>, Pavel Fedin <p.fedin@samsung.com>, Vladimir Murzin <vladimir.murzin@arm.com>, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

Rather than crafting custom macros for reading/writing each system
register provide generics accessors, read_sysreg and write_sysreg, for
this purpose.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/sysreg.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index d48ab5b..4aeebec 100644
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
@@ -232,6 +236,23 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 	val |= set;
 	asm volatile("msr sctlr_el1, %0" : : "r" (val));
 }
+
+/*
+ * Unlike read_cpuid, calls to read_sysreg are never expected to be
+ * optimized away or replaced with synthetic values.
+ */
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

