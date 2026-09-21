Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0672DC783;
	Mon, 21 Sep 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002162; cv=none; b=tjbu3gZj7uOZVFRttRsj0WAK49Hu8Nft7+jEt+TRh2sEAh3E/uulfTKo4ZwDQFxYaSN9+mhqjEPW6YOqGSq3ICKkiPuDOrO2mQ1euVMueqiuMGGRi4Fz13kAojFqlAcEX1d5JnS5k5PjhhBrlwz9W8P6XyIl/OgQVXPMs3DEQ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002162; c=relaxed/simple;
	bh=zB2zeKx2YeUdzvzpowAomppcMNlet1jlGVEh7GvRdTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X/0sRVuAb6qmdDIsPYiE/1BKFppCC1dPTckqUziueUj+VkeeUV7RnRmE7yh32dpqhNOOy2jj+obIuHFWm9dJmclEhziQ5mVJrJkmQ/7h0SfSHfJNze1pzymyFXTTLxFHijCLarm49rEZ66x1PDn6UevdSIs1c+XalQvVQfLWOy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HdZns7tR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HdZns7tR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E21C1F000FF;
	Mon, 21 Sep 2026 14:49:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002160;
	bh=t7sVvZ0TpR9jG7Z6PhTPLhhY4EWJmZkPJ/dFrOpNRfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdZns7tReCovmHsXVFD0CwBYCulv7+HG4ka6oZYWJ8kj6CqlQcNkjR0nDk82rlhve
	 f/a0B57WTKwdXlOAriV0QCKNZ/FFLLLyhvt3Kuu4C23Q1XEadXBHFCeSsQFVtrQjsS
	 HKWwYcRjC5Vg1EuEAGD0vvxNwOuubN8KeP9oyU+2BNE5O+/LKxKJF2orKg7Z0tB3A8
	 iPx16UnvXUpcO31eD4eMzo9preD6/uaQqef3DwhNu3y++KqMYHK/nv93CUjcfhJ1KW
	 Ot1Z0BTcMqt1vWP+CAtR06TdGl0x9DMMryLn4zt+HEJvReHDbPDJfGwOlEtlvvxpht
	 oapMlkvCwpPYg==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	christian.koenig@amd.com,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v7 02/13] mm: Add an allocator for CoCo shared memory
Date: Mon, 21 Sep 2026 20:18:36 +0530
Message-ID: <20260921144847.501151-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260921144847.501151-1-aneesh.kumar@kernel.org>
References: <20260921144847.501151-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Confidential-computing guests may require memory shared with the host to
be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
users need struct page-backed allocations satisfying these requirements.
Provide a common allocator instead of requiring each user to open-code
this sequence.

Add alloc_cc_shared_pages() and its node-aware variant. The allocator
rounds the requested size to the architecture's shared granule,
allocates suitably aligned contiguous pages and transitions the
complete range to shared state. It also preserves the caller's GFP
policy.

A private-to-shared transition may alter memory contents. Mask
__GFP_ZERO from the underlying allocation and when requested, clear the
complete transitioned range after cc_make_shared() succeeds.

Return the page and transitioned size so free_cc_shared_pages() can
restore the complete range to private state before freeing it. If
private state cannot be established, retain the allocation instead of
returning a possibly shared page to the buddy allocator.

Also provide the shared-granule geometry and byte-oriented transition
helpers used by the allocator and by callers managing their own backing
memory.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/cc_shared.h |  39 +++++++++
 mm/Makefile               |   1 +
 mm/cc_shared.c            | 172 ++++++++++++++++++++++++++++++++++++++
 3 files changed, 212 insertions(+)
 create mode 100644 include/linux/cc_shared.h
 create mode 100644 mm/cc_shared.c

diff --git a/include/linux/cc_shared.h b/include/linux/cc_shared.h
new file mode 100644
index 000000000000..5f8db7c468c5
--- /dev/null
+++ b/include/linux/cc_shared.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CC_SHARED_H
+#define _LINUX_CC_SHARED_H
+
+#include <linux/gfp_types.h>
+#include <linux/types.h>
+
+struct page;
+
+struct cc_shared_pages {
+	struct page *page;
+	size_t shared_size;
+};
+
+struct cc_shared_layout {
+	size_t requested_size;
+	size_t shared_size;
+	size_t alignment;
+};
+
+/*
+ * Architectures may override this to return the granule used for transitions
+ * between private and shared memory. The value must be a power of two and no
+ * smaller than PAGE_SIZE.
+ */
+size_t arch_cc_shared_granule_size(void);
+
+size_t cc_shared_granule_size(void);
+int cc_shared_calc_layout(size_t requested, struct cc_shared_layout *layout);
+bool cc_shared_range_valid(phys_addr_t base, size_t size);
+int cc_make_shared(void *addr, size_t size);
+int cc_make_private(void *addr, size_t size);
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem);
+int alloc_cc_shared_pages(gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem);
+void free_cc_shared_pages(struct cc_shared_pages *mem);
+
+#endif /* _LINUX_CC_SHARED_H */
diff --git a/mm/Makefile b/mm/Makefile
index e7245cb88c66..6e6544428422 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -56,6 +56,7 @@ obj-y			:= filemap.o mempool.o oom_kill.o fadvise.o \
 			   compaction.o show_mem.o \
 			   interval_tree.o list_lru.o workingset.o \
 			   debug.o gup.o mmap_lock.o vma_init.o $(mmu-y)
