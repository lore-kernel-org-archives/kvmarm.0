Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0EBAD46
	for <kvmarm@lists.linux.dev>; Thu, 18 May 2023 09:58:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03048C433D2;
	Thu, 18 May 2023 09:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684403929;
	bh=wPhtXogwWz6NCnVt73wqOVcAkv5wf6+cM0nWx014CaU=;
	h=From:To:Cc:Subject:Date:From;
	b=uZxM/XqE71Dmeo0+Od17rfKn7pH7sfysP31FFwFcK3JQfe3LGf2AfTiJ8eiD5dXNo
	 9dNBl9KaZpyTFTQlozUReE8DnwgZm66Yp9NZoH//7hjWJmJiGRuMNNv0tKQ5yXTbPU
	 rWTs9t/sWiArzKXNbl0bPM1Mk0xUu2U9gyWIULHne6gCGGIYauIgwNuj4nOyff/UYB
	 RDONYMxZVz7vT5HUXvHvLIXLT/BVEcWPBGnTbvdMrImoJ676rtKU7z1k5auW+qa2eR
	 Si3/C95Gn3k3AFZmLexMaWOhpL/XJw5AhVjBrJaJX/oFeDSB+mSYD31onzmoCWHLBd
	 RYeiM4mALkboQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	Will Deacon <will@kernel.org>,
	Quentin Perret <qperret@google.com>
Subject: [PATCH] KVM: arm64: Prevent unconditional donation of unmapped regions from the host
Date: Thu, 18 May 2023 10:58:44 +0100
Message-Id: <20230518095844.1178-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since host stage-2 mappings are created lazily, we cannot rely solely on
the pte in order to recover the target physical address when checking a
host-initiated memory transition as this permits donation of unmapped
regions corresponding to MMIO or "no-map" memory.

Instead of inspecting the pte, move the addr_is_allowed_memory() check
into the host callback function where it is passed the physical address
directly from the walker.

Cc: Quentin Perret <qperret@google.com>
Fixes: e82edcc75c4e ("KVM: arm64: Implement do_share() helper for sharing memory")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2e9ec4a2a4a3..a8813b212996 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -575,7 +575,7 @@ struct pkvm_mem_donation {
 
 struct check_walk_data {
 	enum pkvm_page_state	desired;
-	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte);
+	enum pkvm_page_state	(*get_page_state)(kvm_pte_t pte, u64 addr);
 };
 
 static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
@@ -583,10 +583,7 @@ static int __check_page_state_visitor(const struct kvm_pgtable_visit_ctx *ctx,
 {
 	struct check_walk_data *d = ctx->arg;
 
-	if (kvm_pte_valid(ctx->old) && !addr_is_allowed_memory(kvm_pte_to_phys(ctx->old)))
-		return -EINVAL;
-
-	return d->get_page_state(ctx->old) == d->desired ? 0 : -EPERM;
+	return d->get_page_state(ctx->old, ctx->addr) == d->desired ? 0 : -EPERM;
 }
 
 static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
@@ -601,8 +598,11 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return kvm_pgtable_walk(pgt, addr, size, &walker);
 }
 
-static enum pkvm_page_state host_get_page_state(kvm_pte_t pte)
+static enum pkvm_page_state host_get_page_state(kvm_pte_t pte, u64 addr)
 {
+	if (!addr_is_allowed_memory(addr))
+		return PKVM_NOPAGE;
+
 	if (!kvm_pte_valid(pte) && pte)
 		return PKVM_NOPAGE;
 
@@ -709,7 +709,7 @@ static int host_complete_donation(u64 addr, const struct pkvm_mem_transition *tx
 	return host_stage2_set_owner_locked(addr, size, host_id);
 }
 
-static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte)
+static enum pkvm_page_state hyp_get_page_state(kvm_pte_t pte, u64 addr)
 {
 	if (!kvm_pte_valid(pte))
 		return PKVM_NOPAGE;
-- 
2.40.1.698.g37aff9b760-goog

