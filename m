Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 472B1391
	for <kvmarm@lists.linux.dev>; Tue,  7 Mar 2023 03:46:00 +0000 (UTC)
Received: by mail-pg1-f201.google.com with SMTP id n66-20020a634045000000b004e8c27fa528so2684601pga.17
        for <kvmarm@lists.linux.dev>; Mon, 06 Mar 2023 19:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678160759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LXjg3XdHor1xScvKJ1/3b/tZKV68fOXxw69FE2u7KXM=;
        b=TEIrBjGjU179ZpJIWEH+C5Nz88ToCnQe7ZOCNm4q8ZJFUpinJCVFJ4sycG4rScvLaj
         tU9NVkDxDVW53B9O/4L59S4NvY1smRH7Sh6P6E0xd55c+9LWsJxfTCjQdewtzgESZkdz
         GTDel2JZpqbWT9LSzLS9DHDtpvu4YOOSZzrccCpumt7v/IC8RU4PkS+Y2Umnr2eBYnXc
         Y9fJ7t9edp+mO7+pEa9DOjQq6Sw2GLu8jhNODkpGME1bklArNyCTx/qTyFZVpijPxtjs
         t5FqX72mB9ADxcxtXT8TGpb62PoYJ3/+WNVDN3x4bVnDy76LwcXs4tDsjrko71CM62Mp
         6njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678160759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LXjg3XdHor1xScvKJ1/3b/tZKV68fOXxw69FE2u7KXM=;
        b=vpMYAvURIIGYjmPrS08VAMKff4klaUyoNm4hq/PtME8/ZHcNI7HeHVsIV57g7sp6Kb
         YhrVcNgziOImSlg2vTTzv/nrRtQSLbuULhf3pO0GUl8l5cX0wMGqUJwL+Rk3SQ8847Nu
         KoGkD5wYxKIxYhEZvN72S8zo+up7xfdwfb+7m1NGTl8jupwWLT+FVq8Jo+ctGJOaBh2Y
         vSNwskPtzDd3lxH8mhxlI/Vjk8J9hcjPLzqe9xql7l6Uv/MCWYUkrCNeU4eve71R49cf
         gcy9yHp+e6mBOujCB0NVpIxuUx0W5QBLnjcE462RFWKLzlANd39FpKMxTeCeVP8eE0sn
         MQfQ==
X-Gm-Message-State: AO0yUKW0BWJH8V+cvWlpMCYr7H01wTKFf0M+NhI+rVrfPjkhU+eZFYre
	KZErPk7fT7K9+mr7p+pA/kvUXRK4m9Uzqg==
X-Google-Smtp-Source: AK7set8zOY8bAwD3+MNCNiolz9Kw3seRpXSRe4yVUgiUYl/zeIALVmQIW3a9zD8WFqOvbJW1PcnYbWqfr7tVjw==
X-Received: from ricarkol4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a17:902:a3c4:b0:199:6e3:187a with SMTP id
 q4-20020a170902a3c400b0019906e3187amr5371422plb.6.1678160759623; Mon, 06 Mar
 2023 19:45:59 -0800 (PST)
Date: Tue,  7 Mar 2023 03:45:44 +0000
In-Reply-To: <20230307034555.39733-1-ricarkol@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230307034555.39733-1-ricarkol@google.com>
X-Mailer: git-send-email 2.40.0.rc0.216.gc4246ad0f0-goog
Message-ID: <20230307034555.39733-2-ricarkol@google.com>
Subject: [PATCH v6 01/12] KVM: arm64: Rename free_removed to free_unlinked
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
	yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com, 
	catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com, 
	gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com, 
	ricarkol@gmail.com, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Normalize on referring to tables outside of an active paging structure
as 'unlinked'.

A subsequent change to KVM will add support for building page tables
that are not part of an active paging structure. The existing
'removed_table' terminology is quite clunky when applied in this
context.

No functional change intended.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  |  8 ++++----
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 +++---
 arch/arm64/kvm/hyp/pgtable.c          |  6 +++---
 arch/arm64/kvm/mmu.c                  | 10 +++++-----
 4 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index 4cd6762bda80..26a4293726c1 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -104,7 +104,7 @@ static inline bool kvm_level_supports_block_mapping(u32 level)
  *				allocation is physically contiguous.
  * @free_pages_exact:		Free an exact number of memory pages previously
  *				allocated by zalloc_pages_exact.
- * @free_removed_table:		Free a removed paging structure by unlinking and
+ * @free_unlinked_table:	Free an unlinked paging structure by unlinking and
  *				dropping references.
  * @get_page:			Increment the refcount on a page.
  * @put_page:			Decrement the refcount on a page. When the
