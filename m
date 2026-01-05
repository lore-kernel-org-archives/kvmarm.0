Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E01A1E9B3A
	for <kvmarm@lists.linux.dev>; Mon,  5 Jan 2026 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767628246; cv=none; b=mjfoeqKMRm08yCfg7QaW6JE9+pqqyZ7+9Kbv0rRF953EOwbVPBzUbOgADnqRUxnfLgKpNyfv+dSuW+8nJLy9L9VJMr+Br8r/CmTgAbmbEdEhho2QkAq4y7zwmaP52F4CYyaiizvLMaV47QlnQrqfE4SpWY6XzgfEdLgXuylZwyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767628246; c=relaxed/simple;
	bh=vgLyn6tJZl/IzUA/ABSnXGcwxUN7qnglUo+W23OuePQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pozzJiovfA+X1JaI1y5Jd0e/kdcBoinn7ryggF7xPdHeNYV34CpW/yeCPX+IqjB+OREULRFOmeeKx+RanV+ppV2vo+tv8bkCiZAkvUDjEo/g8E4NQ7nZx4AmvvBpnxhv4fhmTEN+4QuE+U34ATnv+v6KRbbTeeTdF53i/H5Tv5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLfh4s7U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLfh4s7U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EBFEC116D0;
	Mon,  5 Jan 2026 15:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767628246;
	bh=vgLyn6tJZl/IzUA/ABSnXGcwxUN7qnglUo+W23OuePQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLfh4s7U/2r8ZZGsSED3Z7sdHutH5ikw+xVospiq87BO5lP6IDbG1uSqEqrUOO6rJ
	 UsddN8WMrSufxfPrn4EUQehcO05ZiSfmsDPoi8t4HYNupxL5DSTpkgbROHIdZsk2q9
	 S1SViVnjFBcTtb3tbLmqQwXJfI3P9Oa/VFUxgBky3GQalThACNBoNMje38gemwrXth
	 C1zs6fliaPcqEnvZqs0qXQXVen5xyni8ljyTC24nib+sAJQ7kIGcmOUpr7Aym7sR2q
	 D9rt5Jn5s6dXVGdHLt7fDbRUzRXXNA2EnIsGeGnVLVhGKmpVtQdDgq/LOUUgx16XnJ
	 Q22BvbFAyRfVQ==
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
Subject: [PATCH 18/30] KVM: arm64: Introduce host_stage2_set_owner_metadata_locked()
Date: Mon,  5 Jan 2026 15:49:26 +0000
Message-ID: <20260105154939.11041-19-will@kernel.org>
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

Rework host_stage2_set_owner_locked() to add a new helper function,
host_stage2_set_owner_metadata_locked(), which will allow us to store
additional metadata alongside the owner ID for invalid host stage-2
entries.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 6c32bdc689ed..7d1844e2888d 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -539,12 +539,8 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 		set_host_state(page, state);
 }
 
-static kvm_pte_t kvm_init_invalid_leaf_owner(u8 owner_id)
-{
-	return FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id);
-}
-
-int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+static int host_stage2_set_owner_metadata_locked(phys_addr_t addr, u64 size,
+						 u8 owner_id, u64 meta)
 {
 	kvm_pte_t annotation;
 	int ret;
@@ -552,10 +548,14 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 	if (!FIELD_FIT(KVM_INVALID_PTE_OWNER_MASK, owner_id))
 		return -EINVAL;
 
+	if (!FIELD_FIT(KVM_INVALID_PTE_EXTRA_MASK, meta))
+		return -EINVAL;
+
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
-	annotation = kvm_init_invalid_leaf_owner(owner_id);
+	annotation = FIELD_PREP(KVM_INVALID_PTE_OWNER_MASK, owner_id) |
+		     FIELD_PREP(KVM_INVALID_PTE_EXTRA_MASK, meta);
 	ret = host_stage2_try(kvm_pgtable_stage2_annotate, &host_mmu.pgt,
 			      addr, size, &host_s2_pool, annotation);
 	if (ret)
@@ -570,6 +570,11 @@ int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 	return 0;
 }
 
+int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
+{
+	return host_stage2_set_owner_metadata_locked(addr, size, owner_id, 0);
+}
+
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
 {
 	/*
-- 
2.52.0.351.gbe84eed79e-goog

