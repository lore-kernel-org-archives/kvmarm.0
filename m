Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A588C4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0DDCE6135A
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 11:45:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0DDCE6135A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B4BDB49E5F;
	Tue,  8 Jun 2021 07:45:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id y4aAKIckBLGy; Tue,  8 Jun 2021 07:45:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7ED5A4A319;
	Tue,  8 Jun 2021 07:45:42 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42D8E40895
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id y1ccjziDZjP2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 07:45:41 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 270A649F83
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 07:45:36 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 190-20020a3708c70000b02903aa60e6d8c1so8020228qki.19
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 04:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=CcKhBHrtrE/oRoJL40NCriVUGHKq+WAbrBb37/bST5E=;
 b=N6R/REz4ypDjIMoMcK3tEjc75MX/zkNinHX3hHsQVqihRFxwe8089S+UykOpHh8VwK
 qMH3bqnJPyrAJyvloziZBUaZfldnmKgRTZlx+kdBdNLGLoruhCS7iGBtlroyKTvXXDgK
 LD3GcWTVf/fQbryWYSgQ2xvXpwKh4JIYZYscTMNMaCrgTG2zwW+m5l+EFFLoJS7c4TCB
 W6z/jkBN+t+2ozsr4N2Q2lH4wIODWu50ZT/OqhGNZKId0rX7dbZ+iQYr4EruboN6kKSx
 6ueh5m5IwsSofk/VxH5YzAOHmp1FVNoKszwyAYWxGDeYYAzxAEzYw8E3+m/NDiSC5Wjn
 h52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=CcKhBHrtrE/oRoJL40NCriVUGHKq+WAbrBb37/bST5E=;
 b=ZWCKoak0OUiSbZH2Jn6ldICEXf3+I8Ca9N6JYTPbaX0N4cW/dpkonlOQVFjODt1GvQ
 Di1BlZJ64KZOvlAvjjbyrCWr1UStbzs772ONtWEM7Td8z9vzU/sqeWIpFnsLLsKO2vaH
 REwV6iy6JE03Y+KkW9PS8hy70MaeZ6ajLLojt5a+QR1N4X6jbMH5Yj9pcUQdPi2Aip5q
 4kBU5HJ/KwhkHvamZ9dI3aPN2rdvxl6jIOFPXFgTqzg3cFVJcBF3HAuw3RTLD4CwhuWn
 ZSVn7sG2SZzOybwXmiWMmTKDe5rWYpSEk6mVtjlGu0kR0eKPn14b/gPk7X6qsqrHBP9i
 WYMQ==
X-Gm-Message-State: AOAM533I2vpGhz61prt/5EVwKE86MgSggLNmh30RXV1e/6BHhn9FS/M7
 BOynhp6Uq79B2iLjBL0VzY9LtojndyLA
X-Google-Smtp-Source: ABdhPJwmV4HHnFr5CoJZmAB4zmxtaQ4QQ4wZomGtKJiRX7H4lCdFOrj6XD5yptTjk6e2TsAql/Ga999/epVc
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a05:6214:e4d:: with SMTP id
 o13mr23256075qvc.19.1623152735694; Tue, 08 Jun 2021 04:45:35 -0700 (PDT)
Date: Tue,  8 Jun 2021 11:45:16 +0000
In-Reply-To: <20210608114518.748712-1-qperret@google.com>
Message-Id: <20210608114518.748712-6-qperret@google.com>
Mime-Version: 1.0
References: <20210608114518.748712-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v3 5/7] KVM: arm64: Remove hyp_pool pointer from struct
 hyp_page
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

