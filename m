Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FB33AA1B8
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 06:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781247578; cv=none; b=BYylXTwHBN9LXZM4H+b/ra2/Y4gmQ9HkAXTfzT7Mqr8S2ctlSDIUYB8Ji0Z7jQXVkVyAXsBuCsq/kLr6CBCKY3kIBLGZ6JmroUe3HBuwduFT6ZfXrivAiGJep8zNi3dRQdwmXLX39IoseeWzYxMhC8tknl7MovR9/QMOx83LFig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781247578; c=relaxed/simple;
	bh=eFwkdQvsnnkAAU5tIHtV0qy18EI7g0zv1kyLHmxBKvg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Msv4y/ACxG5RdnFbVuUqPYpJZtg25NFzuRFIKs4Qao3PI6V4sXw8C8Sn/Qs4HVoRjUz8yp1vFRvzr/3gwIpokyfJzjxnbXLbTAF6+bpzjQvB10zFSP0U04q7wAdmRy5lY5N6xnG+AfElAodi0UxXJjkokigHxCOghWiT8dCTrlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mpQgkCtX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mpQgkCtX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-46067b07571so349142f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 11 Jun 2026 23:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781247573; x=1781852373; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qXGuzfNsHuVFTTiBdUfpVNe6SVwR2WJsAlgBZBabf/Q=;
        b=mpQgkCtX9YVyXrMN1X7LDgaohFovhtbf8Ki9RMXTLJgmQu+2sGMtdtZ/ewjeMCkvbK
         5I9Y9p6VgT17/N4gHD0w4GBFRgseqSZ5jGbO2cA9e+4NdqG+phIyCo4KG6qSXzc3muBh
         GCuyyajZigLfnTVZVogePVKrLiJloEvgCkHetog3FRd6lrsloaIDZ4fuwad4UCWTuVJN
         HNEAx7Tr0Tve4Zwy8L50FR2wu62GJKuDg/P+/EY1eQPysnCA1SwIQ5qWCDQ/zVcogksG
         tolUdnNt16kVtZkh51UoBvvUA+VlJGAL2obnJ4IFK7xli/23aR7NQNtCnRkIHbw31zLj
         ++Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781247573; x=1781852373;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qXGuzfNsHuVFTTiBdUfpVNe6SVwR2WJsAlgBZBabf/Q=;
        b=WJciiwlSk4iTmvo/IVADvvTu+DR7cwx6Cw9+K3+aNlfkePDJ8QJp0gaioLExBjJ91C
         HqUYDfTT4VZaPwwpRWXU8r2CIS8q+9+kwYf5UIjzaMB1RWw97KsG2XVOZ3s4NzJB1Fe4
         GVTJkO/6OUDMZdils4MjCKmXKJ0Wp2VkmPXUzv6tVlaknkxy9SOdk8/n51McjqOFryZy
         Mye/AZ5etYqNYNEMCyP0CVNZ+sqwSOnqV7fMkpMnmcMfjIlw0a9xWHiddkr6ErX7fl66
         2ASnOwg7iehEENKHrQThFPnrCrJt/C1T4UIJ0OFIuESzeoRDaGgfV2BjrHwVxYDUEOAK
         YjdQ==
X-Forwarded-Encrypted: i=1; AFNElJ/iTR4xew7WQTdq4HwxADbZnsSX5mMQ4WEmsSr4RaB+kDLkKXxY3An9OdCRfEjo7qsELWvWASA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCjij5FJek7cVfEafW1jVKKbMbox+23vsOBErtpDu5ym6m7lRC
	1XNH7ZONoYykZXkiyQ/NXZOuoidhfsW4tx7EPkzKRC3lVHBqox0h3BNxW7wHyv7VyKyDX2MrzO/
	jJQ==
X-Received: from wrmd12.prod.google.com ([2002:adf:e88c:0:b0:460:2d58:8588])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:4709:b0:460:602f:85ac
 with SMTP id ffacd0b85a97d-4606cae532fmr1906945f8f.0.1781247572720; Thu, 11
 Jun 2026 23:59:32 -0700 (PDT)
