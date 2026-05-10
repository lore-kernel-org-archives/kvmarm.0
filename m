Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1870B39EF2F
	for <kvmarm@lists.linux.dev>; Sun, 10 May 2026 14:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424867; cv=none; b=HiO3m2mWo1mTZLKOmraXycZLsnIsS+MInat5JYPc9rjGnrdhLNZRNYCihm+p7V8HNfqq2AAVcZoTni50k4ceuWMOPbN52/4sCuQD60JLAv6GnP/rU76jmCHlebrq8MPVMuX5enn8iZQc13zz8S7LC/ijs+nPtCb53KiXuRkctb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424867; c=relaxed/simple;
	bh=9fm0S8CwEDchTPXPyF4feAMGPKEjd0k5sn0tF2wpAv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRz+NO6cEXBkyBOUEScxV9JJ4qfz4juvwAtm/cCSVc4yQeUnZKrTch1NIq1oiLLSBTmpUuACTrKarhqxOoqSKrqeG3XXXmbdA69E+Bxy4I7oltH/ze7WlgE7frRdwX6z/skJuWeeyGWB+I4FS1+ZHxQ3KbptrlrY2Si+fAA5hPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=S+1BdtcH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="S+1BdtcH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AC15293F;
	Sun, 10 May 2026 07:54:18 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FD0B3F836;
	Sun, 10 May 2026 07:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778424863; bh=9fm0S8CwEDchTPXPyF4feAMGPKEjd0k5sn0tF2wpAv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S+1BdtcHphWSuGmGikwmK3uKHitEkieD6gB1ej5+6DjUKPMO4AdW69jO61hwYe2tn
	 4YUPztVVIhwKjnDyNMXPUGOhILcSMLFV6Wg5iPOTog3RG1ksn7ytAdi0hXQIDkrJn1
	 HUGTStmW9Tt3sDabDQd15ZRy+Z5tOWhnYpCIv5Qg=
