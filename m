From: Kristina Martsenko <kristina.martsenko@arm.com>
Subject: [RFC 12/17] arm64: move ptrauth keys to thread_info
Date: Fri,  5 Oct 2018 09:47:49 +0100
Message-ID: <20181005084754.20950-13-kristina.martsenko@arm.com>
References: <20181005084754.20950-1-kristina.martsenko@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181005084754.20950-1-kristina.martsenko@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Adam Wallis <awallis@codeaurora.org>, Amit Kachhap <Amit.Kachhap@arm.com>, Andrew Jones <drjones@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, Dave P Martin <Dave.Martin@arm.com>, Jacob Bramley <jacob.bramley@arm.com>, Kees Cook <keescook@chromium.org>, Marc Zyngier <marc.zyngier@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>, "Suzuki K . Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Mark Rutland <mark.rutland@arm.com>

To use pointer authentication in the kernel, we'll need to switch keys
in the entry assembly. This patch moves the pointer auth keys into
thread_info to make this possible.

There should be no functional change as a result of this patch.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/mmu.h          |  5 -----
 arch/arm64/include/asm/mmu_context.h  | 13 -------------
 arch/arm64/include/asm/pointer_auth.h | 13 +++++++------
 arch/arm64/include/asm/thread_info.h  |  4 ++++
 arch/arm64/kernel/process.c           |  4 ++++
 5 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/mmu.h b/arch/arm64/include/asm/mmu.h
index f6480ea7b0d5..dd320df0d026 100644
--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -25,15 +25,10 @@
 
 #ifndef __ASSEMBLY__
 
-#include <asm/pointer_auth.h>
-
 typedef struct {
 	atomic64_t	id;
 	void		*vdso;
 	unsigned long	flags;
-#ifdef CONFIG_ARM64_PTR_AUTH
-	struct ptrauth_keys	ptrauth_keys;
-#endif
 } mm_context_t;
 
 /*
diff --git a/arch/arm64/include/asm/mmu_context.h b/arch/arm64/include/asm/mmu_context.h
index 983f80925566..387e810063c7 100644
--- a/arch/arm64/include/asm/mmu_context.h
+++ b/arch/arm64/include/asm/mmu_context.h
@@ -215,8 +215,6 @@ static inline void __switch_mm(struct mm_struct *next)
 		return;
 	}
 
-	mm_ctx_ptrauth_switch(&next->context);
-
 	check_and_switch_context(next, cpu);
 }
 
@@ -242,17 +240,6 @@ switch_mm(struct mm_struct *prev, struct mm_struct *next,
 void verify_cpu_asid_bits(void);
 void post_ttbr_update_workaround(void);
 
-static inline void arch_bprm_mm_init(struct mm_struct *mm,
-				     struct vm_area_struct *vma)
-{
-	mm_ctx_ptrauth_init(&mm->context);
-}
-#define arch_bprm_mm_init arch_bprm_mm_init
-
-/*
- * We need to override arch_bprm_mm_init before including the generic hooks,
- * which are otherwise sufficient for us.
- */
 #include <asm-generic/mm_hooks.h>
 
 #endif /* !__ASSEMBLY__ */
diff --git a/arch/arm64/include/asm/pointer_auth.h b/arch/arm64/include/asm/pointer_auth.h
index f5a4b075be65..cedb03bd175b 100644
--- a/arch/arm64/include/asm/pointer_auth.h
+++ b/arch/arm64/include/asm/pointer_auth.h
@@ -63,16 +63,17 @@ static inline unsigned long ptrauth_strip_insn_pac(unsigned long ptr)
 	return ptr & ~ptrauth_pac_mask();
 }
 
-#define mm_ctx_ptrauth_init(ctx) \
-	ptrauth_keys_init(&(ctx)->ptrauth_keys)
+#define ptrauth_task_init_user(tsk)	\
+	ptrauth_keys_init(&(tsk)->thread_info.keys_user); \
+	ptrauth_keys_switch(&(tsk)->thread_info.keys_user)
 
-#define mm_ctx_ptrauth_switch(ctx) \
-	ptrauth_keys_switch(&(ctx)->ptrauth_keys)
+#define ptrauth_task_switch(tsk)	\
+	ptrauth_keys_switch(&(tsk)->thread_info.keys_user)
 
 #else /* CONFIG_ARM64_PTR_AUTH */
 #define ptrauth_strip_insn_pac(lr)	(lr)
-#define mm_ctx_ptrauth_init(ctx)
-#define mm_ctx_ptrauth_switch(ctx)
+#define ptrauth_task_init_user(tsk)
+#define ptrauth_task_switch(tsk)
 #endif /* CONFIG_ARM64_PTR_AUTH */
 
 #endif /* __ASM_POINTER_AUTH_H */
diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
index cb2c10a8f0a8..ea9272fb52d4 100644
--- a/arch/arm64/include/asm/thread_info.h
+++ b/arch/arm64/include/asm/thread_info.h
@@ -28,6 +28,7 @@
 struct task_struct;
 
 #include <asm/memory.h>
+#include <asm/pointer_auth.h>
 #include <asm/stack_pointer.h>
 #include <asm/types.h>
 
@@ -43,6 +44,9 @@ struct thread_info {
 	u64			ttbr0;		/* saved TTBR0_EL1 */
 #endif
 	int			preempt_count;	/* 0 => preemptable, <0 => bug */
+#ifdef CONFIG_ARM64_PTR_AUTH
+	struct ptrauth_keys	keys_user;
+#endif
 };
 
 #define thread_saved_pc(tsk)	\
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 7f1628effe6d..fae52be66c92 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -57,6 +57,7 @@
 #include <asm/fpsimd.h>
 #include <asm/mmu_context.h>
 #include <asm/processor.h>
+#include <asm/pointer_auth.h>
 #include <asm/stacktrace.h>
 
 #ifdef CONFIG_STACKPROTECTOR
@@ -425,6 +426,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	contextidr_thread_switch(next);
 	entry_task_switch(next);
 	uao_thread_switch(next);
+	ptrauth_task_switch(next);
 
 	/*
 	 * Complete any pending TLB or cache maintenance on this CPU in case
@@ -492,6 +494,8 @@ unsigned long arch_randomize_brk(struct mm_struct *mm)
 void arch_setup_new_exec(void)
 {
 	current->mm->context.flags = is_compat_task() ? MMCF_AARCH32 : 0;
+
+	ptrauth_task_init_user(current);
 }
 
 #ifdef CONFIG_GCC_PLUGIN_STACKLEAK
-- 
2.11.0
