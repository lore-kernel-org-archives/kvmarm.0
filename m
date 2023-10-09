Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13198FBE3
	for <kvmarm@lists.linux.dev>; Mon,  9 Oct 2023 18:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 34B7A1474;
	Mon,  9 Oct 2023 11:51:05 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E54293F5A1;
	Mon,  9 Oct 2023 11:50:22 -0700 (PDT)
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
Subject: [PATCH v4 04/12] KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
Date: Mon,  9 Oct 2023 19:50:00 +0100
Message-Id: <20231009185008.3803879-5-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231009185008.3803879-1-ryan.roberts@arm.com>
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose FEAT_LPA2 as a capability so that we can take advantage of
alternatives patching in both the kernel and hypervisor.

Although FEAT_LPA2 presence is advertised separately for stage1 and
stage2, the expectation is that in practice both stages will either
support or not support it. Therefore, for the case where KVM is present,
we combine both into a single capability, allowing us to simplify the
implementation. For the case where KVM is not present, we only care
about stage1.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 ++++
 arch/arm64/kernel/cpufeature.c      | 46 +++++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 52 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 5bba39376055..b1292ec88538 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -831,6 +831,11 @@ static inline bool system_supports_tlb_range(void)
 		cpus_have_const_cap(ARM64_HAS_TLB_RANGE);
 }
 
+static inline bool system_supports_lpa2(void)
+{
+	return cpus_have_const_cap(ARM64_HAS_LPA2);
+}
+
 int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
 bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 444a73c2e638..1ccb1fe0e310 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1746,6 +1746,46 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
 	return !meltdown_safe;
 }
 
+static inline bool has_lpa2_at_stage1(u64 mmfr0)
+{
+#if defined(CONFIG_ARM64_4K_PAGES) || defined(CONFIG_ARM64_16K_PAGES)
+	unsigned int tgran;
+
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+						ID_AA64MMFR0_EL1_TGRAN_SHIFT);
+	return tgran == ID_AA64MMFR0_EL1_TGRAN_LPA2;
+#else
+	return false;
+#endif
+}
+
+static inline bool has_lpa2_at_stage2(u64 mmfr0)
+{
+#if defined(CONFIG_ARM64_4K_PAGES) || defined(CONFIG_ARM64_16K_PAGES)
+	unsigned int tgran;
+
+	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
+						ID_AA64MMFR0_EL1_TGRAN_2_SHIFT);
+	return tgran == ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2;
+#else
+	return false;
+#endif
+}
+
+static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
+{
+	u64 mmfr0;
+	bool ret;
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	ret = has_lpa2_at_stage1(mmfr0);
+
+	if (kvm_get_mode() != KVM_MODE_NONE)
+		ret = ret && has_lpa2_at_stage2(mmfr0);
+
+	return ret;
+}
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define KPTI_NG_TEMP_VA		(-(1UL << PMD_SHIFT))
 
@@ -2719,6 +2759,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = has_cpuid_feature,
 		ARM64_CPUID_FIELDS(ID_AA64MMFR2_EL1, EVT, IMP)
 	},
+	{
+		.desc = "Large Physical Address 2",
+		.capability = ARM64_HAS_LPA2,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_lpa2,
+	},
 	{},
 };
 
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index dea3dc89234b..07f3957b8488 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -36,6 +36,7 @@ HAS_GIC_PRIO_MASKING
 HAS_GIC_PRIO_RELAXED_SYNC
 HAS_HCX
 HAS_LDAPR
+HAS_LPA2
 HAS_LSE_ATOMICS
 HAS_MOPS
 HAS_NESTED_VIRT
-- 
2.25.1

