From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v6 17/21] KVM: ARM64: Add helper to handle PMCR register bits
Date: Tue, 8 Dec 2015 20:47:36 +0800
Message-ID: <1449578860-15808-18-git-send-email-zhaoshenglong@huawei.com>
References: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 788CF412A2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:47:13 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id u2P9TcVs+LWe for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Dec 2015 07:47:12 -0500 (EST)
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [58.251.152.64])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EAF70407A6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Dec 2015 07:47:09 -0500 (EST)
In-Reply-To: <1449578860-15808-1-git-send-email-zhaoshenglong@huawei.com>
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
 arch/arm64/kvm/sys_regs.c |  2 ++
 include/kvm/arm_pmu.h     |  2 ++
 virt/kvm/arm/pmu.c        | 51 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 55 insertions(+)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9baa654..110b288 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -620,6 +620,7 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
 			val &= ~ARMV8_PMCR_MASK;
 			val |= p->regval & ARMV8_PMCR_MASK;
 			vcpu_sys_reg(vcpu, r->reg) = val;
+			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
 		case PMCEID0_EL0:
@@ -1218,6 +1219,7 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
 			val &= ~ARMV8_PMCR_MASK;
 			val |= p->regval & ARMV8_PMCR_MASK;
 			vcpu_cp15(vcpu, r->reg) = val;
+			kvm_pmu_handle_pmcr(vcpu, val);
 			break;
 		}
 		case c9_PMCEID0:
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index d12450a..a131f76 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -46,6 +46,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx);
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
 {
@@ -58,6 +59,7 @@ void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u32 val) {}
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 				    u32 select_idx) {}
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val) {}
 #endif
 
 #endif
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 093e211..9b9c706 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -151,6 +151,57 @@ static u32 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 
 /**
+ * kvm_pmu_handle_pmcr - handle PMCR register
+ * @vcpu: The vcpu pointer
+ * @val: the value guest writes to PMCR register
+ */
+void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+	struct kvm_pmc *pmc;
+	u32 enable;
+	int i;
+
+	if (val & ARMV8_PMCR_E) {
+		if (!vcpu_mode_is_32bit(vcpu))
+			enable = vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		else
+			enable = vcpu_cp15(vcpu, c9_PMCNTENSET);
+
+		kvm_pmu_enable_counter(vcpu, enable, true);
+	} else {
+		kvm_pmu_disable_counter(vcpu, 0xffffffffUL);
+	}
+
+	if (val & ARMV8_PMCR_C) {
+		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
+		if (pmc->perf_event)
+			local64_set(&pmc->perf_event->count, 0);
+		if (!vcpu_mode_is_32bit(vcpu))
+			vcpu_sys_reg(vcpu, PMCCNTR_EL0) = 0;
+		else
+			vcpu_cp15(vcpu, c9_PMCCNTR) = 0;
+	}
+
+	if (val & ARMV8_PMCR_P) {
+		for (i = 0; i < ARMV8_MAX_COUNTERS - 1; i++) {
+			pmc = &pmu->pmc[i];
+			if (pmc->perf_event)
+				local64_set(&pmc->perf_event->count, 0);
+			if (!vcpu_mode_is_32bit(vcpu))
+				vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i) = 0;
+			else
+				vcpu_cp15(vcpu, c14_PMEVCNTR0 + i) = 0;
+		}
+	}
+
+	if (val & ARMV8_PMCR_LC) {
+		pmc = &pmu->pmc[ARMV8_MAX_COUNTERS - 1];
+		pmc->bitmask = 0xffffffffffffffffUL;
+	}
+}
+
+/**
  * kvm_pmu_overflow_clear - clear PMU overflow interrupt
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMOVSCLR register
-- 
2.0.4
