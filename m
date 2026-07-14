Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594A5390CA2
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030419; cv=none; b=a6828PE/kCdon+GaWJ+T0gnqD2VJhEYrq6+bx9fqZIDHVuXMmOi/Mw1ArayV6mXkllc+u+Z2KQ+rhpA1ceg8Rwf+ddwBr6B6d7b80fkEJbbZL9bAUzeki5rqFNnf5cRvaZcOq3Jt2ezFJ2ygLHO445mAR0o78wsY+xozGiYi9L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030419; c=relaxed/simple;
	bh=IQR1Dv1T87h3rluP4EOjqIIc0OVDqRoRbfBoLL9DAnQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tvAzVV+5s0lHJl9sN+6kMzfgayWqDFKlHNOccU76mIjpMCuLqP8xmhGpXgmFiN+8Xx9ztIji/js/wBI8YIZtzSskZgQmi0jpYOGXDfOzOK/3xVJyKEAGddDM2+qUm+gDXKXBSsyZC9UJQRRwohfXpNLXV7mmMA2GREylAM0dJQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=GfqLBJum; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="GfqLBJum"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61BAC497;
	Tue, 14 Jul 2026 05:00:12 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F2503F93E;
	Tue, 14 Jul 2026 05:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030416; bh=IQR1Dv1T87h3rluP4EOjqIIc0OVDqRoRbfBoLL9DAnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GfqLBJumVoE8E1s01F+ZhXkKTS4V1PXEk5c8kEgM0BWil1b2Y6ulWkZt+avz3Aoer
	 n69TDCqmjtZz6IEU/kTWlCQhjdJV/2XGaeTGul1aiL3a7SMg/wRpwhWSOQ+AOaidrC
	 bTca6vNTj68SKF+ShWE0X2q3VFRA386mtdwoaHRE=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	Sebastian Ene <sebastianene@google.com>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v4 6/6] KVM: arm64: nv: Create nested IPA direct map to speed up reverse map removal
Date: Tue, 14 Jul 2026 12:59:25 +0100
Message-ID: <20260714115926.2044757-7-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260714115926.2044757-1-weilin.chang@arm.com>
References: <20260714115926.2044757-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Iterating through the whole reverse map to find which entries to remove
when handling guest hypervisor TLBIs is not efficient. Create a direct
map that goes from nested IPA to canonical IPA so that the canonical
IPA range affected by the TLBI can be quickly determined, then remove
the entries in the reverse map accordingly.

