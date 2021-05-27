Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E82F3C47089
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 94E0C6109F
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 94E0C6109F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 470914A551;
	Thu, 27 May 2021 08:51:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qXY5FK5yYF5H; Thu, 27 May 2021 08:51:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3085A4ACC9;
	Thu, 27 May 2021 08:51:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A773D407D1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id J40yEkmUXdic for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 08:51:51 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0128A49F6C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:50 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 g3-20020adfd1e30000b02901122a4b850aso1683926wrd.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 05:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1VjwQ4Izjf01RJSguF+MyepUhFZaPW5Ia+1I2PStwVY=;
 b=vg6SBmeyHn1if0S0th7HR74BmQq74KmKE1yJjpIX9ye6dYwZLFggZYO5tq/veoHetZ
 5Q674WCyrQCG1WcqWZ/jITEVUmcJ4tH02f9Q/jSUmO3DkI1nwPjLa+F+mh/xVPVUv70u
 DhwBIsTjMJG0vUJsYatwyaGUIVp0XfFCtM9O20KmFC1EMHi61ZbgXBOmMAjh+wSNpiwj
 TgqBPSdq5pZx3UnHrUAtAGwfF9G6cMEuCVccdMwhdvt+8C55BcGj7kQFJiqmktvWDITl
 rETXsw+t6gsxPNXVtXZPbOGAzOxk9VekuOtK3lGvNUe4dEMSFsj/2aKbiiLuCFSz7wWp
 YmDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1VjwQ4Izjf01RJSguF+MyepUhFZaPW5Ia+1I2PStwVY=;
 b=DfJsiQDtBb0tVhHYe69MPr5Hy/gYTEEhA/cf004Y4ydyTzuB9MrEsS3dnRQIEmdab2
 ZxZWe6UaNVVEfQ7gQdPLFL1+8Ew8T0hlArKK4pyRmt4aH10LvRvpZN7oN35HsA30htEm
 IrD6G914F+5CT+LJtJxF0Cz5dTNi4C5KxhjRriZt/umrShVlKp4+Ks4H2iEDSW5RWjKa
 oJRzDqAeNw8U4QfU/LL3qe9WoA2mkfmdCemmcZNKJ6Om86FuRMgndCXFNnDuTAJQeqGO
 kW0eQJYAjp3RDeg0Vfvk6zyk7TVTjc3jALJLXFz2h8ihPQ3e4KAjA+nFxHx+t99gt0w4
 YJNA==
X-Gm-Message-State: AOAM533kQG031LFtfADCO6eFf6jNEVAM4y9bMymfIQ63z/rt0dy4PZCD
 mUDv2+dNnMC/RST4wfh7EjKUP1xUlvKk
X-Google-Smtp-Source: ABdhPJyrMPjGXOBkf7UTBcOaGjq3koWvGQeLen0va0jMrfOi2lbpRnwG62zACEHhkBJxblCYtamLOJFnGkdm
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a1c:e205:: with SMTP id
 z5mr6882602wmg.70.1622119910127; Thu, 27 May 2021 05:51:50 -0700 (PDT)
Date: Thu, 27 May 2021 12:51:33 +0000
In-Reply-To: <20210527125134.2116404-1-qperret@google.com>
Message-Id: <20210527125134.2116404-7-qperret@google.com>
Mime-Version: 1.0
References: <20210527125134.2116404-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 6/7] KVM: arm64: Use less bits for hyp_page order
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

The hyp_page order is currently encoded on 4 bytes even though it is
guaranteed to be smaller than this. Make it 2 bytes to reduce the hyp
vmemmap overhead.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  6 +++---
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 12 ++++++------
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index 9ed374648364..d420e5c0845f 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -7,7 +7,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/spinlock.h>
 
-#define HYP_NO_ORDER	UINT_MAX
+#define HYP_NO_ORDER	USHRT_MAX
 
 struct hyp_pool {
 	/*
@@ -19,7 +19,7 @@ struct hyp_pool {
 	struct list_head free_area[MAX_ORDER];
 	phys_addr_t range_start;
 	phys_addr_t range_end;
-	unsigned int max_order;
+	unsigned short max_order;
 };
 
 static inline void hyp_page_ref_inc(struct hyp_page *p)
@@ -41,7 +41,7 @@ static inline void hyp_set_page_refcounted(struct hyp_page *p)
 }
 
 /* Allocation */
-void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
+void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
 void hyp_get_page(void *addr, struct hyp_pool *pool);
 void hyp_put_page(void *addr, struct hyp_pool *pool);
 
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 991636be2f46..3fe34fa30ea4 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -9,7 +9,7 @@
 
 struct hyp_page {
 	unsigned int refcount;
-	unsigned int order;
+	unsigned short order;
 };
 
 extern u64 __hyp_vmemmap;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index e453108a2d95..2ba2c550ab03 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -32,7 +32,7 @@ u64 __hyp_vmemmap;
  */
 static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
 					     struct hyp_page *p,
-					     unsigned int order)
+					     unsigned short order)
 {
 	phys_addr_t addr = hyp_page_to_phys(p);
 
@@ -51,7 +51,7 @@ static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
 /* Find a buddy page currently available for allocation */
 static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
 					   struct hyp_page *p,
-					   unsigned int order)
+					   unsigned short order)
 {
 	struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
 
@@ -93,7 +93,7 @@ static inline struct hyp_page *node_to_page(struct list_head *node)
 static void __hyp_attach_page(struct hyp_pool *pool,
 			      struct hyp_page *p)
 {
-	unsigned int order = p->order;
+	unsigned short order = p->order;
 	struct hyp_page *buddy;
 
 	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
@@ -123,7 +123,7 @@ static void __hyp_attach_page(struct hyp_pool *pool,
 
 static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
 					   struct hyp_page *p,
-					   unsigned int order)
+					   unsigned short order)
 {
 	struct hyp_page *buddy;
 
@@ -168,9 +168,9 @@ void hyp_get_page(void *addr, struct hyp_pool *pool)
 	hyp_spin_unlock(&pool->lock);
 }
 
-void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
+void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order)
 {
-	unsigned int i = order;
+	unsigned short i = order;
 	struct hyp_page *p;
 
 	hyp_spin_lock(&pool->lock);
-- 
2.31.1.818.g46aad6cb9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
