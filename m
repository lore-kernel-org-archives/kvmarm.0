From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v9 1/7] arm64: cpufeature: Detect CPU RAS Extentions
Date: Sun, 7 Jan 2018 00:02:51 +0800
Message-ID: <1515254577-6460-2-git-send-email-gengdongjiu@huawei.com>
References: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6F7349DAB
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pw4ebZp0Jlg8 for <kvmarm@lists.cs.columbia.edu>;
 Sat,  6 Jan 2018 02:53:33 -0500 (EST)
Received: from huawei.com (szxga05-in.huawei.com [45.249.212.191])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94E1F49DAE
 for <kvmarm@lists.cs.columbia.edu>; Sat,  6 Jan 2018 02:53:33 -0500 (EST)
In-Reply-To: <1515254577-6460-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@linaro.org, marc.zyngier@arm.com, linux@armlinux.org.uk, catalin.marinas@arm.com, rjw@rjwysocki.net, bp@alien8.de, robert.moore@intel.com, lv.zheng@intel.com, james.morse@arm.com, corbet@lwn.net, will.deacon@arm.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-acpi@vger.kernel.org, devel@acpica.org
Cc: huangshaoyu@huawei.com, gengdongjiu@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

From: Xie XiuQi <xiexiuqi@huawei.com>

ARM's v8.2 Extentions add support for Reliability, Availability and
Serviceability (RAS). On CPUs with these extensions system software
can use additional barriers to isolate errors and determine if faults
are pending.

Add cpufeature detection and a barrier in the context-switch code.
There is no need to use alternatives for this as CPUs that don't
support this feature will treat the instruction as a nop.

Platform level RAS support may require additional firmware support.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
[Rebased added config option, reworded commit message]
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/Kconfig               | 16 ++++++++++++++++
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  2 ++
 arch/arm64/kernel/cpufeature.c   | 13 +++++++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0df64a6..cc00d10 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -973,6 +973,22 @@ config ARM64_PMEM
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
 
 config ARM64_MODULE_CMODEL_LARGE
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8da6216..4820d44 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -40,7 +40,8 @@
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
+#define ARM64_HAS_RAS_EXTN			22
 
-#define ARM64_NCAPS				22
+#define ARM64_NCAPS				23
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index f707fed..64e2a80 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -332,6 +332,7 @@
 #define ID_AA64ISAR1_DPB_SHIFT		0
 
 /* id_aa64pfr0 */
+#define ID_AA64PFR0_RAS_SHIFT		28
 #define ID_AA64PFR0_GIC_SHIFT		24
 #define ID_AA64PFR0_ASIMD_SHIFT		20
 #define ID_AA64PFR0_FP_SHIFT		16
@@ -340,6 +341,7 @@
 #define ID_AA64PFR0_EL1_SHIFT		4
 #define ID_AA64PFR0_EL0_SHIFT		0
 
+#define ID_AA64PFR0_RAS_V1		0x1
 #define ID_AA64PFR0_FP_NI		0xf
 #define ID_AA64PFR0_FP_SUPPORTED	0x0
 #define ID_AA64PFR0_ASIMD_NI		0xf
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 21e2c95..4846974 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -125,6 +125,7 @@ static int __init register_cpu_hwcaps_dumper(void)
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -900,6 +901,18 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 		.min_field_value = 1,
 	},
 #endif
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
1.9.1
