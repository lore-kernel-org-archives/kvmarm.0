Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE7B1F1526;
	Tue, 25 Mar 2025 18:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742928570; cv=none; b=dxZzvgglaaa/9R1M0URjqjGTaChGXuQKXfp3c7tH3Rab63jsIKJOnbTvH5o9tFKZaGU0xkLaXLBKKUyBjFDpwzPSZ46llbK3EvSPfwckrSm+UTu84WpCS4aOJH1Eg2xP5aheWaG0CEYaoOHBt/a4GWwBla39h2Tne5TqP8sc+7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742928570; c=relaxed/simple;
	bh=9bK1pLnPw0ndr+CZ33l3PmoXOB7bAHxLqCaExh5vFpY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XBV15+tDeWLniiiVLA7pdn/oU+KzS7rEtPoxx/JSfHohFAbXr9owcWR/tHuiKbLiNcn6U8lCZFLtMAUbn8/VB+y8ALUbloqjqKuvFClKzP72g2LfbMxQi7PAYxqgLNv9/cefdACyLpkl7ZtmfoUTOkopiHNj8v1UAKizy9FlA0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TOevBzYR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TOevBzYR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B419C4CEEF;
	Tue, 25 Mar 2025 18:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742928570;
	bh=9bK1pLnPw0ndr+CZ33l3PmoXOB7bAHxLqCaExh5vFpY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TOevBzYRC5JeTBzCLG1IGg9LuEgFu0wV9Ts24h4NkiTboPw6StkAHZe8WvIqaUpOL
	 kxjBxlGxjmBfZ9M5XaDFoMOUGl4UbZ2PAdD2+kXzkN1AhAWl9OGsWhS+LJ7R0oMRDK
	 6NTlVUXknKJdrf8pcTauKkfnFAznaRMSjJN/PVdAaqn/75uCY6ry1eTDJTutJTj6yg
	 imeQhqHMA9lh7FJAIx2WW8H+/LQ4P5Nvr+yHzG0UFoN9CQcMjekqchH48IK20uycvF
	 O6rJQveKTOTHPqvrqAhP6bS7aFNz7BnkvG7+jNtvX8CLNjC9kyFIA5fGu+0xuNXN+m
	 tdNk6ENul957w==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 25 Mar 2025 18:48:16 +0000
Subject: [PATCH 6.1 02/12] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250325-stable-sve-6-1-v1-2-83259d427d84@kernel.org>
References: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
In-Reply-To: <20250325-stable-sve-6-1-v1-0-83259d427d84@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-1b0d6
X-Developer-Signature: v=1; a=openpgp-sha256; l=13750; i=broonie@kernel.org;
 h=from:subject:message-id; bh=9bK1pLnPw0ndr+CZ33l3PmoXOB7bAHxLqCaExh5vFpY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn4vqnvbIvrpJOzkFMUTLwDw96gXLVP8PkfQv9Dsfr
 lOKFrk+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+L6pwAKCRAk1otyXVSH0MvvB/
 40AlD/vuzhTxJEyfrtPYhPp8coiDbHHVWLw76Uh7pouX8itJzIlaa1Fhpsi2F1Ctcnb68OCfGNzqJa
 EtkrKh5A3/wbIll6Bax7Pzxc/eHHD/8/TU5yt02Py7bmiP33plL02Gvetj+mFRl+Y9M8WhyG/xTXiH
 QeIwa/nLpVIxENaHQotOuaMNO0WQwDvqloUcmWcAKu6GKWgFiiD2f5mV+sovLpXOjsmfHgH2AGVDiH
 swOydWh04loCo2abv7PAgJyzdJ6MHGti7sywGPhd9pnJji8WnMvxI01w2koMTlBgGLp2Uq4Dkc6o+Z
 0PRqWKP1/DtkNMP0RO2wT7nHsgYWZx
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

[ Upstream commit baa8515281b30861cff3da7db70662d2a25c6440 ]

