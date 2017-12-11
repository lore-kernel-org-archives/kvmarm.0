From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 05/19] arm64: alternatives: Add dynamic patching feature
Date: Mon, 11 Dec 2017 14:49:23 +0000
Message-ID: <20171211144937.4537-6-marc.zyngier@arm.com>
References: <20171211144937.4537-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 281F949DAD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CCgPJctn1g1E for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Dec 2017 09:46:31 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C67EB49DBF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Dec 2017 09:46:30 -0500 (EST)
In-Reply-To: <20171211144937.4537-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

We've so far relied on a patching infrastructure that only gave us
a single alternative, without any way to finely control what gets
patched. For a single feature, this is an all or nothing thing.

It would be interesting to have a more fine grained way of patching
the kernel though, where we could dynamically tune the code that gets
injected.

In order to achive this, let's introduce a new form of alternative
that is associated with a callback. This callback gets the instruction
sequence number and the old instruction as a parameter, and returns
the new instruction. This callback is always called, as the patching
decision is now done at runtime (not patching is equivalent to returning
the same instruction).

Patching with a callback is declared with the new ALTERNATIVE_CB
and alternative_cb directives:

	asm volatile(ALTERNATIVE_CB("mov %0, #0\n", callback)
		     : "r" (v));
or
	alternative_cb callback
		mov	x0, #0
	alternative_else_nop_endif

where callback is the C function computing the alternative.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/alternative.h       | 40 ++++++++++++++++++++++--------
 arch/arm64/include/asm/alternative_types.h |  3 +++
 arch/arm64/kernel/alternative.c            | 14 +++++++++--
 3 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 395befde7595..ce612e10a2c9 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -18,10 +18,14 @@
 void __init apply_alternatives_all(void);
 void apply_alternatives(void *start, size_t length);
 
-#define ALTINSTR_ENTRY(feature)						      \
+#define ALTINSTR_ENTRY(feature,cb)					      \
 	" .align " __stringify(ALTINSTR_ALIGN) "\n"			      \
 	" .word 661b - .\n"				/* label           */ \
+	" .if " __stringify(cb) " == 0\n"				      \
 	" .word 663f - .\n"				/* new instruction */ \
+	" .else\n"							      \
+	" .word " __stringify(cb) "- .\n"		/* callback */	      \
+	" .endif\n"							      \
 	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
 	" .byte 662b-661b\n"				/* source len      */ \
 	" .byte 664f-663f\n"				/* replacement len */
@@ -40,13 +44,13 @@ void apply_alternatives(void *start, size_t length);
  * be fixed in a binutils release posterior to 2.25.51.0.2 (anything
  * containing commit 4e4d08cf7399b606 or c1baaddf8861).
  */
-#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled)	\
+#define __ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg_enabled, cb)	\
 	".if "__stringify(cfg_enabled)" == 1\n"				\
 	"661:\n\t"							\
 	oldinstr "\n"							\
 	"662:\n"							\
 	".pushsection .altinstructions,\"a\"\n"				\
-	ALTINSTR_ENTRY(feature)						\
+	ALTINSTR_ENTRY(feature,cb)					\
 	".popsection\n"							\
 	".pushsection .altinstr_replacement, \"a\"\n"			\
 	"663:\n\t"							\
@@ -58,26 +62,32 @@ void apply_alternatives(void *start, size_t length);
 	".endif\n"
 
 #define _ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg, ...)	\
-	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg))
+	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg), 0)
 
+#define _ALTERNATIVE_CB(oldinstr, cb, ...) \
+	__ALTERNATIVE_CFG(oldinstr, oldinstr, ARM64_NCAPS, 1, cb)
 #else
 
 #include <asm/assembler.h>
 
-.macro altinstruction_entry orig_offset alt_offset feature orig_len alt_len
+.macro altinstruction_entry orig_offset, alt_offset, feature, orig_len, alt_len, cb = 0
 	.align ALTINSTR_ALIGN
 	.word \orig_offset - .
+	.if \cb == 0
 	.word \alt_offset - .
+	.else
+	.word \cb - .
+	.endif
 	.hword \feature
 	.byte \orig_len
 	.byte \alt_len
 .endm
 
-.macro alternative_insn insn1, insn2, cap, enable = 1
+.macro alternative_insn insn1, insn2, cap, enable = 1, cb = 0
 	.if \enable
 661:	\insn1
 662:	.pushsection .altinstructions, "a"
-	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f
+	altinstruction_entry 661b, 663f, \cap, 662b-661b, 664f-663f, \cb
 	.popsection
 	.pushsection .altinstr_replacement, "ax"
 663:	\insn2
