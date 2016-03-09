From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 70/95] arm64: KVM: Add helper to handle PMCR register bits
Date: Wed,  9 Mar 2016 07:31:04 +0000
Message-ID: <1457508689-19672-71-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4630B412ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wTah1Euh+0j4 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:05 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36E55412A6
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:04 -0500 (EST)
In-Reply-To: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

According to ARMv8 spec, when writing 1 to PMCR.E, all counters are
enabled by PMCNTENSET, while writing 0 to PMCR.E, all counters are
disabled. When writing 1 to PMCR.P, reset all event counters, not
including PMCCNTR, to zero. When writing 1 to PMCR.C, reset PMCCNTR to
zero.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/kvm_perf_event.h |  4 +++-
 arch/arm64/kvm/sys_regs.c               |  1 +
 include/kvm/arm_pmu.h                   |  2 ++
 virt/kvm/arm/pmu.c                      | 34 +++++++++++++++++++++++++++++++++
 4 files changed, 40 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_perf_event.h b/arch/arm64/include/asm/kvm_perf_event.h
index 62fa60f..6d080c0 100644
--- a/arch/arm64/include/asm/kvm_perf_event.h
+++ b/arch/arm64/include/asm/kvm_perf_event.h
@@ -29,9 +29,11 @@
 #define ARMV8_PMU_PMCR_D	(1 << 3) /* CCNT counts every 64th cpu cycle */
 #define ARMV8_PMU_PMCR_X	(1 << 4) /* Export to ETM */
 #define ARMV8_PMU_PMCR_DP	(1 << 5) /* Disable CCNT if non-invasive debug*/
+/* Determines which bit of PMCCNTR_EL0 generates an overflow */
+#define ARMV8_PMU_PMCR_LC	(1 << 6)
 #define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
 #define	ARMV8_PMU_PMCR_N_MASK	0x1f
-#define	ARMV8_PMU_PMCR_MASK	0x3f	 /* Mask for writable bits */
+#define	ARMV8_PMU_PMCR_MASK	0x7f	 /* Mask for writable bits */
 
 /*
  * PMOVSR: counters overflow flag status reg
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 10e5379..12f36ef 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -467,6 +467,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
 		vcpu_sys_reg(vcpu, PMCR_EL0) = val;
+		kvm_pmu_handle_pmcr(vcpu, val);
 	} else {
 		/* PMCR.P & PMCR.C are RAZ */
 		val = vcpu_sys_reg(vcpu, PMCR_EL0)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 348c4c9..8bc92d1 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -45,6 +45,7 @@ void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 #else
@@ -67,6 +68,7 @@ static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 9fc775e..cda869c 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -210,6 +210,40 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
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
+	if (val & ARMV8_PMU_PMCR_E) {
+		kvm_pmu_enable_counter(vcpu,
+				vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
+	} else {
+		kvm_pmu_disable_counter(vcpu, mask);
+	}
+
+	if (val & ARMV8_PMU_PMCR_C)
+		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
+
+	if (val & ARMV8_PMU_PMCR_P) {
+		for (i = 0; i < ARMV8_PMU_CYCLE_IDX; i++)
+			kvm_pmu_set_counter_value(vcpu, i, 0);
+	}
+
+	if (val & ARMV8_PMU_PMCR_LC) {
+		pmc = &pmu->pmc[ARMV8_PMU_CYCLE_IDX];
+		pmc->bitmask = 0xffffffffffffffffUL;
+	}
+}
+
 static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
 {
 	return (vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) &&
-- 
2.1.4
