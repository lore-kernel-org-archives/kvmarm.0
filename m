Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441F31283E
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374193; cv=none; b=DiOm6j6sfuWu2u829jD3w5VuOIC0y/fsV47RaSdKlfkIUU/czEA3UeD2Jx4fOjvFoMp9vqgx1eF/10cHGg2LJMun5yOr1h16+UijpKrP7MGkATv3VFLd4ONKTMhw2prtA/XRenog2yBmoZHzmHOQALeNVVhu7nZamkcjgg5BVTs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374193; c=relaxed/simple;
	bh=5wgjsO0zLsvlZJNrXi0+JADUQZc5VcQfDtfnXCWFE7o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=U5d5Z08KSKodWbTeIwzzXuE4dkRAXPVKCW7m8gZSkkxoDareO3lyK1r3eL07w/wh9kYSjtEZUkgOyEygsFFJR2PBR+2P6xq/cC27JkvVmdiz+pATR9fGYCKpAXACi2oK6nzBYN+qXtRrY3+1MPdxAN8hKAZitRemoEhK+NfhmEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JidyBrZV; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JidyBrZV"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-680ff5fbf99so6945105a12.0
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374190; x=1779978990; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ4h4JFPJkjPFghLJ0DWNvcvk9w/PFFhb5TesVJy4fY=;
        b=JidyBrZVx9fYYWpwWnKny90hEd4GkZVZZBso9rQQzDF6uw/2WBjkWls3w8R5oNGn8U
         reR0yfeO1HMaeMcJPmI5hiniosiQQEXrMLB1CGRWD3CXr6Ml+beFSRfco0IpGYMgN28f
         DOcKHM2t0k/DbX4it0yHd71pHSnk7G8sFnX+l0NAuIBfx5fuZtRNiRJzppZJORVFyCSv
         cbXk1SsF5tIByrqsZ0h9j92LWHMPv1DXkqmcW1SiILOdtTQA01rsYsk5o/Mq2yyPUrcs
         9EHx5cuHS9u4T8DwT/AkgfImSQKmg1h36U152enEYjsFsEb6Acg0/Nc9IiSu3CspG1d9
         u32w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374190; x=1779978990;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ4h4JFPJkjPFghLJ0DWNvcvk9w/PFFhb5TesVJy4fY=;
        b=E1UcUhbJYX/TMvTPjHPGjTUTku9tNi6s7l/rFW9lisTRedSOfdk5oTpeDwj2ulPYD2
         njaFTtbnBwoQZoNY4Z7eHKwFCfkiSlspQw4sGKiE7OJUkLhJj43i85DAQ54AJ8aNV3vw
         unnBblxVWBlek+OiCMLWW9Z714JivwZty6r8FSOdQSGCrQRdqum3ir7uMS+IsfFkGyao
         TAec/VhadBJzmHlebo2uq3YLTKrFkxZHLKcWUzFUie6HSidb/r2g1fPQ2QQE+0WEY3Vq
         hdJmivNneUI4rkAS6x238bcmb05YxwLFuAJnJtfAzJN/oSfB5WLqAU13dUKgE/nCmrPm
         hjxQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VmssIC8LtF/allCgVZ6+3yN2P9OLMj3qaCiYbtkh/bbFy/5o+cqL2AGkfx53YcALqwAd3IEI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxeBIkTbdcwaFihLmqUiPylpPojxzOWAcI6ywmU8qnyfK20VWCG
	ulLKKT0vYGFJSc1ItQsXTtRLbU9PPDJjF733NejjJY9MLuI00p4QdZ1xo8b2Za5KFwtGmd4ClA/
	6w3l0o8C7MWP8w8+AhEIQug==
X-Received: from edbdz17.prod.google.com ([2002:a05:6402:1d51:b0:67b:ef53:f70b])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:43cf:b0:67b:cd1f:9cc1 with SMTP id 4fb4d7f45d1cf-68835ef63f6mr1723450a12.6.1779374190011;
 Thu, 21 May 2026 07:36:30 -0700 (PDT)
Date: Thu, 21 May 2026 15:36:24 +0100
In-Reply-To: <20260521143626.1005660-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521143626.1005660-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143626.1005660-2-vdonnefort@google.com>
Subject: [RESEND v3 1/3] KVM: arm64: Reset page order in pKVM hyp_pool
From: Vincent Donnefort <vdonnefort@google.com>
To: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	kernel-team@android.com, qperret@google.com, tabba@google.com, 
	Vincent Donnefort <vdonnefort@google.com>, Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"

When a VM fails to initialise after its stage-2 hyp_pool has been
initialised, that stage-2 must be torn down entirely. This requires
resetting both the refcount and the order of its pages back to 0.

Currently, reclaim_pgtable_pages() implicitly resets the page order by
allocating the entire pool with order-0 granularity. However, in the VM
initialisation error path, the addresses of the donated memory (the PGD)
are already known, making it unnecessary to iterate over all pages in
the pool.

Since the vmemmap page order is a hyp_pool-specific field, leaving a
non-zero order on hyp_pool destruction is harmless until another pool
attempts to admit the page. Instead of resetting this field during
destruction, reset it during pool initialization in hyp_pool_init().

For 'external' pages, we can't trust the order either as they bypass
hyp_pool_init(). Since we never coalesce them, enforce order-0 to ensure
safe insertion into the pool.

This leaves no vmemmap order users outside of hyp_pool.

Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 25f04629014e..fa447d400b71 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -217,7 +217,6 @@ static void *guest_s2_zalloc_page(void *mc)
 	memset(addr, 0, PAGE_SIZE);
 	p = hyp_virt_to_page(addr);
 	p->refcount = 1;
-	p->order = 0;
 
 	return addr;
 }
@@ -322,7 +321,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	while (addr) {
 		page = hyp_virt_to_page(addr);
 		page->refcount = 0;
-		page->order = 0;
 		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
 		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
 		addr = hyp_alloc_pages(&vm->pool, 0);
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a1eb27a1a747..57f86aa0f82f 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -94,13 +94,22 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 			      struct hyp_page *p)
 {
 	phys_addr_t phys = hyp_page_to_phys(p);
-	u8 order = p->order;
 	struct hyp_page *buddy;
+	bool coalesce = true;
+	u8 order = p->order;
 
-	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
+	/*
+	 * 'external' pages are never coalesced and their ->order field
+	 * untrusted as they bypass hyp_pool_init(). Enforce order-0.
+	 */
+	if (phys < pool->range_start || phys >= pool->range_end) {
+		order = 0;
+		coalesce = false;
+	}
+
+	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << order);
 
-	/* Skip coalescing for 'external' pages being freed into the pool. */
-	if (phys < pool->range_start || phys >= pool->range_end)
+	if (!coalesce)
 		goto insert;
 
 	/*
@@ -237,8 +246,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
-	for (i = 0; i < nr_pages; i++)
+	for (i = 0; i < nr_pages; i++) {
 		hyp_set_page_refcounted(&p[i]);
+		p[i].order = 0;
+	}
 
 	/* Attach the unused pages to the buddy tree */
 	for (i = reserved_pages; i < nr_pages; i++)
-- 
2.54.0.746.g67dd491aae-goog

