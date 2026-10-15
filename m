Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7416B582B9C
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094972; cv=none; b=N0Kk6N0qJqbRvsMKldiWsoTiSNPpMb0huBKER8w8aEVK6FPKDrddkl7ilF1N6RA3CCYm57TMCri3db9gork3QRCrtQGlsO+HLkk2ksQPvwfxA7tAMeIoabhlUfJ1zicN96i2xIt3CYtBflTn3a1iAjAq5cKWgv/UyXXxGrqEnIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094972; c=relaxed/simple;
	bh=wzECFTgv0gbRiroiT6ZEgspnN/KjS2YQoxW9c4Mnl1s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NdBAErgsK147xKaH0BuPxlAh6QCZSDYAbvIBXJpbeNzo8MPycn1D8odlz0jBX84tLyB+w+lXtbqskxOL79gFJ68MalNds4knAg3xXGM7WsSt3iADZXw8RdQW6Vi74GH0rgUJG5u5qSTks3Eg0TuEzX/nMVM7LzIec7w5m/R8Qkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKsppQGz; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKsppQGz"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4a1721559b4so58751525e9.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094968; x=1792699768; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tp66Frxalg0sY1/x9PE5w46OtuySfbUHfMRz44KKCn8=;
        b=sKsppQGzy9yrcea6q4sgQbNqkeArR1gHwEb2fgYWLgM98UQwSLlbRwR6tW7TjpCgV1
         rgttq1McZE2N8dk1NKccCAxHM99gT3x7qrGkHnwCH0kUKNaNSpEPrPqTbVmZKA6cg0Jf
         +ubhhB1yP3j70QfFufJIF6pyhp+erKfbBIXfMIu0XwUnBbLG0kMWvsWTHh/bWpQbMJB7
         5/C02TEhWj9w8X2ue7LQeJMQi1WeH1w35pmZ5xD1migvLGMn8a9IUIevQmGNs8YIzidT
         PLXFXzPUPqRJzh7dJUpW8lRcnW/bZ8qRAgmU3fBNquCi5NDvO7r9foFq8BVM/AVVMmWx
         1FxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094968; x=1792699768;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tp66Frxalg0sY1/x9PE5w46OtuySfbUHfMRz44KKCn8=;
        b=nfcWUep4d22xJOG7Fs//JWoNQxV69gj/3vo62Xlzr1SJj8Dxuy4VxBHxqVh5q2H3+G
         5TpUcFx8JyOZxxkPVUOky/8xjCKMoq6OxSaW5PBjJfoIbjMAoghxUQnimFLOtvgbB09w
         ctoxPcPgQsnNe78rRmgDJJE8H7AtHOqYwQSouvLtjMm2HbRue8aJaPLCZTD03jJFyG21
         b0V5Q4KRE2YL+20a+Skqa153BqE/muDRVs7WFOne6bvKhdhYaV0ldHydJPCB9ZS0FqJI
         OGNC6Q1vJDZCz/Vi/jJoU2JmEmFYAUZjvjUAVplwODwbe1CEkCrkV8RUrb+xfrjmBtJK
         gtMA==
X-Forwarded-Encrypted: i=1; AKwUvBynhIVQaPAj/uW+doYppA0KvZGoIy7/nuu6AcMAPNB/L15Br//YIZ/vlQ85fhoHy2q2KA4Jx5Q=@lists.linux.dev
X-Gm-Message-State: AFq9FYKCDdoCdRW6pFBsCx5eQKmKCT4pusiipMFLeEFFI6ZU768cDIvA
	RZRROT6PCjMQZb85ZItqACFSwaB2xTJhq/tliojIxpARL56gXJCrEFlltJBaMYrtlmAe2VIBRSN
	4LW0lrzQ5COK1Ww==
X-Received: from wmbz11.prod.google.com ([2002:a05:600c:c08b:b0:4a1:88e2:2dde])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4689:b0:4a0:1cfd:321 with SMTP id 5b1f17b1804b1-4a18e4a9b31mr433958165e9.12.1792094967596;
 Thu, 15 Oct 2026 13:09:27 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:45 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-15-smostafa@google.com>
Subject: [PATCH v9 14/25] iommu/arm-smmu-v3-kvm: Shadow the command queue
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

At boot, allocate a command queue per SMMU which is used as a shadow
by the hypervisor.

The command queue size is 64K which is more than enough, as the
hypervisor would consume all the entries per a command queue prod
write, which means it can handle up to 4096 at a time.

Then, the host command queue needs to be pinned in a shared state, so
it can't be donated to VMs, and avoid tricking the hypervisor into
accessing them. This is done each time the command queue is enabled,
and undone each time the command queue is disabled.
The hypervisor won't access the host command queue when it is disabled
from the host.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c   |  25 ++++
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 127 +++++++++++++++++-
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |  11 +-
 3 files changed, 161 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
index 5c5f0ff455e3..d7f2e73add7f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
@@ -16,6 +16,8 @@
 #include "arm-smmu-v3.h"
 #include "pkvm/arm-smmu-v3-hyp.h"
 
