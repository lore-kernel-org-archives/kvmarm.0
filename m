Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A811E3A6B72
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865233; cv=none; b=oUS5cm+YxCjkfKbqM6p+QP/NrDcVwa/Q5wVexcsbyon0zdWBadMlcwhoadjhtRWi8HfBuQGAM3/l9Srybf5QCJqh5EJ3RGzYTs+LOTgrtCY2XaRCJ9tT/6jwc2NnjUdx4INV7lqoo/xgTbT+vLbnHCgoUQEg6BI3TRY6lhYEggI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865233; c=relaxed/simple;
	bh=qvHFVIHqG3TWDeZr998/wNmo51SV4CoZlGbG5u71zm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLW0PhbwSL2ZrcVGmVJwZw9rnOUfKaeBF2Ge+FxuGMm+UCeE1MqiVHvPsSPsIrt8+L4jKVKYahDNceqB/kU0WeDZw+rmx3jMG/gwXylsxMm41JU/2HLFH7OtVY8u2Oka9OheO1cRh9ZayFE09wEm+ta+LqHqhh0MJI+g4qDFjwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=J4PHWicz; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="J4PHWicz"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 46AA21C01;
	Mon, 30 Mar 2026 03:07:05 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 843103F915;
	Mon, 30 Mar 2026 03:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774865231; bh=qvHFVIHqG3TWDeZr998/wNmo51SV4CoZlGbG5u71zm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4PHWiczP9ZzU94WsjEk1h3tgoY+8z+3JmQBZ2+uVqlqtPSvwdL2nGZm61oVXmf7o
	 vWllWsEZ4n3w7gj5ErvL+iD5THoHQI7Ix8yJFLn+xvUkpBM8yGiW26V+w0KvIlXKtz
	 s+3nJsCpREmki6dHmKXiQ9vIrmTpnnLAMkdYGQ2I=
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
Subject: [PATCH 1/4] KVM: arm64: nv: Avoid full shadow s2 unmap
Date: Mon, 30 Mar 2026 11:06:30 +0100
Message-ID: <20260330100633.2817076-2-weilin.chang@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260330100633.2817076-1-weilin.chang@arm.com>
References: <20260330100633.2817076-1-weilin.chang@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently we are forced to fully unmap all shadow stage-2 for a VM when
unmapping a page from the canonical stage-2, for example during an MMU
notifier call. This is because we are not tracking what canonical IPA
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
canonical IPA range overlaps with any existing ranges in the tree, erase
those existing ranges, and create a new range that spans all the
overlapping ranges including the input range. In the mean time, mark
this new spanning canonical IPA range as "polluted" indicating we lost
track of the nested IPA ranges that map to this canonical IPA range.

The maple tree's 64 bit entry is enough to store the nested IPA and
polluted status (stored as a bit called UNKNOWN_IPA), therefore besides
maple tree's internal operation, memory allocation is avoided.

Example:
|||| means existing range, ---- means empty range

input:            $$$$$$$$$$$$$$$$$$$$$$$$$$
tree:  --||||-----|||||||---------||||||||||-----------

free overlaps:
       --||||------------------------------------------
insert spanning range:
       --||||-----||||||||||||||||||||||||||-----------
                  ^^^^^^^^polluted!^^^^^^^^^

With the reverse map created, when a canonical IPA range gets unmapped,
look into each s2 mmu's maple tree and look for canonical IPA ranges
affected, and base on their polluted status:

polluted -> fall back and fully invalidate the current shadow stage-2,
            also clear the tree
not polluted -> unmap the nested IPA range, and remove the reverse map
                entry

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h   |   3 +
 arch/arm64/include/asm/kvm_nested.h |   4 +
 arch/arm64/kvm/mmu.c                |  27 +++++--
 arch/arm64/kvm/nested.c             | 112 +++++++++++++++++++++++++++-
 4 files changed, 140 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8545811e2238..1d0db7f268cc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -217,6 +217,9 @@ struct kvm_s2_mmu {
 	 */
 	bool	nested_stage2_enabled;
 
+	/* canonical IPA to nested IPA range lookup, protected by kvm.mmu_lock */
+	struct maple_tree nested_revmap_mt;
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	struct dentry *shadow_pt_debugfs_dentry;
 #endif
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 091544e6af44..4d09d567d7f9 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -76,6 +76,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 				       const union tlbi_info *info,
 				       void (*)(struct kvm_s2_mmu *,
 						const union tlbi_info *));
+extern int kvm_record_nested_revmap(gpa_t gpa, struct kvm_s2_mmu *mmu,
+				    gpa_t fault_gpa, size_t map_size);
 extern void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu);
 extern void kvm_vcpu_put_hw_mmu(struct kvm_vcpu *vcpu);
 
@@ -164,6 +166,8 @@ extern int kvm_s2_handle_perm_fault(struct kvm_vcpu *vcpu,
 				    struct kvm_s2_trans *trans);
 extern int kvm_inject_s2_fault(struct kvm_vcpu *vcpu, u64 esr_el2);
 extern void kvm_nested_s2_wp(struct kvm *kvm);
+extern void kvm_unmap_gfn_range_nested(struct kvm *kvm, gpa_t gpa, size_t size,
+				       bool may_block);
 extern void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block);
 extern void kvm_nested_s2_flush(struct kvm *kvm);
 
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..6beb07d817c8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1107,8 +1107,10 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		free_percpu(mmu->last_vcpu_ran);
 	}
 
-	if (kvm_is_nested_s2_mmu(kvm, mmu))
+	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		mtree_destroy(&mmu->nested_revmap_mt);
 		kvm_init_nested_s2_mmu(mmu);
