Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C483B895C
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774865239; cv=none; b=VwL/NsMtDQPU2xK6ioRtFIxiLYmfVCSAvqaYr0SxjT4W9L2h7Ep5fU6Cb6xpxpTcgRXpiDv6MtOI/cHgD9JA2/hCJbtDAlpyKPZYcpSamniASQAbGW/cp65vOzDnWUkJ3yJRXtit5TuI4Kpv7hVCG6vXn1C+kwwMMwE09stB4fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774865239; c=relaxed/simple;
	bh=aEkqyU+VsdQU8bT4JUQkuDybMkR2ZVB/qzwWdelmvWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZF4QcM3SnLjsRw5Bz3btrDaI2JHvN5Hk5T/vSnRVoQHJurGyqVeR2GCbO+kBgqJcrA3ygc9glrczcTikJhiNjrY0rYchkL3Y6ChUMVDql+P52Iop9rc5+ZqXtdeLIHb16nurW4kWw3BOf9DJ+H+1SWkJOJp1cwEa10GSYGiEcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=N5D8JjiJ; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="N5D8JjiJ"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8BCFF1BF3;
	Mon, 30 Mar 2026 03:07:11 -0700 (PDT)
Received: from workstation-e142269.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C955B3F99C;
	Mon, 30 Mar 2026 03:07:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774865237; bh=aEkqyU+VsdQU8bT4JUQkuDybMkR2ZVB/qzwWdelmvWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5D8JjiJIrjFLT/wI5LNLTCzKPiYVotKdtCD5clebHHnwqfTlsTwv0vViTVLH2iLJ
	 uZJeHHu0O1otw5QB1/bKSe6y7qPLe4sMQ4VUBiwdOf7Yk6iBEEwEYxmBHaOMzU9dFp
	 +VpVTula5m6aotXcd8Tdl/u5qUmWnfwFjBwAb3g4=
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
Subject: [PATCH 2/4] KVM: arm64: nv: Accelerate canonical IPA unmapping with canonical s2 mmu maple tree
Date: Mon, 30 Mar 2026 11:06:31 +0100
Message-ID: <20260330100633.2817076-3-weilin.chang@arm.com>
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

Checking every nested mmu during canonical IPA unmapping is slow,
especially when there are many valid nested mmus. We can leverage the
unused maple tree in the canonical kvm_s2_mmu to accelerate this
process.

At stage-2 fault time, other than recording the reverse map, also add an
entry in canonical s2 mmu's maple tree, with the canonical IPA range as
the key, and the "nested s2 mmu this fault is happending to" encoded in
the entry.

With the new maple tree for acceleration's information, at canonical
IPA unmap time we can look into the tree to retrieve the nested mmus
affected by this unmap much quicker.

In terms of encoding the nested mmus in the entry, there are 62 bits
available for each entry (bits 1 and 0 are reserved by the maple tree).
Each bit represents a number of nested mmus base on the total number of
nested mmus, this value grows in power of 2, so for example:

total nested mmus: 1-62    -> each bit represents: 1 nested mmu
                   63-124  ->                      2 nested mmus
                   125-248 ->                      4 nested mmus
                   ...                             ...

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Wei-Lin Chang <weilin.chang@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |   1 +
 arch/arm64/kvm/mmu.c              |   5 +-
 arch/arm64/kvm/nested.c           | 166 ++++++++++++++++++++++++++++--
 3 files changed, 163 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1d0db7f268cc..06f83bb7ff1d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -321,6 +321,7 @@ struct kvm_arch {
 	struct kvm_s2_mmu *nested_mmus;
 	size_t nested_mmus_size;
 	int nested_mmus_next;
+	int mmus_per_bit_power;
 
 	/* Interrupt controller */
 	struct vgic_dist	vgic;
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 6beb07d817c8..2b413d3dc790 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1009,6 +1009,8 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
 	if (kvm_is_nested_s2_mmu(kvm, mmu))
 		kvm_init_nested_s2_mmu(mmu);
 
+	mt_init(&mmu->nested_revmap_mt);
+
 	return 0;
 
 out_destroy_pgtable:
@@ -1107,8 +1109,9 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
 		free_percpu(mmu->last_vcpu_ran);
 	}
 
+	mtree_destroy(&mmu->nested_revmap_mt);
+
 	if (kvm_is_nested_s2_mmu(kvm, mmu)) {
-		mtree_destroy(&mmu->nested_revmap_mt);
 		kvm_init_nested_s2_mmu(mmu);
 	}
 
