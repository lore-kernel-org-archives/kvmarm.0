Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794937463;
	b=JBli1YlLBLYN2Adm0ufVws5DicpjInYI8yXa8jpdHVWIYXjfiqrUQ8MGLdGxCfbYWGqB
	 i2pVtrBaqqWx5lD2R6r++sEONr8t3wGvm1jZ6ZTgvXqLokuD/Cy3E28lGuFN0ySMlBl+r
	 M1kYTRcCrAemMLTSiFW8u2Lt3p/xqZKs5ICEwWlJJM+l7D2T/VHUq2fZvXnPyB8VL0AR2
	 M9vNVm/kDTVLgCJm797TopvZMcNsCdncC2kqdE5JkS4qRUqlspEYBmhgBa7DXapij0my7
	 r2hwNOXNlmHT8AJa+cNozBgO6lx/hjIzOlD3JITI7OiMFLrmvSfBBsSmnwyhzSu12iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794937463;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=vTaHZCSWdFFTXqo9G5D3lZQ7MAOWE28tCTSPWpkrVJs=;
	b=FyXn31ZEV9777NFkPmNpQ18hBtKGyzAI1qYqN5AHxcxds3b26eg6h1quayL2NH073J0s
	 88r8pguUsxv8kLq6ZBiuKkQZG+IzyUwcZs0qiUOKAbwSGp7pcea8kNab+/aOxAAsQfG7s
	 qNUL8ohzzRh/uyBqYfgZ+Vqo68QzvMS+9X543kTlYLGt2Jz6y4kUjGnLA7TplWcCgETtJ
	 oqhd175LWsZA3EpelJqPg+kQjee6SYzGnwZ4UTGOYSpIqKFLt4fxafa5R8KccSmrrTTzi
	 NyQ20x1t43A7VxHnJOGVNn82r9PA1ELgXabcqIzx1k8gH/DooqA40oXAMxrCx+iTbtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="U506/k7C";
	arc=none smtp.remote-ip=209.85.218.71
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C17D606A331
	for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 17:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2C17D606A331
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=U506/k7C
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c4d288b67ccso356929666b.0
        for <kvmarm@lists.linux.dev>; Tue, 17 Nov 2026 09:44:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794937461; x=1795542261; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vTaHZCSWdFFTXqo9G5D3lZQ7MAOWE28tCTSPWpkrVJs=;
        b=U506/k7CYPbjMbNrXu9xSjJ9ZFT0SNIpYoFpWX/jn3KN1D1Wx8VkyPoyOdSgy04RDW
         3yzOyhk7G8HuMIjcKjYUqN1Y9St45o3xqyK6OlHHiBgYPEjZSGod5Excbqm12ksC+Mhr
         kJZCxMgkjWBKApnKenxehViuLtlxoEXrZccAe12FH4z2kLHiJnREr/OfIIq9QSPAHEDV
         RWb7vEFwZGi++HBc/T4w7KLA43glZeERG3cpXseGiW33EpDlDQg1WhIjlCexgffdC8AJ
         5/SBXE+yoRRbk5akMcWWpXuFPzRSt3fN9Adn5NsJMF5hpte8nBN82NTyjbrjQAC8Ek4O
         WTuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794937461; x=1795542261;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vTaHZCSWdFFTXqo9G5D3lZQ7MAOWE28tCTSPWpkrVJs=;
        b=A99ZPXrCG+35HIGu5xILGidn5/sksJXLO8kkyJReejudTxCtkMllzSMnD+HqU4LG9V
         lq4fdIEXsMKvsKJzTXgiE8Oovmi+dWmqAMqyb5cjdIWQq4uPVNN9cFFXVwykvCbSTzuH
         lCXCqlz8/vxQDQnb4SjQkU2iRLU1JzDboiNfAcYP6y07OziNFyKRrn53xgHHsLz/Y/p7
         sFyOvw922ekJ8E2OdOAgSniBkfznxfVhmKXytf9hpc7F84BGZHo2T97Wr2g6p3ynQ8Ot
         zjdEzAH3Eg/pJGpCAhmPKmylvEsthNjDVE9emjdsbIkKiHH5gxcWOohdZC2fcE2Jf77z
         wDQg==
X-Forwarded-Encrypted: i=1; AL+hErHqtVPf88raAcY3z8vvML2PMUUL+zPcAlveXaijTkBzq7RMPzSwuQlz8joGoFSkTv/68+ZgSlQ=@lists.linux.dev
X-Gm-Message-State: APuU4Z8Q2HN+CAess3HoKlgfpAt4otm8pY6jW8nJya6Bpq34j2fBKz8o
	rVzArxyQpXFkrKqN3n2rrZW4YQOGAWHWAcuEJdsfdvIdhwL+/jf4HeHL2wzF5ZaxOdNI+RYnCL9
	VU4mRwI8unMPNGQUTeb8xsA==
X-Received: from ejbd8.prod.google.com ([2002:a17:906:3448:b0:c31:9613:6217])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:96a4:b0:c50:8ff9:4f40 with SMTP id a640c23a62f3a-c510e28ff9amr99766b.11.1794937461280;
 Tue, 17 Nov 2026 09:44:21 -0800 (PST)
Date: Tue, 17 Nov 2026 17:43:43 +0000
In-Reply-To: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261117174403.58762-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261117174403.58762-5-vdonnefort@google.com>
Subject: [PATCH v4 04/23] KVM: arm64: Use block-level annotations when setting
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
2.56.1.708.g77570a6a1d-goog

