From: Dave Martin <Dave.Martin@arm.com>
Subject: [RFC PATCH 07/16] arm64/sve: Enable SVE state tracking for non-task
 contexts
Date: Thu, 21 Jun 2018 15:57:31 +0100
Message-ID: <1529593060-542-8-git-send-email-Dave.Martin@arm.com>
References: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E8944A0C3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:47:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xSfOVYOno1eT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 21 Jun 2018 10:46:52 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 164C64A0D3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 21 Jun 2018 10:46:52 -0400 (EDT)
In-Reply-To: <1529593060-542-1-git-send-email-Dave.Martin@arm.com>
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
Cc: Okamoto Takayuki <tokamoto@jp.fujitsu.com>, Christoffer Dall <cdall@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The current FPSIMD/SVE context handling support for non-task (i.e.,
KVM vcpu) contexts does not take SVE into account.  This means that
only task contexts can safely use SVE at present.

In preparation for enabling KVM guests to use SVE, it is necessary
to keep track of SVE state for non-task contexts too.

This patch adds the necessary support, removing assumptions from
the context switch code about the location of the SVE context
storage.

When binding a vcpu context, its vector length is arbitrarily
specified as sve_max_vl for now.  In any case, because TIF_SVE is
presently cleared at vcpu context bind time, the specified vector
length will not be used for anything yet.  In later patches TIF_SVE
will be set here as appropriate, and the appropriate maximum vector
length for the vcpu will be passed when binding.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |  3 ++-
 arch/arm64/kernel/fpsimd.c      | 20 +++++++++++++++-----
 arch/arm64/kvm/fpsimd.c         |  4 +++-
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 3ad4607..d575e59 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -54,7 +54,8 @@ extern void fpsimd_restore_current_state(void);
 extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 
 extern void fpsimd_bind_task_to_cpu(void);
-extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state);
+extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
+				     void *sve_state, unsigned int sve_vl);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_flush_cpu_state(void);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 390afb4..8afc518 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -121,6 +121,8 @@
  */
 struct fpsimd_last_state_struct {
 	struct user_fpsimd_state *st;
+	void *sve_state;
+	unsigned int sve_vl;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -260,14 +262,15 @@ static void task_fpsimd_load(void)
  */
 void fpsimd_save(void)
 {
-	struct user_fpsimd_state *st = __this_cpu_read(fpsimd_last_state.st);
+	struct fpsimd_last_state_struct const *last =
+		this_cpu_ptr(&fpsimd_last_state);
 	/* set by fpsimd_bind_task_to_cpu() or fpsimd_bind_state_to_cpu() */
 
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	if (!test_thread_flag(TIF_FOREIGN_FPSTATE)) {
 		if (system_supports_sve() && test_thread_flag(TIF_SVE)) {
-			if (WARN_ON(sve_get_vl() != current->thread.sve_vl)) {
+			if (WARN_ON(sve_get_vl() != last->sve_vl)) {
 				/*
 				 * Can't save the user regs, so current would
 				 * re-enter user with corrupt state.
@@ -277,9 +280,11 @@ void fpsimd_save(void)
 				return;
 			}
 
-			sve_save_state(sve_pffr(&current->thread), &st->fpsr);
+			sve_save_state((char *)last->sve_state +
+						sve_ffr_offset(last->sve_vl),
+				       &last->st->fpsr);
 		} else
-			fpsimd_save_state(st);
+			fpsimd_save_state(last->st);
 	}
 }
 
@@ -1053,6 +1058,8 @@ void fpsimd_bind_task_to_cpu(void)
 		this_cpu_ptr(&fpsimd_last_state);
 
 	last->st = &current->thread.uw.fpsimd_state;
+	last->sve_state = current->thread.sve_state;
+	last->sve_vl = current->thread.sve_vl;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	if (system_supports_sve()) {
@@ -1066,7 +1073,8 @@ void fpsimd_bind_task_to_cpu(void)
 	}
 }
 
-void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
+void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
+			      unsigned int sve_vl)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1074,6 +1082,8 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st)
 	WARN_ON(!in_softirq() && !irqs_disabled());
 
 	last->st = st;
+	last->sve_state = sve_state;
+	last->sve_vl = sve_vl;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 4aaf78e..872008c 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -85,7 +85,9 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs);
+		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.gp_regs.fp_regs,
+					 NULL, sve_max_vl);
+
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		clear_thread_flag(TIF_SVE);
 	}
-- 
2.1.4
