Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5165E4A99D6;
	Mon, 21 Sep 2026 14:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002245; cv=none; b=MDyyMeuLEmx6b4HOV1cssVyNdn1cLRnNrSGCb99wAc+QcnF3LPgkBzpkkv4Uw0+HNUV/bC5eIMuPd+wY5LcGA+3tWjNiW4R1kiJKHuxaEUZTRY8Oi7wLpSt0dsKOStdobV+HkNrn1x7rzCerFw2APGs0qdnK3aYdu1WGCfZgD7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002245; c=relaxed/simple;
	bh=drypGKbE/uJUN8VQPTwrS3YIr5N/QFKxqxtDqB4F6so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=se5/dckfIoJryU1CUoJq/7OP221c6JpFM306E7JPvxvAqN0M//ihD8adhVMi0QAbES+p+ymGUZxA3euLRVRJUwAocBka3D98xxp6dSuAfOg2ehEbzI4wVVr4z6nrGEJbW5dTjYiOLO51MT2rIi8rRLkK/RKnTwIB44t81Kkc3P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjUxmdmq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjUxmdmq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612241F00893;
	Mon, 21 Sep 2026 14:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002244;
	bh=siS6q1O96r8tBJzuPFNLC7opJrdAHxEvYaTkWIfgUUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjUxmdmq75evpjC4UkLaIYo0hP1XgCpj8SoLSF8Mj/tcBn6ZXbtjFhVAaKSTA07Pz
	 lcTzehyS2LIa8dVZJu0DH7jWgBEqhuXNdci/JIOQjepi2K6XsYv9W8nt+AQOrN2R5A
	 GwhI+wHs4GccO3WeI8bWmNcjtBIETFgcFnkfcJJEuwLLSycNBG1sqPgI3051Zr8kZ6
	 U97zOFM3SrsTI1AnQl5GJtgARF76druhEyK+73UdsBpZrzCA9fClz5xVqiCrtuMxzV
	 w1xa4hEs4oNB/M+V03LS2ikLG8NnJCu3G2/YsWbURiG3Y/RuHL5MIzUGNI/ccucgQc
	 T9CCrMe1mJY2w==
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
Subject: [RFC PATCH v7 11/13] dma-buf: system_heap: Limit scatterlist entries to the buffer size
Date: Mon, 21 Sep 2026 20:18:45 +0530
Message-ID: <20260921144847.501151-12-aneesh.kumar@kernel.org>
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

The system heap currently allocates each backing page no larger than the
remaining dma-buf length. It can therefore use the complete
compound-page size for every scatterlist entry while keeping the total
length equal to the buffer size.

Shared backing allocations may need to be rounded up to an architecture
shared granule size. A backing allocation can then be larger than the
remaining buffer length. Describing the complete allocation in the
scatterlist would incorrectly expose the rounded tail to scatterlist
consumers as part of the dma-buf.

Track the remaining buffer length while constructing the scatterlist and
limit each entry to the smaller of the compound-page size and the
remaining length. The complete backing allocation remains owned by the
heap and is still released normally.

This does not change behavior with the current allocation policy, but
prepares the heap for shared-granule-sized backing allocations.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/dma-buf/heaps/system_heap.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/dma-buf/heaps/system_heap.c b/drivers/dma-buf/heaps/system_heap.c
index c8959eadc71d..b5b8cdf65f23 100644
--- a/drivers/dma-buf/heaps/system_heap.c
+++ b/drivers/dma-buf/heaps/system_heap.c
@@ -406,6 +406,7 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 	struct system_heap_buffer *buffer;
 	DEFINE_DMA_BUF_EXPORT_INFO(exp_info);
 	unsigned long size_remaining = len;
+	unsigned long sg_remaining = len;
 	unsigned int max_order = orders[0];
 	struct system_heap_priv *priv = dma_heap_get_drvdata(heap);
 	bool cc_shared = priv->cc_shared;
@@ -454,7 +455,11 @@ static struct dma_buf *system_heap_allocate(struct dma_heap *heap,
 
 	sg = table->sgl;
 	list_for_each_entry_safe(page, tmp_page, &pages, lru) {
-		sg_set_page(sg, page, page_size(page), 0);
+		unsigned long sg_len;
+
+		sg_len = min_t(unsigned long, page_size(page), sg_remaining);
+		sg_set_page(sg, page, sg_len, 0);
+		sg_remaining -= sg_len;
 		sg = sg_next(sg);
 		list_del(&page->lru);
 	}
-- 
2.43.0

