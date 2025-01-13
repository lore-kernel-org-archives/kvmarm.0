Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86A3E1FECCE
	for <kvmarm@lists.linux.dev>; Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736793332; cv=none; b=d0XEtR4Wz67IkjgL7WBe1f7kCIZnvNyrsV+IOQUqNdF+RL5gWT1+7n7RFQgVG6TxnufoiwvNsvpQvxP40Qkaf2WOpBm5dzfawBZro6vpa/UQFQOTxIR9nSmgt4qy+aYQGq5ito0OeleJ5bWWkzvfDMO/nNVFSdcEoaLLCzXWCcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736793332; c=relaxed/simple;
	bh=w7eGqIyDaQitZPPmkNJ3WPRHLy5cul7f2oz9AH7iHbM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=V25OcPdF0UesM67iBGmHGZZITuXRxELaEcaA7EwYyMJ9rFZ+yRN7iorv7v+QFvyDlSSRqjBtwd9rkxCOrFKBNMIrDf4dRZWhZS/Tehc/bGLrx4Vftf6HGUaJHlnEYyZNiYwXGN1D3ixohUWzr10BPxWQvU2E5b1JSkCpkXuan5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRWRhhSQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRWRhhSQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4916AC4CEE1;
	Mon, 13 Jan 2025 18:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736793332;
	bh=w7eGqIyDaQitZPPmkNJ3WPRHLy5cul7f2oz9AH7iHbM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lRWRhhSQwl/9Higy4jXP+Nsc/G9mP2jdm0mbM38Qk8ZDhQ8lVW5w/DBQ1u2zs6Lwr
	 Lu+UNgvIvu+ZBW/3C+kEGLlqHw2xXy2JVPwEfwbkrnS1RQjzA0oDgsIcr0VvXzLSTG
	 RVn99xxL23sbkKe+SMUToVGS8/YvBdtT9NkspcLZDyHvAjWlXs3w1eCsiC8WoYfO6i
	 uOKuAA3+05Yxq3QnRBtsIgF/T5hOume0Yfx6LIwulzYXLABGL8Lbfp/2tkKuO3tr3K
	 J7pjdWruQmjr7gT1JJTiMiRtbLU6rP2BI2U4DZFEnZxCqmIRhoFA6kBYn13+huLsRl
	 lThDM8pfEkoqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <maz@kernel.org>)
	id 1tXPHe-00BjrF-Fb;
	Mon, 13 Jan 2025 18:35:30 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [RFC PATCH 2/4] KVM: arm64: Add RMW specific sysreg accessor
Date: Mon, 13 Jan 2025 18:35:22 +0000
Message-Id: <20250113183524.1378778-3-maz@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250113183524.1378778-1-maz@kernel.org>
References: <20250113183524.1378778-1-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, joey.gouly@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

In a number of cases, we perform a Read-Modify-Write operation on
a system register, meaning that we would apply the RESx masks twice.

Instead, provide a new accessor that performs this RMW operation,
allowing the masks to be applied exactly once per operation.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  | 10 ++++++++++
 arch/arm64/kvm/debug.c             |  4 ++--
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c |  4 ++--
 arch/arm64/kvm/nested.c            |  2 +-
 arch/arm64/kvm/pmu-emul.c          | 10 +++++-----
 arch/arm64/kvm/sys_regs.c          | 26 +++++++++++++-------------
 6 files changed, 33 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1525b16d1df3e..c96a0c19dd108 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1077,6 +1077,16 @@ u64 kvm_vcpu_apply_reg_masks(const struct kvm_vcpu *, enum vcpu_sysreg, u64);
 		ctxt_sys_reg(ctxt, (r)) = __v;				\
 	} while (0)
 
