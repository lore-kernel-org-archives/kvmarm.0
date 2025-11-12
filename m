Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D99E35388A
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 18:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762972451; cv=none; b=o8Doqu2iy0aVBNxLHRC/H6jB9gIiEJfH4N9mAo+3Kl0EEgG7rdnBUdnQ9AShveqV9MsW9xXLPn3sud+uuT98XBObGwbyI+r7SJhFU4D+ZqKceCThwE5+qIu3yrSLL2vOzNscHtjE5HJuXLR8dRq3q+bAch28jSpCurNG6KPcb5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762972451; c=relaxed/simple;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvB+oE9c2boyCvl/uJwXJ/yPl6OA/cBnVRzCwk2U5UQdkkqIl9nJ7y3T70yUCLtEaqll49Lo0biZDF67zlTUFCE9p0YunCQjzJzdVFoDf9hgMTQlesKniLWlV6N4Z1BYluPLYhazAMql2V6vlHfZrmvndQuzhPxhEHYHNKlhEWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rXpE3dij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rXpE3dij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90045C19425;
	Wed, 12 Nov 2025 18:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762972450;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXpE3dij9G7G2iGKC3sGhIXbm6SMuxXPDn5N+nSu9a+ZmA5K0fjQu20w2xiLR7zOH
	 ASzf138mH32PIfhwaOxH1x0BY6XfegpQaJl5XPENTYr0yXTn2wbVLZfNZAA/csbvyL
	 gmDdM12OCMvKJrDC6E+T0xYLczteOIXhNeIkA0yCuj9yIIUtIH8vhq/+Y/pgwqqhft
	 IxUlHISz242rA7ShIT9MOwxx0E4Q9TTYb7XuXpUmat5Xre61knO//1XUS4p5WT+YGu
	 AmezzNgGkbV7f0UXK9/9K062T3DksMIc/Wi3tjHoW+xm8v71vvre4tQ3WFXtV/q7vO
	 8+p4ijjZDA/Lw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH 01/12] arm64: Detect FEAT_XNX
Date: Wed, 12 Nov 2025 10:33:55 -0800
Message-ID: <20251112183406.2118981-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112183406.2118981-1-oupton@kernel.org>
References: <20251112183406.2118981-1-oupton@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect the feature in anticipation of using it in KVM.

Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 7 +++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 8 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 5ed401ff79e3..aa3ecae252d3 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -3088,6 +3088,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.capability = ARM64_HAS_GICV5_LEGACY,
 		.matches = test_has_gicv5_legacy,
 	},
+	{
+		.desc = "XNX",
+		.capability = ARM64_HAS_XNX,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, XNX, IMP)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 1b32c1232d28..ee74199107d3 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -64,6 +64,7 @@ HAS_TLB_RANGE
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
+HAS_XNX
 HAFT
 HW_DBM
 KVM_HVHE
-- 
2.47.3

