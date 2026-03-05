Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0783B4EB1
	for <kvmarm@lists.linux.dev>; Thu,  5 Mar 2026 14:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772721917; cv=none; b=lqXrCBvTr/93mx9qVniJaTlE5rdeJkuLHOpAlynnY7ebMVtHteJAvkan65qPnM6ePoFTJXRwYJfUTRLXJnQr1/6G7qzCC0P34hO4Mibqs+qQDSTsTeTr2GPF4X23Z05plKbo4tLfkYrdejz/C+85c9z6v+FGWf+Y6BIqB+9F9Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772721917; c=relaxed/simple;
	bh=9bxzJMbzCySm9hHPY4I1q+HVEuSM2S18zUCS/sk+q6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rjb65y/Inh8XmYmbYOowTMmFUp0BeAt7M/kPBAXKxWCFC/Z8hgG0CV+Y2SPsvVVVLJznHej4LoeYw6FEqSgQio7ikdXZNEBZfLvJqRhyG/PaliMvTj2ZZGKMv6qubnOVpCq4mfmBL8moCJfKjSMYL7MeZ6O64RoQjcw0NljMBW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UGQsWi2/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UGQsWi2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E495DC19423;
	Thu,  5 Mar 2026 14:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772721916;
	bh=9bxzJMbzCySm9hHPY4I1q+HVEuSM2S18zUCS/sk+q6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UGQsWi2/DyABwX3oysIJmxpurOnUdKtt/fsrNBmvD8jdUNZEYGs5CIv1tyZC/13Zg
	 88JcX0P1QyM7AvS2aKdAV40tGcbJWPvfumyPg0iGUqhDhjI1LgHiV+TyRa3e96t3gM
	 V2QcB5Ui817jCEsd/yAt0Ty1b1D0uwwxiMRXzfpv7zsVqow+pNWQXSREk6+6EomY7R
	 br2ssv8f4zZ2NeT1zBihsugHHea652bwtfjsP0Chmte2dMCxNHuiyYzSfHptDmL+7f
	 bsF73xRTb4IeTlL9VBr+E7xMaRgimINP8MPNKG9xWaivkvAoiAOfeqy1N2Dc6gEK/4
	 uBvkImavT5dtg==
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
Subject: [PATCH v3 19/36] KVM: arm64: Avoid pointless annotation when mapping host-owned pages
Date: Thu,  5 Mar 2026 14:43:32 +0000
Message-ID: <20260305144351.17071-20-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260305144351.17071-1-will@kernel.org>
References: <20260305144351.17071-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a page is transitioned to host ownership, we can eagerly map it
into the host stage-2 page-table rather than going via the convoluted
step of a faulting annotation to trigger the mapping.

Call host_stage2_idmap_locked() directly when transitioning a page to
be owned by the host.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 0dc1d6fc546c..f673ebe7c888 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -551,23 +551,27 @@ static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
 {
-	int ret;
+	int ret = -EINVAL;
 
 	if (!range_is_memory(addr, addr + size))
 		return -EPERM;
 
-	ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
-			      addr, size, &host_s2_pool, owner_id);
-	if (ret)
-		return ret;
+	switch (owner_id) {
+	case PKVM_ID_HOST:
+		ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
+		if (!ret)
+			__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
+		break;
+	case PKVM_ID_GUEST:
+	case PKVM_ID_HYP:
+		ret = host_stage2_try(kvm_pgtable_stage2_set_owner, &host_mmu.pgt,
+				      addr, size, &host_s2_pool, owner_id);
+		if (!ret)
+			__host_update_page_state(addr, size, PKVM_NOPAGE);
+		break;
+	}
 
-	/* Don't forget to update the vmemmap tracking for the host */
-	if (owner_id == PKVM_ID_HOST)
-		__host_update_page_state(addr, size, PKVM_PAGE_OWNED);
-	else
-		__host_update_page_state(addr, size, PKVM_NOPAGE);
-
-	return 0;
+	return ret;
 }
 
 static bool host_stage2_force_pte_cb(u64 addr, u64 end, enum kvm_pgtable_prot prot)
-- 
2.53.0.473.g4a7958ca14-goog

