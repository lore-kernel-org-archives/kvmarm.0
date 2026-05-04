Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB537401A0E
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929524; cv=none; b=Df6FY/2vIpUv33JLz7CIs+oeBxxlZdgckgCmGb5099lw0oPVIUAkC1me94GUKFN8DqmmIZNEp/xliehKpF3u7CN9xGe6d4QN3mxvj3nX3i0247Ls0Hd13+v6LxLaBrRYpKTui53JXlsusvb07r7RxmRH/yiH1nbQgst1yxhD6TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929524; c=relaxed/simple;
	bh=SKo63HjoGCHTOKU92BPiu/k9cKpX9pAJWhd5TqUrBa0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LhX/N2EhCRDQhKB03SdHFZV//rGy6WFVcy3GbOmqeJk0xjdP5KOtpDnh6uvDYGQGL3tt1XNMvIit4YXJY4bHfLVi5Nm+8yfrUXjArfRo/isv1qMGsGol86/UQ7yzqG9lKYRPEIkO1kZk47NqN2GyTY1UpXhJldmKGH0dSxFZHnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XQTIW6ox; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XQTIW6ox"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40f25e55f20so7267479fac.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929518; x=1778534318; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BdEaEz514fBiVElpHNtxsUX8/xlNYtbOJ74nBbxAmPE=;
        b=XQTIW6oxB/Tq3IhaAPb0gPpO9Fp8OcJRcm5VzotV8Ej12itNWu7W9slEJBU9hZVEE6
         fWPbIDsqwT/ISrMfDfVeIEXB32Iw3BnNtkjwTmnFjXfSSuMcUcJynMI3iYJXMsJE6m8G
         Bs9ZDyutKInlqBI40gawQlb6WRuEiGEE+Ykcn/LVQPvy2/VVUmBQ723U/ATh2kHz4O2f
         wyuLOANFuYk+FAmGY3NbD6g2EKHnI01a1GPGhT44+drp/un+VcHumbrbKJ+iibdEdvIN
         Jp/YB8gs1jEF7bdzDIhs2VY5lLf6EzZA7vZ4X2PN2Z+kmTkKcKOzjdhkanrdvXyiwgHP
         fk4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929518; x=1778534318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BdEaEz514fBiVElpHNtxsUX8/xlNYtbOJ74nBbxAmPE=;
        b=IetBFnvmWyGPXgIz+DYAzC6PSux4bZ8eSeuPvPc48F+YV7LAbvLfD0qa/m18BQ1ott
         aVQq6+OiyVfJCQ5Sifliui0jY6pD16d2ch0/Qv5fiaBA8BQTXTjzxti+rGwliymGrnlx
         g2igRnUOiEbEyAQZcIDM8dxeLGhWa+AC7LvEegk5glSt8ar6MGzQBH0t4ajQ71/sqfnC
         VV82A+xrQinh+27kSBXxlqvUMPamUlCDLpOqMWE9WH/Ed5qfoUeUZkA3483RDY8IHabZ
         IFs5nXExcT2IbIq4nH3w1Kl2yq+iRM78N1rfRGU3EGdp1FxgjwT7eE50+tzgw8/k8/fr
         B8Sw==
X-Forwarded-Encrypted: i=1; AFNElJ97/RhXrfXLX+EWs86g5T+DzCq4fvNjR8+eNeSz5VMH37Q4uZqChOczVfplFeyl00bqOFprtsU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZWPVoJo1FjOTHVRPBZ3A3Gesq9Vlp78X2sdS3tryU2C4AhEpO
	6KIpe6bNojTZRIRABmHY9tipM1L1ck/Ekxpz/WSB/Vv7vWB+U8s67jUxKiAIVLAi8x8YOdldegS
	vZQE1RCdO517YAVymIv1xvDbZCA==
X-Received: from ilvd7.prod.google.com ([2002:a05:6e02:2147:b0:4fa:a7a5:6571])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2214:b0:696:1791:add8 with SMTP id 006d021491bc7-69697d5e366mr5834496eaf.40.1777929517855;
 Mon, 04 May 2026 14:18:37 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:01 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-9-coltonlewis@google.com>
Subject: [PATCH v7 08/20] KVM: arm64: Add Partitioned PMU register trap handlers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

We may want a partitioned PMU but not have FEAT_FGT to untrap the
specific registers that would normally be untrapped. Add handling for
those trapped register accesses that does the right thing if the PMU
is partitioned.

