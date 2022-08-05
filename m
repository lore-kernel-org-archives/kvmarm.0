Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB4CEC25B06
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 00:41:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 648824E739;
	Thu,  4 Aug 2022 20:41:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tscbyejnuBBo; Thu,  4 Aug 2022 20:41:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 160C44F12C;
	Thu,  4 Aug 2022 20:41:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43AC74EEE7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c5eWwqTBO0wo for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 20:41:47 -0400 (EDT)
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com
 [209.85.214.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D27A64EEEE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:47 -0400 (EDT)
Received: by mail-pl1-f202.google.com with SMTP id
 m5-20020a170902f64500b0016d313f3ce7so688905plg.23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 17:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=Xta+5jo8D6n81XJuayprsG3hqDUXpAb03ORZYKyImH4=;
 b=RcLA+Zq6qXG6nb04SDIiGKmGfbCjaUmQHtwXC1JnydFtyVyLLMtlMQeiflZpyQQShe
 gc8i0Qf2HjjDPJ8+bU5u/lYqVMCwt4NkCuLtTmLATivhuQ4jDLvjTVDtrhwbqWioAkj/
 1hqY5MHriXKZFBBU9LOHs8QEFSGyW/bcLZOBvLsLdqb3z1bAJBlA3d6pZ2fN71sP3DUb
 Uub6M+XqHqb8QYF6tjOGm4TAQvYltIv9Nq0/MkdYsByZPNCsOF3AAEKPBx5kacU0gfXv
 7WIozOVVwetMYn24DdfRZ7AY8AfJBPAiXn9+UVFwINsLawhwbNJAB0kxF+V6lOS/C/eq
 oSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=Xta+5jo8D6n81XJuayprsG3hqDUXpAb03ORZYKyImH4=;
 b=nFyBBiHpk95ebU9X3jhWXjb5HP0yldg/FSmvuJyOEYcUvfQ39zhYnshPxX/zdPbUJ+
 Fmb8EAPq6UEWnpxxo3L7Jdjpwg7wZK6TyIshpVDZFlhsl8ycr0F1ULP4roxABJ4VesuH
 HQPTBI9IiY6rfXfRlCk1f2U8OtWKNtnrAZyiy/M2ikzO15eXxQqUBpiqVymotriIUe3a
 lnC3VyD9rIxrGuBI7Ls+fCo0eP1fY45MDwnuYB7mPNQZ9QcvMWmU1AffAy6BE4+t9Sy0
 vnGGqdEfgmnyzWYKbWynlRtObasH6aEkrTIQALEs/je1yxmuaqE9PJHJ7T9lp3aHtFxS
 G7rQ==
X-Gm-Message-State: ACgBeo30hkUETUP0A1nTFNjFHqiqwApvWN7W1aSqkWWt6hhdUxgzSqo2
 Bo7rE+Vc9IKd6+H/bnXqdiG8fsnsWVPATw==
X-Google-Smtp-Source: AA6agR6p25PD3cnGmsDcBFcmo0zDtZpWTFOCJEQtR8qZiBsp87t52hcZ+Nvb74raqLa83wm/kDnE1jbD4eqerg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:1d26:b0:52b:fb6f:e44d with SMTP
 id a38-20020a056a001d2600b0052bfb6fe44dmr4198613pfx.6.1659660107068; Thu, 04
 Aug 2022 17:41:47 -0700 (PDT)
Date: Thu,  4 Aug 2022 17:41:39 -0700
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
Message-Id: <20220805004139.990531-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220805004139.990531-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 3/3] arm: pmu: Check for overflow in the low
 counter in chained counters tests
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

A chained event overflowing on the low counter can set the overflow flag
in PMOVS.  KVM does not set it, but real HW and the fast-model seem to.
Moreover, the AArch64.IncrementEventCounter() pseudocode in the ARM ARM
(DDI 0487H.a, J1.1.1 "aarch64/debug") also sets the PMOVS bit on
overflow.

The pmu chain tests fail on bare metal when checking the overflow flag
of the low counter _not_ being set on overflow.  Fix by checking for
overflow. Note that this test fails in KVM without the respective fix.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 12e7d84e..0a7e12f8 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -583,7 +583,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
 	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
 
 	/* test 64b overflow */
 
@@ -595,7 +595,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_regn_el0(pmevcntr, 1, ALL_SET);
@@ -603,7 +603,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
-	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
@@ -629,8 +629,9 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
-		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report((read_sysreg(pmovsclr_el0) == 0x1) &&
+		(read_regn_el0(pmevcntr, 1) == 1),
+		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
@@ -648,10 +649,10 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+	report((read_sysreg(pmovsclr_el0) == 0x3) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
-		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
+		"expected overflows and values after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 }
@@ -731,8 +732,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -759,8 +761,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"32b->64b: CHAIN counter incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"32b->64b: CHAIN counter incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -868,8 +871,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	isb();
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0),
-		"no overflow interrupt expected on 32b boundary");
+	report(expect_interrupts(0x1),
+		"expect overflow interrupt on 32b boundary");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
@@ -877,8 +880,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	isb();
 	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0x2),
-		"expect overflow interrupt on odd counter");
+	report(expect_interrupts(0x3),
+		"expect overflow interrupt on even and odd counter");
 }
 #endif
 
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
