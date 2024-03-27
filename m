Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A7812D748
	for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 17:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711561001; cv=none; b=F+jqRP64iml5uYTAYdk+jYHpB7QAZcs9QbJfPiq7/9E2/hUtbdN2M7NW/lGJlNKUP3rUPX/edyEa1FPqjYduBdAfUDm5a7asaoMOv7zFzGGjZMJMNXAQPt4rs5yyGS7nJCitGA58UxWSHbay8cknhFtDhxAzgJ4SK8KS79muYSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711561001; c=relaxed/simple;
	bh=eM/y9n6oAhq3GdEWeO5WEdE1IHmMYMGEHly+Oa5YZB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=j9Pip0ShckExfVbpUjqKt8I8BQroic1iawORpRVwSmatICduhvKJOJoxGl+3Bfu54p6I2061Bb/gr8+7UdiAaU03iXlNukkm8dakQsZXkUwlYyC48U2jMHcykxCd8Zq3/A84s5oSdRLO1wk7nSBxKO3KBCsx8lsDNVY+IdAf3Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PkZLbVEJ; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PkZLbVEJ"
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-ddaf2f115f2so36092276.3
        for <kvmarm@lists.linux.dev>; Wed, 27 Mar 2024 10:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711560999; x=1712165799; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qC9nJYgq3KADrJVHmOmGn/dJpO571FX+lr6dw4HsnMs=;
        b=PkZLbVEJHJ1DlzXUsl+dNqfm82rSRqF5P8eEdwrK76yHLYkP6kGu4IP6dnzHl+UEVv
         u/zPCOT21v3svDVK52dATXzTuoiXQswF44KEqM8nfIcWRroT/Gsm6gyBUjjgZRe7WfuT
         LydziMTM0TFPWbC1uZTGXjVvGHhy8TuCDA4GMvJlhjX4v3hh7sWP8sujF/+hDOC9fc+v
         Y9hu39bqSkrC7zx+nZJENj6xukKFMxRrTtTjGzAMStds2nMBC5Kh7vcFxbNwPo5X7nZ8
         I8ID606M2I9oy7R8t5OGyPLkvRKP3C6A5FgGR6bHhNsrmGj+gGAW9A0HEi5JNF/X8xA7
         tJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711560999; x=1712165799;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qC9nJYgq3KADrJVHmOmGn/dJpO571FX+lr6dw4HsnMs=;
        b=Y79R/jh7roezYzstCb+laEyGwtIoqg79bVy7g6umLi3IXEPY6wC9Ouh9mD44p6Fl9m
         9HNrffdD1T91LAuR1ltRnqPr0UExx5gw33XP+/YQM9/o1S4G4VEBGEs1L10JS1kQF5Ba
         RapSiwgLD0suGlEXF2PsSV7miXJUiNffN+jyUe4OVcJS7c190YqZANWmFsIW28CIt5tK
         nKmpygQLP7AxfobPgUmrZlS+xHn6m2XR+bNOHHbeEROLf4BtR1ODrXVYW9zlflqg5CRS
         MtoqqxehqbLx3RgGNNamDBrAYgtLXI1CxeNCA/AtDpzTHsv6VUuoV9tT17psE9rHFj19
         WjdA==
X-Gm-Message-State: AOJu0Ywdo/f1KtOonOx/s+QnRKfBWIBsIg/fbGFUuZxtFDuzQj+VL/Jb
	Cnfpe9GvFgeBndK+YNv21BtOGizFgJ6oG8cqNsQ2MgqFHyKAZiCSVay4xx82ULqBJUPbOdOJtKG
	KQs8BBlrPaB+BOxuvxKQtL7ItptuC5Mb75IixVK+6ZS5DfRl5EHAzZ/ihBvHkHkgHQtuujuK5Jd
	WLbiBJ/xgnQv9K4KtkQBXnwjfmrLI=
X-Google-Smtp-Source: AGHT+IEXWdpsCtaYjLi7tn3rWBuFz72NBm6vuHAp5tTw4sVoNOvnpnu3FuWufcEcihoTAGBvglJ72kW1+A==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:6902:1009:b0:dc6:b768:2994 with SMTP id
 w9-20020a056902100900b00dc6b7682994mr64868ybt.0.1711560998756; Wed, 27 Mar
 2024 10:36:38 -0700 (PDT)
Date: Wed, 27 Mar 2024 17:35:15 +0000
In-Reply-To: <20240327173531.1379685-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com>
X-Mailer: git-send-email 2.44.0.478.gd926399ef9-goog
Message-ID: <20240327173531.1379685-29-tabba@google.com>
Subject: [PATCH v1 28/44] KVM: arm64: Remove locking from EL2 allocation fast-paths
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
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
index 169cdb43b4b8..96b52f545af0 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -155,33 +155,25 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 
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
2.44.0.478.gd926399ef9-goog