For registers that shouldn't be written to hardware because they
require special handling (PMEVTYPER and PMOVS), write to the virtual
register. A later patch will ensure these are handled correctly at
vcpu_load time.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/sys_regs.c | 236 +++++++++++++++++++++++++++++++-------
 1 file changed, 197 insertions(+), 39 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 0a8e8ee69cd00..cc3d1804ab200 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -985,9 +985,25 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
+static void pmu_write_pmuserenr(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		write_sysreg(val, pmuserenr_el0);
+	else
+		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0, val);
+}
+
+static u64 pmu_read_pmuserenr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmuserenr_el0);
+	else
+		return __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+}
+
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
-	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	u64 reg = pmu_read_pmuserenr(vcpu);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
 	if (!enabled)
@@ -1016,6 +1032,29 @@ static bool pmu_access_event_counter_el0_disabled(struct kvm_vcpu *vcpu)
 	return check_pmu_access_disabled(vcpu, ARMV8_PMU_USERENR_ER | ARMV8_PMU_USERENR_EN);
 }
 
+static void pmu_write_pmcr(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		write_sysreg(val, pmcr_el0);
+		return;
+	}
+
+	kvm_pmu_handle_pmcr(vcpu, val);
+}
+
+static u64 pmu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		return u64_replace_bits(
+			read_sysreg(pmcr_el0),
+			vcpu->kvm->arch.nr_pmu_counters,
+			ARMV8_PMU_PMCR_N);
+	}
+
+	return kvm_vcpu_read_pmcr(vcpu);
+
+}
+
 static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			const struct sys_reg_desc *r)
 {
@@ -1026,18 +1065,17 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write) {
 		/*
-		 * Only update writeable bits of PMCR (continuing into
-		 * kvm_pmu_handle_pmcr() as well)
+		 * Only update writeable bits of PMCR
 		 */
-		val = kvm_vcpu_read_pmcr(vcpu);
+		val = pmu_read_pmcr(vcpu);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
-		kvm_pmu_handle_pmcr(vcpu, val);
+		pmu_write_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = kvm_vcpu_read_pmcr(vcpu)
+		val = pmu_read_pmcr(vcpu)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -1045,6 +1083,24 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static void pmu_write_pmselr(struct kvm_vcpu *vcpu, u64 val)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		write_sysreg(val, pmselr_el0);
+		return;
+	}
+
+	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
+}
+
+static u64 pmu_read_pmselr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmselr_el0);
+
+	return __vcpu_sys_reg(vcpu, PMSELR_EL0);
+}
+
 static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			  const struct sys_reg_desc *r)
 {
@@ -1052,10 +1108,10 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write)
-		__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, p->regval);
+		pmu_write_pmselr(vcpu, p->regval);
 	else
 		/* return PMSELR.SEL field */
-		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
+		p->regval = pmu_read_pmselr(vcpu)
 			    & PMSELR_EL0_SEL_MASK;
 
 	return true;
@@ -1128,6 +1184,44 @@ static int set_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	return 0;
 }
 
+static void pmu_write_evcntr(struct kvm_vcpu *vcpu, u64 val, u64 idx)
+{
+	u64 pmselr;
+
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		kvm_pmu_set_counter_value(vcpu, idx, val);
+		return;
+	}
+
+	if (idx == ARMV8_PMU_CYCLE_IDX) {
+		write_sysreg(val, pmccntr_el0);
+		return;
+	}
+
+	pmselr = read_sysreg(pmselr_el0);
+	write_sysreg(idx, pmselr_el0);
+	write_sysreg(val, pmxevcntr_el0);
+	write_sysreg(pmselr, pmselr_el0);
+}
+
+static u64 pmu_read_evcntr(struct kvm_vcpu *vcpu, u64 idx)
+{
+	u64 pmselr;
+	u64 val;
+
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
+		return kvm_pmu_get_counter_value(vcpu, idx);
+
+	if (idx == ARMV8_PMU_CYCLE_IDX)
+		return read_sysreg(pmccntr_el0);
+
+	pmselr = read_sysreg(pmselr_el0);
+	write_sysreg(idx, pmselr_el0);
+	val = read_sysreg(pmxevcntr_el0);
+	write_sysreg(pmselr, pmselr_el0);
+	return val;
+}
+
 static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
@@ -1141,7 +1235,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 				return false;
 
 			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
-					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
+					    pmu_read_pmselr(vcpu));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1173,14 +1267,34 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 		if (pmu_access_el0_disabled(vcpu))
 			return false;
 
