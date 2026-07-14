Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C654E385521
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 12:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784030407; cv=none; b=GrAtfq7/ScvIh/c2UmsJPsIPjm/xBuJIhfMTpKYWR8OG5PhyqkzSbgLW8AIixNGii3VPRat6KDBZSOXKRSxRV5nCwHWzSU9rym28jaJb+BP7pPUkQyN70I9EdERZ+4AuUE9cd7wf28KlOcsfphiiojUDUaDCEaDZM51GTaISepU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784030407; c=relaxed/simple;
	bh=GPIPzN0jFwepejcD52PL/IcNSdWmNA3pYoGfSzQoRms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJlPT3YLc/i6cWtbfNvGzzVwlmh+8Gwy3V5/SbMTsh7lU+LOP/Tpl0aAXOB9T9K4OMRoeKVDkgzihu4NG7nz/wsvo1bj+ke3HTOgf0NMtBvBKdPtI0pH34yqzblKvx4IgV5KoOl17gcrnLS7XpjYoLF6m6PJ+fCOD5I5AFI1QXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Ak0Zk7fM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Ak0Zk7fM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EEBBC497;
	Tue, 14 Jul 2026 05:00:00 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9934C3F93E;
	Tue, 14 Jul 2026 05:00:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784030405; bh=GPIPzN0jFwepejcD52PL/IcNSdWmNA3pYoGfSzQoRms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ak0Zk7fM1suQ5CCrf7e2o3trFUtCJSqAv1yhepnVYZdve4RxnfKMDhW8fGfs1iWl5
	 D70VIKVDGh+oKTwAcdgQ1W0E5JS3VpaTWZIIIqaSwzYkvgyCmfMdirnkAw6A9dCAJ2
	 9fLbkwbyyt1HLDogCelkTrg1aHJfxcaEa7aHizhU=
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
Subject: [PATCH v4 2/6] KVM: arm64: nv: Avoid full shadow s2 unmap
Date: Tue, 14 Jul 2026 12:59:21 +0100
Message-ID: <20260714115926.2044757-3-weilin.chang@arm.com>
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

Currently we are forced to fully unmap all shadow stage-2 for a VM when
unmapping a page from the canonical stage-2, for example during an MMU
notifier call. This is because we are not tracking which canonical IPAs
are mapped in the shadow stage-2 page tables hence there is no way to
know what to unmap.

Create a per kvm_s2_mmu maple tree to track canonical IPA range ->
nested IPA range, so that it is possible to partially unmap shadow
stage-2 when a canonical IPA range is unmapped. The algorithm is simple
and conservative:

At each shadow stage-2 map, insert the nested IPA range into the maple
tree, with the canonical IPA range as the key. If the canonical IPA
range doesn't overlap with existing ranges in the tree, insert as is,
and a reverse mapping for this range is established. But if the
canonical IPA range overlaps with any existing ranges in the tree,
create a new range that spans all the overlapping ranges including the
input range and replace those existing ranges. In the meantime, mark
this new spanning canonical IPA range with an "UNKNOWN_IPA" bit,
indicating we give up tracking the nested IPA ranges that map to this
canonical IPA range.

The maple tree's 64-bit entry is enough to store the nested IPA and
the UNKNOWN_IPA status, therefore besides maple tree's internal
operation, memory allocation is avoided.

Example:
|||| means existing range, ---- means empty range

input:            $$$$$$$$$$$$$$$$$$$$$$$$$$
tree:  --||||-----|||||||---------||||||||||-----------

insert spanning range and replace overlapping ones:
       --||||-----||||||||||||||||||||||||||-----------
                  ^^^^marked UNKNOWN_IPA^^^^

With the reverse map created, when a canonical IPA range gets unmapped,
look into each s2 mmu's maple tree and look for canonical IPA ranges
affected, and based on their UNKNOWN_IPA status:

UNKNOWN_IPA     -> fall back and fully unmap the current shadow
                   stage-2, also clear the tree

