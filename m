Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA423376A7
	for <kvmarm@lists.linux.dev>; Wed, 10 Sep 2025 18:09:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757527787; cv=none; b=GL40pDHY4jaFjDq9CS241R4z5Ac6z08TwQ6W2rh4rv4d1QfuW4vERuWb/McOD1YVyv0FEcsdDVx2QT5PWJjKog9dp3NmTJkweoUxJRFmcQlVtlvn9AuGymbrB4QCGi5qiyjduAHLk7yHkQxpQn30rUaL3ervKlVsvcZcLL3K0sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757527787; c=relaxed/simple;
	bh=rXWJqJft9qRnT37sROgBw2BQpz8y+zR3s63eK3zyYk8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jOyhiIWNzA7VBxoqrHdQ6xoKCmLmqr+Tb9KvgRkbAgkI6KzzcJ7SANkSLnvwoujdimX9IwKRaX/wfmGZyy4wW+0paT10q2XI/D6TUNb35qAUMrNWb7reseut8HRaZyCJi17EGH8I/4yE1bTdONId9YJB5s5ACn/JOLKboO575ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=D6mC7ZQE; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="D6mC7ZQE"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757527783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3/3NYCrYU10OqzVNnB/rKIXIMaH0ha49X1JhZ9LVGNU=;
	b=D6mC7ZQENO+iejZB3g8lmOIejqgl9/hN0mKc8WRNHrTYWtOfEhItqKLxyENBafIRnaHZoi
	w9sQw1unrQneB83S4VuGMOWZPD0qIKymK7C+vNfpKYEAKte4rWMhcEiHmizZNWCmoO5mU4
	JKwH1ifJCy0kME2/azcZ6LWcciqeEZs=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/2] Revert "KVM: arm64: Split kvm_pgtable_stage2_destroy()"
Date: Wed, 10 Sep 2025 11:09:29 -0700
Message-Id: <20250910180930.3679473-3-oliver.upton@linux.dev>
In-Reply-To: <20250910180930.3679473-1-oliver.upton@linux.dev>
References: <20250910180930.3679473-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

This reverts commit 0e89ca13ee5ff41b437bb2a003c0eaf34ea43555.

The functional change that depended on this refactoring has been found
to be quite problematic. Reverting the whole pile to start fresh when
new fixes are available.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_pgtable.h | 30 ----------------------------
 arch/arm64/include/asm/kvm_pkvm.h    |  4 +---
 arch/arm64/kvm/hyp/pgtable.c         | 25 ++++-------------------
 arch/arm64/kvm/mmu.c                 | 12 ++---------
 arch/arm64/kvm/pkvm.c                | 11 ++--------
 5 files changed, 9 insertions(+), 73 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 1246216616b5..2888b5d03757 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -355,11 +355,6 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return pteref;
 }
 
