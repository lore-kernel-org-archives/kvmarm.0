Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694302571CC
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206437; cv=none; b=bN31Cuq1gD6KEei4Ld/Mw0Vn1vPamuxHSJ+j7zEwfgE7P2dwrtsqcNjg0LlFfBU56wwK8uGlqFiRyVdMVt4LZxDnb3qZ576LsDsph7NnBKW7aiClwjhWNwS9MRJvq+PfVTLnKLV2FtC63OQqrdzcIF4SnfBMaI30TuRluqvCNi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206437; c=relaxed/simple;
	bh=vK1+x/oH4C2L06cHRhyex0jjEkTsnRDWG7XJ6Vehvmc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WVxtEC/To7SjQPGpjDgFoh6nhcdEWMF6TGWBkTVE6mACUUv9z9gVz5hHRIj9DY0/TtJas4gSMFwWi4VtA/9J95wIs6b7hGRBbd73xpHSryRLPnWQcbRotrU05EG/5EdyCWzGM/M7MAuoWBRe2meQZtuP4Vmo2o3M79ykrCdY5DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pX37egNM; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pX37egNM"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fMolSMro59Ca+eo5+KC/3QVyQOdAKcjNGqGIeoq5FRk=;
	b=pX37egNMcod03driNkZK6YqDwy+cYLeVQqpNfNixJN1DJv+w+nCiIm7ve/64y0F60dykck
	qoePi1MZKFIkf01E7ubdhm9yK1Sr4JA4xg6QINPEe0Qw0KRGhidYYwzFHY7SqRDfWAa4Tq
	VGG0WvFdTksKhNeSV+XBkxsFHDj5lh4=
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
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 06/14] KVM: arm64: Drop kvm_arm_pmu_available static key
Date: Wed,  5 Mar 2025 12:26:33 -0800
Message-Id: <20250305202641.428114-7-oliver.upton@linux.dev>
In-Reply-To: <20250305202641.428114-1-oliver.upton@linux.dev>
References: <20250305202641.428114-1-oliver.upton@linux.dev>
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

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/image-vars.h |  5 -----
 arch/arm64/kvm/arm.c           |  4 ++--
 arch/arm64/kvm/pmu-emul.c      | 11 ++++++-----
 include/kvm/arm_pmu.h          | 10 ++--------
 4 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/kernel/image-vars.h b/arch/arm64/kernel/image-vars.h
index ef3a69cc398e..e705c64138ce 100644
--- a/arch/arm64/kernel/image-vars.h
+++ b/arch/arm64/kernel/image-vars.h
@@ -112,11 +112,6 @@ KVM_NVHE_ALIAS(broken_cntvoff_key);
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
index b8e55a441282..dc27d4eb503a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -366,7 +366,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = get_num_wrps();
 		break;
 	case KVM_CAP_ARM_PMU_V3:
-		r = kvm_arm_support_pmu_v3();
+		r = kvm_supports_guest_pmuv3();
 		break;
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
@@ -1388,7 +1388,7 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
-	if (!kvm_arm_support_pmu_v3())
+	if (!kvm_supports_guest_pmuv3())
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
 
 	if (!system_supports_sve())
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 62349b670cf9..120f48136a0f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -17,8 +17,6 @@
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
-DEFINE_STATIC_KEY_FALSE(kvm_arm_pmu_available);
-
 static LIST_HEAD(arm_pmus);
 static DEFINE_MUTEX(arm_pmus_lock);
 
@@ -26,6 +24,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
+bool kvm_supports_guest_pmuv3(void)
+{
+	guard(mutex)(&arm_pmus_lock);
+	return !list_empty(&arm_pmus);
+}
+
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
 {
 	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
@@ -795,9 +799,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
-	if (list_is_singular(&arm_pmus))
-		static_branch_enable(&kvm_arm_pmu_available);
-
 out_unlock:
 	mutex_unlock(&arm_pmus_lock);
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3a8edd78240f..58fc7f932b3f 100644
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
@@ -102,7 +96,7 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
-static inline bool kvm_arm_support_pmu_v3(void)
+static inline bool kvm_supports_guest_pmuv3(void)
 {
 	return false;
 }
-- 
2.39.5

