Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A68B3D0908
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 14:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779374005; cv=none; b=kfrKEwCOB9Yza+IP3AZ6GFLvlWpCVqfTdS/idMnykQdAMN/5PKo/cU75rs1TqehOpvjpORP4emdtc5+HvM6UFIa6CbfvyG1tTh/GGGXZq/SfKL12/RqJyZ1TK9KhUh4CKQNHfeIpYsicnezvA6ijCVXUYftkw7TJghuZU5wUK2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779374005; c=relaxed/simple;
	bh=5wgjsO0zLsvlZJNrXi0+JADUQZc5VcQfDtfnXCWFE7o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sYQJRf7tjQtOxoQ4TN0NPSXSVvyBUCqwGFbpwVWuv6x1QVwb5It+cCcYLC3LloO508oGL/XqHbhwCqEejFxcFFUbOIw5nuiDR/JkTgh/5plcb2dG7mZ+V16qy1IeJzd5paaaYO0ak5nhmpXNGOTLs8Ch4uLfifca4SQKia9h1QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ulVM6pHy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ulVM6pHy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fd233d1e2so57129215e9.1
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 07:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779374003; x=1779978803; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ4h4JFPJkjPFghLJ0DWNvcvk9w/PFFhb5TesVJy4fY=;
        b=ulVM6pHy0b6sBlbSM6syg7h3kmtdACL6Gbn4n/LGA+ilqs3SjKzzI9EGcK06gsaeGe
         YNUFBGvFBPYnXEaPS46K1Nx1PgE7Zte/zmx7iocLEzmftz7NPgZVG8e0pQIjVvWbDjXx
         QWWOkMLeJu6unge3+WZKAnGyWSt5pJhZht2558c8Y5U0gzwZ/GN5kQKBveVs0Y/RVV4q
         x88SyoEDY31Bzap9NdxRODPulopGafTSJ5UG8OpEedF2MMbt2l4IOuT5JswBtPpiRO/k
         1V1LeyikrE2OcS6FROJ6kPnAMwXwVh71Ynskg4Jo6QR4ZkuKBP6QKOK8uULj+oQkiKPV
         zfig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779374003; x=1779978803;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HZ4h4JFPJkjPFghLJ0DWNvcvk9w/PFFhb5TesVJy4fY=;
        b=Nw9NzxY9pgzTgGFnV5aS7C+nNHnVbjfdTkRT82AfPYKS2qk/tfOAkYSlCsMAm6SDMT
         I4IaqiMjnNwKbngiFIqcLNNhm/lB8jVbv0QUBVmMviDlk6cABq3dLZM/7eEKjgHR9hTa
         w/CX58iNAT5gUzeN3pq8lA/Cthi0aUIgaYuMVG4N6W5UrjijrJVjIHWi2Vjm04qWBbmI
         gX4stRshKWZn+vbeUPODOZrh6Vmk9NhcngEO195YAewRVEsuDbkcV0CnqdApMcvm3UoP
         CTnn/wJH9evZfJBmAaIMr/51Sb1kepsjMj+wGTAVGGoL1Aq7gUrjpgzGLGxKOz8kcrRC
         SbRQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Zz0Yihe1JIJfCeENyyQGgxvhqj5vqR+A4J6EAONGezIQ3UEZA75gc4r5c0zrmhA4nh7lQlTY=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYRZRIVuftR4mK1R3BDsA381uE3xNwBqJWV5ufaI4m7AoYxzyb
	0eE4M+xhjuWoHuecBZZQkLJOZRyYrp49XOCpg7MJbRquQQdChwwhVI3XcT8CQxRKjHGvx7RQUXL
	NA9qlhRo2SF65Qq+B0qDpnw==
X-Received: from wmlz4.prod.google.com ([2002:a05:600c:2204:b0:48f:f301:5115])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a04:b0:48a:97b6:7420 with SMTP id 5b1f17b1804b1-490360e46d3mr43743355e9.24.1779374002345;
 Thu, 21 May 2026 07:33:22 -0700 (PDT)
Date: Thu, 21 May 2026 15:33:16 +0100
In-Reply-To: <20260521143318.1002172-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521143318.1002172-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521143318.1002172-2-vdonnefort@google.com>
Subject: [PATCH v3 1/3] KVM: arm64: Reset page order in pKVM hyp_pool
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

