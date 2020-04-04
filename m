Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B867C2BA1A
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3040E206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ll6pGOCd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3040E206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E01A94B179;
	Sat,  4 Apr 2020 10:38:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2zhdTy7qsv1H; Sat,  4 Apr 2020 10:38:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 930414B115;
	Sat,  4 Apr 2020 10:38:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F364B1F6
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7pqZKoi2c-GS for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:07 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAAC54B211
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011086;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=esT0Q0gioFinX15SP781reoHfr6dcdqw3vZtq2Y8jjs=;
 b=Ll6pGOCdX5fjWvn8i7hKpxzXRwyzKfBrSgIyV1T2jFj+iepnn4U2jR/YULO1D1LQL3IIWR
 wRXHBaCi1DBeu1GaO9wfNTxSEKbshrakr8IxQtw9X5RKI+7koNgnD1LwMVLGLpCLLHKyxX
 AhTKFN7L84BZcM/6PpLF7u1r79ePEso=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-o7XYZwL8OQySIINZUy42DA-1; Sat, 04 Apr 2020 10:38:03 -0400
X-MC-Unique: o7XYZwL8OQySIINZUy42DA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE7AD14E0;
 Sat,  4 Apr 2020 14:38:02 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E311D9B912;
 Sat,  4 Apr 2020 14:38:00 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 10/39] arm/arm64: Perform dcache clean +
 invalidate after turning MMU off
Date: Sat,  4 Apr 2020 16:37:02 +0200
Message-Id: <20200404143731.208138-11-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

When the MMU is off, data accesses are to Device nGnRnE memory on arm64 [1]
or to Strongly-Ordered memory on arm [2]. This means that the accesses are
non-cacheable.

Perform a dcache clean to PoC so we can read the newer values from the
cache after we turn the MMU off, instead of the stale values from memory.

Perform an invalidation so we can access the data written to memory after
we turn the MMU back on. This prevents reading back the stale values we
cleaned from the cache when we turned the MMU off.

Data caches are PIPT and the VAs are translated using the current
translation tables, or an identity mapping (what Arm calls a "flat
mapping") when the MMU is off [1, 2]. Do the clean + invalidate when the
MMU is off so we don't depend on the current translation tables and we can
make sure that the operation applies to the entire physical memory.

The patch was tested by hacking arm/selftest.c:

+#include <alloc_page.h>
+#include <asm/mmu.h>
 int main(int argc, char **argv)
 {
+	int *x = alloc_page();
+
 	report_prefix_push("selftest");

+	*x = 0x42;
+	mmu_disable();
+	report(*x == 0x42, "read back value written with MMU on");
+	*x = 0x50;
+	mmu_enable(current_thread_info()->pgtable);
+	report(*x == 0x50, "read back value written with MMU off");
+
 	if (argc < 2)
 		report_abort("no test specified");

Without the fix, the first report fails, and the test usually hangs before
the second report. This is because mmu_enable pushes the LR register on the
stack when the MMU is off, which means that the value will be written to
memory.  However, after asm_mmu_enable, the MMU is enabled, and we read it
back from the dcache, thus getting garbage.

With the fix, the two reports pass.

[1] ARM DDI 0487E.a, section D5.2.9
[2] ARM DDI 0406C.d, section B3.2.1

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/cstart.S              | 22 ++++++++++++++++++++++
 arm/cstart64.S            | 23 +++++++++++++++++++++++
 lib/arm/asm/processor.h   | 13 +++++++++++++
 lib/arm/setup.c           |  8 ++++++++
 lib/arm64/asm/processor.h | 12 ++++++++++++
 5 files changed, 78 insertions(+)

diff --git a/arm/cstart.S b/arm/cstart.S
index e54e380e0d53..ef936ae2f874 100644
--- a/arm/cstart.S
+++ b/arm/cstart.S
@@ -197,6 +197,20 @@ asm_mmu_enable:
 
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
@@ -204,6 +218,14 @@ asm_mmu_disable:
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
index e5a561ea2e39..ffdd49f73ddd 100644
--- a/arm/cstart64.S
+++ b/arm/cstart64.S
@@ -193,12 +193,35 @@ asm_mmu_enable:
 
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
diff --git a/lib/arm/asm/processor.h b/lib/arm/asm/processor.h
index a8c4628da818..1e1132dafd2b 100644
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
@@ -64,6 +69,7 @@ extern bool is_user(void);
 
 #define CNTVCT		__ACCESS_CP15_64(1, c14)
 #define CNTFRQ		__ACCESS_CP15(c14, 0, c0, 0)
+#define CTR		__ACCESS_CP15(c0, 0, c0, 1)
 
 static inline u64 get_cntvct(void)
 {
@@ -76,4 +82,11 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(CNTFRQ);
 }
 
+static inline u32 get_ctr(void)
+{
+	return read_sysreg(CTR);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* _ASMARM_PROCESSOR_H_ */
diff --git a/lib/arm/setup.c b/lib/arm/setup.c
index 385e135f4865..418b4e58a5f8 100644
--- a/lib/arm/setup.c
+++ b/lib/arm/setup.c
@@ -20,6 +20,7 @@
 #include <asm/thread_info.h>
 #include <asm/setup.h>
 #include <asm/page.h>
+#include <asm/processor.h>
 #include <asm/smp.h>
 
 #include "io.h"
@@ -38,6 +39,8 @@ static struct mem_region __initial_mem_regions[NR_INITIAL_MEM_REGIONS + 1];
 struct mem_region *mem_regions = __initial_mem_regions;
 phys_addr_t __phys_offset, __phys_end;
 
+u32 dcache_line_size;
+
 int mpidr_to_cpu(uint64_t mpidr)
 {
 	int i;
@@ -66,6 +69,11 @@ static void cpu_init(void)
 	ret = dt_for_each_cpu_node(cpu_set, NULL);
 	assert(ret == 0);
 	set_cpu_online(0, true);
+	/*
+	 * DminLine is log2 of the number of words in the smallest cache line; a
+	 * word is 4 bytes.
+	 */
+	dcache_line_size = 1 << (CTR_DMINLINE(get_ctr()) + 2);
 }
 
 unsigned int mem_region_get_flags(phys_addr_t paddr)
diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 1d9223f728a5..02665b84cc7e 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -16,6 +16,11 @@
 #define SCTLR_EL1_A	(1 << 1)
 #define SCTLR_EL1_M	(1 << 0)
 
+#define CTR_DMINLINE_SHIFT	16
+#define CTR_DMINLINE_MASK	(0xf << 16)
+#define CTR_DMINLINE(x)	\
+	(((x) & CTR_DMINLINE_MASK) >> CTR_DMINLINE_SHIFT)
+
 #ifndef __ASSEMBLY__
 #include <asm/ptrace.h>
 #include <asm/esr.h>
@@ -105,5 +110,12 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(cntfrq_el0);
 }
 
+static inline u64 get_ctr(void)
+{
+	return read_sysreg(ctr_el0);
+}
+
+extern u32 dcache_line_size;
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
