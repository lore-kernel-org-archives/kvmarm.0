Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86EBE346A11
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640351; cv=none; b=ev7/U/j6RVtd3dQmpG/c+muaDuaztPnovS9SHPH680mKsR+gfn3mbzEnyQJUtZHoe+e1vvTzXW/F6leQWmolcJ0Z41kZ1u0a5Iehdr4ohxlrAKnXgGnUAanwo9L1d4USIJXaiBEDExM/FBW/FBm0voN4fKLJxiJ9zY9MEp5bDFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640351; c=relaxed/simple;
	bh=f1zhYYpnAEfMBFW4F8zFMkjpoIuuoFRXw/JRH6L83UM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=k7WNgNsuyUs0jD9xzr5EmX/9f5oAmPMoz7KuW9j2shN2OAQ6IJ/WwyZTLLjOlhpB9B8yJXYvNL5ILtrv17iVgSQElYKNB/1q/slcu0LJ3Eleup1BQLclI8f+jcZ0uyZqusev8EIq7r4ex9yYcC0arj9lFC0Zp/A/OwHCqV7BwaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YbM+VUxi; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YbM+VUxi"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0b14daso21688655e9.2
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640348; x=1756245148; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3pO2YE+QLHcZDr5ERfg64RTVx9rRsQJCpks4Jpbfd5g=;
        b=YbM+VUxiSEOd/SIIsAwkE4gTGP0lx+m0AS3+NstyTeyBk63gOJwDvMOoqbqW2sjGl9
         ZNFYrP4aCewlxOS38plrV0CCsz5SuBTI+iFhnXafmVjZsVYe7YA52s+nlatobxXskO8S
         T6VXt6O7/CGnaAVG8Q7YVD0PyVw67AFJxkF06ITsLzajorfZMw27uGWI6jHEHT3/suzK
         kZOAZBT/U3LFSUrnCj9KgLiR+IRVhMvI+QM7jbJ1HSFI61wZpGZ/H459Bwot31gadGHT
         SaZ6BWuOYsanL9SInpt8UJJb3M9tXaib0PNb2JGLMCETDK2ha4vwJEKOD7tuI2GdjDNK
         dwuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640348; x=1756245148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3pO2YE+QLHcZDr5ERfg64RTVx9rRsQJCpks4Jpbfd5g=;
        b=YuQfm2uNZ0VrPTYK5AIRXJpDkbcGLxyETLvB1nNtxremsE4YCwvniLBbgEXtETc3lU
         Cfz2OiLmW/YKC02FIMWWvg+NWE3uSiMWr9NbFBGf67lIvPB+UwfVeIgAUZXodEKt1CDg
         bLzwS5Dqm2LxYEgf59oL2QmvEA668SG+f4HHX9jxR7y8xTByccYqXbEDwqhNtdQurfWU
         yP+yfhPHiI2QFayXh/ogrzZ0aMj+8tuv88XM1PD4JraVMo6Ub55xYDRtoHCNOylQUdy6
         FTGnOpQIV7SapfeAZsx61RbtCIAUpxW2t87LzM3n2TD2QPurCV1GPvKq6pxxQp6TBj68
         pAGg==
X-Forwarded-Encrypted: i=1; AJvYcCUgroDmD4jetF/P+L/3nk381L+fOujpXxj1Evu9wa7edJscgQFAjj9rPtksn10c5R+XOmfG6lo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yze1lHKyLz/8zGlF8kRCFwHprytV90uI/zNfp5M30iWpuE0TQ5+
	xD6/ttm1IVBxAdplmjA+Ft/TmuPxjoz/hE4VOO1lkMchOxxTWqaUC0LRfh90KHh6HVKqGffHlhe
	Nzapc/JKxjCraXg==
