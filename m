Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EEEC436344
	for <kvmarm@lists.linux.dev>; Fri, 27 Feb 2026 15:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772205460; cv=none; b=tjQJux8PyajyHaQ5iiDu397eVKe2g7OZZXQAsmHbgYyai2npeH7LVlH6lOxPQi7Eskc7H35QbT4yUh5qUXVZ3gcO2M+0RDmokQhx8UVLRIpHZdWRjJ3271s+Eu10MEEW4mXupmqFABmR7S76jUD8Upc2EqcVBtSEfUlDUriGT3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772205460; c=relaxed/simple;
	bh=XESANQC/s6OALJdLs3NlY0zl7jnA3aP+X3rssV/Wfd0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=C0Ecm1Orz53rhCg6CngUtS/YKTK+MGty6J39LRzXoVzKiy9NL81/vWsYSgBqk2nwf58ridem2I3T2twPeZrui146fRH9Ru6Lf5ei5Q8tIqbQP2atMMqBvl6eowLrePaK/tG9gtYwVrcEyvWRuKutN8n58Wc8/ojZm1YJ60X02go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 906DF1516;
	Fri, 27 Feb 2026 07:17:32 -0800 (PST)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.1.197.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F0A003F73B;
	Fri, 27 Feb 2026 07:17:35 -0800 (PST)
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	maz@kernel.org,
	oupton@kernel.org,
	miko.lenczewski@arm.com,
	kevin.brodsky@arm.com,
	broonie@kernel.org,
	ardb@kernel.org,
	suzuki.poulose@arm.com,
	lpieralisi@kernel.org,
	joey.gouly@arm.com,
	yuzenghui@huawei.com,
	yeoreum.yun@arm.com
Subject: [PATCH v15 1/8] arm64: cpufeature: add FEAT_LSUI
Date: Fri, 27 Feb 2026 15:16:58 +0000
Message-Id: <20260227151705.1275328-2-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260227151705.1275328-1-yeoreum.yun@arm.com>
References: <20260227151705.1275328-1-yeoreum.yun@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since Armv9.6, FEAT_LSUI introduces load/store instructions that allow
privileged code to access user memory without clearing the PSTATE.PAN bit.

Add CPU feature detection for FEAT_LSUI and enable its use
when FEAT_PAN is present so that removes the need for SW_PAN handling
when using LSUI instructions.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 ++
 arch/arm64/kernel/cpufeature.c   | 10 ++++++++++
 arch/arm64/tools/cpucaps         |  1 +
 3 files changed, 13 insertions(+)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 177c691914f8..6e3da333442e 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -71,6 +71,8 @@ cpucap_is_possible(const unsigned int cap)
 		return true;
 	case ARM64_HAS_PMUV3:
 		return IS_ENABLED(CONFIG_HW_PERF_EVENTS);
+	case ARM64_HAS_LSUI:
+		return IS_ENABLED(CONFIG_ARM64_LSUI);
 	}
 
 	return true;
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c31f8e17732a..5074ff32176f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -281,6 +281,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar2[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_FPRCVT_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_LSUI_SHIFT, 4, ID_AA64ISAR3_EL1_LSUI_NI),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_LSFE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64ISAR3_EL1_FAMINMAX_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -3169,6 +3170,15 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.cpu_enable = cpu_enable_ls64_v,
 		ARM64_CPUID_FIELDS(ID_AA64ISAR1_EL1, LS64, LS64_V)
 	},
+#ifdef CONFIG_ARM64_LSUI
+	{
+		.desc = "Unprivileged Load Store Instructions (LSUI)",
+		.capability = ARM64_HAS_LSUI,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
+	},
+#endif
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 7261553b644b..b7286d977788 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -48,6 +48,7 @@ HAS_LPA2
 HAS_LSE_ATOMICS
 HAS_LS64
 HAS_LS64_V
+HAS_LSUI
 HAS_MOPS
 HAS_NESTED_VIRT
 HAS_BBML2_NOABORT
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}

