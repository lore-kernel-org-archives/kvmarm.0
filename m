Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 891983C0623;
	Mon,  6 Jul 2026 06:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317913; cv=none; b=o7tKqvCUCNtnKpMukJkEdWLuRK6+Bz6ok74aVV7W78w26JzcL2+8TnVDb2fHD88KsKVy2Jk8hPyGrQFqCv78bZu1XrpH9ZxyiRYYvugV7HiFm3y1eKTHGGIUp8f9YOQ0GneVDO//Tc5V1yUzf9sZzvFsWJaTySY4dD4yYqqu4FY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317913; c=relaxed/simple;
	bh=/qkHPYnVfz/t1AnGGJVoBJOAsr3PdmgR3F3Lktgx544=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbTw3Vx4pYrWvtyFDto8q+PDfnyeowy3lkOioH/ZX/y/T9iEnzAWgkedRyyXMuLRcQGM1ziiNnDQWc88es0ZvTH6LtA2lmuWTLUdHH2kdbOoeFCxAuWJd2yBczFvBrIcYAs8lE7QPl9/J/wJ2jG5XQmuLknSKMQWYewc2V5Pgmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ASzXjcVF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ASzXjcVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D621F00A3A;
	Mon,  6 Jul 2026 06:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317908;
	bh=ofp0MrdUzNa7XupP7o8c8i/wr02mLs0ptrPxTOVDMXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ASzXjcVF+pgwQE+oJgM1a463oGMTAFYuZXkS5CKr7QamRJ7pAauCrPKFSDYDZKNPC
	 10REZauexCApsQYbFDA2KidvoQou01I1kj2YPOxypgmQ/MBB/fmj+u+IFQvopJ86pb
	 uJQAGnFuXpZ9o0qUKADknVsWFbpTbFN8ciC7JlX87RNz2oSw4Kpb9DQZFKUO3V0gat
	 0QrtrxDYu0oFyBan+HmvB6zy9+oiF5x8C27DV7szwXUqfdJSjRJfHVhdyy85/ysHDE
	 tGN+ay5ql5ol2lWgBhoZc3DcAl/aDYXssjB7Sk2f5KaMECreanCJWbabW+XMesB93/
	 E5MVMYHtr7J7Q==
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
Subject: [PATCH v5 03/10] dma-mapping: Pass allocation attrs to contiguous allocation helpers
Date: Mon,  6 Jul 2026 11:34:25 +0530
Message-ID: <20260706060432.1375570-4-aneesh.kumar@kernel.org>
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

Prepare for handling CoCo shared allocation requirements in the common
contiguous allocation path by passing DMA allocation attributes down to the
helpers that may allocate from CMA.

The next patch uses this to apply shared-granule alignment only to
allocations that are actually creating CoCo shared backing pages.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/iommu/dma-iommu.c   |  2 +-
 include/linux/dma-map-ops.h |  5 +++--
 kernel/dma/contiguous.c     |  4 +++-
 kernel/dma/direct.c         | 11 ++++++-----
 kernel/dma/ops_helpers.c    |  3 ++-
 5 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/dma-iommu.c b/drivers/iommu/dma-iommu.c
index fe387829ee92..da4aa4373842 100644
--- a/drivers/iommu/dma-iommu.c
+++ b/drivers/iommu/dma-iommu.c
@@ -1627,7 +1627,7 @@ static void *iommu_dma_alloc_pages(struct device *dev, size_t size,
 	struct page *page = NULL;
 	void *cpu_addr;
 
-	page = dma_alloc_contiguous(dev, alloc_size, gfp);
+	page = dma_alloc_contiguous(dev, alloc_size, gfp, attrs);
 	if (!page)
 		page = alloc_pages_node(node, gfp, get_order(alloc_size));
 	if (!page)
diff --git a/include/linux/dma-map-ops.h b/include/linux/dma-map-ops.h
index 8fae2b7deb20..1849f352fb88 100644
--- a/include/linux/dma-map-ops.h
+++ b/include/linux/dma-map-ops.h
@@ -102,7 +102,8 @@ struct page *dma_alloc_from_contiguous(struct device *dev, size_t count,
 				       unsigned int order, bool no_warn);
 bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 				 int count);
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp);
+struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp,
+		unsigned long attrs);
 void dma_free_contiguous(struct device *dev, struct page *page, size_t size);
 
 void dma_contiguous_early_fixup(phys_addr_t base, unsigned long size);