+#define SMMU_KVM_CMDQ_ORDER		get_order(MAX(SZ_64K, PAGE_SIZE))
+
 static size_t kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device *kvm_arm_smmu_array;
 static size_t kvm_arm_smmu_cur;
@@ -23,6 +25,15 @@ static size_t kvm_arm_smmu_cur;
 static void __init kvm_arm_smmu_array_free(void)
 {
 	int order;
+	int i;
+
+	for (i = 0 ; i < kvm_arm_smmu_cur ; ++i) {
+		struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[i];
+
+		if (smmu->cmdq.base_dma)
+			free_pages((unsigned long)phys_to_virt(smmu->cmdq.base_dma),
+				   SMMU_KVM_CMDQ_ORDER);
+	}
 
 	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
 	free_pages((unsigned long)kvm_arm_smmu_array, order);
@@ -67,6 +78,7 @@ static int __init smmuv3_nesting_probe(struct platform_device *pdev)
 	struct hyp_arm_smmu_v3_device *smmu;
 	struct device *dev = &pdev->dev;
 	struct resource *res;
+	void *cmdq_base;
 
 	/* Only device tree, ACPI not supported. */
 	if (!dev->of_node)
@@ -94,6 +106,19 @@ static int __init smmuv3_nesting_probe(struct platform_device *pdev)
 	smmu->mmio_addr = res->start;
 	smmu->mmio_size = resource_size(res);
 
+	/*
+	 * Allocate the shadow command queue, it doesn't have to be the same
+	 * size as the host.
+	 * Only populate base_dma and llq.max_n_shift, the hypervisor will init
+	 * the rest.
+	 */
+	cmdq_base = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, SMMU_KVM_CMDQ_ORDER);
+	if (!cmdq_base)
+		return -ENOMEM;
+
+	smmu->cmdq.base_dma = virt_to_phys(cmdq_base);
+	smmu->cmdq.llq.max_n_shift = SMMU_KVM_CMDQ_ORDER + PAGE_SHIFT - CMDQ_ENT_SZ_SHIFT;
+
 	if (of_dma_is_coherent(dev->of_node))
 		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index d95b459a796a..02e7c6175832 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -23,12 +23,69 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
 	     (smmu)++)
 
+#define cmdq_size(cmdq)	((1UL << ((cmdq)->llq.max_n_shift)) * CMDQ_ENT_DWORDS * 8)
+
+static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
+}
+
+/*
+ * Host structures the hypervisor reads (CMDQ, STE) are shared and pinned:
+ * - Prevent the host from donating this memory.
+ * - Map them in the hypervisor s1 page tables.
+ */
+static int smmu_share_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base = addr & PAGE_MASK;
+	int i, ret;
+
+	for (i = 0; i < nr_pages; ++i) {
+		if (__pkvm_host_share_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT)) {
+			while (i--)
+				__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+			return -EPERM;
+		}
+	}
+
+	ret = hyp_pin_shared_mem(hyp_phys_to_virt(base),
+				 hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+	if (ret) {
+		for (i = 0; i < nr_pages; ++i)
+			__pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+	}
+
+	return ret;
+}
+
+static int smmu_unshare_pages(phys_addr_t addr, size_t size)
+{
+	size_t nr_pages = PAGE_ALIGN(size + (addr & ~PAGE_MASK)) >> PAGE_SHIFT;
+	phys_addr_t base = addr & PAGE_MASK;
+	int i, ret;
+
+	hyp_unpin_shared_mem(hyp_phys_to_virt(base),
+			     hyp_phys_to_virt(base + nr_pages * PAGE_SIZE));
+
+	for (i = 0; i < nr_pages; ++i) {
+		ret = __pkvm_host_unshare_hyp((base + i * PAGE_SIZE) >> PAGE_SHIFT);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /* Put the device in a state that can be probed by the host driver. */
 static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	WARN_ON(__pkvm_hyp_donate_host_mmio(hyp_phys_to_pfn(smmu->mmio_addr),
 					    smmu->mmio_size >> PAGE_SHIFT,
 					    (unsigned long)smmu->base));
+	if (smmu->cmdq.base)
+		WARN_ON(__pkvm_hyp_donate_host(smmu->cmdq.base_dma >> PAGE_SHIFT,
+					       PAGE_ALIGN(cmdq_size(&smmu->cmdq)) >> PAGE_SHIFT));
 	smmu->base = NULL;
 }
 
@@ -62,6 +119,7 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
 	ret = arm_smmu_device_idr1_probe(smmu, &reg);
 	if (ret)
 		return ret;
+	smmu->cmdq_max_shift = FIELD_GET(IDR1_CMDQS, reg);
 
 	arm_smmu_device_idr3_probe(smmu);
 	arm_smmu_device_idr5_probe(smmu);
@@ -73,6 +131,33 @@ static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+/*
+ * The kernel part of the driver allocates and zeroes the shadow cmdq. Take
+ * ownership of it and program it into the hardware.
+ */
+static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
+{
+	size_t cmdq_nr_pages;
+	int ret;
+
+	smmu->cmdq.llq.max_n_shift = min(smmu->cmdq.llq.max_n_shift, smmu->cmdq_max_shift);
+	cmdq_nr_pages = PAGE_ALIGN(cmdq_size(&smmu->cmdq)) >> PAGE_SHIFT;
+	ret = __pkvm_host_donate_hyp(smmu->cmdq.base_dma >> PAGE_SHIFT, cmdq_nr_pages);
+	if (ret)
+		return ret;
+
+	smmu->cmdq.base = hyp_phys_to_virt(smmu->cmdq.base_dma);
+	smmu->cmdq.prod_reg = smmu->base + ARM_SMMU_CMDQ_PROD;
+	smmu->cmdq.cons_reg = smmu->base + ARM_SMMU_CMDQ_CONS;
+	smmu->cmdq.q_base = smmu->cmdq.base_dma |
+			    FIELD_PREP(Q_BASE_LOG2SIZE, smmu->cmdq.llq.max_n_shift);
+	smmu->cmdq.ent_dwords = CMDQ_ENT_DWORDS;
+	writel_relaxed(0, smmu->cmdq.prod_reg);
+	writel_relaxed(0, smmu->cmdq.cons_reg);
+	writeq_relaxed(smmu->cmdq.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	unsigned long haddr;
@@ -92,8 +177,16 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	smmu->base = (void __iomem *)haddr;
 	ret = smmu_probe(smmu);
 	if (ret)
-		smmu_deinit_device(smmu);
+		goto out_deinit;
 
+	ret = smmu_init_cmdq(smmu);
+	if (ret)
+		goto out_deinit;
+
+	return 0;
+
+out_deinit:
+	smmu_deinit_device(smmu);
 	return ret;
 }
 
@@ -132,6 +225,23 @@ static int smmu_init(void)
 	return ret;
 }
 
+static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
+
+	smmu->cmdq_host.llq.max_n_shift = min(shift, smmu->cmdq_max_shift);
+	smmu->cmdq_host.base_dma = smmu->cmdq_host.q_base & Q_BASE_ADDR_MASK;
+	smmu->cmdq_host.base_dma &= ~(cmdq_size(&smmu->cmdq_host) - 1);
+	WARN_ON(smmu_share_pages(smmu->cmdq_host.base_dma,
+				 cmdq_size(&smmu->cmdq_host)));
+}
+
+static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
+				   cmdq_size(&smmu->cmdq_host)));
+}
+
 static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			     struct user_pt_regs *regs,
 			     u64 esr, u32 off)
