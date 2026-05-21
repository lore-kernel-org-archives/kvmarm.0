Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08797384CEC
	for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 10:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779358929; cv=none; b=A8HtKXNlu4q7qC8K6yu7tG7g5+z9W6yvSbsNy6/U5nAGs+jNHia1cRc9oT29wMk23LDnGLl9UAoyk3huYgIydhqrHf8/c3SMwS3oFy4hfSl3xNZtk1ULfENkIgvS/ZR/iAwWErj8SqPs9b9F03Y8DwgYy6B7CCQ6q+ledDMXLy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779358929; c=relaxed/simple;
	bh=7SHbyk+8cc77w3P4/19mkuW54Z6G1GrpiZM/Vct40t0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=RpjnmpORRhAad5mKAxTKsTxRpzi3dV/yOn2oCyDy6R7bqndC+1ytObHtiCYgiPy3YFgTRyXgd3H9AX8juO1jkJwNns+XUIKFhZq9P49ntbc99MFyhrz7GQMlWfq6qBsEbtoebLHWubEBrMXoSHbf8aqMCYU29Lh1iaMFZDZ+bHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SGNQEcNa; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--vdonnefort.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SGNQEcNa"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4900f69197fso22422795e9.2
        for <kvmarm@lists.linux.dev>; Thu, 21 May 2026 03:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779358926; x=1779963726; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bAVmqlcZ2Z9Lg1Mm4jdT1/XrqkH6zmj7M8ZuRWP5AwA=;
        b=SGNQEcNaD/keKCksB4KiMFsqEIFB3XGoEPCv2yOYb4z5Vsf3zkiGKta0D5wkj3OFZU
         wf6qPagfbYV2KwgcQtiVXZ6ww7eCludwcyB21egy3vFdw9OdDtQi0l+8dJagaLVOkman
         4DKXPXT3gGaGCJqfA4r6RxOMWG6P0ugPAl5NZO0z5dOaOZS5Q8b0gYvCCzecY/qDnR0L
         NNKOHO/Jw886ccd0kGtt3oN4yZTGoyhMcfg8jzGvB1CoBrFoXJiXkQmH4LWpXl7r1Azc
         rAhsNGCu6PZiTDmLlgp0+mz7hMuOgmr/dR/se5aDNA7In14gSp886BU5Mvqfi/X374WR
         Uo3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779358926; x=1779963726;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bAVmqlcZ2Z9Lg1Mm4jdT1/XrqkH6zmj7M8ZuRWP5AwA=;
        b=j0s5Zc+uC/nrWhKRUcOFerU9nAQGTfATcMWskOPOiL3ioxW7jOWO3DF/dyQlX7UFR8
         vYJ/2uHS/LrmEVOwONJbBLC0iOPXEHB98bAqIkXK4yWnu5bGSgE/t+SX7mahBgq66fJy
         Q1Kyh+a4h3k2k+pSLuwRiiq2h9T85RkXLsEggPuEDVjz4ZtpLOqP+bksBJeR4n4tYyOX
         RRngMnY2j7kJEZsG/1amCXm6142JL+KXEW/O0EnxXmjrKR4DY+oMN3GmH/izJyV9N6xe
         vBd/e+OQ85hq/CWPtRZ17gFfVfuLaFkTSuP4ayMIWYyVNJOLE4L+G+nscvzNOaAhDxJI
         jSlQ==
X-Forwarded-Encrypted: i=1; AFNElJ+jcYTXl08WaS6FMdjsqRrSfVUBGzAGSF++OnmmigNgDBYAgsPpwR7O0WJibSJ8iryMQ75Lbfc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzi0E8Uj3NmpAqBPQwlqh1eLA51pzQnWvn+baV4dYjikLVz0DOB
	w2RWqGJnsJnzZZH3gPBl6e4j8qSE8+Fne/ELCizVfZq644xK+iJx+bHGDCQzix+EaO7/mV2+Xkt
	TZiQFeF6/vg81uKhLcpMqMA==
X-Received: from wmlz4.prod.google.com ([2002:a05:600c:2204:b0:48f:f301:5115])
 (user=vdonnefort job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c105:b0:48e:5990:9698 with SMTP id 5b1f17b1804b1-490360a5f3amr25133725e9.24.1779358926161;
 Thu, 21 May 2026 03:22:06 -0700 (PDT)
Date: Thu, 21 May 2026 11:21:47 +0100
In-Reply-To: <20260521102149.804874-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260521102149.804874-1-vdonnefort@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <20260521102149.804874-2-vdonnefort@google.com>
Subject: [PATCH v2 1/3] KVM: arm64: Reset page order in pKVM hyp_pool_init
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
Note that pages added to the pool outside of the initial pool range
(e.g., via guest_s2_zalloc_page()) must still have their order managed
manually.

While at it, add a WARN_ON() in the hyp_pool attach path to catch
unexpected page orders that exceed the pool's max_order.

Fixes: 256b4668cd89 ("KVM: arm64: Introduce separate hypercalls for pKVM VM reservation and initialization")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Vincent Donnefort <vdonnefort@google.com>

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 25f04629014e..89eb20d4fee4 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -322,7 +322,6 @@ void reclaim_pgtable_pages(struct pkvm_hyp_vm *vm, struct kvm_hyp_memcache *mc)
 	while (addr) {
 		page = hyp_virt_to_page(addr);
 		page->refcount = 0;
-		page->order = 0;
 		push_hyp_memcache(mc, addr, hyp_virt_to_phys);
 		WARN_ON(__pkvm_hyp_donate_host(hyp_virt_to_pfn(addr), 1));
 		addr = hyp_alloc_pages(&vm->pool, 0);
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index a1eb27a1a747..c3b3dc5a8ea7 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -97,6 +97,8 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 	u8 order = p->order;
 	struct hyp_page *buddy;
 
+	WARN_ON(p->order > pool->max_order);
+
 	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
 
 	/* Skip coalescing for 'external' pages being freed into the pool. */
@@ -237,8 +239,10 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 
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

