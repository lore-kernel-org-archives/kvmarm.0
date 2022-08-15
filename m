Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21797C00140
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AABAE4D8B8;
	Mon, 15 Aug 2022 18:58:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C1enRtCLxam0; Mon, 15 Aug 2022 18:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 708914D897;
	Mon, 15 Aug 2022 18:58:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1588E4D885
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xzzerNjISisn for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:14 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A70D64D897
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 1BF4C612C8;
 Mon, 15 Aug 2022 22:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58E91C433C1;
 Mon, 15 Aug 2022 22:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604293;
 bh=BYv1xdAdFry2V6Yy7i/5yJN/xwGkJAUP7khIRPg/K5E=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=M7DFFhpkBqhEwrmxQqvG2Yp5M33C1QkKf9tWGVPYOi6WYXGVGQS35AuCXQ3vzXVcz
 Ec+7UYKL3B3HA966oGaxsiRUFDoB2mgW9J5RzZx1F3fJTsr8KoiFfghmfmZm2R8QDF
 baMsFsmgQfTGcwHBv4bF/gH/uthIDYoA6YOeZOAcFwF7HwtCfj93/yVhaGAEaVGCFV
 f/Vnq5qTg0atkAFF5sPC2JGdAhBWSqCZ22psmNCINvNrP2kWhWCQWwpbH5Qf4eV8m0
 zGEI31e2TOCGHpBMt2Hsbq1MSAVgOaSBE8NXVEpExeSmXCIvXMoTM0zty5kARHMZ7P
 k6Hyl5MGRV9jg==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 3/7] arm64/fpsimd: Have KVM explicitly say which FP
 registers to save
Date: Mon, 15 Aug 2022 23:55:25 +0100
Message-Id: <20220815225529.930315-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220815225529.930315-1-broonie@kernel.org>
References: <20220815225529.930315-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5312; i=broonie@kernel.org;
 h=from:subject; bh=BYv1xdAdFry2V6Yy7i/5yJN/xwGkJAUP7khIRPg/K5E=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7cZxz+ohGe59/pDM6ezKzZEBh77fby2LVHQxbm
 Mkp37d6JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO3AAKCRAk1otyXVSH0C/iB/
 9qgKJIqlVfddVeL7VLNVAWVLLnD+3yP2qE67aYY42rOsj2lhoFWztVmy47jfQaNhoPA8fm6PF6CRqd
 hQdNKmlBL2McC3dUPHcm4+bSxbYm1kj3Eqk64F2nkzA2zwGoF8JLbKgVA1agwmdnz/dTKK+k6bhbDk
 xYmGBOBOTX+paQMVT/jc3/2eFqL70b0Qt5hus/BOzauGQODK7TELYdaw+TLbaB84PRUR3i/rSLq6vQ
 w6KRa1QY7xOuwAkEhJTJcKIXBi3ozqmk/fpAS9kXY/NViykKwPz8BJ2xTGlapLwS2M6tcdselFZyQt
 uRFmGOvvlgLFlw4nmmB+IZBDzpCOZZ
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
binds to the CPU. We introduce a new FP_TYPE_TASK for use during normal
task binding to indicate that we should base our decisions on the current
task. In order to ease any future debugging that might be required this
patch does not actually update any of the decision making about what to
save, it merely starts tracking the new information and warns if the
requested state is not what we would otherwise have decided to save.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/fpsimd.h    |  3 ++-
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/kernel/fpsimd.c         | 20 +++++++++++++++++++-
 arch/arm64/kvm/fpsimd.c            |  9 ++++++++-
 4 files changed, 30 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index b74103a79052..21a1dd320ca5 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -61,7 +61,8 @@ extern void fpsimd_kvm_prepare(void);
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl,
 				     void *za_state, unsigned int sme_vl,
-				     u64 *svcr, enum fp_state *type);
+				     u64 *svcr, enum fp_state *type,
+				     enum fp_state to_save);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 4818a6b77f39..89c248b8d4ba 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -123,6 +123,7 @@ enum vec_type {
 };
 
 enum fp_state {
+	FP_STATE_TASK,		/* Save based on current, invalid as fp_type */
 	FP_STATE_FPSIMD,
 	FP_STATE_SVE,
 };
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 6544ae00230f..7be20ced2c45 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -126,6 +126,7 @@ struct fpsimd_last_state_struct {
 	unsigned int sve_vl;
 	unsigned int sme_vl;
 	enum fp_state *fp_type;
+	enum fp_state to_save;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -459,6 +460,21 @@ static void fpsimd_save(void)
 		vl = last->sve_vl;
 	}
 
+	/*
+	 * For now we're just validating that the requested state is
+	 * consistent with what we'd otherwise work out.
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
 
@@ -1693,6 +1709,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
 	last->fp_type = &current->thread.fp_type;
+	last->to_save = FP_STATE_TASK;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1717,7 +1734,7 @@ static void fpsimd_bind_task_to_cpu(void)
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
 			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_state *type)
+			      enum fp_state *type, enum fp_state to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1732,6 +1749,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
 	last->fp_type = type;
+	last->to_save = to_save;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index a92977759f8d..db0b2bacaeb8 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -130,9 +130,16 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
+	enum fp_state fp_type;
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

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
