Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF633438B5
	for <kvmarm@lists.linux.dev>; Fri,  4 Sep 2026 13:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788528642; cv=none; b=h4cFJWk2GOVdsiqDt9V982KD+srw1r+sLlZtvJnOSrcWoKMh8PLhoUb8wKzuEkoCvnW8qoyO3N4hjvFT4B6T6TJDas/8wc+W4jItpDcHB4keaTOn/fxU9N+PPL/JeYLW3MrBNIw16ndbT1qbhY6HbkvblvESPZS4jPEB0XqeVfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788528642; c=relaxed/simple;
	bh=W8286X3x2YYchw5/EQ6lcrwdU39/OSfeCai+at1wVpY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OhA7rDeTe1a4eiA4lpe09/NYLIc9pGoUpta8qpiBXgaohmRqs119WqHqlbEJVjQMdI0Qtt+ZL3JRfoPyvqoEXJF7UjP1EmrKlganJng+EdNuA5dRzpgdCwCI8WPJdkuvdBaJi+Ks/wVRNgtASZPM/kBR1SHUHhmwKAtZXVJty08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AkTSI7pw; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AkTSI7pw"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49cc9f5bee2so8458185e9.2
        for <kvmarm@lists.linux.dev>; Fri, 04 Sep 2026 06:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788528637; x=1789133437; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fRJEDmVHvkj6iKYNb/lr1u1maCv+SpOx76Gyqqg/nbk=;
        b=AkTSI7pwcORl6WmlSdGA7xByMRriP5bDwx/M7F8l8HcOH09RgySV8vhdGOkthjvRPY
         YiQ+QUu8LLa1HbXO4kdTIbjjBr+6h3gsjmQCqHaGViBq7mC+u4rEAUh/Dmlyqx+aIewE
         jpmAWUEP+ErpulOMvhWIoNuLs1+ULwG9qPpl9yHLpiqL7MZzMQF6Igc0DKMCJf+ugeww
         IuNlSUmbsWrSIl8AbEtkodtmaMs5O/G/2FshPaSXC2WPss4DHVgugLB62ctKYVkpqP/d
         G/tGmqd90gqGSadEhpw1MgTrUPwdLoYIg17PtyliN/NQOSK/bu8nM5s1JT+pqJqqeMLU
         5CZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788528637; x=1789133437;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fRJEDmVHvkj6iKYNb/lr1u1maCv+SpOx76Gyqqg/nbk=;
        b=mC2IGtMXjtUfHGkXIfct0O44xUnazz46TTFvEs8Pk68zd1M/Fr1ebRisCUqU4emmP3
         0plDOzouI/f/lBq2YKPV1z2sj+pbb9aM9Had4JIPsxMREPjUxeWwcXjaPXQrEmox80H+
         TihS6ZJ6y9R1PqrnaxFFsr9nT/TLB5uBu3E69iG26rnOEUlMGEhwzCQgpeS0iOjVxRl1
         d8zicQ3O8M0Na0FyPPgqERiuEwU/D3kTUq4kD824Q8zYxFaxnEjNzKiF2ZheAhsoTC4i
         OHKMlxgN++Eq8eve1vzND4t01+09Aw8QSMoC5mdkBTI74F4IhuTw2YUr5ijMSuJaR0NE
         CtQA==
X-Forwarded-Encrypted: i=1; AKwUvBw+GE1jAuZyZHEzMC74r7q1DY7U/f8ffdZBAhmw0IMcmczmWZL8ucVLqqmtC4ujPLpZTXD14Ow=@lists.linux.dev
X-Gm-Message-State: AFuF++mj6ClA0YfWYM5pPN8T2kOFlxS4kTyZ2bwUe9YmtDGSALvTst2/
	y5SP+UhRWn3VfQjCboFmDhur8G2M3/3vB4Z+S4+4zBsiENXDFQnrzmDTCd6abC/K4ZorU6Ah11X
	w6QejLRPtcdmcPw==
