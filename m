Return-Path: <SRS0=Zhuu=CJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39242C43461
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E019620719
	for <kvmarm@archiver.kernel.org>; Mon, 31 Aug 2020 19:34:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WIhWWcLq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E019620719
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A6034B318;
	Mon, 31 Aug 2020 15:34:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bthD6yJAn-6; Mon, 31 Aug 2020 15:34:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B204B386;
	Mon, 31 Aug 2020 15:34:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EFA14B34E
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id k1VvFh+Bvb2L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Aug 2020 15:34:38 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 621D04B24D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Aug 2020 15:34:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1598902477;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=UbfoLXN+nHRwFXdTrfiaSZqZbGEzYEgETohlSjexE70=;
 b=WIhWWcLq12Jsf9yQjTV5hvkLkRGoQMQEhTLzeIbJ8iNbbbaA7Fs+Ac0Daovcl38rrTd7MB
 /KXY4iDtGWSGjLSgZlLfLQuDqgety/VatpMEOILgOtpr8MeYXQrTQ3faztR+eqQ5D7d2rT
 YCjYRwmmSL6u05FFW2pcBjlH2VmD+QQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-184-RB50YXbIM1yGtBsKCVNXEg-1; Mon, 31 Aug 2020 15:34:35 -0400
X-MC-Unique: RB50YXbIM1yGtBsKCVNXEg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DF1EC8030DD;
 Mon, 31 Aug 2020 19:34:33 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-112.ams2.redhat.com [10.36.112.112])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 7169F7EB85;
 Mon, 31 Aug 2020 19:34:31 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, qemu-devel@nongnu.org, drjones@redhat.com,
 andrew.murray@arm.com, sudeep.holla@arm.com, maz@kernel.org,
 will@kernel.org, haibo.xu@linaro.org
Subject: [kvm-unit-tests RFC 4/4] spe: Test Profiling Buffer Events
Date: Mon, 31 Aug 2020 21:34:14 +0200
Message-Id: <20200831193414.6951-5-eric.auger@redhat.com>
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

Setup the infrastructure to check the occurence of events.
The test checks the Buffer Full event occurs when no space
is available. The PPI is handled and we check the syndrome register
against the expected event.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 arm/spe.c         | 141 +++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |   8 +++
 2 files changed, 148 insertions(+), 1 deletion(-)

diff --git a/arm/spe.c b/arm/spe.c
index 7996f79..2f5ee35 100644
--- a/arm/spe.c
+++ b/arm/spe.c
@@ -19,6 +19,7 @@
 #include "alloc_page.h"
 #include <bitops.h>
 #include "alloc.h"
