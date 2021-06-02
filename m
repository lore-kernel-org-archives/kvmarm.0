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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3571EC47093
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4E74613BF
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4E74613BF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E78049F8F;
	Wed,  2 Jun 2021 05:44:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id x9stss94bew8; Wed,  2 Jun 2021 05:44:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B2DED4A5A0;
	Wed,  2 Jun 2021 05:44:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AEF3440856
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:44:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wtCKOoexh7T3 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 05:44:08 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8D4344A319
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:44:00 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 o10-20020a05622a138ab029023ee9c05f1eso986048qtk.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 02:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=ofFGPvvwIXZqH8gfjNYLHplOpXsBE/sEx9SqgA/jKn4=;
 b=M07Nm+ShVS7ds9EPGTVntA5Hd0A/yeVOhnF5gmQOwFbsJf+D63JOeN5bMxoXSEUl1J
 tCfrzlWNxhhhNCy6vOrVG4p/DZdH3UJaEZYjkab+W1zyXHo9tB7XH9m3snmOxKfcScgU
 uDB29M8UUBvbdg0yeE+pMUJX/lFgY+1pvvOBZu0Erzf2UhZorgNeRZ/q5RTcu1+eGDCG
 ZawI0iA/+lwa2RHEa5k8Yyry0toOdnHvG1s/cQ24A7ga40kDLDnnIFNMMYzATAmi3dhF
 mvrtBqwKOPvt9AyYsWWlZpuPvSxmLswfVfL3eXtbk+1VJ8O1fCdxLhHCJm+F1jqBz1hD
 Uniw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ofFGPvvwIXZqH8gfjNYLHplOpXsBE/sEx9SqgA/jKn4=;
 b=XyIqvlwyYk6vBBmVmvO0OgCpbehuJ+FnQ/246gIsoKLj8Dxh1iS6s2Um15ljA6Q92s
 4UMMV4hZ20VR/8Q3ZjUUBD+TGdyYxVBDmvbBJk3ZRZnPsdwnkxqLGanQUsjSZg6+7b5h
 fIufcjw03UqH26Lp1nQoGzkyYng5098Q4NYdGobt8d6WyKPu6CrV6p/S0FsGaLmAEKR0
 EnCzjJDgBldkelOr3scl8q6HeHUWsQCdmRLUM53gK2qzgkOlFlq/PyFU2zeevUIRsib/
 8XVyic7Lyjl4Z3bGzxWuK1PlxEEzKvJU7yUw073pLIy3IXzCD/+cDAa0ZQ7HUWyTicam
 di9Q==
X-Gm-Message-State: AOAM533gmIp8pkUj+qHKcv+wzRjSunyJNFhHxD0oOni+LzXsKugph01l
 RyuhA/eSV16/ue6+ddBUeNPjjPUtjyPs
X-Google-Smtp-Source: ABdhPJzY+neeJuSq4GoyamQtUDLMJrL/pDoFIpyY+8ImNj+ITViiir8Z8blmTXrJmRiE1LSVC/2JtapmMZxK
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:e387:: with SMTP id
 a7mr25742137qvl.36.1622627040109; Wed, 02 Jun 2021 02:44:00 -0700 (PDT)
Date: Wed,  2 Jun 2021 09:43:44 +0000
In-Reply-To: <20210602094347.3730846-1-qperret@google.com>
Message-Id: <20210602094347.3730846-5-qperret@google.com>
Mime-Version: 1.0
References: <20210602094347.3730846-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 4/7] KVM: arm64: Unify MMIO and mem host stage-2 pools
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

We currently maintain two separate memory pools for the host stage-2,
one for pages used in the page-table when mapping memory regions, and
the other to map MMIO regions. The former is large enough to map all of
memory with page granularity and the latter can cover an arbitrary
portion of IPA space, but allows to 'recycle' pages.

However, this split makes accounting difficult to manage as pages at
intermediate levels of the page-table may be used to map both memory and
MMIO regions. Simplify the scheme by merging both pools into one. This
means we can now hit the -ENOMEM case in the memory abort path, but
we're still guaranteed forward-progress in the worst case by unmapping
MMIO regions. On the plus side this also means we can usually map a lot
more MMIO space at once if memory ranges happen to be mapped with block
mappings.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |  2 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          | 13 +++---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         | 46 ++++++++-----------
 arch/arm64/kvm/hyp/nvhe/setup.c               | 16 ++-----
 arch/arm64/kvm/hyp/reserved_mem.c             |  3 +-
 5 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
