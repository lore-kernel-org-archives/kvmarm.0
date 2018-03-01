From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 01/23] arm64: alternatives: Add dynamic patching feature
Date: Thu,  1 Mar 2018 15:55:16 +0000
Message-ID: <20180301155538.26860-2-marc.zyngier@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7224649E67
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:49:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1-6rFZ3U2N0C for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Mar 2018 10:48:49 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3292B4048A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Mar 2018 10:48:49 -0500 (EST)
In-Reply-To: <20180301155538.26860-1-marc.zyngier@arm.com>
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
a single alternative, without any way to provide a range of potential
replacement instructions. For a single feature, this is an all or
nothing thing.

It would be interesting to have a more flexible grained way of patching
the kernel though, where we could dynamically tune the code that gets
injected.

In order to achive this, let's introduce a new form of dynamic patching,
assiciating a callback to a patching site. This callback gets source and
target locations of the patching request, as well as the number of
instructions to be patched.

Dynamic patching is declared with the new ALTERNATIVE_CB and alternative_cb
directives:

	asm volatile(ALTERNATIVE_CB("mov %0, #0\n", callback)
		     : "r" (v));
or
	alternative_cb callback
		mov	x0, #0
	alternative_cb_end

where callback is the C function computing the alternative.

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/alternative.h | 41 ++++++++++++++++++++++++++++++----
 arch/arm64/kernel/alternative.c      | 43 +++++++++++++++++++++++++++---------
 2 files changed, 69 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/alternative.h b/arch/arm64/include/asm/alternative.h
index 669028172fd6..a91933b1e2e6 100644
--- a/arch/arm64/include/asm/alternative.h
+++ b/arch/arm64/include/asm/alternative.h
@@ -5,6 +5,8 @@
 #include <asm/cpucaps.h>
 #include <asm/insn.h>
 
+#define ARM64_CB_PATCH ARM64_NCAPS
+
 #ifndef __ASSEMBLY__
 
 #include <linux/init.h>
@@ -22,12 +24,19 @@ struct alt_instr {
 	u8  alt_len;		/* size of new instruction(s), <= orig_len */
 };
 
+typedef void (*alternative_cb_t)(struct alt_instr *alt,
+				 __le32 *origptr, __le32 *updptr, int nr_inst);
+
 void __init apply_alternatives_all(void);
 void apply_alternatives(void *start, size_t length);
 
-#define ALTINSTR_ENTRY(feature)						      \
+#define ALTINSTR_ENTRY(feature,cb)					      \
 	" .word 661b - .\n"				/* label           */ \
+	" .if " __stringify(cb) " == 0\n"				      \
 	" .word 663f - .\n"				/* new instruction */ \
+	" .else\n"							      \
+	" .word " __stringify(cb) "- .\n"		/* callback */	      \
+	" .endif\n"							      \
 	" .hword " __stringify(feature) "\n"		/* feature bit     */ \
 	" .byte 662b-661b\n"				/* source len      */ \
 	" .byte 664f-663f\n"				/* replacement len */
@@ -45,15 +54,18 @@ void apply_alternatives(void *start, size_t length);
  * but most assemblers die if insn1 or insn2 have a .inst. This should
  * be fixed in a binutils release posterior to 2.25.51.0.2 (anything
  * containing commit 4e4d08cf7399b606 or c1baaddf8861).
+ *
+ * Alternatives with callbacks do not generate replacement instructions.
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
+	" .if " __stringify(cb) " == 0\n"				\
 	".pushsection .altinstr_replacement, \"a\"\n"			\
 	"663:\n\t"							\
 	newinstr "\n"							\
@@ -61,11 +73,17 @@ void apply_alternatives(void *start, size_t length);
 	".popsection\n\t"						\
 	".org	. - (664b-663b) + (662b-661b)\n\t"			\
 	".org	. - (662b-661b) + (664b-663b)\n"			\
+	".else\n\t"							\
+	"663:\n\t"							\
+	"664:\n\t"							\
+	".endif\n"							\
 	".endif\n"
 
 #define _ALTERNATIVE_CFG(oldinstr, newinstr, feature, cfg, ...)	\
