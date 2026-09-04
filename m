Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AEF3AC0EE;
	Fri,  4 Sep 2026 10:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788518115; cv=none; b=seBRSl4dZ5srxOLnYkU5cirQ+sbx6fwYYjqaBPxd/PeWp1WifyqBzR/T43DgCWujK3uuwGDRFc8bOyVj6PF1Yqpba1SR3u4j/IMnGBlslubdy3DqaFe2A0KlStaV05ozfyYUxKVOvdJpAkhh9GcsKws3br9mP9zItLKt7DJSYU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788518115; c=relaxed/simple;
	bh=cS0g/nDD61NS45zqSS8FVqMvbKkUuuYzbwvshF2J/pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4xMn8Zifc30MEMwoIxFW6WWAJz3ZIZFNkDOEZhCQ/XwoGYSsSQPcuzOPnWCVGv55K0ec854K7GEvb8LV8a32O8MjdKFBLO+TaMgSQe3mFdiWdPvQM4HyY/vG6I/2qUIm+DzGJgw/qBqN+OfHC+hjrKaP/u23Q0z1cXqb30gGCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=erlD1+uD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="erlD1+uD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED601F00A3D;
	Fri,  4 Sep 2026 10:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788518113;
	bh=/zkAw0Mk8GkqlqvyS44GmVtI+30wAgQRZHaj1Ir4nIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=erlD1+uDMTvmkBHPQ5hx5RxALAbZgQ13+Sb+kS0mqKvW7e5jYGpWWh2xzNUnu5uQJ
	 ZSg4GPscYVOTRBVXtgSOMUOVhAXCNypcXz91wqLI6MFAljeyFJMMmQjY9Egjfglg/9
	 k18YENiUpf1s3FOlaeQIMHjByg4dWZuwV1IIejRmuf0Ci3I4oS3MxKB7jSNR/c/6uK
	 /utYsfZCevfUSnXx8MMabqlPwhTWfy0vzD4LW1mB+OiHQF+YCF0KpnVi7hUs3iLdj5
	 5jX39qFoUpal0uFMDTOyaYv4Q1U0DERYHFB/cfddGK0X7rl8ubamTFMUByU28RWSEx
	 pKFHjYeYUzPkA==
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
Subject: [PATCH v6 2/9] irqchip/gic-v3-its: Align shared ITS allocations to the CoCo shared granule size
Date: Fri,  4 Sep 2026 16:04:45 +0530
Message-ID: <20260904103452.1197239-3-aneesh.kumar@kernel.org>
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

ITS tables allocated by the coco guest are shared with the hypervisor.
These allocations must satisfy the host shared-buffer granule size so that
the full converted range is safe for host access.

Allocate ITS pages using a size rounded up to the shared granule size and
use the same allocation order when encrypting, decrypting and freeing the
memory. Also grow the ITT cache in shared-granule sized chunks instead of
assuming PAGE_SIZE is sufficient.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e9807af23537..98d8fccbf0f2 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -216,6 +216,7 @@ static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 	struct page *page;
 	int ret = 0;
 
+	order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
 	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
 
 	if (!page)
@@ -241,6 +242,8 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 
 static void its_free_pages(void *addr, unsigned int order)
 {
+
+	order = get_order(mem_cc_align_to_shared_granule(PAGE_SIZE << order));
 	/*
 	 * If the memory cannot be encrypted again then we must leak the pages.
 	 * set_memory_encrypted() will already have WARNed.
@@ -272,7 +275,8 @@ static void *itt_alloc_pool(int node, int size)
 		if (!page)
 			break;
 
-		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     mem_cc_align_to_shared_granule(PAGE_SIZE), node);
 	} while (!addr);
 
 	return (void *)addr;
-- 
2.43.0

