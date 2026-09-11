Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6763F40E8D6
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134689; cv=none; b=YPxeAsEvLox7aFEHxG54mZqAWkNmQw0kB/maAHYKenzfZ6AI/XCT42TOOB89djdm4GPsHmq8pfIlAXbsF2ZLQJgb9qCawik6iY0NQ1sq0qoQ4Qbyerj6f2x9y8V6r1q3g9VEVzzdUHlxZV39Nw76JtF6ynglD5E2QBUeIQYWGvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134689; c=relaxed/simple;
	bh=qWySg4maIfcimusRnp2qjWq9ZCAdJ+qT/Jx4w1eO6gE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sq9yvcTWcmcJiwaaYYavk0v1XujD5j7p2/Uc3VYRZk6B0qhIVS4fxD2hDhhatF+7yTmvSa0q9REqTpfdm8NGfSa4dDEdVY0fHxrd0BlwKTV7CJlDHf3UbegXFyXguG/NLdacRm/U2pg7QhaWiAEzACYqgQAzD0H1xU3Gu8yeoaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RgBATJAq; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RgBATJAq"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a9b526a19fso1207145a12.3
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134682; x=1789739482; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/pTg2vf1jjIMBVtegu9b0KSVQwmbhLOaMelrOQMA6JM=;
        b=RgBATJAqy3Yc2WoRQHtDmZnp0JM59An4Lthq1lfQ4lZXPVMWZ5a/nsoNNguUr97w5b
         Du4+X8C3v9cnaQ0P6vPp7nWMt9NopNAIiw2AAx1YHaZjC78Qo7XDdX8zMMZJtcd6IH6l
         TaV70ma3or4VBxHD3sBYumPAN0fSgi75DIH07mkonV45dyPE7otGKwBaJxCImEln6sfl
         I3Cvv25YiW/XYPXs/vOh03sijSOWe3tUCN8eHdlL8157dZl4GmXg5ikC51H2GZEGDcay
         jVeo1Wkh+NryyizA6I7+lrB3zhF/5GsKtHri9lxf33xUQGSV0aDeg+iJc9mtpIB6Mofj
         8ULQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134682; x=1789739482;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/pTg2vf1jjIMBVtegu9b0KSVQwmbhLOaMelrOQMA6JM=;
        b=hDXp2GFLdUqD1+Q/i5GPSdr04p+WzyyTCSnxURW5k0quaVJGMFO8Wno8hz/97gOwoa
         5bL8BlnNF1BFBYeV7WTeKCfpui4NifzPVnc1M08A12jW3706UfXYpVw35/OChZrcmyao
         v2VUpXAO7EGif2FTFh3Ww9Wv5ze50wG9fnz56Kw+RNFkxWQLLabfpDfTmli0zHG8xb3I
         5Oww3ODbgAv2UgLYHQotFVHdnhZSFf55Bxmt+8nsjgHd1esFu9qznAMrtuleqHq9S0za
         RAH0ZDVjOr7JE+NXOTaDnIvCln4cFJ9aMRqk4OKL8+zGKnIx4HzsLeoy/jUxLGKxcwQM
         3ZnA==
X-Forwarded-Encrypted: i=1; AKwUvBzg0uyUkk6HgCIY+2c2NQBwUuqNJO4vmS5RyE74mX4QVcMwGdz3K6j3/c+TjrDUe5xBpMDDsVc=@lists.linux.dev
X-Gm-Message-State: AFuF++kBkJkf930FfJSAQBVRoenDUEXoDLa9Yxo92Rgtk9AK9n0Z96LQ
	y2oUiiZZCiw1plP7iUyzesIqmWv5yqKWlyRojiIqruVVWjwVA2H/AbyFipwTKMTpK6CDcG/ua5S
	fo+LpaUhIcItiwa490d18pA==
X-Received: from edad9.prod.google.com ([2002:a05:6402:4009:b0:6a7:e6d1:c763])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:3889:b0:6a9:a5e7:f8be with SMTP id 4fb4d7f45d1cf-6a9b5655206mr1868948a12.5.1789134681903;
 Fri, 11 Sep 2026 06:51:21 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:48 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-18-vdonnefort@google.com>
Subject: [PATCH v2 17/22] KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

The existing kvm_pgtable_stage2_split() is unfit for pKVM: it relies on
kvm_mmu_memory_cache which pKVM doesn't use and has no easy way to
handle pKVM-specific annotations.

Add the pgtable helper kvm_pgtable_stage2_table_install() so pKVM can
handle block splitting in mem_protect.c. That helper can take a table
either populated with kvm_pgtable_stage2_create_unlinked() or one filled
with annotations.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/include/asm/kvm_pgtable.h | 12 ++++
 arch/arm64/kvm/hyp/pgtable.c         | 85 ++++++++++++++++++++++++----
 2 files changed, 86 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 41a8687938eb..24d6e05d8050 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -827,6 +827,18 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
 int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 			     struct kvm_mmu_memory_cache *mc);
 