+obj-y			+= cc_shared.o
 
 # Give 'page_alloc' its own module-parameter namespace
 page-alloc-y := page_alloc.o
diff --git a/mm/cc_shared.c b/mm/cc_shared.c
new file mode 100644
index 000000000000..3e33681218f1
--- /dev/null
+++ b/mm/cc_shared.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2026 ARM Ltd.
+ */
+#include <linux/align.h>
+#include <linux/cc_shared.h>
+#include <linux/errno.h>
+#include <linux/export.h>
+#include <linux/gfp.h>
+#include <linux/log2.h>
+#include <linux/mm.h>
+#include <linux/mem_encrypt.h>
+#include <linux/numa.h>
+#include <linux/overflow.h>
+#include <linux/set_memory.h>
+
+size_t __weak arch_cc_shared_granule_size(void)
+{
+	return PAGE_SIZE;
+}
+
+size_t cc_shared_granule_size(void)
+{
+	size_t granule = arch_cc_shared_granule_size();
+
+	if (WARN_ON_ONCE(granule < PAGE_SIZE || !is_power_of_2(granule)))
+		return PAGE_SIZE;
+
+	return granule;
+}
+EXPORT_SYMBOL_GPL(cc_shared_granule_size);
+
+int cc_shared_calc_layout(size_t requested, struct cc_shared_layout *layout)
+{
+	size_t granule, rounded;
+
+	if (!requested || !layout)
+		return -EINVAL;
+
+	granule = cc_shared_granule_size();
+	if (check_add_overflow(requested, granule - 1, &rounded))
+		return -EOVERFLOW;
+
+	rounded = ALIGN_DOWN(rounded, granule);
+	layout->requested_size = requested;
+	layout->shared_size = rounded;
+	layout->alignment = granule;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(cc_shared_calc_layout);
+
+bool cc_shared_range_valid(phys_addr_t base, size_t size)
+{
+	size_t granule = cc_shared_granule_size();
+
+	if (!size)
+		return false;
+
+	return IS_ALIGNED(base, granule) && IS_ALIGNED(size, granule);
+}
+EXPORT_SYMBOL_GPL(cc_shared_range_valid);
+
+static int cc_validate_transition(void *addr, size_t size)
+{
+	phys_addr_t phys;
+
+	if (!addr || !size || !PAGE_ALIGNED(addr) ||
+	    !virt_addr_valid(addr))
+		return -EINVAL;
+
+	phys = page_to_phys(virt_to_page(addr));
+	if (!cc_shared_range_valid(phys, size))
+		return -EINVAL;
+
+	return 0;
+}
+
+int cc_make_shared(void *addr, size_t size)
+{
+	int ret = cc_validate_transition(addr, size);
+
+	if (ret)
+		return ret;
+
+	return set_memory_decrypted((unsigned long)addr, size >> PAGE_SHIFT);
+}
+
+int cc_make_private(void *addr, size_t size)
+{
+	int ret = cc_validate_transition(addr, size);
+
+	if (ret)
+		return ret;
+
+	return set_memory_encrypted((unsigned long)addr, size >> PAGE_SHIFT);
+}
+
+int alloc_cc_shared_pages_node(int nid, gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem)
+{
+	struct cc_shared_layout layout;
+	struct page *page;
+	unsigned int order;
+	bool zero = gfp & __GFP_ZERO;
+	int ret;
+
+	if (!mem)
+		return -EINVAL;
+
+	ret = cc_shared_calc_layout(requested, &layout);
+	if (ret)
+		return ret;
+
+	order = get_order(layout.shared_size);
+	if (order > MAX_PAGE_ORDER)
+		return -EINVAL;
+
+	/*
+	 * State transitions require a linear-map address and may modify memory.
+	 * Allocate from low memory and defer requested zeroing until afterwards.
+	 */
+	gfp &= ~(__GFP_HIGHMEM | __GFP_ZERO);
+	if (nid == NUMA_NO_NODE)
+		page = alloc_pages(gfp, order);
+	else
+		page = alloc_pages_node(nid, gfp, order);
+	if (!page)
+		return -ENOMEM;
+
+	ret = cc_make_shared(page_address(page), layout.shared_size);
+	if (ret) {
+		if (!cc_make_private(page_address(page), layout.shared_size))
+			__free_pages(page, order);
+		else
+			pr_warn_ratelimited("leaking %zu bytes with uncertain shared state\n",
+					    layout.shared_size);
+		return ret;
+	}
+
+	if (zero)
+		memset(page_address(page), 0, layout.shared_size);
+
+	mem->page = page;
+	mem->shared_size = layout.shared_size;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(alloc_cc_shared_pages_node);
+
+int alloc_cc_shared_pages(gfp_t gfp,
+		size_t requested, struct cc_shared_pages *mem)
+{
+	return alloc_cc_shared_pages_node(NUMA_NO_NODE, gfp, requested, mem);
+}
+EXPORT_SYMBOL_GPL(alloc_cc_shared_pages);
+
+void free_cc_shared_pages(struct cc_shared_pages *mem)
+{
+	if (!mem || !mem->page)
+		return;
+
+	if (cc_make_private(page_address(mem->page), mem->shared_size)) {
+		pr_warn_ratelimited("leaking %zu bytes that cannot be made private\n",
+				    mem->shared_size);
+		return;
+	}
+
+	__free_pages(mem->page, get_order(mem->shared_size));
+	mem->page = NULL;
+	mem->shared_size = 0;
+}
+EXPORT_SYMBOL_GPL(free_cc_shared_pages);
-- 
2.43.0

