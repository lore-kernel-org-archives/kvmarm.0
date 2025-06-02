Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A1CB660
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892552; cv=none; b=EaGbT10BDKqXRT+/LCd3XVC2x3PqGKbPc0BJKYA1Ux6OJgjQwUAzrOF0NTd9ASdjqWr3fDBiWO7p2qwL4N0QJ8pZqI1qWCM56zx6ZxIKR1hNHN5UKCK6b6wso1epBww3Bz3nWyAFXVJxjIc+PMqCJFRsL0gNTkNfz8PsaYc85zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892552; c=relaxed/simple;
	bh=Kvx3uAqjJggLi1DATHITYErcbyIy/uA3bAn8jDjgGIY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nZ14YGth2+LC4SNtkDiJU7/VvTG6bh3p7BOmWRb2B7s+9ijxsg4gpuPpy547wEg3xsp37q3RMLGNv9ZXPOKiXCplPJL9QOJBDmVReDwwYM0iE4bmHrufMsM+yHq/ewaH+syYuZCGj1XPlswvuGWxO75IgjXeCNG7uqd/sz5Lryk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Xuf1h2aT; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Xuf1h2aT"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3dd89b3a644so62355455ab.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892545; x=1749497345; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GXuWSM2GCZ9T+i75KiasrPAv9lcjtTJZ6XXd+zYRNlg=;
        b=Xuf1h2aTO0A5GjLB6niA5yLOgxwfwlv173Y4mxat2YmQzJTveaP5mFOkCWQodHHFGe
         u5q1+MV6Co6dzlIcd++QYrnaZJatqRpxCD2Ld7J9JUtE5BQNjElYno3/suEc3PwBIGXe
         LhLh1bepGKWiME3IktGBKplQxkZIsNlB8RbZtLiKGxnI14jLjUSbI29ERU6sSzsGVk34
         OwJ2kyEY/ltOk4KqRWkokCtOY8F2gf3CGUvrtafqVbJHYKQZbKe+Ei2soMagwYvAou2K
         u/PLg51W5eefliLHY/Uqqmsmig/QpZ5iNb0AS7NxEWltd0Q9iPTi/tBermZo1qZr1jGA
         A7RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892545; x=1749497345;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GXuWSM2GCZ9T+i75KiasrPAv9lcjtTJZ6XXd+zYRNlg=;
        b=Z7o3NJ9yrOlITsVJlUP6d27cZlfnC11NJLlr5EqnNRnGNgbC5Ge7pKDAxD7v7Gb/0l
         7G6PpuYfRcj0AlwNreGX4+qGkZwbFD8pappR/wm0CwFfXK3SdGISFtAyFOZ8vcR2jxPt
         xz71Jj1xuK3e6cqMNYLR/+DliTv0eUe/mQlhRR3iVteuqFiYldoaN4dUTxphulmrCwYa
         8jDw2IiB0ZV4/1Od0bGpFd95g+M9gpCDCnLxp/U+4svygklg/q/3yCYgp9LdM9pnN7Ln
         xMhX+jBA+dH4z6nZxceOa1QvDxLplUM5MgxfBoZjVqsjpbEP/meummLw9GgUePuRVxhT
         z4ww==
X-Forwarded-Encrypted: i=1; AJvYcCXxk9HH3Zuj9pbxp+1E0jOMsxgOxPHQyW5O8+AqIu/fejwAiOJwe9Ek5cJonYTeO4/vRA4eav8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXEoGXxffw/QpnuM5pbf9/Ut9n/iUDlQNbQdYdNZ3lPigQRdY8
	iKNRjCHIuMRXDJCsea79CxOREcW33KZy4CH4LD8vfwSlgO5qwR4SVIE3x1tdiS509n3B48FtC36
	AFy++/9W/fGr17Sgc0V9sH0QIgg==
