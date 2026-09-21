Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21BA4A9D49;
	Mon, 21 Sep 2026 14:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790002235; cv=none; b=hWVo3p7F7QnTjBEZyRUDy6pWdZWF8iV2BDzDv/hR39eiSxevWHBjzbvxG6jNp/f0kQf9nBbjePUGsYsvMY2SSqU9XaWJXHx5NEaHrHVMDWVnpBp4S6XAjwKsbQSX5Ko4HjRokEvxhKdYhKQcTbqd94LNqGB3yNW8c3dz0LkMY4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790002235; c=relaxed/simple;
	bh=vGksCyHyAkFbUYd9dsUIKEBHw/XWRfLaAVMwPBqAwMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un5E4Bb7RzsNzbwOC0obPc8xLGmsMrj27+K06oQXieb2rRCoIMjc4Pq8JU+20tJiVW0HUiYsuCOOaIF5YoQR8qA9XyuNT90zMhfdCgs4VTPEUV4lrCAQJ7kg1QaW8+zvte9zgbaAhZLp36ibtpt468BjWKB8I759JDqDTEZIWbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Psocjzb6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Psocjzb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 441611F00898;
	Mon, 21 Sep 2026 14:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790002234;
	bh=HsGwfxBcGa2X8eifj86iWN6Y5mB+a2kx/vCpPCjEWWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Psocjzb6bowHSDioUIF9/6tvJDU4QGBRjJjxTFtyWDQk/oft1o4Ri+wYY8Q5qVirE
	 kqBOewXMKNfLKWyfWfmRQDs0BAbqll4f1bcCNdAzPNx7tU7gy+7rGsnC5ILEr6UEo5
	 v1g7rqi1Aht05l0fIpjnwsguZWG6xUS2U2gJWyL4ZxAKLzo/36bVRfUZ9Qfj9OpRRJ
	 MF3cO+ivHMYiYkd+66D0ig61BpdP0tNcsvHZSeuG7LX5q9xooHfyg4toVn00kxehkp
	 8qZq9va6WawQxeeOKd61ivw0oVChTUbrGK15k3D2Ndt7EX//ZubzVxK/gi6rxepOn1
	 6SredcbkRgL/w==
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
Subject: [RFC PATCH v7 10/13] swiotlb: Reject misaligned restricted DMA pools for CoCo guests
Date: Mon, 21 Sep 2026 20:18:44 +0530
Message-ID: <20260921144847.501151-11-aneesh.kumar@kernel.org>
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

A restricted DMA pool is a firmware-described ownership boundary. Unlike
a pool allocated by SWIOTLB itself, its base cannot be moved and its
size cannot be rounded without claiming memory outside the reserved
region.

Confidential-computing guests may require private/shared state changes
to cover units larger than PAGE_SIZE. Passing a misaligned restricted
region to set_memory_decrypted() can therefore fail.

Validate both the physical base and the complete reserved size with the
common CoCo shared-range helper before allocating SWIOTLB metadata or
performing a state transition. Perform the transition through
cc_make_shared().

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 kernel/dma/swiotlb.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index 9928d75efc2d..cb67105b8812 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -2010,6 +2010,14 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 		return -EINVAL;
 	}
 
+	if (cc_platform_has(CC_ATTR_MEM_ENCRYPT) &&
+	    !cc_shared_range_valid(rmem->base, rmem->size)) {
+		dev_err(dev,
+			"Restricted DMA pool must be aligned to %#zx bytes for memory encryption\n",
+			cc_shared_granule_size());
+		return -EINVAL;
+	}
+
 	/*
 	 * Since multiple devices can share the same pool, the private data,
 	 * io_tlb_mem struct, will be initialized by the first device attached
@@ -2043,8 +2051,7 @@ static int rmem_swiotlb_device_init(struct reserved_mem *rmem,
 			int ret;
 
 			mem->cc_shared = true;
-			ret = set_memory_decrypted((unsigned long)phys_to_virt(rmem->base),
-						   rmem->size >> PAGE_SHIFT);
+			ret = cc_make_shared(phys_to_virt(rmem->base), rmem->size);
 			if (ret) {
 				dev_err(dev, "Failed to decrypt restricted DMA pool\n");
 				kfree(pool->areas);
-- 
2.43.0

