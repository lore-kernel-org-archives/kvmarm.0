Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130246F4BB;
	Mon, 21 Sep 2026 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002177; cv=none; b=j8I+8hWa6Xruw55caZdGN7gNhZskiHsohH+7ivaia2U90WapNrGHANmBihrKeqBH0lw8ImZbU+w2mT1OjfpAFXpcYLVw3s0u8iD5LGS2WCmvCnQJaDwHAh+fQnsoMRCjAcoSuJO/aR2JwDaSr18xI/w6CUXETpV6QlnlBoK2RK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002177; c=relaxed/simple;
	bh=53V69p39PUi4l6s3POXdnLWsBJZpvCWbAlqdcc7UTzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RSq/DjgjqucGCt3gr/5H6bf2VQfU3yVz6M4Mdm4uqJy+EGp1f3Jc+MxxlR2kdpxSW65rM9Cry5PUOc+FZlccjPQINLt9oFydGkgpE157EgZ30DmiD+CanpQXMTbd3mhRIuWl8iclLxvFF+JefUKYGvFVTcl1k8XwdjwdSTsoe70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1qRWRjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1qRWRjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69DCA1F000FF;
	Mon, 21 Sep 2026 14:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002176;
	bh=NUhVS/70oe+xVDq7uGuyK6On8HV25TTU2SaXV4Mxt0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1qRWRjl1RV2uS6/gMaLuJ2pewyPR4lUHdxCKfj6tWJ7rGg/GojHBKVpQxQjMXmS7
	 lY/S//7gau/68XfSGzMXBxaEMlB4ozHdEDhscfQu8EZpTtDlYz4eNXG2JKnXNuWtAu
	 BesJL1+xMU8cIT7oCt0WaP8iyHhp83v3hmLLmamhE4RaEwCPOItgvTeld9nqcMfBzd
	 fg42y/fS6NwDQZ9GpZazOkEimF6PsA6coMmQZM1qB6Wvq/kXB7yjuyaV4YKO3pKgR5
	 P/F300kBVcQYxP0VTJLVWehPnUpnJzr/xmVPpj5xMqxWRog4njX/mK/wons75YlO+s
	 PhP5XTRddPZlw==
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
Subject: [RFC PATCH v7 04/13] irqchip/gic-v3-its: Resolve the default NUMA node explicitly
Date: Mon, 21 Sep 2026 20:18:38 +0530
Message-ID: <20260921144847.501151-5-aneesh.kumar@kernel.org>
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

alloc_pages_node() resolves NUMA_NO_NODE to numa_mem_id() internally. In
preparation for switching ITS allocations to the CoCo shared memory
allocator, resolve the default node explicitly in its_alloc_pages().

The CoCo shared memory allocator interprets NUMA_NO_NODE as a request to
apply the current task's memory policy. Passing numa_mem_id() instead
preserves the existing nearest-memory-node placement across the
allocator switch. This patch does not change the current allocation
behavior.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index e9807af23537..ac5507acb1a0 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -32,6 +32,7 @@
 #include <linux/set_memory.h>
 #include <linux/slab.h>
 #include <linux/syscore_ops.h>
+#include <linux/topology.h>
 
 #include <linux/irqchip.h>
 #include <linux/irqchip/arm-gic-v3.h>
@@ -236,7 +237,7 @@ static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 
 static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 {
-	return its_alloc_pages_node(NUMA_NO_NODE, gfp, order);
+	return its_alloc_pages_node(numa_mem_id(), gfp, order);
 }
 
 static void its_free_pages(void *addr, unsigned int order)
-- 
2.43.0

