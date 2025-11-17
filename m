Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E39E28504F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 22:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763419408; cv=none; b=qX0LJTKSsJPIWMOZDUR23AOztcE8rO3ZIhnsiBGgnkgTkWjQHPawr15M+H/PATW/xkIrB34Q64LW09LnaH1VORw62dTUNHNbeKHH1Sd4sfnItsx/EEi87sgBbGV7fDsmu4ecx0kGewN4X4ANME9jGeLqFI5+1XrKd1ExjGXFjaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763419408; c=relaxed/simple;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNcGa9TokH4uDWJl1QeYaRM0u1mJriAyu+Qc+PFVN1P3iUfTs8JR9susd2UyGSGZJnq4I4IbQTo/xAy7WDCPuQPI2AK2VQdHg4TFV5H2NtRXZZIw9pooyPF4YWkLSptI9Gh3HmND+l6pKGG8nI1BTvEqHxifTo8C+8bD3t3PemU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwJvExBF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwJvExBF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4D1C2BCAF;
	Mon, 17 Nov 2025 22:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763419407;
	bh=pDFAQEgrrb6MNUq0QHvvefg81WhPMe2QqlhgC9ChIHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwJvExBFILgsmV25rPcrL+HTdIuq3bTy/BZb2hgxr3ValEkzLiFSLtxkrBlWR9JVV
	 HmtDd+48cmhkp02tQM6iCtYlbuqxISJ3ZmYcPc1LZ4mTVoPKw5Ar1oSCEDN2ISYTIX
	 U+3yFCWHWzgzWZp6E7kTluFPO9fQbwX2aWEJmZtr0bJ/FnP8bcB2greLeYKawP9Yfc
	 7QPSgcdHsWOQpiasyr8QU4s2VqQv6yJEOs9zAlkWUoZTcWOr2hZyE39duplmQWfg1+
	 uapwKmzu6tXv19ldW+niRfqleEifMVGDYeyrbCAf/R+tw+aKYTjSiFCm8I26NEKwMx
	 VDwzX6TuoLgfw==
From: Oliver Upton <oupton@kernel.org>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oupton@kernel.org>
Subject: [PATCH v2 01/14] arm64: Detect FEAT_XNX
Date: Mon, 17 Nov 2025 14:43:12 -0800
Message-ID: <20251117224325.2431848-2-oupton@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117224325.2431848-1-oupton@kernel.org>
References: <20251117224325.2431848-1-oupton@kernel.org>
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

