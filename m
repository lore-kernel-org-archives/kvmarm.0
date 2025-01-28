Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF1B21D63FD
	for <kvmarm@lists.linux.dev>; Tue, 28 Jan 2025 15:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738079774; cv=none; b=FFbN4re2JXBImR4rq7hmGwyh39Bx7DJi6GDM/CnB9z0CJlyoyqiwDEbI0CG/w1yqhDSpbYqFXBoeKr1ljhZWIFW9QRgZt4mM9gqQflu+a2lEKQBAl1vdXeAeSCHg1V2JKDFLJOvZ+9XuMTUHUHpCjEY6t9GJIFVt6Vv0rJ6Z1Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738079774; c=relaxed/simple;
	bh=1rbWs5jWdSjgE+B44ZQJeBFCn+YMydfG4GONrwP7gkY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=NgiWtl+S8hxRh6qsW+RmoOLfE1OpIQPdOeW7TiVhhEgRgxcj9uRxRmazf0Kv0UcfRvOCb5+7160jA4D4UEm8oQtl/3LAMXGZXRVs0STzuEbNM1w4oMMwujdly+RV4ugotPyrOlneE4fMUGE/8EgIlpt97FAAz8db3d4WEDCYZtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F1CAD497;
	Tue, 28 Jan 2025 07:56:38 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C47F73F694;
	Tue, 28 Jan 2025 07:56:10 -0800 (PST)
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
Subject: [PATCH 3/4] arm64: cpufeature: mitigate CVE-2024-7881
Date: Tue, 28 Jan 2025 15:54:27 +0000
Message-Id: <20250128155428.210645-4-mark.rutland@arm.com>
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

On some CPUs from Arm Ltd, it is possible for unprivileged code to cause
a hardware prefetcher to form an address using the contents of a memory
location which is accessible by privileged accesses in the active
translation regime, potentially leaking the contents of this memory
location via a side channel. This has been assigned CVE-2024-7881:

  https://developer.arm.com/Arm%20Security%20Center/Arm%20CPU%20Vulnerability%20CVE-2024-7881

Arm's recommended mitigation is that firmware configures an
IMPLEMENTATION DEFINED control bit (CPUACTLR6_EL1[41]) to disable the
affected prefetcher, and updates to Trusted Firmware-A are available to
do this. Presence of the firmware mitigation is indicated by the
presence of a new SMCCC call, SMCCC_ARCH_WORKAROUND_4, which is
documented in the SMCCC 1.6 G BET0 specification:

  https://developer.arm.com/documentation/den0028/gbet0/?lang=en

Note that SMCCC_ARCH_WORKAROUND_4 has no return value, and exists solely
such that it can be detected via SMCCC_ARCH_FEATURES.

On systems which have not yet received a firmware update, enabling KPTI
will help to mitigate the issue. This patch enables KPTI on affected
parts where the lack of SMCCC_ARCH_WORKAROUND_4 indicates the absence of
the firmware workaround. This will implicitly disable SPE and/or TRBE if
either of these are present.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/cpufeature.c | 34 +++++++++++++++++++++++++++++++++-
 include/linux/arm-smccc.h      |  5 +++++
 2 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index b746bb16ee785..e90bf4dcb6f1c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1793,6 +1793,35 @@ static bool cpu_is_meltdown_safe(void)
 	return false;
 }
 
+static bool cpu_has_leaky_prefetcher(void)
+{
+	struct arm_smccc_res res;
+
+	/* CPUs which are affected by CVE-2024-7881 */
+	static const struct midr_range leaky_prefetcher_list[] = {
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X3),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X4),
+		MIDR_ALL_VERSIONS(MIDR_CORTEX_X925),
+		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V2),
+		MIDR_ALL_VERSIONS(MIDR_NEOVERSE_V3),
+		{ /* sentinel */ }
+	};
+
+	if (!is_midr_in_range_list(read_cpuid_id(), leaky_prefetcher_list))
+		return false;
+
+	/*
+	 * If ARCH_WORKAROUND_4 is implemented, then the firmware mitigation is
+	 * present. There is no need to call ARCH_WORKAROUND_4 itself.
+	 */
+	arm_smccc_1_1_invoke(ARM_SMCCC_ARCH_FEATURES_FUNC_ID,
+			     ARM_SMCCC_ARCH_WORKAROUND_4, &res);
+	if (res.a0 == SMCCC_RET_SUCCESS)
+		return false;
+
+	return true;
+}
+
 static bool __meltdown_safe = true;
 static int __kpti_forced; /* 0: not forced, >0: forced on, <0: forced off */
 
@@ -1800,6 +1829,7 @@ static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 {
 	char const *str = "kpti command line option";
 	bool meltdown_safe;
+	bool prefetcher_safe;
 
 	WARN_ON(scope != SCOPE_LOCAL_CPU);
 
@@ -1807,6 +1837,8 @@ static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 	if (!meltdown_safe)
 		__meltdown_safe = false;
 
+	prefetcher_safe = !cpu_has_leaky_prefetcher();
+
 	/*
 	 * For reasons that aren't entirely clear, enabling KPTI on Cavium
 	 * ThunderX leads to apparent I-cache corruption of kernel text, which
@@ -1846,7 +1878,7 @@ static bool needs_kpti(const struct arm64_cpu_capabilities *entry, int scope)
 		return __kpti_forced > 0;
 	}
 
-	return !meltdown_safe;
+	return !meltdown_safe || !prefetcher_safe;
 }
 
 static bool has_nv1(const struct arm64_cpu_capabilities *entry, int scope)
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 67f6fdf2e7cd8..e77103ab2adfd 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -100,6 +100,11 @@
 			   ARM_SMCCC_SMC_32,				\
 			   0, 0x3fff)
 
+#define ARM_SMCCC_ARCH_WORKAROUND_4					\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   0, 0x0004)
+
 #define ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
 			   ARM_SMCCC_SMC_32,				\
-- 
2.30.2

