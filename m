Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8373D538A
	for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 17:23:38 +0000 (UTC)
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-b8f54b1297eso8216271276.1
        for <kvmarm@lists.linux.dev>; Wed, 26 Apr 2023 10:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682529817; x=1685121817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bjzErw4O5d1yWmG+wTXuNlVYtJ+5Myh+Z0U10DnfqPM=;
        b=WvwIGshtOVWMstsvD21FTk9Lvwg5JZyZwizymkrmVrPPa7FacoOAgg3HWBmTPwIaKM
         LOX642Zsbl3QcEUzeEfZwSrqt2JX/lNbkOQwI21VCXQ7IywKab5WxPowHciyRstKaKP0
         0YnWMjrZ+gdGR9GKXbwQ7Zg64phLq3A3NN+y6pM0ZFFMbi9wjU9i22lME/W9u/OJ0TjE
         ns1h7JI7UWqHtv25HCxTxilMUxPV7gDWul1G5ESmpSXP8zCmrlO0LjY7PAmE7U93sAtJ
         kz2ERFvszQ+qCDeNxwjxR4hL6EiKW6cV0lrwEXvK+4QCRIKDy4vx/LJs/m1XchhSnavr
         +tiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682529817; x=1685121817;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bjzErw4O5d1yWmG+wTXuNlVYtJ+5Myh+Z0U10DnfqPM=;
        b=iAkOc/dhvWPdQBhit5+RxctT+8CmKU3d5M+gWn7Yl/yy09PanlZ8UU6WlzxtbgVoYG
         CMQViPkdoEjasKd7bRF9ItZD2OQNNhPfUbbLZf6qzJtEBBl4SvQFeoEQmyIZQ56RHpx2
         0KXzbDXu4TFjK5D8TFVD44uAmUHo9ipu3xrUJiMHI1aKH/DE8xM2lw1F1Yep5swIoOoE
         fEoNNbINs7TrgyF65CF7h4W+cOrIlz710GDgpVfbOh8KPxwMQwj+uxauEdY/uliF44Ik
         3nacnFmHH3ctbbNQFOAQ0JPj9lPrfZFOVcMLt7pDRAe692LCVr6MvOl5QDWdDMr+1qL/
         dngg==
X-Gm-Message-State: AAQBX9fedQGB4yriJmkJNwXDSpPZgBz9GmW+nEpsgfZdxit7WlnOV7YB
	BgDSN23EERg1qze9rlVrJdk3UFE0mw1WpA==
X-Google-Smtp-Source: AKy350aFpQM1DcvAYGAvfUmoNkliskk8Q+GXawb5W8KAecIhJYE2v4p038m2lzOhlRGrXoUeVrmI2BsX+VPJLA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:ca05:0:b0:b92:1f3c:a212 with SMTP id
 a5-20020a25ca05000000b00b921f3ca212mr12357344ybg.8.1682529817477; Wed, 26 Apr
 2023 10:23:37 -0700 (PDT)
Date: Wed, 26 Apr 2023 17:23:20 +0000
In-Reply-To: <20230426172330.1439644-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230426172330.1439644-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.1.495.gc816e09b53d-goog
Message-ID: <20230426172330.1439644-3-ricarkol@google.com>
Subject: [PATCH v8 02/12] KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping
 CMOs and BBM TLBIs
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

Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM_TLBI
and KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
perform TLB invalidations (TLBIs) in break-before-make (BBM) nor cache
maintenance operations (CMO). This will be used by a future commit to
create unlinked tables not accessible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         | 37 +++++++++++++++++++---------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 965fddcd53b8b..7bbd77e9b7b47 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -195,6 +195,12 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					with other software walkers.
  * @KVM_PGTABLE_WALK_HANDLE_FAULT:	Indicates the page-table walk was
  *					invoked from a fault handler.
+ * @KVM_PGTABLE_WALK_SKIP_BBM_TLBI:	Visit and update table entries
+ *					without Break-before-make's
+ *					TLB invalidation.
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
+	KVM_PGTABLE_WALK_SKIP_BBM_TLBI		= BIT(5),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(6),
 };
 
 struct kvm_pgtable_visit_ctx {
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 1dfbc4848ae52..64c96f9116171 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -63,6 +63,16 @@ struct kvm_pgtable_walk_data {
 	const u64			end;
 };
 
+static bool kvm_pgtable_walk_skip_bbm_tlbi(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_BBM_TLBI);
+}
+
+static bool kvm_pgtable_walk_skip_cmo(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return unlikely(ctx->flags & KVM_PGTABLE_WALK_SKIP_CMO);
+}
+
 static bool kvm_phys_is_valid(u64 phys)
 {
 	return phys < BIT(id_aa64mmfr0_parange_to_phys_shift(ID_AA64MMFR0_EL1_PARANGE_MAX));
@@ -743,14 +753,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
+	if (!kvm_pgtable_walk_skip_bbm_tlbi(ctx)) {
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
@@ -857,11 +870,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
2.40.1.495.gc816e09b53d-goog

