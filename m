Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793652427;
	b=Hyl6PdmfHcPdlGvENsGYZJJ/+gzBCEsOFAEHnY0hKopAbpYIH4hWU9NRQDtsA+rjpFfz
	 mwO2OxyO/zkKx3wFIRcT/i08WhZFeRt3CuU0JB7EfWhjo/7BX/pyC04UTj2a9WmKPIBs+
	 gfM9CixNLJmaR7QgWiBtYKJtVbxB3VDpt1tbKcU+RU5NEwroG2ILqdnlYzMN1EY+dorgA
	 SfBVQCs59XOC4J8WClp+Lf2yMq3KWBCOeX+p+yAAC2Jg8K1FT4qhxgojA8owFKRN1N7uZ
	 LmiFQjk5+UoBlwKO1zRMakikaYszqBmgfLdXKhDXgd88/UZOQXKOwUtxZ1dntnOXT7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793652427;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=MZQux3Jpn+/KtJ7ZhOVOZlF+zjF+/1BvGRCOtT2ZllI=;
	b=HDkF2rbqNFDar+hcrTt83lo3l5UVWCb3shMn6R7x1glZKjfhxxNXZLSblvZeeCsuOEs6
	 fTqutrFp6UXcMQkET8udsWie+Ot1TXT5QxFQisWGj7atIJ3wDArvUnKhlhArnLXoQQiA9
	 lXc85YfVBh8lhuIjGR5AzZvnE3slGA+3qNYtmFYamLjdaD+6WmI6q3ncUDps1Iltg6dc5
	 1Kja8tZ8qutcxtNVD0ghM0CH1sZ2G82xMlbM1xzGIakwup53oifokK0Qh7NBI9/HPGI3G
	 oXNwy3581UBd1eEKc3HW2E7YugREHNU1yThto7sfTs2FEr44wh/K8AJ93Nb7D7kVRdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TKQgI9F3;
	arc=none smtp.remote-ip=209.85.221.71
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C221606A326
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 20:47:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3C221606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TKQgI9F3
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48c6a1d4034so2993347f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 02 Nov 2026 12:47:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793652426; x=1794257226; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MZQux3Jpn+/KtJ7ZhOVOZlF+zjF+/1BvGRCOtT2ZllI=;
        b=TKQgI9F3F6TOp0OeYWh6bqjGWha1fNAnq0IuEPRFfivU/wqXkKSdqiAAMtnJQIr4rC
         1FJApLrh8Z7M+P4h91P3TyjzY3aE/j+IKKycrcc4A51VoEXP+5oI6p7GLSoYInz5Kpgg
         WrehkV8PYnmn6c+XyBp2BG4/HnSO8P7uh9mQv0bI3hdjf6nQvzzI8NjedYaDUoE0oFvl
         CbLQhuA0r0EQu1I7yrnrKXZnMHWxUCzqcj2zjnFwmvNMRkmr0FAXX7qxR1zpWjCtWxrf
         I9daZtF/F3Leey/65psnoG2VxYLilvAp/se2wlV/rH1KEBvrtITJEHNpgeSjf+D77fJk
         kMcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793652426; x=1794257226;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MZQux3Jpn+/KtJ7ZhOVOZlF+zjF+/1BvGRCOtT2ZllI=;
        b=p4ETKoUC9fCwdpu7FbtbU0BKjON4HKMCAxLUflhdUgOa3zFid7JT03roV6JBPSCmsX
         hYOzPBkyPGqGD2f8Mo4/nrap9mVnPgvCe4ZZ8T2PZwkpIDtE0it2SqMLL2VEal4g7B18
         wn7m32PRCPfVgT7ApM4cJQbGMyQt/OPf+lYL7aePBapLgXTfdx+HmTrbrxRDrGwKP1QM
         frr4g7FHoo2um8eRYmynrAYLujilLeTlhZoto3fiolc0fPEcLDdDZ5/h0RugTAGSfpco
         rSjN9PxYkQMyAoPKoZ8EcRPqvMumTHR1XHpxma2yLEpXC3L4EeliKCrHStl+FVqlXvGP
         bzfA==
X-Forwarded-Encrypted: i=1; AKwUvBxgIkwvXEvxCps4CJBXKV/Bacx5S7mGGHmD07z1VwWL9pNjz1GptomAyd9pv01PuK2VTtI3Wyc=@lists.linux.dev
X-Gm-Message-State: AFq9FYLIcTX7x8k9bTNDfC90H4Xv/eR6UTVIsDd+NfGCG+5D1Nl2E3vQ
	HmuJiseu4ZfGWmLkFKAho7rv1KzGJm46oXdcVNgzlRubQnGYYuPjFyCJCvXr1zwix9E53zg/kdb
	jcSyiTTyXpzQOlRZGBh6+pA==
X-Received: from wmbel6.prod.google.com ([2002:a05:600c:3e06:b0:4a1:7fbd:344d])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6095:b0:4a3:7344:13b5 with SMTP id 5b1f17b1804b1-4ac182dcb98mr226181805e9.16.1793652425494;
 Mon, 02 Nov 2026 12:47:05 -0800 (PST)
Date: Mon,  2 Nov 2026 20:46:09 +0000
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
Message-ID: <20261102204628.401871-5-vdonnefort@google.com>
Subject: [PATCH v3 04/23] KVM: arm64: Use block-level annotations when setting
 up the host stage-2
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oupton@kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	kernel-team@android.com, fuad.tabba@linux.dev, 
	Vincent Donnefort <vdonnefort@google.com>
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
 arch/arm64/kvm/hyp/nvhe/setup.c          | 157 ++++++++++++++---------
 3 files changed, 104 insertions(+), 63 deletions(-)

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
index d4c332a91803..58094d52b8a2 100644
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
index 7bbc26b28faa..e72b7626799d 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -187,50 +187,46 @@ static void hpool_put_page(void *addr)
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
-		if (addr_is_hyp_text(phys)) {
+		for_each_hyp_page(page, data->phys, data->size) {
+			set_hyp_state(page, PKVM_PAGE_OWNED);
 			set_host_state(page, PKVM_NOPAGE);
-			return host_stage2_idmap_locked(phys, PAGE_SIZE, KVM_PGTABLE_PROT_R);
-		} else {
-			return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 		}
+		/* hyp text is RO in the host stage-2 to be inspected on panic. */
+		if (addr_is_hyp_text(data->phys))
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
@@ -239,6 +235,81 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
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
+	/* The stacks sit in the private VA range, not the linear map. */
+	for (i = 0; i < hyp_nr_cpus; i++) {
+		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
+		u64 start = params->stack_hyp_va - NVHE_STACK_SIZE;
+
+		data = (struct fix_host_ownership_data){ 0 };
+		ret = kvm_pgtable_walk(&pkvm_pgtable, start, NVHE_STACK_SIZE, &walker);
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
@@ -253,36 +324,6 @@ static int fix_hyp_pgtable_refcnt_walker(const struct kvm_pgtable_visit_ctx *ctx
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
-	/* The stacks sit in the private VA range, not the linear map. */
-	for (i = 0; i < hyp_nr_cpus; i++) {
-		struct kvm_nvhe_init_params *params = per_cpu_ptr(&kvm_init_params, i);
-		u64 start = params->stack_hyp_va - NVHE_STACK_SIZE;
-
-		ret = kvm_pgtable_walk(&pkvm_pgtable, start, NVHE_STACK_SIZE, &walker);
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
2.56.0.385.gac671c819a-goog

