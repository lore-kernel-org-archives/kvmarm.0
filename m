Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B52BC4708C
	for <kvmarm@archiver.kernel.org>; Tue,  6 Dec 2022 14:00:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0448A4B5F1;
	Tue,  6 Dec 2022 09:00:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EegCjQhyni3i; Tue,  6 Dec 2022 09:00:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3A314B5ED;
	Tue,  6 Dec 2022 09:00:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 878B34B3F3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E1RVJgEOLSP1 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Dec 2022 09:00:12 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE88B4B5EA
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Dec 2022 09:00:10 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD583139F;
 Tue,  6 Dec 2022 06:00:16 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 699F13F73D;
 Tue,  6 Dec 2022 06:00:08 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
Subject: [PATCH v1 04/12] KVM: arm64: Plumbing to enable multiple pgtable
 formats
Date: Tue,  6 Dec 2022 13:59:22 +0000
Message-Id: <20221206135930.3277585-5-ryan.roberts@arm.com>
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

FEAT_LPA2 brings support for 52-bit input and output addresses for both
stage1 and stage2 translation when using 4KB and 16KB page sizes. The
architecture allows for the HW to support FEAT_LPA2 in one or both
stages of translation. When FEAT_LPA2 is enabled for a given stage, it
effectively changes the page table format; PTE bits change meaning and
blocks can be mapped at levels that were previously not possible.

All of this means that KVM has to support 2 page table formats and
decide which to use at runtime, after querying the HW. If FEAT_LPA2 is
advertised for stage1, KVM must choose to either use the classic format
or lpa2 format according to some policy for its hyp stage1, else it must
use the classic format. Independently, if FEAT_LPA2 is advertised for
stage2, KVM must which format to use for the vm stage2 tables according
to a policy.

As a first step towards enabling FEAT_LPA2, make struct kvm_pgtable
accessible to functions that will need to take different actions
depending on the page-table format. These functions are:

  - kvm_pte_to_phys()
  - kvm_phys_to_pte()
  - kvm_level_supports_block_mapping()
  - hyp_set_prot_attr()
  - stage2_set_prot_attr()

Fix this by more consistently passing the struct kvm_pgtable around as
the first parameter of each kvm_pgtable function call. As a result of
always passing it to walker callbacks, we can remove some ad-hoc members
from walker-specific data structures because those members are
accessible through the struct kvm_pgtable (notably mmu and mm_ops).

No functional changes are intended.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  23 ++--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |   5 +-
 arch/arm64/kvm/hyp/nvhe/setup.c       |   8 +-
 arch/arm64/kvm/hyp/pgtable.c          | 181 +++++++++++++-------------
 4 files changed, 109 insertions(+), 108 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 3252eb50ecfe..2247ed74871a 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -47,16 +47,6 @@ static inline bool kvm_pte_valid(kvm_pte_t pte)
 	return pte & KVM_PTE_VALID;
 }
 
