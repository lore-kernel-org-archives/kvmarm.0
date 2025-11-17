Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6189D32E135
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405338; cv=none; b=LX2gr0gczhcnUMF3Le0OMShGqk4h7HYNJn/6fdPH1BhmgyZoReUJORY3iL0yJRSzcNyiovoGFpQbfnLylwjLaTFDZiJ9fp1mxzzZ5PuEH64E5Qx4o2DtJrw4KfAz0gbrTEtQ0paY7aNphjG0eFk79t4D2E8KxISgh8s5WXdApAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405338; c=relaxed/simple;
	bh=yCEYZh2AGSeMppy6W4pQzDAJmahJxTs69c+HgyMSqIs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jWypQOhTqihRCEtC2CtxpgIDrKQtpcWdiFankGvsT+lPuPD64TA5ymTyadJPA+NwihuYvAgopzs7nhGNPCntYkLZ34JiUKTlExXtgOI0XXJvb1bFqQLqpiAuRk6FIB7yw87YVwS6p+j+gzPXXcfyd5piL4FwlC2E3LmqF9IT77Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uVrI+nkX; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uVrI+nkX"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64165abd7ffso5632528a12.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405332; x=1764010132; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=31DOoq9hxxOVuOmnZkKoNNzWo0+aj1CFvIYXfA+a1tI=;
        b=uVrI+nkX7nMh79KtY1gLoBCCHqtrdskKSQ+ZuV8qAK29auoUxDCWfbmBWGVFaO0ZGP
         YP7YFlpbmk+BoXcrfONqrZXKjAPEbPPfzNX3sYZBAmk6+RXB4XbAyUAugJwsZIZSs1xl
         tmoRowuMYTmIdT7gM9viV8fLEV8eTCTwCO91ouiCDqLvV2oWPtFz6UEtx0nzueoYLMWM
         WhY2TbtfVZbC4NrVY0HX9p0R534jGfa0XQt9i4T4NbGch4+e7FMaoh73cb+uk/v0Hpqo
         RgUEGjNBgO2GdaqwzbxZqOdmxQo+bN2lNoEs6eOuMMw8H0qgLT8kg3KX3NQDO9RjFfyA
         5Y6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405332; x=1764010132;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31DOoq9hxxOVuOmnZkKoNNzWo0+aj1CFvIYXfA+a1tI=;
        b=Ot6jq+UvMKd1W7igUQl4AdkxeLI5svB0MosJIpdmSsTcfDVnYyuYCYfUqhapi5v2k/
         IHSfgtewspqaqKniXt8D2A7U8GnoEuasIIPugniNAOo/8k1cqndJHptTDKbSMxqrpO1w
         DSAt0wMhHqIImAASHBAu/MTJzNJSQ062GDdLspHIDmQ8R/gVUZUWUlAioKLhlih4JFYw
         4g1h2JQp0C1MzyCqvBY+EofCafqOCpjOuxoMotXqFkB87rbupfpqTE7dr8gZkyHqt/OF
         UzReghspZnmoJYnIbD8XDwJ8Q4zCanwXsLCwjx8JagR5HIuevR25fiCbzAH1KH/zdIzG
         nqTg==
X-Forwarded-Encrypted: i=1; AJvYcCX9BEMRWYSzDiGZMFKn9LP9YeGJHj5tdyXM0Xt05Xjeq7Niz5iYXCzNUNK4+EVHWJm+IDfVF58=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJaZ6lrYSPRhCRZPfb0/5AQggQlzXwR5FnPwEhu6GWgxlDZVMg
	xlWfiY5UsGZo9FecCVyGa9NpMJUEo3dRcSF0e51Xjo7ReK7SiEWk6kmc3QTc+GuozTlk9l+BlEX
	o5fv2E22zcnwvkw==
