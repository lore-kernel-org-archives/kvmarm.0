From: James Morse <james.morse@arm.com>
Subject: [PATCH v5 03/13] arm64: cpufeature: Detect CPU RAS Extentions
Date: Fri, 15 Dec 2017 15:50:51 +0000
Message-ID: <20171215155101.23505-4-james.morse@arm.com>
References: <20171215155101.23505-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C338249D8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:49:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Ux9yzW1klmaI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 Dec 2017 10:49:51 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FFF6406D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 Dec 2017 10:49:51 -0500 (EST)
In-Reply-To: <20171215155101.23505-1-james.morse@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Dongjiu Geng <gengdongjiu@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Xie XiuQi <xiexiuqi@huawei.com>

ARM's v8.2 Extentions add support for Reliability, Availability and
Serviceability (RAS). On CPUs with these extensions system software
can use additional barriers to isolate errors and determine if faults
are pending. Add cpufeature detection.

Platform level RAS support may require additional firmware support.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
[Rebased added config option, reworded commit message]
Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
Changes since v4:
 * Removed barrier in context switch

 arch/arm64/Kconfig               | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  2 ++
 arch/arm64/kernel/cpufeature.c   | 13 +++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index a93339f5178f..f160e98b06bd 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1011,6 +1011,22 @@ config ARM64_PMEM
 	  operations if DC CVAP is not supported (following the behaviour of
 	  DC CVAP itself if the system does not define a point of persistence).
 
+config ARM64_RAS_EXTN
+	bool "Enable support for RAS CPU Extensions"
+	default y
+	help
+	  CPUs that support the Reliability, Availability and Serviceability
+	  (RAS) Extensions, part of ARMv8.2 are able to track faults and
+	  errors, classify them and report them to software.
+
+	  On CPUs with these extensions system software can use additional
+	  barriers to determine if faults are pending and read the
+	  classification from a new set of registers.
+
+	  Selecting this feature will allow the kernel to use these barriers
+	  and access the new registers if the system supports the extension.
+	  Platform RAS features may additionally depend on firmware support.
+
 endmenu
 
 config ARM64_SVE
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2ff7c5e8efab..ff9edaa07549 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -41,7 +41,8 @@
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
 #define ARM64_SVE				22
+#define ARM64_HAS_RAS_EXTN			23
 
-#define ARM64_NCAPS				23
+#define ARM64_NCAPS				24
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 5cdc139267b6..2eca9e2368d9 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -495,6 +495,7 @@
 
 /* id_aa64pfr0 */
 #define ID_AA64PFR0_SVE_SHIFT		32
+#define ID_AA64PFR0_RAS_SHIFT		28
 #define ID_AA64PFR0_GIC_SHIFT		24
 #define ID_AA64PFR0_ASIMD_SHIFT		20
 #define ID_AA64PFR0_FP_SHIFT		16
@@ -504,6 +505,7 @@
 #define ID_AA64PFR0_EL0_SHIFT		0
 
 #define ID_AA64PFR0_SVE			0x1
+#define ID_AA64PFR0_RAS_V1		0x1
 #define ID_AA64PFR0_FP_NI		0xf
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 68a49f7fb75c..cfc7588a380c 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -146,6 +146,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
 	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_SVE_SHIFT, 4, 0),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -962,6 +963,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.enable = sve_kernel_enable,
 	},
 #endif /* CONFIG_ARM64_SVE */
+#ifdef CONFIG_ARM64_RAS_EXTN
+	{
+		.desc = "RAS Extension Support",
+		.capability = ARM64_HAS_RAS_EXTN,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64PFR0_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64PFR0_RAS_SHIFT,
+		.min_field_value = ID_AA64PFR0_RAS_V1,
+	},
+#endif /* CONFIG_ARM64_RAS_EXTN */
 	{},
 };
 
-- 
2.15.0
