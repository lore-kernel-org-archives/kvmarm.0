Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28977256C72
	for <kvmarm@lists.linux.dev>; Wed,  5 Mar 2025 20:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741206656; cv=none; b=YUykFy/IBqD1iYh4azXrBixiuzzsMUgPjWjMJwPiGSv3LWIfztGc7Ycu/nrMhBtcU16eDgpytDTYJJ44ebUJfNmtTH3jCscUPCLsL3R33kvk+cMIQUalHHlyahaUR5q/3YceLFJEPAWKDhpZ8VeU7aPBEa5d6/SIx3eCAPOXye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741206656; c=relaxed/simple;
	bh=CMFyWCDGDbW9/mXeVsTOJ32gxb6vUpEPCaJZb22v4aI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=LS6vz+xsA+1QWTKJVkq6KGTANxE8wZOOFr4PT2+bYzAWd5IjLhGzd9ozWtUOJFQ4+AfImb+ypKg4mdyL8gHk15RUpNPLaHzeTk3mYNdsLwL/u6w7p1+f9pENGt2mFqy9Hvq+BGQrhzYEDRfUEwAkQdBZAZ/x+LSGjemifCKU9EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IuJxw1qX; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IuJxw1qX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1741206651;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p04z4NA8ANBpeee2BaIv4nfZi9bpNGy7L59DW/TFIH4=;
	b=IuJxw1qXki9Y8j6dAGW4w8UfiE4wUBjjfAqsCFQf/1aWS+lsfyXXKZs3LbiqaPf0pMhvs2
	e6fYrAw4qSrrmby5rDLBWZ9ir2r1yxe9Cqz4rbgmYmF9nVkLBDAJUdffUZ0ik7ShGHm53S
	k/jBXxB9RFopkMaX/CCmssHzh4Pkqg0=
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
	Janne Grunau <j@jannau.net>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 14/14] arm64: Enable IMP DEF PMUv3 traps on Apple M*
Date: Wed,  5 Mar 2025 12:30:40 -0800
Message-Id: <20250305203040.428448-1-oliver.upton@linux.dev>
In-Reply-To: <20250305202641.428114-1-oliver.upton@linux.dev>
References: <20250305202641.428114-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Apple M1 and M2 CPUs support IMPDEF traps of the PMUv3 sysregs, allowing
a hypervisor to virtualize an architectural PMU for a VM. Flip the
appropriate bit in HACR_EL2 on supporting hardware.

Tested-by: Janne Grunau <j@jannau.net>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kernel/cpu_errata.c | 44 ++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/arch/arm64/kernel/cpu_errata.c b/arch/arm64/kernel/cpu_errata.c
index 7ce555862895..a1e16b156fab 100644
--- a/arch/arm64/kernel/cpu_errata.c
+++ b/arch/arm64/kernel/cpu_errata.c
@@ -194,6 +194,43 @@ has_neoverse_n1_erratum_1542419(const struct arm64_cpu_capabilities *entry,
 	return is_midr_in_range(midr, &range) && has_dic;
 }
 
+static const struct midr_range impdef_pmuv3_cpus[] = {
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_PRO),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_ICESTORM_MAX),
+	MIDR_ALL_VERSIONS(MIDR_APPLE_M1_FIRESTORM_MAX),
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
@@ -794,6 +831,13 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
 					{}
 				})),
 	},
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

