Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48CE0C25B0E
	for <kvmarm@archiver.kernel.org>; Thu, 11 Aug 2022 18:52:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE214E992;
	Thu, 11 Aug 2022 14:52:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bEQxameBo8WT; Thu, 11 Aug 2022 14:52:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D89F64E98F;
	Thu, 11 Aug 2022 14:52:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 187874E993
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z-fUUYgoZbGT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Aug 2022 14:52:20 -0400 (EDT)
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com
 [209.85.128.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C410F4E99E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 14:52:19 -0400 (EDT)
Received: by mail-yw1-f202.google.com with SMTP id
 00721157ae682-31f46b4759bso155928927b3.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Aug 2022 11:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=hZ5qGKKiUKkw1fqPsVoeWYEgPkjp69U3hEQvPplzfvk=;
 b=GU5lkgJX69idfN2d8JbckBIkC4aHLRil8U4m/JOxyBQ0FK87bDtii7WCALqoXtsYEu
 8gt3Oi7J6uaZ7e77mig5FNqzNOAEz8h0GA21MH/Qy6x/l7lH1i2Cwj1wfI4cU5Ssjj9q
 xSIUnJyrv7l9JbMaz6NOwDRKQoNGbrRgLmtLx5uVvTyL0SY+SflE9iphBpBO2Zyfg1H0
 4LDMkO4qiSOAqzVLSzqPwPbJTvbqNnm457gBp1yAt4sGcru0y/w3USkBBvk+M39juQ5o
 uaJlabuMoyHSrfc+SIWXoQKDDtfD0GDcwK0gkzyIinHiHXRmF+4ShhXkXZ4orxtUgzuj
 KStA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=hZ5qGKKiUKkw1fqPsVoeWYEgPkjp69U3hEQvPplzfvk=;
 b=yAdBen3L2KcPzMatRp+wj40wICKPsLS2s/iEbjjMJYNKLAv1sz5SNh5hiW8cCz14wm
 IxsUwbSRltUkA1JmetN+JR1SNv36jati+BRMuV6JqQWAxKgeWIcvZncmHuf85+WyQGGb
 S3vg/XwSU6baJFrkvJkBJZoYgtfyGPmkr0CmCpQrd0NQH8lJ8ExhVElinvRh3ejOA5ru
 pMJOirosPojrg+F2zFVnVGeVbQtyaYV65bju9oseY8kP6ZSis6TvbbHQ9OleEbYmbfbR
 p/uUybIxLA1/kCRq1Bj211jiSktyZPoU4EvxBcNJtoKUXZ3jzBP4bcC0dDShGvDTjcDu
 iAww==
X-Gm-Message-State: ACgBeo07pmpMT8OTsuWkXKmaP/npuwwmNlHB28uaXEqEzsgIQjPscpxl
 h6FMaACbal4Mkb2QTQPage62cM2Vkf2HpQ==
X-Google-Smtp-Source: AA6agR70CWqtzcvuMK/sClY7Dw2wWjBzu7ZjCcMyhILiex8btb4PBZ86HtRsiEPXyfjMX31didUmEKfO3RYZ8g==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a81:9b47:0:b0:325:2240:ce5 with SMTP id
 s68-20020a819b47000000b0032522400ce5mr620224ywg.210.1660243939175; Thu, 11
 Aug 2022 11:52:19 -0700 (PDT)
Date: Thu, 11 Aug 2022 11:52:09 -0700
In-Reply-To: <20220811185210.234711-1-ricarkol@google.com>
Message-Id: <20220811185210.234711-4-ricarkol@google.com>
Mime-Version: 1.0
References: <20220811185210.234711-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v4 3/4] arm: pmu: Reset the pmu registers
 before starting some tests
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

Some registers like the PMOVS reset to an architecturally UNKNOWN value.
Most tests expect them to be reset (mostly zeroed) using pmu_reset().
Add a pmu_reset() on all the tests that need one.

As a bonus, fix a couple of comments related to the register state
before a sub-test.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index a5260178..756e0d26 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -858,7 +858,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -906,6 +906,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -960,6 +961,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.1.559.g78731f0fdb-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
