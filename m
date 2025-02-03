Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA0013C81B;
	Mon,  3 Feb 2025 00:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543407; cv=none; b=MC+ht5ZWVHHRjgXKEcCJuu57Nph0zSUvXvxuyhTE3z6jsyjhW/Y/j80wSaA2I+JmQLE/JF0a2sZhrpj3iaZNqCfhnbryIxJbcywogrjB+hBwANtBi5RB7m20W6AorvkWO2vxG52nUwyccYQ3daUzJDPnBK+ZZwUzyqrwd0ezR4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543407; c=relaxed/simple;
	bh=za8iN40FQDk2pmfaRnhlPlw8DceIe2LhWYenqsGL+wo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OvoNdl4ef4u6Cu6gU93Sxagc2/VUqomWH0RQufVEj7wRSDco1UZCZtk1o4bh8K0d1NYh6rQYm3Tk3V7j6x2FdmTiT9nGpVdwWXKaUkmYKk2+Ybkzoc7Q2GJFkClBhcVjyddFrlOMwzcVZ+Bh/lTErJ3d41ACKl54dD/QUh2lpPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H3hGoIBB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H3hGoIBB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A7EC4CED2;
	Mon,  3 Feb 2025 00:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543406;
	bh=za8iN40FQDk2pmfaRnhlPlw8DceIe2LhWYenqsGL+wo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=H3hGoIBBMzDCLW7E18zVmykhF6bZl5dP7Lo1l11EQM6X8XzW3d+RGXBgvEM0X++OE
	 NRG4/9SWnLw9YTfC0lUdqxFuB+6RycR9I6dH0XKkf05YlIESfquaW0CnkEjF5HVLXm
	 BSMilz5mRmrzr8JSPmulK868+aysAY2jx6V/r7kTE9zzrlOBKMe0UNfDfnRDfBLzWY
	 xRMLj7fM2o/CNrDIvzUDoldks3Oo1GD0tX+qAd5z+G4acvN1FrXrhLL8+8j1Hj0kj2
	 fc/AS886T7T8luDUYmI3AlaJbTVm5tYS7CfKXPRhFDy54B2pwcIyyY8F0mCUkUGQje
	 fb+r3+uE9CKtg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:43:00 -0600
Subject: [PATCH v19 06/11] perf: apple_m1: Don't disable counter in
 m1_pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-6-1c1300802385@kernel.org>
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

Currently m1_pmu_enable_event() starts by disabling the event counter
it has been asked to enable. This should not be necessary as the
counter (and the PMU as a whole) should not be active when
m1_pmu_enable_event() is called.

Cc: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

