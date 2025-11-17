Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BBA733FE26
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405334; cv=none; b=MXucwqi4fwTtq/V5CFW5zfU5AFkI5SIk0edmx3UvwRiSK8MguU9eh7sNGpp4Hj1+qq5CFdbdQccAMQJR2cGWmidfi5ZEefuJbwkMRdjfzBnPLFcXZ+GlAUDScywm9neds7fsiWcMmphVTFdWnHtj7nh7X0clmKdMoPIFH/di3VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405334; c=relaxed/simple;
	bh=OZ4uQ0yDoACRmNdHRBQeRNzIXtXWO2EVRqqs9TQAI90=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p0nO+1wFx1IzsMsZOOwfgkGI+wBBzBR7UwT5gKjZxuEUHmfb/+MU4XFUtNgIfib1bvDj1lwGGLm2hbI6DHJco59lVROKXX4hFkXLOFLYGpvPsX5DBlolb256uW23FWfobxtiKpY6TZV8WDYRwM4NFwPMMwHlMQY+HvPZwGNBlU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VGn+RoM2; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VGn+RoM2"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2ffbba05so2450777f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405329; x=1764010129; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qs8S7LI/sbSmCau3G8bqaka/RHnKzp9VmZFW3fnA4G8=;
        b=VGn+RoM2hBi90EvTfEyB+HKQdDbsBl15vHZfzBcHzVRwPkKLrlZnFasqosjUU22WJd
         KJNQMffJjDs9Z69t3fhrygq6fgYIJzBa9032dz2g7N+ocACRtVNkfQFoschtG8zAvMuV
         ncPbe9aIF3tHWAyHh6NH3fE2soq9FPiCr414UeR/sLzG+ZdtdogRig3tGWFkvuLYmQtj
         Y/IZ/HFP8M77Bxqa6boL34SomElyYuNIJl3jFJNEWeSnH78FIErYP0RNE06w1u6MS/5R
         hDo4YCX7mUy10Op0w67BEGgxbovvE6L+D3gYO3I2YuIjuP5rU0Q/dJrzcS8RI5WXaAg7
         iKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405329; x=1764010129;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qs8S7LI/sbSmCau3G8bqaka/RHnKzp9VmZFW3fnA4G8=;
        b=O4EQCwamDmKfJyMlwuO1F+SpaZjOaOLtCUEIUDYbsQAW0yxZSNP9XQOM0jthy5yz2y
         x123rKGPP2pn7FGcoan9CliOxr/nfM+QCLHzMvS13cGYECQV4iQ3pNaEwZiqdd6OtF/B
         X8ooNKnHIk4qBpf1y5YP4zjepC0IH2lXLSjECIqELH9cNrCaoz6WyQW8pwNwHazK7hhl
         73MBMNtUBSDwzQdFEJNaAeYRHXgO31AXYu3C8YTvWSJ81gNpPEfDMGRlodX3p2/Woa8G
         OXXZzbs4QbO9M0ZqkQbfv6zW1DRqe5bKCK1qS5NAaimigZZuzBc/riHGj2VsJPvQyUTg
         Y7Og==
X-Forwarded-Encrypted: i=1; AJvYcCU/Ley/coqnsRHs8DM7jHKn43xPqePOWH8/6J46R/J8Qtg5jyX2fnx7k+ZR0PaA1kmwRe4Iok4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw84Z/ozXsSF19fU+P30csM6wQBTbnBCVCQljBnZOhgkSFHCcPf
	j39auSas4pYnPg5Ylb4az/Od31MtzKlnJgnz5pNyVM+7YNtGXQkDNpdC6Wip7H4tQ56FfkhLlip
	5PZ3NRNZd9FrwQA==
