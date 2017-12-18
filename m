From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH V2 3/7] arm64: kasan: Switch to using KASAN_SHADOW_OFFSET
Date: Mon, 18 Dec 2017 21:47:32 +0000
Message-ID: <20171218214736.13761-4-steve.capper@arm.com>
References: <20171218214736.13761-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D657C40D25
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U-wZMfOLTzKy for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Dec 2017 16:44:12 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E83D49DB9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Dec 2017 16:44:11 -0500 (EST)
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

KASAN_SHADOW_OFFSET is a constant that is supplied to gcc as a command
line argument and affects the codegen of the inline address sanetiser.

Essentially, for an example memory access:
	*ptr1 = val;
The compiler will insert logic similar to the below:
	shadowValue = *(ptr1 >> 3 + KASAN_SHADOW_OFFSET)
	if (somethingWrong(shadowValue))
		flagAnError();

As this code sequence is inserted into many places, and
KASAN_SHADOW_OFFSET is essentially baked into many places in the kernel
.text, the only sane thing we can do at compile time is to check that
the KASAN_SHADOW_OFFSET gives us a memory region that is valid,
otherwise BUILD_BUG on a discrepancy.

i.e. If we want to run a single kernel binary with multiple address
spaces, then we need to do this with KASAN_SHADOW_OFFSET fixed.

Thankfully, due to the way the KASAN_SHADOW_OFFSET is used to provide
shadow addresses we know that the end of the shadow region is constant
w.r.t. VA space size:
	KASAN_SHADOW_END = ~0 >> 3 + KASAN_SHADOW_OFFSET

This means that if we increase the size of the VA space, the KASAN
region expands upwards into the new space that is provided.

This patch removes the logic to compute the KASAN_SHADOW_OFFSET in the
arm64 Makefile, and instead we adopt the approach used by x86 to supply
offset values in kConfig. To help debug/develop future VA space changes,
the Makefile logic has been preserved in a script file in the arm64
Documentation folder.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 Documentation/arm64/kasan-offsets.sh | 17 +++++++++++++++++
 arch/arm64/Kconfig                   | 10 ++++++++++
 arch/arm64/Makefile                  |  7 -------
 arch/arm64/include/asm/kasan.h       | 21 ++++++++-------------
 arch/arm64/include/asm/memory.h      |  7 ++++---
 arch/arm64/mm/kasan_init.c           |  1 -
 6 files changed, 39 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/arm64/kasan-offsets.sh

diff --git a/Documentation/arm64/kasan-offsets.sh b/Documentation/arm64/kasan-offsets.sh
new file mode 100644
index 000000000000..d07a95518770
--- /dev/null
+++ b/Documentation/arm64/kasan-offsets.sh
@@ -0,0 +1,17 @@
+#!/bin/sh
+
+# Print out the KASAN_SHADOW_OFFSETS required to place the KASAN SHADOW
+# start address at the mid-point of the kernel VA space
+
+print_kasan_offset () {
+	printf "%02d\t" $1
+	printf "0x%08x00000000\n" $(( (0xffffffff & (-1 << ($1 - 1 - 32))) \
+			+ (1 << ($1 - 32 - 3)) \
+			- (1 << (64 - 32 - 3)) ))
+}
+
+printf "VABITS\tKASAN_SHADOW_OFFSET\n"
+print_kasan_offset 48
+print_kasan_offset 42
+print_kasan_offset 39
+print_kasan_offset 36
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c9a7e9e1414f..dc7e54522fa1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -272,6 +272,16 @@ config ARCH_SUPPORTS_UPROBES
 config ARCH_PROC_KCORE_TEXT
 	def_bool y
 
+config KASAN_SHADOW_OFFSET
+	hex
+	depends on KASAN
+	default 0xdfffa00000000000 if ARM64_VA_BITS_48
+	default 0xdfffd00000000000 if ARM64_VA_BITS_47
+	default 0xdffffe8000000000 if ARM64_VA_BITS_42
+	default 0xdfffffd000000000 if ARM64_VA_BITS_39
+	default 0xdffffffa00000000 if ARM64_VA_BITS_36
+	default 0xffffffffffffffff
+
 source "init/Kconfig"
 
 source "kernel/Kconfig.freezer"
diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 7eaff48d2a39..13cc9311ef7d 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -97,13 +97,6 @@ else
 TEXT_OFFSET := 0x00080000
 endif
 
