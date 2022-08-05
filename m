Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EB41C25B0D
	for <kvmarm@archiver.kernel.org>; Fri,  5 Aug 2022 00:41:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 264AB4EDD6;
	Thu,  4 Aug 2022 20:41:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WYvo1V2h+DgZ; Thu,  4 Aug 2022 20:41:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030F04EF21;
	Thu,  4 Aug 2022 20:41:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D881D4ED16
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xhNllOVcYKJd for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Aug 2022 20:41:46 -0400 (EDT)
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com
 [209.85.210.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26F3B4EAE7
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Aug 2022 20:41:46 -0400 (EDT)
Received: by mail-pf1-f201.google.com with SMTP id
 bq15-20020a056a000e0f00b0052af07b6c6bso445928pfb.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Aug 2022 17:41:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:from:to:cc;
 bh=IkUE99B0TchNS4vqhItmmclxhXXwJ9wxAc8kOQ5+evM=;
 b=iVfcJW8RlHTsp+7/8Ai9Ar6TcPX/EvMkfx9Ea9osF8B/WeFcKJTGR5MvNNv1C9aR3D
 dPpsi/u/rJgjH15v3faO9zC5EdKesI2rs6biTyr0ayp3x4Opjln4sViOrhtDPkYsZN7/
 zHVUvjuftQKLseSsX4XYZlVEgF6fOEz2Xj8E/EaEbrafUJIVz6AUoLSnACjkTHbWvkHQ
 f5aJ8ht6Mq6aHZvmE4wyLtd09SO09NWmoNiCvYnmZXQotuzZoZUKbZu3Hn0r4aDZvoYI
 UXPhVBkqEinpEnZKG2rptUcvNeJS4pVhflPwPB9WGEvk98udF50S2IvLo9GRJhqGi9GH
 BhQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
 :date:x-gm-message-state:from:to:cc;
 bh=IkUE99B0TchNS4vqhItmmclxhXXwJ9wxAc8kOQ5+evM=;
 b=tzkZPJpEndZlxqtRfzWw4w/xoqrfvutEMsnPSONsRs/kokYO8pAFuSsVMoea2Q60Gd
 z9OoB0OS6pKxTfG0Cl2HpEb+Ntsed1MPbPG8a+NEbcrfs8rD1xpDqHqYHE5rCITYZmAy
 zGppnkUELgILILV9xGGg3udfyPNo0f3hlctJMrk6FoVNqPqCLqI7PEcEj1+PZtyDLfIP
 xJYjVS3UVBsf6f6r5LTA1y9mmNcCEziZGJRHRX/wfrry8Y4Az5ehGztxRKgHOokgBMuv
 Toh6Hdz83S/SucVqiFoAzJ4SrieRbRyOwYnbAKO+zZ4xl6u6mS5Q9bKMsI7kAREvdKIM
 C0/Q==
X-Gm-Message-State: ACgBeo2vAFE7Wh79E3xO0WYP/e/YuaHjAoJ75TzQgLGh5NONTIVPUpTR
 TDtDZT2+V2dWtSUWZOFlvQMp5Z6RkMx/iA==
X-Google-Smtp-Source: AA6agR4TcLN6Lga7RRZ0+dyIKf0ldH3fBJqtB88WLNxRgIPNyZKd3Bc+sF7uqhYAz2fvChCj+ulwcPDPdw6XaQ==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a616:b0:16d:b3cf:9fe3 with SMTP
 id u22-20020a170902a61600b0016db3cf9fe3mr4127366plq.99.1659660105374; Thu, 04
 Aug 2022 17:41:45 -0700 (PDT)
Date: Thu,  4 Aug 2022 17:41:38 -0700
In-Reply-To: <20220805004139.990531-1-ricarkol@google.com>
Message-Id: <20220805004139.990531-3-ricarkol@google.com>
Mime-Version: 1.0
References: <20220805004139.990531-1-ricarkol@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [kvm-unit-tests PATCH v3 2/3] arm: pmu: Reset the pmu registers
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
index 4c601b05..12e7d84e 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -826,7 +826,7 @@ static void test_overflow_interrupt(void)
 	write_regn_el0(pmevcntr, 1, PRE_OVERFLOW);
 	isb();
 
-	/* interrupts are disabled */
+	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
 	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
@@ -842,7 +842,7 @@ static void test_overflow_interrupt(void)
 	isb();
 	report(expect_interrupts(0), "no overflow interrupt after counting");
 
-	/* enable interrupts */
+	/* enable interrupts (PMINTENSET_EL1 <= ALL_SET) */
 
 	pmu_reset_stats();
 
@@ -890,6 +890,7 @@ static bool check_cycles_increase(void)
 	bool success = true;
 
 	/* init before event access, this test only cares about cycle count */
+	pmu_reset();
 	set_pmcntenset(1 << PMU_CYCLE_IDX);
 	set_pmccfiltr(0); /* count cycles in EL0, EL1, but not EL2 */
 
@@ -944,6 +945,7 @@ static bool check_cpi(int cpi)
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
