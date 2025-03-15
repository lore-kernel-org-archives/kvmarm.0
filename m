Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008831F4706
	for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 09:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742029973; cv=none; b=pZ6/lzDpy9CUXsXDeZ/GD2Wk97/cPpk+i5TKpaVowzVq+P1+TXdhAVXOWDKgwiqVClUhVyudR/3gEgDrpK4ZqSoLlmZyJ/F7vQHFYoKLHl1Xn4VoT1vl6WkpPyqxzAgted1JrvwfU7iDS/lGMZbao6dFhmyAhNWEycqn5osjEng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742029973; c=relaxed/simple;
	bh=1avxgZwVJG4KZf5fCS1jidC7wJmMcnTsHuVGLTbJhjo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TeRZ2BK8n9rVKiYsgZUqWjg0KXdv92tZQBXyV5mOUr9IZZcooA9sPCNUm7sIp69Qcc2dnHcdYX/XqqhvHl80EHLsD86AHJ5SZ9V+Or+4JyeuUT0zrNd84fn9KtvpsnEG5O8UvLas7Kc1Q75xseiuCmYwTIpXUC5LCXlQ58L5v50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=ReYQY4mv; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="ReYQY4mv"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-223fd89d036so59031625ad.1
        for <kvmarm@lists.linux.dev>; Sat, 15 Mar 2025 02:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1742029971; x=1742634771; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RBhoY3JzR5UUf6f22tr97FXC7T2gtMfmjNwq/zidCrE=;
        b=ReYQY4mvDapNvaRsmJB/K6HgJNZcI3BIzXxaGM6bcIKidcecdl1oNGO50WDIINjw45
         CUhIHE7lqC4Gh3eOJQHSo6ekrbqHOfMVdQr2LVfodoV+YGgtU8BxMGWIEWBTnqGNCK1t
         yxDtlaWIBNN1T91vMUXAiTACtAlFkZ1nQMTQ0TF4FTx4PZxfUU1+ccB56qhqtsitqkrv
         5tdtEBvfLXFMUSAwxOUd4ibsYZSYG9DvHZo2rl2Y72juPq70C1xj1BeiTQrntMeITbNF
         IQ72XQWy7B/ExJlgpjoguOekz+EuLPmwXQWUpTPSSnlwI+u2SYPduiq2K3cL90bt+Vf9
         Nurw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742029971; x=1742634771;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RBhoY3JzR5UUf6f22tr97FXC7T2gtMfmjNwq/zidCrE=;
        b=HiB9jQ2J8EM/k027J/XAatYTyVdhkAcPsgjlVBvUf3zIaKvscmXghhfnd2usXlSd0r
         J6+kdQo+Hjq1gpcF9X5TaGKrzzLZr8MueBR0iP300UQ2C0Hkm1u02c5lhuAWSjvSUzSN
         Htpmg2xG2tm3pTMgNPiFAkNlSZpRbU/5GBpbsHBu5YA5m5gzfyVHZCOGiVLI2QOkvxdr
         Xl6tj32NZkDugAVtpNaH8D62nqDz5T6Po9NQyjJBFfZfS1+cvqQEKBukxky6IXdZgOwA
         5sSoaXA6v5w1NpQlJeW67SZzh1Q5ZulzV127CNwgDzPEYTadqj7U2JbZDkBaTEtrDEw4
         ApYA==
X-Forwarded-Encrypted: i=1; AJvYcCWCnjWwOOD0/TJhTzXKS8F8uJTOhHnXMfP+oscPeu5tn6HOaTKbVyvinizRapz7BZ/9edsiV14=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQi/z2Yh6X4vYvjdaMrcLSlO55iEXmEJiOTe7tkLmxJ7J0ijwE
	ju6NePjJEO4OP2RmycWPV7fSajSFdIA2/VA8D4ZYjhEwEbzGW2b47BSgD0GXOSg=
X-Gm-Gg: ASbGncvA8bv09naUjUpBzBLL56GE2uPJKqWrFFR1MlKX/dh5afnuhc2nFw7oIpD+e0m
	a/Y3k6QQYJgmG+b4Jn2VMT+Oq57Ej2TrLPZwDtBpghDfQYufYRcJ6SXx0EIiVHCfVbLoabaWSDj
	m9dlCSvy8mUPR8oHJjwfDPDVdJsIkTMeIAB0JCoI7pcNwHoFeylTUU4wiKDHFjrdZLwE32K3+WB
	Cejvo/urZ1AEg4uhcbSzAFEpkjKK0XjkPv0Y7k6MjuK5mwUs5hEJ+/X/xs2ot8Vlb7rBwB8FNx7
	vnnVkHAqT9gDkMYPixbIAnI2uEeqGIHm1NmF2NSQ/bEQceHM
