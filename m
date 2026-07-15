Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD8247A0B6
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116784; cv=none; b=ZbUIk06AWM2Wgh9GWGDy4LTIDaDQ5oISPmxPzHAtJokuxyEiIpYUEVAxIDoZGRDEaSowIXmuz0RqHoT6GZTuKQR/VuH89K5avOMkgF/N6M4OZEdVNqOm5moihl/LWd4TfrwX/llj5IP0GWhB1XmhpH0EcYaqArC+pJ0BArxkoow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116784; c=relaxed/simple;
	bh=yEEUCGjMm6Cq047Eod0q14m6OWNvFshd3GgoogvNQCM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LH9f+FufK7MPfqhycXw3mdMIVfO5v9an0wVYFDpbJahmoyir0mUydalwYGJYNDW9TWBysf7dlEWMAkDoGdzJSkEspmmbujDCFfMaB5FE+Kh02I0LY95ga7CoqjKK1cR2Bw8muiWAbk5tfUJRYX+p/n5yP3cBxcTU5Gjh5kOWpHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=clopqq32; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="clopqq32"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493b21b1fe8so18020415e9.0
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116780; x=1784721580; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JkwZN65XPQxPyKvbylt/w2oKgmc1B/VRyR24GVjyEdM=;
        b=clopqq32hr10dKeIJCOjdJ5qxZwIgFLQNlTrX4O+jk7gWLgo7DNBRiF1zm2Ss+xyCD
         Pgutr5rwKmk6s4bMK4TCfscwSpdE+F+8Qo6lEX8u+0pENjeRLKKu8h5GXgXG/j/pfksk
         eFni0QbhMijh07L25488lW+B40uqEd4doluYnpniqKo5On3ZBOfKKhwtxlrPXA4rBb/V
         tkDiAidP5UVXeGbzg+rQ8XPstcECWUMc0KyA39iL+B4MtVWHsX15blvBRIc0m22lznF9
         TERS1IFchLUirocUFiyoaN26sjxskUJfu7royr/1lqpqMflW21Gj+MoiiP946NCj3Ho7
         er3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116780; x=1784721580;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JkwZN65XPQxPyKvbylt/w2oKgmc1B/VRyR24GVjyEdM=;
        b=CM4IE2CXKZY684kL8a0+JPwRmMw/I7E1OKWJKYWDV34t/lGDGi46asOCW8tRHJlGM+
         voXLNmIfDEQQ9qiuFitHw9OxoEbZX9RGeXDFyz7eSTrDp2CzeMUeNgvv+3b0DHzTxxNO
         iN1RgFJ7kmGdhZoXSU7WwCgyH2c30DI3uuPUGZwrfkvKbbQVSxuSLbtWnoHKiHVpgFMP
         kSRd48yUOVb/hvMvSXOMI6osAfFbraPQopwrvR6eR8OHGeTcqAUeT2hDJQ+XDLNI6LSE
         OtlAxXZvpuZvASpx0L8hqIEOHmWT2sgb6RDlPGJElosniH4WvGJg5jJ1FcajnE2El1E2
         fQPA==
X-Forwarded-Encrypted: i=1; AHgh+RrZNgZi1BGfPArAbq/FUrq2BTBwQuMqsxcJN+/4Rexsh2ZsWBWQiVHk13ZIEo53tHwtOxq25Ak=@lists.linux.dev
X-Gm-Message-State: AOJu0YxD5Jexq9CTOHwnptBQla1cHOmfr+tAlnMMPqbWgDLZl6JnXjaL
	aKe5U84FsxqY+0V4VFp7oxm8zSBWdb36xih0pEU6YTSB0zQ59F7VjWzqqeG1eTwqTmudx8H7VoK
	cd8Hqq8eAxRa50w==
X-Received: from wmop7.prod.google.com ([2002:a05:600c:4687:b0:493:f738:6344])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a111:b0:490:9782:3eb8 with SMTP id 5b1f17b1804b1-493f881d11amr144285835e9.25.1784116780019;
 Wed, 15 Jul 2026 04:59:40 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:59:02 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-22-smostafa@google.com>
Subject: [PATCH v7 21/24] iommu/io-pgtable-arm: Support io-pgtable-arm in the hypervisor
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

To be able to populate the shadow stage-2 in the hypervisor, compile
io-pgtable-arm object for the hypervisor.

