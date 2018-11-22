From: Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC] tracepoint: fix bad trace value in trace_kvm_exit()
Date: Thu, 22 Nov 2018 12:17:30 +0000
Message-ID: <1542889050-23144-1-git-send-email-yuzenghui@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: rostedt@goodmis.org, mingo@redhat.com, wanghaibin.wang@huawei.com, Zenghui Yu <yuzenghui@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

After enabling KVM event tracing, almost all of trace_kvm_exit()'s
printk shows
	"kvm_exit: IRQ: ..."
even if the actual exception_type is NOT IRQ.

This slight problem may have existed after commit e6753f2. There are
two variables in trace_kvm_exit() and __DO_TRACE() which have the
same name, *idx*. Thus the actual value of *idx* will be overwritten
when tracing.

So, what about this stupid patch?

Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Wang Haibin <wanghaibin.wang@huawei.com>
---
 include/linux/tracepoint.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/linux/tracepoint.h b/include/linux/tracepoint.h
index 538ba1a..e9de8ad 100644
--- a/include/linux/tracepoint.h
+++ b/include/linux/tracepoint.h
@@ -166,7 +166,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		struct tracepoint_func *it_func_ptr;			\
 		void *it_func;						\
 		void *__data;						\
-		int __maybe_unused idx = 0;				\
+		int __maybe_unused __idx = 0;				\
 									\
 		if (!(cond))						\
 			return;						\
@@ -182,7 +182,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 		 * doesn't work from the idle path.			\
 		 */							\
 		if (rcuidle) {						\
-			idx = srcu_read_lock_notrace(&tracepoint_srcu);	\
+			__idx = srcu_read_lock_notrace(&tracepoint_srcu);\
 			rcu_irq_enter_irqson();				\
 		}							\
 									\
@@ -198,7 +198,7 @@ static inline struct tracepoint *tracepoint_ptr_deref(tracepoint_ptr_t *p)
 									\
 		if (rcuidle) {						\
 			rcu_irq_exit_irqson();				\
-			srcu_read_unlock_notrace(&tracepoint_srcu, idx);\
+			srcu_read_unlock_notrace(&tracepoint_srcu, __idx);\
 		}							\
 									\
 		preempt_enable_notrace();				\
-- 
1.8.3.1
