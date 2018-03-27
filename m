From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v2 10/17] kvm: arm64: Dynamic configuration of VTCR and VTTBR
 mask
Date: Tue, 27 Mar 2018 14:15:20 +0100
Message-ID: <1522156531-28348-11-git-send-email-suzuki.poulose@arm.com>
References: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 747A949F7F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:09:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yS-q+kQ8qY5b for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Mar 2018 09:08:45 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB1D049FBB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Mar 2018 09:08:22 -0400 (EDT)
In-Reply-To: <1522156531-28348-1-git-send-email-suzuki.poulose@arm.com>
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
Cc: ard.biesheuvel@linaro.org, kvm@vger.kernel.org, marc.zyngier@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

VTCR_EL2 holds the following key stage2 translation table
parameters:
 SL0  - Entry level in the page table lookup.
 T0SZ - Denotes the size of the memory addressed by the table.

We have been using fixed values for the SL0 depending on the
page size as we have a fixed IPA size. But since we are about
to make it dynamic, we need to calculate the SL0 at runtime
per VM.

Also the VTTBR:BADDR holds the base address for the stage2
translation table and the ARM ARM mandates that bits
BADDR[x-1:0] should be 0, where 'x' defined using some
magical constant, which depends on the page size, T0SZ
and the entry level of lookup (Since the entry level page
tables can be concatenated at stage2, a given T0SZ could
possibly start at 2 different levels). We need a way to
calculate this magical value per VM, depending on the
IPA size. Luckily there is a magic formula for finding
the "magic" number to find "x". See the patch for more
details.

This patch adds helpers to figure out the VTCR_SL0 and
the magic "X" for a configuration of stage2.

The other advantage we have with this change is switching
the entry level for a given IPA size, depending on if we
are able to get contiguous block of memory for the entry
level page table. (e.g, With 64KB page size and 46bit IPA
starting at level 2, finding 16 * 64KB contiguous block on a
loaded system could be tricky. So we could decide to rather
enter at level 1, with a single page).

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 96 +++++++++++++++++++++++++++++++++++++---
 arch/arm64/include/asm/kvm_mmu.h | 20 ++++++++-
 2 files changed, 110 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index b0c8417..176551c 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -124,6 +124,8 @@
 #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
 #define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
 
