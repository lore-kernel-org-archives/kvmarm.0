Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31638309F0D
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313563; cv=none; b=hbKFc05a/bGU/bE/9K11GdjfN7GAIomaqJ+ZgiukNjW7CStFKX0DsjQU/qGyJKSMvLw7E5HZ81PGHsCRHQCf2nq+ogRJ3UHPxEixj4lkJ+6gjmwO/Qjat99YTfGTFpSdUy0uZ9wuFkfqNGGpurztQGTGuQlrL+IOugTFDMljFlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313563; c=relaxed/simple;
	bh=41NAhCA/2EGwgWmj+Pj9H/vR82+MtXJvtZjvEDce/A4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sOazXxZuePw8UKvqbUSo5jdcxkkKHz5TUfcuNCKsidhAFc8gXMlMSqwsR3Y2T694xHmP4LN9AUlZiziUQBQzBND3LmVMFuXR30p1uDyqaevbczx61yUVghEqG6iRu3Lnd+FkuAt3NRWqRAnaDqNijLc2edxCoaf1qjg5+J/sj4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=conbyiiv; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="conbyiiv"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-450b8303c1cso8896777b6e.0
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313555; x=1765918355; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Ne4/j3i6bMg+yI7GrAFYYJtGDrr1dKJKFAZAi4YL0=;
        b=conbyiivbo4m1ipGyEmWEkcHKPVLYorXKIlYGGPE/UlxvffBgzg++fZJWJY3GuwGUv
         xEZPOrJRlEdA/M5Bdj33U635QL2wt2fX/ms9y65HG/dzUoh02vueIfl8oTKSMLtx21/e
         wIFHRQyJtLCVg0aXimrxkzst8CE5i1JEsZGjQrMse8zSDlSEffbJTY18DPXAmY4HQZD0
         rmWYjgUz3cYYe3Uwu853E7U3Q2x/ifkxNjJdgEoScI9cmDGyV3FPpDqJfvaYWDALACSc
         CU17fBhCjsaFfabCN4eAOOMrUcLpK6WfI234eR7nOAh6bFnU50RAGZoBpyq1ttbOu/FQ
         OysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313555; x=1765918355;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3Ne4/j3i6bMg+yI7GrAFYYJtGDrr1dKJKFAZAi4YL0=;
        b=Zhum2R5JOHOTKKghVry9yvNhYq6CZmdc98EWJCk0A5ftLJWiPy1zeCoA7pCUB1/fO/
         U/xO2U3JTfGPO0lyjFHWdk4SaLZi7l9LsfWfTEuOt5ParEmkTJEpbwQEWpstrtlFiUe0
         JT59lApkW3JIF1HfR/jQ6bQ4C44jU5ldaKm2l+05AU8L+o5R2IBWVyciGvopcO6yxcIA
         TTrVW/q1jQrQ4zSN92zHYWyXRBhGgwJvlDyhZE5RnsY+CmES3dweNrdHpzOAQ1NcTeqp
         bv62AsyzjDzrR/AKyqYENqRgyuc4Xq2c97G/taOwknGd6Zmygqee4KWN2JYyBlo1uo/M
         7i/g==
X-Forwarded-Encrypted: i=1; AJvYcCWNm4h21gIMtvLLAoS2wwBmPoDlrOoVH5mDBQnKgXuzTi+XUvRXPsTzBKCUXgieYHUab52mTnY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOLjJY4EAWGc+NYlQC/IQSZnQxDl1M+lemArzfC4lkirzZ8lvd
	yTgkqM+RklmhYx+djR054XzULur+he3ddyDw459icbIO7efwOaQZ01VYcjGs3FLH15lcAA6p7ZB
	8dEBlz90u2eIS8a3Q447CzAay7w==
X-Google-Smtp-Source: AGHT+IEa/rFR8Fw1AH4pDhUYtNUCf4vwq4EK7bqkjQNV+qFXgux9uP/SUV3Lv9mVRc+RszyAsYKt8sMK0JKXjHWz8Q==
X-Received: from oifn25-n1.prod.google.com ([2002:a05:6808:8859:10b0:450:63b:b0dd])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:6d8e:b0:450:760b:cc8d with SMTP id 5614622812f47-4558660f2ecmr115150b6e.29.1765313555166;
 Tue, 09 Dec 2025 12:52:35 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:06 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-10-coltonlewis@google.com>
