Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF2F1EEA42;
	Fri,  4 Apr 2025 13:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743773257; cv=none; b=TWCfLVv3hJ/Rpf9u6a2NtVHXsPJfGGHDoSL5TVzE4mjf8c2+6d8cV55jsw0h5kY6V4UYvdWgV6zlQn4JrUwABY2jcj783f7QTt35HGXSyWOy8B8fTYMwVb05ydn7RlZkzPjqAuNBoF0NlSy9f5P5B/bPhQusSmVVLKpn4yeI+bA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743773257; c=relaxed/simple;
	bh=MxdQ/1REGXVrn8Hm4GG+x/CyGbgEaQyqQoaMs6/KE9c=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y8rxObksbe5p06tFia6ua330jehpNXVfbDiIKJtTkC3ADaq+YdPTiof7Wf+5FLAY4zFkSISHnVf+12t4wkGFY30EYCoP1/oG/DAYqyu7kkqFDsVtgOk/R0NTAEKPAzwo6LXGudDjDdlOsi6DDKEUcQhWpJFvoeBYalRlZs3yZ/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5o/mNEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5o/mNEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C364C4CEE9;
	Fri,  4 Apr 2025 13:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743773256;
	bh=MxdQ/1REGXVrn8Hm4GG+x/CyGbgEaQyqQoaMs6/KE9c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=O5o/mNEUJmKDwXQNo9ATkpBJWrYk+dX6dA6J+VhblM0a36b9lV+KzXghp0agB14fd
	 Yo5To/8JV/B5BVgIMTUEEoVsKAPpHbaCt7OMxd85weCmiQCv7WGjrkfrC59yDa+4Xk
	 his5eHVsDEYB1CU9XE0pYZm2W9OAhZCPre357qdaarbcgtm2+4zmJMqTAFi+SLeWTi
	 r02BPfqlajnEp8Zb+FcTqfbPKS/5GkP6LDpkl6uwPBLVcFL8jQrI9uYQ5Yn5JRyBaO
	 5FRqFyFsM6Y85duj56HOLJ7n6yssFMOfBGJtxLN1oMzS2hb6zhln+KOIya+r16Dw5Q
	 N6M5VSOKMtjqw==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Apr 2025 14:23:36 +0100
Subject: [PATCH RESEND 6.1 03/12] arm64/fpsimd: Have KVM explicitly say
 which FP registers to save
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250404-stable-sve-6-1-v1-3-cd5c9eb52d49@kernel.org>
References: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
In-Reply-To: <20250404-stable-sve-6-1-v1-0-cd5c9eb52d49@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Oleg Nesterov <oleg@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu, 
 Mark Brown <broonie@kernel.org>, stable@vger.kernel.org, 
 Mark Rutland <mark.rutland@arm.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=6976; i=broonie@kernel.org;
 h=from:subject:message-id; bh=MxdQ/1REGXVrn8Hm4GG+x/CyGbgEaQyqQoaMs6/KE9c=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBn794vvB/sgz4CRzF58t9/+w2OKK11+EoGnH5+t691
 wQ3JP5iJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCZ+/eLwAKCRAk1otyXVSH0LdJB/
 45MIQc4g8UdqFdqQZ+Ofhb+pRTrRNGZe1bf1wba0WalzUQKvO/leYYyGmdx6jrTmlkH+WTDLBF8N2X
 aPbbTHUzi1RU7A62qY8KOe4fbC5C0Ao6hpOxAjrTWTIwQUoudsSysGlOCe1eeoIq1cX5muxv0Cg9eX
 AW6JKv2w3uSL/GNGQyL21HOst0nJY3+ut/5mFsM8CaL/Cs1jbAYUmxrP2Lt05CYIQbDDtX32jePbfo
 XoRwKnjdfPE/AwdI++PXweMSLKaiQyyqMx0eAEnoWIPl+6r2pOPfwoq3oXR2NNBuWTWEdGH4ObZpmB
 LfEEow7a43XbbzaOrr7YrV52YNVduh
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

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
---
 arch/arm64/include/asm/fpsimd.h    |  3 ++-
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/fpsimd.c         | 27 ++++++++++++++++++++++++---
 arch/arm64/kvm/fpsimd.c            |  9 ++++++++-
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index e10894100c73..7622782d0bb9 100644
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
index 208434a2e924..1b822e618bb4 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -123,6 +123,7 @@ enum vec_type {
 };
 
 enum fp_type {
+	FP_STATE_CURRENT,	/* Save based on current task state. */
 	FP_STATE_FPSIMD,
 	FP_STATE_SVE,
 };
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 2e0cecf02bf8..1f6fd9229e53 100644
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
 
@@ -1709,6 +1728,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
 	last->fp_type = &current->thread.fp_type;
+	last->to_save = FP_STATE_CURRENT;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1733,7 +1753,7 @@ static void fpsimd_bind_task_to_cpu(void)
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
 			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_type *type)
+			      enum fp_type *type, enum fp_type to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1748,6 +1768,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
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
2.39.5

