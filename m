Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F1A63CA
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:41 +0000 (UTC)
Received: by mail-wr1-f52.google.com with SMTP id t7so8870247wrp.5
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k/GDOaMle8fCK10H5aUfKS5834jy6OqVt1je6uaYFNc=;
        b=a/ySk0jxxFQ5Umd321G1J6ggbfnZENu3LP6l8nOj0kuQsqnkHyvy58UCJ+6Y3R86Y7
         qciFJoPzshScME2lHsL8LXXpKOGBlcO3vHzloNhsQQctl2aHlghvudN8rptx4J0zWIB2
         1qwhgBKnKOUj8Juft52uvLCjLPPDy7lDrmB7mf8R+WC6xa3VSuMx10HbRza3O7DFYYpH
         r241/v3swxNAnpVjvfgtneMgbEDMBZEM165wWObwT7MD9w8WsNl7qICdc5JE1p5kllaz
         ZXs7X0SbZ9zAQx0yk03oJFCzCjVSvJ6GCipFrVzA49yvnVsSGuWFKjDlktjL1Z//lDua
         wYsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k/GDOaMle8fCK10H5aUfKS5834jy6OqVt1je6uaYFNc=;
        b=rv0SlZ8xB1BKXYagSXq1Srm7SdxG+RZNwWjlaDZ5BaMQ6U7fGx/lvByJv85GM99fSv
         TpbAHzaMJXGhNj/DdUhjS13chX4aecoS/v2+4WVCPhA4sF95bqDWxwZY+3q4dkzeRxhw
         0OF4O6wAO9OkAgIjTiEfBjv+Le8SVJRCeJe954LPCCSmJiikAcvt0GC7NHLQ8BTxnkqR
         lGIc2qMFMUYfJcxDAQDDaXK7FJvfAM+hgEg8OYsBMViMpJoY4gOJGIcVJtnmHXat81Ns
         bmJbMtqXP7rjO6TmyXnRvkW7W4d/VG4RudCXWT+Poa4srHQ30bhhXAL6BYBrfdpXgwWB
         34sg==
X-Gm-Message-State: AO0yUKWt/sjrdWBsFly2iPCelFnSyxAyi/GTnlveiz9nVAxlAgHdJS/r
	0O61ifoTOyAFggMXh71wu9vI7w==
X-Google-Smtp-Source: AK7set/PuZ0iGJgAqsm7rVA84kvYeOepxjawaRC1mJFoy/KL6sqcM9J5i+g+Fl43K/IxMpuWhh+0Hg==
X-Received: by 2002:a5d:514d:0:b0:2bf:ae1e:84d2 with SMTP id u13-20020a5d514d000000b002bfae1e84d2mr2263196wrt.12.1675256380688;
        Wed, 01 Feb 2023 04:59:40 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:40 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 27/45] KVM: arm64: smmu-v3: Setup domains and page table configuration
Date: Wed,  1 Feb 2023 12:53:11 +0000
Message-Id: <20230201125328.2186498-28-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Setup the stream table entries when the host issues the attach_dev() and
detach_dev() hypercalls. The driver holds one io-pgtable configuration
for all domains.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 include/kvm/arm_smmu_v3.h                   |   2 +
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 178 +++++++++++++++++++-
 2 files changed, 177 insertions(+), 3 deletions(-)

diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index fc67a3bf5709..ed139b0e9612 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -3,6 +3,7 @@
 #define __KVM_ARM_SMMU_V3_H
 
 #include <asm/kvm_asm.h>
+#include <linux/io-pgtable-arm.h>
 #include <kvm/iommu.h>
 
 #if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
