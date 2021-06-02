Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C10A4C4708F
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A464613E4
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5A464613E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 030FA4A195;
	Wed,  2 Jun 2021 05:44:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LemlK+HyjH3o; Wed,  2 Jun 2021 05:44:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 179094A3A5;
	Wed,  2 Jun 2021 05:43:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 65CC1406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Y52+b0Tgj+ti for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 05:43:55 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B0B040856
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:55 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 j6-20020a05600c1906b029019e9c982271so1892342wmq.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 02:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=c9G26svnUWbmDEss+L1TLE5EXYPohttILixiExhT9vI=;
 b=GcqoSOATgdiJrr5Oyizj8W+rLOQpOg6DZBabZvKf0IMeyx8khSL42yhMPQqnKMValL
 uAuTd7nM6YbDqtCbcfkCOb91BewwCwkquHrYu3JXLQuAhzknh9aLKNwGrtiVOjPOF0s3
 MTpErDLuSq5rbVOp8wHNBBV5LvKlhDcle0BvvwrjH9hUYWyryR0raOp0ZUcleQapEoq4
 ZsrhtqCMSeaauWimVgYusqVb6KZP54Kd5hU6BreNlQRzkE1rl+J/nu+1hIq3lFk6wypT
 nmfCTaAyA9oRe3Fgl687yhu8ZucC7AGOBP++xZAZ6+L8CKO8qyNzqJdu7ycUwCrfMU6O
 lf+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=c9G26svnUWbmDEss+L1TLE5EXYPohttILixiExhT9vI=;
 b=Q7ApyVEzDBOXH38yjgyRyBC9v2c0S3aW6arntCTjP9UwA1MocCsZ2stFUxXKyWnkG5
 WY9nWaTgFXDqNvgTt8M4kgdLe9E7Z6yOAhQKpevh9Ay9nl6+j72/sTcb1EqKCsFa4qGY
 7VY9KlJMl6d9OqTZebyOL+bMQ5NSHanyixE4PSLWQ2YZNCam6aa46eNU0j5d+itOsvbx
 CXbvOusq/jnDXplNT6zbWYMg1vr4Qv60jOypK4BZzAQX2CMah6GX57HxQ2lL6vCZAKlo
 xmaLptYQp1IlOXpAE8LSKaaAIyMhAnYYgkg4jh003GSGkEMqn0TEn9HlUfnVKdFJKynp
 nBsA==
X-Gm-Message-State: AOAM530dfwgT4DFEXBp2dD0byJhpDjAyUUjb2OQYLnGl0c3u335FzRH7
 kcwwVtVo7sWD4NhKqKu+Spi0/SDQdwUt
X-Google-Smtp-Source: ABdhPJxZ5g83EDaY4+kbAAODmvGhWrt2ItBDMTFzKjsuLKEcW0HzeMd2O18SphwhlIcp+ggGfCB1veunhgrR
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:35cc:: with SMTP id
 r12mr385000wmq.1.1622627033853; Wed, 02 Jun 2021 02:43:53 -0700 (PDT)
Date: Wed,  2 Jun 2021 09:43:41 +0000
In-Reply-To: <20210602094347.3730846-1-qperret@google.com>
Message-Id: <20210602094347.3730846-2-qperret@google.com>
Mime-Version: 1.0
References: <20210602094347.3730846-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 1/7] KVM: arm64: Move hyp_pool locking out of refcount
 helpers
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The hyp_page refcount helpers currently rely on the hyp_pool lock for
serialization. However, this means the refcounts can't be changed from
the buddy allocator core as it already holds the lock, which means pages
have to go through odd transient states.

For example, when a page is freed, its refcount is set to 0, and the
lock is transiently released before the page can be attached to a free
list in the buddy tree. This is currently harmless as the allocator
checks the list node of each page to see if it is available for
allocation or not, but it means the page refcount can't be trusted to
represent the state of the page even if the pool lock is held.

In order to fix this, remove the pool locking from the refcount helpers,
and move all the logic to the buddy allocator. This will simplify the
removal of the list node from struct hyp_page in a later patch.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h | 35 ----------------------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 43 ++++++++++++++++++++-------
 2 files changed, 32 insertions(+), 46 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 18a4494337bd..f2c84e4fa40f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -22,41 +22,6 @@ struct hyp_pool {
 	unsigned int max_order;
 };
 
-static inline void hyp_page_ref_inc(struct hyp_page *p)
-{
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-
-	hyp_spin_lock(&pool->lock);
-	p->refcount++;
-	hyp_spin_unlock(&pool->lock);
-}
-
-static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
-{
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-	int ret;
-
-	hyp_spin_lock(&pool->lock);
-	p->refcount--;
-	ret = (p->refcount == 0);
-	hyp_spin_unlock(&pool->lock);
-
-	return ret;
-}
-
-static inline void hyp_set_page_refcounted(struct hyp_page *p)
-{
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-
-	hyp_spin_lock(&pool->lock);
-	if (p->refcount) {
-		hyp_spin_unlock(&pool->lock);
-		BUG();
-	}
-	p->refcount = 1;
-	hyp_spin_unlock(&pool->lock);
-}
-
 /* Allocation */
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
 void hyp_get_page(void *addr);
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 237e03bf0cb1..d666f4789e31 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -93,15 +93,6 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 	list_add_tail(&p->node, &pool->free_area[order]);
 }
 
-static void hyp_attach_page(struct hyp_page *p)
-{
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-
-	hyp_spin_lock(&pool->lock);
-	__hyp_attach_page(pool, p);
-	hyp_spin_unlock(&pool->lock);
-}
-
 static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 					   struct hyp_page *p,
 					   unsigned int order)
@@ -125,19 +116,49 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 	return p;
 }
 
+static inline void hyp_page_ref_inc(struct hyp_page *p)
+{
+	p->refcount++;
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	p->refcount--;
+	return (p->refcount == 0);
+}
+
+static inline void hyp_set_page_refcounted(struct hyp_page *p)
+{
+	BUG_ON(p->refcount);
+	p->refcount = 1;
+}
+
+/*
+ * Changes to the buddy tree and page refcounts must be done with the hyp_pool
+ * lock held. If a refcount change requires an update to the buddy tree (e.g.
+ * hyp_put_page()), both operations must be done within the same critical
+ * section to guarantee transient states (e.g. a page with null refcount but
+ * not yet attached to a free list) can't be observed by well-behaved readers.
+ */
 void hyp_put_page(void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
+	struct hyp_pool *pool = hyp_page_to_pool(p);
 
+	hyp_spin_lock(&pool->lock);
 	if (hyp_page_ref_dec_and_test(p))
-		hyp_attach_page(p);
+		__hyp_attach_page(pool, p);
+	hyp_spin_unlock(&pool->lock);
 }
 
 void hyp_get_page(void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
+	struct hyp_pool *pool = hyp_page_to_pool(p);
 
+	hyp_spin_lock(&pool->lock);
 	hyp_page_ref_inc(p);
+	hyp_spin_unlock(&pool->lock);
 }
 
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
@@ -159,8 +180,8 @@ void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
 	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
 	p = __hyp_extract_page(pool, p, order);
 
-	hyp_spin_unlock(&pool->lock);
 	hyp_set_page_refcounted(p);
+	hyp_spin_unlock(&pool->lock);
 
 	return hyp_page_to_virt(p);
 }
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