+	}
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -1625,6 +1627,13 @@ static int gmem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		goto out_unlock;
 	}
 
+	if (nested) {
+		ret = kvm_record_nested_revmap(gfn << PAGE_SHIFT, pgt->mmu,
+					       fault_ipa, PAGE_SIZE);
+		if (ret)
+			goto out_unlock;
+	}
+
 	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, PAGE_SIZE,
 						 __pfn_to_phys(pfn), prot,
 						 memcache, flags);
@@ -1922,6 +1931,12 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
 		prot &= ~KVM_NV_GUEST_MAP_SZ;
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_relax_perms)(pgt, fault_ipa, prot, flags);
 	} else {
+		if (nested) {
+			ret = kvm_record_nested_revmap(gfn << PAGE_SHIFT, pgt->mmu,
+						       fault_ipa, vma_pagesize);
+			if (ret)
+				goto out_unlock;
+		}
 		ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, fault_ipa, vma_pagesize,
 					     __pfn_to_phys(pfn), prot,
 					     memcache, flags);
@@ -2223,14 +2238,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	gpa_t gpa = range->start << PAGE_SHIFT;
+	size_t size = (range->end - range->start) << PAGE_SHIFT;
+	bool may_block = range->may_block;
+
 	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_unmap_gfn_range_nested(kvm, gpa, size, may_block);
 
-	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..53392cc7dbae 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -7,6 +7,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/maple_tree.h>
 
 #include <asm/fixmap.h>
 #include <asm/kvm_arm.h>
@@ -43,6 +44,16 @@ struct vncr_tlb {
  */
 #define S2_MMU_PER_VCPU		2
 
+/*
+ * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
+ * layout:
+ *
+ * bits 55-12: nested IPA bits 55-12
+ * bit 0: polluted, 1 for polluted, 0 for not
+ */
+#define NESTED_IPA_MASK		GENMASK_ULL(55, 12)
+#define UNKNOWN_IPA		BIT(0)
+
 void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
@@ -769,12 +780,54 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	return s2_mmu;
 }
 
+int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
+			     gpa_t fault_ipa, size_t map_size)
+{
+	struct maple_tree *mt = &mmu->nested_revmap_mt;
+	gpa_t start = ipa;
+	gpa_t end = ipa + map_size - 1;
+	u64 entry, new_entry = 0;
+	int r = 0;
+
+	lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
+
+	MA_STATE(mas, mt, start, end);
+	entry = (u64)mas_find_range(&mas, end);
+
+	if (entry) {
+		/* maybe just a perm update... */
+		if (!(entry & UNKNOWN_IPA) && mas.index == start &&
+		    mas.last == end &&
+		    fault_ipa == (entry & NESTED_IPA_MASK))
+			goto out;
+		/*
+		 * Remove every overlapping range, then create a "polluted"
+		 * range that spans all these ranges and store it.
+		 */
+		while (entry && mas.index <= end) {
+			start = min(mas.index, start);
+			end = max(mas.last, end);
+			mas_erase(&mas);
+			entry = (u64)mas_find_range(&mas, end);
+		}
+		new_entry |= UNKNOWN_IPA;
+	} else {
+		new_entry |= fault_ipa;
+	}
+
+	mas_set_range(&mas, start, end);
+	r = mas_store_gfp(&mas, (void *)new_entry, GFP_KERNEL_ACCOUNT);
+out:
+	return r;
+}
+
 void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 {
 	/* CnP being set denotes an invalid entry */
 	mmu->tlb_vttbr = VTTBR_CNP_BIT;
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
+	mt_init(&mmu->nested_revmap_mt);
 }
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
@@ -1150,6 +1203,60 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
+static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
+				  size_t unmap_size, bool may_block)
+{
+	struct maple_tree *mt = &mmu->nested_revmap_mt;
+	gpa_t start = gpa;
+	gpa_t end = gpa + unmap_size - 1;
+	u64 entry;
+	size_t entry_size;
+
+	MA_STATE(mas, mt, gpa, end);
+	entry = (u64)mas_find_range(&mas, end);
+
+	while (entry && mas.index <= end) {
+		start = mas.last + 1;
+		entry_size = mas.last - mas.index + 1;
+		/*
+		 * Give up and invalidate this s2 mmu if the unmap range
+		 * touches any polluted range.
+		 */
+		if (entry & UNKNOWN_IPA) {
+			mtree_destroy(mt);
+			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu),
+					       may_block);
+			return;
+		}
+		mas_erase(&mas);
+		kvm_stage2_unmap_range(mmu, entry & NESTED_IPA_MASK, entry_size,
+				       may_block);
+		/*
+		 * Other maple tree operations during preemption could render
+		 * this ma_state invalid, so reset it.
+		 */
+		mas_set_range(&mas, start, end);
+		entry = (u64)mas_find_range(&mas, end);
+	}
+}
+
+void kvm_unmap_gfn_range_nested(struct kvm *kvm, gpa_t gpa, size_t size,
+				bool may_block)
+{
+	int i;
+
+	if (!kvm->arch.nested_mmus_size)
+		return;
+
+	/* TODO: accelerate this using mt of canonical s2 mmu */
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			unmap_mmu_ipa_range(mmu, gpa, size, may_block);
+	}
+}
+
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
@@ -1162,8 +1269,10 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
-		if (kvm_s2_mmu_valid(mmu))
+		if (kvm_s2_mmu_valid(mmu)) {
+			mtree_destroy(&mmu->nested_revmap_mt);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+		}
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -1848,6 +1957,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
+			mtree_destroy(&mmu->nested_revmap_mt);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
 			mmu->pending_unmap = false;
 		}
-- 
2.43.0