@@ -28,6 +29,7 @@ struct hyp_arm_smmu_v3_device {
 	size_t			strtab_num_entries;
 	size_t			strtab_num_l1_entries;
 	u8			strtab_split;
+	struct arm_lpae_io_pgtable pgtable;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index 81040339ccfe..56e313203a16 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -152,7 +152,6 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
-__maybe_unused
 static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 {
 	struct arm_smmu_cmdq_ent cmd = {
@@ -194,7 +193,6 @@ static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 idx)
 	return 0;
 }
 
-__maybe_unused
 static u64 *smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 {
 	u32 idx;
@@ -382,6 +380,68 @@ static int smmu_reset_device(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_write_cr0(smmu, 0);
 }
 
+static struct hyp_arm_smmu_v3_device *to_smmu(struct kvm_hyp_iommu *iommu)
+{
+	return container_of(iommu, struct hyp_arm_smmu_v3_device, iommu);
+}
+
+static void smmu_tlb_flush_all(void *cookie)
+{
+	struct kvm_iommu_tlb_cookie *data = cookie;
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(data->iommu);
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_TLBI_S12_VMALL,
+		.tlbi.vmid = data->domain_id,
+	};
+
+	WARN_ON(smmu_send_cmd(smmu, &cmd));
+}
+
+static void smmu_tlb_inv_range(struct kvm_iommu_tlb_cookie *data,
+			       unsigned long iova, size_t size, size_t granule,
+			       bool leaf)
+{
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(data->iommu);
+	unsigned long end = iova + size;
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_TLBI_S2_IPA,
+		.tlbi.vmid = data->domain_id,
+		.tlbi.leaf = leaf,
+	};
+
+	/*
+	 * There are no mappings at high addresses since we don't use TTB1, so
+	 * no overflow possible.
+	 */
+	BUG_ON(end < iova);
+
+	while (iova < end) {
+		cmd.tlbi.addr = iova;
+		WARN_ON(smmu_send_cmd(smmu, &cmd));
+		BUG_ON(iova + granule < iova);
+		iova += granule;
+	}
+}
+
+static void smmu_tlb_flush_walk(unsigned long iova, size_t size,
+				size_t granule, void *cookie)
+{
+	smmu_tlb_inv_range(cookie, iova, size, granule, false);
+}
+
+static void smmu_tlb_add_page(struct iommu_iotlb_gather *gather,
+			      unsigned long iova, size_t granule,
+			      void *cookie)
+{
+	smmu_tlb_inv_range(cookie, iova, granule, granule, true);
+}
+
+static const struct iommu_flush_ops smmu_tlb_ops = {
+	.tlb_flush_all	= smmu_tlb_flush_all,
+	.tlb_flush_walk = smmu_tlb_flush_walk,
+	.tlb_add_page	= smmu_tlb_add_page,
+};
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -394,6 +454,14 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (IS_ERR(smmu->base))
 		return PTR_ERR(smmu->base);
 
+	smmu->iommu.pgtable_cfg.tlb = &smmu_tlb_ops;
+
+	ret = kvm_arm_io_pgtable_init(&smmu->iommu.pgtable_cfg, &smmu->pgtable);
+	if (ret)
+		return ret;
+
+	smmu->iommu.pgtable = &smmu->pgtable.iop;
+
 	ret = smmu_init_registers(smmu);
 	if (ret)
 		return ret;
@@ -406,7 +474,11 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
-	return smmu_reset_device(smmu);
+	ret = smmu_reset_device(smmu);
+	if (ret)
+		return ret;
+
+	return kvm_iommu_init_device(&smmu->iommu);
 }
 
 static int smmu_init(void)
@@ -414,6 +486,10 @@ static int smmu_init(void)
 	int ret;
 	struct hyp_arm_smmu_v3_device *smmu;
 
+	ret = kvm_iommu_init();
+	if (ret)
+		return ret;
+
 	ret = pkvm_create_mappings(kvm_hyp_arm_smmu_v3_smmus,
 				   kvm_hyp_arm_smmu_v3_smmus +
 				   kvm_hyp_arm_smmu_v3_count,
@@ -430,8 +506,104 @@ static int smmu_init(void)
 	return 0;
 }
 
