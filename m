Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB83391
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:02 +0000 (UTC)
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-536af109f9aso124051027b3.13
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DPheaVcCbjSmROjElANCHCHz5AMlJCBRQkCYrvmfbqU=;
        b=WxzFs7JxxYImFM2eogjaHHE3j/Guhz9RteJOE6Yvo7foersk17L159zhAsf4Hl+8lY
         jFtVvvVjqAN7eNKo33ysvgKJwUM6BMy9eIY4+GxYTZOGw/1DSrEFFzaejk3b+WWNioEe
         cBMlBKvP4bVfnq+vkpz7X8Eh7Du8Drg1dneZ8iDhU11sVoSri2X+lOPUvYvzg5Ht2DFa
         pllMqbUjBGeYeIka/V26CHJwAWMu1jYccDW8xgi4vIpy5Tv3aYswT2kkmPH9ZuPJl55t
         YAMozr7wag+WtHBlGWqRb1/KyiljV0FW/nQi/Ma5A9V6LCWNuMXzi8W2Ez5sf7tZeFRG
         +isA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DPheaVcCbjSmROjElANCHCHz5AMlJCBRQkCYrvmfbqU=;
        b=AYePAVOo87ACrPPZVYY/603nCTV8GaMaXId3yZIvi7EAsIBAEaJ51SbGBcVyel/dUR
         NNcFnjiELyNr8oFxqpb3wKJyXqzSI5640JNHWmekLlw7nZwtwEHV45Wg/vy54AfZLEie
         p+v7jYdlDuxL4vU7XAMMCu+j7AftSgTFR3vZ4czMR0ubZ0J/lh9NYU45yzw2NMq2pTN1
         HZJDT4tdathexZH8W01R5uhAC6TmhlWaJe52pj/49ytBJjtahf6cYrttr0xreA9CE7JQ
         YnIUVTkTqPlnZScjcXGZONcvGczh+tqt6fXPYXaAORk3y7PZsX6YHBjFoSTXCe3SaX6W
         2zYw==
X-Gm-Message-State: AO0yUKWao5XmK0WISM9+l1HrSvX13t6MavPfFmGKhQjcX3uf7rNct8bz
	pCE1Q5mcg2imUk/7tWPsnWFRTPDJg+6GBQ==
X-Google-Smtp-Source: AK7set+fqoEuVvKk0bd9tdokqq3ZyjFzf4QWcHC3PLM/mqaktQFkzCCnuiuJqqWCxnmTxHxJKjfAP6JD3e8ADQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:5b54:0:b0:52b:e47f:8a00 with SMTP id
 p81-20020a815b54000000b0052be47f8a00mr1ywb.22.1678160761453; Mon, 06 Mar 2023
 19:46:01 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:45 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-3-ricarkol@google.com>
Subject: [PATCH v6 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
perform break-before-make (BBM) nor cache maintenance operations
(CMO). This will by a future commit to create unlinked tables not
accessible to the HW page-table walker.  This is safe as these
unlinked tables are not visible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 26a4293726c1..c7a269cad053 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					with other software walkers.
  * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
  *					invoked from a fault handler.
+ * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
+ *					without Break-before-make
+ *					requirements.
+ * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
+ *					without Cache maintenance
+ *					operations required.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
@@ -202,6 +208,8 @@ enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
 	KVM_PGTABLE_WALK_HANDLE_FAULT		= BIT(4),
+	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(5),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -223,6 +231,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
 	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
 }
 
+static inline bool kvm_pgtable_walk_skip_bbm(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM;
+}
+
+static inline bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a3246d6cddec..4f703cc4cb03 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -741,14 +741,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!stage2_try_set_pte(ctx, KVM_INVALID_PTE_LOCKED))
 		return false;
 
-	/*
-	 * Perform the appropriate TLB invalidation based on the evicted pte
-	 * value (if any).
-	 */
-	if (kvm_pte_table(ctx->old, ctx->level))
-		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
-	else if (kvm_pte_valid(ctx->old))
-		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
+	if (!kvm_pgtable_walk_skip_bbm(ctx)) {
+		/*
+		 * Perform the appropriate TLB invalidation based on the
+		 * evicted pte value (if any).
+		 */
+		if (kvm_pte_table(ctx->old, ctx->level))
+			kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
+		else if (kvm_pte_valid(ctx->old))
+			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
+				     ctx->addr, ctx->level);
+	}
 
 	if (stage2_pte_is_counted(ctx->old))
 		mm_ops->put_page(ctx->ptep);
@@ -832,11 +835,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
-	if (mm_ops->dcache_clean_inval_poc && stage2_pte_cacheable(pgt, new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->dcache_clean_inval_poc &&
+	    stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
+					       granule);
 
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+	if (!kvm_pgtable_walk_skip_cmo(ctx) && mm_ops->icache_inval_pou &&
+	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
 	stage2_make_pte(ctx, new);
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

