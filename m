Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EDD87B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 22:23:43 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666909422;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6/INBoJIrWD1fTlLMrgpkisXK+cYYTD0nB+IU7Yqcwo=;
	b=c7Pk/QPIzo2WNEr/uGsdXwLSfoLveKQJ2rYJ3OqsdUBNOfw3t85I9HISfCwHhUuaI8aULF
	YGtef+KtplozjDLh/wHjM50g4yU8Xib+y92A3kIrzrMxS7NLA41CM+Tv+NWEtwO/wh8ayW
	9E5/4VEElglHNl4oaOYEzPh5vrHwa3Q=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>
Cc: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	kvm@vger.kernel.org,
	Reiji Watanabe <reijiw@google.com>,
	Ricardo Koller <ricarkol@google.com>,
	David Matlack <dmatlack@google.com>,
	Quentin Perret <qperret@google.com>,
	Ben Gardon <bgardon@google.com>,
	Gavin Shan <gshan@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	Sean Christopherson <seanjc@google.com>,
	kvmarm@lists.linux.dev,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v3 14/15] KVM: arm64: Make table->block changes parallel-aware
Date: Thu, 27 Oct 2022 22:23:32 +0000
Message-ID: <20221027222332.1685156-1-oliver.upton@linux.dev>
In-Reply-To: <20221027221752.1683510-1-oliver.upton@linux.dev>
References: <20221027221752.1683510-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221027222332.mfqWe6oOc1Yv3U3ivFjN0HqqkSEbBTmzoIWPfM0KTFA@z>

stage2_map_walk_leaf() and friends now handle stage-2 PTEs generically,
and perform the correct flush when a table PTE is removed. Additionally,
they've been made parallel-aware, using an atomic break to take
ownership of the PTE.

Stop clearing the PTE in the pre-order callback and instead let
stage2_map_walk_leaf() deal with it.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 581ba688c6f7..d08e14008bfb 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -841,21 +841,12 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_leaf_mapping_allowed(ctx, data))
 		return 0;
 
-	kvm_clear_pte(ctx->ptep);
-
-	/*
-	 * Invalidate the whole stage-2, as we may have numerous leaf
-	 * entries below us which would otherwise need invalidating
-	 * individually.
-	 */
-	kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
-
 	ret = stage2_map_walker_try_leaf(ctx, data);
+	if (ret)
+		return ret;
 
-	mm_ops->put_page(ctx->ptep);
 	mm_ops->free_removed_table(childp, ctx->level + 1);
-
-	return ret;
+	return 0;
 }
 
 static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
-- 
2.38.1.273.g43a17bfeac-goog

