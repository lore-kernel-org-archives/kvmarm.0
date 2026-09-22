Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51C15581E6
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082815; cv=none; b=Bns2B4xKjtDROPcK6P/+orCGlzHWYTB68JdPM/FQsRxNQf1xblkhO8+GUeGz7KxtjeZmJ8yy5lVofInXz0w8v4D88tZ8X1gy6r2c6WhItrj3X9PvRavGYzZ6f0dsYyvZh9Ay9ka+Qz4x67uMLUvHbmBrkN0U4EJseg5ZHMA7aLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082815; c=relaxed/simple;
	bh=h3MWy8FQu9HQqm+azwu7dF3FORvtZ6BG/l5MhlF23Vk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=d2JYtZG90Rk3zWRnAq5Ak1Gc70MTfG5yi09TknD/TgqxDNY60C4ZpUKT7lkHAP0qX0I747un0gMa8jfVNrVpEhrrr2LiQmERxhqBoctWoyQngjGkUewkOSIrbLcJD4fBbWmdWOhoROh5lcpmcH7PAbzWeio/JEAleSx+5wlhcqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mf26uVMa; arc=none smtp.client-ip=209.85.128.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mf26uVMa"
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-490a767c7dcso31190145e9.2
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082810; x=1790687610; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LSo/cDlJ7ohD2G3UI5KuRXiO2Rxr2FOcqemAL7pGINk=;
        b=mf26uVMa5OIqRh69qwtKZfjC2GXIKtaz5m3y2yeqMZvwbupxQxTbEgHwaO15QztUBV
         JkM4gthWDmdZ0tqXhQdSkFzI7Wuz+u9tMe05USONYSz+FIZYXu8i069Q0cngy9bLv2pz
         iOtJYOMP6AAT+uSMrXqUbR0hGz3OnQoz2OKp3HnQ7lfAmJxwJPYQr32SzEFngOSEHA9o
         Kd/0kNQOwNt8dHu9naWHJD3B2Lorko9QVNTUkzEZj0sRzEcqq3aU5J7Sa1lBCmAsoqvB
         gojvJTUNwDG+/wcZ45JEXYfRq3Omqpw0dUGPRnUFQTo34IVJLlkcyEpSLAiRSGFzavTG
         KBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082810; x=1790687610;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LSo/cDlJ7ohD2G3UI5KuRXiO2Rxr2FOcqemAL7pGINk=;
        b=nuwGru0gk9Of5ikqRYX5bQqVVS6bFe1xlZym17EDsYlFvAT5aLHI/wrTNizgDFyGTm
         J7UNrsN+VXHdRNCo03iVUCbebIe5UhsH8WasUhe274R69j5jZXhMYqlblwGEojImb9gB
         /+rPDSJh+DVYNeOKY/HKJ+FvOQApTl+7l4WTq8K5N06GmQuMZVZA7ZiIQ1EiZXyEn272
         75fuCQaWIhi8TSqogdjV8U8aeHb7jGubRmGlQuBC1ByioB2mtUvTn0tDvJ2l59c0rQwy
         97WNTeZ+/L8E/ilkVNbEsgi/ULsjBhlycpeYvrkBf8h4aKw10nfe76Q0k/Mt7c3Vm9+r
         /XHg==
X-Forwarded-Encrypted: i=1; AKwUvByudOkFrRbt0go+fMv/9K9zsANUAGVb+8XkTm9Vy5wEteC7214myh6xjDYGCuYvAzmftZeBFqY=@lists.linux.dev
X-Gm-Message-State: AFuF++mR5DuE550rMUQJEZQdY4b6bDkrw3I7qNJyRObyMcElZRcOJyQw
	khMvyWg7zUD6NWLa9WhxBA+BJY5BDbpKoMkGHI+n/0v0CvqJEYxC7zhoC3GPHjxgLPmItz5cMXB
	wy8+ZnYr2ry83Sw==
X-Received: from wmdd15.prod.google.com ([2002:a05:600c:a20f:b0:49e:78cc:d2e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f0b:b0:49d:1df6:2592 with SMTP id 5b1f17b1804b1-49fc5750c61mr171840065e9.21.1790082809523;
 Tue, 22 Sep 2026 06:13:29 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:55 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-23-smostafa@google.com>
Subject: [PATCH v8 22/25] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
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
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 153 +++++++++++++++++-
 1 file changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 6e023e968ed3..6f0ea3a4e48d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -14,6 +14,9 @@
 #include "../arm-smmu-v3.h"
 #include "../arm-smmu-v3-common-lib.h"
 
+#include <linux/io-pgtable.h>
+#include "../../../io-pgtable-arm.h"
+
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
@@ -70,6 +73,9 @@ static inline u64 hyp_clock_ns(void)
 	__ret;								\
 })
 
+/* Protected by host_mmu.lock from core code. */
+static struct io_pgtable *idmap_pgtable;
+
 static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 {
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
@@ -215,6 +221,24 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
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
@@ -480,6 +504,38 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -509,7 +565,10 @@ static int smmu_init(void)
 
 	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
 
-	return 0;
+	ret = smmu_init_pgt();
+	if (ret)
+		goto out_reclaim_smmu;
+	return ret;
 
 out_reclaim_smmu:
 	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
@@ -998,8 +1057,100 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
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
2.55.0.1082.g2b9226bbc0-goog

