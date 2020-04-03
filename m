Return-Path: <SRS0=EFuC=5T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B92BCC2D0E8
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:14:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6A2A6206F5
	for <kvmarm@archiver.kernel.org>; Fri,  3 Apr 2020 07:14:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YRDPYOGK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6A2A6206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2350D4B181;
	Fri,  3 Apr 2020 03:14:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id SLFc4BQdRB6W; Fri,  3 Apr 2020 03:14:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03C724B188;
	Fri,  3 Apr 2020 03:14:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 188E74B181
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:14:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OtP0RWLmMCWX for <kvmarm@lists.cs.columbia.edu>;
 Fri,  3 Apr 2020 03:14:12 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 218344B18F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  3 Apr 2020 03:14:12 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1585898052;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=+OI1YdSQwikzDc085EaC9McOghPW3ztxWZW1WYLNUFc=;
 b=YRDPYOGKiE3uP1RpAoVGR8Tkx0pD01CoMYj2qD8dbJlwZfREYM9JCmNOdT0iGPmq4Qow4f
 48uk1ySUciUkBPTsvl9/CWUPaEYYPIo8Am1yQnUdkR4ivDIPW1jCk0+VxiN9BQ988O3X3c
 se+NLCOSlN2xMtlJ+3juKeIwjhE5zEE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-143-mZOvCsZePEanI3HYWynJGA-1; Fri, 03 Apr 2020 03:14:10 -0400
X-MC-Unique: mZOvCsZePEanI3HYWynJGA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AD649149C2;
 Fri,  3 Apr 2020 07:14:08 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-112-58.ams2.redhat.com [10.36.112.58])
 by smtp.corp.redhat.com (Postfix) with ESMTP id E2A925C1C6;
 Fri,  3 Apr 2020 07:14:05 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH v4 09/12] arm: pmu: Test chained counters
Date: Fri,  3 Apr 2020 09:13:23 +0200
Message-Id: <20200403071326.29932-10-eric.auger@redhat.com>
In-Reply-To: <20200403071326.29932-1-eric.auger@redhat.com>
References: <20200403071326.29932-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: andrew.murray@arm.com, andre.przywara@arm.com
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

Add 2 tests exercising chained counters. The first one uses
CPU_CYCLES and the second one uses SW_INCR.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---
v3 -> v4:
- each report_info has a different message

v2 -> v3:
- added prefix pop
- added pmu prefix to the test names
- defines, event array ...
---
 arm/pmu.c         | 98 ++++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg | 12 ++++++
 2 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index c954c71..be249cc 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -47,6 +47,7 @@
 #define INST_PREC		0x1B
 #define STALL_FRONTEND		0x23
 #define STALL_BACKEND		0x24
+#define CHAIN			0x1E
 
 #define COMMON_EVENTS_LOW	0x0
 #define COMMON_EVENTS_HIGH	0x3F
@@ -141,6 +142,8 @@ static void test_event_counter_config(void) {}
 static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
 static void test_sw_incr(void) {}
+static void test_chained_counters(void) {}
+static void test_chained_sw_incr(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -504,7 +507,92 @@ static void test_sw_incr(void)
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
-		"overflow reg after 100 SW_INCR");
+		"overflow on counter #0 after 100 SW_INCR");
+}
+
+static void test_chained_counters(void)
+{
+	uint32_t events[] = {CPU_CYCLES, CHAIN};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
+	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
+
+	/* test 64b overflow */
+
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, 0x1);
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
+	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
+	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
+	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+}
+
+static void test_chained_sw_incr(void)
+{
+	uint32_t events[] = {SW_INCR, CHAIN};
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 0, SW_INCR | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
+		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+
+	/* 64b SW_INCR and overflow on CHAIN counter*/
+	pmu_reset();
+
+	write_regn_el0(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	write_regn_el0(pmevcntr, 1, ALL_SET);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+		(read_regn_el0(pmevcntr, 1) == 0) &&
+		(read_regn_el0(pmevcntr, 0) == 84),
+		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
+	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
 #endif
@@ -697,6 +785,14 @@ int main(int argc, char *argv[])
 		report_prefix_push(argv[1]);
 		test_sw_incr();
 		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chained-counters") == 0) {
+		report_prefix_push(argv[1]);
+		test_chained_counters();
+		report_prefix_pop();
+	} else if (strcmp(argv[1], "pmu-chained-sw-incr") == 0) {
+		report_prefix_push(argv[1]);
+		test_chained_sw_incr();
+		report_prefix_pop();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 175afe6..d31dcbf 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -96,6 +96,18 @@ groups = pmu
 arch = arm64
 extra_params = -append 'pmu-sw-incr'
 
+[pmu-chained-counters]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-chained-counters'
+
+[pmu-chained-sw-incr]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'pmu-chained-sw-incr'
+
 # Test PMU support (TCG) with -icount IPC=1
 #[pmu-tcg-icount-1]
 #file = pmu.flat
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
