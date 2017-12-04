From: Steve Capper <steve.capper@arm.com>
Subject: [PATCH 02/12] arm64: KVM: Enforce injective kern_hyp_va mappings
Date: Mon,  4 Dec 2017 14:13:03 +0000
Message-ID: <20171204141313.31604-3-steve.capper@arm.com>
References: <20171204141313.31604-1-steve.capper@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D90440651
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:30 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HXn4RULuHCYk for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Dec 2017 09:10:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7CB9E49D32
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Dec 2017 09:10:27 -0500 (EST)
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

For systems that are not executing with VHE, we need to create page
tables for HYP/EL2 mode in order to access data from the kernel running
at EL1.

In addition to parts of the kernel address space being mapped to EL2, we
also need to make space for an identity mapping of the __hyp_idmap_text
area (as this code is responsible for activating the EL2 MMU).

In order to create these pagetables, we need a mechanism to map from the
address space pointed to by TTBR1_EL1 (addresses preceded by 0xFF...)
to the one addressed by TTBR0_EL2 (addresses preceded by 0x00...).

There are two ways of performing this mapping depending upon the
physical address of __hyp_idmap_text_start.

If PA[VA_BITS - 2] == 0b:
1) HYP_VA = KERN_VA & GENMASK(VA_BITS - 2, 0) - so we mask in the lower
bits of the kernel address. This is a bijective mapping.

If PA[VA_BITS - 2] == 1b:
2) HYP_VA = KERN_VA & GENMASK(VA_BITS - 3, 0) - so the top bit of our HYP
VA will always be zero. This mapping is no longer injective, each HYP VA
can be obtained from two different kernel VAs.

These mappings guarantee that kernel addresses in the direct linear
mapping will not give a HYP VA that collides with the identity mapping
for __hyp_idmap_text.

Unfortunately, with the second mapping we run the risk of hyp VAs
derived from kernel addresses in the direct linear map colliding with
those derived from kernel addresses from ioremap.

This patch addresses this issue by switching to the following logic:
If PA[VA_BITS - 2] == 0b:
3) HYP_VA = KERN_VA XOR GENMASK(63, VA_BITS - 1) - we toggle off the top
bits from the kernel address rather than and in the bottom bits.

If PA[VA_BITS - 2] == 1b:
4) HYP_VA = KERN_VA XOR GENMASK(63, VA_BITS - 2) - no longer maps to a
reduced address space, we have a bijective mapping.

Now there is no possibility of collision between HYP VAs obtained from
kernel addresses.

Note that the new mappings are no longer idempotent, so the following
code sequence will behave differently after this patch is applied:
	testva = kern_hyp_va(kern_hyp_va(sourceva));

Cc: James Morse <james.morse@arm.com>
Signed-off-by: Steve Capper <steve.capper@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/include/asm/kvm_mmu.h | 36 +++++++++++++++++-------------------
 arch/arm64/kernel/cpufeature.c   |  8 ++++----
 3 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2ff7c5e8efab..3de31a1010ee 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -32,7 +32,7 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
-#define ARM64_HYP_OFFSET_LOW			14
+#define ARM64_HYP_MAP_FLIP			14
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 672c8684d5c2..d74d5236c26c 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -69,8 +69,8 @@
  * mappings, and none of this applies in that case.
  */
 
-#define HYP_PAGE_OFFSET_HIGH_MASK	((UL(1) << VA_BITS) - 1)
-#define HYP_PAGE_OFFSET_LOW_MASK	((UL(1) << (VA_BITS - 1)) - 1)
+#define HYP_MAP_KERNEL_BITS	(UL(0xffffffffffffffff) << VA_BITS)
+#define HYP_MAP_HIGH_BIT	(UL(1) << (VA_BITS - 1))
 
 #ifdef __ASSEMBLY__
 
@@ -82,26 +82,24 @@
  * reg: VA to be converted.
  *
  * This generates the following sequences:
- * - High mask:
- *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
+ *
+ * - Flip the kernel bits:
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS
  *		nop
- * - Low mask:
- *		and x0, x0, #HYP_PAGE_OFFSET_HIGH_MASK
- *		and x0, x0, #HYP_PAGE_OFFSET_LOW_MASK
+ *
+ * - Flip the kernel bits and upper HYP bit:
+ *		eor x0, x0, #HYP_MAP_KERNEL_BITS
+ *		eor x0, x0, #HYP_MAP_HIGH_BIT
  * - VHE:
  *		nop
  *		nop
- *
- * The "low mask" version works because the mask is a strict subset of
- * the "high mask", hence performing the first mask for nothing.
- * Should be completely invisible on any viable CPU.
  */
 .macro kern_hyp_va	reg
 alternative_if_not ARM64_HAS_VIRT_HOST_EXTN
-	and     \reg, \reg, #HYP_PAGE_OFFSET_HIGH_MASK
+	eor     \reg, \reg, #HYP_MAP_KERNEL_BITS
 alternative_else_nop_endif
-alternative_if ARM64_HYP_OFFSET_LOW
-	and     \reg, \reg, #HYP_PAGE_OFFSET_LOW_MASK
+alternative_if ARM64_HYP_MAP_FLIP
+	eor     \reg, \reg, #HYP_MAP_HIGH_BIT
 alternative_else_nop_endif
 .endm
 
@@ -115,16 +113,16 @@ alternative_else_nop_endif
 
 static inline unsigned long __kern_hyp_va(unsigned long v)
 {
-	asm volatile(ALTERNATIVE("and %0, %0, %1",
+	asm volatile(ALTERNATIVE("eor %0, %0, %1",
 				 "nop",
 				 ARM64_HAS_VIRT_HOST_EXTN)
 		     : "+r" (v)
-		     : "i" (HYP_PAGE_OFFSET_HIGH_MASK));
+		     : "i" (HYP_MAP_KERNEL_BITS));
 	asm volatile(ALTERNATIVE("nop",
-				 "and %0, %0, %1",
-				 ARM64_HYP_OFFSET_LOW)
+				 "eor %0, %0, %1",
+				 ARM64_HYP_MAP_FLIP)
 		     : "+r" (v)
-		     : "i" (HYP_PAGE_OFFSET_LOW_MASK));
+		     : "i" (HYP_MAP_HIGH_BIT));
 	return v;
 }
 
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c5ba0097887f..5a6e1f3611eb 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,7 +824,7 @@ static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused
 	return is_kernel_in_hyp_mode();
 }
 
-static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
+static bool hyp_flip_space(const struct arm64_cpu_capabilities *entry,
 			   int __unused)
 {
 	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
@@ -926,10 +926,10 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
 	{
-		.desc = "Reduced HYP mapping offset",
-		.capability = ARM64_HYP_OFFSET_LOW,
+		.desc = "HYP mapping flipped",
+		.capability = ARM64_HYP_MAP_FLIP,
 		.def_scope = SCOPE_SYSTEM,
-		.matches = hyp_offset_low,
+		.matches = hyp_flip_space,
 	},
 	{
 		/* FP/SIMD is not implemented */
-- 
2.11.0
