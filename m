Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39B94A6CF2
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270981; cv=none; b=MrhQVAXwAdRwU8bjPpaWWntqTDSWRNBXZrAJkee4RIBVKDZh6JzLy+GPry9mfLAHbETNuB6aYMHNoFMBq24u/c7aoqzH59IBKu9E6ahiXVNAvugr8U8BbilXAz658AKLgaaouVvwWh+/6idHElaUCp2YfzGlvvQoRvaTnfoEb8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270981; c=relaxed/simple;
	bh=8m9Y6G84gKgUWcVKbdu5emCQehFy0FAvurHcdU+Uhmc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=he4GJ+W4xIPfz9z5wxIXGCipdICWdSJLu1WaLrzwTkY7BKpspyMJPToims+kaUsRtZzYRHL2opyVFCOJjcZbP8m5jazkvs6pqWycTICPOO9Jys+aPShoXCcA12cllkjFrAkm/IOkPQtIa/uy+tfkWPhpa2zjOwu17G6F0WhIzZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kqgvhvtM; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kqgvhvtM"
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cbff1bc700so100622b6e.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270974; x=1790875774; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BLmlZVm6m1RFNiiRmQZmf3BQcG79q4ymhMlRheGsADk=;
        b=kqgvhvtMcAN5/jcNWMp/3rO+oB/76x4uDvvvWksJiWyDT4SmkTIwCTEpV92reBKc6h
         YzTm7jjfuu8Xw3NVgRlmjiEPXPmpCNPU/2NoeOv+HzLc9GeyPCJcrcjlB8hHao3Yht1/
         RkRi+wzTwxWe0nbNNWom8RzgURh2KyiBgMJAFsN8aydY69wBr9nvfX4cvH/ov0GBJfmN
         GCnXpT+c32EbJUZUBCDZaEM7NQYJ1qKZNw6N7dzzmA3KC8RMPi6FSIxOuIFx08eYUue5
         fnA7+ALkM5W3dRM4Q5iJE5nUZlnVIe6/K4bM6QYM7M8ACKhNGG1jOL4nvRt7a8D5ydQN
         LyDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270974; x=1790875774;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BLmlZVm6m1RFNiiRmQZmf3BQcG79q4ymhMlRheGsADk=;
        b=bnh6ubLYqOzzzTn8pYRphyoC+u6FZUOt6dYL7ePLr8fMf/Vwkl3J0xuUa+nb1gTUR3
         dtUvJypcmGlITirYHxhG8wxDQ/Z+KZog956FgnPb3vHMJO0oiJHFmKF7vdvOlp4lJ61N
         4q0rPeNqy0gf2sR5rRljwOmnOhWVt1J5kqGinCSfqKYi7wNB2D45z00Y23aLtoeKWI/V
         yM7xpx4EOCMJMPIy22LohfHiMQttVMHLM68nGOg3UCRmL4EsSBItiSJCBjtaP62xuTUy
         mDSOLyb+/CHoUG+RrUMwJlUpbFpFZgJFxHMrKwxzAbnrvW3DTPumxiDkce0T1HZSIL80
         drCw==
X-Forwarded-Encrypted: i=1; AKwUvBx16gxrrYvw2G7dF1ZBOMAo82rXDDJb5q2CY3uyXTE1dSPYVFS7KzG5khVrpeS+WHqV0UV/G7E=@lists.linux.dev
X-Gm-Message-State: AFuF++lv/Bzva184lVVKzma5bTXG/7UILijpLQdyfVhsUE2vsc9O/+uz
	rlVjr3ypkESt7x/impB3T4yiJ6y59/Giw/GqQBuPPv9xdpMW4fiWmwDZY7klWacBXa8HgcPoycK
	T9wtUKW8i1HAsk9PkCVBUj1iH8A==
X-Received: from jasg13.prod.google.com ([2002:a05:6638:11cd:b0:5ec:7f32:cf92])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1392:b0:4b3:880a:f08e with SMTP id 5614622812f47-4d728717b46mr3222793b6e.13.1790270973919;
 Thu, 24 Sep 2026 10:29:33 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:09 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-4-coltonlewis@google.com>
Subject: [PATCH v9 03/22] KVM: arm64: Reorganize PMU functions
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

A lot of functions in pmu-emul.c aren't specific to the emulated PMU
implementation. Move them to the more appropriate pmu.c file where
shared PMU functions should live.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 702 +------------------------------------
 arch/arm64/kvm/pmu.c      | 705 ++++++++++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h     |   9 +-
 3 files changed, 714 insertions(+), 702 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 5b1af7e2176fa..2a2c924fc6b8f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -17,19 +17,10 @@
 
 #define PERF_ATTR_CFG1_COUNTER_64BIT	BIT(0)
 
-static LIST_HEAD(arm_pmus);
-static DEFINE_MUTEX(arm_pmus_lock);
-
 static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
-bool kvm_supports_guest_pmuv3(void)
-{
-	guard(mutex)(&arm_pmus_lock);
-	return !list_empty(&arm_pmus);
-}
-
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
 {
 	return container_of(pmc, struct kvm_vcpu, arch.pmu.pmc[pmc->idx]);
@@ -40,46 +31,6 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
 	return &vcpu->arch.pmu.pmc[cnt_idx];
 }
 
