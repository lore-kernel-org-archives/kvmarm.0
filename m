Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68751D54F0
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323198; cv=none; b=EYJXT7pxf3ta/YiPhe5S4BxrcEq7aorcVtnQocmc45fDo0rIEEGMJs295mOHpNAF1m9GDoMRtHvbF2xGgSFP5QcN64YiM7HxzNRnfnHjNYhfTHq8oCHaZufQv1ESA6BnTWTT6JF54wAIaqHsdOchlrjYtgDn74kBH2xiL644dys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323198; c=relaxed/simple;
	bh=IVW7wtPyv92hDSqiKc28D1r45r+AtuNlt6X5e6cDYU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPUz0IkVzQEwxM75ueChXjPE6yL8HZCaqK4uktjlKfnuyent+NLDhefPdc6guw4C35JccRceYdp7kq1E0l9UWG2CxPqUDRpJZuOCKdKVmPK2sLY8SNg5WyBBVAsNhBK5O4ieOsyh3bKv3B47Alkc1u2JHxeOSoYgMwm7+SwBy+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=tPCwo2Qo; arc=none smtp.client-ip=95.215.58.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="tPCwo2Qo"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323194;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2YabCh8caSoh2eonw+P50J7IX0Ggc0bcE2FPtebm4=;
	b=tPCwo2Qoeu2D7BDLRrwrRrkrcf2kVJjV/T4Oi3U/AUhjJHUN73Z+ee0Klj1mH+cRE3Vv/6
	95hvCgq0rIjgTFiT6rvFjntdJ0pZKT5NWeeoz/4779YVbCGK+4Qnr7zhRtjTxAIUvrd6pp
	UGm86hht+MTfCe0IUfMVzafttMv9rj4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 11/17] KVM: arm64: Rename kvm_pmu_valid_counter_mask()
Date: Mon,  7 Oct 2024 17:45:53 +0000
Message-ID: <20241007174559.1830205-12-oliver.upton@linux.dev>
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

Nested PMU support requires dynamically changing the visible range of
PMU counters based on the exception level and value of MDCR_EL2.HPMN. At
the same time, the PMU emulation code needs to know the absolute number
of implemented counters, regardless of context.

Rename the existing helper to make it obvious that it returns the number
of implemented counters and not anything else.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c |  8 ++++----
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 include/kvm/arm_pmu.h     |  4 ++--
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 937405e8dbec..ca5da1da477d 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -244,7 +244,7 @@ void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 {
-	unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+	unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
 	int i;
 
 	for_each_set_bit(i, &mask, 32)
@@ -276,7 +276,7 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 	return idx >= hpmn;
 }
 
-u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
 
@@ -585,7 +585,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
@@ -815,7 +815,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 30fe940cd5bd..bd0c116f041b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1131,7 +1131,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 {
 	bool set;
 
-	val &= kvm_pmu_valid_counter_mask(vcpu);
+	val &= kvm_pmu_implemented_counter_mask(vcpu);
 
 	switch (r->reg) {
 	case PMOVSSET_EL0:
@@ -1154,7 +1154,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 
 static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *val)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	*val = __vcpu_sys_reg(vcpu, r->reg) & mask;
 	return 0;
@@ -1168,7 +1168,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_valid_counter_mask(vcpu);
+	mask = kvm_pmu_implemented_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
@@ -1191,7 +1191,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
@@ -1215,7 +1215,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
@@ -1245,7 +1245,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_valid_counter_mask(vcpu);
+	mask = kvm_pmu_implemented_counter_mask(vcpu);
 	kvm_pmu_software_increment(vcpu, p->regval & mask);
 	return true;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e6103df9ef5d..b175b10491f0 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -47,7 +47,7 @@ static __always_inline bool kvm_arm_support_pmu_v3(void)
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
-u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
@@ -114,7 +114,7 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 }
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
-static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+static inline u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
-- 
2.47.0.rc0.187.ge670bccf7e-goog

