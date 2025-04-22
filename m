Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E440199E8D;
	Tue, 22 Apr 2025 06:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745304236; cv=none; b=jHYjIWPyWuu9oAiB9i7kFdc5eHdTFZDiav5VH78GkWoDfP3d7GO0qeCewR855keWgWYBL7BnqWGTssB+mDo7FgzlCliIRCh6xa17IfN2u4IVMXoG5sgw3Wxxlcq/4W+8xaGn98+qeOmBlq1gYWXgxfFi+zzlmwHJUlZZGiz+vA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745304236; c=relaxed/simple;
	bh=BnHbi03XVjNc1c/NWp8gBLOR1mzCcty4qVicdT15Nww=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=AvP0KLSDtRLMWhTn0biw5QEtv3etq2ODG4RPcJLRNWrBfIsB1Q/MSppRHANhFCc+jVfIPJyuHu216WfJi5YgH8FrSEAdAXzLKUBS7UqCWhuGbE5lNaH5QbPGgRjDk8G5Qn/46JetgObRjAIadl7mqtLYeXijyj2ZsRK5ZsyJ/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nP6KKO8a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nP6KKO8a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B50C5C4CEE9;
	Tue, 22 Apr 2025 06:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745304236;
	bh=BnHbi03XVjNc1c/NWp8gBLOR1mzCcty4qVicdT15Nww=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=nP6KKO8akCk92i4+vTOo9JtLjZITLP9Elohm1n9IoHpQuCFkUFgMP5Kcojy0Sdqhl
	 PvktGs0SypHwBuMdsNfzlMlHU7KiI8r9YK1wG2zbZs7l7PvN67xEJBtxtKigw2xfdv
	 Gijw/smImRqf0XSxsxzQE1bpowvUe161k6Or+vsk=
Subject: Patch "arm64/fpsimd: Have KVM explicitly say which FP registers to save" has been added to the 6.1-stable tree
To: broonie@kernel.org,catalin.marinas@arm.com,gregkh@linuxfoundation.org,james.morse@arm.com,kvmarm@lists.cs.columbia.edu,kvmarm@lists.linux.dev,linux-arm-kernel@lists.infradead.org,mark.rutland@arm.com,maz@kernel.org,oleg@redhat.com,oliver.upton@linux.dev,suzuki.poulose@arm.com,will@kernel.org
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Tue, 22 Apr 2025 08:43:53 +0200
In-Reply-To: <20250404-stable-sve-6-1-v1-3-cd5c9eb52d49@kernel.org>
Message-ID: <2025042253-lavender-purging-fdfd@gregkh>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    arm64/fpsimd: Have KVM explicitly say which FP registers to save

to the 6.1-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     arm64-fpsimd-have-kvm-explicitly-say-which-fp-registers-to-save.patch
and it can be found in the queue-6.1 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-128302-greg=kroah.com@vger.kernel.org Fri Apr  4 15:28:08 2025
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:36 +0100
Subject: arm64/fpsimd: Have KVM explicitly say which FP registers to save
To: Catalin Marinas <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,  James Morse <james.morse@arm.com>,  Suzuki K Poulose <suzuki.poulose@arm.com>,  Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,  kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,  Mark Brown <broonie@kernel.org>, stable@vger.kernel.org,  Mark Rutland <mark.rutland@arm.com>
Message-ID: <20250404-stable-sve-6-1-v1-3-cd5c9eb52d49@kernel.org>

From: Mark Brown <broonie@kernel.org>

[ Upstream commit deeb8f9a80fdae5a62525656d65c7070c28bd3a4 ]

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
binds to the CPU. We introduce a new FP_STATE_CURRENT for use
during normal task binding to indicate that we should base our
decisions on the current task. This should not be used when
actually saving. Ideally we might want to use a separate enum for
the type to save but this enum and the enum values would then
need to be named which has problems with clarity and ambiguity.

