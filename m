Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D71D92264A7
	for <kvmarm@lists.linux.dev>; Fri, 27 Mar 2026 14:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774620120; cv=none; b=PZOVQzRi31vv3cVO1G/BhMrp/Jhr1FquWCAjJj8+2rgW2Hlhtn66Cr+g/w+CiZizr7UAuNvBmIWYMFdFyLW9v3U4rnwmzTIi2ycJ0K40w5Kht+JsogCyr+bHvByXXCQ3kN4R5TYYhOFkVG6SnU6SrbRR2iNNvwOn9rKn/MffRV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774620120; c=relaxed/simple;
	bh=Ix0Q+eOR2BImfuEQCGWKQk+aOt9W6ZEXM/EA71e0MUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hT/I0LSvrbXlHSclEsEWE8oWp732hbWYAdAimRt+wKcfFHMOQetYU4038zKeJywlGEIQVLFVF/b53U3ybrkTNp9LwKyN6erQ14NdGUI+3TTwtDs4LFuWlIO9GDtAVPVzsxOZ4HHNQGoOPdTCeiFXxER1fw8v5CgWSvEyvSqBCRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwQ0ivyt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwQ0ivyt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76E28C19423;
	Fri, 27 Mar 2026 14:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774620120;
	bh=Ix0Q+eOR2BImfuEQCGWKQk+aOt9W6ZEXM/EA71e0MUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AwQ0ivyttu4B5l6sZ/lOXqNDHO6KsQC0ZuW78qzALHGpOj8fnDjDr/bt4xRPGyIGE
	 5DBsPAMJoMhG3rHxZ8mtDba/yh88jDFtOUwbrm+sPH5mJKTGHY1ZNeaRJGzAi0y1qi
	 9q0f/MqsLIwf2X1duNaZflVbZhEXFJ9+E5jY/8FFP8GA69ColcUIH5M03vrpX7qP1O
	 +OwyXTJVbaUwn+bSMFGxmn3Sy8+EEZqqmBOiq0YT49r+TxrXncKZcfjJGPv+CCnbmG
	 uqfxGzP3ej1z3mgaImEXTxmlrHe3dAf5X0wp3UoBYBKZWwHPnK5BoV/DKU8M9hjozj
	 +jgOujxpHUkmg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Quentin Perret <qperret@google.com>,
	Fuad Tabba <tabba@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v4 21/38] KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
Date: Fri, 27 Mar 2026 14:00:20 +0000
Message-ID: <20260327140039.21228-22-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327140039.21228-1-will@kernel.org>
References: <20260327140039.21228-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_pgtable_stage2_set_owner() can be generalised into a way to store
up to 59 bits in the page tables alongside a 4-bit 'type' identifier
specific to the format of the 59-bit payload.

Introduce kvm_pgtable_stage2_annotate() and move the existing invalid
ptes (for locked ptes and donated pages) over to the new scheme.

Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 39 +++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 +++++++++--
 arch/arm64/kvm/hyp/pgtable.c          | 33 ++++++++++++++---------
 3 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 50caca311ef5..e36c2908bdb2 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -100,13 +100,25 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		2
 
