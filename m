From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH] arm64: Add support for new control bits CTR_EL0.IDC and
 CTR_EL0.IDC
Date: Fri, 16 Feb 2018 18:57:46 -0600
Message-ID: <1518829066-3558-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Philip Elcan <pelcan@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

Two point of unification cache maintenance operations 'DC CVAU' and
'IC IVAU' are optional for implementors as per ARMv8 specification.
This patch parses the updated CTR_EL0 register definition and adds
the required changes to skip POU operations if the hardware reports
CTR_EL0.IDC and/or CTR_EL0.IDC.

CTR_EL0.DIC: Instruction cache invalidation requirements for
 instruction to data coherence. The meaning of this bit[29].
  0: Instruction cache invalidation to the point of unification
     is required for instruction to data coherence.
  1: Instruction cache cleaning to the point of unification is
      not required for instruction to data coherence.

CTR_EL0.IDC: Data cache clean requirements for instruction to data
 coherence. The meaning of this bit[28].
  0: Data cache clean to the point of unification is required for
     instruction to data coherence, unless CLIDR_EL1.LoC == 0b000
     or (CLIDR_EL1.LoUIS == 0b000 && CLIDR_EL1.LoUU == 0b000).
  1: Data cache clean to the point of unification is not required
     for instruction to data coherence.

Signed-off-by: Philip Elcan <pelcan@codeaurora.org>
Signed-off-by: Shanker Donthineni <shankerd@codeaurora.org>
---
 arch/arm64/include/asm/assembler.h | 48 ++++++++++++++++++++++++--------------
 arch/arm64/include/asm/cache.h     |  2 ++
 arch/arm64/kernel/cpufeature.c     |  2 ++
 arch/arm64/mm/cache.S              | 26 ++++++++++++++-------
 4 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 3c78835..9eaa948 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -30,6 +30,7 @@
 #include <asm/pgtable-hwdef.h>
 #include <asm/ptrace.h>
 #include <asm/thread_info.h>
+#include <asm/cache.h>
 
 	.macro save_and_disable_daif, flags
 	mrs	\flags, daif
@@ -334,9 +335,9 @@
  * raw_dcache_line_size - get the minimum D-cache line size on this CPU
  * from the CTR register.
  */
-	.macro	raw_dcache_line_size, reg, tmp
-	mrs	\tmp, ctr_el0			// read CTR
-	ubfm	\tmp, \tmp, #16, #19		// cache line size encoding
+	.macro	raw_dcache_line_size, reg, tmp, ctr
+	mrs	\ctr, ctr_el0			// read CTR
+	ubfm	\tmp, \ctr, #16, #19		// cache line size encoding
 	mov	\reg, #4			// bytes per word
 	lsl	\reg, \reg, \tmp		// actual cache line size
 	.endm
@@ -344,9 +345,9 @@
 /*
  * dcache_line_size - get the safe D-cache line size across all CPUs
  */
-	.macro	dcache_line_size, reg, tmp
-	read_ctr	\tmp
-	ubfm		\tmp, \tmp, #16, #19	// cache line size encoding
+	.macro	dcache_line_size, reg, tmp, ctr
+	read_ctr	\ctr
+	ubfm		\tmp, \ctr, #16, #19	// cache line size encoding
 	mov		\reg, #4		// bytes per word
 	lsl		\reg, \reg, \tmp	// actual cache line size
 	.endm
@@ -355,9 +356,9 @@
  * raw_icache_line_size - get the minimum I-cache line size on this CPU
  * from the CTR register.
  */
-	.macro	raw_icache_line_size, reg, tmp
-	mrs	\tmp, ctr_el0			// read CTR
-	and	\tmp, \tmp, #0xf		// cache line size encoding
+	.macro	raw_icache_line_size, reg, tmp, ctr
+	mrs	\ctr, ctr_el0			// read CTR
+	and	\tmp, \ctr, #0xf		// cache line size encoding
 	mov	\reg, #4			// bytes per word
 	lsl	\reg, \reg, \tmp		// actual cache line size
 	.endm
@@ -365,9 +366,9 @@
 /*
  * icache_line_size - get the safe I-cache line size across all CPUs
  */
-	.macro	icache_line_size, reg, tmp
-	read_ctr	\tmp
-	and		\tmp, \tmp, #0xf	// cache line size encoding
+	.macro	icache_line_size, reg, tmp, ctr
+	read_ctr	\ctr
+	and		\tmp, \ctr, #0xf	// cache line size encoding
 	mov		\reg, #4		// bytes per word
 	lsl		\reg, \reg, \tmp	// actual cache line size
 	.endm
@@ -408,13 +409,21 @@
  * 	size:		size of the region
  * 	Corrupts:	kaddr, size, tmp1, tmp2
  */
-	.macro dcache_by_line_op op, domain, kaddr, size, tmp1, tmp2
-	dcache_line_size \tmp1, \tmp2
+	.macro dcache_by_line_op op, domain, kaddr, size, tmp1, tmp2, tmp3
+	dcache_line_size \tmp1, \tmp2, \tmp3
 	add	\size, \kaddr, \size
 	sub	\tmp2, \tmp1, #1
 	bic	\kaddr, \kaddr, \tmp2
 9998:
-	.if	(\op == cvau || \op == cvac)
+	.if	(\op == cvau)
+alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
+	tbnz	\tmp3, #CTR_IDC_SHIFT, 9997f
+	dc	cvau, \kaddr
+alternative_else
+	dc	civac, \kaddr
+	nop
+alternative_endif
+	.elseif (\op == cvac)
 alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
 	dc	\op, \kaddr
 alternative_else
