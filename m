Return-Path: <SRS0=Zhuu=CJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D74EC433E2
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 05AC02087D
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QcguCFps"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05AC02087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AED184B34F;
	Mon, 31 Aug 2020 15:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J+sXP8HRfX7V; Mon, 31 Aug 2020 15:34:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 22CCE4B318;
	Mon, 31 Aug 2020 15:34:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C1A4B24D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UWDafErH1nua for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Aug 2020 15:34:34 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA40E4B30B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598902474;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=TGiGuMkb/kt3ln7/bHWTnbLda6Wmue4f9drr7QeU4IY=;
 b=QcguCFps0iKMMfQp4og1e4BWq67UYhJfYmGGNbMLd7s2rk7mgA2JGZHtmCWNowZBtvPBOK
 i2wXgamsvEaFz5vrWKnQf96vqaUkeylc8lelTYbUd8QGs8tl/eRu66EsL+AuOKB3hbbB4X
 rSTQWc2cXydrHrV4dFEOhJ/bkgp50Rg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-W7Q8DgKwPvCiInBKbhD9sg-1; Mon, 31 Aug 2020 15:34:32 -0400
X-MC-Unique: W7Q8DgKwPvCiInBKbhD9sg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1B6BA18A224C;
 Mon, 31 Aug 2020 19:34:31 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A3A3B7EB69;
 Mon, 31 Aug 2020 19:34:28 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, drjones@redhat.com,
 andrew.murray@arm.com, sudeep.holla@arm.com, maz@kernel.org,
 will@kernel.org, haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 3/4] spe: Add profiling buffer test
Date: Mon, 31 Aug 2020 21:34:13 +0200
Message-Id: <20200831193414.6951-4-eric.auger@redhat.com>
In-Reply-To: <20200831193414.6951-1-eric.auger@redhat.com>
References: <20200831193414.6951-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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

Add the code to prepare for profiling at EL1. The code under profiling
is a simple loop doing memory addresses. We simply check the profiling
buffer write position increases, ie. the buffer gets filled. No event
is expected.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

To make sure no buffer full events is likely to be received, the number
of to be collected events should be estimated. This needs to be done.
Same for next patch. I tried to read PMSICR.COUNT after a single iteration
but I get a value greated than the set interval so I wonder whether this
is a bug or rather than reading this value gives unpredictable value.
---
 arm/spe.c               | 161 ++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg       |   8 ++
 lib/arm64/asm/barrier.h |   1 +
 3 files changed, 170 insertions(+)

diff --git a/arm/spe.c b/arm/spe.c
index 153c182..7996f79 100644
--- a/arm/spe.c
+++ b/arm/spe.c
@@ -14,9 +14,11 @@
 #include "errata.h"
 #include "asm/barrier.h"
 #include "asm/sysreg.h"
+#include "asm/page.h"
 #include "asm/processor.h"
 #include "alloc_page.h"
 #include <bitops.h>
