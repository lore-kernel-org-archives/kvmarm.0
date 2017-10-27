From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v4 25/28] arm64/sve: Detect SVE and activate runtime support
Date: Fri, 27 Oct 2017 11:51:07 +0100
Message-ID: <1509101470-7881-26-git-send-email-Dave.Martin@arm.com>
References: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509101470-7881-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
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
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>

---

**Dropped** Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
The entry.S changes need reviewing; however the rest of the cpufeatures
support (reviewed by Suzuki) has not changed and shouldn't need re-
review.

Changes since v3
----------------

Changes requested by Catalin Marinas / Will Deacon:

 * ABI change: Zero SVE regs on syscall entry:

   Move to asm alternatives for skipping SVE discard at syscall entry,
   now that we have a suitable cpucap defined.

Miscellaneous:

 * Add HWCAP_SVE description to elf_hwcaps.txt
---
 Documentation/arm64/cpu-feature-registers.txt |  6 +++++-
 Documentation/arm64/elf_hwcaps.txt            |  4 ++++
 arch/arm64/include/asm/cpucaps.h              |  3 ++-
 arch/arm64/include/asm/cpufeature.h           |  3 ++-
 arch/arm64/include/uapi/asm/hwcap.h           |  1 +
 arch/arm64/kernel/cpufeature.c                | 17 +++++++++++++++++
 arch/arm64/kernel/cpuinfo.c                   |  1 +
 arch/arm64/kernel/entry.S                     |  7 ++++---
 8 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/Documentation/arm64/cpu-feature-registers.txt b/Documentation/arm64/cpu-feature-registers.txt
index 011ddfc..bd9b3fa 100644
--- a/Documentation/arm64/cpu-feature-registers.txt
+++ b/Documentation/arm64/cpu-feature-registers.txt
@@ -142,7 +142,11 @@ infrastructure:
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
diff --git a/Documentation/arm64/elf_hwcaps.txt b/Documentation/arm64/elf_hwcaps.txt
index 0ba1805..89edba1 100644
--- a/Documentation/arm64/elf_hwcaps.txt
+++ b/Documentation/arm64/elf_hwcaps.txt
@@ -154,3 +154,7 @@ HWCAP_ASIMDDP
 HWCAP_SHA512
 
     Functionality implied by ID_AA64ISAR0_EL1.SHA2 == 0b0002.
+
+HWCAP_SVE
+
+    Functionality implied by ID_AA64PFR0_EL1.SVE == 0b0001.
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
index 9b27e8c..ac67cfc 100644
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
index a4bad90..6229410 100644
--- a/arch/arm64/include/uapi/asm/hwcap.h
+++ b/arch/arm64/include/uapi/asm/hwcap.h
@@ -41,5 +41,6 @@
 #define HWCAP_SM4		(1 << 19)
 #define HWCAP_ASIMDDP		(1 << 20)
 #define HWCAP_SHA512		(1 << 21)
+#define HWCAP_SVE		(1 << 22)
 
 #endif /* _UAPI__ASM_HWCAP_H */
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 2154373..c5ba009 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -145,6 +145,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_SVE_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -948,6 +949,19 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
 
@@ -985,6 +999,9 @@ static const struct arm64_cpu_capabilities arm64_elf_hwcaps[] = {
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_JSCVT_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_JSCVT),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_FCMA_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_FCMA),
 	HWCAP_CAP(SYS_ID_AA64ISAR1_EL1, ID_AA64ISAR1_LRCPC_SHIFT, FTR_UNSIGNED, 1, CAP_HWCAP, HWCAP_LRCPC),
+#ifdef CONFIG_ARM64_SVE
+	HWCAP_CAP(SYS_ID_AA64PFR0_EL1, ID_AA64PFR0_SVE_SHIFT, FTR_UNSIGNED, ID_AA64PFR0_SVE, CAP_HWCAP, HWCAP_SVE),
+#endif
 	{},
 };
 
diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
index 58da504..1e25545 100644
--- a/arch/arm64/kernel/cpuinfo.c
+++ b/arch/arm64/kernel/cpuinfo.c
@@ -75,6 +75,7 @@ static const char *const hwcap_str[] = {
 	"sm4",
 	"asimddp",
 	"sha512",
+	"sve",
 	NULL
 };
 
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 56e848f..67522ac 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -853,9 +853,10 @@ el0_svc:
 	mov	wscno, w8			// syscall number in w8
 	mov	wsc_nr, #__NR_syscalls
 
-#ifndef CONFIG_ARM64_SVE
+#ifdef CONFIG_ARM64_SVE
+alternative_if_not ARM64_SVE
 	b	el0_svc_naked
-#else
+alternative_else_nop_endif
 	tbz	x16, #TIF_SVE, el0_svc_naked	// Skip unless TIF_SVE set:
 	bic	x16, x16, #_TIF_SVE		// discard SVE state
 	str	x16, [tsk, #TSK_TI_FLAGS]
@@ -870,7 +871,7 @@ el0_svc:
 	mrs	x9, cpacr_el1
 	bic	x9, x9, #CPACR_EL1_ZEN_EL0EN	// disable SVE for el0
 	msr	cpacr_el1, x9			// synchronised by eret to el0
-#endif /* CONFIG_ARM64_SVE */
+#endif
 
 el0_svc_naked:					// compat entry point
 	stp	x0, xscno, [sp, #S_ORIG_X0]	// save the original x0 and syscall number
-- 
2.1.4
