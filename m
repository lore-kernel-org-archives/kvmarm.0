Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0EEB357D02
	for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 07:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781852847; cv=none; b=gUND0UvWfeepFf7IWLSyZPk1bvnq1Mf375XI9e0rYulxj5d5PiL1/lgqHaDAXYZsjlzTjvaNngcZKAcvN5VJXkdpGvdZtwncAfxHL7oBukNxU0P14E+yG+jA2YffpGDHRkvFN1lxNp022N4NoqC4OGZREx9uKdBjBTtZpneAsmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781852847; c=relaxed/simple;
	bh=RMpU/b9vwNa0lym1MipW92ORxJiykVXfsm8dCsXUSZE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fReWvLnQPjnCB/6np5DNUSryGSMBbg2TPR237EKHYhIPp6VRvR4xamxk3+r5pz63jUbrEiKFRdqDiCLdK+DRzmT82miQUVKFNN+9n+pPDbDL2xEJYjIOm3clO3CZLeHr1ebSNVbt5s6g2lf9sFX9W3nHNV2JCePXnpn1fDR28LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nPfc/uHs; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nPfc/uHs"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-490b93debc8so12019915e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Jun 2026 00:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781852844; x=1782457644; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bo+Do6fvILC4QlQ6OlZKSYXEigkmbClK8Dx3jUj91Os=;
        b=nPfc/uHsmaF2BNoVpeSuEcIjmeuV7Z7fYGYEXggH+0smfHh9XBSoBSgJihNgndt7nH
         BDIWdq4LbHF1xIT5DSTjJ0fuLW2gGKHsvi5M8lwa8o5Xh4FantUOqet6CWFwkjTzckMV
         Ip6jFAMlCA9QOgHIEmv4DCe59Rtqrzcwnh6cYgivW+/2cVXqHJAtp+G2c88GJu1E0/tt
         cUMC/KWK0bRrRT5XCdb8HI6/b41ZyD5S69Ud00WQeDGJE4XoXw2e2+8wHRSWRsPVm5vH
         88i53mOLQw45Kk7MPMg44Etei5Nd03WorTpP9mFvT21Tk34Igzdi6l5sZttPleN05bcP
         NP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781852844; x=1782457644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bo+Do6fvILC4QlQ6OlZKSYXEigkmbClK8Dx3jUj91Os=;
        b=HPvfMk/HAvI/OALlcdaCtBD5E6pDHpWtwKrK+2XmRJOawUwKmFqrl05u5FMdSeKWf3
         aqyQSfO7/OvB+xrDmYbYQ1jtMFL/uY1PnER8yb0HQZu0E9xJ1B3ANATPVzBPr2kL8XCm
         +oQpKUdBrn5+oLRVwVAvoAyBYF/tCtEJABt9Q4P4cZAMv3QbzFoaRGwt3BhHUqDHzSqb
         ny4yYtfLFUMetylOQzK62KRmoNcg6nwTrAgL8LFAHV4E+njgWk2OiG+BrG5DU+6Plq+o
         msOAy7hEDMafa68P4V2scN5shOPz92OP1p9T0G9lRXGvf+7qIDq75DgNITeqLUVAI6Tg
         q8EA==
X-Forwarded-Encrypted: i=1; AFNElJ/xNXsWdQMLZlAzcqBbS6C0GknhdLYEEAeD4mNLPmeqNZEl/QfKch8xFlY3OmG5GVs8OT9q8/w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCkQR7kmW+7ot6Y1a08Mi6K/fanIHaFwMoIZOuMIpX3lFrhqkc
	g5zU/fT9lJIHRup4PklDbdeAW/wmoI5fOpImTPeSq3ro2AB/HoL7vinjADyAmW7JZZ2C597/VOL
	73A==
X-Received: from wmbid14.prod.google.com ([2002:a05:600c:a18e:b0:492:2b81:7d7e])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600d:8453:b0:492:37b7:6090
 with SMTP id 5b1f17b1804b1-4923ef51a7fmr43891775e9.5.1781852844306; Fri, 19
 Jun 2026 00:07:24 -0700 (PDT)
Date: Fri, 19 Jun 2026 08:07:14 +0100
In-Reply-To: <20260619070719.812227-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260619070719.812227-1-tabba@google.com>
X-Mailer: git-send-email 2.55.0.rc0.738.g0c8ab3ebcc-goog
Message-ID: <20260619070719.812227-4-tabba@google.com>
Subject: [PATCH v2 3/8] KVM: arm64: Factor out reusable vCPU reset helpers
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

