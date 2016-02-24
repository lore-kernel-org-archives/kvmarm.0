From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v13 07/20] KVM: ARM64: Add access handler for PMCNTENSET and
 PMCNTENCLR register
Date: Wed, 24 Feb 2016 13:08:27 +0800
Message-ID: <1456290520-10012-8-git-send-email-zhaoshenglong@huawei.com>
References: <1456290520-10012-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 625C949616
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qUaPEZMNudif for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Feb 2016 00:03:38 -0500 (EST)
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [119.145.14.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 278C949444
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Feb 2016 00:03:34 -0500 (EST)
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

Since the reset value of PMCNTENSET and PMCNTENCLR is UNKNOWN, use
reset_unknown for its reset handler. Add a handler to emulate writing
PMCNTENSET or PMCNTENCLR register.

When writing to PMCNTENSET, call perf_event_enable to enable the perf
event. When writing to PMCNTENCLR, call perf_event_disable to disable
the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/sys_regs.c         | 35 ++++++++++++++++++---
 include/kvm/arm_pmu.h             |  9 ++++++
 virt/kvm/arm/pmu.c                | 66 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 107 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 627f01e..e6910db 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -121,6 +121,7 @@ enum vcpu_sysreg {
 	PMEVCNTR0_EL0,	/* Event Counter Register (0-30) */
 	PMEVCNTR30_EL0 = PMEVCNTR0_EL0 + 30,
 	PMCCNTR_EL0,	/* Cycle Counter Register */
+	PMCNTENSET_EL0,	/* Count Enable Set Register */
 
 	/* 32bit specific registers. Keep them at the end of the range */
 	DACR32_EL2,	/* Domain Access Control Register */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index ff3214b..d4b6ae3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -563,6 +563,33 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			   const struct sys_reg_desc *r)
+{
+	u64 val, mask;
+
+	if (!kvm_arm_pmu_v3_ready(vcpu))
+		return trap_raz_wi(vcpu, p, r);
+
+	mask = kvm_pmu_valid_counter_mask(vcpu);
+	if (p->is_write) {
+		val = p->regval & mask;
+		if (r->Op2 & 0x1) {
+			/* accessing PMCNTENSET_EL0 */
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
+			kvm_pmu_enable_counter(vcpu, val);
+		} else {
+			/* accessing PMCNTENCLR_EL0 */
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			kvm_pmu_disable_counter(vcpu, val);
+		}
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -757,10 +784,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcr, reset_pmcr, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmcnten, reset_unknown, PMCNTENSET_EL0 },
 	/* PMCNTENCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmcnten, NULL, PMCNTENSET_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
 	  trap_raz_wi },
@@ -1057,8 +1084,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcnten },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcnten },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index bcb7698..b70058e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,6 +40,9 @@ struct kvm_pmu {
 #define kvm_arm_pmu_v3_ready(v)		((v)->arch.pmu.ready)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
+u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 #else
 struct kvm_pmu {
 };
@@ -52,6 +55,12 @@ static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 }
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
+static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index cd74e63..f8dc174 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -61,3 +61,69 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
 }
+
+u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+
+	val &= ARMV8_PMU_PMCR_N_MASK;
+	if (val == 0)
+		return BIT(ARMV8_PMU_CYCLE_IDX);
+	else
+		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
+}
+
+/**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET register
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
+		return;
+
+	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+		if (!(val & BIT(i)))
+			continue;
+
+		pmc = &pmu->pmc[i];
+		if (pmc->perf_event) {
+			perf_event_enable(pmc->perf_event);
+			if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
+				kvm_debug("fail to enable perf event\n");
+		}
+	}
+}
+
+/**
+ * kvm_pmu_disable_counter - disable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENCLR register
+ *
+ * Call perf_event_disable to stop counting the perf event
+ */
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if (!val)
+		return;
+
+	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
+		if (!(val & BIT(i)))
+			continue;
+
+		pmc = &pmu->pmc[i];
+		if (pmc->perf_event)
+			perf_event_disable(pmc->perf_event);
+	}
+}
-- 
2.0.4
