Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777C626658A
	for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 08:53:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747731187; cv=none; b=lvSMajCy16lczNj21W7wvJRV03jsMLrpmQ9CmvscvaM3tXrHJ5Phy/36Iv164u5LC3XHGq9d0cDhOvv5i+aaxRiKqGxGJaHGAr7q2hVvD2wUxE1fiCd+U/v37VG1N9LfMEOSq/NQiduuFia82j+FktlC7y2sr1QyoO9FrU3vj8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747731187; c=relaxed/simple;
	bh=O5K7ItQfEvdR6AyA+LX5hbN194oMzarUGnY1zvOk3ZA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Gfaivi6IwMcRzdk5blOvQcc5DJbZp+5UEfn+w68H81D9Y70s1ZG4ZB81jjs3Gonu3ogweoZmuGvvXuXwOV1d/kw/vsYyL99/iILL2abyWn9uF7SdghpoKEoz0uezFNmtTa+l/skT422FnbTcQIC2txq0ZWTzQyFepIt/x+SG690=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p1GvNoLA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p1GvNoLA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-43e9a3d2977so39959395e9.1
        for <kvmarm@lists.linux.dev>; Tue, 20 May 2025 01:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747731184; x=1748335984; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=a+P4jqcPY/5X/H7GHLC9QBb5JYHi83egH9jTzrY/YYI=;
        b=p1GvNoLAmDnUpLCtuZKi5+bNjo3/xsQS7LeO8lHDubgpxIUWulnJ0Wpclp/vEaLyIJ
         a/twEfCWnEhNS3wnmmPxpLHlOXyC0+qQno7baqpN2xKOv0Xggc8BqokWGnlG3ukjfhmP
         LeDsKIDyLN8x+vXaWvdv0GSOnY18I9ecUHIsNiMnjA6WPLu0VLnK/3qGXUjKsPEuyHjA
         IAvR2jm4CCU+wUgd+J8kr9t1QKrb7whO7RGXUmM4XwRPMmN6m5wHq0VaERloAdkg6bih
         nKwGyUOkCQIjxTcEsh5omjs6nC2/Q/0ES7W8K5/uB2vgZF1L1n0ynQK8cT1yOzFr4MaW
         UUbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747731184; x=1748335984;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a+P4jqcPY/5X/H7GHLC9QBb5JYHi83egH9jTzrY/YYI=;
        b=l5tRM8iaoX5WvbrZI7KS9CK7JQiUrYW55QUOzsMtUddJ7z/eRdpPQz8Yl6uJXRcnoN
         unV5IW2+4lYVjNAauCnWEeIFfZ8qiO93s/c6NJF9D6o/bKIWHv681WzcnfvFTodx2s27
         J058VYTj1aa7MjWP31CVML9G6Pg06gTNv8v4kDhQCwbj1qac1yk5sHen+89zcG9zQU7/
         nu9uTkrgl6adAiavKcNoU5Z/Jgb8dpkNs0oe5IdCt8P2sshptgwiopZjRh4GdJQNkvat
         beNI6pW+gHLdgph2UMRZPI3pNSQ7uWGKXFX/ueYU82R7QZU1rpgqQhQfb0Q3HKHnGQZX
         nULg==
X-Forwarded-Encrypted: i=1; AJvYcCW6NnoomvhBUnBkGPBz6oGemVEkb23P1T5os532moQBcSip6M/byjA1bHeePl2CtGqeU+294J8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOii9zJ+2ZVFxC0mEcvx1GRNehYNklayBuVC9aQKi7cqwQzIc2
	okUW5mycQodhZCUkkgJVb16LrLXgYbDdtBx1sp3pq2Ve9qvPXeXIMUr5eEk714cjVsgCH3AZktZ
	zU+Kb3zNMnc1nOryr+NoYvQ==
X-Google-Smtp-Source: AGHT+IGLoj+sVRo93xr3VaTiuIGmKV090qzpfNpi8aOUsOQ8a3/MaEFrOpiu7dpS+CVE/xIW+C0ev0Qm8AecEqxT
X-Received: from wmbec10.prod.google.com ([2002:a05:600c:610a:b0:440:595d:fba9])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5305:b0:441:b19c:96fe with SMTP id 5b1f17b1804b1-442fd622eb4mr188234885e9.10.1747731183859;
 Tue, 20 May 2025 01:53:03 -0700 (PDT)
