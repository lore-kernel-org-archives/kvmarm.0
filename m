Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6957247886D
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116780; cv=none; b=uZ/1Xds6u7mhvraHSttHuYDnVN3V/XxfdgdTKTz+4EIhwgGhzcjA7/D8XcOoe+RqGa0GNg72Vpr6azT/KggNiTRzuzJ4d2sdGe/zYJ/616jvss5TsvI19FrJcdV540vdbXasAgDtXz2ye9BGnG8m9TiKakyz0OmYUldMk3w2bUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116780; c=relaxed/simple;
	bh=qSwbMCTvMcx1q1S8+AnJgpwJf3eG58WbAdUNotD1jCo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Y+5dZ5Cj98xY6/Lt2wotMNavbBiAhHZoecPKpHuaKYb7udEt/s+E1hkEYLXeskBxGsH9WhN9CuKcoDYyh+TfaZOOQ6qPNKlr4lRdA0EirFMKb9YUnh2U0ozuaSBtI0j2Zuo5rRW0IfwEY6Wt5FIiKZ4MkJ8dNMifzqsZzTANzts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XcQU2kuj; arc=none smtp.client-ip=209.85.208.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XcQU2kuj"
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6984787eeddso5335793a12.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116775; x=1784721575; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhVA7+fH5iuDTjPK4Ro+fz5qNNNKxyVJWdTpr47ZOpA=;
        b=XcQU2kuj3PuAZZL+FFfSf83tVduJjcOAn7wlmV+gmhKVwZ9rgn6N2MkZUhVIskCtXC
         a0pT2OisI+3OOKzwy2x8KNYL92qQOttYrYMzeTZSx/APQFbFUUucDaqeXHhjhOTs2GKd
         xsrYYoqsMHpcOWp7Pr9xWNPGuNLlgQedFOUL6OwFLYJ/XedtskfH+YFSHcXT7lchbTVP
         vL8DocDzb2VnPH5rNJ6ElbxjFpXCbY7CFijr/jltyio066MvSqiZ4m7q5TTFTLb93BCe
         Ejurf/UjUdEpM1tr9/pBARVK5jrnTuLhWAfHGPO08Zy6VxdBk8zvRY9ciLpsAuxKeBti
         obHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116775; x=1784721575;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QhVA7+fH5iuDTjPK4Ro+fz5qNNNKxyVJWdTpr47ZOpA=;
        b=GITblxG89/mV0gZtxpOxa8wHg39n6bzoJrnuOz1/fmBB1WmCoLB1Flfi/WynCdvt0Z
         ev/zS06w07iB1eZFFirwUvOUogpjWDyB4skqMdLKQ+BzLdeT2BT6ZoxtByNviQnvgpdJ
         AH0ueQFsmH+SdeUVNVoEtl76qoRt8c8Wv6mXw1VyoxbrYm9z2jtSMDeXZchTyISse/sL
         2JsrDvrDCfRvKmrE0F0CMbprSs/8FUckQlUj4SBFQVb3z8B+ZFc03Q6LoaDAj7GtG4Rb
         g6LoSXvBDuzEwqkLzpCndeqKa9zRksD7WmvAEoqeKq1nH7Lg4ywFRuVBdVjQL19rypdJ
         jnrQ==
X-Forwarded-Encrypted: i=1; AHgh+RpUCHenPmW+zuniQQW/l9WQxSBHVvPJbVBc8dPEz3LZEY30MexY/D/V+lVxxmz5qOQ9Kr70FlQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZtsCIllrCoWNCe8e2gTBelC2LVCRcLRz+IXCdUp9L3FP1VupS
	q0vn1sSHxy1a0ej1Rf7xHeiC/n1zWM06YvHT6R0Rz7CivHmXqSWJx3/RN2uMoJcuGd54OV845mv
	dcQq0j8xt+tGhsg==
X-Received: from edr22.prod.google.com ([2002:a05:6402:44d6:b0:695:9e2c:a1ca])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1ed6:b0:698:52b4:c2c9 with SMTP id 4fb4d7f45d1cf-69cd6f069dcmr3544598a12.31.1784116774920;
 Wed, 15 Jul 2026 04:59:34 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:58 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-18-smostafa@google.com>
Subject: [PATCH v7 17/24] iommu/arm-smmu-v3-kvm: Shadow stream table
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

Allocate the shadow stream table per SMMU.
We choose the size of that table to be 1MB which is the
max size used by host in the case of 2 levels.

All the host writes are still paththrough for bisectibility, that
is changed next where CFGI commands will be trapped and used to
update the shadow copy hypervisor that will be used by HW.

Similar to the command queue, the host stream table is
shared/unshared each time the SMMU is enabled/disabled.

Handling of L2 tables is also done in the next patch when
the shadowing is added.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  21 ++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 122 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  10 ++
 3 files changed, 152 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 81a4cd539415..2cafb03995ea 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -16,6 +16,13 @@
 #include "pkvm/arm_smmu_v3.h"
 
 #define SMMU_KVM_CMDQ_ORDER				4
+/*
+ * Use the max value of L1 the kernel uses, that also covers the worst case
+ * for linear tables as it is mandatory according to the spec to support 2
+ * lvl tables if SIDSIZE >= 7
+ */
+#define SMMU_KVM_STRTAB_ORDER				(get_order(STRTAB_MAX_L1_ENTRIES * \
+							 sizeof(struct arm_smmu_strtab_l1)))
 
 extern struct pkvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
