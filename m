Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A3D15C8C
	for <kvmarm@lists.linux.dev>; Mon,  7 Nov 2022 21:58:01 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1667858280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UZiyD2k3y+EgHFhd63YTq4eWFfM6/StSmrCFVfziB3E=;
	b=xLi/4ocdf+ppLrJmfOO+OYHS7mtB+7dzqmhZiOcFcQZHi8X8TOQ/crSA6zZYUCcP6Y/RHg
	+xbh68fMgMm8gPPpUe60TmWNqPpB27Ji699w5Z1P247b+uHye6ghSkJKJA0oK/wiCaKmgN
	ndLg94qd5fQh+6KgVLM7dveIGEDA0uw=
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
Subject: [PATCH v5 10/14] KVM: arm64: Split init and set for table PTE
Date: Mon,  7 Nov 2022 21:56:40 +0000
Message-ID: <20221107215644.1895162-11-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
Message-ID: <20221107215640.w0L2gEqWrwP2YgpfJzHq_2zfedMsd9gkIMbgD-HW79k@z>

Create a helper to initialize a table and directly call
smp_store_release() to install it (for now). Prepare for a subsequent
change that generalizes PTE writes with a helper.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a34e2050f931..f4dd77c6c97d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -136,16 +136,13 @@ static void kvm_clear_pte(kvm_pte_t *ptep)
 	WRITE_ONCE(*ptep, 0);
 }
 
-static void kvm_set_table_pte(kvm_pte_t *ptep, kvm_pte_t *childp,
-			      struct kvm_pgtable_mm_ops *mm_ops)
+static kvm_pte_t kvm_init_table_pte(kvm_pte_t *childp, struct kvm_pgtable_mm_ops *mm_ops)
 {
-	kvm_pte_t old = *ptep, pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
+	kvm_pte_t pte = kvm_phys_to_pte(mm_ops->virt_to_phys(childp));
 
 	pte |= FIELD_PREP(KVM_PTE_TYPE, KVM_PTE_TYPE_TABLE);
 	pte |= KVM_PTE_VALID;
-
-	WARN_ON(kvm_pte_valid(old));
-	smp_store_release(ptep, pte);
+	return pte;
 }
 
 static kvm_pte_t kvm_init_valid_leaf_pte(u64 pa, kvm_pte_t attr, u32 level)
@@ -413,7 +410,7 @@ static bool hyp_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			  enum kvm_pgtable_walk_flags visit)
 {
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	struct hyp_map_data *data = ctx->arg;
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
@@ -427,8 +424,10 @@ static int hyp_map_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
-	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ctx->ptep);
+	smp_store_release(ctx->ptep, new);
+
 	return 0;
 }
 
@@ -796,7 +795,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	int ret;
 
 	ret = stage2_map_walker_try_leaf(ctx, data);
@@ -821,8 +820,9 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (stage2_pte_is_counted(ctx->old))
 		stage2_put_pte(ctx, data->mmu, mm_ops);
 
-	kvm_set_table_pte(ctx->ptep, childp, mm_ops);
+	new = kvm_init_table_pte(childp, mm_ops);
 	mm_ops->get_page(ctx->ptep);
+	smp_store_release(ctx->ptep, new);
 
 	return 0;
 }
-- 
2.38.1.431.g37b22c650d-goog

