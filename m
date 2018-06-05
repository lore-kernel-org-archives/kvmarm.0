From: Abbott Liu <liuwenliang@huawei.com>
Subject: [PATCH v5 4/6] Define the virtual space of KASan's shadow region
Date: Tue, 5 Jun 2018 14:14:14 +0800
Message-ID: <20180605061416.18690-5-liuwenliang__14184.5481041402$1528180530$gmane$org@huawei.com>
References: <20180605061416.18690-1-liuwenliang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B939A49F7F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QCl55TLknQQJ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 Jun 2018 02:24:43 -0400 (EDT)
Received: from huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BA7414A0C8
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 Jun 2018 02:24:42 -0400 (EDT)
In-Reply-To: <20180605061416.18690-1-liuwenliang@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: aryabinin@virtuozzo.com, glider@google.com, dvyukov@google.com, corbet@lwn.net, linux@armlinux.org.uk, christoffer.dall@arm.com, marc.zyngier@arm.com, arnd@arndb.de, nicolas.pitre@linaro.org, vladimir.murzin@arm.com, keescook@chromium.org, jinb.park7@gmail.com, alexandre.belloni@bootlin.com, ard.biesheuvel@linaro.org, daniel.lezcano@linaro.org, pombredanne@nexb.com, kstewart@linuxfoundation.org, liuwenliang@huawei.com, rob@landley.net, gregkh@linuxfoundation.org, f.fainelli@gmail.com, mawilcox@microsoft.com, akpm@linux-foundation.org, mark.rutland@arm.com, catalin.marinas@arm.com, yamada.masahiro@socionext.com, alexander.levin@verizon.com, tglx@linutronix.de, thgarnie@google.com, dhowells@redhat.com, geert@linux-m68k.org, andre.przywara@arm.com, julien.thierry@arm.com, drjones@redhat.com, philip@cog.sys
Cc: a.ryabinin@samsung.com, ryabinin.a.a@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

Define KASAN_SHADOW_OFFSET,KASAN_SHADOW_START and KASAN_SHADOW_END for arm
kernel address sanitizer.

     +----+ 0xffffffff
     |    |
     |    |
     |    |
     +----+ CONFIG_PAGE_OFFSET
     |    |     |    | |->  module virtual address space area.
     |    |/
     +----+ MODULE_VADDR = KASAN_SHADOW_END
     |    |     |    | |-> the shadow area of kernel virtual address.
     |    |/
     +----+ TASK_SIZE(start of kernel space) = KASAN_SHADOW_START  the
     |    |\  shadow address of MODULE_VADDR
     |    | ---------------------+
     |    |                      |
     +    + KASAN_SHADOW_OFFSET  |-> the user space area. Kernel address
     |    |                      |    sanitizer do not use this space.
     |    | ---------------------+
     |    |/
     ------ 0

1)KASAN_SHADOW_OFFSET:
  This value is used to map an address to the corresponding shadow
address by the following formula:
shadow_addr = (address >> 3) + KASAN_SHADOW_OFFSET;

2)KASAN_SHADOW_START
  This value is the MODULE_VADDR's shadow address. It is the start
of kernel virtual space.

3)KASAN_SHADOW_END
  This value is the 0x100000000's shadow address. It is the end of
kernel addresssanitizer's shadow area. It is also the start of the
module area.

When enable kasan, the definition of TASK_SIZE is not an an 8-bit
rotated constant, so we need to modify the TASK_SIZE access code
in the *.s file.

Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Reported-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Tested-by: Joel Stanley <joel@jms.id.au>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
---
 arch/arm/include/asm/kasan_def.h | 64 ++++++++++++++++++++++++++++++++++++++++
 arch/arm/include/asm/memory.h    |  5 ++++
 arch/arm/kernel/entry-armv.S     |  5 ++--
 arch/arm/kernel/entry-common.S   |  9 ++++--
 arch/arm/mm/init.c               |  6 ++++
 arch/arm/mm/mmu.c                |  7 ++++-
 6 files changed, 90 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/include/asm/kasan_def.h

diff --git a/arch/arm/include/asm/kasan_def.h b/arch/arm/include/asm/kasan_def.h
new file mode 100644
index 0000000..7b7f424
--- /dev/null
+++ b/arch/arm/include/asm/kasan_def.h
@@ -0,0 +1,64 @@
+/*
+ *  arch/arm/include/asm/kasan_def.h
+ *
+ *  Copyright (c) 2018 Huawei Technologies Co., Ltd.
+ *
+ *  Author: Abbott Liu <liuwenliang@huawei.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef __ASM_KASAN_DEF_H
+#define __ASM_KASAN_DEF_H
+
+#ifdef CONFIG_KASAN
+
+/*
+ *    +----+ 0xffffffff
+ *    |    |
+ *    |    |
+ *    |    |
+ *    +----+ CONFIG_PAGE_OFFSET
+ *    |    |\
+ *    |    | |->  module virtual address space area.
+ *    |    |/
+ *    +----+ MODULE_VADDR = KASAN_SHADOW_END
+ *    |    |\
+ *    |    | |-> the shadow area of kernel virtual address.
+ *    |    |/
+ *    +----+ TASK_SIZE(start of kernel space) = KASAN_SHADOW_START  the
+ *    |    |\  shadow address of MODULE_VADDR
+ *    |    | ---------------------+
+ *    |    |                      |
+ *    +    + KASAN_SHADOW_OFFSET  |-> the user space area. Kernel address
+ *    |    |                      |    sanitizer do not use this space.
+ *    |    | ---------------------+
+ *    |    |/
+ *    ------ 0
+ *
+ *1)KASAN_SHADOW_OFFSET:
+ *    This value is used to map an address to the corresponding shadow
+ * address by the following formula:
+ * shadow_addr = (address >> 3) + KASAN_SHADOW_OFFSET;
+ *
+ * 2)KASAN_SHADOW_START
+ *     This value is the MODULE_VADDR's shadow address. It is the start
+ * of kernel virtual space.
+ *
+ * 3) KASAN_SHADOW_END
+ *   This value is the 0x100000000's shadow address. It is the end of
+ * kernel addresssanitizer's shadow area. It is also the start of the
+ * module area.
+ *
+ */
+
+#define KASAN_SHADOW_OFFSET     (KASAN_SHADOW_END - (1<<29))
+
+#define KASAN_SHADOW_START      ((KASAN_SHADOW_END >> 3) + KASAN_SHADOW_OFFSET)
+
+#define KASAN_SHADOW_END        (UL(CONFIG_PAGE_OFFSET) - UL(SZ_16M))
+
+#endif
+#endif
diff --git a/arch/arm/include/asm/memory.h b/arch/arm/include/asm/memory.h
index ed8fd0d..6e099a5 100644
--- a/arch/arm/include/asm/memory.h
+++ b/arch/arm/include/asm/memory.h
@@ -21,6 +21,7 @@
 #ifdef CONFIG_NEED_MACH_MEMORY_H
 #include <mach/memory.h>
 #endif
