Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB243233E8;
	Mon, 21 Sep 2026 14:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002195; cv=none; b=LS5lhADNrJUTF6ykFo6watPlWfjOsWfx07w+JWRfLNRMOSsmTlalPDawKKeQIiu5qtcJ8q/y1muSvMw/GFv44gF4y872Wg6XTOh8yYI9P04eVb/x/cMg3+WptH7t9dnctVFDPaWxxkKkMkJ0I6AynLjNdv1Kn5eVM1FzqnvgssY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002195; c=relaxed/simple;
	bh=YGAvUXdHwA2bj2Y65/x62DxpbXFeL/Eml2oKLw6RTN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F6aWRrVS220HOsIR+t4GSo3JBHvGFSh0gCc5S5KFoaYzFhJGtKZjPtEer2ha7QWbrB8JozR1NseRx2pEUkm2g9wJXcIebbxCU6bEbIxpuWDEuq78hA0gZk4LbKPPvQ46cP3rut7/wU/FIezxeHMd4Dgpd5qmy++vd+mwS8Q9AtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YJdFcyfj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YJdFcyfj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D501F00899;
	Mon, 21 Sep 2026 14:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002194;
	bh=sX7dUzzV4Hpq5I4TQA062/lgzQvMj3dJFADJlWWRou0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YJdFcyfj9wySKBLUv88So2kWSKHUboALGjctLGYfvYsp8z/a/Kps7TgjPZbRm9goL
	 sgTjrs5YQHKrzXJ3k8841BLqoq9r7xbExhIpUjjgZoUXiX7fRtzSKUqnWNUwLTuGQ6
	 ChP1vDUy1+53pQyNL+ZUNR3aU7Vg4iIuLPUQp/QBlZHsiX0bT+slgQZkeVXT58WH8X
	 p7g1gM0r8ntvcDzvFPmBumXENBCN9mrW51ESwQ3rQRKXNrnGkFp8hbLrJJbxk2EP0m
	 c/TBrFVHAQtHmymlb7JxIR7fEjesCenC7H/EYsav5tet8A2khH5jjopMUVaiqO40kt
	 dPk0Kgwc25zVw==
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
Subject: [RFC PATCH v7 06/13] dma-contiguous: Accept an explicit minimum alignment
Date: Mon, 21 Sep 2026 20:18:40 +0530
Message-ID: <20260921144847.501151-7-aneesh.kumar@kernel.org>
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

Confidential-computing shared allocations need CMA backing allocations
to be aligned to the architecture private/shared state-change granule
size. Passing a DMA attribute into CMA would make a generic physical
allocator interpret DMA and confidential-computing policy that has
already been resolved by its caller.

Add an explicit minimum alignment order to dma_alloc_contiguous().
Preserve the existing size-derived alignment for ordinary callers by
passing zero, and reject a request that exceeds CONFIG_CMA_ALIGNMENT.
For supported requests, use the larger of the size-derived and requested
orders, capped by the configured CMA alignment as before.

Also distinguish preferred and required alignment for
dma_alloc_from_contiguous(). Existing callers pass zero as the required
alignment and retain the current clamping behavior. Callers that require
a minimum alignment can request it explicitly and receive NULL when CMA
cannot satisfy it.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm/mm/dma-mapping.c   |  5 +++--
 drivers/iommu/dma-iommu.c   |  2 +-
 include/linux/dma-map-ops.h | 10 ++++++----
 kernel/dma/contiguous.c     | 33 +++++++++++++++++++++++----------
 kernel/dma/direct.c         |  2 +-
 kernel/dma/ops_helpers.c    |  2 +-
 kernel/dma/pool.c           |  2 +-
 kernel/kexec_file.c         |  3 ++-
 8 files changed, 38 insertions(+), 21 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7761099dde9e..9714fcd51941 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -398,7 +398,8 @@ static void *__alloc_from_contiguous(struct device *dev, size_t size,
 	struct page *page;
 	void *ptr = NULL;
 
-	page = dma_alloc_from_contiguous(dev, count, order, gfp & __GFP_NOWARN);
+	page = dma_alloc_from_contiguous(dev, count, order, 0,
+					 gfp & __GFP_NOWARN);
 	if (!page)
 		return NULL;
 
@@ -866,7 +867,7 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
 		unsigned long order = get_order(size);
 		struct page *page;
 
-		page = dma_alloc_from_contiguous(dev, count, order,
+		page = dma_alloc_from_contiguous(dev, count, order, 0,
 						 gfp & __GFP_NOWARN);
 		if (!page)
 			goto error;
diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index 58c624513cd4..59baf2687612 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1627,7 +1627,7 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
 	struct page *page = NULL;
 	void *cpu_addr;
 
-	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	page = dma_alloc_contiguous(dev, alloc_size, gfp, 0);
 	if (!page)
 		page = alloc_pages_node(node, gfp, get_order(alloc_size));
 	if (!page)
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 8fae2b7deb20..5fccda7e5c69 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -99,10 +99,11 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
 		phys_addr_t limit, struct cma **res_cma, bool fixed);
 
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int order, bool no_warn);
+		unsigned int order, unsigned int required_order, bool no_warn);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
+struct page *dma_alloc_contiguous(struct device *dev, size_t size,
+		gfp_t gfp, unsigned int align_order);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
@@ -125,7 +126,8 @@ static inline int dma_contiguous_reserve_area(phys_addr_t size,
 	return -ENOSYS;
 }
 static inline struct page *dma_alloc_from_contiguous(struct device *dev,
-		size_t count, unsigned int order, bool no_warn)
+		size_t count, unsigned int order, unsigned int required_order,
+		bool no_warn)
 {
 	return NULL;
 }
