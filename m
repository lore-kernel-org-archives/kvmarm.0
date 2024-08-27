Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F881FAA
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718192; cv=none; b=QlRSWz57MZwo+gODxSWU11YHns9T6FhMPSKUbaF3anFxlo6XQr4xQbkI1w0fLrsT3pClrt06fRzY9mHVGzc9kdSBSsoeDrED+c42/g2Rhz+PK4paYNEKqj5ljP6eD7LjaIn/WY6eZOCaX9zAUQaZ/X1NeNOThrZCFFDPYpYOiic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718192; c=relaxed/simple;
	bh=Pp9YrKpswXnvpe+HFy4/qjTm2KlfXOBazn7dNk3a6u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moIubr27EHvq0znwEZ5VSMiBHigD3aB4KnJu5l95f7ERwH8QQR+BI4zlVp7QWkrJpegCeGA82uICMf0vJQ6tWvkl1leKM9c5MEPwJkLlgOjddPm1G+qEailsTQnf9dinpckwEBs1+22Dy2rtsNdH3u3OknBktRfahdUBOR5I/lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=xEgcXZ4F; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="xEgcXZ4F"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ObM6iY5Nr6LaS3YCvxHLfg3vKETemK1F5KGQ+yubIFA=;
	b=xEgcXZ4F8zSnR8L+HOn2A+8LZmX208IrjgiuHvzdN2daG4DLnaXbAoO/jqf17xcMzvginm
	NeCmQBUmvBnvX3m/1GazXxycAYpNHAIdu7Gp+5Sy5CxVsl2pykoytYriK5PYv8HILp4fZo
	Y4HP1wdCb68ZADF5/3nTKd9WhrZ28Co=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 12/12] KVM: arm64: nv: Reprogram PMU events affected by nested transition
Date: Tue, 27 Aug 2024 00:22:35 +0000
Message-ID: <20240827002235.1753237-13-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
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
index ae183dea79b7..6f748c4257f5 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2411,6 +2411,8 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
+
+	kvm_pmu_reprogram_events(vcpu);
 }
 
 static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
@@ -2493,6 +2495,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 
+	kvm_pmu_reprogram_events(vcpu);
+
 	return 1;
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dee669c0674..0cd0426892be 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1180,3 +1180,27 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 
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
index 25017e72c562..4e3f35b00bf8 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -97,6 +97,7 @@ int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
+void kvm_pmu_reprogram_events(struct kvm_vcpu *vcpu);
 #else
 struct kvm_pmu {
 };
@@ -192,6 +193,8 @@ static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline void kvm_pmu_reprogram_events(struct kvm_vcpu *vcpu) {}
+
 #endif
 
 #endif
-- 
2.46.0.295.g3b9ea8a38a-goog