not UNKNOWN_IPA -> unmap the nested IPA range, and remove the reverse
                   map entry

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/kvm_nested.h |   4 +
 arch/arm64/kvm/mmu.c                |  21 +++-
 arch/arm64/kvm/nested.c             | 167 +++++++++++++++++++++++++++-
 4 files changed, 190 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2faa60df847d..42ab121a04f8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -227,6 +227,10 @@ struct kvm_s2_mmu {
 	 */
 	bool	pending_unmap;
 
+	bool	nested_revmap_broken;
+	/* canonical IPA to nested IPA range lookup */
+	struct maple_tree nested_revmap_mt;
+
 	/*
 	 *  0: Nobody is currently using this, check vttbr for validity
 	 * >0: Somebody is actively using this.
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index cbdaaa2a2903..79de224f3438 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -77,6 +77,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 				       const union tlbi_info *info,
 				       void (*)(struct kvm_s2_mmu *,
 						const union tlbi_info *));
+extern void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
+				     gpa_t nested_ipa, size_t map_size);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
@@ -165,6 +167,8 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_unmap_cipa_range_nested(struct kvm *kvm, gpa_t canonical_ipa, size_t size,
+				       bool may_block);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 54395a608fd3..73629aa1ade6 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/maple_tree.h>
 #include <linux/mman.h>
 #include <linux/kvm_host.h>
 #include <linux/io.h>
@@ -1126,6 +1127,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
@@ -1135,8 +1137,11 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		free_percpu(mmu->last_vcpu_ran);
 	}
 
-	if (kvm_is_nested_s2_mmu(kvm, mmu))
+	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		if (!mtree_empty(revmap_mt))
+			mtree_destroy(revmap_mt);
 		kvm_init_nested_s2_mmu(mmu);
+	}
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -1670,6 +1675,9 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, s2fd->fault_ipa,
 								 prot, flags);
 	} else {
+		if (s2fd->nested)
+			kvm_record_nested_revmap(gfn << PAGE_SHIFT, pgt->mmu,
+						 s2fd->fault_ipa, PAGE_SIZE);
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
@@ -2074,6 +2082,10 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, gfn_to_gpa(gfn),
 								 prot, flags);
 	} else {
+		if (s2fd->nested)
+			kvm_record_nested_revmap(canonical_gpa, pgt->mmu,
+						 gfn_to_gpa(gfn), mapping_size);
+
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, gfn_to_gpa(gfn), mapping_size,
 							 __pfn_to_phys(pfn), prot,
 							 memcache, flags);
@@ -2435,8 +2447,9 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
-
-	kvm_nested_s2_unmap(kvm, range->may_block);
+	kvm_unmap_cipa_range_nested(kvm, range->start << PAGE_SHIFT,
+				    (range->end - range->start) << PAGE_SHIFT,
+				    range->may_block);
 	return false;
 }
 
@@ -2714,7 +2727,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
-	kvm_nested_s2_unmap(kvm, true);
+	kvm_unmap_cipa_range_nested(kvm, gpa, size, true);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 94df26de6990..065823e415ce 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -7,6 +7,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/maple_tree.h>
 
 #include <asm/fixmap.h>
 #include <asm/kvm_arm.h>
@@ -44,6 +45,32 @@ struct vncr_tlb {
  */
 #define S2_MMU_PER_VCPU		2
 
+/*
+ * Per shadow S2 reverse map (canonical IPA -> nested IPA range) maple tree
+ * payload layout:
+ *
+ * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
+ *              the whole value to 0 (NULL for maple tree)
+ * bits 55-12:  nested IPA bits 55-12
+ * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
+ *              IPA maps to this canonical IPA in the shadow stage-2
+ */
+#define VALID_ENTRY		BIT(62)
+#define ADDR_MASK		GENMASK_ULL(55, 12)
+#define UNKNOWN_IPA		BIT(0)
+
+static bool valid_entry(unsigned long entry)
+{
+	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
+	return entry & VALID_ENTRY;
+}
+
+static bool unknown_ipa_entry(unsigned long entry)
+{
+	WARN_ON(entry & VALID_ENTRY && entry & UNKNOWN_IPA);
+	return entry & UNKNOWN_IPA;
+}
+
 void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
@@ -844,12 +871,65 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	return s2_mmu;
 }
 
