Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1BA8C43334
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 898E74B3A2;
	Mon, 20 Jun 2022 08:42:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H2p6cBfqut1s; Mon, 20 Jun 2022 08:42:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AEEA4B4E6;
	Mon, 20 Jun 2022 08:42:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26FFE4B2E2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I3tRX6hvScM0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:24 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BD0004B2B4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:24 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 445A7614B6;
 Mon, 20 Jun 2022 12:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825D9C341C4;
 Mon, 20 Jun 2022 12:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728943;
 bh=dN8kuRsgxXxjgQi1RYr3FyQpPMXEjlPJM6DD23PyclY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=R42wyt+z4I0Ca1A7f6G1zwkdQE9PUkMwrHZBhefWETvkwZeAEvXMsQFEu7g0/Btq+
 aXplUoAotejBeSOoXJgRg05OilABEQE9UHbtQH/ASnZJkjsko7CKM4iWMhtE6KRlTp
 NYpVbPoiC8dwxmso/U2eYeBi0ihBeHnugQTKMkWuYzQno1oCEKXZo5s4xzy2uqCASC
 ecu6KNFRGGha1eSy9EDowQG/l+hfLEFn9Sq+YCDHfK0IcbuJqSvDwf/wCtH6VxNnzm
 L0LPjpkzEJa92YKXEJzygQw51QdYgIaFuEFMo0bJ52AnBvPZTJzUoK1iqOxtkKOqgR
 hd2y+6ltgkPRA==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 3/7] arm64/fpsimd: Have KVM explicitly say which FP
 registers to save
Date: Mon, 20 Jun 2022 13:41:54 +0100
Message-Id: <20220620124158.482039-4-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220620124158.482039-1-broonie@kernel.org>
References: <20220620124158.482039-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5333; h=from:subject;
 bh=dN8kuRsgxXxjgQi1RYr3FyQpPMXEjlPJM6DD23PyclY=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsQHol+dN8bpsZPk0aPTJmr8291FXLOrM2grb+Y
 p7szEmiJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrEAAKCRAk1otyXVSH0DxLB/
 wLy7gzfvdSrWBZBtyxFT01A78KrzqHsPpHXhVajD3IzMzsy4smVeuTjhmk640H575KG3dZcoEb7wAG
 RYnp47d71coRGk2EIFl3rX9cy/utxfJQheS1gZni21BePvYmSwBubRlieJMqccSEOSATEIDgq7jaKY
 tWAbom5o4ByespAdrzXaePE4qzY7LpTK07X4CSLMppP+E5JVCfT/oag/TlI8D0AEu8Q2Foa/wcBfes
 4X5mRAVwpmPc6vzsXKgF9k6hfWtd2bv9pArzpbwFQJA90TLV7gy2cC9NgyAKjpY9HIj8h/aWvDWhAf
 yhLe1wBB+L3Z/f4M00U7FkEmINT/QM
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
index 5762419fdcc0..e008965719a4 100644
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
index 192986509a8e..7d9f0c95b352 100644
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
index fdb2925becdf..95c95411bd42 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -126,6 +126,7 @@ struct fpsimd_last_state_struct {
 	unsigned int sve_vl;
 	unsigned int sme_vl;
 	enum fp_state *type;
+	enum fp_state to_save;
 };
 
 static DEFINE_PER_CPU(struct fpsimd_last_state_struct, fpsimd_last_state);
@@ -458,6 +459,21 @@ static void fpsimd_save(void)
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
 		*svcr = read_sysreg_s(SYS_SVCR);
@@ -1702,6 +1718,7 @@ static void fpsimd_bind_task_to_cpu(void)
 	last->sme_vl = task_get_sme_vl(current);
 	last->svcr = &current->thread.svcr;
 	last->type = &current->thread.fp_type;
+	last->to_save = FP_STATE_TASK;
 	current->thread.fpsimd_cpu = smp_processor_id();
 
 	/*
@@ -1726,7 +1743,7 @@ static void fpsimd_bind_task_to_cpu(void)
 void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 			      unsigned int sve_vl, void *za_state,
 			      unsigned int sme_vl, u64 *svcr,
-			      enum fp_state *type)
+			      enum fp_state *type, enum fp_state to_save)
 {
 	struct fpsimd_last_state_struct *last =
 		this_cpu_ptr(&fpsimd_last_state);
@@ -1741,6 +1758,7 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->sve_vl = sve_vl;
 	last->sme_vl = sme_vl;
 	last->type = type;
+	last->to_save = to_save;
 }
 
 /*
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index be3ddb214ab1..542c71b16451 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -129,9 +129,16 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
+	enum fp_state fp_type;
+
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+		if (vcpu_has_sve(vcpu))
+			fp_type = FP_STATE_SVE;
+		else
+			fp_type = FP_STATE_FPSIMD;
+
 		/*
 		 * Currently we do not support SME guests so SVCR is
 		 * always 0 and we just need a variable to point to.
@@ -140,7 +147,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
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
