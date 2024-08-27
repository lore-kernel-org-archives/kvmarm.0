Received: from out-176.mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68FE11FB4
	for <kvmarm@lists.linux.dev>; Tue, 27 Aug 2024 00:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724718175; cv=none; b=QGuI1XTgr8KnIAe/YFuFJdfx3kh/iEWl5JwCSu62N2JTP112M8Op7si5DCykVM9uy4BKF/YwMLc53SlJkxKg/mkpeA3CAM3iU21D6fbxdAOMe40JNp9wRZ/DlIlPODdUgHOGwOYSpRd1O1e9iAUZRHuTP2cXRmjqtZF4IKi79Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724718175; c=relaxed/simple;
	bh=GTcNx0TgbNt6Wktir1+jYZZdYuuzdl/k2Gqp3KS5AaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTSbCr5kLolJJQ+dLMFItNboSg21NvKDz297VCB6Sv373uZFjd/jfpwOvGUT4sdmXhytdR6A3dVjCA2tO0xM6B2LyiupUFFDMHjZBsqxeQyE8D64hxanbrAlVkSxPviM/NVLQ4Gkipx33ubkikEe8eL6tx+Xn6Rwa5oXJT6DmYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XnPrn64f; arc=none smtp.client-ip=91.218.175.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XnPrn64f"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724718171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8jTAuYesvGZrLSw/ll7H7DhWsWXOquUSyhUloqp7g+A=;
	b=XnPrn64f4VqUzfV89swtwSlJ2XAP581Yv0FlWYgfK1lyU5+Lh26C9IOKWAU7uPrZFCgLqN
	tTfuSc5VcK2fmldCQMd0cQa7Zzdtc8M0ujl69lvJ4gIusfxAAw7WMnzEmnyuPmaSCV8csb
	IabLv7+cC9SNgzOOnJMIwjz86WzRYW4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 02/12] KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN
Date: Tue, 27 Aug 2024 00:22:25 +0000
Message-ID: <20240827002235.1753237-3-oliver.upton@linux.dev>
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
index e88d6bd8221a..f0081dc891a0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -275,6 +275,18 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
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
 /**
  * kvm_pmu_enable_counter_mask - enable selected PMU counters
  * @vcpu: The vcpu pointer
@@ -574,7 +586,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu);
+		unsigned long mask = kvm_pmu_accessible_counter_mask(vcpu);
 		mask &= ~BIT(ARMV8_PMU_CYCLE_IDX);
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index b25f6f44f451..b3c01d3be794 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1128,7 +1128,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 {
 	bool set;
 
-	val &= kvm_pmu_implemented_counter_mask(vcpu);
+	val &= kvm_pmu_accessible_counter_mask(vcpu);
 
 	switch (r->reg) {
 	case PMOVSSET_EL0:
@@ -1151,7 +1151,7 @@ static int set_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 va
 
 static int get_pmreg(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r, u64 *val)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	*val = __vcpu_sys_reg(vcpu, r->reg) & mask;
 	return 0;
@@ -1165,7 +1165,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_implemented_counter_mask(vcpu);
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	if (p->is_write) {
 		val = p->regval & mask;
 		if (r->Op2 & 0x1) {
@@ -1188,7 +1188,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			   const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	if (check_pmu_access_disabled(vcpu, 0))
 		return false;
@@ -1212,7 +1212,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			 const struct sys_reg_desc *r)
 {
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	u64 mask = kvm_pmu_accessible_counter_mask(vcpu);
 
 	if (pmu_access_el0_disabled(vcpu))
 		return false;
@@ -1242,7 +1242,7 @@ static bool access_pmswinc(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	if (pmu_write_swinc_el0_disabled(vcpu))
 		return false;
 
-	mask = kvm_pmu_implemented_counter_mask(vcpu);
+	mask = kvm_pmu_accessible_counter_mask(vcpu);
 	kvm_pmu_software_increment(vcpu, p->regval & mask);
 	return true;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6af5ac1bdd54..25017e72c562 100644
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
@@ -117,6 +118,10 @@ static inline u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
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
2.46.0.295.g3b9ea8a38a-goog

