Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 399653B6376
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292566; cv=none; b=qSlogwXNHsWk6KS1MmyHQ1FtkfWW7bMdZVeo4MxCsuhcaxYqRAds/bEn91qswjHcHyB6U2H0Ii8GfQDKReOnOjNVl6E6OZOea1yn4TIlS84l+ojCkCDRw0jAegBgUCwMRxZxdXpWbpxLmzzCz5dbxcHzm5w57T74uyj8YUg3ul8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292566; c=relaxed/simple;
	bh=iDy5+j0nb9ZzT1lZTvVDNd2wmqQSBDk1yQc1yUrAGb4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o5hyIUS+ePcu5OqOGNbIHBkt2X3h3fZT+lEH2gD/Pkxj4U5LhyA6yqNXFj1rcuMQyLZgvhIZQcuopK+9rHgdCaHof+yJwMenh8iemMliSKEgFAq5T59BF01SAXIzNh+VaHx1bK/CaVc8TNJKXeZClyF5olit3//s8xtpMl/cG9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SuGzg6tW; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SuGzg6tW"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-48687e7f161so2129305b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292559; x=1781897359; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wX0J1ZgJ0AcfnjFoXewJ6CMfNQ+azFxPeQUJWlNBlCk=;
        b=SuGzg6tWHDCC3pcByBQ+gKwzlMjF4cVmn1e4M20ePDHqwGgp3XBiOSLDBrI65NIHjC
         /L+Gw35mPdnVxmtfofEBz+9XuaGwUMc212WT4heJKvVwecgolb3J/ktpirLLLJtT7mD7
         wgCzgpr671+71bkmUfmVLq0ROIg5ivhZmtDpMQL+tA/B+xcPB8B6nwWClnMCpd/ALb4E
         dsPsBMDJs8phDUNefGkUsq9Iudg1WcANQAFYa41pYgZSSs8FUSbWWRVuu2FzFe/VhUcU
         E3snmBV6VtUiDr9YTt1WojG+Ipi055Phn36U1riCgdr6whEsCDRmxHa+81ZTlkJrpFiz
         3KEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292559; x=1781897359;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wX0J1ZgJ0AcfnjFoXewJ6CMfNQ+azFxPeQUJWlNBlCk=;
        b=b6XKriDvXXRURRZUidtBXS5dh4DUntQZHDosigjWQ9bTq7++K1eVtTBoTl53OT1753
         Is9NOM3pj2bE/Iv9jQ8cJkcF3rHCjt45v2aazU38vMZjdYAg3G0vTkj2Vz5C9rXOZywO
         vr4Uo0XspE//7qNXXzSSseP3ZY+l2/Oteyqr2bxa9SGTRyGLPc8F/Rg7lQdZXGgmToyP
         6Zs39kBwABuiqpE1Zekjteg6tnouOngPvQDglH27cIztVsen2KKKaT90tl5tmRlZ6J+w
         cIpiO9DoB+hMyBdfH0PuB8iFwRMZtCnIultJfo/6rJUTBbAMggLAObjBce//GxcABV/o
         UCIw==
X-Forwarded-Encrypted: i=1; AFNElJ+U4Ub6/JxcU/feQ7Fs+xGLcjYWe2xrTIWBFjBdKR4crPumUB+r3sYDl0chLNy9tZdWbvSnK3g=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMbqVVkoTztP+eZFAt7V4Ud6kWKeRlfIvEqnMx7vCrdrbrNldY
	gnxgCTSwKzQTqVJIui6PzVQQiY7hLVXvzLv5fDmxZGJOwA5z5SuOvBwwmhq4A0oIQCXLJwS4G8B
	Ms/BlkVCtquarpjdWOk7i3vim4w==
X-Received: from ilec10-n2.prod.google.com ([2002:a05:6e02:614a:20b0:500:2720:748])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2516:b0:486:3537:218b with SMTP id 5614622812f47-487419e6716mr726786b6e.11.1781292558550;
 Fri, 12 Jun 2026 12:29:18 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:28:57 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-10-coltonlewis@google.com>
