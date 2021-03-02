Return-Path: <SRS0=a/wb=IA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66405C433E0
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 10D6964F39
	for <kvmarm@archiver.kernel.org>; Tue,  2 Mar 2021 15:00:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 10D6964F39
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B65464B650;
	Tue,  2 Mar 2021 10:00:38 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id de9ZNKdPXltW; Tue,  2 Mar 2021 10:00:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 310EE4B65A;
	Tue,  2 Mar 2021 10:00:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CEEB84B663
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SlS6hLwN7Hx9 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  2 Mar 2021 10:00:34 -0500 (EST)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4E4C54B678
 for <kvmarm@lists.cs.columbia.edu>; Tue,  2 Mar 2021 10:00:34 -0500 (EST)
Received: by mail-wr1-f73.google.com with SMTP id e13so11208337wrg.4
 for <kvmarm@lists.cs.columbia.edu>; Tue, 02 Mar 2021 07:00:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=pye8MWijHDuX/6U4nUOVsXqZBW6SBmLY4zPnwQvFKsw=;
 b=epDHIE/L93TKXA7lQa8OgDcHaSB6tPztVKPOaQGywIiQJfROqLgjmNZK9s7BuQEZCQ
 ulFzjV+XDin1zWhRy8bl5TKBaam+7aCd02v73F1fQuvP6LrLFa+qY6uy0wKCay6qCNNj
 5wxAx9if0cS2zloTC9veY+x64MQq4HxvCWH7ZI/jSL60OUuXLCOSQwLVLDNyWT2og9YT
 vHMc3yMYUucpvG9ksdaVNy2d7/0Sn50mcjTrrBsQCmtkxDRDn4wlY3Iiv6m5oVfp21Fk
 ND8I3ldY9T+swh8x9j3PvEtyR3ZJM+aprvLfel2/snbaDBuWfmkADrYb3ARs0SOLLuLP
 uczQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=pye8MWijHDuX/6U4nUOVsXqZBW6SBmLY4zPnwQvFKsw=;
 b=Gw5lDL0baFcaMFdj/W9Low39lGTh1M9jFOhtVX00TNdQUIbnBt/YX8MMTFjNM0hzIi
 +cGmf24Mm3rvPxpi/0qAZlJm1D7pQ0Uq2JVmJwv38IEvOTcM6b8dmpZ+DiTugDBMDU85
 2ACsXllRJOyJT0aBQkYk9cuYAl27RHOFMKahM/BeBRq6hL2C5lluC59DURQ+l1j0z3VA
 Oz7IMQg9dcKDiiytzi2Ia4pTkuES3DmocuqvPBD3AeBzFRkDD3JCmyFh6eff9GXOxkov
 2H8xENGf6m6c5FGD/jvuA0UNmg9UT+xN5md+8Sv0QmC78IFDSknxA9pcbgGrDiUdEcMf
 J58Q==
X-Gm-Message-State: AOAM533HU+r+nEPyZxQHHIn3/13avYiNCpdS1wz5A3x8GCeDszvCsmti
 6wyNuaKV66X7L7I+bOmD2kiMhxcRIfgj
X-Google-Smtp-Source: ABdhPJyfV1MJIORGvvergETmz4TjrbeLzl0o8XcLTDwcrpsGfbKpZNLJA1ZH5Z44AlNYao0NkvRZHPdZwRj+
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:adf:e548:: with SMTP id
 z8mr23029463wrm.246.1614697233474; Tue, 02 Mar 2021 07:00:33 -0800 (PST)
Date: Tue,  2 Mar 2021 14:59:42 +0000
In-Reply-To: <20210302150002.3685113-1-qperret@google.com>
Message-Id: <20210302150002.3685113-13-qperret@google.com>
Mime-Version: 1.0
References: <20210302150002.3685113-1-qperret@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH v3 12/32] KVM: arm64: Introduce a Hyp buddy page allocator
From: Quentin Perret <qperret@google.com>
To: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
Cc: android-kvm@google.com, seanjc@google.com, mate.toth-pal@arm.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, tabba@google.com
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

