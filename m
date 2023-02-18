Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com [209.85.219.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F01633
	for <kvmarm@lists.linux.dev>; Sat, 18 Feb 2023 03:23:19 +0000 (UTC)
Received: by mail-yb1-f202.google.com with SMTP id e83-20020a25e756000000b0086349255277so2754983ybh.8
        for <kvmarm@lists.linux.dev>; Fri, 17 Feb 2023 19:23:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=G8W7vR0PRQmPGFMPIXJ++IapBHBRtIMd4Chx9W9B5Ps=;
        b=jfshQ85qJucHKlc9NtInF4jRlhylfSuyLpB0sjsaublJRAg8aCadTARhFFiJRw1CtZ
         brVcjj52MiE0ZT3l4SduCr0zSuPGVfnqTPiukrZlRVA4eALEupuFrrYCnq5vUQYl2Yow
         NrtMlFuEZThW3dk+ytyBqPvXroS0hxtB/1aIyqry1xz/e+/dV2bvZ4HQ6JABHdUssUcS
         4XaS2Ua584WH8LqzqavcXtevKQVKiyK9i980P+IzC4FY6iRe10ITilbboKKulq8MZAZg
         7PbRpdikVvWIM8uwUTJwvIRa98Awv4Y+ZuGx7+w25P1x/BTHXwQaaOk8Kz2u4GMQwOS7
         ZP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8W7vR0PRQmPGFMPIXJ++IapBHBRtIMd4Chx9W9B5Ps=;
        b=feExt/30WLyOb7D84BO+6OGY8ZWFzX0l1Nu4Z6GjxG07lhVzHOWmgy7crTgmuBKKvI
         /Cx0fBlmMeH3qCsf2F6F1fX16Py8wQWLHBW4nBjaL83Jf23IsZCVf4Y/uDH4U6S6S/FI
         dcvmnAmPXnTAe+pqTHo0OpnaZ8Kli4M6UDHy/j3u12D83DDrzViQZfx0jHrFQAq03yI8
         ikezokbSnXLRHkp8sISvvHwjXaRWju8I2cGxRO2X4Zzcf7XRB2ZFSsL8ZSW7N513xUdS
         m9fgGM733CY3gwEkgrsBBCi3jQCML4QTIZAR8nPCWwBRwomFivSlncPrHb/w+OLPCprZ
         psAQ==
X-Gm-Message-State: AO0yUKWMNHkUW0k0J7yPC/2Tw1d3/3q+5t2Cj4ESvQ6kLSJzpmbxwVB5
	kyKqqrQ7kCZd/rd5EzpgKr691I6aaRj2XQ==
X-Google-Smtp-Source: AK7set8xVKfNyBAGZlVz+zxNxGP3IALOxKRKuRoHBiLyPDSeaWu4wCUI5EWWUpiE3JolGW6iyDb4YSaev4n/Mg==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6a03:0:b0:533:9485:c828 with SMTP id
 f3-20020a816a03000000b005339485c828mr831393ywc.512.1676690598494; Fri, 17 Feb
 2023 19:23:18 -0800 (PST)
Date: Sat, 18 Feb 2023 03:23:03 +0000
In-Reply-To: <20230218032314.635829-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230218032314.635829-1-ricarkol@google.com>
X-Mailer: git-send-email 2.39.2.637.g21b0678d19-goog
Message-ID: <20230218032314.635829-2-ricarkol@google.com>
Subject: [PATCH v4 01/12] KVM: arm64: Add KVM_PGTABLE_WALK ctx->flags for
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
index 63f81b27a4e3..252b651f743d 100644
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
+	KVM_PGTABLE_WALK_SKIP_CMO		= BIT(5),
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
2.39.2.637.g21b0678d19-goog