-# KASAN_SHADOW_OFFSET = VA_START + (1 << (VA_BITS - 3)) - (1 << 61)
-# in 32-bit arithmetic
-KASAN_SHADOW_OFFSET := $(shell printf "0x%08x00000000\n" $$(( \
-			(0xffffffff & (-1 << ($(CONFIG_ARM64_VA_BITS) - 1 - 32))) \
-			+ (1 << ($(CONFIG_ARM64_VA_BITS) - 32 - 3)) \
-			- (1 << (64 - 32 - 3)) )) )
-
 export	TEXT_OFFSET GZFLAGS
 
 core-y		+= arch/arm64/kernel/ arch/arm64/mm/
diff --git a/arch/arm64/include/asm/kasan.h b/arch/arm64/include/asm/kasan.h
index e266f80e45b7..5f0d6130e53f 100644
--- a/arch/arm64/include/asm/kasan.h
+++ b/arch/arm64/include/asm/kasan.h
@@ -13,21 +13,16 @@
 /*
  * KASAN_SHADOW_START: beginning of the kernel virtual addresses.
  * KASAN_SHADOW_END: KASAN_SHADOW_START + 1/8 of kernel virtual addresses.
- */
-#define KASAN_SHADOW_START      (VA_START)
-#define KASAN_SHADOW_END        (KASAN_SHADOW_START + KASAN_SHADOW_SIZE)
-
-/*
- * This value is used to map an address to the corresponding shadow
- * address by the following formula:
- *     shadow_addr = (address >> 3) + KASAN_SHADOW_OFFSET;
  *
- * (1 << 61) shadow addresses - [KASAN_SHADOW_OFFSET,KASAN_SHADOW_END]
- * cover all 64-bits of virtual addresses. So KASAN_SHADOW_OFFSET
- * should satisfy the following equation:
- *      KASAN_SHADOW_OFFSET = KASAN_SHADOW_END - (1ULL << 61)
+ * We derive these values from KASAN_SHADOW_OFFSET and the size of the VA
+ * space.
+ *
+ * KASAN shadow addresses are derived from the following formula:
+ *	shadow_addr = (address >> 3) + KASAN_SHADOW_OFFSET;
+ *
  */
-#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1ULL << (64 - 3)))
+#define _KASAN_SHADOW_START(va)	(KASAN_SHADOW_END - (1UL << ((va) - 3)))
+#define KASAN_SHADOW_START      _KASAN_SHADOW_START(VA_BITS)
 
 void kasan_init(void);
 void kasan_copy_shadow(pgd_t *pgdir);
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 0a912eb3d74f..c52b90cdc583 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -70,7 +70,7 @@
 #define PAGE_OFFSET_END		(VA_START)
 #define KIMAGE_VADDR		(MODULES_END)
 #define MODULES_END		(MODULES_VADDR + MODULES_VSIZE)
-#define MODULES_VADDR		(VA_START + KASAN_SHADOW_SIZE)
+#define MODULES_VADDR		(KASAN_SHADOW_END)
 #define MODULES_VSIZE		(SZ_128M)
 #define VMEMMAP_START		(-VMEMMAP_SIZE)
 #define PCI_IO_END		(VMEMMAP_START - SZ_2M)
@@ -86,11 +86,12 @@
  * stack size when KASAN is in use.
  */
 #ifdef CONFIG_KASAN
-#define KASAN_SHADOW_SIZE	(UL(1) << (VA_BITS - 3))
 #define KASAN_THREAD_SHIFT	1
+#define KASAN_SHADOW_OFFSET	_AC(CONFIG_KASAN_SHADOW_OFFSET, UL)
+#define KASAN_SHADOW_END	((UL(1) << 61) + KASAN_SHADOW_OFFSET)
 #else
-#define KASAN_SHADOW_SIZE	(0)
 #define KASAN_THREAD_SHIFT	0
+#define KASAN_SHADOW_END	(VA_START)
 #endif
 
 #define MIN_THREAD_SHIFT	(14 + KASAN_THREAD_SHIFT)
diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index 5aef679e61c6..968535789d13 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -135,7 +135,6 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 /* The early shadow maps everything to a single page of zeroes */
 asmlinkage void __init kasan_early_init(void)
 {
-	BUILD_BUG_ON(KASAN_SHADOW_OFFSET != KASAN_SHADOW_END - (1UL << 61));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_START, PGDIR_SIZE));
 	BUILD_BUG_ON(!IS_ALIGNED(KASAN_SHADOW_END, PGDIR_SIZE));
 	kasan_pgd_populate(KASAN_SHADOW_START, KASAN_SHADOW_END, NUMA_NO_NODE,
-- 
2.11.0
