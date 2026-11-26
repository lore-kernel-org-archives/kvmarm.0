Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795693819;
	b=gKHLP5bZAuKe2rs8kBG4EUuHAOUYRAqxAWVmkRJAbecpN9gP62knRHx2xV+SomHQDH3P
	 QNSNwye/W4TKZHZILrWA8sRNZCVJL8XuqSFaf9zey3Q2Mme/Z3tkwK7jfczI0mOJr/Ltd
	 bPdFx5AckvgOlmphjowjRNAof1/Rh9tUqhavQHFU9BsNRwdrd0LmcrcdsH0TYcCBeID+U
	 xoUU63x/+hRBEf4//2BuL160DoKMAvzFFYUs7Yok178uEMOmhdChk364NlpjmtZEi5nwj
	 pvMMKHWWADJnCyDAg7r28vIYMAigJ4/vZYFigqHHG1FW9p9ya3+KO6cg6/fWDql+jnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795693819;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=p6pCAmfKttvQs1qE/yGyvXWawOOJ5bLlKuCjOlPLrCE=;
	b=njZSSnBFlFKKjvHORjfz53XnNvNUs1tnAtbUkZmwxu/2QDpuwydQvB5HwSytOqpoCbOk
	 VCqK1iZSOM3lJxvhw835z64luIJYb5GU32A2Ew6OWupKQ2yswoI/4KVpBkWKWnBQLShdv
	 +0c8oXlxfhWEn5RQt9tTiWPCA3nCpMBMhko+tUqNPUFpnLqWDMh4sD/mzO3UKbyWcw5iF
	 zDobCSnnBztWmCJtf45jfkXYtrZ+dVSVzA85pIYSvrz/Rxh2ATJmBLubwOSLcIXE4NVoI
	 6DO08tXNSwQsu1T1OOELz1mHRjh2VVxLkIOigCWVZYNxNfrFTqIW/b23m85+O9siBqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ugYDt0iB;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 167FF606A321
	for <kvmarm@lists.linux.dev>; Thu, 26 Nov 2026 11:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 167FF606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ugYDt0iB
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C1F2D1C2B;
	Thu, 26 Nov 2026 03:50:15 -0800 (PST)
Received: from e142392.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5DEF23F632;
	Thu, 26 Nov 2026 03:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795693818; bh=Rdgqx0rOK7ovOMli2Zxsy7q/hl7GZXAheTR1CD4NiOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ugYDt0iBpMGL6SslLU1XaMAQqU1TNtSmLpd/Gm+m9CvPRgWvTiSxirQYEs1btE/SC
	 W8SjYqMva5D8yZZ8IX7RmiCLVlL9CeJm1/D6fAHYvddIEAvPIv+LklcoI8TIeHjPIN
	 tIhw4qShY2o68Y+fqVopvTPsdoU0T2IVDLNb2Qxg=
From: =?UTF-8?q?Kristina=20Mart=C5=A1enko?= <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-acpi@vger.kernel.org,
	kvmarm@lists.linux.dev,
	linux-efi@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Jinqian Yang <yangjinqian1@huawei.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [RFC v2 03/13] arm64: Detect TLBID
Date: Thu, 26 Nov 2026 11:49:26 +0000
Message-ID: <20261126114936.864256-4-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261126114936.864256-1-kristina.martsenko@arm.com>
References: <20261126114936.864256-1-kristina.martsenko@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Detect if FEAT_TLBID is supported by the system. Detect TLBID
configuration from TLBIDIDR_EL1. This information will be used in later
patches.

Signed-off-by: Kristina Martšenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/cpu.h        |  1 +
 arch/arm64/include/asm/cpufeature.h |  7 +++++++
 arch/arm64/kernel/cpufeature.c      | 25 +++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  3 +++
 arch/arm64/tools/cpucaps            |  1 +
 5 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/cpu.h b/arch/arm64/include/asm/cpu.h
index 3d1693aaf4e0..e839edded6ed 100644
--- a/arch/arm64/include/asm/cpu.h
+++ b/arch/arm64/include/asm/cpu.h
@@ -48,6 +48,7 @@ struct cpuinfo_arm64 {
 	u64		reg_gmid;
 	u64		reg_smidr;
 	u64		reg_mpamidr;
+	u64		reg_tlbididr;
 
 	u64		reg_id_aa64dfr0;
 	u64		reg_id_aa64dfr1;
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index e3c8a1493dc8..b236fe3077f5 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -658,6 +658,13 @@ static inline bool id_aa64pfr1_mte(u64 pfr1)
 	return val >= ID_AA64PFR1_EL1_MTE_MTE2;
 }
 