X-Received: from wmgi7.prod.google.com ([2002:a05:600c:2d87:b0:49c:fcf3:6a19])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6211:b0:49c:fa21:1c88 with SMTP id 5b1f17b1804b1-49cfa211d8cmr38545275e9.29.1788528636429;
 Fri, 04 Sep 2026 06:30:36 -0700 (PDT)
Date: Fri,  4 Sep 2026 13:28:55 +0000
In-Reply-To: <20260904132855.638117-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260904132855.638117-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904132855.638117-3-smostafa@google.com>
Subject: [PATCH v3 2/2] KVM: arm64: Support BBM level 3
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, sebastianene@google.com, keirf@google.com, 
	qperret@google.com, linu.cherian@arm.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

If the system supports hardware Break-Before-Make (BBM) level 3, use it
to replace stage-2 PTEs directly. Otherwise, fall back to the software
BBM sequence.

For BBML3 the sequence is:
1) Get a reference count on the containing table for the new PTE.
2) Atomically update the PTE with the new valid descriptor.
3) Invalidate the TLB for the old PTE.
4) Drop the reference count holding the old PTE.

Add 2 helpers:
1) kvm_pgtable_use_bbml3(): Checks for the architecture requirement
   for BBML3.

2) stage2_use_bbml3(): Extra checks added by SW design (FWB and DIC)
   - As BBML3 will update the PTE atomically, it can only know it
     raced with another core at the point of the cmpxchg failing,
     unlike the SW implementation which locks the PTE first.
     And as we must issue CMOs to the new mapped page before the
     update, that means with BBML3 racing cores will issue redundant
     CMOs.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 111 ++++++++++++++++++++++++++++-------
 1 file changed, 90 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index d670da8882a5..a9ba761e9a01 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -82,6 +82,27 @@ static bool kvm_pte_table(kvm_pte_t pte, s8 level)
 	return FIELD_GET(KVM_PTE_TYPE, pte) == KVM_PTE_TYPE_TABLE;
 }
 
+/*
+ * Check if BBML3 can be used for this PTE update.
+ * Fallback to software break-before-make for leaf-to-leaf changes.
+ */
+static bool kvm_pgtable_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
+				  kvm_pte_t new)
+{
+	if (!system_supports_bbml3())
+		return false;
+
+	if (!kvm_pte_valid(ctx->old) || !kvm_pte_valid(new))
+		return false;
+
+	/* Block <-> Table is ok. */
+	if (kvm_pte_table(new, ctx->level) ||
+	    kvm_pte_table(ctx->old, ctx->level))
+		return true;
+
+	return false;
+}
+
 static kvm_pte_t *kvm_pte_follow(kvm_pte_t pte, struct kvm_pgtable_mm_ops *mm_ops)
 {
 	return mm_ops->phys_to_virt(kvm_pte_to_phys(pte));
@@ -835,25 +856,46 @@ static void stage2_clean_old_pte(const struct kvm_pgtable_visit_ctx *ctx,
 		mm_ops->put_page(ctx->ptep);
 }
 
+/*
+ * Don't use bbml3 for stage-2 if FWB or DIC are not supported
+ * as that means racing cores will issue duplicate CMOs.
+ */
+static bool stage2_use_bbml3(const struct kvm_pgtable_visit_ctx *ctx,
+			     kvm_pte_t new)
+{
+	if (!cpus_have_final_cap(ARM64_HAS_STAGE2_FWB) ||
+	    !cpus_have_final_cap(ARM64_HAS_CACHE_DIC))
+		return false;
+
+	return kvm_pgtable_use_bbml3(ctx, new);
+}
+
 /**
  * stage2_try_break_pte() - Invalidates a pte according to the
  *			    'break-before-make' requirements of the
- *			    architecture.
+ *			    architecture, if BBML3 is supported it
+ *			    will be used and this function won't
+ *			    break the PTE.
  *
  * @ctx: context of the visited pte.
  * @mmu: stage-2 mmu
+ * @new: New pte installed in make.
  *
- * Returns: true if the pte was successfully broken.
+ * Returns: true if the pte was successfully broken or BBML3 is used.
  *
  * If the removed pte was valid, performs the necessary serialization and TLB
  * invalidation for the old value. For counted ptes, drops the reference count
  * on the containing table page.
  */
 static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
-				 struct kvm_s2_mmu *mmu)
+				 struct kvm_s2_mmu *mmu, kvm_pte_t new)
 {
 	kvm_pte_t locked_pte;
 
+	/* All handled in stage2_make_pte() */
+	if (stage2_use_bbml3(ctx, new))
+		return true;
+
 	if (stage2_pte_is_locked(ctx->old)) {
 		/*
 		 * Should never occur if this walker has exclusive access to the
@@ -873,16 +915,37 @@ static bool stage2_try_break_pte(const struct kvm_pgtable_visit_ctx *ctx,
 	return true;
 }
 
-static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t new)
+static bool stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
+			    kvm_pte_t new)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
-
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
 
+	if (stage2_use_bbml3(ctx, new)) {
+		if (!kvm_pgtable_walk_shared(ctx)) {
+			/*
+			 * stage2_try_set_pte() uses WRITE_ONCE for non-shared walks,
+			 * lacking release semantics used in the software BBM case.
+			 */
+			smp_wmb();
+		}
+
+		if (!stage2_try_set_pte(ctx, new)) {
+			/* Raced with another core. */
+			if (stage2_pte_is_counted(new))
+				mm_ops->put_page(ctx->ptep);
+			return false;
+		}
+
+		stage2_clean_old_pte(ctx, mmu);
+		return true;
+	}
+
+	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
 	smp_store_release(ctx->ptep, new);
