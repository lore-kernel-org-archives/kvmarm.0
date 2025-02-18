Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E94701DF75B;
	Tue, 18 Feb 2025 20:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911240; cv=none; b=qq3xTG0RX3sV2JAv/Oz447eg0Hjxba2xgh1Grpf/xALM8uJIXvWCp6rU3+L8pfthihDvWKmY9QppyK/q24ENLDq+C6QoXXAwnc7HMrLpJNZWSLIBlSwz7JoQPnm1JUSXCrk1lqJbIxwM0JERF+iLHVG/znSXng9ynceTOziB0R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911240; c=relaxed/simple;
	bh=DFruu6M6LuyMFhOcYMVY3k7q3IHlAshlqt8WjYP/+dM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rB0HQZ1+ryk1eAdTuZFNijpBoFzRXvRMUVr2dPYqJcIrdUch0Y9+2k8yRfKFOW8/9sOWE2PWIU5Z5kBVzjQ4w6EbgmRhOw6vJtLtk3I6HOkaT6NbcjAkN4zzkBjEqu8PqbS2/H9Hy1OJMjcf4fJkJtGbI5yqciy79DVHd+pXeiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s/GRhmpb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s/GRhmpb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20BABC4CEE2;
	Tue, 18 Feb 2025 20:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911239;
	bh=DFruu6M6LuyMFhOcYMVY3k7q3IHlAshlqt8WjYP/+dM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=s/GRhmpbbtmzWA6zPT8aWKbbG3tGtdsk00aNPFP6V/Tw33q3a9zCAz49rMyqX3Ey4
	 oL3xsUlQfRy08APXbG6t0C2tm6zP1AqzlbrIgwuAssg83ZzTqGduEb83+lzO1M1JX5
	 MLu3wztsI3u9UQr4IPc67SPbXvi4eF9haJWJNOMgjnEoneW8Ju6tnQA8VkXyMpxOA5
	 2fcoBrsYbSOj3KOu6vU+m0pOK+eTBXnlaHNgcwWRE3Zx66EhgPPwzrMutsNy+HS2bp
	 FOP+rH3BeLoFS+GQVH1d8jds4bWv7p4CUNKDoyyHhnYo59F+52YfhX8tpC6jZ8DXyE
	 YJ6M9AeOguHsQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:39:58 -0600
Subject: [PATCH v20 03/11] perf: arm_pmuv3: Don't disable counter in
 armv8pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-3-4e9922fc2e8e@kernel.org>
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

Currently armv8pmu_enable_event() starts by disabling the event counter
it has been asked to enable. This should not be necessary as the counter
(and the PMU as a whole) should not be active when
armv8pmu_enable_event() is called.

Remove the redundant call to armv8pmu_disable_event_counter(). At the
same time, remove the comment immeditately above as everything it says
is obvious from the function names below.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 drivers/perf/arm_pmuv3.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 9ebc950559c0..5406b9ca591a 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -795,11 +795,6 @@ static void armv8pmu_enable_user_access(struct arm_pmu *cpu_pmu)
 
 static void armv8pmu_enable_event(struct perf_event *event)
 {
-	/*
-	 * Enable counter and interrupt, and set the counter to count
-	 * the event that we're interested in.
-	 */
-	armv8pmu_disable_event_counter(event);
 	armv8pmu_write_event_type(event);
 	armv8pmu_enable_event_irq(event);
 	armv8pmu_enable_event_counter(event);

-- 
2.47.2

