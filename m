Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D645C1D935C
	for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 22:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738016454; cv=none; b=qKom4Qwj9mKwdqd9rcl5P1U2edu++YYA/ThqovLLC4FL4iceJm6GWroRNuLoZW34bGjS9rrOat+HZMP7R3ICuuiFBq61M/DKCRCm8TZiY2CfHVynXygZeYLmFki27nWXeVL0tS7W+SMJB6VtU+N5BEIJHCPH1rueHnUgoGD999I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738016454; c=relaxed/simple;
	bh=OFXUUpVM5xCyc7SM7fsv7AifVke2OdEg9lg1/oLLCic=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=XYrIHIw09knk6H7cw7gWYCw4sRd9KkQwdKDD3Pnz90Em4IZxKi7zTyya1T7Abj/rPd1pXLHONO9RrkNgtRVFvyuSJJIUcRdqfP9/9Kg5zzOa92u7YTZhpNVit4KUxf5Gh6iMVehjB6W0HhNXaiCb0VNkUssH0dIzRJXxN+fjeOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S6Fbh1Uc; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S6Fbh1Uc"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-3eb8507f344so3744595b6e.1
        for <kvmarm@lists.linux.dev>; Mon, 27 Jan 2025 14:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738016452; x=1738621252; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=J+qObDwS88LTAskUjFBnmb2tHGwgbjCOQx4TzLmc3bo=;
        b=S6Fbh1UcYe8VXZtqG4wQcSBA8LJqupd8bvgS9wdkwoIlQdo0JHX0SU7ZgKIABY4C8q
         QHhESTIGZO9ES2knDIR23FMsSEUMsXJAbMEe58w8qHxqXEKtFV2SNHI13qRy6IxqXQB+
         P9ZJlV3TEQ63P2vI5D/IGoitrMfVZDgHgovsTjYjF3GppX+NY5ledEyleJvJmfd7Ahfe
         ascAKtMqZSMHtREeVtQTSBYBfruIXmthOrg/ncWdHPcpSNZPpTB9hOAPCY7qW91Tni3i
         hRqskIl2PgjNatDWE+CGz7eE1DY2fNopzQtfjT+AKtWGv3XMRpSXjaf6OXPQYUfnKH7x
         //UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738016452; x=1738621252;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J+qObDwS88LTAskUjFBnmb2tHGwgbjCOQx4TzLmc3bo=;
        b=k+IgDyXvIddEr0g4eHFs4tDay0507VT8U2pdn1+SeCRWBjvdShsUJibKM0Yq51dme2
         LhFXdHa+byM3q7PLQHiYMppFRzcpd+NuyAalXQNtqIC+ahxiMr50Sxmw/aZPBi99LOS/
         eOQt8lgFlbIdEtCRfXKxhV2tIc30OQ3/5Ajn95YzPD9JJKaxX3MexDK8r1vQjDyqgHkZ
         /x9GKtefGAHYmjJx109dCLNQ5R422UeDmcQxppWKH+BQCwHFkCbw7GIheDyTEA02dVAT
         4eBtAuprQHP3e0vET9YouYJLCdihYz/NsGDAEYpWFHPjLQN6qZHagj31A4mERYT9Xc4h
         15aw==
X-Forwarded-Encrypted: i=1; AJvYcCWFwyCea3nYuC82gY/oCnir7B0+J/liq1VTBuj4vMfUUl/RYjmqyjW5AVuXzLZECj7+BUyRYDY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSaGL0e37sD3b8OOk9XaxjCcKlwFBfbbTCdyOdBF1FC61oKZ3U
	cjxiO1jMejg9kQdp5DvVIqqWCyDbm+B5HDVf4PS535JiF9eDrjE8GikwXJW27MFLHgbLC6h/cr+
	o9t3UlHiweW2r+9Kr98aTcA==
X-Google-Smtp-Source: AGHT+IGwmY6EDgFuxeR3LWy7D1Q3b/YTDKxzwuYjqYnE2eZqfv0wem+uFwxiXcUXaHQYscSNGguM00ZFGJ5jekmJ8A==
X-Received: from oojj19.prod.google.com ([2002:a05:6820:a013:b0:5f6:2f27:1d57])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3c96:b0:3eb:549b:2c14 with SMTP id 5614622812f47-3f19fbfcd73mr29492204b6e.2.1738016451988;
 Mon, 27 Jan 2025 14:20:51 -0800 (PST)
Date: Mon, 27 Jan 2025 22:20:27 +0000
In-Reply-To: <20250127222031.3078945-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250127222031.3078945-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.262.g85cc9f2d1e-goog
Message-ID: <20250127222031.3078945-2-coltonlewis@google.com>
Subject: [RFC PATCH 1/4] perf: arm_pmuv3: Introduce module param to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

For PMUv3, the register MDCR_EL2.HPMN partitiones the PMU counters
into two ranges where counters 0..HPMN-1 are accessible by EL1 and, if
allowed, EL0 while counters HPMN..N are only accessible by EL2.

Introduce a module parameter in the PMUv3 driver to set this
register. The name reserved_guest_counters reflects the intent to
reserve some counters for the guest so they may eventually be allowed
direct access to a subset of PMU functionality for increased
performance.

Track HPMN and whether the pmu is partitioned in struct arm_pmu.

While FEAT_HPMN0 does allow HPMN to be set to 0, this patch
specifically disallows that case because it's not useful given the
intention to allow guests access to their own counters.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h   | 10 +++++++
 arch/arm64/include/asm/arm_pmuv3.h | 10 +++++++
 drivers/perf/arm_pmuv3.c           | 43 ++++++++++++++++++++++++++++--
 include/linux/perf/arm_pmu.h       |  2 ++
 include/linux/perf/arm_pmuv3.h     |  7 +++++
 5 files changed, 70 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 2ec0e5e83fc9..49ad90486aa5 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -277,4 +277,14 @@ static inline u64 read_pmceid1(void)
 	return val;
 }
 
