Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C828F598BF8
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094983; cv=none; b=RB8wxqn2TCskUqB+93yt48qnYiRMW/h9kFM6wuQ6NBB9cKH+ypRb1DZuHN96IqR2C3C44rB+y4XPj3ViaxJW4t8ooRALIJxVSJJGjtFldVuQfAe6wa/bkGRC4J0AtFHOqKzSuAcWXOHil7Stk4ewXbShUZd5eBpgVykymmh4R6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094983; c=relaxed/simple;
	bh=8tg9o3qv8IiFhlcVCCrsusGvG3Ox1GG+zDGl5YrpDKQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MrBZg7EK+B1zUwdzm2qQXDqkvHPdiJmq9bw5K+6cVj5LhdHaOBMX5Vc8EMrH0kI1hB/fIlnlrvV47PUtFkQvMtYbUj3cGoL3CJ7Rq+KeRbZpBWEW24Vmt5b/P9Xpmn0Fj/I1BeGIciTrt4hxnzJRnQQOOTpdyjm8G+z4ls75J78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PDD4oip4; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PDD4oip4"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a028616bebso42377565e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094978; x=1792699778; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOWI3MWzFM4E6XsnBaoMm2oO1l7gBBooy2wESuq6Qac=;
        b=PDD4oip44IgYDD00utx36UKFmYOX17NtMd+/egxPE/QuSdc1C+WKRJ1Zs++DLY4M0r
         h8C6yhkrFhwVjTnhbqnfR/sMIp0h4cuO24TcSvqkk0N9NjkChmsLf/wyd1sdZAU6JCE4
         lf/lMFKc9fcg+MKr012SbHP2l5ruWxyE7ZIjQVDIrzChshGXLKM4R/ULMk9KI5w50LES
         a5vbS3qJRb9n8sUkpX56FnfMTUXdxt+vKxp51eADXF6Edsjw7CqoHas8Is7pQCtulwhR
         8MTdc37/mTgd+RVOzvyt/5XdZQ27tq2tsndmKeLYTJ5cb6l4MaVt8SdcLoVxn2UCC0v3
         HyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094978; x=1792699778;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uOWI3MWzFM4E6XsnBaoMm2oO1l7gBBooy2wESuq6Qac=;
        b=t1Jr6/hJ2acmMBmvfHOLd8YTqq2h6Q+SHUS1FN4Pqwb7hcns9myf4r9boXJq2Cdvk4
         lIQxhzmLEnhK6jUFixTuFCM3oaijPfZzDPh9Xqf1DFC0VdoTrrMd60CUdwxGzmlo/0kq
         wkyWnws7CApEsKSy8cipSRJ35GFTC5ddN5fD+po+ay4oJcBAlIc/0wzRwguCd/ofBmiX
         Ahn+TE5SGshQIRrrWcxo7Q7TGu5F2nG2sZO2qqqXlDWSQp8k/jSyUtsh49rCqFbHXFDv
         /ySzjIYM43bhWwWhmUlZWWZserxrqWPBApQ4jdAil1ue8FKjZOV0U5d80rourkJwoZeO
         oW2A==
X-Forwarded-Encrypted: i=1; AKwUvBzkBdYpwIFfL6joe2495jhsKoOXQBaDBenxuOfzz0SNMByLvcZCnO7UWMfLChZkxK2nJYdBP0k=@lists.linux.dev
X-Gm-Message-State: AFq9FYJUBJ5oWv3tEh2gt3z5ISGs9lni3EikyE1akltVQSxPyLxhhLFv
	GiWwUzcxdnjJCZfD7VHHWLWaWOkFVkpC+j+CuPwJF7eutlilKw4GyZlJlRfUfvkrzXa0qqE4ric
	C1AW8CjW51VN7Yg==
X-Received: from wmjs9.prod.google.com ([2002:a7b:c389:0:b0:4a1:8be5:4018])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3e0a:b0:4a0:1c10:1419 with SMTP id 5b1f17b1804b1-4a18e4cd667mr404934305e9.26.1792094977861;
 Thu, 15 Oct 2026 13:09:37 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:53 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-23-smostafa@google.com>