@@ -136,7 +138,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
 }
 /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
 static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
-		gfp_t gfp)
+		gfp_t gfp, unsigned int align_order)
 {
 	return NULL;
 }
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 66093460584e..a3eb3299b817 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -357,19 +357,25 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
  * dma_alloc_from_contiguous() - allocate pages from contiguous area
  * @dev:   Pointer to device for which the allocation is performed.
  * @count: Requested number of pages.
- * @align: Requested alignment of pages (in PAGE_SIZE order).
+ * @align: Preferred alignment of pages (in PAGE_SIZE order).
+ * @required_align: Minimum required alignment (in PAGE_SIZE order).
  * @no_warn: Avoid printing message about failed allocation.
  *
  * This function allocates memory buffer for specified device. It uses
  * device specific contiguous memory area if available or the default
  * global one. Requires architecture specific dev_get_cma_area() helper
  * function.
+ *
+ * The preferred alignment is capped at CONFIG_CMA_ALIGNMENT. Return NULL
+ * if the required alignment exceeds this limit. A required alignment of
+ * zero preserves the preferred-alignment clamping behavior.
  */
 struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
-				       unsigned int align, bool no_warn)
+		unsigned int align, unsigned int required_align, bool no_warn)
 {
-	if (align > CONFIG_CMA_ALIGNMENT)
-		align = CONFIG_CMA_ALIGNMENT;
+	if (required_align > CONFIG_CMA_ALIGNMENT)
+		return NULL;
+	align = min(max(align, required_align), CONFIG_CMA_ALIGNMENT);
 
 	return cma_alloc(dev_get_cma_area(dev), count, align, no_warn);
 }
@@ -390,9 +396,14 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 	return cma_release(dev_get_cma_area(dev), pages, count);
 }
 
-static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
+static struct page *cma_alloc_aligned(struct cma *cma, size_t size,
+	   gfp_t gfp, unsigned int align_order)
 {
-	unsigned int align = min(get_order(size), CONFIG_CMA_ALIGNMENT);
+	unsigned int align;
+
+	if (align_order > CONFIG_CMA_ALIGNMENT)
+		return NULL;
+	align = min(max(get_order(size), align_order), CONFIG_CMA_ALIGNMENT);
 
 	return cma_alloc(cma, size >> PAGE_SHIFT, align, gfp & __GFP_NOWARN);
 }
@@ -402,6 +413,7 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * @dev:   Pointer to device for which the allocation is performed.
  * @size:  Requested allocation size.
  * @gfp:   Allocation flags.
+ * @align_order: Minimum alignment as a power-of-two page order.
  *
  * tries to use device specific contiguous memory area if available, or it
  * tries to use per-numa cma, if the allocation fails, it will fallback to
@@ -412,7 +424,8 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * there is no need to waste CMA pages for that kind; it also helps reduce
  * fragmentations.
  */
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
+struct page *dma_alloc_contiguous(struct device *dev, size_t size,
+	   gfp_t gfp, unsigned int align_order)
 {
 #ifdef CONFIG_DMA_NUMA_CMA
 	int nid = dev_to_node(dev);
@@ -422,7 +435,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 	if (!gfpflags_allow_blocking(gfp))
 		return NULL;
 	if (dev->cma_area)
-		return cma_alloc_aligned(dev->cma_area, size, gfp);
+		return cma_alloc_aligned(dev->cma_area, size, gfp, align_order);
 	if (size <= PAGE_SIZE)
 		return NULL;
 
@@ -431,7 +444,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 		struct cma *cma = dma_contiguous_numa_area[nid];
 		struct page *page;
 		if (cma) {
-			page = cma_alloc_aligned(cma, size, gfp);
+			page = cma_alloc_aligned(cma, size, gfp, align_order);
 			if (page)
 				return page;
 		}
@@ -440,7 +453,7 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 	if (!dma_contiguous_default_area)
 		return NULL;
 
-	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp);
+	return cma_alloc_aligned(dma_contiguous_default_area, size, gfp, align_order);
 }
 
 /**
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index da665ca22d5c..d968a0c81e73 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -124,7 +124,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp, 0);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 6b5f9208d31c..8320cc0fada5 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -66,7 +66,7 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	phys_addr_t phys;
 
-	page = dma_alloc_contiguous(dev, size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp, 0);
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), gfp, get_order(size));
 	if (!page)
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 00f422a1e896..70b7f64b17ab 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -99,7 +99,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 		pool_size = 1 << (PAGE_SHIFT + order);
 		if (cma_in_zone(gfp))
 			page = dma_alloc_from_contiguous(NULL, 1 << order,
-							 order, false);
+							 order, 0, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
 	} while (!page && order-- > 0);
diff --git a/kernel/kexec_file.c b/kernel/kexec_file.c
index 59fb9d71e9d8..2a337ce7264e 100644
--- a/kernel/kexec_file.c
+++ b/kernel/kexec_file.c
@@ -682,7 +682,8 @@ static int kexec_alloc_contig(struct kexec_buf *kbuf)
 	if (kbuf->image->type == KEXEC_TYPE_CRASH)
 		return -EPERM;
 
-	p = dma_alloc_from_contiguous(NULL, nr_pages, get_order(kbuf->buf_align), true);
+	p = dma_alloc_from_contiguous(NULL, nr_pages,
+				      get_order(kbuf->buf_align), 0, true);
 	if (!p)
 		return -ENOMEM;
 
-- 
2.43.0