From: Wei-Lin Chang <weilin.chang@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Wei-Lin Chang <weilin.chang@arm.com>
Subject: [PATCH v3 5/5] KVM: arm64: nv: Create nested IPA direct map to speed up reverse map removal
Date: Sun, 10 May 2026 15:53:38 +0100
Message-ID: <20260510145338.322962-6-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260510145338.322962-1-weilin.chang@arm.com>
References: <20260510145338.322962-1-weilin.chang@arm.com>
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

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   5 ++
 arch/arm64/kvm/mmu.c              |   9 ++-
 arch/arm64/kvm/nested.c           | 124 ++++++++++++++++++++++--------
 3 files changed, 104 insertions(+), 34 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index dc4c0bce1bbb..f9e95a023ec4 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -226,6 +226,11 @@ struct kvm_s2_mmu {
 	bool	nested_revmap_broken;
 	/* canonical IPA to nested IPA range lookup */
 	struct maple_tree nested_revmap_mt;
+	/*
+	 * Nested IPA to canonical IPA range lookup, essentially a cache of
+	 * the guest's stage-2.
+	 */
+	struct maple_tree nested_direct_mt;
 
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	struct dentry *shadow_pt_debugfs_dentry;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index ce0bd88cd3c1..77146431be6d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1101,6 +1101,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
@@ -1111,8 +1112,12 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
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
index 96b88d9c0c2a..fcb6a88047e1 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -45,14 +45,14 @@ struct vncr_tlb {
 #define S2_MMU_PER_VCPU		2
 
 /*
- * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
- * layout:
+ * Per shadow S2 reverse & direct map maple tree payload layout:
  *
- * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
+ * bit  62:     valid, prevents the case where the address is 0 and turning
  *              the whole value to 0
- * bits 55-12:  nested IPA bits 55-12
+ * bits 55-12:  {nested, canonical} IPA bits 55-12
  * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
- *              IPA maps to this canonical IPA in the shadow stage-2
+ *              IPA maps to this canonical IPA in the shadow stage-2, only used
+ *              in reverse map
  */
 #define VALID_ENTRY		BIT(62)
 #define ADDR_MASK		GENMASK_ULL(55, 12)
@@ -787,37 +787,67 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 nested_ipa, size_t size)
 {
 	/*
-	 * Iterate through the mt of this mmu, remove all canonical ipa ranges
-	 * with !UNKNOWN_IPA that maps to ranges that are strictly within
-	 * [addr, addr + size).
+	 * For all ranges in direct_mt that are completely covered by the range
+	 * we are TLBIing [gpa, gpa + size), remove the reverse map and its
+	 * corresponding direct map together, when these conditions are met:
+	 *
+	 * 1. The reverse map is not UNKNOWN_IPA.
+	 * 2. The reverse map is completely covered by the TLBI range.
+	 * 3. The reverse map and the direct map are symmetric i.e. they map to
+	 *    each other, with the same size.
+	 *
+	 * Symmetry must be checked because there are three places where the
+	 * direct map could become inconsistent:
+	 *
+	 * 1. Direct map removal failure during an mmu notifier in
+	 *    unmap_mmu_ipa_range().
+	 * 2. Direct map insertion failure during an s2 fault in
+	 *    kvm_record_nested_revmap().
+	 * 3. Direct map removal failure during a previous call of this very
+	 *    function.
 	 */
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
-	void *entry;
-	u64 entry_val, nested_ipa_end = nested_ipa + size;
-	u64 this_nested_ipa, this_nested_ipa_end;
-	size_t revmap_size;
-
-	MA_STATE(mas_rev, revmap_mt, 0, ULONG_MAX);
-
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	gpa_t nested_ipa_end = nested_ipa + size - 1;
+	u64 entry_dir;
+	struct mapping {
+		u64 from;
+		u64 to;
+		size_t size;
+	};
+
+	MA_STATE(mas_dir, direct_mt, nested_ipa, nested_ipa_end);
 	mtree_lock(revmap_mt);
-	mas_for_each(&mas_rev, entry, ULONG_MAX) {
-		entry_val = xa_to_value(entry);
-		if (entry_val & UNKNOWN_IPA)
-			continue;
-
-		revmap_size = mas_rev.last - mas_rev.index + 1;
-		this_nested_ipa = entry_val & ADDR_MASK;
-		this_nested_ipa_end = this_nested_ipa + revmap_size;
-
-		if (this_nested_ipa >= nested_ipa &&
-		    this_nested_ipa_end <= nested_ipa_end) {
-			/*
-			 * As the shadow stage-2 is about to be unmapped
-			 * after this function, it doesn't matter whether the
-			 * removal of the reverse map failed or not.
-			 */
+	entry_dir = xa_to_value(mas_find_range(&mas_dir, nested_ipa_end));
+
+	while (entry_dir && mas_dir.index <= nested_ipa_end) {
+		struct mapping dir, rev;
+		u64 entry_rev;
+
+		dir.from = mas_dir.index;
+		dir.to   = entry_dir & ADDR_MASK;
+		dir.size = mas_dir.last - mas_dir.index + 1;
+
+		/* Use ipa range to find the corresponding entry in revmap. */
+		MA_STATE(mas_rev, revmap_mt, dir.to, dir.to + dir.size - 1);
+		entry_rev = xa_to_value(mas_find_range(&mas_rev,
+						       dir.to + dir.size - 1));
+
+		rev.from = mas_rev.index;
+		rev.to   = entry_rev & ADDR_MASK;
+		rev.size = mas_rev.last - mas_rev.index + 1;
+
+		/* The three conditions outlined above. */
+		if (entry_rev && !(entry_rev & UNKNOWN_IPA) &&
+		    dir.from >= nested_ipa &&
+		    dir.from + dir.size - 1 <= nested_ipa_end &&
+		    dir.from == rev.to &&
+		    rev.from == dir.to &&
+		    dir.size == rev.size) {
+			mas_store_gfp(&mas_dir, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 			mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 		}
+		entry_dir = xa_to_value(mas_find_range(&mas_dir, nested_ipa_end));
 	}
 	mtree_unlock(revmap_mt);
 }
@@ -826,9 +856,12 @@ void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 			      gpa_t fault_ipa, size_t map_size)
 {
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
 	gpa_t ipa_end = ipa + map_size - 1;
+	gpa_t fault_ipa_end = fault_ipa + map_size - 1;
 	u64 entry, new_entry = 0;
 	MA_STATE(mas_rev, revmap_mt, ipa, ipa_end);
+	MA_STATE(mas_dir, direct_mt, fault_ipa, fault_ipa_end);
 
 	if (mmu->nested_revmap_broken)
 		return;
@@ -861,6 +894,15 @@ void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 	if (mas_store_gfp(&mas_rev, xa_mk_value(new_entry),
 			  GFP_NOWAIT | __GFP_ACCOUNT))
 		mmu->nested_revmap_broken = true;
+
+	/*
+	 * Add direct map but ignore the result, missing a direct map does not
+	 * affect correctness.
+	 */
+	if (new_entry & VALID_ENTRY && !mmu->nested_revmap_broken)
+		mas_store_gfp(&mas_dir, xa_mk_value(ipa | VALID_ENTRY),
+			      GFP_NOWAIT | __GFP_ACCOUNT);
+
 unlock:
 	mtree_unlock(revmap_mt);
 }
@@ -872,6 +914,8 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
 	mt_init(&mmu->nested_revmap_mt);
+	mt_init_flags(&mmu->nested_direct_mt, MT_FLAGS_LOCK_EXTERN);
+	mt_set_external_lock(&mmu->nested_direct_mt, &mmu->nested_revmap_mt.ma_lock);
 	mmu->nested_revmap_broken = false;
 }
 
@@ -1250,7 +1294,10 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 
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
@@ -1259,11 +1306,14 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 				  size_t unmap_size, bool may_block)
 {
 	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
 	gpa_t ipa = gpa;
 	gpa_t ipa_end = gpa + unmap_size - 1;
+	gpa_t nested_ipa, nested_ipa_end;
 	u64 entry;
 	size_t entry_size;
 	MA_STATE(mas_rev, revmap_mt, gpa, ipa_end);
+	MA_STATE(mas_dir, direct_mt, 0, ULONG_MAX);
 
 	if (mmu->nested_revmap_broken) {
 		reset_revmap_and_unmap(mmu, may_block);
@@ -1292,6 +1342,16 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 		 */
 		mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
 
+		/*
+		 * Try to also remove the direct map, it is okay if this fails,
+		 * as we check for direct map consistency in
+		 * kvm_remove_nested_revmap().
+		 */
+		nested_ipa = entry & ADDR_MASK;
+		nested_ipa_end = nested_ipa + entry_size - 1;
+		mas_set_range(&mas_dir, nested_ipa, nested_ipa_end);
+		mas_store_gfp(&mas_dir, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
+
 		mtree_unlock(revmap_mt);
 		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
 				       may_block);
-- 
2.43.0

