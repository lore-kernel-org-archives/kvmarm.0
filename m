Return-Path: <SRS0=HOrx=GL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C24C433E0
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5DE69239EC
	for <kvmarm@archiver.kernel.org>; Fri,  8 Jan 2021 12:15:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5DE69239EC
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 05C8A4B447;
	Fri,  8 Jan 2021 07:15:57 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R6NU3qxPtzTg; Fri,  8 Jan 2021 07:15:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 913594B40B;
	Fri,  8 Jan 2021 07:15:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 532ED4B408
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kPrszpJrF4KA for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Jan 2021 07:15:53 -0500 (EST)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 506164B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Jan 2021 07:15:52 -0500 (EST)
Received: by mail-qk1-f201.google.com with SMTP id g5so9085427qke.22
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Jan 2021 04:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=ceff8+9tLTRWb3Ib2eeejY1GjuxFu6p07DG9AQWeIgA=;
 b=o1HoA0mPFwZpw0DdHGRPHKx/T6rDflGmOszd0YIx7p2fKFiqlAW1ROvHpBj+onvC50
 qzY9C/SkLL0uTt2VNDditVMD7t6C9KEql1rV3GtAcNq9znapL8tpohAHALK+2Ij5wgA/
 tzYUMncZHqtGZ54jL66WjScg4hKdxqxNnNglO0QT3oi7VbdAuTqlCPSusUJmyo9htZ/T
 QAjg5JHq2MD5peMijqpHS4HhIMdGIX615K0Rti9mHiFzLC+5+27V3BrdxJqCpzp9g4HN
 KMNIIAQ9v6tSIfkbEa6sEDGL1JBwMLOoti3DUBBRGdeyEJLpif4t5Jpquvv2W0ydVH+s
 1slw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=ceff8+9tLTRWb3Ib2eeejY1GjuxFu6p07DG9AQWeIgA=;
 b=rSAVRLsCHpvZFqZN07+uNZByg2mCk5ahZ6zrojattExWEUgkCg7q6l2dt7pWZMBsmd
 S5ShBOWC9jxFbP/fl+zZPqDqDJKErtPrcu3PAJQHeGGh3KHQj7OKRhBIAbHworuEtyly
 QHKhWcgTqM6eNE4caafcLGnaLG8+UM0wx3jARVrT0MhIDeJJyG+KAB6/DKcXPLrVsLyt
 NxqlrLWYwXeYj93EEHCdmC+ZvddT9f70a3WyjfKAa/l7JU4mQogs52vBcLwLH/7pppz9
 b6WPy/JtP2f1Fm8QkM+L7EGiRBpwYkDn0PC5kmmW7bm4PecGM3hHNO6/QCIFI7B5yXwl
 dW9w==
X-Gm-Message-State: AOAM533dFr/muzB6BCuA4yQZvluPSmi/tc9ME50120Q7nDTljgNh6umF
 ulPz3yrCuFemVtGDwo+4TLq5WLJZuPZg
X-Google-Smtp-Source: ABdhPJwkGRhporxOaFcuqjq5p6+PDcs5YIKF7gM3HMEKHCm/kO0804yGlAJfanmP6R2nmlALxy+tEsjGTRKE
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:a0c:fd68:: with SMTP id
 k8mr6434357qvs.56.1610108151798; Fri, 08 Jan 2021 04:15:51 -0800 (PST)
Date: Fri,  8 Jan 2021 12:15:10 +0000
In-Reply-To: <20210108121524.656872-1-qperret@google.com>
Message-Id: <20210108121524.656872-13-qperret@google.com>
Mime-Version: 1.0
References: <20210108121524.656872-1-qperret@google.com>
X-Mailer: git-send-email 2.30.0.284.gd98b1dd5eaa7-goog
Subject: [RFC PATCH v2 12/26] KVM: arm64: Introduce a Hyp buddy page allocator
From: Quentin Perret <qperret@google.com>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>
Cc: devicetree@vger.kernel.org, android-kvm@google.com,
 linux-kernel@vger.kernel.org, Fuad Tabba <tabba@google.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
 arch/arm64/kvm/hyp/include/nvhe/gfp.h    |  32 ++++
 arch/arm64/kvm/hyp/include/nvhe/memory.h |  25 +++
 arch/arm64/kvm/hyp/nvhe/Makefile         |   2 +-
 arch/arm64/kvm/hyp/nvhe/page_alloc.c     | 185 +++++++++++++++++++++++
 4 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm64/kvm/hyp/include/nvhe/gfp.h
 create mode 100644 arch/arm64/kvm/hyp/nvhe/page_alloc.c

