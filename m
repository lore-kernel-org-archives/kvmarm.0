Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8FBF184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:09 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id 8-20020a250508000000b00b7c653a0a4aso38673328ybf.23
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021808; x=1683613808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=if+YkGXz3GoOKFXpY68wLACnSj9D5ohyIKRDRrK/Hs4=;
        b=HygojbwsLM+kCoupRBYy10Ibop+q1/MYjUIVR7DbPvFnuNWijIn/UhfWGHmVnfNzSx
         O/zMOGi5LhdHBN4rtUz+yk29d71nuWhbU0SaqMi7Tl+4eHezKkIjeI5cK69qyXeFi3Ft
         Bmcg3+qMWQxApRrzosruX3kbbsZfuOVuj4IKjJ2tipYltcCFcS3CXzWuaZhj81ZIcFU0
         octi8sr/FpV3xpC7dwTVcj1/ceXgVMwaVOLLhRTJdMAayTLOF4J2OQ1+5E4NtVE+gRua
         kJEjUmc8x4jjanZoUpJkJ37vGzoZwxZMd8sG5quOoa4pKCZ1RvoiK2Cwvq83jfGeHlqi
         qZQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021808; x=1683613808;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=if+YkGXz3GoOKFXpY68wLACnSj9D5ohyIKRDRrK/Hs4=;
        b=h0crorNE0qVDX3XX9YhLAR942YDBp8wS1R1hKDTH50u6BxFq7FjRUc5aXvDCJ1SPNC
         AIyk3MDU+wRMtO+u3kp0HSwEmcKlTRV/L19yHPfbuaniZd/YFu3RH2NNoJKVpIyWMVT0
         EvlKmscIrZaBn0NOr1BCSXmtIy6EBQRyS2zb+tA5njEYqry5Lzdsd04/h/LKl8nt6VlM
         0RK+n9ModClofRbUZ0PEc7oBMzXt05h6jbELj/jKAd7cwpfQ1/+6Ul22xIyidBbTq4eA
         Sy+XKS/w81VF1LbnXiBsQAhS6ycsDI+yr+bQ0YOWvE+qnpTeW0esKJ7StjSMn2OZmuB8
         lp4g==
X-Gm-Message-State: AAQBX9dee8+FuuH/TTOfl3BEOxD1TNG12ZhAjcHkNv/htXlPHfMsRtdQ
	B39vDd8Ljf0HxKDNfKvVzebUFxu3PhKD5Q==
X-Google-Smtp-Source: AKy350bux1gSy/tqUCk8dzR6pnh+RgxO/Ld8BwP+yAuSbfTZdOY365S2qdqqoy50RgsAHilx4ojrq8jmVNUhMQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a25:d98e:0:b0:b6e:b924:b96f with SMTP id
 q136-20020a25d98e000000b00b6eb924b96fmr4248784ybg.3.1681021808809; Sat, 08
 Apr 2023 23:30:08 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:50 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-4-ricarkol@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: Add KVM_PGTABLE_WALK flags for skipping
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
---
 arch/arm64/include/asm/kvm_pgtable.h |  8 ++++++
 arch/arm64/kvm/hyp/pgtable.c         | 37 +++++++++++++++++++---------
 2 files changed, 34 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 26a4293726c14..3f2d43ba2b628 100644
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
index a3246d6cddec7..633679ee3c49a 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -62,6 +62,16 @@ struct kvm_pgtable_walk_data {
 	u64				end;
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
@@ -741,14 +751,17 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
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
@@ -832,11 +845,13 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
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
2.40.0.577.gac1e443424-goog