When we save the state for the floating point registers this can be done
in the form visible through either the FPSIMD V registers or the SVE Z and
P registers. At present we track which format is currently used based on
TIF_SVE and the SME streaming mode state but particularly in the SVE case
this limits our options for optimising things, especially around syscalls.
Introduce a new enum which we place together with saved floating point
state in both thread_struct and the KVM guest state which explicitly
states which format is active and keep it up to date when we change it.

At present we do not use this state except to verify that it has the
expected value when loading the state, future patches will introduce
functional changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-3-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: fix conflicts due to earlier backports ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    |  2 +-
 arch/arm64/include/asm/kvm_host.h  | 12 +++++++-
 arch/arm64/include/asm/processor.h |  6 ++++
 arch/arm64/kernel/fpsimd.c         | 58 ++++++++++++++++++++++++++++----------
 arch/arm64/kernel/process.c        |  2 ++
 arch/arm64/kernel/ptrace.c         |  3 ++
 arch/arm64/kernel/signal.c         |  7 ++++-
 arch/arm64/kvm/fpsimd.c            |  3 +-
 8 files changed, 74 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 3544dfcc67a1eccc12bdff22347e40c378f4ca6b..e10894100c7394b3f3156f7475d62646662812d4 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -61,7 +61,7 @@ extern void fpsimd_kvm_prepare(void);
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
 				     void *za_state, unsigned int sme_vl,
