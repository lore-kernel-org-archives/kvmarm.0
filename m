Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492DC155A47;
	Fri,  7 Jun 2024 20:32:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792333; cv=none; b=UIrx8gUNwKqDfPQj7lirIwqNFS/Ts/WOauF16lHryWOZviVqG69hZSnvjt+sTMqM9IwHFifBXbDml2N6ddnalpCUOWEZK2EmM66qkDBC7YQOSlEYidJOf7VCccYN7WKoH2y+SGTUWH9vXuR/gH0+V2xcVNsF0o/a7tWxYWeL7OM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792333; c=relaxed/simple;
	bh=0PuD070n2iQEaU9GwC/6rdl3ex4y0laQrCuOVZ80ZSM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p9jfxSzaxoYLmlDw//tpy/BEJrZnjK5Lp0lry+DD61+mZ4P8ghIlnfPaw7FR7CTQwv/fKmtgIW6CIq4aWjxk+Vnv1Y6nDN3BpdaWf13TIvCD+18gmwyp+3X+3s0r6EL0ikkfZVv5Hi4fuRsRTfUr3xkaAq5k1ZEcZaoVOwzj5+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAUj+VV4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAUj+VV4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A82C7C32782;
	Fri,  7 Jun 2024 20:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792332;
	bh=0PuD070n2iQEaU9GwC/6rdl3ex4y0laQrCuOVZ80ZSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KAUj+VV4IljDqnnGXjXbzgTEJO9m2AWbY51T7niBiiXSJgW/4fkvZJuCOlqAw4X5G
	 b+f5H1ZTXo9khnQEN7o/eSXMOUA7gVZtvCZ/xmPtpEnA3BYSrnh78upORearDd8rJ2
	 zzbzGpkbKLjh439z3pcJ1EI1BsWCl3Zpu9kw17GAC4P8A8husFUQk7yjjuK7ZKwLpS
	 VJP2+OKt1hEUsUkUsTO10AJKd9vIkV3RDFO5bLiIt9Q3GF9YirLGQPxoqGX/8pU0vB
	 RyFilF/uBjTzHtMYtvDNR5DNB3v6vNUq6mb3ItKcsqBTBRdxmMBaoFjh3hLzKfNOK3
	 W+ksPlXAkBgZw==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Fri, 07 Jun 2024 14:31:32 -0600
Subject: [PATCH 7/9] arm64: perf/kvm: Use a common PMU cycle counter define
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-7-c7bd2dceff3b@kernel.org>
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
In-Reply-To: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

The PMUv3 and KVM code each have a define for the PMU cycle counter
index. Move KVM's define to a shared location and use it for PMUv3
driver.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm/include/asm/arm_pmuv3.h   |  2 ++
 arch/arm64/include/asm/arm_pmuv3.h |  2 ++
 arch/arm64/kvm/sys_regs.c          |  1 +
 drivers/perf/arm_pmuv3.c           | 23 +++++++++--------------
 include/kvm/arm_pmu.h              |  1 -
 5 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index a41b503b7dcd..ac2cf37b57e3 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -9,6 +9,8 @@
 #include <asm/cp15.h>
 #include <asm/cputype.h>
 
