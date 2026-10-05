Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D09643803F;
	Mon,  5 Oct 2026 09:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191323; cv=none; b=tg5di1wMREd3jhRONBQSzJrU2a/nmYJ2l0CZ6CPzqF9YDsrJ8MXHJLfKjUa3sBMSIX7yvPfzE5M7a2/3zS9Vdvq6wTkjKf3wMcXS4j50liDd4ZzetqDl4DU1wSUOjEfOwJU1l9mF3uE+7nmz7+Wf33iugiKmcoS/JuieVGRZUWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191323; c=relaxed/simple;
	bh=to/o+2+LTNUsw7yP3Ll+qatHWCaw6Nm2Yp7csAeqYaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qfQi3tfQgpPV/mG97hB/YUcPrMwUKwKhWK2eJhcKZZZlXvqxQPvKSCIXyrVJtCEtZL9MjyWkK0xQwFRHQEEKTPCVbLcbr1xhWKEXgOuvqm/4ULgsFLGJ/BXHOyGus/lCdGmoEic/1q3OR6qFYBkjdqc88vnNrOEyRYuvaUFBMJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=ZkSWqd+3; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="ZkSWqd+3"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 557C41576;
	Mon,  5 Oct 2026 02:08:36 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B4C493F66F;
	Mon,  5 Oct 2026 02:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191319; bh=to/o+2+LTNUsw7yP3Ll+qatHWCaw6Nm2Yp7csAeqYaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkSWqd+3Cdo2ScU1cPdjqhieUQ4DtB1tB0BiA9pTYesABpdQepqape5Ir9Gv8spYa
	 u9YnVJtpNqNOxgQcw5uvWc2Kzjw3yHKqmfzuoppm0W1i0GiczAp60LOpNGG3Zbf0JT
	 kVt4FUVYbwbUq5qMKFJro+JOWFYEllaqMPaujWNo=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 10/23] KVM: arm64: Consolidate stage2 unmap range into kvm_stage2_unmap_range
Date: Mon,  5 Oct 2026 10:07:41 +0100
Message-ID: <20261005090754.2140522-11-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding VM specific backends for stage2 operations,
nuke __unmap_stage2_range() and fold the logic into
kvm_stage2_unmap_range(). Also, make kvm_unmap_gfn_range(), the only other
user of the __unmap_stage2_range() call the kvm_stage2_unmap_range(). Also,
while at it fix the comment to make it clear that mmu_lock must always be
held while unmapping. The code already mandates that and the two call paths
do have the write mmu_lock held.

Later we would replace the logic in kvm_stage2_unmap_range() with VM
specific backends.

No functional changes intended.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Change since v21:
 - Nuke __unmap_stage2_range and consolidate the stage2_unmap_range logic
   into kvm_stage2_unmap_range(), in preparation for removing the KVM_PGT_FN()
   for stage2_unmap
---
 arch/arm64/kvm/mmu.c | 38 ++++++++++++++++----------------------
 1 file changed, 16 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 0f4e8b71fa85d..4ae3bb6baef1a 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -314,36 +314,30 @@ static void invalidate_icache_guest_page(void *va, size_t size)
  * does.
  */
 /**
- * __unmap_stage2_range -- Clear stage2 page table entries to unmap a range
+ * kvm_stage2_unmap_range -- Clear stage2 page table entries to unmap a range
  * @mmu:   The KVM stage-2 MMU pointer
  * @start: The intermediate physical base address of the range to unmap
  * @size:  The size of the area to unmap
  * @may_block: Whether or not we are permitted to block
  *
  * Clear a range of stage-2 mappings, lowering the various ref-counts.  Must
- * be called while holding mmu_lock (unless for freeing the stage2 pgd before
- * destroying the VM), otherwise another faulting VCPU may come in and mess
- * with things behind our backs.
+ * be called while holding mmu_lock otherwise another faulting VCPU may
+ * come in and mess with things behind our backs.
  */
-static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size,
-				 bool may_block)
-{
-	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
-	phys_addr_t end = start + size;
-
-	lockdep_assert_held_write(&kvm->mmu_lock);
-	WARN_ON(size & ~PAGE_MASK);
-	WARN_ON(stage2_apply_range(mmu, start, end, KVM_PGT_FN(kvm_pgtable_stage2_unmap),
-				   may_block));
-}
-
 void kvm_stage2_unmap_range(struct kvm_s2_mmu *mmu, phys_addr_t start,
 			    u64 size, bool may_block)
 {
-	if (kvm_vm_is_protected(kvm_s2_mmu_to_kvm(mmu)))
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
+
+	if (kvm_vm_is_protected(kvm))
 		return;
 
-	__unmap_stage2_range(mmu, start, size, may_block);
+	lockdep_assert_held_write(&kvm->mmu_lock);
+	WARN_ON(size & ~PAGE_MASK);
+
+	WARN_ON(stage2_apply_range(mmu, start, start + size,
+				   KVM_PGT_FN(kvm_pgtable_stage2_unmap),
+				   may_block));
 }
 
 void kvm_stage2_flush_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)
@@ -2436,12 +2430,12 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.mmu.pgt || kvm_vm_is_protected(kvm))
+	if (!kvm->arch.mmu.pgt)
 		return false;
 
-	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
-			     (range->end - range->start) << PAGE_SHIFT,
-			     range->may_block);
+	kvm_stage2_unmap_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
+			       (range->end - range->start) << PAGE_SHIFT,
+			       range->may_block);
 
 	kvm_nested_s2_unmap(kvm, range->may_block);
 	return false;
-- 
2.43.0

