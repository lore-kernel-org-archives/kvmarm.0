Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1E44C25B0F
	for <kvmarm@archiver.kernel.org>; Tue,  9 Aug 2022 09:16:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AE4174C9A6;
	Tue,  9 Aug 2022 05:16:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ks5MeGO8z46D; Tue,  9 Aug 2022 05:15:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E2DC14CAAC;
	Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B0B04C4CB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w6TOPLJz+LCL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Aug 2022 05:15:52 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5796D4C53B
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Aug 2022 05:15:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A631C143D;
 Tue,  9 Aug 2022 02:15:47 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C65C73F67D;
 Tue,  9 Aug 2022 02:15:45 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: pbonzini@redhat.com, thuth@redhat.com, andrew.jones@linux.dev,
 kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, nikos.nikoleris@arm.com
Subject: [kvm-unit-tests RFC PATCH 14/19] arm/arm64: Add C functions for doing
 cache maintenance
Date: Tue,  9 Aug 2022 10:15:53 +0100
Message-Id: <20220809091558.14379-15-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220809091558.14379-1-alexandru.elisei@arm.com>
References: <20220809091558.14379-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add C functions for doing cache maintenance, which will be used for
implementing the necessary maintenance when kvm-unit-tests boots.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/Makefile.arm           |  4 +-
 arm/Makefile.arm64         |  4 +-
 arm/Makefile.common        |  4 +-
 lib/arm/asm/assembler.h    |  4 +-
 lib/arm/asm/cacheflush.h   |  1 +
 lib/arm/asm/mmu.h          |  6 ---
 lib/arm/cache.S            | 89 ++++++++++++++++++++++++++++++++++++++
 lib/arm64/asm/cacheflush.h | 32 ++++++++++++++
 lib/arm64/asm/mmu.h        |  5 ---
 lib/arm64/cache.S          | 85 ++++++++++++++++++++++++++++++++++++
 10 files changed, 218 insertions(+), 16 deletions(-)
 create mode 100644 lib/arm/asm/cacheflush.h
 create mode 100644 lib/arm/cache.S
 create mode 100644 lib/arm64/asm/cacheflush.h
 create mode 100644 lib/arm64/cache.S

diff --git a/arm/Makefile.arm b/arm/Makefile.arm
index 01fd4c7bb6e2..03ec08503cfb 100644
--- a/arm/Makefile.arm
+++ b/arm/Makefile.arm
@@ -25,7 +25,9 @@ endif
 define arch_elf_check =
 endef
 
-cstart.o = $(TEST_DIR)/cstart.o
+asmobjs  = $(TEST_DIR)/cstart.o
+asmobjs += lib/arm/cache.o
+
 cflatobjs += lib/arm/spinlock.o
 cflatobjs += lib/arm/processor.o
 cflatobjs += lib/arm/stack.o
diff --git a/arm/Makefile.arm64 b/arm/Makefile.arm64
index 42e18e771b3b..31ac56dab104 100644
--- a/arm/Makefile.arm64
+++ b/arm/Makefile.arm64
@@ -20,7 +20,9 @@ define arch_elf_check =
 		$(error $(1) has unsupported reloc types))
 endef
 
-cstart.o = $(TEST_DIR)/cstart64.o
+asmobjs  = $(TEST_DIR)/cstart64.o
+asmobjs += lib/arm64/cache.o
+
 cflatobjs += lib/arm64/processor.o
 cflatobjs += lib/arm64/spinlock.o
 cflatobjs += lib/arm64/gic-v3-its.o lib/arm64/gic-v3-its-cmd.o
diff --git a/arm/Makefile.common b/arm/Makefile.common
index 38385e0c558e..a7a4787a5ef8 100644
--- a/arm/Makefile.common
+++ b/arm/Makefile.common
@@ -60,7 +60,7 @@ eabiobjs = lib/arm/eabi_compat.o
 
 FLATLIBS = $(libcflat) $(LIBFDT_archive) $(libeabi)
 %.elf: LDFLAGS = -nostdlib $(arch_LDFLAGS)
-%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(cstart.o)
+%.elf: %.o $(FLATLIBS) $(SRCDIR)/arm/flat.lds $(asmobjs)
 	$(CC) $(CFLAGS) -c -o $(@:.elf=.aux.o) $(SRCDIR)/lib/auxinfo.c \
 		-DPROGNAME=\"$(@:.elf=.flat)\" -DAUXFLAGS=$(AUXFLAGS)
 	$(LD) $(LDFLAGS) -o $@ -T $(SRCDIR)/arm/flat.lds \