diff --git a/arch/arm64/kvm/hyp/include/nvhe/gfp.h b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
new file mode 100644
index 000000000000..95587faee171
--- /dev/null
+++ b/arch/arm64/kvm/hyp/include/nvhe/gfp.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __KVM_HYP_GFP_H
+#define __KVM_HYP_GFP_H
+
+#include <linux/list.h>
+
+#include <nvhe/memory.h>
+#include <nvhe/spinlock.h>
+
+#define HYP_MAX_ORDER	11U
+#define HYP_NO_ORDER	UINT_MAX
+
+struct hyp_pool {
+	hyp_spinlock_t lock;
+	struct list_head free_area[HYP_MAX_ORDER + 1];
+	phys_addr_t range_start;
+	phys_addr_t range_end;
+};
+
+/* GFP flags */
+#define HYP_GFP_NONE	0
+#define HYP_GFP_ZERO	1
+
+/* Allocation */
+void *hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask, unsigned int order);
+void hyp_get_page(void *addr);
+void hyp_put_page(void *addr);
+
+/* Used pages cannot be freed */
+int hyp_pool_init(struct hyp_pool *pool, phys_addr_t phys,
+		  unsigned int nr_pages, unsigned int used_pages);
+#endif /* __KVM_HYP_GFP_H */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/memory.h b/arch/arm64/kvm/hyp/include/nvhe/memory.h
index 64c44c142c95..ed47674bc988 100644
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
 #define __hyp_va(virt)	((void *)((phys_addr_t)(virt) - hyp_physvirt_offset))
@@ -21,4 +31,19 @@ static inline phys_addr_t hyp_virt_to_phys(void *addr)
 	return __hyp_pa(addr);
 }
 
+#define hyp_phys_to_pfn(phys)	((phys) >> PAGE_SHIFT)
+#define hyp_phys_to_page(phys)	(&hyp_vmemmap[hyp_phys_to_pfn(phys)])
+#define hyp_virt_to_page(virt)	hyp_phys_to_page(__hyp_pa(virt))
+
+#define hyp_page_to_phys(page)  ((phys_addr_t)((page) - hyp_vmemmap) << PAGE_SHIFT)
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
index 33bd381d8f73..9e5eacfec6ec 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -10,7 +10,7 @@ lib-objs := clear_page.o copy_page.o memcpy.o memset.o
 lib-objs := $(addprefix ../../../lib/, $(lib-objs))
 
 obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o \
-	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o
+	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o stub.o page_alloc.o
 obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../fpsimd.o ../hyp-entry.o ../exception.o
 obj-y += $(lib-objs)
