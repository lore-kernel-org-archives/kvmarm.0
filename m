Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A59C1953BB;
	Wed, 26 Jun 2024 22:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441174; cv=none; b=KAlSpjEOlhhUCPmEWgnOgLlsbg8g07jUY85Fcqz3ZV+1FoaJ+4bxpB+XoHMdSAiqTgGPFCnFW3FBGrJ/Las39vvJGDCMKBcmIXzoQW+pa586rytfpnqCNxeQMk7dZ0Qg5mGH56zhrOwFm3V44fzQohc7MW4sXGl5PbIO6K9xLHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441174; c=relaxed/simple;
	bh=Dwd/duDp/vRwBOdI65Z0JGJma+8NpgU/zSDmEoeuinE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=iSzW9rsjNhJsKREEKmxxLxgig/FdDjuNFfBk0qBuWxN6SGezrLuGU5wWFcgDG2L3NfXfLnYpugNqG8SALX/BHYFTpxbcOT/+LLcOTWAkiL6bG9pF8aUPOMcz2B5xosm5/eoKvKNz6Cc+n+LgfmxheY5CtDyud5OL8GVixF7wfVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c9fvPWR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c9fvPWR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6057C2BD10;
	Wed, 26 Jun 2024 22:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441174;
	bh=Dwd/duDp/vRwBOdI65Z0JGJma+8NpgU/zSDmEoeuinE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=c9fvPWR08MtFyK/Su5Mf5KDcU9K6/gWQm6nYiLD7Fp6N1PPnIZEwRud855C6lXpRb
	 j4xFu1QmJiSaV8YZLUf2crtWykcvAvI1tYw9dn32206d0TRYrmhqR7cLiehLkSEXEC
	 uiAT5eYuXwQO2Pp15VaOkN7hO4TeLm1a/B3nTPw1TfZWc0uTG748qczxUckbPoLfIZ
	 SWbDUIyWSIFifdqV4NRGWpb3PTZZZN6cqNg5h6HIrvQ+4R3KMnRv92YrL9hGi1mS4l
	 A9qTFp8Dp/d1MkhCu02wfAGdWthwwINjfv9v+KfY+BDbeEf0/0GAy/N+OXe79z1fQ0
	 pNG99ayPnnBBA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:34 -0600
Subject: [PATCH v2 10/12] arm64: perf/kvm: Use a common PMU cycle counter
 define
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-10-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
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
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

The PMUv3 and KVM code each have a define for the PMU cycle counter
index. Move KVM's define to a shared location and use it for PMUv3
driver.

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
index f771242168f1..f58dff49ea7d 100644
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

