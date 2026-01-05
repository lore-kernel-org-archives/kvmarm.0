Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04432F25E4
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628196; cv=none; b=Ceb8iwnBl84jrV1ZiAQcJm3fsAEcwN3AtPD4e6x9V8YR2z9dJs54mI5whCP+4Cw+V8Kd2Rle9W1XUziBQ7yy3pw06b52hPsfd8ZDKTsePhbgZo6fa2S1Q5AO6hYO/lkA7KRHZKNVoMfMyeG3e124MA6V0kp2ANtjkQTmmcjmFcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628196; c=relaxed/simple;
	bh=EiR6H2PI7nrIrBLjfYnWtgkFePwcLsCE5gSk6ktCNXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uJMEnd/3t9H2hbxcvfW8RSgdcdXD/cVbHROhfsxD6bAXh1gmgTJbjFxrZEwkLm8AgW0kHpZsupguLEHh9vAk2/NMpfrbdsIKtbWfBOZLSRuspK2YiLrTVbkNbRz9Rj1d57RS/TsCYUN5z04WVrg9Ac6Gtx1mrkp5l3YwOkogkAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rBAIRSDY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rBAIRSDY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A85FC19422;
	Mon,  5 Jan 2026 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628196;
	bh=EiR6H2PI7nrIrBLjfYnWtgkFePwcLsCE5gSk6ktCNXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBAIRSDYUKhc0GKyLg828rNJP/qvq5dmeIVRDu5lPb/0YjbNzAtuMeexjV/izbd2U
	 vETtcCVLAJhzubw+LeR/NvTdBUUH8XdQy6tZOM/6BvovJmplpLRaJFpYNii7T2CIa8
	 rcsa7VUZsD77hOknzd844kAt4YhXvByD9OUUjyksq7Op6QSemNRZ86KtxBTUylLtzt
	 KJYv9IdkhHdx7YOO2n/YGapiOd1qIbGca7GFDmrfCCh9/HE6OmoAFMs2DsD/vJSjFi
	 ffh9wuNcCKpvyINvLF8uSr62I3TMQp25ys+qsAHn+YYd8m3rRSo+Pg68hLFj3ZEJjb
	 oVeMGrNivtTpw==
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
Subject: [PATCH 02/30] KVM: arm64: Remove redundant 'pgt' pointer checks from MMU notifiers
Date: Mon,  5 Jan 2026 15:49:10 +0000
Message-ID: <20260105154939.11041-3-will@kernel.org>
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

The MMU notifiers are registered by kvm_init_mmu_notifier() only after
kvm_arch_init_vm() has returned successfully. Since the latter function
initialises the 'kvm->arch.mmu.pgt' pointer (and allocates the VM handle
when pKVM is enabled), the initialisation checks in the MMU notifiers
are not required.

Remove the redundant checks from the MMU notifier callbacks.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/mmu.c  | 9 ---------
 arch/arm64/kvm/pkvm.c | 9 ++++++---
 2 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 2b260bdf3202..5d18927f76ba 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2208,9 +2208,6 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
-	if (!kvm->arch.mmu.pgt)
-		return false;
-
 	__unmap_stage2_range(&kvm->arch.mmu, range->start << PAGE_SHIFT,
 			     (range->end - range->start) << PAGE_SHIFT,
 			     range->may_block);
@@ -2223,9 +2220,6 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt)
-		return false;
-
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, true);
@@ -2239,9 +2233,6 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
-	if (!kvm->arch.mmu.pgt)
-		return false;
-
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
 						   size, false);
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index d7a0f69a9982..7797813f4dbe 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -329,9 +329,6 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 	struct pkvm_mapping *mapping;
 	int ret;
 
-	if (!handle)
-		return 0;
-
 	for_each_mapping_in_range_safe(pgt, start, end, mapping) {
 		ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_guest, handle, mapping->gfn,
 					mapping->nr_pages);
@@ -347,6 +344,12 @@ static int __pkvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 start, u64 e
 void pkvm_pgtable_stage2_destroy_range(struct kvm_pgtable *pgt,
 					u64 addr, u64 size)
 {
+	struct kvm *kvm = kvm_s2_mmu_to_kvm(pgt->mmu);
+	pkvm_handle_t handle = kvm->arch.pkvm.handle;
+
+	if (!handle)
+		return;
+
 	__pkvm_pgtable_stage2_unmap(pgt, addr, addr + size);
 }
 
-- 
2.52.0.351.gbe84eed79e-goog

