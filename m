Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D58BD1E0E0D;
	Tue, 18 Feb 2025 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911240; cv=none; b=C8y7+A8gUnF3brgZcDz1C/Fnxke+zWA4FBuXymLwh44YSHDn5OcOJ9+GuKNhlS6+bQyXuJncUPysGRT10tZpq6GtPIq9OIn2ILvmKeLILFC/KrBEj3aDMU95PrZauBERiN6GEJUKpFFVXQkhmBR3ZfzaevQZgj/cFhuLm8Radsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911240; c=relaxed/simple;
	bh=WOev3GWVs5k3PS+7RVxODhtU0P5MrvrxotTjByzSK9o=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bwmmI7EpbLah9EzfxtbInnLvRIPCkAzPEKNW4NzMY430Zj/HPC77uc5CbQraE29/BCH8/pZRDkRu3FPAKV53k9vsPU42qBVXainGxOhLLocjUlaZw+gvpKu/ivuDMAB6oeZUbYyzFJQxBK2vY3Rg6emY9vZ9fVBEW398LM9tLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=i9KbD9AH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i9KbD9AH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3E0C4AF19;
	Tue, 18 Feb 2025 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911240;
	bh=WOev3GWVs5k3PS+7RVxODhtU0P5MrvrxotTjByzSK9o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=i9KbD9AHF0nvLUvui2jkZzjoEqOmRbOxTg2F9TkX6fAo2Peu0PfCocd510+weACvL
	 PcfKNCcoq7Jz/tLJcjHqHxNcbbGgIN6mE3/pbLiRhQZh7n1kQ9wTSDDF3gpK2MYEaO
	 tKgim/eIZRCHAaEdgWxvx0Wqmd4HYOatNkeHQ8929DUmJ87zpyzq/lnJY2VBV6+7LZ
	 e6SQEIbyLWoDsSE2sRPB9kDuNloGh8Xc/aWQFAxHBuiwfdI5+VKubO2QU5lRbnQCXN
	 EENE+PCxSjvUA4+idGJG80bB0OqaTqjQ9qqN/0yj9fcnUFKQjrGh6RW4BxS6TtUsNR
	 N/uypyrmHzNYA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:39:59 -0600
Subject: [PATCH v20 04/11] perf: arm_v7_pmu: Drop obvious comments for
 enabling/disabling counters and interrupts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-4-4e9922fc2e8e@kernel.org>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
In-Reply-To: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

The function calls for enabling/disabling counters and interrupts are
pretty obvious as to what they are doing, and the comments don't add
any additional value.

Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 drivers/perf/arm_v7_pmu.c | 44 --------------------------------------------
 1 file changed, 44 deletions(-)

diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
index 420cadd108e7..7fa88e3b64e0 100644
--- a/drivers/perf/arm_v7_pmu.c
+++ b/drivers/perf/arm_v7_pmu.c
@@ -857,14 +857,6 @@ static void armv7pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
-	/*
-	 * Enable counter and interrupt, and set the counter to count
-	 * the event that we're interested in.
-	 */
-
-	/*
-	 * Disable counter
-	 */
 	armv7_pmnc_disable_counter(idx);
 
 	/*
@@ -875,14 +867,7 @@ static void armv7pmu_enable_event(struct perf_event *event)
 	if (cpu_pmu->set_event_filter || idx != ARMV7_IDX_CYCLE_COUNTER)
 		armv7_pmnc_write_evtsel(idx, hwc->config_base);
 
-	/*
-	 * Enable interrupt for this counter
-	 */
 	armv7_pmnc_enable_intens(idx);
-
-	/*
-	 * Enable counter
-	 */
 	armv7_pmnc_enable_counter(idx);
 }
 
@@ -898,18 +883,7 @@ static void armv7pmu_disable_event(struct perf_event *event)
 		return;
 	}
 
-	/*
-	 * Disable counter and interrupt
-	 */
-
-	/*
-	 * Disable counter
-	 */
 	armv7_pmnc_disable_counter(idx);
-
-	/*
-	 * Disable interrupt for this counter
-	 */
 	armv7_pmnc_disable_intens(idx);
 }
 
@@ -1476,12 +1450,6 @@ static void krait_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	/*
-	 * Enable counter and interrupt, and set the counter to count
-	 * the event that we're interested in.
-	 */
-
-	/* Disable counter */
 	armv7_pmnc_disable_counter(idx);
 
 	/*
@@ -1494,10 +1462,7 @@ static void krait_pmu_enable_event(struct perf_event *event)
 	else
 		armv7_pmnc_write_evtsel(idx, hwc->config_base);
 
-	/* Enable interrupt for this counter */
 	armv7_pmnc_enable_intens(idx);
-
-	/* Enable counter */
 	armv7_pmnc_enable_counter(idx);
 }
 
@@ -1797,12 +1762,6 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	/*
-	 * Enable counter and interrupt, and set the counter to count
-	 * the event that we're interested in.
-	 */
-
-	/* Disable counter */
 	armv7_pmnc_disable_counter(idx);
 
 	/*
@@ -1815,10 +1774,7 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
 	else if (idx != ARMV7_IDX_CYCLE_COUNTER)
 		armv7_pmnc_write_evtsel(idx, hwc->config_base);
 
-	/* Enable interrupt for this counter */
 	armv7_pmnc_enable_intens(idx);
-
-	/* Enable counter */
 	armv7_pmnc_enable_counter(idx);
 }
 

-- 
2.47.2

