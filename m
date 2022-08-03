Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17C64C19F28
	for <kvmarm@archiver.kernel.org>; Wed,  3 Aug 2022 18:23:44 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BDD114F547;
	Wed,  3 Aug 2022 14:23:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GbKxz-H8m9+o; Wed,  3 Aug 2022 14:23:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CF6D4FABB;
	Wed,  3 Aug 2022 14:23:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CAB5E403FD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oOUhMTC5Iif7 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2022 14:23:38 -0400 (EDT)
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com
 [209.85.216.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EFE3D4FB17
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:37 -0400 (EDT)
Received: by mail-pj1-f73.google.com with SMTP id
 q12-20020a17090aa00c00b001f228eb8b84so1480679pjp.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2022 11:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=FVFMELFSTgopXdyyg1vAr05TDgaRRWOAIMCURi85wlQ=;
 b=RtdafaWt5jSum8MWA8bEOoevkPgTvqI1vZC+MJDEhJ/RnPS8JdhJa26Q7Xvv4cPmdN
 SyMabGpPCWDv/S+zvgNjuHQZbtdg1nuTXIdWePy0kTY8JBRgZPwrHvGvL320nDTmM/ZA
 7fZS3ZVMSRFDrdLM/5jj9WtRYhH7vXlsZgio7CVArJzbW+4iNl9FYrA3OLP8cozl8vwU
 y2THh7EkNPsB/0SZKGKCgCv9voRZd1U4YjCIsgx9G8dHPZ9TFW9VVb0kPbuJa49cUjGD
 cQLUiNzJfMaKhr5UhuMJTKMrDSAnlGysFbYsAT73m5eBVJRgVIAC1Th/oTJ/mEKhVVnF
 7L8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=FVFMELFSTgopXdyyg1vAr05TDgaRRWOAIMCURi85wlQ=;
 b=bewVZZhyZ86Mezi+tBrUeUx/urrTBdDH+j1hb5iM15Ve/NJ3caGbV2yg3+NUy8D2Ob
 sYXEEDPxjP/mr//amg3RzRJoSvB2CN0vzmV/v0grNMXYs6nGj4i16cpMP+BoDcpUuJJs
 zb/l7WmoHveXZg8HDwsO337c3y4ggcAu6gmAwE5dFxDOmhkDXqNht22OAnSAVWM+mmfY
 q8RKBbPsSpPIacsdQDzggMjofJWFPMIvST3b9lz6QLgF/OqoJxiX0UWyaTplG3CD8Xnc
 JfYEYSW4TjoW40Z05RGnTe+Jz9AqbfQgFktlO0o1iTPiaDoCRCxmP5p8BSmBkhj/ewOT
 LnnQ==
X-Gm-Message-State: ACgBeo0GAkK/Z2w7KdHIvVUuWCM6hnqcIttS7K7509Sl6uMWEYAZeuZC
 HTlrvgupnNszNSyCDmY8SPgH+9UZY10acw==
X-Google-Smtp-Source: AA6agR7/j0qVYNg+PlMvNx4NVrtY/qJXCWsd5FcNscQ/kFRjr7TFokSdqFREl5h9gdtDyNh/kW+JJOpzN/Y6MQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1207:b0:16a:7e87:dad3 with SMTP
 id l7-20020a170903120700b0016a7e87dad3mr27763996plh.99.1659551017145; Wed, 03
 Aug 2022 11:23:37 -0700 (PDT)
Date: Wed,  3 Aug 2022 11:23:28 -0700
In-Reply-To: <20220803182328.2438598-1-ricarkol@google.com>
Message-Id: <20220803182328.2438598-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220803182328.2438598-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 3/3] arm: pmu: Check for overflow in the low
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 33 ++++++++++++++++++---------------
 1 file changed, 18 insertions(+), 15 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 7c5bc259..258780f4 100644
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
+		"overflow on even and odd counters,  and expected values after 100 SW_INCR/CHAIN");
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
@@ -867,8 +870,8 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW);
 	isb();
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
-	report(expect_interrupts(0),
-		"no overflow interrupt expected on 32b boundary");
+	report(expect_interrupts(0x1),
+		"expect overflow interrupt on 32b boundary");
 
 	/* overflow on odd counter */
 	pmu_reset_stats();
@@ -876,8 +879,8 @@ static void test_overflow_interrupt(void)
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
2.37.1.455.g008518b4e5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
