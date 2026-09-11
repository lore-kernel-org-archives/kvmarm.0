Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 697D247D44B
	for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789134670; cv=none; b=nsVDG3TNiluYXIyJiIWlQTSe1AV96YHcMW3mKC5UhrlFKucCPorAhhWgWv0Hetf8cq6v/xRtfv2Q0boeizwQgb0u9wg1GzlIRDiNEW9nbQA6IxwOFw22L1OEdpabwH2cMGbCD0S/qzGmSOuLFfcPqc2C1EBwGYY0ojk39nHTREA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789134670; c=relaxed/simple;
	bh=uSJiiOotgrsOJnsbaokIb9IMsZ3c58y/MChRoOTx2LI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jcsICp9Rk9eSRC1D/3Nt6Wrjd0o3yEOqCm+nIuM+7outl6fye2d+5zXSCJyp3TslJp5aYJSuWO1CHi4JhcjHTk+YizXx/cKnkROIJ+q9dT7aCvQwUQVqzbf95xYbClYKsJHu9/TKQrnFtCdBJFXS2EV7ZJO9BZuB73oky44yJyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YOZlmBcm; arc=none smtp.client-ip=209.85.208.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YOZlmBcm"
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-6a178080182so1040059a12.2
        for <kvmarm@lists.linux.dev>; Fri, 11 Sep 2026 06:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789134666; x=1789739466; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SFk2Z6Xi7d6Da3C0kQCSLnpvItVd8hZ6EBv2sHcLHBQ=;
        b=YOZlmBcmkQr/6+o8kQoXCoHv+DSgxvb9PW0ixFhDNLalYZH029r6ofDQQWbtfCklbs
         tLp/R/Fx5sG4y4CbBjYDBn7dmJYJGT4VxOgU8AZ/MpDM0MkNo01if48qeSa1TpqWOdq0
         +t04vTqYUSpWUljNoHK0C1lCjjKXQ8EKZI8JlhZdply83uiCyqhv03w3JxOi5tvrEMEY
         7MHdsLReFam8bOy2nBut7A5b9jXj3qOOdgebjINJBFWNslJxDHI8EVRkLXzI4O6I62W1
         XU+gJOmK7W/RUzn+kE3TKjlFFZzYzz6Y+ESESizpY7g8woput/yJgcuaWpIzaGPt39t4
         avLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789134666; x=1789739466;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SFk2Z6Xi7d6Da3C0kQCSLnpvItVd8hZ6EBv2sHcLHBQ=;
        b=MtxBSYFZa2Q4B5o0U+jrh0NjFEzWAtkedCe/BDiVIH0ADPpA1Cy/jhVmxGMKQDw+9+
         S2QkJLNRIK3+ZZaolK0VdbyUpTFkYOZtuii0Q+tqO87pVOkrraCFupZbq2bqK13BQ7rA
         2ACd8v1NyKyos7S1P4TeoOFUEr8qt1nwkB858It6h7hqISSPmOhqg0M5IuHAGN8N/d6T
         gMbzvNkvxSE0p/TaienXdcj1p6zxPuD0GRSeRSeYcbvmOseJb9vPHPkiq+u/gmZld/Ja
         enxQ3I4mKl1WT39E9OGN6Lm9qf0bdPaFzYae5WAPetq84AhlOQf7YkY3Mqf3O3jrOns9
         jk8A==
X-Forwarded-Encrypted: i=1; AKwUvBz148pMMDKVo6mSu4QHgzXYUHOcXo0os42qSb33DySVlICEQd1DxLUTtPtuEpCe56SyITeDk10=@lists.linux.dev
X-Gm-Message-State: AFuF++lcOqAIE/UF7ajiIsO6OXKQMhPw7DVFcOF1V8k2HCjIhh2qla/H
	jUH1LEMLJ8jG1DLAV6XSp0n9tJDni1JB55M/zeF76aEzZF1pWq+mOtDC8P2F3ruBWm07n3R/HlO
	BkIE52uDN09QYmwF9gzXfLQ==
