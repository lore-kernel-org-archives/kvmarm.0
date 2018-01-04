From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 04/19] arm64: alternatives: Enforce alignment of struct alt_instr
Date: Thu,  4 Jan 2018 18:43:19 +0000
Message-ID: <20180104184334.16571-5-marc.zyngier@arm.com>
References: <20180104184334.16571-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20180104184334.16571-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>, Steve Capper <steve.capper@arm.com>, Peter Maydell <peter.maydell@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

We're playing a dangerous game with struct alt_instr, as we produce
it using assembly tricks, but parse them using the C structure.
We just assume that the respective alignments of the two will
be the same.

But as we add more fields to this structure, the alignment requirements
of the structure may change, and lead to all kind of funky bugs.

TO solve this, let's move the definition of struct alt_instr to its
own file, and use this to generate the alignment constraint from
asm-offsets.c. The various macros are then patched to take the
alignment into account.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/alternative.h       | 13 +++++--------
 arch/arm64/include/asm/alternative_types.h | 13 +++++++++++++
 arch/arm64/kernel/asm-offsets.c            |  4 ++++
 3 files changed, 22 insertions(+), 8 deletions(-)
 create mode 100644 arch/arm64/include/asm/alternative_types.h

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 4a85c6952a22..395befde7595 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -2,28 +2,24 @@
 #ifndef __ASM_ALTERNATIVE_H
 #define __ASM_ALTERNATIVE_H
 
+#include <asm/asm-offsets.h>
 #include <asm/cpucaps.h>
 #include <asm/insn.h>
 
 #ifndef __ASSEMBLY__
 
+#include <asm/alternative_types.h>
+
 #include <linux/init.h>
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <linux/stringify.h>
 
-struct alt_instr {
-	s32 orig_offset;	/* offset to original instruction */
-	s32 alt_offset;		/* offset to replacement instruction */
-	u16 cpufeature;		/* cpufeature bit set for replacement */
-	u8  orig_len;		/* size of original instruction(s) */
-	u8  alt_len;		/* size of new instruction(s), <= orig_len */
-};
-
 void __init apply_alternatives_all(void);
 void apply_alternatives(void *start, size_t length);
 
 #define ALTINSTR_ENTRY(feature)						      \
+	" .align " __stringify(ALTINSTR_ALIGN) "\n"			      \
 	" .word 661b - .\n"				/* label           */ \
 	" .word 663f - .\n"				/* new instruction */ \
 	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
@@ -69,6 +65,7 @@ void apply_alternatives(void *start, size_t length);
 #include <asm/assembler.h>
 
 .macro altinstruction_entry orig_offset alt_offset feature orig_len alt_len
+	.align ALTINSTR_ALIGN
 	.word \orig_offset - .
 	.word \alt_offset - .
 	.hword \feature
diff --git a/arch/arm64/include/asm/alternative_types.h b/arch/arm64/include/asm/alternative_types.h
new file mode 100644
index 000000000000..26cf76167f2d
--- /dev/null
+++ b/arch/arm64/include/asm/alternative_types.h
@@ -0,0 +1,13 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __ASM_ALTERNATIVE_TYPES_H
+#define __ASM_ALTERNATIVE_TYPES_H
+
+struct alt_instr {
+	s32 orig_offset;	/* offset to original instruction */
+	s32 alt_offset;		/* offset to replacement instruction */
+	u16 cpufeature;		/* cpufeature bit set for replacement */
+	u8  orig_len;		/* size of original instruction(s) */
+	u8  alt_len;		/* size of new instruction(s), <= orig_len */
+};
+
+#endif
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 5ab8841af382..f00666341ae2 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -25,6 +25,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/kvm_host.h>
 #include <linux/suspend.h>
+#include <asm/alternative_types.h>
 #include <asm/cpufeature.h>
 #include <asm/thread_info.h>
 #include <asm/memory.h>
@@ -151,5 +152,8 @@ int main(void)
   DEFINE(HIBERN_PBE_ADDR,	offsetof(struct pbe, address));
   DEFINE(HIBERN_PBE_NEXT,	offsetof(struct pbe, next));
   DEFINE(ARM64_FTR_SYSVAL,	offsetof(struct arm64_ftr_reg, sys_val));
+  BLANK();
+  DEFINE(ALTINSTR_ALIGN,	(63 - __builtin_clzl(__alignof__(struct alt_instr))));
+
   return 0;
 }
-- 
2.14.2
