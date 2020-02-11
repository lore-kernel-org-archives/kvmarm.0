Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 577CBC352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:35:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CDD3A20842
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 12:35:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QQXq1/Oo"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CDD3A20842
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A2764AEB0;
	Tue, 11 Feb 2020 07:35:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hS1RgheiVeE5; Tue, 11 Feb 2020 07:35:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B5E74AEAC;
	Tue, 11 Feb 2020 07:35:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A465C4AEAC
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:35:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zN5xLQPR17yL for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 07:35:29 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [207.211.31.81])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 91F544A59B
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 07:35:29 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581424529;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=SvgnBksltlfdKTQjesT7j5JDJyAmqiI6NDbtZfxaBYc=;
 b=QQXq1/OoeobxBPDl6j3B5I1tadgyW1YEXwsq4mHwMSHTEIXIuZjPzWxIV9CGFclNA3t/t5
 HP4X9patdwnrDvu4ES0l9u0qe7rlnWHIRloUCno5wj854CmVm1R+O0TqLzpKIWt3LcZJrk
 iOnGyYOFgm/600OST0T8WRr7eYgarvk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-p6630gJaMpGBbeTuArspaw-1; Tue, 11 Feb 2020 07:35:25 -0500
X-MC-Unique: p6630gJaMpGBbeTuArspaw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2CAF9477;
 Tue, 11 Feb 2020 12:35:24 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id A15976055B;
 Tue, 11 Feb 2020 12:35:22 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests] arm64: timer: Speed up gic-timer-state check
Date: Tue, 11 Feb 2020 13:35:21 +0100
Message-Id: <20200211123521.13637-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
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

Let's bail out of the wait loop if we see the expected state
to save about seven seconds of run time. Make sure we wait a
bit before reading the registers, though, to somewhat mitigate
the chance of the expected state being stale.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f5cf775ce50f..c2262c112c09 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,7 +183,8 @@ static bool timer_pending(struct timer_info *info)
 		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
 }
 
-static enum gic_state gic_timer_state(struct timer_info *info)
+static bool gic_timer_check_state(struct timer_info *info,
+				  enum gic_state expected_state)
 {
 	enum gic_state state = GIC_STATE_INACTIVE;
 	int i;
@@ -191,6 +192,7 @@ static enum gic_state gic_timer_state(struct timer_info *info)
 
 	/* Wait for up to 1s for the GIC to sample the interrupt. */
 	for (i = 0; i < 10; i++) {
+		mdelay(100);
 		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
 		active = readl(gic_isactiver) & (1 << PPI(info->irq));
 		if (!active && !pending)
@@ -201,10 +203,11 @@ static enum gic_state gic_timer_state(struct timer_info *info)
 			state = GIC_STATE_ACTIVE;
 		if (active && pending)
 			state = GIC_STATE_ACTIVE_PENDING;
-		mdelay(100);
+		if (state == expected_state)
+			return true;
 	}
 
-	return state;
+	return false;
 }
 
 static bool test_cval_10msec(struct timer_info *info)
@@ -253,11 +256,11 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
 			"not pending before");
 
 	info->write_cval(now - 1);
-	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_PENDING),
 			"interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
@@ -265,12 +268,12 @@ static void test_timer(struct timer_info *info)
 	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
 			"interrupt signal no longer pending");
 
 	info->write_cval(now - 1);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
-	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_STATE_INACTIVE),
 			"interrupt signal not pending");
 
 	report(test_cval_10msec(info), "latency within 10 ms");
-- 
2.21.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