Subject: [PATCH 09/21] KVM: arm64: Add Partitioned PMU register trap handlers
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
 arch/arm64/kvm/pmu-direct.c |  30 ++++
 arch/arm64/kvm/sys_regs.c   | 265 +++++++++++++++++++++++++++++-------
 include/kvm/arm_pmu.h       |   7 +
 3 files changed, 254 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 0135989667564..43f04c2f33d44 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -9,6 +9,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
 
 /**
  * has_host_pmu_partition_support() - Determine if partitioning is possible
@@ -56,3 +57,32 @@ bool kvm_pmu_is_partitioned(struct kvm *kvm)
 	return pmu_is_partitioned(kvm->arch.arm_pmu) &&
 		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
 }
+
+void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val)
+{
+	bool reset_p = val & ARMV8_PMU_PMCR_P;
+	unsigned long mask;
+	int i;
+
+	val &= ~ARMV8_PMU_PMCR_P;
+
+	write_sysreg(val, pmcr_el0);
+
+	if (reset_p) {
+		mask = kvm_pmu_implemented_counter_mask(vcpu) & ~BIT(ARMV8_PMU_CYCLE_IDX);
+
+		if (!vcpu_is_el2(vcpu))
+			mask &= ~kvm_pmu_hyp_counter_mask(vcpu);
+
+		for_each_set_bit(i, &mask, ARMV8_PMU_MAX_GENERAL_COUNTERS)
+			write_pmevcntrn(i, 0);
+	}
+}
+
+u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
+{
+	return u64_replace_bits(
+		read_sysreg(pmcr_el0),
+		vcpu->kvm->arch.nr_pmu_counters,
+		ARMV8_PMU_PMCR_N);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c52873a6f91ed..94572bc52c32a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1070,9 +1070,192 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
 
+/**
+ * pmu_reg_write() - Register writes for Partitioned PMU
+ * @vcpu: Pointer to vcpu
+ * @reg: vcpu register
+ * @val: value to write
+ * @set: setting or clearing a mask
+ *
+ * Helper for sys_reg.c register accessor functions.
+ */
+static void pmu_reg_write(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg, u64 val, bool set)
+{
+	unsigned long flags;
+	u64 mask;
+	int idx;
+
+	switch (reg) {
+	case PMCR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			kvm_pmu_direct_pmcr_write(vcpu, val);
+		else
+			kvm_pmu_handle_pmcr(vcpu, val);
+		break;
+	case PMSELR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			write_sysreg(val, pmselr_el0);
+		else
+			__vcpu_assign_sys_reg(vcpu, reg, val);
+		break;
+	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
+		idx = reg - PMEVCNTR0_EL0;
+
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			if (idx == ARMV8_PMU_CYCLE_IDX)
+				write_sysreg(val, pmccntr_el0);
+			else
+				write_pmevcntrn(idx, val);
+		} else {
+			kvm_pmu_set_counter_value(vcpu, idx, val);
+		}
+		break;
+	case PMEVTYPER0_EL0 ... PMCCFILTR_EL0:
+		idx = reg - PMEVTYPER0_EL0;
+
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			mask = kvm_pmu_evtyper_mask(vcpu->kvm);
+			__vcpu_assign_sys_reg(vcpu, reg, val & mask);
+		} else {
+			kvm_pmu_set_counter_event_type(vcpu, val, idx);
+			kvm_vcpu_pmu_restore_guest(vcpu);
+		}
+		break;
+	case PMCNTENSET_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			if (set)
+				write_sysreg(val, pmcntenset_el0);
+			else
+				write_sysreg(val, pmcntenclr_el0);
+		} else {
+			if (set)
+				/* accessing PMCNTENSET_EL0 */
+				__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, |=, val);
+			else
+				/* accessing PMINTENCLR_EL1 */
+				__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, ~val);
+
+			kvm_pmu_reprogram_counter_mask(vcpu, val);
+		}
+		break;
+	case PMINTENSET_EL1:
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			if (set)
+				write_sysreg(val, pmintenset_el1);
+			else
+				write_sysreg(val, pmintenclr_el1);
+		} else {
+			if (set)
+				/* accessing PMINTENSET_EL1 */
+				__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
+			else
+				/* accessing PMINTENCLR_EL1 */
+				__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
+
+			kvm_pmu_reprogram_counter_mask(vcpu, val);
+		}
+		break;
+	case PMOVSSET_EL0:
+		local_irq_save(flags);
+		if (set)
+			/* accessing PMOVSSET_EL0 */
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val);
+		else
+			/* accessing PMOVSCLR_EL0 */
+			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~val);
+		local_irq_restore(flags);
+		break;
+	case PMUSERENR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			write_sysreg(val, pmuserenr_el0);
+		else
+			__vcpu_assign_sys_reg(vcpu, reg, val);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+}
+
+/**
+ * pmu_reg_read() - Register reads for Partitioned PMU
+ * @vcpu: Pointer to vcpu
+ * @reg: vcpu register
+ *
+ * Helper for sys_reg.c register accessor functions.
+ *
+ * Return: value read
+ */
+static u64 pmu_reg_read(struct kvm_vcpu *vcpu, enum vcpu_sysreg reg)
+{
+	u64 val = 0;
+	int idx;
+
+	switch (reg) {
+	case PMCR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			val = kvm_pmu_direct_pmcr_read(vcpu);
+		else
+			val = kvm_vcpu_read_pmcr(vcpu);
+		break;
+	case PMSELR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			val = read_sysreg(pmselr_el0);
+		else
+			val = __vcpu_sys_reg(vcpu, reg);
+		break;
+	case PMEVCNTR0_EL0 ... PMCCNTR_EL0:
+		idx = reg - PMEVCNTR0_EL0;
+
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			if (idx == ARMV8_PMU_CYCLE_IDX)
+				val = read_sysreg(pmccntr_el0);
+			else
+				val = read_pmevcntrn(idx);
+		} else {
+			val = kvm_pmu_get_counter_value(vcpu, idx);
+		}
+		break;
+	case PMEVTYPER0_EL0 ... PMCCFILTR_EL0:
+		val = __vcpu_sys_reg(vcpu, reg);
+		break;
+	case PMCNTENSET_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			val = read_sysreg(pmcntenset_el0);
+			val &= kvm_pmu_guest_counter_mask(vcpu->kvm->arch.arm_pmu);
+		} else {
+			val = __vcpu_sys_reg(vcpu, reg);
+		}
+		break;
+	case PMINTENSET_EL1:
+		if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+			val = read_sysreg(pmintenset_el1);
+			val &= kvm_pmu_guest_counter_mask(vcpu->kvm->arch.arm_pmu);
+		} else {
+			val = __vcpu_sys_reg(vcpu, reg);
+		}
+		break;
+	case PMOVSSET_EL0:
+		val = __vcpu_sys_reg(vcpu, reg);
+		break;
+	case PMUSERENR_EL0:
+		if (kvm_pmu_is_partitioned(vcpu->kvm))
+			val = read_sysreg(pmuserenr_el0);
+		else
+			val = __vcpu_sys_reg(vcpu, reg);
+		break;
+	default:
+		WARN_ON(1);
+		break;
+	}
+
+	return val;
+}
+
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
-	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	u64 reg = pmu_reg_read(vcpu, PMUSERENR_EL0);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
 	if (!enabled)