+#include <asm/kasan_def.h>
 
 /* PAGE_OFFSET - the virtual address of the start of the kernel image */
 #define PAGE_OFFSET		UL(CONFIG_PAGE_OFFSET)
@@ -31,7 +32,11 @@
  * TASK_SIZE - the maximum size of a user space task.
  * TASK_UNMAPPED_BASE - the lower boundary of the mmap VM area
  */
+#ifndef CONFIG_KASAN
 #define TASK_SIZE		(UL(CONFIG_PAGE_OFFSET) - UL(SZ_16M))
+#else
+#define TASK_SIZE		(KASAN_SHADOW_START)
+#endif
 #define TASK_UNMAPPED_BASE	ALIGN(TASK_SIZE / 3, SZ_16M)
 
 /*
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 1752033..b4de9e4 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -183,7 +183,7 @@ ENDPROC(__und_invalid)
 
 	get_thread_info tsk
 	ldr	r0, [tsk, #TI_ADDR_LIMIT]
-	mov	r1, #TASK_SIZE
+	ldr	r1, =TASK_SIZE
 	str	r1, [tsk, #TI_ADDR_LIMIT]
 	str	r0, [sp, #SVC_ADDR_LIMIT]
 
@@ -437,7 +437,8 @@ ENDPROC(__fiq_abt)
 	@ if it was interrupted in a critical region.  Here we
 	@ perform a quick test inline since it should be false
 	@ 99.9999% of the time.  The rest is done out of line.
-	cmp	r4, #TASK_SIZE
+	ldr	r0, =TASK_SIZE
+	cmp	r4, r0
 	blhs	kuser_cmpxchg64_fixup
 #endif
 #endif
diff --git a/arch/arm/kernel/entry-common.S b/arch/arm/kernel/entry-common.S
index 3c4f887..78046de 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -51,7 +51,8 @@ ret_fast_syscall:
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr	r1, =TASK_SIZE
+	cmp	r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -81,7 +82,8 @@ ret_fast_syscall:
 	str	r0, [sp, #S_R0 + S_OFF]!	@ save returned r0
 	disable_irq_notrace			@ disable interrupts
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr     r1, =TASK_SIZE
+	cmp     r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -116,7 +118,8 @@ ret_slow_syscall:
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr     r1, =TASK_SIZE
+	cmp	r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]
 	tst	r1, #_TIF_WORK_MASK
diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index c186474..9320cf5 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -538,6 +538,9 @@ void __init mem_init(void)
 #ifdef CONFIG_MODULES
 			"    modules : 0x%08lx - 0x%08lx   (%4ld MB)\n"
 #endif
+#ifdef CONFIG_KASAN
+			"    kasan   : 0x%08lx - 0x%08lx   (%4ld MB)\n"
+#endif
 			"      .text : 0x%p" " - 0x%p" "   (%4td kB)\n"
 			"      .init : 0x%p" " - 0x%p" "   (%4td kB)\n"
 			"      .data : 0x%p" " - 0x%p" "   (%4td kB)\n"
@@ -558,6 +561,9 @@ void __init mem_init(void)
 #ifdef CONFIG_MODULES
 			MLM(MODULES_VADDR, MODULES_END),
 #endif
+#ifdef CONFIG_KASAN
+			MLM(KASAN_SHADOW_START, KASAN_SHADOW_END),
+#endif
 
 			MLK_ROUNDUP(_text, _etext),
 			MLK_ROUNDUP(__init_begin, __init_end),
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index e46a6a4..f5aa1de 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1251,9 +1251,14 @@ static inline void prepare_page_table(void)
 	/*
 	 * Clear out all the mappings below the kernel image.
 	 */
-	for (addr = 0; addr < MODULES_VADDR; addr += PMD_SIZE)
+	for (addr = 0; addr < TASK_SIZE; addr += PMD_SIZE)
 		pmd_clear(pmd_off_k(addr));
 
+#ifdef CONFIG_KASAN
+	/*TASK_SIZE ~ MODULES_VADDR is the KASAN's shadow area -- skip over it*/
+	addr = MODULES_VADDR;
+#endif
+
 #ifdef CONFIG_XIP_KERNEL
 	/* The XIP kernel is mapped in the module area -- skip over it */
 	addr = ((unsigned long)_exiprom + PMD_SIZE - 1) & PMD_MASK;
-- 
2.9.0
