From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH 24/27] arm64/sve: Detect SVE and activate runtime support
Date: Wed,  9 Aug 2017 13:05:30 +0100
Message-ID: <1502280338-23002-25-git-send-email-Dave.Martin@arm.com>
References: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1502280338-23002-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch enables detection of hardware SVE support via the
cpufeatures framework, and reports its presence to the kernel and
userspace via the new ARM64_SVE cpucap and HWCAP_SVE hwcap
respectively.

Userspace can also detect SVE using ID_AA64PFR0_EL1, using the
cpufeatures MRS emulation.

When running on hardware that supports SVE, this enables runtime
kernel support for SVE, and allows user tasks to execute SVE
instructions and make of the of the SVE-specific user/kernel
interface extensions implemented by this series.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/cpufeature.h |  3 ++-
 arch/arm64/include/uapi/asm/hwcap.h |  1 +
 arch/arm64/kernel/cpufeature.c      | 16 ++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 5 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8d2272c..0b4ce6a 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -39,7 +39,8 @@
 #define ARM64_WORKAROUND_QCOM_FALKOR_E1003	18
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
+#define ARM64_SVE				21
 
-#define ARM64_NCAPS				21
+#define ARM64_NCAPS				22
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 05eec27..27182bb 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -272,7 +272,8 @@ static inline bool system_uses_ttbr0_pan(void)
 
 static inline bool system_supports_sve(void)
 {
-	return false;
+	return IS_ENABLED(CONFIG_ARM64_SVE) &&
+		cpus_have_const_cap(ARM64_SVE);
 }
 
 /*
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 4e187ce..7d2ec07 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -35,5 +35,6 @@
 #define HWCAP_JSCVT		(1 << 13)
 #define HWCAP_FCMA		(1 << 14)
 #define HWCAP_LRCPC		(1 << 15)
+#define HWCAP_SVE		(1 << 16)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index f322c90..390cb73 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -125,6 +125,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_SVE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -913,6 +914,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 0,
 		.matches = has_no_fpsimd,
 	},
+#ifdef CONFIG_ARM64_SVE
+	{
+		.desc = "Scalable Vector Extension",
+		.capability = ARM64_SVE,
+		.def_scope = SCOPE_SYSTEM,
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR0_SVE_SHIFT,
+		.min_field_value = ID_AA64PFR0_SVE,
+		.matches = has_cpuid_feature,
+	},
+#endif /* CONFIG_ARM64_SVE */
 	{},
 };
 
@@ -944,6 +957,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_JSCVT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
+#ifdef CONFIG_ARM64_SVE
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 0e087d7..943aad0 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -69,6 +69,7 @@ static const char *const hwcap_str[] = {
 	"jscvt",
 	"fcma",
 	"lrcpc",
+	"sve",
 	NULL
 };
 
-- 
2.1.4