@@ -124,7 +124,7 @@ struct kvm_pgtable_mm_ops {
 	void*		(*zalloc_page)(void *arg);
 	void*		(*zalloc_pages_exact)(size_t size);
 	void		(*free_pages_exact)(void *addr, size_t size);
-	void		(*free_removed_table)(void *addr, u32 level);
+	void		(*free_unlinked_table)(void *addr, u32 level);
 	void		(*get_page)(void *addr);
 	void		(*put_page)(void *addr);
 	int		(*page_count)(void *addr);
@@ -440,7 +440,7 @@ int __kvm_pgtable_stage2_init(struct kvm_pgtable *pgt, struct kvm_s2_mmu *mmu,
 void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
 
 /**
- * kvm_pgtable_stage2_free_removed() - Free a removed stage-2 paging structure.
+ * kvm_pgtable_stage2_free_unlinked() - Free an unlinked stage-2 paging structure.
  * @mm_ops:	Memory management callbacks.
  * @pgtable:	Unlinked stage-2 paging structure to be freed.
  * @level:	Level of the stage-2 paging structure to be freed.
@@ -448,7 +448,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt);
  * The page-table is assumed to be unreachable by any hardware walkers prior to
  * freeing and therefore no TLB invalidation is performed.
  */
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level);
 
 /**
  * kvm_pgtable_stage2_map() - Install a mapping in a guest stage-2 page-table.
diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 552653fa18be..b030170d803b 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -91,9 +91,9 @@ static void host_s2_put_page(void *addr)
 	hyp_put_page(&host_s2_pool, addr);
 }
 
-static void host_s2_free_removed_table(void *addr, u32 level)
+static void host_s2_free_unlinked_table(void *addr, u32 level)
 {
-	kvm_pgtable_stage2_free_removed(&host_mmu.mm_ops, addr, level);
+	kvm_pgtable_stage2_free_unlinked(&host_mmu.mm_ops, addr, level);
 }
 
 static int prepare_s2_pool(void *pgt_pool_base)
@@ -110,7 +110,7 @@ static int prepare_s2_pool(void *pgt_pool_base)
 	host_mmu.mm_ops = (struct kvm_pgtable_mm_ops) {
 		.zalloc_pages_exact = host_s2_zalloc_pages_exact,
 		.zalloc_page = host_s2_zalloc_page,
-		.free_removed_table = host_s2_free_removed_table,
+		.free_unlinked_table = host_s2_free_unlinked_table,
 		.phys_to_virt = hyp_phys_to_virt,
 		.virt_to_phys = hyp_virt_to_phys,
 		.page_count = hyp_page_count,
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 3d61bd3e591d..a3246d6cddec 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -860,7 +860,7 @@ static int stage2_map_walk_table_pre(const struct kvm_pgtable_visit_ctx *ctx,
 	if (ret)
 		return ret;
 
-	mm_ops->free_removed_table(childp, ctx->level);
+	mm_ops->free_unlinked_table(childp, ctx->level);
 	return 0;
 }
 
@@ -905,7 +905,7 @@ static int stage2_map_walk_leaf(const struct kvm_pgtable_visit_ctx *ctx,
  * The TABLE_PRE callback runs for table entries on the way down, looking
  * for table entries which we could conceivably replace with a block entry
  * for this mapping. If it finds one it replaces the entry and calls
- * kvm_pgtable_mm_ops::free_removed_table() to tear down the detached table.
+ * kvm_pgtable_mm_ops::free_unlinked_table() to tear down the detached table.
  *
  * Otherwise, the LEAF callback performs the mapping at the existing leaves
  * instead.
@@ -1276,7 +1276,7 @@ void kvm_pgtable_stage2_destroy(struct kvm_pgtable *pgt)
 	pgt->pgd = NULL;
 }
 
-void kvm_pgtable_stage2_free_removed(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
+void kvm_pgtable_stage2_free_unlinked(struct kvm_pgtable_mm_ops *mm_ops, void *pgtable, u32 level)
 {
 	kvm_pteref_t ptep = (kvm_pteref_t)pgtable;
 	struct kvm_pgtable_walker walker = {
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 7113587222ff..efdaab3f154d 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -131,21 +131,21 @@ static void kvm_s2_free_pages_exact(void *virt, size_t size)
 
 static struct kvm_pgtable_mm_ops kvm_s2_mm_ops;
 
-static void stage2_free_removed_table_rcu_cb(struct rcu_head *head)
+static void stage2_free_unlinked_table_rcu_cb(struct rcu_head *head)
 {
 	struct page *page = container_of(head, struct page, rcu_head);
 	void *pgtable = page_to_virt(page);
 	u32 level = page_private(page);
 
-	kvm_pgtable_stage2_free_removed(&kvm_s2_mm_ops, pgtable, level);
+	kvm_pgtable_stage2_free_unlinked(&kvm_s2_mm_ops, pgtable, level);
 }
 
-static void stage2_free_removed_table(void *addr, u32 level)
+static void stage2_free_unlinked_table(void *addr, u32 level)
 {
 	struct page *page = virt_to_page(addr);
 
 	set_page_private(page, (unsigned long)level);
-	call_rcu(&page->rcu_head, stage2_free_removed_table_rcu_cb);
+	call_rcu(&page->rcu_head, stage2_free_unlinked_table_rcu_cb);
 }
 
 static void kvm_host_get_page(void *addr)
@@ -682,7 +682,7 @@ static struct kvm_pgtable_mm_ops kvm_s2_mm_ops = {
 	.zalloc_page		= stage2_memcache_zalloc_page,
 	.zalloc_pages_exact	= kvm_s2_zalloc_pages_exact,
 	.free_pages_exact	= kvm_s2_free_pages_exact,
-	.free_removed_table	= stage2_free_removed_table,
+	.free_unlinked_table	= stage2_free_unlinked_table,
 	.get_page		= kvm_host_get_page,
 	.put_page		= kvm_s2_put_page,
 	.page_count		= kvm_host_page_count,
-- 
2.40.0.rc0.216.gc4246ad0f0-goog

