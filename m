Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813FA3C10A2;
	Mon,  6 Jul 2026 06:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317920; cv=none; b=IzF6PXEhANA7/IWO8d309e5Fw/Wr0Q94kN2gLRke7LCP8Wl4oTcYTeieEJ6axpeZeoh6FPNcU9LJ2FW5uBbk1VQlmAoQVuoKb6JhCBLeGnd++YOZBI1Eex0uHIt2dCWAHvp68RY+/8J1D71oD2RpIALMQ7Ih6WT5j8vLSaJmk6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317920; c=relaxed/simple;
	bh=vRGeLz9uTygkok0d/nLp9chMqt1hZRjTlGkBos2rc6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LxVZAemDc0Q+Lu/fysyG47CSAnMnZRi8KU+eQ0UpCIcLGAu1Huv34flHMSKBLQ/QtRnT8Slp62i51WC8RkgpZZk0R0MkLEw8qobvwa2LavaIPuTh9hqRiVp/yvZxueIC1ABpdL7tO7ZNk5z5gOdEgMcp/U63+fwNAouK+QP63SQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AGq5LAK2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AGq5LAK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8507A1F000E9;
	Mon,  6 Jul 2026 06:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317916;
	bh=z+bPfSuQARImroV5BkbmoGryt8x5TsbegRK/YB3WTqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AGq5LAK2N1saAxqSz5Vt6bmFurZ7JFxzV/U+nWXFTylLAZiE1DEl4C5XD2g20oK+Y
	 2fsdg49V3jrpAIg2uqIzleiq2C0QdbPUTERFuk3kOGLxJ7XVYXV4WsWpc55feBywC9
	 iSSs2HM6CjCTu+aS+sH02WI7p/465mZKkhW3ImZSp2CHz1TW0ROAAYyWoOEKZh+u0o
	 EM5EgjeLAcByJT3tWVvTDwMgo5atfQ79cmG5huP7rMPaEOkTDe8ro2PZDGwdIl94rX
	 K4aiQDkyVCDr0/9UtK+9MbEPTUfzkqwkDjUvDDkmL3qSSwI1y8oOEK2d/9NcQMLcq4
	 CgpWH8GynLScw==
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
Subject: [PATCH v5 04/10] dma-direct: Align CoCo shared DMA allocations to the shared granule size
Date: Mon,  6 Jul 2026 11:34:26 +0530
Message-ID: <20260706060432.1375570-5-aneesh.kumar@kernel.org>
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

DMA allocations that create shared backing pages for confidential-computing
guests are converted between private and shared memory before being used
for DMA. On some architecture, the conversion granule may be larger than
PAGE_SIZE, so converting only the requested size can leave the rest of the
host-managed granule private.

Use the internal __DMA_ATTR_ALLOC_CC_SHARED allocation attribute to
identify those allocations in the DMA allocation paths. Round the allocated
and converted size up to mem_cc_shared_granule_size(), and use the same
aligned size when restoring encryption on free.

Also reject CMA allocations for CoCo shared backing pages when CMA cannot
provide alignment at the required shared granule size, and keep atomic DMA
pool expansion from falling below the order needed for shared-buffer
conversions.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/contiguous.c |  9 +++++++++
 kernel/dma/direct.c     | 16 ++++++++++++++--
 kernel/dma/pool.c       |  4 +++-
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 6c8a61ab5456..3d0eac2e2a20 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -45,6 +45,7 @@
 #include <linux/dma-map-ops.h>
 #include <linux/cma.h>
 #include <linux/nospec.h>
+#include <linux/mem_encrypt.h>
 
 #ifdef CONFIG_CMA_SIZE_MBYTES
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
@@ -417,6 +418,14 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp,
 #ifdef CONFIG_DMA_NUMA_CMA
 	int nid = dev_to_node(dev);
 #endif
+	/*
+	 * CoCo shared allocations require CMA alignment large enough for the
+	 * architecture's shared-buffer granule.
+	 */
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED) {
+		if (get_order(mem_cc_shared_granule_size()) > CONFIG_CMA_ALIGNMENT)
+			return NULL;
+	}
 
 	/* CMA can be used only in the context which permits sleeping */
 	if (!gfpflags_allow_blocking(gfp))
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 80f9f7d23ad4..6d0e485fdc34 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -280,6 +280,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return NULL;
 	}
 
+	if (mark_mem_decrypt)
+		size = mem_cc_align_to_shared_granule(size);
+
 	/* we always manually zero the memory once we are done */
 	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO,
 					allow_highmem, attrs);
@@ -402,6 +405,9 @@ void dma_direct_free(struct device *dev, size_t size,
 		/* Swiotlb doesn't need a page attribute update on free */
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted && force_dma_unencrypted(dev))
+		size = mem_cc_align_to_shared_granule(size);
+
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
 	} else {
@@ -448,6 +454,9 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
+	if (attrs & __DMA_ATTR_ALLOC_CC_SHARED)
+		size = mem_cc_align_to_shared_granule(size);
+
 	page = __dma_direct_alloc_pages(dev, size, gfp, false, attrs);
 	if (!page)
 		return NULL;
@@ -488,8 +497,11 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	if (swiotlb_pool)
 		mark_mem_encrypted = false;
 
-	if (mark_mem_encrypted && dma_set_encrypted(dev, vaddr, size))
-		return;
+	if (mark_mem_encrypted) {
+		size = mem_cc_align_to_shared_granule(size);
+		if (dma_set_encrypted(dev, vaddr, size))
+			return;
+	}
 
 	if (swiotlb_pool)
 		swiotlb_free_from_pool(dev, phys, swiotlb_pool);
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 5115a3e8c722..d02b630e80fc 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -90,7 +90,9 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 	bool leak_pages = false;
 	void *addr;
 	int ret = -ENOMEM;
+	unsigned int min_encrypt_order = get_order(mem_cc_shared_granule_size());
 
+	pool_size = mem_cc_align_to_shared_granule(pool_size);
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -101,7 +103,7 @@ static int atomic_pool_expand(struct dma_gen_pool *dma_pool, size_t pool_size,
 							 order, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
-	} while (!page && order-- > 0);
+	} while (!page && order-- > min_encrypt_order);
 	if (!page)
 		goto out;
 
-- 
2.43.0