-static u32 __kvm_pmu_event_mask(unsigned int pmuver)
-{
-	switch (pmuver) {
-	case ID_AA64DFR0_EL1_PMUVer_IMP:
-		return GENMASK(9, 0);
-	case ID_AA64DFR0_EL1_PMUVer_V3P1:
-	case ID_AA64DFR0_EL1_PMUVer_V3P4:
-	case ID_AA64DFR0_EL1_PMUVer_V3P5:
-	case ID_AA64DFR0_EL1_PMUVer_V3P7:
-		return GENMASK(15, 0);
-	default:		/* Shouldn't be here, just for sanity */
-		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
-		return 0;
-	}
-}
-
-static u32 kvm_pmu_event_mask(struct kvm *kvm)
-{
-	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
-	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
-
-	return __kvm_pmu_event_mask(pmuver);
-}
-
-u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
-{
-	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
-		   kvm_pmu_event_mask(kvm);
-
-	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
-		mask |= ARMV8_PMU_INCLUDE_EL2;
-
-	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
-		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
-			ARMV8_PMU_EXCLUDE_NS_EL1 |
-			ARMV8_PMU_EXCLUDE_EL3;
-
-	return mask;
-}
-
 /**
  * kvm_pmc_is_64bit - determine if counter is 64bit
  * @pmc: counter context
@@ -272,59 +223,6 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 	irq_work_sync(&vcpu->arch.pmu.overflow_work);
 }
 
-static u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
-{
-	unsigned int hpmn, n;
-
-	if (!vcpu_has_nv(vcpu))
-		return 0;
-
-	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-	n = vcpu->kvm->arch.nr_pmu_counters;
-
-	/*
-	 * Programming HPMN to a value greater than PMCR_EL0.N is
-	 * CONSTRAINED UNPREDICTABLE. Make the implementation choice that an
-	 * UNKNOWN number of counters (in our case, zero) are reserved for EL2.
-	 */
-	if (hpmn >= n)
-		return 0;
-
-	/*
-	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
-	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
-	 * depend on hardware (all PMU registers are trapped), make the
-	 * implementation choice that all counters are included in the second
-	 * range reserved for EL2/EL3.
-	 */
-	return GENMASK(n - 1, hpmn);
-}
-
-bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
-{
-	return kvm_pmu_hyp_counter_mask(vcpu) & BIT(idx);
-}
-
-u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
-{
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
-
-	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
-		return mask;
-
-	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
-}
-
-u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
-{
-	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
-
-	if (val == 0)
-		return BIT(ARMV8_PMU_CYCLE_IDX);
-	else
-		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
-}
-
 static void kvm_pmc_enable_perf_event(struct kvm_pmc *pmc)
 {
 	if (!pmc->perf_event) {
@@ -370,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -393,16 +291,6 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 	return reg;
 }
 
-static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
-{
-	struct kvm_pmu *pmu = &vcpu->arch.pmu;
-
-	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
-		return;
-
-	WARN_ON(kvm_vgic_inject_irq(vcpu->kvm, vcpu, pmu->irq_num,
-				    kvm_pmu_overflow_status(vcpu), pmu));
-}
 
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 {
@@ -423,43 +311,6 @@ bool kvm_pmu_update_run(struct kvm_vcpu *vcpu)
 	return update;
 }
 
-/**
- * kvm_pmu_flush_hwstate - flush pmu state to cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the PMU has overflowed while we were running in the host, and inject
- * an interrupt if that was the case.
- */
-void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
-{
-	kvm_pmu_update_state(vcpu);
-}
-
-/**
- * kvm_pmu_sync_hwstate - sync pmu state from cpu
- * @vcpu: The vcpu pointer
- *
- * Check if the PMU has overflowed while we were running in the guest, and
- * inject an interrupt if that was the case.
- */
-void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
-{
-	kvm_pmu_update_state(vcpu);
-}
-
-/*
- * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
- * to the event.
- * This is why we need a callback to do it once outside of the NMI context.
- */
-static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
-{
-	struct kvm_vcpu *vcpu;
-
-	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
-	kvm_vcpu_kick(vcpu);
-}
-
 /*
  * Perform an increment on any of the counters described in @mask,
  * generating the overflow if required, and propagate it as a chained
@@ -771,133 +622,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 	kvm_pmu_create_perf_event(pmc);
 }
 
-void kvm_host_pmu_init(struct arm_pmu *pmu)
-{
-	struct arm_pmu_entry *entry;
-
-	/*
-	 * Check the sanitised PMU version for the system, as KVM does not
-	 * support implementations where PMUv3 exists on a subset of CPUs.
-	 */
-	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
-		return;
-
-	guard(mutex)(&arm_pmus_lock);
-
-	entry = kmalloc_obj(*entry);
-	if (!entry)
-		return;
-
-	entry->arm_pmu = pmu;
-	list_add_tail(&entry->entry, &arm_pmus);
-}
-
-static struct arm_pmu *kvm_pmu_probe_armpmu(void)
-{
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *pmu;
-	int cpu;
-
-	guard(mutex)(&arm_pmus_lock);
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
-	list_for_each_entry(entry, &arm_pmus, entry) {
-		pmu = entry->arm_pmu;
-
-		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
-			return pmu;
-	}
-
-	return NULL;
-}
-
-static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
-{
-	u32 hi[2], lo[2];
-
-	bitmap_to_arr32(lo, pmu->pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
-	bitmap_to_arr32(hi, pmu->pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
-
-	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
-}
-
-static u64 compute_pmceid0(struct kvm_vcpu *vcpu)
-{
-	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 0);
-
-	/* always support SW_INCR */
-	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
-	/* always support CHAIN */
-	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
-	return val;
-}
-
-static u64 compute_pmceid1(struct kvm_vcpu *vcpu)
-{
-	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 1);
-
-	/*
-	 * If KVM_ARM_VCPU_PMU_V3_STRICT is not set, PMMIR_EL1 is
-	 * unconditionally RAZ, so don't advertise STALL_SLOT* events.
-	 */
-	if (!kvm_vcpu_has_pmuv3_strict(vcpu))
-		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
-			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
-			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
-
-	return val;
-}
-
-u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
-{
-	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
-	u64 val, mask = 0;
-	int base, i, nr_events;
-
-	if (!pmceid1) {
-		val = compute_pmceid0(vcpu);
-		base = 0;
-	} else {
-		val = compute_pmceid1(vcpu);
-		base = 32;
-	}
-
-	if (!bmap)
-		return val;
-
-	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
-
-	for (i = 0; i < 32; i += 8) {
-		u64 byte;
-
-		byte = bitmap_get_value8(bmap, base + i);
-		mask |= byte << i;
-		if (nr_events >= (0x4000 + base + 32)) {
-			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
-			mask |= byte << (32 + i);
-		}
-	}
-
-	return val & mask;
-}
-
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
@@ -909,430 +633,6 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 	kvm_pmu_reprogram_counter_mask(vcpu, mask);
 }
 
