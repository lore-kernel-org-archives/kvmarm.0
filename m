Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380282C181;
	Mon,  6 Jul 2026 06:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317924; cv=none; b=MDmkxIdsY8TbcAnBSFph4CB3UIW2yGlC6aSdkylLw1CzhgRft1sNEWQ0wGRae4crI6h2X/qfEwnpN68QAfTitr/lMkACX4H6vFs1gkJ+rNctGA2tR71+sgakL3Qf6iwse4hzLj+xERYgMKuNjhglgloV18xFYjuXjOmUrsb/8WQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317924; c=relaxed/simple;
	bh=5Fh/HF+sh6aJFodEmfl0wYTeQLetdm7629n3hJL8VIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nq+p3kBiJY1HxJPXszaRcwrrQMvTcjaEV5/kZHINEg0JZ0pr+8RHiWg6JilLJ6xxaYGfoddBuRlgICPjqs1F/m5MtmCxQ7Q6RMBqseHqfGY0jNePWeeaTkEk1P8gBnbZ1SlcqWMpDm63azSS6JxP7uu8Z7whaK8BIhEfaePtUyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L8JG8hBs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L8JG8hBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055D61F00A3A;
	Mon,  6 Jul 2026 06:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317923;
	bh=e2V3VqU4Wtz37YK1GAfo+NDcDqEETC18sWhhjPNJ4SU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L8JG8hBsi7TeebOUuOSZlVgb8uOzreNkz4Lu8dOGqF6RK+IsodD4hcPNs3XwR8r30
	 8+9AbGoKFF16IhQX6xvaIQ6WDdgF+08nRLe+YFpiGh82047xona2TEvgDy8SwEyNYY
	 h60+QAnm28YIAtDPwj7dXKZkCoZkWIigteci+qjDqqYIlHmjnxMqmcb9r3+AntLSxw
	 GzLIMudvqM5YBG80WnBD/aV4um2euTd6qc69SPNLeux04yUQ4BJAfTr0IMxGxFZJIS
	 lkXPTeSe9H89xpQ3IQ3RhLxjTw6hh1bKxY2QEctLOoKQy+KMjRnjwf8+BdEUaLQOwH
	 jbSZYDPBul29Q==
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
Subject: [PATCH v5 05/10] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Mon,  6 Jul 2026 11:34:27 +0530
Message-ID: <20260706060432.1375570-6-aneesh.kumar@kernel.org>
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

swiotlb pools used by confidential-computing guests are shared with the
host and therefore must be converted at the host shared-granule size. A
PAGE_SIZE-sized or PAGE_SIZE-aligned pool is not sufficient when the host
tracks shared state at a larger granularity.

Round swiotlb pool sizes to mem_cc_shared_granule_size(), allocate the
pools at that alignment, and use the same aligned size when decrypting,
encrypting and freeing pool memory. Apply the same rule to dynamically
allocated swiotlb pools.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 897aba538c5b..1d77746b6f31 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -287,7 +287,8 @@ void __init swiotlb_update_mem_attributes(void)
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
+
+	bytes = mem_cc_align_to_shared_granule(mem->nslabs << IO_TLB_SHIFT);
 
 	if (io_tlb_default_mem.cc_shared) {
 		int ret;
@@ -354,8 +355,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = mem_cc_align_to_shared_granule(nslabs << IO_TLB_SHIFT);
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -363,9 +364,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	 * memory encryption.
 	 */
 	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
+		tlb = memblock_alloc(bytes, mem_cc_shared_granule_size());
 	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+		tlb = memblock_alloc_low(bytes, mem_cc_shared_granule_size());
 
 	if (!tlb) {
 		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
@@ -374,7 +375,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -496,7 +497,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(mem_cc_align_to_shared_granule(nslabs << IO_TLB_SHIFT));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -505,6 +506,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(mem_cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -585,7 +588,7 @@ void __init swiotlb_exit(void)
 
 	pr_info("tearing down default memory pool\n");
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
-	tbl_size = PAGE_ALIGN(mem->end - mem->start);
+	tbl_size = mem_cc_align_to_shared_granule(mem->end - mem->start);
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
 
 	if (io_tlb_default_mem.cc_shared) {
@@ -629,12 +632,14 @@ void __init swiotlb_exit(void)
 static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes,
 		u64 phys_limit, unsigned long attrs)
 {
-	unsigned int order = get_order(bytes);
 	bool cc_shared = attrs & __DMA_ATTR_ALLOC_CC_SHARED;
+	unsigned int order;
 	struct page *page;
 	phys_addr_t paddr;
 	void *vaddr;
 
+	bytes = mem_cc_align_to_shared_granule(bytes);
+	order = get_order(bytes);
 	page = alloc_pages(gfp, order);
 	if (!page)
 		return NULL;
@@ -725,6 +730,7 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
 	    dma_free_from_pool(NULL, vaddr, bytes))
 		return;
 
+	bytes = mem_cc_align_to_shared_granule(bytes);
 	/* Intentional leak if pages cannot be encrypted again. */
 	if (!cc_shared ||
 	    !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
-- 
2.43.0

