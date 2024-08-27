Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04041FA4
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718174; cv=none; b=c7VINiPpxn7SPRuMitZ6zd2zX9X5yrfnjHa1r4tPAZcGWQdSGQf2zxDoakIZfUGqzkjGFekIaMCUdFVqkt768v7AvFWChLC5+me062Cq/xzhEylkO0WED/Qy3tOi7Nf6MCdbzMhp+Pjf7AX6nyreJkaaqa9VHDl2sRDhjVqP4kQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718174; c=relaxed/simple;
	bh=SPr8ICQPPSB3ribiEmqnaOrMfyQouJ8l4qUg5S2AXts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5KgwIy50g7NV88gwMaCJiKy50IymvwlhAybrWnpCgDoi1xBZIgC5BDniZBfyWXgEGmETh9fl7picvPqITRzc2KRVAuPMOuuIYp1cTzGkK7GY4HRCWNK9zU0DLHGW/xIg6spX6ynL9qbK7CiQUV4pJpIAB37QhHzmGADs+M5fbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Owr8LTN+; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Owr8LTN+"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TRWIJEmiaF7MWU/Hty7bOWTLp4WOhJ/0lc7sXafTwo4=;
	b=Owr8LTN+x2leQTVRQ/uaUizWIiJsbe/mNDOYdi6eDbADbTnTv+m72PhDyzbJD/7hIB9Npl
	sGGDpmYY1GEXtP01e+bLKiveB6DTkV6yyVv2g2DH4BNA8FJ6rH3nHIW6Yk/zpB7fSgi2mt
	wo6IoEm+F7d/4gj8wfclU1qmD/9cyxs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 01/12] KVM: arm64: Rename kvm_pmu_valid_counter_mask()
Date: Tue, 27 Aug 2024 00:22:24 +0000
Message-ID: <20240827002235.1753237-2-oliver.upton@linux.dev>
In-Reply-To: <20240827002235.1753237-1-oliver.upton@linux.dev>
References: <20240827002235.1753237-1-oliver.upton@linux.dev>
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
index 82a2a003259c..e88d6bd8221a 100644
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
@@ -265,7 +265,7 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
-u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
 
@@ -574,7 +574,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
@@ -804,7 +804,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	kvm_pmu_handle_pmcr(vcpu, kvm_vcpu_read_pmcr(vcpu));
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c90324060436..b25f6f44f451 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1128,7 +1128,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 {
 	bool set;
 
-	val &= kvm_pmu_valid_counter_mask(vcpu);
+	val &= kvm_pmu_implemented_counter_mask(vcpu);
 
 	switch (r->reg) {
 	case PMOVSSET_EL0:
@@ -1151,7 +1151,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 
 static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *val)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	*val = __vcpu_sys_reg(vcpu, r->reg) & mask;
 	return 0;
@@ -1165,7 +1165,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_valid_counter_mask(vcpu);
+	mask = kvm_pmu_implemented_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
@@ -1188,7 +1188,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
@@ -1212,7 +1212,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
@@ -1242,7 +1242,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_valid_counter_mask(vcpu);
+	mask = kvm_pmu_implemented_counter_mask(vcpu);
 	kvm_pmu_software_increment(vcpu, p->regval & mask);
 	return true;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 35d4ca4f6122..6af5ac1bdd54 100644
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
@@ -113,7 +113,7 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 }
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
-static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+static inline u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
-- 
2.46.0.295.g3b9ea8a38a-goog