@@ -158,6 +268,14 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		break;
 	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		if (is_write) {
+			/* Not allowed by the architecture */
+			if (is_cmdq_enabled(smmu))
+				break;
+			smmu->cmdq_host.q_base = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_CMDQ_PROD:
 	case ARM_SMMU_CMDQ_CONS:
 	case ARM_SMMU_STRTAB_BASE:
@@ -170,9 +288,16 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			break;
 
 		if (is_write) {
+			bool last_cmdq_en = is_cmdq_enabled(smmu);
+
 			/* Enforce ATS checks. */
 			if (smmu->features & ARM_SMMU_FEAT_ATS)
 				val |= CR0_ATSCHK;
+			smmu->cr0 = val;
+			if (!last_cmdq_en && is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_enable(smmu);
+			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
+				smmu_emulate_cmdq_disable(smmu);
 			mask = read_write;
 		} else {
 			mask = read_write & ~CR0_ATSCHK;
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index afc3ca791583..3903ae358555 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -8,6 +8,8 @@
 #include <nvhe/spinlock.h>
 #endif
 
+#include "../arm-smmu-v3.h"
+
 /**
  * struct hyp_arm_smmu_v3_device - SMMUv3 instance owned by the hypervisor
  * @mmio_addr:		Physical address of the SMMU registers
@@ -21,7 +23,10 @@
  * @lock:		Lock to protect SMMU emulation
  * @hw_lock:		Lock to protect SMMU HW (e.g. CMDQ)
  *			Order smmu.lock => host_mmu.lock => smmu.hw_lock
- *
+ * @cmdq:		CMDQ as observed by HW
+ * @cmdq_host:		Host view of the CMDQ, only q_base, base_dma and llq used
+ * @cmdq_max_shift:	Max shift for the CMDQ probed from HW
+ * @cr0:		Last value of CR0
  * @mmio_addr, @mmio_size and ARM_SMMU_FEAT_COHERENCY are filled by the host
  * before de-privilege, the rest by the hypervisor driver.
  */
@@ -41,6 +46,10 @@ struct hyp_arm_smmu_v3_device {
 	u32			lock;
 	u32			hw_lock;
 #endif
+	struct arm_smmu_queue	cmdq;
+	struct arm_smmu_queue	cmdq_host;
+	u32			cmdq_max_shift;
+	u32			cr0;
 };
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-- 
2.56.0.176.g3575e65682-goog

