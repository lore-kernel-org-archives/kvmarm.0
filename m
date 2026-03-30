Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6655329E5C
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 14:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774882157; cv=none; b=mTmsKS4JcY78sdLR797QaJPwa+/Izz1cz4vG3p7adkzQTmSKdTYzGuIb8/QkBvyxZ9kUXf1qNP9N3Oxoibm3vrQdjgaFn8BJX4LHCogFE2Wgj698dzJRhkjHhaQxmUwjOPZKcnxXcNHUJ23tbuSLi+zVW2yl9WpINLIBIf5zfUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774882157; c=relaxed/simple;
	bh=/BxvkufNMC6Kn6LsbaQ15SUXIbt9TyUSXKShJCXUoWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZhqHktkt3uuDoUdtVspYPLl0KuP1Oi0RNqogCYANFZ99TqnadRN+xJhQZxhaV6w/QwJw0SOqR83NsB2vI2mE3s17LGM5lP4/5Kg1I8pZNctz2ncsio1y1vG+zHNEmQkGpLGbD+B8uPinFX1SwO3p6MzkyVP7JG/6ajtXXSMcVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BmK69iyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BmK69iyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADDFC19423;
	Mon, 30 Mar 2026 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774882157;
	bh=/BxvkufNMC6Kn6LsbaQ15SUXIbt9TyUSXKShJCXUoWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmK69iyx+JhAIZBWrndMgC+BCS1MaOyE2m3a6gSYBJyU4lH7pqCoK4BzxNxI0i5EA
	 vpA22sqjU90E/PBNulTizk/T/zGg8tHmdF9DUUKPilnW+WDqOP/ANDgIoDvOD0SGDQ
	 wWQhLrhw0DO/j6xvbiaqHR/jjc75FCLvqhmHog+PShS3VqP3FN/tyvJuoCwG4MH1A3
	 OnqSvhsy/1KY9IWuEJ0qo1gm5xyJr8ztqOr1ja1xe1aUiIMEBhreAwA+Ja/LVH/Rcf
	 jokn+I0GOdh5LlyATlnFxu1CldNRLJROqc1b39YXcHHfSpEPrrTeczYM6zQZQ45/fx
	 qmtimgninF79g==
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
	Mostafa Saleh <smostafa@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 08/38] KVM: arm64: Ignore MMU notifier callbacks for protected VMs
Date: Mon, 30 Mar 2026 15:48:09 +0100
Message-ID: <20260330144841.26181-9-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260330144841.26181-1-will@kernel.org>
References: <20260330144841.26181-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for supporting the donation of pinned pages to protected
VMs, return early from the MMU notifiers when called for a protected VM,
as the necessary hypercalls are exposed only for non-protected guests.

Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Fuad Tabba <tabba@google.com>
Tested-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c  |  9 ++++++---
 arch/arm64/kvm/pkvm.c | 19 ++++++++++++++++++-
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 17d64a1e11e5..5e7821fe0fc4 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -340,6 +340,9 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block)
 {
+	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
+		return;
+
 	__unmap_stage2_range(mmu, start, size, may_block);
 }
 
@@ -2223,7 +2226,7 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.mmu.pgt)
+	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
@@ -2238,7 +2241,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt)
+	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
@@ -2254,7 +2257,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt)
+	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
 		return false;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 42f6e50825ac..dd93dfdfe52d 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -407,7 +407,12 @@ int pkvm_pgtable_stage2_map(struct kvm_pgtable *pgt, u64 addr, u64 size,
 
 int pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
 {
-	lockdep_assert_held_write(&kvm_s2_mmu_to_kvm(pgt->mmu)->mmu_lock);
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+
+	if (WARN_ON(kvm_vm_is_protected(kvm)))
+		return -EPERM;
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
 
 	return __pkvm_pgtable_stage2_unshare(pgt, addr, addr + size);
 }
@@ -419,6 +424,9 @@ int pkvm_pgtable_stage2_wrprotect(struct kvm_pgtable *pgt, u64 addr, u64 size)
 	struct pkvm_mapping *mapping;
 	int ret = 0;
 
+	if (WARN_ON(kvm_vm_is_protected(kvm)))
+		return -EPERM;
+
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_wrprotect_guest, handle, mapping->gfn,
@@ -450,6 +458,9 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 	struct pkvm_mapping *mapping;
 	bool young = false;
 
+	if (WARN_ON(kvm_vm_is_protected(kvm)))
+		return false;
+
 	lockdep_assert_held(&kvm->mmu_lock);
 	for_each_mapping_in_range_safe(pgt, addr, addr + size, mapping)
 		young |= kvm_call_hyp_nvhe(__pkvm_host_test_clear_young_guest, handle, mapping->gfn,
@@ -461,12 +472,18 @@ bool pkvm_pgtable_stage2_test_clear_young(struct kvm_pgtable *pgt, u64 addr, u64
 int pkvm_pgtable_stage2_relax_perms(struct kvm_pgtable *pgt, u64 addr, enum kvm_pgtable_prot prot,
 				    enum kvm_pgtable_walk_flags flags)
 {
+	if (WARN_ON(kvm_vm_is_protected(kvm_s2_mmu_to_kvm(pgt->mmu))))
+		return -EPERM;
+
 	return kvm_call_hyp_nvhe(__pkvm_host_relax_perms_guest, addr >> PAGE_SHIFT, prot);
 }
 
 void pkvm_pgtable_stage2_mkyoung(struct kvm_pgtable *pgt, u64 addr,
 				 enum kvm_pgtable_walk_flags flags)
 {
+	if (WARN_ON(kvm_vm_is_protected(kvm_s2_mmu_to_kvm(pgt->mmu))))
+		return;
+
 	WARN_ON(kvm_call_hyp_nvhe(__pkvm_host_mkyoung_guest, addr >> PAGE_SHIFT));
 }
 
-- 
2.53.0.1018.g2bb0e51243-goog

