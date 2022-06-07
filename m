Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51AB1C43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:23:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E20484B303;
	Tue,  7 Jun 2022 09:23:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9b-juQrphpmb; Tue,  7 Jun 2022 09:23:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CB4854B32C;
	Tue,  7 Jun 2022 09:23:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 588E94B30A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GGG46q44T1fM for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:23:32 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7DF464B30F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:32 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 54EE8B81FE5;
 Tue,  7 Jun 2022 13:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A722CC34119;
 Tue,  7 Jun 2022 13:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654608210;
 bh=x/YnccdfwN1G7uGwzWBBcKl1/jPLQFnyYkcN9xP7yos=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=F/TZ2TB3OSLvGT2aTX4j/GnQGjlUWoWflgSx3c9OmbPed3gXhbUKWwvfCKlFw6NxE
 kLy+/ggjaSJHJ9YsvLSZ7k4GI0N7BMB1KpX2Wiy+l3CpsSDQ5KUWGulVuNVkHYacVC
 20bu07yBYgayeD1+HLRb7gLyqXkAIHkWKWZkqPtoyGtj/aVJrflumjz0hBuVGIBOOy
 kHJTEB2ebbLb24/Wysszz7dLbR9aS/L7TaQF6iHHRheqhBhp9OpvIhl9IsZkQFN/Y1
 FluSfh729olnVYv6RctW06iOwclnD6SuVHWdnvVQObnoW6PkqoA/NX3QJCxIWlbD6Z
 yoYxYVwAOKMtQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 2/7] arm64/fpsimd: Track the saved FPSIMD state type
 separately to TIF_SVE
Date: Tue,  7 Jun 2022 14:17:30 +0100
Message-Id: <20220607131735.1300726-3-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220607131735.1300726-1-broonie@kernel.org>
References: <20220607131735.1300726-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=11892; h=from:subject;
 bh=x/YnccdfwN1G7uGwzWBBcKl1/jPLQFnyYkcN9xP7yos=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBin0/pcNHG4/4RzTcnXPmVnZqcHWmr0RyWzEI34l4K
 XNJRcS6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYp9P6QAKCRAk1otyXVSH0PcSB/
 wPsFmT/W7VtuKUkSmDRsFcpo8fC0GTmYRWp0eZ/HpnaaGeWmWsjpD/uDvXRGuf96VGjl4RgufUF8wB
 8d4spu7WrnqKPY1r6wcIDEdUQr5GEWxmqQL0uavE7HWJ7ZRBeMv568Wq0hkMFyelJtmMGMfa6tyvz1
 OTX1/xhd9LdteC//ypxN1XrgIQ8/BJwJMAyF1JjqDmsRgMGTCRM6AIu6nXZjLoxceWB4LXcyiAiFo3
 tce8evfcQ6IAGTxAq0VufKBFRbEtk/uQzLYkh/94eYTuHZOxP41Ruq1Pb9eYvILMPrOJjEFxtXmfgE
 xCoEWqMN9UOK8u4fez6bjHt5FYGYzL
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
 arch/arm64/include/asm/processor.h |  6 +++
 arch/arm64/kernel/fpsimd.c         | 63 +++++++++++++++++++++---------
 arch/arm64/kernel/process.c        |  2 +
 arch/arm64/kernel/ptrace.c         |  6 ++-
 arch/arm64/kernel/signal.c         |  3 ++
 arch/arm64/kvm/fpsimd.c            |  3 +-
 8 files changed, 63 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index 847fd119cdb8..5762419fdcc0 100644
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
index 47a1e25e25bb..ead30636b8d9 100644
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
index 9e58749db21d..192986509a8e 100644
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
index 3399ebf86b8e..fa54fea0701b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -125,6 +125,7 @@ struct fpsimd_last_state_struct {
 	u64 *svcr;
 	unsigned int sve_vl;
 	unsigned int sme_vl;
+	enum fp_state *type;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -328,19 +329,7 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *  * TIF_SVE or SVCR.SM set:
  *
  *    The task can execute SVE instructions while in userspace without
- *    trapping to the kernel.
- *
- *    When stored, Z0-Z31 (incorporating Vn in bits[127:0] or the
- *    corresponding Zn), P0-P15 and FFR are encoded in in
- *    task->thread.sve_state, formatted appropriately for vector
- *    length task->thread.sve_vl or, if SVCR.SM is set,
- *    task->thread.sme_vl.
- *
- *    task->thread.sve_state must point to a valid buffer at least
- *    sve_state_size(task) bytes in size.
- *
- *    During any syscall, the kernel may optionally clear TIF_SVE and
- *    discard the vector state except for the FPSIMD subset.
+ *    trapping to the kernel and the full SVE state will be stored.
  *
  *  * TIF_SVE clear:
  *
@@ -348,7 +337,15 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
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
@@ -358,6 +355,19 @@ void task_set_vl_onexec(struct task_struct *task, enum vec_type type,
  *    task->thread.sve_state does not need to be non-NULL, valid or any
  *    particular size: it must not be dereferenced.
  *
+ *
+ *  * SVE state - FP_STATE_SVE:
+ *
+ *    When the full SVE state is stored task->thread.fp_type is set to
+ *    FP_STATE_SVE and Z0-Z31 (incorporating Vn in bits[127:0] or the
+ *    corresponding Zn), P0-P15 and FFR are encoded in in
+ *    task->thread.sve_state, formatted appropriately for vector
+ *    length task->thread.sve_vl or, if SVCR.SM is set,
+ *    task->thread.sme_vl.
+ *
+ *    task->thread.sve_state must point to a valid buffer at least
+ *    sve_state_size(task) bytes in size.
+ *
  *  * FPSR and FPCR are always stored in task->thread.uw.fpsimd_state
  *    irrespective of whether TIF_SVE is clear or set, since these are
  *    not vector length dependent.
@@ -404,12 +414,15 @@ static void task_fpsimd_load(void)
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
@@ -475,8 +488,10 @@ static void fpsimd_save(void)
 		sve_save_state((char *)last->sve_state +
 					sve_ffr_offset(vl),
 			       &last->st->fpsr, save_ffr);
+		*last->type = FP_STATE_SVE;
 	} else {
 		fpsimd_save_state(last->st);
+		*last->type = FP_STATE_FPSIMD;
 	}
 }
 
