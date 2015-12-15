From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v7 10/19] KVM: ARM64: Add access handler for PMCNTENSET and
 PMCNTENCLR register
Date: Tue, 15 Dec 2015 16:49:30 +0800
Message-ID: <1450169379-12336-11-git-send-email-zhaoshenglong@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 487ED49785
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:49:21 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BMwpvXcJZ-Pf for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 03:49:20 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2176941280
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:49:18 -0500 (EST)
In-Reply-To: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
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
Cc: kvm@vger.kernel.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
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
 arch/arm64/kvm/sys_regs.c | 41 +++++++++++++++++++++++++++++++----
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 55 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dc6bb26..f216da7 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -615,6 +615,39 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMCR_N_SHIFT;
+
+	val &= ARMV8_PMCR_N_MASK;
+	return GENMASK(val - 1, 0) | BIT(ARMV8_CYCLE_IDX);
+}
+
+static bool access_pmcntenset(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	u64 val, mask;
+
+	mask = kvm_pmu_valid_counter_mask(vcpu);
+	if (p->is_write) {
+		val = p->regval & mask;
+		if (r->Op2 & 0x1) {
+			/* accessing PMCNTENSET_EL0 */
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			kvm_pmu_enable_counter(vcpu, val);
+		} else {
+			/* accessing PMCNTENCLR_EL0 */
+			vcpu_sys_reg(vcpu, r->reg) &= mask;
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			kvm_pmu_disable_counter(vcpu, val);
+		}
+	} else {
+		p->regval = vcpu_sys_reg(vcpu, r->reg) & mask;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -816,10 +849,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcr, reset_pmcr, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmcntenset, reset_unknown, PMCNTENSET_EL0 },
 	/* PMCNTENCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmcntenset, NULL, PMCNTENSET_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
 	  trap_raz_wi },
@@ -1161,8 +1194,8 @@ static const struct sys_reg_desc cp15_regs[] = {
 
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmcr },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmcntenset },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmcntenset },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmselr },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), access_pmceid },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 14bedb0..43c4117 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -36,6 +36,8 @@ struct kvm_pmu {
 };
 
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -46,6 +48,8 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index b107fb8..94bff0e 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -75,6 +75,61 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc)
 }
 
 /**
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
+	if (!(vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) || !val)
+		return;
+
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if (!((val >> i) & 0x1))
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
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		if (!((val >> i) & 0x1))
+			continue;
+
+		pmc = &pmu->pmc[i];
+		if (pmc->perf_event)
+			perf_event_disable(pmc->perf_event);
+	}
+}
+
+/**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
  * @data: The data guest writes to PMXEVTYPER_EL0
-- 
2.0.4