diff --git a/arch/arm64/kvm/hyp/nvhe/page_alloc.c b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
new file mode 100644
index 000000000000..6de6515f0432
--- /dev/null
+++ b/arch/arm64/kvm/hyp/nvhe/page_alloc.c
@@ -0,0 +1,185 @@
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
+ * Example of requests on this zon:
+ *   __find_buddy(pool, page 0, order 0) => page 1
+ *   __find_buddy(pool, page 0, order 1) => page 2
+ *   __find_buddy(pool, page 1, order 0) => page 0
+ *   __find_buddy(pool, page 2, order 0) => page 3
+ */
+static struct hyp_page *__find_buddy(struct hyp_pool *pool, struct hyp_page *p,
+				     unsigned int order)
+{
+	phys_addr_t addr = hyp_page_to_phys(p);
+
+	addr ^= (PAGE_SIZE << order);
+	if (addr < pool->range_start || addr >= pool->range_end)
+		return NULL;
+
+	return hyp_phys_to_page(addr);
+}
+
+static void __hyp_attach_page(struct hyp_pool *pool,
+			      struct hyp_page *p)
+{
+	unsigned int order = p->order;
+	struct hyp_page *buddy;
+
+	p->order = HYP_NO_ORDER;
+	for (; order < HYP_MAX_ORDER; order++) {
+		/* Nothing to do if the buddy isn't in a free-list */
+		buddy = __find_buddy(pool, p, order);
+		if (!buddy || list_empty(&buddy->node) || buddy->order != order)
+			break;
+
+		/* Otherwise, coalesce the buddies and go one level up */
+		list_del_init(&buddy->node);
+		buddy->order = HYP_NO_ORDER;
+		p = (p < buddy) ? p : buddy;
+	}
+
+	p->order = order;
+	list_add_tail(&p->node, &pool->free_area[order]);
+}
+
+void hyp_put_page(void *addr)
+{
+	struct hyp_page *p = hyp_virt_to_page(addr);
+	struct hyp_pool *pool = hyp_page_to_pool(p);
+
+	hyp_spin_lock(&pool->lock);
+	if (!p->refcount)
+		hyp_panic();
+	p->refcount--;
+	if (!p->refcount)
+		__hyp_attach_page(pool, p);
+	hyp_spin_unlock(&pool->lock);
+}
+
+void hyp_get_page(void *addr)
+{
+	struct hyp_page *p = hyp_virt_to_page(addr);
+	struct hyp_pool *pool = hyp_page_to_pool(p);
+
+	hyp_spin_lock(&pool->lock);
+	p->refcount++;
+	hyp_spin_unlock(&pool->lock);
+}
+
+/* Extract a page from the buddy tree, at a specific order */
+static struct hyp_page *__hyp_extract_page(struct hyp_pool *pool,
+					   struct hyp_page *p,
+					   unsigned int order)
+{
+	struct hyp_page *buddy;
+
+	if (p->order == HYP_NO_ORDER || p->order < order)
+		return NULL;
+
+	list_del_init(&p->node);
+
+	/* Split the page in two until reaching the requested order */
+	while (p->order > order) {
+		p->order--;
+		buddy = __find_buddy(pool, p, p->order);
+		buddy->order = p->order;
+		list_add_tail(&buddy->node, &pool->free_area[buddy->order]);
+	}
+
+	p->refcount = 1;
+
+	return p;
+}
+
+static void clear_hyp_page(struct hyp_page *p)
+{
+	unsigned long i;
+
+	for (i = 0; i < (1 << p->order); i++)
+		clear_page(hyp_page_to_virt(p) + (i << PAGE_SHIFT));
+}
+
+static void *__hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask,
+			       unsigned int order)
+{
+	unsigned int i = order;
+	struct hyp_page *p;
+
+	/* Look for a high-enough-order page */
+	while (i <= HYP_MAX_ORDER && list_empty(&pool->free_area[i]))
+		i++;
+	if (i > HYP_MAX_ORDER)
+		return NULL;
+
+	/* Extract it from the tree at the right order */
+	p = list_first_entry(&pool->free_area[i], struct hyp_page, node);
+	p = __hyp_extract_page(pool, p, order);
+
+	if (mask & HYP_GFP_ZERO)
+		clear_hyp_page(p);
+
+	return p;
+}
+
+void *hyp_alloc_pages(struct hyp_pool *pool, gfp_t mask, unsigned int order)
+{
+	struct hyp_page *p;
+
+	hyp_spin_lock(&pool->lock);
+	p = __hyp_alloc_pages(pool, mask, order);
+	hyp_spin_unlock(&pool->lock);
+
+	return p ? hyp_page_to_virt(p) : NULL;
+}
+
+/* hyp_vmemmap must be backed beforehand */
+int hyp_pool_init(struct hyp_pool *pool, phys_addr_t phys,
+		  unsigned int nr_pages, unsigned int used_pages)
+{
+	struct hyp_page *p;
+	int i;
+
+	if (phys % PAGE_SIZE)
+		return -EINVAL;
+
+	hyp_spin_lock_init(&pool->lock);
+	for (i = 0; i <= HYP_MAX_ORDER; i++)
+		INIT_LIST_HEAD(&pool->free_area[i]);
+	pool->range_start = phys;
+	pool->range_end = phys + (nr_pages << PAGE_SHIFT);
+
+	/* Init the vmemmap portion */
+	p = hyp_phys_to_page(phys);
+	memset(p, 0, sizeof(*p) * nr_pages);
+	for (i = 0; i < nr_pages; i++, p++) {
+		p->pool = pool;
+		INIT_LIST_HEAD(&p->node);
+	}
+
+	/* Attach the unused pages to the buddy tree */
+	p = hyp_phys_to_page(phys + (used_pages << PAGE_SHIFT));
+	for (i = used_pages; i < nr_pages; i++, p++)
+		__hyp_attach_page(pool, p);
+
+	return 0;
+}
-- 
2.30.0.284.gd98b1dd5eaa7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
