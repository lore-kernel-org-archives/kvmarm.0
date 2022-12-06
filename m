Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8989C4708E
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 626C84B3E8;
	Tue,  6 Dec 2022 09:00:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gk08rxZ+Xs57; Tue,  6 Dec 2022 09:00:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B144B5E8;
	Tue,  6 Dec 2022 09:00:28 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D5FC4B355
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MVQBqN57MzR1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E7B584B637
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:19 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3869223A;
 Tue,  6 Dec 2022 06:00:26 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D411C3F73D;
 Tue,  6 Dec 2022 06:00:17 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 09/12] KVM: arm64: Convert translation level parameter to s8
Date: Tue,  6 Dec 2022 13:59:27 +0000
Message-Id: <20221206135930.3277585-10-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

With the introduction of FEAT_LPA2, the Arm ARM adds a new level of
translation, level -1, so levels can now be in the range [-1;3]. 3 is
always the last level and the first level is determined based on the
number of VA bits in use.

Convert level variables to use a signed type in preparation for
supporting this new level -1.

Since the last level is always anchored at 3, and the first level varies
to suit the number of VA/IPA bits, take the opportunity to replace
KVM_PGTABLE_MAX_LEVELS with the 2 macros KVM_PGTABLE_FIRST_LEVEL and
KVM_PGTABLE_LAST_LEVEL. This removes the assumption from the code that
levels run from 0 to KVM_PGTABLE_MAX_LEVELS - 1, which will soon no
longer be true.

No behavioral changes intended.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_emulate.h  |  2 +-
 arch/arm64/include/asm/kvm_pgtable.h  | 21 +++---
 arch/arm64/include/asm/kvm_pkvm.h     |  5 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |  4 +-
 arch/arm64/kvm/hyp/pgtable.c          | 94 ++++++++++++++-------------
 arch/arm64/kvm/mmu.c                  | 11 ++--
 7 files changed, 75 insertions(+), 68 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 9bdba47f7e14..270f49e7f29a 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -341,7 +341,7 @@ static __always_inline u8 kvm_vcpu_trap_get_fault_type(const struct kvm_vcpu *vc
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_TYPE;
 }
 
-static __always_inline u8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
+static __always_inline s8 kvm_vcpu_trap_get_fault_level(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_get_esr(vcpu) & ESR_ELx_FSC_LEVEL;
 }
diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d6f4dcdd00fd..a282a3d5ddbc 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -11,7 +11,8 @@
 #include <linux/kvm_host.h>
 #include <linux/types.h>
 
-#define KVM_PGTABLE_MAX_LEVELS		4U
+#define KVM_PGTABLE_FIRST_LEVEL		0
+#define KVM_PGTABLE_LAST_LEVEL		3
 
 /*
  * The largest supported block sizes for KVM (no 52-bit PA support):
@@ -20,9 +21,9 @@
  *  - 64K (level 2):	512MB
  */
 #ifdef CONFIG_ARM64_4K_PAGES
-#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1U
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	1
 #else
-#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
+#define KVM_PGTABLE_MIN_BLOCK_LEVEL	2
 #endif
 
 static inline bool kvm_supports_hyp_lpa2(void)
@@ -84,18 +85,18 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
 	return pte & KVM_PTE_VALID;
 }
 
-static inline u64 kvm_granule_shift(u32 level)
+static inline u64 kvm_granule_shift(s8 level)
 {
-	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
+	/* Assumes KVM_PGTABLE_LAST_LEVEL is 3 */
 	return ARM64_HW_PGTABLE_LEVEL_SHIFT(level);
 }
 
-static inline u64 kvm_granule_size(u32 level)
+static inline u64 kvm_granule_size(s8 level)
 {
 	return BIT(kvm_granule_shift(level));
 }
 
-static inline bool kvm_level_supports_block_mapping(u32 level)
+static inline bool kvm_level_supports_block_mapping(s8 level)
 {
 	return level >= KVM_PGTABLE_MIN_BLOCK_LEVEL;
 }
