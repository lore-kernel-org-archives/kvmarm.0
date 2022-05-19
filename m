Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282AFC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:33 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D30C04B465;
	Thu, 19 May 2022 09:47:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lcehhCTHXc0U; Thu, 19 May 2022 09:47:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F9544B49A;
	Thu, 19 May 2022 09:47:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2BB3C4B434
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mUDXfnWIf7Mv for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:29 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C89CB4B498
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:28 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DE3C0B824DA;
 Thu, 19 May 2022 13:47:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32815C34119;
 Thu, 19 May 2022 13:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968046;
 bh=sbfGSCQlcdHr0AlNILq/FUQuZCUkIjPNbUYGIv+SreI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=S4PtIS2/n2txKk9VfZXhyhkRcZz/zUXjKAdMDN52IZB/o8BcLi/awKd4YB4FiDQ43
 N3w2Er4fYT4XMfGPGDsuubvTUYYCHStQ0JqjYo5oT0eyx32HEIje1+5aFAvKFCoip/
 ysf+6GXXvjBXygNxYdaf9HVAwdUmGJTR4C3SlHi8LKU8ihQMfuIJ4uVLa7SKt3tfUz
 42Q1TfImobSrMi1VAnOW25q8aEooXZ0j7S7Qm29O8US3xhRmwIb4RJGM49UYZZZ4A0
 GIy9U8KQMgBelbsYEQAHqqnjyBxJoC8OtqD7aGA1FlW+mwXdxcDjOP1MtAlYxarglN
 Q7DjDjNKaorPg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 76/89] KVM: arm64: Factor out vcpu_reset code for core
 registers and PSCI
Date: Thu, 19 May 2022 14:41:51 +0100
Message-Id: <20220519134204.5379-77-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Factor out logic that resets a vcpu's core registers, including
additional PSCI handling. This code will be reused when resetting
VMs in protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 41 +++++++++++++++++++++++++
 arch/arm64/kvm/reset.c               | 45 +++++-----------------------
 2 files changed, 48 insertions(+), 38 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 82515b015eb4..2a79c861b8e0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -522,4 +522,45 @@ static inline unsigned long psci_affinity_mask(unsigned long affinity_level)
 	return 0;
 }
 
+/* Reset a vcpu's core registers. */
+static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
+{
+	u32 pstate;
+
+	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
+		pstate = VCPU_RESET_PSTATE_SVC;
+	} else {
+		pstate = VCPU_RESET_PSTATE_EL1;
+	}
+
+	/* Reset core registers */
+	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
+	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
+	vcpu->arch.ctxt.spsr_abt = 0;
+	vcpu->arch.ctxt.spsr_und = 0;
+	vcpu->arch.ctxt.spsr_irq = 0;
+	vcpu->arch.ctxt.spsr_fiq = 0;
+	vcpu_gp_regs(vcpu)->pstate = pstate;
+}
+
+/* PSCI reset handling for a vcpu. */
+static inline void kvm_reset_vcpu_psci(struct kvm_vcpu *vcpu,
+				       struct vcpu_reset_state *reset_state)
+{
+	unsigned long target_pc = reset_state->pc;
+
+	/* Gracefully handle Thumb2 entry point */
+	if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
+		target_pc &= ~1UL;
+		vcpu_set_thumb(vcpu);
+	}
+
+	/* Propagate caller endianness */
+	if (reset_state->be)
+		kvm_vcpu_set_be(vcpu);
+
+	*vcpu_pc(vcpu) = target_pc;
+	vcpu_set_reg(vcpu, 0, reset_state->r0);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 6bc979aece3c..4d223fae996d 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -109,7 +109,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		kfree(buf);
 		return ret;
 	}
-	
+
 	vcpu->arch.sve_state = buf;
 	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
 	return 0;
@@ -202,7 +202,6 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	struct vcpu_reset_state reset_state;
 	int ret;
 	bool loaded;
-	u32 pstate;
 
 	mutex_lock(&vcpu->kvm->lock);
 	reset_state = vcpu->arch.reset_state;
@@ -240,29 +239,13 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	switch (vcpu->arch.target) {
-	default:
-		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
-			pstate = VCPU_RESET_PSTATE_SVC;
-		} else {
-			pstate = VCPU_RESET_PSTATE_EL1;
-		}
-
-		if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
-			ret = -EINVAL;
-			goto out;
-		}
-		break;
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm_arm_support_pmu_v3()) {
+		ret = -EINVAL;
+		goto out;
 	}
 
 	/* Reset core registers */
-	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
-	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
-	vcpu->arch.ctxt.spsr_abt = 0;
-	vcpu->arch.ctxt.spsr_und = 0;
-	vcpu->arch.ctxt.spsr_irq = 0;
-	vcpu->arch.ctxt.spsr_fiq = 0;
-	vcpu_gp_regs(vcpu)->pstate = pstate;
+	kvm_reset_vcpu_core(vcpu);
 
 	/* Reset system registers */
 	kvm_reset_sys_regs(vcpu);
@@ -271,22 +254,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	 * Additional reset state handling that PSCI may have imposed on us.
 	 * Must be done after all the sys_reg reset.
 	 */
-	if (reset_state.reset) {
-		unsigned long target_pc = reset_state.pc;
-
-		/* Gracefully handle Thumb2 entry point */
-		if (vcpu_mode_is_32bit(vcpu) && (target_pc & 1)) {
-			target_pc &= ~1UL;
-			vcpu_set_thumb(vcpu);
-		}
-
-		/* Propagate caller endianness */
-		if (reset_state.be)
-			kvm_vcpu_set_be(vcpu);
-
-		*vcpu_pc(vcpu) = target_pc;
-		vcpu_set_reg(vcpu, 0, reset_state.r0);
-	}
+	if (reset_state.reset)
+		kvm_reset_vcpu_psci(vcpu, &reset_state);
 
 	/* Reset timer */
 	ret = kvm_timer_vcpu_reset(vcpu);
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
