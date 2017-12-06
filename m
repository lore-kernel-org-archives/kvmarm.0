From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 09/18] arm64: cpufeatures: Drop the ARM64_HYP_OFFSET_LOW feature flag
Date: Wed,  6 Dec 2017 14:38:30 +0000
Message-ID: <20171206143839.29223-10-marc.zyngier@arm.com>
References: <20171206143839.29223-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20171206143839.29223-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, James Morse <james.morse@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Now that we can dynamically compute the kernek/hyp VA mask, there
is need for a feature flag to trigger the alternative patching.
Let's drop the flag and everything that depends on it.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/include/asm/cpucaps.h |  2 +-
 arch/arm64/kernel/cpufeature.c   | 19 -------------------
 2 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 2ff7c5e8efab..f130f35dca3c 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -32,7 +32,7 @@
 #define ARM64_HAS_VIRT_HOST_EXTN		11
 #define ARM64_WORKAROUND_CAVIUM_27456		12
 #define ARM64_HAS_32BIT_EL0			13
-#define ARM64_HYP_OFFSET_LOW			14
+/* #define ARM64_UNALLOCATED_ENTRY			14 */
 #define ARM64_MISMATCHED_CACHE_LINE_SIZE	15
 #define ARM64_HAS_NO_FPSIMD			16
 #define ARM64_WORKAROUND_REPEAT_TLBI		17
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index c5ba0097887f..9eabceaaf5fb 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -824,19 +824,6 @@ static bool runs_at_el2(const struct arm64_cpu_capabilities *entry, int __unused
 	return is_kernel_in_hyp_mode();
 }
 
-static bool hyp_offset_low(const struct arm64_cpu_capabilities *entry,
-			   int __unused)
-{
-	phys_addr_t idmap_addr = __pa_symbol(__hyp_idmap_text_start);
-
-	/*
-	 * Activate the lower HYP offset only if:
-	 * - the idmap doesn't clash with it,
-	 * - the kernel is not running at EL2.
-	 */
-	return idmap_addr > GENMASK(VA_BITS - 2, 0) && !is_kernel_in_hyp_mode();
-}
-
 static bool has_no_fpsimd(const struct arm64_cpu_capabilities *entry, int __unused)
 {
 	u64 pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
@@ -925,12 +912,6 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64PFR0_EL0_SHIFT,
 		.min_field_value = ID_AA64PFR0_EL0_32BIT_64BIT,
 	},
-	{
-		.desc = "Reduced HYP mapping offset",
-		.capability = ARM64_HYP_OFFSET_LOW,
-		.def_scope = SCOPE_SYSTEM,
-		.matches = hyp_offset_low,
-	},
 	{
 		/* FP/SIMD is not implemented */
 		.capability = ARM64_HAS_NO_FPSIMD,
-- 
2.14.2
