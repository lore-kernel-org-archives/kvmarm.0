Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7779641
	for <kvmarm@lists.linux.dev>; Mon, 25 Mar 2024 18:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711392732; cv=none; b=JDAQCtJI1QqVse6IuYoM+iVws0eCqbhnuAV6DDtmFjLOgztlg5vASbYAn0VwIE1VD0tfqC+KNYVAPxlqwbHNOaL/UjXlpOgDcVk9Y5WS8SFSWZciUHkU8BC4f2mjeWn0w4lKnCUzEuiXyWnAIVAK9a2r47BV6SzXmKMroVJu1Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711392732; c=relaxed/simple;
	bh=bXN/HevD7CPAdyg/mpq/H+7HLHjel9WBtmGPHdrhUQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=o35GVS78Zl+Iu3Be7oa41AQB6N73LCNLTDdFwBx0RyD1zNbP+df+zjh6sD52W5kwuCl33Vk+hWlUoEObYWkwYlXSi7huOQew+TOmpDlfbMeJAmOX2P4/TubmmJ9wQCRub+ZKXNMm+/fklqhZsV125+NKcHewGsBIynJ7NklD/V4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iqkXUcEq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iqkXUcEq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67E3C433C7;
	Mon, 25 Mar 2024 18:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711392732;
	bh=bXN/HevD7CPAdyg/mpq/H+7HLHjel9WBtmGPHdrhUQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iqkXUcEqtXtdLyi6K+9/BQsjj4e5kgjUopHt/DtwiYzGrlNzSLd6ydKyOAsF3XNQh
	 28vLSImXPQUJihOMxFLRUXi3anhq6aG0oB18h2tVn8K/vH/+OMh+jYAyh1WtUWQoGo
	 vm72biZGh5ILWtD4RfILoKyMmNnZlv6JG7XpLHC0J4d0/CT2psTgt/7G+W64Ob1obc
	 W1LG9WUIQmN5EVr+Am9B6ozT8scdoSie+tZ9QnPPDlN1h+U80pGTypfvUgqHAJw2P1
	 Q3UGJIgW2I9fJ4uvfcKo698NSDS835GfFBLVn6VJr9d58mnxc0ehYcmP1UXxJ+APu1
	 8Cp+DiMItY3Gg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Marc Zyngier <maz@kernel.org>,
	Mostafa Saleh <smostafa@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Quentin Perret <qperret@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH 2/3] KVM: arm64: Don't pass a TLBI level hint when zapping table entries
Date: Mon, 25 Mar 2024 18:51:57 +0000
Message-Id: <20240325185158.8565-3-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20240325185158.8565-1-will@kernel.org>
References: <20240325185158.8565-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The TLBI level hints are for leaf entries only, so take care not to pass
them incorrectly after clearing a table entry.

Cc: Gavin Shan <gshan@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Fixes: 82bb02445de5 ("KVM: arm64: Implement kvm_pgtable_hyp_unmap() at EL2")
Fixes: 6d9d2115c480 ("KVM: arm64: Add support for stage-2 map()/unmap() in generic page-table")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/pgtable.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index de0b667ba296..a40dafc43bb6 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -528,7 +528,7 @@ static int hyp_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
 
 		kvm_clear_pte(ctx->ptep);
 		dsb(ishst);
-		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), ctx->level);
+		__tlbi_level(vae2is, __TLBI_VADDR(ctx->addr, 0), TLBI_TTL_UNKNOWN);
 	} else {
 		if (ctx->end - ctx->addr < granule)
 			return -EINVAL;
@@ -896,10 +896,12 @@ static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (kvm_pte_valid(ctx->old)) {
 		kvm_clear_pte(ctx->ptep);
 
-		if (!stage2_unmap_defer_tlb_flush(pgt) ||
-		    kvm_pte_table(ctx->old, ctx->level)) {
-			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
-					ctx->addr, ctx->level);
+		if (kvm_pte_table(ctx->old, ctx->level)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     TLBI_TTL_UNKNOWN);
+		} else if (!stage2_unmap_defer_tlb_flush(pgt)) {
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr,
+				     ctx->level);
 		}
 	}
 
-- 
2.44.0.396.g6e790dbe36-goog