-/*
- * Used to indicate a pte for which a 'break-before-make' sequence is in
- * progress.
- */
-#define KVM_INVALID_PTE_LOCKED		BIT(10)
+/* pKVM invalid pte encodings */
+#define KVM_INVALID_PTE_TYPE_MASK	GENMASK(63, 60)
+#define KVM_INVALID_PTE_ANNOT_MASK	~(KVM_PTE_VALID | \
+					  KVM_INVALID_PTE_TYPE_MASK)
+
+enum kvm_invalid_pte_type {
+	/*
+	 * Used to indicate a pte for which a 'break-before-make'
+	 * sequence is in progress.
+	 */
+	KVM_INVALID_PTE_TYPE_LOCKED	= 1,
+
+	/*
+	 * pKVM has unmapped the page from the host due to a change of
+	 * ownership.
+	 */
+	KVM_HOST_INVALID_PTE_TYPE_DONATION,
+};
 
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
@@ -658,14 +670,18 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			   void *mc, enum kvm_pgtable_walk_flags flags);
 
 /**
- * kvm_pgtable_stage2_set_owner() - Unmap and annotate pages in the IPA space to
- *				    track ownership.
+ * kvm_pgtable_stage2_annotate() - Unmap and annotate pages in the IPA space
+ *				   to track ownership (and more).
  * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
  * @addr:	Base intermediate physical address to annotate.
  * @size:	Size of the annotated range.
  * @mc:		Cache of pre-allocated and zeroed memory from which to allocate
  *		page-table pages.
- * @owner_id:	Unique identifier for the owner of the page.
+ * @type:	The type of the annotation, determining its meaning and format.
+ * @annotation:	A 59-bit value that will be stored in the page tables.
+ *		@annotation[0] and @annotation[63:60] must be 0.
+ * 		@annotation[59:1] is stored in the page tables, along
+ *		with @type.
  *
  * By default, all page-tables are owned by identifier 0. This function can be
  * used to mark portions of the IPA space as owned by other entities. When a
@@ -674,8 +690,9 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id);
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, enum kvm_invalid_pte_type type,
+				kvm_pte_t annotation);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index bf5102594fc8..aea6ec981801 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -549,10 +549,19 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 		set_host_state(page, state);
 }
 
+static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
+{
+	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
+}
+
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
+	kvm_pte_t annotation;
 	int ret = -EINVAL;
 
+	if (!FIELD_FIT(KVM_INVALID_PTE_OWNER_MASK, owner_id))
+		return -EINVAL;
+
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
@@ -564,8 +573,11 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 		break;
 	case PKVM_ID_GUEST:
 	case PKVM_ID_HYP:
-		ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-				      addr, size, &host_s2_pool, owner_id);
+		annotation = kvm_init_invalid_leaf_owner(owner_id);
+		ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+				      addr, size, &host_s2_pool,
+				      KVM_HOST_INVALID_PTE_TYPE_DONATION,
+				      annotation);
 		if (!ret)
 			__host_update_page_state(addr, size, PKVM_NOPAGE);
 		break;
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9b480f947da2..84c7a1df845d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -114,11 +114,6 @@ static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, s8 level)
 	return pte;
 }
 
-static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
-{
-	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
-}
-
 static int kvm_pgtable_visitor_cb(struct kvm_pgtable_walk_data *data,
 				  const struct kvm_pgtable_visit_ctx *ctx,
 				  enum kvm_pgtable_walk_flags visit)
@@ -581,7 +576,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	const u64			phys;
 	kvm_pte_t			attr;
-	u8				owner_id;
+	kvm_pte_t			pte_annot;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -798,7 +793,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 
 static bool stage2_pte_is_locked(kvm_pte_t pte)
 {
-	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
+	if (kvm_pte_valid(pte))
+		return false;
+
+	return FIELD_GET(KVM_INVALID_PTE_TYPE_MASK, pte) ==
+	       KVM_INVALID_PTE_TYPE_LOCKED;
 }
 
 static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
@@ -829,6 +828,7 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 				 struct kvm_s2_mmu *mmu)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t locked_pte;
 
 	if (stage2_pte_is_locked(ctx->old)) {
 		/*
@@ -839,7 +839,9 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		return false;
 	}
 
-	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
+	locked_pte = FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK,
+				KVM_INVALID_PTE_TYPE_LOCKED);
+	if (!stage2_try_set_pte(ctx, locked_pte))
 		return false;
 
 	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
@@ -964,7 +966,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!data->annotation)
 		new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	else
-		new = kvm_init_invalid_leaf_owner(data->owner_id);
+		new = data->pte_annot;
 
 	/*
 	 * Skip updating the PTE if we are trying to recreate the exact
@@ -1118,16 +1120,18 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id)
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, enum kvm_invalid_pte_type type,
+				kvm_pte_t pte_annot)
 {
 	int ret;
 	struct stage2_map_data map_data = {
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.owner_id	= owner_id,
 		.force_pte	= true,
 		.annotation	= true,
+		.pte_annot	= pte_annot |
+				  FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK, type),
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -1136,7 +1140,10 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	if (owner_id > KVM_MAX_OWNER_ID)
+	if (pte_annot & ~KVM_INVALID_PTE_ANNOT_MASK)
+		return -EINVAL;
+
+	if (!type || type == KVM_INVALID_PTE_TYPE_LOCKED)
 		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.53.0.1018.g2bb0e51243-goog