Date: Tue, 20 May 2025 09:51:53 +0100
In-Reply-To: <20250520085201.3059786-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250520085201.3059786-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.49.0.1143.g0be31eac6b-goog
Message-ID: <20250520085201.3059786-3-vdonnefort@google.com>
Subject: [PATCH v5 02/10] KVM: arm64: Introduce for_each_hyp_page
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: qperret@google.com, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org, kernel-team@android.com, 
	Vincent Donnefort <vdonnefort@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a helper to iterate over the hypervisor vmemmap. This will be
particularly handy with the introduction of huge mapping support
for the np-guest stage-2.

Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index eb0c2ebd1743..dee1a406b0c2 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -96,24 +96,24 @@ static inline struct hyp_page *hyp_phys_to_page(phys_addr_t phys)
 #define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
 #define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
 
-static inline enum pkvm_page_state get_host_state(phys_addr_t phys)
+static inline enum pkvm_page_state get_host_state(struct hyp_page *p)
 {
-	return (enum pkvm_page_state)hyp_phys_to_page(phys)->__host_state;
+	return p->__host_state;
 }
 
-static inline void set_host_state(phys_addr_t phys, enum pkvm_page_state state)
+static inline void set_host_state(struct hyp_page *p, enum pkvm_page_state state)
 {
-	hyp_phys_to_page(phys)->__host_state = state;
+	p->__host_state = state;
 }
 
-static inline enum pkvm_page_state get_hyp_state(phys_addr_t phys)
+static inline enum pkvm_page_state get_hyp_state(struct hyp_page *p)
 {
-	return hyp_phys_to_page(phys)->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
+	return p->__hyp_state_comp ^ PKVM_PAGE_STATE_MASK;
 }
 
-static inline void set_hyp_state(phys_addr_t phys, enum pkvm_page_state state)
+static inline void set_hyp_state(struct hyp_page *p, enum pkvm_page_state state)
 {
-	hyp_phys_to_page(phys)->__hyp_state_comp = state ^ PKVM_PAGE_STATE_MASK;
+	p->__hyp_state_comp = state ^ PKVM_PAGE_STATE_MASK;
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index be4f7c5612f8..1018a6f66359 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -60,6 +60,11 @@ static void hyp_unlock_component(void)
 	hyp_spin_unlock(&pkvm_pgd_lock);
 }
 
+#define for_each_hyp_page(__p, __st, __sz)				\
+	for (struct hyp_page *__p = hyp_phys_to_page(__st),		\
+			     *__e = __p + ((__sz) >> PAGE_SHIFT);	\
+	     __p < __e; __p++)
+
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
 	void *addr = hyp_alloc_pages(&host_s2_pool, get_order(size));
@@ -485,7 +490,8 @@ static int host_stage2_adjust_range(u64 addr, struct kvm_mem_range *range)
 		return -EAGAIN;
 
 	if (pte) {
-		WARN_ON(addr_is_memory(addr) && get_host_state(addr) != PKVM_NOPAGE);
+		WARN_ON(addr_is_memory(addr) &&
+			get_host_state(hyp_phys_to_page(addr)) != PKVM_NOPAGE);
 		return -EPERM;
 	}
 
