Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C6BE1D6DA3
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079764; cv=none; b=Ab3wPnpEBqF+OJ49HAj74eJrxwqzlk9+RxjG9iIdBBG08GQ7upkpYTNIP7+KPK+vWWE6B/1kua/x6myL8nhLKD4WR60rUFoAxrjUC4KuDNlfhPe0VSJgz9Q2C+3WjQFrasRYtGtat3b6CZt5gwY6GNumFJlm5djSUSeQBTcbzlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079764; c=relaxed/simple;
	bh=m/Bz7jiFLstk4d21RWDvrAzY7UGn8FJNGjYOYkNaSI8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qR/CH7NlELQGPvf6Dz/deByQZXkhpri+zSLrfTEjgqAAyy4//eOCT99fChRTl/ARLRirvRyH6qK/MzW7mqpH/XgS3lBNNxR3MN4P+LmcLKeUCuAtDWaRgsWSq6U5QEFYuIBJuMwHn4zHs9oRYhJP/Uan9ZHsESsS1t7Emk/w3/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0FEC5497;
	Tue, 28 Jan 2025 07:56:28 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D6CB53F694;
	Tue, 28 Jan 2025 07:55:59 -0800 (PST)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	suzuki.poulose@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com
Subject: [PATCH 2/4] arm64: cpufeature: factor out cpu_is_meltdown_safe()
Date: Tue, 28 Jan 2025 15:54:26 +0000
Message-Id: <20250128155428.210645-3-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250128155428.210645-1-mark.rutland@arm.com>
References: <20250128155428.210645-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently needs_kpti() checks whether a CPU is immune to meltdown. The
ID_AA64PFR0_EL1.CSV3 ID register field allows a CPU to self report that
it is immune, and kpti_safe_list contains CPUs which are known to be
immune but predate the existence of ID_AA64PFR0_EL1.CSV3.

In future there may be additional reasons to enable KPTI for a CPU
regardless of whether that CPU is immune to meltdown.

Factor out the existing meltdown checks into a new
cpu_is_meltdown_safe() helper function. The ID_AA64PFR0_EL1.CSV3 field
description is removed from the capability structure and made explicit
within cpu_is_meltdown_safe(). As needs_kpti() is only called with
SCOPE_LOCAL, this should not result in any functional change.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marins <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 43 +++++++++++++++++++++-------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 8fdcff3722696..b746bb16ee785 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1755,13 +1755,12 @@ has_useable_cnp(const struct arm64_cpu_capabilities *entry, int scope)
 	return has_cpuid_feature(entry, scope);
 }
 
-static bool __meltdown_safe = true;
-static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
-
-static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
+static bool cpu_is_meltdown_safe(void)
 {
-	/* List of CPUs that are not vulnerable and don't need KPTI */
-	static const struct midr_range kpti_safe_list[] = {
+	u64 pfr0;
+
+	/* List of CPUs that are not vulnerable to meltdown */
+	static const struct midr_range meltdown_safe_list[] = {
 		MIDR_ALL_VERSIONS(MIDR_CAVIUM_THUNDERX2),
 		MIDR_ALL_VERSIONS(MIDR_BRCM_VULCAN),
 		MIDR_ALL_VERSIONS(MIDR_BRAHMA_B53),
@@ -1779,15 +1778,32 @@ static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 		MIDR_ALL_VERSIONS(MIDR_QCOM_KRYO_4XX_SILVER),
 		{ /* sentinel */ }
 	};
+
+	if (is_midr_in_range_list(read_cpuid_id(), meltdown_safe_list))
+		return true;
+
+	/*
+	 * ID_AA64PFR0_EL1.CSV3 > 0 indicates that this CPU is not vulnerable
+	 * to meltdown.
+	 */
+	pfr0 = __read_sysreg_by_encoding(SYS_ID_AA64PFR0_EL1);
+	if (cpuid_feature_extract_unsigned_field(pfr0, ID_AA64PFR0_EL1_CSV3_SHIFT))
+		return true;
+
+	return false;
+}
+
+static bool __meltdown_safe = true;
+static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
+
+static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
+{
 	char const *str = "kpti command line option";
 	bool meltdown_safe;
 
-	meltdown_safe = is_midr_in_range_list(read_cpuid_id(), kpti_safe_list);
-
-	/* Defer to CPU feature registers */
-	if (has_cpuid_feature(entry, scope))
-		meltdown_safe = true;
+	WARN_ON(scope != SCOPE_LOCAL_CPU);
 
+	meltdown_safe = cpu_is_meltdown_safe();
 	if (!meltdown_safe)
 		__meltdown_safe = false;
 
@@ -2545,11 +2561,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_BOOT_RESTRICTED_CPU_LOCAL_FEATURE,
 		.cpu_enable = cpu_enable_kpti,
 		.matches = needs_kpti,
-		/*
-		 * The ID feature fields below are used to indicate that the
-		 * CPU doesn't need KPTI. See needs_kpti for more details.
-		 */
-		ARM64_CPUID_FIELDS(ID_AA64PFR0_EL1, CSV3, IMP)
 	},
 	{
 		.capability = ARM64_HAS_FPSIMD,
-- 
2.30.2

