Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2D9EC4708D
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 03:10:47 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9B2334B811;
	Mon, 19 Dec 2022 22:10:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id iP3Y-v2XwDhd; Mon, 19 Dec 2022 22:10:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 719E04B84A;
	Mon, 19 Dec 2022 22:10:45 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E77254B823
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:44 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SuCYzsYIHu9S for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 22:10:42 -0500 (EST)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAD9B4B5EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:42 -0500 (EST)
Received: by mail-pj1-f73.google.com with SMTP id
 p11-20020a17090a680b00b002233455d706so4418867pjj.4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=Q10rUBAMPp02OLhY9eCZCmG3XUyvR5sIHjaDQiVf8kk=;
 b=Tvafgg6lFog2gJPmCOGhUj8Gk0WzLIFS7rEmTaCtNS+wVfoRMaNckCyqEeYcfCMi44
 r3+3Q+WD5gPtX8afrAtXbryso5Gf+Hr3Pb/yeZHfRoUK1MDHquixZ8yqSiFDmHL515iL
 uZJbQUo27JjPfEFhq9NQkIV1yO1R1CQDLKq8x17erkYpAFFmET4hq85pFlO8F6MELIH9
 USR50ALgV96KN3DSQgvUVOn9BQ3Kl0lTe/BYaGi/DUCL+AuAjQFT/hKCdbRph76n5mcb
 6mN0BbPpaSHn8frr6wxGnG0HIoorI9/Glt/Afy8Fz7JeBZlfv+JT5EhzStQVnyI9fyC3
 C/cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=Q10rUBAMPp02OLhY9eCZCmG3XUyvR5sIHjaDQiVf8kk=;
 b=7Y5SuIJxprlK1EG3f3R3K6tX3Lu4wExODWUFEK6R6FVBljmM3WJKGnKKqr3mZvtOU9
 jPXRo+ttq9TPCrj5P1wqastLnPOnyEVpMw9YMl6eGKQ1ZWqXBA5qSRgJW+aVmlIYAoln
 7dE71wGuukg6i3e1nOwrTHnUfzoBP2Zi6y7OYF1wGgZeeRFweQMnWqrbGDqLQu0a1wuj
 vdo4jyHRg9nMzJkiolakQ9mXeeIL5Dl0G9iiLkKPLV0A1cXRrub2G+EUoSb3wxlFD6it
 B8FgOJQT2mJrhsHU1KzTOFh9tGA2QkPYsfU/dB38B9YCATw7OfiSrlm88KHmsLEVqUhO
 q2ng==
X-Gm-Message-State: ANoB5pmSXSj8z2eCFVhsov6PNuttgwK4MXbYQxkxWzd1MuhJwmh+fQPS
 bBdKjsVRzzX8UlTkHNIHmfiV4i3+K/twSw==
X-Google-Smtp-Source: AA0mqf61vT9Jbaw7sgIBUPagUbDMGnQGx8IGqPTGr0B37Fpqbf+yIDfkZdKydSege8UhWLjgoKJXsr6BdGr+jg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:84c7:0:b0:574:9b8d:1873 with SMTP id
 x7-20020aa784c7000000b005749b8d1873mr68849788pfn.75.1671505842066; Mon, 19
 Dec 2022 19:10:42 -0800 (PST)
Date: Tue, 20 Dec 2022 03:10:32 +0000
In-Reply-To: <20221220031032.2648701-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221220031032.2648701-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-5-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 4/4] arm: pmu: Print counter values as
 hexadecimals
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

The arm/pmu test prints the value of counters as %ld.  Most tests start
with counters around 0 or UINT_MAX, so having something like -16 instead of
0xffff_fff0 is not very useful.

Report counter values as hexadecimals.

Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 680623d..b6b2871 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -537,8 +537,8 @@ static void test_mem_access(bool overflow_at_64bits)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	isb();
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
-	report_info("counter #0 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
-	report_info("counter #1 is %ld (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
+	report_info("counter #0 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 0));
+	report_info("counter #1 is 0x%lx (MEM_ACCESS)", read_regn_el0(pmevcntr, 1));
 	/* We may measure more than 20 mem access depending on the core */
 	report((read_regn_el0(pmevcntr, 0) == read_regn_el0(pmevcntr, 1)) &&
 	       (read_regn_el0(pmevcntr, 0) >= 20) && !read_sysreg(pmovsclr_el0),
@@ -553,7 +553,7 @@ static void test_mem_access(bool overflow_at_64bits)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(read_sysreg(pmovsclr_el0) == 0x3,
 	       "Ran 20 mem accesses with expected overflows on both counters");
-	report_info("cnt#0 = %ld cnt#1=%ld overflow=0x%lx",
+	report_info("cnt#0=0x%lx cnt#1=0x%lx overflow=0x%lx",
 			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1),
 			read_sysreg(pmovsclr_el0));
 }
@@ -584,7 +584,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report_info("SW_INCR counter #0 has value %ld", read_regn_el0(pmevcntr, 0));
+	report_info("SW_INCR counter #0 has value 0x%lx", read_regn_el0(pmevcntr, 0));
 	report(read_regn_el0(pmevcntr, 0) == pre_overflow,
 		"PWSYNC does not increment if PMCR.E is unset");
 
@@ -604,7 +604,7 @@ static void test_sw_incr(bool overflow_at_64bits)
 		(uint64_t)pre_overflow + 100;
 	report(read_regn_el0(pmevcntr, 0) == cntr0, "counter #0 after + 100 SW_INCR");
 	report(read_regn_el0(pmevcntr, 1) == 100, "counter #1 after + 100 SW_INCR");
-	report_info("counter values after 100 SW_INCR #0=%ld #1=%ld",
+	report_info("counter values after 100 SW_INCR #0=0x%lx #1=0x%lx",
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 	report(read_sysreg(pmovsclr_el0) == 0x1,
 		"overflow on counter #0 after 100 SW_INCR");
@@ -680,7 +680,7 @@ static void test_chained_sw_incr(bool unused)
 	report((read_sysreg(pmovsclr_el0) == 0x1) &&
 		(read_regn_el0(pmevcntr, 1) == 1),
 		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
@@ -705,7 +705,7 @@ static void test_chained_sw_incr(bool unused)
 	       (read_regn_el0(pmevcntr, 0) == cntr0) &&
 	       (read_regn_el0(pmevcntr, 1) == cntr1),
 	       "expected overflows and values after 100 SW_INCR/CHAIN");
-	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
+	report_info("overflow=0x%lx, #0=0x%lx #1=0x%lx", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
 
@@ -737,11 +737,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, 20, pmu.pmcr_ro | PMU_PMCR_E);
 	report(!read_regn_el0(pmevcntr, 1) && (read_sysreg(pmovsclr_el0) == 0x1),
 		"odd counter did not increment on overflow if disabled");
-	report_info("MEM_ACCESS counter #0 has value %ld",
+	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
-	report_info("CHAIN counter #1 has value %ld",
+	report_info("CHAIN counter #1 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 1));
-	report_info("overflow counter %ld", read_sysreg(pmovsclr_el0));
+	report_info("overflow counter 0x%lx", read_sysreg(pmovsclr_el0));
 
 	/* start at 0xFFFFFFDC, +20 with CHAIN enabled, +20 with CHAIN disabled */
 	pmu_reset();
-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
