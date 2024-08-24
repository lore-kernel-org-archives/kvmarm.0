Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1AAC625
	for <kvmarm@lists.linux.dev>; Sat, 24 Aug 2024 00:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724458464; cv=none; b=H38TevgjMkOS33aeJXpcn9Z4rpPMj68jXAqCjBlt+ALmL1rn/u831XQFpzD1H0qaCo0YbJth7vhDsWSOBqsiJbk5bbos5nMuQ5S9735NdZgPkXU3J14JoiPZ+xb0QXns5nh0x6IMP0V1IDx9LPARRFNtg2fBtEm8CHQUWkXJXfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724458464; c=relaxed/simple;
	bh=D6gKsoWLd/QRPh6oXbihpN3o/1Z5Gk8IJ8bpS+SZIeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oDQ3ZaRFWyyQUoFilCa61XMN00BdlSL5kc5T5SUERCFPa8iv55PsX/bFf+1G30/pdCnbJNbVTxekXXVQf7OrekqqO42BKV/cG0wEzVZ60lH8+jRpghfgPX0pCpyEEKZv6E6hp2b95elWm2ITrlWHvrKiCDdoscjJqQaDt9NNsnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qDOfn4Kc; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qDOfn4Kc"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724458460;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1NzEYwMMH2wGqMI7xDAOkkPshyAgWojC9cuvLn0VhdM=;
	b=qDOfn4KcLU4G7dl0BQ5O4Xfw8gxG1HQwLLbMJ2eiL8P0GWSxQl1ffiFjIZi+9wwqmsKeLc
	OfjWxGWVRjK4uNU9b0gQ7Dbrxzn8BDnB0aHTg0CXkuYbJ/dh1fsVd7S6PbsgxLsf9iJMqn
	7Pa6Z99vuSx48zMriQo21JjceGGR6TI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 3/3] KVM: arm64: nv: Reprogram PMU events affected by nested transition
Date: Sat, 24 Aug 2024 00:14:02 +0000
Message-ID: <20240824001402.3909504-4-oliver.upton@linux.dev>
In-Reply-To: <20240824001402.3909504-1-oliver.upton@linux.dev>
References: <20240824001402.3909504-1-oliver.upton@linux.dev>
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
 arch/arm64/kvm/pmu-emul.c       | 24 ++++++++++++++++++++++++
 include/kvm/arm_pmu.h           |  3 +++
 3 files changed, 31 insertions(+)

diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 05166eccea0a..fc56dace61af 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2322,6 +2322,8 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	kvm_pmu_reprogram_events(vcpu);
 }
 
 static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
@@ -2404,6 +2406,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 
+	kvm_pmu_reprogram_events(vcpu);
+
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index edc543574c5e..028b20c70344 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1168,3 +1168,27 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 
 	return u64_replace_bits(pmcr, vcpu->kvm->arch.pmcr_n, ARMV8_PMU_PMCR_N);
 }
+
+void kvm_pmu_reprogram_events(struct kvm_vcpu *vcpu)
+{
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
+	}
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 35d4ca4f6122..d9f512bf714d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,7 @@ int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
+void kvm_pmu_reprogram_events(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -187,6 +188,8 @@ static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void kvm_pmu_reprogram_events(struct kvm_vcpu *vcpu) {}
+
 #endif
 
 #endif
-- 
2.46.0.295.g3b9ea8a38a-goog

