Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81AD2221543
	for <kvmarm@lists.linux.dev>; Mon, 19 Jan 2026 12:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768826822; cv=none; b=kNGGJ9O+68VsqZcazfOqA4z8Cw4U2IGHJ8pQaBFmctPMQ2beUgcxSkrNfB4b+BL+RyEX18rZ1vEHBYNFSxC328a6eR0dTqTIBSeftOqRw7cvWfueAtEKAsaUbzbbtSGBMI3JiyQFcd3HRiMQjs9ejxNrRzRO2Z/zswGzyv1/4nQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768826822; c=relaxed/simple;
	bh=Xla0EE0EqHreutQ1jfO5kxNb3sYx2UrdMxQNpU9siy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZuKkAl/Dpb+GdOZOE3vmRhKSed51iVj0KXjffFOokwHCKewh83gps8jPJux6bs/QJqBjp5DZba+fEdchHaUlJwMNlSwBL+XLu7EaaxZvngsxJ32SfoB2jbxT6URmmDz0ipdZMd1fa3fPRaP5tCObXfe78CiHgApC2Nq7Yxzq3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bZi+Ot5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bZi+Ot5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9CEFC19423;
	Mon, 19 Jan 2026 12:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768826822;
	bh=Xla0EE0EqHreutQ1jfO5kxNb3sYx2UrdMxQNpU9siy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZi+Ot5nUMovxcGhzAfN6vlS+gsXjPikIAh2pOzdZQgYXnpEKjCYbfDVGGnOJz/qm
	 Eotcok8jIdkys8NSCeA54BpAxxhU9Z1R2Nc22wwvKKzh1gE2mLN15YcAUmJpTR1zUf
	 1frm3QKvvP8hKJcQyhUxM6uFAfm2tdML0gZKqs6GwEsQFjXW+hMXhw3tgVIL8XoOhm
	 JZYwjWCJHwCeBNOtGELHKWvNot6SapKju6B4s5iJAUYd+PyxSUPH3IB3ImxxoJDNoh
	 i4267bysFRykLsNNDNjl+ZOL+NiE5JofXFmLx8CNZzIbwo0NMfxaK3WmZF9mnV4/Cx
	 CAyXACEtxojQg==
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
Subject: [PATCH v2 03/35] KVM: arm64: Move handle check into pkvm_pgtable_stage2_destroy_range()
Date: Mon, 19 Jan 2026 12:45:56 +0000
Message-ID: <20260119124629.2563-4-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260119124629.2563-1-will@kernel.org>
References: <20260119124629.2563-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When pKVM is enabled, a VM has a 'handle' allocated by the hypervisor
in kvm_arch_init_vm() and released later by kvm_arch_destroy_vm().

Consequently, the only time __pkvm_pgtable_stage2_unmap() can run into
an uninitialised 'handle' is on the kvm_arch_init_vm() failure path,
where we destroy the empty stage-2 page-table if we fail to allocate a
handle.

Move the handle check into pkvm_pgtable_stage2_destroy_range(), which
will additionally handle protected VMs in subsequent patches.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/pkvm.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

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
2.52.0.457.g6b5491de43-goog