Date: Fri, 12 Jun 2026 07:59:20 +0100
In-Reply-To: <20260612065925.755562-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612065925.755562-1-tabba@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612065925.755562-7-tabba@google.com>
Subject: [PATCH v1 06/11] KVM: arm64: Factor out reusable vCPU reset helpers
From: tabba@google.com
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <tabba@google.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Quentin Perret <qperret@google.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Sebastian Ene <sebastianene@google.com>, 
	Per Larsen <perlarsen@google.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Joey Gouly <joey.gouly@arm.com>, 
	Steffen Eiden <seiden@linux.ibm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Jonathan Cameron <jonathan.cameron@huawei.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
PSTATE values in kvm_arm.h, and split the core register reset and the
PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
A follow-up series reuses these to reset protected vCPUs at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 12 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 58 +++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c               | 60 ++--------------------------
 3 files changed, 73 insertions(+), 57 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 3f9233b5a130..aba4ec09acd2 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -348,4 +348,16 @@
 	{ PSR_AA32_MODE_UND,	"32-bit UND" },	\
 	{ PSR_AA32_MODE_SYS,	"32-bit SYS" }
 
+/*
+ * ARMv8 Reset Values
+ */
+#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
+#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
+				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
+
 #endif /* __ARM64_KVM_ARM_H__ */
diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index aed9fc0b717b..8436e71c402d 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -704,4 +704,62 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 	}
 }
+
+/* Reset a vcpu's core registers. */
+static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
+{
+	u32 pstate;
+
+	if (vcpu_el1_is_32bit(vcpu)) {
+		pstate = VCPU_RESET_PSTATE_SVC;
+	} else if (vcpu_has_nv(vcpu)) {
+		pstate = VCPU_RESET_PSTATE_EL2;
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
+
+	/*
+	 * We may come from a state where either a PC update was
+	 * pending (SMC call resulting in PC being increpented to
+	 * skip the SMC) or a pending exception. Make sure we get
+	 * rid of all that, as this cannot be valid out of reset.
+	 *
+	 * Note that clearing the exception mask also clears PC
+	 * updates, but that's an implementation detail, and we
+	 * really want to make it explicit.
+	 */
+	vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
+	vcpu_clear_flag(vcpu, EXCEPT_MASK);
+	vcpu_clear_flag(vcpu, INCREMENT_PC);
+	vcpu_set_reg(vcpu, 0, reset_state->r0);
+}
+
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 60969d90bdd3..e22d0be9e57c 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -34,18 +34,6 @@
 static u32 __ro_after_init kvm_ipa_limit;
 unsigned int __ro_after_init kvm_host_sve_max_vl;
 
-/*
- * ARMv8 Reset Values
- */
-#define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
-				 PSR_F_BIT | PSR_D_BIT)
-
-#define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
-				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
-
 unsigned int __ro_after_init kvm_sve_max_vl;
 
 int __init kvm_arm_init_sve(void)
@@ -191,7 +179,6 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_reset_state reset_state;
 	bool loaded;
-	u32 pstate;
 
 	scoped_guard(spinlock, &vcpu->arch.mp_state_lock) {
 		reset_state = vcpu->arch.reset_state;
@@ -210,21 +197,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 		kvm_vcpu_reset_sve(vcpu);
 	}
 
-	if (vcpu_el1_is_32bit(vcpu))
-		pstate = VCPU_RESET_PSTATE_SVC;
-	else if (vcpu_has_nv(vcpu))
-		pstate = VCPU_RESET_PSTATE_EL2;
-	else
-		pstate = VCPU_RESET_PSTATE_EL1;
-
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
@@ -233,36 +207,8 @@ void kvm_reset_vcpu(struct kvm_vcpu *vcpu)
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
-
-		/*
-		 * We may come from a state where either a PC update was
-		 * pending (SMC call resulting in PC being increpented to
-		 * skip the SMC) or a pending exception. Make sure we get
-		 * rid of all that, as this cannot be valid out of reset.
-		 *
-		 * Note that clearing the exception mask also clears PC
-		 * updates, but that's an implementation detail, and we
-		 * really want to make it explicit.
-		 */
-		vcpu_clear_flag(vcpu, PENDING_EXCEPTION);
-		vcpu_clear_flag(vcpu, EXCEPT_MASK);
-		vcpu_clear_flag(vcpu, INCREMENT_PC);
-		vcpu_set_reg(vcpu, 0, reset_state.r0);
-	}
+	if (reset_state.reset)
+		kvm_reset_vcpu_psci(vcpu, &reset_state);
 
 	/* Reset timer */
 	kvm_timer_vcpu_reset(vcpu);
-- 
2.54.0.1136.gdb2ca164c4-goog

