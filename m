Received: from mail-io1-f73.google.com (mail-io1-f73.google.com [209.85.166.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8B524A074
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457931; cv=none; b=RQ2yuLZVQddQ0zLtocMej5KrRWBLxYT2NAsFMMQilOTd9Jm4HyNukmYMInePFQ1oM+3zPa0IQMExXZ7qk9oEPJd3qKqEjDU2/gqRD8g53RzVC10xMho0JBlvvSlUdEV/4cooO/wgjZ9TwEiUJHIU1SDxummRHMjmqhRX3dMd9fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457931; c=relaxed/simple;
	bh=6ysZwt5atmpSKFCDrlDBPLn3kfM3W7BZIeQsXMk2wqc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gv+X6rWbQwQ5x4PwQbeO588xpXgxepcGFQoDP2sd3+o5eDhbpdBjJL+qIP3f283q4T6NkogZjUFaGGnsSBnXxO1UP+Eyq0/22xRy8wO6EwhxQnhNFY3RI0e1Afyj/04VDa2MSaCowi3r3dWIAzeMT3sRAY3oOy4dg4PXJjCEQRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cs8V6O9c; arc=none smtp.client-ip=209.85.166.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cs8V6O9c"
Received: by mail-io1-f73.google.com with SMTP id ca18e2360f4ac-86cf753423cso201505439f.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457926; x=1751062726; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TaxbDY8rSubDKVeB5qmQvsKdNyXQzHjSCcKHkHOgoe8=;
        b=cs8V6O9c2096aTNCs0qCUwa4yTXgXgFcaATyhfCayvM+iooDMTukI25dS68Yi6d8go
         hg31/3cQMneH7M7tGpVHzCpy4jd85CfDhYPe4iSv15N3646OUOd0v00V0de6ENj5wYGo
         FDIEW3khGFYY55YTOH9TNl9vXXV8JX89LcMhQhPwMwPaOQcTe0zvkAGGP3bMPJE5+mTA
         lfXsfHaQvr/j2BFsFmYVwb6R2xfe873MWjpn7t3mqBUvpt9Cdj/Xm/9xVi9x55NhhzQo
         CwCxdBe72QZQw9NvNZMUaqao+jh77dVwVPDgIILEoSeBbEKqWyoRMZlFcyVZaL91TzPa
         WhqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457926; x=1751062726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TaxbDY8rSubDKVeB5qmQvsKdNyXQzHjSCcKHkHOgoe8=;
        b=sMYNF1jzkPIrYKPWNaT93JZeU23yV5oKkdyWzX1xlhHtFOIZWLnScfkNFIHbHUmXqD
         HfDWjmYmJ1hq+dozKj2BogCh6GWEDCHyN5cJMCvAd199GTa0K8dPoLBArrFHm3sMmbob
         5X+4amTyJar81aRAh6sVRojpj+A+Fw1GBw0Brp0quZGoin2lw37W/435QtjTHdnrWy1R
         S5TyeX70SIP4r0xPpp5pQzJnoE956KuVz9oavrmzC79VyrxluUSdt7BjvJJX/K98gM1y
         IDBEquuSJBw/h8jYq02eoz1e+26hu8ZpscIkbwJMWNn6+Z5Iiue2+UbKowKftIx7BiVn
         QrCA==
X-Forwarded-Encrypted: i=1; AJvYcCXUadXr93F7N4eOpYYxjEywuhf4+6jSvLpvFE4KjxSnlmkNLMY6HyOs5d7mHmhBcIUIF0EgRHM=@lists.linux.dev
X-Gm-Message-State: AOJu0YylrfojMrt+JHb4XsZtgGsLG/f2w/Z8/y9BZegAyR6YMpdALR47
	0gMWaVdw7sFoM/85i2pWecoKFTCGKgTB/L9wXkjQL7p3PEI7qdR+fboX+Vk8HUxYbwz4C4Y4mK8
	9dASWDEKQtP0R82WF/4kndkkp2g==
X-Google-Smtp-Source: AGHT+IHmcP6P8yd1kt8l/2AJx8SYpIrdG7oKp/9ZlcMxhqeWhGwhZSAzY8eWSi7LyqHpRmp5lQSqYAZtIJu5h/0h1g==
X-Received: from ilbbp5.prod.google.com ([2002:a05:6e02:3485:b0:3dd:ca88:fcaf])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:318f:b0:3d4:3ab3:daf0 with SMTP id e9e14a558f8ab-3de38c3295emr45672015ab.7.1750457926519;
 Fri, 20 Jun 2025 15:18:46 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:10 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-11-coltonlewis@google.com>
Subject: [PATCH v2 09/23] perf: arm_pmuv3: Keep out of guest counter partition
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
defined by the MDCR_EL2.HPMN register field and the maximum value KVM
can use is saved in cpu_pmu->hpmn_max. The range 0..HPMN-1 is
accessible by EL1 and EL0 while HPMN..PMCR.N is reserved for EL2.

Define some functions that take HPMN as an argument and construct
mutually exclusive bitmaps for testing which partition a particular
counter is in. Note that despite their different position in the
bitmap, the cycle and instruction counters are always in the guest
partition.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h | 18 +++++++
 arch/arm64/include/asm/kvm_pmu.h | 26 ++++++++++
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/pmu-part.c        | 88 ++++++++++++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c         | 36 +++++++++++--
 5 files changed, 165 insertions(+), 5 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-part.c

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 9dc43242538c..59c471c33c77 100644
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
 
 static inline bool has_vhe(void)
 {
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index c55dbac28c90..151e5b6793f2 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -87,6 +87,14 @@ void kvm_host_pmu_init(struct arm_pmu *pmu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
+u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
+u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
+void kvm_pmu_host_counters_enable(void);
+void kvm_pmu_host_counters_disable(void);
+
+#else
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -208,6 +216,24 @@ static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int id
 
 static inline void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu) {}
 
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
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 86035b311269..3edbaa57bbf2 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-v3-nested.o
 
-kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu-part.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
new file mode 100644
index 000000000000..340f8d334efd
--- /dev/null
+++ b/arch/arm64/kvm/pmu-part.c
@@ -0,0 +1,88 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Colton Lewis <coltonlewis@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+#include <linux/perf/arm_pmuv3.h>
+
+#include <asm/kvm_pmu.h>
+#include <asm/arm_pmuv3.h>
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
+	return pmu->hpmn_max <= *host_data_ptr(nr_event_counters);
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
index e47f5953928a..48ff8c65de68 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -839,12 +839,18 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
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
 
@@ -954,6 +960,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr)) {
 		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
 			return ARMV8_PMU_CYCLE_IDX;
@@ -969,6 +976,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * may not know how to handle it.
 	 */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_INST_RETIRED) &&
+	    !kvm_pmu_is_partitioned(cpu_pmu) &&
 	    !armv8pmu_event_get_threshold(&event->attr) &&
 	    test_bit(ARMV8_PMU_INSTR_IDX, cpu_pmu->cntr_mask) &&
 	    !armv8pmu_event_want_user_access(event)) {
@@ -980,7 +988,7 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	 * Otherwise use events counters
 	 */
 	if (armv8pmu_event_is_chained(event))
-		return	armv8pmu_get_chain_idx(cpuc, cpu_pmu);
+		return armv8pmu_get_chain_idx(cpuc, cpu_pmu);
 	else
 		return armv8pmu_get_single_idx(cpuc, cpu_pmu);
 }
@@ -1072,6 +1080,14 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
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
@@ -1079,6 +1095,9 @@ static void armv8pmu_reset(void *info)
 
 	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		mask &= kvm_pmu_host_counter_mask(cpu_pmu);
+
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(mask);
 	armv8pmu_disable_intens(mask);
@@ -1086,11 +1105,20 @@ static void armv8pmu_reset(void *info)
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
2.50.0.714.g196bf9f422-goog

