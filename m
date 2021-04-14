Return-Path: <SRS0=hZsu=JL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5654FC001EA
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 13:44:32 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD5A3611B0
	for <kvmarm@archiver.kernel.org>; Wed, 14 Apr 2021 13:44:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD5A3611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 701314B5E8;
	Wed, 14 Apr 2021 09:44:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9RKRi+d5M4Ba; Wed, 14 Apr 2021 09:44:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 946AF4B6AC;
	Wed, 14 Apr 2021 09:44:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D0D14B663
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 09:44:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d-aOkCfAgCpX for <kvmarm@lists.cs.columbia.edu>;
 Wed, 14 Apr 2021 09:44:26 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5A7EE4B66D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 14 Apr 2021 09:44:26 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9BEFC611C9;
 Wed, 14 Apr 2021 13:44:25 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lWfod-007RSZ-Vw; Wed, 14 Apr 2021 14:44:24 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org
Subject: [PATCH 3/5] s390: Get rid of oprofile leftovers
Date: Wed, 14 Apr 2021 14:44:07 +0100
Message-Id: <20210414134409.1266357-4-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210414134409.1266357-1-maz@kernel.org>
References: <20210414134409.1266357-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-sh@vger.kernel.org, mark.rutland@arm.com,
 will@kernel.org, dalias@libc.org, ysato@users.sourceforge.jp,
 peterz@infradead.org, acme@kernel.org, borntraeger@de.ibm.com,
 hca@linux.ibm.com, nathan@kernel.org, viresh.kumar@linaro.org,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Rich Felker <dalias@libc.org>, Yoshinori Sato <ysato@users.sourceforge.jp>,
 Peter Zijlstra <peterz@infradead.org>, Viresh Kumar <viresh.kumar@linaro.org>,
 Heiko Carstens <hca@linux.ibm.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 nathan@kernel.org, Christian Borntraeger <borntraeger@de.ibm.com>,
 kernel-team@android.com, Will Deacon <will@kernel.org>
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

perf_pmu_name() and perf_num_counters() are unused. Drop them.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/s390/kernel/perf_event.c | 21 ---------------------
 1 file changed, 21 deletions(-)

diff --git a/arch/s390/kernel/perf_event.c b/arch/s390/kernel/perf_event.c
index 1e75cc983546..ea7729bebaa0 100644
--- a/arch/s390/kernel/perf_event.c
+++ b/arch/s390/kernel/perf_event.c
@@ -23,27 +23,6 @@
 #include <asm/sysinfo.h>
 #include <asm/unwind.h>
 
-const char *perf_pmu_name(void)
-{
-	if (cpum_cf_avail() || cpum_sf_avail())
-		return "CPU-Measurement Facilities (CPU-MF)";
-	return "pmu";
-}
-EXPORT_SYMBOL(perf_pmu_name);
-
-int perf_num_counters(void)
-{
-	int num = 0;
-
-	if (cpum_cf_avail())
-		num += PERF_CPUM_CF_MAX_CTR;
-	if (cpum_sf_avail())
-		num += PERF_CPUM_SF_MAX_CTR;
-
-	return num;
-}
-EXPORT_SYMBOL(perf_num_counters);
-
 static struct kvm_s390_sie_block *sie_block(struct pt_regs *regs)
 {
 	struct stack_frame *stack = (struct stack_frame *) regs->gprs[15];
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
