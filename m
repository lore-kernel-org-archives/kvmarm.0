Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D8E1DE2DE;
	Tue, 18 Feb 2025 20:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911237; cv=none; b=ZYZV/5FKJ//WJ1wmXT1PRCcdV9dxJKDOVH37dE5la5noHo0pRgB2N1Zl6JgDE2b+sOgk26cY4uVLK1uKPzfXE+yccJS80UR9NzeVhdj44/c2OkJmbsH6GJM5txGr8JkbmbHrBEkM2siAK15k0gdDmtVDgn77iu1Eqn4mIZ45qus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911237; c=relaxed/simple;
	bh=2Jk2ywPW1km/VJ9+Y88YkoBT2vTs0W+V15cPnxKdj14=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P/BhtBX+PH1PDnE1/8oB1moVnleCh8tEe2eyZW3iFZRhynTcAMZb1rtD7Lz53a5PJflob6Rl4LMWTjmluFt3J81sU/hE/5i9pHxeIFriDlkLFhJxPAsDOxcINgBsk+NJ8nkHOi0qofolka+4+t/cHB6G6O6g7pP1RvA9m17GUoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n3ttOiTg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n3ttOiTg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84015C4CEE2;
	Tue, 18 Feb 2025 20:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739911236;
	bh=2Jk2ywPW1km/VJ9+Y88YkoBT2vTs0W+V15cPnxKdj14=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=n3ttOiTgS8RpPSUIV38aLtqXbVgOCiMU4MWMndweh9S963Fj6ha+k10xyhpo8e5BT
	 U9N6eZesWmmHGB7Yj+shOxo/ZcIN6r/ERxZyDQf5tevL8+r/QIQjbSqYqNi063ANnd
	 eBziIh5/+ZSoAGJm5CxaqPeE7HHA64S1biSgN0Zjw87mLITMNqcgOUQ6sLS2GbB8cY
	 tvXYQedEQuSD07yNo6leHkMSksH6S8Ua9TV28iKHKCV+AXKao+6YIbjs6a0tt79IUc
	 oZtFG3RUjUHh0+7ZLAi+Ol89rxWtJCNfLd/40G6tDkQkn17Www/4Ph8t3luMObJ8GH
	 afdwbizJFV/0A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 18 Feb 2025 14:39:56 -0600
Subject: [PATCH v20 01/11] perf: arm_pmuv3: Call kvm_vcpu_pmu_resync_el0()
 before enabling counters
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250218-arm-brbe-v19-v20-1-4e9922fc2e8e@kernel.org>
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

Counting events related to setup of the PMU is not desired, but
kvm_vcpu_pmu_resync_el0() is called just after the PMU counters have
been enabled. Move the call to before enabling the counters.

Signed-off-by: "Rob Herring (Arm)" <robh@kernel.org>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 drivers/perf/arm_pmuv3.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 0e360feb3432..9ebc950559c0 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -825,10 +825,10 @@ static void armv8pmu_start(struct arm_pmu *cpu_pmu)
 	else
 		armv8pmu_disable_user_access();
 
+	kvm_vcpu_pmu_resync_el0();
+
 	/* Enable all counters */
 	armv8pmu_pmcr_write(armv8pmu_pmcr_read() | ARMV8_PMU_PMCR_E);
-
-	kvm_vcpu_pmu_resync_el0();
 }
 
 static void armv8pmu_stop(struct arm_pmu *cpu_pmu)

-- 
2.47.2

