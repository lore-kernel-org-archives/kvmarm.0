Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563CD332EB7
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628213; cv=none; b=Vh8eVhdyHjrNIissS7vfBx+SrCYf5K0a+1iasmyG9+MBt014N9KtG/mzAMJagcknNbfKnM63CSbxgxLE9KdSUlSO86f0C0Zs02MUl2br/LOHBfH2COPB9qiONiomzpwmpQCYXtOB8umCH+4FiNd55aMmEROcxV0Ki+9qzeIURNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628213; c=relaxed/simple;
	bh=avRE/22DDTZ0ogA02eYtumbOLmxw2aUxX3FpcUEiOgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQirBwlGeSmXBEcJcLaGZlf05Qfjw12F9EPca1Ti5PhjcJFrT/Cz+EpeqiCtLY1L7ihuAkokReYQVJORZ96lj7L8ddivjNhhVoEkOVSt3hGKZ0rvhaGeUdCUjS8uRDYlG9sW8mN89jRLkqMqG6jfN93ei3T71n9eXzCD8nO4a24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bS+rNVUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bS+rNVUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47830C116D0;
	Mon,  5 Jan 2026 15:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628211;
	bh=avRE/22DDTZ0ogA02eYtumbOLmxw2aUxX3FpcUEiOgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bS+rNVUVVqtzOLL/a7jLqLBwB8ZQUxnBTm8Jf2BDawX/jIcj3Yguia5QvXp+XL1mr
	 q1E7h79fdrvf3SZpyTH84B7hD91z2RIgQ+uzC99iCRGdk1qdjwhdUfEhonOwOMghhf
	 xW/0qJ3/z15XkkOd+HXRNHaehmrz4xC1fjls2AA3sH5xqtoXPqwmLl/aR9mIUTOkB0
	 D8hTCwvaZQmkYtE6ygRIcszC4w1Sbhl5KvO4netlrlZUksSnN2ZHa+CwSbdHUjRrTC
	 OtBoOC3R2Cghfvl2WSc4WQG3JLUY9h8LK3JtGgXHQWXlb0sHHoHai+jiRlyDf/6jum
	 I2Szq6h9SGzxw==
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
Subject: [PATCH 07/30] KVM: arm64: Ignore MMU notifier callbacks for protected VMs
Date: Mon,  5 Jan 2026 15:49:15 +0000
Message-ID: <20260105154939.11041-8-will@kernel.org>
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

In preparation for supporting the donation of pinned pages to protected
VMs, return early from the MMU notifiers when called for a protected VM,
as the necessary hypercalls are exposed only for non-protected guests.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c  | 12 ++++++++++++
 arch/arm64/kvm/pkvm.c | 19 ++++++++++++++++++-
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5d18927f76ba..a888840497f9 100644
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
 
@@ -2208,6 +2211,9 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
+	if (kvm_vm_is_protected(kvm))
+		return false;
+
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
@@ -2220,6 +2226,9 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
+	if (kvm_vm_is_protected(kvm))
+		return false;
+
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
@@ -2233,6 +2242,9 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
+	if (kvm_vm_is_protected(kvm))
+		return false;
+
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index 42f6e50825ac..20d50abb3b94 100644
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
+		return -EPERM;
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
2.52.0.351.gbe84eed79e-goog

