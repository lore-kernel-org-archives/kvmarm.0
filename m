Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE3C0241668
	for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 11:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741780581; cv=none; b=N1luNNOwTmUFIWd4p5hwecZO0nnBacu7tn8ClRK6O8KU3DbAvNcHHLaQ80G0SucLWbKIbxz5qmxIiK+eBEWoHr2Vk/otDl7jpnpTI0qxFz2K/srPh8Vfm3uTWBxXRBmw5WgdoIhUufqmlXeMrvrnz/OQ9e1g6opqNaPzcSDArSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741780581; c=relaxed/simple;
	bh=CT75ZjyQVy3Jaeis6Xdan35QGJN8axEMP875Tyh32QU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=U4TC2is24Wo1hhyxGgLWthDG+GW2uZdeO5no08IUYHyzjWTYP5lHkQqllKtbWk8/NsLbFev/hgM6o+bMl7TLx/MD0dzauwPwG3Nl27HdPLura0vS0O7zgUx/yPkKmleB+EvkHLDaIj6jMQJKgCk5+w0qQK+7wED3Teg5BABumng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com; spf=pass smtp.mailfrom=daynix.com; dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b=TSO24+ot; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=daynix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=daynix.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="TSO24+ot"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-22423adf751so97054945ad.2
        for <kvmarm@lists.linux.dev>; Wed, 12 Mar 2025 04:56:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1741780579; x=1742385379; darn=lists.linux.dev;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wwE7purWiXM/F0UZ+ykkSRqLAxV2EP4DXS0cEhDzP48=;
        b=TSO24+otqc9p6UXqQcnBbnm9fumQ6MKXGRdeBHmb8lJndxXXfoslmtImxJDDE5IW5D
         I+3IDbsyfhBi9xpt8CSm+io08ewyJie2HlW1vsfCb7NfKojj59Q8R54BwvyOtuZdii2z
         PEkezRD93Qs4FXpO6sotY8OkAis5ZOxPiqWye5pTvbEK2/B8HH0mg4wSNHPXPFRPF7Cz
         UzP/xttaJt9+bV4NlJF/JOpiKZFz8HvRdaFXDymX0R1IuKssCAZdQkLwWvlxCklFE5da
         AF1k0Y+KpKs5dQF09uxQZsN3mLiCAt0+TVgO/nnRelvjB84e4eKoHwnQzG7DvkUna3Tq
         x07g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741780579; x=1742385379;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wwE7purWiXM/F0UZ+ykkSRqLAxV2EP4DXS0cEhDzP48=;
        b=c90xzCzapn9v6qotLMiQZ+6ICEbQOJqErTwAigRIwjrZgoOXlsylcl4p2euc//OV6V
         TY4pJZhT68KwOMn4yGfazD32ZffZj+ESRypuzak2oriUZymHTyjqgfEvNiuVDd4VRQ09
         yu84CsLYhjIBvi0KIGamQpKUgBLzdcEFhDNGlh+R2ZX+PwabYFfM1J9Xh0SBXkoiiZLA
         TIQ4ESTVQgLNhWGQ8hAcjQbnggFGfwAOM/emYKro6hBUE1WSc5y5kgoLrzN0daVE79F2
         xKc18sccG9YyUI3Kp8D95oTnZp1zfvHvoaxgX9ZhI/zx+cdlDjViyfU5KRSsOWyIv/Vw
         aZHw==
X-Forwarded-Encrypted: i=1; AJvYcCVDGiBVRdVWjSKdgc7u5UylPO9YuoI9urtq2veQdUy6J8fpFrrF6SG4N2D5iafiGjG4vj2Qwoo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzFPpTVSAwmHKnDuICd1QO7lLTeUTDb32aJDYZNImadazdtsW26
	/3nLXFNcLx7j8LjXzVVShNb2807+9BklM8tRF0pmJh22MKUtaB7jMlCbcAyENGg=
