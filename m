Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3570C1DD867
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323207; cv=none; b=b5d8ulwSw8VK0gqQZSupI0LIXu+uxcSXTXB/jJEbjtbXk+0B943Haptymbl5dSzBby4RO4+8PPDn1E20ayLopWJ1MdbNoILExBprc/bIqQ/gHdVVSjT406X19M8r0OmkGf+uiV7iQlpXMeBQJ9aFez5mzlDeSKJkZF+XrTkX3+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323207; c=relaxed/simple;
	bh=Ke/HbXNd2QaF1khD+xCounJCx5EAjabWEGVhaJH2ilc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHOUfDdjnF9bcR0c2aU8RXhsV9TojyvWpFZKz+KEleKCFODPmcW8ZY/Ck0iBqCNyIAd0HqSoa5b3dWhYkpHxBFLGB2vZWnMDSsYgoAI65XSmFQPNcFGgHaT2hefLsPLlQWkoHJF/ghTH8tgzWh+oUfrKnNWv9LEwu6bKx9g4cNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=X44sq4CT; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="X44sq4CT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8QfP+8mOOm+c69ZTmTLC/ic52VJGev74ACqNnTlzulk=;
	b=X44sq4CTTtToFCDt4ko7B11jEyLcMevL8BApVowkFzYfrGWwlhY5NzMGQ8CmaD1/PHuXxP
	KeIbambeCm/vN8q4Wd+RGVGsj6UiD2eVnAmbzvWFbIzzD+GLm4KuyeL6bvALUbRjVTjvWi
	P65XftQ7WNI8kzq7cRbozgxxM+gGsYU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 17/17] KVM: arm64: nv: Reprogram PMU events affected by nested transition
Date: Mon,  7 Oct 2024 17:45:59 +0000
Message-ID: <20241007174559.1830205-18-oliver.upton@linux.dev>
In-Reply-To: <20241007174559.1830205-1-oliver.upton@linux.dev>
References: <20241007174559.1830205-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Start reprogramming PMU events at nested boundaries now that everything
is in place to handle the EL2 event filter. Only repaint events where
the filter differs between EL1 and EL2 as a slight optimization.

PMU now 'works' for nested VMs, albeit slow.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/emulate-nested.c |  4 ++++
 arch/arm64/kvm/pmu-emul.c       | 29 +++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h           |  3 +++
 3 files changed, 36 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 2d7a8b1f40fa..5fd55a7bb417 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2457,6 +2457,8 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	kvm_pmu_nested_transition(vcpu);
 }
 
 static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
@@ -2539,6 +2541,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 
+	kvm_pmu_nested_transition(vcpu);
+
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e7e9f8f25cbe..549cea3917eb 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1208,3 +1208,32 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 
 	return u64_replace_bits(pmcr, vcpu->kvm->arch.pmcr_n, ARMV8_PMU_PMCR_N);
 }
+
+void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
+{
+	bool reprogrammed = false;
+	unsigned long mask;
+	int i;
+
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return;
+
+	mask = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	for_each_set_bit(i, &mask, 32) {
+		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
+
+		/*
+		 * We only need to reconfigure events where the filter is
+		 * different at EL1 vs. EL2, as we're multiplexing the true EL1
+		 * event filter bit for nested.
+		 */
+		if (kvm_pmc_counts_at_el1(pmc) == kvm_pmc_counts_at_el2(pmc))
+			continue;
+
+		kvm_pmu_create_perf_event(pmc);
+		reprogrammed = true;
+	}
+
+	if (reprogrammed)
+		kvm_vcpu_pmu_restore_guest(vcpu);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b738ffb39bb0..3493e9d9f58e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -98,6 +98,7 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
+void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -198,6 +199,8 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu)
 	return false;
 }
 
+static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
+
 #endif
 
 #endif
-- 
2.47.0.rc0.187.ge670bccf7e-goog

