Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F5D27E;
	Mon,  9 Mar 2026 10:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773052039; cv=none; b=FIsRAqyuumxClAdjvuGVR+KmingD7ohLiaQitjJZcoaTvzCqWFTmg9IVrwFw3kpq6SU0kjeEihPR+4Aooen6WH5pdGWZIxovPeTOVIC6AGIV3WagdDkqKTdf6cNXSXFmNj74wJQA/LfDJ6+CDpd2zUVrBDQCugt39u+ItHRH1+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773052039; c=relaxed/simple;
	bh=hTZfptBC21AFwTpVViQ/DgWyW3LFFFEkT+PdY8C3uk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Px8Fk1TOyCXF6yfV1BkQKLDYpKN84UVq85vujp48Kg0bBixwVqTpVsocbYeTjZUkUBNxRrdcIDepKVsHlLh8bSWzOGEg/a4hLjID5aPBAZi8iLnZGvNzkIyyI/LT+KOu0k+CxuLFWN7xfHs3Atpvj9KrChYxIRIxsUfO/d9u8TI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uVrNl8fW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uVrNl8fW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F8EC2BCAF;
	Mon,  9 Mar 2026 10:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773052039;
	bh=hTZfptBC21AFwTpVViQ/DgWyW3LFFFEkT+PdY8C3uk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uVrNl8fWo3R8qf0vUBHAWoAee1w4XxCrTWdZMxb0SgsJSU5XFW9Y6DCJOABheYnoX
	 psOegVTtsgZRAL7Mz/UuoC46uoMHeBWexVQ8jmNVMA1nNau6o+dmwBsJYYVzXCY4rF
	 xXEni/HL66pxvJ8IzfoI+eYacgGrSbFGR/ATMA+3aYUJU6TPYT4G6M755fp4voXp7R
	 nhxatUnS6cNzYAQE9aHjXG4XSTM6MjzXZwattc4oq8vsPdSkTAqhj+ZGRgHAFZN2gL
	 czvurErujvqSI0p57O3duA1SADSaNwGqo1YZp6+X72l7hVJn1+OjRwuwnjJWU+CCcH
	 zHCs5teTxeRdQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v3 2/3] swiotlb: dma: its: Enforce host page-size alignment for shared buffers
Date: Mon,  9 Mar 2026 15:56:24 +0530
Message-ID: <20260309102625.2315725-3-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
References: <20260309102625.2315725-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

When running private-memory guests, the guest kernel must apply additional
constraints when allocating buffers that are shared with the hypervisor.

These shared buffers are also accessed by the host kernel and therefore
must be aligned to the host’s page size, and have a size that is a multiple
of the host page size.

On non-secure hosts, set_guest_memory_attributes() tracks memory at the
host PAGE_SIZE granularity. This creates a mismatch when the guest applies
attributes at 4K boundaries while the host uses 64K pages. In such cases,
set_guest_memory_attributes() call returns -EINVAL, preventing the
conversion of memory regions from private to shared.

Architectures such as Arm can tolerate realm physical address space
(protected memory) PFNs being mapped as shared memory, as incorrect
accesses are detected and reported as GPC faults. However, relying on this
mechanism is unsafe and can still lead to kernel crashes.

This is particularly likely when guest_memfd allocations are mmapped and
accessed from userspace. Once exposed to userspace, we cannot guarantee
that applications will only access the intended 4K shared region rather
than the full 64K page mapped into their address space. Such userspace
addresses may also be passed back into the kernel and accessed via the
linear map, resulting in a GPC fault and a kernel crash.

With CCA, although Stage-2 mappings managed by the RMM still operate at a
4K granularity, shared pages must nonetheless be aligned to the
host-managed page size and sized as whole host pages to avoid the issues
described above.

Introduce a new helper, mem_decrypt_align(), to allow callers to enforce
the required alignment and size constraints for shared buffers.

The architecture-specific implementation of mem_decrypt_align() will be
provided in a follow-up patch.

Note on restricted-dma-pool:
rmem_swiotlb_device_init() uses reserved-memory regions described by
firmware. Those regions are not changed in-kernel to satisfy host granule
alignment. This is intentional: we do not expect restricted-dma-pool
allocations to be used with CCA. If restricted-dma-pool is intended for CCA
shared use, firmware must provide base/size aligned to the host IPA-change
granule.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/mm/mem_encrypt.c      | 19 +++++++++++++++----
 drivers/irqchip/irq-gic-v3-its.c | 20 +++++++++++++-------
 include/linux/mem_encrypt.h      | 12 ++++++++++++
 kernel/dma/contiguous.c          | 10 ++++++++++
 kernel/dma/direct.c              | 16 ++++++++++++++--
 kernel/dma/pool.c                |  4 +++-
 kernel/dma/swiotlb.c             | 21 +++++++++++++--------
 7 files changed, 80 insertions(+), 22 deletions(-)

