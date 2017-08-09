From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 26/27] arm64: signal: Report signal frame size to userspace via auxv
Date: Wed,  9 Aug 2017 13:05:32 +0100
Message-ID: <1502280338-23002-27-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Michael Ellerman <mpe@ellerman.id.au>
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
 arch/arm64/kernel/signal.c           | 38 +++++++++++++++++++++++++++++++-----
 4 files changed, 43 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index acae781..7cee254 100644
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
@@ -149,6 +153,7 @@ typedef struct user_fpsimd_state elf_fpregset_t;
 do {									\
 	NEW_AUX_ENT(AT_SYSINFO_EHDR,					\
 		    (elf_addr_t)current->mm->context.vdso);		\
+	NEW_AUX_ENT(AT_MINSIGSTKSZ, get_minsigstksz());			\
 } while (0)
 
 #define ARCH_HAS_SETUP_ADDITIONAL_PAGES
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 70b03b4..121d011 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -197,6 +197,9 @@ static inline void spin_lock_prefetch(const void *ptr)
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
index 2694143..221bcf2 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -560,8 +560,15 @@ asmlinkage long sys_rt_sigreturn(struct pt_regs *regs)
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
 
@@ -571,7 +578,7 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 		return err;
 
 	/* fault information, if valid */
-	if (current->thread.fault_code) {
+	if (add_all || current->thread.fault_code) {
 		err = sigframe_alloc(user, &user->esr_offset,
 				     sizeof(struct esr_context));
 		if (err)
@@ -595,7 +602,6 @@ static int setup_sigframe_layout(struct rt_sigframe_user_layout *user)
 	return sigframe_alloc_end(user);
 }
 
-
 static int setup_sigframe(struct rt_sigframe_user_layout *user,
 			  struct pt_regs *regs, sigset_t *set)
 {
@@ -693,7 +699,7 @@ static int get_sigframe(struct rt_sigframe_user_layout *user,
 	int err;
 
 	init_user_layout(user);
-	err = setup_sigframe_layout(user);
+	err = setup_sigframe_layout(user, false);
 	if (err)
 		return err;
 
@@ -927,3 +933,25 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
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
+	} else
+		return sigframe_size(&user) +
+			round_up(sizeof(struct frame_record), 16) +
+			16; /* max alignment padding */
+}
-- 
2.1.4