In order to ease any future debugging that might be required this patch
does not actually update any of the decision making about what to save,
it merely starts tracking the new information and warns if the requested
state is not what we would otherwise have decided to save.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221115094640.112848-4-broonie@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
[ Mark: trivial backport ]
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h    |    3 ++-
 arch/arm64/include/asm/processor.h |    1 +
 arch/arm64/kernel/fpsimd.c         |   27 ++++++++++++++++++++++++---
 arch/arm64/kvm/fpsimd.c            |    9 ++++++++-
 4 files changed, 35 insertions(+), 5 deletions(-)

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
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -123,6 +123,7 @@ enum vec_type {
 };
 
 enum fp_type {
+	FP_STATE_CURRENT,	/* Save based on current task state. */
 	FP_STATE_FPSIMD,
 	FP_STATE_SVE,
 };
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -126,6 +126,7 @@ struct fpsimd_last_state_struct {
 	unsigned int sve_vl;
 	unsigned int sme_vl;
 	enum fp_type *fp_type;
+	enum fp_type to_save;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -356,7 +357,8 @@ void task_set_vl_onexec(struct task_stru
  *    but userspace is discouraged from relying on this.
  *
  *    task->thread.sve_state does not need to be non-NULL, valid or any
- *    particular size: it must not be dereferenced.
+ *    particular size: it must not be dereferenced and any data stored
+ *    there should be considered stale and not referenced.
  *
  *  * SVE state - FP_STATE_SVE:
  *
@@ -369,7 +371,9 @@ void task_set_vl_onexec(struct task_stru
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
+	case FP_STATE_CURRENT:
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
 
@@ -1709,6 +1728,7 @@ static void fpsimd_bind_task_to_cpu(void
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
 	last->fp_type = &current->thread.fp_type;
+	last->to_save = FP_STATE_CURRENT;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1733,7 +1753,7 @@ static void fpsimd_bind_task_to_cpu(void
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
 			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_type *type)
+			      enum fp_type *type, enum fp_type to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1748,6 +1768,7 @@ void fpsimd_bind_state_to_cpu(struct use
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
 	last->fp_type = type;
+	last->to_save = to_save;
 }
 
 /*
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -130,9 +130,16 @@ void kvm_arch_vcpu_ctxflush_fp(struct kv
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
@@ -141,7 +148,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl,
 					 NULL, 0, &vcpu->arch.svcr,
-					 &vcpu->arch.fp_type);
+					 &vcpu->arch.fp_type, fp_type);
 
 		clear_thread_flag(TIF_FOREIGN_FPSTATE);
 		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));


Patches currently in stable-queue which might be from broonie@kernel.org are

queue-6.1/kvm-arm64-remove-host-fpsimd-saving-for-non-protected-kvm.patch
queue-6.1/spi-cadence-qspi-fix-probe-on-am62a-lp-sk.patch
queue-6.1/asoc-qdsp6-q6asm-dai-fix-q6asm_dai_compr_set_params-error-path.patch
queue-6.1/asoc-qdsp6-q6apm-dai-fix-capture-pipeline-overruns.patch
queue-6.1/kvm-arm64-mark-some-header-functions-as-inline.patch
queue-6.1/kvm-arm64-eagerly-switch-zcr_el-1-2.patch
queue-6.1/kvm-arm64-unconditionally-save-flush-host-fpsimd-sve-sme-state.patch
queue-6.1/asoc-amd-add-dmi-quirk-for-acp6x-mic-support.patch
queue-6.1/kvm-arm64-refactor-exit-handlers.patch
queue-6.1/asoc-qdsp6-q6apm-dai-set-10-ms-period-and-buffer-alignment.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-vi-feedback-rate.patch
queue-6.1/arm64-fpsimd-track-the-saved-fpsimd-state-type-separately-to-tif_sve.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.zen.patch
queue-6.1/kvm-arm64-remove-vhe-host-restore-of-cpacr_el1.smen.patch
queue-6.1/asoc-fsl_audmix-register-card-device-depends-on-dais.patch
queue-6.1/arm64-fpsimd-have-kvm-explicitly-say-which-fp-registers-to-save.patch
queue-6.1/kvm-arm64-discard-any-sve-state-when-entering-kvm-guests.patch
queue-6.1/arm64-fpsimd-stop-using-tif_sve-to-manage-register-saving-in-kvm.patch
queue-6.1/asoc-codecs-lpass-wsa-macro-fix-logic-of-enabling-vi-channels.patch
queue-6.1/kvm-arm64-calculate-cptr_el2-traps-on-activating-traps.patch