@@ -81,4 +81,4 @@ arm_clean: asm_offsets_clean
 	      $(TEST_DIR)/.*.d lib/arm/.*.d
 
 generated-files = $(asm-offsets)
-$(tests-all:.flat=.o) $(cstart.o) $(cflatobjs): $(generated-files)
+$(tests-all:.flat=.o) $(asmobjs) $(cflatobjs): $(generated-files)
diff --git a/lib/arm/asm/assembler.h b/lib/arm/asm/assembler.h
index db5f0f55027c..e728bb210a07 100644
--- a/lib/arm/asm/assembler.h
+++ b/lib/arm/asm/assembler.h
@@ -41,7 +41,9 @@
 	.ifc	\op, dccimvac
 	mcr	p15, 0, \addr, c7, c14, 1
 	.else
-	.err
+	.ifc	\op, dccmvac
+	mcr	p15, 0, \addr, c7, c10, 1
+	.endif
 	.endif
 	add	\addr, \addr, \tmp1
 	cmp	\addr, \end
diff --git a/lib/arm/asm/cacheflush.h b/lib/arm/asm/cacheflush.h
new file mode 100644
index 000000000000..42dc88a44ce0
--- /dev/null
+++ b/lib/arm/asm/cacheflush.h
@@ -0,0 +1 @@
+#include "../../arm64/asm/cacheflush.h"
diff --git a/lib/arm/asm/mmu.h b/lib/arm/asm/mmu.h
index b24b97e554e2..6359ba642a4c 100644
--- a/lib/arm/asm/mmu.h
+++ b/lib/arm/asm/mmu.h
@@ -45,12 +45,6 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	isb();
 }
 
-static inline void flush_dcache_addr(unsigned long vaddr)
-{
-	/* DCCIMVAC */
-	asm volatile("mcr p15, 0, %0, c7, c14, 1" :: "r" (vaddr));
-}
-
 #include <asm/mmu-api.h>
 
 #endif /* _ASMARM_MMU_H_ */
diff --git a/lib/arm/cache.S b/lib/arm/cache.S
new file mode 100644
index 000000000000..f42284491b1f
--- /dev/null
+++ b/lib/arm/cache.S
@@ -0,0 +1,89 @@
+/*
+ * Based on arch/arm64/mm/cache.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012, 2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/assembler.h>
+
+/*
+ *      dcache_inval_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are invalidated. Any partial lines at the ends of the interval are
+ *      cleaned to PoC instead to prevent data loss.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_inval_poc
+dcache_inval_poc:
+	dmb	sy
+	dcache_line_size r2, r3
+	sub 	r3, r2, #1
+	tst	r1, r3			// end cache line aligned?
+	bic	r1, r1, r3
+	beq 	1f
+	// DCCIMVAC
+	mcr	p15, 0, r1, c7, c14, 1	// clean + invalidate end cache line
+1:	tst	r0, r3			// start cache line aligned?
+	bic	r0, r0, r3
+	beq	2f
+	mcr	p15, 0, r0, c7, c14, 1	// clean + invalidate start cache line
+	b	3f
+	// DCIMVAC
+2:	mcr	p15, 0, r0, c7, c6, 1	// invalidate current cache line
+3:	add	r0, r0, r2
+	cmp	r0, r1
+	blo	2b
+	dsb	sy
+	mov	pc, lr
+
+/*
+ *      dcache_clean_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are cleaned to the PoC.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_clean_poc
+dcache_clean_poc:
+	dmb	sy
+	dcache_by_line_op dccmvac, sy, r0, r1, r2, r3
+	mov	pc, lr
+
+/*
+ *      dcache_clean_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_addr_poc
+dcache_clean_addr_poc:
+	dmb	sy
+	// DCCMVAC
+	mcr 	p15, 0, r0, c7, c10, 1
+	dsb	sy
+	mov	pc, lr
+
+/*
+ *      dcache_clean_inval_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned and invalidated
+ *      to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_inval_addr_poc
+dcache_clean_inval_addr_poc:
+	dmb	sy
+	// DCCIMVAC
+	mcr 	p15, 0, r0, c7, c14, 1
+	dsb	sy
+	mov	pc, lr
diff --git a/lib/arm64/asm/cacheflush.h b/lib/arm64/asm/cacheflush.h
new file mode 100644
index 000000000000..2f0ac1f3e573
--- /dev/null
+++ b/lib/arm64/asm/cacheflush.h
@@ -0,0 +1,32 @@
+#ifndef _ASMARM64_CACHEFLUSH_H_
+#define _ASMARM64_CACHEFLUSH_H_
+/*
+ * Based on arch/arm64/asm/include/cacheflush.h
+ *
+ * Copyright (C) 1999-2002 Russell King.
+ * Copyright (C) 2012,2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/page.h>
+
+extern void dcache_clean_addr_poc(unsigned long addr);
+extern void dcache_clean_inval_addr_poc(unsigned long addr);
+
+extern void dcache_inval_poc(unsigned long start, unsigned long end);
+extern void dcache_clean_poc(unsigned long start, unsigned long end);
+
+static inline void dcache_inval_page_poc(unsigned long page_addr)
+{
+	assert(PAGE_ALIGN(page_addr) == page_addr);
+	dcache_inval_poc(page_addr, page_addr + PAGE_SIZE);
+}
+
+static inline void dcache_clean_page_poc(unsigned long page_addr)
+{
+	assert(PAGE_ALIGN(page_addr) == page_addr);
+	dcache_clean_poc(page_addr, page_addr + PAGE_SIZE);
+}
+
+#endif /* _ASMARM64_CACHEFLUSH_H_ */
diff --git a/lib/arm64/asm/mmu.h b/lib/arm64/asm/mmu.h
index 5c27edb24d2e..2ebbe925033b 100644
--- a/lib/arm64/asm/mmu.h
+++ b/lib/arm64/asm/mmu.h
@@ -28,11 +28,6 @@ static inline void flush_tlb_page(unsigned long vaddr)
 	isb();
 }
 
