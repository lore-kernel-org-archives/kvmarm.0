Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282C4C43334
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 15:49:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C8C644D6FE;
	Mon, 18 Jul 2022 11:49:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nW2hQuZjab4v; Mon, 18 Jul 2022 11:49:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DD7D4D769;
	Mon, 18 Jul 2022 11:49:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C95234D4E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CKxNaFxqfT6w for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 11:49:21 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4C7F24D776
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:20 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 v19-20020a17090abb9300b001ef7bbd5a28so9715499pjr.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 08:49:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rfoG4qLeZytJWA1isKua1kICmPqasbDSZhpe1qk8ong=;
 b=S+txijMRAXsBEVF7o8XsVyUv2tIUOax/KO6CSpJ80iRzhpiZRWO8usijOfOPrCy45O
 MbwjIf6ZVRbYe9T8gT4X7+jJw9vFIWJ6Bki8/H5Q/gynvSxzqSc/d1jdeQsxE5e4vojs
 ikHteJAq2Klks/JcFubdBFyXdyLskvGIAzz5eG3NQgr4BE/TMcqDu6gocB9DRXR1BIbw
 tR7JctWQbwx6QgAi4wV3XL97XXWRvgF8rqQjOR7XFZ3u/c3kg0m0V5sKTl3UufwkkkwF
 TuzJDgPsxwwKCD17R3XPjcQce2oaQGh/P7T3GHco8mZU4Ba+9J8oT9OAVpEmtsonwVa3
 upwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rfoG4qLeZytJWA1isKua1kICmPqasbDSZhpe1qk8ong=;
 b=lCPbmVvVQnR/xuCErTccs6XhOonoSzTWNSaHPILjsre7PIf0aHQdVIE8IGpb+1ZzZz
 hqG0vLQsmRfNaFzePdVhbFrrNEr8UgzOMPocKLRiIaiVQyxFZrzf7cQGgmhVr/yhqD9A
 cQqFd1fqlCQEFsDvPKAtOxxIbUK1pn4ERe6oOW9MmXTxXT73aPc7K+7J6R7tImUO1cWC
 MomLiB08o8NKmsinrKxMehIYv05b7QWRDU5vxoqkMWoFEn72doXVtZxSSB1IImtZfIq/
 ePKGH97Kg7G5t7CZjPjHhS0GmuwTa4ua01oMCeHYHUpw6KAJ6z/CwuZwyzk4C+orgaEq
 0hlg==
X-Gm-Message-State: AJIora/wc7PULYu0wJh3kJqaG5fgwd3bjQ8ic1lWmAcTv7WSYYpm9qUv
 8zMAZXj3MJOKiX5V2A8fzwq6D4oGV8Hyfw==
X-Google-Smtp-Source: AGRyM1sd98nCGMNOituotgp5UUesMEtGF7CPQtTVuIgTG5IhZZNqSEF6WTSMMTCYQ0EWauFX0K+i44bds9ZdIQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:8c0a:b0:1ef:7c95:3f00 with SMTP
 id a10-20020a17090a8c0a00b001ef7c953f00mr32345198pjo.180.1658159359484; Mon,
 18 Jul 2022 08:49:19 -0700 (PDT)
Date: Mon, 18 Jul 2022 08:49:10 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 3/3] arm: pmu: Remove checks for !overflow in
 chained counters tests
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, drjones@redhat.com
Cc: maz@kernel.org, oliver.upton@linux.dev
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
of the low counter _not_ being set on overflow.  Fix by removing the
checks.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a7899c3c..4f2c5096 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -581,7 +581,6 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
 	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
 
 	/* test 64b overflow */
 
@@ -593,7 +592,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+	report((read_sysreg(pmovsclr_el0) & 0x2) == 0, "no overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_regn_el0(pmevcntr, 1, ALL_SET);
@@ -601,7 +600,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
-	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+	report(read_sysreg(pmovsclr_el0) & 0x2, "overflow on chain counter");
 }
 
 static void test_chained_sw_incr(void)
@@ -626,10 +625,10 @@ static void test_chained_sw_incr(void)
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
-	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
-		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report(read_regn_el0(pmevcntr, 1) == 1,
+			"no chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
-		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
+			read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
 	/* 64b SW_INCR and overflow on CHAIN counter*/
 	pmu_reset();
@@ -644,7 +643,7 @@ static void test_chained_sw_incr(void)
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
-	report((read_sysreg(pmovsclr_el0) == 0x2) &&
+	report((read_sysreg(pmovsclr_el0) & 0x2) &&
 		(read_regn_el0(pmevcntr, 1) == 0) &&
 		(read_regn_el0(pmevcntr, 0) == 84),
 		"overflow on chain counter and expected values after 100 SW_INCR/CHAIN");
@@ -727,8 +726,8 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1),
+		"CHAIN counter enabled: CHAIN counter was incremented");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -755,8 +754,8 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"32b->64b: CHAIN counter incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1),
+		"32b->64b: CHAIN counter incremented");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
