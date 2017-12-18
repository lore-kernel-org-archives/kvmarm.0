From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH V2 7/7] arm64: mm: Add 48/52-bit kernel VA support
Date: Mon, 18 Dec 2017 21:47:36 +0000
Message-ID: <20171218214736.13761-8-steve.capper@arm.com>
References: <20171218214736.13761-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 521D249DB8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:18 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nOKvBe1l7T7l for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 16:44:17 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D68B949DB7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:16 -0500 (EST)
In-Reply-To: <20171218214736.13761-1-steve.capper@arm.com>
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
 arch/arm64/include/asm/memory.h |  4 ++++
 arch/arm64/mm/proc.S            | 13 +++++++++++++
 3 files changed, 25 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 5a42edc18718..3fa5342849dc 100644
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
@@ -656,6 +658,10 @@ config ARM64_VA_BITS_47
 config ARM64_VA_BITS_48
 	bool "48-bit"
 
+config ARM64_VA_BITS_48_52
+	bool "48 or 52-bit (decided at boot time)"
+	depends on ARM64_64K_PAGES
+
 endchoice
 
 config ARM64_VA_BITS
@@ -665,9 +671,11 @@ config ARM64_VA_BITS
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
index 2c11df336109..417b70bb50be 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -75,6 +75,10 @@
 #define _VA_START(va)		(UL(0xffffffffffffffff) - \
 				(UL(1) << ((va) - 1)) + 1)
 
+#ifdef CONFIG_ARM64_VA_BITS_48_52
+#define VA_BITS_ALT		(52)
+#endif
+
 #define KERNEL_START      _text
 #define KERNEL_END        _end
 
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 16564324c957..42a91a4a1126 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -259,9 +259,22 @@ ENTRY(__cpu_setup)
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
