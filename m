From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 11/20] KVM: ARM64: Add access handler for PMOVSSET and
 PMOVSCLR register
Date: Wed, 24 Feb 2016 13:08:31 +0800
Message-ID: <1456290520-10012-12-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1EE412DD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E3Vsqk3Q5rY0 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:03:31 -0500 (EST)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 81428413E1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:30 -0500 (EST)
In-Reply-To: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, will.deacon@arm.com, shannon.zhao@linaro.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

Since the reset value of PMOVSSET and PMOVSCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a handler to emulate writing
PMOVSSET or PMOVSCLR register.

When writing non-zero value to PMOVSSET, the counter and its interrupt
is enabled, kick this vcpu to sync PMU interrupt.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 29 ++++++++++++++++++++++++++---
 include/kvm/arm_pmu.h             |  2 ++
 virt/kvm/arm/pmu.c                | 31 +++++++++++++++++++++++++++++++
 4 files changed, 60 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index c7642de..05f4808 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -126,6 +126,7 @@ enum vcpu_sysreg {
 	PMCCFILTR_EL0,	/* Cycle Count Filter Register */
 	PMCNTENSET_EL0,	/* Count Enable Set Register */
 	PMINTENSET_EL1,	/* Interrupt Enable Set Register */
+	PMOVSSET_EL0,	/* Overflow Flag Status Set Register */
 
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bfc70b2..6a774f9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -650,6 +650,28 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	return true;
 }
 
+static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			 const struct sys_reg_desc *r)
+{
+	u64 mask = kvm_pmu_valid_counter_mask(vcpu);
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	if (p->is_write) {
+		if (r->CRm & 0x2)
+			/* accessing PMOVSSET_EL0 */
+			kvm_pmu_overflow_set(vcpu, p->regval & mask);
+		else
+			/* accessing PMOVSCLR_EL0 */
+			vcpu_sys_reg(vcpu, PMOVSSET_EL0) &= ~(p->regval & mask);
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -857,7 +879,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcnten, NULL, PMCNTENSET_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovs, NULL, PMOVSSET_EL0 },
 	/* PMSWINC_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b100),
 	  trap_raz_wi },
@@ -884,7 +906,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  trap_raz_wi },
 	/* PMOVSSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1110), Op2(0b011),
-	  trap_raz_wi },
+	  access_pmovs, reset_unknown, PMOVSSET_EL0 },
 
 	/* TPIDR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1101), CRm(0b0000), Op2(0b010),
@@ -1198,7 +1220,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), access_pmovs },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmceid },
@@ -1208,6 +1230,7 @@ static const struct sys_reg_desc cp15_regs[] = {
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 0), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 1), access_pminten },
 	{ Op1( 0), CRn( 9), CRm(14), Op2( 2), access_pminten },
+	{ Op1( 0), CRn( 9), CRm(14), Op2( 3), access_pmovs },
 
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 0), access_vm_reg, NULL, c10_PRRR },
 	{ Op1( 0), CRn(10), CRm( 2), Op2( 1), access_vm_reg, NULL, c10_NMRR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index c5737797..60061da 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -43,6 +43,7 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -63,6 +64,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 591a11d..0232861 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -149,6 +149,37 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
+static u64 kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+{
+	u64 reg = 0;
+
+	if ((vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
+		reg = vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+		reg &= vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		reg &= vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		reg &= kvm_pmu_valid_counter_mask(vcpu);
+
+	return reg;
+}
+
+/**
+ * kvm_pmu_overflow_set - set PMU overflow interrupt
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMOVSSET register
+ */
+void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val)
+{
+	u64 reg;
+
+	if (val == 0)
+		return;
+
+	vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= val;
+	reg = kvm_pmu_overflow_status(vcpu);
+	if (reg != 0)
+		kvm_vcpu_kick(vcpu);
+}
+
 static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
-- 
2.0.4
