Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF74366806
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332261; cv=none; b=C2pP1o8DPuP+kiQGrK6Dkh10hHuYrHPFBmImAynuQpAJk+11k+cg0s91PeoTpNx32QYLRxNT7O/rzQscqwW3AyZw6pRtVA6jHlPhfuVheXZLbGMZG6Hfg/HKLU+r6Yyh+FWjUY7qc38EHDmTuSNwG22MWidZO92qdIBgyfaFVcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332261; c=relaxed/simple;
	bh=Zrer7klNxFYNjOSCWy3rQnGgV7jKhFmWE8tYanAzBls=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=kHMvAJU5DeY38bIMp8ZTn8Av28s6wJV9FPNxCT3dHFv7yri36mwMfX8QgWpb9io8Fxmuh3OsH0AHNBbbRiNVmFjeaTObE3aq0MhNV0EyrAQyT9cjnqF9LsfN51WQg6mOaC60awGWQpWd2JSqQ6qxbB6xV5GETES/Lz/TXFDIgTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=qUDt8Neb reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="qUDt8Neb"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 666A3TQ8013128
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 6 Jul 2026 19:03:44 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=oK+YJdhItWoaV2JEF0iLTogYbuLuNDgUBo7W91MWRuw=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783332224; v=1;
        b=qUDt8Neb077mCO0lX3NOgfcHYC58NRL46RfIXuOKTeTcUI05tWSYT7OxJUZBC1uC
         pFGZL/SHnRAMzvTDnXIURQiK3opEDRTlZP0gSqVSx74FRC7zUpTLFn63bodrSk6R
         7UjBCDPNZnCgZgRHbW3oDoV3MqB2qZnz5bgd4ikY46O0uZuispgT/CwZqk/HsJ0X
         dN3oo/isPov5tt2AlN52OEaDa/l2pQiIvnMFup7Lh6UZSQ2nnrocHTg5llwfz8qB
         6/3OTa6Z0pTCVkytgk09/0zb/HFY+7R6ueVasT0u0sh6hIHesTu6uSxeeQWLBIu7
         pK4WLgRqabuB4xJTh04A0Q==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 06 Jul 2026 19:03:28 +0900
Subject: [PATCH v8 5/7] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-hybrid-v8-5-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5

Add internal state for PMUv3 emulation without programmable event
counters. When fixed-counters-only mode is active, KVM reports no
programmable counters and hides PMCEID, avoiding event-counter state
whose behavior can depend on the selected hardware PMU.

The cycle counter still uses a host perf event. Unlike the normal PMU
path, fixed-counters-only mode may create that event from the hardware
PMU attached to the VCPU's current pCPU. If the VCPU later loads on a
pCPU that is not covered by the existing event's PMU, request a PMU
reload so the cycle counter can be recreated against the new pCPU's PMU.
Keep this affinity check limited to fixed-counters-only VMs; the normal
programmable-counter mode continues to use the VM-wide PMU and does not
need per-load reload decisions.

Add a separate internal flag for explicit userspace PMU selection. The
UAPI wiring added later will use it to keep explicit PMU selection and
fixed-counters-only mode mutually exclusive while still allowing
fixed-counters-only mode to replace the default PMU selected during
KVM_ARM_VCPU_INIT.

The UAPI wiring that sets the fixed-counters-only flag and records
explicit PMU selection is added later in the series.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/include/asm/kvm_host.h |  4 ++++
 arch/arm64/kvm/arm.c              |  1 +
 arch/arm64/kvm/pmu-emul.c         | 43 +++++++++++++++++++++++++++++++++++++--
 include/kvm/arm_pmu.h             |  2 ++
 4 files changed, 48 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0c39d9db7d57..aa07b05b8231 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -353,6 +353,10 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* PMUv3 is emulated with an explicitly specified hardware PMU */
+#define KVM_ARCH_FLAG_PMU_V3_EXPLICIT			12
+	/* PMUv3 is emulated without progammable event counters */
+#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	13
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 68767bb08285..1cc7754d5ace 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -687,6 +687,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_load_pmu(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e70628653e4b..40cad183376c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -96,6 +96,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
 	return mask;
 }
 
+static bool kvm_pmu_fixed_counters_only(struct kvm *kvm)
+{
+	return test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
+}
+
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -343,7 +348,11 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 
 static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
 {
-	if (!pmc->perf_event) {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
+	if (!pmc->perf_event ||
+	    (kvm_pmu_fixed_counters_only(vcpu->kvm) &&
+	     !cpumask_test_cpu(vcpu->cpu, &to_arm_pmu(pmc->perf_event->pmu)->supported_cpus))) {
 		kvm_pmu_create_perf_event(pmc);
 		return;
 	}
@@ -720,6 +729,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	int eventsel;
 	u64 evtreg;
 
+	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
+		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
+		if (WARN_ON_ONCE(!arm_pmu))
+			return;
+	}
+
 	evtreg = kvm_pmc_read_evtreg(pmc);
 
 	kvm_pmu_stop_counter(pmc);
@@ -748,7 +763,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * Don't create an event if we're running on hardware that requires
 	 * PMUv3 event translation and we couldn't find a valid mapping.
 	 */
-	eventsel = kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
+	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
 	if (eventsel < 0)
 		return;
 
@@ -878,6 +893,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
+	if (kvm_pmu_fixed_counters_only(vcpu->kvm))
+		return 0;
+
 	if (!pmceid1) {
 		val = compute_pmceid0(cpu_pmu);
 		base = 0;
@@ -905,6 +923,24 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return val & mask;
 }
 
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * ARMV8_PMU_INSTR_IDX will need the same check once
+	 * FEAT_PMUv3_ICNTR is supported.
+	 */
+	struct kvm_pmc *pmc = kvm_vcpu_idx_to_pmc(vcpu, ARMV8_PMU_CYCLE_IDX);
+	struct arm_pmu *cpu_pmu;
+
+	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) ||
+	    !kvm_pmu_counter_is_enabled(pmc) || !pmc->perf_event)
+		return;
+
+	cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
+	if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
@@ -1016,6 +1052,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (kvm_pmu_fixed_counters_only(kvm))
+		return 0;
+
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
 	 * event, though the same may not be true of non-PMUv3 hardware.
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 354f06edfdee..f01c68a79d22 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -59,6 +59,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu);
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
@@ -164,6 +165,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
 static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {

-- 
2.55.0