+void kvm_record_nested_revmap(gpa_t canonical_ipa, struct kvm_s2_mmu *mmu,
+			      gpa_t nested_ipa, size_t map_size)
+{
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t canonical_ipa_end;
+	u64 entry, new_entry = 0;
+
+	lockdep_assert_held_read(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+
+	if (mmu->nested_revmap_broken)
+		return;
+
+	if (WARN_ON(!IS_ALIGNED(canonical_ipa, map_size)))
+		canonical_ipa = ALIGN_DOWN(canonical_ipa, map_size);
+
+	canonical_ipa_end = canonical_ipa + map_size - 1;
+	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
+
+	mtree_lock(revmap_mt);
+	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
+
+	if (entry) {
+		/* parallel faults can be adding the same mapping */
+		if (valid_entry(entry) &&
+		    mas_rmap.index == canonical_ipa &&
+		    mas_rmap.last == canonical_ipa_end &&
+		    nested_ipa == (entry & ADDR_MASK))
+			goto unlock;
+		/*
+		 * Create a "UNKNOWN_IPA" range that spans all the overlapping
+		 * ranges and store it.
+		 */
+		while (entry && mas_rmap.index <= canonical_ipa_end) {
+			canonical_ipa = min(mas_rmap.index, canonical_ipa);
+			canonical_ipa_end = max(mas_rmap.last, canonical_ipa_end);
+			entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
+		}
+		new_entry |= UNKNOWN_IPA;
+	} else {
+		new_entry |= nested_ipa;
+		new_entry |= VALID_ENTRY;
+	}
+
+	mas_set_range(&mas_rmap, canonical_ipa, canonical_ipa_end);
+	if (mas_store_gfp(&mas_rmap, xa_mk_value(new_entry),
+			  GFP_NOWAIT | __GFP_ACCOUNT))
+		mmu->nested_revmap_broken = true;
+unlock:
+	mtree_unlock(revmap_mt);
+}
+
 void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 {
 	/* CnP being set denotes an invalid entry */
 	mmu->tlb_vttbr = VTTBR_CNP_BIT;
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
+	mt_init(&mmu->nested_revmap_mt);
+	mmu->nested_revmap_broken = false;
 }
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
@@ -1225,6 +1305,89 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
+static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
+{
+	mtree_destroy(&mmu->nested_revmap_mt);
+	mmu->nested_revmap_broken = false;
+	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+}
+
+static void unmap_mmu_cipa_range(struct kvm_s2_mmu *mmu, gpa_t canonical_ipa,
+				  size_t unmap_size, bool may_block)
+{
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t canonical_ipa_end = canonical_ipa + unmap_size - 1;
+	size_t entry_size;
+	gpa_t next_addr;
+	u64 entry;
+	MA_STATE(mas_rmap, revmap_mt, canonical_ipa, canonical_ipa_end);
+
+	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+
+	if (mmu->nested_revmap_broken) {
+		reset_revmap_and_unmap(mmu, may_block);
+		return;
+	}
+
+	if (!mmu->nested_stage2_enabled) {
+		kvm_stage2_unmap_range(mmu, canonical_ipa, unmap_size, may_block);
+		return;
+	}
+
+	mtree_lock(revmap_mt);
+	entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
+
+	while (entry && mas_rmap.index <= canonical_ipa_end) {
+		entry_size = mas_rmap.last - mas_rmap.index + 1;
+		next_addr = mas_rmap.index + entry_size;
+		/*
+		 * Give up and invalidate this s2 mmu if the unmap range
+		 * touches any UNKNOWN_IPA range.
+		 */
+		if (unknown_ipa_entry(entry)) {
+			mtree_unlock(revmap_mt);
+			reset_revmap_and_unmap(mmu, may_block);
+			return;
+		}
+
+		/*
+		 * Ignore result, it is okay if a reverse mapping erase
+		 * fails.
+		 */
+		mas_store_gfp(&mas_rmap, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
+
+		mtree_unlock(revmap_mt);
+		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
+				       may_block);
+		mtree_lock(revmap_mt);
+		/*
+		 * Other maple tree operations during preemption could render
+		 * this ma_state invalid, so reset it.
+		 */
+		mas_set_range(&mas_rmap, next_addr, canonical_ipa_end);
+		entry = xa_to_value(mas_find(&mas_rmap, canonical_ipa_end));
+	}
+	mtree_unlock(revmap_mt);
+}
+
+void kvm_unmap_cipa_range_nested(struct kvm *kvm, gpa_t canonical_ipa, size_t size,
+				bool may_block)
+{
+	int i;
+
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			unmap_mmu_cipa_range(mmu, canonical_ipa, size, may_block);
+	}
+
+	kvm_invalidate_vncr_ipa(kvm, canonical_ipa, canonical_ipa + size);
+}
+
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
@@ -1238,7 +1401,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+			reset_revmap_and_unmap(mmu, may_block);
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -1924,7 +2087,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			reset_revmap_and_unmap(mmu, true);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.43.0

