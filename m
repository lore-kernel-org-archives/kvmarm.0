Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000CE1D2229
	for <kvmarm@lists.linux.dev>; Mon,  7 Oct 2024 17:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728323199; cv=none; b=BMbKAGw8e1O3znHE3Dm/reoFXel8D72JHfDlj5zx9QoWJ4fmk4HInKu8aPW0fvlYvWkqW69xtilPhkCF6J/WqNX5C77mtb4WYlAvE0G/kct66pW2g03+8U6arD1ZAGNHOsONt7T2ArWi59ExxsF5Y/+V8UNZyuF082ToLC6UQac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728323199; c=relaxed/simple;
	bh=RZdru1zmgnb47gjA3oA+GrZ85nU4ZrNd70RZxNM1aZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1VJCSE10h+diBBJuxFFdedYBgfYItYocH3jkEgg3bDpF2WoCQUtFLIt7iqVndtTJBMwyhVRxpoJt8+YJvR/yNvkMe05VBggvJZW0CJyvRCnOqb5ce1VxsUMYkeCzj8+CkHTqZd5bn9muFHvYlke8ZxqG5lpqlh0cyfDGucZcwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ea/LGw1b; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ea/LGw1b"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1728323196;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rJepSeoFgQDQiAnCBymnsdL2dPEkUcxhRRkMkqE5wBs=;
	b=ea/LGw1bUIB8AvdMDWH6iCvoTqnyRzRAAPCh+Ny9Hak3fuom7I6dTvEJHxfFboddKpuQvW
	JnbrdrToJ+SV82imurkuJL6XWzUm7bz8PMZh+McKq5frujojKDQ//xQiAvgaNRy77zLMA7
	xgyu0hXe3g1+PxHdD0jfkx74jtaXvOI=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 12/17] KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
Date: Mon,  7 Oct 2024 17:45:54 +0000
Message-ID: <20241007174559.1830205-13-oliver.upton@linux.dev>
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

The value of MDCR_EL2.HPMN controls the number of event counters made
visible to EL0 and EL1. This means it is possible for the guest
hypervisor to allow direct access to event counters to the L2.

Rework KVM's PMU register emulation to take the effects of HPMN into
account when handling a trap. For bitmask-style registers, writes only
affect accessible registers.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 14 +++++++++++++-
 arch/arm64/kvm/sys_regs.c | 12 ++++++------
 include/kvm/arm_pmu.h     |  5 +++++
 3 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ca5da1da477d..746ff1ceb998 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -276,6 +276,18 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 	return idx >= hpmn;
 }
 
+u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 hpmn;
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return mask;
+
+	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	return mask & GENMASK(hpmn - 1, 0);
+}
+
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
@@ -585,7 +597,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
+		unsigned long mask = kvm_pmu_accessible_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bd0c116f041b..8c226ec8bc25 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1131,7 +1131,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 {
 	bool set;
 
-	val &= kvm_pmu_implemented_counter_mask(vcpu);
+	val &= kvm_pmu_accessible_counter_mask(vcpu);
 
 	switch (r->reg) {
 	case PMOVSSET_EL0:
@@ -1154,7 +1154,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 
 static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *val)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	*val = __vcpu_sys_reg(vcpu, r->reg) & mask;
 	return 0;
@@ -1168,7 +1168,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_implemented_counter_mask(vcpu);
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
@@ -1191,7 +1191,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
@@ -1215,7 +1215,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
@@ -1245,7 +1245,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_implemented_counter_mask(vcpu);
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	kvm_pmu_software_increment(vcpu, p->regval & mask);
 	return true;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index b175b10491f0..b738ffb39bb0 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -48,6 +48,7 @@ static __always_inline bool kvm_arm_support_pmu_v3(void)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
@@ -118,6 +119,10 @@ static inline u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
-- 
2.47.0.rc0.187.ge670bccf7e-goog