X-Gm-Gg: ASbGncvqinOg9A7hwG7I7uLA8hYg7P73aEtzlcV1SI7FZT9Gh3e3UQOlLq61d5NB2Km
	MVyW832CUxLeABGaYY0f4e86K63RIH445QiJToBMDENSH5pMfCV0raN52NedEQfd4xGGagXsljm
	tbiCryBS/uQueqCNtatYuRdFAm7YG0H++23mFfpMg2n4Eu/Bmjjt2swQavoNr6XbUIEx6sJUaMj
	UNf2TsCJs61yNBpBtpfVz7Glw5jiYOWEAnPIfDnPP3v3+nTWnXt15kYbyZ7741z66cZJc3TFvje
	Z3bhElemT/a337Q8EE4MFlLDH5V244129Liy1575WMX1fFq7
X-Google-Smtp-Source: AGHT+IGnNDhaZJn9+pWAJQQhskEvDmKUXMj64Q6j1/BL2bE5sEl9YUEXr8ltZIQn3VPWZCpg0FkadA==
X-Received: by 2002:a05:6a21:6f07:b0:1f5:6f98:70a0 with SMTP id adf61e73a8af0-1f58cb466e2mr11761471637.22.1741780578715;
        Wed, 12 Mar 2025 04:56:18 -0700 (PDT)
Received: from localhost ([157.82.205.237])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-736a6e5c13asm10966593b3a.157.2025.03.12.04.56.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Mar 2025 04:56:18 -0700 (PDT)
From: Akihiko Odaki <akihiko.odaki@daynix.com>
Date: Wed, 12 Mar 2025 20:55:56 +0900
Subject: [PATCH v3 2/6] KVM: arm64: PMU: Assume PMU presence in pmu-emul.c
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250312-pmc-v3-2-0411cab5dc3d@daynix.com>
References: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
In-Reply-To: <20250312-pmc-v3-0-0411cab5dc3d@daynix.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, Shannon Zhao <shannon.zhao@linaro.org>
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
and remove the obsolete checks from pmu-emul.c.

Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
---
 arch/arm64/kvm/arm.c      |  8 +++++---
 arch/arm64/kvm/guest.c    | 12 ++++++++++++
 arch/arm64/kvm/pmu-emul.c | 34 ++--------------------------------
 arch/arm64/kvm/sys_regs.c |  6 ++++--
 4 files changed, 23 insertions(+), 37 deletions(-)

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
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 962f985977c2..fc09eec3fd94 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -951,6 +951,10 @@ int kvm_arm_vcpu_arch_set_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		if (!kvm_vcpu_has_pmu(vcpu)) {
+			ret = -ENODEV;
+			break;
+		}
 		mutex_lock(&vcpu->kvm->arch.config_lock);
 		ret = kvm_arm_pmu_v3_set_attr(vcpu, attr);
 		mutex_unlock(&vcpu->kvm->arch.config_lock);
@@ -976,6 +980,10 @@ int kvm_arm_vcpu_arch_get_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		if (!kvm_vcpu_has_pmu(vcpu)) {
+			ret = -ENODEV;
+			break;
+		}
 		ret = kvm_arm_pmu_v3_get_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_TIMER_CTRL:
@@ -999,6 +1007,10 @@ int kvm_arm_vcpu_arch_has_attr(struct kvm_vcpu *vcpu,
 
 	switch (attr->group) {
 	case KVM_ARM_VCPU_PMU_V3_CTRL:
+		if (!kvm_vcpu_has_pmu(vcpu)) {
+			ret = -ENXIO;
+			break;
+		}
 		ret = kvm_arm_pmu_v3_has_attr(vcpu, attr);
 		break;
 	case KVM_ARM_VCPU_TIMER_CTRL:
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e3e82b66e226..3e5bf414447f 100644
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
 
@@ -1022,9 +999,6 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return -ENODEV;
-
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
@@ -1129,9 +1103,6 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (!irqchip_in_kernel(vcpu->kvm))
 			return -EINVAL;
 
-		if (!kvm_vcpu_has_pmu(vcpu))
-			return -ENODEV;
-
 		if (!kvm_arm_pmu_irq_initialized(vcpu))
 			return -ENXIO;
 
@@ -1150,8 +1121,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
-		if (kvm_vcpu_has_pmu(vcpu))
-			return 0;
+		return 0;
 	}
 
 	return -ENXIO;
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

