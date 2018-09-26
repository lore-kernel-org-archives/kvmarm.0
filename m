From: Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v6 11/18] kvm: arm64: Dynamic configuration of VTTBR mask
Date: Wed, 26 Sep 2018 17:32:47 +0100
Message-ID: <20180926163258.20218-12-suzuki.poulose@arm.com>
References: <20180926163258.20218-1-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180926163258.20218-1-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, suzuki.poulose@arm.com, will.deacon@arm.com, dave.martin@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, julien.grall@arm.com, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On arm64 VTTBR_EL2:BADDR holds the base address for the stage2
translation table. The Arm ARM mandates that the bits BADDR[x-1:0]
should be 0, where 'x' is defined for a given IPA Size and the
number of levels for a translation granule size. It is defined
using some magical constants. This patch is a reverse engineered
implementation to calculate the 'x' at runtime for a given ipa and
number of page table levels. See patch for more details.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <cdall@kernel.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v5:
 - Update comment about the Magic_N for VTTBR_X calculation
 - Remove the obsolete VTTBR_TGRAN_MAGIC value defintions
Changes since V3:
 - Update reference to latest ARM ARM and improve commentary
---
 arch/arm64/include/asm/kvm_arm.h | 73 ++++++++++++++++++++++++++++----
 arch/arm64/include/asm/kvm_mmu.h | 25 ++++++++++-
 2 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 14317b3a1820..b236d90ca056 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -123,7 +123,6 @@
 #define VTCR_EL2_SL0_MASK	(3 << VTCR_EL2_SL0_SHIFT)
 #define VTCR_EL2_SL0_LVL1	(1 << VTCR_EL2_SL0_SHIFT)
 #define VTCR_EL2_T0SZ_MASK	0x3f
-#define VTCR_EL2_T0SZ_40B	24
 #define VTCR_EL2_VS_SHIFT	19
 #define VTCR_EL2_VS_8BIT	(0 << VTCR_EL2_VS_SHIFT)
 #define VTCR_EL2_VS_16BIT	(1 << VTCR_EL2_VS_SHIFT)
@@ -140,11 +139,8 @@
  * Note that when using 4K pages, we concatenate two first level page tables
  * together. With 16K pages, we concatenate 16 first level page tables.
  *
- * The magic numbers used for VTTBR_X in this patch can be found in Tables
- * D4-23 and D4-25 in ARM DDI 0487A.b.
  */
 
-#define VTCR_EL2_T0SZ_IPA	VTCR_EL2_T0SZ_40B
 #define VTCR_EL2_COMMON_BITS	(VTCR_EL2_SH0_INNER | VTCR_EL2_ORGN0_WBWA | \
 				 VTCR_EL2_IRGN0_WBWA | VTCR_EL2_RES1)
 
@@ -155,7 +151,6 @@
  * 2 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_64K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		38
 #elif defined(CONFIG_ARM64_16K_PAGES)
 /*
  * Stage2 translation configuration:
@@ -163,7 +158,6 @@
  * 2 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_16K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		42
 #else	/* 4K */
 /*
  * Stage2 translation configuration:
@@ -171,13 +165,74 @@
  * 3 level page tables (SL = 1)
  */
 #define VTCR_EL2_TGRAN_FLAGS		(VTCR_EL2_TG0_4K | VTCR_EL2_SL0_LVL1)
-#define VTTBR_X_TGRAN_MAGIC		37
 #endif
 
 #define VTCR_EL2_FLAGS			(VTCR_EL2_COMMON_BITS | VTCR_EL2_TGRAN_FLAGS)
