Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29DE1770E2;
	Mon,  3 Feb 2025 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543405; cv=none; b=YbqpyCE5AhKYBOkwN68aWSbdlSmrP/VggMfQPzXzOQiKQXKREqdzqViuUDprs3r/e8aTf4j8z6X3V//UD8mPhPyApYVBbxaRNgq4cG+g7LMMxBwh6IfUdWjYmMlPlr+hKwEKLz+TnjoTSeYjIuyLgQ0SH6wTcs7iTIUp/sq0fcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543405; c=relaxed/simple;
	bh=HlJZ4X1QMrX/xJ0XjPX1zV2wX+vGp3xXOqm0TGuJopU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=svTk2mwB7OHAQQH7qj4wcVruw5MIqQ8XRKDpHhnjzWTUQaPd5Ed45OLyseHbXhD6QNEyEkmQV2Uc/sXlgwbcU7op1bqqjIuVbqzv/uwGUirAO0jGxSIIPeNigffbC+sqCGjuFxVVqBe/ffdiw6oydE5ZmOr9JISh51F6F3Lohno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cPwVx/x7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cPwVx/x7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE324C4CEE3;
	Mon,  3 Feb 2025 00:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543405;
	bh=HlJZ4X1QMrX/xJ0XjPX1zV2wX+vGp3xXOqm0TGuJopU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cPwVx/x7GuYkzvdEuyjaydOXSjWrwbwhgrGixTeEjUTqXZJb+otZxbgyud3yioHjc
	 2kwkTabYNQPy2afhrFVDaklbdRx8lkMTvQN3Q1xKZCqiB31O3PBGM+Y7uDcR69eK21
	 ELboOt8FXLdEDPHSAkf79OV63k+s/8cuTm2jueMRevdABKbO32M/S593yXIeXTJ+eb
	 rLDbD/Aug0boQA4+LuWMfk79IGZ4+1v1HGYqgMmjOx86cc5Ex3Av8MrvP2wpqhurGj
	 7H2TMOYkjacLRyAogUdGB2CA4WhjQOGDelUGj/O8a4wMA1nhV13vY9bHAje3LwgRHZ
	 eM+bdJHxSN/Bg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:42:59 -0600
Subject: [PATCH v19 05/11] perf: arm_v7_pmu: Don't disable counter in
 (armv7|krait_|scorpion_)pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-5-1c1300802385@kernel.org>
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

Currently (armv7|krait_|scorpion_)pmu_enable_event() start by disabling
the event counter it has been asked to enable. This should not be
necessary as the counter (and the PMU as a whole) should not be active
when *_enable_event() is called.

Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 drivers/perf/arm_v7_pmu.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/perf/arm_v7_pmu.c b/drivers/perf/arm_v7_pmu.c
index 7fa88e3b64e0..17831e1920bd 100644
--- a/drivers/perf/arm_v7_pmu.c
+++ b/drivers/perf/arm_v7_pmu.c
@@ -857,8 +857,6 @@ static void armv7pmu_enable_event(struct perf_event *event)
 		return;
 	}
 
-	armv7_pmnc_disable_counter(idx);
-
 	/*
 	 * Set event (if destined for PMNx counters)
 	 * We only need to set the event for the cycle counter if we
@@ -1450,8 +1448,6 @@ static void krait_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	armv7_pmnc_disable_counter(idx);
-
 	/*
 	 * Set event (if destined for PMNx counters)
 	 * We set the event for the cycle counter because we
@@ -1762,8 +1758,6 @@ static void scorpion_pmu_enable_event(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	armv7_pmnc_disable_counter(idx);
-
 	/*
 	 * Set event (if destined for PMNx counters)
 	 * We don't set the event for the cycle counter because we

-- 
2.47.2

