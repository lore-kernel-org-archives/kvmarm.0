From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH v5] arm64: Add support for new control bits CTR_EL0.DIC and
 CTR_EL0.IDC
Date: Sat, 24 Feb 2018 06:09:53 -0600
Message-ID: <1519474193-25973-1-git-send-email-shankerd@codeaurora.org>
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
To: Will Deacon <will.deacon@arm.com>, Robin Murphy <robin.murphy@arm.com>, Mark Rutland <mark.rutland@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Philip Elcan <pelcan@codeaurora.org>, Shanker Donthineni <shankerd@codeaurora.org>, Vikram Sethi <vikrams@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

The DCache clean & ICache invalidation requirements for instructions
to be data coherence are discoverable through new fields in CTR_EL0.
The following two control bits DIC and IDC were defined for this
purpose. No need to perform point of unification cache maintenance
operations from software on systems where CPU caches are transparent.

This patch optimize the three functions __flush_cache_user_range(),
clean_dcache_area_pou() and invalidate_icache_range() if the hardware
reports CTR_EL0.IDC and/or CTR_EL0.IDC. Basically it skips the two
instructions 'DC CVAU' and 'IC IVAU', and the associated loop logic
in order to avoid the unnecessary overhead.

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
Changes since v4:
  -Moved patching ARM64_HAS_CACHE_DIC inside invalidate_icache_by_line
  -Removed 'dsb	ishst' for ARM64_HAS_CACHE_DIC as Mark suggested.

Changes since v3:
  -Added preprocessor guard CONFIG_xxx to code snippets in cache.S
  -Changed barrier attributes from ISH to ISHST.

Changes since v2:
  -Included barriers, DSB/ISB with DIC set, and DSB with IDC set.
  -Single Kconfig option.

Changes since v1:
  -Reworded commit text.
  -Used the alternatives framework as Catalin suggested.
  -Rebased on top of https://patchwork.kernel.org/patch/10227927/

 arch/arm64/Kconfig                 | 12 ++++++++++++
 arch/arm64/include/asm/assembler.h |  6 ++++++
 arch/arm64/include/asm/cache.h     |  5 +++++
 arch/arm64/include/asm/cpucaps.h   |  4 +++-
 arch/arm64/kernel/cpufeature.c     | 40 ++++++++++++++++++++++++++++++++------
 arch/arm64/mm/cache.S              | 13 +++++++++++++
 6 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f55fe5b..82b8053 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1095,6 +1095,18 @@ config ARM64_RAS_EXTN
 	  and access the new registers if the system supports the extension.
 	  Platform RAS features may additionally depend on firmware support.
 
+config ARM64_SKIP_CACHE_POU
+	bool "Enable support to skip cache POU operations"
+	default y
+	help
+	  Explicit point of unification cache operations can be eliminated
+	  in software if the hardware handles transparently. The new bits in
+	  CTR_EL0, CTR_EL0.DIC and CTR_EL0.IDC indicates the hardware
+	  capabilities of ICache and DCache POU requirements.
+
+	  Selecting this feature will allow the kernel to optimize the POU
+	  cache maintaince operations where it requires 'D{I}C C{I}VAU'
+
 endmenu
 
 config ARM64_SVE
diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index 3c78835..39f2274 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -444,6 +444,11 @@
  * 	Corrupts:	tmp1, tmp2
  */
 	.macro invalidate_icache_by_line start, end, tmp1, tmp2, label
+#ifdef CONFIG_ARM64_SKIP_CACHE_POU
+alternative_if ARM64_HAS_CACHE_DIC
+	b	9996f
+alternative_else_nop_endif
+#endif
 	icache_line_size \tmp1, \tmp2
 	sub	\tmp2, \tmp1, #1
 	bic	\tmp2, \start, \tmp2
@@ -453,6 +458,7 @@
 	cmp	\tmp2, \end
 	b.lo	9997b
 	dsb	ish
+9996:
 	isb
 	.endm
 
diff --git a/arch/arm64/include/asm/cache.h b/arch/arm64/include/asm/cache.h
index ea9bb4e..e22178b 100644
--- a/arch/arm64/include/asm/cache.h
+++ b/arch/arm64/include/asm/cache.h
@@ -20,8 +20,13 @@
 
 #define CTR_L1IP_SHIFT		14
 #define CTR_L1IP_MASK		3
