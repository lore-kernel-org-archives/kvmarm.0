Return-Path: <SRS0=2BI6=HL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F535C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87B3064EB8
	for <kvmarm@archiver.kernel.org>; Tue,  9 Feb 2021 05:05:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87B3064EB8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C1024B525;
	Tue,  9 Feb 2021 00:05:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ashyofhFbiza; Tue,  9 Feb 2021 00:05:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7071A4B6D8;
	Tue,  9 Feb 2021 00:05:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D94A64B52E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VrXtAtwHkDLA for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Feb 2021 00:05:25 -0500 (EST)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 047844B749
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Feb 2021 00:05:24 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1612847124;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=8ZwEcaaCW2fwIWiKq1ahxhbS7GuwRrhgOYRBtd1MvBY=;
 b=gbK+7Qs/i2UAv2/KriOOXKpqKl3MrzF7Q3lbx/Xq8B4YCSWZo/ET3+xq7QQoBmfDWhyxRF
 +5YoEzOgc/EJge7qpC3olt1KDwIGTOlq3NRHDpS4re8yLaf2T4iIqV5mJCoEG5hz+Wzx5U
 pFFe9hk8CQlNUwHj7r0UQKuHstCf5p8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-yeKoS8XPO0WXpajCIpiEOQ-1; Tue, 09 Feb 2021 00:05:20 -0500
X-MC-Unique: yeKoS8XPO0WXpajCIpiEOQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17B16107ACC7;
 Tue,  9 Feb 2021 05:05:19 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-26.bne.redhat.com [10.64.54.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 4B7A05D9C0;
 Tue,  9 Feb 2021 05:05:16 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 15/17] arm64: Reschedule process on aync PF
Date: Tue,  9 Feb 2021 13:04:01 +0800
Message-Id: <20210209050403.103143-16-gshan@redhat.com>
In-Reply-To: <20210209050403.103143-1-gshan@redhat.com>
References: <20210209050403.103143-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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
index ca2cd75d3286..2176c88c77a7 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -154,6 +154,7 @@ struct thread_struct {
 	u64			sctlr_tcf0;
 	u64			gcr_user_excl;
 #endif
+	void			*data;
 };
 
 static inline void arch_thread_struct_whitelist(unsigned long *offset,
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index 9f4e3b266f21..939beb3c7723 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -65,6 +65,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_UPROBE		4	/* uprobe breakpoint or singlestep */
 #define TIF_MTE_ASYNC_FAULT	5	/* MTE Asynchronous Tag Check Fault */
 #define TIF_NOTIFY_SIGNAL	6	/* signal notifications exist */
+#define TIF_ASYNC_PF		7	/* Asynchronous page fault */
 #define TIF_SYSCALL_TRACE	8	/* syscall trace active */
 #define TIF_SYSCALL_AUDIT	9	/* syscall auditing */
 #define TIF_SYSCALL_TRACEPOINT	10	/* syscall tracepoint for ftrace */
@@ -95,11 +96,12 @@ void arch_release_task_struct(struct task_struct *tsk);
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
index 6237486ff6bb..2cd2d13aa905 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -915,6 +915,23 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
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