@@ -202,7 +203,7 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  */
 struct kvm_pgtable {
 	u32					ia_bits;
-	u32					start_level;
+	s8					start_level;
 	kvm_pte_t				*pgd;
 	struct kvm_pgtable_mm_ops		*mm_ops;
 	bool					lpa2_ena;
@@ -245,7 +246,7 @@ enum kvm_pgtable_walk_flags {
 };
 
 typedef int (*kvm_pgtable_visitor_fn_t)(struct kvm_pgtable *pgt,
-					u64 addr, u64 end, u32 level,
+					u64 addr, u64 end, s8 level,
 					kvm_pte_t *ptep,
 					enum kvm_pgtable_walk_flags flag,
 					void * const arg);
@@ -581,7 +582,7 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
  * Return: 0 on success, negative error code on failure.
  */
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
-			 kvm_pte_t *ptep, u32 *level);
+			 kvm_pte_t *ptep, s8 *level);
 
 /**
  * kvm_pgtable_stage2_pte_prot() - Retrieve the protection attributes of a
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 9f4ad2a8df59..addcf63cf8d5 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -16,10 +16,11 @@ extern unsigned int kvm_nvhe_sym(hyp_memblock_nr);
 
 static inline unsigned long __hyp_pgtable_max_pages(unsigned long nr_pages)
 {
-	unsigned long total = 0, i;
+	unsigned long total = 0;
+	int i;
 
 	/* Provision the worst case scenario */
-	for (i = 0; i < KVM_PGTABLE_MAX_LEVELS; i++) {
+	for (i = KVM_PGTABLE_FIRST_LEVEL; i <= KVM_PGTABLE_LAST_LEVEL; i++) {
 		nr_pages = DIV_ROUND_UP(nr_pages, PTRS_PER_PTE);
 		total += nr_pages;
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 43e729694deb..96a5567a9db3 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -281,7 +281,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 {
 	struct kvm_mem_range cur;
 	kvm_pte_t pte;
-	u32 level;
+	s8 level;
 	int ret;
 
 	hyp_assert_lock_held(&host_kvm.lock);
@@ -300,7 +300,7 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		cur.start = ALIGN_DOWN(addr, granule);
 		cur.end = cur.start + granule;
 		level++;
-	} while ((level < KVM_PGTABLE_MAX_LEVELS) &&
+	} while ((level <= KVM_PGTABLE_LAST_LEVEL) &&
 			!(kvm_level_supports_block_mapping(level) &&
 			  range_included(&cur, range)));
 
@@ -416,7 +416,7 @@ struct check_walk_data {
 };
 
 static int __check_page_state_visitor(struct kvm_pgtable *pgt,
-				      u64 addr, u64 end, u32 level,
+				      u64 addr, u64 end, s8 level,
 				      kvm_pte_t *ptep,
 				      enum kvm_pgtable_walk_flags flag,
 				      void * const arg)
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index b44e87b9d168..0355c53b3530 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -187,7 +187,7 @@ static void hpool_put_page(void *addr)
 }
 
 static int finalize_host_mappings_walker(struct kvm_pgtable *pgt,
-					 u64 addr, u64 end, u32 level,
+					 u64 addr, u64 end, s8 level,
 					 kvm_pte_t *ptep,
 					 enum kvm_pgtable_walk_flags flag,
 					 void * const arg)
@@ -210,7 +210,7 @@ static int finalize_host_mappings_walker(struct kvm_pgtable *pgt,
 	if (flag != KVM_PGTABLE_WALK_LEAF)
 		return 0;
 
-	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
+	if (level != KVM_PGTABLE_LAST_LEVEL)
 		return -EINVAL;
 
 	phys = kvm_pte_to_phys(pgt, pte);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cde852f91db8..274f839bd0d7 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -68,7 +68,7 @@ static bool kvm_phys_is_valid(struct kvm_pgtable *pgt, u64 phys)
 }
 
 static bool kvm_block_mapping_supported(struct kvm_pgtable *pgt,
-					u64 addr, u64 end, u64 phys, u32 level)
+					u64 addr, u64 end, u64 phys, s8 level)
 {
 	u64 granule = kvm_granule_size(level);
 
@@ -84,7 +84,7 @@ static bool kvm_block_mapping_supported(struct kvm_pgtable *pgt,
 	return IS_ALIGNED(addr, granule);
 }
 
-static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, u32 level)
+static u32 kvm_pgtable_idx(struct kvm_pgtable_walk_data *data, s8 level)
 {
 	u64 shift = kvm_granule_shift(level);
 	u64 mask = BIT(PAGE_SHIFT - 3) - 1;
@@ -105,7 +105,7 @@ static u32 kvm_pgd_page_idx(struct kvm_pgtable_walk_data *data)
 	return __kvm_pgd_page_idx(data->pgt, data->addr);
 }
 
