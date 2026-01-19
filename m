Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE935E555
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826875; cv=none; b=Sz8wx81G1WIO81d7vtgkTwKZD8o87ef9lh4hH+fbxvQoggE5qDgxYp1O/vBl9+I9Q6/ylsZcK3b5VrfXOMn3z8b8HWGKNI2F9tK7EZzBJ1MdOLU33jnFmMo2JszDwSLRTZljvGsFw/MVTIAlZOh9bbrIu/u5jz8yU/QrOFE4Pww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826875; c=relaxed/simple;
	bh=sgOZZb6q9M08bmQiXhieF6pJuGs5khdAx8nj6Z9sywM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EuAZjb7kMjrQc63f7/WxpJaLwdhhqV+3nuNebJ5cZ3ZPv+MJ1XFzAyDChmvayjEGLIr2zlkJ+u6M51+1/8q61s8oTGYnY+k1rnHbIX//osXNzY11kzc6FTiW17x2Z2plJHFzpncZgQ8YGO1eWg19VLEG/J1FlpWrKLTVQjClbMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PiV9LCg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PiV9LCg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E808C19423;
	Mon, 19 Jan 2026 12:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826874;
	bh=sgOZZb6q9M08bmQiXhieF6pJuGs5khdAx8nj6Z9sywM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PiV9LCg1PexKXgWo5zFhwIAJn8FgGiFPP1bbum8QDaAbzLqNtQpEhKb3sJq+Y9Vy1
	 Uqp2cAW3WtuhdTtDUUpCnO7nyhbcwR7pFrZAMvHgpbbwxxPh8VAD4OYs3YEPmrS0aU
	 W5flyyjOw/wPjOGqxynt+qfbED4SuFXGv44SuGE6kn0vlz6nZiKceATb3NlHZ6sgkQ
	 ra2oH9REx+18RQ/o2adDaXdGt+VpSyw5hq2rjTRsPBBP4NSLrR0wo8cUBpWpEj3FBA
	 b54Dsd4LWqHPUoBASacHZc7oeiHEAvdxOrq8MOzOEnZeuUYOr6RvrVe+U4VX999RIZ
	 Dv+vs8ca6Wm+w==
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
	Mostafa Saleh <smostafa@google.com>
Subject: [PATCH v2 20/35] KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
Date: Mon, 19 Jan 2026 12:46:13 +0000
Message-ID: <20260119124629.2563-21-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
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

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 39 +++++++++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 16 +++++++++--
 arch/arm64/kvm/hyp/pgtable.c          | 33 ++++++++++++++---------
 3 files changed, 62 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9ce55442b621..4c41a8ed4a7c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -98,13 +98,25 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		3
 
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
@@ -657,14 +669,18 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
@@ -673,8 +689,9 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
index 55df0c45b0f2..3f8a73461f90 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -546,10 +546,19 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
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
 
@@ -561,8 +570,11 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
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
index 9abc0a6cf448..38465f547c8c 100644
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
@@ -563,7 +558,7 @@ void kvm_pgtable_hyp_destroy(struct kvm_pgtable *pgt)
 struct stage2_map_data {
 	const u64			phys;
 	kvm_pte_t			attr;
-	u8				owner_id;
+	kvm_pte_t			pte_annot;
 
 	kvm_pte_t			*anchor;
 	kvm_pte_t			*childp;
@@ -780,7 +775,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 
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
@@ -811,6 +810,7 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 				 struct kvm_s2_mmu *mmu)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+	kvm_pte_t locked_pte;
 
 	if (stage2_pte_is_locked(ctx->old)) {
 		/*
@@ -821,7 +821,9 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		return false;
 	}
 
-	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
+	locked_pte = FIELD_PREP(KVM_INVALID_PTE_TYPE_MASK,
+				KVM_INVALID_PTE_TYPE_LOCKED);
+	if (!stage2_try_set_pte(ctx, locked_pte))
 		return false;
 
 	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
@@ -946,7 +948,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!data->annotation)
 		new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	else
-		new = kvm_init_invalid_leaf_owner(data->owner_id);
+		new = data->pte_annot;
 
 	/*
 	 * Skip updating the PTE if we are trying to recreate the exact
@@ -1100,16 +1102,18 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
@@ -1118,7 +1122,10 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
2.52.0.457.g6b5491de43-goog