@@ -136,7 +137,7 @@ static inline bool dma_release_from_contiguous(struct device *dev,
 }
 /* Use fallback alloc() and free() when CONFIG_DMA_CMA=n */
 static inline struct page *dma_alloc_contiguous(struct device *dev, size_t size,
-		gfp_t gfp)
+		gfp_t gfp, unsigned long attrs)
 {
 	return NULL;
 }
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index f754079a287d..6c8a61ab5456 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -400,6 +400,7 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * @dev:   Pointer to device for which the allocation is performed.
  * @size:  Requested allocation size.
  * @gfp:   Allocation flags.
+ * @attrs: DMA attributes.
  *
  * tries to use device specific contiguous memory area if available, or it
  * tries to use per-numa cma, if the allocation fails, it will fallback to
@@ -410,7 +411,8 @@ static struct page *cma_alloc_aligned(struct cma *cma, size_t size, gfp_t gfp)
  * there is no need to waste CMA pages for that kind; it also helps reduce
  * fragmentations.
  */
-struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
+struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp,
+		unsigned long attrs)
 {
 #ifdef CONFIG_DMA_NUMA_CMA
 	int nid = dev_to_node(dev);
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 9575d68571bf..80f9f7d23ad4 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -113,7 +113,7 @@ static struct page *dma_direct_alloc_swiotlb(struct device *dev, size_t size,
 }
 
 static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
-		gfp_t gfp, bool allow_highmem)
+		gfp_t gfp, bool allow_highmem, unsigned long attrs)
 {
 	int node = dev_to_node(dev);
 	struct page *page;
@@ -122,7 +122,7 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
 	WARN_ON_ONCE(!PAGE_ALIGNED(size));
 
 	gfp |= dma_direct_optimal_gfp_mask(dev, &phys_limit);
-	page = dma_alloc_contiguous(dev, size, gfp);
+	page = dma_alloc_contiguous(dev, size, gfp, attrs);
 	if (page) {
 		if (dma_coherent_ok(dev, page_to_phys(page), size) &&
 		    (allow_highmem || !PageHighMem(page)))
@@ -182,7 +182,7 @@ static void *dma_direct_alloc_no_mapping(struct device *dev, size_t size,
 {
 	struct page *page;
 
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true, 0);
 	if (!page)
 		return NULL;
 
@@ -281,7 +281,8 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 	}
 
 	/* we always manually zero the memory once we are done */
-	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, allow_highmem);
+	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO,
+					allow_highmem, attrs);
 	if (!page)
 		return NULL;
 
@@ -447,7 +448,7 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
-	page = __dma_direct_alloc_pages(dev, size, gfp, false);
+	page = __dma_direct_alloc_pages(dev, size, gfp, false, attrs);
 	if (!page)
 		return NULL;
 
diff --git a/kernel/dma/ops_helpers.c b/kernel/dma/ops_helpers.c
index 20caf9cabf69..d67a5c838291 100644
--- a/kernel/dma/ops_helpers.c
+++ b/kernel/dma/ops_helpers.c
@@ -66,7 +66,8 @@ struct page *dma_common_alloc_pages(struct device *dev, size_t size,
 	struct page *page;
 	phys_addr_t phys;
 
-	page = dma_alloc_contiguous(dev, size, gfp);
+	/* __DMA_ATTR_ALLOC_CC_SHARED is not yet supported here, attrs = 0 */
+	page = dma_alloc_contiguous(dev, size, gfp, 0);
 	if (!page)
 		page = alloc_pages_node(dev_to_node(dev), gfp, get_order(size));
 	if (!page)
-- 
2.43.0

