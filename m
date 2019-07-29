Return-Path: <SRS0=m0cG=V2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8261DC7618B
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:29:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1268020693
	for <kvmarm@archiver.kernel.org>; Mon, 29 Jul 2019 09:29:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1268020693
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 670B94A528;
	Mon, 29 Jul 2019 05:29:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YGgN0QWcvoS6; Mon, 29 Jul 2019 05:29:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2757D4A539;
	Mon, 29 Jul 2019 05:29:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2F6C64A528
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:29:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2GEuymvlsCnW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Jul 2019 05:29:08 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB62F4A4E8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Jul 2019 05:29:08 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 580A9344;
 Mon, 29 Jul 2019 02:29:08 -0700 (PDT)
Received: from e121566-lin.cambridge.arm.com (e121566-lin.cambridge.arm.com
 [10.1.196.217])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 805E63F694;
 Mon, 29 Jul 2019 02:29:07 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] arm: timer: Fix potential deadlock when
 waiting for interrupt
Date: Mon, 29 Jul 2019 10:28:52 +0100
Message-Id: <1564392532-7692-1-git-send-email-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.7.4
Cc: marc.zyngier@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
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

Commit 204e85aa9352 ("arm64: timer: a few test improvements") added a call
to report_info after enabling the timer and before the wfi instruction. The
uart that printf uses is emulated by userspace and is slow, which makes it
more likely that the timer interrupt will fire before executing the wfi
instruction, which leads to a deadlock.

An interrupt can wake up a CPU out of wfi, regardless of the
PSTATE.{A, I, F} bits. Fix the deadlock by masking interrupts on the CPU
before enabling the timer and unmasking them after the wfi returns so the
CPU can execute the timer interrupt handler.

Suggested-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arm/timer.c b/arm/timer.c
index 6f2ad1d76ab2..f2f60192ba62 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -242,9 +242,11 @@ static void test_timer(struct timer_info *info)
 	/* Test TVAL and IRQ trigger */
 	info->irq_received = false;
 	info->write_tval(read_sysreg(cntfrq_el0) / 100);	/* 10 ms */
+	local_irq_disable();
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 	report_info("waiting for interrupt...");
 	wfi();
+	local_irq_enable();
 	left = info->read_tval();
 	report("interrupt received after TVAL/WFI", info->irq_received);
 	report("timer has expired (%d)", left < 0, left);
-- 
2.7.4

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
