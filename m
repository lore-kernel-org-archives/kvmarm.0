Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686003BFE2F;
	Mon,  6 Jul 2026 06:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783317903; cv=none; b=tZLfbzLRwK6PUhtwsAZHvl9GoaPJenEMAcoSkUoRSw0ste7lrFO/l3YT9/b2X/RiRklz3OaY3+uN/Xi3SuVTCBc3g2dBIoHM4Xqw+rPpZ1TDmneICstBLcuUxATEwdPTaYDw38LwPOWO3XnnLGo0gvRsny19IM21tEuredmiinY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783317903; c=relaxed/simple;
	bh=B3jg+HehA7RFhOMhDP12l1kQSa9HFD7GULt6HYSsE7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ra0vgRYermtBOTIcq4GohE6G/bsdhd6mFybPPT3RPYUo4Vhx37YvIV8pc4kQBnc43rDFpJCsQlnjePAxa/0zxaYLbQ6aAIeoS3pAbHCcbyI2fzEkzTW5JzyHxKtHx7X7Rb2zbanfm/+XwTAQCsENDzrYojx+mcaf/BzDKyBuAUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AeQvRqng; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AeQvRqng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A2A1F000E9;
	Mon,  6 Jul 2026 06:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783317901;
	bh=r/6QCDeil0i4wpPLRy/lh5myzwbTMSRGajg6rLXjcnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AeQvRqngK209IZbTEJdvoEFXWzsasnIiz0BF4GHk03AcWpk81M2iDCjTl4avLbvD7
	 hAvYX22sB47e9A54rbl/U86iI6fuKU7lb6JnqE2f597IJ3VLp+bsp3eavf2VXQ0Iwh
	 8Bfaa+V1OEbvGg8y8TCPVnEA5t4n9LHIY5bFOX71vwTF74RLqlD/C2Gj5+pTZinGSQ
	 lgC2CALzEgO+JfsSFHHh7uWFiuk2jd16MZAPXlPa1ch/4hkq7bxNX+9dP2wLz45//P
	 aWQkggnoQKBqp1BVKpXaqviWku5PXU9EL9Vcr+wJcCCHlXecKym1SpLjJ0tJMkU2wA
	 RiFBu6r3vhuWQ==
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
Subject: [PATCH v5 02/10] irqchip/gic-v3-its: Align shared ITS allocations to the CoCo shared granule size
Date: Mon,  6 Jul 2026 11:34:24 +0530
Message-ID: <20260706060432.1375570-3-aneesh.kumar@kernel.org>
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

ITS tables allocated by the coco guest are shared with the hypervisor.
These allocations must satisfy the host shared-buffer granule size so that
the full converted range is safe for host access.

Allocate ITS pages using a size rounded up to the shared granule size and
use the same allocation order when encrypting, decrypting and freeing the
memory. Also grow the ITT cache in shared-granule sized chunks instead of
assuming PAGE_SIZE is sufficient.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index b57d81ad33a0..5d6d38aa0dae 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -213,16 +213,17 @@ static gfp_t gfp_flags_quirk;
 static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 					 unsigned int order)
 {
+	unsigned int alloc_order;
 	struct page *page;
 	int ret = 0;
 
-	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
-
+	alloc_order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
+	page = alloc_pages_node(node, gfp | gfp_flags_quirk, alloc_order);
 	if (!page)
 		return NULL;
 
 	ret = set_memory_decrypted((unsigned long)page_address(page),
-				   1 << order);
+				   1 << alloc_order);
 	/*
 	 * If set_memory_decrypted() fails then we don't know what state the
 	 * page is in, so we can't free it. Instead we leak it.
@@ -241,13 +242,16 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 
 static void its_free_pages(void *addr, unsigned int order)
 {
+	int alloc_order;
+
+	alloc_order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
 	/*
 	 * If the memory cannot be encrypted again then we must leak the pages.
 	 * set_memory_encrypted() will already have WARNed.
 	 */
-	if (set_memory_encrypted((unsigned long)addr, 1 << order))
+	if (set_memory_encrypted((unsigned long)addr, 1 << alloc_order))
 		return;
-	free_pages((unsigned long)addr, order);
+	free_pages((unsigned long)addr, alloc_order);
 }
 
 static struct gen_pool *itt_pool;
@@ -272,7 +276,8 @@ static void *itt_alloc_pool(int node, int size)
 		if (!page)
 			break;
 
-		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     mem_cc_align_to_shared_granule(PAGE_SIZE), node);
 	} while (!addr);
 
 	return (void *)addr;
-- 
2.43.0

