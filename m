From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH v4 27/28] arm64: signal: Report signal frame size to
 userspace via auxv
Date: Fri, 27 Oct 2017 11:51:09 +0100
Message-ID: <1509101470-7881-28-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 58B9849D65
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Dub8trIQ1chS for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 06:50:48 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C36740638
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 06:50:48 -0400 (EDT)
In-Reply-To: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: linux-arch@vger.kernel.org, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, libc-alpha@sourceware.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Stateful CPU architecture extensions may require the signal frame
to grow to a size that exceeds the arch's MINSIGSTKSZ #define.
However, changing this #define is an ABI break.

To allow userspace the option of determining the signal frame size
in a more forwards-compatible way, this patch adds a new auxv entry
tagged with AT_MINSIGSTKSZ, which provides the maximum signal frame
size that the process can observe during its lifetime.

If AT_MINSIGSTKSZ is absent from the aux vector, the caller can
assume that the MINSIGSTKSZ #define is sufficient.  This allows for
a consistent interface with older kernels that do not provide
AT_MINSIGSTKSZ.

The idea is that libc could expose this via sysconf() or some
similar mechanism.

There is deliberately no AT_SIGSTKSZ.  The kernel knows nothing
about userspace's own stack overheads and should not pretend to
know.

For arm64:

The primary motivation for this interface is the Scalable Vector
Extension, which can require at least 4KB or so of extra space
in the signal frame for the largest hardware implementations.

To determine the correct value, a "Christmas tree" mode (via the
add_all argument) is added to setup_sigframe_layout(), to simulate
addition of all possible records to the signal frame at maximum
possible size.

If this procedure goes wrong somehow, resulting in a stupidly large
frame layout and hence failure of sigframe_alloc() to allocate a
record to the frame, then this is indicative of a kernel bug: the
kernel's internal SIGFRAME_MAXSZ is supposed to sanity-check
against generting frames that we consider _impossibly_ large.  In
this case, SIGSTKSZ is returned as a "reasonable guess that is at
least bigger than MINSIGSTKSZ" and we WARN().

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/elf.h         |  5 +++++
 arch/arm64/include/asm/processor.h   |  3 +++
 arch/arm64/include/uapi/asm/auxvec.h |  3 ++-
 arch/arm64/kernel/signal.c           | 39 +++++++++++++++++++++++++++++++-----
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index fac1c4d..771c7a8 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -24,6 +24,10 @@
 #include <asm/ptrace.h>
 #include <asm/user.h>
 
+#ifndef __ASSEMBLY__
+#include <asm/processor.h> /* for get_minsigstksz(), used by ARCH_DLINFO */
+#endif
+
 /*
  * AArch64 static relocation types.
  */
@@ -148,6 +152,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
 do {									\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
 		    (elf_addr_t)current->mm->context.vdso);		\
+	NEW_AUX_ENT(AT_MINSIGSTKSZ, get_minsigstksz());			\
 } while (0)
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 023cacb..055b06d 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -217,6 +217,9 @@ static inline void spin_lock_prefetch(const void *ptr)
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 
+/* User signal frame size discovery: */
+int get_minsigstksz(void);
+
 /* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
 #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
 #define SVE_GET_VL()	sve_get_current_vl()
diff --git a/arch/arm64/include/uapi/asm/auxvec.h b/arch/arm64/include/uapi/asm/auxvec.h
index 4cf0c17..1d45b28 100644
--- a/arch/arm64/include/uapi/asm/auxvec.h
+++ b/arch/arm64/include/uapi/asm/auxvec.h
@@ -18,7 +18,8 @@
 
 /* vDSO location */
 #define AT_SYSINFO_EHDR	33
+#define AT_MINSIGSTKSZ	34	/* stack needed for signal delivery */
 
-#define AT_VECTOR_SIZE_ARCH 1 /* entries in ARCH_DLINFO */
+#define AT_VECTOR_SIZE_ARCH 2 /* entries in ARCH_DLINFO */
 
 #endif
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 79bc55a..ecae147 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -567,8 +567,15 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
 	return 0;
 }
 
-/* Determine the layout of optional records in the signal frame */
-static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
+/*
+ * Determine the layout of optional records in the signal frame
+ *
+ * add_all: if true, lays out the biggest possible signal frame for
+ *	this task; otherwise, generates a layout for the current state
+ *	of the task.
+ */
+static int setup_sigframe_layout(struct rt_sigframe_user_layout *user,
+				 bool add_all)
 {
 	int err;
 
@@ -578,7 +585,7 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 		return err;
 
 	/* fault information, if valid */
-	if (current->thread.fault_code) {
+	if (add_all || current->thread.fault_code) {
 		err = sigframe_alloc(user, &user->esr_offset,
 				     sizeof(struct esr_context));
 		if (err)
@@ -600,7 +607,6 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 	return sigframe_alloc_end(user);
 }
 
-
 static int setup_sigframe(struct rt_sigframe_user_layout *user,
 			  struct pt_regs *regs, sigset_t *set)
 {
@@ -698,7 +704,7 @@ static int get_sigframe(struct rt_sigframe_user_layout *user,
 	int err;
 
 	init_user_layout(user);
-	err = setup_sigframe_layout(user);
+	err = setup_sigframe_layout(user, false);
 	if (err)
 		return err;
 
@@ -930,3 +936,26 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 		thread_flags = READ_ONCE(current_thread_info()->flags);
 	} while (thread_flags & _TIF_WORK_MASK);
 }
+
+/*
+ * Determine the stack space required for guaranteed signal devliery.
+ * This function is used to populate AT_MINSIGSTKSZ at process startup.
+ */
+int get_minsigstksz(void)
+{
+	struct rt_sigframe_user_layout user;
+	int err;
+
+	init_user_layout(&user);
+	err = setup_sigframe_layout(&user, true);
+
+	if (err) {
+		WARN_ON(1);
+
+		return SIGSTKSZ;
+	} else {
+		return sigframe_size(&user) +
+			round_up(sizeof(struct frame_record), 16) +
+			16; /* max alignment padding */
+	}
+}
-- 
2.1.4
