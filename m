Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C63E3C47082
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 732836135A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 732836135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 276D14A00B;
	Tue,  8 Jun 2021 07:45:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5NYeDHL9q9Ah; Tue,  8 Jun 2021 07:45:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A81DC4A3A5;
	Tue,  8 Jun 2021 07:45:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51ABF49E5F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NJ37--zQbFEF for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 07:45:45 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 845024064F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:38 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 u5-20020adf9e050000b029010df603f280so9323200wre.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 04:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=5BNxXykWbSSzvgU2PyfVwBVhSOGhRGpGA/8JFAOEVmg=;
 b=RpPiV66cUY0ERU4ts0ZWRLX6HM855EURR0LBhraB/GG2HQQvfPX5fQ0d+wqECu1yLq
 BsE7Qc/3grhd+Y7hO/9tzN2u4M7IuO5K5lTpp/JBQnQGhV3/G1ye2lIf895dn6H3e3be
 wS0Ei7PbgSVXOUPIOPom6v5UkiPp56iUJV37nQoNTAEKbcMhVn/gyg8Sn//+5g5KmWj3
 lKFXL1+52EY0b01a6d8k5AOOqf/kDkJSPiz/bLZqz3mIMK/siOA8lcAZXWXMUFDBTg7F
 VdqnAvUR2UCk5v0EQhE2ze7cx0VNHSnDWjZGyxerqm3ql6BNqZ8v4RfO8LSfHiNFDdWf
 oGAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=5BNxXykWbSSzvgU2PyfVwBVhSOGhRGpGA/8JFAOEVmg=;
 b=GJjjLIgubD+1VDRKyNqox6OCaWNIKJ61/EnoyPAqxEWrv/GdaCxxLnQhZZhijjY9zv
 T09bTnU5zLUQIZzhc7Yw32R7Pwatm9vhf1Y6hXgdQA50vN8KaN0zix7702BHRlTTdEOf
 ro+UwBi9iGwMeqyBtBpMaPD4bWc+2Vtv7Kw7Nt1xqIaaVoqXglIYuSa/BLsSsANiTTEC
 aamFC9URpjQhAR3PoLk1Py8FHMPO4FVhy8062t7bZMHlpkdgcmv8e2ujTpyOJgkp0gaF
 R7xP00GOMImsiI5UAoYFqfoJ2HcD6MKThgYonjjMjqFnL6xLnGYC6Xv/H3kjUEST4nLu
 1/bA==
X-Gm-Message-State: AOAM533pAak5PR4l90ZCoM0CoJkdH+vEMCgl6daB9SHBLQXpRaBDZjq6
 ouVjN9IMR6sCZcPgh0z29GNxkG1Xm6af
X-Google-Smtp-Source: ABdhPJxY0xFXprzkSg2IzWugfcreotUMtjfhIgxJAyEAb/go+uRuv0+nLOY4lwHHvo9KG8qAO8hAvcdRsU0b
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a7b:cb0b:: with SMTP id
 u11mr307833wmj.0.1623152737523; Tue, 08 Jun 2021 04:45:37 -0700 (PDT)
Date: Tue,  8 Jun 2021 11:45:17 +0000
In-Reply-To: <20210608114518.748712-1-qperret@google.com>
Message-Id: <20210608114518.748712-7-qperret@google.com>
Mime-Version: 1.0
References: <20210608114518.748712-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v3 6/7] KVM: arm64: Use less bits for hyp_page order
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
index 3ea7bfb6c380..fb0f523d1492 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -7,7 +7,7 @@
 #include <nvhe/memory.h>
 #include <nvhe/spinlock.h>
 
-#define HYP_NO_ORDER	UINT_MAX
+#define HYP_NO_ORDER	USHRT_MAX
 
 struct hyp_pool {
 	/*
@@ -19,11 +19,11 @@ struct hyp_pool {
 	struct list_head free_area[MAX_ORDER];
 	phys_addr_t range_start;
 	phys_addr_t range_end;
-	unsigned int max_order;
+	unsigned short max_order;
 };
 
 /* Allocation */
-void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
+void *hyp_alloc_pages(struct hyp_pool *pool, unsigned short order);
 void hyp_get_page(struct hyp_pool *pool, void *addr);
 void hyp_put_page(struct hyp_pool *pool, void *addr);
 
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
index e3689def7033..be07055bbc10 100644
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
 
@@ -192,9 +192,9 @@ void hyp_get_page(struct hyp_pool *pool, void *addr)
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
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
