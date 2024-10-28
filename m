Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23A361C3F27;
	Mon, 28 Oct 2024 09:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730108442; cv=none; b=FkS84KdfaP7GzPkhl5CkDWNLEkaS4g3KU8qQ1pewHVw/yEnNzL4+6a60VXPOtUAjUDW3SszewC1zToAjng/3qV9CDNa5UXW6mZy1eKOk3ieQ71DUS2O6pzZ0ZOVypVEWqt0U1YHSLA6tdtwj0aJl9M9eZjN86qKrPVo45GojLVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730108442; c=relaxed/simple;
	bh=RL1PZZNf/Qj/0CoaY+xr8w3mCVtSPwhdkys11uyrEvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qE0z/z183MAtwKdlR4FNKjt+ORdKvUly1kETa0V9U3a8i+HxK6f7UrcyDvsQm6sgE0o+zWgI00TfMoZ1mBGT/nsnKE3RwRlgAMynKuZUzYOSZ7KvdcktCwOpcpNZtIZVMcXgPe+ADhCmTt9Z8LS2z04ths+HTxpSvtW27x9Am0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HlSAs4nH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HlSAs4nH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7022BC4CEC3;
	Mon, 28 Oct 2024 09:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730108441;
	bh=RL1PZZNf/Qj/0CoaY+xr8w3mCVtSPwhdkys11uyrEvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HlSAs4nHSi8Xsp1PizspeIZXy72a6PgV2vUn6GZDzYeFo5s/f3OEKccFiiaEfWYo6
	 KbLSASzGtqlGRfJWRpeJbqkFUcS25er91XoEvH9eGWzp+wUWoGSM69I/9zz3ZG4yKD
	 XDbv63ZzJhUTGzbyDugx79sYl2qD8AAohXOmhVAPtLIHXk4gnGtT+nYnUpYIi04ks5
	 NJXKMmA196rgn3y6KQEBsJUwCEgvnjD2YRrYEZKAW84wFeUB7JyIr0kzqXBXEV2yMw
	 +tBdbjz+OHqAaHAqDqyaI1Ml64RYfZH1XH+UkuSCkF8/H/l+evz/FTk8pLSI2pNasd
	 ucGbLvsHnKKoQ==
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
Subject: [PATCH 2/4] arm64: cpufeature: add Allocation Tag Access Permission (MTE_PERM) feature
Date: Mon, 28 Oct 2024 15:10:12 +0530
Message-ID: <20241028094014.2596619-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
References: <20241028094014.2596619-1-aneesh.kumar@kernel.org>
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

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/cpufeature.h | 5 +++++
 arch/arm64/include/asm/memory.h     | 2 ++
 arch/arm64/kernel/cpufeature.c      | 9 +++++++++
 arch/arm64/tools/cpucaps            | 1 +
 4 files changed, 17 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 3d261cc123c1..6e6631890021 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -805,6 +805,11 @@ static inline bool system_supports_mte(void)
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
index ca42f6d87c16..006a649d4ac7 100644
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
index 718728a85430..608e24e313ad 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -305,6 +305,7 @@ static const struct arm64_ftr_bits ftr_id_aa64pfr1[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr2[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_FPMR_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR2_EL1_MTEPERM_SHIFT, 4, 0),
 	ARM64_FTR_END,
 };
 
@@ -2742,6 +2743,14 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
index eedb5acc21ed..81c6599d2a95 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -62,6 +62,7 @@ KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MTE
 MTE_ASYMM
+MTE_PERM
 SME
 SME_FA64
 SME2
-- 
2.43.0

