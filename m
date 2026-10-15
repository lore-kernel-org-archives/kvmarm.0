Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3138358E2B6
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094978; cv=none; b=oBt8DbSagFo7e9Zd5iYJjCH3NANBodJaXjfivh04aBRTkUxYoIdrPaPjEhU9AU2k80acCbIdI+E1sOWJ7uTULxijxrVDb2xRVqkwSj3pYyi0nqHOJ8as6ZeWkq9UQMqFfZj4NN0ThrezFr8Jdu64+fctiMIUKGzlgAHnrNWy1xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094978; c=relaxed/simple;
	bh=iTalrg1xW1kAOUo6QghDdcHthHRFMoeDKbdR5Syc7gg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G0v1XQSCdIknLn14UuHnFoi5ZinfqdZbkNd/cCk4tEsYO0JUaqxBHA0e3FGW5Tp50+z/amI45AXYKe543Rc1ov1XgnGKSp62ToWBd0wgLbvHP+ux7Lx5bj9joja/U7Vppisyab028khqpm2Y2X9pLhWVc0o8cGw5MkL+lZMmqOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aj3eVadi; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aj3eVadi"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-48b01a74792so3724749f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094973; x=1792699773; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FI4iSn8zAFr7RU3MPIgQJ9gzmtZlTDgEvk+laO2rSqk=;
        b=aj3eVadiMJ5nQ8P5nQ6J82YPccBdHnxPMfRgFqiGZk4cMm1ZAqJL6kCGt3X3wa1Kp0
         OOvCav+DkXcNBFkiiEAV71zfZjVYhfZ27Yw5R6QEhRf4C/cwlWnWSO81xgaa0YKc6nrF
         wKSPQaBUECN1PNITpEMX6Qh/WAEBQOpLIfMJFaA3tIs0SUfV7PLNsg05WH6X8el4JkFM
         9IH0OSEKo0xDVNHAYGTqpjiNckJl1FoM7yT7v0VnAr60FESwK+xP0S0jYn3Et+JBkvvw
         A7spXmUXNMikM5YigMCeFBrHYNsi3ejChbbHxmYiGm5KAkUlRhGIuDSTqs6Z2ykiJDUz
         2taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094973; x=1792699773;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FI4iSn8zAFr7RU3MPIgQJ9gzmtZlTDgEvk+laO2rSqk=;
        b=WQmmk0PotiW2NmTM9U9/7BHCoh0I4l7ZG91CN8F8hWYlYv5dgzVgffyPQko/QjyeCg
         /wLDY14TD+z8kbFzMWCJIvdTgAy7D5L1qnkdBu9lhjNPac5Jn9/fwKIt70j5PLnttvYe
         v7MBVu9/3l7W4yk4uI6ZxAiE5jozVSb4XSZeO8gF1KFsoi1ACAFtPhPjrDLeJpnBU/GT
         gnZUwKrEUJ9iC/7A+/xJlVXRWKa4JeucPXhPMduHj1ijamXovR9nTX1Jiiu8b4mx23a9
         k0JBW+XmAyS//JtxCVzwqUwL1wkd8Jd9Mp7bf1iCLshIezuWXPk7Xrg2+72gsuI+hdk/
         3XLQ==
X-Forwarded-Encrypted: i=1; AKwUvBxK6WI55VvUdE+3IxQGsQntA+SyZ5M09yGWvJhYPcGkffJxYYnplmh2jQf+wZdLOIIy6jYdhsU=@lists.linux.dev
X-Gm-Message-State: AFq9FYIfOAvRI4XMHZlXiVSOizW3WMPloToNoOznRdKB6lydui2sFD7R
	5OhXwiJfw6T/5gI0bFszxLzPJu8/wdgJapcYzvhT2uFMsAVTRVf7v/j0xsQEkMtziJKfpNZ8sJ1
	SDA9hHFwwQcnkvQ==