-static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
+static u32 kvm_pgd_pages(u32 ia_bits, s8 start_level)
 {
 	struct kvm_pgtable pgt = {
 		.ia_bits	= ia_bits,
@@ -115,9 +115,9 @@ static u32 kvm_pgd_pages(u32 ia_bits, u32 start_level)
 	return __kvm_pgd_page_idx(&pgt, -1ULL) + 1;
 }
 
-static bool kvm_pte_table(kvm_pte_t pte, u32 level)
+static bool kvm_pte_table(kvm_pte_t pte, s8 level)
 {
-	if (level == KVM_PGTABLE_MAX_LEVELS - 1)
+	if (level == KVM_PGTABLE_LAST_LEVEL)
 		return false;
 
 	if (!kvm_pte_valid(pte))
@@ -166,11 +166,11 @@ static void kvm_set_table_pte(struct kvm_pgtable *pgt,
 }
 
 static kvm_pte_t kvm_init_valid_leaf_pte(struct kvm_pgtable *pgt,
-					 u64 pa, kvm_pte_t attr, u32 level)
+					 u64 pa, kvm_pte_t attr, s8 level)
 {
 	kvm_pte_t pte = kvm_phys_to_pte(pgt, pa);
-	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
-							   KVM_PTE_TYPE_BLOCK;
+	u64 type = (level == KVM_PGTABLE_LAST_LEVEL) ? KVM_PTE_TYPE_PAGE :
+						       KVM_PTE_TYPE_BLOCK;
 
 	pte |= attr & (KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI);
 	pte |= FIELD_PREP(KVM_PTE_TYPE, type);
@@ -185,7 +185,7 @@ static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
 }
 
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
-				  u32 level, kvm_pte_t *ptep,
+				  s8 level, kvm_pte_t *ptep,
 				  enum kvm_pgtable_walk_flags flag)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
@@ -194,10 +194,10 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      kvm_pte_t *pgtable, u32 level);
+			      kvm_pte_t *pgtable, s8 level);
 
 static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
