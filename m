Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0242D34DCC3
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640373; cv=none; b=IlLpR4HxAbDyt8w2cMfUnbtX5cp+Mkjq/nVuMNvq2GOtPy/AlIaXxz1q38nOBmfbdSxEdxMqqGmJqjzdkb7SAwXUHQDlk4lwh4DdvWQ0A/UYjGhZurp/vxSnpqWv301B2mzPVo8IsuWATtH2wp8YH205CTQGNwtqAm8PLcc0SIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640373; c=relaxed/simple;
	bh=pfRmcOYtcTv/5f7EQKmMO5NvR2S3xc1JUwdDGpRDJlc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ss5MxuFJqMyjOF1uKvtN2PYFMtvI649IBt6AiJDEBjzrPmBuZC80phNKPeFXuVVxvXtyf4mBjyZWTnj+NDjqQGac7m5q34ikGJbzciENwghAnIctyCnDni53CqY0CR5UnM9f4DhYBlBb2E8JV50r9gU/VC1J+rpufCRGmcJa0F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0BVOMlpA; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0BVOMlpA"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45a1b0015aaso22034345e9.0
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640369; x=1756245169; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ykEL2Fz+GpEcyIy6HAU7e6ae/ECc9Mn8DWNDC0CC2vc=;
        b=0BVOMlpAwjFV26QS8CLLI1C4iU6A13kek21sDehyujCeNvHaoP2UNLkQyIkR5WcoYU
         RM4sDvDgUGEz2L/yKlkpDrMKg8MOQ4DeObJ0H9H8iEFQw9VKM6uKbItY6MHmw/bygpsS
         FWeFWY664lFL6IKzr2o9g72Dh6YPYM4XG04BpqwnYKeFLt8eYdxGAKp4+vMJv27fpwQO
         i+n5o4FmsfI7ImZjLLCFXST4cptHNNg/6LbqUrcbsc8vRus236ZBJDGy73Aov9b8QypR
         aaFhMVrV1I4y2O89A2iUiVFkbKsRqAGY093djcsz6PV6yQV+5wvRoLcRdKTYA1zjOaXC
         o4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640369; x=1756245169;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ykEL2Fz+GpEcyIy6HAU7e6ae/ECc9Mn8DWNDC0CC2vc=;
        b=fZtxtRsdIDC+aHYnMGgADkwZEspOqKqrBWhwGTsRy0Io0qgR6lfZLF0KAnaflEo/Kn
         e0DdsApXrzFCBtcyJz9iJrY1x3MvVC57gB0APuBANLuuiW6zzBrVLZTIWRhTGwpiB0aR
         IXSXOaTALFsReraQ+9CzgSbdD8IbsMtWZb7BVEhzhmqjlJjVSgoxQpJ+MUgIvlqsxgtR
         MI8gyEL8I7KLFREaQBVoVoemVLYjg2Vt7OTfuw6+cVO+iNj8rV9tFFqTzoQSNZh+2Bac
         kBZNZ++yxex1Zz3eIl4WPgsYQBWpTEcEtA1nbdhDDidhtxev0ER6hwRmOAMjUxCP0v4O
         nrLw==
X-Forwarded-Encrypted: i=1; AJvYcCUOALsUV59UgWEZQo5IEDhz2hE1ZGeyoMZyvbpCkgkL9gXCwpxtsxYKmsSDCVwLc0JtIl/Tg0A=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1geT9jitq/N08vc+Nh8D3tLt3hkK29Oxn2SS3Km2CHU57+jqU
	O4wYhl+an2UxdI66t/kXyWuNw1/OIeP1KaoQP2mSXbS2A770tUGm448iX+TZ98AwMy6R7xcRzQD
	IN1yvfwR9AKrhyg==
X-Google-Smtp-Source: AGHT+IFhJzb4rLm89vMz9Kb+NMtcA3enxs1xJ/ZH3zd93j7HhNxOeMD+CCA4otMjkpxLYE9Tct7Cp4AlPuNvpA==
X-Received: from wmbhj15.prod.google.com ([2002:a05:600c:528f:b0:459:db93:61f0])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e56:b0:458:c059:7da0 with SMTP id 5b1f17b1804b1-45b47caca71mr1829455e9.2.1755640369505;
 Tue, 19 Aug 2025 14:52:49 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:55 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-28-smostafa@google.com>
Subject: [PATCH v4 27/28] iommu/arm-smmu-v3-kvm: Shadow the CPU stage-2 page table
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Based on the callbacks from the hypervisor, update the SMMUv3
Identity mapped page table.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 171 +++++++++++++++++-
 1 file changed, 169 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index db9d9caaca2c..2d4ff21f83f9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -11,6 +11,7 @@
 #include <nvhe/trap_handler.h>
 
 #include "arm_smmu_v3.h"
+#include "../../../io-pgtable-arm.h"
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
@@ -58,6 +59,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	smmu_wait(_cond);					\
 })
 
+/* Protected by host_mmu.lock from core code. */
+static struct io_pgtable *idmap_pgtable;
+
 /* Transfer ownership of memory */
 static int smmu_take_pages(u64 phys, size_t size)
 {
@@ -166,7 +170,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait_event(smmu, smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -178,6 +181,66 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static void __smmu_add_cmd(struct hyp_arm_smmu_v3_device *smmu, void *unused,
+			   struct arm_smmu_cmdq_ent *cmd)
+{
+	WARN_ON(smmu_add_cmd(smmu, cmd));
+}
+
+static int smmu_tlb_inv_range_smmu(struct hyp_arm_smmu_v3_device *smmu,
+				   struct arm_smmu_cmdq_ent *cmd,
+				   unsigned long iova, size_t size, size_t granule)
+{
+	arm_smmu_tlb_inv_build(cmd, iova, size, granule,
+			       idmap_pgtable->cfg.pgsize_bitmap, smmu,
+			       __smmu_add_cmd, NULL);
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
+		WARN_ON(smmu_tlb_inv_range_smmu(smmu, &cmd, iova, size, granule));
+		WARN_ON(smmu_send_cmd(smmu, &cmd_s1));
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
@@ -434,6 +497,37 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -455,7 +549,7 @@ static int smmu_init(void)
 
 	BUILD_BUG_ON(sizeof(hyp_spinlock_t) != sizeof(u32));
 
-	return 0;
+	return smmu_init_pgt();
 
 out_reclaim_smmu:
 	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
@@ -789,8 +883,81 @@ static bool smmu_dabt_handler(struct user_pt_regs *regs, u64 esr, u64 addr)
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
+							    pgsize, pgcount, NULL);
+			size -= unmapped;
+			start += unmapped;
+			if (!unmapped)
+				return;
+		}
+		/* Some memory were not unmapped. */
+		WARN_ON(size);
+	}
 }
 
 /* Shared with the kernel driver in EL1 */
-- 
2.51.0.rc1.167.g924127e9c0-goog