index 42d81ec739fa..9c227d87c36d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mem_protect.h
@@ -23,7 +23,7 @@ extern struct host_kvm host_kvm;
 int __pkvm_prot_finalize(void);
 int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end);
 
-int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool);
+int kvm_host_prepare_stage2(void *pgt_pool_base);
 void handle_host_mem_abort(struct kvm_cpu_context *host_ctxt);
 
 static __always_inline void __load_host_stage2(void)
diff --git a/arch/arm64/kvm/hyp/include/nvhe/mm.h b/arch/arm64/kvm/hyp/include/nvhe/mm.h
index 0095f6289742..8ec3a5a7744b 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/mm.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/mm.h
@@ -78,19 +78,20 @@ static inline unsigned long hyp_s1_pgtable_pages(void)
 	return res;
 }
 
-static inline unsigned long host_s2_mem_pgtable_pages(void)
+static inline unsigned long host_s2_pgtable_pages(void)
 {
+	unsigned long res;
+
 	/*
 	 * Include an extra 16 pages to safely upper-bound the worst case of
 	 * concatenated pgds.
 	 */
-	return __hyp_pgtable_total_pages() + 16;
-}
+	res = __hyp_pgtable_total_pages() + 16;
 
-static inline unsigned long host_s2_dev_pgtable_pages(void)
-{
 	/* Allow 1 GiB for MMIO mappings */
-	return __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
+	res += __hyp_pgtable_max_pages(SZ_1G >> PAGE_SHIFT);
+
+	return res;
 }
 
 #endif /* __KVM_HYP_MM_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index e342f7f4f4fb..fdd5b5702e8a 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -23,8 +23,7 @@
 extern unsigned long hyp_nr_cpus;
 struct host_kvm host_kvm;
 
-struct hyp_pool host_s2_mem;
-struct hyp_pool host_s2_dev;
+struct hyp_pool host_s2_pool;
 
 /*
  * Copies of the host's CPU features registers holding sanitized values.
@@ -36,7 +35,7 @@ static const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
 {
-	return hyp_alloc_pages(&host_s2_mem, get_order(size));
+	return hyp_alloc_pages(&host_s2_pool, get_order(size));
 }
 
 static void *host_s2_zalloc_page(void *pool)
@@ -44,20 +43,14 @@ static void *host_s2_zalloc_page(void *pool)
 	return hyp_alloc_pages(pool, 0);
 }
 
-static int prepare_s2_pools(void *mem_pgt_pool, void *dev_pgt_pool)
+static int prepare_s2_pool(void *pgt_pool_base)
 {
 	unsigned long nr_pages, pfn;
 	int ret;
 
-	pfn = hyp_virt_to_pfn(mem_pgt_pool);
-	nr_pages = host_s2_mem_pgtable_pages();
-	ret = hyp_pool_init(&host_s2_mem, pfn, nr_pages, 0);
-	if (ret)
-		return ret;
-
-	pfn = hyp_virt_to_pfn(dev_pgt_pool);
-	nr_pages = host_s2_dev_pgtable_pages();
-	ret = hyp_pool_init(&host_s2_dev, pfn, nr_pages, 0);
+	pfn = hyp_virt_to_pfn(pgt_pool_base);
+	nr_pages = host_s2_pgtable_pages();
+	ret = hyp_pool_init(&host_s2_pool, pfn, nr_pages, 0);
 	if (ret)
 		return ret;
 
@@ -86,7 +79,7 @@ static void prepare_host_vtcr(void)
 					  id_aa64mmfr1_el1_sys_val, phys_shift);
 }
 
-int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
+int kvm_host_prepare_stage2(void *pgt_pool_base)
 {
 	struct kvm_s2_mmu *mmu = &host_kvm.arch.mmu;
 	int ret;
@@ -94,7 +87,7 @@ int kvm_host_prepare_stage2(void *mem_pgt_pool, void *dev_pgt_pool)
 	prepare_host_vtcr();
 	hyp_spin_lock_init(&host_kvm.lock);
 
-	ret = prepare_s2_pools(mem_pgt_pool, dev_pgt_pool);
+	ret = prepare_s2_pool(pgt_pool_base);
 	if (ret)
 		return ret;
 
@@ -199,11 +192,10 @@ static bool range_is_memory(u64 start, u64 end)
 }
 
 static inline int __host_stage2_idmap(u64 start, u64 end,
-				      enum kvm_pgtable_prot prot,
-				      struct hyp_pool *pool)
+				      enum kvm_pgtable_prot prot)
 {
 	return kvm_pgtable_stage2_map(&host_kvm.pgt, start, end - start, start,
-				      prot, pool);
+				      prot, &host_s2_pool);
 }
 
 static int host_stage2_idmap(u64 addr)
@@ -211,7 +203,6 @@ static int host_stage2_idmap(u64 addr)
 	enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_R | KVM_PGTABLE_PROT_W;
 	struct kvm_mem_range range;
 	bool is_memory = find_mem_range(addr, &range);
-	struct hyp_pool *pool = is_memory ? &host_s2_mem : &host_s2_dev;
 	int ret;
 
 	if (is_memory)
@@ -222,22 +213,21 @@ static int host_stage2_idmap(u64 addr)
 	if (ret)
 		goto unlock;
 
-	ret = __host_stage2_idmap(range.start, range.end, prot, pool);
-	if (is_memory || ret != -ENOMEM)
+	ret = __host_stage2_idmap(range.start, range.end, prot);
+	if (ret != -ENOMEM)
 		goto unlock;
 
 	/*
-	 * host_s2_mem has been provided with enough pages to cover all of
-	 * memory with page granularity, so we should never hit the ENOMEM case.
-	 * However, it is difficult to know how much of the MMIO range we will
-	 * need to cover upfront, so we may need to 'recycle' the pages if we
-	 * run out.
+	 * The pool has been provided with enough pages to cover all of memory
+	 * with page granularity, but it is difficult to know how much of the
+	 * MMIO range we will need to cover upfront, so we may need to 'recycle'
+	 * the pages if we run out.
 	 */
 	ret = host_stage2_unmap_dev_all();
 	if (ret)
 		goto unlock;
 