-		kvm_pmu_set_counter_value(vcpu, idx, p->regval);
+		pmu_write_evcntr(vcpu, p->regval, idx);
 	} else {
-		p->regval = kvm_pmu_get_counter_value(vcpu, idx);
+		p->regval = pmu_read_evcntr(vcpu, idx);
 	}
 
 	return true;
 }
 
+
+static void pmu_write_evtyper(struct kvm_vcpu *vcpu, u64 val, u64 idx)
+{
+	u64 mask;
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		mask = kvm_pmu_evtyper_mask(vcpu->kvm);
+		__vcpu_assign_sys_reg(vcpu, PMEVTYPER0_EL0 + idx, val & mask);
+		return;
+	}
+
+	kvm_pmu_set_counter_event_type(vcpu, val, idx);
+	kvm_vcpu_pmu_restore_guest(vcpu);
+}
+
+static u64 pmu_read_evtyper(struct kvm_vcpu *vcpu, u64 idx)
+{
+	return __vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx);
+}
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1191,7 +1305,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, pmu_read_pmselr(vcpu));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
@@ -1207,12 +1321,10 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
-	if (p->is_write) {
-		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
-		kvm_vcpu_pmu_restore_guest(vcpu);
-	} else {
-		p->regval = __vcpu_sys_reg(vcpu, reg);
-	}
+	if (p->is_write)
+		pmu_write_evtyper(vcpu, p->regval, idx);
+	else
+		p->regval = pmu_read_evtyper(vcpu, idx);
 
 	return true;
 }
@@ -1235,6 +1347,35 @@ static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *v
 	return 0;
 }
 
+static void pmu_write_pmcnten(struct kvm_vcpu *vcpu, u64 val, bool set)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (set)
+			write_sysreg(val, pmcntenset_el0);
+		else
+			write_sysreg(val, pmcntenclr_el0);
+
+		return;
+	}
+
+	if (set)
+		/* accessing PMCNTENSET_EL0 */
+		__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
+	else
+		/* accessing PMCNTENCLR_EL0 */
+		__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
+
+	kvm_pmu_reprogram_counter_mask(vcpu, val);
+}
+
+static u64 pmu_read_pmcnten(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmcntenset_el0);
+
+	return __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+}
+
 static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
@@ -1246,40 +1387,58 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
-		if (r->Op2 & 0x1)
-			/* accessing PMCNTENSET_EL0 */
-			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
-		else
-			/* accessing PMCNTENCLR_EL0 */
-			__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
-
-		kvm_pmu_reprogram_counter_mask(vcpu, val);
+		pmu_write_pmcnten(vcpu, val, r->Op2 & 0x1);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		p->regval = pmu_read_pmcnten(vcpu);
 	}
 
 	return true;
 }
 
+static void pmu_write_pminten(struct kvm_vcpu *vcpu, u64 val, bool set)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (set)
+			write_sysreg(val, pmintenset_el1);
+		else
+			write_sysreg(val, pmintenclr_el1);
+
+		return;
+	}
+
+	if (set)
+		/* accessing PMINTENSET_EL1 */
+		__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
+	else
+		/* accessing PMINTENCLR_EL1 */
+		__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
+
+	kvm_pmu_reprogram_counter_mask(vcpu, val);
+}
+
+static u64 pmu_read_pminten(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmintenset_el1);
+
+	return __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+}
+
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+	u64 val, mask;
 
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
 
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	if (p->is_write) {
-		u64 val = p->regval & mask;
+		val = p->regval & mask;
 
-		if (r->Op2 & 0x1)
-			/* accessing PMINTENSET_EL1 */
-			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
-		else
-			/* accessing PMINTENCLR_EL1 */
-			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
+		pmu_write_pminten(vcpu, val, r->Op2 & 0x1);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		p->regval = pmu_read_pminten(vcpu);
 	}
 
 	return true;
@@ -1330,10 +1489,9 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!vcpu_mode_priv(vcpu))
 			return undef_access(vcpu, p, r);
 
-		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0,
-				      (p->regval & ARMV8_PMU_USERENR_MASK));
+		pmu_write_pmuserenr(vcpu, p->regval & ARMV8_PMU_USERENR_MASK);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
+		p->regval = pmu_read_pmuserenr(vcpu)
 			    & ARMV8_PMU_USERENR_MASK;
 	}
 
-- 
2.54.0.545.g6539524ca2-goog

