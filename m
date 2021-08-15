Return-Path: <SRS0=D5oV=NG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F97C4338F
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:03:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 96CC260F46
	for <kvmarm@archiver.kernel.org>; Sun, 15 Aug 2021 01:03:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 96CC260F46
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 43B824A523;
	Sat, 14 Aug 2021 21:03:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jnwNhVozJJ2M; Sat, 14 Aug 2021 21:03:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FA4D4B09A;
	Sat, 14 Aug 2021 21:03:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63B054A523
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id U5TCVKlix9tK for <kvmarm@lists.cs.columbia.edu>;
 Sat, 14 Aug 2021 21:03:02 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 50ABA4A4A4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 14 Aug 2021 21:03:02 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1628989382;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=CqHOmSIP5cV9mCzKB802uxnJHOq5EnByqLZMT4FCu9w=;
 b=Qj7VzYujXtsgdOsmKabKc0TXJAd8yLubMZZ+K6bYRIqmS5JkhVXFvt8MgU86692nqwJVMo
 wIo6zIGTUTYKfU0WJOXtvwxZBz8ovr5GQBp+tRiLsuVDaa+wKfbKrsSqoyAaJq7BCsHOsT
 AS6AgnT0irBvY7GVG1nFYP1RBmgI+FY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-162-oK8DLNHyN8es6-0UbIOAQg-1; Sat, 14 Aug 2021 21:02:58 -0400
X-MC-Unique: oK8DLNHyN8es6-0UbIOAQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com
 [10.5.11.13])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7ADD31082921;
 Sun, 15 Aug 2021 01:02:57 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-103.bne.redhat.com [10.64.54.103])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 341146091B;
 Sun, 15 Aug 2021 01:02:51 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 13/15] arm64: Reschedule process on aync PF
Date: Sun, 15 Aug 2021 08:59:45 +0800
Message-Id: <20210815005947.83699-14-gshan@redhat.com>
In-Reply-To: <20210815005947.83699-1-gshan@redhat.com>
References: <20210815005947.83699-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

The page-not-present notification is delivered by SDEI event. The
guest reschedules current process to another one when the SDEI event
is received. It's not safe to do so in the SDEI event handler because
the SDEI event should be acknowledged as soon as possible.

So the rescheduling is postponed until the current process switches
from kernel to user mode. In order to trigger the switch, the SDEI
event handler sends (reschedule) IPI to current CPU and it's delivered
in time after the SDEI event is acknowledged.

A new thread flag (TIF_ASYNC_PF) is introduced in order to track the
state for the process, to be rescheduled. With the flag is set, there
is a head of wait-queue is associated with the process. The process
keeps rescheduling itself until the flag is cleared when page-ready
notification is received through (PPI) interrupt.

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/processor.h   |  1 +
 arch/arm64/include/asm/thread_info.h |  4 +++-
 arch/arm64/kernel/signal.c           | 17 +++++++++++++++++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index b6517fd03d7b..4d05d292baa1 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -156,6 +156,7 @@ struct thread_struct {
 	u64			gcr_user_excl;
 #endif
 	u64			sctlr_user;
+	void			*data;
 };
 
 #define SCTLR_USER_MASK                                                        \
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 6623c99f0984..38567adb26be 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -67,6 +67,7 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_ASYNC_PF		7	/* Asynchronous page fault */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -97,11 +98,12 @@ int arch_dup_task_struct(struct task_struct *dst,
 #define _TIF_SVE		(1 << TIF_SVE)
 #define _TIF_MTE_ASYNC_FAULT	(1 << TIF_MTE_ASYNC_FAULT)
 #define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
+#define _TIF_ASYNC_PF		(1 << TIF_ASYNC_PF)
 
 #define _TIF_WORK_MASK		(_TIF_NEED_RESCHED | _TIF_SIGPENDING | \
 				 _TIF_NOTIFY_RESUME | _TIF_FOREIGN_FPSTATE | \
 				 _TIF_UPROBE | _TIF_MTE_ASYNC_FAULT | \
-				 _TIF_NOTIFY_SIGNAL)
+				 _TIF_NOTIFY_SIGNAL | _TIF_ASYNC_PF)
 
 #define _TIF_SYSCALL_WORK	(_TIF_SYSCALL_TRACE | _TIF_SYSCALL_AUDIT | \
 				 _TIF_SYSCALL_TRACEPOINT | _TIF_SECCOMP | \
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 23036334f4dc..15c7d115aa5d 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -929,6 +929,23 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 				 unsigned long thread_flags)
 {
 	do {
+		if (thread_flags & _TIF_ASYNC_PF) {
+			struct swait_queue_head *wq =
+				READ_ONCE(current->thread.data);
+			DECLARE_SWAITQUEUE(wait);
+
+			local_daif_restore(DAIF_PROCCTX_NOIRQ);
+
+			do {
+				prepare_to_swait_exclusive(wq,
+					&wait, TASK_UNINTERRUPTIBLE);
+				if (!test_thread_flag(TIF_ASYNC_PF))
+					break;
+
+				schedule();
+			} while (test_thread_flag(TIF_ASYNC_PF));
+		}
+
 		if (thread_flags & _TIF_NEED_RESCHED) {
 			/* Unmask Debug and SError for the next task */
 			local_daif_restore(DAIF_PROCCTX_NOIRQ);
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
