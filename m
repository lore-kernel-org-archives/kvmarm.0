Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952791FC0E2
	for <kvmarm@lists.linux.dev>; Thu, 13 Mar 2025 06:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741849088; cv=none; b=AlXa07UONOWSEb0+KQdrRNBv+Hoqsfni+cLGgyTeJYfh0DYkPSRSNMIeVISjyxaBJ2wBYppcyR7AkN9qCxzfCPRKpD4Xj9qhXIJ1KLGJYfMfP0n4r1ll1pLlKmwt7iSUPWP1Ve4ywLr6Mz3ppjaFVC7YjmbiqSxK72DpGSCi99U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741849088; c=relaxed/simple;
	bh=+7MGOulWYcTlLDw/DCCsYd1DVWMrJUiUcRqYbW+j+3Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=FYpkgwxILhQxRSy2QXU1Ll2TzY4ntbQHzQe7kh7Hd3Frhylj65DFq/p6Ob7ncd7M+Qq4cqxmM01ji9NKTMX7P6iFXDM3nLddlYY1qxox5jjL6Gq17PkDiNvbgFiN76r7jdlg1uQnhkJMgDse0J3U/bDnPUZ9t6Nx8anltljMhVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=Mgz3RpK+; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="Mgz3RpK+"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-223a7065ff8so16534265ad.0
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 23:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741849086; x=1742453886; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emEcgI1IcFZcczsFk7v4KbqV5pyU76mkqQgr8+I1+js=;
        b=Mgz3RpK+GPvUZfpFxJDb5JWImSyTh2qPD3Ps21jYCMulQeh0zehPhjU+MDb9moq5YC
         huzNOEa4x0/OLZS8BnbJlb98QoPreXRBoz3/3tt8a5G7P5+SKv7u9DQC03LFNMRYY8EZ
         mPZnessFqGYjJBnm//pBo3VF7vyPE8eVi5YtbSEuiYv7CUSLer+prr5h0u1bzOX52gZ5
         QFMnKRf93Htamu5ieE9Voe/8j5LQcKmEMo2w7k8NbaeBIpfywvoLPCCi1563PRyz6qQb
         gt4pAOfCSlxnu9PDMhk04IgqhM9qKSp2v02gwLPTXVN5njjjBt0Sj7Vu3/lNBQabU8DI
         kZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741849086; x=1742453886;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=emEcgI1IcFZcczsFk7v4KbqV5pyU76mkqQgr8+I1+js=;
        b=pDYMsdWCYBGUBtm0KmbN4XhbyY/dttq5CJNRgA7VVIor1h789CeIk2IX2zyuGttmrD
         5bZtVqksQJJUru/xyLrZzRbrhaQZJPvvI8q5NARPx3PI934bjGJtqzf1rg7pKfzGELtz
         17VQHtzdclu7gqLknwn6kq35ZHqaIoFzLKSk/H9e8U5PAX85TghWev005PzLKNdGs88e
         U96XEYIqEK2yyE5Mlimln1EJvq7zFQ47nRPXIE3HwW5Kn6DGlAClOBpbp6VofIzToEC2
         vICk9nDdnfuVOFdQth6Pafw2iwxEg8FRthvPJ6Yfljri7v7OsgYmnVel2U7IJGwVVSKE
         2v2g==
X-Forwarded-Encrypted: i=1; AJvYcCU9FcuDl5wmd6Lzwq/EvJV+5ywt8Bzru/m7gD7stg+lBigMJU4q4zWtsYOPvFLmh1caXQ22FKw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBbKqV1MprizE5mnBKMFX8ool6ldj6tPeoC89C7Yvkfkr9tKF1
	Z1EV04MxSLC6aCd1xWXO269y5U4xUuczV1sVKvJsX6UyzcZhdClUNGB60y4qPrI=
X-Gm-Gg: ASbGncvYrbXxMOsAFF5jgESOlBRIYB3B9KKFFDz11++gJEPxH4XvnKFgr6WkdnVxjLc
	yHxaR6IwubivwJLwNQhYMBh18/Ai2wp7OxbAMCzg/AMIYe0fDLEHk/6A6KGAmkTdFGPGe8oMLdK
	gl8cnZJq6wQYsXJRWoSG7WYfmMuqvua3x4pgh1/yAgjsYaCz+syopUE8rA0cAH9yfvTE7zvA9he
	CAlqgdK5SYuchkPbzPK2eg4oa2GdSdguWPsrURToHS98uq7hVbl5x6cxyfn3kd3QL4GqxwbOEYW
	VWWAkfruCKqH8iM17sZdrpP0hhjpjNXmsCwADUbe8aiwbD9m
