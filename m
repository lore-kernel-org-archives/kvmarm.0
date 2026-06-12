Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E73E3B992A
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292567; cv=none; b=YTxjZ+f9GadGIb8m7rRqZqV+GRRQTPODGNKs4L8wW7TjIOtebMYy05DQBgTaXFYfFpwmnbn/DucgnRtOPzQDcS4sY4WQMYdYIB649OW+FWR3waSjbYB61pDmmDb21/XEwI5k7mXqpsIpVQREz1cM1dloOmj0lZ+4eESENQnuPHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292567; c=relaxed/simple;
	bh=RkEksbwbk8kbIhWES8T+6toRKKVqJf9OYkVaucjt0jU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=SdSIRIH+GWzXmKrSCNx0ORYbhHBtcClfwGXg/UZou0liwoHqYlSJxqWe4uDu+SP6S8pm4qaoh+8k2/1gPVcYz4JtlzqjEWB9xxaQvbpSAOiW10jDHNxzwVXIUc21DAg8jzCFJYn//lDUoHyXYgFl4jCIMiQKjODNQWFIgaKppt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O26GMDuM; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O26GMDuM"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-486a2a910efso2781288b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292560; x=1781897360; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mgP7OlxDmA2YIY21MfVAeQtCru4lRgU61gAmgy3l2mA=;
        b=O26GMDuMiTlIn/Agb/uUNIxKjLnW/RrOmh088NPb0Rfk4t4eIDfII94eUW8tbFcL2T
         btLdS+gqPSOE2NAuY3eANzixuT7TH3CiA33PSIV0Lby4G0vjgq7TE+tHahJ0tY7wybKD
         ZH6hCBw+vFoZb8AEi5amHRWOeCHz+YKoinPiGuf8zGAAlRmIEBC0auvJ7gRz2q3IMLA9
         rFV8UX39D6F21EYIh5UoHeFZNZP+btu6/ME5hCdNN3UVSrcLhuCtd9+eaixeJUPPxNrE
         ZSMg1ZZgkw/ZWXyIuASlxqw51ijAFGMxWOmDhan4GkLZ0XcFh0I7cQRJquLTL6s4R5ly
         C8Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292560; x=1781897360;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mgP7OlxDmA2YIY21MfVAeQtCru4lRgU61gAmgy3l2mA=;
        b=YeU5b0ABARvuGMonTzNFlFX3LhXoVhMtqAlfVvOea85y/K2uK82sp2XzPniyMWUTCC
         lgzGa694680c2YAUZuPfTbhXgFj2HxNRVwsTwDDZ7HBlWSw3wsotjOpNt5vH5IVvAbFS
         Gw+YgPbQTSxWLghkdi695wCQaRD0g7LxsLWEIzCTZWih7KrFfZJeBn35HRteV8Tr3IOZ
         gG7dXQNW89vBd0O7vct4ppvyxroxmDL+QCzz/7dy6ftiW7DzssaC84z2l4mUz63eWqda
         XiNEkBWDymdzLOpmGHd8pQ7A79+U5SGqOt/R844oDWHgthoe7NQS2vArPzJ3tR6T9Vts
         +sGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9iVxhfYKtkSPlPato/SGpegE9E64XArZtlWjJlTXqSxEpNfVfkXJDzRQeV2OuaANCTtuw0enM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4yk8vsNaNGXJ8Tt/urKhrl/ZxkHjF7L4lHtShOmsEU25mROO1
	UN/eymwZ4Dr8j7310/mzQtzh8zCm6p7AeDcwbFPt+S6SvTUv/4cFltliBN5PDlXl7qWGznjXeCJ
	abK0Hz6YAlnmvpk8HTJvT7g5KDA==
