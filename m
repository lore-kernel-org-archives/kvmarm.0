From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [PATCH v2 3/8] perf/trace: Add notification for perf trace events
Date: Wed, 26 Oct 2016 18:41:43 +0100
Message-ID: <20161026174148.17172-4-punit.agrawal@arm.com>
References: <20161026174148.17172-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 64EF740402
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sKb9y4xlTuBs for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Oct 2016 13:42:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24AA8402A3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Oct 2016 13:42:25 -0400 (EDT)
In-Reply-To: <20161026174148.17172-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Add a mechanism to notify listeners about perf trace event state
changes. This enables listeners to take actions requiring the event
context (e.g., attached process).

The notification mechanism can be used to reduce trace point based
profiling overhead by enabling/disabling hardware traps for specific
contexts (e.g., virtual machines).

Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
---
 include/linux/trace_events.h    |  3 +++
 kernel/trace/trace_event_perf.c | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index be00761..5924032 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -505,6 +505,9 @@ perf_trace_buf_submit(void *raw_data, int size, int rctx, u16 type,
 {
 	perf_tp_event(type, count, raw_data, size, regs, head, rctx, task);
 }
+
+extern int perf_trace_notifier_register(struct notifier_block *nb);
+extern int perf_trace_notifier_unregister(struct notifier_block *nb);
 #endif
 
 #endif /* _LINUX_TRACE_EVENT_H */
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 562fa69..9aaaacf 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -6,10 +6,12 @@
  */
 
 #include <linux/module.h>
+#include <linux/notifier.h>
 #include <linux/kprobes.h>
 #include "trace.h"
 
 static char __percpu *perf_trace_buf[PERF_NR_CONTEXTS];
+static RAW_NOTIFIER_HEAD(perf_trace_notifier_list);
 
 /*
  * Force it to be aligned to unsigned long to avoid misaligned accesses
@@ -86,6 +88,26 @@ static int perf_trace_event_perm(struct trace_event_call *tp_event,
 	return 0;
 }
 
+int perf_trace_notifier_register(struct notifier_block *nb)
+{
+	return raw_notifier_chain_register(&perf_trace_notifier_list, nb);
+}
+
+int perf_trace_notifier_unregister(struct notifier_block *nb)
+{
+	return raw_notifier_chain_unregister(&perf_trace_notifier_list, nb);
+}
+
+static void perf_trace_notify(enum trace_reg event, struct perf_event *p_event)
+{
+	/*
+	 * We use raw notifiers here as we are called with the
+	 * event_mutex held.
+	 */
+	raw_notifier_call_chain(&perf_trace_notifier_list,
+				     event, p_event);
+}
+
 static int perf_trace_event_reg(struct trace_event_call *tp_event,
 				struct perf_event *p_event)
 {
@@ -176,6 +198,7 @@ static void perf_trace_event_unreg(struct perf_event *p_event)
 static int perf_trace_event_open(struct perf_event *p_event)
 {
 	struct trace_event_call *tp_event = p_event->tp_event;
+	perf_trace_notify(TRACE_REG_PERF_OPEN, p_event);
 	return tp_event->class->reg(tp_event, TRACE_REG_PERF_OPEN, p_event);
 }
 
@@ -183,6 +206,7 @@ static void perf_trace_event_close(struct perf_event *p_event)
 {
 	struct trace_event_call *tp_event = p_event->tp_event;
 	tp_event->class->reg(tp_event, TRACE_REG_PERF_CLOSE, p_event);
+	perf_trace_notify(TRACE_REG_PERF_CLOSE, p_event);
 }
 
 static int perf_trace_event_init(struct trace_event_call *tp_event,
-- 
2.9.3
