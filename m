From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v10 01/18] arm64: fpsimd: Fix TIF_FOREIGN_FPSTATE after
 invalidating cpu regs
Date: Tue, 22 May 2018 17:05:02 +0100
Message-ID: <1527005119-6842-2-git-send-email-Dave.Martin@arm.com>
References: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 697EE4A11D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:56:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cdDO-92EOqZn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 May 2018 11:55:43 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 69F9B4A104
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 May 2018 11:55:33 -0400 (EDT)
In-Reply-To: <1527005119-6842-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

fpsimd_last_state.st is set to NULL as a way of indicating that
current's FPSIMD registers are no longer loaded in the cpu.  In
particular, this is done when the kernel temporarily uses or
clobbers the FPSIMD registers for its own purposes, as in CPU PM or
kernel-mode NEON, resulting in them being populated with garbage
data not belonging to a task.

Commit 17eed27b02da ("arm64/sve: KVM: Prevent guests from using
SVE") factors this operation out as a new helper
fpsimd_flush_cpu_state() to make it clearer what is being done
here, and on SVE systems this helper is now used, via
kvm_fpsimd_flush_cpu_state(), to invalidate the registers after KVM
has run a vcpu.  The reason for this is that KVM does not yet
understand how to restore the full host SVE registers itself after
loading the guest FPSIMD context into them.

This exposes a particular problem: if fpsimd_last_state.st is set
to NULL without also setting TIF_FOREIGN_FPSTATE, the kernel may
continue to think that current's FPSIMD registers are live even
though they have actually been clobbered.

Prior to the aforementioned commit, the only path where
fpsimd_last_state.st is set to NULL without setting
TIF_FOREIGN_FPSTATE is when kernel_neon_begin() is called by a
kernel thread (where current->mm can be NULL).  This does not
matter, because the only harm is that at context-switch time
fpsimd_thread_switch() may unnecessarily save the FPSIMD registers
back to current's thread_struct (even though kernel threads are not
considered to have any FPSIMD context of their own and the
registers will never be reloaded).

Note that although CPU_PM_ENTER lacks the TIF_FOREIGN_FPSTATE
setting, every CPU passing through that path must subsequently pass
through CPU_PM_EXIT before it can re-enter the kernel proper.
CPU_PM_EXIT sets the flag.

The sve_flush_cpu_state() function added by commit 17eed27b02da
also lacks the proper maintenance of TIF_FOREIGN_FPSTATE.  This may
cause the bits of a host task's SVE registers that do not alias the
FPSIMD register file to spontaneously appear zeroed if a KVM vcpu
runs in the same task in the meantime.  Although this effect is
hidden by the fact that the non-FPSIMD bits of the SVE registers
are zeroed by a syscall anyway, it is doubtless a bad idea to rely
on these different code paths interacting correctly under future
maintenance.

This patch makes TIF_FOREIGN_FPSTATE an unconditional side-effect
of fpsimd_flush_cpu_state(), and removes the set_thread_flag()
calls that become redunant as a result.  This ensures that
TIF_FOREIGN_FPSTATE cannot remain clear if the FPSIMD state in the
FPSIMD registers is invalid.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>

---

Changes since v9:

 * New patch (bugfix to subsequent commits).
---
 arch/arm64/kernel/fpsimd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 87a3536..12e1c96 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1067,6 +1067,7 @@ void fpsimd_flush_task_state(struct task_struct *t)
 static inline void fpsimd_flush_cpu_state(void)
 {
 	__this_cpu_write(fpsimd_last_state.st, NULL);
+	set_thread_flag(TIF_FOREIGN_FPSTATE);
 }
 
 /*
@@ -1121,10 +1122,8 @@ void kernel_neon_begin(void)
 	__this_cpu_write(kernel_neon_busy, true);
 
 	/* Save unsaved task fpsimd state, if any: */
-	if (current->mm) {
+	if (current->mm)
 		task_fpsimd_save();
-		set_thread_flag(TIF_FOREIGN_FPSTATE);
-	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
 	fpsimd_flush_cpu_state();
@@ -1251,8 +1250,6 @@ static int fpsimd_cpu_pm_notifier(struct notifier_block *self,
 		fpsimd_flush_cpu_state();
 		break;
 	case CPU_PM_EXIT:
-		if (current->mm)
-			set_thread_flag(TIF_FOREIGN_FPSTATE);
 		break;
 	case CPU_PM_ENTER_FAILED:
 	default:
-- 
2.1.4
