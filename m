Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D08F215C63
	for <kvmarm@lists.linux.dev>; Fri, 25 Oct 2024 18:24:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729880677; cv=none; b=tARwL/OT2oXVHSxKhbAzyZI0buJlDYCMhcfcatW+ijl5mFOZe/Iyo8TfcEs3+mT8E7UwpfpQyeVX+hvefr36ls7Ftd1paBUXE4Jy08/7gyVzIjr5J2tj7MLD481LSvCUYCP3goy7DH41/JTo4GE7gTyOYIVNuvCeDdVzxU14h48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729880677; c=relaxed/simple;
	bh=HwkrC5aYPyJueVAlEgE14kMiYROceJnsX/Qw7zWubvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7BlrMg4J8UXuqaqNfKQbKSSg5gNqHdWb175Tw+TOrBo7jxJHIZ/1d4vb6oK3nGEasw9hnLvXCH8YwbmWlj9kc+qwo37c71QxfIwn5dr1JVbGis2vl9ViOukUduyBCSmuMula8o/ctK6RzSCrCZ2ql1q8MvSt0Avx5GshBJ972k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=VtQ3YKFg; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="VtQ3YKFg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729880673;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xS0LNtsr13NpmIWzYUeUSq9N7nBweh4XNUS3GYHX4cw=;
	b=VtQ3YKFgXHUajBZz+dZotBgh3+GWO+WNGMC630H6ZIeq4kUc7UrLdRJ4T3JbWDrpiZ9o8J
	JJK8kKyIr8bj0P6U9nLHUBAiByt0JFXUzxRGSyvT3T4o/Wiy22J+63AJ5qItg4lA/HxNct
	EXb9KW4wxBpApx32kZKY5tYLG7ePMP0=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 12/18] KVM: arm64: Rename kvm_pmu_valid_counter_mask()
Date: Fri, 25 Oct 2024 18:23:47 +0000
Message-ID: <20241025182354.3364124-13-oliver.upton@linux.dev>
In-Reply-To: <20241025182354.3364124-1-oliver.upton@linux.dev>
References: <20241025182354.3364124-1-oliver.upton@linux.dev>
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
index 28f938f145ac..fd08c4b53be3 100644
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
@@ -283,7 +283,7 @@ bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 	return idx >= hpmn;
 }
 
-u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
 
@@ -592,7 +592,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_valid_counter_mask(vcpu);
+		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
@@ -822,7 +822,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
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
2.47.0.163.g1226f6d8fa-goog

