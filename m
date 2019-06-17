Return-Path: <SRS0=wAvJ=UQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DF25C31E5C
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 22:12:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 26D8D2080A
	for <kvmarm@archiver.kernel.org>; Mon, 17 Jun 2019 22:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XyDwQXzN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 26D8D2080A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0D0F4A521;
	Mon, 17 Jun 2019 18:12:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Vdzu3lQV7GxO; Mon, 17 Jun 2019 18:12:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 652764A4C0;
	Mon, 17 Jun 2019 18:12:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 871904A4A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 18:12:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IZ5oaSD7j+w2 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Jun 2019 18:12:30 -0400 (EDT)
Received: from mail-pg1-f193.google.com (mail-pg1-f193.google.com
 [209.85.215.193])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E0A94A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 18:12:30 -0400 (EDT)
Received: by mail-pg1-f193.google.com with SMTP id v11so6522698pgl.5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Jun 2019 15:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=7DrG5+RQG0FCVM4nQANaF2hEes9VxzWs9d/hV5PsNqg=;
 b=XyDwQXzNnEij5TW9Icqwv/CiWNVb5T+NWkPGhFjfrSpTK2s8KmaXHMuwW5UXiSQy/Y
 hsHRRWSHbDpn/fZmM9n89xSTJEFW15xamSdjj2kfvj48wHQDBul+Teb7O076bKCSS2nZ
 C5GncPJXbGCAQEsP5eT/pDsHSal7Xkd5Wefa0xjxYnidkLCQwAC9QI+Ki0snnNa4XWRp
 Pq8+H1mOEkReVCWrjLpMYIpWKAKFRrymvAFDjDYH2IMUvA2ORvMBSwjmPZZDmQZE42rT
 Bz2t0TaVE4AQZkIvPvy7Yhy7Bi+gvFSdHRvbnLGkjpYFFkQRgTfOG9lC6rXugAz3SflF
 G7gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
 :references;
 bh=7DrG5+RQG0FCVM4nQANaF2hEes9VxzWs9d/hV5PsNqg=;
 b=lJZ5dBiC2Fsl+qBBuemp5ZQPD5QPu9xC6DkRvvVOZrS7TXIr2RKQFDCuG24c7JIpI8
 Crw3uBoLoLUQTcKutsLxHNgP37WbNCd9uSKszhUy5j2H6JGmDUWdosg8YqWw7m3vGpk8
 +L83hZe0rfCazJbi2SoeT9kBWBJAHJLs27wJSWgAjYz1soNAWg6nbvao5bniAegWmmE/
 CGHnqekdg4Nc4qjiBi0kAkCjVVsnBxeqVjgr1jwcEGS3bbAmSRNG0jctlUanYbmgAe67
 c1+nAvFcZfugIzMXKdJYSKtCFHamOMmpXV9NY6uQG7n40Ts8W1NrFJ2mESEUXp4f8a4Z
 qSRA==
X-Gm-Message-State: APjAAAVktJPLPBlSLLQw8H5DWVP41NbBGtg8qf0edBgf8AIsQb5MQTJy
 9unsb8i1fPKOE/PnJycD1n0=
X-Google-Smtp-Source: APXvYqzALF9X8zx3ACx38xgnCez+oxMQ0D3gKMg8/imffldM/5SvhkikVjpppW+WO/yVXbAhtFw/vQ==
X-Received: by 2002:a62:1d11:: with SMTP id d17mr24476871pfd.249.1560809510618; 
 Mon, 17 Jun 2019 15:11:50 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
 by smtp.gmail.com with ESMTPSA id s129sm12551020pfb.186.2019.06.17.15.11.48
 (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
 Mon, 17 Jun 2019 15:11:49 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v6 4/6] ARM: Define the virtual space of KASan's shadow region
Date: Mon, 17 Jun 2019 15:11:32 -0700
Message-Id: <20190617221134.9930-5-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190617221134.9930-1-f.fainelli@gmail.com>
References: <20190617221134.9930-1-f.fainelli@gmail.com>
Cc: alexandre.belloni@bootlin.com, mhocko@suse.com, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, dhowells@redhat.com,
 yamada.masahiro@socionext.com, ryabinin.a.a@gmail.com, glider@google.com,
 kvmarm@lists.cs.columbia.edu, Florian Fainelli <f.fainelli@gmail.com>,
 corbet@lwn.net, Abbott Liu <liuwenliang@huawei.com>, daniel.lezcano@linaro.org,
 linux@armlinux.org.uk, kasan-dev@googlegroups.com,
 bcm-kernel-feedback-list@broadcom.com,
 Andrey Ryabinin <aryabinin@virtuozzo.com>, keescook@chromium.org,
 arnd@arndb.de, marc.zyngier@arm.com, andre.przywara@arm.com,
 philip@cog.systems, jinb.park7@gmail.com, tglx@linutronix.de,
 dvyukov@google.com, nico@fluxnic.net, gregkh@linuxfoundation.org,
 ard.biesheuvel@linaro.org, linux-doc@vger.kernel.org, geert@linux-m68k.org,
 rob@landley.net, pombredanne@nexb.com, akpm@linux-foundation.org,
 thgarnie@google.com, kirill.shutemov@linux.intel.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: Abbott Liu <liuwenliang@huawei.com>

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
Signed-off-by: Abbott Liu <liuwenliang@huawei.com>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 arch/arm/include/asm/kasan_def.h | 64 ++++++++++++++++++++++++++++++++
 arch/arm/include/asm/memory.h    |  5 +++
 arch/arm/kernel/entry-armv.S     |  5 ++-
 arch/arm/kernel/entry-common.S   |  9 +++--
 arch/arm/mm/mmu.c                |  7 +++-
 5 files changed, 84 insertions(+), 6 deletions(-)
 create mode 100644 arch/arm/include/asm/kasan_def.h

diff --git a/arch/arm/include/asm/kasan_def.h b/arch/arm/include/asm/kasan_def.h
new file mode 100644
index 000000000000..7b7f42435146
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
index ed8fd0d19a3e..6e099a5458db 100644
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
index ce4aea57130a..c3ca3b96f22a 100644
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
index f7649adef505..0dfa3153d633 100644
--- a/arch/arm/kernel/entry-common.S
+++ b/arch/arm/kernel/entry-common.S
@@ -53,7 +53,8 @@ __ret_fast_syscall:
  UNWIND(.cantunwind	)
 	disable_irq_notrace			@ disable interrupts
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr	r1, =TASK_SIZE
+	cmp	r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -90,7 +91,8 @@ __ret_fast_syscall:
 #endif
 	disable_irq_notrace			@ disable interrupts
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr     r1, =TASK_SIZE
+	cmp     r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]		@ re-check for syscall tracing
 	tst	r1, #_TIF_SYSCALL_WORK | _TIF_WORK_MASK
@@ -131,7 +133,8 @@ ret_slow_syscall:
 	disable_irq_notrace			@ disable interrupts
 ENTRY(ret_to_user_from_irq)
 	ldr	r2, [tsk, #TI_ADDR_LIMIT]
-	cmp	r2, #TASK_SIZE
+	ldr     r1, =TASK_SIZE
+	cmp	r2, r1
 	blne	addr_limit_check_failed
 	ldr	r1, [tsk, #TI_FLAGS]
 	tst	r1, #_TIF_WORK_MASK
diff --git a/arch/arm/mm/mmu.c b/arch/arm/mm/mmu.c
index f3ce34113f89..3ae33c2dc1ad 100644
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1256,9 +1256,14 @@ static inline void prepare_page_table(void)
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
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
