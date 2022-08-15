Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6532C25B08
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F804D8B0;
	Mon, 15 Aug 2022 18:58:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HiDzHxAAWHsk; Mon, 15 Aug 2022 18:58:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 972BE4D8A9;
	Mon, 15 Aug 2022 18:58:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C50DC4D8AE
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0lMYIa0V8xmW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:13 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 335734D883
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:13 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 2266BB811A0;
 Mon, 15 Aug 2022 22:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F913C433D6;
 Mon, 15 Aug 2022 22:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604290;
 bh=E2y9Q/gWgAfmGgWq3oAFHf7g8o0mlhcpIWRadXqL5J8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=PDpBAs963TRf/wUzJfSZ4T2gbOWIMloPr+sprjo6QxUwwIbOKJyTcOPFK9WSnJFaL
 erm2sgs2AJibBL3dGIYwde2LOvI8/iZUxk1ZsVT7jWkI39IhBANZ2ql3CZddGrgUFA
 qjRDLmzBG6w1TthSIAXM7TJIGwl4kFdGXqQdwHDIRKfJfoTRMXd8N3GB57vn3LwVW7
 v65ejfTs0jEag62DUPK8wH/ggyv22wim0f9HGHlOjQ3g9w1OeQOwoKE5fmlTrkXAme
 ct+ZgxGyxagopNlpogdr35fV65cuZy8uaY0ME466OVRSp+RJ4Cwkv9K+aCp/3z08mQ
 hNI1SKM8hne+w==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Date: Mon, 15 Aug 2022 23:55:24 +0100
Message-Id: <20220815225529.930315-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=12333; i=broonie@kernel.org;
 h=from:subject; bh=E2y9Q/gWgAfmGgWq3oAFHf7g8o0mlhcpIWRadXqL5J8=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7bnbQtN6PFCq6T3iitu+nVnesC1rGLpu+GxOGU
 xegk4X+JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO2wAKCRAk1otyXVSH0ENMB/
 9nqtZJzPyQnerYerElAsG/jXZRhA2JG2scxna1IZ8XvZ7COq+lfws+Hsf7qA1acPPs7L18K1FqUeHL
 +lmvHefRUq60BtFob/JTPDe05Prj8h69ltTGqejFvU7u32jIEOSfedrLM5bZhR9IJ4vyfCT5JOEct9
 irJDWyzSNDTDaGGvk6hmz5sAmyFsKIHDtFT3pu5odkyHN7qGz4xlkSevxRlTw59m8S7PykDzqgUk4G
 RBYYkN7hGCVeywsdU1YP2z7kRWr+VvKxnlntlvOGQhsh2941AOs4tm4x9mS1PD3P5Ytz238xVHbR2a
 G18tDO1OonRE3TGzAgilPIIR9UKv5E
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

When we save the state for the floating point registers this can be done
in the form visible through either the FPSIMD V registers or the SVE Z and
P registers. At present we track which format is currently used based on
TIF_SVE and the SME streaming mode state but particularly in the SVE case
this limits our options for optimising things, especially around syscalls.
Introduce a new enum in thread_struct which explicitly states which format
is active and keep it up to date when we change it.

At present we do not use this state except to verify that it has the
expected value when loading the state, future patches will introduce
functional changes.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    |  2 +-
 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/include/asm/processor.h |  6 ++++
 arch/arm64/kernel/fpsimd.c         | 58 ++++++++++++++++++++++--------
 arch/arm64/kernel/process.c        |  2 ++
 arch/arm64/kernel/ptrace.c         |  3 ++
 arch/arm64/kernel/signal.c         |  7 +++-
 arch/arm64/kvm/fpsimd.c            |  3 +-
 8 files changed, 64 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index c07e4abaca3d..b74103a79052 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -61,7 +61,7 @@ extern void fpsimd_kvm_prepare(void);
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
 				     void *za_state, unsigned int sme_vl,