@@ -511,10 +517,8 @@ int host_stage2_idmap_locked(phys_addr_t addr, u64 size,
 
 static void __host_update_page_state(phys_addr_t addr, u64 size, enum pkvm_page_state state)
 {
-	phys_addr_t end = addr + size;
-
-	for (; addr < end; addr += PAGE_SIZE)
-		set_host_state(addr, state);
+	for_each_hyp_page(page, addr, size)
+		set_host_state(page, state);
 }
 
 int host_stage2_set_owner_locked(phys_addr_t addr, u64 size, u8 owner_id)
@@ -636,16 +640,16 @@ static int check_page_state_range(struct kvm_pgtable *pgt, u64 addr, u64 size,
 static int __host_check_page_state_range(u64 addr, u64 size,
 					 enum pkvm_page_state state)
 {
-	u64 end = addr + size;
 	int ret;
 
-	ret = check_range_allowed_memory(addr, end);
+	ret = check_range_allowed_memory(addr, addr + size);
 	if (ret)
 		return ret;
 
 	hyp_assert_lock_held(&host_mmu.lock);
-	for (; addr < end; addr += PAGE_SIZE) {
-		if (get_host_state(addr) != state)
+
+	for_each_hyp_page(page, addr, size) {
+		if (get_host_state(page) != state)
 			return -EPERM;
 	}
 
@@ -655,7 +659,7 @@ static int __host_check_page_state_range(u64 addr, u64 size,
 static int __host_set_page_state_range(u64 addr, u64 size,
 				       enum pkvm_page_state state)
 {
-	if (get_host_state(addr) == PKVM_NOPAGE) {
+	if (get_host_state(hyp_phys_to_page(addr)) == PKVM_NOPAGE) {
 		int ret = host_stage2_idmap_locked(addr, size, PKVM_HOST_MEM_PROT);
 
 		if (ret)
@@ -669,18 +673,14 @@ static int __host_set_page_state_range(u64 addr, u64 size,
 
 static void __hyp_set_page_state_range(phys_addr_t phys, u64 size, enum pkvm_page_state state)
 {
-	phys_addr_t end = phys + size;
-
-	for (; phys < end; phys += PAGE_SIZE)
-		set_hyp_state(phys, state);
+	for_each_hyp_page(page, phys, size)
+		set_hyp_state(page, state);
 }
 
 static int __hyp_check_page_state_range(phys_addr_t phys, u64 size, enum pkvm_page_state state)
 {
-	phys_addr_t end = phys + size;
-
-	for (; phys < end; phys += PAGE_SIZE) {
-		if (get_hyp_state(phys) != state)
+	for_each_hyp_page(page, phys, size) {
+		if (get_hyp_state(page) != state)
 			return -EPERM;
 	}
 
@@ -931,7 +931,7 @@ int __pkvm_host_share_guest(u64 pfn, u64 gfn, struct pkvm_hyp_vcpu *vcpu,
 		goto unlock;
 
 	page = hyp_phys_to_page(phys);
-	switch (get_host_state(phys)) {
+	switch (get_host_state(page)) {
 	case PKVM_PAGE_OWNED:
 		WARN_ON(__host_set_page_state_range(phys, PAGE_SIZE, PKVM_PAGE_SHARED_OWNED));
 		break;
@@ -983,9 +983,9 @@ static int __check_host_shared_guest(struct pkvm_hyp_vm *vm, u64 *__phys, u64 ip
 	if (WARN_ON(ret))
 		return ret;
 
-	if (get_host_state(phys) != PKVM_PAGE_SHARED_OWNED)
-		return -EPERM;
 	page = hyp_phys_to_page(phys);
+	if (get_host_state(page) != PKVM_PAGE_SHARED_OWNED)
+		return -EPERM;
 	if (WARN_ON(!page->host_share_guest_count))
 		return -EINVAL;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 6d513a4b3763..c19860fc8183 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -190,6 +190,7 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 				     enum kvm_pgtable_walk_flags visit)
 {
 	enum pkvm_page_state state;
+	struct hyp_page *page;
 	phys_addr_t phys;
 
 	if (!kvm_pte_valid(ctx->old))
@@ -202,6 +203,8 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	if (!addr_is_memory(phys))
 		return -EINVAL;
 
+	page = hyp_phys_to_page(phys);
+
 	/*
 	 * Adjust the host stage-2 mappings to match the ownership attributes
 	 * configured in the hypervisor stage-1, and make sure to propagate them
@@ -210,15 +213,15 @@ static int fix_host_ownership_walker(const struct kvm_pgtable_visit_ctx *ctx,
 	state = pkvm_getstate(kvm_pgtable_hyp_pte_prot(ctx->old));
 	switch (state) {
 	case PKVM_PAGE_OWNED:
-		set_hyp_state(phys, PKVM_PAGE_OWNED);
+		set_hyp_state(page, PKVM_PAGE_OWNED);
 		return host_stage2_set_owner_locked(phys, PAGE_SIZE, PKVM_ID_HYP);
 	case PKVM_PAGE_SHARED_OWNED:
-		set_hyp_state(phys, PKVM_PAGE_SHARED_OWNED);
-		set_host_state(phys, PKVM_PAGE_SHARED_BORROWED);
+		set_hyp_state(page, PKVM_PAGE_SHARED_OWNED);
+		set_host_state(page, PKVM_PAGE_SHARED_BORROWED);
 		break;
 	case PKVM_PAGE_SHARED_BORROWED:
-		set_hyp_state(phys, PKVM_PAGE_SHARED_BORROWED);
-		set_host_state(phys, PKVM_PAGE_SHARED_OWNED);
+		set_hyp_state(page, PKVM_PAGE_SHARED_BORROWED);
+		set_host_state(page, PKVM_PAGE_SHARED_OWNED);
 		break;
 	default:
 		return -EINVAL;
-- 
2.49.0.1143.g0be31eac6b-goog

