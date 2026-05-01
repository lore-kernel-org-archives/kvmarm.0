Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A07E3A63E8
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634435; cv=none; b=Y4mwIDsGbTzwwiXvJHoiZN58XMgVs+0R2oYeRExim7z5OuCuRXmi7MNXc4y6hiQKVh5FshSsywNTvkxXU85Q8eX+i542P9nIiIyXy3g5NZYjbxGiv4if1SswHuTwzYZ62MtZ12LJ7lF5NMzqJ8cC5CyMtbnnsyy/We1uoFdDyhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634435; c=relaxed/simple;
	bh=mlHokx8sO2Xw5g9TqHe+AADr1SoayKwnTHlfGZA9zeM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ljtgQYFO6lJ5klogiSfrWik4KtVysqdVZiISZy966x5gDj4CB++I+DcUL3CG5S1F2ZOC+h6lMZeBFMlwCRGE14wbvh0wGwcuGKp9VlnN7Y4+EYCPyhD/rU2BAR0DJLORLvGLc28isrJOsGojGvzo4GmrCEt8KbClZu6qRB5V9jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGzJ69Iu; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGzJ69Iu"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4891f97aef0so11938915e9.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634431; x=1778239231; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w0w7aacCAKh5xDmIAde6/c4ma74UnnFyw9cMZFzY2vk=;
        b=jGzJ69IulaQd7Ns7pOQiGjSGtr3LKqFXy/D+S7ZH00+CsO9cBWgW+HmvkGYTVNkz0n
         sBqJPrRWaNhxzcH+psaFZMobAcDiCshQ2QYSaMDOvPSffBK7IQVELBUhBawooKyf1rvp
         8axEbzf0dmU654DwU/CVJ1FZvbN0DktZZYJfCY+5jH/0PJQldO4xUmoLKA5Nzx4ZL+08
         KaN618JbNI7Q508f+9JNwya1nnWFRj6WrQY5xy5iENpS4yMv9B9J7YoGn3PjbMEC6uoe
         YVZu/fUBNt5mfDeInFVSJWHinRSC3rLk8Y9h4SRQfnkpvod8jzbGMKuRPlQ1NiFHLU9p
         e3Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634431; x=1778239231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0w7aacCAKh5xDmIAde6/c4ma74UnnFyw9cMZFzY2vk=;
        b=bHbK63V39mE1gTYmzOiLgsCgN3L5oSNOCJ786OokHc49h9+MCsDkp1/nwAWU3pp89j
         ZG7cI1QQhwtCR4L3nsrZTfnsYZyv7a3VxJB2jBbvHC785iynfo3L2VqLcGT1fVGZM8CO
         SytMYi0c9OYnOswTT84Xp8ANMyq/5C9dFcJXzCv/dTiFDMrx3GX2ctCNJZlOvAwgsYZo
         yUM0WSOglQMYjhnZk5eMgj7Nd+mj5OZGDUVZCvuq4xCY3fvQ7EVrVG3caWrFNzg91rVA
         maUIG2/vjxOO3WtOb+U6vxqrThemk3gKwpq2W6wS768CVPkhw93Rc72tvtyT90KWT7N3
         Quvw==
X-Forwarded-Encrypted: i=1; AFNElJ+DNaxVTO/A9aDJoz6L6WOatL4hGFpCSkXrVE7leQPIprt1HSHu0FV724vvSlWxPUt+yYwvCAE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+qVV8ohI8N3qX5u0Sj9h7N4YOdScin1ntqmEFh0BkXtLm+nWy
	LV9X1QSIWr0b1HI4XYRlfx6YSF5s5jTw2E96qWT8+LmR/oD9VCl3ZFjwPVNeHH4fz6hLeDuRNfm
	vPbNhW+iZTWCWig==
X-Received: from wroq15.prod.google.com ([2002:adf:f50f:0:b0:44a:c22c:e636])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a316:b0:48a:58ae:9933 with SMTP id 5b1f17b1804b1-48a8eb8b706mr26555135e9.18.1777634431501;
 Fri, 01 May 2026 04:20:31 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:25 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-24-smostafa@google.com>
