Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3525194131;
	Wed, 26 Jun 2024 22:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441160; cv=none; b=Aqw+ugn5ud/qAMxjy8DWZWlhwY1BJ5TrGGoiGtQMjuHB/vRKfYnFgtT3W7jDcAtUU9c2xeoyeqDFZ3q/FUNlK6HVQocA+e/z2L+/ueQQ6yhEuVa1gEatavjxiVGkxzZz5tYw+HR3XTZxx9hfA9YcZJLExNpZoZf/EkP9mYvfzPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441160; c=relaxed/simple;
	bh=WFW4O9a/P3vJBEq/1R2/A6s4nHRFlDzLuQG5qk6khFQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=BsfxrZbdpV5eYQ4J2djZDww/JXFmjvk+aDLefos5PEKL5sbMHnFG8/VSdGWHx0XJ3aisTQO+Nv73AdXj5m1N8h802PwnBWRCTcV3nni4vuGVRMtKNZu1F2thXlyajrJ5O/oOlRKkOYaAePMGblHdEBr//5/I+1jvmCPPl/b2Hh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqnRnP7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqnRnP7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C836C4AF07;
	Wed, 26 Jun 2024 22:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441160;
	bh=WFW4O9a/P3vJBEq/1R2/A6s4nHRFlDzLuQG5qk6khFQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jqnRnP7kq3HQQ6yTW0IAppr/Mqyt5PEzSwDm8LbWM0gG7EGy7/OIMN01Xf2XPDnUy
	 DvS79Lywp5m8Ahl0QbN0gj3imZpqFy4SpwqPijMiRvgY+cSomahgvPg8LAgc1Qcsfe
	 Gc15rJrNgJPH82M0T39zxMkOjsBOyX8YGsbsJtjiokgfQJyHUsM8YqYduZ0FxdFz+y
	 4QHfUnbF+VquXUuRyd+AbYlR1aV8tbnCMfb8kOKcg1HwU8VlvGYstP0rmvmsVK4zlv
	 B9X0A9vv2yL7uFwSPP3p6Ijm6+WYrsNfs4RuExi6QzKMPQu9z+mKVM52/20asaCeD+
	 r8nsoBCTHYLVQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:26 -0600
Subject: [PATCH v2 02/12] perf: arm_pmuv3: Drop unnecessary
 IS_ENABLED(CONFIG_ARM64) check
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-2-c9784b4f4065@kernel.org>
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

The IS_ENABLED(CONFIG_ARM64) check for threshold support is unnecessary.
The purpose is to not enable thresholds on arm32, but if threshold is
non-zero, the check against threshold_max() just above here will have
errored out because threshold_max() is always 0 on arm32.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - new patch
---
 drivers/perf/arm_pmuv3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 8ed5c3358920..3e51cd7062b9 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -1045,7 +1045,7 @@ static int armv8pmu_set_event_filter(struct hw_perf_event *event,
 		return -EINVAL;
 	}
 
-	if (IS_ENABLED(CONFIG_ARM64) && th) {
+	if (th) {
 		config_base |= FIELD_PREP(ARMV8_PMU_EVTYPE_TH, th);
 		config_base |= FIELD_PREP(ARMV8_PMU_EVTYPE_TC,
 					  armv8pmu_event_threshold_control(attr));

-- 
2.43.0

