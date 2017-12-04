From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 12/12] arm64: mm: Add 48/52-bit kernel VA support
Date: Mon,  4 Dec 2017 14:13:13 +0000
Message-ID: <20171204141313.31604-13-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69D3A49D27
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:11:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nBT4nynXQtfJ for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:52 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2079149D95
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:43 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Add the option to use 52-bit VA support upon availability at boot. We
use the same KASAN_SHADOW_OFFSET for both 48 and 52 bit VA spaces as in
both cases the start and end of the KASAN shadow region are PGD aligned.

>From ID_AA64MMFR2, we check the LVA field on very early boot and set the
VA size, PGDIR_SHIFT and TCR.T[01]SZ values which then influence how the
rest of the memory system behaves.

Note that userspace addresses will still be capped out at 48-bit. More
patches are needed to deal with scenarios where the user provides
MMAP_FIXED hint and a high address to mmap.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/Kconfig              |  8 ++++++++
 arch/arm64/include/asm/memory.h |  5 +++++
 arch/arm64/mm/kasan_init.c      |  3 +++
 arch/arm64/mm/proc.S            | 21 +++++++++++++++++++++
 4 files changed, 37 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 143c453b06f1..be65dd4bb109 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -262,6 +262,7 @@ config PGTABLE_LEVELS
 	default 2 if ARM64_16K_PAGES && ARM64_VA_BITS_36
 	default 2 if ARM64_64K_PAGES && ARM64_VA_BITS_42
 	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48
+	default 3 if ARM64_64K_PAGES && ARM64_VA_BITS_48_52
 	default 3 if ARM64_4K_PAGES && ARM64_VA_BITS_39
 	default 3 if ARM64_16K_PAGES && ARM64_VA_BITS_47
 	default 4 if !ARM64_64K_PAGES && ARM64_VA_BITS_48
@@ -275,6 +276,7 @@ config ARCH_PROC_KCORE_TEXT
 config KASAN_SHADOW_OFFSET
 	hex
 	depends on KASAN
+	default 0xdfffa00000000000 if ARM64_VA_BITS_48_52
 	default 0xdfffa00000000000 if ARM64_VA_BITS_48
 	default 0xdfffd00000000000 if ARM64_VA_BITS_47
 	default 0xdffffe8000000000 if ARM64_VA_BITS_42
@@ -646,6 +648,10 @@ config ARM64_VA_BITS_47
 config ARM64_VA_BITS_48
 	bool "48-bit"
 
+config ARM64_VA_BITS_48_52
+	bool "48 or 52-bit (decided at boot time)"
+	depends on ARM64_64K_PAGES
+
 endchoice
 
 config ARM64_VA_BITS
@@ -655,9 +661,11 @@ config ARM64_VA_BITS
 	default 42 if ARM64_VA_BITS_42
 	default 47 if ARM64_VA_BITS_47
 	default 48 if ARM64_VA_BITS_48
+	default 48 if ARM64_VA_BITS_48_52
 
 config ARM64_VA_BITS_ALT
 	bool
+	default y if ARM64_VA_BITS_48_52
 	default n
 
 config CPU_BIG_ENDIAN
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 652ae83468b6..8530f8eb77da 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -72,6 +72,11 @@
 #define PCI_IO_START		(PCI_IO_END - PCI_IO_SIZE)
 #define FIXADDR_TOP		(PCI_IO_START - PGDIR_SIZE)
 #define VMEMMAP_START		(FIXADDR_START - VMEMMAP_SIZE)
+#define VA_BITS_MIN		(CONFIG_ARM64_VA_BITS)
+
+#ifdef CONFIG_ARM64_VA_BITS_48_52
+#define VA_BITS_ALT		(52)
+#endif
 
 #define KERNEL_START      _text
 #define KERNEL_END        _end
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 33f99e18e4ff..38c933c17f82 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -135,6 +135,9 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 /* The early shadow maps everything to a single page of zeroes */
 asmlinkage void __init kasan_early_init(void)
 {
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_ALT), PGDIR_SIZE));
+#endif
 	BUILD_BUG_ON(!IS_ALIGNED(_KASAN_SHADOW_START(VA_BITS_MIN), PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
 	kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE,
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 607a6ff0e205..42a91a4a1126 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -225,6 +225,14 @@ ENTRY(__cpu_setup)
 	 */
 	ldr	x10, =TCR_TxSZ(VA_BITS_MIN) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
 			TCR_TG_FLAGS | TCR_ASID16 | TCR_TBI0
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+	ldr_l	x9, vabits_actual
+	cmp	x9, #VA_BITS_ALT
+	b.ne	1f
+	ldr	x10, =TCR_TxSZ(VA_BITS_ALT) | TCR_CACHE_FLAGS | TCR_SMP_FLAGS | \
+			TCR_TG_FLAGS | TCR_ASID16 | TCR_TBI0
+1:
+#endif
 	tcr_set_idmap_t0sz	x10, x9
 
 	/*
@@ -251,9 +259,22 @@ ENTRY(__cpu_setup)
 ENDPROC(__cpu_setup)
 
 ENTRY(__setup_va_constants)
+#ifdef CONFIG_ARM64_VA_BITS_48_52
+	mrs_s	x5, SYS_ID_AA64MMFR2_EL1
+	and	x5, x5, #0xf << ID_AA64MMFR2_LVA_SHIFT
+	cmp	x5, #1 << ID_AA64MMFR2_LVA_SHIFT
+	b.ne	1f
+	mov	x0, #VA_BITS_ALT
+	mov	x1, TCR_T0SZ(VA_BITS_ALT)
+	mov	x2, #1 << (VA_BITS_ALT - PGDIR_SHIFT)
+	b	2f
+#endif
+
+1:
 	mov	x0, #VA_BITS_MIN
 	mov	x1, TCR_T0SZ(VA_BITS_MIN)
 	mov	x2, #1 << (VA_BITS_MIN - PGDIR_SHIFT)
+2:
 	str_l	x0, vabits_actual, x5
 	str_l	x1, idmap_t0sz, x5
 	str_l	x2, ptrs_per_pgd, x5
-- 
2.11.0