-				      kvm_pte_t *ptep, u32 level)
+				      kvm_pte_t *ptep, s8 level)
 {
 	int ret = 0;
 	u64 addr = data->addr;
@@ -241,12 +241,12 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
-			      kvm_pte_t *pgtable, u32 level)
+			      kvm_pte_t *pgtable, s8 level)
 {
 	u32 idx;
 	int ret = 0;
 
-	if (WARN_ON_ONCE(level >= KVM_PGTABLE_MAX_LEVELS))
+	if (WARN_ON_ONCE(level > KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
 	for (idx = kvm_pgtable_idx(data, level); idx < PTRS_PER_PTE; ++idx) {
@@ -302,11 +302,11 @@ int kvm_pgtable_walk(struct kvm_pgtable *pgt, u64 addr, u64 size,
 
 struct leaf_walk_data {
 	kvm_pte_t	pte;
-	u32		level;
+	s8		level;
 };
 
 static int leaf_walker(struct kvm_pgtable *pgt,
-		       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+		       u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 		       enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct leaf_walk_data *data = arg;
@@ -318,7 +318,7 @@ static int leaf_walker(struct kvm_pgtable *pgt,
 }
 
 int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
-			 kvm_pte_t *ptep, u32 *level)
+			 kvm_pte_t *ptep, s8 *level)
 {
 	struct leaf_walk_data data;
 	struct kvm_pgtable_walker walker = {
@@ -399,7 +399,7 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 }
 
 static bool hyp_map_walker_try_leaf(struct kvm_pgtable *pgt,
-				    u64 addr, u64 end, u32 level,
+				    u64 addr, u64 end, s8 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
 	kvm_pte_t new, old = *ptep;
@@ -422,7 +422,7 @@ static bool hyp_map_walker_try_leaf(struct kvm_pgtable *pgt,
 }
 
 static int hyp_map_walker(struct kvm_pgtable *pgt,
-			  u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			  u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t *childp;
@@ -432,7 +432,7 @@ static int hyp_map_walker(struct kvm_pgtable *pgt,
 	if (hyp_map_walker_try_leaf(pgt, addr, end, level, ptep, data))
 		return 0;
 
-	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
+	if (WARN_ON(level == KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
 	childp = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
@@ -472,7 +472,7 @@ struct hyp_unmap_data {
 };
 
 static int hyp_unmap_walker(struct kvm_pgtable *pgt,
-			    u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			    u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			    enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t pte = *ptep, *childp = NULL;
@@ -531,14 +531,18 @@ u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 			 struct kvm_pgtable_mm_ops *mm_ops, bool lpa2_ena)
 {
-	u64 levels = ARM64_HW_PGTABLE_LEVELS(va_bits);
+	s8 start_level = KVM_PGTABLE_LAST_LEVEL + 1 -
+			 ARM64_HW_PGTABLE_LEVELS(va_bits);
+	if (start_level < KVM_PGTABLE_FIRST_LEVEL ||
+	    start_level > KVM_PGTABLE_LAST_LEVEL)
+		return -EINVAL;
 
 	pgt->pgd = (kvm_pte_t *)mm_ops->zalloc_page(NULL);
 	if (!pgt->pgd)
 		return -ENOMEM;
 
 	pgt->ia_bits		= va_bits;
-	pgt->start_level	= KVM_PGTABLE_MAX_LEVELS - levels;
+	pgt->start_level	= start_level;
 	pgt->mm_ops		= mm_ops;
 	pgt->lpa2_ena		= lpa2_ena;
 	pgt->mmu		= NULL;
@@ -548,7 +552,7 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 }
 
 static int hyp_free_walker(struct kvm_pgtable *pgt,
-			   u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			   u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
@@ -594,7 +598,7 @@ struct stage2_map_data {
 u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 {
 	u64 vtcr = VTCR_EL2_FLAGS;
-	u8 lvls;
+	s8 levels;
 	u64 parange;
 	bool lpa2_ena = false;
 
@@ -618,10 +622,10 @@ u64 kvm_get_vtcr(u64 mmfr0, u64 mmfr1, u32 phys_shift)
 	 * Use a minimum 2 level page table to prevent splitting
 	 * host PMD huge pages at stage2.
 	 */
-	lvls = stage2_pgtable_levels(phys_shift);
-	if (lvls < 2)
-		lvls = 2;
-	vtcr |= VTCR_EL2_LVLS_TO_SL0(lvls);
+	levels = stage2_pgtable_levels(phys_shift);
+	if (levels < 2)
+		levels = 2;
+	vtcr |= VTCR_EL2_LVLS_TO_SL0(levels);
 
 	/*
 	 * Enable the Hardware Access Flag management, unconditionally
@@ -716,7 +720,7 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 }
 
 static void stage2_put_pte(kvm_pte_t *ptep, struct kvm_s2_mmu *mmu, u64 addr,
-			   u32 level, struct kvm_pgtable_mm_ops *mm_ops)
+			   s8 level, struct kvm_pgtable_mm_ops *mm_ops)
 {
 	/*
 	 * Clear the existing PTE, and perform break-before-make with
@@ -742,17 +746,17 @@ static bool stage2_pte_executable(kvm_pte_t pte)
 }
 
 static bool stage2_leaf_mapping_allowed(struct kvm_pgtable *pgt,
-					u64 addr, u64 end, u32 level,
+					u64 addr, u64 end, s8 level,
 					struct stage2_map_data *data)
 {
-	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
+	if (data->force_pte && level < KVM_PGTABLE_LAST_LEVEL)
 		return false;
 
 	return kvm_block_mapping_supported(pgt, addr, end, data->phys, level);
 }
 
 static int stage2_map_walker_try_leaf(struct kvm_pgtable *pgt,
-				      u64 addr, u64 end, u32 level,
+				      u64 addr, u64 end, s8 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
@@ -798,7 +802,7 @@ static int stage2_map_walker_try_leaf(struct kvm_pgtable *pgt,
 }
 
 static int stage2_map_walk_table_pre(struct kvm_pgtable *pgt,
-				     u64 addr, u64 end, u32 level,
+				     u64 addr, u64 end, s8 level,
 				     kvm_pte_t *ptep,
 				     struct stage2_map_data *data)
 {
@@ -822,7 +826,7 @@ static int stage2_map_walk_table_pre(struct kvm_pgtable *pgt,
 }
 
 static int stage2_map_walk_leaf(struct kvm_pgtable *pgt,
-				u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+				u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
@@ -840,7 +844,7 @@ static int stage2_map_walk_leaf(struct kvm_pgtable *pgt,
 	if (ret != -E2BIG)
 		return ret;
 
-	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
+	if (WARN_ON(level == KVM_PGTABLE_LAST_LEVEL))
 		return -EINVAL;
 
 	if (!data->memcache)
@@ -865,7 +869,7 @@ static int stage2_map_walk_leaf(struct kvm_pgtable *pgt,
 }
 
 static int stage2_map_walk_table_post(struct kvm_pgtable *pgt,
-				      u64 addr, u64 end, u32 level,
+				      u64 addr, u64 end, s8 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
@@ -911,7 +915,7 @@ static int stage2_map_walk_table_post(struct kvm_pgtable *pgt,
  * pointer and clearing the anchor to NULL.
  */
 static int stage2_map_walker(struct kvm_pgtable *pgt,
-			     u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			     u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			     enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct stage2_map_data *data = arg;
@@ -984,7 +988,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 }
 
 static int stage2_unmap_walker(struct kvm_pgtable *pgt,
-			       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			       u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
@@ -1041,11 +1045,11 @@ struct stage2_attr_data {
 	kvm_pte_t			attr_set;
 	kvm_pte_t			attr_clr;
 	kvm_pte_t			pte;
-	u32				level;
+	s8				level;
 };
 
 static int stage2_attr_walker(struct kvm_pgtable *pgt,
-			      u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			      u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
@@ -1084,7 +1088,7 @@ static int stage2_attr_walker(struct kvm_pgtable *pgt,
 static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 				    u64 size, kvm_pte_t attr_set,
 				    kvm_pte_t attr_clr, kvm_pte_t *orig_pte,
-				    u32 *level)
+				    s8 *level)
 {
 	int ret;
 	kvm_pte_t attr_mask = KVM_PTE_LEAF_ATTR_LO | KVM_PTE_LEAF_ATTR_HI;
@@ -1151,7 +1155,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 				   enum kvm_pgtable_prot prot)
 {
 	int ret;
-	u32 level;
+	s8 level;
 	kvm_pte_t set = 0, clr = 0;
 
 	if (prot & KVM_PTE_LEAF_ATTR_HI_SW)
@@ -1173,7 +1177,7 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 }
 
 static int stage2_flush_walker(struct kvm_pgtable *pgt,
-			       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			       u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
@@ -1212,7 +1216,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	u64 vtcr = mmu->arch->vtcr;
 	u32 ia_bits = VTCR_EL2_IPA(vtcr);
 	u32 sl0 = FIELD_GET(VTCR_EL2_SL0_MASK, vtcr);
-	u32 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
+	s8 start_level = VTCR_EL2_TGRAN_SL0_BASE - sl0;
 	bool lpa2_ena = (vtcr & VTCR_EL2_DS) != 0;
 
 	pgd_sz = kvm_pgd_pages(ia_bits, start_level) * PAGE_SIZE;
@@ -1234,7 +1238,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 }
 
 static int stage2_free_walker(struct kvm_pgtable *pgt,
-			      u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+			      u64 addr, u64 end, s8 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 13e48539f022..4ce46be3f0a0 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -642,18 +642,19 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 	struct kvm_pgtable pgt = {
 		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
 		.ia_bits	= vabits_actual,
-		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
-				   CONFIG_PGTABLE_LEVELS),
+		.start_level	= (KVM_PGTABLE_LAST_LEVEL -
+				   CONFIG_PGTABLE_LEVELS + 1),
 		.mm_ops		= &kvm_user_mm_ops,
 		.lpa2_ena	= lpa2_is_enabled(),
 	};
 	kvm_pte_t pte = 0;	/* Keep GCC quiet... */
-	u32 level = ~0;
+	s8 level = ~0;
 	int ret;
 
 	ret = kvm_pgtable_get_leaf(&pgt, addr, &pte, &level);
 	VM_BUG_ON(ret);
-	VM_BUG_ON(level >= KVM_PGTABLE_MAX_LEVELS);
+	VM_BUG_ON(level > KVM_PGTABLE_LAST_LEVEL);
+	VM_BUG_ON(level < KVM_PGTABLE_FIRST_LEVEL);
 	VM_BUG_ON(!(pte & PTE_VALID));
 
 	return BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(level));
@@ -1138,7 +1139,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 	kvm_pfn_t pfn;
 	bool logging_active = memslot_is_logging(memslot);
 	bool use_read_lock = false;
-	unsigned long fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
+	s8 fault_level = kvm_vcpu_trap_get_fault_level(vcpu);
 	unsigned long vma_pagesize, fault_granule;
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R;
 	struct kvm_pgtable *pgt;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
