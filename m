Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EC93BFE3C;
	Mon,  6 Jul 2026 06:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317939; cv=none; b=tJDLZWQ0Bfp+ZU2/LFyoPeBSl8WFzt+w6fY+UpxOS433BXxJjQ+DrcLol2qljKNyEEnfdSEsubs4nerdU+EHgXoxa61QXH/+67Y9BJfCVlK/aCPw3AYoZtI1wulllcJeF72e9ettc+UmUkUTlgnG3PBpyWYezm/h37U7dVkfUFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317939; c=relaxed/simple;
	bh=6Emig9//T2dSJ2I19kbsWa5yXWNMzvoSSFCcG6vna6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kx7jioJVTMXdp5QYS7bwOAjiRjYaEbwVa33dkyc3CLIbLhtmBZPFpGzEZKcy98OyHY4yyCTl6YP7a6cP6w1x+nfb4gDRoCCBj2y2jiVM3cnBU3Iv1/UB8JTnmTSRxGxagfeYQn7N4IJpqcOUAOu3emFA3x6VS0OQlhdQoE1D4f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgVB/Zmy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgVB/Zmy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D851C1F00A3A;
	Mon,  6 Jul 2026 06:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317937;
	bh=SRAlXDC5oqmsaoNnYadnzJXzxvCqL4owp1KVT95a8j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RgVB/Zmypcck62R5YgLImy6Oj1gZRgAEeXjBj/gKMiPfIOY6j9s/98FSqsVFJbmSQ
	 aZn6wrKVYBrWDyVoausJoTqSGqheZbDd7dOooqRMaBtNq9Dbf5u9p9ltFJZ7uYM5xa
	 v7GnRcBSSAYSTVc5YJ7Y31ZCsKJCytnqVo5U6hcINLcno6iich7TluhQz/8xIy9E7S
	 9ehmgxB+pqapzYiIOohuZNZxqv1UXbLIUWB4tS2VS7RIkR2VTc74BDL5TiVTLnlUSX
	 PC4iKfv6yBtW47OtPQr9fFWE7QfoEPP0kielTDEvGapndbSMMOaqx+DvvWdyomQFXa
	 KpOOIsjYEEeIQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v5 07/10] dma-buf: system_heap: Enforce shared-granule alignment for cc-shared buffers
Date: Mon,  6 Jul 2026 11:34:29 +0530
Message-ID: <20260706060432.1375570-8-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
References: <20260706060432.1375570-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The system heap can allocate buffers that are decrypted and shared with the
host. For confidential-computing guests, those shared buffers must cover
whole shared-buffer granule; otherwise a userspace mmap of the dma-buf may
expose only part of a host-managed granule and allow unintended access to
adjacent private memory.

Require cc-shared system-heap allocations to have a size aligned to
mem_cc_shared_granule_size(), and allocate pages at least as large as the
required granule. Keep the allocation bounded by the existing heap orders,
but fall back to an exact minimum-order allocation when the required
granule is not one of the preferred heap orders.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 50 +++++++++++++++++++++++------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..9cbfcebe2088 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -55,7 +55,6 @@ struct dma_heap_attachment {
 #define HIGH_ORDER_GFP  (((GFP_HIGHUSER | __GFP_ZERO | __GFP_NOWARN \
 				| __GFP_NORETRY) & ~__GFP_RECLAIM) \
 				| __GFP_COMP)
-static gfp_t order_flags[] = {HIGH_ORDER_GFP, HIGH_ORDER_GFP, LOW_ORDER_GFP};
 /*
  * The selection of the orders used for allocation (1MB, 64K, 4K) is designed
  * to match with the sizes often found in IOMMUs. Using order 4 pages instead
@@ -375,26 +374,44 @@ static const struct dma_buf_ops system_heap_buf_ops = {
 	.release = system_heap_dma_buf_release,
 };
 
+static struct page *system_heap_alloc_order(unsigned int order)
+{
+	gfp_t flags = order ? HIGH_ORDER_GFP : LOW_ORDER_GFP;
+
+	if (mem_accounting)
+		flags |= __GFP_ACCOUNT;
+
+	return alloc_pages(flags, order);
+}
+
 static struct page *alloc_largest_available(unsigned long size,
-					    unsigned int max_order)
+					    unsigned int max_order,
+					    unsigned int min_order)
 {
 	struct page *page;
 	int i;
-	gfp_t flags;
 
 	for (i = 0; i < NUM_ORDERS; i++) {
 		if (size <  (PAGE_SIZE << orders[i]))
 			continue;
-		if (max_order < orders[i])
+
+		if (max_order < orders[i] || orders[i] < min_order)
 			continue;
-		flags = order_flags[i];
-		if (mem_accounting)
-			flags |= __GFP_ACCOUNT;
-		page = alloc_pages(flags, orders[i]);
+
+		page = system_heap_alloc_order(orders[i]);
 		if (!page)
 			continue;
 		return page;
 	}
+	/*
+	 * The required minimum order might not be one of the preferred heap
+	 * orders. Allocate exactly min_order when it does not exceed the
+	 * remaining size.
+	 */
+	if (min_order && min_order <= max_order &&
+	    size >= (PAGE_SIZE << min_order))
+		return system_heap_alloc_order(min_order);
+
 	return NULL;
 }
 
@@ -409,6 +426,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	unsigned int max_order = orders[0];
 	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
 	bool cc_shared = priv->cc_shared;
+	unsigned int min_order = 0;
+	size_t cc_granule_size;
 	struct dma_buf *dmabuf;
 	struct sg_table *table;
 	struct scatterlist *sg;
@@ -425,6 +444,18 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	buffer->heap = heap;
 	buffer->len = len;
 	buffer->cc_shared = cc_shared;
+	if (cc_shared_buffer(buffer)) {
+		cc_granule_size = mem_cc_shared_granule_size();
+		if (!IS_ALIGNED(len, cc_granule_size)) {
+			ret = -EINVAL;
+			goto free_buffer;
+		}
+		min_order = get_order(cc_granule_size);
+		if (min_order > max_order) {
+			ret = -EINVAL;
+			goto free_buffer;
+		}
+	}
 
 	INIT_LIST_HEAD(&pages);
 	i = 0;
@@ -438,7 +469,8 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 			goto free_buffer;
 		}
 
-		page = alloc_largest_available(size_remaining, max_order);
+		page = alloc_largest_available(size_remaining, max_order,
+					       min_order);
 		if (!page)
 			goto free_buffer;
 
-- 
2.43.0