@@ -1111,18 +1294,17 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (p->is_write) {
 		/*
-		 * Only update writeable bits of PMCR (continuing into
-		 * kvm_pmu_handle_pmcr() as well)
+		 * Only update writeable bits of PMCR
 		 */
-		val = kvm_vcpu_read_pmcr(vcpu);
+		val = pmu_reg_read(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
-		kvm_pmu_handle_pmcr(vcpu, val);
+		pmu_reg_write(vcpu, PMCR_EL0, val, 0);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
-		val = kvm_vcpu_read_pmcr(vcpu)
+		val = pmu_reg_read(vcpu, PMCR_EL0)
 		      & ~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
 		p->regval = val;
 	}
@@ -1137,10 +1319,10 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		return false;
 
 	if (p->is_write)
-		__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, p->regval);
+		pmu_reg_write(vcpu, PMSELR_EL0, p->regval, 0);
 	else
 		/* return PMSELR.SEL field */
-		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
+		p->regval = pmu_reg_read(vcpu, PMSELR_EL0)
 			    & PMSELR_EL0_SEL_MASK;
 
 	return true;
@@ -1217,6 +1399,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			      struct sys_reg_params *p,
 			      const struct sys_reg_desc *r)
 {
+	enum vcpu_sysreg reg;
 	u64 idx = ~0UL;
 
 	if (r->CRn == 9 && r->CRm == 13) {
@@ -1226,7 +1409,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 				return false;
 
 			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
-					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
+					    pmu_reg_read(vcpu, PMSELR_EL0));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1254,18 +1437,21 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
+	reg = PMEVCNTR0_EL0 + idx;
+
 	if (p->is_write) {
 		if (pmu_access_el0_disabled(vcpu))
 			return false;
 
-		kvm_pmu_set_counter_value(vcpu, idx, p->regval);
+		pmu_reg_write(vcpu, reg, p->regval, 0);
 	} else {
-		p->regval = kvm_pmu_get_counter_value(vcpu, idx);
+		p->regval = pmu_reg_read(vcpu, reg);
 	}
 
 	return true;
 }
 
