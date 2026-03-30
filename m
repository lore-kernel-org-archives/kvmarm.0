Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A1573B8BB1
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865264; cv=none; b=a/XdGQroYTW5KEEi2LvFVWey5BCxHQIyudQGqTK85RsSrIYoH7RoGL9pY57KI81rBwI2ZUfoPQQ/fbltGog5fStenR8SSjN5SjaAElct+hDX1O3wRwSiC0VdFusk03L2/Fx0IWtARvbDlgT4EcMaALAOVN2V0lkLaMfHxvVWYx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865264; c=relaxed/simple;
	bh=Vb9xxtHsTHwRbzD7GU8OESZOKbk4eyUOZTuHVncJqrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1myravoVD4herLAXbdy/pTlMO7YtwiMMIBANZr5BKe/mApTR2pKyUus+a/C7RNY9jSrOA+0K9mcXqa3t10FvgnKeiNFcX+VFCiocEnMBIqzkkbu9c71XtywsuDb9EZG1TLBoVlsPnZdz6xpX1JL0xfrVHOXhL7TavPfFNMX7Nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=f/3+x1/2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="f/3+x1/2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B266A1BF3;
	Mon, 30 Mar 2026 03:07:36 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E77803F915;
	Mon, 30 Mar 2026 03:07:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774865262; bh=Vb9xxtHsTHwRbzD7GU8OESZOKbk4eyUOZTuHVncJqrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/3+x1/2VERKOhutWBXZBELrTUAbk7W/MrKR6o8yuXOk1TMKjLgjirYbc08fs+Zbu
	 DvVg3CpQ4Henpk4kT7JVgqTOQk7BVnW9IdOaY596wWkD1qUYgZPvEUkdEkI8PuWhyM
	 hpNiKCxVjYDxUYh9/bvpDXEflvOGQ5RDWYdv4fmg=
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
Subject: [PATCH 4/4] KVM: arm64: nv: Create nested IPA direct map to speed up reverse map removal
Date: Mon, 30 Mar 2026 11:06:33 +0100
Message-ID: <20260330100633.2817076-5-weilin.chang@arm.com>
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

