Return-Path: <SRS0=EkBd=A4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D029C433E3
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 08:05:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB7B920737
	for <kvmarm@archiver.kernel.org>; Fri, 17 Jul 2020 08:05:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB7B920737
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D2824B2D4;
	Fri, 17 Jul 2020 04:05:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C0+aLDeqmG2e; Fri, 17 Jul 2020 04:05:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 119B54B2D0;
	Fri, 17 Jul 2020 04:05:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAE504B2D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 04:05:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VKBTGHp6zaTX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jul 2020 04:05:39 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 687744B2C7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jul 2020 04:05:39 -0400 (EDT)
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id 06DC456026DCBC285F91;
 Fri, 17 Jul 2020 16:05:36 +0800 (CST)
Received: from DESKTOP-5IS4806.china.huawei.com (10.174.187.22) by
 DGGEMS405-HUB.china.huawei.com (10.3.19.205) with Microsoft SMTP Server id
 14.3.487.0; Fri, 17 Jul 2020 16:05:26 +0800
From: Keqian Zhu <zhukeqian1@huawei.com>
To: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
 <kvmarm@lists.cs.columbia.edu>, <kvm@vger.kernel.org>
Subject: [PATCH] drivers: arm arch timer: Correct fault programming of
 CNTKCTL_EL1.EVNTI
Date: Fri, 17 Jul 2020 16:05:15 +0800
Message-ID: <20200717080515.19088-1-zhukeqian1@huawei.com>
X-Mailer: git-send-email 2.8.4.windows.1
MIME-Version: 1.0
X-Originating-IP: [10.174.187.22]
X-CFilter-Loop: Reflected
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

ARM virtual counter supports event stream, it can only trigger an event
when the trigger bit (the value of CNTKCTL_EL1.EVNTI) of CNTVCT_EL0 changes,
so the actual period of event stream is 2^(cntkctl_evnti + 1). For example,
when the trigger bit is 0, then virtual counter trigger an event for every
two cycles.

Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
---
 drivers/clocksource/arm_arch_timer.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index ecf7b7db2d05..bc019dd0975b 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -799,10 +799,20 @@ static void __arch_timer_setup(unsigned type,
 static void arch_timer_evtstrm_enable(int divider)
 {
 	u32 cntkctl = arch_timer_get_cntkctl();
+	int cntkctl_evnti;
+
+	/*
+	 * Note that it can only trigger an event when the trigger bit
+	 * of CNTVCT_EL0 changes, so the actual period of event stream
+	 * is 2^(cntkctl_evnti + 1).
+	 */
+	cntkctl_evnti = divider - 1;
+	cntkctl_evnti = min(cntkctl_evnti, 15);
+	cntkctl_evnti = max(cntkctl_evnti, 0);
 
 	cntkctl &= ~ARCH_TIMER_EVT_TRIGGER_MASK;
 	/* Set the divider and enable virtual event stream */
-	cntkctl |= (divider << ARCH_TIMER_EVT_TRIGGER_SHIFT)
+	cntkctl |= (cntkctl_evnti << ARCH_TIMER_EVT_TRIGGER_SHIFT)
 			| ARCH_TIMER_VIRT_EVT_EN;
 	arch_timer_set_cntkctl(cntkctl);
 	arch_timer_set_evtstrm_feature();
@@ -816,10 +826,11 @@ static void arch_timer_configure_evtstream(void)
 	/* Find the closest power of two to the divisor */
 	evt_stream_div = arch_timer_rate / ARCH_TIMER_EVT_STREAM_FREQ;
 	pos = fls(evt_stream_div);
-	if (pos > 1 && !(evt_stream_div & (1 << (pos - 2))))
+	if ((pos == 1) || (pos > 1 && !(evt_stream_div & (1 << (pos - 2)))))
 		pos--;
+
 	/* enable event stream */
-	arch_timer_evtstrm_enable(min(pos, 15));
+	arch_timer_evtstrm_enable(pos);
 }
 
 static void arch_counter_set_user_access(void)
-- 
2.19.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