diff --git a/arch/arm64/mm/mem_encrypt.c b/arch/arm64/mm/mem_encrypt.c
index ee3c0ab04384..38c62c9e4e74 100644
--- a/arch/arm64/mm/mem_encrypt.c
+++ b/arch/arm64/mm/mem_encrypt.c
@@ -17,8 +17,7 @@
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/mm.h>
-
-#include <asm/mem_encrypt.h>
+#include <linux/mem_encrypt.h>
 
 static const struct arm64_mem_crypt_ops *crypt_ops;
 
@@ -33,18 +32,30 @@ int arm64_mem_crypt_ops_register(const struct arm64_mem_crypt_ops *ops)
 
 int set_memory_encrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops))
 		return 0;
 
+	if (WARN_ON(!IS_ALIGNED(addr, mem_decrypt_granule_size())))
+		return -EINVAL;
+
+	if (WARN_ON(!IS_ALIGNED(numpages << PAGE_SHIFT, mem_decrypt_granule_size())))
+		return -EINVAL;
+
 	return crypt_ops->encrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
-	if (likely(!crypt_ops) || WARN_ON(!PAGE_ALIGNED(addr)))
+	if (likely(!crypt_ops))
 		return 0;
 
+	if (WARN_ON(!IS_ALIGNED(addr, mem_decrypt_granule_size())))
+		return -EINVAL;
+
+	if (WARN_ON(!IS_ALIGNED(numpages << PAGE_SHIFT, mem_decrypt_granule_size())))
+		return -EINVAL;
+
 	return crypt_ops->decrypt(addr, numpages);
 }
 EXPORT_SYMBOL_GPL(set_memory_decrypted);
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 291d7668cc8d..239d7e3bc16f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -213,16 +213,17 @@ static gfp_t gfp_flags_quirk;
 static struct page *its_alloc_pages_node(int node, gfp_t gfp,
 					 unsigned int order)
 {
+	unsigned int new_order;
 	struct page *page;
 	int ret = 0;
 
-	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
-
+	new_order = get_order(mem_decrypt_align((PAGE_SIZE << order)));
+	page = alloc_pages_node(node, gfp | gfp_flags_quirk, new_order);
 	if (!page)
 		return NULL;
 
 	ret = set_memory_decrypted((unsigned long)page_address(page),
-				   1 << order);
+				   1 << new_order);
 	/*
 	 * If set_memory_decrypted() fails then we don't know what state the
 	 * page is in, so we can't free it. Instead we leak it.
@@ -241,13 +242,16 @@ static struct page *its_alloc_pages(gfp_t gfp, unsigned int order)
 
 static void its_free_pages(void *addr, unsigned int order)
 {
+	int new_order;
+
+	new_order = get_order(mem_decrypt_align((PAGE_SIZE << order)));
 	/*
 	 * If the memory cannot be encrypted again then we must leak the pages.
 	 * set_memory_encrypted() will already have WARNed.
 	 */
-	if (set_memory_encrypted((unsigned long)addr, 1 << order))
+	if (set_memory_encrypted((unsigned long)addr, 1 << new_order))
 		return;
-	free_pages((unsigned long)addr, order);
+	free_pages((unsigned long)addr, new_order);
 }
 
 static struct gen_pool *itt_pool;
@@ -268,11 +272,13 @@ static void *itt_alloc_pool(int node, int size)
 		if (addr)
 			break;
 
-		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
+		page = its_alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO,
+					    get_order(mem_decrypt_granule_size()));
 		if (!page)
 			break;
 
-		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
+		gen_pool_add(itt_pool, (unsigned long)page_address(page),
+			     mem_decrypt_granule_size(), node);
 	} while (!addr);
 
 	return (void *)addr;
diff --git a/include/linux/mem_encrypt.h b/include/linux/mem_encrypt.h
index 07584c5e36fb..6cf39845058e 100644
--- a/include/linux/mem_encrypt.h
+++ b/include/linux/mem_encrypt.h
@@ -54,6 +54,18 @@
 #define dma_addr_canonical(x)		(x)
 #endif
 
