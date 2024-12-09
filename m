Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA51D154BFC
	for <kvmarm@lists.linux.dev>; Mon,  9 Dec 2024 18:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733767795; cv=none; b=OvP1/k5ksYDWPrnAq2s77WTXwaNjpo5KwFbeQi16lOam20M6MuDHLvOmhM6zv65u6HQB85R1gXoTElkVRaIRUdZ9Qwyb01xqa6KA9cZJsmHS2dYyIuFWAiOwTcHzT7b2gIqCrQ9N64TCGUDLFo0+57QmveVEK4Uwyg+HkNha7oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733767795; c=relaxed/simple;
	bh=S0ZYnz2jGMtTuKQ6qQq3Q336BA2A+heQnezQf4HgYTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=P4CQMxMJmEJyPJ7ucr/KD6QmqQsK4Poz5PRmpNviRBjxYdiKQRUjbosWgo1AZKTfArRrMhnGe/a7MikvIXoPDdhwXPWyiR99WPZ8bTrxhOTNY/fOfQ4ocnTWKnqgCAL294DfxNbIVbJe4rNPnyZE4i8bAWkpKSNJgF9TgbM8G2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=HlG+aKp7; arc=none smtp.client-ip=91.218.175.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="HlG+aKp7"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1733767790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cHz1Ut8+bQs8ibeP2uZah6McNBvlhMlR671FDk6LG44=;
	b=HlG+aKp7vMfuDL/wuh1rGs6VUf81ML+wziBp1LmZHjb7RQa674hDLpRYAjIrsMZ9bk4hro
	3LJuCv7vyH0ubkiTFLItH9os0Bt6P3MKhzivH7OrclT40AvCLgu65/KzyXVfT4O74jfwO/
	bQRCfBoL8lsx8rDbGlk33XCH9jlsCQk=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 03/16] KVM: arm64: Track presence of SPE/TRBE in kvm_host_data instead of vCPU
Date: Mon,  9 Dec 2024 10:09:13 -0800
Message-Id: <20241209180926.2161373-4-oliver.upton@linux.dev>
In-Reply-To: <20241209180926.2161373-1-oliver.upton@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Add flags to kvm_host_data to track if SPE/TRBE is present +
programmable on a per-CPU basis. Set the flags up at init rather than
vcpu_load() as the programmability of these buffers is unlikely to
change.

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h  | 19 +++++++++-------
 arch/arm64/kvm/arm.c               |  3 ---
 arch/arm64/kvm/debug.c             | 36 ++++++++----------------------
 arch/arm64/kvm/hyp/nvhe/debug-sr.c |  8 +++----
 4 files changed, 24 insertions(+), 42 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 064f5dfca7f4..fb252d540850 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -610,6 +610,10 @@ struct cpu_sve_state {
  * field.
  */
 struct kvm_host_data {
+#define KVM_HOST_DATA_FLAG_HAS_SPE	0
+#define KVM_HOST_DATA_FLAG_HAS_TRBE	1
+	unsigned long flags;
+
 	struct kvm_cpu_context host_ctxt;
 
 	/*
@@ -911,10 +915,6 @@ struct kvm_vcpu_arch {
 #define EXCEPT_AA64_EL2_SERR	__vcpu_except_flags(7)
 /* Guest debug is live */
 #define DEBUG_DIRTY		__vcpu_single_flag(iflags, BIT(4))
-/* Save SPE context if active  */
-#define DEBUG_STATE_SAVE_SPE	__vcpu_single_flag(iflags, BIT(5))
-/* Save TRBE context if active  */
-#define DEBUG_STATE_SAVE_TRBE	__vcpu_single_flag(iflags, BIT(6))
 
 /* SVE enabled for host EL0 */
 #define HOST_SVE_ENABLED	__vcpu_single_flag(sflags, BIT(0))
@@ -1310,6 +1310,13 @@ DECLARE_KVM_HYP_PER_CPU(struct kvm_host_data, kvm_host_data);
 	 &this_cpu_ptr_hyp_sym(kvm_host_data)->f)
 #endif
 
+#define host_data_test_flag(flag)					\
+	(test_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags)))
+#define host_data_set_flag(flag)					\
+	set_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
+#define host_data_clear_flag(flag)					\
+	clear_bit(KVM_HOST_DATA_FLAG_##flag, host_data_ptr(flags))
+
 /* Check whether the FP regs are owned by the guest */
 static inline bool guest_owns_fp_regs(void)
 {
@@ -1370,10 +1377,6 @@ static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
 	return (!has_vhe() && attr->exclude_host);
 }
 
-/* Flags for host debug state */
-void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
-void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
-
 #ifdef CONFIG_KVM
 void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
 void kvm_clr_pmu_events(u64 clr);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ab1bf9ccf385..3822774840e1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -617,15 +617,12 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	vcpu_set_pauth_traps(vcpu);
 
-	kvm_arch_vcpu_load_debug_state_flags(vcpu);
-
 	if (!cpumask_test_cpu(cpu, vcpu->kvm->arch.supported_cpus))
 		vcpu_set_on_unsupported_cpu(vcpu);
 }
 
 void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 {
-	kvm_arch_vcpu_put_debug_state_flags(vcpu);
 	kvm_arch_vcpu_put_fp(vcpu);
 	if (has_vhe())
 		kvm_vcpu_put_vhe(vcpu);
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d8ea6fe6a2a2..1ee2fd765b62 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -294,40 +294,22 @@ void kvm_arm_clear_debug(struct kvm_vcpu *vcpu)
 	}
 }
 
-void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
+void kvm_init_host_debug_data(void)
 {
-	u64 dfr0;
+	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
+
+	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
+		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
+							      read_sysreg(pmcr_el0));
 
-	/* For VHE, there is nothing to do */
 	if (has_vhe())
 		return;
 
-	dfr0 = read_sysreg(id_aa64dfr0_el1);
-	/*
-	 * If SPE is present on this CPU and is available at current EL,
-	 * we may need to check if the host state needs to be saved.
-	 */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_PMSVer_SHIFT) &&
-	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(PMBIDR_EL1_P_SHIFT)))
-		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_SPE);
+	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
+		host_data_set_flag(HAS_SPE);
 
-	/* Check if we have TRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceBuffer_SHIFT) &&
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_EL1_P))
-		vcpu_set_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
-}
-
-void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
-{
-	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_SPE);
-	vcpu_clear_flag(vcpu, DEBUG_STATE_SAVE_TRBE);
-}
-
-void kvm_init_host_debug_data(void)
-{
-	u64 dfr0 = read_sysreg(id_aa64dfr0_el1);
-
-	if (cpuid_feature_extract_signed_field(dfr0, ID_AA64DFR0_EL1_PMUVer_SHIFT) > 0)
-		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
-							      read_sysreg(pmcr_el0));
+		host_data_set_flag(HAS_TRBE);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 1e2a26d0196e..858bb38e273f 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -82,10 +82,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
+	if (host_data_test_flag(HAS_SPE))
 		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
+	if (host_data_test_flag(HAS_TRBE))
 		__debug_save_trace(host_data_ptr(host_debug_state.trfcr_el1));
 }
 
@@ -96,9 +96,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_SPE))
+	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
-	if (vcpu_get_flag(vcpu, DEBUG_STATE_SAVE_TRBE))
+	if (host_data_test_flag(HAS_TRBE))
 		__debug_restore_trace(*host_data_ptr(host_debug_state.trfcr_el1));
 }
 
-- 
2.39.5

