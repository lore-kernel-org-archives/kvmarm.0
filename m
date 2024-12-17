Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678021FA157
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 17:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734458126; cv=none; b=ej4VYCma4AbngZLxSC9Sz7QXGuegYAD29Kd5mA7vq8s0C+vl+slah8rqG2mMFWO1fIOE5RmPRONP71pNWIXqSq/jj7/lDbiK9d+AC80m6gl5jlawyFGa5FS4d+7yfiAXgbDKwuzc9/zcI+T4QPQS+3lXfE+Mm1Q8JbfY48GcdaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734458126; c=relaxed/simple;
	bh=Dhq/P+MJKRITE2QJeXclRtN9eNZOoRQosXwiw0h7IMI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HPU6wsBiStHlPVI6pcdQ9p6zbVMJmimdEYtlwb99Xx7OlXPl1KKDsUA7Da9wsM8OKwnMK+KK82jO3FwiLjktYeFZx95JoaUeul7Xd73aHATFab0f34C11uDueJim4NYrjpJdKWi6EybUMw4YojAG8JS0y3HlvChiHXrbtEpkfXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tBUcOjxv; arc=none smtp.client-ip=91.218.175.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tBUcOjxv"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734458121;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CB9HKI+NJ3n64/5iDioBH4e+062atYAXFb5LTf/POpw=;
	b=tBUcOjxve7l8wQEkhVSzFL7shqlnW8ljQAyJ40CQA8mr5iA3Vr66BAEDueGK2p/1u2SWYA
	InWbQQLI1iHgPw6xRh824FesXidnWl0NFdB93WvAVRpjCFMwEpXtyIlc7VlRnWpJ6sX+lJ
	B1g9xdid1r0BS9jENdAjOzg4pvP9DZ4=
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
Subject: [PATCH 1/4] KVM: arm64: Add unified helper for reprogramming counters by mask
Date: Tue, 17 Dec 2024 09:55:13 -0800
Message-Id: <20241217175513.3658056-1-oliver.upton@linux.dev>
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

Having separate helpers for enabling/disabling counters provides the
wrong abstraction, as the state of each counter needs to be evaluated
independently and, in some cases, use a different global enable bit.

Collapse the enable/disable accessors into a single, common helper that
reconfigures every counter set in @mask, leaving the complexity of
determining if an event is actually enabled in
kvm_pmu_counter_is_enabled().

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 66 ++++++++++++++-------------------------
 arch/arm64/kvm/sys_regs.c | 10 +++---
 include/kvm/arm_pmu.h     |  6 ++--
 3 files changed, 29 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 456102bc0b55..6b3ec956a6e2 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -24,6 +24,7 @@ static DEFINE_MUTEX(arm_pmus_lock);
 
 static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
+static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
 {
@@ -327,48 +328,25 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
 }
 
-/**
- * kvm_pmu_enable_counter_mask - enable selected PMU counters
- * @vcpu: The vcpu pointer
- * @val: the value guest writes to PMCNTENSET register
- *
- * Call perf_event_enable to start counting the perf event
- */
-void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
+static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
 {
-	int i;
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
-	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
+	if (!pmc->perf_event) {
+		kvm_pmu_create_perf_event(pmc);
 		return;
+	}
 
-	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
-		struct kvm_pmc *pmc;
-
-		if (!(val & BIT(i)))
-			continue;
-
-		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
+	perf_event_enable(pmc->perf_event);
+	if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
+		kvm_debug("fail to enable perf event\n");
+}
 
-		if (!pmc->perf_event) {
-			kvm_pmu_create_perf_event(pmc);
-		} else {
-			perf_event_enable(pmc->perf_event);
-			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
-				kvm_debug("fail to enable perf event\n");
-		}
-	}
+static void kvm_pmc_disable_perf_event(struct kvm_pmc *pmc)
+{
+	if (pmc->perf_event)
+		perf_event_disable(pmc->perf_event);
 }
 
-/**
- * kvm_pmu_disable_counter_mask - disable selected PMU counters
- * @vcpu: The vcpu pointer
- * @val: the value guest writes to PMCNTENCLR register
- *
- * Call perf_event_disable to stop counting the perf event
- */
-void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
+void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
@@ -376,16 +354,18 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 		return;
 
 	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
-		struct kvm_pmc *pmc;
+		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
 
 		if (!(val & BIT(i)))
 			continue;
 
-		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
-
-		if (pmc->perf_event)
-			perf_event_disable(pmc->perf_event);
+		if (kvm_pmu_counter_is_enabled(pmc))
+			kvm_pmc_enable_perf_event(pmc);
+		else
+			kvm_pmc_disable_perf_event(pmc);
 	}
+
+	kvm_vcpu_pmu_restore_guest(vcpu);
 }
 
 /*
@@ -630,10 +610,10 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	__vcpu_sys_reg(vcpu, PMCR_EL0) = val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P);
 
 	if (val & ARMV8_PMU_PMCR_E) {
-		kvm_pmu_enable_counter_mask(vcpu,
+		kvm_pmu_reprogram_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	} else {
-		kvm_pmu_disable_counter_mask(vcpu,
+		kvm_pmu_reprogram_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
 	}
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e2a5c2918d9e..6ef8641d9833 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1208,16 +1208,14 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
-		if (r->Op2 & 0x1) {
+		if (r->Op2 & 0x1)
 			/* accessing PMCNTENSET_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
-			kvm_pmu_enable_counter_mask(vcpu, val);
-			kvm_vcpu_pmu_restore_guest(vcpu);
-		} else {
+		else
 			/* accessing PMCNTENCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
-			kvm_pmu_disable_counter_mask(vcpu, val);
-		}
+
+		kvm_pmu_reprogram_counter_mask(vcpu, val);
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e61dd7dd2286..147bd3ee4f7b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -53,8 +53,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
-void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
-void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
@@ -127,8 +126,7 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
-static inline void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
-static inline void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
-- 
2.39.5

