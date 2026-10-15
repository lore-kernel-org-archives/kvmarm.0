Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com [209.85.221.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15CF598BED
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094982; cv=none; b=Ozd3FK3O2MEj3SNNvvRZn80ACym0hJKpHas47ynqyIPWwoM3Yo7pdIOml8RoNTMDaYPcYpd0GMMqGMVfzGQcTPdE3wZgcrMwi+kJIrcEgBA9OVkF7dvcfMKkPgAslEiHtSk8z1sqFepn5hkVLCy+ty4UcfZt8o7vxEhB2dyyKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094982; c=relaxed/simple;
	bh=imFEZKcawpde6wneHyOMm60Ni0qSyDkx3BQ2dv1g5HY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=CT4XSU4FdnVY+FZPxpaQCphVonL7q7iAU/zc0sYYxqZq+FnnRQ1w01+w+jHFbKlgqRUJIYDPtYT3iWT9Xz75D85lszPBRK/aguolVdu6BNZm7i0oIA9mEf1/VJb9doN0VsMvT/UZNhJgLsIftgagSw6q3nFlwgqocgB6zEhk6zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aN/AGft9; arc=none smtp.client-ip=209.85.221.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aN/AGft9"
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-48dea677afcso208984f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094977; x=1792699777; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=l+MxF80V9nS6Nyq45ubbKvlA2fryYNHeqrMVD/2LTb0=;
        b=aN/AGft909fMEebfZ6kDeWt4dDNECmduJuuHc/jL6J95ojpC96pnLd98mhkijhJ8vI
         xY4MW34t6qeDgAayP3sYTqzS6qR9LQODNol1QzzKE0he06JnTHWyascVy5BmM58gKaNs
         kiEE29vzQLXiC4g0vhFVZcyCx4JWVpIM5m1qcEQ0pOa2N+mQkTgrJ2g6dwM8N0cAmuKA
         D0e03ym0WThPAipSWWwsIN5GgYZTFsFxbiEK9mJfoXXxakqPyIo6eOqS2OG+X9UMogKK
         j6lU1E5rIjdILzsz37Mm1nHWqRLnpxGV9ttXH3O4sUSBtjgfOJL0uhLZXxOqA0dhSxOH
         RpMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094977; x=1792699777;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+MxF80V9nS6Nyq45ubbKvlA2fryYNHeqrMVD/2LTb0=;
        b=V+rGF0APGEJpvW0jdSNhQCrz34U/8kTOk1Fhs4R3GwgmTMB9lZTRI3GvdBHvzooYDo
         ijOe/Y1es20iHjz0gTptI0StIRPx2/IaYJ4tP/IqRlQQbDe6K3jt7fJPhL3aVVm/2L0u
         R0woH/ZZdBJhzN0tz3WwPwzkBOpcZDxwnrSFAO6AfE+NwNuINxqthA9KFxINEDCc92LQ
         0xlJMYZkrEJDI2+pl9IuEuRfaz0zV050VNXJuGE2yRZH4BNkQ5v3GxCqHjgHamweH0V3
         JyYfBUJLt0cdNwVXMxVYc9UKyZ0G6+ALAEPDhHe9SFZObKblc/RhYa6uzZdTXP4CgUak
         Icxw==
X-Forwarded-Encrypted: i=1; AKwUvBwrraZc3SXzlWGRcI/0J5pac4ILyUCGOOXtcJfIeIph7gyz+c/QgeO5lLY2Z1oq5bQInA37nPY=@lists.linux.dev
X-Gm-Message-State: AFq9FYJ6JHpWB6krEwenb8+ulqnRk0wGw6rISKRZhhw1xm2aLtMhOSvr
	1432ZSjN3fSGiuCfAY34GXsDA61ud46Z1nFyjCCx+fU/by9cZvkkzXUlIbuIDpRsCgvDbO9oGEB
	Eg56bTmuh/PYyKA==
X-Received: from wrzh2.prod.google.com ([2002:a5d:6e02:0:b0:48d:f498:dec8])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6292:0:b0:48c:6756:dab3 with SMTP id ffacd0b85a97d-48dfacf53famr2128690f8f.3.1792094976702;
 Thu, 15 Oct 2026 13:09:36 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:52 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-22-smostafa@google.com>
Subject: [PATCH v9 21/25] iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To be able to populate the shadow stage-2 in the hypervisor, compile
io-pgtable-arm object for the hypervisor.

That requires the hypervisor to provide the iommu-pages allocator,
redefine the address conversion helpers, and stub out the DMA API.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  3 +-
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h | 88 +++++++++++++++++++
 drivers/iommu/io-pgtable-arm.c                | 14 +--
 drivers/iommu/io-pgtable-arm.h                |  9 ++
 4 files changed, 106 insertions(+), 8 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index ee86e4b3436f..08da05ddda5d 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -36,7 +36,8 @@ hyp-obj-y += $(lib-objs)
 HYP_SMMU_V3_DRV_PATH := ../../../../../drivers/iommu/arm/arm-smmu-v3
 
 hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += $(HYP_SMMU_V3_DRV_PATH)/pkvm/arm-smmu-v3-hyp.o \
-	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o ../../../../../lib/hweight.o
+	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o ../../../../../lib/hweight.o \
+	$(HYP_SMMU_V3_DRV_PATH)/../../io-pgtable-arm.o
 
 # Path to simple_ring_buffer.c
 CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h
new file mode 100644
index 000000000000..d278c6788fb1
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h
@@ -0,0 +1,88 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef IO_PGTABLE_ARM_HYP_H_
+#define IO_PGTABLE_ARM_HYP_H_
+
+#include <nvhe/memory.h>
+#include <nvhe/iommu.h>
+
+#undef WARN_ONCE
+#define WARN_ONCE(condition, format...) WARN_ON(condition)
+
+static inline void *iommu_alloc_pages_node_sz(int nid, gfp_t gfp, size_t size)
+{
+	return pkvm_iommu_alloc_pages(get_order(size));
+}
+
+static inline void iommu_free_pages(void *virt)
+{
+	pkvm_iommu_free_pages(virt);
+}
+
+#define arm_lpae_alloc_data(obj)	pkvm_iommu_alloc_pages(get_order(sizeof(obj)))
+#define arm_lpae_free_data(p)		pkvm_iommu_free_pages(p)
+
+#undef phys_to_virt
+#define phys_to_virt(x)		hyp_phys_to_virt(x)
+
+#undef virt_to_phys
+#define virt_to_phys(x)		hyp_virt_to_phys(x)
+
+/* Stubs used by io-pgtable-arm but no relevant for hypervisor object. */
+#undef dma_map_single
+#define dma_map_single(d, p, s, dir) \
+	({ (void)(d); (void)(s); (void)(dir); virt_to_phys(p); })
+
+#undef dma_unmap_single
+#define dma_unmap_single(d, a, s, r) \
+	do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
+
+#define dma_sync_single_for_device(d, a, s, r) \
+	do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
+
+#undef dma_mapping_error
+#define dma_mapping_error(...) (0)
+
+#undef dev_err
+#define dev_err(dev, format, ...) \
+	({ (void)(dev); no_printk(format, ##__VA_ARGS__); })
+
+#undef iommu_dirty_bitmap_record
+#define iommu_dirty_bitmap_record(d, i, l) \
+	do { (void)(d); (void)(i); (void)(l); } while (0)
+
+static inline int iommu_pages_start_incoherent(void *virt, struct device *dma_dev)
+{
+	return 0;
+}
+
+static inline void iommu_pages_free_incoherent(void *virt,
+					       struct device *dma_dev)
+{
+}
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+}
+
+static inline struct io_pgtable_ops *pkvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+							       struct io_pgtable_cfg *cfg,
+							       void *cookie)
+{
+	struct io_pgtable *iop;
+
+	if (fmt != ARM_64_LPAE_S2)
+		return NULL;
+
+	iop = io_pgtable_arm_64_lpae_s2_init_fns.alloc(cfg, cookie);
+	if (!iop)
+		return NULL;
+
+	iop->fmt	= fmt;
+	iop->cookie	= cookie;
+	iop->cfg	= *cfg;
+
+	return &iop->ops;
+}
+#endif /* IO_PGTABLE_ARM_HYP_H_ */
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 476c0e25631a..6b2668c2ef44 100644
--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -20,7 +20,6 @@
 #include <asm/barrier.h>
 
 #include "io-pgtable-arm.h"
-#include "iommu-pages.h"
 
 #define ARM_LPAE_MAX_ADDR_BITS		52
 #define ARM_LPAE_S2_MAX_CONCAT_PAGES	16
@@ -301,6 +300,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 {
 	struct device *dev = cfg->iommu_dev;
 	void *pages;
+	int nid = dev ? dev_to_node(dev) : NUMA_NO_NODE;
 
 	/*
 	 * For very small starting-level translation tables the HW requires a
@@ -311,7 +311,7 @@ static void *__arm_lpae_alloc_pages(size_t size, gfp_t gfp,
 	if (cfg->alloc)
 		return __arm_lpae_cfg_alloc(size, gfp, cfg, cookie);
 
-	pages = iommu_alloc_pages_node_sz(dev_to_node(dev), gfp, size);
+	pages = iommu_alloc_pages_node_sz(nid, gfp, size);
 	if (!pages)
 		return NULL;
 
@@ -650,7 +650,7 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
 
 	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
-	kfree(data);
+	arm_lpae_free_data(data);
 }
 
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
@@ -964,7 +964,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 	if (cfg->oas > ARM_LPAE_MAX_ADDR_BITS)
 		return NULL;
 
-	data = kmalloc_obj(*data);
+	data = arm_lpae_alloc_data(*data);
 	if (!data)
 		return NULL;
 
@@ -1091,7 +1091,7 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1187,7 +1187,7 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1266,7 +1266,7 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index ba7cfdf7afa0..4278da41e406 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -27,4 +27,13 @@
 #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
 #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+#include "iommu-pages.h"
+#define arm_lpae_alloc_data(obj)	kmalloc_obj(obj)
+#define arm_lpae_free_data(p)		kfree(p)
+
+#else
+#include "arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h"
+#endif
+
 #endif /* IO_PGTABLE_ARM_H_ */
-- 
2.56.0.176.g3575e65682-goog

