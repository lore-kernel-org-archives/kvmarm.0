Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541C4C352A3
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 13:37:18 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D68D72070A
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 13:37:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XCoLoi91"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D68D72070A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4328D4AE9C;
	Tue, 11 Feb 2020 08:37:17 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ira2G7rZD+fB; Tue, 11 Feb 2020 08:37:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 214E84AEB1;
	Tue, 11 Feb 2020 08:37:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7881A4AE9C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:37:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKTdG+ND0wD0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 08:37:13 -0500 (EST)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F0D24A97D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 08:37:13 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1581428233;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding;
 bh=Nx7UfFP0sIiH35S7kPPK91DRlS1gGk3KRmm0NaUAgl4=;
 b=XCoLoi91gJUR2zOyu+o1ao+8Nv16cDzuosEdCzwJfaEfLOrPXiRx5NuRx7FqGtHwIRcsln
 heZ6mEQLGjjk1XyyVgRmZxgfRPpkKvOgfYm1lWm+FU3oTwMb4nOKrv8WP096zIzKmQBgN5
 bGCYfVkYPfG7/jRW7ParPhUt5Dr0qSc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-58-mwDLRYU3N7G8fTlDMoOOWg-1; Tue, 11 Feb 2020 08:37:09 -0500
X-MC-Unique: mwDLRYU3N7G8fTlDMoOOWg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 274ED1005514;
 Tue, 11 Feb 2020 13:37:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
 by smtp.corp.redhat.com (Postfix) with ESMTP id B9D8887B34;
 Tue, 11 Feb 2020 13:37:06 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvm-unit-tests v2] arm64: timer: Speed up gic-timer-state check
Date: Tue, 11 Feb 2020 14:37:05 +0100
Message-Id: <20200211133705.1398-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
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
to save over six seconds of run time. Make sure we wait a bit
before reading the registers and double check again after,
though, to somewhat mitigate the chance of seeing the expected
state by accident.

We also take this opportunity to push more IRQ state code to
the library.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c       | 30 ++++++++++++------------------
 lib/arm/asm/gic.h | 11 ++++++-----
 lib/arm/gic.c     | 33 +++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+), 23 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f5cf775ce50f..3c4e27f20e2e 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -183,28 +183,22 @@ static bool timer_pending(struct timer_info *info)
 		(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS);
 }
 
-static enum gic_state gic_timer_state(struct timer_info *info)
+static bool gic_timer_check_state(struct timer_info *info,
+				  enum gic_irq_state expected_state)
 {
-	enum gic_state state = GIC_STATE_INACTIVE;
 	int i;
-	bool pending, active;
 
 	/* Wait for up to 1s for the GIC to sample the interrupt. */
 	for (i = 0; i < 10; i++) {
-		pending = readl(gic_ispendr) & (1 << PPI(info->irq));
-		active = readl(gic_isactiver) & (1 << PPI(info->irq));
-		if (!active && !pending)
-			state = GIC_STATE_INACTIVE;
-		if (pending)
-			state = GIC_STATE_PENDING;
-		if (active)
-			state = GIC_STATE_ACTIVE;
-		if (active && pending)
-			state = GIC_STATE_ACTIVE_PENDING;
 		mdelay(100);
+		if (gic_irq_state(info->irq) == expected_state) {
+			mdelay(100);
+			if (gic_irq_state(info->irq) == expected_state)
+				return true;
+		}
 	}
 
-	return state;
+	return false;
 }
 
 static bool test_cval_10msec(struct timer_info *info)
@@ -253,11 +247,11 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"not pending before");
 
 	info->write_cval(now - 1);
-	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_PENDING,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_PENDING),
 			"interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
@@ -265,12 +259,12 @@ static void test_timer(struct timer_info *info)
 	info->irq_received = false;
 	set_timer_irq_enabled(info, true);
 	report(!info->irq_received, "no interrupt when timer is disabled");
-	report(!timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(!timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal no longer pending");
 
 	info->write_cval(now - 1);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE | ARCH_TIMER_CTL_IMASK);
-	report(timer_pending(info) && gic_timer_state(info) == GIC_STATE_INACTIVE,
+	report(timer_pending(info) && gic_timer_check_state(info, GIC_IRQ_STATE_INACTIVE),
 			"interrupt signal not pending");
 
 	report(test_cval_10msec(info), "latency within 10 ms");
diff --git a/lib/arm/asm/gic.h b/lib/arm/asm/gic.h
index a72e0cde4e9c..922cbe95750c 100644
--- a/lib/arm/asm/gic.h
+++ b/lib/arm/asm/gic.h
@@ -47,11 +47,11 @@
 #ifndef __ASSEMBLY__
 #include <asm/cpumask.h>
 
-enum gic_state {
-	GIC_STATE_INACTIVE,
-	GIC_STATE_PENDING,
-	GIC_STATE_ACTIVE,
-	GIC_STATE_ACTIVE_PENDING,
+enum gic_irq_state {
+	GIC_IRQ_STATE_INACTIVE,
+	GIC_IRQ_STATE_PENDING,
+	GIC_IRQ_STATE_ACTIVE,
+	GIC_IRQ_STATE_ACTIVE_PENDING,
 };
 
 /*
@@ -80,6 +80,7 @@ extern u32 gic_iar_irqnr(u32 iar);
 extern void gic_write_eoir(u32 irqstat);
 extern void gic_ipi_send_single(int irq, int cpu);
 extern void gic_ipi_send_mask(int irq, const cpumask_t *dest);
+extern enum gic_irq_state gic_irq_state(int irq);
 
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM_GIC_H_ */
diff --git a/lib/arm/gic.c b/lib/arm/gic.c
index 94301169215c..0563b31132c8 100644
--- a/lib/arm/gic.c
+++ b/lib/arm/gic.c
@@ -146,3 +146,36 @@ void gic_ipi_send_mask(int irq, const cpumask_t *dest)
 	assert(gic_common_ops && gic_common_ops->ipi_send_mask);
 	gic_common_ops->ipi_send_mask(irq, dest);
 }
+
+enum gic_irq_state gic_irq_state(int irq)
+{
+	enum gic_irq_state state;
+	bool pending = false, active = false;
+	void *base;
+
+	assert(gic_common_ops);
+
+	switch (gic_version()) {
+	case 2:
+		base = gicv2_dist_base();
+		pending = readl(base + GICD_ISPENDR) & (1 << PPI(irq));
+		active = readl(base + GICD_ISACTIVER) & (1 << PPI(irq));
+		break;
+	case 3:
+		base = gicv3_sgi_base();
+		pending = readl(base + GICR_ISPENDR0) & (1 << PPI(irq));
+		active = readl(base + GICR_ISACTIVER0) & (1 << PPI(irq));
+		break;
+	}
+
+	if (!active && !pending)
+		state = GIC_IRQ_STATE_INACTIVE;
+	if (pending)
+		state = GIC_IRQ_STATE_PENDING;
+	if (active)
+		state = GIC_IRQ_STATE_ACTIVE;
+	if (active && pending)
+		state = GIC_IRQ_STATE_ACTIVE_PENDING;
+
+	return state;
+}
-- 
2.21.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
