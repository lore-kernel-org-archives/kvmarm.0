Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB871E5714;
	Tue, 18 Feb 2025 20:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911245; cv=none; b=SBVulI0uvX3W6egVU5yk3QIhAB8XBIvrcf6jBqGcdPRnZOW9W6OYTJcD3SyrFqZpPtWrosZm33V1G4aAhVmwwQ5KbkbwgLq0ZXVi2Ugw46F1m2sOyCmeqXpO1nhgLcoIQRCxt2ysn5u7nvVSpsE5vvsmxv6By88jCOLdAjQSbVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911245; c=relaxed/simple;
	bh=0HI/XixRZkGw+9m3cuDiZCs1Y4vkExGOb34klMI4Tis=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=vGS9yGmQn5PmGxAWQ0QaiPsBUZY9Vdtdlu1xEbB6jAOS3oE6VHmnX9xDOw0G4z6zIOWPsOt5itnuJMxZLcC4WPyYRoPyqPR69LTrp+lmNa4U7tMq2DVAD3698N/OggirWRKy2CWDqvDf9eXtrQyi2c+g9/GeIL/tb6S3hUp6SEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uFFCuShQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uFFCuShQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DAAC4CEEB;
	Tue, 18 Feb 2025 20:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911243;
	bh=0HI/XixRZkGw+9m3cuDiZCs1Y4vkExGOb34klMI4Tis=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=uFFCuShQItWJZZbs/xnVI9pRAzaR+yWjzDpJLv/CP2mXqqPMmlbBIUttagyXoWTLA
	 0TVVP+vrcC1/vLJTdwXZo0RpQIOIEDzBklDDO8xkbN7/uwH5nnJRLOromFbNgsl/RR
	 zG6rDp8QIk3oCynaOjYLWNsSV0MLvk29683wfrT2WXT3ZPqDo9eaVF+f5XZIFE2qbF
	 myQgLBDaYcHgLGCt5XmiXePDmkWErABfbHdpI401Fv0CbGh6FQSSsdHT8MsgHQTy2G
	 HN8LUVqBoeXziArDVjkyfmxbmv5aPUO15kvp0k2wyKjM/HMBEk8Z+LH10Jw6OzEn7A
	 rle5XFY9+ukJg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:40:01 -0600
Subject: [PATCH v20 06/11] perf: apple_m1: Don't disable counter in
 m1_pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-6-4e9922fc2e8e@kernel.org>
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

Currently m1_pmu_enable_event() starts by disabling the event counter
it has been asked to enable. This should not be necessary as the
counter (and the PMU as a whole) should not be active when
m1_pmu_enable_event() is called.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 drivers/perf/apple_m1_cpu_pmu.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/perf/apple_m1_cpu_pmu.c b/drivers/perf/apple_m1_cpu_pmu.c
index 06fd317529fc..39349ecec3c1 100644
--- a/drivers/perf/apple_m1_cpu_pmu.c
+++ b/drivers/perf/apple_m1_cpu_pmu.c
@@ -396,10 +396,6 @@ static void m1_pmu_enable_event(struct perf_event *event)
 	user = event->hw.config_base & M1_PMU_CFG_COUNT_USER;
 	kernel = event->hw.config_base & M1_PMU_CFG_COUNT_KERNEL;
 
-	m1_pmu_disable_counter_interrupt(event->hw.idx);
-	m1_pmu_disable_counter(event->hw.idx);
-	isb();
-
 	m1_pmu_configure_counter(event->hw.idx, evt, user, kernel);
 	m1_pmu_enable_counter(event->hw.idx);
 	m1_pmu_enable_counter_interrupt(event->hw.idx);

-- 
2.47.2

