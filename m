Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AB440628D
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929528; cv=none; b=tT+b7hMN2e05oJDE4Sx8S7FelO5QUoRNxPdm5e8oBvyYdYnXmEc3KBPzWLWuoqonxMZ9YN2AxZM/JIuEY/EvwLPznYhraed6wfoV1j3FG053hMctCGv/X+QmUlfh4SWCecEs/iAM5R9UgS4awygfejDWZFKHdxR/y1VpvdNzzd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929528; c=relaxed/simple;
	bh=QP8yK+xtQLGuqO+G6G0f6iW6TMzPpPpuwA/KTPen/9Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GKieqL/ZIzjtIqwXqF7HJCuko+i9uW/7EeuJQTM32lmdg5ti2e1rAXjGukcNjj6ZDmMSRLjy7aBvm7r07SlHea16/YqKwQsvP0PqfimKTqpTCzLexgCFT9gwppwkjzGgUwQNGuKSSTg4v9nssznmy72CLACFehJKICf7r8CsIdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=de3Ya960; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="de3Ya960"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-69492bc3a38so5732626eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929520; x=1778534320; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4FfWFLRUcTJ7zqTosU1ICG6npkIxsQ1895Jbe5/J8PE=;
        b=de3Ya960O4V25zbrnurSYnlVFzE1yDEOGGJEUXnLJWtraG9983gLRv183n6IsIaZav
         0LJ8Erel2RaiyFPr6RGQr8wtalf/FC5JSBWL0w/PlJyRebnkCyxAFZE9s4J79wXQMTDU
         syyt/KQQX2tPtvrZ1piWnL0FPJz6Z2ABsiYXaASDyTnk9YAyaVZNmtT6og31w6hj2aau
         A6Bri24Hw40GB9f+JnE4JAV92uuhrWRXWQ3gx1Yao+Ai1VP6NXoisxqmP24FOaotXgiJ
         PEil+gfXvIRyNxB3ahzyOQRhDAO2a/1ybZQ9WsrKlkt9YkeUP+V3h7dsn1brFF9W/Ipw
         KP+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929520; x=1778534320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4FfWFLRUcTJ7zqTosU1ICG6npkIxsQ1895Jbe5/J8PE=;
        b=szcEkpX4uMV+KwbTYBSkZLHoVtE+zMTEkRJgVijkABKOKqdv8N9B2kB5loNFg98ML6
         IoFItg6bJdz0I3n3BpiHePAxrSnpPXGOC9mHLzPi26NOOFukPmGjz8L4bva12R4IrUp1
         D5qGemBoYi4wVjcECTXvX6QEZgivYMZC1wvYnByy0VaXp+cP+KpgPMVrEOihLtvY8pxZ
         OhdX0DaLRzcngvtpINgIvorviYW/Fk31HkEAmt8TEgLIINoLZqczzMRe4Dn6TuO/6hpm
         Z4wMQF1OHtS7R389ZDYKIusfG6iGN2Xm+bM/ChqX6oSjQvH4aUwR71aEurEDd/FWOYK6
         o6Jw==
X-Forwarded-Encrypted: i=1; AFNElJ9ehNc8RZKZbQUWwLmDhhBySDN0inDz+ZCb5VenVzHrPWwGjD2PdGXtsyCZZ7eGyqNkejSuuMk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBK/YkyJz+IPPsMHu/qgk/Natxod6wCNS2NX/7+chgBtZW1WtW
	TipR4XyrZ1iwiWCfYbZTuSuY+8gjawtzDAHQUuXJBPWUd+GpK7ts59sUDkt0GKvGYLu4q5KLQ9x
	DryFaXBR7T1yuv9iWjn+SI/dS1g==
X-Received: from iobim21.prod.google.com ([2002:a05:6602:6d15:b0:967:e08a:567c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:e914:0:b0:696:573c:9f12 with SMTP id 006d021491bc7-6998a56fa40mr176153eaf.4.1777929520238;
 Mon, 04 May 2026 14:18:40 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:03 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-11-coltonlewis@google.com>
Subject: [PATCH v7 10/20] KVM: arm64: Context swap Partitioned PMU guest registers
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
 arch/arm64/kvm/pmu-direct.c      | 169 +++++++++++++++++++++++++++++++
 include/kvm/arm_pmu.h            |  16 +++
 4 files changed, 191 insertions(+)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 42d62aa48d0a6..eebc89bdab7a1 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -235,6 +235,10 @@ static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
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
index 410ffd41fd73a..a942f2bc13fc4 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -680,6 +680,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
+	kvm_pmu_load(vcpu);
 	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
 		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
@@ -721,6 +722,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_timer_vcpu_put(vcpu);
 	kvm_vgic_put(vcpu);
 	kvm_vcpu_pmu_restore_host(vcpu);
+	kvm_pmu_put(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
 	kvm_arm_vmid_clear_active();
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 63ac72910e4b5..360d022d918d5 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -9,6 +9,7 @@
 #include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
+#include <asm/kvm_emulate.h>
 
 /**
  * has_host_pmu_partition_support() - Determine if partitioning is possible
@@ -98,3 +99,171 @@ u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 
 	return *host_data_ptr(nr_event_counters);
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
+	if (kvm_pmu_is_partitioned(pmu))
+		return GENMASK(nr_counters - 1, pmu->max_guest_counters);
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
+	if (kvm_pmu_is_partitioned(pmu))
+		return ARMV8_PMU_CNT_MASK_C | GENMASK(pmu->max_guest_counters - 1, 0);
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
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
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
+		if (i == ARMV8_PMU_CYCLE_IDX) {
+			write_sysreg(val, pmccntr_el0);
+		} else {
+			write_sysreg(i, pmselr_el0);
+			write_sysreg(val, pmxevcntr_el0);
+		}
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
+	u64 mask;
+	u8 i;
+	u64 val;
+
+	/*
+	 * If we aren't guest-owned then we know the guest is not
+	 * accessing the PMU anyway, so no need to bother with the
+	 * swap.
+	 */
+	if (!kvm_vcpu_pmu_is_partitioned(vcpu))
+		return;
+
+	preempt_disable();
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+	guest_counters = kvm_pmu_guest_counter_mask(pmu);
+
+	for_each_set_bit(i, &guest_counters, ARMPMU_MAX_HWEVENTS) {
+		if (i == ARMV8_PMU_CYCLE_IDX) {
+			val = read_sysreg(pmccntr_el0);
+		} else {
+			write_sysreg(i, pmselr_el0);
+			val = read_sysreg(pmxevcntr_el0);
+		}
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
+	preempt_enable();
+}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6aaeb27642540..fa881dc5f5832 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -96,6 +96,10 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
+void kvm_pmu_load(struct kvm_vcpu *vcpu);
+void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
@@ -167,6 +171,8 @@ static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
 {
 	return 0;
 }
+static inline void kvm_pmu_load(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_put(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
@@ -269,6 +275,16 @@ static inline bool kvm_pmu_is_partitioned(void *pmu)
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
2.54.0.545.g6539524ca2-goog

