Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D74B33A4F50
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634434; cv=none; b=K10RGIrVFPG+qCTWM5+fJf0WdkwnbZEhKdpfgaDTDAn+1IR4CnrL16p/AwQd6s80Oa6ux20k1ysRcbys+Q/PP348vk7r6bsFOKb+B8KQKK6kkxv/GJ7S/OPnF7RgpDzitbqYQwZqJvJ9pn/HLNuYutbeXjSSOx6v1YFbXDBVhl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634434; c=relaxed/simple;
	bh=/cJ7AkplAzft5yBV8ZxNUAFnFWochsKTITaa04WSWs4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=OzuT7j4FFIAFY37eOg/ydqZ1KR9w7Z14WmMSoCJb5gMJ3FLS4yGLjN59ddhElTOFKbC1drFxhqDNTbgB3BUnk/iUOupKeFrT+OsfMvtJIA84DbGHmdJZdHEhFnAGdA8cnVuDAhwGNns9zT4KgXl+TXFGS92Jof/WqQiOe3jp8NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rzn1Js62; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rzn1Js62"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-449b2a183d3so966159f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634430; x=1778239230; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yTbFP/vzGSoWzHV54z7Mcha0ge1NRm8j7joYQ/l7s4Q=;
        b=rzn1Js62fEG6O0Z7Rl/aFAteoLDQxNwI8zg5WZwLBQ+w+rnpVcp1gEdUIpgHqyVDI1
         /+yiRy/T6gozMMnsfSt/DpKOaSvhSeJ1E76Ii/8dqmB7VXC+Pv/V/6mMtsk8ld7URWy+
         /c33fovno1uWDaQurHvBYsUWDS8vwMAcVI8Cd7kKYxTaQC3EdOTIgDX4PQbF9UI4nA7G
         Mo6c0sbLTn+brb6A3CbM+4OTCI9A8vbCxPar8sTRgdeSo+zyVCoPMWSbMOFkQTh0BYQ2
         RVLfy+VVJa//JWm2G+NYvT15hSskZ0ATOs7oFuBX26nB+7IYY5F+J1uWq0N1w8fR/dHw
         B0lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634430; x=1778239230;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yTbFP/vzGSoWzHV54z7Mcha0ge1NRm8j7joYQ/l7s4Q=;
        b=fhkVASYSEzyDpWVX7ma8Xe8s9BOBkvv+ErqfyzWNkoVJfmovzxHVxVPPg+ImjgXBSA
         6C+TPz0sI6orOcyyoTZr6lvAfZNIjm41X7PJ9BmNaotKVxlOk1KGCt9gvT7eArDy8nQK
         PULaj6/6y7qRensXQoKSOP138gg+58Zdjg2oFblakIZ6wKHAbdzxCDSi7d6S/8j+RDf4
         WovlhWEID8EA5rrL7hEx/DCY7BigJChZxNuaTsKfbEhPeUoQWVkYhUcgw3aklIqJtvYH
         1tg7xWt2HJTz9VHtrDEItkK0fF5MbTYLSUX+YLLQvFsSBsTKcLcBHdZAS2lvlGH34X3D
         N0ng==
X-Forwarded-Encrypted: i=1; AFNElJ9zCRT+c4sYw9Ws3YWYfESEfnrAB+HUVS3sU+mTmH+chyB6vpqsPkwF+kKkbXArrpUQKecyIRs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzbrKDKVuX5fDOCp6NbrPEzSdQ0rP3ODzo/uLn9hx8gJIM+vHvv
	RCkTyRiPBtMgp6f4gaYZVyH/xDGZH1b1oI3dbwc5KeI5L7sCSrkmdDkfnqoPQALFb5vt7l7+N6B
	WozrBlJGiWp1Wtg==