X-Received: from jabb24.prod.google.com ([2002:a05:6638:3158:b0:5e2:68f4:12c7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1486:b0:479:e9d2:26cf with SMTP id 5614622812f47-4872f378913mr3528034b6e.15.1781292560239;
 Fri, 12 Jun 2026 12:29:20 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:28:59 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-12-coltonlewis@google.com>
Subject: [PATCH 11/21] KVM: arm64: Context swap Partitioned PMU guest registers
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Save and restore newly untrapped registers that can be directly
accessed by the guest when the PMU is partitioned.

* PMEVCNTRn_EL0
* PMCCNTR_EL0
* PMSELR_EL0
* PMCR_EL0
* PMCNTEN_EL0
* PMINTEN_EL1

If we know we are not partitioned (that is, using the emulated vPMU),
then return immediately. A later patch will make this lazy so the
context swaps don't happen unless the guest has accessed the PMU.

PMEVTYPER is handled in a following patch since we must apply the KVM
event filter before writing values to hardware.

PMOVS guest counters are cleared to avoid the possibility of
generating spurious interrupts when PMINTEN is written. This is fine
because the virtual register for PMOVS is always the canonical value.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h |   4 +
 arch/arm64/kvm/arm.c             |   2 +
 arch/arm64/kvm/pmu-direct.c      | 183 +++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h            |  16 +++
 4 files changed, 205 insertions(+)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index eedf58ea01b10..f6031bd522718 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -235,6 +235,10 @@ static inline bool pmu_is_partitioned(struct arm_pmu *pmu)
 {
 	return false;
 }
+static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
+{
+	return ~0;
+}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c67..24f63edc8b384 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -700,6 +700,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_pmu_load(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -743,6 +744,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	kvm_pmu_put(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 43f04c2f33d44..79022447cfb9a 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -86,3 +86,186 @@ u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 		vcpu->kvm->arch.nr_pmu_counters,
 		ARMV8_PMU_PMCR_N);
 }
+
+/**
+ * kvm_pmu_host_counter_mask() - Compute bitmask of host-reserved counters
+ * @pmu: Pointer to arm_pmu struct
+ *
+ * Compute the bitmask that selects the host-reserved counters in the
+ * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
+ * in HPMN..N
+ *
+ * Return: Bitmask
+ */
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
+{
+	u8 nr_counters = *host_data_ptr(nr_event_counters);
+
+	if (pmu_is_partitioned(pmu))
+		return GENMASK_ULL(nr_counters - 1, pmu->max_guest_counters);
+
+	return ARMV8_PMU_CNT_MASK_ALL;
+}
+
+/**
+ * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
+ * @pmu: Pointer to arm_pmu struct
+ *
+ * Compute the bitmask that selects the guest-reserved counters in the
+ * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
+ * in 0..HPMN and the cycle and instruction counters.
+ *
+ * Return: Bitmask
+ */
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
+{
+	if (pmu_is_partitioned(pmu)) {
+		u64 mask = ARMV8_PMU_CNT_MASK_C;
+
+		if (pmu->max_guest_counters > 0)
+			mask |= GENMASK_ULL(pmu->max_guest_counters - 1, 0);
+
+		return mask;
+	}
+
+	return 0;
+}
+
+/**
+ * kvm_pmu_load() - Load untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Load all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_load(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu;
+	unsigned long guest_counters;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't guest-owned then we know the guest isn't using
+	 * the PMU anyway, so no need to bother with the swap.
+	 */
+	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+		return;
+
+	preempt_disable();
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		val = __vcpu_sys_reg(vcpu, PMEVCNTR0_EL0 + i);
+
+		if (i == ARMV8_PMU_CYCLE_IDX)
+			write_pmccntr(val);
+		else
+			write_pmevcntrn(i, val);
+	}
+
+	val = __vcpu_sys_reg(vcpu, PMSELR_EL0);
+	write_sysreg(val, pmselr_el0);
+
+	/* Save only the stateful writable bits. */
+	val = __vcpu_sys_reg(vcpu, PMCR_EL0);
+	mask = ARMV8_PMU_PMCR_MASK &
+		~(ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C);
+	write_sysreg(val & mask, pmcr_el0);
+
+	/*
+	 * When handling these:
+	 * 1. Apply only the bits for guest counters (indicated by mask)
+	 * 2. Use the different registers for set and clear
+	 */
+	mask = kvm_pmu_guest_counter_mask(pmu);
+
+	/* Clear the hardware overflow flags so there is no chance of
+	 * creating spurious interrupts. The hardware here is never
+	 * the canonical version anyway.
+	 */
+	write_sysreg(mask, pmovsclr_el0);
+
+	val = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+	write_sysreg(val & mask, pmcntenset_el0);
+	write_sysreg(~val & mask, pmcntenclr_el0);
+
+	val = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+	write_sysreg(val & mask, pmintenset_el1);
+	write_sysreg(~val & mask, pmintenclr_el1);
+
+	preempt_enable();
+}
+
+/**
+ * kvm_pmu_put() - Put untrapped PMU registers
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Put all untrapped PMU registers from the VCPU into the PCPU. Mask
+ * to only bits belonging to guest-reserved counters and leave
+ * host-reserved counters alone in bitmask registers.
+ */
+void kvm_pmu_put(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu;
+	unsigned long guest_counters;
+	unsigned long flags;
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't guest-owned then we know the guest is not
+	 * accessing the PMU anyway, so no need to bother with the
+	 * swap.
+	 */
+	if (!kvm_pmu_is_partitioned(vcpu->kvm))
+		return;
+
+	preempt_disable();
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		if (i == ARMV8_PMU_CYCLE_IDX)
+			val = read_pmccntr();
+		else
+			val = read_pmevcntrn(i);
+
+		__vcpu_assign_sys_reg(vcpu, PMEVCNTR0_EL0 + i, val);
+	}
+
+	val = read_sysreg(pmselr_el0);
+	__vcpu_assign_sys_reg(vcpu, PMSELR_EL0, val);
+
+	val = read_sysreg(pmcr_el0);
+	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, val);
+
+	/* Mask these to only save the guest relevant bits. */
+	mask = kvm_pmu_guest_counter_mask(pmu);
+
+	val = read_sysreg(pmcntenset_el0);
+	__vcpu_assign_sys_reg(vcpu, PMCNTENSET_EL0, val & mask);
+
+	val = read_sysreg(pmintenset_el1);
+	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
+
+	/* Save pending guest hardware overflows. */
+	local_irq_save(flags);
+	val = read_sysreg(pmovsset_el0);
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, val & mask);
+	write_sysreg(val & mask, pmovsclr_el0);
+	local_irq_restore(flags);
+
+	/* Stop guest counters and disable interrupts in hardware. */
+	write_sysreg(mask, pmcntenclr_el0);
+	write_sysreg(mask, pmintenclr_el1);
+
+	kvm_pmu_set_guest_counters(pmu, 0);
+	preempt_enable();
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 700d5f275b557..61f8d4ed35e10 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -99,6 +99,10 @@ bool pmu_is_partitioned(struct arm_pmu *pmu);
 bool kvm_pmu_is_partitioned(struct kvm *kvm);
 void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val);
 u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
+void kvm_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
@@ -148,6 +152,8 @@ static inline u64 kvm_pmu_direct_pmcr_read(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
@@ -250,6 +256,16 @@ static inline bool pmu_is_partitioned(void *pmu)
 	return false;
 }
 
+static inline u64 kvm_pmu_host_counter_mask(void *kvm)
+{
+	return ~0;
+}
+
+static inline u64 kvm_pmu_guest_counter_mask(void *kvm)
+{
+	return 0;
+}
+
 #endif
 
 #endif
-- 
2.54.0.1136.gdb2ca164c4-goog

