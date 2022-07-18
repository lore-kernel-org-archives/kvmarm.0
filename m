Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C8ACCA482
	for <kvmarm@archiver.kernel.org>; Mon, 18 Jul 2022 15:49:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A174D3AB;
	Mon, 18 Jul 2022 11:49:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id v7iBU5hrWbh4; Mon, 18 Jul 2022 11:49:20 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 32A264D769;
	Mon, 18 Jul 2022 11:49:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F694D4E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WMXENWD414o0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2022 11:49:18 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A5784D44A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 11:49:17 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 p10-20020a170902e74a00b0016c3f3acb51so6897726plf.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2022 08:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=tr1adnag8rLEQO6ZSct7qpTF68eGMGiTHDrAuDcnvTM=;
 b=g+86Cpm6aI2ALmntVwxDfmXwwqLRFwWD1mKhCk67HT6khla4fghcvnKWs9icM02IJy
 U69Le5z1MTLibkErj/i9unqF4527hMxkXr2n5TvRF2P0t7gXFBgy8kYzV+yQvtEm6cUk
 fyYYoHCkDBnt1b4MEvzYt9cXlcJm4WabKEDuUzZ6Mw7P/LXDdmVe9UjnbI6mmBM7iTPq
 rPA/h+9SNvzH1wnN2P3OplRyhswr/cilCKwnrkWh8v9fJgswknCKcX4MmOD8+xIbzLr0
 N115nbXVPoCBCUQvCcrIUY1B5/ZjzJmuqt2hiPo7JdKCA/ZzqY54ReAAjWTCZH2WZmEt
 zmsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=tr1adnag8rLEQO6ZSct7qpTF68eGMGiTHDrAuDcnvTM=;
 b=IcCW7yNgJwZhaGwZqkjFvheGfg7NSPbVgvirVn+uIsFYxj6s0RvCOPQDlA3I6sRKAe
 e08QFeZPE44NM/O1vW7+QcjGGvaiIkwqiqfYdVV8P74HfagRESxjfggPBf1NttkInlcX
 TugXlLbV4eUYRduqU+pWb2ezrRqDbonYgxo6JngJUcXCeKVH7Jo2I63I5QuHx9bFAl7o
 hOngI5uhXJlWVpiJpaDEB9vmsazgsBJwGSdvTvfwO1rPaB/zfQtnOeT8TzGX08AdvQqB
 0Do2+rrYj1KLTCQSBHwzJ7Mwc7I5MXe+L8lpyTFY06ZwGx6b/QyoOR2clkPYKnbu8mT7
 waIQ==
X-Gm-Message-State: AJIora+Jo7JGSY+0wf8mPqjjUwv2KUDgTRDIS66h4cZ5tBQ5I8ZPtp45
 D5MFwfk6q/BtjMZQPQJnMOyRwhiGvWN0pQ==
X-Google-Smtp-Source: AGRyM1tTNPv7SmG4wK1haaBWjYyP1C1LxeIzT8jVdcAagvhMT9lcJpJDdDaV0QCIUQTmG1L5C/7CE9R6z0NyvQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:249:b0:1e0:a8a3:3c6c with SMTP id
 t9-20020a17090a024900b001e0a8a33c6cmr107pje.0.1658159355896; Mon, 18 Jul 2022
 08:49:15 -0700 (PDT)
Date: Mon, 18 Jul 2022 08:49:08 -0700
In-Reply-To: <20220718154910.3923412-1-ricarkol@google.com>
Message-Id: <20220718154910.3923412-2-ricarkol@google.com>
Mime-Version: 1.0
References: <20220718154910.3923412-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.0.170.g444d1eabd0-goog
Subject: [kvm-unit-tests PATCH 1/3] arm: pmu: Add missing isb()'s after sys
 register writing
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

There are various pmu tests that require an isb() between enabling
counting and the actual counting. This can lead to count registers
reporting less events than expected; the actual enabling happens after
some events have happened.  For example, some missing isb()'s in the
pmu-sw-incr test lead to the following errors on bare-metal:

	INFO: pmu: pmu-sw-incr: SW_INCR counter #0 has value 4294967280
        PASS: pmu: pmu-sw-incr: PWSYNC does not increment if PMCR.E is unset
        FAIL: pmu: pmu-sw-incr: counter #1 after + 100 SW_INCR
        FAIL: pmu: pmu-sw-incr: counter #0 after + 100 SW_INCR
        INFO: pmu: pmu-sw-incr: counter values after 100 SW_INCR #0=82 #1=98
        PASS: pmu: pmu-sw-incr: overflow on counter #0 after 100 SW_INCR
        SUMMARY: 4 tests, 2 unexpected failures

Add the missing isb()'s on all failing tests, plus some others that are
not currently required but might in the future (like an isb() after
clearing the overflow signal in the IRQ handler).

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arm/pmu.c b/arm/pmu.c
index 15c542a2..fd838392 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -307,6 +307,7 @@ static void irq_handler(struct pt_regs *regs)
 			}
 		}
 		write_sysreg(ALL_SET, pmovsclr_el0);
+		isb();
 	} else {
 		pmu_stats.unexpected = true;
 	}
@@ -534,6 +535,7 @@ static void test_sw_incr(void)
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
@@ -547,6 +549,7 @@ static void test_sw_incr(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
 
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
@@ -618,6 +621,8 @@ static void test_chained_sw_incr(void)
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
@@ -634,6 +639,8 @@ static void test_chained_sw_incr(void)
 	write_regn_el0(pmevcntr, 1, ALL_SET);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x1, pmswinc_el0);
 
@@ -821,6 +828,8 @@ static void test_overflow_interrupt(void)
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E);
+	isb();
+
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x2, pmswinc_el0);
 
@@ -879,6 +888,7 @@ static bool check_cycles_increase(void)
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
 	set_pmcr(get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E);
+	isb();
 
 	for (int i = 0; i < NR_SAMPLES; i++) {
 		uint64_t a, b;
@@ -894,6 +904,7 @@ static bool check_cycles_increase(void)
 	}
 
 	set_pmcr(get_pmcr() & ~PMU_PMCR_E);
+	isb();
 
 	return success;
 }
-- 
2.37.0.170.g444d1eabd0-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
