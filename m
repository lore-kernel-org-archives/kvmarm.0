Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C86453B5
	for <kvmarm@lists.linux.dev>; Mon,  6 Feb 2023 16:58:56 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id s76-20020a632c4f000000b0049ceb0f185eso5356722pgs.7
        for <kvmarm@lists.linux.dev>; Mon, 06 Feb 2023 08:58:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P3PXZO2PAZ/1nsWzQyVXqhwuxW1n83TTriFfsfUCsQA=;
        b=L4RNQJZL1MT/Aad1VHABZMMB22m0kayodkbnYbokIBzqNcAJmn4Y/NIBteI7b+9Qy2
         H9f7LwtCQx/TA7Jfp+rYtQ6bsMT0UgKYOalNOwe5sJW1ydOJB0oHp6YQA/ALnpB73rAu
         f/YYAhop4pNSqMAC1Ezfe1UwI9xNmDL4GXM7WjXsUiqYCn5oWC0XwjWvJiO2HK1V2KFK
         zVPzkbruwA54lKSjGKnE6Phx56m7dp30o+XsWg24I3XD+1OawhNAAf4KMHW/QSUIWsGz
         FeC4ysjVn/BaeQSwRYh6IC6cpAD4biZoZNkY/yAHN7iYD0+UT3ZRq57AGjEP4p2X4RPm
         epCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P3PXZO2PAZ/1nsWzQyVXqhwuxW1n83TTriFfsfUCsQA=;
        b=T/NumzQTcHJEw2PfA+Rgi03lzpaGiNfmR8cdqbofaD2LTpFXRmICeQjUfbQzIHH9oF
         odoeZA4KJ1Yl83STQrXetkdHr3vQsEqPCJNV5R3g3qrdgxQsgo4N16dRFoDPwHAtAHJH
         mBsSOH3Fgtzg9f55mggykRSM91WIv9FtkXcMc++J5sFXdfaMHsJjA58gV3nCtyi5xaSk
         8YjHIgS02IKW9/cmQ01xIIdELoi3c4kvkr5Gn0f+lTgxNNUnb6buS9so48qdSIDJUC5P
         eidMCXvH5e/vfjxz3sxyw7Jc1NnjuXHgbgZVB7Hz9ogSsFoRuKSB5QFMvrp/FrT6SSF0
         ar9g==
X-Gm-Message-State: AO0yUKVUi1tZPVVp2NY7rbK4j+Pt0ZMrANpMLS9minSKJKaAUia/Wyyq
	uQScvkek2G1Yl4cqD41mJZgzrdRJpB4W9Q==
X-Google-Smtp-Source: AK7set+90OrweG69CIxyYmFiQ3bdqgsDLbX1w8hVLWMGuRqtT43AVv2Q4Ruvd4/uGc9cuLGsQLYNjxtcfJrqdA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:90a:195c:b0:230:c4f5:8577 with SMTP
 id 28-20020a17090a195c00b00230c4f58577mr100062pjh.20.1675702735889; Mon, 06
 Feb 2023 08:58:55 -0800 (PST)
Date: Mon,  6 Feb 2023 16:58:40 +0000
In-Reply-To: <20230206165851.3106338-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230206165851.3106338-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230206165851.3106338-2-ricarkol@google.com>
Subject: [PATCH v2 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
 skipping BBM and CMO
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add two flags to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_SKIP_BBM and
KVM_PGTABLE_WALK_SKIP_CMO, to indicate that the walk should not
perform break-before-make (BBM) nor cache maintenance operations
(CMO). This will by a future commit to create unlinked tables not
accessible to the HW page-table walker.  This is safe as these removed
tables are not visible to the HW page-table walker.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 18 ++++++++++++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..3339192a97a9 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -188,12 +188,20 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ * @KVM_PGTABLE_WALK_SKIP_BBM:		Visit and update table entries
+ *					without Break-before-make
+ *					requirements.
+ * @KVM_PGTABLE_WALK_SKIP_CMO:		Visit and update table entries
+ *					without Cache maintenance
+ *					operations required.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
+	KVM_PGTABLE_WALK_SKIP_BBM		= BIT(4),
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(4),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -215,6 +223,16 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
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
index b11cf2c618a6..e093e222daf3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -717,14 +717,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
@@ -808,11 +811,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
2.39.1.519.gcb327c4b5f-goog

