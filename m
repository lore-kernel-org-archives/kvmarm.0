From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v10 14/21] KVM: ARM64: Add helper to handle PMCR register bits
Date: Wed, 27 Jan 2016 11:51:42 +0800
Message-ID: <1453866709-20324-15-git-send-email-zhaoshenglong@huawei.com>
References: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4103B407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:54:40 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImfS6K7xcqtc for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 Jan 2016 22:54:38 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 166B34053F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 Jan 2016 22:54:32 -0500 (EST)
In-Reply-To: <1453866709-20324-1-git-send-email-zhaoshenglong@huawei.com>
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
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/sys_regs.c |  1 +
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 42 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f45c227..eefc60a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -467,6 +467,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val &= ~ARMV8_PMCR_MASK;
 		val |= p->regval & ARMV8_PMCR_MASK;
 		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = vcpu_sys_reg(vcpu, PMCR_EL0)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index caa706e..5bed00c 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -42,6 +42,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -62,6 +63,7 @@ static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 706c935..d411f3f 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -190,6 +190,48 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
+/**
+ * kvm_pmu_handle_pmcr - handle PMCR register
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCR register
+ */
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	u64 mask;
+	int i;
+
+	mask = kvm_pmu_valid_counter_mask(vcpu);
+	if (val & ARMV8_PMCR_E) {
+		kvm_pmu_enable_counter(vcpu,
+				     vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+	} else {
+		kvm_pmu_disable_counter(vcpu, mask);
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
 static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMCR_E) &&
-- 
2.0.4