Since insertion and deletion to the maple tree aren't guaranteed to
succeed, the direct map is implemented best-effort, and we always check
the direct mapping and the reverse mapping are symmetric (they store the
same mapping in reverse) before removing the reverse mapping.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   5 ++
 arch/arm64/kvm/mmu.c              |   9 +-
 arch/arm64/kvm/nested.c           | 131 ++++++++++++++++++++++--------
 3 files changed, 108 insertions(+), 37 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 42ab121a04f8..9b385897c352 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -230,6 +230,11 @@ struct kvm_s2_mmu {
 	bool	nested_revmap_broken;
 	/* canonical IPA to nested IPA range lookup */
 	struct maple_tree nested_revmap_mt;
+	/*
+	 * Nested IPA to canonical IPA range lookup, essentially a cache of
+	 * the guest's stage-2.
+	 */
+	struct maple_tree nested_direct_mt;
 
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6bfc1fbc5387..b0cca48040c4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1128,6 +1128,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
@@ -1138,8 +1139,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	}
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
-		if (!mtree_empty(revmap_mt))
-			mtree_destroy(revmap_mt);
+		if (!mtree_empty(revmap_mt) || !mtree_empty(direct_mt)) {
+			mtree_lock(revmap_mt);
+			__mt_destroy(revmap_mt);
+			__mt_destroy(direct_mt);
+			mtree_unlock(revmap_mt);
+		}
 		kvm_init_nested_s2_mmu(mmu);
 	}
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index cd93793fe89d..975a1b38d545 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -47,14 +47,14 @@ struct vncr_tlb {
 #define S2_MMU_PER_VCPU		2
 
 /*
- * Per shadow S2 reverse map (canonical IPA -> nested IPA range) maple tree
- * payload layout:
+ * Per shadow S2 reverse & direct map maple tree payload layout:
  *
- * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
+ * bit  62:     valid, prevents the case where the address is 0 and turning
  *              the whole value to 0 (NULL for maple tree)
- * bits 55-12:  nested IPA bits 55-12
+ * bits 55-12:  {nested, canonical} IPA bits 55-12
  * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
- *              IPA maps to this canonical IPA in the shadow stage-2
+ *              IPA maps to this canonical IPA in the shadow stage-2, only used
+ *              in reverse map
  */
 #define VALID_ENTRY		BIT(62)
 #define ADDR_MASK		GENMASK_ULL(55, 12)
@@ -127,12 +127,18 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 	swap(kvm->arch.nested_mmus, tmp);
 
 	/*
-	 * If we went through a realocation, adjust the MMU back-pointers in
-	 * the previously initialised kvm_pgtable structures.
+	 * If we went through a reallocation, adjust pointers in the
+	 * previously initialised MMUs.
 	 */
-	if (kvm->arch.nested_mmus != tmp)
-		for (int i = 0; i < kvm->arch.nested_mmus_size; i++)
-			kvm->arch.nested_mmus[i].pgt->mmu = &kvm->arch.nested_mmus[i];
+	if (kvm->arch.nested_mmus != tmp) {
+		for (int i = 0; i < kvm->arch.nested_mmus_size; i++) {
+			struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+			mmu->pgt->mmu = &kvm->arch.nested_mmus[i];
+			mt_set_external_lock(&mmu->nested_direct_mt,
+					     &mmu->nested_revmap_mt.ma_lock);
+		}
+	}
 
 	for (int i = kvm->arch.nested_mmus_size; !ret && i < num_mmus; i++)
 		ret = init_nested_s2_mmu(kvm, &kvm->arch.nested_mmus[i]);
@@ -875,36 +881,61 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 nested_ipa, size_t size)
 {
 	/*
-	 * Iterate through the mt of this mmu, remove all canonical ipa ranges
-	 * with !UNKNOWN_IPA that maps to ranges that are strictly within
-	 * [addr, addr + size).
+	 * Remove the reverse map and its corresponding direct map together,
+	 * when these conditions are met:
+	 *
+	 * 1. The reverse map is valid (not UNKNOWN_IPA).
+	 * 2. The reverse map is completely covered by the TLBI range.
+	 * 3. The reverse map and the direct map are symmetric i.e. they map to
+	 *    each other, with the same size.
+	 *
+	 * The symmetry check ensures we don't remove wrong reverse mappings.
 	 */
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
-	u64 entry_val, nested_ipa_end = nested_ipa + size;
-	u64 this_nested_ipa, this_nested_ipa_end;
-	size_t revmap_size;
-	void *entry;
-
-	MA_STATE(mas_rmap, revmap_mt, 0, ULONG_MAX);
-
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	gpa_t nested_ipa_end = nested_ipa + size - 1;
+	u64 entry_dmap;
+	struct mapping {
+		u64 from;
+		u64 to;
+		size_t size;
+	};
+
+	MA_STATE(mas_dmap, direct_mt, nested_ipa, nested_ipa_end);
 	mtree_lock(revmap_mt);
-	mas_for_each(&mas_rmap, entry, ULONG_MAX) {
-		entry_val = xa_to_value(entry);
-		if (unknown_ipa_entry(entry_val))
-			continue;
+	entry_dmap = xa_to_value(mas_find(&mas_dmap, nested_ipa_end));
 
-		revmap_size = mas_rmap.last - mas_rmap.index + 1;
-		this_nested_ipa = entry_val & ADDR_MASK;
-		this_nested_ipa_end = this_nested_ipa + revmap_size;
+	while (entry_dmap && mas_dmap.index <= nested_ipa_end) {
+		struct mapping dmap, rmap;
+		u64 entry_rmap;
 
-		if (this_nested_ipa >= nested_ipa &&
-		    this_nested_ipa_end <= nested_ipa_end) {
-			/*
-			 * Ignore result, failure to remove reverse mapping will
-			 * only cause extra unmaps.
-			 */
+		dmap.from = mas_dmap.index;
+		dmap.to   = entry_dmap & ADDR_MASK;
+		dmap.size = mas_dmap.last - mas_dmap.index + 1;
+
+		/*
+		 * Use the canonical ipa range to find the corresponding entry
+		 * in revmap.
+		 */
+		MA_STATE(mas_rmap, revmap_mt, dmap.to, dmap.to + dmap.size - 1);
+		entry_rmap = xa_to_value(mas_find(&mas_rmap,
+						       dmap.to + dmap.size - 1));
+
+		rmap.from = mas_rmap.index;
+		rmap.to   = entry_rmap & ADDR_MASK;
+		rmap.size = mas_rmap.last - mas_rmap.index + 1;
+
+		/* The three conditions outlined above. */
+		if (entry_rmap && valid_entry(entry_rmap) &&
+		    dmap.from >= nested_ipa &&
+		    dmap.from + dmap.size - 1 <= nested_ipa_end &&
+		    dmap.from == rmap.to &&
+		    rmap.from == dmap.to &&
+		    dmap.size == rmap.size) {
+			mas_store_gfp(&mas_dmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 			mas_store_gfp(&mas_rmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 		}
+		entry_dmap = xa_to_value(mas_find(&mas_dmap, nested_ipa_end));
 	}
 	mtree_unlock(revmap_mt);
 }
@@ -913,7 +944,8 @@ void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
 			      gpa_t nested_ipa, size_t map_size)
 {
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
-	gpa_t canonical_ipa_end;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	gpa_t canonical_ipa_end, nested_ipa_end;
 	u64 entry, new_entry = 0;
 
 	lockdep_assert_held_read(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
@@ -925,7 +957,9 @@ void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
 		canonical_ipa = ALIGN_DOWN(canonical_ipa, map_size);
 
 	canonical_ipa_end = canonical_ipa + map_size - 1;
+	nested_ipa_end = nested_ipa + map_size - 1;
 	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
+	MA_STATE(mas_dmap, direct_mt, nested_ipa, nested_ipa_end);
 
 	mtree_lock(revmap_mt);
 	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
@@ -960,6 +994,15 @@ void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
 					       nested_ipa, new_entry);
 		mmu->nested_revmap_broken = true;
 	}
+
+	/*
+	 * Add direct map but ignore the result, missing a direct map does not
+	 * affect correctness.
+	 */
+	if (valid_entry(new_entry) && !mmu->nested_revmap_broken)
+		mas_store_gfp(&mas_dmap, xa_mk_value(canonical_ipa | VALID_ENTRY),
+			      GFP_NOWAIT | __GFP_ACCOUNT);
+
 unlock:
 	mtree_unlock(revmap_mt);
 }
@@ -971,6 +1014,8 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
 	mt_init(&mmu->nested_revmap_mt);
+	mt_init_flags(&mmu->nested_direct_mt, MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&mmu->nested_direct_mt, &mmu->nested_revmap_mt.ma_lock);
 	mmu->nested_revmap_broken = false;
 }
 
@@ -1349,7 +1394,10 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 
 static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
 {
-	mtree_destroy(&mmu->nested_revmap_mt);
+	mtree_lock(&mmu->nested_revmap_mt);
+	__mt_destroy(&mmu->nested_revmap_mt);
+	__mt_destroy(&mmu->nested_direct_mt);
+	mtree_unlock(&mmu->nested_revmap_mt);
 	mmu->nested_revmap_broken = false;
 	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 }
@@ -1357,12 +1405,15 @@ static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
 static void unmap_mmu_cipa_range(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 				  size_t unmap_size, bool may_block)
 {
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
 	gpa_t canonical_ipa_end = canonical_ipa + unmap_size - 1;
+	gpa_t nested_ipa, nested_ipa_end;
 	size_t entry_size;
 	gpa_t next_addr;
 	u64 entry;
 	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
+	MA_STATE(mas_dmap, direct_mt, 0, ULONG_MAX);
 
 	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
@@ -1398,6 +1449,16 @@ static void unmap_mmu_cipa_range(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
 		 */
 		mas_store_gfp(&mas_rmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 
+		/*
+		 * Try to also remove the direct map, it is okay if this fails,
+		 * as we check for direct map consistency in
+		 * kvm_remove_nested_revmap().
+		 */
+		nested_ipa = entry & ADDR_MASK;
+		nested_ipa_end = nested_ipa + entry_size - 1;
+		mas_set_range(&mas_dmap, nested_ipa, nested_ipa_end);
+		mas_store_gfp(&mas_dmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
+
 		mtree_unlock(revmap_mt);
 		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
 				       may_block);
-- 
2.43.0

