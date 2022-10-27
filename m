Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9ED7B
	for <kvmarm@lists.linux.dev>; Thu, 27 Oct 2022 22:23:03 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1666909381;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dPwjtzII4NJsaEvVqD8Y9/lgXYuRXWzbtMwl7fUqLuk=;
	b=MmIH5HmhCHwt0avZHfKtX9MTg15VVkAla2tpvP7S0CI479c/WbUOI2CqhuLONOtVOhxXqu
	u1M9qg1NcOy20UUTF3wp440Nv6g2a7mE7H/NIVSvX0orN7cnKWLGLKxHu2wcwZBEvCBrwB
	LpPh0FPxnD4oyHee0SxMqNKsi87qxQs=
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
Subject: [PATCH v3 12/15] KVM: arm64: Make block->table PTE changes parallel-aware
Date: Thu, 27 Oct 2022 22:22:47 +0000
Message-ID: <20221027222247.1685023-1-oliver.upton@linux.dev>
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
Message-ID: <20221027222247.jDEzJfRhqj-Y0jJ3SJN6xcPDQd-UTH6KU3X7rtJ5wIs@z>

In order to service stage-2 faults in parallel, stage-2 table walkers
must take exclusive ownership of the PTE being worked on. An additional
requirement of the architecture is that software must perform a
'break-before-make' operation when changing the block size used for
mapping memory.

Roll these two concepts together into helpers for performing a
'break-before-make' sequence. Use a special PTE value to indicate a PTE
has been locked by a software walker. Additionally, use an atomic
compare-exchange to 'break' the PTE when the stage-2 page tables are
possibly shared with another software walker. Elide the DSB + TLBI if
the evicted PTE was invalid (and thus not subject to break-before-make).

All of the atomics do nothing for now, as the stage-2 walker isn't fully
ready to perform parallel walks.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/pgtable.c | 82 +++++++++++++++++++++++++++++++++---
 1 file changed, 76 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4c579b3beabf..1df858c21b2e 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -49,6 +49,12 @@
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
+/*
+ * Used to indicate a pte for which a 'break-before-make' sequence is in
+ * progress.
+ */
+#define KVM_INVALID_PTE_LOCKED		BIT(10)
+
 struct kvm_pgtable_walk_data {
 	struct kvm_pgtable_walker	*walker;
 
@@ -674,6 +680,11 @@ static bool stage2_pte_is_counted(kvm_pte_t pte)
 	return !!pte;
 }
 
+static bool stage2_pte_is_locked(kvm_pte_t pte)
+{
+	return !kvm_pte_valid(pte) && (pte & KVM_INVALID_PTE_LOCKED);
+}
+
 static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
 {
 	if (!kvm_pgtable_walk_shared(ctx)) {
@@ -684,6 +695,64 @@ static bool stage2_try_set_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_
 	return cmpxchg(ctx->ptep, ctx->old, new) == ctx->old;
 }
 
+/**
+ * stage2_try_break_pte() - Invalidates a pte according to the
+ *			    'break-before-make' requirements of the
+ *			    architecture.
+ *
+ * @ctx: context of the visited pte.
+ * @data: stage-2 map data
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pte was valid, performs the necessary serialization and TLB
+ * invalidation for the old value. For counted ptes, drops the reference count
+ * on the containing table page.
+ */
+static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				 struct stage2_map_data *data)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+
+	if (stage2_pte_is_locked(ctx->old)) {
+		/*
+		 * Should never occur if this walker has exclusive access to the
+		 * page tables.
+		 */
+		WARN_ON(!kvm_pgtable_walk_shared(ctx));
+		return false;
+	}
+
+	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
+		return false;
+
+	/*
+	 * Perform the appropriate TLB invalidation based on the evicted pte
+	 * value (if any).
+	 */
+	if (kvm_pte_table(ctx->old, ctx->level))
+		kvm_call_hyp(__kvm_tlb_flush_vmid, data->mmu);
+	else if (kvm_pte_valid(ctx->old))
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, data->mmu, ctx->addr, ctx->level);
+
+	if (stage2_pte_is_counted(ctx->old))
+		mm_ops->put_page(ctx->ptep);
+
+	return true;
+}
+
+static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+{
+	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
+
+	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+
+	if (stage2_pte_is_counted(new))
+		mm_ops->get_page(ctx->ptep);
+
+	smp_store_release(ctx->ptep, new);
+}
+
 static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
 			   struct kvm_pgtable_mm_ops *mm_ops)
 {
@@ -795,7 +864,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 				struct stage2_map_data *data)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
-	kvm_pte_t *childp;
+	kvm_pte_t *childp, new;
 	int ret;
 
 	ret = stage2_map_walker_try_leaf(ctx, data);
@@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (!stage2_try_break_pte(ctx, data)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
 	/*
 	 * If we've run into an existing block mapping then replace it with
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
-	if (stage2_pte_is_counted(ctx->old))
-		stage2_put_pte(ctx, data->mmu, mm_ops);
-
 	new = kvm_init_table_pte(childp, mm_ops);
-	mm_ops->get_page(ctx->ptep);
-	smp_store_release(ctx->ptep, new);
+	stage2_make_pte(ctx, new);
 
 	return 0;
 }
-- 
2.38.1.273.g43a17bfeac-goog

