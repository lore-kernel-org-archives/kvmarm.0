Return-Path: <SRS0=F5E6=BK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2947C433E1
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:44:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6526D2067D
	for <kvmarm@archiver.kernel.org>; Fri, 31 Jul 2020 07:44:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6526D2067D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2002C4B4EA;
	Fri, 31 Jul 2020 03:44:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0rQXDN02Pg6e; Fri, 31 Jul 2020 03:44:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E1F354B487;
	Fri, 31 Jul 2020 03:44:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7B1C84B157
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:44:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2dP8IW0LOFyX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 31 Jul 2020 03:44:02 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 31F9F4B334
 for <kvmarm@lists.cs.columbia.edu>; Fri, 31 Jul 2020 03:44:02 -0400 (EDT)
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id CF4FA47FF5AF96551DE;
 Fri, 31 Jul 2020 15:43:36 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.42) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Fri, 31 Jul 2020 15:43:28 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH v3 09/10] arm64: microbench: Add test->post()
 to further process test results
Date: Fri, 31 Jul 2020 15:42:43 +0800
Message-ID: <20200731074244.20432-10-wangjingyi11@huawei.com>
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

Under certain circumstances, we need to further process microbench
test results, so we add test->post() in the microbench framework,
later patch will use that.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 1e1bde5..4680ba4 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -33,6 +33,12 @@ static int nr_ipi_received;
 static void *vgic_dist_base;
 static void (*write_eoir)(u32 irqstat);
 
+struct ns_time {
+	uint64_t ns;
+	uint64_t ns_frac;
+};
+static void ticks_to_ns_time(uint64_t ticks, struct ns_time *ns_time);
+
 static void gic_irq_handler(struct pt_regs *regs)
 {
 	u32 irqstat = gic_read_iar();
@@ -283,24 +289,20 @@ struct exit_test {
 	const char *name;
 	bool (*prep)(void);
 	void (*exec)(void);
+	void (*post)(uint64_t, uint64_t, struct ns_time*);
 	u32 times;
 	bool run;
 };
 
 static struct exit_test tests[] = {
-	{"hvc",			NULL,		hvc_exec,		65536,		true},
-	{"mmio_read_user",	NULL,		mmio_read_user_exec,	65536,		true},
-	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	65536,		true},
-	{"eoi",			NULL,		eoi_exec,		65536,		true},
-	{"ipi",			ipi_prep,	ipi_exec,		65536,		true},
-	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		65536,		true},
-	{"lpi",			lpi_prep,	lpi_exec,		65536,		true},
-	{"timer_10ms",		timer_prep,	timer_exec,		256,		true},
-};
-
-struct ns_time {
-	uint64_t ns;
-	uint64_t ns_frac;
+	{"hvc",			NULL,		hvc_exec,		NULL,		65536,		true},
+	{"mmio_read_user",	NULL,		mmio_read_user_exec,	NULL,		65536,		true},
+	{"mmio_read_vgic",	NULL,		mmio_read_vgic_exec,	NULL,		65536,		true},
+	{"eoi",			NULL,		eoi_exec,		NULL,		65536,		true},
+	{"ipi",			ipi_prep,	ipi_exec,		NULL,		65536,		true},
+	{"ipi_hw",		ipi_hw_prep,	ipi_exec,		NULL,		65536,		true},
+	{"lpi",			lpi_prep,	lpi_exec,		NULL,		65536,		true},
+	{"timer_10ms",		timer_prep,	timer_exec,		NULL,		256,		true},
 };
 
 #define PS_PER_SEC (1000 * 1000 * 1000 * 1000UL)
@@ -339,6 +341,9 @@ static void loop_test(struct exit_test *test)
 		ticks_to_ns_time(total_ticks, &total_ns);
 	}
 
+	if (test->post)
+		test->post(total_ticks, ntimes, &total_ns);
+
 	avg_ns.ns = total_ns.ns / ntimes;
 	avg_ns.ns_frac = total_ns.ns_frac / ntimes;
 
-- 
2.19.1


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
