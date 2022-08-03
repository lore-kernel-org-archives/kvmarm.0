Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 364C2C19F2C
	for <kvmarm@archiver.kernel.org>; Wed,  3 Aug 2022 18:23:41 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B75374D189;
	Wed,  3 Aug 2022 14:23:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QVNc2ZyTSgHX; Wed,  3 Aug 2022 14:23:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33F8A4FB20;
	Wed,  3 Aug 2022 14:23:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D62814FAFC
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bIfsGtru-F4K for <kvmarm@lists.cs.columbia.edu>;
 Wed,  3 Aug 2022 14:23:36 -0400 (EDT)
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com
 [209.85.216.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6E3DF4FB19
 for <kvmarm@lists.cs.columbia.edu>; Wed,  3 Aug 2022 14:23:36 -0400 (EDT)
Received: by mail-pj1-f74.google.com with SMTP id
 o18-20020a17090aac1200b001f3252af009so1469680pjq.7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 03 Aug 2022 11:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=NCd9pZ1nHReYqpUxat1aRffhr9vnDsLXOgqhJFAxey4=;
 b=llw0yKtpNQpehkZ+QVXavGRSEMpGWCvk1V9rOY5p84zXQGCRh6aQK15QyIrz5fRQYV
 ksahlTxNw7rqH0KRxKGXwXS96EGD+yah7tZeI/ct+R/DdMRNGSg+FdmU7E5sYsy+JG83
 9mcTe5poTVEoB0PKjZePir/IDp8WBUPJJNmIZpzLeGA214xtAefmg8ZZenL+cI3KEgar
 ASOnLz344uqMuVY9bfA6e+s8b5I1QHmff5jNqpeShQMXEr3jprDSfi4gbDqk50KvPNqM
 BRwue+UlTPA1Z5h2X1RlWRJRThjGTPo+sHGsWYZOtk2iGvPk72aQcADalmF45dBqk2HK
 Zmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=NCd9pZ1nHReYqpUxat1aRffhr9vnDsLXOgqhJFAxey4=;
 b=HyJmgDUIT3Sg02X0At3zuKEgkucWDWv0lzkMBF3HLl8U0Py5P+YUQoVG15D3H2BGHG
 cY/u/hS31X6b8pNP2eDBt8TtJvDnoU8Hdep9ZG/dICfWGfaZHtJG7VT0wxlO1af51I7m
 fdLCWu70JgwGJY3fMh5OxwbyvsQGz8nxzxlCQfanpmMvUtUsm+iIa8dszpuhuZLnsHh/
 wni7hmJO6goH7ePx4jNclJtb003bHUvMRwzDidBgWdh0zEsihEaYLkvjo7Q9LIAFIfTz
 j+eFxG4eXUbgF4cjWE9cxiXUN9p93WXMIQM5NGjPMRVhNxzDKhhFsZeUB8R1Ry/y9YMh
 xHNg==
X-Gm-Message-State: ACgBeo2B51+4ALWMI57aWKi54i9KTZHghdbELhPF/MZOn6sI8cPQfWS2
 S9c/C5r0Pn2fUO0rKgZNb40N1Gn4SGxnBQ==
X-Google-Smtp-Source: AA6agR46+fS5xqb633nq44y0Z/Fa4yZf37XU33PssxOX+2ZsgstmTBevMRPV9uxYjBsBsCd1m35M1FfY2MCy0g==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:df03:b0:1f3:396c:dd94 with SMTP
 id gp3-20020a17090adf0300b001f3396cdd94mr435102pjb.1.1659551015065; Wed, 03
 Aug 2022 11:23:35 -0700 (PDT)
Date: Wed,  3 Aug 2022 11:23:27 -0700
In-Reply-To: <20220803182328.2438598-1-ricarkol@google.com>
Message-Id: <20220803182328.2438598-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220803182328.2438598-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [kvm-unit-tests PATCH v2 2/3] arm: pmu: Reset the pmu registers
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

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arm/pmu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 76156f78..7c5bc259 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -841,7 +841,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -889,6 +889,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -943,6 +944,7 @@ static bool check_cpi(int cpi)
 	uint32_t pmcr = get_pmcr() | PMU_PMCR_LC | PMU_PMCR_C | PMU_PMCR_E;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
-- 
2.37.1.455.g008518b4e5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