X-Google-Smtp-Source: AGHT+IHzLP/Cp0+ZoY1hmXekIVA9+RY6XNkX4cssJ6gV1Uehk1XprCWAd4bfwyV6HDnSKCO9/1qjaA==
X-Received: by 2002:a17:903:2b0c:b0:223:faf5:c82 with SMTP id d9443c01a7336-225e0a28898mr57188645ad.8.1742029971350;
        Sat, 15 Mar 2025 02:12:51 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-30153b994b3sm2327772a91.30.2025.03.15.02.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Mar 2025 02:12:51 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Sat, 15 Mar 2025 18:12:11 +0900
Subject: [PATCH v5 2/5] KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250315-pmc-v5-2-ecee87dab216@daynix.com>
References: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
In-Reply-To: <20250315-pmc-v5-0-ecee87dab216@daynix.com>
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
 arch/arm64/kvm/arm.c            | 17 +++++++++++------
 arch/arm64/kvm/emulate-nested.c |  6 ++++--
 arch/arm64/kvm/pmu-emul.c       | 26 +-------------------------
 arch/arm64/kvm/sys_regs.c       |  6 ++++--
 4 files changed, 20 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0160b4924351..caa1357fa367 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -835,9 +835,11 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
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
@@ -1148,7 +1150,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 */
 		preempt_disable();
 
-		kvm_pmu_flush_hwstate(vcpu);
+		if (kvm_vcpu_has_pmu(vcpu))
+			kvm_pmu_flush_hwstate(vcpu);
 
 		local_irq_disable();
 
@@ -1167,7 +1170,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		if (ret <= 0 || kvm_vcpu_exit_request(vcpu, &ret)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
 			isb(); /* Ensure work in x_flush_hwstate is committed */
-			kvm_pmu_sync_hwstate(vcpu);
+			if (kvm_vcpu_has_pmu(vcpu))
+				kvm_pmu_sync_hwstate(vcpu);
 			if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
 				kvm_timer_sync_user(vcpu);
 			kvm_vgic_sync_hwstate(vcpu);
@@ -1197,7 +1201,8 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 		 * that the vgic can properly sample the updated state of the
 		 * interrupt line.
 		 */
-		kvm_pmu_sync_hwstate(vcpu);
+		if (kvm_vcpu_has_pmu(vcpu))
+			kvm_pmu_sync_hwstate(vcpu);
 
 		/*
 		 * Sync the vgic state before syncing the timer state because
diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
index 607d37bab70b..9293fb078fc6 100644
--- a/arch/arm64/kvm/emulate-nested.c
+++ b/arch/arm64/kvm/emulate-nested.c
@@ -2516,7 +2516,8 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcpu)
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 
-	kvm_pmu_nested_transition(vcpu);
+	if (kvm_vcpu_has_pmu(vcpu))
+		kvm_pmu_nested_transition(vcpu);
 }
 
 static void kvm_inject_el2_exception(struct kvm_vcpu *vcpu, u64 esr_el2,
@@ -2599,7 +2600,8 @@ static int kvm_inject_nested(struct kvm_vcpu *vcpu, u64 esr_el2,
 	kvm_arch_vcpu_load(vcpu, smp_processor_id());
 	preempt_enable();
 
-	kvm_pmu_nested_transition(vcpu);
+	if (kvm_vcpu_has_pmu(vcpu))
+		kvm_pmu_nested_transition(vcpu);
 
 	return 1;
 }
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 6c5950b9ceac..98fdc65f5b24 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -150,9 +150,6 @@ static u64 kvm_pmu_get_pmc_value(struct kvm_pmc *pmc)
  */
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	return kvm_pmu_get_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx));
 }
 
@@ -191,9 +188,6 @@ static void kvm_pmu_set_pmc_value(struct kvm_pmc *pmc, u64 val, bool force)
  */
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, select_idx), val, false);
 }
 
@@ -350,7 +344,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu) || !val)
+	if (!val)
 		return;
 
 	for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -401,9 +395,6 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	overflow = kvm_pmu_overflow_status(vcpu);
 	if (pmu->irq_level == overflow)
 		return;
@@ -599,9 +590,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
@@ -766,9 +754,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, select_idx);
 	u64 reg;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	reg = counter_index_to_evtreg(pmc->idx);
 	__vcpu_sys_reg(vcpu, reg) = data & kvm_pmu_evtyper_mask(vcpu->kvm);
 
@@ -848,9 +833,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
 		/* always support CHAIN */
@@ -900,9 +882,6 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!vcpu->arch.pmu.created)
 		return -EINVAL;
 
@@ -1231,9 +1210,6 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 	unsigned long mask;
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	mask = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
 	for_each_set_bit(i, &mask, 32) {
 		struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ffee72fd1273..e8e9c781a929 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1853,12 +1853,14 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
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

