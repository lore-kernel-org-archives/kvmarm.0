From: Shanker Donthineni <shankerd@codeaurora.org>
Subject: [PATCH v2] arm64: Add support for new control bits CTR_EL0.DIC and
 CTR_EL0.IDC
Date: Mon, 19 Feb 2018 20:59:06 -0600
Message-ID: <1519095546-24420-1-git-send-email-shankerd@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6918402C7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 21:54:43 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5H3FrlFbjHCt for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Feb 2018 21:54:22 -0500 (EST)
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 52CC5402B8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Feb 2018 21:54:22 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Catalin Marinas <catalin.marinas@arm.com>, kvmarm <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Thomas Speier <tspeier@codeaurora.org>, Philip Elcan <pelcan@codeaurora.org>
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
Changes since v1:
  -Reworded commit text.
  -Used the alternatives framework as Catalin suggested.
  -Rebased on top of https://patchwork.kernel.org/patch/10227927/

 arch/arm64/Kconfig               | 21 +++++++++++++++++++
 arch/arm64/include/asm/cache.h   |  5 +++++
 arch/arm64/include/asm/cpucaps.h |  4 +++-
 arch/arm64/kernel/cpufeature.c   | 44 ++++++++++++++++++++++++++++++++++------
 arch/arm64/mm/cache.S            | 15 ++++++++++++++
 5 files changed, 82 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index f55fe5b..4061210 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1095,6 +1095,27 @@ config ARM64_RAS_EXTN
 	  and access the new registers if the system supports the extension.
 	  Platform RAS features may additionally depend on firmware support.
 
+config ARM64_CACHE_IDC
+	bool "Enable support for DCache clean PoU optimization"
+	default y
+	help
+	  The data cache clean to the point of unification is not required
+	  for instruction to be data coherence if CTR_EL0.IDC has value 1.
+
+	  Selecting this feature will allow the kernel to optimize the POU
+	  cache maintaince operations where it requires 'DC CVAU'.
+
+config ARM64_CACHE_DIC
+	bool "Enable support for ICache invalidation PoU optimization"
+	default y
+	help
+	  Instruction cache invalidation to the point of unification is not
+	  required for instruction to be data coherence if CTR_EL0.DIC has
+	  value 1.
+
+	  Selecting this feature will allow the kernel to optimize the POU
+	  cache maintaince operations where it requires 'IC IVAU'.
+
 endmenu
 
 config ARM64_SVE
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
index ff8a6e9..53a7266 100644
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
@@ -864,6 +864,22 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
+#ifdef CONFIG_ARM64_CACHE_IDC
+static bool has_cache_idc(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	return !!(read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_IDC_SHIFT));
+}
+#endif
+
+#ifdef CONFIG_ARM64_CACHE_DIC
+static bool has_cache_dic(const struct arm64_cpu_capabilities *entry,
+			  int __unused)
+{
+	return !!(read_sanitised_ftr_reg(SYS_CTR_EL0) & (1UL << CTR_DIC_SHIFT));
+}
+#endif
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
@@ -1100,6 +1116,22 @@ static int cpu_copy_el2regs(void *__unused)
 		.enable = cpu_clear_disr,
 	},
 #endif /* CONFIG_ARM64_RAS_EXTN */
+#ifdef CONFIG_ARM64_CACHE_IDC
+	{
+		.desc = "DCache clean to POU",
+		.capability = ARM64_HAS_CACHE_IDC,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cache_idc,
+	},
+#endif /* CONFIG_ARM64_CACHE_IDC */
+#ifdef CONFIG_ARM64_CACHE_DIC
+	{
+		.desc = "ICache invalidation to POU",
+		.capability = ARM64_HAS_CACHE_DIC,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cache_dic,
+	},
+#endif /* CONFIG_ARM64_CACHE_DIC */
 	{},
 };
 
diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
index 758bde7..7d37d71 100644
--- a/arch/arm64/mm/cache.S
+++ b/arch/arm64/mm/cache.S
@@ -50,6 +50,9 @@ ENTRY(flush_icache_range)
  */
 ENTRY(__flush_cache_user_range)
 	uaccess_ttbr0_enable x2, x3, x4
+alternative_if ARM64_HAS_CACHE_IDC
+	b	8f
+alternative_else_nop_endif
 	dcache_line_size x2, x3
 	sub	x3, x2, #1
 	bic	x4, x0, x3
@@ -60,6 +63,11 @@ user_alt 9f, "dc cvau, x4",  "dc civac, x4",  ARM64_WORKAROUND_CLEAN_CACHE
 	b.lo	1b
 	dsb	ish
 
+8:
+alternative_if ARM64_HAS_CACHE_DIC
+	mov	x0, #0
+	b	1f
+alternative_else_nop_endif
 	invalidate_icache_by_line x0, x1, x2, x3, 9f
 	mov	x0, #0
 1:
@@ -80,6 +88,10 @@ ENDPROC(__flush_cache_user_range)
  *	- end     - virtual end address of region
  */
 ENTRY(invalidate_icache_range)
+alternative_if ARM64_HAS_CACHE_DIC
+	mov	x0, xzr
+	ret
+alternative_else_nop_endif
 	uaccess_ttbr0_enable x2, x3, x4
 
 	invalidate_icache_by_line x0, x1, x2, x3, 2f
@@ -116,6 +128,9 @@ ENDPIPROC(__flush_dcache_area)
  *	- size    - size in question
  */
 ENTRY(__clean_dcache_area_pou)
+alternative_if ARM64_HAS_CACHE_IDC
+	ret
+alternative_else_nop_endif
 	dcache_by_line_op cvau, ish, x0, x1, x2, x3
 	ret
 ENDPROC(__clean_dcache_area_pou)
-- 
Qualcomm Datacenter Technologies, Inc. on behalf of the Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