+#include "alloc.h"
 
 struct spe {
 	int min_interval;
@@ -27,6 +29,10 @@ struct spe {
 	bool fe_cap;
 	int align;
 	void *buffer;
+	uint64_t pmbptr_el1;
+	uint64_t pmblimitr_el1;
+	uint64_t pmsirr_el1;
+	uint64_t pmscr_el1;
 	bool unique_record_size;
 };
 
@@ -36,6 +42,7 @@ static struct spe spe;
 
 static bool spe_probe(void) { return false; }
 static void test_spe_introspection(void) { }
+static void test_spe_buffer(void) { }
 
 #else
 
@@ -59,10 +66,35 @@ static void test_spe_introspection(void) { }
 #define PMSIDR_EL1_COUNTSIZE_SHIFT	16
 #define PMSIDR_EL1_COUNTSIZE_MASK	0xFUL
 
+#define PMSIRR_EL1_INTERVAL_SHIFT	8
+#define PMSIRR_EL1_INTERVAL_MASK	0xFFFFFF
+
+#define PMSFCR_EL1_FE			0x1
+#define PMSFCR_EL1_FT			0x2
+#define PMSFCR_EL1_FL			0x4
+#define PMSFCR_EL1_B			0x10000
+#define PMSFCR_EL1_LD			0x20000
+#define PMSFCR_EL1_ST			0x40000
+
+#define PMSCR_EL1	sys_reg(3, 0, 9, 9, 0)
+#define PMSICR_EL1	sys_reg(3, 0, 9, 9, 2)
+#define PMSIRR_EL1	sys_reg(3, 0, 9, 9, 3)
+#define PMSFCR_EL1	sys_reg(3, 0, 9, 9, 4)
+#define PMSEVFR_EL1	sys_reg(3, 0, 9, 9, 5)
 #define PMSIDR_EL1	sys_reg(3, 0, 9, 9, 7)
 
+#define PMBLIMITR_EL1	sys_reg(3, 0, 9, 10, 0)
+#define PMBPTR_EL1	sys_reg(3, 0, 9, 10, 1)
+#define PMBSR_EL1	sys_reg(3, 0, 9, 10, 3)
 #define PMBIDR_EL1	sys_reg(3, 0, 9, 10, 7)
 
+#define PMBLIMITR_EL1_E			0x1
+
+#define PMSCR_EL1_E1SPE			0x2
+#define PMSCR_EL1_PA			0x10
+#define PMSCR_EL1_TS			0x20
+#define PMSCR_EL1_PCT			0x40
+
 static int min_interval(uint8_t idr_bits)
 {
 	switch (idr_bits) {
@@ -138,6 +170,131 @@ static void test_spe_introspection(void)
 		"PMSIDR_EL1: Minimal sampling interval = %d", spe.min_interval);
 }
 
+static void mem_access_loop(void *addr, int loop, uint64_t pmblimitr)
+{
+asm volatile(
+	"	msr_s " xstr(PMBLIMITR_EL1) ", %[pmblimitr]\n"
+	"       isb\n"
+	"       mov     x10, %[loop]\n"
+	"1:     sub     x10, x10, #1\n"
+	"       ldr     x9, [%[addr]]\n"
+	"       cmp     x10, #0x0\n"
+	"       b.gt    1b\n"
+	"	bfxil   %[pmblimitr], xzr, 0, 1\n"
+	"	msr_s " xstr(PMBLIMITR_EL1) ", %[pmblimitr]\n"
+	"       isb\n"
+	:
+	: [addr] "r" (addr), [pmblimitr] "r" (pmblimitr), [loop] "r" (loop)
+	: "x8", "x9", "x10", "cc");
+}
+
+char null_buff[PAGE_SIZE] = {};
+
+static void reset(void)
+{
+	/* erase the profiling buffer, reset the start and limit addresses */
+	spe.pmbptr_el1 = (uint64_t)spe.buffer;
+	spe.pmblimitr_el1 = (uint64_t)(spe.buffer + PAGE_SIZE);
+	write_sysreg_s(spe.pmbptr_el1, PMBPTR_EL1);
+	write_sysreg_s(spe.pmblimitr_el1, PMBLIMITR_EL1);
+	isb();
+
+	/* Drain any buffered data */
+	psb_csync();
+	dsb(nsh);
+
+	memset(spe.buffer, 0, PAGE_SIZE);
+
+	/* reset the syndrome register */
+	write_sysreg_s(0, PMBSR_EL1);
+
+	/* SW must write 0 to PMSICR_EL1 before enabling sampling profiling */
+	write_sysreg_s(0, PMSICR_EL1);
+
+	/* Filtering disabled */
+	write_sysreg_s(0, PMSFCR_EL1);
+
+	/* Interval Reload Register */
+	spe.pmsirr_el1 = (spe.min_interval & PMSIRR_EL1_INTERVAL_MASK) << PMSIRR_EL1_INTERVAL_SHIFT;
+	write_sysreg_s(spe.pmsirr_el1, PMSIRR_EL1);
+
+	/* Control Registrer */
+	spe.pmscr_el1 = PMSCR_EL1_E1SPE | PMSCR_EL1_TS | PMSCR_EL1_PCT | PMSCR_EL1_PA;
+	write_sysreg_s(spe.pmscr_el1, PMSCR_EL1);
+
+	/* Make sure the syndrome register is void */
+	write_sysreg_s(0, PMBSR_EL1);
+}
+
+static inline void drain(void)
+{
+	/* ensure profiling data are written */
+	psb_csync();
+	dsb(nsh);
+}
+
+static void test_spe_buffer(void)
+{
+	uint64_t pmbsr_el1, val1, val2;
+	void *addr = malloc(10 * PAGE_SIZE);
+
+	reset();
+
+	val1 = read_sysreg_s(PMBPTR_EL1);
+	val2 = read_sysreg_s(PMBLIMITR_EL1);
+	report(val1 == spe.pmbptr_el1 && val2 == spe.pmblimitr_el1,
+	       "PMBPTR_EL1, PMBLIMITR_EL1: reset");
+
+	val1 = read_sysreg_s(PMSIRR_EL1);
+	report(val1 == spe.pmsirr_el1, "PMSIRR_EL1: Sampling interval set to %d", spe.min_interval);
+
+	val1 = read_sysreg_s(PMSCR_EL1);
+	report(val1 == spe.pmscr_el1, "PMSCR_EL1: EL1 Statistical Profiling enabled");
+
+	val1 = read_sysreg_s(PMSFCR_EL1);
+	report(!val1, "PMSFCR_EL1: No Filter Control");
+
+	report(!memcmp(spe.buffer, null_buff, PAGE_SIZE),
+		       "Profiling buffer empty before profiling");
+
+	val1 = read_sysreg_s(PMBSR_EL1);
+	report(!val1, "PMBSR_EL1: Syndrome Register void before profiling");
+
+	mem_access_loop(addr, 1, spe.pmblimitr_el1 | PMBLIMITR_EL1_E);
+	drain();
+	val1 = read_sysreg_s(PMSICR_EL1);
+	/*
+	 * TODO: the value read in PMSICR_EL1.count currently seems not consistent with
+	 * programmed interval. Getting a good value would allow to estimate the number
+	 * of records to be collected in next step.
+	 */
+	report_info("count for a single iteration: PMSICR_EL1.count=%lld interval=%d",
+		    val1 & GENMASK_ULL(31, 0), spe.min_interval);
+
+	/* Stuff to profile */
+
+	mem_access_loop(addr, 1000000, spe.pmblimitr_el1 | PMBLIMITR_EL1_E);
+
+	/* end of stuff to profile */
+
+	drain();
+
+	report(memcmp(spe.buffer, null_buff, PAGE_SIZE), "Profiling buffer filled");
+
+	val1 = read_sysreg_s(PMBPTR_EL1);
+	val2 = val1 - (uint64_t)spe.buffer;
+	report(val1 > (uint64_t)spe.buffer,
+		"PMBPTR_EL1: Current write position has increased: 0x%lx -> 0x%lx (%ld bytes)",
+		(uint64_t)spe.buffer, val1, val2);
+	if (spe.unique_record_size)
+		report_info("This corresponds to %ld record(s) of %d bytes",
+			    val2 / spe.maxsize, spe.maxsize);
+	pmbsr_el1 = read_sysreg_s(PMBSR_EL1);
+	report(!pmbsr_el1, "PMBSR_EL1: no event");
+
+	free(addr);
+}
+
 #endif
 
 int main(int argc, char *argv[])
@@ -156,6 +313,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_spe_introspection();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "spe-buffer") == 0) {
+		report_prefix_push(argv[1]);
+		test_spe_buffer();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index c070939..bb0e84c 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -142,6 +142,14 @@ extra_params = -append 'spe-introspection'
 accel = kvm
 arch = arm64
 
+[spe-buffer]
+file = spe.flat
+groups = spe
+arch = arm64
+extra_params = -append 'spe-buffer'
+accel = kvm
+arch = arm64
+
 # Test GIC emulation
 [gicv2-ipi]
 file = gic.flat
diff --git a/lib/arm64/asm/barrier.h b/lib/arm64/asm/barrier.h
index 0e1904c..f9ede15 100644
--- a/lib/arm64/asm/barrier.h
+++ b/lib/arm64/asm/barrier.h
@@ -23,5 +23,6 @@
 #define smp_mb()	dmb(ish)
 #define smp_rmb()	dmb(ishld)
 #define smp_wmb()	dmb(ishst)
+#define psb_csync()	asm volatile("hint #17" : : : "memory")
 
 #endif /* _ASMARM64_BARRIER_H_ */
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