+#define ARMV8_PMU_CYCLE_IDX		31
+
 #define PMCCNTR			__ACCESS_CP15_64(0, c9)
 
 #define PMCR			__ACCESS_CP15(c9,  0, c12, 0)
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 1ed91334fede..46930729fb3f 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -11,6 +11,8 @@
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
+#define ARMV8_PMU_CYCLE_IDX		31
+
 #define RETURN_READ_PMEVCNTRN(n) \
 	return read_sysreg(pmevcntr##n##_el0)
 static inline unsigned long read_pmevcntrn(int n)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index f8b5db48ea8a..22393ae7ce14 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -18,6 +18,7 @@
 #include <linux/printk.h>
 #include <linux/uaccess.h>
 
+#include <asm/arm_pmuv3.h>
 #include <asm/cacheflush.h>
 #include <asm/cputype.h>
 #include <asm/debug-monitors.h>
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 3b49144f3a58..468a0a3bbd5a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -448,11 +448,6 @@ static const struct attribute_group armv8_pmuv3_caps_attr_group = {
 	.attrs = armv8_pmuv3_caps_attrs,
 };
 
-/*
- * Perf Events' indices
- */
-#define	ARMV8_IDX_CYCLE_COUNTER	31
-
 /*
  * We unconditionally enable ARMv8.5-PMU long event counter support
  * (64-bit events) where supported. Indicate if this arm_pmu has long
@@ -484,7 +479,7 @@ static bool armv8pmu_event_is_chained(struct perf_event *event)
 	return !armv8pmu_event_has_user_read(event) &&
 	       armv8pmu_event_is_64bit(event) &&
 	       !armv8pmu_has_long_event(cpu_pmu) &&
-	       (idx != ARMV8_IDX_CYCLE_COUNTER);
+	       (idx != ARMV8_PMU_CYCLE_IDX);
 }
 
 /*
@@ -543,7 +538,7 @@ static bool armv8pmu_event_needs_bias(struct perf_event *event)
 		return false;
 
 	if (armv8pmu_has_long_event(cpu_pmu) ||
-	    idx == ARMV8_IDX_CYCLE_COUNTER)
+	    idx == ARMV8_PMU_CYCLE_IDX)
 		return true;
 
 	return false;
@@ -571,7 +566,7 @@ static u64 armv8pmu_read_counter(struct perf_event *event)
 	int idx = hwc->idx;
 	u64 value;
 
-	if (idx == ARMV8_IDX_CYCLE_COUNTER)
+	if (idx == ARMV8_PMU_CYCLE_IDX)
 		value = read_pmccntr();
 	else
 		value = armv8pmu_read_hw_counter(event);
@@ -604,7 +599,7 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
 
 	value = armv8pmu_bias_long_counter(event, value);
 
-	if (idx == ARMV8_IDX_CYCLE_COUNTER)
+	if (idx == ARMV8_PMU_CYCLE_IDX)
 		write_pmccntr(value);
 	else
 		armv8pmu_write_hw_counter(event, value);
@@ -641,7 +636,7 @@ static void armv8pmu_write_event_type(struct perf_event *event)
 		armv8pmu_write_evtype(idx - 1, hwc->config_base);
 		armv8pmu_write_evtype(idx, chain_evt);
 	} else {
-		if (idx == ARMV8_IDX_CYCLE_COUNTER)
+		if (idx == ARMV8_PMU_CYCLE_IDX)
 			write_pmccfiltr(hwc->config_base);
 		else
 			armv8pmu_write_evtype(idx, hwc->config_base);
@@ -768,7 +763,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 
 	/* Clear any unused counters to avoid leaking their contents */
 	for_each_clear_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
-		if (i == ARMV8_IDX_CYCLE_COUNTER)
+		if (i == ARMV8_PMU_CYCLE_IDX)
 			write_pmccntr(0);
 		else
 			armv8pmu_write_evcntr(i, 0);
@@ -928,8 +923,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if (evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) {
-		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
-			return ARMV8_IDX_CYCLE_COUNTER;
+		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
+			return ARMV8_PMU_CYCLE_IDX;
 		else if (armv8pmu_event_is_64bit(event) &&
 			   armv8pmu_event_want_user_access(event) &&
 			   !armv8pmu_has_long_event(cpu_pmu))
@@ -1191,7 +1186,7 @@ static void __armv8pmu_probe_pmu(void *info)
 		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
 
 	/* Add the CPU cycles counter */
-	bitmap_set(cpu_pmu->cntr_mask, ARMV8_IDX_CYCLE_COUNTER, 1);
+	bitmap_set(cpu_pmu->cntr_mask, ARMV8_PMU_CYCLE_IDX, 1);
 
 	pmceid[0] = pmceid_raw[0] = read_pmceid0();
 	pmceid[1] = pmceid_raw[1] = read_pmceid1();
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 334d7c5503cf..871067fb2616 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -10,7 +10,6 @@
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
 
-#define ARMV8_PMU_CYCLE_IDX		(ARMV8_PMU_MAX_COUNTERS - 1)
 
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {

-- 
2.43.0

