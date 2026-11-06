Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793986082;
	b=JUsEk3xHFiwrIAkhFuDXNAlo+pS9GFEmwW6jeOQkO19kgm7HrtKL+bAlTS23I4D3Ik+h
	 0FGVFSS0ncH0/Wp49DY2asonkfW/RKWQ+5Cwnn3NDi1leRol+klsvt9ZA848wWM7VodOC
	 Gz/oKI2Zf/iTptGVCIU3C13EOGaEZVOtf7/acAaIjT7zrVbxkNU38I57zk74Q38An3YCJ
	 MEkqPT8eZfqcB1lXG9atz2CalgZY2C/QYlpz06hJab2W3zUX2Qt2zuMRZDAC6jrFfAvGN
	 ZdkAYR5N8KwoYxiDQDlhXEOgzqS2j2SvX5EbHE2d/vcMTyfC4d4nKw1pIs2VbaEu0JA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793986082;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=MLkiO5+iQTmH9kwercp9zyxtA2cVUMT1WfXqJlOm5MI=;
	b=c1xAmizZsxKYAzvdgqrD4Nir6LgJReKnWpmQBn4WVZPdewI/o10QdeIp+FWtIssvkyyM
	 cOn0B/k/z3bgb25RHyD24e0FKc+fsSCUhfAkK884QkOUq/xHbxnFzJak1J10Z+wf5K/FE
	 WEgRTZ6/zlIMo2Cvy0yFiWKLaJ6gmdIEdoEsTu81Ura3tJKN1nWw/Q/k5jJRCEZ3jFlFI
	 /CrKYwnCAOluFEo9C1oX9YQgKcI8pIAYuGyAnREoWcpDnXZBbVD+sYYIc/R4JNP7S7lBa
	 UgFUdxu0AeBJ1o5v7xdfQCzhb7y0uzxJhG15A+uJAQcSAX0krHuGIN94VPNttiniK8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b="Rf/0usiv";
	arc=none smtp.remote-ip=209.85.218.70
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3790A606A326
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 17:28:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3790A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Rf/0usiv
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-c3613c35145so112341666b.3
        for <kvmarm@lists.linux.dev>; Fri, 06 Nov 2026 09:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793986080; x=1794590880; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MLkiO5+iQTmH9kwercp9zyxtA2cVUMT1WfXqJlOm5MI=;
        b=Rf/0usivPWSNkjcTIHQN/mK9XAjiBM5MY9EqxYUNtPWbyZf6ah3ukycc0dUrIjnDr3
         p8VMdHQ9Ki39pKr8aFRsn1SQCbVgZUGEZocNFNEwzXmrUsJfokBoX3VVjyvAZRFnTtfB
         a3CVGC0HG4in/TWVojkMwQ1LKgWubGtLxFZzdFUHKhxeZrCuXgnZmuwpZODbfhfWUcPO
         GVU+4UVWuVRO/PYLHrJ7A0wC6N4v1SQ4TuuQ0A7KEJPzvuPpz0FGAjXNWPU38eGQVbs1
         3SzR3n1lWfL0x9wifej/Dq72YuMLdBgh2sSo1V1Cjt+nQxbzFjD0VfLZuI9VHO2WqJpz
         9jOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793986080; x=1794590880;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MLkiO5+iQTmH9kwercp9zyxtA2cVUMT1WfXqJlOm5MI=;
        b=lqOhUCqMhY9orta6ngwPW8rpSx0ROF5PsEO+6gr2P+/o8w+1ftPG6Essx+PAwbEEw6
         /cpvuB6Xh1MM3XiuCwWHAzZH9Ux9yCVdbEd6hL5Peux5TpUDRVS7YHGNsDETBJT3vsF8
         o1e138Ms1BgsqAySymP+n5XQFC10um+TIMneYj+dv6tTm/88cHSr6TRxXUcb09d5aD0Z
         ELINnhPGrIlY3jMfcu0Lo/5V/02NCMNVie4wk3rpaSGElVRs3OjzgoYqgGLpuFG0GyGf
         Ja9JEJ+N44IrXwSg1sHJLMSadcSHpcR0EqKXf72uVpEtF9+Pa1LNB2GOjmjP926WBZ3M
         sxnA==
X-Forwarded-Encrypted: i=1; AL+hErFaS/brIxwHziHHuRbinVsAlJDQc/8NMOI9ANBpIOAlbVPXVwH+QcGkZe06jD/UHhRWkYuGj5Y=@lists.linux.dev
X-Gm-Message-State: APuU4Z8/mi1Zj3skY1VXO46XgalqET3FtzhaQh0HWBpuf4eYlZjr8Gwl
	kC0sUQxlHydhm4UKWEFSlsVAlcTzOOk1kdY9YAjYpNpZ/xUICnCb44LVdhUrZosiZRX4OGdQy6e
	oFqcbhoDiRmMUSg==
X-Received: from edzd18.prod.google.com ([2002:a05:6402:8d2:b0:6b4:6266:6380])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5191:b0:6b4:641:baed with SMTP id 4fb4d7f45d1cf-6b59783b40amr2200349a12.30.1793986080211;
 Fri, 06 Nov 2026 09:28:00 -0800 (PST)
Date: Fri,  6 Nov 2026 17:27:49 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106172750.2678873-1-smostafa@google.com>
Subject: [PATCH v3] KVM: arm64: Use consistent type for pool size
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com, 
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	catalin.marinas@arm.com, will@kernel.org, vdonnefort@google.com, 
	tabba@google.com, xuheng@cs.columbia.edu, Mostafa Saleh <smostafa@google.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>
Content-Type: text/plain; charset="UTF-8"

All the pool sizes in the hypervisor are "unsigned long" but when
they get passed to hyp_early_alloc_contig() or hyp_pool_init() they get
truncated to 32-bits.

That is not a big problem at the moment as to overflow this we need
4G bytes of carveout (2 TB of host or guest system memory).

However when new users are added (as IOMMU) it is hard to reason
about the carveout size anymore.

Fixes: e75960408723 ("KVM: arm64: Introduce an early Hyp page allocator")
Fixes: 8e17c66249e9 ("KVM: arm64: Introduce a Hyp buddy page allocator")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
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
2.56.0.455.g6c5a503b38-goog