+#include <asm/gic.h>
 
 struct spe {
 	int min_interval;
@@ -36,13 +37,37 @@ struct spe {
 	bool unique_record_size;
 };
 
+enum spe_event_exception_class {
+	EC_STAGE1_DATA_ABORT =  0x24,
+	EC_STAGE2_DATA_ABORT = 0x25,
+	EC_OTHER = 0,
+};
+
+struct spe_event {
+	enum spe_event_exception_class ec;
+	bool dl;	/* data lost */
+	bool ea;	/* external abort */
+	bool s;		/* service */
+	bool coll;	/* collision */
+	union {
+		bool buffer_filled; /* ec = other */
+	} mss;
+};
+
 static struct spe spe;
 
+struct spe_stats {
+	struct spe_event observed;
+	bool unexpected;
+};
+static struct spe_stats spe_stats;
+
 #ifdef __arm__
 
 static bool spe_probe(void) { return false; }
 static void test_spe_introspection(void) { }
 static void test_spe_buffer(void) { }
+static void test_spe_events(void) { }
 
 #else
 
@@ -95,6 +120,16 @@ static void test_spe_buffer(void) { }
 #define PMSCR_EL1_TS			0x20
 #define PMSCR_EL1_PCT			0x40
 
+#define PMBSR_EL1_COLL			0x10000
+#define PMBSR_EL1_S			0x20000
+#define PMBSR_EL1_EA			0x40000
+#define PMBSR_EL1_DL			0x80000
+#define PMBSR_EL1_EC_SHIFT		26
+#define PMBSR_EL1_EC_MASK		0x3F
+#define PMBSR_EL1_MISS_MASK		0xFFFF
+
+#define SPE_PPI 21
+
 static int min_interval(uint8_t idr_bits)
 {
 	switch (idr_bits) {
@@ -119,6 +154,44 @@ static int min_interval(uint8_t idr_bits)
 	}
 }
 
+static int decode_syndrome_register(uint64_t sr, struct spe_event *event, bool verbose)
+{
+	if (!sr)
+		return 0;
+
+	if (sr & PMBSR_EL1_S)
+		event->s = true;
+	if (sr & PMBSR_EL1_COLL)
+		event->coll = true;
+	if (sr & PMBSR_EL1_EA)
+		event->ea = true;
+	if (sr & PMBSR_EL1_DL)
+		event->dl = true;
+	if (verbose)
+		report_info("PMBSR_EL1: Service=%d Collision=%d External Fault=%d DataLost=%d",
+			    event->s, event->coll, event->ea, event->dl);
+
+	switch ((sr >> PMBSR_EL1_EC_SHIFT) & PMBSR_EL1_EC_MASK) {
+	case EC_OTHER:
+		event->ec = EC_OTHER;
+		event->mss.buffer_filled = sr & 0x1;
+		if (verbose)
+			report_info("PMBSR_EL1: EC = OTHER buffer filled=%d", event->mss.buffer_filled);
+		break;
+	case EC_STAGE1_DATA_ABORT:
+		event->ec = EC_STAGE1_DATA_ABORT;
+		report_info("PMBSR_EL1: EC = stage 1 data abort");
+		break;
+	case EC_STAGE2_DATA_ABORT:
+		event->ec = EC_STAGE2_DATA_ABORT;
+		report_info("PMBSR_EL1: EC = stage 2 data abort");
+		break;
+	default:
+		return -1;
+	}
+	return 0;
+}
+
 static bool spe_probe(void)
 {
 	uint64_t pmbidr_el1, pmsidr_el1;
@@ -224,6 +297,13 @@ static void reset(void)
 
 	/* Make sure the syndrome register is void */
 	write_sysreg_s(0, PMBSR_EL1);
+
+	memset(&spe_stats, 0, sizeof(spe_stats));
+}
+
+inline bool event_match(struct spe_event *observed, struct spe_event *expected)
+{
+	return !memcmp(observed, expected, sizeof(struct spe_event));
 }
 
 static inline void drain(void)
@@ -235,6 +315,7 @@ static inline void drain(void)
 
 static void test_spe_buffer(void)
 {
+	struct spe_event observed = {}, expected = {};
 	uint64_t pmbsr_el1, val1, val2;
 	void *addr = malloc(10 * PAGE_SIZE);
 
@@ -290,7 +371,61 @@ static void test_spe_buffer(void)
 		report_info("This corresponds to %ld record(s) of %d bytes",
 			    val2 / spe.maxsize, spe.maxsize);
 	pmbsr_el1 = read_sysreg_s(PMBSR_EL1);
-	report(!pmbsr_el1, "PMBSR_EL1: no event");
+	report(!(decode_syndrome_register(pmbsr_el1, &observed, true)) &&
+	       event_match(&observed, &expected), "PMBSR_EL1: no event");
+
+	free(addr);
+}
+
+static void irq_handler(struct pt_regs *regs)
+{
+	uint32_t irqstat, irqnr;
+
+	irqstat = gic_read_iar();
+	irqnr = gic_iar_irqnr(irqstat);
+
+	if (irqnr == SPE_PPI) {
+		uint64_t pmbsr_el1 = read_sysreg_s(PMBSR_EL1);
+
+		if (decode_syndrome_register(pmbsr_el1, &spe_stats.observed, true))
+			spe_stats.unexpected = true;
+		report_info("SPE IRQ! SR=0x%lx", pmbsr_el1);
+		write_sysreg_s(0, PMBSR_EL1);
+	} else {
+		spe_stats.unexpected = true;
+	}
+	gic_write_eoir(irqstat);
+}
+
+static inline bool has_event_occurred(struct spe_event *expected)
+{
+	return (!spe_stats.unexpected && event_match(&spe_stats.observed, expected));
+}
+
+static void test_spe_events(void)
+{
+	struct spe_event expected = {.ec = EC_OTHER, .mss.buffer_filled = true, .s = true};
+	void *addr = malloc(10 * PAGE_SIZE);
+
+	gic_enable_defaults();
+	install_irq_handler(EL1H_IRQ, irq_handler);
+	local_irq_enable();
+	gic_enable_irq(SPE_PPI);
+
+	reset();
+
+	/* Willingly set pmblimitr tp pmdptr */
+	spe.pmblimitr_el1 = spe.pmbptr_el1;
+
+	mem_access_loop(addr, 100000, spe.pmblimitr_el1 | PMBLIMITR_EL1_E);
+	drain();
+	report(has_event_occurred(&expected), "PMBSR_EL1: buffer full event");
+
+	/* redo it once */
+
+	mem_access_loop(addr, 100000, spe.pmblimitr_el1 | PMBLIMITR_EL1_E);
+	drain();
+	report(has_event_occurred(&expected), "PMBSR_EL1: buffer full event");
 
 	free(addr);
 }
@@ -317,6 +452,10 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_spe_buffer();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "spe-events") == 0) {
+		report_prefix_push(argv[1]);
+		test_spe_events();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index bb0e84c..b2b07be 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -150,6 +150,14 @@ extra_params = -append 'spe-buffer'
 accel = kvm
 arch = arm64
 
+[spe-events]
+file = spe.flat
+groups = spe
+arch = arm64
+extra_params = -append 'spe-events'
+accel = kvm
+arch = arm64
+
 # Test GIC emulation
 [gicv2-ipi]
 file = gic.flat
-- 
2.21.3

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
