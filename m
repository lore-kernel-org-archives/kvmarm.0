Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EA7EC433DF
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 21D0220829
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:43:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 21D0220829
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE8E4B411;
	Fri, 31 Jul 2020 03:43:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id z9vTWPqic3fR; Fri, 31 Jul 2020 03:43:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A6F964B427;
	Fri, 31 Jul 2020 03:43:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 707BC4B385
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T+wctUgh3Y+R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 03:43:49 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 559824B30A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:43:47 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id BFA2E2378A2746313A8B;
 Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:26 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v3 06/10] arm64: microbench: Allow each test to
 specify its running times
Date: Fri, 31 Jul 2020 15:42:40 +0800
Message-ID: <20200731074244.20432-7-wangjingyi11@huawei.com>
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

For some test in micro-bench can be time consuming, we add a
micro-bench test parameter to allow each individual test to specify
its running times.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
---
 arm/micro-bench.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 82f3c07..93bd855 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -22,8 +22,6 @@
 #include <asm/gic.h>
 #include <asm/gic-v3-its.h>
 
-#define NTIMES (1U << 16)
-
 static u32 cntfrq;
 
 static volatile bool irq_ready, irq_received;
@@ -234,17 +232,18 @@ struct exit_test {
 	const char *name;
 	bool (*prep)(void);
 	void (*exec)(void);
+	u32 times;
 	bool run;
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,		hvc_exec,		true},
-	{"mmio_read_user",	NULL,		mmio_read_user_exec,	true},
-	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	true},
-	{"eoi",			NULL,		eoi_exec,		true},
-	{"ipi",			ipi_prep,	ipi_exec,		true},
-	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		true},
-	{"lpi",			lpi_prep,	lpi_exec,		true},
+	{"hvc",			NULL,		hvc_exec,		65536,		true},
+	{"mmio_read_user",	NULL,		mmio_read_user_exec,	65536,		true},
+	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	65536,		true},
+	{"eoi",			NULL,		eoi_exec,		65536,		true},
+	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
+	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
 };
 
 struct ns_time {
@@ -265,7 +264,7 @@ static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time)
 
 static void loop_test(struct exit_test *test)
 {
-	uint64_t start, end, total_ticks, ntimes = NTIMES;
+	uint64_t start, end, total_ticks, ntimes = 0;
 	struct ns_time total_ns, avg_ns;
 
 	if (test->prep) {
@@ -276,15 +275,17 @@ static void loop_test(struct exit_test *test)
 	}
 	isb();
 	start = read_sysreg(cntpct_el0);
-	while (ntimes--)
+	while (ntimes < test->times) {
 		test->exec();
+		ntimes++;
+	}
 	isb();
 	end = read_sysreg(cntpct_el0);
 
 	total_ticks = end - start;
 	ticks_to_ns_time(total_ticks, &total_ns);
-	avg_ns.ns = total_ns.ns / NTIMES;
-	avg_ns.ns_frac = total_ns.ns_frac / NTIMES;
+	avg_ns.ns = total_ns.ns / ntimes;
+	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
 
 	printf("%-30s%15" PRId64 ".%-15" PRId64 "%15" PRId64 ".%-15" PRId64 "\n",
 		test->name, total_ns.ns, total_ns.ns_frac, avg_ns.ns, avg_ns.ns_frac);
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