@@ -34,6 +41,9 @@ static void kvm_arm_smmu_array_free(void)
 		if (smmu->cmdq.base_dma)
 			free_pages((unsigned long)phys_to_virt(smmu->cmdq.base_dma),
 				   SMMU_KVM_CMDQ_ORDER);
+		if (smmu->strtab_dma)
+			free_pages((unsigned long)phys_to_virt(smmu->strtab_dma),
+				   SMMU_KVM_STRTAB_ORDER);
 	}
 
 	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
@@ -80,8 +90,8 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
 {
 	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
 	struct device *dev = &pdev->dev;
+	void *cmdq_base, *strtab;
 	struct resource *res;
-	void *cmdq_base;
 
 	/* Only device tree, ACPI not supported. */
 	if (!dev->of_node)
@@ -117,6 +127,15 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
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
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index f62c9e8f2c59..3b133f24b4ca 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -16,6 +16,14 @@
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
@@ -58,6 +66,11 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
 }
 
+static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_SMMUEN, smmu->cr0);
+}
+
 /*
  * CMDQ, STE host copies are accessed by the hypervisor, we share them to
  * - Prevent the host from passing protected VM memory.
@@ -190,6 +203,11 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (smmu->cmdq.base)
 		WARN_ON(__pkvm_hyp_donate_host(smmu->cmdq.base_dma >> PAGE_SHIFT,
 					       cmdq_size(&smmu->cmdq) >> PAGE_SHIFT));
+
+	if (smmu->strtab_cfg.linear.table ||
+	    smmu->strtab_cfg.l2.l1tab)
+		WARN_ON(__pkvm_hyp_donate_host(hyp_phys_to_pfn(smmu->strtab_dma),
+					       smmu->strtab_size >> PAGE_SHIFT));
 	smmu->base = NULL;
 }
 
@@ -265,6 +283,45 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -288,6 +345,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_ret;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
 
 out_ret:
@@ -422,6 +483,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
 	return ret;
 }
 
+static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enabled)
+{
+	size_t strtab_size;
+	u32 fmt  = FIELD_GET(STRTAB_BASE_CFG_FMT, smmu->host_ste_cfg);
+
+	/* Linux doesn't change the fmt nor size of the strtab in the run time. */
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		if ((fmt != STRTAB_BASE_CFG_FMT_2LVL) ||
+		     (strtab_split(smmu) != STRTAB_SPLIT) ||
+		     (strtab_log2size(smmu) > (ilog2(STRTAB_MAX_L1_ENTRIES) + STRTAB_SPLIT)) ||
+		     (strtab_split(smmu) >= strtab_log2size(smmu)))
+			return -EINVAL;
+		strtab_size = strtab_l1_size(smmu);
+	} else {
+		if ((fmt != STRTAB_BASE_CFG_FMT_LINEAR) ||
+		    (strtab_log2size(smmu) > smmu->sid_bits))
+			return -EINVAL;
+		strtab_size = strtab_size(smmu);
+	}
+
+	if (enabled)
+		return smmu_share_pages(strtab_host_base(smmu), strtab_size);
+
+	return smmu_unshare_pages(strtab_host_base(smmu), strtab_size);
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
@@ -509,7 +610,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		}
 	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_STRTAB_BASE:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
+			if (is_smmu_enabled(smmu))
+				break;
+			smmu->host_ste_base = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_STRTAB_BASE_CFG:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
+			if (is_smmu_enabled(smmu))
+				break;
+			smmu->host_ste_cfg = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
@@ -518,12 +635,17 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			break;
 		if (is_write) {
 			bool last_cmdq_en = is_cmdq_enabled(smmu);
+			bool last_smmu_en = is_smmu_enabled(smmu);
 
 			smmu->cr0 = val;
 			if (!last_cmdq_en && is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_enable(smmu);
 			else if (last_cmdq_en && !is_cmdq_enabled(smmu))
 				smmu_emulate_cmdq_disable(smmu);
+			if (!last_smmu_en && is_smmu_enabled(smmu))
+				smmu_emulate_enable(smmu);
+			else if (last_smmu_en && !is_smmu_enabled(smmu))
+				smmu_emulate_disable(smmu);
 		}
 		mask = read_write;
 		break;
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 74a7f62d93eb..085aead009b6 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -15,6 +15,8 @@
  * @mmio_addr		base address of the SMMU registers
  * @mmio_size		size of the registers resource
  * @features		Features of SMMUv3, subset of the main driver
+ * @strtab_dma		Phys address of stream table
+ * @strtab_size		Stream table size
  *
  * Other members are filled and used at runtime by the SMMU driver.
  * @base		Virtual address of SMMU registers
@@ -27,6 +29,9 @@
  * @cmdq		CMDQ as observed by HW
  * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
  * @cr0			Last value of CR0
+ * @host_ste_cfg	Host stream table config
+ * @host_ste_base	Host stream table base
+ * @strtab_cfg		Stream table as seen by HW
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -46,6 +51,11 @@ struct hyp_arm_smmu_v3_device {
 	struct arm_smmu_queue	cmdq;
 	struct arm_smmu_queue	cmdq_host;
 	u32			cr0;
+	dma_addr_t		strtab_dma;
+	size_t			strtab_size;
+	u64			host_ste_cfg;
+	u64			host_ste_base;
+	struct arm_smmu_strtab_cfg strtab_cfg;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.55.0.141.g00534a21ce-goog

