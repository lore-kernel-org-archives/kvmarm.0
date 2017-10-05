From: James Morse <james.morse@arm.com>
Subject: [PATCH v3 11/20] arm64: cpufeature: Detect CPU RAS Extentions
Date: Thu,  5 Oct 2017 20:18:03 +0100
Message-ID: <20171005191812.5678-12-james.morse@arm.com>
References: <20171005191812.5678-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5247949C23
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VAdaSfteGKFH for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Oct 2017 15:20:10 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EB97440BC5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Oct 2017 15:20:09 -0400 (EDT)
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

From: Xie XiuQi <xiexiuqi@huawei.com>

ARM's v8.2 Extensions add support for Reliability, Availability and
Serviceability (RAS). On CPUs with these extensions system software
can use additional barriers to isolate errors and determine if faults
are pending.

Add cpufeature detection and a barrier in the context-switch code.
There is no need to use alternatives for this as CPUs that don't
support this feature will treat the instruction as a nop.

Platform level RAS support may require additional firmware support.

Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
[Rebased, added esb and config option, reworded commit message]
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/Kconfig               | 16 ++++++++++++++++
 arch/arm64/include/asm/barrier.h |  1 +
 arch/arm64/include/asm/cpucaps.h |  3 ++-
 arch/arm64/include/asm/sysreg.h  |  2 ++
 arch/arm64/kernel/cpufeature.c   | 13 +++++++++++++
 arch/arm64/kernel/process.c      |  3 +++
 6 files changed, 37 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 70dfe4e9ccc5..b68f5e93baac 100644
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
diff --git a/arch/arm64/include/asm/barrier.h b/arch/arm64/include/asm/barrier.h
index 0fe7e43b7fbc..8b0a0eb67625 100644
--- a/arch/arm64/include/asm/barrier.h
+++ b/arch/arm64/include/asm/barrier.h
@@ -30,6 +30,7 @@
 #define isb()		asm volatile("isb" : : : "memory")
 #define dmb(opt)	asm volatile("dmb " #opt : : : "memory")
 #define dsb(opt)	asm volatile("dsb " #opt : : : "memory")
+#define esb()		asm volatile("hint #16"  : : : "memory")
 
 #define mb()		dsb(sy)
 #define rmb()		dsb(ld)
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 8da621627d7c..4820d441bfb9 100644
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
index f707fed5886f..64e2a80fd749 100644
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
index cd52d365d1f0..0fc017b55cb1 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -125,6 +125,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_RAS_SHIFT, 4, 0),
 	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_EXACT, ID_AA64PFR0_GIC_SHIFT, 4, 0),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_ASIMD_SHIFT, 4, ID_AA64PFR0_ASIMD_NI),
 	S_ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_FP_SHIFT, 4, ID_AA64PFR0_FP_NI),
@@ -900,6 +901,18 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
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
 
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2dc0f8482210..5e5d2f0a1d0a 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -365,6 +365,9 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
 	 */
 	dsb(ish);
 
+	/* Deliver any pending SError from prev */
+	esb();
+
 	/* the actual thread switch */
 	last = cpu_switch_to(prev, next);
 
-- 
2.13.3