Subject: [PATCH v5 09/24] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

If the PMU is partitioned, keep the driver out of the guest counter
partition and only use the host counter partition.

Define some functions that determine whether the PMU is partitioned
and construct mutually exclusive bitmaps for testing which partition a
particular counter is in. Note that despite their separate position in
the bitmap, the cycle and instruction counters are always in the guest
partition.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h | 18 +++++++
 arch/arm64/include/asm/kvm_pmu.h | 24 +++++++++
 arch/arm64/kvm/pmu-direct.c      | 86 ++++++++++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c         | 41 +++++++++++++--
 4 files changed, 165 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 636b1aab9e8d2..3ea5741d213d8 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -231,6 +231,24 @@ static inline bool kvm_set_pmuserenr(u64 val)
 }
 
 static inline void kvm_vcpu_pmu_resync_el0(void) {}
+static inline void kvm_pmu_host_counters_enable(void) {}
+static inline void kvm_pmu_host_counters_disable(void) {}
+
+static inline bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	return false;
+}
+
+static inline u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu)
+{
+	return ~0;
+}
+
+static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
+{
+	return ~0;
+}
+
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 63bff75e4f8dd..8887f39c25e60 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -90,6 +90,12 @@ void kvm_vcpu_pmu_resync_el0(void);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
+void kvm_pmu_host_counters_enable(void);
+void kvm_pmu_host_counters_disable(void);
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -222,6 +228,24 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
 static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
 
+static inline bool kvm_pmu_is_partitioned(void *pmu)
+{
+	return false;
+}
+
+static inline u64 kvm_pmu_host_counter_mask(void *pmu)
+{
+	return ~0;
+}
+
+static inline u64 kvm_pmu_guest_counter_mask(void *pmu)
+{
+	return ~0;
+}
+
+static inline void kvm_pmu_host_counters_enable(void) {}
+static inline void kvm_pmu_host_counters_disable(void) {}
+
 #endif
 
 #endif
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 0d38265b6f290..d5de7fdd059f4 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -5,7 +5,10 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
 
+#include <asm/arm_pmuv3.h>
 #include <asm/kvm_pmu.h>
 
 /**
@@ -20,3 +23,86 @@ bool kvm_pmu_partition_supported(void)
 	return has_vhe() &&
 		system_supports_pmuv3();
 }
+
+/**
+ * kvm_pmu_is_partitioned() - Determine if given PMU is partitioned
+ * @pmu: Pointer to arm_pmu struct
+ *
+ * Determine if given PMU is partitioned by looking at hpmn field. The
+ * PMU is partitioned if this field is less than the number of
+ * counters in the system.
+ *
+ * Return: True if the PMU is partitioned, false otherwise
+ */
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
+{
+	if (!pmu)
+		return false;
+
+	return pmu->hpmn_max >= 0 &&
+		pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
+}
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
+	if (!kvm_pmu_is_partitioned(pmu))
+		return ARMV8_PMU_CNT_MASK_ALL;
+
+	return GENMASK(nr_counters - 1, pmu->hpmn_max);
+}
+
+/**
+ * kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
+ *
+ * Compute the bitmask that selects the guest-reserved counters in the
+ * {PMCNTEN,PMINTEN,PMOVS}{SET,CLR} registers. These are the counters
+ * in 0..HPMN and the cycle and instruction counters.
+ *
+ * Return: Bitmask
+ */
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
+{
+	return ARMV8_PMU_CNT_MASK_ALL & ~kvm_pmu_host_counter_mask(pmu);
+}
+
+/**
+ * kvm_pmu_host_counters_enable() - Enable host-reserved counters
+ *
+ * When partitioned the enable bit for host-reserved counters is
+ * MDCR_EL2.HPME instead of the typical PMCR_EL0.E, which now
+ * exclusively controls the guest-reserved counters. Enable that bit.
+ */
+void kvm_pmu_host_counters_enable(void)
+{
+	u64 mdcr = read_sysreg(mdcr_el2);
+
+	mdcr |= MDCR_EL2_HPME;
+	write_sysreg(mdcr, mdcr_el2);
+}
+
+/**
+ * kvm_pmu_host_counters_disable() - Disable host-reserved counters
+ *
+ * When partitioned the disable bit for host-reserved counters is
+ * MDCR_EL2.HPME instead of the typical PMCR_EL0.E, which now
+ * exclusively controls the guest-reserved counters. Disable that bit.
+ */
+void kvm_pmu_host_counters_disable(void)
+{
+	u64 mdcr = read_sysreg(mdcr_el2);
+
+	mdcr &= ~MDCR_EL2_HPME;
+	write_sysreg(mdcr, mdcr_el2);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 3e6eb4be4ac43..2bed99ba992d7 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -871,6 +871,9 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 		brbe_enable(cpu_pmu);
 
 	/* Enable all counters */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		kvm_pmu_host_counters_enable();
+
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 }
 