+/**
+ * kvm_pgtable_stage2_table_install() - Replace a stage-2 leaf entry with a table.
+ * @pgt:	Page-table structure initialised by kvm_pgtable_stage2_create_unlinked().
+ * @addr:	Address identifying the leaf entry to replace.
+ * @size:	Size of the block to replace.
+ * @tab:	Pointer to the pre-allocated table to install.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, u64 addr, u64 size,
+				     kvm_pte_t *table);
+
 /**
  * kvm_pgtable_walk() - Walk a page-table.
  * @pgt:	Page-table structure initialised by kvm_pgtable_*_init().
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c4ebae0544d4..6c85af51002d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1533,18 +1533,38 @@ static int stage2_block_get_nr_page_tables(s8 level)
 	};
 }
 
+static int stage2_table_install(const struct kvm_pgtable_visit_ctx *ctx,
+				struct kvm_s2_mmu *mmu,
+				kvm_pte_t *table)
+{
+	kvm_pte_t new;
+
+	if (!stage2_try_break_pte(ctx, mmu))
+		return -EAGAIN;
+
+	/*
+	 * Note, the contents of the page table are guaranteed to be made
+	 * visible before the new PTE is assigned because stage2_make_pte()
+	 * writes the PTE using smp_store_release().
+	 */
+	new = kvm_init_table_pte(table, ctx->mm_ops);
+	stage2_make_pte(ctx, new);
+	return 0;
+}
+
 static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 			       enum kvm_pgtable_walk_flags visit)
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 	struct kvm_mmu_memory_cache *mc = ctx->arg;
-	struct kvm_s2_mmu *mmu;
-	kvm_pte_t pte = ctx->old, new, *childp;
+	kvm_pte_t pte = ctx->old, *childp;
 	enum kvm_pgtable_prot prot;
+	struct kvm_s2_mmu *mmu;
 	s8 level = ctx->level;
 	bool force_pte;
 	int nr_pages;
 	u64 phys;
+	int ret;
 
 	/* No huge-pages exist at the last level */
 	if (level == KVM_PGTABLE_LAST_LEVEL)
@@ -1586,18 +1606,12 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (IS_ERR(childp))
 		return PTR_ERR(childp);
 
-	if (!stage2_try_break_pte(ctx, mmu)) {
+	ret = stage2_table_install(ctx, mmu, childp);
+	if (ret) {
 		kvm_pgtable_stage2_free_unlinked(mm_ops, childp, level);
-		return -EAGAIN;
+		return ret;
 	}
 
-	/*
-	 * Note, the contents of the page table are guaranteed to be made
-	 * visible before the new PTE is assigned because stage2_make_pte()
-	 * writes the PTE using smp_store_release().
-	 */
-	new = kvm_init_table_pte(childp, mm_ops);
-	stage2_make_pte(ctx, new);
 	return 0;
 }
 
@@ -1616,6 +1630,55 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
 	return ret;
 }
 
+struct stage2_table_install_data {
+	struct kvm_s2_mmu	*mmu;
+	kvm_pte_t		*table;
+};
+
+static int stage2_table_install_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				       enum kvm_pgtable_walk_flags visit)
+{
+	struct stage2_table_install_data *data = ctx->arg;
+	struct kvm_s2_mmu *mmu = data->mmu;
+	kvm_pte_t *childp = data->table;
+
+	if (ctx->level == KVM_PGTABLE_LAST_LEVEL)
+		return -EINVAL;
+
+	if (ctx->addr != ctx->start ||
+	    ctx->end != ctx->addr + kvm_granule_size(ctx->level))
+		return -EINVAL;
+
+	/*
+	 * On success, return a positive value to prevent descending into the
+	 * new table.
+	 */
+	return stage2_table_install(ctx, mmu, childp) ?: 1;
+}
+
+int kvm_pgtable_stage2_table_install(struct kvm_pgtable *pgt, u64 addr, u64 size, kvm_pte_t *table)
+{
+	struct stage2_table_install_data data = {
+		.mmu	= pgt->mmu,
+		.table	= table,
+	};
+	struct kvm_pgtable_walker walker = {
+		.cb	= stage2_table_install_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &data,
+	};
+	int ret;
+
+	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EINVAL;
+
+	dsb(ishst);
+	return 0;
+}
+
 int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 			      struct kvm_pgtable_mm_ops *mm_ops,
 			      enum kvm_pgtable_stage2_flags flags,
-- 
2.55.0.1007.g17ff1f9808-goog

