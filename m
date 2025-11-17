Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B89314A83
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405333; cv=none; b=UOiDtFg+CwrrBgVSlSnPN2xsD7/GUAkKyUEyJJXVid8FMEgoceg+ZY0xVzIDR0E73XUOXaGdT/y/F98j13pL6m1/8NduuFj7h0i3sxEXCJiSCLRiZe47YNHbtPFZgtdkhRPN702aYxrH4kXqfEM+a+0bjRZqdyAeNVSm2h6YQ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405333; c=relaxed/simple;
	bh=McTMZ04nUPWuX1adTdf753MDynTmdT9+Yvl+v890ioQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lZ60q8Xtd1222OuZ5XAtYhaR9qg4+dXDBFkoZrs0nnrPCwnzVPGXtb/V1JPNvLbSmr9vXPQn6oo+rvU5eYh38rb2+uaDmmkAb4sEFTRrXWmVGyvPpnmSf3XuTc3EcDz8pPoI9kjccqbPK7t1+9Kldp+hzDxjL/MapQG5YYFcDeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jHwwZXYK; arc=none smtp.client-ip=209.85.218.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jHwwZXYK"
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7270cab7eeso415882466b.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405328; x=1764010128; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rb8/GtH372WJ0qxy4TkHlGTwt2qL/Zq2TNdTmFCsamI=;
        b=jHwwZXYK7Ov/3uSHPnH1hLka1duJJC3NxxOkjxbZdT/IwQE65qy5pCn/4Du90P60Y9
         2H9ZV7XOU4P0wkIElWIqJ8GPmGDbawvpXxGlXhdF2/XlDut3VYuEpAS/T/MeWifOREDt
         wRXCqarBVYE5fyx4zY36mgtHURjzMhqIe/adAu+wPxppPhROsdWomVyGno6mqkEDMOGM
         U9AqU3v04snmkOqC5T/w2rCH7IQMa5awXW+iqNfWioCUe5jP7JikgFHcg+38oJxb1Ku+
         tnjAnreQFp7jRcDCnSV/PVa9a2sIrT4UwO/rInhtSA8A3Xr6LL265VoG4cN3CZnC58zi
         2G+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405328; x=1764010128;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rb8/GtH372WJ0qxy4TkHlGTwt2qL/Zq2TNdTmFCsamI=;
        b=cLQWZeO3hsjlstzHXGI9q9NLdUp2PtWub+xuwBW72yZajBEWxtnQHEjiMSUV3gCmh1
         yHLP1hOEQ9IjJZqvbBSnC+ud53II+l0/IU1ToPDpkfDX7gpIXoeo7iFZd8jWui4mY5VP
         A2CwwpPIQ3dXJSmHWzX/iA/QlDdpQrugHlm6+MNsCJQILEWvaVqtwhvBfurYneH/mVrP
         CZLVGa+e4HINR261Fv4wvMVKSxtg4zVCOIuJ3DVfsUl0Xq65MdFhCJGXRmIICat80/GY
         nX/YyjqmY0pCtySSAzVTSSKVwJ9lE82I6cYaTDXtkVLAW/fbUFNcnSaWFtOhMmqqFVyi
         ciyw==
X-Forwarded-Encrypted: i=1; AJvYcCXJ1dH9HYIGwRk+EQO/Q2tvWhI2+d84YGCgGcEIRRvXRj2v7h+h4QCNtLlycwokZ+8ovYXcpO4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxymQ4R1FdTsN96v3AM9RRAVDmY1jFJwngponYxjih43Ydyjjab
	yiwWirs/VJzus6KyOLeMq9uTQj60C6jj9FARZQivwdypNxHOVDB0c8+SX+sItq1vD+VV2D1K/V5
	xKrY6mTsMOC4hyQ==
