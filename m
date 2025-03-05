Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A7A725A2D2
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206433; cv=none; b=OOHhQ1Dnfs1HMUI8/u+OzwLIbXubdPi41xG/4Z6Ypw6bYsByUP+8oO2Oi9A9oNcfkB1bjrEnddisSubklc3OiQ0XbQ6g99v0KdsGIzfpe3J88NwfLfpf4+tWIjOwSX+X4j+BgEzQpdw8RLzfj5N5b25oCRk7KR7XuwOr5Z1LEa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206433; c=relaxed/simple;
	bh=AwuECbKM6eCDyCx3x5BYpkKPLS5ibK9me7opmyzr5a8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sE5khCb5CnvclHXTIuUgZSBK5rzjzXfU2dhz6/ezppMQ6+KxXRfIsu5yigJo3hTYYYSA+4SdA+qsUfrV08epLfhcP9ZznJhX6mTzBG25PGqOm/DC6PbGUQ97dCi1Bx6ET6VM069QiX62W7o+ATo0+LJaz4wd4ZMWGpApT62xel0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=gYoTh6f1; arc=none smtp.client-ip=95.215.58.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="gYoTh6f1"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mi1XMcQcbK6K358IcTKG6ZBCQ8Wr+Tcqk+OJxyY+WuA=;
	b=gYoTh6f1jnEqxMed8Twec9WKr1UZ1j5M4K3FBegYEm9cf0klPbsOZkujn1shCl2WqeSg9P
	Ntj7XMT1zry3/nogC9yC2owhfBHIeLGh+2rqxAv1j6i6v9p6zJS4ZmEByTfUMbGfq4g/io
	hCx+UGUOvf0+dW1jWT7OCDhdRxzVK0I=
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
Subject: [PATCH v3 05/14] KVM: arm64: Use a cpucap to determine if system supports FEAT_PMUv3
Date: Wed,  5 Mar 2025 12:26:32 -0800
Message-Id: <20250305202641.428114-6-oliver.upton@linux.dev>
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

KVM is about to learn some new tricks to virtualize PMUv3 on IMPDEF
hardware. As part of that, we now need to differentiate host support
from guest support for PMUv3.

Add a cpucap to determine if an architectural PMUv3 is present to guard
host usage of PMUv3 controls.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/cpucaps.h        |  2 ++
 arch/arm64/include/asm/cpufeature.h     |  5 +++++
 arch/arm64/kernel/cpufeature.c          | 28 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/kvm/pmu.c                    | 10 ++++-----
 arch/arm64/tools/cpucaps                |  1 +
 include/kvm/arm_pmu.h                   |  2 +-
 7 files changed, 44 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 0b5ca6e0eb09..9d769291a306 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
 		 * KVM MPAM support doesn't rely on the host kernel supporting MPAM.
 		*/
 		return true;
+	case ARM64_HAS_PMUV3:
+		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
 	}
 
 	return true;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e0e4478f5fb5..0eff048848b8 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -866,6 +866,11 @@ static __always_inline bool system_supports_mpam_hcr(void)
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
+static inline bool system_supports_pmuv3(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_PMUV3);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index d561cf3b8ac7..ce2c1e688d8c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1898,6 +1898,26 @@ static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
 }
 #endif
 
+static bool has_pmuv3(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	unsigned int pmuver;
+
+	/*
+	 * PMUVer follows the standard ID scheme for an unsigned field with the
+	 * exception of 0xF (IMP_DEF) which is treated specially and implies
+	 * FEAT_PMUv3 is not implemented.
+	 *
+	 * See DDI0487L.a D24.1.3.2 for more details.
+	 */
+	pmuver = cpuid_feature_extract_unsigned_field(dfr0,
+						      ID_AA64DFR0_EL1_PMUVer_SHIFT);
+	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return false;
+
+	return pmuver >= ID_AA64DFR0_EL1_PMUVer_IMP;
+}
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define KPTI_NG_TEMP_VA		(-(1UL << PMD_SHIFT))
 
@@ -2998,6 +3018,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, GCS, IMP)
 	},
+#endif
+#ifdef CONFIG_HW_PERF_EVENTS
+	{
+		.desc = "PMUv3",
+		.capability = ARM64_HAS_PMUV3,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_pmuv3,
+	},
 #endif
 	{},
 };
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 23bbe28eaaf9..b741ea6aefa5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -244,7 +244,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	 * counter, which could make a PMXEVCNTR_EL0 access UNDEF at
 	 * EL1 instead of being trapped to EL2.
 	 */
-	if (kvm_arm_support_pmu_v3()) {
+	if (system_supports_pmuv3()) {
 		struct kvm_cpu_context *hctxt;
 
 		write_sysreg(0, pmselr_el0);
@@ -281,7 +281,7 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	write_sysreg(*host_data_ptr(host_debug_state.mdcr_el2), mdcr_el2);
 
 	write_sysreg(0, hstr_el2);
-	if (kvm_arm_support_pmu_v3()) {
+	if (system_supports_pmuv3()) {
 		struct kvm_cpu_context *hctxt;
 
 		hctxt = host_data_ptr(host_ctxt);
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 0b3adf3e17b4..6b48a3d16d0d 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -41,7 +41,7 @@ void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3() || !kvm_pmu_switch_needed(attr))
+	if (!system_supports_pmuv3() || !kvm_pmu_switch_needed(attr))
 		return;
 
 	if (!attr->exclude_host)
@@ -57,7 +57,7 @@ void kvm_clr_pmu_events(u64 clr)
 {
 	struct kvm_pmu_events *pmu = kvm_get_pmu_events();
 
-	if (!kvm_arm_support_pmu_v3())
+	if (!system_supports_pmuv3())
 		return;
 
 	pmu->events_host &= ~clr;
@@ -133,7 +133,7 @@ void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_events *pmu;
 	u64 events_guest, events_host;
 
-	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+	if (!system_supports_pmuv3() || !has_vhe())
 		return;
 
 	preempt_disable();
@@ -154,7 +154,7 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)
 	struct kvm_pmu_events *pmu;
 	u64 events_guest, events_host;
 
-	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+	if (!system_supports_pmuv3() || !has_vhe())
 		return;
 
 	pmu = kvm_get_pmu_events();
@@ -180,7 +180,7 @@ bool kvm_set_pmuserenr(u64 val)
 	struct kvm_cpu_context *hctxt;
 	struct kvm_vcpu *vcpu;
 
-	if (!kvm_arm_support_pmu_v3() || !has_vhe())
+	if (!system_supports_pmuv3() || !has_vhe())
 		return false;
 
 	vcpu = kvm_get_running_vcpu();
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1e65f2fb45bd..ee4316cb3690 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -45,6 +45,7 @@ HAS_LSE_ATOMICS
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_PAN
+HAS_PMUV3
 HAS_S1PIE
 HAS_S1POE
 HAS_RAS_EXTN
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 147bd3ee4f7b..3a8edd78240f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -86,7 +86,7 @@ void kvm_vcpu_pmu_resync_el0(void);
  */
 #define kvm_pmu_update_vcpu_events(vcpu)				\
 	do {								\
-		if (!has_vhe() && kvm_arm_support_pmu_v3())		\
+		if (!has_vhe() && system_supports_pmuv3())		\
 			vcpu->arch.pmu.events = *kvm_get_pmu_events();	\
 	} while (0)
 
-- 
2.39.5