-static inline void flush_dcache_addr(unsigned long vaddr)
-{
-	asm volatile("dc civac, %0" :: "r" (vaddr));
-}
-
 #include <asm/mmu-api.h>
 
 #endif /* _ASMARM64_MMU_H_ */
diff --git a/lib/arm64/cache.S b/lib/arm64/cache.S
new file mode 100644
index 000000000000..28a339a451bf
--- /dev/null
+++ b/lib/arm64/cache.S
@@ -0,0 +1,85 @@
+/*
+ * Based on arch/arm64/mm/cache.S
+ *
+ * Copyright (C) 2001 Deep Blue Solutions Ltd.
+ * Copyright (C) 2012, 2022 ARM Ltd.
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.
+ */
+
+#include <asm/assembler.h>
+
+/*
+ *      dcache_inval_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are invalidated. Any partial lines at the ends of the interval are
+ *      cleaned to PoC instead to prevent data loss.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_inval_poc
+dcache_inval_poc:
+	dmb	sy
+	raw_dcache_line_size x2, x3
+	sub 	x3, x2, #1
+	tst	x1, x3			// end cache line aligned?
+	bic	x1, x1, x3
+	b.eq 	1f
+	dc	civac, x1		// clean + invalidate end cache line
+1:	tst	x0, x3			// start cache line aligned?
+	bic	x0, x0, x3
+	b.eq	2f
+	dc 	civac, x0		// clean + invalidate start cache line
+	b	3f
+2:	dc	ivac, x0		// invalidate current cache line
+3:	add	x0, x0, x2
+	cmp	x0, x1
+	b.lo	2b
+	dsb	sy
+	ret
+
+/*
+ *      dcache_clean_poc(start, end)
+ *
+ *      Ensure that any D-cache lines for the interval [start, end)
+ *      are cleaned to the PoC.
+ *
+ *      - start   - start address of region
+ *      - end     - end address of region
+ */
+.global dcache_clean_poc
+dcache_clean_poc:
+	dmb	sy
+	dcache_by_line_op cvac, sy, x0, x1, x2, x3
+	ret
+
+/*
+ *      dcache_clean_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_addr_poc
+dcache_clean_addr_poc:
+	dmb	sy
+	dc	cvac, x0
+	dsb	sy
+	ret
+
+/*
+ *      dcache_clean_inval_addr_poc(addr)
+ *
+ *      Ensure that the D-cache line for address addr is cleaned and invalidated
+ *      to the PoC.
+ *
+ *      - addr    - the address
+ */
+.global dcache_clean_inval_addr_poc
+dcache_clean_inval_addr_poc:
+	dmb	sy
+	dc	civac, x0
+	dsb	sy
+	ret
-- 
2.37.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