That requires the hypervisor to support iommu-pages, re-defining some
functions as address conversion and stubbing some others as DMA-API.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  3 +-
 .../arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h | 68 +++++++++++++++++++
 drivers/iommu/io-pgtable-arm.c                | 39 ++++++++---
 drivers/iommu/io-pgtable-arm.h                | 17 +++++
 4 files changed, 117 insertions(+), 10 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index dcb75fb5b4f1..35ac274ab2c0 100644
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h
new file mode 100644
index 000000000000..c9d20e781aed
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h
@@ -0,0 +1,68 @@
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
+	return pkvm_iommu_donate_pages(get_order(size));
+}
+
+static inline void iommu_free_pages(void *virt)
+{
+	pkvm_iommu_reclaim_pages(virt);
+}
+
+static inline void *arm_lpae_alloc_data(size_t size)
+{
+	return pkvm_iommu_donate_pages(get_order(size));
+}
+
+static inline void arm_lpae_free_data(void *p)
+{
+	pkvm_iommu_reclaim_pages(p);
+}
+
+#undef phys_to_virt
+#define phys_to_virt(x)		hyp_phys_to_virt(x)
+
+#undef virt_to_phys
+#define virt_to_phys(x)		hyp_virt_to_phys(x)
+
+/* Stubs used by io-pgtable-arm but no relevant for hypervisor object. */
+#undef dma_map_single
+#define dma_map_single(d, p, s, dir) (virt_to_phys(p))
+
+#undef dma_unmap_single
+#define dma_unmap_single(d, a, s, r) do { (void)(d); (void)(a); (void)(s); (void)(r); } while (0)
+
+#define dma_mapping_error(...) (0)
+
+#undef dev_err
+#define dev_err(dev, format, ...)
+
+static inline int iommu_pages_start_incoherent(void *virt, struct device *dma_dev)
+{
+	return 0;
+}
+
+static inline void iommu_pages_free_incoherent(void *virt,
+						   struct device *dma_dev)
+{
+}
+
+static inline void iommu_pages_flush_incoherent(struct device *dma_dev,
+						void *virt, size_t offset,
+						size_t len)
+{
+}
+
+struct io_pgtable_ops *kvm_alloc_io_pgtable_ops(enum io_pgtable_fmt fmt,
+						struct io_pgtable_cfg *cfg,
+						void *cookie);
+#endif /* IO_PGTABLE_ARM_HYP_H_ */
diff --git a/drivers/iommu/io-pgtable-arm.c b/drivers/iommu/io-pgtable-arm.c
index 476c0e25631a..cf71087e4d3a 100644
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
 
@@ -350,8 +350,7 @@ static void __arm_lpae_free_pages(void *pages, size_t size,
 static void __arm_lpae_sync_pte(arm_lpae_iopte *ptep, int num_entries,
 				struct io_pgtable_cfg *cfg)
 {
-	dma_sync_single_for_device(cfg->iommu_dev, __arm_lpae_dma_addr(ptep),
-				   sizeof(*ptep) * num_entries, DMA_TO_DEVICE);
+	iommu_pages_flush_incoherent(cfg->iommu_dev, ptep, 0, sizeof(*ptep) * num_entries);
 }
 
 static void __arm_lpae_clear_pte(arm_lpae_iopte *ptep, struct io_pgtable_cfg *cfg, int num_entries)
@@ -650,7 +649,7 @@ static void arm_lpae_free_pgtable(struct io_pgtable *iop)
 	struct arm_lpae_io_pgtable *data = io_pgtable_to_data(iop);
 
 	__arm_lpae_free_pgtable(data, data->start_level, data->pgd);
-	kfree(data);
+	arm_lpae_free_data(data);
 }
 
 static size_t __arm_lpae_unmap(struct arm_lpae_io_pgtable *data,
@@ -964,7 +963,7 @@ arm_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg)
 	if (cfg->oas > ARM_LPAE_MAX_ADDR_BITS)
 		return NULL;
 
-	data = kmalloc_obj(*data);
+	data = arm_lpae_alloc_data(sizeof(*data));
 	if (!data)
 		return NULL;
 
@@ -1091,7 +1090,7 @@ arm_64_lpae_alloc_pgtable_s1(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1187,7 +1186,7 @@ arm_64_lpae_alloc_pgtable_s2(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1266,7 +1265,7 @@ arm_mali_lpae_alloc_pgtable(struct io_pgtable_cfg *cfg, void *cookie)
 	return &data->iop;
 
 out_free_data:
-	kfree(data);
+	arm_lpae_free_data(data);
 	return NULL;
 }
 
@@ -1299,3 +1298,25 @@ struct io_pgtable_init_fns io_pgtable_arm_mali_lpae_init_fns = {
 	.alloc	= arm_mali_lpae_alloc_pgtable,
 	.free	= arm_lpae_free_pgtable,
 };
+
+#ifdef __KVM_NVHE_HYPERVISOR__
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
+	iop->fmt	= fmt;
+	iop->cookie	= cookie;
+	iop->cfg	= *cfg;
+
+	return &iop->ops;
+}
+#endif
\ No newline at end of file
diff --git a/drivers/iommu/io-pgtable-arm.h b/drivers/iommu/io-pgtable-arm.h
index ba7cfdf7afa0..fd5c5ff2b550 100644
--- a/drivers/iommu/io-pgtable-arm.h
+++ b/drivers/iommu/io-pgtable-arm.h
@@ -27,4 +27,21 @@
 #define ARM_LPAE_TCR_PS_48_BIT		0x5ULL
 #define ARM_LPAE_TCR_PS_52_BIT		0x6ULL
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+#include "iommu-pages.h"
+
+static inline void *arm_lpae_alloc_data(size_t size)
+{
+	return kmalloc(size, GFP_KERNEL);
+}
+
+static inline void arm_lpae_free_data(void *p)
+{
+	kfree(p);
+}
+
+#else
+#include "arm/arm-smmu-v3/pkvm/io-pgtable-arm-hyp.h"
+#endif
+
 #endif /* IO_PGTABLE_ARM_H_ */
-- 
2.55.0.141.g00534a21ce-goog

