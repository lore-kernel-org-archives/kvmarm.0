From: shannon.zhao@linaro.org
Subject: [PATCH 11/18] KVM: ARM64: Add reset and access handlers for
 PMCNTENSET_EL0 and PMCNTENCLR_EL0 register
Date: Mon,  6 Jul 2015 10:17:41 +0800
Message-ID: <1436149068-3784-12-git-send-email-shannon.zhao@linaro.org>
References: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D21057AE3
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id JmtClqbUBDYd for <kvmarm@lists.cs.columbia.edu>;
 Sun,  5 Jul 2015 22:07:22 -0400 (EDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
 [209.85.220.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 806D957A93
 for <kvmarm@lists.cs.columbia.edu>; Sun,  5 Jul 2015 22:07:22 -0400 (EDT)
Received: by pacws9 with SMTP id ws9so88344633pac.0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 05 Jul 2015 19:18:48 -0700 (PDT)
In-Reply-To: <1436149068-3784-1-git-send-email-shannon.zhao@linaro.org>
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

Since the reset value of PMCNTENSET_EL0 and PMCNTENCLR_EL0 is UNKNOWN,
use reset_unknown for its reset handler. Add access handler which
emulates writing and reading PMCNTENSET_EL0 or PMCNTENCLR_EL0 register.
When writing to PMCNTENSET_EL0, call perf_event_enable to enable the
perf event. When writing to PMCNTENCLR_EL0, call perf_event_disable to
disable the perf event.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c | 56 +++++++++++++++++++++++++++++++++++++++++++++--
 include/kvm/arm_pmu.h     |  4 ++++
 virt/kvm/arm/pmu.c        | 41 ++++++++++++++++++++++++++++++++++
 3 files changed, 99 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 29883df..c14ec8d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -392,6 +392,58 @@ static bool access_pmccntr(struct kvm_vcpu *vcpu,
 	return true;
 }
 
+/* PMCNTENSET_EL0 accessor. */
+static bool access_pmcntenset(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		val = *vcpu_reg(vcpu, p->Rt);
+		if (!p->is_aarch32)
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+		else
+			vcpu_cp15(vcpu, r->reg) |= val & 0xffffffffUL;
+
+		kvm_pmu_enable_counter(vcpu, val);
+	} else {
+		if (!p->is_aarch32)
+			val = vcpu_sys_reg(vcpu, r->reg);
+		else
+			val = vcpu_cp15(vcpu, r->reg);
+		*vcpu_reg(vcpu, p->Rt) = val;
+	}
+
+	return true;
+}
+
+/* PMCNTENCLR_EL0 accessor. */
+static bool access_pmcntenclr(struct kvm_vcpu *vcpu,
+			      const struct sys_reg_params *p,
+			      const struct sys_reg_desc *r)
+{
+	unsigned long val;
+
+	if (p->is_write) {
+		val = *vcpu_reg(vcpu, p->Rt);
+		if (!p->is_aarch32)
+			vcpu_sys_reg(vcpu, r->reg) |= val;
+		else
+			vcpu_cp15(vcpu, r->reg) |= val & 0xffffffffUL;
+
+		kvm_pmu_disable_counter(vcpu, val);
+	} else {
+		if (!p->is_aarch32)
+			val = vcpu_sys_reg(vcpu, r->reg);
+		else
+			val = vcpu_cp15(vcpu, r->reg);
+		*vcpu_reg(vcpu, p->Rt) = val;
+	}
+
+	return true;
+}
+
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	/* DBGBVRn_EL1 */						\
@@ -586,10 +638,10 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	  access_pmcr, reset_pmcr_el0, PMCR_EL0, },
 	/* PMCNTENSET_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b001),
-	  trap_raz_wi },
+	  access_pmcntenset, reset_unknown, PMCNTENSET_EL0 },
 	/* PMCNTENCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b010),
-	  trap_raz_wi },
+	  access_pmcntenclr, reset_unknown, PMCNTENCLR_EL0 },
 	/* PMOVSCLR_EL0 */
 	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b011),
 	  trap_raz_wi },
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 40ab4a0..2cfd9be 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -49,6 +49,8 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, unsigned long select_idx,
 			       unsigned long val);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					unsigned long select_idx);
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val);
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx);
 void kvm_pmu_init(struct kvm_vcpu *vcpu);
@@ -61,6 +63,8 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 {
 	return 0;
 }
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, unsigned long data,
 				    unsigned long select_idx) {}
 static inline void kvm_pmu_init(struct kvm_vcpu *vcpu) {}
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 361fa51..cf59998 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -134,6 +134,47 @@ unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 }
 
 /**
+ * kvm_pmu_enable_counter - enable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENSET_EL0 register
+ *
+ * Call perf_event_enable to start counting the perf event
+ */
+void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	int select_idx = find_first_bit(&val, 32);
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (pmc->perf_event) {
+		local64_set(&pmc->perf_event->count, 0);
+		perf_event_enable(pmc->perf_event);
+		if (pmc->perf_event->state != PERF_EVENT_STATE_ACTIVE)
+			printk("kvm: fail to enable event\n");
+	}
+	pmc->enable = true;
+}
+
+/**
+ * kvm_pmu_disable_counter - disable selected PMU counter
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCNTENCLR_EL0 register
+ *
+ * Call perf_event_disable to stop counting the perf event
+ */
+void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	int select_idx = find_first_bit(&val, 32);
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
+
+	if (pmc->perf_event)
+		perf_event_disable(pmc->perf_event);
+
+	pmc->enable = false;
+}
+
+/**
  * kvm_pmu_find_hw_event - find hardware event
  * @pmu: The pmu pointer
  * @event_select: The number of selected event type
-- 
2.1.0