diff --git a/arch/arm64/kvm/nested.c b/arch/arm64/kvm/nested.c
index 53392cc7dbae..c7d00cb40ba5 100644
--- a/arch/arm64/kvm/nested.c
+++ b/arch/arm64/kvm/nested.c
@@ -80,7 +80,7 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_s2_mmu *tmp;
-	int num_mmus, ret = 0;
+	int num_mmus, power = 0, ret = 0;
 
 	if (test_bit(KVM_ARM_VCPU_HAS_EL2_E2H0, kvm->arch.vcpu_features) &&
 	    !cpus_have_final_cap(ARM64_HAS_HCR_NV1))
@@ -131,6 +131,25 @@ int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu)
 
 	kvm->arch.nested_mmus_size = num_mmus;
 
+	/*
+	 * Calculate how many s2 mmus are represented by each bit in the
+	 * acceleration maple tree entries.
+	 *
+	 * power == 0 -> 1 s2 mmu
+	 * power == 1 -> 2 s2 mmus
+	 * power == 2 -> 4 s2 mmus
+	 * power == 3 -> 8 s2 mmus
+	 * etc.
+	 *
+	 * We use only the top 62 bits in the canonical s2 mmu maple tree
+	 * entries, bits 0 and 1 are not used, since maple trees reserve values
+	 * with bit patterns ending in 10 that are also smaller that 4096.
+	 */
+	while (62 * (1 << power) < kvm->arch.nested_mmus_size)
+		power++;
+
+	kvm->arch.mmus_per_bit_power = power;
+
 	return 0;
 }
 
@@ -780,6 +799,119 @@ static struct kvm_s2_mmu *get_s2_mmu_nested(struct kvm_vcpu *vcpu)
 	return s2_mmu;
 }
 
+static int s2_mmu_to_accel_bit(struct kvm_s2_mmu *mmu)
+{
+	BUG_ON(&mmu->arch->mmu == mmu);
+
+	int index = mmu - mmu->arch->nested_mmus;
+	int power = mmu->arch->mmus_per_bit_power;
+
+	return (index >> power) + 2;
+}
+
+/* this returns the first s2 mmu from the span */
+static struct kvm_s2_mmu *accel_bit_to_s2_mmu(struct kvm *kvm, int bit)
+{
+	int power = kvm->arch.mmus_per_bit_power;
+	int index = (bit - 2) << power;
+
+	BUG_ON(index >= kvm->arch.nested_mmus_size);
+
+	return &kvm->arch.nested_mmus[index];
+}
+
+static void accel_clear_mmu_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
+				  size_t size)
+{
+	struct maple_tree *mt = &mmu->arch->mmu.nested_revmap_mt;
+	int bit = s2_mmu_to_accel_bit(mmu);
+	void *entry, *new_entry;
+	gpa_t start = gpa;
+	gpa_t end = gpa + size - 1;
+
+	if (mmu->arch->mmus_per_bit_power > 0) {
+		/* sadly nothing we can do here... */
+		return;
+	}
+
+	MA_STATE(mas, mt, start, end);
+
+	entry = mas_find_range(&mas, end);
+	BUG_ON(!entry);
+
+	/*
+	 * 1. Ranges smaller than the queried range should not exist, because
+	 *    for the same mmu, the same ranges are added in both the accel mt
+	 *    and the mmu's mt at fault time.
+	 *
+	 * 2. Ranges larger than the queried range could exist, since
+	 *    another mmu could have a range mapped on top.
+	 *    However in this case we don't know whether there are other
+	 *    smaller ranges in this larger range that belongs to this same
+	 *    mmu, so we can't just remove the bit.
+	 */
+	if (mas.index == start && mas.last == end) {
+		new_entry = (void *)((unsigned long)entry & ~BIT(bit));
+		/*
+		 * This naturally clears the range from the mt if
+		 * new_entry == 0.
+		 */
+		mas_store_gfp(&mas, new_entry, GFP_KERNEL_ACCOUNT);
+	}
+}
+
+static void accel_clear_mmu(struct kvm_s2_mmu *mmu)
+{
+	struct maple_tree *mt = &mmu->arch->mmu.nested_revmap_mt;
+	int bit = s2_mmu_to_accel_bit(mmu);
+	void *entry, *new_entry;
+
+	if (mmu->arch->mmus_per_bit_power > 0) {
+		/* sadly nothing we can do here... */
+		return;
+	}
+
+	MA_STATE(mas, mt, 0, ULONG_MAX);
+
+	mas_for_each(&mas, entry, ULONG_MAX) {
+		new_entry = (void *)((unsigned long)entry & ~BIT(bit));
+		/*
+		 * This naturally clears the range from the mt if
+		 * new_entry == 0.
+		 */
+		mas_store_gfp(&mas, new_entry, GFP_KERNEL_ACCOUNT);
+	}
+}
+
+static int record_accel(struct kvm_s2_mmu *mmu, gpa_t gpa,
+			       size_t map_size)
+{
+	struct maple_tree *mt = &mmu->arch->mmu.nested_revmap_mt;
+	gpa_t start = gpa;
+	gpa_t end = gpa + map_size - 1;
+	u64 entry, new_entry = 0;
+
+	MA_STATE(mas, mt, start, end);
+	entry = (u64)mas_find_range(&mas, end);
+
+	/*
+	 * OR every overlapping range's entry, then create a
+	 * range that spans all these ranges and store it.
+	 */
+	while (entry && mas.index <= end) {
+		start = min(mas.index, start);
+		end = max(mas.last, end);
+		new_entry |= entry;
+		mas_erase(&mas);
+		entry = (u64)mas_find_range(&mas, end);
+	}
+
+	new_entry |= BIT(s2_mmu_to_accel_bit(mmu));
+	mas_set_range(&mas, start, end);
+
+	return mas_store_gfp(&mas, (void *)new_entry, GFP_KERNEL_ACCOUNT);
+}
+
 int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 			     gpa_t fault_ipa, size_t map_size)
 {
@@ -792,6 +924,11 @@ int kvm_record_nested_revmap(gpa_t ipa, struct kvm_s2_mmu *mmu,
 	lockdep_assert_held_write(kvm_s2_mmu_to_kvm(mmu)->mmu_lock);
 
 	MA_STATE(mas, mt, start, end);
+
+	r = record_accel(mmu, ipa, map_size);
+	if (r)
+		goto out;
+
 	entry = (u64)mas_find_range(&mas, end);
 
 	if (entry) {
@@ -827,7 +964,6 @@ void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu)
 	mmu->tlb_vttbr = VTTBR_CNP_BIT;
 	mmu->nested_stage2_enabled = false;
 	atomic_set(&mmu->refcnt, 0);
-	mt_init(&mmu->nested_revmap_mt);
 }
 
 void kvm_vcpu_load_hw_mmu(struct kvm_vcpu *vcpu)
@@ -1224,11 +1360,13 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 		 */
 		if (entry & UNKNOWN_IPA) {
 			mtree_destroy(mt);
+			accel_clear_mmu(mmu);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu),
 					       may_block);
 			return;
 		}
 		mas_erase(&mas);
