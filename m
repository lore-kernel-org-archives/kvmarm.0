Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A6B1FBEB7
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470490; cv=none; b=ohen8eVw5gIntUhGscvD501RqBbFkX12wj3HTAwrtwfPysSvM0vOAvY+OIjq3T4TH2ok7J+UkoXXTl7wB6TZCpnHtiFE2Qpm5DpBlp15+hzqc0M4V3kK9q+gBZOFAbNYLVWg2xsdtHboY9UA3oGWg4sVXTzN0wiNZW+iHRw0US4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470490; c=relaxed/simple;
	bh=DOye4xIOa3nwplZo3TdCdVs12KW3vKRKL3DFnkaLT3g=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LfUXOH++NIovuSYtXHKY3n6DijbCvOK3dOl0Xp0Ve5xxxPq/fTyn+Egf/GR9yZnzgHLjSMRWas+G4ObgL9JDG7XLDe4Gw/77HqNlSVtiJNuzUUCWrvA9z/FvbF+BKxG2PcVLuTAbGfu/0IiCE8dLR06M39NLtbyqCg29Jz/HoU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=jGTWKqhV; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="jGTWKqhV"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470485;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6SQwzTk2E2amZdprtST0cKKyp5nJbG4/LtiuybIBSxk=;
	b=jGTWKqhVbpZZd5jgU84mQ5ES1HboPFBTX6JGwTQPEp3dMQ/IPXfZwfUAA8RQaDDyq8hAN6
	blhyafJUt9UHEWPsZP2SHem2RDN727+vC0P77zhSwAW2aqmmeH/3VHrH688cjgNhEIchtI
	00hGP0J/Sedi1eEvV6xe0baOYIjfdGs=
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
Subject: [PATCH 09/18] KVM: arm64: Drop kvm_arm_pmu_available static key
Date: Tue, 17 Dec 2024 13:20:39 -0800
Message-Id: <20241217212048.3709204-10-oliver.upton@linux.dev>
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
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
index 6d7fc0051ad8..33cd694c754f 100644
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
@@ -826,9 +830,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
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

