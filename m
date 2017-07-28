From: James Morse <james.morse@arm.com>
Subject: [PATCH v2 13/16] arm64: cpufeature: Enable Implicit ESB on
 entry/return-from EL1
Date: Fri, 28 Jul 2017 15:10:16 +0100
Message-ID: <20170728141019.9084-14-james.morse@arm.com>
References: <20170728141019.9084-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C81D540D1D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZFwoBsyNnUYZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Jul 2017 10:11:01 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC55D49C24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Jul 2017 10:11:01 -0400 (EDT)
In-Reply-To: <20170728141019.9084-1-james.morse@arm.com>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Wang Xiongfeng <wangxiongfeng2@huawei.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ARM v8.2 adds a feature to add implicit error synchronization barriers
whenever the CPU enters or returns from EL1. Add code to detect this
feature and enable the SCTLR_EL1.IESB bit.

The explicit ESBs on entry/return-from EL1 are replaced with nops
by this feature.

Platform level RAS support may require additional firmware support.

Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig                 | 15 +++++++++++++++
 arch/arm64/include/asm/cpucaps.h   |  3 ++-
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  1 +
 arch/arm64/kernel/cpufeature.c     | 21 +++++++++++++++++++++
 arch/arm64/kernel/entry.S          |  4 ++++
 6 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 6e417e25672f..f6367cc2e180 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -976,6 +976,21 @@ config ARM64_RAS_EXTN
 	  and access the new registers if the system supports the extension.
 	  Platform RAS features may additionally depend on firmware support.
 
+config ARM64_IESB
+	bool "Enable Implicit Error Synchronization Barrier (IESB)"
+	default y
+	depends on ARM64_RAS_EXTN
+	help
+	  ARM v8.2 adds a feature to add implicit error synchronization
+	  barriers whenever the CPU enters or exits a particular exception
+	  level.
+
+	  On CPUs with this feature and the 'RAS Extensions' feature, we can
+	  use this to contain detected (but not yet reported) errors to the
+	  relevant exception level.
+
+	  The feature is detected at runtime, selecting this option will
+	  enable these implicit barriers if the CPU supports the feature.
 endmenu
 
 config ARM64_MODULE_CMODEL_LARGE
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index f93bf77f1f74..716545c96714 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -40,7 +40,8 @@
 #define ARM64_WORKAROUND_858921			19
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_RAS_EXTN			21
+#define ARM64_HAS_IESB				22
 
-#define ARM64_NCAPS				22
+#define ARM64_NCAPS				23
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 82e8ff01153d..fe353f5a4a7b 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -194,5 +194,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
 int cpu_clear_disr(void *__unused);
+int cpu_enable_iesb(void *__unused);
 
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 18cabd92af22..e817e802f0b9 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -314,6 +314,7 @@
 /* SCTLR_EL1 specific flags. */
 #define SCTLR_EL1_UCI		(1 << 26)
 #define SCTLR_EL1_SPAN		(1 << 23)
+#define SCTLR_EL1_IESB		(1 << 21)
 #define SCTLR_EL1_UCT		(1 << 15)
 #define SCTLR_EL1_SED		(1 << 8)
 #define SCTLR_EL1_CP15BEN	(1 << 5)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 6dbefe401dc4..12cb1b7ef46b 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -901,6 +901,19 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64PFR0_RAS_V1,
 		.enable = cpu_clear_disr,
 	},
+#ifdef CONFIG_ARM64_IESB
+	{
+		.desc = "Implicit Error Synchronization Barrier",
+		.capability = ARM64_HAS_IESB,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = has_cpuid_feature,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_IESB_SHIFT,
+		.min_field_value = 1,
+		.enable = cpu_enable_iesb,
+	},
+#endif /* CONFIG_ARM64_IESB */
 #endif /* CONFIG_ARM64_RAS_EXTN */
 	{},
 };
@@ -1317,3 +1330,11 @@ int cpu_clear_disr(void *__unused)
 
 	return 0;
 }
+
+int cpu_enable_iesb(void *__unused)
+{
+	if (cpus_have_cap(ARM64_HAS_RAS_EXTN))
+		config_sctlr_el1(0, SCTLR_EL1_IESB);
+
+	return 0;
+}
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 173b86fac066..0e9b056385c2 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -160,7 +160,9 @@ alternative_else_nop_endif
 	msr	sp_el0, tsk
 	.endif
 
+	alternative_if_not ARM64_HAS_IESB
 	esb
+	alternative_else_nop_endif
 	disr_read reg=x15
 
 	/*
@@ -442,7 +444,9 @@ ENDPROC(el1_error_invalid)
 ENTRY(do_kernel_exit)
 __do_kernel_exit_start:
 	enable_serror
+	alternative_if_not ARM64_HAS_IESB
 	esb
+	alternative_else_nop_endif
 
 	eret
 __do_kernel_exit_end:
-- 
2.13.2