X-Google-Smtp-Source: AGHT+IHvu5Pm7T3ulD8svZ9/ewILArBTgbOobiFYwmLzMkQ3ahrrnLUgoZ1utD9YIAk9Ft4XjCqCnrq1nS8Y+Q==
X-Received: from edy24.prod.google.com ([2002:a05:6402:5358:b0:641:76b8:383a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:5213:b0:641:72a8:c91c with SMTP id 4fb4d7f45d1cf-64350e9b333mr11728047a12.27.1763405332073;
 Mon, 17 Nov 2025 10:48:52 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:13 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-27-smostafa@google.com>
Subject: [PATCH v5 26/27] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Based on the callbacks from the hypervisor, update the SMMUv3
Identity mapped page table.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 189 +++++++++++++++++-
 1 file changed, 187 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 0a2ce6c06f4f..f0075f9a0947 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -12,6 +12,9 @@
 
 #include "arm_smmu_v3.h"
 
+#include <linux/io-pgtable.h>
+#include "../../../io-pgtable-arm.h"
+
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
@@ -53,6 +56,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	__ret;							\
 })
 
+/* Protected by host_mmu.lock from core code. */
+static struct io_pgtable *idmap_pgtable;
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -192,7 +198,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 			 smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -204,6 +209,78 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
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
+			       idmap_pgtable->cfg.pgsize_bitmap,
+			       smmu->features & ARM_SMMU_FEAT_RANGE_INV,
+			       smmu, __smmu_add_cmd, NULL);
+	return smmu_sync_cmd(smmu);
+}
+
+static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t granule,
+			       bool leaf)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_TLBI_S2_IPA,
+		.tlbi = {
+			.leaf = leaf,
+			.vmid = 0,
+		},
+	};
+	struct arm_smmu_cmdq_ent cmd_s1 = {
+		.opcode = CMDQ_OP_TLBI_NH_ALL,
+		.tlbi = {
+			.vmid = 0,
+		},
+	};
+	struct hyp_arm_smmu_v3_device *smmu;
+
+	for_each_smmu(smmu) {
+		hyp_spin_lock(&smmu->lock);
+		/*
+		 * Don't bother if SMMU is disabled, this would be useful for the case
+		 * when RPM is supported to avoid thouching the SMMU MMIO when disabled.
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
@@ -454,6 +531,40 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
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
+		cfg.ias = min(cfg.ias, smmu->ias);
+		cfg.oas = min(cfg.oas, smmu->oas);
+		cfg.pgsize_bitmap &= smmu->pgsize_bitmap;
+		cfg.coherent_walk &= !!(smmu->features & ARM_SMMU_FEAT_COHERENCY);
+	}
+
+	/* Avoid larger input size as this is identity mapped. */
+	cfg.ias = min(cfg.ias, cfg.oas);
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
 static int smmu_init(void)
 {
 	int ret;
@@ -475,7 +586,7 @@ static int smmu_init(void)
 
 	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
 
-	return 0;
+	return smmu_init_pgt();
 
 out_reclaim_smmu:
 	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
@@ -798,8 +909,82 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
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
+	/* Return the larget page size that fits. */
+	return BIT(__fls(pgsizes));
+}
+
 static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
 {
+	size_t size = end - start;
+	size_t pgsize = PAGE_SIZE, pgcount;
+	size_t mapped, unmapped;
+	int ret;
+	struct io_pgtable *pgtable = idmap_pgtable;
+	struct iommu_iotlb_gather gather;
+
+	end = min(end, BIT(pgtable->cfg.oas));
+	if (start >= end)
+		return;
+
+	if (prot) {
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
+			if (!mapped || ret)
+				return;
+		}
+	} else {
+		/* Shouldn't happen. */
+		WARN_ON(prot & IOMMU_MMIO);
+		while (size) {
+			pgcount = size / pgsize;
+			unmapped = pgtable->ops.unmap_pages(&pgtable->ops, start,
+							    pgsize, pgcount, &gather);
+			size -= unmapped;
+			start += unmapped;
+			if (!unmapped)
+				break;
+		}
+		/* Some memory were not unmapped. */
+		WARN_ON(size);
+	}
 }
 
 /* Shared with the kernel driver in EL1 */
-- 
2.52.0.rc1.455.g30608eb744-goog

