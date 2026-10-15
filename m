Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FD058E2D1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094978; cv=none; b=SHNJaYRGutshINleK8O9JVCSafpsrfqH+/zuZ/3o53RfT8qo8bh9bykPMNbRRQD5Uk1q3Cdf1qoJf+7s/IevknHZ9f7ZPzbV9gm3XY0Ssz0AckaTq153JEWd6eThQfPBv1K45FcvmLdegF3am0+Yt77KeP+3is9Hu0q+hISXJEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094978; c=relaxed/simple;
	bh=H1XJZkFETNlFizGY4gN5Rz/C+FYzCAV4WD+qe29jC30=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=GnxQwwe5SRPSWJZFiSx8dxUsPtKEz3Q5MxUqjq7xFjp8t3alfxhBAXw4Bz/7bUechPTXorTyMUpLJPDmuz2IrlmDqnKtyE3ZJ9ZPV+a4Cai0j23Di13eeWiwoh8+JVNU2WBp8PQlRnLLiD9czK8j0fhRFbOu/1dkJQLx4SNceBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OK4prE7p; arc=none smtp.client-ip=209.85.208.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OK4prE7p"
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-6afa6850207so2980606a12.1
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094972; x=1792699772; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9TkbtrZkecnnvik8qD/P9yBzmRooaT/6w/h40hH+Qfk=;
        b=OK4prE7pOwwtE5FHQX/5jUyhUK4t0H4DEoVOsI6co0/0njTktkQUmfYY30x82/M/8c
         96HCRBBG68CYRXAYJ0Sdk7O/jv6tip1pvYDpRJ+yVC8OOMZGQF+d/50HOTXzf1LRdQQb
         9mAmSBd0ksOb5c3NYWg37+bTWearMcTr744u8c/uCeHG4vn1XS8039P/nRg7YcqwwyGH
         w2ain4WdI2aT1yR+bV6JQ7CMdNOYPifRK8mIFUpxxuyMEagR0CL/Zd67jxF2HCGCtH2g
         ishNSKc+cnm3uhi5ttd0GJ6+ol9zIfuRbC+RaLdc95m3LYvpgxrnkNPCEIyu4Fs/EAax
         8jJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094972; x=1792699772;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9TkbtrZkecnnvik8qD/P9yBzmRooaT/6w/h40hH+Qfk=;
        b=JyECw/FQTGSAFTqX3srB+TRT5Q0slyD8hlh+SbMsHZhyK2RkuCAGYKwF4SxFczxIzL
         E9KhZ3GdrmwjsHV2A9bOAzCG0xfBcoXhI6nyB+CShhZ+8nrxS0ZUXMcAO5fYUEiOO2wE
         WCwexKiSQ/cXSoG4Ce/ptG2CCwo72pJHmMuEVwyKHVYmZ6lzq0psyPj/861e12af+eLF
         xI2wO7IOvHsVfUFfUosSq8ID9mmnVbzxNxK3f7Hy/Cwsk/aYFEOAVBXaZ75JwCu8QGdq
         Zx8oMCJkoMIbYFXapSgwBHUXxa5i3jTGwZI80FbCgCNXwUzN4zWGrwhkijfYQMggbTna
         VjVQ==
X-Forwarded-Encrypted: i=1; AKwUvByunnX7fDid+eELA18kzJQc1uzsHnGYg1zZOAyBlM+hfOY6AX9NeSdLRxRr7Lr4gHq9v9kypUs=@lists.linux.dev
X-Gm-Message-State: AFq9FYK3CNY4c7xvEbASAFbFj3BszfKk04ImqPMjnuDDDtFd1x6UVEAc
	7LNPRYJmqrQBwUrzR0hfPRXwmWRaEx+/u9aPkTA9HbthgcE1xX5Vh9GDD4uMTHnuV9YjJLDO6uW
	IF5e4+gVGGXdQCQ==
X-Received: from edro22.prod.google.com ([2002:aa7:d3d6:0:b0:6ac:b91c:a379])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:42c3:b0:6a9:a3df:e4f1 with SMTP id 4fb4d7f45d1cf-6b17c2c4b13mr16130875a12.25.1792094971599;
 Thu, 15 Oct 2026 13:09:31 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:48 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-18-smostafa@google.com>
Subject: [PATCH v9 17/25] iommu/arm-smmu-v3-kvm: Shadow stream table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Allocate the shadow stream table per SMMU.
We choose the size of that table to be 1MB which is the
max size used by host in the case of 2 levels.

All the host writes are still passthrough for bisectability, that
is changed next where CFGI commands will be trapped and used to
update the shadow copy that will be used by the HW.

Similar to the command queue, the host stream table is
shared/unshared each time the SMMU is enabled/disabled.

Handling of L2 tables is also done in the next patch when
the shadowing is added.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c   |  21 ++-
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 122 ++++++++++++++++++
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |  11 ++
 3 files changed, 153 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