-int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
-{
-	if (!vcpu->arch.pmu.created)
-		return -EINVAL;
-
-	/*
-	 * A valid interrupt configuration for the PMU is either to have a
-	 * properly configured interrupt number and using an in-kernel
-	 * irqchip, or to not have an in-kernel GIC and not set an IRQ.
-	 */
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		int irq = vcpu->arch.pmu.irq_num;
-		/*
-		 * If we are using an in-kernel vgic, at this point we know
-		 * the vgic will be initialized, so we can check the PMU irq
-		 * number against the dimensions of the vgic and make sure
-		 * it's valid.
-		 */
-		if (!irq_is_ppi(vcpu->kvm, irq) &&
-		    !vgic_valid_spi(vcpu->kvm, irq))
-			return -EINVAL;
-	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
-		   return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
-{
-	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
-	if (!vcpu->kvm->arch.arm_pmu)
-		return -ENXIO;
-
-	if (irqchip_in_kernel(vcpu->kvm)) {
-		int ret;
-
-		/*
-		 * If using the PMU with an in-kernel virtual GIC
-		 * implementation, we require the GIC to be already
-		 * initialized when initializing the PMU.
-		 */
-		if (!vgic_initialized(vcpu->kvm))
-			return -ENODEV;
-
-		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
-			if (!vgic_is_v5(vcpu->kvm))
-				return -ENXIO;
-
-			/* Use the architected irq number for GICv5. */
-			vcpu->arch.pmu.irq_num = KVM_ARMV8_PMU_GICV5_IRQ;
-		}
-
-		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
-					 &vcpu->arch.pmu);
-		if (ret)
-			return ret;
-	}
-
-	init_irq_work(&vcpu->arch.pmu.overflow_work,
-		      kvm_pmu_perf_overflow_notify_vcpu);
-
-	vcpu->arch.pmu.created = true;
-	return 0;
-}
-
-/*
- * For one VM the interrupt type must be same for each vcpu.
- * As a PPI, the interrupt number is the same for all vcpus,
- * while as an SPI it must be a separate number per vcpu.
- */
-static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
-{
-	unsigned long i;
-	struct kvm_vcpu *vcpu;
-
-	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
-	if (vgic_is_v5(kvm) && irq != KVM_ARMV8_PMU_GICV5_IRQ)
-		return false;
-
-	kvm_for_each_vcpu(i, vcpu, kvm) {
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			continue;
-
-		if (irq_is_ppi(vcpu->kvm, irq)) {
-			if (vcpu->arch.pmu.irq_num != irq)
-				return false;
-		} else {
-			if (vcpu->arch.pmu.irq_num == irq)
-				return false;
-		}
-	}
-
-	return true;
-}
-
-/**
- * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
- * @kvm: The kvm pointer
- */
-u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
-{
-	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
-
-	/*
-	 * Under KVM_ARM_VCPU_PMU_V3_STRICT no PMU exists until userspace sets
-	 * one, so this can be reached before arm_pmu is set. Report no
-	 * counters in that case.
-	 */
-	if (!arm_pmu)
-		return 0;
-
-	/*
-	 * PMUv3 requires that all event counters are capable of counting any
-	 * event, though the same may not be true of non-PMUv3 hardware.
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
-		return 1;
-
-	/*
-	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
-	 * Ignore those and return only the general-purpose counters.
-	 */
-	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
-}
-
-static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
-{
-	kvm->arch.nr_pmu_counters = nr;
-
-	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
-	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
-		struct kvm_vcpu *vcpu;
-		unsigned long i;
-
-		kvm_for_each_vcpu(i, vcpu, kvm) {
-			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
-			val &= ~MDCR_EL2_HPMN;
-			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
-			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-		}
-	}
-}
-
-static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
-{
-	lockdep_assert_held(&kvm->arch.config_lock);
-
-	kvm->arch.arm_pmu = arm_pmu;
-	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
-}
-
-/**
- * kvm_arm_set_default_pmu - No PMU set and KVM_ARM_VCPU_PMU_V3_STRICT not
- * set, get the default one.
- * @kvm: The kvm pointer
- *
- * The observant among you will notice that the supported_cpus
- * mask does not get updated for the default PMU even though it
- * is quite possible the selected instance supports only a
- * subset of cores in the system. This is intentional, and
- * upholds the preexisting behavior on heterogeneous systems
- * where vCPUs can be scheduled on any core but the guest
- * counters could stop working.
- */
-int kvm_arm_set_default_pmu(struct kvm *kvm)
-{
-	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
-
-	if (!arm_pmu)
-		return -ENODEV;
-
-	kvm_arm_set_pmu(kvm, arm_pmu);
-	return 0;
-}
-
-static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
-{
-	struct kvm *kvm = vcpu->kvm;
-	struct arm_pmu_entry *entry;
-	struct arm_pmu *arm_pmu;
-	int ret = -ENXIO;
-
-	lockdep_assert_held(&kvm->arch.config_lock);
-	mutex_lock(&arm_pmus_lock);
-
-	list_for_each_entry(entry, &arm_pmus, entry) {
-		arm_pmu = entry->arm_pmu;
-		if (arm_pmu->pmu.type == pmu_id) {
-			if (kvm_vm_has_ran_once(kvm) ||
-			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
-				ret = -EBUSY;
-				break;
-			}
-
-			kvm_arm_set_pmu(kvm, arm_pmu);
-			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
-
-			/*
-			 * Since a specific PMU is explicitly selected,
-			 * PMMIR_EL1.SLOTS is deterministic to the guest.
-			 * If KVM_ARM_VCPU_PMU_V3_STRICT is set, snapshot
-			 * the value to allow the guest to read it.
-			 */
-			if (kvm_vcpu_has_pmuv3_strict(vcpu))
-				kvm->arch.pmmir_slots =
-					FIELD_GET(ARMV8_PMU_SLOTS,
-						  arm_pmu->reg_pmmir);
-			ret = 0;
-			break;
-		}
-	}
-
-	mutex_unlock(&arm_pmus_lock);
-	return ret;
-}
-
-static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
-{
-	struct kvm *kvm = vcpu->kvm;
-
-	if (!kvm->arch.arm_pmu)
-		return -EINVAL;
-
-	if (n > kvm_arm_pmu_get_max_counters(kvm))
-		return -EINVAL;
-
-	kvm_arm_set_nr_counters(kvm, n);
-	return 0;
-}
-
-int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	struct kvm *kvm = vcpu->kvm;
-
-	lockdep_assert_held(&kvm->arch.config_lock);
-
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return -ENODEV;
-
-	if (vcpu->arch.pmu.created)
-		return -EBUSY;
-
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int irq;
-
-		if (!irqchip_in_kernel(kvm))
-			return -EINVAL;
-
-		if (get_user(irq, uaddr))
-			return -EFAULT;
-
-		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
-		if (!(irq_is_ppi(vcpu->kvm, irq) || irq_is_spi(vcpu->kvm, irq)))
-			return -EINVAL;
-
-		if (!pmu_irq_is_valid(kvm, irq))
-			return -EINVAL;
-
-		if (kvm_arm_pmu_irq_initialized(vcpu))
-			return -EBUSY;
-
-		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
-		vcpu->arch.pmu.irq_num = irq;
-		return 0;
-	}
-	case KVM_ARM_VCPU_PMU_V3_FILTER: {
-		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
-		struct kvm_pmu_event_filter __user *uaddr;
-		struct kvm_pmu_event_filter filter;
-		int nr_events;
-
-		/*
-		 * Allow userspace to specify an event filter for the entire
-		 * event range supported by PMUVer of the hardware, rather
-		 * than the guest's PMUVer for KVM backward compatibility.
-		 */
-		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
-
-		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
-
-		if (copy_from_user(&filter, uaddr, sizeof(filter)))
-			return -EFAULT;
-
-		if (((u32)filter.base_event + filter.nevents) > nr_events ||
-		    (filter.action != KVM_PMU_EVENT_ALLOW &&
-		     filter.action != KVM_PMU_EVENT_DENY))
-			return -EINVAL;
-
-		if (kvm_vm_has_ran_once(kvm))
-			return -EBUSY;
-
-		if (!kvm->arch.arm_pmu)
-			return -ENXIO;
-
-		if (!kvm->arch.pmu_filter) {
-			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
-			if (!kvm->arch.pmu_filter)
-				return -ENOMEM;
-
-			/*
-			 * The default depends on the first applied filter.
-			 * If it allows events, the default is to deny.
-			 * Conversely, if the first filter denies a set of
-			 * events, the default is to allow.
-			 */
-			if (filter.action == KVM_PMU_EVENT_ALLOW)
-				bitmap_zero(kvm->arch.pmu_filter, nr_events);
-			else
-				bitmap_fill(kvm->arch.pmu_filter, nr_events);
-		}
-
-		if (filter.action == KVM_PMU_EVENT_ALLOW)
-			bitmap_set(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
-		else
-			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
-
-		return 0;
-	}
-	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int pmu_id;
-
-		if (get_user(pmu_id, uaddr))
-			return -EFAULT;
-
-		return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
-	}
-	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS: {
-		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
-		unsigned int n;
-
-		if (get_user(n, uaddr))
-			return -EFAULT;
-
-		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
-	}
-	case KVM_ARM_VCPU_PMU_V3_INIT:
-		return kvm_arm_pmu_v3_init(vcpu);
-	}
-
-	return -ENXIO;
-}
-
-int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ: {
-		int __user *uaddr = (int __user *)(long)attr->addr;
-		int irq;
-
-		if (!irqchip_in_kernel(vcpu->kvm))
-			return -EINVAL;
-
-		if (!kvm_vcpu_has_pmu(vcpu))
-			return -ENODEV;
-
-		if (!kvm_arm_pmu_irq_initialized(vcpu))
-			return -ENXIO;
-
-		irq = vcpu->arch.pmu.irq_num;
-		return put_user(irq, uaddr);
-	}
-	}
-
-	return -ENXIO;
-}
-
-int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
-{
-	switch (attr->attr) {
-	case KVM_ARM_VCPU_PMU_V3_IRQ:
-	case KVM_ARM_VCPU_PMU_V3_INIT:
-	case KVM_ARM_VCPU_PMU_V3_FILTER:
-	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
-	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
-		if (kvm_vcpu_has_pmu(vcpu))
-			return 0;
-	}
-
-	return -ENXIO;
-}
-
-u8 kvm_arm_pmu_get_pmuver_limit(void)
-{
-	unsigned int pmuver;
-
-	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
-			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
-
-	/*
-	 * Spoof a barebones PMUv3 implementation if the system supports IMPDEF
-	 * traps of the PMUv3 sysregs
-	 */
-	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
-		return ID_AA64DFR0_EL1_PMUVer_IMP;
-
-	/*
-	 * Otherwise, treat IMPLEMENTATION DEFINED functionality as
-	 * unimplemented
-	 */
-	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
-		return 0;
-
-	return min(pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
-}
-
-/**
- * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
- * @vcpu: The vcpu pointer
- */
-u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
-{
-	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
-
-	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
-		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-
-	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
-}
-
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu)
 {
 	bool reprogrammed = false;
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 6b48a3d16d0d5..6f60f86fad387 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -8,8 +8,21 @@
 #include <linux/perf/arm_pmu.h>
 #include <linux/perf/arm_pmuv3.h>
 
+#include <kvm/arm_pmu.h>
+#include <kvm/arm_vgic.h>
+
+#include <asm/kvm_emulate.h>
+
+static LIST_HEAD(arm_pmus);
+static DEFINE_MUTEX(arm_pmus_lock);
 static DEFINE_PER_CPU(struct kvm_pmu_events, kvm_pmu_events);
 
+bool kvm_supports_guest_pmuv3(void)
+{
+	guard(mutex)(&arm_pmus_lock);
+	return !list_empty(&arm_pmus);
+}
+
 /*
  * Given the perf event attributes and system type, determine
  * if we are going to need to switch counters at guest entry/exit.
@@ -209,3 +222,695 @@ void kvm_vcpu_pmu_resync_el0(void)
 
 	kvm_make_request(KVM_REQ_RESYNC_PMU_EL0, vcpu);
 }
+
+void kvm_host_pmu_init(struct arm_pmu *pmu)
+{
+	struct arm_pmu_entry *entry;
+
+	/*
+	 * Check the sanitised PMU version for the system, as KVM does not
+	 * support implementations where PMUv3 exists on a subset of CPUs.
+	 */
+	if (!pmuv3_implemented(kvm_arm_pmu_get_pmuver_limit()))
+		return;
+
+	guard(mutex)(&arm_pmus_lock);
+
+	entry = kmalloc_obj(*entry);
+	if (!entry)
+		return;
+
+	entry->arm_pmu = pmu;
+	list_add_tail(&entry->entry, &arm_pmus);
+}
+
+static struct arm_pmu *kvm_pmu_probe_armpmu(void)
+{
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *pmu;
+	int cpu;
+
+	guard(mutex)(&arm_pmus_lock);
+
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
+	cpu = raw_smp_processor_id();
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		pmu = entry->arm_pmu;
+
+		if (cpumask_test_cpu(cpu, &pmu->supported_cpus))
+			return pmu;
+	}
+
+	return NULL;
+}
+
+static u64 __compute_pmceid(struct arm_pmu *pmu, bool pmceid1)
+{
+	u32 hi[2], lo[2];
+
+	bitmap_to_arr32(lo, pmu->pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+	bitmap_to_arr32(hi, pmu->pmceid_ext_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
+
+	return ((u64)hi[pmceid1] << 32) | lo[pmceid1];
+}
+
+static u64 compute_pmceid0(struct kvm_vcpu *vcpu)
+{
+	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 0);
+
+	/* always support SW_INCR */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_SW_INCR);
+	/* always support CHAIN */
+	val |= BIT(ARMV8_PMUV3_PERFCTR_CHAIN);
+	return val;
+}
+
+static u64 compute_pmceid1(struct kvm_vcpu *vcpu)
+{
+	u64 val = __compute_pmceid(vcpu->kvm->arch.arm_pmu, 1);
+
+	/*
+	 * If KVM_ARM_VCPU_PMU_V3_STRICT is not set, PMMIR_EL1 is
+	 * unconditionally RAZ, so don't advertise STALL_SLOT* events.
+	 */
+	if (!kvm_vcpu_has_pmuv3_strict(vcpu))
+		val &= ~(BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_FRONTEND - 32) |
+			 BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT_BACKEND - 32));
+
+	return val;
+}
+
+u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
+{
+	unsigned long *bmap = vcpu->kvm->arch.pmu_filter;
+	u64 val, mask = 0;
+	int base, i, nr_events;
+
+	if (!pmceid1) {
+		val = compute_pmceid0(vcpu);
+		base = 0;
+	} else {
+		val = compute_pmceid1(vcpu);
+		base = 32;
+	}
+
+	if (!bmap)
+		return val;
+
+	nr_events = kvm_pmu_event_mask(vcpu->kvm) + 1;
+
+	for (i = 0; i < 32; i += 8) {
+		u64 byte;
+
+		byte = bitmap_get_value8(bmap, base + i);
+		mask |= byte << i;
+		if (nr_events >= (0x4000 + base + 32)) {
+			byte = bitmap_get_value8(bmap, 0x4000 + base + i);
+			mask |= byte << (32 + i);
+		}
+	}
+
+	return val & mask;
+}
+
+/*
+ * When perf interrupt is an NMI, we cannot safely notify the vcpu corresponding
+ * to the event.
+ * This is why we need a callback to do it once outside of the NMI context.
+ */
+static void kvm_pmu_perf_overflow_notify_vcpu(struct irq_work *work)
+{
+	struct kvm_vcpu *vcpu;
+
+	vcpu = container_of(work, struct kvm_vcpu, arch.pmu.overflow_work);
+	kvm_vcpu_kick(vcpu);
+}
+
+static u32 __kvm_pmu_event_mask(unsigned int pmuver)
+{
+	switch (pmuver) {
+	case ID_AA64DFR0_EL1_PMUVer_IMP:
+		return GENMASK(9, 0);
+	case ID_AA64DFR0_EL1_PMUVer_V3P1:
+	case ID_AA64DFR0_EL1_PMUVer_V3P4:
+	case ID_AA64DFR0_EL1_PMUVer_V3P5:
+	case ID_AA64DFR0_EL1_PMUVer_V3P7:
+		return GENMASK(15, 0);
+	default:		/* Shouldn't be here, just for sanity */
+		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
+		return 0;
+	}
+}
+
+u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	u64 dfr0 = kvm_read_vm_id_reg(kvm, SYS_ID_AA64DFR0_EL1);
+	u8 pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer, dfr0);
+
+	return __kvm_pmu_event_mask(pmuver);
+}
+
+u64 kvm_pmu_evtyper_mask(struct kvm *kvm)
+{
+	u64 mask = ARMV8_PMU_EXCLUDE_EL1 | ARMV8_PMU_EXCLUDE_EL0 |
+		   kvm_pmu_event_mask(kvm);
+
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL2, IMP))
+		mask |= ARMV8_PMU_INCLUDE_EL2;
+
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, EL3, IMP))
+		mask |= ARMV8_PMU_EXCLUDE_NS_EL0 |
+			ARMV8_PMU_EXCLUDE_NS_EL1 |
+			ARMV8_PMU_EXCLUDE_EL3;
+
+	return mask;
+}
+
+static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
+{
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
+
+	if (unlikely(!irqchip_in_kernel(vcpu->kvm)))
+		return;
+
+	WARN_ON(kvm_vgic_inject_irq(vcpu->kvm, vcpu, pmu->irq_num,
+				    kvm_pmu_overflow_status(vcpu), pmu));
+}
+
+/**
+ * kvm_pmu_flush_hwstate - flush pmu state to cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the host, and inject
+ * an interrupt if that was the case.
+ */
+void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+/**
+ * kvm_pmu_sync_hwstate - sync pmu state from cpu
+ * @vcpu: The vcpu pointer
+ *
+ * Check if the PMU has overflowed while we were running in the guest, and
+ * inject an interrupt if that was the case.
+ */
+void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu)
+{
+	kvm_pmu_update_state(vcpu);
+}
+
+int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
+{
+	if (!vcpu->arch.pmu.created)
+		return -EINVAL;
+
+	/*
+	 * A valid interrupt configuration for the PMU is either to have a
+	 * properly configured interrupt number and using an in-kernel
+	 * irqchip, or to not have an in-kernel GIC and not set an IRQ.
+	 */
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int irq = vcpu->arch.pmu.irq_num;
+		/*
+		 * If we are using an in-kernel vgic, at this point we know
+		 * the vgic will be initialized, so we can check the PMU irq
+		 * number against the dimensions of the vgic and make sure
+		 * it's valid.
+		 */
+		if (!irq_is_ppi(vcpu->kvm, irq) && !vgic_valid_spi(vcpu->kvm, irq))
+			return -EINVAL;
+	} else if (kvm_arm_pmu_irq_initialized(vcpu)) {
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
+{
+	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
+	if (!vcpu->kvm->arch.arm_pmu)
+		return -ENXIO;
+
+	if (irqchip_in_kernel(vcpu->kvm)) {
+		int ret;
+
+		/*
+		 * If using the PMU with an in-kernel virtual GIC
+		 * implementation, we require the GIC to be already
+		 * initialized when initializing the PMU.
+		 */
+		if (!vgic_initialized(vcpu->kvm))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu)) {
+			if (!vgic_is_v5(vcpu->kvm))
+				return -ENXIO;
+
+			/* Use the architected irq number for GICv5. */
+			vcpu->arch.pmu.irq_num = KVM_ARMV8_PMU_GICV5_IRQ;
+		}
+
+		ret = kvm_vgic_set_owner(vcpu, vcpu->arch.pmu.irq_num,
+					 &vcpu->arch.pmu);
+		if (ret)
+			return ret;
+	}
+
+	init_irq_work(&vcpu->arch.pmu.overflow_work,
+		      kvm_pmu_perf_overflow_notify_vcpu);
+
+	vcpu->arch.pmu.created = true;
+	return 0;
+}
+
+/*
+ * For one VM the interrupt type must be same for each vcpu.
+ * As a PPI, the interrupt number is the same for all vcpus,
+ * while as an SPI it must be a separate number per vcpu.
+ */
+static bool pmu_irq_is_valid(struct kvm *kvm, int irq)
+{
+	unsigned long i;
+	struct kvm_vcpu *vcpu;
+
+	/* On GICv5, the PMUIRQ is architecturally mandated to be PPI 23 */
+	if (vgic_is_v5(kvm) && irq != KVM_ARMV8_PMU_GICV5_IRQ)
+		return false;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			continue;
+
+		if (irq_is_ppi(kvm, irq)) {
+			if (vcpu->arch.pmu.irq_num != irq)
+				return false;
+		} else {
+			if (vcpu->arch.pmu.irq_num == irq)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+/**
+ * kvm_arm_pmu_get_max_counters - Return the max number of PMU counters.
+ * @kvm: The kvm pointer
+ */
+u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
+
+	/*
+	 * Under KVM_ARM_VCPU_PMU_V3_STRICT no PMU exists until userspace sets
+	 * one, so this can be reached before arm_pmu is set. Report no
+	 * counters in that case.
+	 */
+	if (!arm_pmu)
+		return 0;
+
+	/*
+	 * PMUv3 requires that all event counters are capable of counting any
+	 * event, though the same may not be true of non-PMUv3 hardware.
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return 1;
+
+	/*
+	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
+	 * Ignore those and return only the general-purpose counters.
+	 */
+	return bitmap_weight(arm_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS);
+}
+
+static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
+{
+	kvm->arch.nr_pmu_counters = nr;
+
+	/* Reset MDCR_EL2.HPMN behind the vcpus' back... */
+	if (test_bit(KVM_ARM_VCPU_HAS_EL2, kvm->arch.vcpu_features)) {
+		struct kvm_vcpu *vcpu;
+		unsigned long i;
+
+		kvm_for_each_vcpu(i, vcpu, kvm) {
+			u64 val = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+			val &= ~MDCR_EL2_HPMN;
+			val |= FIELD_PREP(MDCR_EL2_HPMN, kvm->arch.nr_pmu_counters);
+			__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
+		}
+	}
+}
+
+static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
+{
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	kvm->arch.arm_pmu = arm_pmu;
+	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
+}
+
+/**
+ * kvm_arm_set_default_pmu - No PMU set and KVM_ARM_VCPU_PMU_V3_STRICT not
+ * set, get the default one.
+ * @kvm: The kvm pointer
+ *
+ * The observant among you will notice that the supported_cpus
+ * mask does not get updated for the default PMU even though it
+ * is quite possible the selected instance supports only a
+ * subset of cores in the system. This is intentional, and
+ * upholds the preexisting behavior on heterogeneous systems
+ * where vCPUs can be scheduled on any core but the guest
+ * counters could stop working.
+ */
+int kvm_arm_set_default_pmu(struct kvm *kvm)
+{
+	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu();
+
+	if (!arm_pmu)
+		return -ENODEV;
+
+	kvm_arm_set_pmu(kvm, arm_pmu);
+	return 0;
+}
+
+static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
+{
+	struct kvm *kvm = vcpu->kvm;
+	struct arm_pmu_entry *entry;
+	struct arm_pmu *arm_pmu;
+	int ret = -ENXIO;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+	mutex_lock(&arm_pmus_lock);
+
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		arm_pmu = entry->arm_pmu;
+		if (arm_pmu->pmu.type == pmu_id) {
+			if (kvm_vm_has_ran_once(kvm) ||
+			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
+				ret = -EBUSY;
+				break;
+			}
+
+			kvm_arm_set_pmu(kvm, arm_pmu);
+			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
+
+			/*
+			 * Since a specific PMU is explicitly selected,
+			 * PMMIR_EL1.SLOTS is deterministic to the guest.
+			 * If KVM_ARM_VCPU_PMU_V3_STRICT is set, snapshot
+			 * the value to allow the guest to read it.
+			 */
+			if (kvm_vcpu_has_pmuv3_strict(vcpu))
+				kvm->arch.pmmir_slots =
+					FIELD_GET(ARMV8_PMU_SLOTS,
+						  arm_pmu->reg_pmmir);
+			ret = 0;
+			break;
+		}
+	}
+
+	mutex_unlock(&arm_pmus_lock);
+	return ret;
+}
+
+static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (!kvm->arch.arm_pmu)
+		return -EINVAL;
+
+	if (n > kvm_arm_pmu_get_max_counters(kvm))
+		return -EINVAL;
+
+	kvm_arm_set_nr_counters(kvm, n);
+	return 0;
+}
+
+int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (!kvm_vcpu_has_pmu(vcpu))
+		return -ENODEV;
+
+	if (vcpu->arch.pmu.created)
+		return -EBUSY;
+
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(kvm))
+			return -EINVAL;
+
+		if (get_user(irq, uaddr))
+			return -EFAULT;
+
+		/* The PMU overflow interrupt can be a PPI or a valid SPI. */
+		if (!(irq_is_ppi(kvm, irq) || irq_is_spi(kvm, irq)))
+			return -EINVAL;
+
+		if (!pmu_irq_is_valid(kvm, irq))
+			return -EINVAL;
+
+		if (kvm_arm_pmu_irq_initialized(vcpu))
+			return -EBUSY;
+
+		kvm_debug("Set kvm ARM PMU irq: %d\n", irq);
+		vcpu->arch.pmu.irq_num = irq;
+		return 0;
+	}
+	case KVM_ARM_VCPU_PMU_V3_FILTER: {
+		u8 pmuver = kvm_arm_pmu_get_pmuver_limit();
+		struct kvm_pmu_event_filter __user *uaddr;
+		struct kvm_pmu_event_filter filter;
+		int nr_events;
+
+		/*
+		 * Allow userspace to specify an event filter for the entire
+		 * event range supported by PMUVer of the hardware, rather
+		 * than the guest's PMUVer for KVM backward compatibility.
+		 */
+		nr_events = __kvm_pmu_event_mask(pmuver) + 1;
+
+		uaddr = (struct kvm_pmu_event_filter __user *)(long)attr->addr;
+
+		if (copy_from_user(&filter, uaddr, sizeof(filter)))
+			return -EFAULT;
+
+		if (((u32)filter.base_event + filter.nevents) > nr_events ||
+		    (filter.action != KVM_PMU_EVENT_ALLOW &&
+		     filter.action != KVM_PMU_EVENT_DENY))
+			return -EINVAL;
+
+		if (kvm_vm_has_ran_once(kvm))
+			return -EBUSY;
+
+		if (!kvm->arch.arm_pmu)
+			return -ENXIO;
+
+		if (!kvm->arch.pmu_filter) {
+			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
+			if (!kvm->arch.pmu_filter)
+				return -ENOMEM;
+
+			/*
+			 * The default depends on the first applied filter.
+			 * If it allows events, the default is to deny.
+			 * Conversely, if the first filter denies a set of
+			 * events, the default is to allow.
+			 */
+			if (filter.action == KVM_PMU_EVENT_ALLOW)
+				bitmap_zero(kvm->arch.pmu_filter, nr_events);
+			else
+				bitmap_fill(kvm->arch.pmu_filter, nr_events);
+		}
+
+		if (filter.action == KVM_PMU_EVENT_ALLOW)
+			bitmap_set(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+		else
+			bitmap_clear(kvm->arch.pmu_filter, filter.base_event, filter.nevents);
+
+		return 0;
+	}
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int pmu_id;
+
+		if (get_user(pmu_id, uaddr))
+			return -EFAULT;
+
+		return kvm_arm_pmu_v3_set_pmu(vcpu, pmu_id);
+	}
+	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS: {
+		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
+		unsigned int n;
+
+		if (get_user(n, uaddr))
+			return -EFAULT;
+
+		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
+	}
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+		return kvm_arm_pmu_v3_init(vcpu);
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ: {
+		int __user *uaddr = (int __user *)(long)attr->addr;
+		int irq;
+
+		if (!irqchip_in_kernel(vcpu->kvm))
+			return -EINVAL;
+
+		if (!kvm_vcpu_has_pmu(vcpu))
+			return -ENODEV;
+
+		if (!kvm_arm_pmu_irq_initialized(vcpu))
+			return -ENXIO;
+
+		irq = vcpu->arch.pmu.irq_num;
+		return put_user(irq, uaddr);
+	}
+	}
+
+	return -ENXIO;
+}
+
+int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
+{
+	switch (attr->attr) {
+	case KVM_ARM_VCPU_PMU_V3_IRQ:
+	case KVM_ARM_VCPU_PMU_V3_INIT:
+	case KVM_ARM_VCPU_PMU_V3_FILTER:
+	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
+	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+		if (kvm_vcpu_has_pmu(vcpu))
+			return 0;
+	}
+
+	return -ENXIO;
+}
+
+u8 kvm_arm_pmu_get_pmuver_limit(void)
+{
+	unsigned int pmuver;
+
+	pmuver = SYS_FIELD_GET(ID_AA64DFR0_EL1, PMUVer,
+			       read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1));
+
+	/*
+	 * Spoof a barebones PMUv3 implementation if the system supports IMPDEF
+	 * traps of the PMUv3 sysregs
+	 */
+	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
+		return ID_AA64DFR0_EL1_PMUVer_IMP;
+
+	/*
+	 * Otherwise, treat IMPLEMENTATION DEFINED functionality as
+	 * unimplemented
+	 */
+	if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return 0;
+
+	return min(pmuver, ID_AA64DFR0_EL1_PMUVer_V3P5);
+}
+
+u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
+
+	if (val == 0)
+		return BIT(ARMV8_PMU_CYCLE_IDX);
+	else
+		return GENMASK(val - 1, 0) | BIT(ARMV8_PMU_CYCLE_IDX);
+}
+
+u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
+{
+	unsigned int hpmn, n;
+
+	if (!vcpu_has_nv(vcpu))
+		return 0;
+
+	hpmn = SYS_FIELD_GET(MDCR_EL2, HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+	n = vcpu->kvm->arch.nr_pmu_counters;
+
+	/*
+	 * Programming HPMN to a value greater than PMCR_EL0.N is
+	 * CONSTRAINED UNPREDICTABLE. Make the implementation choice that an
+	 * UNKNOWN number of counters (in our case, zero) are reserved for EL2.
+	 */
+	if (hpmn >= n)
+		return 0;
+
+	/*
+	 * Programming HPMN=0 is CONSTRAINED UNPREDICTABLE if FEAT_HPMN0 isn't
+	 * implemented. Since KVM's ability to emulate HPMN=0 does not directly
+	 * depend on hardware (all PMU registers are trapped), make the
+	 * implementation choice that all counters are included in the second
+	 * range reserved for EL2/EL3.
+	 */
+	return GENMASK(n - 1, hpmn);
+}
+
+bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
+{
+	return kvm_pmu_hyp_counter_mask(vcpu) & BIT(idx);
+}
+
+u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+
+	if (!vcpu_has_nv(vcpu) || vcpu_is_el2(vcpu))
+		return mask;
+
+	return mask & ~kvm_pmu_hyp_counter_mask(vcpu);
+}
+
+/**
+ * kvm_vcpu_read_pmcr - Read PMCR_EL0 register for the vCPU
+ * @vcpu: The vcpu pointer
+ */
+u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
+{
+	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+
+	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
+		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
+
+	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 93f41ac77c25f..e1bf29de0b6dd 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -50,18 +50,21 @@ struct arm_pmu_entry {
 };
 
 bool kvm_supports_guest_pmuv3(void);
-#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num != 0)
+#define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num >= VGIC_NR_SGIS)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu);
 u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu);
+u32 kvm_pmu_event_mask(struct kvm *kvm);
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1);
 void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
 void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
 bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
@@ -137,6 +140,10 @@ static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline u32 kvm_pmu_event_mask(struct kvm *kvm)
+{
+	return 0;
+}
 static inline void kvm_pmu_vcpu_init(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
-- 
2.56.0.rc1.310.g51773c2048-goog

