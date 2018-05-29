From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 16/17] arm64: ssbd: Enable delayed setting of TIF_SSBD
Date: Tue, 29 May 2018 13:11:20 +0100
Message-ID: <20180529121121.24927-17-marc.zyngier@arm.com>
References: <20180529121121.24927-1-marc.zyngier@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529121121.24927-1-marc.zyngier@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoffer Dall <christoffer.dall@arm.com>, Randy Dunlap <rdunlap@infradead.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Julien Grall <julien.grall@arm.com>, Mark Rutland <mark.rutland@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Setting the TIF_SSBD flag on a seccomp thread can happen while the
thread is in userspace (a complete departure from the normal behaviour
of the prctl interface).

As a consequence, the kernel will not enable the mitigation when
transitioning from EL0 to EL1, as it relies on not seeing TIF_SSBD
to call into the firmware. Not exactly what we had planned.

As a way to solve this problem, let's introduce a new TIF_SSBD_PENDING
flag, which gets set on the userspace thread instead of TIF_SSBD.
On entering the kernel, the mitigation will be activated (as the
TIF_SSBD flag is not there). On exit to userspace, we check for the
pending flag, and if present, replace it with TIF_SSBD, leaving
the mitigation on.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/thread_info.h |  1 +
 arch/arm64/kernel/entry.S            | 16 ++++++++++++++++
 arch/arm64/kernel/ssbd.c             |  5 +++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index cbcf11b5e637..e462e7332951 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -95,6 +95,7 @@ void arch_release_task_struct(struct task_struct *tsk);
 #define TIF_SVE			23	/* Scalable Vector Extension in use */
 #define TIF_SVE_VL_INHERIT	24	/* Inherit sve_vl_onexec across exec */
 #define TIF_SSBD		25	/* Wants SSB mitigation */
+#define TIF_SSBD_PENDING	26	/* Sets TIF_SSB on exit to EL0 */
 
 #define _TIF_SIGPENDING		(1 << TIF_SIGPENDING)
 #define _TIF_NEED_RESCHED	(1 << TIF_NEED_RESCHED)
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 28ad8799406f..550c793d9bc6 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -896,12 +896,27 @@ el0_error_naked:
 	b	ret_to_user
 ENDPROC(el0_error)
 
+	.macro fixup_ssbd, tmp1, tmp2, wtmp
+#ifdef CONFIG_ARM64_SSBD
+alternative_cb	arm64_enable_wa2_handling
+	b	2f
+alternative_cb_end
+	// If the thread is in the SSBD_PENDING state, move it to
+	// the SSBD state, ensuring that the mitigation stays on.
+	add	\tmp2, tsk, #TSK_TI_FLAGS
+	test_and_clear_flag \tmp1, \tmp2, TIF_SSBD_PENDING, \wtmp
+	cbz	\tmp1, 2f
+	set_flag \tmp2, TIF_SSBD, \tmp1, \wtmp
+2:
+#endif
+	.endm
 
 /*
  * This is the fast syscall return path.  We do as little as possible here,
  * and this includes saving x0 back into the kernel stack.
  */
 ret_fast_syscall:
+	fixup_ssbd	x20, x21 , w22
 	disable_daif
 	str	x0, [sp, #S_X0]			// returned x0
 	ldr	x1, [tsk, #TSK_TI_FLAGS]	// re-check for syscall tracing
@@ -930,6 +945,7 @@ work_pending:
  * "slow" syscall return path.
  */
 ret_to_user:
+	fixup_ssbd	x20, x21, w22
 	disable_daif
 	ldr	x1, [tsk, #TSK_TI_FLAGS]
 	and	x2, x1, #_TIF_WORK_MASK
diff --git a/arch/arm64/kernel/ssbd.c b/arch/arm64/kernel/ssbd.c
index 07b12c034ec2..34eafdc7fb6b 100644
--- a/arch/arm64/kernel/ssbd.c
+++ b/arch/arm64/kernel/ssbd.c
@@ -43,20 +43,21 @@ static int ssbd_prctl_set(struct task_struct *task, unsigned long ctrl)
 		    task_spec_ssb_force_disable(task))
 			return -EPERM;
 		task_clear_spec_ssb_disable(task);
+		clear_tsk_thread_flag(task, TIF_SSBD_PENDING);
 		clear_tsk_thread_flag(task, TIF_SSBD);
 		break;
 	case PR_SPEC_DISABLE:
 		if (state == ARM64_SSBD_FORCE_DISABLE)
 			return -EPERM;
 		task_set_spec_ssb_disable(task);
-		set_tsk_thread_flag(task, TIF_SSBD);
+		set_tsk_thread_flag(task, TIF_SSBD_PENDING);
 		break;
 	case PR_SPEC_FORCE_DISABLE:
 		if (state == ARM64_SSBD_FORCE_DISABLE)
 			return -EPERM;
 		task_set_spec_ssb_disable(task);
 		task_set_spec_ssb_force_disable(task);
-		set_tsk_thread_flag(task, TIF_SSBD);
+		set_tsk_thread_flag(task, TIF_SSBD_PENDING);
 		break;
 	default:
 		return -ERANGE;
-- 
2.14.2
