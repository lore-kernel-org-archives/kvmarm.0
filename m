Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445C439FCC4
	for <kvmarm@lists.linux.dev>; Sun, 10 May 2026 14:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778424868; cv=none; b=DbqsTXH4Dc8C5LBIdf35QFzufvtDkW2lhAAso6r51OYShMaLDYpfr5tFhLdqMYmk8xQ6i8ShcC1+nr7Dke/TSodOW7yO5FpE6NpFJzkYkI07h5uQUcRV6h3AgCjPORFGW/ZTMwQfKLqSBq6/rR/ABbNxGa1913Hx8T7UDyaIMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778424868; c=relaxed/simple;
	bh=JbecycsRsO7GsuiD2qYQWCKe8z/108r6RfeoZgR8gSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcdg9e76x9WqjmYIxJ1zKF7I6oEAOBT9tCXTk1sBAOSG1CoctedNA43/LjhT8vn9gWPZpVHPd3WfoXNw3Iyf68hW/VIqDXtk0iY9m62+fPrGFCph0TWqyD8xlH7seWBBS+4e3dmiKDhbOyXbGmcIouprKqPx3U6J4rlA+Hk/qs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=vI1bL0GV; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="vI1bL0GV"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 05D002936;
	Sun, 10 May 2026 07:54:15 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C46DE3F836;
	Sun, 10 May 2026 07:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778424860; bh=JbecycsRsO7GsuiD2qYQWCKe8z/108r6RfeoZgR8gSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI1bL0GVk/XuBFOApt/EmeQuwANWzrnLhZQRdYc0gV3Qrb7o2xcxVSF1DQ8t90hH0
	 Za6kAWtSmkAuk8L10TcjDAQ3BLq1dTlHeHAwbbmobpXi6dyg6nAy4yRsAagaGbpQns
	 z7tYaKBXJo/7uBsZJkEQyvvWtLAuJsdY+YdSRP6g=
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
Subject: [PATCH v3 3/5] KVM: arm64: nv: Avoid full shadow s2 unmap
Date: Sun, 10 May 2026 15:53:36 +0100
Message-ID: <20260510145338.322962-4-weilin.chang@arm.com>
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
canonical IPA range overlaps with any existing ranges in the tree,
create a new range that spans all the overlapping ranges including the
input range and replace those existing ranges. In the mean time, mark
this new spanning canonical IPA range with an "UNKNOWN_IPA" bit,
indicating we give up tracking the nested IPA ranges that map to this
canonical IPA range.

The maple tree's 64 bit entry is enough to store the nested IPA and
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
affected, and base on their UNKNOWN_IPA status:

UNKNOWN_IPA     -> fall back and fully unmap the current shadow
                   stage-2, also clear the tree

not UNKNOWN_IPA -> unmap the nested IPA range, and remove the reverse
                   map entry

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h   |   4 +
 arch/arm64/include/asm/kvm_nested.h |   4 +
 arch/arm64/kvm/mmu.c                |  27 ++++--
 arch/arm64/kvm/nested.c             | 140 +++++++++++++++++++++++++++-
 4 files changed, 167 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1a56d137df10..dc4c0bce1bbb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -223,6 +223,10 @@ struct kvm_s2_mmu {
 	 */
 	bool	pending_unmap;
 
+	bool	nested_revmap_broken;
+	/* canonical IPA to nested IPA range lookup */
+	struct maple_tree nested_revmap_mt;
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	struct dentry *shadow_pt_debugfs_dentry;
 #endif
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 091544e6af44..5cbf78dfc685 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -76,6 +76,8 @@ extern void kvm_s2_mmu_iterate_by_vmid(struct kvm *kvm, u16 vmid,
 				       const union tlbi_info *info,
 				       void (*)(struct kvm_s2_mmu *,
 						const union tlbi_info *));
+extern void kvm_record_nested_revmap(gpa_t gpa, struct kvm_s2_mmu *mmu,
+				     gpa_t fault_ipa, size_t map_size);
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
index e4becd5cdf36..ce0bd88cd3c1 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/maple_tree.h>
 #include <linux/mman.h>
 #include <linux/kvm_host.h>
 #include <linux/io.h>
@@ -1099,6 +1100,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 {
 	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
 	struct kvm_pgtable *pgt = NULL;
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
 
 	write_lock(&kvm->mmu_lock);
 	pgt = mmu->pgt;
@@ -1108,8 +1110,11 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		free_percpu(mmu->last_vcpu_ran);
 	}
 
-	if (kvm_is_nested_s2_mmu(kvm, mmu))
+	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		if (!mtree_empty(revmap_mt))
+			mtree_destroy(revmap_mt);
 		kvm_init_nested_s2_mmu(mmu);
+	}
 
 	write_unlock(&kvm->mmu_lock);
 
@@ -1631,6 +1636,10 @@ static int gmem_abort(const struct kvm_s2_fault_desc *s2fd)
 		goto out_unlock;
 	}
 
+	if (s2fd->nested)
+		kvm_record_nested_revmap(gfn << PAGE_SHIFT, pgt->mmu,
+					 s2fd->fault_ipa, PAGE_SIZE);
+
 	ret = KVM_PGT_FN(kvm_pgtable_stage2_map)(pgt, s2fd->fault_ipa, PAGE_SIZE,
 						 __pfn_to_phys(pfn), prot,
 						 memcache, flags);
@@ -2034,6 +2043,10 @@ static int kvm_s2_fault_map(const struct kvm_s2_fault_desc *s2fd,
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
@@ -2389,14 +2402,16 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	gpa_t gpa = range->start << PAGE_SHIFT;
+	size_t size = (range->end - range->start) << PAGE_SHIFT;
+	bool may_block = range->may_block;
+
 	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+	__unmap_stage2_range(&kvm->arch.mmu, gpa, size, may_block);
+	kvm_unmap_gfn_range_nested(kvm, gpa, size, may_block);
 
-	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
 }
 
