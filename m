Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 998CE79CC
	for <kvmarm@lists.linux.dev>; Thu, 16 Feb 2023 16:01:34 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D68F1168F;
	Thu, 16 Feb 2023 08:02:16 -0800 (PST)
Received: from e126864.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 14FAD3F881;
	Thu, 16 Feb 2023 08:01:30 -0800 (PST)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Luis Machado <luis.machado@arm.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] arm64: cpufeature: detect FEAT_HCX
Date: Thu, 16 Feb 2023 16:00:04 +0000
Message-Id: <20230216160012.272345-3-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230216160012.272345-1-kristina.martsenko@arm.com>
References: <20230216160012.272345-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Detect if the system has the new HCRX_EL2 register added in ARMv8.7/9.2,
so that subsequent patches can check for its presence.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/kernel/cpufeature.c | 12 ++++++++++++
 arch/arm64/tools/cpucaps       |  1 +
 2 files changed, 13 insertions(+)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 45a42cf2191c..1b0a71541381 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -357,6 +357,7 @@ static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
 static const struct arm64_ftr_bits ftr_id_aa64mmfr1[] = {
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_TIDCP1_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_AFP_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_HCX_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_ETS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_TWED_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64MMFR1_EL1_XNX_SHIFT, 4, 0),
@@ -2290,6 +2291,17 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
 		.matches = is_kvm_protected_mode,
 	},
+	{
+		.desc = "HCRX_EL2 register",
+		.capability = ARM64_HAS_HCX,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.sys_reg = SYS_ID_AA64MMFR1_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR1_EL1_HCX_SHIFT,
+		.field_width = 4,
+		.min_field_value = ID_AA64MMFR1_EL1_HCX_IMP,
+		.matches = has_cpuid_feature,
+	},
 #endif
 	{
 		.desc = "Kernel page table isolation (KPTI)",
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 10dcfa13390a..bf32a1122c04 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -31,6 +31,7 @@ HAS_GENERIC_AUTH_IMP_DEF
 HAS_GIC_CPUIF_SYSREGS
 HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
+HAS_HCX
 HAS_LDAPR
 HAS_LSE_ATOMICS
 HAS_NO_FPSIMD
-- 
2.25.1

