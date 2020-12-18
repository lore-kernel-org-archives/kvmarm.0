Return-Path: <SRS0=w40L=FW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF10C4361B
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 07:16:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7353D23A62
	for <kvmarm@archiver.kernel.org>; Fri, 18 Dec 2020 07:16:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7353D23A62
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B30F14B11F;
	Fri, 18 Dec 2020 02:16:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hR7Rrloqy2Y7; Fri, 18 Dec 2020 02:16:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E264B11A;
	Fri, 18 Dec 2020 02:16:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEAEB4B117
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 02:16:06 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IL1nMyjf5KMy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Dec 2020 02:16:04 -0500 (EST)
Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BCD24B0CF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Dec 2020 02:16:04 -0500 (EST)
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
 by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4Cy0WF2G7Zz7D0b;
 Fri, 18 Dec 2020 15:15:21 +0800 (CST)
Received: from DESKTOP-FPN2511.china.huawei.com (10.174.187.192) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Fri, 18 Dec 2020 15:15:49 +0800
From: Jingyi Wang <wangjingyi11@huawei.com>
To: <drjones@redhat.com>, <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>
Subject: [kvm-unit-tests PATCH] arm64: microbench: fix unexpected PPI
Date: Fri, 18 Dec 2020 15:15:42 +0800
Message-ID: <20201218071542.15368-1-wangjingyi11@huawei.com>
X-Mailer: git-send-email 2.14.1.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.192]
X-CFilter-Loop: Reflected
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

For the origin value of CNTV_CVAL_EL0 architecturally UNKNOWN, we may
receive an unexpected PPI before we actual trigger the timer interrupt.
So we should set ARCH_TIMER_CTL_IMASK in timer_prep.

Signed-off-by: Jingyi Wang <wangjingyi11@huawei.com>
---
 arm/micro-bench.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arm/micro-bench.c b/arm/micro-bench.c
index 362f93e..95c418c 100644
--- a/arm/micro-bench.c
+++ b/arm/micro-bench.c
@@ -227,7 +227,7 @@ static bool timer_prep(void)
 	}
 
 	writel(1 << PPI(TIMER_VTIMER_IRQ), gic_isenabler);
-	write_sysreg(ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
+	write_sysreg(ARCH_TIMER_CTL_IMASK | ARCH_TIMER_CTL_ENABLE, cntv_ctl_el0);
 	isb();
 
 	gic_prep_common();
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
