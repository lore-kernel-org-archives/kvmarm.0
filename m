Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE03B20B1ED;
	Fri, 10 Jan 2025 11:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736506849; cv=none; b=ktF1gERH7GNZaohJjYuS+NaxsOTT3v5ZX6gfZgfltc7bRWLDcurWNW/RuXkEoDPTJX1zedGyKII11VjMVSvOrpG8t28Q9SGSu3O0Bq6BawoGnApvOL1Trbk/23ySezUZfkHyqKamyl2KlHDc1niA/IajRpW9ftVnDhhAI2REa/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736506849; c=relaxed/simple;
	bh=7t6+J0/0kwwj5Ro61nODugDvQ9MdrD/SAj9fDOldBM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oWPJ357Oa49O6MtAJpz9moe5CE5aHGq935ZdcWeK/eEQbMIqqW8oUwnPGv7inHlcjZ2pNAkGJe7q2l63wmLCuX8DnmeG+Z/miLSRLM3/VkXPrlTZLn739d+mTGB8UIZ0PydNEzllQWn8yNjx4WO+JeK1RJ7PhE98lgX9HWOQeds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bQr6L/82; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bQr6L/82"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8556EC4CED6;
	Fri, 10 Jan 2025 11:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736506848;
	bh=7t6+J0/0kwwj5Ro61nODugDvQ9MdrD/SAj9fDOldBM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQr6L/82jf4fmSGVwkard9Zw/C+Dv4VOW8HIEIzxoTNP+hVS32DeYAJngDbbwHAbL
	 KtD3SkEGPfJnXsTngjN2p/N8RrdOmjmv5pYsz8ibpgcm89/c8bocob3uZYLH1CnMng
	 LkhkXGreehb4S7hhNRn1mQ4M2wozEA7sybXL1JA+f30A4GUMluSGsg9jsfZjSmSoe7
	 UTTRtesKkBdQyHRWvHTotG1lOGhJ6Td6JWWHkgoD3X4v7S8UBi5CEYOVPMLfAQ6LMh
	 bFzxrnqEO+ZXpg0284J0cE1EiNmrEHcB9ruoKvwD2gHHAM8r6sz108axGxKGyMr/99
	 XYuX8gOn33GVQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Subject: [PATCH v2 3/7] arm64: cpufeature: add Allocation Tag Access Permission (MTE_PERM) feature
Date: Fri, 10 Jan 2025 16:30:19 +0530
Message-ID: <20250110110023.2963795-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
References: <20250110110023.2963795-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This indicates if the system supports MTE_PERM. This will be used by KVM
for stage 2 mapping. This is a CPUCAP_SYSTEM feature because if we enable
the feature all cpus must have it.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 5 +++++
 arch/arm64/include/asm/memory.h     | 2 ++
 arch/arm64/kernel/cpufeature.c      | 9 +++++++++
 arch/arm64/tools/cpucaps            | 1 +
 4 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 8b4e5a3cd24c..d70d60ca1cf7 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -813,6 +813,11 @@ static inline bool system_supports_mte(void)
 	return alternative_has_cap_unlikely(ARM64_MTE);
 }
 
+static inline bool system_supports_notagaccess(void)
+{
+	return alternative_has_cap_unlikely(ARM64_MTE_PERM);
+}
+
 static inline bool system_has_prio_mask_debugging(void)
 {
 	return IS_ENABLED(CONFIG_ARM64_DEBUG_PRIORITY_MASKING) &&
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index cb244668954c..6939e4700a5e 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -179,6 +179,7 @@
  * Memory types for Stage-2 translation
  */
 #define MT_S2_NORMAL			0b1111
+#define MT_S2_NORMAL_NOTAGACCESS	0b0100
 #define MT_S2_NORMAL_NC			0b0101
 #define MT_S2_DEVICE_nGnRE		0b0001
 
@@ -187,6 +188,7 @@
  * Stage-2 enforces Normal-WB and Device-nGnRE
  */
 #define MT_S2_FWB_NORMAL		0b0110
+#define MT_S2_FWB_NORMAL_NOTAGACCESS	0b1110
 #define MT_S2_FWB_NORMAL_NC		0b0101
 #define MT_S2_FWB_DEVICE_nGnRE		0b0001
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6ce71f444ed8..c9cd0735aaf5 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -309,6 +309,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_FPMR_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTEPERM_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2818,6 +2819,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64PFR1_EL1, MTE, MTE3)
 	},
+	{
+		.desc = "MTE Allocation Tag Access Permission",
+		.capability = ARM64_MTE_PERM,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_cpuid_feature,
+		ARM64_CPUID_FIELDS(ID_AA64PFR2_EL1, MTEPERM, IMP)
+	},
+
 #endif /* CONFIG_ARM64_MTE */
 	{
 		.desc = "RCpc load-acquire (LDAPR)",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index eb17f59e543c..10e01cf8ad96 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -66,6 +66,7 @@ MPAM
 MPAM_HCR
 MTE
 MTE_ASYMM
+MTE_PERM
 SME
 SME_FA64
 SME2
-- 
2.43.0

