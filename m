Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3941BE24F;
	Wed, 31 Jul 2024 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444708; cv=none; b=N3TCtbdCfZk02JOXPIjA9CwqdHVNjIEQIU+P6fqU7Ai7eYTHA2JqcUF3Xjj9pX+jmSPHPRIcvreMg2HAuDDs1vp84l6Y32G9laNYKZn6IsFcrUwkzOJn8Ny/Xjgvidb63TppOoKq4vmni8YodTNPU5GpG+3fWYYYUh9bxYjPYXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444708; c=relaxed/simple;
	bh=qwLOrEKtP0iovFP0me6J6poit6hFpATmdQzESC42ZcA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Z4D6xNeF4Fr7PNKkWA4UtJfXpXy42znrGbxy9BBquxLJyzG1ETn53Mp4h8Lyp1GahoTVFHndr+9vPeP8jnrJSnonCsFAEWfWMFlAaE8ErvOl2RF9uN/gbmOpuwOXrx0IM+/sMVXFNIa9Ht+fJW0Jwzg7rKAXjxgy2cMDl7ZPXy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AvNAbZMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AvNAbZMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D173C4AF0B;
	Wed, 31 Jul 2024 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722444708;
	bh=qwLOrEKtP0iovFP0me6J6poit6hFpATmdQzESC42ZcA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=AvNAbZMjPU9AqGj2nGAGEw2NhEvATXks4+3osrBCDevB8QiqyXscpUabYx47GC5s7
	 cPLrR3i6bGh5kXCkjzRwNPCN1knLAy5CraHiSu/eDON4TeRl+ZBNvMfihbqq30r1iL
	 +Q9vH2v6EcocNPEDpvTOdb68drXmaq/jtNZRQxy3ZrDhDOaaoNXWjRQLmHmc86nIM4
	 A6LneQO43UdbfGKUoCbl8N4/CKH0r0ABiahxOXQEOdCQXRrqDAWKfr9yaTfJEPDjWv
	 3nS9uL6wQo+6kcg5dex75SdiTihLzANHls0iI2Y4c3yUFEvdf7zT8gLcjbyjKbgNrG
	 zbJ0m+ah6GQZQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 31 Jul 2024 10:51:22 -0600
Subject: [PATCH v3 5/7] arm64: perf/kvm: Use a common PMU cycle counter
 define
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240731-arm-pmu-3-9-icntr-v3-5-280a8d7ff465@kernel.org>
References: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
In-Reply-To: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, James Clark <james.clark@linaro.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

The PMUv3 and KVM code each have a define for the PMU cycle counter
index. Move KVM's define to a shared location and use it for PMUv3
driver.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Move ARMV8_PMU_CYCLE_IDX to linux/perf/arm_pmuv3.h
---
 arch/arm64/kvm/sys_regs.c      |  1 +
 drivers/perf/arm_pmuv3.c       | 19 +++++++------------
 include/kvm/arm_pmu.h          |  1 -
 include/linux/perf/arm_pmuv3.h |  3 +++
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 33497db257fb..7db24de37ed6 100644
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
index bd45fbcb9a5a..18046cf4b3a3 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -451,11 +451,6 @@ static const struct attribute_group armv8_pmuv3_caps_attr_group = {
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
@@ -574,7 +569,7 @@ static u64 armv8pmu_read_counter(struct perf_event *event)
 	int idx = hwc->idx;
 	u64 value;
 
-	if (idx == ARMV8_IDX_CYCLE_COUNTER)
+	if (idx == ARMV8_PMU_CYCLE_IDX)
 		value = read_pmccntr();
 	else
 		value = armv8pmu_read_hw_counter(event);
@@ -607,7 +602,7 @@ static void armv8pmu_write_counter(struct perf_event *event, u64 value)
 
 	value = armv8pmu_bias_long_counter(event, value);
 
-	if (idx == ARMV8_IDX_CYCLE_COUNTER)
+	if (idx == ARMV8_PMU_CYCLE_IDX)
 		write_pmccntr(value);
 	else
 		armv8pmu_write_hw_counter(event, value);
@@ -644,7 +639,7 @@ static void armv8pmu_write_event_type(struct perf_event *event)
 		armv8pmu_write_evtype(idx - 1, hwc->config_base);
 		armv8pmu_write_evtype(idx, chain_evt);
 	} else {
-		if (idx == ARMV8_IDX_CYCLE_COUNTER)
+		if (idx == ARMV8_PMU_CYCLE_IDX)
 			write_pmccfiltr(hwc->config_base);
 		else
 			armv8pmu_write_evtype(idx, hwc->config_base);
@@ -772,7 +767,7 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 	/* Clear any unused counters to avoid leaking their contents */
 	for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
 			    ARMPMU_MAX_HWEVENTS) {
-		if (i == ARMV8_IDX_CYCLE_COUNTER)
+		if (i == ARMV8_PMU_CYCLE_IDX)
 			write_pmccntr(0);
 		else
 			armv8pmu_write_evcntr(i, 0);
@@ -933,8 +928,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	/* Always prefer to place a cycle counter into the cycle counter. */
 	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
 	    !armv8pmu_event_get_threshold(&event->attr)) {
-		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
-			return ARMV8_IDX_CYCLE_COUNTER;
+		if (!test_and_set_bit(ARMV8_PMU_CYCLE_IDX, cpuc->used_mask))
+			return ARMV8_PMU_CYCLE_IDX;
 		else if (armv8pmu_event_is_64bit(event) &&
 			   armv8pmu_event_want_user_access(event) &&
 			   !armv8pmu_has_long_event(cpu_pmu))
@@ -1196,7 +1191,7 @@ static void __armv8pmu_probe_pmu(void *info)
 		   0, FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read()));
 
 	/* Add the CPU cycles counter */
-	set_bit(ARMV8_IDX_CYCLE_COUNTER, cpu_pmu->cntr_mask);
+	set_bit(ARMV8_PMU_CYCLE_IDX, cpu_pmu->cntr_mask);
 
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
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index 792b8e10b72a..f4ec76f725a3 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -9,6 +9,9 @@
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
 #define ARMV8_PMU_MAX_COUNTERS	32
 
+#define ARMV8_PMU_CYCLE_IDX		31
+
+
 /*
  * Common architectural and microarchitectural event numbers.
  */

-- 
2.43.0

