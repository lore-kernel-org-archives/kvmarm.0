Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D262C187;
	Mon,  3 Feb 2025 00:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738543402; cv=none; b=ZYVL1vz+Qvl5RXwaSNKqGo0LTVBrXbrBC1VOUwzfqtZuqKEaPcZbiRFH3A+au+BpYSClPs4+FfHa7nlbruQ2eJDvUF02GjtAjUBUZEToEqXOy9XYFF8bnymL578nLdBcWMc0AxT5FanhThsjp5UTCmCMZ9BTgFaInY7VpKNV9wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738543402; c=relaxed/simple;
	bh=hL4f+39bFU/TAP2cUriOWdCrZC1hK76nhw254DfXqIc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=DQKQsys8LlL4a/Ei8rbvq2TPt9waZXlJHK0SdqPRqNJj18Hlg+proV42eaniXUAtIKu5hvhvCTjLgWuCNrw17nQIMuTmCf6m42uahKcpWqicW9+qFm4CUp6wTvokhdNBOlEcNlqE4TJm8kDU3Ey1aF6f20BCY3eqs/4inJVqE7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F01lE8v4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F01lE8v4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927BBC4CEE4;
	Mon,  3 Feb 2025 00:43:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738543401;
	bh=hL4f+39bFU/TAP2cUriOWdCrZC1hK76nhw254DfXqIc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=F01lE8v49YhXEBYpLYUpEr2BoB2gLc1++0P10dPiCFD7g9dDpq9gHtI0gGxmq1igE
	 mMik0x7uqdc8VWRE+ECksRqEkGk/mH1XlcKY3pYeyD9Y0gYC0YPLXDtoEfi8vuWFgK
	 j8UUUrCkjuEEbiruLsq3ALFPIN9daTdiv+n7n1QefvaL5Y2KuUDNsdDEFtSSdUKnxJ
	 WcKrZ5MpRmIt8yYYx+8IciFVbZbpolLQOblj5U2eg177dboUPbO066fPfXqN9DwAx7
	 ZFVIy6chz16ML/+i8RF+Pwq+xJM52Uicl6YE3YqaUFeqTlhhNA3zaIC0t/h3+brq2+
	 57cGYVwRyK5+A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Sun, 02 Feb 2025 18:42:57 -0600
Subject: [PATCH v19 03/11] perf: arm_pmuv3: Don't disable counter in
 armv8pmu_enable_event()
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250202-arm-brbe-v19-v19-3-1c1300802385@kernel.org>
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

Currently armv8pmu_enable_event() starts by disabling the event counter
it has been asked to enable. This should not be necessary as the counter
(and the PMU as a whole) should not be active when
armv8pmu_enable_event() is called.

Remove the redundant call to armv8pmu_disable_event_counter(). At the
same time, remove the comment immeditately above as everything it says
is obvious from the function names below.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
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