-				     u64 *svcr);
+				     u64 *svcr, enum fp_type *type);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 577cf444c113583979b9e54fe01b6c5ad21c272d..0e9b093adc6726770e0ff701ae9441ab31e448a5 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -309,8 +309,18 @@ struct vcpu_reset_state {
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 
-	/* Guest floating point state */
+	/*
+	 * Guest floating point state
+	 *
+	 * The architecture has two main floating point extensions,
+	 * the original FPSIMD and SVE.  These have overlapping
+	 * register views, with the FPSIMD V registers occupying the
+	 * low 128 bits of the SVE Z registers.  When the core
+	 * floating point code saves the register state of a task it
+	 * records which view it saved in fp_type.
+	 */
 	void *sve_state;
+	enum fp_type fp_type;
 	unsigned int sve_max_vl;
 	u64 svcr;
 
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 400f8956328b97db27c8d6d937ab66bd24228c2b..208434a2e9247c9be5c85a032494f256e4c2cd58 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -122,6 +122,11 @@ enum vec_type {
 	ARM64_VEC_MAX,
 };
 
+enum fp_type {
+	FP_STATE_FPSIMD,
+	FP_STATE_SVE,
+};
+
 struct cpu_context {
 	unsigned long x19;
 	unsigned long x20;
@@ -152,6 +157,7 @@ struct thread_struct {
 		struct user_fpsimd_state fpsimd_state;
 	} uw;
 
+	enum fp_type		fp_type;	/* registers FPSIMD or SVE? */
 	unsigned int		fpsimd_cpu;
 	void			*sve_state;	/* SVE registers, if any */
 	void			*za_state;	/* ZA register, if any */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 1dc4254a99f25289278b83965946e09674ad4e75..2e0cecf02bf8fcaa799cf1bc89439a61a2a77973 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -125,6 +125,7 @@ struct fpsimd_last_state_struct {
 	u64 *svcr;
 	unsigned int sve_vl;
 	unsigned int sme_vl;
+	enum fp_type *fp_type;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -330,15 +331,6 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    The task can execute SVE instructions while in userspace without
  *    trapping to the kernel.
  *
- *    When stored, Z0-Z31 (incorporating Vn in bits[127:0] or the
- *    corresponding Zn), P0-P15 and FFR are encoded in
- *    task->thread.sve_state, formatted appropriately for vector
- *    length task->thread.sve_vl or, if SVCR.SM is set,
- *    task->thread.sme_vl.
- *
- *    task->thread.sve_state must point to a valid buffer at least
- *    sve_state_size(task) bytes in size.
- *
  *    During any syscall, the kernel may optionally clear TIF_SVE and
  *    discard the vector state except for the FPSIMD subset.
  *
@@ -348,7 +340,15 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    do_sve_acc() to be called, which does some preparation and then
  *    sets TIF_SVE.
  *
- *    When stored, FPSIMD registers V0-V31 are encoded in
+ * During any syscall, the kernel may optionally clear TIF_SVE and
+ * discard the vector state except for the FPSIMD subset.
+ *
+ * The data will be stored in one of two formats:
+ *
+ *  * FPSIMD only - FP_STATE_FPSIMD:
+ *
+ *    When the FPSIMD only state stored task->thread.fp_type is set to
+ *    FP_STATE_FPSIMD, the FPSIMD registers V0-V31 are encoded in
  *    task->thread.uw.fpsimd_state; bits [max : 128] for each of Z0-Z31 are
  *    logically zero but not stored anywhere; P0-P15 and FFR are not
  *    stored and have unspecified values from userspace's point of
@@ -358,6 +358,19 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    task->thread.sve_state does not need to be non-NULL, valid or any
  *    particular size: it must not be dereferenced.
  *
+ *  * SVE state - FP_STATE_SVE:
+ *
+ *    When the full SVE state is stored task->thread.fp_type is set to
+ *    FP_STATE_SVE and Z0-Z31 (incorporating Vn in bits[127:0] or the
+ *    corresponding Zn), P0-P15 and FFR are encoded in in
+ *    task->thread.sve_state, formatted appropriately for vector
+ *    length task->thread.sve_vl or, if SVCR.SM is set,
+ *    task->thread.sme_vl. The storage for the vector registers in
+ *    task->thread.uw.fpsimd_state should be ignored.
+ *
+ *    task->thread.sve_state must point to a valid buffer at least
+ *    sve_state_size(task) bytes in size.
+ *
  *  * FPSR and FPCR are always stored in task->thread.uw.fpsimd_state
  *    irrespective of whether TIF_SVE is clear or set, since these are
  *    not vector length dependent.
@@ -404,12 +417,15 @@ static void task_fpsimd_load(void)
 		}
 	}
 
-	if (restore_sve_regs)
+	if (restore_sve_regs) {
+		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_SVE);
 		sve_load_state(sve_pffr(&current->thread),
 			       &current->thread.uw.fpsimd_state.fpsr,
 			       restore_ffr);
-	else
+	} else {
+		WARN_ON_ONCE(current->thread.fp_type != FP_STATE_FPSIMD);
 		fpsimd_load_state(&current->thread.uw.fpsimd_state);
+	}
 }
 
 /*
@@ -474,8 +490,10 @@ static void fpsimd_save(void)
 		sve_save_state((char *)last->sve_state +
 					sve_ffr_offset(vl),
 			       &last->st->fpsr, save_ffr);
+		*last->fp_type = FP_STATE_SVE;
 	} else {
 		fpsimd_save_state(last->st);
+		*last->fp_type = FP_STATE_FPSIMD;
 	}
 }
 
@@ -851,8 +869,10 @@ int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 
 	fpsimd_flush_task_state(task);
 	if (test_and_clear_tsk_thread_flag(task, TIF_SVE) ||
-	    thread_sm_enabled(&task->thread))
+	    thread_sm_enabled(&task->thread)) {
 		sve_to_fpsimd(task);
+		task->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	if (system_supports_sme()) {
 		if (type == ARM64_VEC_SME ||
@@ -1383,6 +1403,7 @@ static void sve_init_regs(void)
 		fpsimd_bind_task_to_cpu();
 	} else {
 		fpsimd_to_sve(current);
+		current->thread.fp_type = FP_STATE_SVE;
 		fpsimd_flush_task_state(current);
 	}
 }
@@ -1612,6 +1633,8 @@ void fpsimd_flush_thread(void)
 		current->thread.svcr = 0;
 	}
 
+	current->thread.fp_type = FP_STATE_FPSIMD;
+
 	put_cpu_fpsimd_context();
 	kfree(sve_state);
 	kfree(za_state);
@@ -1660,8 +1683,10 @@ void fpsimd_kvm_prepare(void)
 	 */
 	get_cpu_fpsimd_context();
 
