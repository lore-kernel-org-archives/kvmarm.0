Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 496093A3814
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634428; cv=none; b=oBfxrVOSKNrstb+UMcFIOyzInjyXHByuZJAcscfdsulokFRqdK8hnMAmqpzP4m6Q+Veqo8zs7b+ejA1vro5x/JVXmR+tGXOBBdB2S3FRtek01j/w8oNXAnadfZPeopOVuw7W3zBoeRE/vSdNMni7g3UF/dQ0LpxItJksHQErbko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634428; c=relaxed/simple;
	bh=fY8MgosuIzxAf/kMmWlM8XbQqE2bmppPhcnH3qooiwk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=LNTEfUuNzipiz0zyh/NPpz4ij06eXivLjo8LAxJpjJe7KqxbpKczc3fNGrxT0qGzV/aZoUd+uN0x3aSew4Lu5kYiEb5C1l9/iN2K07HpvM5WqgyfJjGqRImFj1A6TDYxLCimFfMB7M9WGcgrwvGOnH6YGnp4n+rR9/j/H916Sck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UiMwx5F1; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UiMwx5F1"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55ecc32cso16297005e9.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634425; x=1778239225; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5m1KpsLfHL+l1yTb9rqM+ybYvsBgDjrRbLz7Mm8Rnis=;
        b=UiMwx5F1CHuJjN1HwkMFYL57X4vHEYO2lWM69ojK6DiCLUfrZ3qIB3JDObLYRZQ6yr
         sKrprhQuBujkY4yYOJhEDVfORxjqcr6qahthCbSdVwVy9sro8ZHsJXO4TEFczgifuckr
         K1/yN15MRuiRPkIdLLqx6MqFUOZJIUhUOJofsW8hjunMyyzpEZF2PZoNyhl7Biu52Yz9
         fAs8zGxQvIr/LpS/klKyvcB/ERT1MeavhBRUUFntu0tTE7RM5KzFPPSWESV8QxItBmp/
         8aayh5+s8FDQdEVtCKtxoVwTbS+NpBa1Z0Zh0G/m9WzH3QItaDZTMzR+n3ChSreQ0605
         0CfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634425; x=1778239225;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5m1KpsLfHL+l1yTb9rqM+ybYvsBgDjrRbLz7Mm8Rnis=;
        b=cx+jAQrfRI3xyKgV3pZjtQqtvas36zN+QE3jfzBXBGyrOrw4c3ntwlkg7nC6esPOnh
         pf0iacUzds/zj/4znAHNj4Evvrza6ic9/VSdc6gCNl8lkFSfZwc+BFBM6tqafML6YGR3
         BWIaC4SZiE7ycrz8tWekhf/XKx7IKyW+Sp0q51DMUDT6BL5l3q6tbqC94zW8TU94XT8O
         +6h1Ca9OOQoJjT18trgThKiWAY077QyL+qg1lQ3lpV2UTZpEovi+J7Ff9wWVXn7vsdEM
         zl7rEwknjPJDg2RNAtXVVCS9qK/OKV+dPxFNaKxQ9BvO1Frt7x8HWiNTtnAfRvH/g6zb
         M+Jw==
X-Forwarded-Encrypted: i=1; AFNElJ/dv20N8RqQR6c2oZUyYTM9AxtGuWacyM97kC+xs8rCQn2+ejycDLKObYvoZUxXotNeTPAlWlQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxIk1XeeTHy5+V+CU8QZi+YNH5DIHBFsu55BSdgPvAAosnZss99
	v6VfX22xbv2Kqwe+cgWcUBCRMh8AQKWgIsPluTo5vlGD17aA+IERGU7021ZKAwbwV2RAjrbDtjx
	q55CW3x9jbTN1NQ==
X-Received: from wmbjl23.prod.google.com ([2002:a05:600c:6a97:b0:48a:79c3:d04c])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:198b:b0:488:a2ac:a334 with SMTP id 5b1f17b1804b1-48a83d66cb9mr112477685e9.3.1777634424524;
 Fri, 01 May 2026 04:20:24 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:20 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-19-smostafa@google.com>
Subject: [PATCH v6 18/25] iommu/arm-smmu-v3-kvm: Shadow stream table
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
index fccbc34de087..7aec558eea29 100644
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
 
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
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
@@ -120,6 +130,15 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
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
 	kvm_arm_smmu_cur++;
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 1633a3cf8a3b..d15c9e5aa998 100644
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
@@ -53,6 +61,11 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -188,6 +201,11 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
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
 
@@ -287,6 +305,45 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -309,6 +366,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_ret;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
 
 out_ret:
@@ -436,6 +497,46 @@ static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait(use_wfe, smmu_cmdq_empty(&smmu->cmdq));
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
@@ -519,7 +620,23 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
@@ -528,12 +645,17 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
index cc1ad4c19845..6a73cf6b8873 100644
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
@@ -25,6 +27,9 @@
  * @cmdq		CMDQ as observed by HW
  * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
  * @cr0			Last value of CR0
+ * @host_ste_cfg	Host stream table config
+ * @host_ste_base	Host stream table base
+ * @strtab_cfg		Stream table as seen by HW
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -42,6 +47,11 @@ struct hyp_arm_smmu_v3_device {
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
2.54.0.545.g6539524ca2-goog

