From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 74/95] arm64: KVM: Free perf event of PMU when destroying vcpu
Date: Wed,  9 Mar 2016 07:31:08 +0000
Message-ID: <1457508689-19672-75-git-send-email-marc.zyngier@arm.com>
References: <1457508689-19672-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4DD948529
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:16 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJbLZin6jOZY for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2016 02:35:15 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B112049B9E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2016 02:35:15 -0500 (EST)
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

When KVM frees VCPU, it needs to free the perf_event of PMU.

Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c    |  1 +
 include/kvm/arm_pmu.h |  2 ++
 virt/kvm/arm/pmu.c    | 21 +++++++++++++++++++++
 3 files changed, 24 insertions(+)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c5e9591..9d133df 100644
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
index b4993eb..9f87d71 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -43,6 +43,7 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
+void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val);
@@ -69,6 +70,7 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 	return 0;
 }
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_overflow_set(struct kvm_vcpu *vcpu, u64 val) {}
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 1dbbc2c..9b83857 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -101,6 +101,27 @@ void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu)
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
+	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
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
 	u64 val = vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
-- 
2.1.4
