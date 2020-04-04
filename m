Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1A89C2BA1A
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9B8FF206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FKKIb0q1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9B8FF206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 573EA4B1ED;
	Sat,  4 Apr 2020 10:38:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7AoKNLwaQZiL; Sat,  4 Apr 2020 10:38:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5365D4B1FF;
	Sat,  4 Apr 2020 10:38:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 629474B1F8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QBWJakwvxpBC for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:04 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 67ECD4B107
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:01 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011081;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=aBG/mcHOc4lZna+l3/TBlcARw6Oe4Vd9Cbmo3iln5tI=;
 b=FKKIb0q1ZMKzjqIQ/ItTXUAu3Aa8gr5n+UE3zogGCDPO6pO0gdN6f949MhSJRmgDHuSzlu
 uf/hJYCtCnCvobZPpakuI6fZd/hfUi1cQSWLvHP/lci348G8oySGQh/XLyilP/9vzzRUDV
 V2mu8FxX82byzT4qFbKsOfXtd5gDt7s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-3KcyUQyyMfahtAk-OZ6fjw-1; Sat, 04 Apr 2020 10:37:59 -0400
X-MC-Unique: 3KcyUQyyMfahtAk-OZ6fjw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 34D3C8017F3;
 Sat,  4 Apr 2020 14:37:58 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4E1F69B912;
 Sat,  4 Apr 2020 14:37:56 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 08/39] arm64: timer: Check the timer interrupt
 state
Date: Sat,  4 Apr 2020 16:37:00 +0200
Message-Id: <20200404143731.208138-9-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

We check that the interrupt is pending (or not) at the GIC level, but we
don't check if the timer is asserting it (or not). Let's make sure we don't
run into a strange situation where the two devices' states aren't
synchronized.

Coincidently, the "interrupt signal no longer pending" test fails for
non-emulated timers (i.e, the virtual timer on a non-vhe host) if the
host kernel doesn't have patch 16e604a437c89 ("KVM: arm/arm64: vgic:
Reevaluate level sensitive interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index ba7e8c6a90ed..35038f2bae57 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,6 +183,13 @@ static void irq_handler(struct pt_regs *regs)
 	info->irq_received = true;
 }
 
+/* Check that the timer condition is met. */
+static bool timer_pending(struct timer_info *info)
+{
+	return (info->read_ctl() & ARCH_TIMER_CTL_ENABLE) &&
+		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
+}
+
 static enum gic_state gic_timer_state(struct timer_info *info)
 {
 	enum gic_state state = GIC_STATE_INACTIVE;
@@ -220,7 +227,7 @@ static bool test_cval_10msec(struct timer_info *info)
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
 
 	/* Wait for the timer to fire */
-	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
+	while (!timer_pending(info))
 		;
 
 	/* It fired, check how long it took */
@@ -253,17 +260,17 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"not pending before");
 
 	info->write_cval(now - 1);
-	report(gic_timer_state(info) == GIC_STATE_PENDING,
+	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
 			"interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
 	set_timer_irq_enabled(info, true);
-	report(gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"interrupt signal no longer pending");
 
 	report(test_cval_10msec(info), "latency within 10 ms");
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