+static struct kvm_hyp_iommu *smmu_id_to_iommu(pkvm_handle_t smmu_id)
+{
+	if (smmu_id >= kvm_hyp_arm_smmu_v3_count)
+		return NULL;
+	smmu_id = array_index_nospec(smmu_id, kvm_hyp_arm_smmu_v3_count);
+
+	return &kvm_hyp_arm_smmu_v3_smmus[smmu_id].iommu;
+}
+
+static int smmu_attach_dev(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id,
+			   struct kvm_hyp_iommu_domain *domain, u32 sid)
+{
+	int i;
+	int ret;
+	u64 *dst;
+	struct io_pgtable_cfg *cfg;
+	u64 ts, sl, ic, oc, sh, tg, ps;
+	u64 ent[STRTAB_STE_DWORDS] = {};
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(iommu);
+
+	dst = smmu_get_ste_ptr(smmu, sid);
+	if (!dst || dst[0])
+		return -EINVAL;
+
+	cfg = &smmu->pgtable.iop.cfg;
+	ps = cfg->arm_lpae_s2_cfg.vtcr.ps;
+	tg = cfg->arm_lpae_s2_cfg.vtcr.tg;
+	sh = cfg->arm_lpae_s2_cfg.vtcr.sh;
+	oc = cfg->arm_lpae_s2_cfg.vtcr.orgn;
+	ic = cfg->arm_lpae_s2_cfg.vtcr.irgn;
+	sl = cfg->arm_lpae_s2_cfg.vtcr.sl;
+	ts = cfg->arm_lpae_s2_cfg.vtcr.tsz;
+
+	ent[0] = STRTAB_STE_0_V |
+		 FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	ent[2] = FIELD_PREP(STRTAB_STE_2_VTCR,
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, ps) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, tg) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, sh) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, oc) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, ic) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, sl) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, ts)) |
+		 FIELD_PREP(STRTAB_STE_2_S2VMID, domain_id) |
+		 STRTAB_STE_2_S2AA64;
+	ent[3] = hyp_virt_to_phys(domain->pgd) & STRTAB_STE_3_S2TTB_MASK;
+
+	/*
+	 * The SMMU may cache a disabled STE.
+	 * Initialize all fields, sync, then enable it.
+	 */
+	for (i = 1; i < STRTAB_STE_DWORDS; i++)
+		dst[i] = cpu_to_le64(ent[i]);
+
+	ret = smmu_sync_ste(smmu, sid);
+	if (ret)
+		return ret;
+
+	WRITE_ONCE(dst[0], cpu_to_le64(ent[0]));
+	ret = smmu_sync_ste(smmu, sid);
+	if (ret)
+		dst[0] = 0;
+
+	return ret;
+}
+
+static int smmu_detach_dev(struct kvm_hyp_iommu *iommu, pkvm_handle_t domain_id,
+			   struct kvm_hyp_iommu_domain *domain, u32 sid)
+{
+	u64 ttb;
+	u64 *dst;
+	int i, ret;
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(iommu);
+
+	dst = smmu_get_ste_ptr(smmu, sid);
+	if (!dst)
+		return -ENODEV;
+
+	ttb = dst[3] & STRTAB_STE_3_S2TTB_MASK;
+
+	dst[0] = 0;
+	ret = smmu_sync_ste(smmu, sid);
+	if (ret)
+		return ret;
+
+	for (i = 1; i < STRTAB_STE_DWORDS; i++)
+		dst[i] = 0;
+
+	return smmu_sync_ste(smmu, sid);
+}
+
 static struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
+	.get_iommu_by_id		= smmu_id_to_iommu,
+	.alloc_iopt			= kvm_arm_io_pgtable_alloc,
+	.free_iopt			= kvm_arm_io_pgtable_free,
+	.attach_dev			= smmu_attach_dev,
+	.detach_dev			= smmu_detach_dev,
 };
 
 int kvm_arm_smmu_v3_register(void)
-- 
2.39.0

