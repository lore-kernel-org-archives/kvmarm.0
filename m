Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1C11E1A3D;
	Tue, 18 Feb 2025 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911242; cv=none; b=r9hJrUkt99zge1fREuKyonBSharxQ+h6OOh+5P7NxZYu/tzYIjvxtwy1VmFyLm3oEx+Zm/UTgTwqLQlJoQ26SyQENIASZRO4Axa9KItXcOOeOvtZurtLukr5y72qj6YCbgkJqZOoqEvyhs8I70GAgLOwdPT2O3my2V9AsXTslQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911242; c=relaxed/simple;
	bh=fpChsUtgUFClO1jwmD1KdQQIXH18jEDefaEwkn8anB4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DF1pHEhVeo9IKRPL4MYF509FYH8TPdJAVVowd2D2HjqCdWjkgib/nusEkTZcwPqynxzzDjA0y+Bc8tyndCcgs4baEXmMypg0pihDULJ4XQq3b5zb/AAtgRBA1x5HuYdGJcgSPIZ7qyHB9BBjeohihmdgGb4TFVD4obNgiVycDfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miI8w+LT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miI8w+LT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C89F9C4CEE2;
	Tue, 18 Feb 2025 20:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911242;
	bh=fpChsUtgUFClO1jwmD1KdQQIXH18jEDefaEwkn8anB4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=miI8w+LTAJVgF0A3ILJStDlifRnPr8aBRiSP1mWCoe8sl1zyfap/SL9nhxWkd7oXW
	 CfEq+g3aANGwyrp2w5SMUw2MRQX4xuRSF50bc+3/Xn4YCgJdtONe0zxQFhRV3PCFM4
	 9QDv+PU8AOhFKYbK7XdfdYN/VRhQw6cMKed3cqJIpW6QurkvbrSCuruCuBt/QeQSzf
	 SNtbPx5+MrSe7J/ghjZeDj9c7qlfnoK8p544W62RfKBfUOMqcqZGiTuFmBQ338r0xJ
	 G6cpBSLEOFsuuOq9C8KoAfwJbMtzm5Rj1yBHk/lsJKBGZ6O6pF17iF/hQ2HoxY3fFM
	 GThKTaQ8ZIEsQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:40:00 -0600
Subject: [PATCH v20 05/11] perf: arm_v7_pmu: Don't disable counter in
 (armv7|krait_|scorpion_)pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-5-4e9922fc2e8e@kernel.org>
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

Currently (armv7|krait_|scorpion_)pmu_enable_event() start by disabling
the event counter it has been asked to enable. This should not be
necessary as the counter (and the PMU as a whole) should not be active
when *_enable_event() is called.

Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
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

