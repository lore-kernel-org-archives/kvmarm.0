From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 01/14] thread_info: Add update_thread_flag() helpers
Date: Fri,  4 May 2018 17:05:22 +0100
Message-ID: <1525449935-31424-2-git-send-email-Dave.Martin@arm.com>
References: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1525449935-31424-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, Christoffer Dall <cdall@kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

There are a number of bits of code sprinkled around the kernel to
set a thread flag if a certain condition is true, and clear it
otherwise.

To help make those call sites terser and less cumbersome, this
patch adds a new family of thread flag manipulators

	update*_thread_flag([...,] flag, cond)

which do the equivalent of:

	if (cond)
		set*_thread_flag([...,] flag);
	else
		clear*_thread_flag([...,] flag);

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 include/linux/sched.h       |  6 ++++++
 include/linux/thread_info.h | 11 +++++++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index b3d697f..c2c3051 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1578,6 +1578,12 @@ static inline void clear_tsk_thread_flag(struct task_struct *tsk, int flag)
 	clear_ti_thread_flag(task_thread_info(tsk), flag);
 }
 
+static inline void update_tsk_thread_flag(struct task_struct *tsk, int flag,
+					  bool value)
+{
+	update_ti_thread_flag(task_thread_info(tsk), flag, value);
+}
+
 static inline int test_and_set_tsk_thread_flag(struct task_struct *tsk, int flag)
 {
 	return test_and_set_ti_thread_flag(task_thread_info(tsk), flag);
diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index cf2862b..8d8821b 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -60,6 +60,15 @@ static inline void clear_ti_thread_flag(struct thread_info *ti, int flag)
 	clear_bit(flag, (unsigned long *)&ti->flags);
 }
 
+static inline void update_ti_thread_flag(struct thread_info *ti, int flag,
+					 bool value)
+{
+	if (value)
+		set_ti_thread_flag(ti, flag);
+	else
+		clear_ti_thread_flag(ti, flag);
+}
+
 static inline int test_and_set_ti_thread_flag(struct thread_info *ti, int flag)
 {
 	return test_and_set_bit(flag, (unsigned long *)&ti->flags);
@@ -79,6 +88,8 @@ static inline int test_ti_thread_flag(struct thread_info *ti, int flag)
 	set_ti_thread_flag(current_thread_info(), flag)
 #define clear_thread_flag(flag) \
 	clear_ti_thread_flag(current_thread_info(), flag)
+#define update_thread_flag(flag, value) \
+	update_ti_thread_flag(current_thread_info(), flag, value)
 #define test_and_set_thread_flag(flag) \
 	test_and_set_ti_thread_flag(current_thread_info(), flag)
 #define test_and_clear_thread_flag(flag) \
-- 
2.1.4
