Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F52833EA;
	Mon,  3 Feb 2025 00:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543404; cv=none; b=iXOS37he2ah8YtNC9V0SOhfBhLn26l8ufTj1hcfmLMBopNxESn4tcKu2ZdT1OOj3OgpaLp1n8QGNpFsvv9wRITj6/Sqqz4PjfRGUu8vCvXjtoxdDrYFJ+LI9SIB7nYS1/kgXuT+TMA9tR2HwnU+avmuR0wgJvljOymHOxwKZnr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543404; c=relaxed/simple;
	bh=AQfzCdl+Y2ebwtEy1FgqsCEm4CfIqqfCEkVfzalKseU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=PnqjIq7RV6FAJeOqnUJDp43eDONYDitXozVjBGxWH9SrIHWATrhwCVaPTBcPlCyfJmoO64tOOWlSSmPTYEQ2gyx868/xDAZo/lxCjmjpKqVTGfSZzqykIfv+z26upwJpTxrHCDhsp2XM3+GS/kUNiqPjJbMr9D9C3yuVXMxLzIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TiAJDCaG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TiAJDCaG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492B8C4CED1;
	Mon,  3 Feb 2025 00:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543403;
	bh=AQfzCdl+Y2ebwtEy1FgqsCEm4CfIqqfCEkVfzalKseU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=TiAJDCaGoVTJdlcRlCTS2l6+fxg1tdIez8UfzZTXeZ+aBKb7IbD6gpJgnSUpWX7Wv
	 eIvOVTiwJ/CxxXTjcR+BZZohbMhbiWzwFqLt0FnCWbTHVP+j3b1Xz3m2urdH7Ak0NC
	 IhBEv7DTJlWIXNql43ujxD5hgvkhNEcKMmofLvvb1Thfy1+8SG0LkSyVNTATx0lEoS
	 i/l4WkDE9Xfy9lCDFMaZ5EvJKpsF93PE+R38PBdOtE7xEywfzq4xX+/alZZSupuoJx
	 gDOdifFIxFtjeidWqTuRDIOS2w+TtQQtUxLvdD7YQrIy01MBJdEiH8J4Ti6M8zVOk+
	 L+1lyNQPNK5VA==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:42:58 -0600
Subject: [PATCH v19 04/11] perf: arm_v7_pmu: Drop obvious comments for
 enabling/disabling counters and interrupts
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-4-1c1300802385@kernel.org>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
In-Reply-To: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

The function calls for enabling/disabling counters and interrupts are
pretty obvious as to what they are doing, and the comments don't add
any additional value.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

