Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803F1205ACE
	for <kvmarm@lists.linux.dev>; Tue,  3 Dec 2024 19:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733254398; cv=none; b=eAqzhNRfMLIhwnPy0QZDh47yLA/mprttvyqdkuHaa31iP72K6GSL7RxFD/p6anPYCWS+Bua64QVryz1Z3gh/NEKcHyQemVXPbzPwfzEgAD//zWPyOXU+YA5oAbXZnuRO5bg04QQuveidOVlQUK4FNGC7ENNTnkuyaTJ33UHTQC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733254398; c=relaxed/simple;
	bh=h1bpT/FSVrolET1fr2NRJSN5XJvqz3EpxTF9rNAZIqs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yms1kMEBnr/+JLKUneIwVtF52WUuHMPRqS1oRGVrTAPJzs19+vamt/l2fj/7RCAVeq3ZwGchmy0AeG9O8xTU8P+jE4MCJjr7UHPV7OqcJVLsbcuIZ5VLcUvnEWlgaDSMF3UJdmY/TIgJtc596j+ogUXpxCrAaG4NQAWXO+5X7ds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=AedCe+Q5; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="AedCe+Q5"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733254394;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bbQlVHAxkvSIwa5LYGh1m2R9EIUqlg58EDGSc2Wrz5Q=;
	b=AedCe+Q5A6H7Wz3z/akVvXlMa0tCVDUeLqdDIudCQJoz3DuEczw9voNUwGw+k9L/WLxfgN
	7dwDbPG4DYiYMaF7hHVPuLi5CeH3pK7g/fH1sGoUoV61QVKpnx2vjYZjWDAxEpJg0cBjQM
	ZYrwgYlzWD6DUVNAJP1O0vIIcF/lCWY=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [RFC PATCH 08/14] KVM: arm64: Drop kvm_arm_pmu_available static key
Date: Tue,  3 Dec 2024 11:32:14 -0800
Message-Id: <20241203193220.1070811-9-oliver.upton@linux.dev>
In-Reply-To: <20241203193220.1070811-1-oliver.upton@linux.dev>
References: <20241203193220.1070811-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

With the PMUv3 cpucap, kvm_arm_pmu_available is no longer used in the
hot path of guest entry/exit. On top of that, guest support for PMUv3
may not correlate with host support for the feature, e.g. on IMPDEF
hardware.

Throw out the static key and just inspect the list of PMUs to determine
if PMUv3 is supported for KVM guests.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/image-vars.h |  5 -----
 arch/arm64/kvm/arm.c           |  4 ++--
 arch/arm64/kvm/pmu-emul.c      | 11 ++++++-----
 include/kvm/arm_pmu.h          | 13 +------------
 4 files changed, 9 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index 8f5422ed1b75..5919320bc802 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -109,11 +109,6 @@ KVM_NVHE_ALIAS(vgic_v3_cpuif_trap);
 KVM_NVHE_ALIAS(__start___kvm_ex_table);
 KVM_NVHE_ALIAS(__stop___kvm_ex_table);
 
-/* PMU available static key */
-#ifdef CONFIG_HW_PERF_EVENTS
-KVM_NVHE_ALIAS(kvm_arm_pmu_available);
-#endif
-
 /* Position-independent library routines */
 KVM_NVHE_ALIAS_HYP(clear_page, __pi_clear_page);
 KVM_NVHE_ALIAS_HYP(copy_page, __pi_copy_page);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a102c3aebdbc..081e638c674f 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -391,7 +391,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = get_num_wrps();
 		break;
 	case KVM_CAP_ARM_PMU_V3:
-		r = kvm_arm_support_pmu_v3();
+		r = kvm_supports_guest_pmuv3();
 		break;
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
@@ -1397,7 +1397,7 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
-	if (!kvm_arm_support_pmu_v3())
+	if (!kvm_supports_guest_pmuv3())
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
 
 	if (!system_supports_sve())
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 0b2ad60717e8..1ff343d43b61 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -17,14 +17,18 @@
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
-DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
-
 static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
 static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 
+bool kvm_supports_guest_pmuv3(void)
+{
+	guard(mutex)(&arm_pmus_lock);
+	return !list_empty(&arm_pmus);
+}
+
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
 {
 	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
@@ -824,9 +828,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 7ef9eb3cede5..d3dcf5438315 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -37,13 +37,7 @@ struct arm_pmu_entry {
 	struct arm_pmu *arm_pmu;
 };
 
-DECLARE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
-
-static __always_inline bool kvm_arm_support_pmu_v3(void)
-{
-	return static_branch_likely(&kvm_arm_pmu_available);
-}
-
+bool kvm_supports_guest_pmuv3(void);
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
@@ -103,11 +97,6 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
-static inline bool kvm_arm_support_pmu_v3(void)
-{
-	return false;
-}
-
 #define kvm_arm_pmu_irq_initialized(v)	(false)
 static inline u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu,
 					    u64 select_idx)
-- 
2.39.5

