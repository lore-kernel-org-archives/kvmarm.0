Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A343E27726
	for <kvmarm@lists.linux.dev>; Mon, 16 Jun 2025 23:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750115005; cv=none; b=PcVNL0kpakoQg2ZZfPFgBmQOHaddcVkn9gK/uUNHhivc26hJ87Wrn12kv7e321DURmwbJCX86EysbwgBArjzdwQf0VrzH4HZv02A0YbFB5HVgW5iVaMtsq/CeXteR2qpbN0f5lHsPZEgnmmCaMGWU0e/r2M4NJtl8Tc7rXjTTYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750115005; c=relaxed/simple;
	bh=yeRmRQ524T2O4H+GtzSE0kEKp7t41lSk0cu4LKgxbr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=a/mS5MFkElHDd4FvPBhalmJjW4w2ZEju2Nwu2lv1TLMlzeVakYyOkVxYWgyqaOR/eDLgnCRB0k0QIs1BEY/8wnPQ30/Rd+F9N+ap353IddFZm+MbtJ3KKu7/nF/D+dlVnpCfhqJ6BAKa8VDOazIUtiYyuAM6E/mvr1g0ieg3/U0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WTXfTFh2; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WTXfTFh2"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750115001;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=D1OrMKy0UcRpphEW1pahh3YmObz3kjMYvRDtP9NbOEI=;
	b=WTXfTFh2HDXE5SSGXjiRJfq9UH0m8WA6GjMQrFR4oIH0p+B1AG0U1pti3I71gyKfk06g8b
	rSTeB4txbu4tbINMl3bBWggwcoo2n87xUV5wZglnfyBFFBfyfpmRhZ1sR2l98hjpIfEK1L
	0w0q3zcnNsFf/iM87YwTGPOnaTGAM2k=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 01/27] arm64: Detect FEAT_SCTLR2
Date: Mon, 16 Jun 2025 16:02:42 -0700
Message-Id: <20250616230308.1192565-2-oliver.upton@linux.dev>
In-Reply-To: <20250616230308.1192565-1-oliver.upton@linux.dev>
References: <20250616230308.1192565-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

KVM is about to pick up support for SCTLR2. Add cpucap for later use in
the guest/host context switch hot path.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b34044e20128..b85be598cb17 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -500,6 +500,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_POE),
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_TCRX_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
@@ -3061,6 +3062,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_pmuv3,
 	},
 #endif
+	{
+		.desc = "SCTLR2",
+		.capability = ARM64_HAS_SCTLR2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, SCTLRX, IMP)
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10effd4cff6b..24d57e309f27 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -49,6 +49,7 @@ HAS_PAN
 HAS_PMUV3
 HAS_S1PIE
 HAS_S1POE
+HAS_SCTLR2
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
-- 
2.39.5