@@ -882,6 +885,9 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 		brbe_disable();
 
 	/* Disable all counters */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		kvm_pmu_host_counters_disable();
+
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
 }
 
@@ -998,6 +1004,7 @@ static int armv8pmu_get_chain_idx(struct pmu_hw_events *cpuc,
 static bool armv8pmu_can_use_pmccntr(struct pmu_hw_events *cpuc,
 				     struct perf_event *event)
 {
+	struct arm_pmu *cpu_pmu = to_arm_pmu(event->pmu);
 	struct hw_perf_event *hwc = &event->hw;
 	unsigned long evtype = hwc->config_base & ARMV8_PMU_EVTYPE_EVENT;
 
@@ -1018,6 +1025,12 @@ static bool armv8pmu_can_use_pmccntr(struct pmu_hw_events *cpuc,
 	if (has_branch_stack(event))
 		return false;
 
+	/*
+	 * If partitioned at all, pmccntr belongs to the guest.
+	 */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		return false;
+
 	return true;
 }
 
@@ -1044,6 +1057,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * may not know how to handle it.
 	 */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr) &&
 	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
 	    !armv8pmu_event_want_user_access(event)) {
@@ -1055,7 +1069,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * Otherwise use events counters
 	 */
 	if (armv8pmu_event_is_chained(event))
-		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
+		return armv8pmu_get_chain_idx(cpuc, cpu_pmu);
 	else
 		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
 }
@@ -1167,6 +1181,14 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	return 0;
 }
 
+static void armv8pmu_reset_host_counters(struct arm_pmu *cpu_pmu)
+{
+	int idx;
+
+	for_each_set_bit(idx, cpu_pmu->cntr_mask, ARMV8_PMU_MAX_GENERAL_COUNTERS)
+		armv8pmu_write_evcntr(idx, 0);
+}
+
 static void armv8pmu_reset(void *info)
 {
 	struct arm_pmu *cpu_pmu = (struct arm_pmu *)info;
@@ -1174,6 +1196,9 @@ static void armv8pmu_reset(void *info)
 
 	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		mask &= kvm_pmu_host_counter_mask(cpu_pmu);
+
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(mask);
 	armv8pmu_disable_intens(mask);
@@ -1186,11 +1211,19 @@ static void armv8pmu_reset(void *info)
 		brbe_invalidate();
 	}
 
+	pmcr = ARMV8_PMU_PMCR_LC;
+
 	/*
-	 * Initialize & Reset PMNC. Request overflow interrupt for
-	 * 64 bit cycle counter but cheat in armv8pmu_write_counter().
+	 * Initialize & Reset PMNC. Request overflow interrupt for 64
+	 * bit cycle counter but cheat in armv8pmu_write_counter().
+	 *
+	 * When partitioned, there is no single bit to reset only the
+	 * host counters. so reset them individually.
 	 */
-	pmcr = ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_LC;
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		armv8pmu_reset_host_counters(cpu_pmu);
+	else
+		pmcr = ARMV8_PMU_PMCR_P | ARMV8_PMU_PMCR_C;
 
 	/* Enable long event counter support where available */
 	if (armv8pmu_has_long_event(cpu_pmu))
-- 
2.52.0.239.gd5f0c6e74e-goog