X-Received: from edbdd4.prod.google.com ([2002:a05:6402:3124:b0:6a6:62f4:91a4])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2546:b0:6a6:37a3:2b0f with SMTP id 4fb4d7f45d1cf-6a9b5606356mr1900256a12.8.1789134665990;
 Fri, 11 Sep 2026 06:51:05 -0700 (PDT)
Date: Fri, 11 Sep 2026 14:50:35 +0100
In-Reply-To: <20260911135053.146435-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260911135053.146435-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260911135053.146435-5-vdonnefort@google.com>
Subject: [PATCH v2 04/22] KVM: arm64: Use block-level annotations when setting
 up the host stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, qperret@google.com, 
	weilin.chang@arm.com, Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

During pKVM initialisation, fix_host_ownership() configures the host
stage-2 mappings to match the hypervisor stage-1. Previously this was
done page-by-page. Now that the host stage-2 supports block-level
annotations, refactor the walker to apply the ownership state to an
entire range at once.

This reduces host stage-2 page-table fragmentation and memory usage by
avoiding allocation of intermediate page-table pages.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/memory.h |   5 +
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    |   5 -
 arch/arm64/kvm/hyp/nvhe/setup.c          | 132 ++++++++++++++---------
 3 files changed, 89 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index b50712d47f6d..86a51cf1d590 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -122,6 +122,11 @@ static inline void set_hyp_state(struct hyp_page *p, enum pkvm_page_state state)
 	p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_VMEMMAP_MASK;
 }
 
+#define for_each_hyp_page(__p, __st, __sz)				\
+	for (struct hyp_page *__p = hyp_phys_to_page(__st),		\
+			     *__e = __p + ((__sz) >> PAGE_SHIFT);	\
+	     __p < __e; __p++)
+
 /*
  * Refcounting for 'struct hyp_page'.
  * hyp_pool::lock must be held if atomic access to the refcount is required.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 39aa8911f62c..c3676243fddc 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -76,11 +76,6 @@ static void hyp_unlock_component(void)
 	hyp_spin_unlock(&pkvm_pgd_lock);
 }
 
-#define for_each_hyp_page(__p, __st, __sz)				\
-	for (struct hyp_page *__p = hyp_phys_to_page(__st),		\
-			     *__e = __p + ((__sz) >> PAGE_SHIFT);	\
-	     __p < __e; __p++)
-
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 75b00c323310..22200bb50990 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -186,50 +186,46 @@ static void hpool_put_page(void *addr)
 	hyp_put_page(&hpool, addr);
 }
 
-static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
-				     enum kvm_pgtable_walk_flags visit)
+struct fix_host_ownership_data {
+	phys_addr_t		phys;
+	size_t			size;
+	enum kvm_pgtable_prot	prot;
+};
+
+static int __fix_host_ownership(const struct fix_host_ownership_data *data)
 {
-	enum pkvm_page_state state;
-	struct hyp_page *page;
-	phys_addr_t phys;
-	enum kvm_pgtable_prot prot;
+	enum pkvm_page_state state = pkvm_getstate(data->prot);
 
-	if (!kvm_pte_valid(ctx->old))
+	if (!data->prot)
 		return 0;
 
-	if (ctx->level != KVM_PGTABLE_LAST_LEVEL)
-		return -EINVAL;
-
-	phys = kvm_pte_to_phys(ctx->old);
-	if (!addr_is_memory(phys))
-		return -EINVAL;
-
-	page = hyp_phys_to_page(phys);
-
 	/*
 	 * Adjust the host stage-2 mappings to match the ownership attributes
 	 * configured in the hypervisor stage-1, and make sure to propagate them
 	 * to the hyp_vmemmap state.
 	 */
