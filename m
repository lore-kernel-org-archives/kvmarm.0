From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v8 19/20] KVM: ARM64: Free perf event of PMU when destroying vcpu
Date: Tue, 22 Dec 2015 16:08:14 +0800
Message-ID: <1450771695-11948-20-git-send-email-zhaoshenglong@huawei.com>
References: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450771695-11948-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com, zhaoshenglong@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Shannon Zhao <shannon.zhao@linaro.org>

When KVM frees VCPU, it needs to free the perf_event of PMU.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
---
 arch/arm/kvm/arm.c    |  1 +
 include/kvm/arm_pmu.h |  2 ++
 virt/kvm/arm/pmu.c    | 21 +++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index f54264c..d2c2cc3 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -266,6 +266,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
+	kvm_pmu_vcpu_destroy(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 51dd2d1..bd49cde 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -38,6 +38,7 @@ struct kvm_pmu {
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
@@ -59,6 +60,7 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index e6aac73..3ec3cdd 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -85,6 +85,27 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 	}
 }
 
+/**
+ * kvm_pmu_vcpu_destroy - free perf event of PMU for cpu
+ * @vcpu: The vcpu pointer
+ *
+ */
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	int i;
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	for (i = 0; i < ARMV8_MAX_COUNTERS; i++) {
+		struct kvm_pmc *pmc = &pmu->pmc[i];
+
+		if (pmc->perf_event) {
+			perf_event_disable(pmc->perf_event);
+			perf_event_release_kernel(pmc->perf_event);
+			pmc->perf_event = NULL;
+		}
+	}
+}
+
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
 	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMCR_N_SHIFT;
-- 
2.0.4


