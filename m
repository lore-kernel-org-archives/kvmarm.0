Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187631FA140
	for <kvmarm@lists.linux.dev>; Tue, 17 Dec 2024 21:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734470590; cv=none; b=SgoA7GtnZBSDaZV49e/s0MFjExPZwjW9ovEQ9zFhihkQo64Q36p3Rnz3dfSvPc+icmKyKnuBWdruUIQyngj27S1LYqm89xkD0ABZhyY8FYryOhBCnCckPq2l8jthBF0GtnI+Drpzh6X47nNg91KD95Yazr9yGKaqLWPLWRIZx2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734470590; c=relaxed/simple;
	bh=nVyu0O7jaOnlHWvZDvzJtM3dvCxDwoBhKEOqCa6puTs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e0Z2uuXcH79cF9SpJNMX6h+Z6Yq0Hi/P2S5oEUTRsDjSF/EAjdPtsc0oAvSlyZgDne7NLDjICPs+QMg3gDkJXf/cP4zK8v7LDTOKKSHw/b+DnRR8cyDaGiwF+XDZviLt/HnUEYN/Uo3PO1E42G1SbxvdcHrYm0sPrYbL5qmx2oM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YVLjQJ/R; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YVLjQJ/R"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734470587;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6d9dUcTSe5Y6WYDonPie5MfCzdgvBZJtuRSWHader5s=;
	b=YVLjQJ/RQf4Iu/Lwu0uHZzu1gNLndqestRfF2O3jNtWCqsbHYL7t/WUVjyZqFDNmSDuIBL
	z7JBGneKH0n0Vb3o21JhUsd7ZB0BSMf+42s3PTetIpVxe50vSLPbPH8FEU12muUt4XX6TG
	QYUySjfTHsaJe8YEO/Jau24gnc19kfE=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 15/18] arm64: Enable IMP DEF PMUv3 traps on Apple M2
Date: Tue, 17 Dec 2024 13:22:55 -0800
Message-Id: <20241217212255.3709400-1-oliver.upton@linux.dev>
In-Reply-To: <20241217212048.3709204-1-oliver.upton@linux.dev>
References: <20241217212048.3709204-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Apple M2 CPUs support IMPDEF traps of the PMUv3 sysregs, allowing a
hypervisor to virtualize an architectural PMU for a VM. Flip the
appropriate bit in HACR_EL2 on supporting hardware.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/cpu_errata.c | 38 ++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index a78f247029ae..441ee4ffc770 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -194,6 +194,37 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
+static const struct midr_range impdef_pmuv3_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_BLIZZARD_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M2_AVALANCHE_MAX),
+	{},
+};
+
+static bool has_impdef_pmuv3(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
+	unsigned int pmuver;
+
+	if (!is_kernel_in_hyp_mode())
+		return false;
+
+	pmuver = cpuid_feature_extract_unsigned_field(dfr0,
+						      ID_AA64DFR0_EL1_PMUVer_SHIFT);
+	if (pmuver != ID_AA64DFR0_EL1_PMUVer_IMP_DEF)
+		return false;
+
+	return is_midr_in_range_list(read_cpuid_id(), impdef_pmuv3_cpus);
+}
+
+static void cpu_enable_impdef_pmuv3_traps(const struct arm64_cpu_capabilities *__unused)
+{
+	sysreg_clear_set_s(SYS_HACR_EL2, 0, BIT(56));
+}
+
 #ifdef CONFIG_ARM64_WORKAROUND_REPEAT_TLBI
 static const struct arm64_cpu_capabilities arm64_repeat_tlbi_list[] = {
 #ifdef CONFIG_QCOM_FALKOR_ERRATUM_1009
@@ -786,6 +817,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 		ERRATA_MIDR_RANGE_LIST(erratum_ac03_cpu_38_list),
 	},
 #endif
+	{
+		.desc = "Apple IMPDEF PMUv3 Traps",
+		.capability = ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS,
+		.type = ARM64_CPUCAP_LOCAL_CPU_ERRATUM,
+		.matches = has_impdef_pmuv3,
+		.cpu_enable = cpu_enable_impdef_pmuv3_traps,
+	},
 	{
 	}
 };
-- 
2.39.5

