Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F94AC2BA15
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2A2272071C
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EH/9ue7R"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A2272071C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CC3E84B1ED;
	Sat,  4 Apr 2020 10:38:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hl6X1MeduUXK; Sat,  4 Apr 2020 10:37:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A81D4B1F0;
	Sat,  4 Apr 2020 10:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B3B94B1E8
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ySLy283GS+Go for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F49F4B19D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011075;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=u+W8aLqjWNoS2hm7NQW8E99+QZ2PFnvwa+mg/8to+p4=;
 b=EH/9ue7RAfzZcL1HVqD38VAaqqx/Wkm7oSANADA8ErfoHctUeguRilwf3bWonQLQ4YMEhg
 Nc+elNWhymlAyqODginYqZ0MCy1C8wtYBuRqEKuIyNW/KWN43+ZQCyTUXd+ZRo8mj5xiaC
 OL+nLlleexgmboZZVfogQHTDoKTAvkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-338-wdevQmdpNLKDzTmd4c2rTA-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: wdevQmdpNLKDzTmd4c2rTA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8330518AB2DA;
 Sat,  4 Apr 2020 14:37:46 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 8B0089B912;
 Sat,  4 Apr 2020 14:37:44 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 03/39] arm64: timer: Add ISB after register
 writes
Date: Sat,  4 Apr 2020 16:36:55 +0200
Message-Id: <20200404143731.208138-4-drjones@redhat.com>
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

From ARM DDI 0487E.a glossary, the section "Context synchronization
event":

"All direct and indirect writes to System registers that are made before
the Context synchronization event affect any instruction, including a
direct read, that appears in program order after the instruction causing
the Context synchronization event."

The ISB instruction is a context synchronization event [1]. Add an ISB
after all register writes, to make sure that the writes have been
completed when we try to test their effects.

[1] ARM DDI 0487E.a, section C6.2.96

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/timer.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arm/timer.c b/arm/timer.c
index f390e8e65d31..c6ea108cfa4b 100644
--- a/arm/timer.c
+++ b/arm/timer.c
@@ -41,6 +41,7 @@ static u64 read_vtimer_cval(void)
 static void write_vtimer_cval(u64 val)
 {
 	write_sysreg(val, cntv_cval_el0);
+	isb();
 }
 
 static s32 read_vtimer_tval(void)
@@ -51,6 +52,7 @@ static s32 read_vtimer_tval(void)
 static void write_vtimer_tval(s32 val)
 {
 	write_sysreg(val, cntv_tval_el0);
+	isb();
 }
 
 static u64 read_vtimer_ctl(void)
@@ -61,6 +63,7 @@ static u64 read_vtimer_ctl(void)
 static void write_vtimer_ctl(u64 val)
 {
 	write_sysreg(val, cntv_ctl_el0);
+	isb();
 }
 
 static u64 read_ptimer_counter(void)
@@ -76,6 +79,7 @@ static u64 read_ptimer_cval(void)
 static void write_ptimer_cval(u64 val)
 {
 	write_sysreg(val, cntp_cval_el0);
+	isb();
 }
 
 static s32 read_ptimer_tval(void)
@@ -86,6 +90,7 @@ static s32 read_ptimer_tval(void)
 static void write_ptimer_tval(s32 val)
 {
 	write_sysreg(val, cntp_tval_el0);
+	isb();
 }
 
 static u64 read_ptimer_ctl(void)
@@ -96,6 +101,7 @@ static u64 read_ptimer_ctl(void)
 static void write_ptimer_ctl(u64 val)
 {
 	write_sysreg(val, cntp_ctl_el0);
+	isb();
 }
 
 struct timer_info {
@@ -181,7 +187,6 @@ static bool test_cval_10msec(struct timer_info *info)
 	before_timer = info->read_counter();
 	info->write_cval(before_timer + time_10ms);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
 
 	/* Wait for the timer to fire */
 	while (!(info->read_ctl() & ARCH_TIMER_CTL_ISTATUS))
@@ -217,11 +222,9 @@ static void test_timer(struct timer_info *info)
 	/* Enable the timer, but schedule it for much later */
 	info->write_cval(later);
 	info->write_ctl(ARCH_TIMER_CTL_ENABLE);
-	isb();
 	report(!gic_timer_pending(info), "not pending before");
 
 	info->write_cval(now - 1);
-	isb();
 	report(gic_timer_pending(info), "interrupt signal pending");
 
 	/* Disable the timer again and prepare to take interrupts */
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
