Received: from mail-oa1-f74.google.com (mail-oa1-f74.google.com [209.85.160.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E608318EF3
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676856; cv=none; b=lL/4A5qQvi6iTmo8lRUuqK4CaQfhedSdPvUdfzewWKUzudNv6E1O/XdpZEE8EAjIeeVqPTdO3PZS5F8P5nTxbaUZA6Bssf8WA2ni5dMzoNywW/nP/SRV+sjCzWIzQ++XKGy5CaJH+gvRrQVWzKZxFtmvYiMHBkaU8njf7KUs2/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676856; c=relaxed/simple;
	bh=EuxKWuzEIIMz2C6Y2N+6HP59WW/pZgL1W1t4JoiFzPo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G8G/pw00sEr/dTimHDx4H2gvkVS2/lW43ylhfFrIsPZi9mZ4/b1JNj/1BS+stjV+uzWnyDcZGgHT26YsibLwwdqqwRQsOa17NeXV8V76gVHQSPG1kCK6uIbdZnAPaUBCmnT4GmUzX9nyorUVFchxF3g/401nBWr0sm16iXl5vaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1tFILsSK; arc=none smtp.client-ip=209.85.160.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1tFILsSK"
Received: by mail-oa1-f74.google.com with SMTP id 586e51a60fabf-40414b6f18dso995663fac.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676850; x=1771281650; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=K7fJO3z0zUsCH/9inACT3LTF5j9RrtbcCQwYrsnTqt8=;
        b=1tFILsSKOPC/r2jYMJvwj/9wYrtabsnXYTULz4YoyLiyPeVH4xLmULv3vGGOcqQtPd
         z+zxEBtkdo8S0RK9g8vTIfbA2GH8aQsO8da1giIuMOiySB1oKeBC5GvuhJcc7cCrdpj1
         GzX6efeqYavauzilEk/Ab1+PnwYANIeiwYqc4CQEysSuFLxD5/3OZFG+9N5W02cUQDEe
         twwHgOx0WVsv6PMhFdr5sVcM9Q820rGDE7MsZUaPPrf5i6fiCUUCqXKDX2sQyBdQinjN
         e5Q3NhhrAj59jqzciL3azrbWJIMy1b5y2dgVAd+amvnoEmaJ3Y8IWuaydI8n3jFi/3Do
         4kjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676850; x=1771281650;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K7fJO3z0zUsCH/9inACT3LTF5j9RrtbcCQwYrsnTqt8=;
        b=l0VHSeen/JwhTrhaLT8cxEtsz4M6QXhaaargrHeThfhcPehhoXCYmj+KNrEnXLvqq+
         7SOGgnWDFetoqnTl+jvO7BQ0EvsUvktyqvFy2g2qMchON0XdZ63ZEKiLtP5jxQEksPIN
         KW7pJ6BIjOagdqbG4rmjKBl3T+m6L1WWeqZRwVAafZQFaKzSXZz2PrL+CAcmeGWAw/FV
         lWVoy9wR2+/k2h1cCo+ZslKa6aBrXPXGG/ZkysyOinST/xBZ1gHlaCkg3BDbLLMd3MZq
         ibvRElW4vfztxINjdA2RjG7rokY9Hj7XWPqXeOPVWGGB3a7X9iA/Z8vS2L2YqAvJ7c1E
         Qhag==
X-Forwarded-Encrypted: i=1; AJvYcCXuO10K5eAEHczDKQ8NOl2wTunaeTuoyot35zyI1piHHd29OjHeKWT7JhQZHRojqsPneeqDgnc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzCz7Nh6AFQXR1VEm+hLut3nx7plJVkxfW8P8dlT/dVsirrC7kl
	B4vQuRYtGqp2k5Ft+UdrxVwxIIlziV2FwJF+aG6xZzqy4lOmThU9L31P0isg9O5uj4MkteVwqbI
	ffdtCCPTxKWJo6rcQF+dBOC9dNA==
X-Received: from jabjx7.prod.google.com ([2002:a05:6638:a287:b0:5c8:f4c9:f665])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:2293:b0:662:c65f:a06a with SMTP id 006d021491bc7-66d0a667020mr6032066eaf.31.1770676850105;
 Mon, 09 Feb 2026 14:40:50 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:01 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-7-coltonlewis@google.com>
Subject: [PATCH v6 06/19] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
 arch/arm64/kvm/pmu-direct.c      | 86 ++++++++++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c         | 40 +++++++++++++--
 include/kvm/arm_pmu.h            | 24 +++++++++
 4 files changed, 164 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 154503f054886..bed4dfa755681 100644
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
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 74e40e4915416..05ac38ec3ea20 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -5,6 +5,8 @@
  */
 
 #include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
 
 #include <asm/arm_pmuv3.h>
 
@@ -20,3 +22,87 @@ bool has_host_pmu_partition_support(void)
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
+	return pmu->max_guest_counters >= 0 &&
+		pmu->max_guest_counters <= *host_data_ptr(nr_event_counters);
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
+	return GENMASK(nr_counters - 1, pmu->max_guest_counters);
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
+	return ARMV8_PMU_CNT_MASK_C & GENMASK(pmu->max_guest_counters - 1, 0);
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
index b37908fad3249..6395b6deb78c2 100644
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
 
@@ -1028,6 +1034,12 @@ static bool armv8pmu_can_use_pmccntr(struct pmu_hw_events *cpuc,
 	if (cpu_pmu->has_smt)
 		return false;
 
+	/*
+	 * If partitioned at all, pmccntr belongs to the guest.
+	 */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		return false;
+
 	return true;
 }
 
@@ -1054,6 +1066,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * may not know how to handle it.
 	 */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr) &&
 	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
 	    !armv8pmu_event_want_user_access(event)) {
@@ -1065,7 +1078,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * Otherwise use events counters
 	 */
 	if (armv8pmu_event_is_chained(event))
-		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
+		return armv8pmu_get_chain_idx(cpuc, cpu_pmu);
 	else
 		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
 }
@@ -1177,6 +1190,14 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
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
@@ -1184,6 +1205,9 @@ static void armv8pmu_reset(void *info)
 
 	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		mask &= kvm_pmu_host_counter_mask(cpu_pmu);
+
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(mask);
 	armv8pmu_disable_intens(mask);
@@ -1196,11 +1220,19 @@ static void armv8pmu_reset(void *info)
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
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index e7172db1e897d..accfcb79723c8 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -92,6 +92,12 @@ void kvm_vcpu_pmu_resync_el0(void);
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
@@ -228,6 +234,24 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
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
-- 
2.53.0.rc2.204.g2597b5adb4-goog