X-Google-Smtp-Source: AGHT+IGu0kjXqesw4Vlk33i3V4Q6Afh7tCka5IjsceWQYSdkeKorvnxtzP7ZJLMV5a7eguSrQpC56lnDAuMk9Q==
X-Received: from ejcuy7.prod.google.com ([2002:a17:907:d107:b0:b73:4e7b:9fe3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:25c9:b0:b72:8e31:4354 with SMTP id a640c23a62f3a-b736782c35cmr1540477366b.25.1763405327824;
 Mon, 17 Nov 2025 10:48:47 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:09 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-23-smostafa@google.com>
Subject: [PATCH v5 22/27] iommu/arm-smmu-v3-kvm: Shadow stream table
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch allocates the shadow stream table per SMMU.
We choose the size of that table to be 1MB which is the
max size used by host in the case of 2 levels.

In this patch all the host writes are still paththrough for
bisectibility, that is changed next where CFGI commands will be
trapped and used to update the shadow copy hypervisor that
will be used by HW.

Similar to the command queue, the host stream table is
shared/unshared each time the SMMU is enabled/disabled.

Handling of L2 tables is also done in the next patch when
the shadowing is added.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   |  11 +-
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 114 ++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  10 ++
 3 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 87376f615798..82626e052a2f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -16,6 +16,8 @@
 #include "pkvm/arm_smmu_v3.h"
 
 #define SMMU_KVM_CMDQ_ORDER				4
+#define SMMU_KVM_STRTAB_ORDER				(get_order(STRTAB_MAX_L1_ENTRIES * \
+							 sizeof(struct arm_smmu_strtab_l1)))
 
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
@@ -73,7 +75,7 @@ static struct platform_driver smmuv3_nesting_driver;
 static int smmuv3_nesting_probe(struct platform_device *pdev)
 {
 	struct resource *res;
-	void *cmdq_base;
+	void *cmdq_base, *strtab;
 	struct hyp_arm_smmu_v3_device *smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
@@ -100,6 +102,13 @@ static int smmuv3_nesting_probe(struct platform_device *pdev)
 	smmu->cmdq.base_dma = virt_to_phys(cmdq_base);
 	smmu->cmdq.llq.max_n_shift = SMMU_KVM_CMDQ_ORDER + PAGE_SHIFT - CMDQ_ENT_SZ_SHIFT;
 
+	strtab = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, SMMU_KVM_STRTAB_ORDER);
+	if (!strtab)
+		return -ENOMEM;
+
+	smmu->strtab_dma = virt_to_phys(strtab);
+	smmu->strtab_size = PAGE_SIZE << SMMU_KVM_STRTAB_ORDER;
+
 	kvm_arm_smmu_cur++;
 	return 0;
 }
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 746ffc4b0a70..9e515a130711 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -15,6 +15,14 @@
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 
+/* strtab accessors */
+#define strtab_log2size(smmu)	(FIELD_GET(STRTAB_BASE_CFG_LOG2SIZE, (smmu)->host_ste_cfg))
+#define strtab_size(smmu)	((1 << strtab_log2size(smmu)) * STRTAB_STE_DWORDS * 8)
+#define strtab_host_base(smmu)	((smmu)->host_ste_base & STRTAB_BASE_ADDR_MASK)
+#define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
+#define strtab_l1_size(smmu)	((1 << (strtab_log2size(smmu) - strtab_split(smmu))) * \
+				 (sizeof(struct arm_smmu_strtab_l1)))
+
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
 	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
@@ -47,6 +55,11 @@ static bool is_cmdq_enabled(struct hyp_arm_smmu_v3_device *smmu)
 	return FIELD_GET(CR0_CMDQEN, smmu->cr0);
 }
 
+static bool is_smmu_enabled(struct hyp_arm_smmu_v3_device *smmu)
+{
+	return FIELD_GET(CR0_SMMUEN, smmu->cr0);
+}
+
 /* Transfer ownership of memory */
 static int smmu_take_pages(u64 phys, size_t size)
 {
@@ -270,6 +283,49 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	u32 reg;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+
+	ret = ___pkvm_host_donate_hyp(hyp_phys_to_pfn(smmu->strtab_dma),
+				      smmu->strtab_size >> PAGE_SHIFT, prot);
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
 	int i, ret;
@@ -298,6 +354,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_ret;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		goto out_ret;
+
 	return 0;
 
 out_ret:
@@ -418,6 +478,41 @@ static void smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
 	WARN_ON(smmu_wait(use_wfe, smmu_cmdq_empty(&smmu->cmdq)));
 }
 
+static void smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enabled)
+{
+	size_t strtab_size;
+	u32 fmt  = FIELD_GET(STRTAB_BASE_CFG_FMT, smmu->host_ste_cfg);
+
+	/* Linux doesn't change the fmt nor size of the strtab in the run time. */
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		strtab_size = strtab_l1_size(smmu);
+		WARN_ON(fmt != STRTAB_BASE_CFG_FMT_2LVL);
+		WARN_ON((strtab_split(smmu) != STRTAB_SPLIT));
+	} else {
+		strtab_size = strtab_size(smmu);
+		WARN_ON(fmt != STRTAB_BASE_CFG_FMT_LINEAR);
+		WARN_ON(FIELD_GET(STRTAB_BASE_CFG_LOG2SIZE, smmu->host_ste_cfg) >
+		       smmu->sid_bits);
+	}
+
+	if (enabled)
+		WARN_ON(smmu_share_pages(strtab_host_base(smmu), strtab_size));
+	else
+		WARN_ON(smmu_unshare_pages(strtab_host_base(smmu), strtab_size));
+}
+
+static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
+	WARN_ON(!is_cmdq_enabled(smmu));
+	smmu_update_ste_shadow(smmu, true);
+}
+
+static void smmu_emulate_disable(struct hyp_arm_smmu_v3_device *smmu)
+{
+	smmu_update_ste_shadow(smmu, false);
+}
+
 static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 {
 	smmu->cmdq_host.llq.max_n_shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
@@ -483,19 +578,38 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		goto out_ret;
 	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_STRTAB_BASE:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
+			WARN_ON(is_smmu_enabled(smmu));
+			smmu->host_ste_base = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_STRTAB_BASE_CFG:
+		if (is_write) {
+			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
+			WARN_ON(is_smmu_enabled(smmu));
+			smmu->host_ste_cfg = val;
+		}
+		mask = read_write;
+		break;
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
 	case ARM_SMMU_CR0:
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
 		WARN_ON(len != sizeof(u32));
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 2fb4c0cab47c..8efa9273b194 100644
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
@@ -26,6 +28,9 @@
  * @cmdq		CMDQ as observed by HW
  * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
  * @cr0			Last value of CR0
+ * @host_ste_cfg	Host stream table config
+ * @host_ste_base	Host stream table base
+ * @strtab_cfg		Stream table as seen by HW
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
@@ -44,6 +49,11 @@ struct hyp_arm_smmu_v3_device {
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
2.52.0.rc1.455.g30608eb744-goog

