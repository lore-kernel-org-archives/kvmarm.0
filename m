Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B124779B3
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 15:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784127693; cv=none; b=PFBTv0vokTEYpt+Skpuy8noVmKat4VZj3TIvHS4RB+2U+sL2QrJy0Vil1rGIpVg7eAV0l3eysatRacu4uoC1dKY6vGekomyhPAQkH17qLGpdAo5c1wdz4awHZPqwcaKAXY7fwxfsnVLelcw9ljXmUcWr6OWP00QRdfDQ2YTdU4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784127693; c=relaxed/simple;
	bh=8+jGNB5irA8u1mmyluWOv/fGSc4MZVL9ROhTZSbY5us=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=FFXLxCiTWxKeFF+t+fWh1VcIDem2oRxqcZ1krb9v+YOLrd+2DUcZbAk+AQ2YiG+B3eAjcw0zBekjwtJ5pv5bq9V/kZcgnMG+vKAHp6muGn2BvDdixHRA212CYTk83yQiVC4FxGTJsSsGxtkpnAqIJPKhdpkDegcW0FgGJqUUHfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EJPOBv2w; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EJPOBv2w"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-4629f312a67so4640219f8f.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784127690; x=1784732490; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j8UdcPrCWpOwvzYn0GBOE+Kb77J6h4WrSrgHpYB821s=;
        b=EJPOBv2wM7kjASweoINaWM8mo4HXqeSr2XgzoexQlbL8xNThjMBWBFBLb9BH/GEsa5
         /iu74/UqAC172zd991wzO/UJprACKxHu+uyYyd+y9UCdz5wNK4thOi5CHyNaZXtbGkqf
         YkNOhY735wUkMK/6yOXEwLu/cl/SdyUhAAc7bsL3pfl7rd93xHY2wizIfBb0B2HdBZzM
         4F28hcwf4b4yW7I5NKb+3v3UaST13NUI10GT700TcwhfytiiXqLFYLdvkpXYUTajTvuE
         vXqNaxQ7fDE9FqsQWxdJJLpmJttKXpudUqlvDd0nWfCsvOdlRfPaJ4QA19eb4xQwIThF
         befQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784127690; x=1784732490;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j8UdcPrCWpOwvzYn0GBOE+Kb77J6h4WrSrgHpYB821s=;
        b=aGi3ttW2GuT9qRG7Vx2/xafeHrpiv+d5ut9fjuz4mAB3UnEJ8OW7/n7TW9PW+tUVm8
         oPsy9LSaJKSGmXKfiXBYINowXjpScr4mnxbDfgZPa7ARsYw3M6pG4AL0dnALsfKWNPs9
         kvtEUugle9Ef0PaUXGJFUck44e282cRj+i4tM6gwQoWQL2bOWFIRPRocxXYu3+bX/5yk
         WOOT8gIILx/rLX58ryhIIGWMs8lshW6e5D8aqCV7CYnPqJn/0xRdlb89FwR15jRq68qD
         uXAo9L9GnywhVeEWGqj+6mi279x5BhO23JN88SpFAPIUBmUvpRwlkZa3Ed8HmNwTgNm/
         Oj4Q==
X-Forwarded-Encrypted: i=1; AHgh+RpTuaxyS+wdtJGmgGr8q9eV3Q1asglusVo4JUb8bxS/jGO3qz+wXq+3AscQeLKfNkZAezjfmsw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE5CJ3u24gfqs+7rHX+Qr0Sm6OuMw8rHQ7FJbTYzpENW8+2DT5
	LMr1kyo5S4iF6iS1X2uv/UWL7TRe5aRrTpZ1NvHGeXItOSzHs7AA65DeNC64/S4KDtLsGqXUHuk
	T1p3ksuTa8PlRcQ==
X-Received: from wrwq6.prod.google.com ([2002:a5d:5746:0:b0:47a:6462:7fbe])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2c0a:b0:474:4525:eb55 with SMTP id ffacd0b85a97d-47f4fd1fc60mr3529438f8f.47.1784127689429;
 Wed, 15 Jul 2026 08:01:29 -0700 (PDT)
Date: Wed, 15 Jul 2026 15:01:25 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715150125.2798116-1-smostafa@google.com>
Subject: [PATCH] KVM: arm64: Use consistent type for pool size
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

All the pool sizes in the hypervisor are "unsigned long" but when
they get passed to hyp_early_alloc_contig() or hyp_pool_init() they get
truncated to 32-bits.

That is not a big problem at the moment as to overflow this we need
4G bytes of carveout (2 TB of host or guest system memory).

However when new users are added (as IOMMU) it is hard to reason
about the carveout size anymore.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
For example in the SMMUv3 to avoid this overflow, I add a cap
for the pools size to UINT_MAX to work around this:
https://lore.kernel.org/linux-iommu/20260715115906.2664882-9-smostafa@google.com/
---
 arch/arm64/kvm/hyp/include/nvhe/early_alloc.h | 2 +-
 arch/arm64/kvm/hyp/include/nvhe/gfp.h         | 4 ++--
 arch/arm64/kvm/hyp/nvhe/early_alloc.c         | 2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 6 +++---
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
index dc61aaa56f31..462883c4e325 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/early_alloc.h
@@ -7,7 +7,7 @@
 void hyp_early_alloc_init(void *virt, unsigned long size);
 unsigned long hyp_early_alloc_nr_used_pages(void);
 void *hyp_early_alloc_page(void *arg);
-void *hyp_early_alloc_contig(unsigned int nr_pages);
+void *hyp_early_alloc_contig(unsigned long nr_pages);
 
 extern struct kvm_pgtable_mm_ops hyp_early_alloc_mm_ops;
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 3766333bace9..3a428dc40b14 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -29,6 +29,6 @@ void hyp_get_page(struct hyp_pool *pool, void *addr);
 void hyp_put_page(struct hyp_pool *pool, void *addr);
 
 /* Used pages cannot be freed */
-int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
-		  unsigned int reserved_pages);
+int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
+		  unsigned long reserved_pages);
 #endif /* __KVM_HYP_GFP_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/early_alloc.c b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
index 00de04153cc6..9fef0c7d2185 100644
--- a/arch/arm64/kvm/hyp/nvhe/early_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/early_alloc.c
@@ -21,7 +21,7 @@ unsigned long hyp_early_alloc_nr_used_pages(void)
 	return (cur - base) >> PAGE_SHIFT;
 }
 
-void *hyp_early_alloc_contig(unsigned int nr_pages)
+void *hyp_early_alloc_contig(unsigned long nr_pages)
 {
 	unsigned long size = (nr_pages << PAGE_SHIFT);
 	void *ret = (void *)cur;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 57f86aa0f82f..51460d420c94 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -229,12 +229,12 @@ void *hyp_alloc_pages(struct hyp_pool *pool, u8 order)
 	return hyp_page_to_virt(p);
 }
 
-int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
-		  unsigned int reserved_pages)
+int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned long nr_pages,
+		  unsigned long reserved_pages)
 {
 	phys_addr_t phys = hyp_pfn_to_phys(pfn);
 	struct hyp_page *p;
-	int i;
+	unsigned long i;
 
 	hyp_spin_lock_init(&pool->lock);
 	pool->max_order = min(MAX_PAGE_ORDER,
-- 
2.55.0.141.g00534a21ce-goog