-	if (test_and_clear_thread_flag(TIF_SVE))
+	if (test_and_clear_thread_flag(TIF_SVE)) {
 		sve_to_fpsimd(current);
+		current->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	put_cpu_fpsimd_context();
 }
@@ -1683,6 +1708,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sve_vl = task_get_sve_vl(current);
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
+	last->fp_type = &current->thread.fp_type;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1706,7 +1732,8 @@ static void fpsimd_bind_task_to_cpu(void)
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
-			      unsigned int sme_vl, u64 *svcr)
+			      unsigned int sme_vl, u64 *svcr,
+			      enum fp_type *type)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1720,6 +1747,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->za_state = za_state;
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
+	last->fp_type = type;
 }
 
 /*
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 3f06e9d4527181eaa0c6422c5c1bf2643ce6bfff..7092840deb5c84260faec77adb8fa30ff0ec9081 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -331,6 +331,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 		clear_tsk_thread_flag(dst, TIF_SME);
 	}
 
+	dst->thread.fp_type = FP_STATE_FPSIMD;
+
 	/* clear any pending asynchronous tag fault raised by the parent */
 	clear_tsk_thread_flag(dst, TIF_MTE_ASYNC_FAULT);
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index b178bbdc1c3b903670cbfa08448e80fc4d361f38..2f1f86d91612914749a13aeec74c7f4df52808d7 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -917,6 +917,7 @@ static int sve_set_common(struct task_struct *target,
 		clear_tsk_thread_flag(target, TIF_SVE);
 		if (type == ARM64_VEC_SME)
 			fpsimd_force_sync_to_sve(target);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -939,6 +940,7 @@ static int sve_set_common(struct task_struct *target,
 	if (!target->thread.sve_state) {
 		ret = -ENOMEM;
 		clear_tsk_thread_flag(target, TIF_SVE);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -952,6 +954,7 @@ static int sve_set_common(struct task_struct *target,
 	fpsimd_sync_to_sve(target);
 	if (type == ARM64_VEC_SVE)
 		set_tsk_thread_flag(target, TIF_SVE);
+	target->thread.fp_type = FP_STATE_SVE;
 
 	BUILD_BUG_ON(SVE_PT_SVE_OFFSET != sizeof(header));
 	start = SVE_PT_SVE_OFFSET;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index 82f4572c8ddfc78da04a70c9db4181ed94d20f17..2461bbffe7d47a0bbab24c2a923fb16f987ffbb4 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -207,6 +207,7 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	clear_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
 	if (!err)
@@ -297,6 +298,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (sve.head.size <= sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
 		current->thread.svcr &= ~SVCR_SM_MASK;
+		current->thread.fp_type = FP_STATE_FPSIMD;
 		goto fpsimd_only;
 	}
 
@@ -332,6 +334,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 		current->thread.svcr |= SVCR_SM_MASK;
 	else
 		set_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_SVE;
 
 fpsimd_only:
 	/* copy the FP and status/control registers */
@@ -937,9 +940,11 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
 		 * FPSIMD register state - flush the saved FPSIMD
 		 * register state in case it gets loaded.
 		 */
-		if (current->thread.svcr & SVCR_SM_MASK)
+		if (current->thread.svcr & SVCR_SM_MASK) {
 			memset(&current->thread.uw.fpsimd_state, 0,
 			       sizeof(current->thread.uw.fpsimd_state));
+			current->thread.fp_type = FP_STATE_FPSIMD;
+		}
 
 		current->thread.svcr &= ~(SVCR_ZA_MASK |
 					  SVCR_SM_MASK);
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 51ca78b31b95241bb8186a473d1bf5ccd50a16f0..a4b4502ad850a5c12f0d2809bdedbba6c6eb957e 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -140,7 +140,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl,
-					 NULL, 0, &vcpu->arch.svcr);
+					 NULL, 0, &vcpu->arch.svcr,
+					 &vcpu->arch.fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));

-- 
2.39.5