-static inline u64 kvm_pte_to_phys(kvm_pte_t pte)
-{
-	u64 pa = pte & KVM_PTE_ADDR_MASK;
-
-	if (PAGE_SHIFT == 16)
-		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
-
-	return pa;
-}
-
 static inline u64 kvm_granule_shift(u32 level)
 {
 	/* Assumes KVM_PGTABLE_MAX_LEVELS is 4 */
@@ -184,6 +174,16 @@ struct kvm_pgtable {
 	kvm_pgtable_force_pte_cb_t		force_pte_cb;
 };
 
+static inline u64 kvm_pte_to_phys(struct kvm_pgtable *pgt, kvm_pte_t pte)
+{
+	u64 pa = pte & KVM_PTE_ADDR_MASK;
+
+	if (PAGE_SHIFT == 16)
+		pa |= FIELD_GET(KVM_PTE_ADDR_51_48, pte) << 48;
+
+	return pa;
+}
+
 /**
  * enum kvm_pgtable_walk_flags - Flags to control a depth-first page-table walk.
  * @KVM_PGTABLE_WALK_LEAF:		Visit leaf entries, including invalid
@@ -199,7 +199,8 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 };
 
-typedef int (*kvm_pgtable_visitor_fn_t)(u64 addr, u64 end, u32 level,
+typedef int (*kvm_pgtable_visitor_fn_t)(struct kvm_pgtable *pgt,
+					u64 addr, u64 end, u32 level,
 					kvm_pte_t *ptep,
 					enum kvm_pgtable_walk_flags flag,
 					void * const arg);
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 07f9dc9848ef..6bf54c8daffa 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -417,7 +417,8 @@ struct check_walk_data {
 	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
 };
 
-static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
+static int __check_page_state_visitor(struct kvm_pgtable *pgt,
+				      u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      enum kvm_pgtable_walk_flags flag,
 				      void * const arg)
@@ -425,7 +426,7 @@ static int __check_page_state_visitor(u64 addr, u64 end, u32 level,
 	struct check_walk_data *d = arg;
 	kvm_pte_t pte = *ptep;
 
-	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pte)))
+	if (kvm_pte_valid(pte) && !addr_is_memory(kvm_pte_to_phys(pgt, pte)))
 		return -EINVAL;
 
 	return d->get_page_state(pte) == d->desired ? 0 : -EPERM;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index e8d4ea2fcfa0..60a6821ae98a 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -186,12 +186,13 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
-static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
+static int finalize_host_mappings_walker(struct kvm_pgtable *pgt,
+					 u64 addr, u64 end, u32 level,
 					 kvm_pte_t *ptep,
 					 enum kvm_pgtable_walk_flags flag,
 					 void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	enum kvm_pgtable_prot prot;
 	enum pkvm_page_state state;
 	kvm_pte_t pte = *ptep;
@@ -212,7 +213,7 @@ static int finalize_host_mappings_walker(u64 addr, u64 end, u32 level,
 	if (level != (KVM_PGTABLE_MAX_LEVELS - 1))
 		return -EINVAL;
 
-	phys = kvm_pte_to_phys(pte);
+	phys = kvm_pte_to_phys(pgt, pte);
 	if (!addr_is_memory(phys))
 		return -EINVAL;
 
@@ -242,7 +243,6 @@ static int finalize_host_mappings(void)
 	struct kvm_pgtable_walker walker = {
 		.cb	= finalize_host_mappings_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
-		.arg	= pkvm_pgtable.mm_ops,
 	};
 	int i, ret;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index cdf8e76b0be1..221e0dafb149 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -59,12 +59,13 @@ struct kvm_pgtable_walk_data {
 
 #define KVM_PHYS_INVALID (-1ULL)
 
-static bool kvm_phys_is_valid(u64 phys)
+static bool kvm_phys_is_valid(struct kvm_pgtable *pgt, u64 phys)
 {
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
 }
 
-static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
+static bool kvm_block_mapping_supported(struct kvm_pgtable *pgt,
+					u64 addr, u64 end, u64 phys, u32 level)
 {
 	u64 granule = kvm_granule_size(level);
 
@@ -74,7 +75,7 @@ static bool kvm_block_mapping_supported(u64 addr, u64 end, u64 phys, u32 level)
 	if (granule > (end - addr))
 		return false;
 
-	if (kvm_phys_is_valid(phys) && !IS_ALIGNED(phys, granule))
+	if (kvm_phys_is_valid(pgt, phys) && !IS_ALIGNED(phys, granule))
 		return false;
 
 	return IS_ALIGNED(addr, granule);
@@ -122,7 +123,7 @@ static bool kvm_pte_table(kvm_pte_t pte, u32 level)
 	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
 }
 
-static kvm_pte_t kvm_phys_to_pte(u64 pa)
+static kvm_pte_t kvm_phys_to_pte(struct kvm_pgtable *pgt, u64 pa)
 {
 	kvm_pte_t pte = pa & KVM_PTE_ADDR_MASK;
 
@@ -132,9 +133,9 @@ static kvm_pte_t kvm_phys_to_pte(u64 pa)
 	return pte;
 }
 
-static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t *kvm_pte_follow(struct kvm_pgtable *pgt, kvm_pte_t pte)
 {
-	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
+	return pgt->mm_ops->phys_to_virt(kvm_pte_to_phys(pgt, pte));
 }
 
 static void kvm_clear_pte(kvm_pte_t *ptep)
@@ -142,10 +143,11 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static void kvm_set_table_pte(struct kvm_pgtable *pgt,
+			      kvm_pte_t *ptep, kvm_pte_t *childp)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t old = *ptep;
+	kvm_pte_t pte = kvm_phys_to_pte(pgt, pgt->mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
@@ -154,9 +156,10 @@ static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
 	smp_store_release(ptep, pte);
 }
 
-static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
+static kvm_pte_t kvm_init_valid_leaf_pte(struct kvm_pgtable *pgt,
+					 u64 pa, kvm_pte_t attr, u32 level)
 {
-	kvm_pte_t pte = kvm_phys_to_pte(pa);
+	kvm_pte_t pte = kvm_phys_to_pte(pgt, pa);
 	u64 type = (level == KVM_PGTABLE_MAX_LEVELS - 1) ? KVM_PTE_TYPE_PAGE :
 							   KVM_PTE_TYPE_BLOCK;
 
@@ -177,7 +180,8 @@ static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data, u64 addr,
 				  enum kvm_pgtable_walk_flags flag)
 {
 	struct kvm_pgtable_walker *walker = data->walker;
-	return walker->cb(addr, data->end, level, ptep, flag, walker->arg);
+	return walker->cb(data->pgt,
+			  addr, data->end, level, ptep, flag, walker->arg);
 }
 
 static int __kvm_pgtable_walk(struct kvm_pgtable_walk_data *data,
@@ -213,7 +217,7 @@ static inline int __kvm_pgtable_visit(struct kvm_pgtable_walk_data *data,
 		goto out;
 	}
 
-	childp = kvm_pte_follow(pte, data->pgt->mm_ops);
+	childp = kvm_pte_follow(data->pgt, pte);
 	ret = __kvm_pgtable_walk(data, childp, level + 1);
 	if (ret)
 		goto out;
@@ -292,7 +296,8 @@ struct leaf_walk_data {
 	u32		level;
 };
 
-static int leaf_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int leaf_walker(struct kvm_pgtable *pgt,
+		       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		       enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct leaf_walk_data *data = arg;
@@ -329,10 +334,10 @@ int kvm_pgtable_get_leaf(struct kvm_pgtable *pgt, u64 addr,
 struct hyp_map_data {
 	u64				phys;
 	kvm_pte_t			attr;
-	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
+static int hyp_set_prot_attr(struct kvm_pgtable *pgt,
+			     enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 {
 	bool device = prot & KVM_PGTABLE_PROT_DEVICE;
 	u32 mtype = device ? MT_DEVICE_nGnRE : MT_NORMAL;
@@ -383,21 +388,22 @@ enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte)
 	return prot;
 }
 
-static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
+static bool hyp_map_walker_try_leaf(struct kvm_pgtable *pgt,
+				    u64 addr, u64 end, u32 level,
 				    kvm_pte_t *ptep, struct hyp_map_data *data)
 {
 	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
 
-	if (!kvm_block_mapping_supported(addr, end, phys, level))
+	if (!kvm_block_mapping_supported(pgt, addr, end, phys, level))
 		return false;
 
 	data->phys += granule;
-	new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	new = kvm_init_valid_leaf_pte(pgt, phys, data->attr, level);
 	if (old == new)
 		return true;
 	if (!kvm_pte_valid(old))
-		data->mm_ops->get_page(ptep);
+		pgt->mm_ops->get_page(ptep);
 	else if (WARN_ON((old ^ new) & ~KVM_PTE_LEAF_ATTR_HI_SW))
 		return false;
 
@@ -405,14 +411,15 @@ static bool hyp_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 	return true;
 }
 
-static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_map_walker(struct kvm_pgtable *pgt,
+			  u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			  enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t *childp;
 	struct hyp_map_data *data = arg;
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
-	if (hyp_map_walker_try_leaf(addr, end, level, ptep, arg))
+	if (hyp_map_walker_try_leaf(pgt, addr, end, level, ptep, data))
 		return 0;
 
 	if (WARN_ON(level == KVM_PGTABLE_MAX_LEVELS - 1))
@@ -422,7 +429,7 @@ static int hyp_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
+	kvm_set_table_pte(pgt, ptep, childp);
 	mm_ops->get_page(ptep);
 	return 0;
 }
@@ -433,7 +440,6 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 	int ret;
 	struct hyp_map_data map_data = {
 		.phys	= ALIGN_DOWN(phys, PAGE_SIZE),
-		.mm_ops	= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_map_walker,
@@ -441,7 +447,7 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 		.arg	= &map_data,
 	};
 
-	ret = hyp_set_prot_attr(prot, &map_data.attr);
+	ret = hyp_set_prot_attr(pgt, prot, &map_data.attr);
 	if (ret)
 		return ret;
 
@@ -453,22 +459,22 @@ int kvm_pgtable_hyp_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 
 struct hyp_unmap_data {
 	u64				unmapped;
-	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_unmap_walker(struct kvm_pgtable *pgt,
+			    u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			    enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	kvm_pte_t pte = *ptep, *childp = NULL;
 	u64 granule = kvm_granule_size(level);
 	struct hyp_unmap_data *data = arg;
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return -EINVAL;
 
 	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte, mm_ops);
+		childp = kvm_pte_follow(pgt, pte);
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
@@ -498,9 +504,7 @@ static int hyp_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 
 u64 kvm_pgtable_hyp_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	struct hyp_unmap_data unmap_data = {
-		.mm_ops	= pgt->mm_ops,
-	};
+	struct hyp_unmap_data unmap_data = {};
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_unmap_walker,
 		.arg	= &unmap_data,
@@ -532,10 +536,11 @@ int kvm_pgtable_hyp_init(struct kvm_pgtable *pgt, u32 va_bits,
 	return 0;
 }
 
-static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int hyp_free_walker(struct kvm_pgtable *pgt,
+			   u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			   enum kvm_pgtable_walk_flags flag, void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
 	if (!kvm_pte_valid(pte))
@@ -544,7 +549,7 @@ static int hyp_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	mm_ops->put_page(ptep);
 
 	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+		mm_ops->put_page(kvm_pte_follow(pgt, pte));
 
 	return 0;
 }
@@ -554,7 +559,6 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 	struct kvm_pgtable_walker walker = {
 		.cb	= hyp_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
-		.arg	= pgt->mm_ops,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
@@ -570,11 +574,8 @@ struct stage2_map_data {
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
 
-	struct kvm_s2_mmu		*mmu;
 	void				*memcache;
 
-	struct kvm_pgtable_mm_ops	*mm_ops;
-
 	/* Force mappings to page granularity */
 	bool				force_pte;
 };