+#define CTR_DMLINE_SHIFT	16
+#define CTR_ERG_SHIFT		20
 #define CTR_CWG_SHIFT		24
 #define CTR_CWG_MASK		15
+#define CTR_IDC_SHIFT		28
+#define CTR_DIC_SHIFT		29
+#define CTR_B31_SHIFT		31
 
 #define CTR_L1IP(ctr)		(((ctr) >> CTR_L1IP_SHIFT) & CTR_L1IP_MASK)
 
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index bb26382..8dd42ae 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -45,7 +45,9 @@
 #define ARM64_HARDEN_BRANCH_PREDICTOR		24
 #define ARM64_HARDEN_BP_POST_GUEST_EXIT		25
 #define ARM64_HAS_RAS_EXTN			26
+#define ARM64_HAS_CACHE_IDC			27
+#define ARM64_HAS_CACHE_DIC			28
 
-#define ARM64_NCAPS				27
+#define ARM64_NCAPS				29
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index ff8a6e9..aea1484 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -199,12 +199,12 @@ static int __init register_cpu_hwcaps_dumper(void)
 };
 
 static const struct arm64_ftr_bits ftr_ctr[] = {
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1),		/* RES1 */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 29, 1, 1),	/* DIC */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 28, 1, 1),	/* IDC */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 24, 4, 0),	/* CWG */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, 20, 4, 0),	/* ERG */
-	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, 16, 4, 1),	/* DminLine */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, CTR_B31_SHIFT, 1, 1),         /* RES1 */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DIC_SHIFT, 1, 1),    /* DIC */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_IDC_SHIFT, 1, 1),    /* IDC */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_CWG_SHIFT, 4, 0),   /* CWG */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_SAFE, CTR_ERG_SHIFT, 4, 0),   /* ERG */
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_DMLINE_SHIFT, 4, 1), /* DminLine */
 	/*
 	 * Linux can handle differing I-cache policies. Userspace JITs will
 	 * make use of *minLine.
@@ -864,6 +864,20 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
+#ifdef CONFIG_ARM64_SKIP_CACHE_POU
+static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_IDC_SHIFT));
+}
+
+static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	return (read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_DIC_SHIFT));
+}
+#endif
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
@@ -1100,6 +1114,20 @@ static int cpu_copy_el2regs(void *__unused)
 		.enable = cpu_clear_disr,
 	},
 #endif /* CONFIG_ARM64_RAS_EXTN */
+#ifdef CONFIG_ARM64_SKIP_CACHE_POU
+	{
+		.desc = "Skip D-Cache maintenance 'DC CVAU' (CTR_EL0.IDC=1)",
+		.capability = ARM64_HAS_CACHE_IDC,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cache_idc,
+	},
+	{
+		.desc = "Skip I-Cache maintenance 'IC IVAU' (CTR_EL0.DIC=1)",
+		.capability = ARM64_HAS_CACHE_DIC,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cache_dic,
+	},
+#endif /* CONFIG_ARM64_SKIP_CACHE_POU */
 	{},
 };
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 758bde7..d8d7a32 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -50,6 +50,12 @@ ENTRY(flush_icache_range)
  */
 ENTRY(__flush_cache_user_range)
 	uaccess_ttbr0_enable x2, x3, x4
+#ifdef CONFIG_ARM64_SKIP_CACHE_POU
+alternative_if ARM64_HAS_CACHE_IDC
+	dsb	ishst
+	b	8f
+alternative_else_nop_endif
+#endif
 	dcache_line_size x2, x3
 	sub	x3, x2, #1
 	bic	x4, x0, x3
@@ -60,6 +66,7 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	b.lo	1b
 	dsb	ish
 
+8:
 	invalidate_icache_by_line x0, x1, x2, x3, 9f
 	mov	x0, #0
 1:
@@ -116,6 +123,12 @@ ENDPIPROC(__flush_dcache_area)
  *	- size    - size in question
  */
 ENTRY(__clean_dcache_area_pou)
+#ifdef CONFIG_ARM64_SKIP_CACHE_POU
+alternative_if ARM64_HAS_CACHE_IDC
+	dsb	ishst
+	ret
+alternative_else_nop_endif
+#endif
 	dcache_by_line_op cvau, ish, x0, x1, x2, x3
 	ret
 ENDPROC(__clean_dcache_area_pou)
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