-	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg))
+	__ALTERNATIVE_CFG(oldinstr, newinstr, feature, IS_ENABLED(cfg), 0)
 
+#define ALTERNATIVE_CB(oldinstr, cb) \
+	__ALTERNATIVE_CFG(oldinstr, "NOT_AN_INSTRUCTION", ARM64_CB_PATCH, 1, cb)
 #else
 
 #include <asm/assembler.h>
@@ -132,6 +150,14 @@ void apply_alternatives(void *start, size_t length);
 661:
 .endm
 
+.macro alternative_cb cb
+	.set .Lasm_alt_mode, 0
+	.pushsection .altinstructions, "a"
+	altinstruction_entry 661f, \cb, ARM64_CB_PATCH, 662f-661f, 0
+	.popsection
+661:
+.endm
+
 /*
  * Provide the other half of the alternative code sequence.
  */
@@ -157,6 +183,13 @@ void apply_alternatives(void *start, size_t length);
 	.org	. - (662b-661b) + (664b-663b)
 .endm
 
+/*
+ * Callback-based alternative epilogue
+ */
+.macro alternative_cb_end
+662:
+.endm
+
 /*
  * Provides a trivial alternative or default sequence consisting solely
  * of NOPs. The number of NOPs is chosen automatically to match the
diff --git a/arch/arm64/kernel/alternative.c b/arch/arm64/kernel/alternative.c
index 414288a558c8..5c4bce4ac381 100644
--- a/arch/arm64/kernel/alternative.c
+++ b/arch/arm64/kernel/alternative.c
@@ -107,32 +107,53 @@ static u32 get_alt_insn(struct alt_instr *alt, __le32 *insnptr, __le32 *altinsnp
 	return insn;
 }
 
+static void patch_alternative(struct alt_instr *alt,
+			      __le32 *origptr, __le32 *updptr, int nr_inst)
+{
+	__le32 *replptr;
+	int i;
+
+	replptr = ALT_REPL_PTR(alt);
+	for (i = 0; i < nr_inst; i++) {
+		u32 insn;
+
+		insn = get_alt_insn(alt, origptr + i, replptr + i);
+		updptr[i] = cpu_to_le32(insn);
+	}
+}
+
 static void __apply_alternatives(void *alt_region, bool use_linear_alias)
 {
 	struct alt_instr *alt;
 	struct alt_region *region = alt_region;
-	__le32 *origptr, *replptr, *updptr;
+	__le32 *origptr, *updptr;
+	alternative_cb_t alt_cb;
 
 	for (alt = region->begin; alt < region->end; alt++) {
-		u32 insn;
-		int i, nr_inst;
+		int nr_inst;
 
-		if (!cpus_have_cap(alt->cpufeature))
+		/* Use ARM64_CB_PATCH as an unconditional patch */
+		if (alt->cpufeature < ARM64_CB_PATCH &&
+		    !cpus_have_cap(alt->cpufeature))
 			continue;
 
-		BUG_ON(alt->alt_len != alt->orig_len);
+		if (alt->cpufeature == ARM64_CB_PATCH)
+			BUG_ON(alt->alt_len != 0);
+		else
+			BUG_ON(alt->alt_len != alt->orig_len);
 
 		pr_info_once("patching kernel code\n");
 
 		origptr = ALT_ORIG_PTR(alt);
-		replptr = ALT_REPL_PTR(alt);
 		updptr = use_linear_alias ? lm_alias(origptr) : origptr;
-		nr_inst = alt->alt_len / sizeof(insn);
+		nr_inst = alt->orig_len / AARCH64_INSN_SIZE;
 
-		for (i = 0; i < nr_inst; i++) {
-			insn = get_alt_insn(alt, origptr + i, replptr + i);
-			updptr[i] = cpu_to_le32(insn);
-		}
+		if (alt->cpufeature < ARM64_CB_PATCH)
+			alt_cb = patch_alternative;
+		else
+			alt_cb  = ALT_REPL_PTR(alt);
+
+		alt_cb(alt, origptr, updptr, nr_inst);
 
 		flush_icache_range((uintptr_t)origptr,
 				   (uintptr_t)(origptr + nr_inst));
-- 
2.14.2