@@ -708,29 +709,30 @@ static bool stage2_pte_executable(kvm_pte_t pte)
 	return !(pte & KVM_PTE_LEAF_ATTR_HI_S2_XN);
 }
 
-static bool stage2_leaf_mapping_allowed(u64 addr, u64 end, u32 level,
+static bool stage2_leaf_mapping_allowed(struct kvm_pgtable *pgt,
+					u64 addr, u64 end, u32 level,
 					struct stage2_map_data *data)
 {
 	if (data->force_pte && (level < (KVM_PGTABLE_MAX_LEVELS - 1)))
 		return false;
 
-	return kvm_block_mapping_supported(addr, end, data->phys, level);
+	return kvm_block_mapping_supported(pgt, addr, end, data->phys, level);
 }
 
-static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
+static int stage2_map_walker_try_leaf(struct kvm_pgtable *pgt,
+				      u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
 	kvm_pte_t new, old = *ptep;
 	u64 granule = kvm_granule_size(level), phys = data->phys;
-	struct kvm_pgtable *pgt = data->mmu->pgt;
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
-	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
+	if (!stage2_leaf_mapping_allowed(pgt, addr, end, level, data))
 		return -E2BIG;
 
-	if (kvm_phys_is_valid(phys))
-		new = kvm_init_valid_leaf_pte(phys, data->attr, level);
+	if (kvm_phys_is_valid(pgt, phys))
+		new = kvm_init_valid_leaf_pte(pgt, phys, data->attr, level);
 	else
 		new = kvm_init_invalid_leaf_owner(data->owner_id);
 
@@ -744,36 +746,37 @@ static int stage2_map_walker_try_leaf(u64 addr, u64 end, u32 level,
 		if (!stage2_pte_needs_update(old, new))
 			return -EAGAIN;
 
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
+		stage2_put_pte(ptep, pgt->mmu, addr, level, mm_ops);
 	}
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
 	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pgt, new),
 						granule);
 
 	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
