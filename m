Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0611F194081;
	Wed, 26 Jun 2024 22:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441159; cv=none; b=n78nwW2EROvQIjONGTDvpLHUTUWYa61TNBYkERggZkcesQlxl27ZVuOOZOpJxbS2bf1/VBnIYW+xtCYdTBYp1463BlErn/Ia43zFmkN1j326U/Z5l0WfrvkGbHVXEDkt05ddm8mRoNSrNaDpsZ1Uu7i7MqJ05S2XG5G/P7RL1BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441159; c=relaxed/simple;
	bh=acEqJRld4aaAwF/FQV6CD2Di0ENXDKGblEFIRkrSSxI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ErEqfrKGZSh82hRPxN3OCq5+AVMPQyYVCQOVIU66l2+AuWIbWpjGMLu+GoiIz1q8E50S/uKrpvJg5ErRIGdlmGz3XUzel8HGB/dvkH1edOvZYLYX/w7Mm/DzWIEejHCDZ8kCkLzhTcTN4Ughtc2B47wvdUqToaaWERoaeYZwoog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=udeLf8lZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="udeLf8lZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702F4C32789;
	Wed, 26 Jun 2024 22:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441158;
	bh=acEqJRld4aaAwF/FQV6CD2Di0ENXDKGblEFIRkrSSxI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=udeLf8lZU5JtyXeXK3aJgJ5ZFbKUGK3E/HBlBD7PSQwzvahYPQlr0gAA478XGid05
	 JWAJD0UfpyT8nburYYBEQciFf1rYIA+QhkiBKD9eV7hTAwVoQxYL5eEhDQu/DNvTAg
	 uh9MHE9SqAQWPA0D+5Nf5N0MZviQKrlEst0s2XiSmnCPboiDDgUpy7YHDOlz2MQgBO
	 vfJEAICL6wB1WayJxlq4aMXAawaoomlm0U658P88UTmkgzX/SXspLQTF/qOxdaY73p
	 UKkS5yC/yez+ltLDgSRYCn9MMe+RrUsbTUiHzmREIgxYcGyQlyXq7C+8j8Cug7MtRW
	 9AOZf8kYYRyJg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:25 -0600
Subject: [PATCH v2 01/12] perf: arm_pmuv3: Avoid assigning fixed cycle
 counter with threshold
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-1-c9784b4f4065@kernel.org>
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

If the user has requested a counting threshold for the CPU cycles event,
then the fixed cycle counter can't be assigned as it lacks threshold
support. Currently, the thresholds will work or not randomly depending
on which counter the event is assigned.

While using thresholds for CPU cycles doesn't make much sense, it can be
useful for testing purposes.

Fixes: 816c26754447 ("arm64: perf: Add support for event counting threshold")
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
This should go to 6.10 and stable. It is also a dependency for ICNTR
support.

v2:
 - Add and use armv8pmu_event_get_threshold() helper.

v1: https://lore.kernel.org/all/20240611155012.2286044-1-robh@kernel.org/
---
 drivers/perf/arm_pmuv3.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 23fa6c5da82c..8ed5c3358920 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -338,6 +338,11 @@ static bool armv8pmu_event_want_user_access(struct perf_event *event)
 	return ATTR_CFG_GET_FLD(&event->attr, rdpmc);
 }
 
+static u32 armv8pmu_event_get_threshold(struct perf_event_attr *attr)
+{
+	return ATTR_CFG_GET_FLD(attr, threshold);
+}
+
 static u8 armv8pmu_event_threshold_control(struct perf_event_attr *attr)
 {
 	u8 th_compare = ATTR_CFG_GET_FLD(attr, threshold_compare);
@@ -941,7 +946,8 @@ static int armv8pmu_get_event_idx(struct pmu_hw_events *cpuc,
 	unsigned long evtype = hwc->config_base & ARMV8_PMU_EVTYPE_EVENT;
 
 	/* Always prefer to place a cycle counter into the cycle counter. */
-	if (evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) {
+	if ((evtype == ARMV8_PMUV3_PERFCTR_CPU_CYCLES) &&
+	    !armv8pmu_event_get_threshold(&event->attr)) {
 		if (!test_and_set_bit(ARMV8_IDX_CYCLE_COUNTER, cpuc->used_mask))
 			return ARMV8_IDX_CYCLE_COUNTER;
 		else if (armv8pmu_event_is_64bit(event) &&
@@ -1033,7 +1039,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 	 * If FEAT_PMUv3_TH isn't implemented, then THWIDTH (threshold_max) will
 	 * be 0 and will also trigger this check, preventing it from being used.
 	 */
-	th = ATTR_CFG_GET_FLD(attr, threshold);
+	th = armv8pmu_event_get_threshold(attr);
 	if (th > threshold_max(cpu_pmu)) {
 		pr_debug("PMU event threshold exceeds max value\n");
 		return -EINVAL;

-- 
2.43.0