X-Google-Smtp-Source: AGHT+IEBQV8sxGuSmnbE6/nC9EVPLKg/DvEGA12lj+yaW9V3WHmb2Osqgs4iyFBmmenFAgCKYwG/xQ==
X-Received: by 2002:a17:902:ce83:b0:21f:c67:a68a with SMTP id d9443c01a7336-22428a890c3mr411961125ad.31.1741849085952;
        Wed, 12 Mar 2025 23:58:05 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d9443c01a7336-225c6bd5ae4sm6400565ad.229.2025.03.12.23.58.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 23:58:05 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Thu, 13 Mar 2025 15:57:43 +0900
Subject: [PATCH v4 2/7] KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250313-pmc-v4-2-2c976827118c@daynix.com>
References: <20250313-pmc-v4-0-2c976827118c@daynix.com>
In-Reply-To: <20250313-pmc-v4-0-2c976827118c@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <andrew.jones@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, devel@daynix.com, 
 Akihiko Odaki <akihiko.odaki@daynix.com>
X-Mailer: b4 0.15-dev-edae6

Many functions in pmu-emul.c checks kvm_vcpu_has_pmu(vcpu). A favorable
interpretation is defensive programming, but it also has downsides:

- It is confusing as it implies these functions are called without PMU
  although most of them are called only when a PMU is present.

- It makes semantics of functions fuzzy. For example, calling
  kvm_pmu_disable_counter_mask() without PMU may result in no-op as
  there are no enabled counters, but it's unclear what
  kvm_pmu_get_counter_value() returns when there is no PMU.

- It allows callers without checking kvm_vcpu_has_pmu(vcpu), but it is
  often wrong to call these functions without PMU.

- It is error-prone to duplicate kvm_vcpu_has_pmu(vcpu) checks into
  multiple functions. Many functions are called for system registers,
  and the system register infrastructure already employs less
  error-prone, comprehensive checks.

Check kvm_vcpu_has_pmu(vcpu) in callers of these functions instead,
and remove the obsolete checks from pmu-emul.c. The only exceptions are
the functions that implement ioctls as they have definitive semantics
even when the PMU is not present.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/arm.c      |  8 +++++---
 arch/arm64/kvm/pmu-emul.c | 25 +------------------------
 arch/arm64/kvm/sys_regs.c |  6 ++++--
 3 files changed, 10 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f66ce098f03b..e375468a2217 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -834,9 +834,11 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 	if (ret)
 		return ret;
 
-	ret = kvm_arm_pmu_v3_enable(vcpu);
-	if (ret)
-		return ret;
+	if (kvm_vcpu_has_pmu(vcpu)) {
+		ret = kvm_arm_pmu_v3_enable(vcpu);
+		if (ret)
+			return ret;
+	}
 
 	if (is_protected_kvm_enabled()) {
 		ret = pkvm_create_hyp_vm(kvm);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e3e82b66e226..3dd0b479c6fd 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -144,9 +144,6 @@ static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
  */
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	return kvm_pmu_get_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
 }
 
@@ -185,9 +182,6 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
  */
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx), val, false);
 }
 
@@ -289,8 +283,6 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
 
 	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E) || !val)
 		return;
@@ -324,7 +316,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu) || !val)
+	if (!val)
 		return;
 
 	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -357,9 +349,6 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	overflow = !!kvm_pmu_overflow_status(vcpu);
 	if (pmu->irq_level == overflow)
 		return;
@@ -555,9 +544,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
@@ -696,9 +682,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
 	u64 reg;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	reg = counter_index_to_evtreg(pmc->idx);
 	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
 
@@ -804,9 +787,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!pmceid1) {
 		val = compute_pmceid0(cpu_pmu);
 		base = 0;
@@ -847,9 +827,6 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!vcpu->arch.pmu.created)
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0a2ce931a946..6e75557bea1d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1784,12 +1784,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
 static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
 				      const struct sys_reg_desc *rd)
 {
-	u8 perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
+	u8 perfmon;
 	u64 val = read_sanitised_ftr_reg(SYS_ID_DFR0_EL1);
 
 	val &= ~ID_DFR0_EL1_PerfMon_MASK;
-	if (kvm_vcpu_has_pmu(vcpu))
+	if (kvm_vcpu_has_pmu(vcpu)) {
+		perfmon = pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
 		val |= SYS_FIELD_PREP(ID_DFR0_EL1, PerfMon, perfmon);
+	}
 
 	val = ID_REG_LIMIT_FIELD_ENUM(val, ID_DFR0_EL1, CopDbg, Debugv8p8);
 

-- 
2.48.1

