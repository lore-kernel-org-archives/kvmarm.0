Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57496AB5
	for <kvmarm@lists.linux.dev>; Fri, 21 Oct 2022 23:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6046AC433B5;
	Fri, 21 Oct 2022 23:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1666393430;
	bh=eGDqfmzxL6Va/B7O0jEjjeg5/7uhjY++g4A/SdVAwMY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFyPQDdv/fzrDCZB9CQhLDpS+1QCJpYNuREhnNqT5zEzWiWUxXjL54Ont6uBG8bY1
	 GGqC5rlgawFTmP2SQDmLIiziGnF2yIasBgjF/Oc2T/ZIiPUyxwkRgYv1Wk7i/l90P7
	 dF1tHO83cuaH4XfcME0uvzCh1VAFVqIDwRseaWLUUDa7+zZw7Q2j4vL5VnVuWS5KIr
	 8J5HQ0BVbMwQe2tXy7b5gsPuHaLEM8S3yJ37UQyqfg2L4KU6hHwErEVkbK4YZnnMNl
	 /rhM6yLo0pyQn9xCs0BUb1gP9Yc12xAITJG1jAj71oU/ceulHsSWqQBzDByza2kV7X
	 g2F9IBHhnTxBA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>,
	Zhang Lei <zhang.lei@jp.fujitsu.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Andre Przywara <andre.przywara@arm.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH v4 3/8] arm64/fpsimd: Have KVM explicitly say which FP registers to save
Date: Sat, 22 Oct 2022 00:03:16 +0100
Message-Id: <20221021230321.1159287-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221021230321.1159287-1-broonie@kernel.org>
References: <20221021230321.1159287-1-broonie@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6550; i=broonie@kernel.org; h=from:subject; bh=eGDqfmzxL6Va/B7O0jEjjeg5/7uhjY++g4A/SdVAwMY=; b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBjUyUzPL76ynNStgSLmSaBowSzNwv2W32CYnG9sH33 3tYs4wKJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCY1MlMwAKCRAk1otyXVSH0E2iB/ 9yXvfvf+uzTI2BPuEF40OX1glfqPV5Di/qtEliIkcDuaw0hwjihzNZ3TtSadyCU45h/Mtnwm7vAhds cVVuvB5j4PqrLz7UqwimwnqnTj7+HuYsSA9cJcmKCtksKwsaWeunjaC7caBUf3NvOh8tybiaQEvk8w iWL2A865+63gKBKPvJXjOUFAuSQjjEKa4n1QOJ76Qf1MxMuyN3mCMdgLF1ThYt2cATn8Tc2nQfpkfk sMkPnxkWqZndPuq0d5AJrdqBpfwKD2T9O7yQAeadk5gtp995lmhZzRrM+fzgSrYZ3+UAC5ZtLqtokV ZxsXcxra7WZ7YugNdScJr57hj5G9au
X-Developer-Key: i=broonie@kernel.org; a=openpgp; fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Content-Transfer-Encoding: 8bit

In order to avoid needlessly saving and restoring the guest registers KVM
relies on the host FPSMID code to save the guest registers when we context
switch away from the guest. This is done by binding the KVM guest state to
the CPU on top of the task state that was originally there, then carefully
managing the TIF_SVE flag for the task to cause the host to save the full
SVE state when needed regardless of the needs of the host task. This works
well enough but isn't terribly direct about what is going on and makes it
much more complicated to try to optimise what we're doing with the SVE
register state.

Let's instead have KVM pass in the register state it wants saving when it
binds to the CPU. We introduce a new FP_STATE_TASK for use during normal
task binding to indicate that we should base our decisions on the current
task. This should not ben used when actually saving. Ideally we might
want to use a separate enum for the type to save but this enum and the
enum values would then need to be named which has problems with clarity
and ambiguity.

In order to ease any future debugging that might be required this patch
does not actually update any of the decision making about what to save,
it merely starts tracking the new information and warns if the requested
state is not what we would otherwise have decided to save.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    |  3 ++-
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/fpsimd.c         | 27 ++++++++++++++++++++++++---
 arch/arm64/kvm/fpsimd.c            |  9 ++++++++-
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 341705fcb7bb..0ad683dab1e2 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -61,7 +61,8 @@ extern void fpsimd_kvm_prepare(void);
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
 				     void *za_state, unsigned int sme_vl,
-				     u64 *svcr, enum fp_type *type);
+				     u64 *svcr, enum fp_type *type,
+				     enum fp_type to_save);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 3cce0a4c4e8d..1d48398cb6dc 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -123,6 +123,7 @@ enum vec_type {
 };
 
 enum fp_type {
+	FP_STATE_TASK,		/* Save based on current task state. */
 	FP_STATE_FPSIMD,
 	FP_STATE_SVE,
 };
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index aacd8e356084..f819f79e69cc 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -126,6 +126,7 @@ struct fpsimd_last_state_struct {
 	unsigned int sve_vl;
 	unsigned int sme_vl;
 	enum fp_type *fp_type;
+	enum fp_type to_save;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -356,7 +357,8 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    but userspace is discouraged from relying on this.
  *
  *    task->thread.sve_state does not need to be non-NULL, valid or any
- *    particular size: it must not be dereferenced.
+ *    particular size: it must not be dereferenced and any data stored
+ *    there should be considered stale and not referenced.
  *
  *  * SVE state - FP_STATE_SVE:
  *
@@ -369,7 +371,9 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    task->thread.uw.fpsimd_state should be ignored.
  *
  *    task->thread.sve_state must point to a valid buffer at least
- *    sve_state_size(task) bytes in size.
+ *    sve_state_size(task) bytes in size. The data stored in
+ *    task->thread.uw.fpsimd_state.vregs should be considered stale
+ *    and not referenced.
  *
  *  * FPSR and FPCR are always stored in task->thread.uw.fpsimd_state
  *    irrespective of whether TIF_SVE is clear or set, since these are
@@ -459,6 +463,21 @@ static void fpsimd_save(void)
 		vl = last->sve_vl;
 	}
 
+	/*
+	 * Validate that an explicitly specified state to save is
+	 * consistent with the task state.
+	 */
+	switch (last->to_save) {
+	case FP_STATE_TASK:
+		break;
+	case FP_STATE_FPSIMD:
+		WARN_ON_ONCE(save_sve_regs);
+		break;
+	case FP_STATE_SVE:
+		WARN_ON_ONCE(!save_sve_regs);
+		break;
+	}
+
 	if (system_supports_sme()) {
 		u64 *svcr = last->svcr;
 
@@ -1693,6 +1712,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
 	last->fp_type = &current->thread.fp_type;
+	last->to_save = FP_STATE_TASK;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1717,7 +1737,7 @@ static void fpsimd_bind_task_to_cpu(void)
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
 			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_type *type)
+			      enum fp_type *type, enum fp_type to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1732,6 +1752,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
 	last->fp_type = type;
+	last->to_save = to_save;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index a4b4502ad850..89c02ce797b8 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -130,9 +130,16 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
+	enum fp_type fp_type;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.fp_state == FP_STATE_GUEST_OWNED) {
+		if (vcpu_has_sve(vcpu))
+			fp_type = FP_STATE_SVE;
+		else
+			fp_type = FP_STATE_FPSIMD;
+
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
@@ -141,7 +148,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl,
 					 NULL, 0, &vcpu->arch.svcr,
-					 &vcpu->arch.fp_type);
+					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
-- 
2.30.2

