Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF9E635
	for <kvmarm@lists.linux.dev>; Fri, 13 Jan 2023 03:50:04 +0000 (UTC)
Received: by mail-pg1-f202.google.com with SMTP id e11-20020a63d94b000000b0048988ed9a6cso9110944pgj.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Jan 2023 19:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jZjRhXEPC2vsb7WOpKphyVNmOEayhCKVSagTVwK+CXE=;
        b=m0sCAioIytK8Y3KnJTXLfxMbnYEWFn9cqCWm4fEsmelo+c3j2aBzy5U+Srm/7J3Bt6
         7HNsFb2BcI0WNv8cK3vppN0msHyojYVdHgzULoN31bKA8B5tEnToC8eGP6CYreBkBhjt
         geVKTpc6aLxPnRSaSOL47CGD0R0Pj6wNyTHmYSjfC1NVIW3iS09Vo65AhxnbPdNLDMT+
         gWbGWtwt5X8ACHTVsHyOpnPCPIMkGISCbyq5xHHf+YblxzRcsnkQSMzWcfNtkKkRIJcq
         69Z5J6VKaKOS7IOrxLbCZT9Ipmh9liXBvuUNxavLsYraYBOFGWn8AKuaiZqR6RWBvD1v
         uiiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jZjRhXEPC2vsb7WOpKphyVNmOEayhCKVSagTVwK+CXE=;
        b=Eg/2oiKuUieBHDJfIcciBi4k3322xNrrBjZ7YT+YfOvmpWds3UIa1Cga0y6GDdx1Iy
         x4xQvigFdn4xcy33ntj2lFE97ZUg9dxOu+zOd0BgIAD5FDVgqEunzLNwgvyhAZ36Bd/r
         F1sRqWHtR0IXFjwhCLEfNlKifSuL2Om5uxKZSyzt4zIJTpK/tf3ILXg+EfSo34s6U8OY
         0aXy5KUxmVtffmncXgLYJlJEJ7BT/zcG9Y2W74wv7cce/Ll1HOP3LBgvzXonSIbjurna
         9Ve0vBBH8C2StrfRUtm9IF0fd9p0+N7u9CSF97spWWKsE7O++3HNsSnvd/exBnOShMMM
         hzMg==
X-Gm-Message-State: AFqh2kqmDX3JcBz5ESZQe4LUzH5/KEPd4L5wOY0g75psdnDDiENil8y6
	FOCtv2JKxIV3xEfgUv+jDJld2S/hpOm/IQ==
X-Google-Smtp-Source: AMrXdXtxEz6Q4oQ8SbH1Gxz2JkQI2nFkBflO+n+bZU0IuqUE0eXpfIbxeGj5xYpYgoxqVygDgol01k7lU6kBeA==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:aa7:8d95:0:b0:582:9b37:2600 with SMTP id
 i21-20020aa78d95000000b005829b372600mr3186912pfr.57.1673581804224; Thu, 12
 Jan 2023 19:50:04 -0800 (PST)
Date: Fri, 13 Jan 2023 03:49:52 +0000
In-Reply-To: <20230113035000.480021-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230113035000.480021-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
Message-ID: <20230113035000.480021-2-ricarkol@google.com>
Subject: [PATCH 1/9] KVM: arm64: Add KVM_PGTABLE_WALK_REMOVED into ctx->flags
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a flag to kvm_pgtable_visit_ctx, KVM_PGTABLE_WALK_REMOVED, to
indicate that the walk is on a removed table not accesible to the HW
page-table walker. Then use it to avoid doing break-before-make or
performing CMOs (Cache Maintenance Operations) when mapping a removed
table. This is safe as these removed tables are not visible to the HW
page-table walker. This will be used in a subsequent commit for
replacing huge-page block PTEs into tables of 4K PTEs.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++++
 arch/arm64/kvm/hyp/pgtable.c         | 27 ++++++++++++++++-----------
 2 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 63f81b27a4e3..84a271647007 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -188,12 +188,15 @@ typedef bool (*kvm_pgtable_force_pte_cb_t)(u64 addr, u64 end,
  *					children.
  * @KVM_PGTABLE_WALK_SHARED:		Indicates the page-tables may be shared
  *					with other software walkers.
+ * @KVM_PGTABLE_WALK_REMOVED:		Indicates the page-tables are
+ *					removed: not visible to the HW walker.
  */
 enum kvm_pgtable_walk_flags {
 	KVM_PGTABLE_WALK_LEAF			= BIT(0),
 	KVM_PGTABLE_WALK_TABLE_PRE		= BIT(1),
 	KVM_PGTABLE_WALK_TABLE_POST		= BIT(2),
 	KVM_PGTABLE_WALK_SHARED			= BIT(3),
+	KVM_PGTABLE_WALK_REMOVED		= BIT(4),
 };
 
 struct kvm_pgtable_visit_ctx {
@@ -215,6 +218,11 @@ static inline bool kvm_pgtable_walk_shared(const struct kvm_pgtable_visit_ctx *c
 	return ctx->flags & KVM_PGTABLE_WALK_SHARED;
 }
 
+static inline bool kvm_pgtable_walk_removed(const struct kvm_pgtable_visit_ctx *ctx)
+{
+	return ctx->flags & KVM_PGTABLE_WALK_REMOVED;
+}
+
 /**
  * struct kvm_pgtable_walker - Hook into a page-table walk.
  * @cb:		Callback function to invoke during the walk.
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index b11cf2c618a6..87fd40d09056 100644
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
+	if (!kvm_pgtable_walk_removed(ctx)) {
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
+	if (!kvm_pgtable_walk_removed(ctx) && mm_ops->dcache_clean_inval_poc &&
+	    stage2_pte_cacheable(pgt, new))
 		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(new, mm_ops),
-						granule);
+					       granule);
 
-	if (mm_ops->icache_inval_pou && stage2_pte_executable(new))
+	if (!kvm_pgtable_walk_removed(ctx) && mm_ops->icache_inval_pou &&
+	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
 	stage2_make_pte(ctx, new);
-- 
2.39.0.314.g84b9a713c41-goog