-	ret = __host_stage2_idmap(range.start, range.end, prot, pool);
+	ret = __host_stage2_idmap(range.start, range.end, prot);
 
 unlock:
 	hyp_spin_unlock(&host_kvm.lock);
@@ -258,7 +248,7 @@ int __pkvm_mark_hyp(phys_addr_t start, phys_addr_t end)
 
 	hyp_spin_lock(&host_kvm.lock);
 	ret = kvm_pgtable_stage2_set_owner(&host_kvm.pgt, start, end - start,
-					   &host_s2_mem, pkvm_hyp_id);
+					   &host_s2_pool, pkvm_hyp_id);
 	hyp_spin_unlock(&host_kvm.lock);
 
 	return ret != -EAGAIN ? ret : 0;
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 7488f53b0aa2..709cb3d19eb7 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -25,8 +25,7 @@ unsigned long hyp_nr_cpus;
 
 static void *vmemmap_base;
 static void *hyp_pgt_base;
-static void *host_s2_mem_pgt_base;
-static void *host_s2_dev_pgt_base;
+static void *host_s2_pgt_base;
 
 static int divide_memory_pool(void *virt, unsigned long size)
 {
@@ -45,14 +44,9 @@ static int divide_memory_pool(void *virt, unsigned long size)
 	if (!hyp_pgt_base)
 		return -ENOMEM;
 
-	nr_pages = host_s2_mem_pgtable_pages();
-	host_s2_mem_pgt_base = hyp_early_alloc_contig(nr_pages);
-	if (!host_s2_mem_pgt_base)
-		return -ENOMEM;
-
-	nr_pages = host_s2_dev_pgtable_pages();
-	host_s2_dev_pgt_base = hyp_early_alloc_contig(nr_pages);
-	if (!host_s2_dev_pgt_base)
+	nr_pages = host_s2_pgtable_pages();
+	host_s2_pgt_base = hyp_early_alloc_contig(nr_pages);
+	if (!host_s2_pgt_base)
 		return -ENOMEM;
 
 	return 0;
@@ -158,7 +152,7 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
-	ret = kvm_host_prepare_stage2(host_s2_mem_pgt_base, host_s2_dev_pgt_base);
+	ret = kvm_host_prepare_stage2(host_s2_pgt_base);
 	if (ret)
 		goto out;
 
diff --git a/arch/arm64/kvm/hyp/reserved_mem.c b/arch/arm64/kvm/hyp/reserved_mem.c
index 83ca23ac259b..d654921dd09b 100644
--- a/arch/arm64/kvm/hyp/reserved_mem.c
+++ b/arch/arm64/kvm/hyp/reserved_mem.c
@@ -71,8 +71,7 @@ void __init kvm_hyp_reserve(void)
 	}
 
 	hyp_mem_pages += hyp_s1_pgtable_pages();
-	hyp_mem_pages += host_s2_mem_pgtable_pages();
-	hyp_mem_pages += host_s2_dev_pgtable_pages();
+	hyp_mem_pages += host_s2_pgtable_pages();
 
 	/*
 	 * The hyp_vmemmap needs to be backed by pages, but these pages
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