+	return true;
 }
 
 static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
@@ -1001,7 +1064,7 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 		return 0;
 	}
 
-	if (!stage2_try_break_pte(ctx, data->mmu))
+	if (!stage2_try_break_pte(ctx, data->mmu, new))
 		return -EAGAIN;
 
 	/* Perform CMOs before installation of the guest stage-2 PTE */
@@ -1014,7 +1077,8 @@ static int stage2_map_walker_try_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	    stage2_pte_executable(new))
 		mm_ops->icache_inval_pou(kvm_pte_follow(new, mm_ops), granule);
 
-	stage2_make_pte(ctx, new);
+	if (!stage2_make_pte(ctx, data->mmu, new))
+		return -EAGAIN;
 
 	return 0;
 }
@@ -1057,19 +1121,21 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
 	childp = mm_ops->zalloc_page(data->memcache);
 	if (!childp)
 		return -ENOMEM;
-
-	if (!stage2_try_break_pte(ctx, data->mmu)) {
-		mm_ops->put_page(childp);
-		return -EAGAIN;
-	}
-
 	/*
 	 * If we've run into an existing block mapping then replace it with
 	 * a table. Accesses beyond 'end' that fall within the new table
 	 * will be mapped lazily.
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+	if (!stage2_try_break_pte(ctx, data->mmu, new)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
+
+	if (!stage2_make_pte(ctx, data->mmu, new)) {
+		mm_ops->put_page(childp);
+		return -EAGAIN;
+	}
 
 	return 0;
 }
@@ -1549,18 +1615,21 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (IS_ERR(childp))
 		return PTR_ERR(childp);
 
-	if (!stage2_try_break_pte(ctx, mmu)) {
-		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
-		return -EAGAIN;
-	}
-
 	/*
 	 * Note, the contents of the page table are guaranteed to be made
 	 * visible before the new PTE is assigned because stage2_make_pte()
 	 * writes the PTE using smp_store_release().
 	 */
 	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
+	if (!stage2_try_break_pte(ctx, mmu, new)) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
+		return -EAGAIN;
+	}
+
+	if (!stage2_make_pte(ctx, mmu, new)) {
+		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
+		return -EAGAIN;
+	}
 	return 0;
 }
 
-- 
2.55.0.979.g7e5102b832-goog

