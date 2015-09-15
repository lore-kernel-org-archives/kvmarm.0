From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>
Subject: [PATCH 14/15] arm64: Add 16K page size support
Date: Tue, 15 Sep 2015 16:41:23 +0100
Message-ID: <1442331684-28818-15-git-send-email-suzuki.poulose@arm.com>
References: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 56D3C418D8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sb5Ku89jxXmW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2015 11:40:49 -0400 (EDT)
Received: from eu-smtp-delivery-143.mimecast.com
 (eu-smtp-delivery-143.mimecast.com [146.101.78.143])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCEDA419A9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2015 11:40:47 -0400 (EDT)
In-Reply-To: <1442331684-28818-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: kvm@vger.kernel.org, ard.biesheuvel@linaro.org, Marc.Zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: "Suzuki K. Poulose" <suzuki.poulose@arm.com>

This patch turns on the 16K page support in the kernel. We
support 48bit VA (4 level page tables) and 47bit VA (3 level
page tables).

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Suzuki K. Poulose <suzuki.poulose@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/Kconfig                   |   25 ++++++++++++++++++++-----
 arch/arm64/include/asm/fixmap.h      |    4 +++-
 arch/arm64/include/asm/kvm_arm.h     |   12 ++++++++++++
 arch/arm64/include/asm/page.h        |    2 ++
 arch/arm64/include/asm/sysreg.h      |    2 ++
 arch/arm64/include/asm/thread_info.h |    2 ++
 arch/arm64/kernel/head.S             |    7 ++++++-
 arch/arm64/mm/proc.S                 |    4 +++-
 8 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 83bca48..2253819 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -171,7 +171,8 @@ config PGTABLE_LEVELS
 	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
 	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
 	default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
-	default 4 if ARM64_4K_PAGES && ARM64_VA_BITS_48
+	default 3 if ARM64_16K_PAGES && ARM64_VA_BITS_47
+	default 4 if !ARM64_64K_PAGES && ARM64_VA_BITS_48
 
 source "init/Kconfig"
 
@@ -345,6 +346,13 @@ config ARM64_4K_PAGES
 	help
 	  This feature enables 4KB pages support.
 
+config ARM64_16K_PAGES
+	bool "16KB"
+	help
+	  The system will use 16KB pages support. AArch32 emulation
+	  requires applications compiled with 16K(or multiple of 16K)
+	  aligned segments.
+
 config ARM64_64K_PAGES
 	bool "64KB"
 	help
@@ -358,6 +366,7 @@ endchoice
 choice
 	prompt "Virtual address space size"
 	default ARM64_VA_BITS_39 if ARM64_4K_PAGES
+	default ARM64_VA_BITS_47 if ARM64_16K_PAGES
 	default ARM64_VA_BITS_42 if ARM64_64K_PAGES
 	help
 	  Allows choosing one of multiple possible virtual address
@@ -372,6 +381,10 @@ config ARM64_VA_BITS_42
 	bool "42-bit"
 	depends on ARM64_64K_PAGES
 
+config ARM64_VA_BITS_47
+	bool "47-bit"
+	depends on ARM64_16K_PAGES
+
 config ARM64_VA_BITS_48
 	bool "48-bit"
 
@@ -381,6 +394,7 @@ config ARM64_VA_BITS
 	int
 	default 39 if ARM64_VA_BITS_39
 	default 42 if ARM64_VA_BITS_42
+	default 47 if ARM64_VA_BITS_47
 	default 48 if ARM64_VA_BITS_48
 
 config CPU_BIG_ENDIAN
@@ -451,7 +465,7 @@ config ARCH_WANT_GENERAL_HUGETLB
 	def_bool y
 
 config ARCH_WANT_HUGE_PMD_SHARE
-	def_bool y if ARM64_4K_PAGES
+	def_bool y if ARM64_4K_PAGES || ARM64_16K_PAGES
 
 config HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	def_bool y
@@ -488,6 +502,7 @@ config XEN
 config FORCE_MAX_ZONEORDER
 	int
 	default "14" if (ARM64_64K_PAGES && TRANSPARENT_HUGEPAGE)
+	default "12" if (ARM64_16K_PAGES && TRANSPARENT_HUGEPAGE)
 	default "11"
 
 menuconfig ARMV8_DEPRECATED
@@ -674,9 +689,9 @@ config COMPAT
 	  the user helper functions, VFP support and the ptrace interface are
 	  handled appropriately by the kernel.
 
-	  If you also enabled CONFIG_ARM64_64K_PAGES, please be aware that you
-	  will only be able to execute AArch32 binaries that were compiled with
-	  64k aligned segments.
+	  If you use a page size other than 4KB(i.e, 16KB or 64KB), please be aware
+	  that you will only be able to execute AArch32 binaries that were compiled
+	  with page size aligned segments.
 
 	  If you want to execute 32-bit userspace applications, say Y.
 
diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 8b9884c..a294c70 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -55,8 +55,10 @@ enum fixed_addresses {
 	 * Temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 */
-#ifdef CONFIG_ARM64_64K_PAGES
+#if	defined(CONFIG_ARM64_64K_PAGES)
 #define NR_FIX_BTMAPS		4
+#elif	defined (CONFIG_ARM64_16K_PAGES)
+#define NR_FIX_BTMAPS		16
 #else
 #define NR_FIX_BTMAPS		64
 #endif
diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 699554d..b28a06e 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -113,6 +113,7 @@
 #define VTCR_EL2_TG0_MASK	(3 << 14)
 #define VTCR_EL2_TG0_4K		(0 << 14)
 #define VTCR_EL2_TG0_64K	(1 << 14)
+#define VTCR_EL2_TG0_16K	(2 << 14)
 #define VTCR_EL2_SH0_MASK	(3 << 12)
 #define VTCR_EL2_SH0_INNER	(3 << 12)
 #define VTCR_EL2_ORGN0_MASK	(3 << 10)
@@ -134,6 +135,8 @@
  *
  * Note that when using 4K pages, we concatenate two first level page tables
  * together.
+ * With 16K pages, we concatenate 16 first level page tables and enter at
+ * level 2.
  *
  * The magic numbers used for VTTBR_X in this patch can be found in Tables
  * D4-23 and D4-25 in ARM DDI 0487A.b.
@@ -151,6 +154,15 @@
 #define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1 | \
 				 VTCR_EL2_COMMON_BITS)
 #define VTTBR_X		(38 - VTCR_EL2_T0SZ_40B)
+#elif defined(CONFIG_ARM64_16K_PAGES)
+/*
+ * Stage2 translation configuration:
+ * 16kB pages (TG0 = 2)
+ * 2 level page tables (SL0 = 1)
+ */
+#define VTCR_EL2_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1 | \
+				 VTCR_EL2_COMMON_BITS)
+#define VTTBR_X			(42 - VTCR_EL2_T0SZ_40B)
 #else
 /*
  * Stage2 translation configuration:
diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
index 3c9ce8c..6aee732 100644
--- a/arch/arm64/include/asm/page.h
+++ b/arch/arm64/include/asm/page.h
@@ -22,6 +22,8 @@
 /* PAGE_SHIFT determines the page size */
 #ifdef CONFIG_ARM64_64K_PAGES
 #define PAGE_SHIFT		16
+#elif defined(CONFIG_ARM64_16K_PAGES)
+#define PAGE_SHIFT		14
 #else
 #define PAGE_SHIFT		12
 #endif
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index e01d323..310592c 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -89,8 +89,10 @@ static inline void config_sctlr_el1(u32 clear, u32 set)
 
 #define ID_AA64MMFR0_TGran4_SHIFT	28
 #define ID_AA64MMFR0_TGran64_SHIFT	24
+#define ID_AA64MMFR0_TGran16_SHIFT	20
 
 #define ID_AA64MMFR0_TGran4_ENABLED	0x0
 #define ID_AA64MMFR0_TGran64_ENABLED	0x0
+#define ID_AA64MMFR0_TGran16_ENABLED	0x1
 
 #endif	/* __ASM_SYSREG_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index d9c8c9f..338a4ac 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -25,6 +25,8 @@
 
 #ifdef CONFIG_ARM64_4K_PAGES
 #define THREAD_SIZE_ORDER	2
+#elif defined(CONFIG_ARM64_16K_PAGES)
+#define THREAD_SIZE_ORDER	0
 #endif
 
 #define THREAD_SIZE		16384
diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
index 0cb04db..959100b 100644
--- a/arch/arm64/kernel/head.S
+++ b/arch/arm64/kernel/head.S
@@ -614,7 +614,12 @@ ENDPROC(__secondary_switched)
 #define ID_AA64MMFR0_TGran_SHIFT	ID_AA64MMFR0_TGran64_SHIFT
 #define ID_AA64MMFR0_TGran_ENABLED	ID_AA64MMFR0_TGran64_ENABLED
 
-#else
+#elif	defined(CONFIG_ARM64_16K_PAGES)
+
+#define ID_AA64MMFR0_TGran_SHIFT	ID_AA64MMFR0_TGran16_SHIFT
+#define ID_AA64MMFR0_TGran_ENABLED	ID_AA64MMFR0_TGran16_ENABLED
+
+#elif	defined(CONFIG_ARM64_4K_PAGES)
 
 #define ID_AA64MMFR0_TGran_SHIFT	ID_AA64MMFR0_TGran4_SHIFT
 #define ID_AA64MMFR0_TGran_ENABLED	ID_AA64MMFR0_TGran4_ENABLED
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index e4ee7bd..994bf7b 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -30,7 +30,9 @@
 
 #ifdef CONFIG_ARM64_64K_PAGES
 #define TCR_TG_FLAGS	TCR_TG0_64K | TCR_TG1_64K
-#else
+#elif defined(CONFIG_ARM64_16K_PAGES)
+#define TCR_TG_FLAGS	TCR_TG0_16K | TCR_TG1_16K
+#else /* CONFIG_ARM64_4K_PAGES */
 #define TCR_TG_FLAGS	TCR_TG0_4K | TCR_TG1_4K
 #endif
 
-- 
1.7.9.5
