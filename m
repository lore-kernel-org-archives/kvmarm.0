Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC47F1946D2;
	Wed, 26 Jun 2024 22:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441163; cv=none; b=XO+sIAiPgIuU8YM6ZmezVOhD+eNm+Cfr/189lBdkM3vq9jTpzb0u0cTMrBajrKsiHqGv5Sej5aowsYu6Y4p0yBwGcVlxtrFKwyq0wOUmDD7W8N90hIknnBTz4g+xLMESKFuVL/xvE7HWV7ih3tV7J1dqhUbe0O1TW/BvXEH+jrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441163; c=relaxed/simple;
	bh=+H6yjdW/IrhMobz5fFu7MLGxXD7u5iFp/ALsvV57SAw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=IAyWuNMUv9ENFgcTf7zk3bVuooOk9DhyHqhSIy6rvoBRqqRxb2K6EXJ9Ll9DzhVZi/lg0aPtddp56VEVyLh/uKIjNiZv1x8Od8JtcjUj+8TOIM3py4f3EqUckDeVWlI+EZ6HCjHN3rTa3Gn7B7nExBnrQNRO+53F41NmEDsnbPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=arnr9mIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="arnr9mIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72709C116B1;
	Wed, 26 Jun 2024 22:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441163;
	bh=+H6yjdW/IrhMobz5fFu7MLGxXD7u5iFp/ALsvV57SAw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=arnr9mItvnVVEuQEJmtRsXBNGVdUjTkYUF1wP8jEeAeLKBznIaZw04n9Q+eBEH7V8
	 42hOMVzD/xRJz6mNhQrmiycGYODwg/+OgcxFkMloWu/OmMozQOo4uLzWbe9UrgXgY7
	 ANR+meVpHV2qwDyV0Cs0G9M58lNA+tXnrI7F5ue21D+b1rQpOqDbaffZUbyoRrkLcX
	 4DbEfc1k4xSt603p3f9Qs3NlZ3ICb9nJ1Tq5IcUNb1IzKwcLlo/OU4aUsZECCi9rpB
	 gKGdmJDK/RNHhQbmK/6OlnPK1YBCVOmA4FsJfm+QWX8xpSoOvmVUwt2fC5DhCqeZeB
	 l/cOLGtGapeGg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:28 -0600
Subject: [PATCH v2 04/12] perf: arm_v6/7_pmu: Drop non-DT probe support
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-4-c9784b4f4065@kernel.org>
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

There are no non-DT based PMU users for v6 or v7, so drop the custom
non-DT probe table. Unfortunately XScale still needs non-DT probing.

Note that this drops support for arm1156 PMU, but there are no arm1156
based systems supported in the kernel.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v2:
 - Note that XScale still needs non-DT probe
---
 drivers/perf/arm_v6_pmu.c | 17 +----------------
 drivers/perf/arm_v7_pmu.c | 10 +---------
 2 files changed, 2 insertions(+), 25 deletions(-)

diff --git a/drivers/perf/arm_v6_pmu.c b/drivers/perf/arm_v6_pmu.c
index f7593843bb85..0bb685b4bac5 100644
--- a/drivers/perf/arm_v6_pmu.c
+++ b/drivers/perf/arm_v6_pmu.c
@@ -401,13 +401,6 @@ static int armv6_1136_pmu_init(struct arm_pmu *cpu_pmu)
 	return 0;
 }
 
-static int armv6_1156_pmu_init(struct arm_pmu *cpu_pmu)
-{
-	armv6pmu_init(cpu_pmu);
-	cpu_pmu->name		= "armv6_1156";
-	return 0;
-}
-
 static int armv6_1176_pmu_init(struct arm_pmu *cpu_pmu)
 {
 	armv6pmu_init(cpu_pmu);
@@ -421,17 +414,9 @@ static const struct of_device_id armv6_pmu_of_device_ids[] = {
 	{ /* sentinel value */ }
 };
 
-static const struct pmu_probe_info armv6_pmu_probe_table[] = {
-	ARM_PMU_PROBE(ARM_CPU_PART_ARM1136, armv6_1136_pmu_init),
-	ARM_PMU_PROBE(ARM_CPU_PART_ARM1156, armv6_1156_pmu_init),
-	ARM_PMU_PROBE(ARM_CPU_PART_ARM1176, armv6_1176_pmu_init),
-	{ /* sentinel value */ }
-};
-
 static int armv6_pmu_device_probe(struct platform_device *pdev)
 {
-	return arm_pmu_device_probe(pdev, armv6_pmu_of_device_ids,
-				    armv6_pmu_probe_table);
+	return arm_pmu_device_probe(pdev, armv6_pmu_of_device_ids, NULL);
 }
 
 static struct platform_driver armv6_pmu_driver = {
diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
index fdd936fbd188..928ac3d626ed 100644
--- a/drivers/perf/arm_v7_pmu.c
+++ b/drivers/perf/arm_v7_pmu.c
@@ -1977,17 +1977,9 @@ static const struct of_device_id armv7_pmu_of_device_ids[] = {
 	{},
 };
 
-static const struct pmu_probe_info armv7_pmu_probe_table[] = {
-	ARM_PMU_PROBE(ARM_CPU_PART_CORTEX_A8, armv7_a8_pmu_init),
-	ARM_PMU_PROBE(ARM_CPU_PART_CORTEX_A9, armv7_a9_pmu_init),
-	{ /* sentinel value */ }
-};
-
-
 static int armv7_pmu_device_probe(struct platform_device *pdev)
 {
-	return arm_pmu_device_probe(pdev, armv7_pmu_of_device_ids,
-				    armv7_pmu_probe_table);
+	return arm_pmu_device_probe(pdev, armv7_pmu_of_device_ids, NULL);
 }
 
 static struct platform_driver armv7_pmu_driver = {

-- 
2.43.0