+#ifndef mem_decrypt_granule_size
+static inline size_t mem_decrypt_granule_size(void)
+{
+	return PAGE_SIZE;
+}
+#endif
+
+static inline size_t mem_decrypt_align(size_t size)
+{
+	return ALIGN(size, mem_decrypt_granule_size());
+}
+
 #endif	/* __ASSEMBLY__ */
 
 #endif	/* __MEM_ENCRYPT_H__ */
diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index c56004d314dc..2b7ff68be0c4 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -46,6 +46,7 @@
 #include <linux/dma-map-ops.h>
 #include <linux/cma.h>
 #include <linux/nospec.h>
+#include <linux/dma-direct.h>
 
 #ifdef CONFIG_CMA_SIZE_MBYTES
 #define CMA_SIZE_MBYTES CONFIG_CMA_SIZE_MBYTES
@@ -374,6 +375,15 @@ struct page *dma_alloc_contiguous(struct device *dev, size_t size, gfp_t gfp)
 #ifdef CONFIG_DMA_NUMA_CMA
 	int nid = dev_to_node(dev);
 #endif
+	/*
+	 * for untrusted device, we require the dma buffers to be aligned to
+	 * the mem_decrypt_align(PAGE_SIZE) so that we can set the memory
+	 * attributes correctly.
+	 */
+	if (force_dma_unencrypted(dev)) {
+		if (get_order(mem_decrypt_granule_size()) > CONFIG_CMA_ALIGNMENT)
+			return NULL;
+	}
 
 	/* CMA can be used only in the context which permits sleeping */
 	if (!gfpflags_allow_blocking(gfp))
diff --git a/kernel/dma/direct.c b/kernel/dma/direct.c
index c2a43e4ef902..34eccd047e9b 100644
--- a/kernel/dma/direct.c
+++ b/kernel/dma/direct.c
@@ -257,6 +257,9 @@ void *dma_direct_alloc(struct device *dev, size_t size,
 		return NULL;
 	}
 
+	if (force_dma_unencrypted(dev))
+		size = mem_decrypt_align(size);
+
 	/* we always manually zero the memory once we are done */
 	page = __dma_direct_alloc_pages(dev, size, gfp & ~__GFP_ZERO, true);
 	if (!page)
@@ -350,6 +353,9 @@ void dma_direct_free(struct device *dev, size_t size,
 	if (swiotlb_find_pool(dev, dma_to_phys(dev, dma_addr)))
 		mark_mem_encrypted = false;
 
+	if (mark_mem_encrypted && force_dma_unencrypted(dev))
+		size = mem_decrypt_align(size);
+
 	if (is_vmalloc_addr(cpu_addr)) {
 		vunmap(cpu_addr);
 	} else {
@@ -384,6 +390,9 @@ struct page *dma_direct_alloc_pages(struct device *dev, size_t size,
 		goto setup_page;
 	}
 
+	if (force_dma_unencrypted(dev))
+		size = mem_decrypt_align(size);
+
 	page = __dma_direct_alloc_pages(dev, size, gfp, false);
 	if (!page)
 		return NULL;
@@ -414,8 +423,11 @@ void dma_direct_free_pages(struct device *dev, size_t size,
 	if (swiotlb_find_pool(dev, page_to_phys(page)))
 		mark_mem_encrypted = false;
 
-	if (mark_mem_encrypted && dma_set_encrypted(dev, vaddr, size))
-		return;
+	if (mark_mem_encrypted && force_dma_unencrypted(dev)) {
+		size = mem_decrypt_align(size);
+		if (dma_set_encrypted(dev, vaddr, size))
+			return;
+	}
 	__dma_direct_free_pages(dev, page, size);
 }
 
diff --git a/kernel/dma/pool.c b/kernel/dma/pool.c
index 2b2fbb709242..b5f10ba3e855 100644
--- a/kernel/dma/pool.c
+++ b/kernel/dma/pool.c
@@ -83,7 +83,9 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 	struct page *page = NULL;
 	void *addr;
 	int ret = -ENOMEM;
+	unsigned int min_encrypt_order = get_order(mem_decrypt_granule_size());
 
+	pool_size = mem_decrypt_align(pool_size);
 	/* Cannot allocate larger than MAX_PAGE_ORDER */
 	order = min(get_order(pool_size), MAX_PAGE_ORDER);
 
@@ -94,7 +96,7 @@ static int atomic_pool_expand(struct gen_pool *pool, size_t pool_size,
 							 order, false);
 		if (!page)
 			page = alloc_pages(gfp | __GFP_NOWARN, order);
-	} while (!page && order-- > 0);
+	} while (!page && order-- > min_encrypt_order);
 	if (!page)
 		goto out;
 
diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
index d8e6f1d889d5..a9e6e4775ec6 100644
--- a/kernel/dma/swiotlb.c
+++ b/kernel/dma/swiotlb.c
@@ -260,7 +260,7 @@ void __init swiotlb_update_mem_attributes(void)
 
 	if (!mem->nslabs || mem->late_alloc)
 		return;
-	bytes = PAGE_ALIGN(mem->nslabs << IO_TLB_SHIFT);
+	bytes = mem_decrypt_align(mem->nslabs << IO_TLB_SHIFT);
 	set_memory_decrypted((unsigned long)mem->vaddr, bytes >> PAGE_SHIFT);
 }
 
@@ -317,8 +317,8 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 		unsigned int flags,
 		int (*remap)(void *tlb, unsigned long nslabs))
 {
-	size_t bytes = PAGE_ALIGN(nslabs << IO_TLB_SHIFT);
 	void *tlb;
+	size_t bytes = mem_decrypt_align(nslabs << IO_TLB_SHIFT);
 
 	/*
 	 * By default allocate the bounce buffer memory from low memory, but
@@ -326,9 +326,9 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	 * memory encryption.
 	 */
 	if (flags & SWIOTLB_ANY)
-		tlb = memblock_alloc(bytes, PAGE_SIZE);
+		tlb = memblock_alloc(bytes, mem_decrypt_granule_size());
 	else
-		tlb = memblock_alloc_low(bytes, PAGE_SIZE);
+		tlb = memblock_alloc_low(bytes, mem_decrypt_granule_size());
 
 	if (!tlb) {
 		pr_warn("%s: Failed to allocate %zu bytes tlb structure\n",
@@ -337,7 +337,7 @@ static void __init *swiotlb_memblock_alloc(unsigned long nslabs,
 	}
 
 	if (remap && remap(tlb, nslabs) < 0) {
-		memblock_free(tlb, PAGE_ALIGN(bytes));
+		memblock_free(tlb, bytes);
 		pr_warn("%s: Failed to remap %zu bytes\n", __func__, bytes);
 		return NULL;
 	}
@@ -459,7 +459,7 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		swiotlb_adjust_nareas(num_possible_cpus());
 
 retry:
-	order = get_order(nslabs << IO_TLB_SHIFT);
+	order = get_order(mem_decrypt_align(nslabs << IO_TLB_SHIFT));
 	nslabs = SLABS_PER_PAGE << order;
 
 	while ((SLABS_PER_PAGE << order) > IO_TLB_MIN_SLABS) {
@@ -468,6 +468,8 @@ int swiotlb_init_late(size_t size, gfp_t gfp_mask,
 		if (vstart)
 			break;
 		order--;
+		if (order < get_order(mem_decrypt_granule_size()))
+			break;
 		nslabs = SLABS_PER_PAGE << order;
 		retried = true;
 	}
@@ -535,7 +537,7 @@ void __init swiotlb_exit(void)
 
 	pr_info("tearing down default memory pool\n");
 	tbl_vaddr = (unsigned long)phys_to_virt(mem->start);
-	tbl_size = PAGE_ALIGN(mem->end - mem->start);
+	tbl_size = mem_decrypt_align(mem->end - mem->start);
 	slots_size = PAGE_ALIGN(array_size(sizeof(*mem->slots), mem->nslabs));
 
 	set_memory_encrypted(tbl_vaddr, tbl_size >> PAGE_SHIFT);
@@ -571,11 +573,13 @@ void __init swiotlb_exit(void)
  */
 static struct page *alloc_dma_pages(gfp_t gfp, size_t bytes, u64 phys_limit)
 {
-	unsigned int order = get_order(bytes);
+	unsigned int order;
 	struct page *page;
 	phys_addr_t paddr;
 	void *vaddr;
 
+	bytes = mem_decrypt_align(bytes);
+	order = get_order(bytes);
 	page = alloc_pages(gfp, order);
 	if (!page)
 		return NULL;
@@ -658,6 +662,7 @@ static void swiotlb_free_tlb(void *vaddr, size_t bytes)
 	    dma_free_from_pool(NULL, vaddr, bytes))
 		return;
 
+	bytes = mem_decrypt_align(bytes);
 	/* Intentional leak if pages cannot be encrypted again. */
 	if (!set_memory_encrypted((unsigned long)vaddr, PFN_UP(bytes)))
 		__free_pages(virt_to_page(vaddr), get_order(bytes));
-- 
2.43.0

