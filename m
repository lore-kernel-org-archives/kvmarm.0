Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A9B725A32C
	for <kvmarm@lists.linux.dev>; Mon,  4 Aug 2025 12:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754309867; cv=none; b=nSFyby+El/a7EGdU/221QdoAxL48JzkKVA4GrUBIS7R03YnNL4PTwzmClEhRMp5j4sNQu5a03T5WimF9SnBAixni5f+HptEoCyox3xi1xWFha7aKCpgSXWLNmogLVTMaZXNXiP/PKLYyeCjNGSRIaJvBY8eVzaJ3ULqRjfa1F1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754309867; c=relaxed/simple;
	bh=Ju7yahbdDwfnsy1wf38WfilZ/oDBCruVYIHwba/TtPs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XLpD8gyFppk8iChajA29oUZFqIBDiltvrEFkB2Tr4ByXtrBNXgP5OyFz8ev1tCQDqS56zIZMsx0ucMedPjJcsF3VXW0LXz57U1sFXwTW7PgiOcFKFCtCGbif6N+tvmD2NFz7GK8uxvSAAHEBYOI2+GGksXzUmAb1xoo06emLpmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C0AFC150C;
	Mon,  4 Aug 2025 05:17:37 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2E63A3F738;
	Mon,  4 Aug 2025 05:17:42 -0700 (PDT)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	broonie@kernel.org,
	oliver.upton@linux.dev,
	anshuman.khandual@arm.com,
	robh@kernel.org,
	james.morse@arm.com,
	mark.rutland@arm.com,
	joey.gouly@arm.com,
	ry111@xry111.site,
	Dave.Martin@arm.com,
	ahmed.genidi@arm.com,
	kevin.brodsky@arm.com,
	scott@os.amperecomputing.com,
	mbenes@suse.cz,
	james.clark@linaro.org,
	frederic@kernel.org,
	rafael@kernel.org,
	pavel@kernel.org,
	ryan.roberts@arm.com,
	suzuki.poulose@arm.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [PATCH 04/11] arm64: cpufeature: add FEAT_SCTLR2 feature
Date: Mon,  4 Aug 2025 13:17:17 +0100
Message-Id: <20250804121724.3681531-5-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250804121724.3681531-1-yeoreum.yun@arm.com>
References: <20250804121724.3681531-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since Armv8.8 architecture FEAT_SCTLR2 is supported to provide
extensions of top-level control system
(i.e) FEAT_PAuth_LR, FEAT_CPA/CPA2, FEAT_MEC and etc.

To use related system extensions in the future, add SCTLR2 feature.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 8 ++++++++
 arch/arm64/tools/cpucaps       | 1 +
 2 files changed, 9 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index e151585c6cca..4aa83221a4a6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -500,6 +500,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE_IF_IS_ENABLED(CONFIG_ARM64_POE),
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_TCRX_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
@@ -3061,6 +3062,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_pmuv3,
 	},
 #endif
+	{
+		.desc = "Secondary System Control Register (SCTLR2)",
+		.capability = ARM64_HAS_SCTLR2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR3_EL1, SCTLRX, IMP)
+	},
 	{},
 };

diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10effd4cff6b..a0184295c5d9 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -52,6 +52,7 @@ HAS_S1POE
 HAS_RAS_EXTN
 HAS_RNG
 HAS_SB
+HAS_SCTLR2
 HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
--
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

