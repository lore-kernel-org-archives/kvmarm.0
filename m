Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82045225
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 06:58:00 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 552351476;
	Sun, 17 Sep 2023 23:58:37 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 511B63F5A1;
	Sun, 17 Sep 2023 23:57:58 -0700 (PDT)
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
Subject: [PATCH v3 04/13] KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
Date: Mon, 18 Sep 2023 07:57:31 +0100
Message-Id: <20230918065740.3670662-5-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230918065740.3670662-1-ryan.roberts@arm.com>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
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
support or not support it. Therefore we combine both into a single
capability, allowing us to simplify the implementation.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/cpufeature.h |  5 ++++
 arch/arm64/kernel/cpufeature.c      | 40 +++++++++++++++++++++++++++++
 arch/arm64/tools/cpucaps            |  1 +
 3 files changed, 46 insertions(+)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 96e50227f940..50fa716dd123 100644
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
index b018ae12ff5f..5893ca103d10 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1745,6 +1745,40 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
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
+
+	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
+	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);
+}
+
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define KPTI_NG_TEMP_VA		(-(1UL << PMD_SHIFT))
 
@@ -2718,6 +2752,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
index c3f06fdef609..a328aff8a5a0 100644
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