Subject: [PATCH v9 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor calls back into the driver on every change to the host
stage-2 page table.
Mirror those changes into an identity mapped stage-2 for the SMMUv3,
That would be attached to all active SIDs.

Difference between memory and MMIO handling:

- Memory is always mapped with PAGE_SIZE. io-pgtable-arm no longer
  supports split_blk_unmap, so a block cannot be broken into a table
  once it is mapped, and pages are donated back and forth at PAGE_SIZE
  granularity. The page table pool is sized to cover all of memory at
  that granularity.

- MMIO is mapped with the largest block that fits, as it is assumed to
  cover the whole IAS that is not memory while pKVM only reserves 1G
  for the page table. MMIO is never donated at runtime, so it is never
  unmapped and never needs a block to be split.

The TLB maintenance ops are left as stubs, they are implemented in the
next patch.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 153 +++++++++++++++++-
 1 file changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 943ffef0bb4a..75b2b1477a4f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -15,6 +15,9 @@
 #include "../arm-smmu-v3.h"
 #include "../arm-smmu-v3-common-lib.h"
 
+#include <linux/io-pgtable.h>
+#include "../../../io-pgtable-arm.h"
+
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
@@ -72,6 +75,9 @@ static inline u64 hyp_clock_ns(void)
 	__ret;								\
 })
 
+/* Protected by host_mmu.lock from core code. */
+static struct io_pgtable *idmap_pgtable;
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -217,6 +223,24 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static void smmu_tlb_flush_walk(unsigned long iova, size_t size,
+				size_t granule, void *cookie)
+{
+	/* TBD: Invalidate the range in all the SMMUs. */
+}
+
+static void smmu_tlb_add_page(struct iommu_iotlb_gather *gather,
+			      unsigned long iova, size_t granule,
+			      void *cookie)
+{
+	/* TBD: Invalidate the granule in all the SMMUs. */
+}
+
+static const struct iommu_flush_ops smmu_tlb_ops = {
+	.tlb_flush_walk = smmu_tlb_flush_walk,
+	.tlb_add_page	= smmu_tlb_add_page,
+};
+
 static int smmu_abort_gbpa(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -483,6 +507,38 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	return ret;
 }
 
+static int smmu_init_pgt(void)
+{
+	/* Default values overridden based on SMMUs common features. */
+	struct io_pgtable_cfg cfg = (struct io_pgtable_cfg) {
+		.tlb = &smmu_tlb_ops,
+		.pgsize_bitmap = ~0UL,
+		.ias = 48,
+		.oas = 48,
+		.coherent_walk = true,
+		.quirks = IO_PGTABLE_QUIRK_NO_WARN,
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
+	/* At least PAGE_SIZE must be supported by all SMMUs */
+	if ((cfg.pgsize_bitmap & PAGE_SIZE) == 0)
+		return -EINVAL;
+
+	ops = pkvm_alloc_io_pgtable_ops(ARM_64_LPAE_S2, &cfg, NULL);
+	if (!ops)
+		return -ENOMEM;
+	idmap_pgtable = io_pgtable_ops_to_pgtable(ops);
+	return 0;
+}
+
 /* Called while the host is still trusted. */
 static int smmu_init(void)
 {
@@ -513,7 +569,10 @@ static int smmu_init(void)
 			goto out_reclaim_smmu;
 	}
 
-	return 0;
+	ret = smmu_init_pgt();
+	if (ret)
+		goto out_reclaim_smmu;
+	return ret;
 
 out_reclaim_smmu:
 	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
@@ -1011,8 +1070,100 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
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
+			 * - MMIO: Unlike memory, pKVM allocates 1G for all MMIO, while
+			 *   the MMIO space can be large, as it is assumed to cover the
+			 *   whole IAS that is not memory, we have to use block mappings,
+			 *   that is fine for MMIO as it is never donated at the moment,
+			 *   so we never need to unmap MMIO at the run time triggering
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
+
+			if (ret == -EEXIST) {
+				/*
+				 * It is possible to get EEXIST when a VM dies with pages
+				 * in a shared state.
+				 */
+				ret = 0;
+				size -= pgsize;
+				start += pgsize;
+				continue;
+			}
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
2.56.0.176.g3575e65682-goog

