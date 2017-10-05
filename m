From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 13/20] arm64: cpufeature: Enable IESB on exception
 entry/return for firmware-first
Date: Thu,  5 Oct 2017 20:18:05 +0100
Message-ID: <20171005191812.5678-14-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2B2A549D2F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QCZ4vMIZ5dli for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:15 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C1A49D12
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:14 -0400 (EDT)
In-Reply-To: <20171005191812.5678-1-james.morse@arm.com>
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
Cc: Jonathan.Zhang@cavium.com, Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ARM v8.2 has a feature to add implicit error synchronization barriers
whenever the CPU enters or returns from an exception level. Add code to
detect this feature and enable the SCTLR_ELx.IESB bit.

This feature causes RAS errors that are not yet visible to software to
become pending SErrors. We expect to have firmware-first RAS support
so synchronised RAS errors will be take immediately to EL3.
Any system without firmware-first handling of errors will take the SError
either immediately after exception return, or when we unmask SError after
entry.S's work.

Platform level RAS support may require additional firmware support.

Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>

---
Note the sneaky KVM change,

 arch/arm64/Kconfig                 | 15 +++++++++++++++
 arch/arm64/include/asm/cpucaps.h   |  3 ++-
 arch/arm64/include/asm/processor.h |  1 +
 arch/arm64/include/asm/sysreg.h    |  1 +
 arch/arm64/kernel/cpufeature.c     | 21 +++++++++++++++++++++
 arch/arm64/kvm/hyp-init.S          |  3 +++
 6 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b68f5e93baac..29df2a93688c 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -989,6 +989,21 @@ config ARM64_RAS_EXTN
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
index 4820d441bfb9..7a2bbbfdff49 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -41,7 +41,8 @@
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
 #define ARM64_HAS_RAS_EXTN			22
+#define ARM64_HAS_IESB				23
 
-#define ARM64_NCAPS				23
+#define ARM64_NCAPS				24
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/processor.h b/arch/arm64/include/asm/processor.h
index 29adab8138c3..6b72ddc33d06 100644
--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -193,5 +193,6 @@ static inline void spin_lock_prefetch(const void *ptr)
 
 int cpu_enable_pan(void *__unused);
 int cpu_enable_cache_maint_trap(void *__unused);
+int cpu_enable_iesb(void *__unused);
 
 #endif /* __ASM_PROCESSOR_H */
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 64e2a80fd749..4500a70c6a57 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -297,6 +297,7 @@
 
 /* Common SCTLR_ELx flags. */
 #define SCTLR_ELx_EE    (1 << 25)
+#define SCTLR_ELx_IESB	(1 << 21)
 #define SCTLR_ELx_I	(1 << 12)
 #define SCTLR_ELx_SA	(1 << 3)
 #define SCTLR_ELx_C	(1 << 2)
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 0fc017b55cb1..626539995316 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -912,6 +912,19 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_RAS_SHIFT,
 		.min_field_value = ID_AA64PFR0_RAS_V1,
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
@@ -1321,3 +1334,11 @@ static int __init enable_mrs_emulation(void)
 }
 
 late_initcall(enable_mrs_emulation);
+
+int cpu_enable_iesb(void *__unused)
+{
+	if (cpus_have_cap(ARM64_HAS_RAS_EXTN))
+		config_sctlr_el1(0, SCTLR_ELx_IESB);
+
+	return 0;
+}
diff --git a/arch/arm64/kvm/hyp-init.S b/arch/arm64/kvm/hyp-init.S
index 3f9615582377..8983e9473017 100644
--- a/arch/arm64/kvm/hyp-init.S
+++ b/arch/arm64/kvm/hyp-init.S
@@ -113,6 +113,9 @@ __do_hyp_init:
 	 */
 	ldr	x4, =(SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
 CPU_BE(	orr	x4, x4, #SCTLR_ELx_EE)
+alternative_if ARM64_HAS_IESB
+	orr	x4, x4, #SCTLR_ELx_IESB
+alternative_else_nop_endif
 	msr	sctlr_el2, x4
 	isb
 
-- 
2.13.3