X-Google-Smtp-Source: AGHT+IEaVN1RJqQh1usVWtaU2+GmutZ2HuXAEHxOLo10Rm858igk+GLC7xcyxVVFvzJzEDXSgQJrFWO0SiMrKA==
X-Received: from wrbfq12.prod.google.com ([2002:a05:6000:2a0c:b0:42b:5250:ee1b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:3106:b0:42b:3b4c:f411 with SMTP id ffacd0b85a97d-42b5938a9e3mr13616468f8f.36.1763405328637;
 Mon, 17 Nov 2025 10:48:48 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:10 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-24-smostafa@google.com>
Subject: [PATCH v5 23/27] iommu/arm-smmu-v3-kvm: Shadow STEs
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch adds STE emulation, this is done when the host sends the
CFGI_STE command.

In this patch we copy the STE as is to the shadow owned by the hypervisor,
in the next patch, stage-2 page table will be attached.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 92 +++++++++++++++++--
 1 file changed, 86 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 9e515a130711..fbe1e13fc15d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -22,6 +22,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 #define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
 #define strtab_l1_size(smmu)	((1 << (strtab_log2size(smmu) - strtab_split(smmu))) * \
 				 (sizeof(struct arm_smmu_strtab_l1)))
+#define strtab_hyp_base(smmu)	((smmu)->features & ARM_SMMU_FEAT_2_LVL_STRTAB ? \
+				 (u64 *)(smmu)->strtab_cfg.l2.l1tab :\
+				 (u64 *)(smmu)->strtab_cfg.linear.table)
 
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
@@ -283,6 +286,80 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+/* Get an STE for a stream table base. */
+static struct arm_smmu_ste *smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu,
+					     u32 sid, u64 *strtab)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_ste *table = (struct arm_smmu_ste *)strtab;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		struct arm_smmu_strtab_l1 *l1tab = (struct arm_smmu_strtab_l1 *)strtab;
+		u32 l1_idx = arm_smmu_strtab_l1_idx(sid);
+		struct arm_smmu_strtab_l2 *l2ptr;
+
+		if (WARN_ON(l1_idx >= cfg->l2.num_l1_ents) ||
+			!(l1tab[l1_idx].l2ptr & STRTAB_L1_DESC_SPAN))
+			return NULL;
+
+		l2ptr = hyp_phys_to_virt(l1tab[l1_idx].l2ptr & STRTAB_L1_DESC_L2PTR_MASK);
+		/* Two-level walk */
+		return &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+	if (WARN_ON(sid >= cfg->linear.num_ents))
+		return NULL;
+	return &table[sid];
+}
+
+static int smmu_shadow_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	u32 idx = arm_smmu_strtab_l1_idx(sid);
+	u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+	struct arm_smmu_strtab_l1 *l1_desc = &smmu->strtab_cfg.l2.l1tab[idx];
+	u64 l1_desc_host;
+	struct arm_smmu_strtab_l2 *l2table;
+
+	l2table = kvm_iommu_donate_pages(get_order(sizeof(*l2table)));
+	if (!l2table)
+		return -ENOMEM;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		kvm_flush_dcache_to_poc(&host_ste_base[idx], sizeof(*l1_desc));
+	l1_desc_host = host_ste_base[idx];
+
+	arm_smmu_write_strtab_l1_desc(l1_desc, hyp_virt_to_phys(l2table));
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		kvm_flush_dcache_to_poc(l1_desc, sizeof(*l1_desc));
+
+	smmu_share_pages(l1_desc_host & STRTAB_L1_DESC_L2PTR_MASK, sizeof(*l2table));
+	return 0;
+}
+
+static void smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool leaf)
+{
+	u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+	u64 *hyp_ste_base = strtab_hyp_base(smmu);
+	struct arm_smmu_ste *host_ste_ptr = smmu_get_ste_ptr(smmu, sid, host_ste_base);
+	struct arm_smmu_ste *hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
+
+	/*
+	 * Linux only uses leaf = 1, when leaf is 0, we need to verify that this
+	 * is a 2 level table and reshadow of l2.
+	 * Also Linux never clears l1 ptr, that needs to free the old shadow.
+	 */
+	if (WARN_ON(!leaf || !host_ste_ptr))
+		return;
+
+	/* If host is valid and hyp is not, means a new L1 installed. */
+	if (!hyp_ste_ptr) {
+		WARN_ON(smmu_shadow_l2_strtab(smmu, sid));
+		hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
+	}
+
+	smmu_copy_from_host(smmu, hyp_ste_ptr->data, host_ste_ptr->data,
+			    STRTAB_STE_DWORDS << 3);
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -402,8 +479,13 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
 	switch (type) {
 	case CMDQ_OP_CFGI_STE:
-		/* TBD: SHADOW_STE*/
+	{
+		u32 sid = FIELD_GET(CMDQ_CFGI_0_SID, command[0]);
+		u32 leaf = FIELD_GET(CMDQ_CFGI_1_LEAF, command[1]);
+
+		smmu_reshadow_ste(smmu, sid, leaf);
 		break;
+	}
 	case CMDQ_OP_CFGI_ALL:
 	{
 		/*
@@ -576,23 +658,21 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			regs->regs[rd] = smmu->cmdq_host.llq.cons | err;
 		}
 		goto out_ret;
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_STRTAB_BASE:
 		if (is_write) {
 			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
 			WARN_ON(is_smmu_enabled(smmu));
 			smmu->host_ste_base = val;
 		}
-		mask = read_write;
-		break;
+		goto out_ret;
 	case ARM_SMMU_STRTAB_BASE_CFG:
 		if (is_write) {
 			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
 			WARN_ON(is_smmu_enabled(smmu));
 			smmu->host_ste_cfg = val;
 		}
-		mask = read_write;
-		break;
+		goto out_ret;
+	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
-- 
2.52.0.rc1.455.g30608eb744-goog

