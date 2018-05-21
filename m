From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v9 10/16] arm64/sve: Switch sve_pffr() argument from task to
 thread
Date: Mon, 21 May 2018 15:17:11 +0100
Message-ID: <1526912237-25308-11-git-send-email-Dave.Martin@arm.com>
References: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44D614A0CD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 10:08:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6rZy4LffLgti for <kvmarm@lists.cs.columbia.edu>;
 Mon, 21 May 2018 10:07:44 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 431CB4A0E6
 for <kvmarm@lists.cs.columbia.edu>; Mon, 21 May 2018 10:07:44 -0400 (EDT)
In-Reply-To: <1526912237-25308-1-git-send-email-Dave.Martin@arm.com>
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

sve_pffr(), which is used to derive the base address used for
low-level SVE save/restore routines, currently takes the relevant
task_struct as an argument.

The only accessed fields are actually part of thread_struct, so
this patch changes the argument type accordingly.  This is done in
preparation for moving this function to a header, where we do not
want to have to include <linux/sched.h> due to the consequent
circular #include problems.

No functional change.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 5c33667..a456d6f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -44,6 +44,7 @@
 #include <asm/fpsimd.h>
 #include <asm/cpufeature.h>
 #include <asm/cputype.h>
+#include <asm/processor.h>
 #include <asm/simd.h>
 #include <asm/sigcontext.h>
 #include <asm/sysreg.h>
@@ -167,10 +168,9 @@ static size_t sve_ffr_offset(int vl)
 	return SVE_SIG_FFR_OFFSET(sve_vq_from_vl(vl)) - SVE_SIG_REGS_OFFSET;
 }
 
-static void *sve_pffr(struct task_struct *task)
+static void *sve_pffr(struct thread_struct *thread)
 {
-	return (char *)task->thread.sve_state +
-		sve_ffr_offset(task->thread.sve_vl);
+	return (char *)thread->sve_state + sve_ffr_offset(thread->sve_vl);
 }
 
 static void change_cpacr(u64 val, u64 mask)
@@ -253,7 +253,7 @@ static void task_fpsimd_load(void)
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (system_supports_sve() && test_thread_flag(TIF_SVE))
-		sve_load_state(sve_pffr(current),
+		sve_load_state(sve_pffr(&current->thread),
 			       &current->thread.uw.fpsimd_state.fpsr,
 			       sve_vq_from_vl(current->thread.sve_vl) - 1);
 	else
@@ -284,7 +284,7 @@ void fpsimd_save(void)
 				return;
 			}
 
-			sve_save_state(sve_pffr(current), &st->fpsr);
+			sve_save_state(sve_pffr(&current->thread), &st->fpsr);
 		} else
 			fpsimd_save_state(st);
 	}
-- 
2.1.4