X-Google-Smtp-Source: AGHT+IHFmiRfGhHEuAQ8BSv3MIMbdR2lvVdsHAXbv8PPs+QRUvPwpjEs+PRrAmKCsaAFW76c2vibn0+6tinsiTYuug==
X-Received: from ilbbl7.prod.google.com ([2002:a05:6e02:32c7:b0:3dc:7303:c8cf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:16cf:b0:3dc:9b89:6a3b with SMTP id e9e14a558f8ab-3ddb6854e4fmr9879575ab.8.1748892545634;
 Mon, 02 Jun 2025 12:29:05 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:26:53 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-9-coltonlewis@google.com>
Subject: [PATCH 08/17] perf: arm_pmuv3: Keep out of guest counter partition
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

If the PMU is partitioned, keep the driver out of the guest counter
partition and only use the host counter partition. Partitioning is
defined by the MDCR_EL2.HPMN register field and saved in
cpu_pmu->hpmn. The range 0..HPMN-1 is accessible by EL1 and EL0 while
HPMN..PMCR.N is reserved for EL2.

Define some functions that take HPMN as an argument and construct
mutually exclusive bitmaps for testing which partition a particular
counter is in. Note that despite their different position in the
bitmap, the cycle and instruction counters are always in the guest
partition.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h | 18 ++++++++
 arch/arm64/include/asm/kvm_pmu.h | 23 ++++++++++
 arch/arm64/kvm/pmu-part.c        | 73 ++++++++++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c         | 36 ++++++++++++++--
 4 files changed, 146 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 2ec0e5e83fc9..1687b4031ec2 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -227,6 +227,24 @@ static inline bool kvm_set_pmuserenr(u64 val)
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
index 83b81e7829bf..4098d4ad03d9 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -25,6 +25,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
 bool kvm_pmu_partition_supported(void);
 u8 kvm_pmu_hpmn(u8 host_counters);
 int kvm_pmu_partition(struct arm_pmu *pmu, u8 host_counters);
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
+void kvm_pmu_host_counters_enable(void);
+void kvm_pmu_host_counters_disable(void);
 
 #else
 
@@ -52,6 +57,24 @@ static inline int kvm_pmu_partition(struct arm_pmu *pmu)
 	return -EPERM;
 }
 
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
+static inline void kvm_pmu_host_counters_enable(void) {}
+static inline void kvm_pmu_host_counters_disable(void) {}
+
 #endif
 
 #endif
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 7252a58f085c..33eeaa8faf7f 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -115,3 +115,76 @@ int kvm_pmu_partition(struct arm_pmu *pmu, u8 host_counters)
 
 	return 0;
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
+	return pmu->hpmn < *host_data_ptr(nr_event_counters);
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
+	return GENMASK(nr_counters - 1, pmu->hpmn);
+}
+
+/** kvm_pmu_guest_counter_mask() - Compute bitmask of guest-reserved counters
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
+/** kvm_pmu_host_counters_enable() - Enable host-reserved counters
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
+/** kvm_pmu_host_counters_disable() - Disable host-reserved counters
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
index bbcbc8e0c62a..f447a0f10e2b 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -823,12 +823,18 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 	kvm_vcpu_pmu_resync_el0();
 
 	/* Enable all counters */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		kvm_pmu_host_counters_enable();
+
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 {
 	/* Disable all counters */
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		kvm_pmu_host_counters_disable();
+
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() & ~ARMV8_PMU_PMCR_E);
 }
 
@@ -939,6 +945,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr)) {
 		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
 			return ARMV8_PMU_CYCLE_IDX;
@@ -954,6 +961,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * may not know how to handle it.
 	 */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr) &&
 	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
 	    !armv8pmu_event_want_user_access(event)) {
@@ -965,7 +973,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * Otherwise use events counters
 	 */
 	if (armv8pmu_event_is_chained(event))
-		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
+		return armv8pmu_get_chain_idx(cpuc, cpu_pmu);
 	else
 		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
 }
@@ -1057,6 +1065,14 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
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
@@ -1064,6 +1080,9 @@ static void armv8pmu_reset(void *info)
 
 	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		mask &= kvm_pmu_host_counter_mask(cpu_pmu);
+
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(mask);
 	armv8pmu_disable_intens(mask);
@@ -1071,11 +1090,20 @@ static void armv8pmu_reset(void *info)
 	/* Clear the counters we flip at guest entry/exit */
 	kvm_clr_pmu_events(mask);
 
+
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
2.49.0.1204.g71687c7c1d-goog

