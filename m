From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v2 12/22] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET and PMCNTENCLR register
Date: Fri, 11 Sep 2015 16:55:05 +0800
Message-ID: <1441961715-11688-13-git-send-email-zhaoshenglong@huawei.com>
References: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC8D3412FA
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lL0MsZhwblnl for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2015 04:55:46 -0400 (EDT)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D317047036
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2015 04:55:39 -0400 (EDT)
In-Reply-To: <1441961715-11688-1-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, shannon.zhao@linaro.org
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
 arch/arm64/kvm/sys_regs.c | 46 +++++++++++++++++++++++++++++++++++++++++----
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 48 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f8d7de0..8307189 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -293,6 +293,24 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 						       val);
 			break;
 		}
+		case PMCNTENSET_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val);
+			/*Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled */
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+			vcpu_sys_reg(vcpu, PMCNTENCLR_EL0) |= val;
+			break;
+		}
+		case PMCNTENCLR_EL0: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/*Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled */
+			vcpu_sys_reg(vcpu, r->reg) &= ~val;
+			vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
+			break;
+		}
 		case PMCR_EL0: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_sys_reg(vcpu, r->reg);
@@ -525,10 +543,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
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
@@ -749,6 +767,24 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 						       val);
 			break;
 		}
+		case c9_PMCNTENSET: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_enable_counter(vcpu, val);
+			/*Value 1 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter enabled */
+			vcpu_cp15(vcpu, r->reg) |= val;
+			vcpu_cp15(vcpu, c9_PMCNTENCLR) |= val;
+			break;
+		}
+		case c9_PMCNTENCLR: {
+			val = *vcpu_reg(vcpu, p->Rt);
+			kvm_pmu_disable_counter(vcpu, val);
+			/*Value 0 of PMCNTENSET_EL0 and PMCNTENCLR_EL0 means
+			 * corresponding counter disabled */
+			vcpu_cp15(vcpu, r->reg) &= ~val;
+			vcpu_cp15(vcpu, c9_PMCNTENSET) &= ~val;
+			break;
+		}
 		case c9_PMCR: {
 			/* Only update writeable bits of PMCR */
 			val = vcpu_cp15(vcpu, r->reg);
@@ -817,8 +853,10 @@ static const struct sys_reg_desc cp15_regs[] = {
 	/* PMU */
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 0), access_pmu_cp15_regs,
 	  reset_pmcr, c9_PMCR },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
-	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMCNTENSET },
+	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), access_pmu_cp15_regs,
+	  reset_unknown_cp15, c9_PMCNTENCLR },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
 	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
 	  reset_unknown_cp15, c9_PMSELR },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 387ec6f..59e70af 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -39,6 +39,8 @@ struct kvm_pmu {
 #ifdef CONFIG_KVM_ARM_PMU
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					unsigned long select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx);
 #else
@@ -47,6 +49,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 0c7fe5c..c6cdc4e 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -115,6 +115,54 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 }
 
 /**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET register
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	for (i = 0; i < 32; i++) {
+		if ((val >> i) & 0x1) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event) {
+				perf_event_enable(pmc->perf_event);
+				if (pmc->perf_event->state
+				    != PERF_EVENT_STATE_ACTIVE)
+					kvm_debug("fail to enable event\n");
+			}
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
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+
+	for (i = 0; i < 32; i++) {
+		if ((val >> i) & 0x1) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event)
+				perf_event_disable(pmc->perf_event);
+		}
+	}
+}
+
+/**
  * kvm_pmu_find_hw_event - find hardware event
  * @pmu: The pmu pointer
  * @event_select: The number of selected event type
-- 
2.0.4