When memory protection is enabled, the hyp code will require a basic
form of memory management in order to allocate and free memory pages at
EL2. This is needed for various use-cases, including the creation of hyp
mappings or the allocation of stage 2 page tables.

To address these use-case, introduce a simple memory allocator in the
hyp code. The allocator is designed as a conventional 'buddy allocator',
working with a page granularity. It allows to allocate and free
physically contiguous pages from memory 'pools', with a guaranteed order
alignment in the PA space. Each page in a memory pool is associated
with a struct hyp_page which holds the page's metadata, including its
refcount, as well as its current order, hence mimicking the kernel's
buddy system in the GFP infrastructure. The hyp_page metadata are made
accessible through a hyp_vmemmap, following the concept of
SPARSE_VMEMMAP in the kernel.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  55 +++++++
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  28 ++++
 arch/arm64/kvm/hyp/nvhe/Makefile         |   2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 195 +++++++++++++++++++++++
 4 files changed, 279 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
new file mode 100644
index 000000000000..d039086d86b5
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_HYP_GFP_H
+#define __KVM_HYP_GFP_H
+
+#include <linux/list.h>
+
+#include <nvhe/memory.h>
+#include <nvhe/spinlock.h>
+
+#define HYP_NO_ORDER	UINT_MAX
+
+struct hyp_pool {
+	/*
+	 * Spinlock protecting concurrent changes to the memory pool as well as
+	 * the struct hyp_page of the pool's pages until we have a proper atomic
+	 * API at EL2.
+	 */
+	hyp_spinlock_t lock;
+	struct list_head free_area[MAX_ORDER];
+	phys_addr_t range_start;
+	phys_addr_t range_end;
+	unsigned int max_order;
+};
+
+static inline void hyp_page_ref_inc(struct hyp_page *p)
+{
+	struct hyp_pool *pool = hyp_page_to_pool(p);
+
+	hyp_spin_lock(&pool->lock);
+	p->refcount++;
+	hyp_spin_unlock(&pool->lock);
+}
+
+static inline int hyp_page_ref_dec_and_test(struct hyp_page *p)
+{
+	struct hyp_pool *pool = hyp_page_to_pool(p);
+	int ret;
+
+	hyp_spin_lock(&pool->lock);
+	p->refcount--;
+	ret = (p->refcount == 0);
+	hyp_spin_unlock(&pool->lock);
+
+	return ret;
+}
+
+/* Allocation */
+void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order);
+void hyp_get_page(void *addr);
+void hyp_put_page(void *addr);
+
+/* Used pages cannot be freed */
+int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
+		  unsigned int reserved_pages);
+#endif /* __KVM_HYP_GFP_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 3e49eaa7e682..d2fb307c5952 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/memory.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/memory.h
@@ -6,7 +6,17 @@
 
 #include <linux/types.h>
 
+struct hyp_pool;
+struct hyp_page {
+	unsigned int refcount;
+	unsigned int order;
+	struct hyp_pool *pool;
+	struct list_head node;
+};
+
 extern s64 hyp_physvirt_offset;
+extern u64 __hyp_vmemmap;
+#define hyp_vmemmap ((struct hyp_page *)__hyp_vmemmap)
 
 #define __hyp_pa(virt)	((phys_addr_t)(virt) + hyp_physvirt_offset)
 #define __hyp_va(phys)	((void *)((phys_addr_t)(phys) - hyp_physvirt_offset))
@@ -21,4 +31,22 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
 	return __hyp_pa(addr);
 }
 