X-Google-Smtp-Source: AGHT+IGJ3zxP4tZSJCnPpnLfo8kuY9/ChMlhp2Vc3i11mcX5tsN9jlzR3HCoS4DbN8uykW/2HzhGSH0eYEjOYg==
X-Received: from wmbhh7.prod.google.com ([2002:a05:600c:5307:b0:458:bfa7:dd5b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6216:b0:456:1b93:76b with SMTP id 5b1f17b1804b1-45b47b50207mr2162775e9.4.1755640348094;
 Tue, 19 Aug 2025 14:52:28 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:33 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-6-smostafa@google.com>
Subject: [PATCH v4 05/28] iommu/io-pgtable-arm: Factor kernel specific code out
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Some of the currently used APIs are only part of the kernel and not
available in the hypervisor, factor those out of the common file:
- alloc/free memory
- CMOs
- virt/phys conversions

Which is implemented by the kernel in io-pgtable-arm-kernel.c and
similarly for the hypervisor later in this series.

va/pa conversion kept as macros.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/io-pgtable-arm-kernel.c | 89 ++++++++++++++++++++++++
 drivers/iommu/io-pgtable-arm.c        | 99 +++------------------------
 drivers/iommu/io-pgtable-arm.h        | 14 ++++
 3 files changed, 113 insertions(+), 89 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-kernel.c b/drivers/iommu/io-pgtable-arm-kernel.c
index f3b869310964..d3056487b0f6 100644
--- a/drivers/iommu/io-pgtable-arm-kernel.c
+++ b/drivers/iommu/io-pgtable-arm-kernel.c
@@ -9,10 +9,99 @@
 #define pr_fmt(fmt)	"arm-lpae io-pgtable: " fmt
 
 #include <linux/device/faux.h>
+#include <linux/dma-mapping.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 
 #include "io-pgtable-arm.h"
+#include "iommu-pages.h"
+
+static dma_addr_t __arm_lpae_dma_addr(void *pages)
+{
+	return (dma_addr_t)virt_to_phys(pages);
+}
+
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+			     struct io_pgtable_cfg *cfg,
+			     void *cookie)
+{
+	struct device *dev = cfg->iommu_dev;
+	size_t alloc_size;
+	dma_addr_t dma;
+	void *pages;
+
+	/*
+	 * For very small starting-level translation tables the HW requires a
+	 * minimum alignment of at least 64 to cover all cases.
+	 */
+	alloc_size = max(size, 64);
+	if (cfg->alloc)
+		pages = cfg->alloc(cookie, alloc_size, gfp);
+	else
+		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
+						  alloc_size);
+
+	if (!pages)
+		return NULL;
+
+	if (!cfg->coherent_walk) {
+		dma = dma_map_single(dev, pages, size, DMA_TO_DEVICE);
+		if (dma_mapping_error(dev, dma))
+			goto out_free;
+		/*
+		 * We depend on the IOMMU being able to work with any physical
+		 * address directly, so if the DMA layer suggests otherwise by
+		 * translating or truncating them, that bodes very badly...
+		 */
+		if (dma != virt_to_phys(pages))
+			goto out_unmap;
+	}
+
+	return pages;
+
+out_unmap:
+	dev_err(dev, "Cannot accommodate DMA translation for IOMMU page tables\n");
+	dma_unmap_single(dev, dma, size, DMA_TO_DEVICE);
+
+out_free:
+	if (cfg->free)
+		cfg->free(cookie, pages, size);
+	else
+		iommu_free_pages(pages);
+
+	return NULL;
+}
+
+void __arm_lpae_free_pages(void *pages, size_t size,
+			   struct io_pgtable_cfg *cfg,
+			   void *cookie)
+{
+	if (!cfg->coherent_walk)
+		dma_unmap_single(cfg->iommu_dev, __arm_lpae_dma_addr(pages),
+				 size, DMA_TO_DEVICE);
+
+	if (cfg->free)
+		cfg->free(cookie, pages, size);
+	else
+		iommu_free_pages(pages);
+}
+
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg)
+{
+	dma_sync_single_for_device(cfg->iommu_dev, __arm_lpae_dma_addr(ptep),
+				   sizeof(*ptep) * num_entries, DMA_TO_DEVICE);
+}
+
+void *__arm_lpae_alloc_data(size_t size, gfp_t gfp)
+{
+	return kmalloc(size, gfp);
+}
+
+void __arm_lpae_free_data(void *p)
+{
+	return kfree(p);
+}
 
 #ifdef CONFIG_IOMMU_IO_PGTABLE_LPAE_SELFTEST
 
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 791a2c4ecb83..2ca09081c3b0 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -12,12 +12,10 @@
 #include <linux/io-pgtable.h>
 #include <linux/sizes.h>
 #include <linux/types.h>
-#include <linux/dma-mapping.h>
 
 #include <asm/barrier.h>
 
 #include "io-pgtable-arm.h"
-#include "iommu-pages.h"
 
 /*
  * Calculate the index at level l used to map virtual address a using the
@@ -118,7 +116,7 @@
 #define ARM_MALI_LPAE_MEMATTR_WRITE_ALLOC 0x8DULL
 
 /* IOPTE accessors */
-#define iopte_deref(pte,d) __va(iopte_to_paddr(pte, d))
+#define iopte_deref(pte,d) __arm_lpae_phys_to_virt(iopte_to_paddr(pte, d))
 
 #define iopte_type(pte)					\
 	(((pte) >> ARM_LPAE_PTE_TYPE_SHIFT) & ARM_LPAE_PTE_TYPE_MASK)
@@ -208,83 +206,6 @@ static inline bool arm_lpae_concat_mandatory(struct io_pgtable_cfg *cfg,
 	       (data->start_level == 1) && (oas == 40);
 }
 
