Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43504457A9
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386165; cv=none; b=lAoLVNawivlfKsYbS6EhrI4+Fb6KM3b44IvOTn/pdVJ7JO90cBQKPwhYaAArWNjhqniLnvQ0stu3TzLyRq06ru4XKnsq38lWu69euuf9shE88QmqDDXkSnRyekzrCU9tE21CKHHxIJN61P4OQJJPL1j65bgzfaCffxEwkl/YNI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386165; c=relaxed/simple;
	bh=gQWq7skHk3HzRyOmbroFN5h3xy4A9J3khh4vGuaijcI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ORWYYGi4DDFuSCNf8DeEyypMbZz6Pu1Ts/3vjGCCF3fiRrwGFScGnNIgsK6uk01O94nDllx8LOYDQnm9MKKmPiR9lN88+E48Cefh3zRa7CKy8qwBjY07JMSRiXSmlNo7Z+LjqkRCGxEzq7+thTT8QNSVudS3mq3chv4x+6A6opw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=iE/qNLMG; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="iE/qNLMG"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsK084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:57 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=cvyXOg+v7uY5DYIJGiGnn+D0ZgQ7JXv/wNICdhOGGyQ=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386117; v=1;
        b=iE/qNLMGpTa4sqtfME1jITeeS6RHf1cy1UNGK3b6+ftiy+R0DtZGELczH7UR/kBs
         +n3zFqKHxU9FheQ/iOHrEyJEE+V9NkMVrey3Mk6oH4nHY3Sv8bUI6kZxVJErKAE8
         gXigOTBiNcuxWxLGtB8e9zhWY5Tr3SnzNythQfROGttpR38qGZDZqypyZgs3bIFa
         idlhyOV1dgnG/O9sioC6LrmMSV1QlUtreE4Y1KvnoE23iHfhdsavlfi+pixI9lZj
         igSmPyCdOMG617nLQmyu7d0MwQ7m2WgZx/lANLuJ6BqQWmD9IjEGO3t0CMvBDtF4
         4ts5E+DFHAAtBLeg0AogDQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:57 +0900
Subject: [PATCH v10 18/20] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-18-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=8244;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=gQWq7skHk3HzRyOmbroFN5h3xy4A9J3khh4vGuaijcI=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu+Wt2557xFnO8JJMfm7kaFM+4cTVKgcOd3WdLVO4F
 rJcKrnaUcrCIMbFICumyJJStJtbI7r2U2FCfAvMHFYmkCEMXJwCMJHA9wx/RT7YpG48UXro8o8P
 q75zBM2vcfOumJu0oZTj/9HA+2vNIhkZlqg2yhrUhYS+1mdmeaxv6N614WXHS6UE5shDt1b+f+H
 GDAA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

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

Registered pPMUs must cover every CPU on which fixed-counters-only
emulation runs. On ACPI systems, a CPU brought online after PMU probing
may have an unregistered PMU implementation. Full coverage is also not
guaranteed when ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS is present.

Fixed-counters-only emulation is not supported once a vCPU runs on an
uncovered CPU. If event creation detects such a CPU, warn and add
TAINT_CPU_OUT_OF_SPEC.

Add a separate internal flag for explicit userspace PMU selection. The
UAPI wiring added later will use it to keep explicit PMU selection and
fixed-counters-only mode mutually exclusive while still allowing
fixed-counters-only mode to replace the default PMU selected during
KVM_ARM_VCPU_INIT.

The UAPI wiring that sets the fixed-counters-only flag and records
explicit PMU selection is added later in the series.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/include/asm/kvm_host.h |  4 +++
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/pmu-emul.c         | 60 ++++++++++++++++++++++++++++++++++-----
 include/kvm/arm_pmu.h             |  2 ++
 4 files changed, 61 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7..10e3ff41079e 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -367,6 +367,10 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* PMUv3 is emulated with an explicitly specified hardware PMU */
+#define KVM_ARCH_FLAG_PMU_V3_EXPLICIT			12
+	/* PMUv3 is emulated without programmable event counters */
+#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	13
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index dce6ba0f51e6..dfebfeb95619 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -652,6 +652,7 @@ static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
 void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	struct kvm_s2_mmu *mmu;
+	int last_cpu = vcpu->cpu;
 	int *last_ran;
 
 	if (is_protected_kvm_enabled())
@@ -701,6 +702,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_load_pmu(vcpu, last_cpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ccd268d76235..a19a913a8925 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -83,6 +83,11 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
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
@@ -711,14 +716,10 @@ static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
 	return NULL;
 }
 
-/**
- * kvm_pmu_create_perf_event - create a perf event for a counter
- * @pmc: Counter context
- */
-static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
+static void kvm_pmu_create_perf_event_with_pmu(struct kvm_pmc *pmc,
+					       struct arm_pmu *arm_pmu)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
-	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
 	struct perf_event *event;
 	struct perf_event_attr attr;
 	int eventsel;
@@ -752,7 +753,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * Don't create an event if we're running on hardware that requires
 	 * PMUv3 event translation and we couldn't find a valid mapping.
 	 */
-	eventsel = kvm_map_pmu_event(vcpu->kvm->arch.arm_pmu, eventsel);
+	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
 	if (eventsel < 0)
 		return;
 
@@ -797,6 +798,32 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	pmc->perf_event = event;
 }
 
+/**
+ * kvm_pmu_create_perf_event - create a perf event for a counter
+ * @pmc: Counter context
+ */
+static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
+{
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
+
+	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
+		do {
+			arm_pmu = kvm_pmu_probe_armpmu(READ_ONCE(vcpu->cpu));
+
+			if (!arm_pmu) {
+				pr_warn_once("kvm: Unsupported PMU variation detected.\n");
+				add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
+				return;
+			}
+
+			kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
+		} while (!cpumask_test_cpu(READ_ONCE(vcpu->cpu), &arm_pmu->supported_cpus));
+	} else {
+		kvm_pmu_create_perf_event_with_pmu(pmc, arm_pmu);
+	}
+}
+
 /**
  * kvm_pmu_set_counter_event_type - set selected counter to monitor some event
  * @vcpu: The vcpu pointer
@@ -883,6 +910,13 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
+	/*
+	 * Hide the hardware PMU's event set to keep PMCEID stable across
+	 * physical CPU migration.
+	 */
+	if (kvm_pmu_fixed_counters_only(vcpu->kvm))
+		return 0;
+
 	if (!pmceid1) {
 		val = compute_pmceid0(vcpu);
 		base = 0;
@@ -910,6 +944,15 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return val & mask;
 }
 
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu)
+{
+	if (!kvm_pmu_fixed_counters_only(vcpu->kvm) || vcpu->cpu == last_cpu || last_cpu == -1)
+		return;
+
+	if (kvm_pmu_probe_armpmu(vcpu->cpu) != kvm_pmu_probe_armpmu(last_cpu))
+		kvm_pmu_request_recreate(vcpu);
+}
+
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
@@ -1034,6 +1077,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (kvm_pmu_fixed_counters_only(kvm))
+		return 0;
+
 	/*
 	 * Under KVM_ARM_VCPU_PMU_V3_STRICT no PMU exists until userspace sets
 	 * one, so this can be reached before arm_pmu is set. Report no
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 29bcc09da93e..17b861ed171d 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -62,6 +62,7 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu);
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
@@ -174,6 +175,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu, int last_cpu) {}
 static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
 static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {

-- 
2.55.0

