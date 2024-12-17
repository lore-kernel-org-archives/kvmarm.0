Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E241F8680
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458145; cv=none; b=RrnY98VUXhuO1dgMO8AjH/B2X7XIHWF7f1yCSwEzXDtH2tbKQBLobyA5pzfZJ5nwhd1pTVA8CLGDUezrDDjaFUnISTWdiWUNzyX32HyEIg8UZpE555oO2SzMr52jE8e7vwqdGEo71Bh9RqhlMJ5bNuzAD/pd7JgvWqDumhycv94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458145; c=relaxed/simple;
	bh=EdkqAqbw6c5reJ2QDNttVzYQ0l37gYy2WjcedPyfUeM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YfIgJdB1nmJWsb9TtkX4/BGKrPm8BXylf+w0nxGYMUoybZa5hgYVX694wX5QsdybSlIrKLTwE+hVUOWm9U62yskL7GwECtTZ+y3YmixXHG8MkzqXpfK7kTnQQUiXw8mqUY1x3DCP/B1A3fsQ8sV/2qlr59KjlfTI64mSTYRn390=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=RslIrCO/; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="RslIrCO/"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=asUI8pvJo2CRJBz1LZ2W9LybpVU0Arw0F+NV3FtkRNU=;
	b=RslIrCO/geDTmA6GEYPC+0I0TMoQkoWIqWjQlrBaYwd1UIrNyJ3XWQHMj5xAy473hFO/Y9
	Fxlb8JXXefk0Oi9tGTK0Md1v76PtSw4V/fJGjQMqm8FGTrNxkj+kq9O79BXdEiUtM9cQqG
	Yfm6IMBRZlQCYTUCfVOCZwPBnP1MqxY=
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
Subject: [PATCH 2/4] KVM: arm64: Use KVM_REQ_RELOAD_PMU to handle PMCR_EL0.E change
Date: Tue, 17 Dec 2024 09:55:32 -0800
Message-Id: <20241217175532.3658134-1-oliver.upton@linux.dev>
In-Reply-To: <20241217175336.3657966-1-oliver.upton@linux.dev>
References: <20241217175336.3657966-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Nested virt introduces yet another set of 'global' knobs for controlling
event counters that are reserved for EL2 (i.e. >= HPMN). Get ready to
share some plumbing with the NV controls by offloading counter
reprogramming to KVM_REQ_RELOAD_PMU.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6b3ec956a6e2..c6423782a8aa 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -606,17 +606,13 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
+	/* Request a reload of the PMU to enable/disable affected counters */
+	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) ^ val) & ARMV8_PMU_PMCR_E)
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
 	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
-	if (val & ARMV8_PMU_PMCR_E) {
-		kvm_pmu_reprogram_counter_mask(vcpu,
-		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
-	} else {
-		kvm_pmu_reprogram_counter_mask(vcpu,
-		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
-	}
-
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
@@ -626,7 +622,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
-	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
@@ -890,11 +885,11 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
-	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
-
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= mask;
 	__vcpu_sys_reg(vcpu, PMINTENSET_EL1) &= mask;
 	__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= mask;
+
+	kvm_pmu_reprogram_counter_mask(vcpu, mask);
 }
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
-- 
2.39.5