+#define VTCR_EL2_T0SZ(x)	TCR_T0SZ((x))
+
 /*
  * We configure the Stage-2 page tables to always restrict the IPA space to be
  * 40 bits wide (T0SZ = 24).  Systems with a PARange smaller than 40 bits are
@@ -150,7 +152,8 @@
  * 2 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		38
+#define VTCR_EL2_TGRAN_SL0_BASE		3UL
+
 #elif defined(CONFIG_ARM64_16K_PAGES)
 /*
  * Stage2 translation configuration:
@@ -158,7 +161,7 @@
  * 2 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		42
+#define VTCR_EL2_TGRAN_SL0_BASE		3UL
 #else	/* 4K */
 /*
  * Stage2 translation configuration:
@@ -166,13 +169,96 @@
  * 3 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		37
+#define VTCR_EL2_TGRAN_SL0_BASE		2UL
 #endif
 
 #define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
-#define VTTBR_X				(VTTBR_X_TGRAN_MAGIC - VTCR_EL2_T0SZ_IPA)
+/*
+ * VTCR_EL2:SL0 indicates the entry level for Stage2 translation.
+ * Interestingly, it depends on the page size.
+ * See D.10.2.110, VTCR_EL2, in ARM DDI 0487B.b
+ *
+ *	-----------------------------------------
+ *	| Entry level		|  4K  | 16K/64K |
+ *	------------------------------------------
+ *	| Level: 0		|  2   |   -     |
+ *	------------------------------------------
+ *	| Level: 1		|  1   |   2     |
+ *	------------------------------------------
+ *	| Level: 2		|  0   |   1     |
+ *	------------------------------------------
+ *	| Level: 3		|  -   |   0     |
+ *	------------------------------------------
+ *
+ * That table roughly translates to :
+ *
+ *	SL0(PAGE_SIZE, Entry_level) = SL0_BASE(PAGE_SIZE) - Entry_Level
+ *
+ * Where SL0_BASE(4K) = 2 and SL0_BASE(16K) = 3, SL0_BASE(64K) = 3, provided
+ * we take care of ruling out the unsupported cases and
+ * Entry_Level = 4 - Number_of_levels.
+ *
+ */
+#define VTCR_EL2_SL0(levels) \
+	((VTCR_EL2_TGRAN_SL0_BASE - (4 - (levels))) << VTCR_EL2_SL0_SHIFT)
+/*
+ * ARM VMSAv8-64 defines an algorithm for finding the translation table
+ * descriptors in section D4.2.8 in ARM DDI 0487B.b.
+ *
+ * The algorithm defines the expectaions on the BaseAddress (for the page
+ * table) bits resolved at each level based on the page size, entry level
+ * and T0SZ. The variable "x" in the algorithm also affects the VTTBR:BADDR
+ * for stage2 page table.
+ *
+ * The value of "x" is calculated as :
+ *	x = Magic_N - T0SZ
+ *
+ * where Magic_N is an integer depending on the page size and the entry
+ * level of the page table as below:
+ *
+ *	--------------------------------------------
+ *	| Entry level		|  4K    16K   64K |
+ *	--------------------------------------------
+ *	| Level: 0 (4 levels)	| 28   |  -  |  -  |
+ *	--------------------------------------------
+ *	| Level: 1 (3 levels)	| 37   | 31  | 25  |
+ *	--------------------------------------------
+ *	| Level: 2 (2 levels)	| 46   | 42  | 38  |
+ *	--------------------------------------------
+ *	| Level: 3 (1 level)	| -    | 53  | 51  |
+ *	--------------------------------------------
+ *
+ * We have a magic formula for the Magic_N below.
+ * Which can also be expressed as:
+ *
+ *  Magic_N(PAGE_SIZE, Entry_Level) = 64 - ((PAGE_SHIFT - 3) * Number of levels)
+ *
+ * where number of levels = (4 - Entry_Level).
+ *
+ * So, given that T0SZ = (64 - PA_SHIFT), we can compute 'x' as follows:
+ *
+ *	x = (64 - ((PAGE_SHIFT - 3) * Number_of_levels)) - (64 - PA_SHIFT)
+ *	  = PA_SHIFT - ((PAGE_SHIFT - 3) * Number of levels)
+ *
+ * Here is one way to explain the Magic Formula:
+ *
+ *  x = log2(Size_of_Entry_Level_Table)
+ *
+ * Since, we can resolve (PAGE_SHIFT - 3) bits at each level, and another
+ * PAGE_SHIFT bits in the PTE, we have :
+ *
+ *  Bits_Entry_level = PA_SHIFT - ((PAGE_SHIFT - 3) * (n - 1) + PAGE_SHIFT)
+ *		     = PA_SHIFT - (PAGE_SHIFT - 3) * n - 3
+ *  where n = number of levels, and since each pointer is 8bytes, we have:
+ *
+ *  x = Bits_Entry_Level + 3
+ *    = PA_SHIFT - (PAGE_SHIFT - 3) * n
+ *
+ * The only constraint here is that, we have to find the number of page table
+ * levels for a given IPA size (which we do, see STAGE2_PGTABLE_LEVELS).
+ */
+#define ARM64_VTTBR_X(ipa, levels)	((ipa) - ((levels) * (PAGE_SHIFT - 3)))
 
-#define VTTBR_BADDR_MASK  (((UL(1) << (PHYS_MASK_SHIFT - VTTBR_X)) - 1) << VTTBR_X)
 #define VTTBR_VMID_SHIFT  (UL(48))
 #define VTTBR_VMID_MASK(size) (_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index bc133ce..447bc10 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -139,7 +139,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 #define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
-#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
 
 static inline bool kvm_page_empty(void *ptr)
 {
@@ -393,5 +392,24 @@ static inline int kvm_map_vectors(void)
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
+/*
+ * Get the magic number 'x' for VTTBR:BADDR of this KVM instance.
+ * With v8.2 LVA extensions, 'x' (rather 'z') should be a minimum
+ * of 6 with 52bit IPS.
+ */
+static inline int kvm_vttbr_x(struct kvm *kvm)
+{
+	int x = ARM64_VTTBR_X(kvm_phys_shift(kvm), kvm_stage2_levels(kvm));
+
+	return (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && x < 6) ? 6 : x;
+}
+
+static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
+{
+	unsigned int x = kvm_vttbr_x(kvm);
+
+	return GENMASK_ULL(PHYS_MASK_SHIFT - 1, x);
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
-- 
2.7.4
