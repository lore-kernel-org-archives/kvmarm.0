Return-Path: <SRS0=VgM6=WY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA3DBC3A5A6
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5FB4323403
	for <kvmarm@archiver.kernel.org>; Wed, 28 Aug 2019 13:39:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FB4323403
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 174E94A5A5;
	Wed, 28 Aug 2019 09:39:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LPq+YgQV+V2A; Wed, 28 Aug 2019 09:39:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE72E4A58C;
	Wed, 28 Aug 2019 09:39:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EC494A58C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T+2zFswLY9FU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Aug 2019 09:39:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B77304A595
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Aug 2019 09:38:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 82A1528;
 Wed, 28 Aug 2019 06:38:59 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 652D73F246;
 Wed, 28 Aug 2019 06:38:58 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH 07/16] arm64: timer: Test behavior when
 timer disabled or masked
Date: Wed, 28 Aug 2019 14:38:22 +0100
Message-Id: <1566999511-24916-8-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
References: <1566999511-24916-1-git-send-email-alexandru.elisei@arm.com>
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When the timer is disabled (the ENABLE bit is clear) or the timer interrupt
is masked at the timer level (the IMASK bit is set), timer interrupts must
not be pending or asserted by the VGIC. However, when the timer interrupt
is masked, we can still check that the timer condition is met by reading
the ISTATUS bit.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
This test was used to discover the issue fixed by the upstream patch
16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive interrupts
on enable").

 arm/timer.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 7ae169bd687e..125b9f30ad3c 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -230,9 +230,17 @@ static void test_timer(struct timer_info *info)
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
+	isb();
+	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
+	report("no interrupt when timer is disabled", !info->irq_received);
 	report("interrupt signal no longer pending", !gic_timer_pending(info));
 
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
+	isb();
+	report("interrupt signal not pending", !gic_timer_pending(info));
+	report("timer condition met", info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
+
 	report("latency within 10 ms", test_cval_10msec(info));
 	report("interrupt received", info->irq_received);
 
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
