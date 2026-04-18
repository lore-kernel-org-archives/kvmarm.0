Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AF51DBB3A
	for <kvmarm@lists.linux.dev>; Sat, 18 Apr 2026 08:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776500152; cv=none; b=EidiO4G8hdg4qLaTkVDSlWTTqJnCbT2FDXP+k8bmTe9rBEFNQNifaOhhghqVd82uKPbKG4lrAOXNOz7NrpnFot32sgnn8Bi7DVJOT2hbih2njf4kqZRTy7MXQYKhy2uCXi/TNXrLQZS3/fOrayajQv+Ru/50ezXI6oBDh90yqaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776500152; c=relaxed/simple;
	bh=XXdceez3l2S+NOYqOuTk7v7Dr9wyt7eZqOdqdSPUDts=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=i4bF4Sw60R0ST3JxHfbjyjaP0MkIkIUCwZVz6vfMjW0MZdW7txbLFuicOF4SIxGCbf9WXCuk9Sxv/E6kstSzgmHLZHzQQ/FSGxKtVph7iKwEp02JnmPDGpjUSPo1RdsJiesx0KskaBlW1mwxMJKtYm/W3zRGF8ryL2mtPbcrtWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=DWDJLJFd reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="DWDJLJFd"
Received: from h205.csg.ci.i.u-tokyo.ac.jp (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 63I8EbAg001871
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 18 Apr 2026 17:15:02 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=vJqpyIq4eooV49BFAyFrAeCEqviMRnUc4BCMgh/4K5M=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1776500103; v=1;
        b=DWDJLJFdpM34Psbk3sRruOmJw4yaKJGBP+f4aTBUcEwBSJWYT0sW6qlphKuBj0o2
         MHwYmLFLg4MJRdvv1EGGnQMqvwmOuyIWpmqNHVwyWYBnqMfoUJZwolPx55Mr5O4M
         OnlwB+RNRIAGWZgxeurhzojp8CRluKDKNd7rveeCkPYudvv870WVXCPRnZwKkjyf
         B0YStkS9icIpvPu9e+7emEMRgouGJYmUHDc9qKLCx3Oa0tuMyLEbxkQ0DBuftoa7
         FfC0Wkrr9FPlyL+a36TNRur8aOkhTAP6g6sFoglg/mtHs2XYOIuSRB8W+R/qSXKm
         GGeFOO1BSB69Yioh9Q2jLQ==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sat, 18 Apr 2026 17:14:25 +0900
Subject: [PATCH v7 3/4] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260418-hybrid-v7-3-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
References: <20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260418-hybrid-v7-0-2bf39ad009bf@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.15-dev-5ab4c

On a heterogeneous arm64 system, KVM's PMU emulation is based on the
features of a single host PMU instance. When a vCPU is migrated to a
pCPU with an incompatible PMU, counters such as PMCCNTR_EL0 stop
incrementing.

Although this behavior is permitted by the architecture, Windows does
not handle it gracefully and may crash with a division-by-zero error.

The current workaround requires VMMs to pin vCPUs to a set of pCPUs
that share a compatible PMU. This is difficult to implement correctly in
QEMU/libvirt, where pinning occurs after vCPU initialization, and it
also restricts the guest to a subset of available pCPUs.

Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
create a "fixed-counters-only" PMU. When set, KVM exposes a PMU that is
compatible with all pCPUs but that does not support programmable
event counters which may have different feature sets on different PMUs.

This allows Windows guests to run reliably on heterogeneous systems
without crashing, even without vCPU pinning, and enables VMMs to
schedule vCPUs across all available pCPUs, making full use of the host
hardware.

Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
attribute provides a getter that facilitates kernel and userspace
debugging/testing.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 Documentation/virt/kvm/devices/vcpu.rst |  29 ++++++
 arch/arm64/include/asm/kvm_host.h       |   2 +
 arch/arm64/include/uapi/asm/kvm.h       |   1 +
 arch/arm64/kvm/arm.c                    |   1 +
 arch/arm64/kvm/pmu-emul.c               | 155 +++++++++++++++++++++++---------
 include/kvm/arm_pmu.h                   |   2 +
 6 files changed, 147 insertions(+), 43 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 60bf205cb373..e0aeb1897d77 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -161,6 +161,35 @@ explicitly selected, or the number of counters is out of range for the
 selected PMU. Selecting a new PMU cancels the effect of setting this
 attribute.
 
+1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
+------------------------------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+:Returns:
+
+	 =======  =====================================================
+	 -EBUSY   Attempted to set after initializing PMUv3 or running
+		  VCPU, or attempted to set for the first time after
+		  setting an event filter
+	 -ENXIO   Attempted to get before setting
+	 -ENODEV  Attempted to set while PMUv3 not supported
+	 =======  =====================================================
+
+If set, PMUv3 will be emulated without programmable event counters. The VCPU
+will use any compatible hardware PMU. This attribute is particularly useful on
+heterogeneous systems where different hardware PMUs cover different physical
+CPUs. The compatibility of hardware PMUs can be checked with
+KVM_ARM_VCPU_PMU_V3_SET_PMU. All VCPUs in a VM share this attribute. It isn't
+possible to set it for the first time if a PMU event filter is already present.
+
+Note that KVM will not make any attempts to run the VCPU on the physical CPUs
+with compatible hardware PMUs. This is entirely left to userspace. However,
+attempting to run the VCPU on an unsupported CPU will fail and KVM_RUN will
+return with exit_reason = KVM_EXIT_FAIL_ENTRY and populate the fail_entry struct
+by setting hardware_entry_failure_reason field to
+KVM_EXIT_FAIL_ENTRY_CPU_UNSUPPORTED and the cpu field to the processor id.
+
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 59f25b85be2b..b59e0182472c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -353,6 +353,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* PMUv3 is emulated without progammable event counters */
+#define KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY	12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index a792a599b9d6..474c84fa757f 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -436,6 +436,7 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 620a465248d1..dca16ca26d32 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -634,6 +634,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
+	kvm_vcpu_load_pmu(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ef5140bbfe28..d1009c144581 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -326,7 +326,10 @@ u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 
 static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
 {
-	if (!pmc->perf_event) {
+	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
+
+	if (!pmc->perf_event ||
+	    !cpumask_test_cpu(vcpu->cpu, &to_arm_pmu(pmc->perf_event->pmu)->supported_cpus)) {
 		kvm_pmu_create_perf_event(pmc);
 		return;
 	}
@@ -667,10 +670,8 @@ static bool kvm_pmc_counts_at_el2(struct kvm_pmc *pmc)
 	return kvm_pmc_read_evtreg(pmc) & ARMV8_PMU_INCLUDE_EL2;
 }
 
-static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
+static int kvm_map_pmu_event(struct arm_pmu *pmu, unsigned int eventsel)
 {
-	struct arm_pmu *pmu = kvm->arch.arm_pmu;
-
 	/*
 	 * The CPU PMU likely isn't PMUv3; let the driver provide a mapping
 	 * for the guest's PMUv3 event ID.
@@ -681,6 +682,23 @@ static int kvm_map_pmu_event(struct kvm *kvm, unsigned int eventsel)
 	return eventsel;
 }
 
+static struct arm_pmu *kvm_pmu_probe_armpmu(int cpu)
+{
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *pmu;
+
+	guard(rcu)();
+
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
+		pmu = entry->arm_pmu;
+
+		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
+			return pmu;
+	}
+
+	return NULL;
+}
+
 /**
  * kvm_pmu_create_perf_event - create a perf event for a counter
  * @pmc: Counter context
@@ -694,6 +712,12 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	int eventsel;
 	u64 evtreg;
 
+	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags)) {
+		arm_pmu = kvm_pmu_probe_armpmu(vcpu->cpu);
+		if (!arm_pmu)
+			return;
+	}
+
 	evtreg = kvm_pmc_read_evtreg(pmc);
 
 	kvm_pmu_stop_counter(pmc);
@@ -722,7 +746,7 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
 	 * Don't create an event if we're running on hardware that requires
 	 * PMUv3 event translation and we couldn't find a valid mapping.
 	 */
-	eventsel = kvm_map_pmu_event(vcpu->kvm, eventsel);
+	eventsel = kvm_map_pmu_event(arm_pmu, eventsel);
 	if (eventsel < 0)
 		return;
 
@@ -810,42 +834,6 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	list_add_tail_rcu(&entry->entry, &arm_pmus);
 }
 
-static struct arm_pmu *kvm_pmu_probe_armpmu(void)
-{
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *pmu;
-	int cpu;
-
-	guard(rcu)();
-
-	/*
-	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
-	 * the same value is used for the entirety of the loop. Given this, and
-	 * the fact that no percpu data is used for the lookup there is no need
-	 * to disable preemption.
-	 *
-	 * It is still necessary to get a valid cpu, though, to probe for the
-	 * default PMU instance as userspace is not required to specify a PMU
-	 * type. In order to uphold the preexisting behavior KVM selects the
-	 * PMU instance for the core during vcpu init. A dependent use
-	 * case would be a user with disdain of all things big.LITTLE that
-	 * affines the VMM to a particular cluster of cores.
-	 *
-	 * In any case, userspace should just do the sane thing and use the UAPI
-	 * to select a PMU type directly. But, be wary of the baggage being
-	 * carried here.
-	 */
-	cpu = raw_smp_processor_id();
-	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
-		pmu = entry->arm_pmu;
-
-		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
-			return pmu;
-	}
-
-	return NULL;
-}
-
 static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
 {
 	u32 hi[2], lo[2];
@@ -888,6 +876,9 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
+	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
+		return 0;
+
 	if (!pmceid1) {
 		val = compute_pmceid0(cpu_pmu);
 		base = 0;
@@ -915,6 +906,26 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	return val & mask;
 }
 
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu)
+{
+	unsigned long mask = kvm_pmu_enabled_counter_mask(vcpu);
+	struct kvm_pmc *pmc;
+	struct arm_pmu *cpu_pmu;
+	int i;
+
+	for_each_set_bit(i, &mask, 32) {
+		pmc = kvm_vcpu_idx_to_pmc(vcpu, i);
+		if (!pmc->perf_event)
+			continue;
+
+		cpu_pmu = to_arm_pmu(pmc->perf_event->pmu);
+		if (!cpumask_test_cpu(vcpu->cpu, &cpu_pmu->supported_cpus)) {
+			kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+			break;
+		}
+	}
+}
+
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
@@ -1016,6 +1027,9 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
+		return 0;
+
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
 	 * event, though the same may not be true of non-PMUv3 hardware.
@@ -1070,7 +1084,24 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
  */
 int kvm_arm_set_default_pmu(struct kvm *kvm)
 {
-	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+	/*
+	 * It is safe to use a stale cpu to iterate the list of PMUs so long as
+	 * the same value is used for the entirety of the loop. Given this, and
+	 * the fact that no percpu data is used for the lookup there is no need
+	 * to disable preemption.
+	 *
+	 * It is still necessary to get a valid cpu, though, to probe for the
+	 * default PMU instance as userspace is not required to specify a PMU
+	 * type. In order to uphold the preexisting behavior KVM selects the
+	 * PMU instance for the core during vcpu init. A dependent use
+	 * case would be a user with disdain of all things big.LITTLE that
+	 * affines the VMM to a particular cluster of cores.
+	 *
+	 * In any case, userspace should just do the sane thing and use the UAPI
+	 * to select a PMU type directly. But, be wary of the baggage being
+	 * carried here.
+	 */
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
 
 	if (!arm_pmu)
 		return -ENODEV;
@@ -1098,6 +1129,7 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
+			clear_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
 			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 			ret = 0;
@@ -1108,11 +1140,42 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	return ret;
 }
 
+static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *arm_pmu;
+	struct cpumask *supported_cpus = kvm->arch.supported_cpus;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (kvm_vm_has_ran_once(kvm) ||
+	    (kvm->arch.pmu_filter &&
+	     !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags)))
+		return -EBUSY;
+
+	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
+	kvm_arm_set_nr_counters(kvm, 0);
+	cpumask_clear(supported_cpus);
+
+	guard(rcu)();
+
+	list_for_each_entry_rcu(entry, &arm_pmus, entry) {
+		arm_pmu = entry->arm_pmu;
+		cpumask_or(supported_cpus, supported_cpus, &arm_pmu->supported_cpus);
+	}
+
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
 
-	if (!kvm->arch.arm_pmu)
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!kvm->arch.arm_pmu &&
+	    !test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags))
 		return -EINVAL;
 
 	if (n > kvm_arm_pmu_get_max_counters(kvm))
@@ -1227,6 +1290,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -1253,6 +1318,9 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		irq = vcpu->arch.pmu.irq_num;
 		return put_user(irq, uaddr);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		if (test_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &vcpu->kvm->arch.flags))
+			return 0;
 	}
 
 	return -ENXIO;
@@ -1266,6 +1334,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 96754b51b411..1375cbaf97b2 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -56,6 +56,7 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
+void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu);
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
 int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,
 			    struct kvm_device_attr *attr);
@@ -161,6 +162,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
+static inline void kvm_vcpu_load_pmu(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
 static inline u8 kvm_arm_pmu_get_pmuver_limit(void)
 {

-- 
2.53.0

