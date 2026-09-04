Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97A146EF61;
	Fri,  4 Sep 2026 10:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518132; cv=none; b=seLvhuOosOv9+v+tqX0M2/NiVrZOpXGpJUUSTCf0APv2sUx3PAKfVrYOKooUG7bLE5zSdnlbKYpFnAPiKC1Tdw6luqHucVVUzc+nUxE2CFbAhWYcyoAelJt34GZqqxz8bG4vvOCs87lUVjcd6jE5YfFsgwxnlxRD403Ye5ZJPU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518132; c=relaxed/simple;
	bh=hdresUF1d7ttnmA8Wb/CR7Xjkv0CEyBIqVKr8DLu4r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GhCBJlADB6mUgD/EkQKIA+TT70UXVX0VO66xZBuNrbNJc1WZ7rUXdnTNduFDaYfsqQcL/ZunaJNpkbV4D9K4lRgYYMqHud1cG6IDvl4Gk2yxX/TGkSGhFzeR5xY3NKiNd8HB6oLGXLVQ18vbINRTqihEE+oPyIUzFTzcF7GbUGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k02l9Yax; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k02l9Yax"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844A31F00A3E;
	Fri,  4 Sep 2026 10:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518130;
	bh=ESkIGke1iFE9Q6toiTpobF2/Kkn44Z+9eDYKIOwSHmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k02l9Yaxmnpzl9kswKAtm4zrmDePBloJ1RK0TJ3W3Sd/TsB0j0MVjfSi1BelD0tx7
	 82RWtQ9ttePRC7m4TAsTbJwjabh/oSX8Kmv70VA+82SwRr/Z0EZi5nP6eH6S/lgOu1
	 1Wob4A9K8xTMOaQkiSdliOZAV5nRCdgy+H6NsujCMY1ElEJ40wPe2kvjafAX0lIlft
	 fTre5+z/yfvGWx05PJHIUeHClTOkTC4YUrSDN5GSkbmrQVvr2ygEXR47cUyCEWuDDp
	 0voGyUvHa6pVctTPcwV/ccAqXxDsVjzZAK5x6+sYMSUQZ4+jnkhaAT+jr25AjceRrH
	 P0s6JOjoNShZw==
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
Subject: [PATCH v6 5/9] swiotlb: Align shared IO TLB pools to the shared granule size
Date: Fri,  4 Sep 2026 16:04:48 +0530
Message-ID: <20260904103452.1197239-6-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
References: <20260904103452.1197239-1-aneesh.kumar@kernel.org>
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
index ded7016a46a7..f8936b03d942 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -369,7 +369,8 @@ void __init swiotlb_update_mem_attributes(void)
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
+
+	bytes = mem_cc_align_to_shared_granule(mem->nslabs << IO_TLB_SHIFT);
 
 	if (io_tlb_default_mem.cc_shared) {
 		int ret;
@@ -436,8 +437,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = mem_cc_align_to_shared_granule(nslabs << IO_TLB_SHIFT);
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -445,9 +446,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
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
@@ -456,7 +457,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -578,7 +579,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(mem_cc_align_to_shared_granule(nslabs << IO_TLB_SHIFT));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -587,6 +588,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(mem_cc_shared_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -667,7 +670,7 @@ void __init swiotlb_exit(void)
 
 	pr_info("tearing down default memory pool\n");
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
-	tbl_size = PAGE_ALIGN(mem->end - mem->start);
+	tbl_size = mem_cc_align_to_shared_granule(mem->end - mem->start);
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
 
 	if (io_tlb_default_mem.cc_shared) {
@@ -711,12 +714,14 @@ void __init swiotlb_exit(void)
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
@@ -807,6 +812,7 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes, bool cc_shared)
 	    dma_free_from_pool(NULL, vaddr, bytes))
 		return;
 
+	bytes = mem_cc_align_to_shared_granule(bytes);
 	/* Intentional leak if pages cannot be encrypted again. */
 	if (!cc_shared ||
 	    !set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
-- 
2.43.0