-				     u64 *svcr);
+				     u64 *svcr, enum fp_state *type);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f38ef299f13b..ebd37f97aeb4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -310,6 +310,7 @@ struct kvm_vcpu_arch {
 	void *sve_state;
 	unsigned int sve_max_vl;
 	u64 svcr;
+	enum fp_state fp_type;
 
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 86eb0bfe3b38..4818a6b77f39 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -122,6 +122,11 @@ enum vec_type {
 	ARM64_VEC_MAX,
 };
 
+enum fp_state {
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
 
+	enum fp_state		fp_type;	/* registers FPSIMD or SVE? */
 	unsigned int		fpsimd_cpu;
 	void			*sve_state;	/* SVE registers, if any */
 	void			*za_state;	/* ZA register, if any */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 549e11645e0f..6544ae00230f 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -125,6 +125,7 @@ struct fpsimd_last_state_struct {
 	u64 *svcr;
 	unsigned int sve_vl;
 	unsigned int sme_vl;
+	enum fp_state *fp_type;
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
 
@@ -848,8 +866,10 @@ int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 
 	fpsimd_flush_task_state(task);
 	if (test_and_clear_tsk_thread_flag(task, TIF_SVE) ||
-	    thread_sm_enabled(&task->thread))
+	    thread_sm_enabled(&task->thread)) {
 		sve_to_fpsimd(task);
+		task->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	if (system_supports_sme() && type == ARM64_VEC_SME) {
 		task->thread.svcr &= ~(SVCR_SM_MASK |
@@ -1368,6 +1388,7 @@ static void sve_init_regs(void)
 		fpsimd_bind_task_to_cpu();
 	} else {
 		fpsimd_to_sve(current);
+		current->thread.fp_type = FP_STATE_SVE;
 	}
 }
 
@@ -1596,6 +1617,8 @@ void fpsimd_flush_thread(void)
 		current->thread.svcr = 0;
 	}
 
+	current->thread.fp_type = FP_STATE_FPSIMD;
+
 	put_cpu_fpsimd_context();
 	kfree(sve_state);
 	kfree(za_state);
@@ -1644,8 +1667,10 @@ void fpsimd_kvm_prepare(void)
 	 */
 	get_cpu_fpsimd_context();
 
-	if (test_and_clear_thread_flag(TIF_SVE))
+	if (test_and_clear_thread_flag(TIF_SVE)) {
 		sve_to_fpsimd(current);
+		current->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	put_cpu_fpsimd_context();
 }
@@ -1667,6 +1692,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sve_vl = task_get_sve_vl(current);
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
+	last->fp_type = &current->thread.fp_type;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1690,7 +1716,8 @@ static void fpsimd_bind_task_to_cpu(void)
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
-			      unsigned int sme_vl, u64 *svcr)
+			      unsigned int sme_vl, u64 *svcr,
+			      enum fp_state *type)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1704,6 +1731,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->za_state = za_state;
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
+	last->fp_type = type;
 }
 
 /*
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 92bcc1768f0b..944d782d581b 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -335,6 +335,8 @@ int arch_dup_task_struct(struct task_struct *dst, struct task_struct *src)
 		clear_tsk_thread_flag(dst, TIF_SME);
 	}
 
+	dst->thread.fp_type = FP_STATE_FPSIMD;
+
 	/* clear any pending asynchronous tag fault raised by the parent */
 	clear_tsk_thread_flag(dst, TIF_MTE_ASYNC_FAULT);
 
diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index eb7c08dfb834..fb6189bc45c9 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -894,6 +894,7 @@ static int sve_set_common(struct task_struct *target,
 		clear_tsk_thread_flag(target, TIF_SVE);
 		if (type == ARM64_VEC_SME)
 			fpsimd_force_sync_to_sve(target);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -916,6 +917,7 @@ static int sve_set_common(struct task_struct *target,
 	if (!target->thread.sve_state) {
 		ret = -ENOMEM;
 		clear_tsk_thread_flag(target, TIF_SVE);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -927,6 +929,7 @@ static int sve_set_common(struct task_struct *target,
 	 */
 	fpsimd_sync_to_sve(target);
 	set_tsk_thread_flag(target, TIF_SVE);
+	target->thread.fp_type = FP_STATE_SVE;
 
 	BUILD_BUG_ON(SVE_PT_SVE_OFFSET != sizeof(header));
 	start = SVE_PT_SVE_OFFSET;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index f00e8b33170a..804cc00befc3 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -207,6 +207,7 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	clear_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
 	if (!err)
@@ -292,6 +293,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (sve.head.size <= sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
 		current->thread.svcr &= ~SVCR_SM_MASK;
+		current->thread.fp_type = FP_STATE_FPSIMD;
 		goto fpsimd_only;
 	}
 
@@ -327,6 +329,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 		current->thread.svcr |= SVCR_SM_MASK;
 	else
 		set_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_SVE;
 
 fpsimd_only:
 	/* copy the FP and status/control registers */
@@ -932,9 +935,11 @@ static void setup_return(struct pt_regs *regs, struct k_sigaction *ka,
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
index 1c1b309ef420..a92977759f8d 100644
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
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