-		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
+		mm_ops->icache_inval_pou(kvm_pte_follow(pgt, new), granule);
 
 	smp_store_release(ptep, new);
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ptep);
-	if (kvm_phys_is_valid(phys))
+	if (kvm_phys_is_valid(pgt, phys))
 		data->phys += granule;
 	return 0;
 }
 
-static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
+static int stage2_map_walk_table_pre(struct kvm_pgtable *pgt,
+				     u64 addr, u64 end, u32 level,
 				     kvm_pte_t *ptep,
 				     struct stage2_map_data *data)
 {
 	if (data->anchor)
 		return 0;
 
-	if (!stage2_leaf_mapping_allowed(addr, end, level, data))
+	if (!stage2_leaf_mapping_allowed(pgt, addr, end, level, data))
 		return 0;
 
-	data->childp = kvm_pte_follow(*ptep, data->mm_ops);
+	data->childp = kvm_pte_follow(pgt, *ptep);
 	kvm_clear_pte(ptep);
 
 	/*
@@ -781,15 +784,16 @@ static int stage2_map_walk_table_pre(u64 addr, u64 end, u32 level,
 	 * entries below us which would otherwise need invalidating
 	 * individually.
 	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	kvm_call_hyp(__kvm_tlb_flush_vmid, pgt->mmu);
 	data->anchor = ptep;
 	return 0;
 }
 
-static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_map_walk_leaf(struct kvm_pgtable *pgt,
+				u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 				struct stage2_map_data *data)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t *childp, pte = *ptep;
 	int ret;
 
@@ -800,7 +804,7 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 	}
 
-	ret = stage2_map_walker_try_leaf(addr, end, level, ptep, data);
+	ret = stage2_map_walker_try_leaf(pgt, addr, end, level, ptep, data);
 	if (ret != -E2BIG)
 		return ret;
 
@@ -820,19 +824,20 @@ static int stage2_map_walk_leaf(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	 * will be mapped lazily.
 	 */
 	if (stage2_pte_is_counted(pte))
-		stage2_put_pte(ptep, data->mmu, addr, level, mm_ops);
+		stage2_put_pte(ptep, pgt->mmu, addr, level, mm_ops);
 
-	kvm_set_table_pte(ptep, childp, mm_ops);
+	kvm_set_table_pte(pgt, ptep, childp);
 	mm_ops->get_page(ptep);
 
 	return 0;
 }
 
