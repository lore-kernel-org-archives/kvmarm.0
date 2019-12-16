Return-Path: <SRS0=GAmw=2G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E127EC2D0C3
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 20:48:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 95C8821835
	for <kvmarm@archiver.kernel.org>; Mon, 16 Dec 2019 20:48:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a7B9y4NZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 95C8821835
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D424A5A0;
	Mon, 16 Dec 2019 15:48:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hYFguEMmUHjX; Mon, 16 Dec 2019 15:48:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 179F54A944;
	Mon, 16 Dec 2019 15:48:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BFC84AC07
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 15:48:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 46ZjQxTgtUum for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Dec 2019 15:48:32 -0500 (EST)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EBBA54A5A0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Dec 2019 15:48:32 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1576529312;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=tjYVs+BNNU240LHN8Sh/MBUq5QkpqVGcrM9TYOWuLzo=;
 b=a7B9y4NZVrX1mWetk7GyO+COcOscsiQ9+6FLayeVndni+q/qJZFvBYWpzqCtLFrQF0xTAE
 jawjG4swE4JilDrsU8MN+z5e8EfsBjlA5Q53val0bCnDKBAOzXWkukdgX36xS485z8g2M6
 Gc6RD8JFBX3EtIl4efelECJZGw59e0M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-401-N7zJNoN6MZy9JS5P6-AjUQ-1; Mon, 16 Dec 2019 15:48:31 -0500
X-MC-Unique: N7zJNoN6MZy9JS5P6-AjUQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CEEF78024EB;
 Mon, 16 Dec 2019 20:48:29 +0000 (UTC)
Received: from laptop.redhat.com (ovpn-116-117.ams2.redhat.com [10.36.116.117])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 251135D9C9;
 Mon, 16 Dec 2019 20:48:26 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, maz@kernel.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, qemu-devel@nongnu.org,
 qemu-arm@nongnu.org
Subject: [kvm-unit-tests PATCH 06/10] arm: pmu: Test chained counter
Date: Mon, 16 Dec 2019 21:47:53 +0100
Message-Id: <20191216204757.4020-7-eric.auger@redhat.com>
In-Reply-To: <20191216204757.4020-1-eric.auger@redhat.com>
References: <20191216204757.4020-1-eric.auger@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: andre.przywara@arm.com
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
 arm/pmu.c         | 128 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  12 +++++
 2 files changed, 140 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 139dae3..ad98771 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -113,6 +113,8 @@ static void test_event_introspection(void) {}
 static void test_event_counter_config(void) {}
 static void test_basic_event_count(void) {}
 static void test_mem_access(void) {}
+static void test_chained_counters(void) {}
+static void test_chained_sw_incr(void) {}
 
 #elif defined(__aarch64__)
 #define ID_AA64DFR0_PERFMON_SHIFT 8
@@ -459,6 +461,126 @@ static void test_mem_access(void)
 			read_sysreg(pmovsclr_el0));
 }
 
+static void test_chained_counters(void)
+{
+	uint32_t events[] = { 0x11 /* CPU_CYCLES */, 0x1E /* CHAIN */};
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* preset counter #0 at 0xFFFFFFF0 */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+
+	report(read_regn(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
+	report(!read_sysreg(pmovsclr_el0), "check no overflow is recorded");
+
+	/* test 64b overflow */
+
+	pmu_reset();
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0x1);
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
+	report(read_regn(pmevcntr, 1) == 2, "CHAIN counter #1 incremented");
+	report(!read_sysreg(pmovsclr_el0), "check no overflow is recorded");
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+
+	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
+	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
+	report(!read_regn(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	report(read_sysreg(pmovsclr_el0) == 0x2,
+		"check no overflow is recorded");
+}
+
+static void test_chained_sw_incr(void)
+{
+	uint32_t events[] = { 0x0 /* SW_INCR */, 0x0 /* SW_INCR */};
+	int i;
+
+	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
+		return;
+
+	pmu_reset();
+
+	write_regn(pmevtyper, 0, events[0] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	/* enable counters #0 and #1 */
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+
+	/* preset counter #0 at 0xFFFFFFF0 */
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x1, pmswinc_el0);
+
+	report_info("SW_INCR counter #0 has value %ld", read_regn(pmevcntr, 0));
+	report(read_regn(pmevcntr, 0) == 0xFFFFFFF0,
+		"PWSYNC does not increment if PMCR.E is unset");
+
+	pmu_reset();
+
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report(read_regn(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
+	report(read_regn(pmevcntr, 1)  == 100,
+		"counter #0 after + 100 SW_INCR");
+	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+	report(read_sysreg(pmovsclr_el0) == 0x1,
+		"overflow reg after 100 SW_INCR");
+
+	/* 64b SW_INCR */
+	pmu_reset();
+
+	events[1] = 0x1E /* CHAIN */;
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report(!read_sysreg(pmovsclr_el0) && (read_regn(pmevcntr, 1) == 1),
+		"overflow reg after 100 SW_INCR/CHAIN");
+	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+
+	/* 64b SW_INCR and overflow on CHAIN counter*/
+	pmu_reset();
+
+	write_regn(pmevtyper, 1, events[1] | PMEVTYPER_EXCLUDE_EL0);
+	write_regn(pmevcntr, 0, 0xFFFFFFF0);
+	write_regn(pmevcntr, 1, 0xFFFFFFFF);
+	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	for (i = 0; i < 100; i++)
+		write_sysreg(0x3, pmswinc_el0);
+
+	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+		(read_regn(pmevcntr, 1) == 0) &&
+		(read_regn(pmevcntr, 0) == 84),
+		"overflow reg after 100 SW_INCR/CHAIN");
+	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+		    read_regn(pmevcntr, 0), read_regn(pmevcntr, 1));
+}
+
 #endif
 
 /*
@@ -658,6 +780,12 @@ int main(int argc, char *argv[])
 	} else if (strcmp(argv[1], "mem-access") == 0) {
 		report_prefix_push(argv[1]);
 		test_mem_access();
+	} else if (strcmp(argv[1], "chained-counters") == 0) {
+		report_prefix_push(argv[1]);
+		test_chained_counters();
+	} else if (strcmp(argv[1], "chained-sw-incr") == 0) {
+		report_prefix_push(argv[1]);
+		test_chained_sw_incr();
 	} else {
 		report_abort("Unknown sub-test '%s'", argv[1]);
 	}
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 7a59403..1bd4319 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -90,6 +90,18 @@ groups = pmu
 arch = arm64
 extra_params = -append 'mem-access'
 
+[pmu-chained-counters]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'chained-counters'
+
+[pmu-chained-sw-incr]
+file = pmu.flat
+groups = pmu
+arch = arm64
+extra_params = -append 'chained-sw-incr'
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
