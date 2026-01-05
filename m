Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3EB13B293
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628243; cv=none; b=M8yf8z/F6TpveQfvQ2dkMZ2PLDumQVcDdSO7jNa+Qy823oKq2A29dpoppzf8d/G+cJ83kEO3Y5kiUlbpPyPFjukM1Bc2tiOlqLZGg3m3+qVi+umtkScg9Yc0gIhS88CEE7EONnG0HZsnsbORdCOg1/cKAiGCVZNw+9mIKnmPyiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628243; c=relaxed/simple;
	bh=qoVYpen1ot9+zckdKOrRl6patLQCwhmwP11TPG1QGCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=An+zVot1MlbRAcnuQ6CS3XGlvLuJ4kp3mz2eX8lfUHFcRtvrUDbHejwLzfF1xM20u+tbidEEdtsSaIprSOgn8u3eQt0RAf5BWr3gnbCviS5y+BD3U2U7tEeDnVGWJaF0vRR++in6+2+rbrpJmuTMY8fdgzuzhukFeGwzY9xosag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o37UXH+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o37UXH+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58034C2BC86;
	Mon,  5 Jan 2026 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628242;
	bh=qoVYpen1ot9+zckdKOrRl6patLQCwhmwP11TPG1QGCc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o37UXH+d2UdpG3NYHzvxp1n7iRvDGlDwM740z0eYCdJJ3rKQlbWsoYvNkxUoC4k57
	 2PBilLB6dRXoAgJ1YCh8rUo+ZOhfPApI8vpP0n0ld6zoVbV3BzwA2XMpTzUUOO5AsA
	 GcdOdiwjuRJmxQs8M2AcNoeQno9Fc8ex7jDG0IoCSab9bBqBBVeGbVM08F+rvGSNdW
	 JEEkPYqiavWtVLw5ewdcJrOFqHo13lfKVAKp0O1+XuxHhpH8e2II+G2n5jk7i3X4G+
	 q636v6YpY3ifvbEsN7ZhcwrIl5x0j5Qz0lMFd5IpEVKw5f5nqr4B8/ivvcA8gKKPie
	 zd8uRf5R2crew==
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
Subject: [PATCH 17/30] KVM: arm64: Generalise kvm_pgtable_stage2_set_owner()
Date: Mon,  5 Jan 2026 15:49:25 +0000
Message-ID: <20260105154939.11041-18-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260105154939.11041-1-will@kernel.org>
References: <20260105154939.11041-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kvm_pgtable_stage2_set_owner() can be generalised into a way to store
up to 62 bits in the page tables, as long as we don't set the 'valid' or
KVM_INVALID_PTE_LOCKED bits.

Let's do that and reduce the owner field to 4 bits to free up more
annotation space for future work.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 21 +++++++++++++--------
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 14 ++++++++++++--
 arch/arm64/kvm/hyp/pgtable.c          | 17 ++++++-----------
 3 files changed, 31 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 9ce55442b621..ddbe0e506e4c 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -97,14 +97,17 @@ typedef u64 kvm_pte_t;
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
-#define KVM_MAX_OWNER_ID		3
+/* pKVM invalid pte encodings */
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(4, 1)
+#define KVM_INVALID_PTE_EXTRA_MASK	GENMASK(62, 5)
+#define KVM_INVALID_PTE_ANNOT_MASK	(KVM_INVALID_PTE_OWNER_MASK | \
+					 KVM_INVALID_PTE_EXTRA_MASK)
 
 /*
  * Used to indicate a pte for which a 'break-before-make' sequence is in
  * progress.
  */
-#define KVM_INVALID_PTE_LOCKED		BIT(10)
+#define KVM_INVALID_PTE_LOCKED		BIT(63)
 
 static inline bool kvm_pte_valid(kvm_pte_t pte)
 {
@@ -657,14 +660,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
+ * @annotation:	A 62-bit value that will be stored in the page tables.
+ *		@annotation[0] and @annotation[63] must be 0.
+ * 		@annotation[62:1] is stored in the page tables.
  *
  * By default, all page-tables are owned by identifier 0. This function can be
  * used to mark portions of the IPA space as owned by other entities. When a
@@ -673,8 +678,8 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
  *
  * Return: 0 on success, negative error code on failure.
  */
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id);
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t annotation);
 
 /**
  * kvm_pgtable_stage2_unmap() - Remove a mapping from a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0336143cbb24..6c32bdc689ed 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -539,15 +539,25 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
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
 	int ret;
 
+	if (!FIELD_FIT(KVM_INVALID_PTE_OWNER_MASK, owner_id))
+		return -EINVAL;
+
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
-	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-			      addr, size, &host_s2_pool, owner_id);
+	annotation = kvm_init_invalid_leaf_owner(owner_id);
+	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
+			      addr, size, &host_s2_pool, annotation);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 9abc0a6cf448..749ee5863601 100644
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
@@ -946,7 +941,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!data->annotation)
 		new = kvm_init_valid_leaf_pte(phys, data->attr, ctx->level);
 	else
-		new = kvm_init_invalid_leaf_owner(data->owner_id);
+		new = data->pte_annot;
 
 	/*
 	 * Skip updating the PTE if we are trying to recreate the exact
@@ -1100,16 +1095,16 @@ int kvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
-int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
-				 void *mc, u8 owner_id)
+int kvm_pgtable_stage2_annotate(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				void *mc, kvm_pte_t pte_annot)
 {
 	int ret;
 	struct stage2_map_data map_data = {
 		.mmu		= pgt->mmu,
 		.memcache	= mc,
-		.owner_id	= owner_id,
 		.force_pte	= true,
 		.annotation	= true,
+		.pte_annot	= pte_annot,
 	};
 	struct kvm_pgtable_walker walker = {
 		.cb		= stage2_map_walker,
@@ -1118,7 +1113,7 @@ int kvm_pgtable_stage2_set_owner(struct kvm_pgtable *pgt, u64 addr, u64 size,
 		.arg		= &map_data,
 	};
 
-	if (owner_id > KVM_MAX_OWNER_ID)
+	if (pte_annot & ~KVM_INVALID_PTE_ANNOT_MASK)
 		return -EINVAL;
 
 	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
-- 
2.52.0.351.gbe84eed79e-goog