-static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
+static int stage2_map_walk_table_post(struct kvm_pgtable *pgt,
+				      u64 addr, u64 end, u32 level,
 				      kvm_pte_t *ptep,
 				      struct stage2_map_data *data)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t *childp;
 	int ret = 0;
 
@@ -843,9 +848,9 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
 		childp = data->childp;
 		data->anchor = NULL;
 		data->childp = NULL;
-		ret = stage2_map_walk_leaf(addr, end, level, ptep, data);
+		ret = stage2_map_walk_leaf(pgt, addr, end, level, ptep, data);
 	} else {
-		childp = kvm_pte_follow(*ptep, mm_ops);
+		childp = kvm_pte_follow(pgt, *ptep);
 	}
 
 	mm_ops->put_page(childp);
@@ -873,18 +878,19 @@ static int stage2_map_walk_table_post(u64 addr, u64 end, u32 level,
  * the page-table, installing the block entry when it revisits the anchor
  * pointer and clearing the anchor to NULL.
  */
-static int stage2_map_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_map_walker(struct kvm_pgtable *pgt,
+			     u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			     enum kvm_pgtable_walk_flags flag, void * const arg)
 {
 	struct stage2_map_data *data = arg;
 
 	switch (flag) {
 	case KVM_PGTABLE_WALK_TABLE_PRE:
-		return stage2_map_walk_table_pre(addr, end, level, ptep, data);
+		return stage2_map_walk_table_pre(pgt, addr, end, level, ptep, data);
 	case KVM_PGTABLE_WALK_LEAF:
-		return stage2_map_walk_leaf(addr, end, level, ptep, data);
+		return stage2_map_walk_leaf(pgt, addr, end, level, ptep, data);
 	case KVM_PGTABLE_WALK_TABLE_POST:
-		return stage2_map_walk_table_post(addr, end, level, ptep, data);
+		return stage2_map_walk_table_post(pgt, addr, end, level, ptep, data);
 	}
 
 	return -EINVAL;
@@ -897,9 +903,7 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	int ret;
 	struct stage2_map_data map_data = {
 		.phys		= ALIGN_DOWN(phys, PAGE_SIZE),
-		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.mm_ops		= pgt->mm_ops,
 		.force_pte	= pgt->force_pte_cb && pgt->force_pte_cb(addr, addr + size, prot),
 	};
 	struct kvm_pgtable_walker walker = {
@@ -928,9 +932,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	int ret;
 	struct stage2_map_data map_data = {
 		.phys		= KVM_PHYS_INVALID,
-		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.mm_ops		= pgt->mm_ops,
 		.owner_id	= owner_id,
 		.force_pte	= true,
 	};
@@ -949,11 +951,11 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_unmap_walker(struct kvm_pgtable *pgt,
+			       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
-	struct kvm_pgtable *pgt = arg;
 	struct kvm_s2_mmu *mmu = pgt->mmu;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep, *childp = NULL;
@@ -968,7 +970,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	}
 
 	if (kvm_pte_table(pte, level)) {
-		childp = kvm_pte_follow(pte, mm_ops);
+		childp = kvm_pte_follow(pgt, pte);
 
 		if (mm_ops->page_count(childp) != 1)
 			return 0;
@@ -984,7 +986,7 @@ static int stage2_unmap_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	stage2_put_pte(ptep, mmu, addr, level, mm_ops);
 
 	if (need_flush && mm_ops->dcache_clean_inval_poc)
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pgt, pte),
 					       kvm_granule_size(level));
 
 	if (childp)
@@ -997,7 +999,6 @@ int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_unmap_walker,
-		.arg	= pgt,
 		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
@@ -1009,16 +1010,16 @@ struct stage2_attr_data {
 	kvm_pte_t			attr_clr;
 	kvm_pte_t			pte;
 	u32				level;
-	struct kvm_pgtable_mm_ops	*mm_ops;
 };
 
-static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_attr_walker(struct kvm_pgtable *pgt,
+			      u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
 	kvm_pte_t pte = *ptep;
 	struct stage2_attr_data *data = arg;
-	struct kvm_pgtable_mm_ops *mm_ops = data->mm_ops;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 
 	if (!kvm_pte_valid(pte))
 		return 0;
@@ -1040,7 +1041,7 @@ static int stage2_attr_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		 */
 		if (mm_ops->icache_inval_pou &&
 		    stage2_pte_executable(pte) && !stage2_pte_executable(*ptep))
-			mm_ops->icache_inval_pou(kvm_pte_follow(pte, mm_ops),
+			mm_ops->icache_inval_pou(kvm_pte_follow(pgt, pte),
 						  kvm_granule_size(level));
 		WRITE_ONCE(*ptep, pte);
 	}
@@ -1058,7 +1059,6 @@ static int stage2_update_leaf_attrs(struct kvm_pgtable *pgt, u64 addr,
 	struct stage2_attr_data data = {
 		.attr_set	= attr_set & attr_mask,
 		.attr_clr	= attr_clr & attr_mask,
-		.mm_ops		= pgt->mm_ops,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_attr_walker,
@@ -1140,11 +1140,11 @@ int kvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr,
 	return ret;
 }
 
-static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_flush_walker(struct kvm_pgtable *pgt,
+			       u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			       enum kvm_pgtable_walk_flags flag,
 			       void * const arg)
 {
-	struct kvm_pgtable *pgt = arg;
 	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
@@ -1152,7 +1152,7 @@ static int stage2_flush_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 		return 0;
 
 	if (mm_ops->dcache_clean_inval_poc)
-		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pte, mm_ops),
+		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(pgt, pte),
 					       kvm_granule_size(level));
 	return 0;
 }
@@ -1162,7 +1162,6 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_flush_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF,
-		.arg	= pgt,
 	};
 
 	if (stage2_has_fwb(pgt))
@@ -1200,11 +1199,12 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 	return 0;
 }
 
-static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
+static int stage2_free_walker(struct kvm_pgtable *pgt,
+			      u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 			      enum kvm_pgtable_walk_flags flag,
 			      void * const arg)
 {
-	struct kvm_pgtable_mm_ops *mm_ops = arg;
+	struct kvm_pgtable_mm_ops *mm_ops = pgt->mm_ops;
 	kvm_pte_t pte = *ptep;
 
 	if (!stage2_pte_is_counted(pte))
@@ -1213,7 +1213,7 @@ static int stage2_free_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
 	mm_ops->put_page(ptep);
 
 	if (kvm_pte_table(pte, level))
-		mm_ops->put_page(kvm_pte_follow(pte, mm_ops));
+		mm_ops->put_page(kvm_pte_follow(pgt, pte));
 
 	return 0;
 }
@@ -1225,7 +1225,6 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
-		.arg	= pgt->mm_ops,
 	};
 
 	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
