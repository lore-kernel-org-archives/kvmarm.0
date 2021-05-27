Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58ACBC47089
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EBCD2613D1
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EBCD2613D1
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9DF9649F83;
	Thu, 27 May 2021 08:51:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RycsXk51iPoB; Thu, 27 May 2021 08:51:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CB6E4A531;
	Thu, 27 May 2021 08:51:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC9B94A126
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7eZB5kUGtAEM for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 08:51:39 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BDBA740808
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:39 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 x10-20020adfc18a0000b029010d83c83f2aso1704495wre.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 05:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=59ZrbnR57dXVmexXuU0iZx85Sibct5xhty4f3jqzmUk=;
 b=jVHXS3bvMibkBWS+bH3WSLubeEwo4y03J+vRbsZSsVjoLuBFta5X2GtmfPD5/3Z7QY
 TA8LUPhrubLg14KwptPsqTA0fyIxxEiMv2j6qPoea7xGJBviUgOJS8LKfAtQ6LRg4xiZ
 vNH4I54lKLKr8niplcjTAZf0ZeEFp4WpohPKu/ocRKYxchgP0pLtq8yCHW0wOP4GUgyk
 /wmQI3jlJLAHjRBTEUFDiGi2tu3nCsJijS3psLbSR0F2aqlmeNBMjDWodcEhaMfXQ52i
 HA4j1aHPpJE4izPecyVmlmp71jx2oZWHOQWqJWSClhiCwre/jt9wfMAJdPwgoSBHyx7U
 Go4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=59ZrbnR57dXVmexXuU0iZx85Sibct5xhty4f3jqzmUk=;
 b=tf6JKfeHgwGuun0uyJqG+Khc2urp7t8eKRmu0Dcn0iEW8SjWEro4C7605E63y6P1Tm
 urinbRDqF2JGcUcFsZUzjptSjwuVcTQc1rxTCx4h+i3OjW3GZn0mQOaHI8wc3fneuA7C
 Q68ey2PKx9jKQTMYQpKWEvE+GJJ/6m/2qgHKCQtPmJdMh4fPtR+tHOxBtxBXmQv0E3nj
 JiFmFdlwJxB/noGBSgB7oo72unKhXPSrCXU8HtqSy9uNloubBIUWASkwXNrnUcevO6pc
 c8fL99o+cGTfUY6+3WYCP5n4/LqVxqTmn2LznBudQ9BvYTLCkjTsdMtNL/mrGRIL8FDS
 aysw==
X-Gm-Message-State: AOAM530iZO5iIDWZVjE01nx4aF+Qcd8R3+pmR6zLR+RK1m4Zc6ndUzwo
 SNhH9EOicIl948/J0EQiZNxFy3F8W4k6
X-Google-Smtp-Source: ABdhPJx3hDj3fqzQNROoGJzyF8S2ksFUOMHLT2ocwl3Ym1DkFjpNtt3AG2ucCS5H6j++RJ8/UzZ53q5BHRH4
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:600c:ad3:: with SMTP id
 c19mr8297036wmr.66.1622119898658; Thu, 27 May 2021 05:51:38 -0700 (PDT)
Date: Thu, 27 May 2021 12:51:28 +0000
In-Reply-To: <20210527125134.2116404-1-qperret@google.com>
Message-Id: <20210527125134.2116404-2-qperret@google.com>
Mime-Version: 1.0
References: <20210527125134.2116404-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 1/7] KVM: arm64: Move hyp_pool locking out of refcount helpers
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
 arch/arm64/kvm/hyp/include/nvhe/gfp.h | 21 ++-------------------
 arch/arm64/kvm/hyp/nvhe/page_alloc.c  | 19 ++++++++-----------
 2 files changed, 10 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 18a4494337bd..aada4d97de49 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -24,37 +24,20 @@ struct hyp_pool {
 
 static inline void hyp_page_ref_inc(struct hyp_page *p)
 {
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-
-	hyp_spin_lock(&pool->lock);
 	p->refcount++;
-	hyp_spin_unlock(&pool->lock);
 }
 
 static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
 {
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-	int ret;
-
-	hyp_spin_lock(&pool->lock);
 	p->refcount--;
-	ret = (p->refcount == 0);
-	hyp_spin_unlock(&pool->lock);
-
-	return ret;
+	return (p->refcount == 0);
 }
 
 static inline void hyp_set_page_refcounted(struct hyp_page *p)
 {
-	struct hyp_pool *pool = hyp_page_to_pool(p);
-
-	hyp_spin_lock(&pool->lock);
-	if (p->refcount) {
-		hyp_spin_unlock(&pool->lock);
+	if (p->refcount)
 		BUG();
-	}
 	p->refcount = 1;
-	hyp_spin_unlock(&pool->lock);
 }
 
 /* Allocation */
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 237e03bf0cb1..04573bf35441 100644
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
@@ -128,16 +119,22 @@ static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
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
@@ -159,8 +156,8 @@ void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
 	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
 	p = __hyp_extract_page(pool, p, order);
 
-	hyp_spin_unlock(&pool->lock);
 	hyp_set_page_refcounted(p);
+	hyp_spin_unlock(&pool->lock);
 
 	return hyp_page_to_virt(p);
 }
-- 
2.31.1.818.g46aad6cb9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
