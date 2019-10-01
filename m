Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF7EC352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 594E721924
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:23:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 594E721924
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1242D4A6A4;
	Tue,  1 Oct 2019 06:23:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AzeRez9xYlKY; Tue,  1 Oct 2019 06:23:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B933E4A700;
	Tue,  1 Oct 2019 06:23:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC63E4A6E2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lNEkZuEQUe52 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:23:53 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E23BE4A708
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:23:52 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B555C1570;
 Tue,  1 Oct 2019 03:23:52 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 779F73F739;
 Tue,  1 Oct 2019 03:23:51 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 10/19] arm/arm64: Perform dcache clean +
 invalidate after turning MMU off
Date: Tue,  1 Oct 2019 11:23:14 +0100
Message-Id: <20191001102323.27628-11-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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

When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [1]
or to Strongly-Ordered memory on arm [2]. This means that the accesses are
non-cacheable.

Perform a dcache clean to PoC so we can read the newer values from the
cache, instead of the stale values from memory.

Perform an invalidation so when we turn the MMU on, we can access the
data written to memory while the MMU was off, instead of potentially
stale values from the cache.

Data caches are PIPT and the VAs are translated using the current
translation tables, or an identity mapping (what Arm calls a "flat
mapping") when the MMU is off [1][2]. Do the clean + invalidate when the
MMU is off so we don't depend on the current translation tables and we can
make sure that the operation applies to the entire physical memory.

[1] ARM DDI 0487E.a, section D5.2.9
[2] ARM DDI 0406C.d, section B3.2.1

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm/asm/processor.h   |  6 ++++++
 lib/arm64/asm/processor.h |  6 ++++++
 lib/arm/processor.c       | 10 ++++++++++
 lib/arm/setup.c           |  2 ++
 lib/arm64/processor.c     | 11 +++++++++++
 arm/cstart.S              | 22 ++++++++++++++++++++++
 arm/cstart64.S            | 23 +++++++++++++++++++++++
 7 files changed, 80 insertions(+)

diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..4684fb4755b3 100644
--- a/lib/arm/asm/processor.h
+++ b/lib/arm/asm/processor.h
@@ -9,6 +9,11 @@
 #include <asm/sysreg.h>
 #include <asm/barrier.h>
 
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 enum vector {
 	EXCPTN_RST,
 	EXCPTN_UND,
@@ -25,6 +30,7 @@ typedef void (*exception_fn)(struct pt_regs *);
 extern void install_exception_handler(enum vector v, exception_fn fn);
 
 extern void show_regs(struct pt_regs *regs);
+extern void init_dcache_line_size(void);
 
 static inline unsigned long current_cpsr(void)
 {
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..fd508c02f30d 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,6 +16,11 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
+#define CTR_EL0_DMINLINE_SHIFT	16
+#define CTR_EL0_DMINLINE_MASK	(0xf << 16)
+#define CTR_EL0_DMINLINE(x)	\
+	(((x) & CTR_EL0_DMINLINE_MASK) >> CTR_EL0_DMINLINE_SHIFT)
+
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
@@ -60,6 +65,7 @@ extern void vector_handlers_default_init(vector_fn *handlers);
 
 extern void show_regs(struct pt_regs *regs);
 extern bool get_far(unsigned int esr, unsigned long *far);
+extern void init_dcache_line_size(void);
 
 static inline unsigned long current_level(void)
 {
diff --git a/lib/arm/processor.c b/lib/arm/processor.c
index 773337e6d3b7..c57657c5ea53 100644
--- a/lib/arm/processor.c
+++ b/lib/arm/processor.c
@@ -25,6 +25,8 @@ static const char *vector_names[] = {
 	"rst", "und", "svc", "pabt", "dabt", "addrexcptn", "irq", "fiq"
 };
 
+unsigned int dcache_line_size;
+
 void show_regs(struct pt_regs *regs)
 {
 	unsigned long flags;
@@ -145,3 +147,11 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+void init_dcache_line_size(void)
+{
+	u32 ctr;
+
+	asm volatile("mrc p15, 0, %0, c0, c0, 1" : "=r" (ctr));
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = 1 << (CTR_DMINLINE(ctr) + 2);
+}
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 4f02fca85607..54fc19a20942 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -20,6 +20,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/processor.h>
 #include <asm/smp.h>
 
 #include "io.h"
@@ -63,6 +64,7 @@ static void cpu_init(void)
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
 	set_cpu_online(0, true);
+	init_dcache_line_size();
 }
 
 static void mem_init(phys_addr_t freemem_start)
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index 2a024e3f4e9d..f28066d40145 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -62,6 +62,8 @@ static const char *ec_names[EC_MAX] = {
 	[ESR_EL1_EC_BRK64]		= "BRK64",
 };
 
+unsigned int dcache_line_size;
+
 void show_regs(struct pt_regs *regs)
 {
 	int i;
@@ -257,3 +259,12 @@ bool is_user(void)
 {
 	return current_thread_info()->flags & TIF_USER_MODE;
 }
+
+void init_dcache_line_size(void)
+{
+	u64 ctr;
+
+	ctr = read_sysreg(ctr_el0);
+	/* DminLine is log2 of the number of words in the smallest cache line */
+	dcache_line_size = 1 << (CTR_EL0_DMINLINE(ctr) + 2);
+}
diff --git a/arm/cstart.S b/arm/cstart.S
index 112124f222cb..c8bbb4f0a2a2 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -185,6 +185,20 @@ asm_mmu_enable:
 
 	mov     pc, lr
 
+.macro dcache_clean_inval domain, start, end, tmp1, tmp2
+	ldr	\tmp1, =dcache_line_size
+	ldr	\tmp1, [\tmp1]
+	sub	\tmp2, \tmp1, #1
+	bic	\start, \start, \tmp2
+9998:
+	/* DCCIMVAC */
+	mcr	p15, 0, \start, c7, c14, 1
+	add	\start, \start, \tmp1
+	cmp	\start, \end
+	blo	9998b
+	dsb	\domain
+.endm
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	/* SCTLR */
@@ -192,6 +206,14 @@ asm_mmu_disable:
 	bic	r0, #CR_M
 	mcr	p15, 0, r0, c1, c0, 0
 	isb
+
+	ldr	r0, =__phys_offset
+	ldr	r0, [r0]
+	ldr	r1, =__phys_end
+	ldr	r1, [r1]
+	dcache_clean_inval sy, r0, r1, r2, r3
+	isb
+
 	mov     pc, lr
 
 /*
diff --git a/arm/cstart64.S b/arm/cstart64.S
index c98842f11e90..f41ffa3bc6c2 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -201,12 +201,35 @@ asm_mmu_enable:
 
 	ret
 
+/* Taken with small changes from arch/arm64/incluse/asm/assembler.h */
+.macro dcache_by_line_op op, domain, start, end, tmp1, tmp2
+	adrp	\tmp1, dcache_line_size
+	ldr	\tmp1, [\tmp1, :lo12:dcache_line_size]
+	sub	\tmp2, \tmp1, #1
+	bic	\start, \start, \tmp2
+9998:
+	dc	\op , \start
+	add	\start, \start, \tmp1
+	cmp	\start, \end
+	b.lo	9998b
+	dsb	\domain
+.endm
+
 .globl asm_mmu_disable
 asm_mmu_disable:
 	mrs	x0, sctlr_el1
 	bic	x0, x0, SCTLR_EL1_M
 	msr	sctlr_el1, x0
 	isb
+
+	/* Clean + invalidate the entire memory */
+	adrp	x0, __phys_offset
+	ldr	x0, [x0, :lo12:__phys_offset]
+	adrp	x1, __phys_end
+	ldr	x1, [x1, :lo12:__phys_end]
+	dcache_by_line_op civac, sy, x0, x1, x2, x3
+	isb
+
 	ret
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