@@ -2674,7 +2689,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
 
 	write_lock(&kvm->mmu_lock);
 	kvm_stage2_unmap_range(&kvm->arch.mmu, gpa, size, true);
-	kvm_nested_s2_unmap(kvm, true);
+	kvm_unmap_gfn_range_nested(kvm, gpa, size, true);
 	write_unlock(&kvm->mmu_lock);
 }
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 883b6c1008fb..35b5d5f21a23 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -7,6 +7,7 @@
 #include <linux/bitfield.h>
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
+#include <linux/maple_tree.h>
 
 #include <asm/fixmap.h>
 #include <asm/kvm_arm.h>
@@ -43,6 +44,20 @@ struct vncr_tlb {
  */
 #define S2_MMU_PER_VCPU		2
 
+/*
+ * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
+ * layout:
+ *
+ * bit  62:     valid, prevents the case where the nested IPA is 0 and turning
+ *              the whole value to 0
+ * bits 55-12:  nested IPA bits 55-12
+ * bit  0:      UNKNOWN_IPA bit, 1 indicates we give up on tracking what nested
+ *              IPA maps to this canonical IPA in the shadow stage-2
+ */
+#define VALID_ENTRY		BIT(62)
+#define ADDR_MASK		GENMASK_ULL(55, 12)
+#define UNKNOWN_IPA		BIT(0)
+
 void kvm_init_nested(struct kvm *kvm)
 {
 	kvm->arch.nested_mmus = NULL;
@@ -769,12 +784,57 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	return s2_mmu;
 }
 
+void kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
+			      gpa_t fault_ipa, size_t map_size)
+{
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t ipa_end = ipa + map_size - 1;
+	u64 entry, new_entry = 0;
+	MA_STATE(mas_rev, revmap_mt, ipa, ipa_end);
+
+	if (mmu->nested_revmap_broken)
+		return;
+
+	mtree_lock(revmap_mt);
+	entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
+
+	if (entry) {
+		/* maybe just a perm update... */
+		if (!(entry & UNKNOWN_IPA) && mas_rev.index == ipa &&
+		    mas_rev.last == ipa_end &&
+		    fault_ipa == (entry & ADDR_MASK))
+			goto unlock;
+		/*
+		 * Create a "UNKNOWN_IPA" range that spans all the overlapping
+		 * ranges and store it.
+		 */
+		while (entry && mas_rev.index <= ipa_end) {
+			ipa = min(mas_rev.index, ipa);
+			ipa_end = max(mas_rev.last, ipa_end);
+			entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
+		}
+		new_entry |= UNKNOWN_IPA;
+	} else {
+		new_entry |= fault_ipa;
+		new_entry |= VALID_ENTRY;
+	}
+
+	mas_set_range(&mas_rev, ipa, ipa_end);
+	if (mas_store_gfp(&mas_rev, xa_mk_value(new_entry),
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
@@ -1150,6 +1210,82 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
 
+static void reset_revmap_and_unmap(struct kvm_s2_mmu *mmu, bool may_block)
+{
+	mtree_destroy(&mmu->nested_revmap_mt);
+	mmu->nested_revmap_broken = false;
+	kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+}
+
+static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
+				  size_t unmap_size, bool may_block)
+{
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t ipa = gpa;
+	gpa_t ipa_end = gpa + unmap_size - 1;
+	u64 entry;
+	size_t entry_size;
+	MA_STATE(mas_rev, revmap_mt, gpa, ipa_end);
+
+	if (mmu->nested_revmap_broken) {
+		reset_revmap_and_unmap(mmu, may_block);
+		return;
+	}
+
+	mtree_lock(revmap_mt);
+	entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
+
+	while (entry && mas_rev.index <= ipa_end) {
+		ipa = mas_rev.last + 1;
+		entry_size = mas_rev.last - mas_rev.index + 1;
+		/*
+		 * Give up and invalidate this s2 mmu if the unmap range
+		 * touches any UNKNOWN_IPA range.
+		 */
+		if (entry & UNKNOWN_IPA) {
+			mtree_unlock(revmap_mt);
+			reset_revmap_and_unmap(mmu, may_block);
+			return;
+		}
+
+		/*
+		 * Ignore result, it is okay if a reverse mapping erase
+		 * fails.
+		 */
+		mas_store_gfp(&mas_rev, NULL, GFP_NOWAIT | __GFP_ACCOUNT);
+
+		mtree_unlock(revmap_mt);
+		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
+				       may_block);
+		mtree_lock(revmap_mt);
+		/*
+		 * Other maple tree operations during preemption could render
+		 * this ma_state invalid, so reset it.
+		 */
+		mas_set_range(&mas_rev, ipa, ipa_end);
+		entry = xa_to_value(mas_find_range(&mas_rev, ipa_end));
+	}
+	mtree_unlock(revmap_mt);
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
+	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
+		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+
+		if (kvm_s2_mmu_valid(mmu))
+			unmap_mmu_ipa_range(mmu, gpa, size, may_block);
+	}
+
+	kvm_invalidate_vncr_ipa(kvm, gpa, gpa + size);
+}
+
 void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 {
 	int i;
@@ -1163,7 +1299,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu))
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
+			reset_revmap_and_unmap(mmu, may_block);
 	}
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
@@ -1848,7 +1984,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
-			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
+			reset_revmap_and_unmap(mmu, true);
 			mmu->pending_unmap = false;
 		}
 		write_unlock(&vcpu->kvm->mmu_lock);
-- 
2.43.0