-static inline kvm_pte_t *kvm_dereference_pteref_raw(kvm_pteref_t pteref)
-{
-	return pteref;
-}
-
 static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	/*
@@ -389,11 +384,6 @@ static inline kvm_pte_t *kvm_dereference_pteref(struct kvm_pgtable_walker *walke
 	return rcu_dereference_check(pteref, !(walker->flags & KVM_PGTABLE_WALK_SHARED));
 }
 
-static inline kvm_pte_t *kvm_dereference_pteref_raw(kvm_pteref_t pteref)
-{
-	return rcu_dereference_raw(pteref);
-}
-
 static inline int kvm_pgtable_walk_begin(struct kvm_pgtable_walker *walker)
 {
 	if (walker->flags & KVM_PGTABLE_WALK_SHARED)
@@ -561,26 +551,6 @@ static inline int kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2
  */
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
-/**
- * kvm_pgtable_stage2_destroy_range() - Destroy the unlinked range of addresses.
- * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_init*().
- * @addr:      Intermediate physical address at which to place the mapping.
- * @size:      Size of the mapping.
- *
- * The page-table is assumed to be unreachable by any hardware walkers prior
- * to freeing and therefore no TLB invalidation is performed.
- */
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
-
-/**
- * kvm_pgtable_stage2_destroy_pgd() - Destroy the PGD of guest stage-2 page-table.
- * @pgt:       Page-table structure initialised by kvm_pgtable_stage2_init*().
- *
- * It is assumed that the rest of the page-table is freed before this operation.
- */
-void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
-
 /**
  * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
  * @mm_ops:	Memory management callbacks.
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index 35f9d9478004..ea58282f59bb 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -179,9 +179,7 @@ struct pkvm_mapping {
 
 int pkvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			     struct kvm_pgtable_mm_ops *mm_ops);
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size);
-void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt);
+void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size, u64 phys,
 			    enum kvm_pgtable_prot prot, void *mc,
 			    enum kvm_pgtable_walk_flags flags);
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c36f282a175d..c351b4abd5db 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1551,38 +1551,21 @@ static int stage2_free_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
-void kvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-				       u64 addr, u64 size)
+void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 {
+	size_t pgd_sz;
 	struct kvm_pgtable_walker walker = {
 		.cb	= stage2_free_walker,
 		.flags	= KVM_PGTABLE_WALK_LEAF |
 			  KVM_PGTABLE_WALK_TABLE_POST,
 	};
 
-	WARN_ON(kvm_pgtable_walk(pgt, addr, size, &walker));
-}
-
-void kvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-{
-	size_t pgd_sz;
-
+	WARN_ON(kvm_pgtable_walk(pgt, 0, BIT(pgt->ia_bits), &walker));
 	pgd_sz = kvm_pgd_pages(pgt->ia_bits, pgt->start_level) * PAGE_SIZE;
-
-	/*
-	 * Since the pgtable is unlinked at this point, and not shared with
-	 * other walkers, safely deference pgd with kvm_dereference_pteref_raw()
-	 */
-	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref_raw(pgt->pgd), pgd_sz);
+	pgt->mm_ops->free_pages_exact(kvm_dereference_pteref(&walker, pgt->pgd), pgd_sz);
 	pgt->pgd = NULL;
 }
 
-void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
-{
-	kvm_pgtable_stage2_destroy_range(pgt, 0, BIT(pgt->ia_bits));
-	kvm_pgtable_stage2_destroy_pgd(pgt);
-}
-
 void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, s8 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6330a02c8418..9a45daf817bf 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -904,14 +904,6 @@ static int kvm_init_ipa_range(struct kvm_s2_mmu *mmu, unsigned long type)
 	return 0;
 }
 
-static void kvm_stage2_destroy(struct kvm_pgtable *pgt)
-{
-	unsigned int ia_bits = VTCR_EL2_IPA(pgt->mmu->vtcr);
-
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_range)(pgt, 0, BIT(ia_bits));
-	KVM_PGT_FN(kvm_pgtable_stage2_destroy_pgd)(pgt);
-}
-
 /**
  * kvm_init_stage2_mmu - Initialise a S2 MMU structure
  * @kvm:	The pointer to the KVM structure
@@ -988,7 +980,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	return 0;
 
 out_destroy_pgtable:
-	kvm_stage2_destroy(pgt);
+	KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
 out_free_pgtable:
 	kfree(pgt);
 	return err;
@@ -1085,7 +1077,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	write_unlock(&kvm->mmu_lock);
 
 	if (pgt) {
-		kvm_stage2_destroy(pgt);
+		KVM_PGT_FN(kvm_pgtable_stage2_destroy)(pgt);
 		kfree(pgt);
 	}
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 61827cf6fea4..fcd70bfe44fb 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -316,16 +316,9 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 	return 0;
 }
 
-void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
-					u64 addr, u64 size)
+void pkvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 {
-	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
-}
-
-void pkvm_pgtable_stage2_destroy_pgd(struct kvm_pgtable *pgt)
-{
-	/* Expected to be called after all pKVM mappings have been released. */
-	WARN_ON_ONCE(!RB_EMPTY_ROOT(&pgt->pkvm_mappings.rb_root));
+	__pkvm_pgtable_stage2_unmap(pgt, 0, ~(0ULL));
 }
 
 int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
-- 
2.39.5

