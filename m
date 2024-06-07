Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8EB154BFB;
	Fri,  7 Jun 2024 20:32:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717792326; cv=none; b=bchkU6eFkNYvTyejCaJykS4cQsuKjWQfZVQN/Ug17GjrXTZvchbKFHf1Qe2AD4PL5+66VTXYqvi55OhCm/900gJfhjYrvtAAe66fD9rUmzr06uGCnC5TgOsl594k4XEnkC+1ZLS/EN9peDoqADgmq2KXeUOkx0Jkuw03eVvIW0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717792326; c=relaxed/simple;
	bh=HBZLgS2LXgUqfTn0Nl4TrmtgYXpXNMKYvKyVmoxUwjM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=V/ebQSj98BtJRTnPiI2xk3MmVRm9hrs3jg/+2i02ByRNjBLYCF/VNeVhCnDFlgw3bIMiCWwb1P4e1q8vVFaxbJs101mgi4Sta4WsKfM/3krg1TAAYgxQnJfGm1QAG1iwDP1Vs02EmPghAirfCHU+x4ZHCKDmK/CmOujvEjwds8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WfNPxBQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WfNPxBQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9961EC32781;
	Fri,  7 Jun 2024 20:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717792325;
	bh=HBZLgS2LXgUqfTn0Nl4TrmtgYXpXNMKYvKyVmoxUwjM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=WfNPxBQmwRVXcwIST4BC7IJCXp4/rTNUJzAVD1GARUWz+0AQo/etwkM3OsQv8Vo0p
	 XESZqf74bQPPhqiZOiEcKeRq+UT6ew2fETMERBLxdZ89F8pSL3jTLlSP440aC96oK4
	 en8jJV05w0ydNPZFs0NiGWMkfCsv/XrQOAM6NP1lJXq7DfwTVisEtKWYT9qrJ/i2fw
	 2ZBEpyMjbiN1r4JPzUK2JFmDXXJcUijg3kRygcklKYFUZSKfmFpJ2XUC2If3yjbAlp
	 az42GwH5bBlFdXzTSAs5xeKSP35ihrxkF4QJ0sngzZo4/3Ivh3O6uWZ+BwCCvYyX6b
	 w+Cq5myiqzu6w==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Fri, 07 Jun 2024 14:31:27 -0600
Subject: [PATCH 2/9] perf: arm_v6/7_pmu: Drop non-DT probe support
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240607-arm-pmu-3-9-icntr-v1-2-c7bd2dceff3b@kernel.org>
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

There are no non-DT based PMU users for v6 or v7, so drop the custom
non-DT probe table.

Note that this drops support for arm1156 PMU, but there are no arm1156
based systems supported in the kernel.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

