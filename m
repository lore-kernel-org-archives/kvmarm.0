From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v7 14/19] KVM: ARM64: Add helper to handle PMCR register bits
Date: Tue, 15 Dec 2015 16:49:34 +0800
Message-ID: <1450169379-12336-15-git-send-email-zhaoshenglong@huawei.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA93C49680
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:51:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dnZaKTOpZpbn for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Dec 2015 03:51:56 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5B6C841280
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Dec 2015 03:51:54 -0500 (EST)
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

According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
disabled. When writing 1 to PMCR.P, reset all event counters, not
including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
zero.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm64/kvm/sys_regs.c |  1 +
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 40 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f09e500..b2ccc25 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -463,6 +463,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val &= ~ARMV8_PMCR_MASK;
 		val |= p->regval & ARMV8_PMCR_MASK;
 		vcpu_sys_reg(vcpu, r->reg) = val;
+		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = vcpu_sys_reg(vcpu, r->reg)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f5888eb..25b5f98 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -42,6 +42,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 #else
 struct kvm_pmu {
 };
@@ -56,6 +57,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx) {}
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 01af727..e664721 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -130,6 +130,46 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
 }
 
 /**
+ * kvm_pmu_handle_pmcr - handle PMCR register
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCR register
+ */
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	int i;
+
+	if (val & ARMV8_PMCR_E) {
+		kvm_pmu_enable_counter(vcpu,
+				       vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
+	} else {
+		kvm_pmu_disable_counter(vcpu, 0xffffffffUL);
+	}
+
+	if (val & ARMV8_PMCR_C) {
+		pmc = &pmu->pmc[ARMV8_CYCLE_IDX];
+		if (pmc->perf_event)
+			local64_set(&pmc->perf_event->count, 0);
+		vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
+	}
+
+	if (val & ARMV8_PMCR_P) {
+		for (i = 0; i < ARMV8_CYCLE_IDX; i++) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event)
+				local64_set(&pmc->perf_event->count, 0);
+			vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
+		}
+	}
+
+	if (val & ARMV8_PMCR_LC) {
+		pmc = &pmu->pmc[ARMV8_CYCLE_IDX];
+		pmc->bitmask = 0xffffffffffffffffUL;
+	}
+}
+
+/**
  * kvm_pmu_overflow_set - set PMU overflow interrupt
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMOVSSET register
-- 
2.0.4
