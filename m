From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v5 11/21] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET and PMCNTENCLR register
Date: Thu, 3 Dec 2015 14:11:21 +0800
Message-ID: <1449123091-20252-12-git-send-email-zhaoshenglong@huawei.com>
References: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 41FAE499E3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0NqaZK6AGeHu for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2015 01:11:27 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B602B4992F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2015 01:11:22 -0500 (EST)
In-Reply-To: <1449123091-20252-1-git-send-email-zhaoshenglong@huawei.com>
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
reset_unknown for its reset handler. Add a new case to emulate writing
PMCNTENSET or PMCNTENCLR register.

When writing to PMCNTENSET, call perf_event_enable to enable the perf
event. When writing to PMCNTENCLR, call perf_event_disable to disable
the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 52 +++++++++++++++++++++++++++++++++++++++++++----
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 47 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9e06fe8..e852e5d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -526,6 +526,27 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + idx) = val;
 			break;
 		}
+		case PMCNTENSET_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val,
+				   vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E);
+			/* Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled.
+			 */
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMCNTENCLR_EL0) |= val;
+			break;
+		}
+		case PMCNTENCLR_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/* Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled.
+			 */
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -764,10 +785,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmu_regs, reset_pmcr, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCNTENSET_EL0 },
 	/* PMCNTENCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmu_regs, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
 	  trap_raz_wi },
@@ -1037,6 +1058,27 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			vcpu_cp15(vcpu, c14_PMEVTYPER0 + idx) = val;
 			break;
 		}
+		case c9_PMCNTENSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val,
+				       vcpu_cp15(vcpu, c9_PMCR) & ARMV8_PMCR_E);
+			/* Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled.
+			 */
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMCNTENCLR) |= val;
+			break;
+		}
+		case c9_PMCNTENCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/* Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled.
+			 */
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMCNTENSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -1118,8 +1160,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
 	  NULL, c9_PMCR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmu_cp15_regs,
+	  NULL, c9_PMCNTENSET },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
+	  NULL, c9_PMCNTENCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  NULL, c9_PMSELR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 59d9085..fff8f15 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,6 +40,8 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
 #else
@@ -47,6 +49,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 6c50003..0d143ca 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -79,6 +79,53 @@ static void kvm_pmu_stop_counter(struct kvm_pmc *pmc)
 }
 
 /**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET register
+ * @all_enable: the value of PMCR.E
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u32 val, bool all_enable)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	if (!all_enable)
+		return;
+
+	for_each_set_bit(i, (const unsigned long *)&val, ARMV8_MAX_COUNTERS) {
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
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u32 val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	for_each_set_bit(i, (const unsigned long *)&val, ARMV8_MAX_COUNTERS) {
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
