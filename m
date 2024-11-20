Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0658D17F7
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 00:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732063970; cv=none; b=XCpInYNQ9E1CugfE/+F4oZ6Kf8E5D/5yL7Obn7385hf6ZnGcOq1kLA9feSPyQpDqqhCKEB//NPlEAQGvKf69pCO1bfEdNDinQAX2qLh4ZUwGHFu6w7LxDGDTGgdNCaJhqxVH1+pJ99VAXqVFFNK9l0fyr2DAy2kvprJAje/LRIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732063970; c=relaxed/simple;
	bh=TP3bu/xgL0e1Zyp+pufHn+p6jySpa9Gq+f/8fkKLVhg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h8ElzBxuBNJUrBdZMf5obtkQvyFaNSgn/vDRiwnJhi54ZJqcJejkbweacZPIk3K/TObaYmEAN6cd1GOj14Dzn3tspunZNTZbxWerOA5qqPCrXLiGfUAIIxuGnDwtjhH5+nnV4sJWGWk27iJCFpPUBGLx5GDYdI3o34IlMvmRAwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IsLbyPPe; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IsLbyPPe"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732063966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0XVQgxb67DiiotKN/g/vT8Fi5rYAwkJ2gypKfdZ5wPE=;
	b=IsLbyPPeiMqcxPQJ1a7ye8t/VptLb6wJpWk6VxXQEKnmLBthmIOjzXD5BxuNblhmIP+tQK
	GL3+l6MXqtjf3fk7JTeCAuBy3KP9JJbYyoBuCxhfy56TmSNuwPgEbIZ8prMcM61NI4F9dc
	6pcQiHLq6sxzRXG6oahBkyp/Kzw7Tbo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 2/2] KVM: arm64: Use MDCR_EL2.HPME to evaluate overflow of hyp counters
Date: Tue, 19 Nov 2024 16:52:30 -0800
Message-Id: <20241120005230.2335682-3-oliver.upton@linux.dev>
In-Reply-To: <20241120005230.2335682-1-oliver.upton@linux.dev>
References: <20241120005230.2335682-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

The 'global enable control' (as it is termed in the architecture) for
counters reserved by EL2 is MDCR_EL2.HPME. Use that instead of
PMCR_EL0.E when evaluating the overflow state for hyp counters.

Change the return value to a bool while at it, which better reflects the
fact that the overflow state is a shared signal and not a per-counter
property.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 58 +++++++++++++++++++++++++++++----------
 1 file changed, 43 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3855cc9d0ca5..fb79fa689ae5 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -274,12 +274,21 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
-bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+static u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
 {
-	unsigned int hpmn;
+	if (!vcpu_has_nv(vcpu))
+		return 0;
 
-	if (!vcpu_has_nv(vcpu) || idx == ARMV8_PMU_CYCLE_IDX)
-		return false;
+	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	n = vcpu->kvm->arch.pmcr_n;
+
+	/*
+	 * Programming HPMN to a value greater than PMCR_EL0.N is
+	 * CONSTRAINED UNPREDICTABLE. Make the implementation choice that an
+	 * UNKNOWN number of counters (in our case, zero) are reserved for EL2.
+	 */
+	if (hpmn >= n)
+		return 0;
 
 	/*
 	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
@@ -288,8 +297,12 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 	 * implementation choice that all counters are included in the second
 	 * range reserved for EL2/EL3.
 	 */
-	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-	return idx >= hpmn;
+	return GENMASK(n - 1, hpmn);
+}
+
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	return kvm_pmu_hyp_counter_mask(vcpu) & BIT(idx);
 }
 
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
@@ -300,8 +313,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
 		return mask;
 
-	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-	return mask & ~GENMASK(vcpu->kvm->arch.pmcr_n - 1, hpmn);
+	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
 }
 
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
@@ -375,14 +387,30 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
-static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+/*
+ * Returns the PMU overflow state, which is true if there exists an event
+ * counter where the values of the global enable control, PMOVSSET_EL0[n], and
+ * PMINTENSET_EL1[n] are all 1.
+ */
+static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
-	u64 reg = 0;
+	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
-	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
-		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
-		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
-	}
+	reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+
+	/*
+	 * PMCR_EL0.E is the global enable control for event counters available
+	 * to EL0 and EL1.
+	 */
+	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
+		reg &= kvm_pmu_hyp_counter_mask(vcpu);
+
+	/*
+	 * Otherwise, MDCR_EL2.HPME is the global enable control for event
+	 * counters reserved for EL2.
+	 */
+	if (!(vcpu_read_sys_reg(vcpu, MDCR_EL2) & MDCR_EL2_HPME))
+		reg &= ~kvm_pmu_hyp_counter_mask(vcpu);
 
 	return reg;
 }
@@ -395,7 +423,7 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	if (!kvm_vcpu_has_pmu(vcpu))
 		return;
 
-	overflow = !!kvm_pmu_overflow_status(vcpu);
+	overflow = kvm_pmu_overflow_status(vcpu);
 	if (pmu->irq_level == overflow)
 		return;
 
-- 
2.39.5