-#define VTTBR_X				(VTTBR_X_TGRAN_MAGIC - VTCR_EL2_T0SZ_IPA)
+/*
+ * ARM VMSAv8-64 defines an algorithm for finding the translation table
+ * descriptors in section D4.2.8 in ARM DDI 0487C.a.
+ *
+ * The algorithm defines the expectations on the translation table
+ * addresses for each level, based on PAGE_SIZE, entry level
+ * and the translation table size (T0SZ). The variable "x" in the
+ * algorithm determines the alignment of a table base address at a given
+ * level and thus determines the alignment of VTTBR:BADDR for stage2
+ * page table entry level.
+ * Since the number of bits resolved at the entry level could vary
+ * depending on the T0SZ, the value of "x" is defined based on a
+ * Magic constant for a given PAGE_SIZE and Entry Level. The
+ * intermediate levels must be always aligned to the PAGE_SIZE (i.e,
+ * x = PAGE_SHIFT).
+ *
+ * The value of "x" for entry level is calculated as :
+ *    x = Magic_N - T0SZ
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
+ * We have a magic formula for the Magic_N below:
+ *
+ *  Magic_N(PAGE_SIZE, Level) = 64 - ((PAGE_SHIFT - 3) * Number_of_levels)
+ *
+ * where Number_of_levels = (4 - Level). We are only interested in the
+ * value for Entry_Level for the stage2 page table.
+ *
+ * So, given that T0SZ = (64 - IPA_SHIFT), we can compute 'x' as follows:
+ *
+ *	x = (64 - ((PAGE_SHIFT - 3) * Number_of_levels)) - (64 - IPA_SHIFT)
+ *	  = IPA_SHIFT - ((PAGE_SHIFT - 3) * Number of levels)
+ *
+ * Here is one way to explain the Magic Formula:
+ *
+ *  x = log2(Size_of_Entry_Level_Table)
+ *
+ * Since, we can resolve (PAGE_SHIFT - 3) bits at each level, and another
+ * PAGE_SHIFT bits in the PTE, we have :
+ *
+ *  Bits_Entry_level = IPA_SHIFT - ((PAGE_SHIFT - 3) * (n - 1) + PAGE_SHIFT)
+ *		     = IPA_SHIFT - (PAGE_SHIFT - 3) * n - 3
+ *  where n = number of levels, and since each pointer is 8bytes, we have:
+ *
+ *  x = Bits_Entry_Level + 3
+ *    = IPA_SHIFT - (PAGE_SHIFT - 3) * n
+ *
+ * The only constraint here is that, we have to find the number of page table
+ * levels for a given IPA size (which we do, see stage2_pt_levels())
+ */
+#define ARM64_VTTBR_X(ipa, levels)	((ipa) - ((levels) * (PAGE_SHIFT - 3)))
 
-#define VTTBR_BADDR_MASK  (((UL(1) << (PHYS_MASK_SHIFT - VTTBR_X)) - 1) << VTTBR_X)
 #define VTTBR_VMID_SHIFT  (UL(48))
 #define VTTBR_VMID_MASK(size) (_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 7342d2c51773..ac3ca9690bad 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -145,7 +145,6 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
 #define kvm_phys_shift(kvm)		KVM_PHYS_SHIFT
 #define kvm_phys_size(kvm)		(_AC(1, ULL) << kvm_phys_shift(kvm))
 #define kvm_phys_mask(kvm)		(kvm_phys_size(kvm) - _AC(1, ULL))
-#define kvm_vttbr_baddr_mask(kvm)	VTTBR_BADDR_MASK
 
 static inline bool kvm_page_empty(void *ptr)
 {
@@ -520,5 +519,29 @@ static inline int hyp_map_aux_data(void)
 
 #define kvm_phys_to_vttbr(addr)		phys_to_ttbr(addr)
 
+/*
+ * Get the magic number 'x' for VTTBR:BADDR of this KVM instance.
+ * With v8.2 LVA extensions, 'x' should be a minimum of 6 with
+ * 52bit IPS.
+ */
+static inline int arm64_vttbr_x(u32 ipa_shift, u32 levels)
+{
+	int x = ARM64_VTTBR_X(ipa_shift, levels);
+
+	return (IS_ENABLED(CONFIG_ARM64_PA_BITS_52) && x < 6) ? 6 : x;
+}
+
+static inline u64 vttbr_baddr_mask(u32 ipa_shift, u32 levels)
+{
+	unsigned int x = arm64_vttbr_x(ipa_shift, levels);
+
+	return GENMASK_ULL(PHYS_MASK_SHIFT - 1, x);
+}
+
+static inline u64 kvm_vttbr_baddr_mask(struct kvm *kvm)
+{
+	return vttbr_baddr_mask(kvm_phys_shift(kvm), kvm_stage2_levels(kvm));
+}
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
-- 
2.19.0
