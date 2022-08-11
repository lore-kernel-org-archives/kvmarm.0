Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92ED9C25B0F
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 18:52:27 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B1DE4E9A3;
	Thu, 11 Aug 2022 14:52:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qI2InBFcjkAB; Thu, 11 Aug 2022 14:52:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 075FA4E99F;
	Thu, 11 Aug 2022 14:52:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EFF7E4E996
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ci3+2V3LAF2c for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 14:52:21 -0400 (EDT)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 945AA4E995
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:21 -0400 (EDT)
Received: by mail-pl1-f201.google.com with SMTP id
 w18-20020a170902e89200b0016eff609594so11897842plg.11
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 11:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=p/ppzg47C+97FQWYd9dFXNdGPOMPqma4qKXwXuPgUEk=;
 b=RJJ9hUqaDoF3x4wOjJ6z7ndtxl2qLnCUzPGlaHF/3CmeduXZqBg0iE3BFQ6Qv6dMO/
 VRfyehBYbA3v6+h71gG32HcjhWcsm902d74UQtzlSDwyV9IBMwVFGwHUtIJPehvPvktb
 f7Aj88/tOSjsxK1DZTWoSTRMbh/yOQQeQrAR8XXj26NlYY1PHDq+ziqMlCfexDtvebn4
 lR5i0DH5dYvNjcKsS1oJaqaeOOyqTuMJ4Sn5ZhWbm/JU5T9/Iq50GoIdz4dL/kyo09zt
 n6/hVmqQOZV4QwxtUD5K13b3bzgAatKkOa3BjhYIMi1+VCDar6qi9bsS46jhc9MbNqv/
 pmBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=p/ppzg47C+97FQWYd9dFXNdGPOMPqma4qKXwXuPgUEk=;
 b=QuV/HFDqkjzLzQN4TSvA8LevH0D3XSoSq7aR7TbgvykQytj8ESsZqqjmJ8c13MhPcb
 Zt1VuZJMaZTgDChqFFsqOi63NDkt+mcPLbEUst9fyqq1ysB5R/6keRoaB/WAP30VKO1U
 AEzVwYMHop1AvMMuysvE9ss/uz2Tn0ojRCP1VhD2LjVcI4jF7HHiV1MthkW9Ct0sk2Kr
 r8nZfrvLlINyCOpLQjgpEJcJOjxvxyijejdGI/nhUsAPcbNyaFSh+WUvNr+JWav5SG86
 XfY/uAqrvtmAPqvzjleQs0novUi+jaORlcQFF7VAF2hX0Ya5b50yk/ltYH/XoUwjY6+t
 c77g==
X-Gm-Message-State: ACgBeo2HBbafjricLJA/nurfw9rNnBtSXLr6PaGWUo02wU/F/HbqdDnX
 nnjW8LIEB+OcxwM6Iaf5Lj7OlkIPfYjPAw==
X-Google-Smtp-Source: AA6agR6YJTzzjFaC/q8A+drTaKkj/pLNeMM2KQKA4NMyV74jrlBe6FcpX+iBRMu2+bl5ZMHk/CQLEBN52PR/rg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:174e:b0:52b:c705:a42c with SMTP
 id j14-20020a056a00174e00b0052bc705a42cmr554586pfc.68.1660243940729; Thu, 11
 Aug 2022 11:52:20 -0700 (PDT)
Date: Thu, 11 Aug 2022 11:52:10 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-5-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 4/4] arm: pmu: Check for overflow in the low
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
index 756e0d26..cd47b14b 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -599,7 +599,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 
 	report(read_regn_el0(pmevcntr, 1) == 1, "CHAIN counter #1 incremented");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #1");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #1");
 
 	/* test 64b overflow */
 
@@ -611,7 +611,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(read_regn_el0(pmevcntr, 1) == 2, "CHAIN counter #1 set to 2");
-	report(!read_sysreg(pmovsclr_el0), "no overflow recorded for chained incr #2");
+	report(read_sysreg(pmovsclr_el0) == 0x1, "overflow recorded for chained incr #2");
 
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	write_regn_el0(pmevcntr, 1, ALL_SET);
@@ -619,7 +619,7 @@ static void test_chained_counters(void)
 	precise_instrs_loop(22, pmu.pmcr_ro | PMU_PMCR_E);
 	report_info("overflow reg = 0x%lx", read_sysreg(pmovsclr_el0));
 	report(!read_regn_el0(pmevcntr, 1), "CHAIN counter #1 wrapped");
-	report(read_sysreg(pmovsclr_el0) == 0x2, "overflow on chain counter");
+	report(read_sysreg(pmovsclr_el0) == 0x3, "overflow on even and odd counters");
 }
 
 static void test_chained_sw_incr(void)
@@ -645,8 +645,9 @@ static void test_chained_sw_incr(void)
 		write_sysreg(0x1, pmswinc_el0);
 
 	isb();
-	report(!read_sysreg(pmovsclr_el0) && (read_regn_el0(pmevcntr, 1) == 1),
-		"no overflow and chain counter incremented after 100 SW_INCR/CHAIN");
+	report((read_sysreg(pmovsclr_el0) == 0x1) &&
+		(read_regn_el0(pmevcntr, 1) == 1),
+		"overflow and chain counter incremented after 100 SW_INCR/CHAIN");
 	report_info("overflow=0x%lx, #0=%ld #1=%ld", read_sysreg(pmovsclr_el0),
 		    read_regn_el0(pmevcntr, 0), read_regn_el0(pmevcntr, 1));
 
@@ -664,10 +665,10 @@ static void test_chained_sw_incr(void)
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
@@ -747,8 +748,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"CHAIN counter enabled: CHAIN counter was incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"CHAIN counter enabled: CHAIN counter was incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -775,8 +777,9 @@ static void test_chain_promotion(void)
 	report_info("MEM_ACCESS counter #0 has value 0x%lx",
 		    read_regn_el0(pmevcntr, 0));
 
-	report((read_regn_el0(pmevcntr, 1) == 1) && !read_sysreg(pmovsclr_el0),
-		"32b->64b: CHAIN counter incremented and no overflow");
+	report((read_regn_el0(pmevcntr, 1) == 1) &&
+		(read_sysreg(pmovsclr_el0) == 0x1),
+		"32b->64b: CHAIN counter incremented and overflow");
 
 	report_info("CHAIN counter #1 = 0x%lx, overflow=0x%lx",
 		read_regn_el0(pmevcntr, 1), read_sysreg(pmovsclr_el0));
@@ -884,8 +887,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	isb();
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0),
-		"no overflow interrupt expected on 32b boundary");
+	report(expect_interrupts(0x1),
+		"expect overflow interrupt on 32b boundary");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
@@ -893,8 +896,8 @@ static void test_overflow_interrupt(void)
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
