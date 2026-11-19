Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114342;
	b=AsnErMCpi8lpFeMCmQuT8YhS8DkEExLXWnY+0gAwAd9WJtwZGh9KnIcjFh0mWhcnOkFd
	 o4Tq/NKaKGhu3Y1WR+wCcqxLJ7buQ36XNoi07hiMCbDWU6Digoc/ZiHGaaBMEHEdiRwxB
	 NPIVFIjh5xLTeilxOaBEajuGPSsaVYGG4P9C5870w9Mp/RSzSuKg4nM4aRKRGbHcNrD0T
	 LAH/wLCoEbZDFEFgGiaP5EYqNtHEaL5/JioTVslsqrtrAXVaVT6ahVstXZi0UD4C7EXHy
	 xyT1NeaPXuA5u+JE1ow0DpQIQL7zeFVIXAOCtsL/+ue3HUspua9fJrbIXpKw6qYubRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114342;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KziqUj3tK3PpXLBTj/ekX0oyzW77dvmCFwUlWMn+z90=;
	b=hb1E0ROl8OzKuz32dyD3i5yyRAnv7ildAzaG/gR7Kw0rUIZo1KyPATWj+pbFq0SlOm3g
	 zw7zkaRg+Woj4O40ZR74wXA6PnnEyd73KaO8ls80AKSqMFk0cDkTbAPKoxIhuNvpUtdCZ
	 vGalOk16XTuYwEmxx+ohfV6U3GKS4y3SsBQ6HmllsNEBvDbHpdAONuP3BFJo8laFa3C+T
	 Pjxw512Bge8l5HBvKol5EZkxY3/+4SVVsHnbT5SvHUIa+0zOYjq/vozrllXZhlqaRGRaf
	 ZxHAu2w9n7cLvGsHIecfnSRhDs2sKrvh36gBLVAORvjQ+2/L4TqZVIUobNiaaGyEizg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D+5Aax59;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8007760A2630
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8007760A2630
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D+5Aax59
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e778acdbc6so171373b6e.3
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114339; x=1795719139; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KziqUj3tK3PpXLBTj/ekX0oyzW77dvmCFwUlWMn+z90=;
        b=D+5Aax59mZiMqGmhecVkpSTlscWu6HJmEBR5G9xXuVnwB5QFUG2KoUDnH0eXz1Zeb3
         Y23nLQBcWxcJ/fklOnF6oLE0sgPHDN52UQoemh4goX4cdPV/SMafYUrrH3tSGKUttbBK
         ZtuqLMMlGWIW6l8R2g4SlMFmg9SJB4/oYCrMXuEDRXjU4xr/J3NaGNTLH3NDiSiR0i3d
         lniSQnVW/OqGRbIW+EbGbXx3Pnpoa2HRAe3IPFJlqEBy1CnNtk9VSh+TVuZFTF2DY/9m
         UlmmlxNXBaVrL0QIoN7Xg+MQfvq/j6iGbeV507X7Gib6qx98P0M9FwTYXv/ku5Rsl0wy
         7WgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114339; x=1795719139;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KziqUj3tK3PpXLBTj/ekX0oyzW77dvmCFwUlWMn+z90=;
        b=PSMF3dKFtvZh0DAgtWhKbTMI3c0FCev9L4G0oC8Aeurcq3imoat+UzgUHy2Xp2DLvb
         UqbGH2N+Lgmds3WqDQ+d4XxqenqmXLRdLz6gTGV9RBwSk/YONOK6n6vAcooqgdCHXm8X
         AYgoGxMj6tzcezMyZjgp6S4tGLQTiHFBHyGZL2hl+e/MEN5/1cX2A5PYRWEVwk6yS9sF
         foKWu4BCksO4mS6pwYWfqIIbVO+5EIGOJ0SAYLn3MTDCLhibGASK6UowX8pddaRA/TOK
         M9BPL8BMzY7uQ8Mx+nL0q9V/Sx7NfY3SCVgjgB1DAxNpqhPHG3mw48skw2cvR6TNf8UP
         4fEg==
X-Forwarded-Encrypted: i=1; AL+hErGy6EFxWHk3vRdA2TqHTWrv3nJy9HpxXbw5ZAcqS6bFXFLIOVcE858ospSlqFqvUH+oLoJqWrA=@lists.linux.dev
X-Gm-Message-State: APuU4Z+TQHZ096j737YxA/gJuiQd2rcJrSc07ZdUtuw1pBnPq6ZsryXV
	UVX9/tDHvpqJ+gb54/TrdCJvW/Anr57jgz8uxULrOnZtdYTt4w7MYulMvhe36Lu9YrJYivwWoF1
	6UP0f90qwDlY1Z6RfSTS7blF2wA==
X-Received: from ioo21-n2.prod.google.com ([2002:a05:6602:8655:20b0:9c7:b2b5:20af])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:148f:b0:565:343d:7e09 with SMTP id 5614622812f47-57a0ae280dbmr972602b6e.30.1795114338891;
 Thu, 19 Nov 2026 10:52:18 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:45 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-4-coltonlewis@google.com>
Subject: [PATCH v10 03/33] KVM: arm64: Reorganize PMU functions
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

A lot of functions in pmu-emul.c aren't specific to the emulated PMU
implementation. Move them to the more appropriate pmu.c file where
shared PMU functions should live.

Tested-by: James Clark <james.clark@linaro.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 716 +------------------------------------
 arch/arm64/kvm/pmu.c      | 719 ++++++++++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h     |  14 +
 3 files changed, 734 insertions(+), 715 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index e2b28dbc0451b..ea5908df42890 100644
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
@@ -40,49 +31,6 @@ static struct kvm_pmc *kvm_vcpu_idx_to_pmc(struct kvm_vcpu *vcpu, int cnt_idx)
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
-	default:
-		/* Shouldn't be here, just for sanity */
-		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
-		fallthrough;
-	case ID_AA64DFR0_EL1_PMUVer_NI:
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
@@ -275,59 +223,6 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
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
@@ -373,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -396,16 +291,6 @@ static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
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
@@ -426,43 +311,6 @@ bool kvm_pmu_update_run(struct kvm_vcpu *vcpu)
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
@@ -774,568 +622,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
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
-void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
-{
-	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
-
-	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
-	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
-	__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, mask);
-
-	kvm_pmu_reprogram_counter_mask(vcpu, mask);
-}
-
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
index 6b48a3d16d0d5..567de460205a0 100644
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
@@ -209,3 +222,709 @@ void kvm_vcpu_pmu_resync_el0(void)
 
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
+	default:
+		/* Shouldn't be here, just for sanity */
+		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
+		fallthrough;
+	case ID_AA64DFR0_EL1_PMUVer_NI:
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
+
+void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
+{
+	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
+	__vcpu_rmw_sys_reg(vcpu, PMCNTENSET_EL0, &=, mask);
+
+	kvm_pmu_reprogram_counter_mask(vcpu, mask);
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 93f41ac77c25f..8d51cf40182d6 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -26,6 +26,7 @@ struct kvm_device_attr;
 struct kvm_vcpu;
 
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
+
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
 	struct perf_event *perf_event;
@@ -55,13 +56,16 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
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
@@ -133,10 +137,20 @@ static inline u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+
+static inline u64 kvm_pmu_hyp_counter_mask(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 static inline u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
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
2.56.1.708.g77570a6a1d-goog

