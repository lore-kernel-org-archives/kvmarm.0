From: Andrew Jones <drjones@redhat.com>
Subject: [PATCH 1/2] arm64: add start_usr32
Date: Fri, 22 Jul 2016 10:43:22 -0400
Message-ID: <1469198603-27537-2-git-send-email-drjones@redhat.com>
References: <1469198603-27537-1-git-send-email-drjones@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 708B749B44
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 10:37:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w7-LD7pXY7kh for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 10:37:09 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E95149B59
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 10:37:09 -0400 (EDT)
In-Reply-To: <1469198603-27537-1-git-send-email-drjones@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 lib/arm64/asm/processor.h |  1 +
 lib/arm64/processor.c     | 21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 84d5c7ce752b..22687851379a 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -79,6 +79,7 @@ DEFINE_GET_SYSREG32(mpidr)
 #define mpidr_to_cpu(mpidr) ((int)((mpidr) & 0xff))
 
 extern void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr);
+extern void start_usr32(void (*func)(void *arg), void *arg, unsigned long sp_usr);
 extern bool is_user(void);
 
 #endif /* !__ASSEMBLY__ */
diff --git a/lib/arm64/processor.c b/lib/arm64/processor.c
index deeab4ec9c8a..a18a29e06dc4 100644
--- a/lib/arm64/processor.c
+++ b/lib/arm64/processor.c
@@ -192,6 +192,8 @@ void vector_handlers_default_init(vector_fn *handlers)
 	handlers[EL1H_IRQ]	= default_vector_irq_handler;
 	handlers[EL0_SYNC_64]	= default_vector_sync_handler;
 	handlers[EL0_IRQ_64]	= default_vector_irq_handler;
+	handlers[EL0_SYNC_32]	= default_vector_sync_handler;
+	handlers[EL0_IRQ_32]	= default_vector_irq_handler;
 }
 
 void do_handle_exception(enum vector v, struct pt_regs *regs, unsigned int esr)
@@ -233,7 +235,8 @@ void thread_info_init(struct thread_info *ti, unsigned int flags)
 	vector_handlers_default_init(ti->vector_handlers);
 }
 
-void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
+static void __start_usr(void (*func)(void *arg), void *arg,
+			unsigned long sp_usr, unsigned int spsr)
 {
 	sp_usr &= (~15UL); /* stack ptr needs 16-byte alignment */
 
@@ -243,10 +246,20 @@ void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
 		"mov	x0, %0\n"
 		"msr	sp_el0, %1\n"
 		"msr	elr_el1, %2\n"
-		"mov	x3, xzr\n"	/* clear and "set" PSR_MODE_EL0t */
-		"msr	spsr_el1, x3\n"
+		"msr	spsr_el1, %3\n"
+		"isb\n"
 		"eret\n"
-	:: "r" (arg), "r" (sp_usr), "r" (func) : "x0", "x3");
+	:: "r" (arg), "r" (sp_usr), "r" (func), "r" (spsr) : "x0");
+}
+
+void start_usr(void (*func)(void *arg), void *arg, unsigned long sp_usr)
+{
+	__start_usr(func, arg, sp_usr, 0);
+}
+
+void start_usr32(void (*func)(void *arg), void *arg, unsigned long sp_usr)
+{
+	__start_usr(func, arg, sp_usr, PSR_MODE32_BIT);
 }
 
 bool is_user(void)
-- 
1.8.3.1
