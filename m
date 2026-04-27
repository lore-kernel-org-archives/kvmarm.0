Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B59439B975;
	Mon, 27 Apr 2026 08:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278547; cv=none; b=EYX15qVTlbw8x7kktojSUE+W1jYz85YGnCwrY81OTmXFyTCIGy/HwmQC/0bXmE1GP/f3zOwwC9QqEA2PWC01098WI+PvB0KpZLhnJT9v5l7PE/7rPt68SGnQ92fR+fCqwn3/09yZluUSp7Daw/IU2KDCr8YNqjdBXveN/QlyZXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278547; c=relaxed/simple;
	bh=5SU9hiceDEieVMjK83mZntxO9wZ9JXg8R4Ezb9ZyoxM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mLNz9RafgSL2B0zQ7i7Yk5IO2io23LW+/gWjFH66GsdzLV6S3+ATkL1i8SVRncNHfWCod0VJjYD691ne33KsSdyTahfG0QLSv/fCi2/yLNxkYglFNtfcVKkQXEDPSmBlQ7Tm5zrZ4HnDskf9vKVOgI/XnczZvYY3lNr3igiZGTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkSZ/ppe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkSZ/ppe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37188C2BCB4;
	Mon, 27 Apr 2026 08:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278546;
	bh=5SU9hiceDEieVMjK83mZntxO9wZ9JXg8R4Ezb9ZyoxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkSZ/ppesy61ker3Jkwkk5hTM+fFQXy4GJV7E2cfaeCXf21wVzfeHmS3kvwg/mxGM
	 FD+ER02Sl8HpdWe7jAD2H6ooHDXq9EfAX3wUp8ZbdnN4nYAPfeDaKbD1u13v1bRKfc
	 HRdDs7j5FB3er+3KMKTPrgXAZvoH9wZgi22oz/i4H+PBuWZmG1N38Pgnq8GGzXnWKE
	 dyQEqUSXoTTr3wdydX/C06qwbVKvvzhRg+wdstXy/FFLIcrV/Gq2v+4Ps6erU1bJr6
	 hjpywogzfZ2A0AyMbjFBXRw4QTD56jG0LoF0P9fwxEX6nMPPI45OFQxmlejN7xWBRe
	 9l0tjqhIKljCw==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 10/11] coco: arm64: dma: Update force_dma_unencrypted for accepted devices
Date: Mon, 27 Apr 2026 13:58:04 +0530
Message-ID: <20260427082805.931832-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427082805.931832-1-aneesh.kumar@kernel.org>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This change updates the DMA behavior for accepted devices by assuming
they access only private memory. Currently, the DMA API does not provide
a mechanism for allocating shared memory that can be accessed by both
the secure realm and the non-secure host. Accepted devices are therefore
expected to operate entirely within the private memory space.

If future use cases require accepted devices to interact with shared
memory— for example, for host-device communication, we will need to
extend the DMA interface to support such allocation semantics. This
commit lays the groundwork for that by clearly defining the current
assumption and isolating the enforcement to force_dma_unencrypted.

Treat swiotlb and decrypted DMA pools as shared-memory paths and avoid them
for accepted devices by:
- returning false from is_swiotlb_for_alloc() for accepted devices
- returning false from is_swiotlb_active() for accepted devices
- bypassing dma-direct atomic pool usage for accepted devices

This is based on the current assumption that accepted devices operate on private
Realm memory only, and prevents accidental fallback to shared/decrypted DMA
backends.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/mem_encrypt.h |  6 +-----
 arch/arm64/mm/mem_encrypt.c          | 10 ++++++++++
 include/linux/swiotlb.h              |  3 +++
 kernel/dma/direct.c                  |  8 ++++++++
 kernel/dma/swiotlb.c                 |  3 +++
 5 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/mem_encrypt.h b/arch/arm64/include/asm/mem_encrypt.h
index 5541911eb028..ae0b0cac0900 100644
--- a/arch/arm64/include/asm/mem_encrypt.h
+++ b/arch/arm64/include/asm/mem_encrypt.h
@@ -15,17 +15,13 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops);
 
 int set_memory_encrypted(unsigned long addr, int numpages);
 int set_memory_decrypted(unsigned long addr, int numpages);
+bool force_dma_unencrypted(struct device *dev);
 
 #define mem_decrypt_granule_size mem_decrypt_granule_size
 size_t mem_decrypt_granule_size(void);
 
 int realm_register_memory_enc_ops(void);
 
-static inline bool force_dma_unencrypted(struct device *dev)
-{
-	return is_realm_world();
-}
-
 /*
  * For Arm CCA guests, canonical addresses are "encrypted", so no changes
  * required for dma_addr_encrypted().
diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index f5d64bc29c20..18dea5d879b8 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -18,6 +18,7 @@
 #include <linux/err.h>
 #include <linux/mm.h>
 #include <linux/mem_encrypt.h>
+#include <linux/device.h>
 
 static const struct arm64_mem_crypt_ops *crypt_ops;
 
@@ -67,3 +68,12 @@ size_t mem_decrypt_granule_size(void)
 	return PAGE_SIZE;
 }
 EXPORT_SYMBOL_GPL(mem_decrypt_granule_size);
+
+bool force_dma_unencrypted(struct device *dev)
+{
+	if (device_cc_accepted(dev))
+		return false;
+
+	return is_realm_world();
+}
+EXPORT_SYMBOL_GPL(force_dma_unencrypted);
diff --git a/include/linux/swiotlb.h b/include/linux/swiotlb.h
index 0efb9b8e5dd0..224dcec6a58f 100644
--- a/include/linux/swiotlb.h
+++ b/include/linux/swiotlb.h
@@ -296,6 +296,9 @@ bool swiotlb_free(struct device *dev, struct page *page, size_t size);
 
 static inline bool is_swiotlb_for_alloc(struct device *dev)
 {
+	if (device_cc_accepted(dev))
+		return false;
+
 	return dev->dma_io_tlb_mem->for_alloc;
 }
 #else
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index 34eccd047e9b..a7a9984db342 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -158,6 +158,14 @@ static struct page *__dma_direct_alloc_pages(struct device *dev, size_t size,
  */
 static bool dma_direct_use_pool(struct device *dev, gfp_t gfp)
 {
+	/*
+	 * Atomic pools are marked decrypted and are used if we require
+	 * updation of pfn mem encryption attributes or for DMA non-coherent
+	 * device allocation. Both is not true for trusted device.
+	 */
+	if (device_cc_accepted(dev))
+		return false;
+
 	return !gfpflags_allow_blocking(gfp) && !is_swiotlb_for_alloc(dev);
 }
 
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index c94abc2dcae3..f0d4b9f799bf 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1651,6 +1651,9 @@ bool is_swiotlb_active(struct device *dev)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 
+	if (device_cc_accepted(dev))
+		return false;
+
 	return mem && mem->nslabs;
 }
 
-- 
2.43.0