-static dma_addr_t __arm_lpae_dma_addr(void *pages)
-{
-	return (dma_addr_t)virt_to_phys(pages);
-}
-
-static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
-				    struct io_pgtable_cfg *cfg,
-				    void *cookie)
-{
-	struct device *dev = cfg->iommu_dev;
-	size_t alloc_size;
-	dma_addr_t dma;
-	void *pages;
-
-	/*
-	 * For very small starting-level translation tables the HW requires a
-	 * minimum alignment of at least 64 to cover all cases.
-	 */
-	alloc_size = max(size, 64);
-	if (cfg->alloc)
-		pages = cfg->alloc(cookie, alloc_size, gfp);
-	else
-		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
-						  alloc_size);
-
-	if (!pages)
-		return NULL;
-
-	if (!cfg->coherent_walk) {
-		dma = dma_map_single(dev, pages, size, DMA_TO_DEVICE);
-		if (dma_mapping_error(dev, dma))
-			goto out_free;
-		/*
-		 * We depend on the IOMMU being able to work with any physical
-		 * address directly, so if the DMA layer suggests otherwise by
-		 * translating or truncating them, that bodes very badly...
-		 */
-		if (dma != virt_to_phys(pages))
-			goto out_unmap;
-	}
-
-	return pages;
-
-out_unmap:
-	dev_err(dev, "Cannot accommodate DMA translation for IOMMU page tables\n");
-	dma_unmap_single(dev, dma, size, DMA_TO_DEVICE);
-
-out_free:
-	if (cfg->free)
-		cfg->free(cookie, pages, size);
-	else
-		iommu_free_pages(pages);
-
-	return NULL;
-}
-
-static void __arm_lpae_free_pages(void *pages, size_t size,
-				  struct io_pgtable_cfg *cfg,
-				  void *cookie)
-{
-	if (!cfg->coherent_walk)
-		dma_unmap_single(cfg->iommu_dev, __arm_lpae_dma_addr(pages),
-				 size, DMA_TO_DEVICE);
-
-	if (cfg->free)
-		cfg->free(cookie, pages, size);
-	else
-		iommu_free_pages(pages);
-}
-
-static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
-				struct io_pgtable_cfg *cfg)
-{
-	dma_sync_single_for_device(cfg->iommu_dev, __arm_lpae_dma_addr(ptep),
-				   sizeof(*ptep) * num_entries, DMA_TO_DEVICE);
-}
-
 static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cfg, int num_entries)
 {
 	for (int i = 0; i < num_entries; i++)
@@ -360,7 +281,7 @@ static arm_lpae_iopte arm_lpae_install_table(arm_lpae_iopte *table,
 	arm_lpae_iopte old, new;
 	struct io_pgtable_cfg *cfg = &data->iop.cfg;
 
-	new = paddr_to_iopte(__pa(table), data) | ARM_LPAE_PTE_TYPE_TABLE;
+	new = paddr_to_iopte(__arm_lpae_virt_to_phys(table), data) | ARM_LPAE_PTE_TYPE_TABLE;
 	if (cfg->quirks & IO_PGTABLE_QUIRK_ARM_NS)
 		new |= ARM_LPAE_PTE_NSTABLE;
 
@@ -581,7 +502,7 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
 
 	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
-	kfree(data);
+	__arm_lpae_free_data(data);
 }
 
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
@@ -895,7 +816,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 	if (cfg->oas > ARM_LPAE_MAX_ADDR_BITS)
 		return NULL;
 
-	data = kmalloc(sizeof(*data), GFP_KERNEL);
+	data = __arm_lpae_alloc_data(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return NULL;
 
@@ -1018,11 +939,11 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	wmb();
 
 	/* TTBR */
-	cfg->arm_lpae_s1_cfg.ttbr = virt_to_phys(data->pgd);
+	cfg->arm_lpae_s1_cfg.ttbr = __arm_lpae_virt_to_phys(data->pgd);
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	__arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1114,11 +1035,11 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	wmb();
 
 	/* VTTBR */
-	cfg->arm_lpae_s2_cfg.vttbr = virt_to_phys(data->pgd);
+	cfg->arm_lpae_s2_cfg.vttbr = __arm_lpae_virt_to_phys(data->pgd);
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	__arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1188,7 +1109,7 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	/* Ensure the empty pgd is visible before TRANSTAB can be written */
 	wmb();
 
-	cfg->arm_mali_lpae_cfg.transtab = virt_to_phys(data->pgd) |
+	cfg->arm_mali_lpae_cfg.transtab = __arm_lpae_virt_to_phys(data->pgd) |
 					  ARM_MALI_LPAE_TTBR_READ_INNER |
 					  ARM_MALI_LPAE_TTBR_ADRMODE_TABLE;
 	if (cfg->coherent_walk)
@@ -1197,7 +1118,7 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	__arm_lpae_free_data(data);
 	return NULL;
 }
 
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index a06a23543cff..7d9f0b759275 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -68,4 +68,18 @@ struct arm_lpae_io_pgtable {
 
 typedef u64 arm_lpae_iopte;
 
+void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
+			 struct io_pgtable_cfg *cfg);
+void __arm_lpae_free_pages(void *pages, size_t size,
+			   struct io_pgtable_cfg *cfg,
+			   void *cookie);
+void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
+			     struct io_pgtable_cfg *cfg,
+			     void *cookie);
+void *__arm_lpae_alloc_data(size_t size, gfp_t gfp);
+void __arm_lpae_free_data(void *p);
+#ifndef __KVM_NVHE_HYPERVISOR__
+#define __arm_lpae_virt_to_phys	__pa
+#define __arm_lpae_phys_to_virt	__va
+#endif /* !__KVM_NVHE_HYPERVISOR__ */
 #endif /* IO_PGTABLE_ARM_H_ */
-- 
2.51.0.rc1.167.g924127e9c0-goog