Each struct hyp_page currently contains a pointer to a hyp_pool struct
where the page should be freed if its refcount reaches 0. However, this
information can always be inferred from the context in the EL2 code, so
drop the pointer to save a few bytes in the vmemmap.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  4 ++--
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  2 --
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 14 ++++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  7 ++-----
 arch/arm64/kvm/hyp/nvhe/setup.c          | 14 ++++++++++++--
 5 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index f2c84e4fa40f..3ea7bfb6c380 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -24,8 +24,8 @@ struct hyp_pool {
 
 /* Allocation */
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
-void hyp_get_page(void *addr);
-void hyp_put_page(void *addr);
+void hyp_get_page(struct hyp_pool *pool, void *addr);
+void hyp_put_page(struct hyp_pool *pool, void *addr);
 
 /* Used pages cannot be freed */
 int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 7691ab495eb4..991636be2f46 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -7,11 +7,9 @@
 
 #include <linux/types.h>
 
-struct hyp_pool;
 struct hyp_page {
 	unsigned int refcount;
 	unsigned int order;
-	struct hyp_pool *pool;
 };
 
 extern u64 __hyp_vmemmap;
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index c8ed7e86231b..d938ce95d3bd 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -43,6 +43,16 @@ static void *host_s2_zalloc_page(void *pool)
 	return hyp_alloc_pages(pool, 0);
 }
 
+static void host_s2_get_page(void *addr)
+{
+	hyp_get_page(&host_s2_pool, addr);
+}
+
+static void host_s2_put_page(void *addr)
+{
+	hyp_put_page(&host_s2_pool, addr);
+}
+
 static int prepare_s2_pool(void *pgt_pool_base)
 {
 	unsigned long nr_pages, pfn;
@@ -60,8 +70,8 @@ static int prepare_s2_pool(void *pgt_pool_base)
 		.phys_to_virt = hyp_phys_to_virt,
 		.virt_to_phys = hyp_virt_to_phys,
 		.page_count = hyp_page_count,
-		.get_page = hyp_get_page,
-		.put_page = hyp_put_page,
+		.get_page = host_s2_get_page,
+		.put_page = host_s2_put_page,
 	};
 
 	return 0;
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
index 34f0eb026dd2..e3689def7033 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -174,20 +174,18 @@ static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
  * section to guarantee transient states (e.g. a page with null refcount but
  * not yet attached to a free list) can't be observed by well-behaved readers.
  */
-void hyp_put_page(void *addr)
+void hyp_put_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
-	struct hyp_pool *pool = hyp_page_to_pool(p);
 
 	hyp_spin_lock(&pool->lock);
 	__hyp_put_page(pool, p);
 	hyp_spin_unlock(&pool->lock);
 }
 
-void hyp_get_page(void *addr)
+void hyp_get_page(struct hyp_pool *pool, void *addr)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
-	struct hyp_pool *pool = hyp_page_to_pool(p);
 
 	hyp_spin_lock(&pool->lock);
 	hyp_page_ref_inc(p);
@@ -236,7 +234,6 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
 	for (i = 0; i < nr_pages; i++) {
-		p[i].pool = pool;
 		p[i].order = 0;
 		hyp_set_page_refcounted(&p[i]);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 1cff3259a493..f834833ac921 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -137,6 +137,16 @@ static void *hyp_zalloc_hyp_page(void *arg)
 	return hyp_alloc_pages(&hpool, 0);
 }
 
+static void hpool_get_page(void *addr)
+{
+	hyp_get_page(&hpool, addr);
+}
+
+static void hpool_put_page(void *addr)
+{
+	hyp_put_page(&hpool, addr);
+}
+
 void __noreturn __pkvm_init_finalise(void)
 {
 	struct kvm_host_data *host_data = this_cpu_ptr(&kvm_host_data);
@@ -160,8 +170,8 @@ void __noreturn __pkvm_init_finalise(void)
 		.zalloc_page = hyp_zalloc_hyp_page,
 		.phys_to_virt = hyp_phys_to_virt,
 		.virt_to_phys = hyp_virt_to_phys,
-		.get_page = hyp_get_page,
-		.put_page = hyp_put_page,
+		.get_page = hpool_get_page,
+		.put_page = hpool_put_page,
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
