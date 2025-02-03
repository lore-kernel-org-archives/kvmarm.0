Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C903918641;
	Mon,  3 Feb 2025 00:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543400; cv=none; b=awL3NTQD/b0g/P5ch1YGUcLSpA23Z61L18es65wovNWJza38WH1D5tQ6deCZtHfrNz//8I1OLqwFBywPVYD7tkYF0NunnTNIYlD486P9ba1OWfoRtYKtL0G7mG+CWUVa8AdiVDzMCiRC2+Zn7OG+vckSYp2AjeVu/5Y4jGEBIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543400; c=relaxed/simple;
	bh=jvbfAk+0Ldh4PLsv8Iq6CECrB3n0Uk9q6M/nTuRd/kM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=aocXiZtYcpnTBNRbtGIkQlVc0vLVe6aNCmf/wmbqHXMuLeq64zc3kLWs1aOPXp2kOl0ufm9nm8Qe5eHlatJzbwFvA8PUgz45mJwkzPgqZL1p1cM5bOd4oEXYJZnNOkQr6PwVoMW2/dnv9FCNCGRjlytaob8Y8CR6FzdbombxRtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ajlOswMX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ajlOswMX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6B9C4CED1;
	Mon,  3 Feb 2025 00:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543400;
	bh=jvbfAk+0Ldh4PLsv8Iq6CECrB3n0Uk9q6M/nTuRd/kM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ajlOswMXmnYE9z7rDc+ppz8gD0EiXYJi+ikMR+9Wi+XGSfoUXhYsCXDkwJSkv95KO
	 FABzbHHYk9QagiafbYfh8V+7lQaUBps3mJBUfggsayMFE4grlodzfx5Sx0EyLGyzzE
	 B+3MCZO9ZqKwh+qLUjvTExSliqHFAhimUiZIL8p/7lvpTrDZ1tXKBosNHX6bgUFl9/
	 pwuRRYxHyXGEl72bGXcZwtnlJ9w671AFkFil9l3dJ9bYjGtc0XG65imZTyvoBgyDFT
	 ou4DJG00WhY5cg63mJu0LfObqUSmhk+HDjLx90U/xlH16pGujfPW+8QqV7dc29AUpR
	 LZ/zJ3I49mTfQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:42:56 -0600
Subject: [PATCH v19 02/11] perf: arm_pmu: Don't disable counter in
 armpmu_add()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-2-1c1300802385@kernel.org>
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
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