+		accel_clear_mmu_range(mmu, mas.index, entry_size);
 		kvm_stage2_unmap_range(mmu, entry & NESTED_IPA_MASK, entry_size,
 				       may_block);
 		/*
@@ -1243,17 +1381,27 @@ static void unmap_mmu_ipa_range(struct kvm_s2_mmu *mmu, gpa_t gpa,
 void kvm_unmap_gfn_range_nested(struct kvm *kvm, gpa_t gpa, size_t size,
 				bool may_block)
 {
-	int i;
+	struct maple_tree *mt = &kvm->arch.mmu.nested_revmap_mt;
+	gpa_t start = gpa;
+	gpa_t end = gpa + size - 1;
+	u64 entry;
+	int bit, i = 0;
+	int power = kvm->arch.mmus_per_bit_power;
+	struct kvm_s2_mmu *mmu;
+	MA_STATE(mas, mt, start, end);
 
 	if (!kvm->arch.nested_mmus_size)
 		return;
 
-	/* TODO: accelerate this using mt of canonical s2 mmu */
-	for (i = 0; i < kvm->arch.nested_mmus_size; i++) {
-		struct kvm_s2_mmu *mmu = &kvm->arch.nested_mmus[i];
+	entry = (u64)mas_find_range(&mas, end);
 
-		if (kvm_s2_mmu_valid(mmu))
-			unmap_mmu_ipa_range(mmu, gpa, size, may_block);
+	while (entry && mas.index <= end) {
+		for_each_set_bit(bit, (unsigned long *)&entry, 64) {
+			mmu = accel_bit_to_s2_mmu(kvm, bit);
+			for (i = 0; i < (1 << power); i++)
+				unmap_mmu_ipa_range(mmu + i, gpa, size, may_block);
+		}
+		entry = (u64)mas_find_range(&mas, end);
 	}
 }
 
@@ -1274,6 +1422,7 @@ void kvm_nested_s2_unmap(struct kvm *kvm, bool may_block)
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), may_block);
 		}
 	}
+	mtree_destroy(&kvm->arch.mmu.nested_revmap_mt);
 
 	kvm_invalidate_vncr_ipa(kvm, 0, BIT(kvm->arch.mmu.pgt->ia_bits));
 }
@@ -1958,6 +2107,7 @@ void check_nested_vcpu_requests(struct kvm_vcpu *vcpu)
 		write_lock(&vcpu->kvm->mmu_lock);
 		if (mmu->pending_unmap) {
 			mtree_destroy(&mmu->nested_revmap_mt);
+			accel_clear_mmu(mmu);
 			kvm_stage2_unmap_range(mmu, 0, kvm_phys_size(mmu), true);
 			mmu->pending_unmap = false;
 		}
-- 
2.43.0

