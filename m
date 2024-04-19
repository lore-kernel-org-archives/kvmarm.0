Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFFB46453
	for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 08:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713513611; cv=none; b=XLc1aYAdHIafqcgcuEnWI63gHtbDKQ2uxQww1ZrjQCtkOsUOlJYa9Yc8qB6M0vE+ue5QpyPQQLbZXSiEpAKrx/BasIxgnrIpszfnAnr54S2lNUTpYyUpgigmiHLUFbr5dRwSGk8Ja9+bx8T5mu2tgS8obiC9P3sVryLEexjXk8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713513611; c=relaxed/simple;
	bh=GEUxzSjoP/xlIbh4FdIQ272Q5TDX9imUlO2Sg4ZnCVM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dS5D7fz5toFNUnwW76l+2cT4ax3E2wqhKuiQphOO+BTWg7gtT6pWYLRirijPMHkGOh/6XWu8htsKvAcYNoo37gDPKVXwvkWooyxfZoCZw9Qy6TYTNFbv7kZdp9aqEz98ZPF3yGCMLhxC8ymHNeqYLqQDQhGyZrbIWCk2eivalpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oddpIrTm; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oddpIrTm"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4167351545cso14509075e9.1
        for <kvmarm@lists.linux.dev>; Fri, 19 Apr 2024 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1713513608; x=1714118408; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oUQonW7gTVwiW5yFC0rU95BievWF+mYOaDpakKa/Sj0=;
        b=oddpIrTmfpH2/1EnuHvXa0BYZ5s5CkrfGbxFMApCn+HRsW16L0duTyT50Q9BwOb3Ll
         Cuni7P+h6mt3i7vHbd2481QdudCcfM4Y0rHro2zkA9/cuogAPwN+wiRnhNJ+T8ANKh2r
         KMqr9NY+yoaN5g7tD1wB12V5pa/0Xqp8CsFaLZLBQq4j1hBz04/BS04c3KfRrIMZqDtY
         UoKvF+provh0v5K0ycPyixsShBRryp4yxd9pE6Q++5a/fqsopqB84G7JKrUbBHEj0Qim
         w1KnNXaz4tkFO76IeE2mOD5Ot3/CSDfK+RjA8FVoh41w3GKfzsP/A1Kj4jO7ZL+cCGTG
         7txA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713513608; x=1714118408;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oUQonW7gTVwiW5yFC0rU95BievWF+mYOaDpakKa/Sj0=;
        b=Lk/7/9bgtGRHkt9Mpw4e+YgnDrrrdI+quUf2Tslr8MSBIUm2zJkPwu5Tdus36HyW2i
         sTPdSW8fKLKekPn1yLm+Bih8S/wXTPS5cOVIlGEk87HkZEi1j9JZ68JsmmF2yqelj55J
         uUgvMfCCfhYki96JlfJ7nibpl5ro0PfSozABUf4bWm6W7iBfQT5SW0HTt6My+JJipuPE
         mXg32F7Sv8kT/RaFjP3SWFaN6z3BFto+aFbRwlZSxrHaTMC4hjs/9cLgy7oExmgEM5Hs
         4sEDLCBYLpqoRxl53PIYUTAlVzOSpvMnAJGhpavYT9uvU32vr7PUXQ+Y8IqgfHp8efht
         JvXQ==
X-Gm-Message-State: AOJu0Yy3/8BIl7QEZVYxOpZSyPkyDgG2cGwFFBNY9faYSHe9bfi+cotk
	HNpVb82gzlZmlq3mgCyhiLekEMEIUXTfT3tA0Sc1VuwJCnz6H3ceB1sTvbBeLxmplIpIsaXB2/d
	N1Be1s3ArorEH5QYWUySnYKot/hkq18hkZC44P1ztGHdEELNsfGPCq7OkczJLGsGahY+yMCnrxi
	9RTtbH5AcONBksDaHyw8DjNp9MSNM=
X-Google-Smtp-Source: AGHT+IE4jHLdzmJljhh8ZxvD0DrGi6kU8qNlB48d97UyZ5ub0ZXZJHQR16ekM5F0KG+HQW/HjDnmN4xtUA==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:4f85:b0:418:f466:2616 with SMTP id
 n5-20020a05600c4f8500b00418f4662616mr8767wmq.1.1713513608279; Fri, 19 Apr
 2024 01:00:08 -0700 (PDT)
Date: Fri, 19 Apr 2024 08:59:21 +0100
In-Reply-To: <20240419075941.4085061-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240419075941.4085061-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.769.g3c40516874-goog
Message-ID: <20240419075941.4085061-12-tabba@google.com>
Subject: [PATCH v3 11/31] KVM: arm64: Remove locking from EL2 allocation fast-paths
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, smostafa@google.com
Content-Type: text/plain; charset="UTF-8"

From: Will Deacon <will@kernel.org>

hyp_{get,put}_page() are called extensively from the page-table code
to adjust reference counts on page-table pages. As a small step towards
removing reader serialisation on these paths, drop the 'hyp_pool' lock
in the case where the refcount remains positive, only taking the lock
if the page is to be freed back to the allocator.

Remove a misleading comment at the same time, which implies that a page
with a refcount of zero and which is not attached to a freelist is
unsafe whereas in practice it's the other way around which can lead to
problems.

Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h |  6 +-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 16 ++++------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 97c527ef53c2..24eb7840d98e 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -10,11 +10,7 @@
 #define HYP_NO_ORDER	USHRT_MAX
 
 struct hyp_pool {
-	/*
-	 * Spinlock protecting concurrent changes to the memory pool as well as
-	 * the struct hyp_page of the pool's pages until we have a proper atomic
-	 * API at EL2.
-	 */
+	/* lock protecting concurrent changes to the memory pool. */
 	hyp_spinlock_t lock;
 	struct list_head free_area[NR_PAGE_ORDERS];
 	phys_addr_t range_start;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index e691290d3765..73437f5c2616 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -152,33 +152,25 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 
 static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 {
-	if (hyp_page_ref_dec_and_test(p))
+	if (hyp_page_ref_dec_and_test(p)) {
+		hyp_spin_lock(&pool->lock);
 		__hyp_attach_page(pool, p);
+		hyp_spin_unlock(&pool->lock);
+	}
 }
 
-/*
- * Changes to the buddy tree and page refcounts must be done with the hyp_pool
- * lock held. If a refcount change requires an update to the buddy tree (e.g.
- * hyp_put_page()), both operations must be done within the same critical
- * section to guarantee transient states (e.g. a page with null refcount but
- * not yet attached to a free list) can't be observed by well-behaved readers.
- */
 void hyp_put_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
 	__hyp_put_page(pool, p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_get_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
 
-	hyp_spin_lock(&pool->lock);
 	hyp_page_ref_inc(p);
-	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_split_page(struct hyp_page *p)
-- 
2.44.0.769.g3c40516874-goog

