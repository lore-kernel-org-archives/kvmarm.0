Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5778156E4
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323201; cv=none; b=D5/8SygOhZ3DVLA9+xbxpZmDxtldo1fFWoSsivVaau3PgJ2Yb9sD6YJ4RrmiEj4NGwFl17/RgEqcuUeoc8/qkB3YhHIEEgvSYETDk2Z8T2dim19kkdG2gVQM7WlSaeRCK0OoUA/dkKQATiSscR8Q0VhvY7wrrm/nFbDKpCM+d3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323201; c=relaxed/simple;
	bh=nl+flrIUuoM/FKyM8iMISWDZ53Ti6WmSlkehC4mg9hg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPqdc+LRz6WBRxfx8MFL84QK+imwokiccVV/9x4S7HguEe68oCXA5IvqY2bXocOnNrjVe6dL0AUa1Z5nIfWYpp7SQ8/qgaP3HcJS6ZjRI0HIfAhXZhL7Js+j8x/BSP+FWXaXSmPATd/d8KW4AwiqTZ/4BoNvk3FHcJljbU9gJTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=nluMk+t4; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="nluMk+t4"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323198;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b9uBNn21qTzNwWu8/imWTosPNOBynlzwf7NAF4YVvR0=;
	b=nluMk+t4b89rGKOD+OKaYJ/3OChILHTq6+FQGSy07LxeJCfdBzosgQ/2Gdi+rr2WIZjc8A
	kOIfAdGBA7TX9cAxqjUW6XHqcixGlCaDZp90Ab7fYwCohiRtKWYzIRrdPFCSzafLrEyK01
	TazkbKGjr6vJSOVtxcq7dXoZlsZdPLU=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 13/17] KVM: arm64: Add helpers to determine if PMC counts at a given EL
Date: Mon,  7 Oct 2024 17:45:55 +0000
Message-ID: <20241007174559.1830205-14-oliver.upton@linux.dev>
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

Checking the exception level filters for a PMC is a minor annoyance to
open code. Add helpers to check if an event counts at EL0 and EL1, which
will prove useful in a subsequent change.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 40 +++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 746ff1ceb998..723c9388b118 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -111,6 +111,11 @@ static u32 counter_index_to_evtreg(u64 idx)
 	return (idx == ARMV8_PMU_CYCLE_IDX) ? PMCCFILTR_EL0 : PMEVTYPER0_EL0 + idx;
 }
 
+static u64 kvm_pmc_read_evtreg(const struct kvm_pmc *pmc)
+{
+	return __vcpu_sys_reg(kvm_pmc_to_vcpu(pmc), counter_index_to_evtreg(pmc->idx));
+}
+
 static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
@@ -612,6 +617,24 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 	       (__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & BIT(pmc->idx));
 }
 
+static bool kvm_pmc_counts_at_el0(struct kvm_pmc *pmc)
+{
+	u64 evtreg = kvm_pmc_read_evtreg(pmc);
+	bool nsu = evtreg & ARMV8_PMU_EXCLUDE_NS_EL0;
+	bool u = evtreg & ARMV8_PMU_EXCLUDE_EL0;
+
+	return u == nsu;
+}
+
+static bool kvm_pmc_counts_at_el1(struct kvm_pmc *pmc)
+{
+	u64 evtreg = kvm_pmc_read_evtreg(pmc);
+	bool nsk = evtreg & ARMV8_PMU_EXCLUDE_NS_EL1;
+	bool p = evtreg & ARMV8_PMU_EXCLUDE_EL1;
+
+	return p == nsk;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -622,17 +645,15 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
 	struct perf_event *event;
 	struct perf_event_attr attr;
-	u64 eventsel, reg, data;
-	bool p, u, nsk, nsu;
+	u64 eventsel, evtreg;
 
-	reg = counter_index_to_evtreg(pmc->idx);
-	data = __vcpu_sys_reg(vcpu, reg);
+	evtreg = kvm_pmc_read_evtreg(pmc);
 
 	kvm_pmu_stop_counter(pmc);
 	if (pmc->idx == ARMV8_PMU_CYCLE_IDX)
 		eventsel = ARMV8_PMUV3_PERFCTR_CPU_CYCLES;
 	else
-		eventsel = data & kvm_pmu_event_mask(vcpu->kvm);
+		eventsel = evtreg & kvm_pmu_event_mask(vcpu->kvm);
 
 	/*
 	 * Neither SW increment nor chained events need to be backed
@@ -650,18 +671,13 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	    !test_bit(eventsel, vcpu->kvm->arch.pmu_filter))
 		return;
 
-	p = data & ARMV8_PMU_EXCLUDE_EL1;
-	u = data & ARMV8_PMU_EXCLUDE_EL0;
-	nsk = data & ARMV8_PMU_EXCLUDE_NS_EL1;
-	nsu = data & ARMV8_PMU_EXCLUDE_NS_EL0;
-
 	memset(&attr, 0, sizeof(struct perf_event_attr));
 	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(pmc);
-	attr.exclude_user = (u != nsu);
-	attr.exclude_kernel = (p != nsk);
+	attr.exclude_user = !kvm_pmc_counts_at_el0(pmc);
+	attr.exclude_kernel = !kvm_pmc_counts_at_el1(pmc);
 	attr.exclude_hv = 1; /* Don't count EL2 events */
 	attr.exclude_host = 1; /* Don't count host events */
 	attr.config = eventsel;
-- 
2.47.0.rc0.187.ge670bccf7e-goog