+static inline u32 read_mdcr(void)
+{
+	return read_sysreg(mdcr_el2);
+}
+
+static inline void write_mdcr(u32 val)
+{
+	write_sysreg(val, mdcr_el2);
+}
+
 #endif
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..fc37e7e81e07 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -188,4 +188,14 @@ static inline bool is_pmuv3p9(int pmuver)
 	return pmuver >= ID_AA64DFR0_EL1_PMUVer_V3P9;
 }
 
+static inline u64 read_mdcr(void)
+{
+	return read_sysreg(mdcr_el2);
+}
+
+static inline void write_mdcr(u64 val)
+{
+	write_sysreg(val, mdcr_el2);
+}
+
 #endif
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index b5cc11abc962..55f9ae560715 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -325,6 +325,7 @@ GEN_PMU_FORMAT_ATTR(threshold_compare);
 GEN_PMU_FORMAT_ATTR(threshold);
 
 static int sysctl_perf_user_access __read_mostly;
+static u8 reserved_guest_counters __read_mostly;
 
 static bool armv8pmu_event_is_64bit(struct perf_event *event)
 {
@@ -500,6 +501,29 @@ static void armv8pmu_pmcr_write(u64 val)
 	write_pmcr(val);
 }
 
+static u64 armv8pmu_mdcr_read(void)
+{
+	return read_mdcr();
+}
+
+static void armv8pmu_mdcr_write(u64 val)
+{
+	write_mdcr(val);
+	isb();
+}
+
+static void armv8pmu_partition(u8 hpmn)
+{
+	u64 mdcr = armv8pmu_mdcr_read();
+
+	mdcr &= ~MDCR_EL2_HPMN_MASK;
+	mdcr |= FIELD_PREP(ARMV8_PMU_MDCR_HPMN, hpmn);
+	/* Prevent guest counters counting at EL2 */
+	mdcr |= ARMV8_PMU_MDCR_HPMD;
+
+	armv8pmu_mdcr_write(mdcr);
+}
+
 static int armv8pmu_has_overflowed(u64 pmovsr)
 {
 	return !!(pmovsr & ARMV8_PMU_OVERFLOWED_MASK);
@@ -1069,6 +1093,9 @@ static void armv8pmu_reset(void *info)
 
 	bitmap_to_arr64(&mask, cpu_pmu->cntr_mask, ARMPMU_MAX_HWEVENTS);
 
+	if (cpu_pmu->partitioned)
+		armv8pmu_partition(cpu_pmu->hpmn);
+
 	/* The counter and interrupt enable registers are unknown at reset. */
 	armv8pmu_disable_counter(mask);
 	armv8pmu_disable_intens(mask);
@@ -1205,6 +1232,7 @@ static void __armv8pmu_probe_pmu(void *info)
 {
 	struct armv8pmu_probe_info *probe = info;
 	struct arm_pmu *cpu_pmu = probe->pmu;
+	u8 pmcr_n;
 	u64 pmceid_raw[2];
 	u32 pmceid[2];
 	int pmuver;
@@ -1215,10 +1243,19 @@ static void __armv8pmu_probe_pmu(void *info)
 
 	cpu_pmu->pmuver = pmuver;
 	probe->present = true;
+	pmcr_n = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	bitmap_set(cpu_pmu->cntr_mask,
-		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
+	bitmap_set(cpu_pmu->cntr_mask, 0, pmcr_n);
+
+	if (reserved_guest_counters > 0 && reserved_guest_counters < pmcr_n) {
+		cpu_pmu->hpmn = reserved_guest_counters;
+		cpu_pmu->partitioned = true;
+	} else {
+		reserved_guest_counters = 0;
+		cpu_pmu->hpmn = pmcr_n;
+		cpu_pmu->partitioned = false;
+	}
 
 	/* Add the CPU cycles counter */
 	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
@@ -1516,3 +1553,5 @@ void arch_perf_update_userpage(struct perf_event *event,
 	userpg->cap_user_time_zero = 1;
 	userpg->cap_user_time_short = 1;
 }
+
+module_param(reserved_guest_counters, byte, 0);
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 4b5b83677e3f..ad97aabed25a 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -101,6 +101,8 @@ struct arm_pmu {
 	void		(*reset)(void *);
 	int		(*map_event)(struct perf_event *event);
 	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
+	u8		hpmn; /* MDCR_EL2.HPMN: counter partition pivot */
+	bool	        partitioned;
 	bool		secure_access; /* 32-bit ARM only */
 #define ARMV8_PMUV3_MAX_COMMON_EVENTS		0x40
 	DECLARE_BITMAP(pmceid_bitmap, ARMV8_PMUV3_MAX_COMMON_EVENTS);
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index d698efba28a2..d399e8c6f98e 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -223,6 +223,13 @@
 				 ARMV8_PMU_PMCR_X | ARMV8_PMU_PMCR_DP | \
 				 ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP)
 
+/*
+ * Per-CPU MDCR: config reg
+ */
+#define ARMV8_PMU_MDCR_HPMN		GENMASK(4, 0)
+#define ARMV8_PMU_MDCR_HPME		BIT(7)
+#define ARMV8_PMU_MDCR_HPMD		BIT(17)
+
 /*
  * PMOVSR: counters overflow flag status reg
  */
-- 
2.48.1.262.g85cc9f2d1e-goog