@@ -109,10 +119,10 @@ void apply_alternatives(void *start, size_t length);
 /*
  * Begin an alternative code sequence.
  */
-.macro alternative_if_not cap
+.macro alternative_if_not cap, cb = 0
 	.set .Lasm_alt_mode, 0
 	.pushsection .altinstructions, "a"
-	altinstruction_entry 661f, 663f, \cap, 662f-661f, 664f-663f
+	altinstruction_entry 661f, 663f, \cap, 662f-661f, 664f-663f, \cb
 	.popsection
 661:
 .endm
@@ -120,13 +130,17 @@ void apply_alternatives(void *start, size_t length);
 .macro alternative_if cap
 	.set .Lasm_alt_mode, 1
 	.pushsection .altinstructions, "a"
-	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f
+	altinstruction_entry 663f, 661f, \cap, 664f-663f, 662f-661f, 0
 	.popsection
 	.pushsection .altinstr_replacement, "ax"
 	.align 2	/* So GAS knows label 661 is suitably aligned */
 661:
 .endm
 
+.macro alternative_cb cb
+	alternative_if_not ARM64_NCAPS, \cb
+.endm
+
 /*
  * Provide the other half of the alternative code sequence.
  */
@@ -166,6 +180,9 @@ alternative_endif
 #define _ALTERNATIVE_CFG(insn1, insn2, cap, cfg, ...)	\
 	alternative_insn insn1, insn2, cap, IS_ENABLED(cfg)
 
+#define _ALTERNATIVE_CB(insn1, cb, ...)	\
+	alternative_insn insn1, insn1, ARM64_NCAPS, 1, cb
+
 .macro user_alt, label, oldinstr, newinstr, cond
 9999:	alternative_insn "\oldinstr", "\newinstr", \cond
 	_ASM_EXTABLE 9999b, \label
@@ -242,4 +259,7 @@ alternative_endif
 #define ALTERNATIVE(oldinstr, newinstr, ...)   \
 	_ALTERNATIVE_CFG(oldinstr, newinstr, __VA_ARGS__, 1)
 
+#define ALTERNATIVE_CB(oldinstr, cb, ...)	\
+	_ALTERNATIVE_CB(oldinstr, cb)
+
 #endif /* __ASM_ALTERNATIVE_H */
diff --git a/arch/arm64/include/asm/alternative_types.h b/arch/arm64/include/asm/alternative_types.h
index 26cf76167f2d..513f3985d455 100644
--- a/arch/arm64/include/asm/alternative_types.h
+++ b/arch/arm64/include/asm/alternative_types.h
@@ -2,6 +2,9 @@
 #ifndef __ASM_ALTERNATIVE_TYPES_H
 #define __ASM_ALTERNATIVE_TYPES_H
 
+struct alt_instr;
+typedef u32 (*alternative_cb_t)(struct alt_instr *alt, int index, u32 new_insn);
+
 struct alt_instr {
 	s32 orig_offset;	/* offset to original instruction */
 	s32 alt_offset;		/* offset to replacement instruction */
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 6dd0a3a3e5c9..279c103ea801 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -110,12 +110,15 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
 	struct alt_instr *alt;
 	struct alt_region *region = alt_region;
 	__le32 *origptr, *replptr, *updptr;
+	alternative_cb_t alt_cb;
 
 	for (alt = region->begin; alt < region->end; alt++) {
 		u32 insn;
 		int i, nr_inst;
 
-		if (!cpus_have_cap(alt->cpufeature))
+		/* Use ARM64_NCAPS as an unconditional patch */
+		if (alt->cpufeature != ARM64_NCAPS &&
+		    !cpus_have_cap(alt->cpufeature))
 			continue;
 
 		BUG_ON(alt->alt_len != alt->orig_len);
@@ -124,11 +127,18 @@ static void __apply_alternatives(void *alt_region, bool use_linear_alias)
 
 		origptr = ALT_ORIG_PTR(alt);
 		replptr = ALT_REPL_PTR(alt);
+		alt_cb  = ALT_REPL_PTR(alt);
 		updptr = use_linear_alias ? lm_alias(origptr) : origptr;
 		nr_inst = alt->alt_len / sizeof(insn);
 
 		for (i = 0; i < nr_inst; i++) {
-			insn = get_alt_insn(alt, origptr + i, replptr + i);
+			if (alt->cpufeature == ARM64_NCAPS) {
+				insn = le32_to_cpu(updptr[i]);
+				insn = alt_cb(alt, i, insn);
+			} else {
+				insn = get_alt_insn(alt, origptr + i,
+						    replptr + i);
+			}
 			updptr[i] = cpu_to_le32(insn);
 		}
 
-- 
2.14.2
