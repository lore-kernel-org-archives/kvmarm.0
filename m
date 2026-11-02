Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652443;
	b=xoTXGuSBhqZ2xE3S0p1ODoiXnQiK96RUhjiuNHlVspGvlnvKHU+benQ2KqXTt2prRLzx
	 rVvEGPP0pgCiNPBFPzallp1C3yxlmWnLpJp3IS5ylJn6kr567zkNu8QRALGlLt6LKjmJN
	 iKxLClJoMYhz3lvFTITpB4mKXVFQGEP5Fi7tQqgHieLR/jqsDkRRduCbyUVJuC02ZX/3R
	 NUGCJzOeYG3mzo1gC9hWdFk+iPN43juwmNxccz4z9HkoM5qcUWnKCA2oW+mHPpyIjwAqK
	 reJU/+P4InVl4HybHcUbUw/4gmtwGQ18Tgl61aWB1OlxPN5Utw81PG+RvGlj7C0PoDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652443;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=FrKaF8369FUs2Vi+hmG02tOP08987jT6Bv1rZZj0tP4=;
	b=kHektSW13qZyHNnfk8cnUlnlgbhqnyzjsip9qQN5Gql4ojQSFXOSD8QpcxdNnJCVx/mI
	 l7LOPfKVBKRu2HwHaP7pp4o4tF4njTt/GIbDp1Y8MixAfuTNwySkzGoqHFBIBnjtGvNZB
	 3FJoxur5RysEUxWGgb7hyxiPb9a7TOIVui6fCsk+gNldAbNONfmz++GSd+vSVYwIeUBev
	 dPasuZ3do82kmFzbUKK8DG7uqUTDALHlTCpyDAvMINyJQlxZsvg0Abaqyv7roLYvKoKZR
	 xea0qvKrcedVCQVzJzfVej2Myohsr26WrlHD/HC0WIQYKJGM/OMBlrMjgrPrzMh6dFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j5Wk+0Bv;
	arc=none smtp.remote-ip=209.85.128.69
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C168E606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C168E606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=j5Wk+0Bv
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-4a16dc2323cso29287205e9.3
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652441; x=1794257241; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FrKaF8369FUs2Vi+hmG02tOP08987jT6Bv1rZZj0tP4=;
        b=j5Wk+0BvrEw2DUyfAE6DWa/B4i1yMcHzMTwJCKM3ZUEKykLAFHFFtylRUqmd6DTmMy
         gd2sx7Z7uFP6NOvBRrHxzLI4/7ZVKO6B9LvlpsEJipmPcGtX6l5ME4HQxc+GX5HPWZX+
         ttURijy32GTHwvjfVrPDYcJlnNL9kV3lCUYs48wxrIzEt7l/qccGVArMamGbYnJRyJ2I
         dYbJUK6zF2gKKk6Ab/Cc0CgjdLI9yDMzjJTsYNP8ARZyP0FlmZ5DdfFyDr3pZ2vO1wU3
         u8/kqiM3dRx/Bd2nZIrSLNXft82cJUJUhNFGfC/3mt0wkoO4sEVxjOTHOYNQXIU0++v1
         qD2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652441; x=1794257241;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FrKaF8369FUs2Vi+hmG02tOP08987jT6Bv1rZZj0tP4=;
        b=DCemtLYfPdWaBzXo/mVAxjC+PJ49MHzPUdcG10TQfdF1zVtwGmaVPUF3t2CRBjwQK/
         s719JzzQa83HoHqVJz5/fdegWwlgXUPEDbw467Yf0nseFrZDRpbDiwIvhTT/2TK0vLt8
         6yFcbh/vtf609qkIjVYtpB38xTBEHyuCbMRVf/n/z/uRqkhiZU9uUc3cbPQcHmmTx7pj
         /rP2Ze8txBHHBdasPjfjdvbSz2ATs6LbHh09DKXx61LBHOMXFGLMXeKstMqhNLobHWK3
         OcS8wLcnFaErL4KEydz7KHTqiXHhThl+KR9BxF0WLCAXCq/ost8Mw7qHLgZNRvVhJ81B
         S0dw==
X-Forwarded-Encrypted: i=1; AKwUvBy4aSLmVjYmPDyTvv27TpqVV+JtmXjNpLUSRcFHAGyqbSoQA/GbYwwjyAYczo3+MMrPLyR2TX4=@lists.linux.dev
X-Gm-Message-State: AFq9FYIUorUF5AKyFBh6Tw6NGG4w24AEXQpGJgy+k6xOUox1pIPWN+fo
	gSBledm+4ePrjiIwljAgq0ltc7+5UF67yl5DgYOcxQhA6h73MAkNxnbkggrChTPFcvl9CzCZO9g
	T5rmt/uL9uRzDutdvUUr0eA==
X-Received: from wrnb2.prod.google.com ([2002:adf:e642:0:b0:48e:579c:a0fa])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:628d:b0:4a1:f7f4:7ced with SMTP id 5b1f17b1804b1-4ac185bd243mr258596025e9.17.1793652441187;
 Mon, 02 Nov 2026 12:47:21 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:23 +0000
In-Reply-To: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261102204628.401871-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261102204628.401871-19-vdonnefort@google.com>
Subject: [PATCH v3 18/23] KVM: arm64: Introduce kvm_pgtable_stage2_table_install()
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
index 1c9c57cd6ae4..587874c3a525 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -835,6 +835,18 @@ int kvm_pgtable_stage2_flush(struct kvm_pgtable *pgt, u64 addr, u64 size);
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
index abd32e94f6ff..19634e5ec555 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -1537,18 +1537,38 @@ static int stage2_block_get_nr_page_tables(s8 level)
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
@@ -1590,18 +1610,12 @@ static int stage2_split_walker(const struct kvm_pgtable_visit_ctx *ctx,
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
 
@@ -1620,6 +1634,55 @@ int kvm_pgtable_stage2_split(struct kvm_pgtable *pgt, u64 addr, u64 size,
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
2.56.0.385.gac671c819a-goog

