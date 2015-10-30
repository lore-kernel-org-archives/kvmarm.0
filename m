From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: [PATCH v4 20/21] KVM: ARM64: Free perf event of PMU when destroying vcpu
Date: Fri, 30 Oct 2015 14:22:02 +0800
Message-ID: <1446186123-11548-21-git-send-email-zhaoshenglong@huawei.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, zhaoshenglong@huawei.com
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
index 9c0fec4..90ddb93 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -259,6 +259,7 @@ void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_caches(vcpu);
 	kvm_timer_vcpu_terminate(vcpu);
 	kvm_vgic_vcpu_destroy(vcpu);
+	kvm_pmu_vcpu_destroy(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e708c49..f2cd8d9 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,6 +40,7 @@ struct kvm_pmu {
 
 #ifdef CONFIG_KVM_ARM_PMU
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu);
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx);
@@ -53,6 +54,7 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u32 data,
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u32 val);
 #else
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 void kvm_pmu_post_sync_hwstate(struct kvm_vcpu *vcpu) {}
 unsigned long kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u32 select_idx)
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 84720a2..d78ce7b 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -89,6 +89,27 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
 }
 
 /**
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
+/**
  * kvm_pmu_sync_hwstate - sync pmu state for cpu
  * @vcpu: The vcpu pointer
  *
-- 
2.0.4