@@ -433,6 +442,7 @@
 	cmp	\kaddr, \size
 	b.lo	9998b
 	dsb	\domain
+9997:
 	.endm
 
 /*
@@ -441,10 +451,11 @@
  *
  * 	start, end:	virtual addresses describing the region
  *	label:		A label to branch to on user fault.
- * 	Corrupts:	tmp1, tmp2
+ * 	Corrupts:	tmp1, tmp2, tmp3
  */
-	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label
-	icache_line_size \tmp1, \tmp2
+	.macro invalidate_icache_by_line start, end, tmp1, tmp2, tmp3, label
+	icache_line_size \tmp1, \tmp2, \tmp3
+	tbnz    \tmp3, #CTR_DIC_SHIFT, 9996f
 	sub	\tmp2, \tmp1, #1
 	bic	\tmp2, \start, \tmp2
 9997:
@@ -454,6 +465,7 @@
 	b.lo	9997b
 	dsb	ish
 	isb
+9996:
 	.endm
 
 /*
diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index ea9bb4e..aea533b 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -22,6 +22,8 @@
 #define CTR_L1IP_MASK		3
 #define CTR_CWG_SHIFT		24
 #define CTR_CWG_MASK		15
+#define CTR_IDC_SHIFT		28
+#define CTR_DIC_SHIFT		29
 
 #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 29b1f87..f42bb5a 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -200,6 +200,8 @@ static int __init register_cpu_hwcaps_dumper(void)
 
 static const struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),	/* RAO */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 0),	/* DIC */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 0),	/* IDC */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 20, 4, 0),	/* ERG */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 758bde7..5764af8 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -24,6 +24,7 @@
 #include <asm/cpufeature.h>
 #include <asm/alternative.h>
 #include <asm/asm-uaccess.h>
+#include <asm/cache.h>
 
 /*
  *	flush_icache_range(start,end)
@@ -50,7 +51,12 @@ ENTRY(flush_icache_range)
  */
 ENTRY(__flush_cache_user_range)
 	uaccess_ttbr0_enable x2, x3, x4
-	dcache_line_size x2, x3
+	dcache_line_size x2, x3, x4
+alternative_if_not ARM64_WORKAROUND_CLEAN_CACHE
+	tbnz    x4, #CTR_IDC_SHIFT, 8f
+alternative_else
+	nop
+alternative_endif
 	sub	x3, x2, #1
 	bic	x4, x0, x3
 1:
@@ -60,7 +66,9 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	b.lo	1b
 	dsb	ish
 
-	invalidate_icache_by_line x0, x1, x2, x3, 9f
+8:
+	invalidate_icache_by_line x0, x1, x2, x3, x4, 9f
+
 	mov	x0, #0
 1:
 	uaccess_ttbr0_disable x1, x2
@@ -82,7 +90,7 @@ ENDPROC(__flush_cache_user_range)
 ENTRY(invalidate_icache_range)
 	uaccess_ttbr0_enable x2, x3, x4
 
-	invalidate_icache_by_line x0, x1, x2, x3, 2f
+	invalidate_icache_by_line x0, x1, x2, x3, x4, 2f
 	mov	x0, xzr
 1:
 	uaccess_ttbr0_disable x1, x2
@@ -102,7 +110,7 @@ ENDPROC(invalidate_icache_range)
  *	- size    - size in question
  */
 ENTRY(__flush_dcache_area)
-	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	dcache_by_line_op civac, sy, x0, x1, x2, x3, x4
 	ret
 ENDPIPROC(__flush_dcache_area)
 
@@ -116,7 +124,7 @@ ENDPIPROC(__flush_dcache_area)
  *	- size    - size in question
  */
 ENTRY(__clean_dcache_area_pou)
-	dcache_by_line_op cvau, ish, x0, x1, x2, x3
+	dcache_by_line_op cvau, ish, x0, x1, x2, x3, x4
 	ret
 ENDPROC(__clean_dcache_area_pou)
 
@@ -140,7 +148,7 @@ ENTRY(__inval_dcache_area)
  */
 __dma_inv_area:
 	add	x1, x1, x0
-	dcache_line_size x2, x3
+	dcache_line_size x2, x3, x4
 	sub	x3, x2, #1
 	tst	x1, x3				// end cache line aligned?
 	bic	x1, x1, x3
@@ -178,7 +186,7 @@ ENTRY(__clean_dcache_area_poc)
  *	- size    - size in question
  */
 __dma_clean_area:
-	dcache_by_line_op cvac, sy, x0, x1, x2, x3
+	dcache_by_line_op cvac, sy, x0, x1, x2, x3, x4
 	ret
 ENDPIPROC(__clean_dcache_area_poc)
 ENDPROC(__dma_clean_area)
@@ -193,7 +201,7 @@ ENDPROC(__dma_clean_area)
  *	- size    - size in question
  */
 ENTRY(__clean_dcache_area_pop)
-	dcache_by_line_op cvap, sy, x0, x1, x2, x3
+	dcache_by_line_op cvap, sy, x0, x1, x2, x3, x4
 	ret
 ENDPIPROC(__clean_dcache_area_pop)
 
@@ -206,7 +214,7 @@ ENDPIPROC(__clean_dcache_area_pop)
  *	- size    - size in question
  */
 ENTRY(__dma_flush_area)
-	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	dcache_by_line_op civac, sy, x0, x1, x2, x3, x4
 	ret
 ENDPIPROC(__dma_flush_area)
 
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
