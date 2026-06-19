Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3487134DB7B
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852716; cv=none; b=k96d4bjCTc7scE3CRk36yWSiEO3B8sTvsMJUwsxSztBXVSh+b/jF15xLCoh99zCAAA9jrljHAhAbnEVlDZxXpgd3fO6ejqbI0hy2GUB1Gv0vHXcuf7eWwY3l2RrUC8F+vvyjuxdItq/We1ZiUzjlFr1PQSlNqJDwXjdfKE4H590=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852716; c=relaxed/simple;
	bh=RMpU/b9vwNa0lym1MipW92ORxJiykVXfsm8dCsXUSZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CZ9AXz3JWBaEo3GwHFdFNVmsuPYk6j+gKXpv+5XR60LFYhpHXNIN0xFWzDO3UrPd89+4ALcTjKm/m5u/yyecf3Bxw+vDmOEbW529OJBouDegcfeBvgfcOFyzbz9j4c7lqrDSH/CHHCfHawHgH/ydUmLNGtuMS5QX2dTGoFNnlRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HZrmU2ud; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HZrmU2ud"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-695f6030f2eso2087646a12.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852714; x=1782457514; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bo+Do6fvILC4QlQ6OlZKSYXEigkmbClK8Dx3jUj91Os=;
        b=HZrmU2udx6OcRHngMtU+XB8uDOyqMApy/X1QBJLEOxeZMO7UM2PnXYFHYNp1vqCzXe
         N0wEqZUhNILjAQmBSpQ1rVCv1F9jncw+djBxf2OQva1x4qeVkXEqBCn+Uq8+VpSY2wxU
         sfqIdPfsGAbqUIyk+Q76HiuYpM7uBgTlUKjxgdD9evX5CJSNN3HjH2X8NKU4qmwPQbbm
         mbvz9qftq/GPIbArYbWcRUI7x49p+GzM9FN3mXTsD8Tr8/7Cn55e5rJNJD8q0UOlfakB
         DEIuaNbzImyjJBr15VsSp8R1eFBXHEf3zugqIltays57bfhTULEpcoe7kJRpuWGCKLmX
         ZfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852714; x=1782457514;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bo+Do6fvILC4QlQ6OlZKSYXEigkmbClK8Dx3jUj91Os=;
        b=tC5V2FvLfmpLM4ocpSAhXERjd5bx08LgGdC/fIlgELb1bXUoPVwfjMithQi5u8er/d
         iF3P/KfUJhkoOPgeJg0z7Ly2wabZldzQmATcVaYCSiDpm6dY51jjmCN55N4NuNt2Rx/M
         7Hbrv2PBMD4nQlM/RkbTgqxumNjuk6AfYEUhsf9ehsJSpn2kERHsMpoYL+jwhmBJcuFD
         xZyjxvzbK+mO+9qn+l6lqkHk21FSSL8QgK9xNeQlIWhZQ+11wIa6wRj+f9WHUKO48r+d
         UQH5HXkL+35L4T3yHVmIkQHkfIMtfb6nlkq05xFi5j0ZDqfDKJ0bE6Yj2V9VMex5bZkd
         YYNA==
X-Forwarded-Encrypted: i=1; AFNElJ8kDZSR7odQbY97dVf/8BhbESy9rRrU3pvQlCKRy/NbVEhlf60uZh+VUiGmBl5LPS7QgOOZDw8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIepRz2aos7fyPYDihtroRmTlVByQV8v56ESModGxldVXakIUL
	J3rVs0sLXtj9n5crJzW5h8MStdXeOJnPDjIiilvGA3oTdgazmP0RjknCbCsrr0tVXyu5GOcp7cv
	ceA==
X-Received: from edea19.prod.google.com ([2002:a05:6402:a193:b0:695:e013:bc1b])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:528a:b0:691:956a:cf6a
 with SMTP id 4fb4d7f45d1cf-696ee621b4emr1079285a12.12.1781852713421; Fri, 19
 Jun 2026 00:05:13 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:05:03 +0100
In-Reply-To: <20260619070508.802802-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070508.802802-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070508.802802-4-tabba@google.com>
Subject: [PATCH 3/8] KVM: arm64: Factor out reusable vCPU reset helpers
From: Fuad Tabba <tabba@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Vincent Donnefort <vdonnefort@google.com>, Quentin Perret <qperret@google.com>, 
	Sebastian Ene <sebastianene@google.com>, Hyunwoo Kim <imv4bel@gmail.com>, 
	Fuad Tabba <tabba@google.com>
Content-Type: text/plain; charset="UTF-8"

Pull the reusable pieces out of kvm_reset_vcpu(): expose the reset
PSTATE values in kvm_arm.h, and split the core register reset and the
PSCI-driven reset into kvm_reset_vcpu_core() and kvm_reset_vcpu_psci().
A follow-up series reuses these to reset protected vCPUs at EL2.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_arm.h     | 12 ++++++
 arch/arm64/include/asm/kvm_emulate.h | 57 ++++++++++++++++++++++++++
 arch/arm64/kvm/reset.c               | 60 ++--------------------------
 3 files changed, 72 insertions(+), 57 deletions(-)

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
index 80b30fead3d1..2385d8855fcf 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -704,4 +704,61 @@ static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
 			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnASR;
 	}
 }
+
+/* Reset a vcpu's core registers. */
+static inline void kvm_reset_vcpu_core(struct kvm_vcpu *vcpu)
+{
+	u32 pstate;
+
+	if (vcpu_el1_is_32bit(vcpu))
+		pstate = VCPU_RESET_PSTATE_SVC;
+	else if (vcpu_has_nv(vcpu))
+		pstate = VCPU_RESET_PSTATE_EL2;
+	else
+		pstate = VCPU_RESET_PSTATE_EL1;
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
index b963fd975aac..10eb7249aa9e 100644
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
 
 	spin_lock(&vcpu->arch.mp_state_lock);
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
2.55.0.rc0.738.g0c8ab3ebcc-goog