index d7f2e73add7f..09078a6c39b0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-pkvm-init.c
@@ -17,6 +17,13 @@
 #include "pkvm/arm-smmu-v3-hyp.h"
 
 #define SMMU_KVM_CMDQ_ORDER		get_order(MAX(SZ_64K, PAGE_SIZE))
+/*
+ * Use the max value of L1 the kernel uses, that also covers the worst case
+ * for linear tables as it is mandatory according to the spec to support 2
+ * lvl tables if SIDSIZE >= 7
+ */
+#define SMMU_KVM_STRTAB_ORDER		(get_order(STRTAB_MAX_L1_ENTRIES * \
+					 sizeof(struct arm_smmu_strtab_l1)))
 
 static size_t kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device *kvm_arm_smmu_array;
@@ -33,6 +40,9 @@ static void __init kvm_arm_smmu_array_free(void)
 		if (smmu->cmdq.base_dma)
 			free_pages((unsigned long)phys_to_virt(smmu->cmdq.base_dma),
 				   SMMU_KVM_CMDQ_ORDER);
+		if (smmu->strtab_dma)
+			free_pages((unsigned long)phys_to_virt(smmu->strtab_dma),
+				   SMMU_KVM_STRTAB_ORDER);
 	}
 
 	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
@@ -77,8 +87,8 @@ static int __init smmuv3_nesting_probe(struct platform_device *pdev)
 {
 	struct hyp_arm_smmu_v3_device *smmu;
 	struct device *dev = &pdev->dev;
+	void *cmdq_base, *strtab;
 	struct resource *res;
-	void *cmdq_base;
 
 	/* Only device tree, ACPI not supported. */
 	if (!dev->of_node)
@@ -119,6 +129,15 @@ static int __init smmuv3_nesting_probe(struct platform_device *pdev)
 	smmu->cmdq.base_dma = virt_to_phys(cmdq_base);
 	smmu->cmdq.llq.max_n_shift = SMMU_KVM_CMDQ_ORDER + PAGE_SHIFT - CMDQ_ENT_SZ_SHIFT;
 
+	strtab = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, SMMU_KVM_STRTAB_ORDER);
+	if (!strtab) {
+		free_pages((unsigned long)cmdq_base, SMMU_KVM_CMDQ_ORDER);
+		return -ENOMEM;
+	}
+
+	smmu->strtab_dma = virt_to_phys(strtab);
+	smmu->strtab_size = PAGE_SIZE << SMMU_KVM_STRTAB_ORDER;
+
 	if (of_dma_is_coherent(dev->of_node))
 		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index dc9b1e659a42..0fa98915e00d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -18,6 +18,14 @@
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
+/* strtab accessors */
+#define strtab_log2size(smmu)	(FIELD_GET(STRTAB_BASE_CFG_LOG2SIZE, (smmu)->host_ste_cfg))
+#define strtab_size(smmu)	((1UL << strtab_log2size(smmu)) * STRTAB_STE_DWORDS * 8)
+#define strtab_host_base(smmu)	((smmu)->host_ste_base & STRTAB_BASE_ADDR_MASK)
+#define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
+#define strtab_l1_size(smmu)	((1UL << (strtab_log2size(smmu) - strtab_split(smmu))) * \
+				 (sizeof(struct arm_smmu_strtab_l1)))
+
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
 	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
@@ -66,6 +74,11 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
 }
 
