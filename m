Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7F4C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:44:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93F6A2067D
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:44:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 93F6A2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DFCB4B157;
	Fri, 31 Jul 2020 03:44:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cu6xoCjEicyd; Fri, 31 Jul 2020 03:44:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 18E8A4B378;
	Fri, 31 Jul 2020 03:44:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80D2F4B32B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:44:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DulrfFJ7KeWP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 03:44:32 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4016A4B157
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:44:32 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CA99D1B48DADD2BC9804;
 Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:27 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v3 07/10] arm64: microbench: Add time limit for
 each individual test
Date: Fri, 31 Jul 2020 15:42:41 +0800
Message-ID: <20200731074244.20432-8-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
In-Reply-To: <20200731074244.20432-1-wangjingyi11@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
MIME-Version: 1.0
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Cc: maz@kernel.org, prime.zeng@hisilicon.com
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

Besides using separate running times parameter, we add time limit
for loop_test to make sure each test should be done in a certain
time(5 sec here).

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 93bd855..09d9d53 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -22,6 +22,7 @@
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 
+#define NS_5_SECONDS (5 * 1000 * 1000 * 1000UL)
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
@@ -267,23 +268,26 @@ static void loop_test(struct exit_test *test)
 	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
+	total_ticks = 0;
 	if (test->prep) {
 		if(!test->prep()) {
 			printf("%s test skipped\n", test->name);
 			return;
 		}
 	}
-	isb();
-	start = read_sysreg(cntpct_el0);
-	while (ntimes < test->times) {
+
+	while (ntimes < test->times && total_ns.ns < NS_5_SECONDS) {
+		isb();
+		start = read_sysreg(cntpct_el0);
 		test->exec();
+		isb();
+		end = read_sysreg(cntpct_el0);
+
 		ntimes++;
+		total_ticks += (end - start);
+		ticks_to_ns_time(total_ticks, &total_ns);
 	}
-	isb();
-	end = read_sysreg(cntpct_el0);
 
-	total_ticks = end - start;
-	ticks_to_ns_time(total_ticks, &total_ns);
 	avg_ns.ns = total_ns.ns / ntimes;
 	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
 
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