Iterating through the whole reverse map to find which entries to remove
when handling guest hypervisor TLBIs is not efficient. Create a direct
map that goes from nested IPA to canonical IPA so that the canonical
IPA range affected by the TLBI can be quickly determined, then remove
the entries in the reverse map accordingly.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   3 +
 arch/arm64/kvm/mmu.c              |   2 +
 arch/arm64/kvm/nested.c           | 131 ++++++++++++++++++++----------
 3 files changed, 95 insertions(+), 41 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 06f83bb7ff1d..6b0858805530 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -220,6 +220,9 @@ struct kvm_s2_mmu {
 	/* canonical IPA to nested IPA range lookup, protected by kvm.mmu_lock */
 	struct maple_tree nested_revmap_mt;
 
+	/* nested IPA to canonical IPA range lookup, protected by kvm.mmu_lock */
+	struct maple_tree nested_direct_mt;
+
 #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
 	struct dentry *shadow_pt_debugfs_dentry;
 #endif
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2b413d3dc790..9f27a9669ec9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1010,6 +1010,7 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 		kvm_init_nested_s2_mmu(mmu);
 
 	mt_init(&mmu->nested_revmap_mt);
+	mt_init(&mmu->nested_direct_mt);
 
 	return 0;
 
@@ -1112,6 +1113,7 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 	mtree_destroy(&mmu->nested_revmap_mt);
 
 	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
+		mtree_destroy(&mmu->nested_direct_mt);
 		kvm_init_nested_s2_mmu(mmu);
 	}
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 125fa21ca2e7..4c96130abf82 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -45,13 +45,12 @@ struct vncr_tlb {
 #define S2_MMU_PER_VCPU		2
 
 /*
- * Per shadow S2 reverse map (IPA -> nested IPA range) maple tree payload
- * layout:
+ * Per shadow S2 reverse & direct map maple tree payload layout:
  *
- * bits 55-12: nested IPA bits 55-12
- * bit 0: polluted, 1 for polluted, 0 for not
+ * bits 55-12: {nested, canonical} IPA bits 55-12
+ * bit 0: polluted, 1 for polluted, 0 for not, only used in reverse map
  */
-#define NESTED_IPA_MASK		GENMASK_ULL(55, 12)
+#define ADDR_MASK		GENMASK_ULL(55, 12)
 #define UNKNOWN_IPA		BIT(0)
 
 void kvm_init_nested(struct kvm *kvm)
@@ -915,74 +914,118 @@ static int record_accel(struct kvm_s2_mmu *mmu, gpa_t gpa,
 void kvm_remove_nested_revmap(struct kvm_s2_mmu *mmu, u64 addr, u64 size)
 {
 	/*
-	 * Iterate through the mt of this mmu, remove all unpolluted canonical
-	 * ipa ranges that maps to ranges that are strictly within
-	 * [addr, addr + size).
+	 * For all ranges in direct_mt that are completely covered by the range
+	 * we are TLBIing [addr, addr + size), we remove the reverse map AND
+	 * its corresponding direct map together, when these conditions are
+	 * met:
+	 *
+	 * 1. The TLBI range completely covers the stored nested IPA range.
+	 * 2. The reverse map is not polluted. This ensures the reverse map
+	 *    and the direct map are 1:1.
 	 */
-	struct maple_tree *mt = &mmu->nested_revmap_mt;
-	void *entry;
-	u64 nested_ipa, nested_ipa_end, addr_end = addr + size;
-	size_t revmap_size;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t nested_ipa_start = addr;
+	gpa_t nested_ipa_end = addr + size - 1;
+	u64 entry_ipa, entry_nested_ipa;
+	u64 ipa, ipa_end;
 
-	MA_STATE(mas, mt, 0, ULONG_MAX);
+	MA_STATE(mas_nested_ipa, direct_mt, nested_ipa_start, nested_ipa_end);
+	entry_ipa = (u64)mas_find_range(&mas_nested_ipa, nested_ipa_end);
 
-	mas_for_each(&mas, entry, ULONG_MAX) {
-		if ((u64)entry & UNKNOWN_IPA)
-			continue;
+	while (entry_ipa && mas_nested_ipa.index <= nested_ipa_end) {
+		ipa = entry_ipa & ADDR_MASK;
+		ipa_end = ipa + mas_nested_ipa.last - mas_nested_ipa.index;
 
-		revmap_size = mas.last - mas.index + 1;
-		nested_ipa = (u64)entry & NESTED_IPA_MASK;
-		nested_ipa_end = nested_ipa + revmap_size;
+		/* Use ipa range to find the corresponding entry in revmap. */
+		MA_STATE(mas_ipa, revmap_mt, ipa, ipa_end);
+		entry_nested_ipa = (u64)mas_find_range(&mas_ipa, ipa_end);
 
-		if (nested_ipa >= addr && nested_ipa_end <= addr_end) {
-			accel_clear_mmu_range(mmu, mas.index, revmap_size);
-			mas_erase(&mas);
+		/*
+		 * Reverse and direct map are created together at s2 faults,
+		 * thus every direct map range should also have a corresponding
+		 * reverse map range, however that can be polluted.
+		 */
+		BUG_ON(!entry_nested_ipa);
+
+		/* The two conditions outlined above. */
+		if (!(entry_nested_ipa & UNKNOWN_IPA) &&
+		    mas_nested_ipa.index >= addr &&
+		    mas_nested_ipa.last <= nested_ipa_end) {
+			/*
+			 * If the reverse map isn't polluted, the direct and
+			 * reverse map are expected to be 1:1, thus they must
+			 * have the same size.
+			 */
+			BUG_ON(mas_ipa.last - mas_ipa.index !=
+			       mas_nested_ipa.last - mas_nested_ipa.index);
+
+			accel_clear_mmu_range(mmu, mas_ipa.index,
+					      mas_ipa.last - mas_ipa.index + 1);
+			mas_erase(&mas_ipa);
+			mas_erase(&mas_nested_ipa);
 		}
+		entry_ipa = (u64)mas_find_range(&mas_nested_ipa, nested_ipa_end);
 	}
 }
 
 int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 			     gpa_t fault_ipa, size_t map_size)
 {
-	struct maple_tree *mt = &mmu->nested_revmap_mt;
-	gpa_t start = ipa;
-	gpa_t end = ipa + map_size - 1;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
+	gpa_t ipa_start = ipa;
+	gpa_t ipa_end = ipa + map_size - 1;
+	gpa_t fault_ipa_end = fault_ipa + map_size - 1;
 	u64 entry, new_entry = 0;
 	int r = 0;
 
 	lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
-	MA_STATE(mas, mt, start, end);
+	MA_STATE(mas_ipa, revmap_mt, ipa_start, ipa_end);
+	MA_STATE(mas_nested_ipa, direct_mt, fault_ipa, fault_ipa_end);
 
 	r = record_accel(mmu, ipa, map_size);
 	if (r)
 		goto out;
 
-	entry = (u64)mas_find_range(&mas, end);
+	r = mas_store_gfp(&mas_nested_ipa, (void *)ipa, GFP_KERNEL_ACCOUNT);
+	/*
+	 * In the case of direct map store failure, don't clean up
+	 * record_accel()'s successfully installed accel mt entry. Keeping
+	 * it is fine as it will just cause us to check a few more s2 mmus
+	 * in the mmu notifier.
+	 */
+	if (r)
+		goto out;
+
+	entry = (u64)mas_find_range(&mas_ipa, ipa_end);
 
 	if (entry) {
 		/* maybe just a perm update... */
-		if (!(entry & UNKNOWN_IPA) && mas.index == start &&
-		    mas.last == end &&
-		    fault_ipa == (entry & NESTED_IPA_MASK))
+		if (!(entry & UNKNOWN_IPA) && mas_ipa.index == ipa_start &&
+		    mas_ipa.last == ipa_end &&
+		    fault_ipa == (entry & ADDR_MASK))
 			goto out;
 		/*
 		 * Remove every overlapping range, then create a "polluted"
 		 * range that spans all these ranges and store it.
 		 */
-		while (entry && mas.index <= end) {
-			start = min(mas.index, start);
-			end = max(mas.last, end);
-			mas_erase(&mas);
-			entry = (u64)mas_find_range(&mas, end);
+		while (entry && mas_ipa.index <= ipa_end) {
+			ipa_start = min(mas_ipa.index, ipa_start);
+			ipa_end = max(mas_ipa.last, ipa_end);
+			mas_erase(&mas_ipa);
+			entry = (u64)mas_find_range(&mas_ipa, ipa_end);
 		}
 		new_entry |= UNKNOWN_IPA;
 	} else {
 		new_entry |= fault_ipa;
 	}
 
-	mas_set_range(&mas, start, end);
-	r = mas_store_gfp(&mas, (void *)new_entry, GFP_KERNEL_ACCOUNT);
+	mas_set_range(&mas_ipa, ipa_start, ipa_end);
+	r = mas_store_gfp(&mas_ipa, (void *)new_entry, GFP_KERNEL_ACCOUNT);
+	if (r)
+		mas_erase(&mas_nested_ipa);
 out:
 	return r;
 }
@@ -1371,13 +1414,14 @@ void kvm_nested_s2_wp(struct kvm *kvm)
 static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 				  size_t unmap_size, bool may_block)
 {
-	struct maple_tree *mt = &mmu->nested_revmap_mt;
+	struct maple_tree *direct_mt = &mmu->nested_direct_mt;
+	struct maple_tree *revmap_mt = &mmu->nested_revmap_mt;
 	gpa_t start = gpa;
 	gpa_t end = gpa + unmap_size - 1;
 	u64 entry;
 	size_t entry_size;
 
-	MA_STATE(mas, mt, gpa, end);
+	MA_STATE(mas, revmap_mt, gpa, end);
 	entry = (u64)mas_find_range(&mas, end);
 
 	while (entry && mas.index <= end) {
@@ -1388,15 +1432,18 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 		 * touches any polluted range.
 		 */
 		if (entry & UNKNOWN_IPA) {
-			mtree_destroy(mt);
+			mtree_destroy(direct_mt);
+			mtree_destroy(revmap_mt);
 			accel_clear_mmu(mmu);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu),
 					       may_block);
 			return;
 		}
+		/* not polluted, direct map and reverse map must be 1:1 */
+		mtree_erase(direct_mt, entry & ADDR_MASK);
 		mas_erase(&mas);
 		accel_clear_mmu_range(mmu, mas.index, entry_size);
-		kvm_stage2_unmap_range(mmu, entry & NESTED_IPA_MASK, entry_size,
+		kvm_stage2_unmap_range(mmu, entry & ADDR_MASK, entry_size,
 				       may_block);
 		/*
 		 * Other maple tree operations during preemption could render
@@ -1447,6 +1494,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
 
 		if (kvm_s2_mmu_valid(mmu)) {
+			mtree_destroy(&mmu->nested_direct_mt);
 			mtree_destroy(&mmu->nested_revmap_mt);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 		}
@@ -2135,6 +2183,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
+			mtree_destroy(&mmu->nested_direct_mt);
 			mtree_destroy(&mmu->nested_revmap_mt);
 			accel_clear_mmu(mmu);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
-- 
2.43.0