@@ -847,8 +862,10 @@ int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 
 	fpsimd_flush_task_state(task);
 	if (test_and_clear_tsk_thread_flag(task, TIF_SVE) ||
-	    thread_sm_enabled(&task->thread))
+	    thread_sm_enabled(&task->thread)) {
 		sve_to_fpsimd(task);
+		task->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	if (system_supports_sme() && type == ARM64_VEC_SME) {
 		task->thread.svcr &= ~(SVCR_SM_MASK |
@@ -1367,6 +1384,7 @@ static void sve_init_regs(void)
 		fpsimd_bind_task_to_cpu();
 	} else {
 		fpsimd_to_sve(current);
+		current->thread.fp_type = FP_STATE_SVE;
 	}
 }
 
@@ -1606,6 +1624,8 @@ void fpsimd_flush_thread(void)
 		current->thread.svcr = 0;
 	}
 
+	current->thread.fp_type = FP_STATE_FPSIMD;
+
 	put_cpu_fpsimd_context();
 	kfree(sve_state);
 	kfree(za_state);
@@ -1654,8 +1674,10 @@ void fpsimd_kvm_prepare(void)
 	 */
 	get_cpu_fpsimd_context();
 
-	if (test_and_clear_thread_flag(TIF_SVE))
+	if (test_and_clear_thread_flag(TIF_SVE)) {
 		sve_to_fpsimd(current);
+		current->thread.fp_type = FP_STATE_FPSIMD;
+	}
 
 	put_cpu_fpsimd_context();
 }
@@ -1677,6 +1699,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sve_vl = task_get_sve_vl(current);
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
+	last->type = &current->thread.fp_type;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1700,7 +1723,8 @@ static void fpsimd_bind_task_to_cpu(void)
 
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
-			      unsigned int sme_vl, u64 *svcr)
+			      unsigned int sme_vl, u64 *svcr,
+			      enum fp_state *type)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1714,6 +1738,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->za_state = za_state;
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
+	last->type = type;
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
index 21da83187a60..e0233f322af3 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -892,8 +892,7 @@ static int sve_set_common(struct task_struct *target,
 		ret = __fpr_set(target, regset, pos, count, kbuf, ubuf,
 				SVE_PT_FPSIMD_OFFSET);
 		clear_tsk_thread_flag(target, TIF_SVE);
-		if (type == ARM64_VEC_SME)
-			fpsimd_force_sync_to_sve(target);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -916,6 +915,7 @@ static int sve_set_common(struct task_struct *target,
 	if (!target->thread.sve_state) {
 		ret = -ENOMEM;
 		clear_tsk_thread_flag(target, TIF_SVE);
+		target->thread.fp_type = FP_STATE_FPSIMD;
 		goto out;
 	}
 
@@ -954,6 +954,8 @@ static int sve_set_common(struct task_struct *target,
 				 &target->thread.uw.fpsimd_state.fpsr,
 				 start, end);
 
+	target->thread.fp_type = FP_STATE_SVE;
+
 out:
 	fpsimd_flush_task_state(target);
 	return ret;
diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index b0980fbb6bc7..23dd4c3bcfed 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -207,6 +207,7 @@ static int restore_fpsimd_context(struct fpsimd_context __user *ctx)
 	__get_user_error(fpsimd.fpcr, &ctx->fpcr, err);
 
 	clear_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_FPSIMD;
 
 	/* load the hardware registers from the fpsimd_state structure */
 	if (!err)
@@ -289,6 +290,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 	if (sve.head.size <= sizeof(*user->sve)) {
 		clear_thread_flag(TIF_SVE);
 		current->thread.svcr &= ~SVCR_SM_MASK;
+		current->thread.fp_type = FP_STATE_FPSIMD;
 		goto fpsimd_only;
 	}
 
@@ -324,6 +326,7 @@ static int restore_sve_fpsimd_context(struct user_ctxs *user)
 		current->thread.svcr |= SVCR_SM_MASK;
 	else
 		set_thread_flag(TIF_SVE);
+	current->thread.fp_type = FP_STATE_SVE;
 
 fpsimd_only:
 	/* copy the FP and status/control registers */
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 64b37f4b862f..f8d5d0b49371 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -137,7 +137,8 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
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
