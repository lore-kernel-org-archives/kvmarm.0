Return-Path: <SRS0=LQ+R=KW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0EA6C4708C
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6AC23613D3
	for <kvmarm@archiver.kernel.org>; Thu, 27 May 2021 12:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6AC23613D3
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 202544A19E;
	Thu, 27 May 2021 08:51:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 8yZNrqn23LnU; Thu, 27 May 2021 08:51:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AE154A4E1;
	Thu, 27 May 2021 08:51:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B83D1406AD
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3pdTUZ7tp264 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 May 2021 08:51:48 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB1864079D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 08:51:48 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 b5-20020a0cc9850000b02901eece87073bso3821457qvk.21
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 May 2021 05:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ehs1oQ+8oLxIXVrBNHuhZcAo+D2g9l++j8BZLV6gtTA=;
 b=a+FtUAFPFyiW0uYlgwR0eSULr6xYa8BpYbZNF6URd1JNP9Jw9Hd23+lAYigwVkhKoW
 lyFAkrD2tp/8dk2Rn0LshAJLDfuuF3tyfte6wErSyLZlahexM9sr15qTiMWbRy54SmxA
 CXiqPJ+PxMN1vY+PA3Qkvfqu2y/7s+tGazebtbYsQ+NKZbUxq46OS/xDMwFrSHKhJI8N
 Q50Hl2GkR08amV3wg4iJhrweLLG/4tHzM6TtJFHyR9LfjuSmNPtKWyKL4Ik1TCtRVESm
 4i4sOBb2IvH511qCVxCI/ubxHWCHIZCq9RxmfVeCzmQC4cK/P8RVV750oUvTNGoiuWHm
 IDYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ehs1oQ+8oLxIXVrBNHuhZcAo+D2g9l++j8BZLV6gtTA=;
 b=o1Qp5OB0FIfUoULJO/mufxmXnvf8rhOAtjVZj8jnHf48XP5towf9qSgCad6DW/1rr5
 OBMqulXqtxV575L7RtswA7qX79qNnqg9nAwRYpCxcBmFIWYEZ/AFVdooknaFrLdY11zt
 F9uUSDil/RCvq5CyO1B9s5atQoeUmoxEoLBouol/92pPvsbGIqO6JnuN8VGz1hxn0Mml
 6FARGI1NRJ8K0f/ggsZBkMF35zEUM4eqbBKvzxsenVl6ZgteyzKxcogDiItwDGMAvG98
 PVX9e7TY3oPZUc3kf3OECed/3qpQhjFgGwzKG20JSeUsoOhdlJceSAicaVrnZLLAMGz6
 1yHw==
X-Gm-Message-State: AOAM532g6qfZ7Wmu9ekWQz3xeH2ykuTElD+lSJ+tE+nlA7HJDZ4mmfGx
 ehqT47IMJthTqRVU63a7LecRSkQz2kKv
X-Google-Smtp-Source: ABdhPJyaKy4GEnKIJ/S5dR75Z6Sp8g/ueH5v6TANNcDxhzHPzuTTPn0wYyWBm/8d245iHVbNGmkmL9vYBxK9
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:9e4e:: with SMTP id
 z14mr3459560qve.31.1622119907499; Thu, 27 May 2021 05:51:47 -0700 (PDT)
Date: Thu, 27 May 2021 12:51:32 +0000
In-Reply-To: <20210527125134.2116404-1-qperret@google.com>
Message-Id: <20210527125134.2116404-6-qperret@google.com>
Mime-Version: 1.0
References: <20210527125134.2116404-1-qperret@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 5/7] KVM: arm64: Remove hyp_pool pointer from struct hyp_page
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
 arch/arm64/kvm/hyp/nvhe/mem_protect.c    | 13 +++++++++++--
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     |  7 ++-----
 arch/arm64/kvm/hyp/nvhe/setup.c          | 14 ++++++++++++--
 5 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
index aada4d97de49..9ed374648364 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/gfp.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -42,8 +42,8 @@ static inline void hyp_set_page_refcounted(struct hyp_page *p)
 
 /* Allocation */
 void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
-void hyp_get_page(void *addr);
-void hyp_put_page(void *addr);
+void hyp_get_page(void *addr, struct hyp_pool *pool);
+void hyp_put_page(void *addr, struct hyp_pool *pool);
 
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
index fdd5b5702e8a..3603311eb41c 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -42,6 +42,15 @@ static void *host_s2_zalloc_page(void *pool)
 {
 	return hyp_alloc_pages(pool, 0);
 }
+static void host_s2_get_page(void *addr)
+{
+	hyp_get_page(addr, &host_s2_pool);
+}
+
+static void host_s2_put_page(void *addr)
+{
+	hyp_put_page(addr, &host_s2_pool);
+}
 
 static int prepare_s2_pool(void *pgt_pool_base)
 {
@@ -60,8 +69,8 @@ static int prepare_s2_pool(void *pgt_pool_base)
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
index ce7379f1480b..e453108a2d95 100644
--- a/arch/arm64/kvm/hyp/nvhe/page_alloc.c
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -150,20 +150,18 @@ static void __hyp_put_page(struct hyp_pool *pool, struct hyp_page *p)
 		__hyp_attach_page(pool, p);
 }
 
-void hyp_put_page(void *addr)
+void hyp_put_page(void *addr, struct hyp_pool *pool)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
-	struct hyp_pool *pool = hyp_page_to_pool(p);
 
 	hyp_spin_lock(&pool->lock);
 	__hyp_put_page(pool, p);
 	hyp_spin_unlock(&pool->lock);
 }
 
-void hyp_get_page(void *addr)
+void hyp_get_page(void *addr, struct hyp_pool *pool)
 {
 	struct hyp_page *p = hyp_virt_to_page(addr);
-	struct hyp_pool *pool = hyp_page_to_pool(p);
 
 	hyp_spin_lock(&pool->lock);
 	hyp_page_ref_inc(p);
@@ -212,7 +210,6 @@ int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
 	/* Init the vmemmap portion */
 	p = hyp_phys_to_page(phys);
 	for (i = 0; i < nr_pages; i++) {
-		p[i].pool = pool;
 		p[i].order = 0;
 		hyp_set_page_refcounted(&p[i]);
 	}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 709cb3d19eb7..bf61abd4a330 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -137,6 +137,16 @@ static void *hyp_zalloc_hyp_page(void *arg)
 	return hyp_alloc_pages(&hpool, 0);
 }
 
+static void hpool_get_page(void *addr)
+{
+	hyp_get_page(addr, &hpool);
+}
+
+static void hpool_put_page(void *addr)
+{
+	hyp_put_page(addr, &hpool);
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
2.31.1.818.g46aad6cb9e-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
