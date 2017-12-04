From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 11/12] arm64: KVM: Add support for an alternative VA space
Date: Mon,  4 Dec 2017 14:13:12 +0000
Message-ID: <20171204141313.31604-12-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 78AD549D8C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:52 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tumOTmM6hcb7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:51 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 76E5249D61
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:41 -0500 (EST)
In-Reply-To: <20171204141313.31604-1-steve.capper@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: catalin.marinas@arm.com, ard.biesheuvel@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

This patch adjusts the alternative patching logic for kern_hyp_va to
take into account a change in virtual address space size on boot.

Because the instructions in the alternatives regions have to be fixed at
compile time, in order to make the logic depend on a dynamic VA size
the predicates have to be adjusted.

The predicates used, follow the corresponding logic:
 - ARM64_HAS_VIRT_HOST_EXTN, true if running with VHE
 - ARM64_HYP_MAP_FLIP, true if !VHE and idmap is high and VA size is small.
 - ARM64_HYP_RUNNING_ALT_VA, true if !VHE and VA size is big.
 - ARM64_HYP_MAP_FLIP_ALT, true if !VHE and idmap is high and VA size is big.

Using the above predicates means we have to add two instructions to
kern_hyp_va.

Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/Kconfig               |  4 ++++
 arch/arm64/include/asm/cpucaps.h |  4 +++-
 arch/arm64/include/asm/kvm_mmu.h | 47 ++++++++++++++++++++++++++++++++++++++++
 arch/arm64/kernel/cpufeature.c   | 39 ++++++++++++++++++++++++++++++++-
 4 files changed, 92 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0fa430326825..143c453b06f1 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -656,6 +656,10 @@ config ARM64_VA_BITS
 	default 47 if ARM64_VA_BITS_47
 	default 48 if ARM64_VA_BITS_48
 
+config ARM64_VA_BITS_ALT
+	bool
+	default n
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 3de31a1010ee..955936adcf7a 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -41,7 +41,9 @@
 #define ARM64_WORKAROUND_CAVIUM_30115		20
 #define ARM64_HAS_DCPOP				21
 #define ARM64_SVE				22
+#define ARM64_HYP_RUNNING_ALT_VA		23
+#define ARM64_HYP_MAP_FLIP_ALT			24
 
-#define ARM64_NCAPS				23
+#define ARM64_NCAPS				25
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 5174fd7e5196..8de396764a11 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -73,6 +73,11 @@
 #define _HYP_MAP_HIGH_BIT(va)		(UL(1) << ((va) - 1))
 #define HYP_MAP_KERNEL_BITS	_HYP_MAP_KERNEL_BITS(VA_BITS_MIN)
 #define HYP_MAP_HIGH_BIT	_HYP_MAP_HIGH_BIT(VA_BITS_MIN)
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+#define HYP_MAP_KERNEL_BITS_ALT	(_HYP_MAP_KERNEL_BITS(VA_BITS_ALT) \
+				 ^ _HYP_MAP_KERNEL_BITS(VA_BITS_MIN))
+#define HYP_MAP_HIGH_BIT_ALT	_HYP_MAP_HIGH_BIT(VA_BITS_ALT)
+#endif
 
 #ifdef __ASSEMBLY__
 
@@ -95,6 +100,27 @@
  * - VHE:
  *		nop
  *		nop
+ *
+ * For cases where we are running with a variable address space size,
+ * two extra instructions are added, and the logic changes thusly:
+ *
+ * - Flip the kernel bits for the new VA:
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS
+ *		nop
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS_ALT
+ *		eor
+ *
+ * - Flip the kernel bits and upper HYP bit for new VA:
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS
+ *		nop
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS_ALT
+ *		eor x0, x0, #HYP_MAP_HIGH_BIT_ALT
+ *
+ * - VHE:
+ *		nop
+ *		nop
+ *		nop
+ *		nop
  */
 .macro kern_hyp_va	reg
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
@@ -103,6 +129,14 @@ alternative_else_nop_endif
 alternative_if ARM64_HYP_MAP_FLIP
 	eor     \reg, \reg, #HYP_MAP_HIGH_BIT
 alternative_else_nop_endif
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+alternative_if ARM64_HYP_RUNNING_ALT_VA
+	eor	\reg, \reg, #HYP_MAP_KERNEL_BITS_ALT
+alternative_else_nop_endif
+alternative_if ARM64_HYP_MAP_FLIP_ALT
+	eor     \reg, \reg, #HYP_MAP_HIGH_BIT_ALT
+alternative_else_nop_endif
+#endif
 .endm
 
 #else
@@ -125,6 +159,19 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 				 ARM64_HYP_MAP_FLIP)
 		     : "+r" (v)
 		     : "i" (HYP_MAP_HIGH_BIT));
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+	asm volatile(ALTERNATIVE("nop",
+				 "eor %0, %0, %1",
+				 ARM64_HYP_RUNNING_ALT_VA)
+		     : "+r" (v)
+		     : "i" (HYP_MAP_KERNEL_BITS_ALT));
+	asm volatile(ALTERNATIVE("nop",
+				 "eor %0, %0, %1",
+				 ARM64_HYP_MAP_FLIP_ALT)
+		     : "+r" (v)
+		     : "i" (HYP_MAP_HIGH_BIT_ALT));
+#endif
+
 	return v;
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 31cfffa79fee..cd4bcd2d0942 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -834,7 +834,8 @@ static bool hyp_flip_space(const struct arm64_cpu_capabilities *entry,
 	 * - the idmap doesn't clash with it,
 	 * - the kernel is not running at EL2.
 	 */
-	return idmap_addr <= GENMASK(VA_BITS_MIN - 2, 0) && !is_kernel_in_hyp_mode();
+	return (VA_BITS == VA_BITS_MIN) &&
+		idmap_addr <= GENMASK(VA_BITS_MIN - 2, 0) && !is_kernel_in_hyp_mode();
 }
 
 static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
@@ -845,6 +846,28 @@ static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unus
 					ID_AA64PFR0_FP_SHIFT) < 0;
 }
 
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+static bool hyp_using_large_va(const struct arm64_cpu_capabilities *entry,
+				int __unused)
+{
+	return (VA_BITS > VA_BITS_MIN) && !is_kernel_in_hyp_mode();
+}
+
+static bool hyp_flip_space_alt(const struct arm64_cpu_capabilities *entry,
+			   int __unused)
+{
+	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
+
+	/*
+	 * Activate the lower HYP offset only if:
+	 * - the idmap doesn't clash with it,
+	 * - the kernel is not running at EL2.
+	 */
+	return (VA_BITS > VA_BITS_MIN) &&
+		idmap_addr <= GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
+}
+#endif
+
 static const struct arm64_cpu_capabilities arm64_features[] = {
 	{
 		.desc = "GIC system register CPU interface",
@@ -931,6 +954,20 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.def_scope = SCOPE_SYSTEM,
 		.matches = hyp_flip_space,
 	},
+#ifdef CONFIG_ARM64_VA_BITS_ALT
+	{
+		.desc = "HYP mapping using larger VA space",
+		.capability = ARM64_HYP_RUNNING_ALT_VA,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = hyp_using_large_va,
+	},
+	{
+		.desc = "HYP mapping using flipped, larger VA space",
+		.capability = ARM64_HYP_MAP_FLIP_ALT,
+		.def_scope = SCOPE_SYSTEM,
+		.matches = hyp_flip_space_alt,
+	},
+#endif
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-- 
2.11.0
