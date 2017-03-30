From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: KVM/ARM: sleeping function called from invalid context
Date: Thu, 30 Mar 2017 18:36:07 +0100
Message-ID: <1490895367-10547-1-git-send-email-suzuki.poulose@arm.com>
References: <7047d954-5c43-600a-3511-4c7dbd60c175@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7047d954-5c43-600a-3511-4c7dbd60c175@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, mark.rutland@arm.com, peterz@infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>, Frederic Weisbecker <fweisbec@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Arnd Bergmann <arnd@arndb.de>
List-Id: kvmarm@lists.cs.columbia.edu

I have confirmed the theory using a sample code like :

	spin_lock(&a);
	spin_lock(&b);
	cond_resched_lock(&b);
	spin_unlock(&b);
	spin_unlock(&a);

Also, the following patch solves the problem for me.


 ----8>-----

sched: Fix ___might_sleep preempt count checks

___might_sleep checks if the preempt_count equals the passed in
preempt_offset to issue a warning. This could cause false warnings,
when preempt_count is greater than the requested offset. Fix the
check to make sure we handle this case.

e.g, following code sequence could cause false warning:

foo:
	spin_lock(&a);
	...
	bar() --------->     bar:
				spin_lock(&b);
				cond_resched_lock(&b);
				do_something();
				spin_unlock(&b);
		<-----------
	...
	spin_unlock(&a)

where locks a and b need not necessarily be related.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 kernel/sched/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3b31fc0..28842dc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6144,11 +6144,11 @@ void __init sched_init(void)
 }
 
 #ifdef CONFIG_DEBUG_ATOMIC_SLEEP
-static inline int preempt_count_equals(int preempt_offset)
+static inline int preempt_count_safe(int preempt_offset)
 {
 	int nested = preempt_count() + rcu_preempt_depth();
 
-	return (nested == preempt_offset);
+	return (nested >= preempt_offset);
 }
 
 void __might_sleep(const char *file, int line, int preempt_offset)
@@ -6179,7 +6179,7 @@ void ___might_sleep(const char *file, int line, int preempt_offset)
 	/* WARN_ON_ONCE() by default, no rate limit required: */
 	rcu_sleep_check();
 
-	if ((preempt_count_equals(preempt_offset) && !irqs_disabled() &&
+	if ((preempt_count_safe(preempt_offset) && !irqs_disabled() &&
 	     !is_idle_task(current)) ||
 	    system_state != SYSTEM_RUNNING || oops_in_progress)
 		return;
@@ -6205,7 +6205,7 @@ void ___might_sleep(const char *file, int line, int preempt_offset)
 	if (irqs_disabled())
 		print_irqtrace_events(current);
 	if (IS_ENABLED(CONFIG_DEBUG_PREEMPT)
-	    && !preempt_count_equals(preempt_offset)) {
+	    && !preempt_count_safe(preempt_offset)) {
 		pr_err("Preemption disabled at:");
 		print_ip_sym(preempt_disable_ip);
 		pr_cont("\n");
-- 
2.7.4