+static inline bool id_aa64mmfr4_tlbid(u64 mmfr4)
+{
+	u32 val = cpuid_feature_extract_unsigned_field(mmfr4, ID_AA64MMFR4_EL1_TLBID_SHIFT);
+
+	return val > 0;
+}
+
 void __init setup_boot_cpu_features(void);
 void __init setup_system_features(void);
 void __init setup_user_features(void);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c9c9a6889455..a08d1ff632e6 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -523,6 +523,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr3[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr4[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_TLBID_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_E2H0_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR4_EL1_NV_frac_SHIFT, 4, 0),
 	ARM64_FTR_END,
@@ -742,6 +743,14 @@ static const struct arm64_ftr_bits ftr_mpamidr[] = {
 	ARM64_FTR_END,
 };
 
+static const struct arm64_ftr_bits ftr_tlbididr[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NVOS_SHIFT, TLBIDIDR_EL1_NVOS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NOS_SHIFT, TLBIDIDR_EL1_NOS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NVIS_SHIFT, TLBIDIDR_EL1_NVIS_WIDTH, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, TLBIDIDR_EL1_NIS_SHIFT, TLBIDIDR_EL1_NIS_WIDTH, 0),
+	ARM64_FTR_END,
+};
+
 /*
  * Common ftr bits for a 32bit register with all hidden, strict
  * attributes, with 4bit feature fields and a default safe value of
@@ -866,6 +875,7 @@ static const struct __ftr_reg_entry {
 
 	/* Op1 = 0, CRn = 10, CRm = 4 */
 	ARM64_FTR_REG(SYS_MPAMIDR_EL1, ftr_mpamidr),
+	ARM64_FTR_REG(SYS_TLBIDIDR_EL1, ftr_tlbididr),
 
 	/* Op1 = 1, CRn = 0, CRm = 0 */
 	ARM64_FTR_REG(SYS_GMID_EL1, ftr_gmid),
@@ -1256,6 +1266,9 @@ static void __init init_cpu_features(void)
 
 	if (IS_ENABLED(CONFIG_ARM64_MTE) && id_aa64pfr1_mte(info->reg_id_aa64pfr1))
 		init_cpu_ftr_reg(SYS_GMID_EL1, info->reg_gmid);
+
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4))
+		init_cpu_ftr_reg(SYS_TLBIDIDR_EL1, info->reg_tlbididr);
 }
 
 static void update_cpu_ftr_reg(struct arm64_ftr_reg *reg, u64 new)
@@ -3085,6 +3098,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		ARM64_CPUID_FIELDS(ID_AA64ISAR3_EL1, LSUI, IMP)
 	},
 #endif
+	{
+		.desc = "TLBI domains (TLBID)",
+		.capability = ARM64_HAS_TLBID,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64MMFR4_EL1, TLBID, IMP)
+	},
 	{},
 };
 
@@ -3884,6 +3904,11 @@ void update_cpu_features(int cpu)
 		taint |= check_update_ftr_reg(SYS_GMID_EL1, cpu,
 					      info->reg_gmid, boot->reg_gmid);
 
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4)) {
+		taint |= check_update_ftr_reg(SYS_TLBIDIDR_EL1, cpu,
+					info->reg_tlbididr, boot->reg_tlbididr);
+	}
+
 	/*
 	 * If we don't have AArch32 at all then skip the checks entirely
 	 * as the register values may be UNKNOWN and we're not going to be
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 94e6cd211d70..da163756fe5c 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -504,6 +504,9 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
 		info->reg_smidr = read_cpuid(SMIDR_EL1) & ~SMIDR_EL1_SMPS;
 	}
 
+	if (id_aa64mmfr4_tlbid(info->reg_id_aa64mmfr4))
+		info->reg_tlbididr = read_cpuid_with_overrides(TLBIDIDR_EL1);
+
 	cpuinfo_detect_icache_policy(info);
 }
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 3125695122a0..a1500a655407 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -67,6 +67,7 @@ HAS_STAGE2_FWB
 HAS_TCR2
 HAS_TIDCP1
 HAS_TLB_RANGE
+HAS_TLBID
 HAS_VA52
 HAS_VIRT_HOST_EXTN
 HAS_WFXT
-- 
2.43.0

