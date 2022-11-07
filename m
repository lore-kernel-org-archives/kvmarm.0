Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CEDC43217
	for <kvmarm@archiver.kernel.org>; Mon,  7 Nov 2022 21:59:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CBC504B836;
	Mon,  7 Nov 2022 16:59:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L8GME00ncnXA; Mon,  7 Nov 2022 16:59:09 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B1AC4B85E;
	Mon,  7 Nov 2022 16:59:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3238E4B836
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:59:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDEZQf+cQs1r for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Nov 2022 16:59:06 -0500 (EST)
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C0F794B658
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Nov 2022 16:59:06 -0500 (EST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1667858345;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=Wjq4QDt9xZJvVi5eTYg9PIR4fiNZZIcRNu978aLl+WU=;
 b=qlHqiut8sI1vgbFWY9FSD2/2a16CyuAbQeA3uuU451g2i3xwblSgrH+EwM2o5+2i2A0AB6
 yhJj6DoLWjl8fbIbMIMQyIj812LambgYU75iuQ5zMrgqNsYFewtzJjQo/nqxX8aT2xL7dy
 tu5OPjHn6rOJbipMkSGD1vkcJVqso30=
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH v5 11/14] KVM: arm64: Make block->table PTE changes
 parallel-aware
Date: Mon,  7 Nov 2022 21:58:55 +0000
Message-Id: <20221107215855.1895367-1-oliver.upton@linux.dev>
In-Reply-To: <20221107215644.1895162-1-oliver.upton@linux.dev>
References: <20221107215644.1895162-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Ben Gardon <bgardon@google.com>, David Matlack <dmatlack@google.com>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

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
 arch/arm64/kvm/hyp/pgtable.c | 80 +++++++++++++++++++++++++++++++++---
 1 file changed, 75 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index f4dd77c6c97d..b9f0d792b8d9 100644
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
+ * @mmu: stage-2 mmu
+ *
+ * Returns: true if the pte was successfully broken.
+ *
+ * If the removed pte was valid, performs the necessary serialization and TLB
+ * invalidation for the old value. For counted ptes, drops the reference count
+ * on the containing table page.
+ */
+static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
+				 struct kvm_s2_mmu *mmu)
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
+		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+	else if (kvm_pte_valid(ctx->old))
+		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
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
@@ -812,17 +881,18 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!childp)
 		return -ENOMEM;
 
+	if (!stage2_try_break_pte(ctx, data->mmu)) {
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
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