+#define hyp_phys_to_pfn(phys)	((phys) >> PAGE_SHIFT)
+#define hyp_pfn_to_phys(pfn)	((phys_addr_t)((pfn) << PAGE_SHIFT))
+#define hyp_phys_to_page(phys)	(&hyp_vmemmap[hyp_phys_to_pfn(phys)])
+#define hyp_virt_to_page(virt)	hyp_phys_to_page(__hyp_pa(virt))
+#define hyp_virt_to_pfn(virt)	hyp_phys_to_pfn(__hyp_pa(virt))
+
+#define hyp_page_to_pfn(page)	((struct hyp_page *)(page) - hyp_vmemmap)
+#define hyp_page_to_phys(page)  hyp_pfn_to_phys((hyp_page_to_pfn(page)))
+#define hyp_page_to_virt(page)	__hyp_va(hyp_page_to_phys(page))
+#define hyp_page_to_pool(page)	(((struct hyp_page *)page)->pool)
+
+static inline int hyp_page_count(void *addr)
+{
+	struct hyp_page *p = hyp_virt_to_page(addr);
+
+	return p->refcount;
+}
+
 #endif /* __KVM_HYP_MEMORY_H */
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 144da72ad510..6894a917f290 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -13,7 +13,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
new file mode 100644
index 000000000000..348fc4329e8f
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2020 Google LLC
+ * Author: Quentin Perret <qperret@google.com>
+ */
+
+#include <asm/kvm_hyp.h>
+#include <nvhe/gfp.h>
+
+u64 __hyp_vmemmap;
+
+/*
+ * Index the hyp_vmemmap to find a potential buddy page, but make no assumption
+ * about its current state.
+ *
+ * Example buddy-tree for a 4-pages physically contiguous pool:
+ *
+ *                 o : Page 3
+ *                /
+ *               o-o : Page 2
+ *              /
+ *             /   o : Page 1
+ *            /   /
+ *           o---o-o : Page 0
+ *    Order  2   1 0
+ *
+ * Example of requests on this pool:
+ *   __find_buddy_nocheck(pool, page 0, order 0) => page 1
+ *   __find_buddy_nocheck(pool, page 0, order 1) => page 2
+ *   __find_buddy_nocheck(pool, page 1, order 0) => page 0
+ *   __find_buddy_nocheck(pool, page 2, order 0) => page 3
+ */
+static struct hyp_page *__find_buddy_nocheck(struct hyp_pool *pool,
+					     struct hyp_page *p,
+					     unsigned int order)
+{
+	phys_addr_t addr = hyp_page_to_phys(p);
+
+	addr ^= (PAGE_SIZE << order);
+
+	/*
+	 * Don't return a page outside the pool range -- it belongs to
+	 * something else and may not be mapped in hyp_vmemmap.
+	 */
+	if (addr < pool->range_start || addr >= pool->range_end)
+		return NULL;
+
+	return hyp_phys_to_page(addr);
+}
+
+/* Find a buddy page currently available for allocation */
+static struct hyp_page *__find_buddy_avail(struct hyp_pool *pool,
+					   struct hyp_page *p,
+					   unsigned int order)
+{
+	struct hyp_page *buddy = __find_buddy_nocheck(pool, p, order);
+
+	if (!buddy || buddy->order != order || list_empty(&buddy->node))
+		return NULL;
+
+	return buddy;
+
+}
+
+static void __hyp_attach_page(struct hyp_pool *pool,
+			      struct hyp_page *p)
+{
+	unsigned int order = p->order;
+	struct hyp_page *buddy;
+
+	memset(hyp_page_to_virt(p), 0, PAGE_SIZE << p->order);
+
+	/*
+	 * Only the first struct hyp_page of a high-order page (otherwise known
+	 * as the 'head') should have p->order set. The non-head pages should
+	 * have p->order = HYP_NO_ORDER. Here @p may no longer be the head
+	 * after coallescing, so make sure to mark it HYP_NO_ORDER proactively.
+	 */
+	p->order = HYP_NO_ORDER;
+	for (; (order + 1) < pool->max_order; order++) {
+		buddy = __find_buddy_avail(pool, p, order);
+		if (!buddy)
+			break;
+
+		/* Take the buddy out of its list, and coallesce with @p */
+		list_del_init(&buddy->node);
+		buddy->order = HYP_NO_ORDER;
+		p = (p < buddy) ? p : buddy;
+	}
+
+	/* Mark the new head, and insert it */
+	p->order = order;
+	list_add_tail(&p->node, &pool->free_area[order]);
+}
+
+static void hyp_attach_page(struct hyp_page *p)
+{
+	struct hyp_pool *pool = hyp_page_to_pool(p);
+
+	hyp_spin_lock(&pool->lock);
+	__hyp_attach_page(pool, p);
+	hyp_spin_unlock(&pool->lock);
+}
+
+static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
+					   struct hyp_page *p,
+					   unsigned int order)
+{
+	struct hyp_page *buddy;
+
+	list_del_init(&p->node);
+	while (p->order > order) {
+		/*
+		 * The buddy of order n - 1 currently has HYP_NO_ORDER as it
+		 * is covered by a higher-level page (whose head is @p). Use
+		 * __find_buddy_nocheck() to find it and inject it in the
+		 * free_list[n - 1], effectively splitting @p in half.
+		 */
+		p->order--;
+		buddy = __find_buddy_nocheck(pool, p, p->order);
+		buddy->order = p->order;
+		list_add_tail(&buddy->node, &pool->free_area[buddy->order]);
+	}
+
+	return p;
+}
+
+void hyp_put_page(void *addr)
+{
+	struct hyp_page *p = hyp_virt_to_page(addr);
+
+	if (hyp_page_ref_dec_and_test(p))
+		hyp_attach_page(p);
+}
+
+void hyp_get_page(void *addr)
+{
+	struct hyp_page *p = hyp_virt_to_page(addr);
+
+	hyp_page_ref_inc(p);
+}
+
+void *hyp_alloc_pages(struct hyp_pool *pool, unsigned int order)
+{
+	unsigned int i = order;
+	struct hyp_page *p;
+
+	hyp_spin_lock(&pool->lock);
+
+	/* Look for a high-enough-order page */
+	while (i < pool->max_order && list_empty(&pool->free_area[i]))
+		i++;
+	if (i >= pool->max_order) {
+		hyp_spin_unlock(&pool->lock);
+		return NULL;
+	}
+
+	/* Extract it from the tree at the right order */
+	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
+	p = __hyp_extract_page(pool, p, order);
+
+	hyp_spin_unlock(&pool->lock);
+	hyp_page_ref_inc(p);
+
+	return p ? hyp_page_to_virt(p) : NULL;
+}
+
+int hyp_pool_init(struct hyp_pool *pool, u64 pfn, unsigned int nr_pages,
+		  unsigned int reserved_pages)
+{
+	phys_addr_t phys = hyp_pfn_to_phys(pfn);
+	struct hyp_page *p;
+	int i;
+
+	hyp_spin_lock_init(&pool->lock);
+	pool->max_order = min(MAX_ORDER, get_order(nr_pages << PAGE_SHIFT));
+	for (i = 0; i < pool->max_order; i++)
+		INIT_LIST_HEAD(&pool->free_area[i]);
+	pool->range_start = phys;
+	pool->range_end = phys + (nr_pages << PAGE_SHIFT);
+
+	/* Init the vmemmap portion */
+	p = hyp_phys_to_page(phys);
+	memset(p, 0, sizeof(*p) * nr_pages);
+	for (i = 0; i < nr_pages; i++) {
+		p[i].pool = pool;
+		INIT_LIST_HEAD(&p[i].node);
+	}
+
+	/* Attach the unused pages to the buddy tree */
+	for (i = reserved_pages; i < nr_pages; i++)
+		__hyp_attach_page(pool, &p[i]);
+
+	return 0;
+}
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
