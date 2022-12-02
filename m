Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D79EC4332F
	for <kvmarm@archiver.kernel.org>; Fri,  2 Dec 2022 04:55:36 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A35704B086;
	Thu,  1 Dec 2022 23:55:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7ru3j0S4NlmF; Thu,  1 Dec 2022 23:55:34 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 814C343C96;
	Thu,  1 Dec 2022 23:55:34 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F65549E34
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yTrpeye9zfvu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  1 Dec 2022 23:55:32 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E671140CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  1 Dec 2022 23:55:31 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 h3-20020a170902f54300b00189af47afd0so4924043plf.9
 for <kvmarm@lists.cs.columbia.edu>; Thu, 01 Dec 2022 20:55:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
 :date:message-id:reply-to;
 bh=ePSSoXiRCXLATVJ0brBTRlEDHpo+JqW+vLuJHQVEQoU=;
 b=BSDooaNj6M7Kvuy7OQ/0DLnUNn6HYbSz/gio2djUCKkrKrK9e4j7OZfNXRWH3mHGz0
 EXRWJ+j1+94AQR431HTsys4faQTpNRPJI9FjA6BFvNJdKQMaCKyh0OJQ/Kue1P+jHOIh
 /4yIeTXB/8SAl0d2UXW/2x5fc8A5HnV5Z7XAiGo2twWr4BWCGzpkXflZMdNVaFMdIBqN
 6Hj8urTTOqciV9VOB0p0+C8Rm8/a6kF0jgPVxx2TfBmp86conFVMDcnuBl1jOx5QmQ9l
 6iVvuHdSj+Z1lNQusHhNTonoUqntCvXLMREUNG0MWk1IsYGddSIku1073bkx2KxozYVi
 gC5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
 :from:to:cc:subject:date:message-id:reply-to;
 bh=ePSSoXiRCXLATVJ0brBTRlEDHpo+JqW+vLuJHQVEQoU=;
 b=LuLwQX0erSwPni+Ag6nHzqhKDAUbyHyNGj9Klg3bS3b82cgEKHR7rkRPd5f7h5of8M
 hGTnWKzNPGkfhnZHRjr3MC4C+NV5YCNn5gqOIK7KIB9XlBWd+9hnAUrR8A2xILqp4FRA
 9doyOq7lPdQuE1a2VENv73WFyPB0PFLpNurT3fH4L01f8mnMe7upyFPbi2AcBPVVewmv
 bLk6IMwG20wsWN08s1yu4edEauusX7WOWh1dFgoQyXqcc1BWpbnM6MXgEmh+s2PkgXfH
 cv/iLJxbWSpnmWCbJ2z/nF4Vx58Ts0vp8kPM3QxD66k3SBrXrH92bzq7OAPwsFhdRL95
 CmEg==
X-Gm-Message-State: ANoB5pmOw5FnnQzRysvB4fXRkrvPcDZrJbnbTNWFx8NCSt13ZbwlEQvu
 O2nkRHhQfrptWURvszCxepg9CIr3c68PyA==
X-Google-Smtp-Source: AA0mqf7ulNAmYN++pr5vxkvvlrtyq6dsW+A+tWOuU1ZyqBRAIvazXv1Ygr0XNWZgsTfhU+/w6a8PciYu7N2SMg==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a05:6a00:e09:b0:575:3e68:ffa0 with SMTP
 id bq9-20020a056a000e0900b005753e68ffa0mr21557649pfb.12.1669956930815; Thu,
 01 Dec 2022 20:55:30 -0800 (PST)
Date: Fri,  2 Dec 2022 04:55:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202045527.3646838-1-ricarkol@google.com>
Subject: [kvm-unit-tests PATCH 0/3] arm: pmu: Add support for PMUv3p5
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

This series was tested on PMUv3p5 and PMUv3p4 using the ARM Fast Model and
kvmtool.  All tests pass on both PMUv3p5 and PMUv3p4 when using Marc's
PMUv3p5 series [0], plus the suggestion made at [1]. Didn't test AArch32.

[0] https://lore.kernel.org/kvmarm/20221113163832.3154370-1-maz@kernel.org/
[1] https://lore.kernel.org/kvmarm/Y4jasyxvFRNvvmox@google.com/

Ricardo Koller (3):
  arm: pmu: Fix overflow checks for PMUv3p5 long counters
  arm: pmu: Prepare for testing 64-bit overflows
  arm: pmu: Add tests for 64-bit overflows

 arm/pmu.c | 217 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 133 insertions(+), 84 deletions(-)

-- 
2.39.0.rc0.267.gcb52ba06e7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
