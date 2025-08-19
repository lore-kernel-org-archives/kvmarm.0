Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDF634165A
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640370; cv=none; b=JPBe6v7YnEdxFW2ppeKuWUUD//CtTm2uXKQgYowPRHlOM5DzsECVp+CMUo7nV1qYhQSz84spuqlBaGRJ2eWsp1dBaoY51wJA4S/NYtcPK1Srrn8OWwPXHU+XeU2lS/a0XfUfY+ih35OS2G14P7Mdpehp/mPPZd0H0nzJVFkPgN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640370; c=relaxed/simple;
	bh=9B+IUAI36ouSms7t4Ms79PVbPypli/gAzLkEi+fAwyI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fh/ypokh8uY0ItJEknI5DFGBZ+jxSyL3Jaa68GB7WVsdrOF2j4E+mx/1s5h/72kJYXP2hQ3xT1CphyRB67xGH93Ybg3oId2hLlqHU2AGs9O1D2uoQ8b3+KghMB+N4G3atKoegHFiODV21a8WcUZfiq96MwL2afk+m7DSvJKyDLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jx/3UT/3; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jx/3UT/3"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b05a59cso35208895e9.1
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640367; x=1756245167; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7sk4h0o5FTOh9oFFMoej2yRTt0xkrjtRUSeSqNCk5ts=;
        b=Jx/3UT/35oYn8mPzHMNf5nqFK+Z7+395tTAgFgvvPwPFBLe14TrijXOSeAmwomv2Ib
         HTcUCI6iwHCwTZ/bUfkI0jLMZ/IG6YvBMzIW1bxrPQqCKqxtFToGZA7JsBx4W6qpbMPY
         eIqXys3fCfSSKq1kEeYVltHGSKBjOfHg5T4wccY1hjkA1+6nE304I09DWq96Kk/xfjv6
         o81j+A5NXYQijyUY9M87QX0Qd2u4P+iPZu2COwXNU4xqKyup30maIyD3/uYXM02hMmtt
         kFV3QBlRebPj1Gn/5xgRL+sO6lKRDXmLXBQVaWpvI1TcjY02TDczYV5zojSJug2jbgWW
         QHog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640367; x=1756245167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7sk4h0o5FTOh9oFFMoej2yRTt0xkrjtRUSeSqNCk5ts=;
        b=xGlTyFYqWaictxt5i+gyo/bgz7lNsGbCSR983kg7D2gszhaHkKQHmmxUv0RgjMg9ta
         eNP+M56MZsftHzdvssvu81j712fJIGjZgygEtleTKVdptCY1/3VJG7kezRCsGyow0xSq
         O2gvTbt1IJFt5eBSnRqVHJeAk/NDEhFTuI40gbKzm5jFj2A5DHIAgmeV4FZcpCup8KAd
         CO2xHberERSjE67YXqV6/ijq/2pxpm33dAjTphdnBFjUbbraA4zIjn9kA6l0LWwBQD7V
         fO3c3vlktu3WdEMFEsS3fF8ntdcW9IDUJlIo6I9V7CBdpKrhmpBloPI0bBvxoxQ6NVKY
         IlTQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwzHluztUA4cblKKU5WagETTJwjqeL9g/hRbiVGR1pn6d/uDjdAJr1zGuGCfuHFQflbcyqjnQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXWGtUrCQ4R6SaNxT5ahYNa9YCTA7qigD6EKM0GdKmG9RZelmB
	1guknuDnJ2Mar85njv/AZlkj1vqiGX4I2jLZKNCtdeoKhOB6Ljfs0afCuZqniO+RpSUfKsMEbNK
	U7VJpRN74Q/FJ4Q==
X-Google-Smtp-Source: AGHT+IFUpQvsGMxlMZxN5e8l+1BLUo+tGugwis/W3Zc75woWAnm0Ggc8nFVugp0gt+/gCvYhg6NiMTal3YfIkg==
X-Received: from wmbhc18.prod.google.com ([2002:a05:600c:8712:b0:458:bb2b:d73e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2dc6:b0:3bd:148e:212 with SMTP id ffacd0b85a97d-3c32ca0701emr371514f8f.14.1755640366978;
 Tue, 19 Aug 2025 14:52:46 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:52 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-25-smostafa@google.com>
Subject: [PATCH v4 24/28] iommu/arm-smmu-v3-kvm: Shadow STEs
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch adds STE emulation, this is done when the host sends the
CFGI_STE command.

In this patch we copy the STE as is to the shadow owned by the hypervisor,
in the next patch, stage-2 page table will be attached.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 95 +++++++++++++++++--
 1 file changed, 89 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index d722f8ce0635..0f890a7d8db3 100644
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
@@ -263,6 +266,83 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
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
+		   !(l1tab[l1_idx].l2ptr & STRTAB_L1_DESC_SPAN))
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
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_strtab_l2 *l2table;
+	u32 idx = arm_smmu_strtab_l1_idx(sid);
+	u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+	u64 l1_desc_host = host_ste_base[idx];
+	struct arm_smmu_strtab_l1 *l1_desc = &cfg->l2.l1tab[idx];
+
+	l2table = kvm_iommu_donate_pages(get_order(sizeof(*l2table)));
+	if (!l2table)
+		return -ENOMEM;
+	arm_smmu_write_strtab_l1_desc(l1_desc, hyp_virt_to_phys(l2table));
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		kvm_flush_dcache_to_poc(l1_desc, sizeof(*l1_desc));
+
+	/*
+	 * Now set the hyp l1 to a shared state.
+	 * As mentioned in smmu_reshadow_ste() Linux never clears L1 ptrs,
+	 * so no need to handle that case. Otherwise, we need to unshare
+	 * the tables and emulate STE clear.
+	 */
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
+	int i;
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
+	for (i = 0; i < STRTAB_STE_DWORDS; i++)
+		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -390,8 +470,13 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
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
@@ -564,23 +649,21 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
2.51.0.rc1.167.g924127e9c0-goog

