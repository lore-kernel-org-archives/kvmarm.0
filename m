Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81D184F
	for <kvmarm@lists.linux.dev>; Sun,  9 Apr 2023 06:30:07 +0000 (UTC)
Received: by mail-pj1-f73.google.com with SMTP id o2-20020a17090ac08200b00244b34f5e3aso935960pjs.2
        for <kvmarm@lists.linux.dev>; Sat, 08 Apr 2023 23:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1681021807; x=1683613807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/9TrLiFh0g6i4CFqkD+8PkRd+TfJMu2Z2yB0plZBwo=;
        b=OKme6zdcLHlLnQV+0WVds+nJndYTKtQG6clVmxCrMGqN+i9aiXDmV/i+QYrKZPYVNo
         UHDSeXvov0SHBxbbiVkXLosyLPavrs0Z1WVMrBEs1yDd8d+/d57hFHkKeCMYaRSU7TVZ
         woNAauRkvBMkeCUSQtaQkBNqNItxgm67ifIwgm+h9dlp6N+JtErbUG84vS4o9mXBc4+8
         ev5VPudAMXCxz2h6Akctc3nmTqN0AE+8GQUhwyUHQ4z+l266a//kvLxl/0k8OaNQ+w7J
         pnVWdEIJ6ojApjdCyeQ/2NOV4e5fKRQ36asYyOyDOkm4j74ATF+xTTuA8KRh7sf0Rwcw
         BYBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681021807; x=1683613807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W/9TrLiFh0g6i4CFqkD+8PkRd+TfJMu2Z2yB0plZBwo=;
        b=DPH3kBT/aN9Md5Nu3K9ZZSdeLJhebDa91DSzPoULat31RtA0PFSdmNfeOiMXB5e9Us
         ICUgU+09DhjG1O1TVjFTpfWifcj9XlJTnd+i0Tbo28x/EwRY7MxI2J2Lz2Tp5N9jA6CP
         +S6N9qU/fREit+DciX4XREAt/z4j9aURNg+0JzcgHMvcJDneuB7fYCXrWvSGppB6+pNR
         UInTzQqfQJxpb/UFMem4/0tKr+MGevnCMOu/JQydSm/5YqDK58VlpqlTP5K4MOceNpfE
         tuPPW0c+PDcoUxen2zmXYSknLA76XyczTjkXI4hWdteRJUztBpFiOpGLB3VmjcUL5//w
         xBTA==
X-Gm-Message-State: AAQBX9eQMQxhiUdSapfdaChW+9wAOrnGnqwbRncVeH9UhfL33nQFzNch
	Zk4jhnvnjAl5+T75PZErwn0ib2tPjjH8tg==
X-Google-Smtp-Source: AKy350Z2WQwB5EMyLbrcj2e9/j7PUbO/8LTAEI6k3DdYFkDybadjKLoY/rTeCg4eYVz+ZWnt2lWiichG8LM6iQ==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:cecb:b0:19a:82a2:fcf9 with SMTP
 id d11-20020a170902cecb00b0019a82a2fcf9mr1088678plg.2.1681021806971; Sat, 08
 Apr 2023 23:30:06 -0700 (PDT)
Date: Sun,  9 Apr 2023 06:29:49 +0000
In-Reply-To: <20230409063000.3559991-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230409063000.3559991-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.577.gac1e443424-goog
Message-ID: <20230409063000.3559991-3-ricarkol@google.com>
Subject: [PATCH v7 02/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
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
(CMO). This will be used by a future commit to create unlinked tables
not accessible to the HW page-table walker.

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

