Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2C17199BA
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CCDC168F;
	Mon, 27 Nov 2023 03:18:49 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 335D53F73F;
	Mon, 27 Nov 2023 03:18:00 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v6 05/12] arm64: Add ARM64_HAS_LPA2 CPU capability
Date: Mon, 27 Nov 2023 11:17:30 +0000
Message-Id: <20231127111737.1897081-6-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231127111737.1897081-1-ryan.roberts@arm.com>
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose FEAT_LPA2 as a capability so that we can take advantage of
alternatives patching in the hypervisor.

Although FEAT_LPA2 presence is advertised separately for stage1 and
stage2, the expectation is that in practice both stages will either
support or not support it. Therefore, we combine both into a single
capability, allowing us to simplify the implementation. KVM requires
support in both stages in order to use LPA2 since the same library is
used for hyp stage 1 and guest stage 2 pgtables.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 ++++
 arch/arm64/kernel/cpufeature.c      | 39 +++++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 45 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index f6d416fe49b0..acf109581ac0 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -819,6 +819,11 @@ static inline bool system_supports_tlb_range(void)
 	return alternative_has_cap_unlikely(ARM64_HAS_TLB_RANGE);
 }
 
+static inline bool system_supports_lpa2(void)
+{
+	return cpus_have_final_cap(ARM64_HAS_LPA2);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 646591c67e7a..7900ba7e157e 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1768,6 +1768,39 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	return !meltdown_safe;
 }
 
+#if defined(ID_AA64MMFR0_EL1_TGRAN_LPA2) && defined(ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2)
+static bool has_lpa2_at_stage1(u64 mmfr0)
+{
+	unsigned int tgran;
+
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+					ID_AA64MMFR0_EL1_TGRAN_SHIFT);
+	return tgran == ID_AA64MMFR0_EL1_TGRAN_LPA2;
+}
+
+static bool has_lpa2_at_stage2(u64 mmfr0)
+{
+	unsigned int tgran;
+
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+					ID_AA64MMFR0_EL1_TGRAN_2_SHIFT);
+	return tgran == ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2;
+}
+
+static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 mmfr0;
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);
+}
+#else
+static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define KPTI_NG_TEMP_VA		(-(1UL << PMD_SHIFT))
 
@@ -2731,6 +2764,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
 	},
+	{
+		.desc = "52-bit Virtual Addressing for KVM (LPA2)",
+		.capability = ARM64_HAS_LPA2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_lpa2,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index b98c38288a9d..919eceb0b3da 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -37,6 +37,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCX
 HAS_LDAPR
+HAS_LPA2
 HAS_LSE_ATOMICS
 HAS_MOPS
 HAS_NESTED_VIRT
-- 
2.25.1