X-Received: from wrxp8.prod.google.com ([2002:a05:6000:188:b0:449:9a82:a60d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1862:b0:43d:779e:afa8 with SMTP id ffacd0b85a97d-4494f9a1430mr11063527f8f.16.1777634430023;
 Fri, 01 May 2026 04:20:30 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:24 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-23-smostafa@google.com>
Subject: [PATCH v6 22/25] iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To support DMA isolation in pKVM through SMMUv3 nested trap and
emulate, io-pgtable-arm needs to be compiled for the hypervisor
to create the SMMUs page tables.

Instead of factoring out the kernel-specific code and providing
parallel implementations for the hypervisor, we directly utilize
and abstract the differences within the iommu-pages API.

This introduces a set of hypervisor-specific wrappers in iommu-pages.h
when compiled under __KVM_NVHE_HYPERVISOR__, routing allocations,
frees, virt/phys conversions, and DMA API mapping to the appropriate
pKVM hypervisor functions (kvm_iommu_donate_pages, etc). The generic
kernel definitions are now appropriately excluded in this case.

It also introduces kvm_alloc_io_pgtable_ops at the end of
io-pgtable-arm.c to instantiate the page table for pKVM and adds
the io-pgtable-arm.o object to the hypervisor Makefile.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile |  3 +-
 drivers/iommu/io-pgtable-arm.c   | 31 +++++++++++++++-
 drivers/iommu/io-pgtable-arm.h   |  6 +++
 drivers/iommu/iommu-pages.h      | 63 ++++++++++++++++++++++++++++++++
 4 files changed, 100 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8a75739db947..4e9e0f1ed2b5 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -36,7 +36,8 @@ hyp-obj-y += $(lib-objs)
 HYP_SMMU_V3_DRV_PATH = ../../../../../drivers/iommu/arm/arm-smmu-v3
 
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += $(HYP_SMMU_V3_DRV_PATH)/pkvm/arm-smmu-v3.o \
-	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o
+	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o \
+	$(HYP_SMMU_V3_DRV_PATH)/../../io-pgtable-arm.o
 
 # Path to simple_ring_buffer.c
 CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index e765021308f9..8a0ffea3ae2c 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -252,10 +252,14 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 				    void *cookie)
 {
 	struct device *dev = cfg->iommu_dev;
+	int nid = NUMA_NO_NODE;
 	size_t alloc_size;
 	dma_addr_t dma;
 	void *pages;
 
+	if (dev)
+		nid = dev_to_node(dev);
+
 	/*
 	 * For very small starting-level translation tables the HW requires a
 	 * minimum alignment of at least 64 to cover all cases.
@@ -264,8 +268,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->alloc)
 		pages = cfg->alloc(cookie, alloc_size, gfp);
 	else
-		pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp,
-						  alloc_size);
+		pages = iommu_alloc_pages_node_sz(nid, gfp, alloc_size);
 
 	if (!pages)
 		return NULL;
@@ -1262,3 +1265,27 @@ struct io_pgtable_init_fns io_pgtable_arm_mali_lpae_init_fns = {
 	.alloc	= arm_mali_lpae_alloc_pgtable,
 	.free	= arm_lpae_free_pgtable,
 };
+
+#ifdef __KVM_NVHE_HYPERVISOR__
+#include <nvhe/iommu.h>
+
+struct io_pgtable_ops *kvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+						struct io_pgtable_cfg *cfg,
+						void *cookie)
+{
+	struct io_pgtable *iop;
+
+	if (fmt != ARM_64_LPAE_S2)
+		return NULL;
+
+	iop = arm_64_lpae_alloc_pgtable_s2(cfg, cookie);
+	if (!iop)
+		return NULL;
+
+	iop->fmt        = fmt;
+	iop->cookie     = cookie;
+	iop->cfg        = *cfg;
+
+	return &iop->ops;
+}
+#endif
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index ba7cfdf7afa0..af3a3f1e765e 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -27,4 +27,10 @@
 #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
 #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
 
+#ifdef __KVM_NVHE_HYPERVISOR__
+struct io_pgtable_ops *kvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+						struct io_pgtable_cfg *cfg,
+						void *cookie);
+#endif
+
 #endif /* IO_PGTABLE_ARM_H_ */
diff --git a/drivers/iommu/iommu-pages.h b/drivers/iommu/iommu-pages.h
index e1945193ad7f..749f0f4f870c 100644
--- a/drivers/iommu/iommu-pages.h
+++ b/drivers/iommu/iommu-pages.h
@@ -10,6 +10,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/iommu.h>
 
+#ifndef __KVM_NVHE_HYPERVISOR__
 /**
  * struct ioptdesc - Memory descriptor for IOMMU page tables
  * @iopt_freelist_elm: List element for a struct iommu_pages_list
@@ -181,4 +182,66 @@ static inline void iommu_pages_dma_unmap(struct device *dev, dma_addr_t dma, siz
 	dma_unmap_single(dev, dma, size, DMA_TO_DEVICE);
 }
 
+#else /* __KVM_NVHE_HYPERVISOR__ */
+
+#include <nvhe/memory.h>
+#include <nvhe/iommu.h>
+
+static inline void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
+{
+	return kvm_iommu_donate_pages(get_order(size));
+}
+
+static inline void iommu_free_pages(void *virt)
+{
+	kvm_iommu_reclaim_pages(virt);
+}
+
+static inline void *iommu_alloc_data(size_t size, gfp_t gfp)
+{
+	return kvm_iommu_donate_pages(get_order(size));
+}
+
+static inline void iommu_free_data(void *p)
+{
+	kvm_iommu_reclaim_pages(p);
+}
+
+#undef WARN_ONCE
+#define WARN_ONCE(condition, format...) WARN_ON(condition)
+
+static inline phys_addr_t iommu_virt_to_phys(void *virt)
+{
+	return hyp_virt_to_phys(virt);
+}
+
+static inline void *iommu_phys_to_virt(phys_addr_t phys)
+{
+	return hyp_phys_to_virt(phys);
+}
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+	kvm_flush_dcache_to_poc(virt + offset, len);
+}
+
+static inline dma_addr_t iommu_pages_dma_map(struct device *dev, void *virt, size_t size)
+{
+	kvm_flush_dcache_to_poc(virt, size);
+	return (dma_addr_t)hyp_virt_to_phys(virt);
+}
+
+static inline int iommu_pages_dma_mapping_error(struct device *dev, dma_addr_t dma)
+{
+	return 0;
+}
+
+static inline void iommu_pages_dma_unmap(struct device *dev, dma_addr_t dma, size_t size)
+{
+}
+
+#endif /* __KVM_NVHE_HYPERVISOR__ */
+
 #endif /* __IOMMU_PAGES_H */
-- 
2.54.0.545.g6539524ca2-goog

