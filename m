Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1313C4167B
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 04:55:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 549904B133;
	Thu,  1 Dec 2022 23:55:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Gnae6ticpvyq; Thu,  1 Dec 2022 23:55:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A170340E25;
	Thu,  1 Dec 2022 23:55:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FF1940CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pHjvp34l8faS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 23:55:33 -0500 (EST)
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com
 [209.85.160.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2980440E25
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:33 -0500 (EST)
Received: by mail-oa1-f73.google.com with SMTP id
 586e51a60fabf-13bf576ffa6so1637274fac.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 20:55:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=FGz+sFHxGqEHN5rxi1/IHD0K758Z+41MxAvfePk9lvQ=;
 b=hxzONmykETsMaOMNBn8jG4SKXF84rnJd0xXOEwHWsp97P5ZBgHJXF2TAvYJRjocn2k
 8qUw6+X6hcWboJm2VAwDpQ+F0ognO5K+tCLgFgTXAeJOagh2BE5KLoKncFjBPluaPi2u
 sNopLOWlmwtW8+J06JijwzrEpCNzZvZ44sYeOKp4oZvssaeIioDNDG3aJF3ersxZZduc
 +OKfBjb8LRXeSR6drhKOZ1VP8kQmq3hJD9t7boISzKQDRrBZSUdAsUXJziMHgquPdzhJ
 Tj2wONkfmggxQ13rjNpHJc1aBmQ39gCZl+TKkO42a6s1mQQ7TPeuRzJp2H6xNfNRkvFa
 Hynw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=FGz+sFHxGqEHN5rxi1/IHD0K758Z+41MxAvfePk9lvQ=;
 b=UWBZmjWc1rjWfPr2tq5RIQWnPX07IzDna/T/EWc/xRNp0aB7tJ4/Hk9/RwXx1D3rxP
 dzEosItSQ99dALWCRZFtJ6mPSh39wJQE0tTfUcDqEVE9/6FvlvN4/kb948+t6FuOaprx
 jTB4WXzA16znBsgClu/xp/BFEoCdGrbirm3HN4DY/p02ngmRvpIozCoEriA2Hi8i6F09
 R7JaOAoSpuDSVaIogLBsEcAJRyCbDzfBFDa5cqkXjx0OWzG5rDd/0Pj7PG66L95nFxr2
 RXrTSnmUdyHA1GdrRFNtOTjxHOLQcWVn+E8Um/kV7svhCsxX9MgFjKX6pP7FbuaSjFHv
 R52Q==
X-Gm-Message-State: ANoB5pkVe8QvuBVyPi7pKdWDGrJYo+jwb1vw1DclK0y6iMrqoqsoXT4v
 l3Pde1duCO40NQb5UQeWWl7Ma/OgCv27Bw==
X-Google-Smtp-Source: AA0mqf5mw9ypZDB3ZsHHcG43pyqGXNWCWfWb80qzt2SEhHRCYVdiGC4D+Odb4u2C54oEPNqrYNYjDP4M94jmsg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6870:1eca:b0:144:1f0b:2d13 with SMTP
 id pc10-20020a0568701eca00b001441f0b2d13mr3542546oab.94.1669956932447; Thu,
 01 Dec 2022 20:55:32 -0800 (PST)
Date: Fri,  2 Dec 2022 04:55:25 +0000
In-Reply-To: <20221202045527.3646838-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221202045527.3646838-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-2-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 1/3] arm: pmu: Fix overflow checks for PMUv3p5
 long counters
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev
Cc: maz@kernel.org
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

PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. The consequence is that tests that check
the counter values after overflowing should not assume that values will be
wrapped around 32-bits: they overflow into the other half of the 64-bit
counters on PMUv3p5.

Fix tests by correctly checking overflowing-counters against the expected
64-bit value.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 29 ++++++++++++++++++-----------
 1 file changed, 18 insertions(+), 11 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index cd47b14..eeac984 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -54,10 +54,10 @@
 #define EXT_COMMON_EVENTS_LOW	0x4000
 #define EXT_COMMON_EVENTS_HIGH	0x403F
 
-#define ALL_SET			0xFFFFFFFF
-#define ALL_CLEAR		0x0
-#define PRE_OVERFLOW		0xFFFFFFF0
-#define PRE_OVERFLOW2		0xFFFFFFDC
+#define ALL_SET			0x00000000FFFFFFFFULL
+#define ALL_CLEAR		0x0000000000000000ULL
+#define PRE_OVERFLOW		0x00000000FFFFFFF0ULL
+#define PRE_OVERFLOW2		0x00000000FFFFFFDCULL
 
 #define PMU_PPI			23
 
@@ -538,6 +538,7 @@ static void test_mem_access(void)
 static void test_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, SW_INCR};
+	uint64_t cntr0;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -572,9 +573,9 @@ static void test_sw_incr(void)
 		write_sysreg(0x3, pmswinc_el0);
 
 	isb();
-	report(read_regn_el0(pmevcntr, 0)  == 84, "counter #1 after + 100 SW_INCR");
-	report(read_regn_el0(pmevcntr, 1)  == 100,
-		"counter #0 after + 100 SW_INCR");
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
+	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
+	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
 	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -584,6 +585,7 @@ static void test_sw_incr(void)
 static void test_chained_counters(void)
 {
 	uint32_t events[] = {CPU_CYCLES, CHAIN};
+	uint64_t cntr1;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
 		return;
@@ -618,13 +620,16 @@ static void test_chained_counters(void)
 
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
-	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
+	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
+	report(read_regn_el0(pmevcntr, 1) == cntr1, "CHAIN counter #1 wrapped");
+
 	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
 {
 	uint32_t events[] = {SW_INCR, CHAIN};
+	uint64_t cntr0, cntr1;
 	int i;
 
 	if (!satisfy_prerequisites(events, ARRAY_SIZE(events)))
@@ -665,10 +670,12 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
+	cntr0 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 0 : ALL_SET + 1;
+	cntr1 = (pmu.version < ID_DFR0_PMU_V3_8_5) ? 84 : PRE_OVERFLOW + 100;
 	report((read_sysreg(pmovsclr_el0) == 0x3) &&
-		(read_regn_el0(pmevcntr, 1) == 0) &&
-		(read_regn_el0(pmevcntr, 0) == 84),
-		"expected overflows and values after 100 SW_INCR/CHAIN");
+	       (read_regn_el0(pmevcntr, 1) == cntr0) &&
+	       (read_regn_el0(pmevcntr, 0) == cntr1),
+	       "expected overflows and values after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