+static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_SMMUEN, smmu->cr0);
+}
+
 /*
  * Host structures the hypervisor reads (CMDQ, STE) are shared and pinned:
  * - Prevent the host from donating this memory.
@@ -200,6 +213,11 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (smmu->cmdq.base)
 		WARN_ON(__pkvm_hyp_donate_host(smmu->cmdq.base_dma >> PAGE_SHIFT,
 					       PAGE_ALIGN(cmdq_size(&smmu->cmdq)) >> PAGE_SHIFT));
+
+	if (smmu->strtab_cfg.linear.table ||
+	    smmu->strtab_cfg.l2.l1tab)
+		WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(smmu->strtab_dma),
+					       smmu->strtab_size >> PAGE_SHIFT));
 	smmu->base = NULL;
 }
 
@@ -272,6 +290,45 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	int ret;
+	u32 reg;
+
+	ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(smmu->strtab_dma),
+				     smmu->strtab_size >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		unsigned int last_sid_idx =
+			arm_smmu_strtab_l1_idx((1ULL << smmu->sid_bits) - 1);
+
+		cfg->l2.l1tab = hyp_phys_to_virt(smmu->strtab_dma);
+		cfg->l2.l1_dma = smmu->strtab_dma;
+		cfg->l2.num_l1_ents = min(last_sid_idx + 1, STRTAB_MAX_L1_ENTRIES);
+
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_2LVL) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE,
+				 ilog2(cfg->l2.num_l1_ents) + STRTAB_SPLIT) |
+		      FIELD_PREP(STRTAB_BASE_CFG_SPLIT, STRTAB_SPLIT);
+	} else {
+		cfg->linear.table = hyp_phys_to_virt(smmu->strtab_dma);
+		cfg->linear.ste_dma = smmu->strtab_dma;
+		cfg->linear.num_ents = 1UL << smmu->sid_bits;
+		reg = FIELD_PREP(STRTAB_BASE_CFG_FMT,
+				 STRTAB_BASE_CFG_FMT_LINEAR) |
+		      FIELD_PREP(STRTAB_BASE_CFG_LOG2SIZE, smmu->sid_bits);
+	}
+
+	writeq_relaxed((smmu->strtab_dma & STRTAB_BASE_ADDR_MASK) | STRTAB_BASE_RA,
+		       smmu->base + ARM_SMMU_STRTAB_BASE);
+	writel_relaxed(reg, smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	unsigned long haddr;
@@ -297,6 +354,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_deinit;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		goto out_deinit;
+
 	return 0;
 
 out_deinit:
@@ -441,6 +502,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
 	return ret;
 }
 
+static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enabled)
+{
+	size_t size;
+	u32 fmt = FIELD_GET(STRTAB_BASE_CFG_FMT, smmu->host_ste_cfg);
+
+	/* Linux doesn't change the fmt nor size of the strtab in the run time. */
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		if ((fmt != STRTAB_BASE_CFG_FMT_2LVL) ||
+		    (strtab_split(smmu) != STRTAB_SPLIT) ||
+		    (strtab_log2size(smmu) > (ilog2(STRTAB_MAX_L1_ENTRIES) + STRTAB_SPLIT)) ||
+		    (strtab_split(smmu) >= strtab_log2size(smmu)))
+			return -EINVAL;
+		size = strtab_l1_size(smmu);
+	} else {
+		if ((fmt != STRTAB_BASE_CFG_FMT_LINEAR) ||
+		    (strtab_log2size(smmu) > smmu->sid_bits))
+			return -EINVAL;
+		size = strtab_size(smmu);
+	}
+
+	if (enabled)
+		return smmu_share_pages(strtab_host_base(smmu), size);
+
+	return smmu_unshare_pages(strtab_host_base(smmu), size);
+}
+
+static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
+	if (WARN_ON(!is_cmdq_enabled(smmu)))
+		return;
+
+	WARN_ON(smmu_update_ste_shadow(smmu, true));
+}
+
+static void smmu_emulate_disable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	WARN_ON(smmu_update_ste_shadow(smmu, false));
+}
+
 static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
@@ -528,7 +629,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		}
 	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_STRTAB_BASE:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
+			if (is_smmu_enabled(smmu))
+				break;
+			smmu->host_ste_base = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_STRTAB_BASE_CFG:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
+			if (is_smmu_enabled(smmu))
+				break;
+			smmu->host_ste_cfg = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
@@ -538,6 +655,7 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 
 		if (is_write) {
 			bool last_cmdq_en = is_cmdq_enabled(smmu);
+			bool last_smmu_en = is_smmu_enabled(smmu);
 
 			/* Enforce ATS checks. */
 			if (smmu->features & ARM_SMMU_FEAT_ATS)
@@ -547,6 +665,10 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 				smmu_emulate_cmdq_enable(smmu);
 			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_disable(smmu);
+			if (!last_smmu_en && is_smmu_enabled(smmu))
+				smmu_emulate_enable(smmu);
+			else if (last_smmu_en && !is_smmu_enabled(smmu))
+				smmu_emulate_disable(smmu);
 			mask = read_write;
 		} else {
 			mask = read_write & ~CR0_ATSCHK;
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index 3903ae358555..31ab7a0335a8 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -27,6 +27,12 @@
  * @cmdq_host:		Host view of the CMDQ, only q_base, base_dma and llq used
  * @cmdq_max_shift:	Max shift for the CMDQ probed from HW
  * @cr0:		Last value of CR0
+ * @host_ste_cfg:	Host stream table config
+ * @host_ste_base:	Host stream table base
+ * @strtab_cfg:		Stream table config as seen by HW
+ * @strtab_dma:		Physical address of the shadow stream table
+ * @strtab_size:	Size of the shadow stream table
+ *
  * @mmio_addr, @mmio_size and ARM_SMMU_FEAT_COHERENCY are filled by the host
  * before de-privilege, the rest by the hypervisor driver.
  */
@@ -50,6 +56,11 @@ struct hyp_arm_smmu_v3_device {
 	struct arm_smmu_queue	cmdq_host;
 	u32			cmdq_max_shift;
 	u32			cr0;
+	dma_addr_t		strtab_dma;
+	size_t			strtab_size;
+	u64			host_ste_cfg;
+	u64			host_ste_base;
+	struct arm_smmu_strtab_cfg strtab_cfg;
 };
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-- 
2.56.0.176.g3575e65682-goog

