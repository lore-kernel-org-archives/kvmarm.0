Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4961C001B2
	for <kvmarm@archiver.kernel.org>; Tue, 20 Dec 2022 03:10:40 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C03B4B81F;
	Mon, 19 Dec 2022 22:10:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id omloIvcdl60M; Mon, 19 Dec 2022 22:10:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E12C24B7F7;
	Mon, 19 Dec 2022 22:10:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1ABDB4B5EE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xcqYn7TVOUdv for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Dec 2022 22:10:35 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD7BE4B5DB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 22:10:35 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 f11-20020a5b01cb000000b0070374b66537so12936654ybp.14
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Dec 2022 19:10:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=DzRaMHQSWDMQOYLi4LFm681DO4wmsRsX9iZ+PyKDp9w=;
 b=Xd2gh5uphWzH0JvVshIjL4yLbft1N1zhzk/j+R3dvrbSuRZ2Bi3bUvuXNszDBBzX1O
 uzb7YfFeHiwGrDNjuB136VOPiz3jILGfMBqJYKdax/gU1HMqb4syORIzzufxsxuBsDA0
 FdQ/HULBUK7pcZADN7SGLQLFm4qSN8f3oGZ+UZTbzbHDQ27L8WAVpj24uil20T3heA1I
 ess0DIqMFqhCroAIJmQfdUsMCMVH+lLpH+AZFhP33UUnjsj+A6m1tU7RHq3kS+tdGpf+
 NVF6UMSG3XKG0U6M3MSvw1bSJ6pfZ01nW7vH9EItab4YRy9yz0Ik20gnCR+tHIsrh1Fz
 s4CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=DzRaMHQSWDMQOYLi4LFm681DO4wmsRsX9iZ+PyKDp9w=;
 b=N0mmgd9MIM0P8BumGLa0yP3IiwOGhMWLtdyttpS3cL7R6dQHJ4k+aDxUiS9/k7blMz
 DyVmslYwIDmIs0kT0ckz0bJgZgFbu0M6gjEhR6XrQ/mAItv3AcyOqxPehzHOcRL1IZFa
 yEvEZYARImnFk8nhPtNSrT2KYhgMIWNFmMTNROKIAi7as4lQPb/ZU2ZhDzbAQhs8RA/2
 sf3G3EqLtWHWQfy3WmJ3nb3FfwsyXbACp3DhP9FoXXz5nSBUlUITyJXDBxFeuNfN+2lA
 RTVh7nybwgDZDp3GF/w181P6kE0OgAWHuRMbPsvce4BnM8ozp5yhcPQrlbeeCFafXNv8
 0nUg==
X-Gm-Message-State: ANoB5pmFbI69jxmLceQMH4vt6a/sWSUKG81lHgWIOV5ZmB3cA2Ee6FL+
 rcaQrNI52aN8YRsW8WwyDH9Ulzh+QRJFmg==
X-Google-Smtp-Source: AA0mqf7EDF6fes8LHciDwQCSCvRrmAybFtC4iF1GFNihPx9pNIA8bFaGjJUUopTMZMk+NXfuSIFGwgko7t8mQw==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d4d5:0:b0:70d:f50c:29ad with SMTP id
 m204-20020a25d4d5000000b0070df50c29admr6202325ybf.265.1671505835190; Mon, 19
 Dec 2022 19:10:35 -0800 (PST)
Date: Tue, 20 Dec 2022 03:10:28 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20221220031032.2648701-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH v2 0/4] arm: pmu: Add support for PMUv3p5
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

The first commit fixes the tests when running on PMUv3p5. The issue is that
PMUv3p5 uses 64-bit counters irrespective of whether the PMU is configured
for overflowing at 32 or 64-bits. Tests are currently failing [0] on
PMUv3p5 because of this. They wrongly assume that values will be wrapped
around 32-bits, but they overflow into the other half of the 64-bit
counters.

The second and third commits add new tests for 64-bit overflows, a feature
added with PMUv3p5 (PMCR_EL0.LP == 1). This is done by running all
overflow-related tests in two modes: with 32-bit and 64-bit overflows.
The fourt commit changes the value reporting to use %lx instead of %ld.

This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.

Changes from v1 (all suggested by Alexandru):
- report counter values in hexadecimal
- s/overflow_at_64bits/unused for all chained tests
- check that odd counters do not increment when using overflow_at_64bits
  (pmcr.LP=1)
- test 64-bit odd counters overflows
- switch confusing var names in test_chained_sw_incr(): cntr0 <-> cntr1

[0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
[1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/

Ricardo Koller (4):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Add tests for 64-bit overflows
  arm: pmu: Print counter values as hexadecimals

 arm/pmu.c | 240 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 149 insertions(+), 91 deletions(-)

-- 
2.39.0.314.g84b9a713c41-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