-	prot = kvm_pgtable_hyp_pte_prot(ctx->old);
-	state = pkvm_getstate(prot);
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		set_hyp_state(page, PKVM_PAGE_OWNED);
-		/* hyp text is RO in the host stage-2 to be inspected on panic. */
-		if (prot == PAGE_HYP_EXEC) {
+		for_each_hyp_page(page, data->phys, data->size) {
+			set_hyp_state(page, PKVM_PAGE_OWNED);
 			set_host_state(page, PKVM_NOPAGE);
-			return host_stage2_idmap_locked(phys, PAGE_SIZE, KVM_PGTABLE_PROT_R);
-		} else {
-			return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 		}
+		/* hyp text is RO in the host stage-2 to be inspected on panic. */
+		if (data->prot == PAGE_HYP_EXEC)
+			return host_stage2_idmap_locked(data->phys, data->size, KVM_PGTABLE_PROT_R);
+		else
+			return host_stage2_set_owner_locked(data->phys, data->size, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
-		set_hyp_state(page, PKVM_PAGE_SHARED_OWNED);
-		set_host_state(page, PKVM_PAGE_SHARED_BORROWED);
+		for_each_hyp_page(page, data->phys, data->size) {
+			set_hyp_state(page, PKVM_PAGE_SHARED_OWNED);
+			set_host_state(page, PKVM_PAGE_SHARED_BORROWED);
+		}
 		break;
 	case PKVM_PAGE_SHARED_BORROWED:
-		set_hyp_state(page, PKVM_PAGE_SHARED_BORROWED);
-		set_host_state(page, PKVM_PAGE_SHARED_OWNED);
+		for_each_hyp_page(page, data->phys, data->size) {
+			set_hyp_state(page, PKVM_PAGE_SHARED_BORROWED);
+			set_host_state(page, PKVM_PAGE_SHARED_OWNED);
+		}
 		break;
 	default:
 		return -EINVAL;
@@ -238,6 +234,66 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	return 0;
 }
 
+static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
+				     enum kvm_pgtable_walk_flags visit)
+{
+	struct fix_host_ownership_data *data = ctx->arg;
+	enum kvm_pgtable_prot prot = 0;
+	phys_addr_t phys = 0;
+	int ret;
+
+	if (kvm_pte_valid(ctx->old)) {
+		prot = kvm_pgtable_hyp_pte_prot(ctx->old);
+		phys = kvm_pte_to_phys(ctx->old);
+		if (!addr_is_memory(phys))
+			return -EINVAL;
+	}
+
+	if (prot == data->prot &&
+	    phys == data->phys + data->size) {
+		data->size += kvm_granule_size(ctx->level);
+
+		return 0;
+	}
+
+	ret = __fix_host_ownership(data);
+	if (ret)
+		return ret;
+
+	data->phys = phys;
+	data->size = kvm_granule_size(ctx->level);
+	data->prot = prot;
+
+	return 0;
+}
+
+static int fix_host_ownership(void)
+{
+	struct fix_host_ownership_data data;
+	struct kvm_pgtable_walker walker = {
+		.cb	= fix_host_ownership_walker,
+		.flags	= KVM_PGTABLE_WALK_LEAF,
+		.arg	= &data,
+	};
+	int i, ret;
+
+	for (i = 0; i < hyp_memblock_nr; i++) {
+		struct memblock_region *reg = &hyp_memory[i];
+		u64 start = (u64)hyp_phys_to_virt(reg->base);
+
+		data = (struct fix_host_ownership_data){ 0 };
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
+		if (ret)
+			return ret;
+
+		ret = __fix_host_ownership(&data);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx,
 					 enum kvm_pgtable_walk_flags visit)
 {
@@ -252,26 +308,6 @@ static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx
 	return 0;
 }
 
-static int fix_host_ownership(void)
-{
-	struct kvm_pgtable_walker walker = {
-		.cb	= fix_host_ownership_walker,
-		.flags	= KVM_PGTABLE_WALK_LEAF,
-	};
-	int i, ret;
-
-	for (i = 0; i < hyp_memblock_nr; i++) {
-		struct memblock_region *reg = &hyp_memory[i];
-		u64 start = (u64)hyp_phys_to_virt(reg->base);
-
-		ret = kvm_pgtable_walk(&pkvm_pgtable, start, reg->size, &walker);
-		if (ret)
-			return ret;
-	}
-
-	return 0;
-}
-
 static int fix_hyp_pgtable_refcnt(void)
 {
 	struct kvm_pgtable_walker walker = {
-- 
2.55.0.1007.g17ff1f9808-goog

