Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98731C2BA15
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E7D8206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8/l/fgD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E7D8206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F26D34B191;
	Sat,  4 Apr 2020 10:38:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Cvat32kctEB5; Sat,  4 Apr 2020 10:38:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 727004B1FC;
	Sat,  4 Apr 2020 10:38:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 79C834B1FD
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ix6B38ivXK31 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:38:04 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E96114B202
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:38:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011083;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=dPpw8Y0BbKXD+s5EjzvlI+dw+lnTfzQ1bENX5180HXQ=;
 b=J8/l/fgDn23+CANFmd8RMYfjN0hsrcc915dWsN9lCzoGVJTv8rCCgkGiWsoJOJYQx2uDax
 CvzmVXJA29hNuy+k/VgWIPjvc6THcz3PKsp0ga8auzJDaG7eSut3SWOdZn3hgBC0ByqM11
 w4OLHn5dIb6Mr3ZMacj5EnIhuaPnWqk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-Cg06DVXyPue4tgTxxAL-PA-1; Sat, 04 Apr 2020 10:38:01 -0400
X-MC-Unique: Cg06DVXyPue4tgTxxAL-PA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6C188800D4E;
 Sat,  4 Apr 2020 14:38:00 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id AAC4D1147DA;
 Sat,  4 Apr 2020 14:37:58 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 09/39] arm64: timer: Test behavior when timer
 disabled or masked
Date: Sat,  4 Apr 2020 16:37:01 +0200
Message-Id: <20200404143731.208138-10-drjones@redhat.com>
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

When the timer is disabled (the *_CTL_EL0.ENABLE bit is clear) or the
timer interrupt is masked at the timer level (the *_CTL_EL0.IMASK bit is
set), timer interrupts must not be pending or asserted by the VGIC.
However, only when the timer interrupt is masked, we can still check
that the timer condition is met by reading the *_CTL_EL0.ISTATUS bit.

This test was used to discover a bug and test the fix introduced by KVM
commit 16e604a437c8 ("KVM: arm/arm64: vgic: Reevaluate level sensitive
interrupts on enable").

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 7 +++++++
 arm/unittests.cfg | 2 +-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/arm/timer.c b/arm/timer.c
index 35038f2bae57..dea364f5355d 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -269,10 +269,17 @@ static void test_timer(struct timer_info *info)
 
 	/* Disable the timer again and prepare to take interrupts */
 	info->write_ctl(0);
+	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
+	report(!info->irq_received, "no interrupt when timer is disabled");
 	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
 			"interrupt signal no longer pending");
 
+	info->write_cval(now - 1);
+	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
+	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+			"interrupt signal not pending");
+
 	report(test_cval_10msec(info), "latency within 10 ms");
 	report(info->irq_received, "interrupt received");
 
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 1f1bb24d9d13..017958d28ffd 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -132,7 +132,7 @@ groups = psci
 [timer]
 file = timer.flat
 groups = timer
-timeout = 8s
+timeout = 10s
 arch = arm64
 
 # Exit tests
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