+#define __vcpu_rmw_sys_reg(v, r, op, val)				\
+	do {								\
+		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
+		u64 __v = ctxt_sys_reg(ctxt, (r)) op (val);		\
+		if (vcpu_has_nv((v)) && (r) >= __SANITISED_REG_START__)	\
+			__v = kvm_vcpu_apply_reg_masks((v), (r), __v);	\
+									\
+		ctxt_sys_reg(ctxt, (r)) = __v;				\
+	} while (0)
+
 #define __vcpu_sys_reg(v,r)						\
 	(*({								\
 		const struct kvm_cpu_context *ctxt = &(v)->arch.ctxt;	\
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0e4c805e7e891..1a7dab333f557 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -216,9 +216,9 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
 void kvm_debug_handle_oslar(struct kvm_vcpu *vcpu, u64 val)
 {
 	if (val & OSLAR_EL1_OSLK)
-		__vcpu_sys_reg(vcpu, OSLSR_EL1) |= OSLSR_EL1_OSLK;
+		__vcpu_rmw_sys_reg(vcpu, OSLSR_EL1, |=, OSLSR_EL1_OSLK);
 	else
-		__vcpu_sys_reg(vcpu, OSLSR_EL1) &= ~OSLSR_EL1_OSLK;
+		__vcpu_rmw_sys_reg(vcpu, OSLSR_EL1, &=, ~OSLSR_EL1_OSLK);
 
 	preempt_disable();
 	kvm_arch_vcpu_put(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index a60639abc4a47..df373c21a4ed7 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -70,8 +70,8 @@ static void __sysreg_save_vel2_state(struct kvm_vcpu *vcpu)
 		 */
 		val = read_sysreg_el1(SYS_CNTKCTL);
 		val &= CNTKCTL_VALID_BITS;
-		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) &= ~CNTKCTL_VALID_BITS;
-		__vcpu_sys_reg(vcpu, CNTHCTL_EL2) |= val;
+		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, &=, ~CNTKCTL_VALID_BITS);
+		__vcpu_rmw_sys_reg(vcpu, CNTHCTL_EL2, |=, val);
 	}
 
 	__vcpu_assign_sys_reg(vcpu, SP_EL2,	 read_sysreg(sp_el1));
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index d3214c3a40393..f99af7cb083ae 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -1908,7 +1908,7 @@ int kvm_init_nv_sysregs(struct kvm_vcpu *vcpu)
 
 out:
 	for (enum vcpu_sysreg sr = __SANITISED_REG_START__; sr < NR_SYS_REGS; sr++)
-		(void)__vcpu_sys_reg(vcpu, sr);
+		__vcpu_rmw_sys_reg(vcpu, sr, |=, 0);
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 94340dee5ae11..3f3838ff47a74 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -516,7 +516,7 @@ static void kvm_pmu_counter_increment(struct kvm_vcpu *vcpu,
 			continue;
 
 		/* Mark overflow */
-		__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(i);
+		__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, BIT(i));
 
 		if (kvm_pmu_counter_can_chain(pmc))
 			kvm_pmu_counter_increment(vcpu, BIT(i + 1),
@@ -562,7 +562,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 	perf_event->attr.sample_period = period;
 	perf_event->hw.sample_period = period;
 
-	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, BIT(idx));
 
 	if (kvm_pmu_counter_can_chain(pmc))
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
@@ -891,9 +891,9 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
-	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
-	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
-	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, mask);
 
 	kvm_pmu_reprogram_counter_mask(vcpu, mask);
 }
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dfbbad2e95c04..6e685534f2858 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -791,7 +791,7 @@ static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		mask |= GENMASK(n - 1, 0);
 
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= mask;
+	__vcpu_rmw_sys_reg(vcpu, r->reg, &=, mask);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -799,7 +799,7 @@ static u64 reset_pmu_reg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_pmevcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= GENMASK(31, 0);
+	__vcpu_rmw_sys_reg(vcpu, r->reg, &=, GENMASK(31, 0));
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -811,7 +811,7 @@ static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return 0;
 
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= kvm_pmu_evtyper_mask(vcpu->kvm);
+	__vcpu_rmw_sys_reg(vcpu, r->reg, &=, kvm_pmu_evtyper_mask(vcpu->kvm));
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -819,7 +819,7 @@ static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= PMSELR_EL0_SEL_MASK;
+	__vcpu_rmw_sys_reg(vcpu, r->reg, &=, PMSELR_EL0_SEL_MASK);
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -1074,9 +1074,9 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 	}
 
 	if (set)
-		__vcpu_sys_reg(vcpu, r->reg) |= val;
+		__vcpu_rmw_sys_reg(vcpu, r->reg, |=, val);
 	else
-		__vcpu_sys_reg(vcpu, r->reg) &= ~val;
+		__vcpu_rmw_sys_reg(vcpu, r->reg, &=, ~val);
 
 	return 0;
 }
@@ -1102,10 +1102,10 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = p->regval & mask;
 		if (r->Op2 & 0x1)
 			/* accessing PMCNTENSET_EL0 */
-			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
+			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
 		else
 			/* accessing PMCNTENCLR_EL0 */
-			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
 
 		kvm_pmu_reprogram_counter_mask(vcpu, val);
 	} else {
@@ -1128,10 +1128,10 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 		if (r->Op2 & 0x1)
 			/* accessing PMINTENSET_EL1 */
-			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) |= val;
+			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
 		else
 			/* accessing PMINTENCLR_EL1 */
-			__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= ~val;
+			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
 	}
@@ -1150,10 +1150,10 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (p->is_write) {
 		if (r->CRm & 0x2)
 			/* accessing PMOVSSET_EL0 */
-			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= (p->regval & mask);
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
 		else
 			/* accessing PMOVSCLR_EL0 */
-			__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 	}
@@ -4611,7 +4611,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 			r->reset(vcpu, r);
 
 		if (r->reg >= __SANITISED_REG_START__ && r->reg < NR_SYS_REGS)
-			(void)__vcpu_sys_reg(vcpu, r->reg);
+			__vcpu_rmw_sys_reg(vcpu, r->reg, |=, 0);
 	}
 
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
-- 
2.39.2