Subject: [PATCH v6 23/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
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

Based on the callbacks from the hypervisor, update the SMMUv3
Identity mapped page table.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 197 +++++++++++++++++-
 1 file changed, 195 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 1ed5ccce7849..b73a2462f0dd 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -13,6 +13,9 @@
 
 #include "arm_smmu_v3.h"
 
+#include <linux/io-pgtable.h>
+#include "../../../io-pgtable-arm.h"
+
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
@@ -59,6 +62,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	__ret;								\
 })
 
+/* Protected by host_mmu.lock from core code. */
+static struct io_pgtable *idmap_pgtable;
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -210,7 +216,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 			 smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -222,6 +227,78 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static void __smmu_add_cmd(void *__opaque, struct arm_smmu_cmdq_batch *unused,
+			   struct arm_smmu_cmdq_ent *cmd)
+{
+	struct hyp_arm_smmu_v3_device *smmu = (struct hyp_arm_smmu_v3_device *)__opaque;
+
+	WARN_ON(smmu_add_cmd(smmu, cmd));
+}
+
+static int smmu_tlb_inv_range_smmu(struct hyp_arm_smmu_v3_device *smmu,
+				   struct arm_smmu_cmdq_ent *cmd,
+				   unsigned long iova, size_t size, size_t granule)
+{
+	arm_smmu_tlb_inv_build(cmd, iova, size, granule,
+			       PAGE_SHIFT, smmu->features & ARM_SMMU_FEAT_RANGE_INV,
+			       smmu, __smmu_add_cmd, NULL);
+	return smmu_sync_cmd(smmu);
+}
+
+static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t granule,
+			       bool leaf)
+{
+	struct arm_smmu_cmdq_ent cmd_s1 = {
+		.opcode = CMDQ_OP_TLBI_NH_ALL,
+		.tlbi = {
+			.vmid = 0,
+		},
+	};
+	struct hyp_arm_smmu_v3_device *smmu;
+
+	for_each_smmu(smmu) {
+		struct arm_smmu_cmdq_ent cmd = {
+			.opcode = CMDQ_OP_TLBI_S2_IPA,
+			.tlbi = {
+				.leaf = leaf,
+				.vmid = 0,
+			},
+		};
+
+		hyp_spin_lock(&smmu->lock);
+		/*
+		 * Don't bother if SMMU is disabled, this would be useful for the case
+		 * when RPM is supported to avoid touching the SMMU MMIO when disabled.
+		 * The hypervisor also asserts CMDQEN is enabled before the SMMU is
+		 * enabled. As otherwise the host can prevent the hypervisor from doing
+		 * TLB invalidations.
+		 */
+		if (is_smmu_enabled(smmu)) {
+			WARN_ON(smmu_tlb_inv_range_smmu(smmu, &cmd, iova, size, granule));
+			WARN_ON(smmu_send_cmd(smmu, &cmd_s1));
+		}
+		hyp_spin_unlock(&smmu->lock);
+	}
+}
+
+static void smmu_tlb_flush_walk(unsigned long iova, size_t size,
+				size_t granule, void *cookie)
+{
+	smmu_tlb_inv_range(iova, size, granule, false);
+}
+
+static void smmu_tlb_add_page(struct iommu_iotlb_gather *gather,
+			      unsigned long iova, size_t granule,
+			      void *cookie)
+{
+	smmu_tlb_inv_range(iova, granule, granule, true);
+}
+
+static const struct iommu_flush_ops smmu_tlb_ops = {
+	.tlb_flush_walk = smmu_tlb_flush_walk,
+	.tlb_add_page	= smmu_tlb_add_page,
+};
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
@@ -495,6 +572,37 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	return ret;
 }
 