+
 static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			       const struct sys_reg_desc *r)
 {
@@ -1276,7 +1462,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, pmu_reg_read(vcpu, PMSELR_EL0));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
@@ -1292,12 +1478,10 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (!pmu_counter_idx_valid(vcpu, idx))
 		return false;
 
-	if (p->is_write) {
-		kvm_pmu_set_counter_event_type(vcpu, p->regval, idx);
-		kvm_vcpu_pmu_restore_guest(vcpu);
-	} else {
-		p->regval = __vcpu_sys_reg(vcpu, reg);
-	}
+	if (p->is_write)
+		pmu_reg_write(vcpu, reg, p->regval, 0);
+	else
+		p->regval = pmu_reg_read(vcpu, reg);
 
 	return true;
 }
@@ -1331,16 +1515,9 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
+		pmu_reg_write(vcpu, PMCNTENSET_EL0, val, r->Op2 & 0x1);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		p->regval = pmu_reg_read(vcpu, PMCNTENSET_EL0);
 	}
 
 	return true;
@@ -1349,22 +1526,17 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
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
-
-		if (r->Op2 & 0x1)
-			/* accessing PMINTENSET_EL1 */
-			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, |=, val);
-		else
-			/* accessing PMINTENCLR_EL1 */
-			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
+		val = p->regval & mask;
+		pmu_reg_write(vcpu, PMINTENSET_EL1, val, r->Op2 & 0x1);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		p->regval = pmu_reg_read(vcpu, PMINTENSET_EL1);
 	}
 
 	return true;
@@ -1373,20 +1545,18 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
+	u64 val, mask;
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
+
 	if (p->is_write) {
-		if (r->CRm & 0x2)
-			/* accessing PMOVSSET_EL0 */
-			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, (p->regval & mask));
-		else
-			/* accessing PMOVSCLR_EL0 */
-			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
+		val = p->regval & mask;
+		pmu_reg_write(vcpu, PMOVSSET_EL0, val, r->CRm & 0x2);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+		p->regval = pmu_reg_read(vcpu, PMOVSSET_EL0);
 	}
 
 	return true;
@@ -1415,10 +1585,9 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (!vcpu_mode_priv(vcpu))
 			return undef_access(vcpu, p, r);
 
-		__vcpu_assign_sys_reg(vcpu, PMUSERENR_EL0,
-				      (p->regval & ARMV8_PMU_USERENR_MASK));
+		pmu_reg_write(vcpu, PMUSERENR_EL0, p->regval & ARMV8_PMU_USERENR_MASK, 0);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMUSERENR_EL0)
+		p->regval = pmu_reg_read(vcpu, PMUSERENR_EL0)
 			    & ARMV8_PMU_USERENR_MASK;
 	}
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 36960b9e52da2..700d5f275b557 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -97,6 +97,8 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 bool pmu_is_partitioned(struct arm_pmu *pmu);
 bool kvm_pmu_is_partitioned(struct kvm *kvm);
+void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val);
+u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu);
 
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
@@ -141,6 +143,11 @@ static inline bool kvm_pmu_is_partitioned(struct kvm *kvm)
 {
 	return false;
 }
+static inline void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val) {}
+static inline u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
-- 
2.54.0.1136.gdb2ca164c4-goog

