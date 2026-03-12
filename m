Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E82EA154;
	Thu, 12 Mar 2026 08:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302754; cv=none; b=KGUbrTCxxFUf4wHF9QFcQ+mBQnJdV7Iwpx0UNL4joj9crHCWCsgvkdd2E1kEZy4ZuWZoU57MH/Ofo5Rv2gXBK8b5PZbY5uKj7cD5U6rE39AHlmsFW8EFn3LusIzaW3hrGjpQScEMZDQ3rDcZZDWE+Xsbz9gAA33bVJh7xyDqW5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302754; c=relaxed/simple;
	bh=0csSeUlZauiC2yr1plM5karIEhjfC8fi+r1dZY3rwSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VEsgSY1ovies3wTcWW2aXx4n/hQOAcPpKRQuJPaOghGwf8gjJy3elcz/ZdpL7Zfi1cpM+o8m6dCH+Mglnz3/nR302q1lpgB45XYHw9qySu1/lv8rqUUMxSyy0tDqFflNZWiyAXl4sCLG+zfkc/7jgiLlmn0iHJTDhh+xnIp2JVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JqlfWZu6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JqlfWZu6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52AA6C116C6;
	Thu, 12 Mar 2026 08:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302753;
	bh=0csSeUlZauiC2yr1plM5karIEhjfC8fi+r1dZY3rwSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JqlfWZu6rAXAO6dOU+A7Udf1owiqizRBdGd5Fxek3Tg01XikVLdTgHoaqxvctiRhw
	 1UHWSTIz7/tPg+ALJjvzgN7v3hRQX++h4R6CW6ZHnyH5UQ0l36AOhghni3/EOQde4+
	 dQoqDARtwAZBcPBn4jG2Thfq+m/FnJH7Xh6gAXlMHeSXo4DMR1Gki/oWw8uW+VNqcm
	 nEOyKZybp+2hmv2MBHymY9aRpDn19IJTft1b6fNR1l37IyFMfJfDi17FL9dqw2hGdq
	 zymbPb8uYf+MW1qrYU3Xyfs2xrtbns5mLGRCW8ajZAPFZ6cdRXiJ9J7pV5EZcRAgNi
	 9eGoXOQbyyGOQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 10/11] coco: arm64: dma: Update force_dma_unencrypted for accepted devices
Date: Thu, 12 Mar 2026 13:34:41 +0530
Message-ID: <20260312080442.3485633-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
References: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
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

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
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
index 309a8b398a7d..339147d1d42f 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -1634,6 +1634,9 @@ bool is_swiotlb_active(struct device *dev)
 {
 	struct io_tlb_mem *mem = dev->dma_io_tlb_mem;
 
+	if (device_cc_accepted(dev))
+		return false;
+
 	return mem && mem->nslabs;
 }
 
-- 
2.43.0

