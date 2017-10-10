From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v3 25/28] arm64/sve: Detect SVE and activate runtime support
Date: Tue, 10 Oct 2017 19:38:42 +0100
Message-ID: <1507660725-7986-26-git-send-email-Dave.Martin@arm.com>
References: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1507660725-7986-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Richard Sandiford <richard.sandiford@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org, Suzuki K Poulose <suzuki.poulose@arm.com>
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
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>

---

Dropped Suzuki's Reviewed-by, since there are non-trivial changes.

Changes since v2
----------------

Requested by Catalin Marinas:

 * Moved the EL1 SVE trap disable logic to cpufeatures.
   This requires the trap to be disabled when the ARM64_SVE cpu
   capability is detected on any booting cpu.
---
 Documentation/arm64/cpu-feature-registers.txt |  6 +++++-
 arch/arm64/include/asm/cpucaps.h              |  3 ++-
 arch/arm64/include/asm/cpufeature.h           |  3 ++-
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 17 +++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 6 files changed, 28 insertions(+), 3 deletions(-)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index dad411d..d65504c 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -132,7 +132,11 @@ infrastructure:
      x--------------------------------------------------x
      | Name                         |  bits   | visible |
      |--------------------------------------------------|
-     | RES0                         | [63-28] |    n    |
+     | RES0                         | [63-36] |    n    |
+     |--------------------------------------------------|
+     | SVE                          | [35-32] |    y    |
+     |--------------------------------------------------|
+     | RES0                         | [31-28] |    n    |
      |--------------------------------------------------|
      | GIC                          | [27-24] |    n    |
      |--------------------------------------------------|
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8da6216..2ff7c5e 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -40,7 +40,8 @@
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
+#define ARM64_SVE				22
 
-#define ARM64_NCAPS				22
+#define ARM64_NCAPS				23
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 51be8e8..9ac1418 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -273,7 +273,8 @@ static inline bool system_uses_ttbr0_pan(void)
 
 static inline bool system_supports_sve(void)
 {
-	return false;
+	return IS_ENABLED(CONFIG_ARM64_SVE) &&
+		cpus_have_const_cap(ARM64_SVE);
 }
 
 /*
diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
index 4b9344c..c6e1e45 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -36,5 +36,6 @@
 #define HWCAP_FCMA		(1 << 14)
 #define HWCAP_LRCPC		(1 << 15)
 #define HWCAP_DCPOP		(1 << 16)
+#define HWCAP_SVE		(1 << 17)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c5acf38..06aa958 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -141,6 +141,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_SVE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -942,6 +943,19 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = 1,
 	},
 #endif
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
+		.enable = sve_kernel_enable,
+	},
+#endif /* CONFIG_ARM64_SVE */
 	{},
 };
 
@@ -974,6 +988,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_JSCVT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
+#ifdef CONFIG_ARM64_SVE
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index be260e8..9559dde 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -70,6 +70,7 @@ static const char *const hwcap_str[] = {
 	"fcma",
 	"lrcpc",
 	"dcpop",
+	"sve",
 	NULL
 };
 
-- 
2.1.4