+static int smmu_init_pgt(void)
+{
+	/* Default values overridden based on SMMUs common features. */
+	struct io_pgtable_cfg cfg = (struct io_pgtable_cfg) {
+		.tlb = &smmu_tlb_ops,
+		.pgsize_bitmap = -1,
+		.ias = 48,
+		.oas = 48,
+		.coherent_walk = true,
+	};
+	struct hyp_arm_smmu_v3_device *smmu;
+	struct io_pgtable_ops *ops;
+
+	for_each_smmu(smmu) {
+		cfg.ias = min(cfg.ias, smmu->oas);
+		cfg.oas = min(cfg.oas, smmu->oas);
+		cfg.pgsize_bitmap &= smmu->pgsize_bitmap;
+		cfg.coherent_walk &= !!(smmu->features & ARM_SMMU_FEAT_COHERENCY);
+	}
+
+	/* At least PAGE_SIZE must be supported by all SMMUs*/
+	if ((cfg.pgsize_bitmap & PAGE_SIZE) == 0)
+		return -EINVAL;
+
+	ops = kvm_alloc_io_pgtable_ops(ARM_64_LPAE_S2, &cfg, NULL);
+	if (!ops)
+		return -ENOMEM;
+	idmap_pgtable = io_pgtable_ops_to_pgtable(ops);
+	return 0;
+}
+
 /* Called while is the host is still trusted. */
 static int smmu_init(void)
 {
@@ -520,7 +628,10 @@ static int smmu_init(void)
 
 	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
 
-	return 0;
+	ret = smmu_init_pgt();
+	if (ret)
+		goto out_reclaim_smmu;
+	return ret;
 
 out_reclaim_smmu:
 	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
@@ -950,8 +1061,90 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
 	return false;
 }
 
+static size_t smmu_pgsize_idmap(size_t size, u64 paddr, size_t pgsize_bitmap)
+{
+	size_t pgsizes;
+
+	/* Remove page sizes that are larger than the current size */
+	pgsizes = pgsize_bitmap & GENMASK_ULL(__fls(size), 0);
+
+	/* Remove page sizes that the address is not aligned to. */
+	if (likely(paddr))
+		pgsizes &= GENMASK_ULL(__ffs(paddr), 0);
+
+	WARN_ON(!pgsizes);
+
+	/* Return the largest page size that fits. */
+	return BIT(__fls(pgsizes));
+}
+
 static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 {
+	size_t pgsize = PAGE_SIZE, pgcount, size;
+	struct io_pgtable *pgtable = idmap_pgtable;
+	int ret = 0;
+
+	end = min(end, BIT(pgtable->cfg.oas));
+	if (start >= end)
+		return 0;
+
+	size = end - start;
+	if (prot) {
+		size_t mapped;
+
+		if (!(prot & IOMMU_MMIO))
+			prot |= IOMMU_CACHE;
+
+		while (size) {
+			mapped = 0;
+			/*
+			 * We handle pages size for memory and MMIO differently:
+			 * - memory: Map everything with PAGE_SIZE, that is guaranteed to
+			 *   find memory as we allocated enough pages to cover the entire
+			 *   memory, we do that as io-pgtable-arm doesn't support
+			 *   split_blk_unmap logic any more, so we can't break blocks once
+			 *   mapped to tables.
+			 * - MMIO: Unlike memory, pKVM allocate 1G to for all MMIO, while
+			 *   the MMIO space can be large, as it is assumed to cover the
+			 *   whole IAS that is not memory, we have to use block mappings,
+			 *   that is fine for MMIO as it is never donated at the moment,
+			 *   so we never need to unmap MMIO at the run time triggereing
+			 *   split block logic.
+			 */
+			if (prot & IOMMU_MMIO)
+				pgsize = smmu_pgsize_idmap(size, start, pgtable->cfg.pgsize_bitmap);
+
+			pgcount = size / pgsize;
+			ret = pgtable->ops.map_pages(&pgtable->ops, start, start,
+						     pgsize, pgcount, prot, 0, &mapped);
+			size -= mapped;
+			start += mapped;
+			/* Map failures doesn't impact security, tolerate it. */
+			if (!mapped || ret)
+				break;
+		}
+	} else {
+		struct iommu_iotlb_gather gather;
+		size_t unmapped;
+
+		while (size) {
+			pgcount = size / pgsize;
+			iommu_iotlb_gather_init(&gather);
+			unmapped = pgtable->ops.unmap_pages(&pgtable->ops, start,
+							    pgsize, pgcount, &gather);
+			size -= unmapped;
+			start += unmapped;
+			if (!unmapped)
+				break;
+		}
+	}
+
+	if (ret)
+		return ret;
+
+	if (WARN_ON(size))
+		return -EINVAL;
+
 	return 0;
 }
 
-- 
2.54.0.545.g6539524ca2-goog

