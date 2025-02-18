Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 705AE1C8624;
	Tue, 18 Feb 2025 20:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911238; cv=none; b=oIi3IFYZS2og9whC3n8Qtj2lUJYMPFkHSvbzK6o7f7T30MfY4+LFabyoApmv+VwfG+rStj6yDp+rH08ll/sIiPYfLzg/AsjtfeFqfX5QQF2dKagujSNGqdCpk+Zbb0k3g+9wEJw8s5emPnj7+j5j9VF8JZ0tk9N0M2OV06ufsVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911238; c=relaxed/simple;
	bh=+a0FkCRCTrAtsp19fWZ4DkttiYkptYjz7H4fWJd1ilY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Odzr/sFf3WFM8n/1WjSORrrK9DhpWkHwPo13G8YKLEKex3/Q1DfTkgu4I4RV4f3Y5GHDPsULMRNtrQ4GJsIJnIHIpHvHy2+YoW4k2J/qcDXrIFnJzA0FVQMzhcUod4OAZj6XXWoWShfeutPRnKL1/Sl2XZjOFq8wsEb8PkpP5d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J7F47NyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J7F47NyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08E1C4CEE2;
	Tue, 18 Feb 2025 20:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911238;
	bh=+a0FkCRCTrAtsp19fWZ4DkttiYkptYjz7H4fWJd1ilY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=J7F47NyVQ1Ny+x2wAP3a80SBDXDEBKp1DoOYgSxWMVEzjAetwvQhjMDnI02t5y9gZ
	 jDpFRCvH/pxop29anUUEuW+VQIWANYPPU7jDnS/pWZkmRiz6v6fDCJQNE5/ICuxebm
	 bFryGQ41YfhjINF396sSNh0yq36boGYHa29TgHVQK+6qktaqrNCm2vSD1ugeGEfaP5
	 bLspV5fIrKWjHPmpIiMAYD7v4utEi3NtPHKSVmwCN5epToCEecqb/qjKqT13Ow0NT9
	 xmf2gCZGArd6Ewt44zn6+ZpP2/mV4HVMNla01U4U57aoej+VkIs1S3FgF7bh38w4lG
	 BrQbBdBDYgQ+Q==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:39:57 -0600
Subject: [PATCH v20 02/11] perf: arm_pmu: Don't disable counter in
 armpmu_add()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-2-4e9922fc2e8e@kernel.org>
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

From: Mark Rutland <mark.rutland@arm.com>

Currently armpmu_add() tries to handle a newly-allocated counter having
a stale associated event, but this should not be possible, and if this
were to happen the current mitigation is insufficient and potentially
expensive. It would be better to warn if we encounter the impossible
case.

Calls to pmu::add() and pmu::del() are serialized by the core perf code,
and armpmu_del() clears the relevant slot in pmu_hw_events::events[]
before clearing the bit in pmu_hw_events::used_mask such that the
counter can be reallocated. Thus when armpmu_add() allocates a counter
index from pmu_hw_events::used_mask, it should not be possible to observe
a stale even in pmu_hw_events::events[] unless either
pmu_hw_events::used_mask or pmu_hw_events::events[] have been corrupted.

If this were to happen, we'd end up with two events with the same
event->hw.idx, which would clash with each other during reprogramming,
deletion, etc, and produce bogus results. Add a WARN_ON_ONCE() for this
case so that we can detect if this ever occurs in practice.

That possiblity aside, there's no need to call arm_pmu::disable(event)
for the new event. The PMU reset code initialises the counter in a
disabled state, and armpmu_del() will disable the counter before it can
be reused. Remove the redundant disable.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 drivers/perf/arm_pmu.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
index 398cce3d76fc..2f33e69a8caf 100644
--- a/drivers/perf/arm_pmu.c
+++ b/drivers/perf/arm_pmu.c
@@ -342,12 +342,10 @@ armpmu_add(struct perf_event *event, int flags)
 	if (idx < 0)
 		return idx;
 
-	/*
-	 * If there is an event in the counter we are going to use then make
-	 * sure it is disabled.
-	 */
+	/* The newly-allocated counter should be empty */
+	WARN_ON_ONCE(hw_events->events[idx]);
+
 	event->hw.idx = idx;
-	armpmu->disable(event);
 	hw_events->events[idx] = event;
 
 	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;

-- 
2.47.2

