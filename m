From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v6 10/15] arm64/sve: Move sve_pffr() to fpsimd.h and make
 inline
Date: Tue,  8 May 2018 17:44:55 +0100
Message-ID: <1525797900-5548-11-git-send-email-Dave.Martin@arm.com>
References: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E12E400D4
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:36:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YpXz9xbjo9MZ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 May 2018 12:36:15 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BE494A0CA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 May 2018 12:36:02 -0400 (EDT)
In-Reply-To: <1525797900-5548-1-git-send-email-Dave.Martin@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@kernel.org>, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

In order to make sve_save_state()/sve_load_state() more easily
reusable and to get rid of a potential branch on context switch
critical paths, this patch makes sve_pffr() inline and moves it to
fpsimd.h.

<asm/processor.h> must be included in fpsimd.h in order to make
this work, and this creates an #include cycle that is tricky to
avoid without modifying core code, due to the way the PR_SVE_*()
prctl helpers are included in the core prctl implementation.

Instead of breaking the cycle, this patch defers inclusion of
<asm/fpsimd.h> in <asm/processor.h> until the point where it is
actually needed: i.e., immediately before the prctl definitions.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/fpsimd.h    | 13 +++++++++++++
 arch/arm64/include/asm/processor.h |  3 ++-
 arch/arm64/kernel/fpsimd.c         | 12 ------------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index f4d80ae..0026a92 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -18,6 +18,8 @@
 
 #include <asm/ptrace.h>
 #include <asm/errno.h>
+#include <asm/processor.h>
+#include <asm/sigcontext.h>
 
 #ifndef __ASSEMBLY__
 
@@ -60,6 +62,17 @@ extern void sve_flush_cpu_state(void);
 /* Maximum VL that SVE VL-agnostic software can transparently support */
 #define SVE_VL_ARCH_MAX 0x100
 
+/* Offset of FFR in the SVE register dump */
+static inline size_t sve_ffr_offset(int vl)
+{
+	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
+}
+
+static inline void *sve_pffr(struct thread_struct *thread)
+{
+	return (char *)thread->sve_state + sve_ffr_offset(thread->sve_vl);
+}
+
 extern void sve_save_state(void *state, u32 *pfpsr);
 extern void sve_load_state(void const *state, u32 const *pfpsr,
 			   unsigned long vq_minus_1);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index f902b6d..ebaadb1 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -40,7 +40,6 @@
 
 #include <asm/alternative.h>
 #include <asm/cpufeature.h>
-#include <asm/fpsimd.h>
 #include <asm/hw_breakpoint.h>
 #include <asm/lse.h>
 #include <asm/pgtable-hwdef.h>
@@ -245,6 +244,8 @@ void cpu_enable_pan(const struct arm64_cpu_capabilities *__unused);
 void cpu_enable_cache_maint_trap(const struct arm64_cpu_capabilities *__unused);
 void cpu_clear_disr(const struct arm64_cpu_capabilities *__unused);
 
+#include <asm/fpsimd.h>
+
 /* Userspace interface for PR_SVE_{SET,GET}_VL prctl()s: */
 #define SVE_SET_VL(arg)	sve_set_current_vl(arg)
 #define SVE_GET_VL()	sve_get_current_vl()
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index d811679..152d834 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -161,18 +161,6 @@ static void sve_free(struct task_struct *task)
 	__sve_free(task);
 }
 
-
-/* Offset of FFR in the SVE register dump */
-static size_t sve_ffr_offset(int vl)
-{
-	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
-}
-
-static void *sve_pffr(struct thread_struct *thread)
-{
-	return (char *)thread->sve_state + sve_ffr_offset(thread->sve_vl);
-}
-
 static void change_cpacr(u64 val, u64 mask)
 {
 	u64 cpacr = read_sysreg(CPACR_EL1);
-- 
2.1.4