X-Received: from wrqr3.prod.google.com ([2002:a5d:4983:0:b0:48b:9d:e37d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2dc1:b0:488:8850:50ec with SMTP id ffacd0b85a97d-48de2b4d7e5mr19390320f8f.46.1792094973106;
 Thu, 15 Oct 2026 13:09:33 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:49 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-19-smostafa@google.com>
Subject: [PATCH v9 18/25] iommu/arm-smmu-v3-kvm: Shadow STEs
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Shadow the STE when the host sends CFGI_STE: copy the host entry as is
into the hypervisor-owned stream table, which is the one the hardware
uses. For 2-level tables the host L2 table is shared and pinned while
the entry is read, and the hypervisor L2 table is allocated from the
IOMMU pool the first time its L1 slot is used.

STRTAB_BASE and STRTAB_BASE_CFG are no longer passed through: writes are
recorded while the SMMU is disabled and reads return the recorded
values.

The next patch attaches the stage-2 page table to the shadow entry.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 124 +++++++++++++++++-
 1 file changed, 118 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 0fa98915e00d..132f3a9ba308 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -25,6 +25,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 #define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
 #define strtab_l1_size(smmu)	((1UL << (strtab_log2size(smmu) - strtab_split(smmu))) * \
 				 (sizeof(struct arm_smmu_strtab_l1)))
+#define strtab_hyp_base(smmu)	((smmu)->features & ARM_SMMU_FEAT_2_LVL_STRTAB ? \
+				 (u64 *)(smmu)->strtab_cfg.l2.l1tab :\
+				 (u64 *)(smmu)->strtab_cfg.linear.table)
 
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
@@ -290,6 +293,91 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_get_host_l2_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid,
+				struct arm_smmu_ste *host_ste_out)
+{
+	u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+	struct arm_smmu_strtab_l1 host_l1_desc;
+	struct arm_smmu_strtab_l2 *l2ptr;
+	phys_addr_t host_l2_tab;
+	int ret, i;
+
+	host_l1_desc.l2ptr = READ_ONCE(host_ste_base[arm_smmu_strtab_l1_idx(sid)]);
+	if (!(le64_to_cpu(host_l1_desc.l2ptr) & STRTAB_L1_DESC_SPAN))
+		return -EINVAL;
+
+	host_l2_tab = le64_to_cpu(host_l1_desc.l2ptr) & STRTAB_L1_DESC_L2PTR_MASK;
+	/* Share and pin the table before accessing it. */
+	ret = smmu_share_pages(host_l2_tab, sizeof(struct arm_smmu_strtab_l2));
+	if (ret)
+		return ret;
+
+	l2ptr = hyp_phys_to_virt(host_l2_tab);
+
+	for (i = 0; i < STRTAB_STE_DWORDS; ++i)
+		host_ste_out->data[i] =
+			READ_ONCE(l2ptr->stes[arm_smmu_strtab_l2_idx(sid)].data[i]);
+
+	WARN_ON(smmu_unshare_pages(host_l2_tab, sizeof(struct arm_smmu_strtab_l2)));
+	return 0;
+}
+
+static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool leaf)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_ste *hyp_ste_ptr, *host_ste_ptr, host_ste_copy;
+	u64 *hyp_ste_base = strtab_hyp_base(smmu);
+	int ret, i;
+
+	/* Leaf = 0 is not supported, as the kernel driver. */
+	if (!leaf || !is_smmu_enabled(smmu) ||
+	    (sid >= (1UL << strtab_log2size(smmu))))
+		return -EINVAL;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB)) {
+		struct arm_smmu_ste *hyp_table = (struct arm_smmu_ste *)hyp_ste_base;
+		u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+		struct arm_smmu_ste *host_table = (struct arm_smmu_ste *)host_ste_base;
+
+		if (sid >= cfg->linear.num_ents)
+			return -E2BIG;
+
+		hyp_ste_ptr = &hyp_table[sid];
+		host_ste_ptr = &host_table[sid];
+	} else {
+		struct arm_smmu_strtab_l1 *l1tab = (struct arm_smmu_strtab_l1 *)hyp_ste_base;
+		u32 l1_idx = arm_smmu_strtab_l1_idx(sid);
+		struct arm_smmu_strtab_l2 *l2ptr;
+
+		if (l1_idx >= cfg->l2.num_l1_ents)
+			return -E2BIG;
+
+		host_ste_ptr = &host_ste_copy;
+		ret = smmu_get_host_l2_ste(smmu, sid, host_ste_ptr);
+		if (ret)
+			return ret;
+
+		/* No hypervisor entry, first time the L2 is populated. */
+		if (!l1tab[l1_idx].l2ptr) {
+			struct arm_smmu_strtab_l2 *l2table;
+
+			l2table = pkvm_iommu_alloc_pages(get_order(sizeof(*l2table)));
+			if (!l2table)
+				return -ENOMEM;
+			/* Ensure L2 is observed before writing the ptr. */
+			dma_wmb();
+			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2table));
+		}
+		l2ptr = hyp_phys_to_virt(le64_to_cpu(l1tab[l1_idx].l2ptr) &
+				STRTAB_L1_DESC_L2PTR_MASK);
+		hyp_ste_ptr = &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+
+	for (i = 0; i < STRTAB_STE_DWORDS; ++i)
+		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);
+	return 0;
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -410,8 +498,24 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
 	switch (type) {
 	case CMDQ_OP_CFGI_STE:
-		/* TBD: SHADOW_STE*/
+	{
+		u32 leaf = FIELD_GET(CMDQ_CFGI_1_LEAF, command[1]);
+		u32 sid = FIELD_GET(CMDQ_CFGI_0_SID, command[0]);
+		int ret;
+
+		/*
+		 * If STE update is required, flush the CMDQ and drop the lock as that
+		 * might require to update the host page table and acquire its lock.
+		 */
+		writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
+		hyp_spin_unlock(&smmu->hw_lock);
+		ret = smmu_reshadow_ste(smmu, sid, leaf);
+		hyp_spin_lock(&smmu->hw_lock);
+		if (ret)
+			return true;
+
 		break;
+	}
 	case CMDQ_OP_CFGI_ALL:
 	{
 		/*
@@ -627,25 +731,33 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			val = smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
 			goto out_update_regs;
 		}
-	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_STRTAB_BASE:
+		if (len != sizeof(u64))
+			break;
 		if (is_write) {
 			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
 			if (is_smmu_enabled(smmu))
 				break;
 			smmu->host_ste_base = val;
+			goto out_ret;
+		} else {
+			val = smmu->host_ste_base;
+			goto out_update_regs;
 		}
-		mask = read_write;
-		break;
 	case ARM_SMMU_STRTAB_BASE_CFG:
+		if (len != sizeof(u32))
+			break;
 		if (is_write) {
 			/* Must only be written when SMMU_CR0.SMMUEN == 0. */
 			if (is_smmu_enabled(smmu))
 				break;
 			smmu->host_ste_cfg = val;
+			goto out_ret;
+		} else {
+			val = smmu->host_ste_cfg;
+			goto out_update_regs;
 		}
-		mask = read_write;
-		break;
+	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
-- 
2.56.0.176.g3575e65682-goog

