Return-Path: <SRS0=N2lg=SL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B49FC10F0E
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:22:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D7E4E20820
	for <kvmarm@archiver.kernel.org>; Tue,  9 Apr 2019 19:22:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D7E4E20820
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D5064A49F;
	Tue,  9 Apr 2019 15:22:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RoafSC1TMS-q; Tue,  9 Apr 2019 15:22:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 449CA4A47E;
	Tue,  9 Apr 2019 15:22:29 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1AF854A472
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:22:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nHIuSbMd-oUt for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Apr 2019 15:22:27 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA6454A46F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Apr 2019 15:22:26 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A656315BE;
 Tue,  9 Apr 2019 12:22:26 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AE4643F59C;
 Tue,  9 Apr 2019 12:22:24 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH v13 1/8] arm64: arm_pmu: remove unnecessary isb instruction
Date: Tue,  9 Apr 2019 20:22:10 +0100
Message-Id: <20190409192217.23459-2-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190409192217.23459-1-andrew.murray@arm.com>
References: <20190409192217.23459-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190409192210.iJ4R5RVaiXe18h4uHl3DAdU60G2SDKZ0V5zbaZRbcZw@z>

The armv8pmu_enable_event_counter function issues an isb instruction
after enabling a pair of counters - this doesn't provide any value
and is inconsistent with the armv8pmu_disable_event_counter.

In any case armv8pmu_enable_event_counter is always called with the
PMU stopped. Starting the PMU with armv8pmu_start results in an isb
instruction being issued prior to writing to PMCR_EL0.

Let's remove the unnecessary isb instruction.

Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
---
 arch/arm64/kernel/perf_event.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 4addb38bc250..cccf4fc86d67 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -533,7 +533,6 @@ static inline void armv8pmu_enable_event_counter(struct perf_event *event)
 	armv8pmu_enable_counter(idx);
 	if (armv8pmu_event_is_chained(event))
 		armv8pmu_enable_counter(idx - 1);
-	isb();
 }
 
 static inline int armv8pmu_disable_counter(int idx)
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
