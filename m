Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AF0B449B39
	for <kvmarm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321983; cv=none; b=d2RIKEzAWve/NWuz13uh5q/RcquTjRDQMwAimN13HgvLGL6VZ6Mxz2H8SabVhDjMmIzV0TZlGleTmxEXfH8rL3xSfIJAD1febIVPC0svnsHbiFd6SmhWh3z+2TmtOTzmaz19tzIlbZavHQ5dN3ottbbPK/FFg1/sCMkLdvEQr+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321983; c=relaxed/simple;
	bh=ww+ujFwrxHSFwXIewOfjab1xcMut8ZTXhS1FDEYJSMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kqsN6eicyZ2K9GkOSh7bBgBd9Ltn7FJIUL8JtEINpWg5fsMU+IP74DBFBvbiLlBiZ9SXC3CGh784L2pdEQyasB5haeiDjsERz3E2JrwGrlatMwxfKelycpLpf40Rd9roa1uCFQ40Mi8NC/WXbHz5/3hwvBuf42V7pCd4v+PE8w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=KZGW5U1u; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="KZGW5U1u"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79A851688;
	Wed, 29 Jul 2026 03:46:17 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B64913F66F;
	Wed, 29 Jul 2026 03:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785321981; bh=ww+ujFwrxHSFwXIewOfjab1xcMut8ZTXhS1FDEYJSMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZGW5U1ubRa1YyujGLMAU0dSNRq6m8qPugyQEoHm9CdaOrrY+DG2k2NeNrx0tmvWz
	 ZncJ1VHLFeChxN8dpqa2dMNdaVF6WWdJ3vdF6FUmQ0F64ztxWealuV+1JEH0vFHElX
	 AYMX4CGmExkI6d3V1xgf+8mf28dXL8qbyzpGsIYw=
From: Leonardo Bras <leo.bras@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	James Morse <james.morse@arm.com>,
	Leonardo Bras <leo.bras@arm.com>,
	Yang Shi <yang@os.amperecomputing.com>,
	mrigendrachaubey <mrigendra.chaubey@gmail.com>,
	Thomas Huth <thuth@redhat.com>,
	Zeng Heng <zengheng4@huawei.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	James Clark <james.clark@linaro.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Tian Zheng <zhengtian10@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Subject: [PATCH v3 02/11] arm64/cpufeature: Add system-wide FEAT_HACDBS detection
Date: Wed, 29 Jul 2026 11:45:37 +0100
Message-ID: <20260729104548.3439958-3-leo.bras@arm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260729104548.3439958-1-leo.bras@arm.com>
References: <20260729104548.3439958-1-leo.bras@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4237; i=leo.bras@arm.com; h=from:subject; bh=ww+ujFwrxHSFwXIewOfjab1xcMut8ZTXhS1FDEYJSMo=; b=owGbwMvMwCX2pizjszvTwvWMp9WSGLIyb17tP/vkrsAsq+5/H29u33BvuszavVXrI/0NfEMXz dgTIaES3VHKwiDGxSArpsgi+2j+Kp7vUzKOXPmxAGYOKxPIEAYuTgGYyMwCRoam66cvXNrCnFn9 WXzxp28G/T/ubTX+WxHlUX1pcztLUdYNRoYVrvwK3KFFi9XL05jPLZswbW5MwXTruPoZf/5WrFM Ta+cBAA==
X-Developer-Key: i=leo.bras@arm.com; a=openpgp; fpr=36E6C95AE0F111CC5B6F4D2E688C33F8A0C5B0C5
Content-Transfer-Encoding: 8bit

FEAT_HACDBS will only be used for dirty-bit cleaning if it is detected in
all running cpus.

Signed-off-by: Leonardo Bras <leo.bras@arm.com>
---
 arch/arm64/include/asm/cpufeature.h | 5 +++++
 arch/arm64/kernel/cpufeature.c      | 8 ++++++++
 arch/arm64/tools/cpucaps            | 1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index bdfab086fd94..620ae4cddb76 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -861,20 +861,25 @@ static inline bool system_supports_gcs(void)
 static inline bool system_supports_haft(void)
 {
 	return cpus_have_final_cap(ARM64_HAFT);
 }
 
 static inline bool system_supports_hdbss(void)
 {
 	return cpus_have_final_cap(ARM64_HAS_HDBSS);
 }
 
+static inline bool system_supports_hacdbs(void)
+{
+	return cpus_have_final_cap(ARM64_HACDBS);
+}
+
 static __always_inline bool system_supports_mpam(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM);
 }
 
 static __always_inline bool system_supports_mpam_hcr(void)
 {
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index aa327eebaf1c..62f56bbd0a65 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -516,20 +516,21 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 		       FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1POE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_S1PIE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_SCTLRX_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR3_EL1_TCRX_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_HACDBS_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
 static const struct arm64_ftr_bits ftr_ctr[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_EXACT, 31, 1, 1), /* RES1 */
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DIC_SHIFT, 1, 1),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_IDC_SHIFT, 1, 1),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_EL0_CWG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_HIGHER_OR_ZERO_SAFE, CTR_EL0_ERG_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, CTR_EL0_DminLine_SHIFT, 4, 1),
@@ -2764,20 +2765,27 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "Hardware dirty bit management",
 		.type = ARM64_CPUCAP_WEAK_LOCAL_CPU_FEATURE,
 		.capability = ARM64_HW_DBM,
 		.matches = has_hw_dbm,
 		.cpu_enable = cpu_enable_hw_dbm,
 		.cpus = &dbm_cpus,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, DBM)
 	},
 #endif
+	{
+		.desc = "Hardware dirty bit Cleaning",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_HACDBS,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, HACDBS, IMP)
+	},
 #ifdef CONFIG_ARM64_HAFT
 	{
 		.desc = "Hardware managed Access Flag for Table Descriptors",
 		/*
 		 * Contrary to the page/block access flag, the table access flag
 		 * cannot be emulated in software (no access fault will occur).
 		 * Therefore this should be used only if it's supported system
 		 * wide.
 		 */
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index a87706c9d160..bd2c0bb98da6 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -65,20 +65,21 @@ HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
 HAS_TLB_RANGE
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
 HAS_XNX
 HAS_HDBSS
 HAFT
 HW_DBM
+HACDBS
 KVM_HVHE
 KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MPAM
 MPAM_HCR
 MTE
 MTE_ASYMM
 MTE_FAR
 MTE_STORE_ONLY
 SME
-- 
2.55.0

