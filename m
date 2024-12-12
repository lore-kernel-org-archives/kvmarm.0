Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51404237FC8
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026746; cv=none; b=kgGvXYIQXWvS7a5a6RTq6aawlfsAdbul3X8miXubBq9MqmqXdNAXGoaNynsHam6Ouq80vFu1TpxmSyxzHUe1Tgc4rH73snbI8GaAMmqjdgZFeIP4+F9FMaS2Va/P6IHcGxwZxtSmBS5Qk4TGp2YWe0HrhQJde3LDdYNTc+DhmEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026746; c=relaxed/simple;
	bh=vYlQF/00jW9GBGXp+yQV9E45uql11nRB0ar6n3dkdhQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=N0mTQ0kkt6KuUXHHU+7Gu4rZsJXrZgF0yB0NlrtFwwtCB47zqIK6ZyrfEPnA6ZD5hKQEhijiP5CzDbB/tJAyxWiRUNg9hn5UZNlC8cJQSEG/qf0bodNNeMd6rQZ5uxWeajD7L8szEyTN3+QsUsiXKSYMwGHi5FLNPuX7dssQ1GM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mys089dR; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mys089dR"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-385e03f54d0so429748f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026742; x=1734631542; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=1LMxyNsNja8u4zNmyLLENTRCKJqkK6QgSakPe49cILk=;
        b=mys089dRvmeYkdMOCPv77kOsRIHa0Uc/ZdLuEsPCC/atQRHMdodYL6sTxdgaNXTNig
         QbZQ3e3sjDg4jUrIEFyt201yHlCxay1ggNDKggwUN6bRXFfZJgVriiHk3hjNr4W8JDl/
         1KTzZHHOMd7haQZesoHdak4yYKrnr4pzuN1s5ZDmIcNthZ+6UA65RuW6AIrkoNdyh0Mp
         X0GResVKAStECniddJu3o6d3IqtTCLFs+ll00AEWJzQN/Vk8qYQglRU8W0Ghq3ala+Gk
         BMPWp1H4wu0BrwBQQkDFZguKWtkhPXr+ngh0jYtAx3hmBOXubZF5rORP3zmmeOfEMQX/
         Vx2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026742; x=1734631542;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1LMxyNsNja8u4zNmyLLENTRCKJqkK6QgSakPe49cILk=;
        b=dbHzA1xdjB9bqSWCzs4tAjz9dsKvZwRSQ/M6QnRuOVaXnXppM0DJx+mkgBu1bZJ3ue
         qkpoSRwTtw4VeBx0M7XpKdhCLSEiQCGCh5skESboe1VMbeXJOwtJ07jLYuhTWwQamrAM
         AbDbNW5oABwjULhtvF7n6CPR9gN6Ycj2wskHBgNrTvE+arsk+oPz6gbL/8d4sIgeJsqu
         KyD6yMo3mIGPXCX0GME5ul2axZdGvq/PSG1fQYekJq4iCp65gkvUOha8GdB3aaWrhR6Q
         r9cZyr1FZiF8x/HjNYFQSEz0xePWa/Gik2Dp8oZIcwEpZCGPisPuNfo98vcqGE1ZeGkw
         BuAg==
X-Forwarded-Encrypted: i=1; AJvYcCXsrv7dfMYjNzBFfgelVp3X8CD11KilO71kLRf73Ns9euVZ659506ZcwadQ4wFhon6Pc8hdT2w=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMm24+So0lfbAT//gMBevSjwxhTuHCcSYbEQCmBuTbZZa4igQi
	eAXmwObg7kjcF2Y5y0CGk82lNVpAnGi0jvkPXeIbcBlUCq9W6oU1HJ9KCGNmoYJozJibAjcdSmX
	5wCFBqD1KFg==
X-Google-Smtp-Source: AGHT+IFPY+N9wTZ2tcFqUmavonh5uuqwBF4VmdeOBIMSWGf8ApdTWlq6S7L/pJ7JZxynPwo+SB3rplDprL91sA==
X-Received: from wmbdx10.prod.google.com ([2002:a05:600c:63ca:b0:436:1a60:654e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5f47:0:b0:382:6f3:a20f with SMTP id ffacd0b85a97d-3864ce8956dmr7667344f8f.11.1734026741969;
 Thu, 12 Dec 2024 10:05:41 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:52 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-29-smostafa@google.com>
Subject: [RFC PATCH v2 28/58] KVM: arm64: smmu-v3: Setup stream table
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Map the stream table allocated by the host into the hypervisor address
space. When the host mappings are finalized, the table is unmapped from
the host. Depending on the host configuration, the stream table may have
one or two levels. Populate the level-2 stream table lazily.

Also, add accessors for STEs.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 157 +++++++++++++++++++-
 include/kvm/arm_smmu_v3.h                   |   3 +
 2 files changed, 159 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index e15356509424..43d2ce7828c1 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -174,7 +174,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait_event(smmu, smmu_cmdq_empty(smmu));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -186,6 +185,94 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+__maybe_unused
+static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CFGI_STE,
+		.cfgi.sid = sid,
+		.cfgi.leaf = true,
+	};
+
+	return smmu_send_cmd(smmu, &cmd);
+}
+
+static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_strtab_l1 *l1_desc;
+	dma_addr_t l2ptr_dma;
+	struct arm_smmu_strtab_l2 *l2table;
+	size_t l2_order = get_order(sizeof(struct arm_smmu_strtab_l2));
+	int flags = 0;
+
+	l1_desc = &cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)];
+	if (l1_desc->l2ptr)
+		return 0;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		flags |= IOMMU_PAGE_NOCACHE;
+
+	l2table = kvm_iommu_donate_pages(l2_order, flags);
+	if (!l2table)
+		return -ENOMEM;
+
+	l2ptr_dma = hyp_virt_to_phys(l2table);
+
+	if (l2ptr_dma & (~STRTAB_L1_DESC_L2PTR_MASK | ~PAGE_MASK)) {
+		kvm_iommu_reclaim_pages(l2table, l2_order);
+		return -EINVAL;
+	}
+
+	/* Ensure the empty stream table is visible before the descriptor write */
+	wmb();
+
+	arm_smmu_write_strtab_l1_desc(l1_desc, l2ptr_dma);
+	return 0;
+}
+
+static struct arm_smmu_ste *
+smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		struct arm_smmu_strtab_l1 *l1_desc =
+					&cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)];
+		struct arm_smmu_strtab_l2 *l2ptr;
+
+		if (arm_smmu_strtab_l1_idx(sid) > cfg->l2.num_l1_ents)
+			return NULL;
+		/* L2 should be allocated before calling this. */
+		if (WARN_ON(!l1_desc->l2ptr))
+			return NULL;
+
+		l2ptr = hyp_phys_to_virt(l1_desc->l2ptr & STRTAB_L1_DESC_L2PTR_MASK);
+		/* Two-level walk */
+		return &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+
+	if (sid > cfg->linear.num_ents)
+		return NULL;
+	/* Simple linear lookup */
+	return &cfg->linear.table[sid];
+}
+
+__maybe_unused
+static struct arm_smmu_ste *
+smmu_get_alloc_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		int ret = smmu_alloc_l2_strtab(smmu, sid);
+
+		if (ret) {
+			WARN_ON(ret != -ENOMEM);
+			return NULL;
+		}
+	}
+	return smmu_get_ste_ptr(smmu, sid);
+}
+
 static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u64 val, old;
@@ -255,6 +342,70 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	u64 strtab_base;
+	size_t strtab_size;
+	u32 strtab_cfg, fmt;
+	int split, log2size;
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+
+	strtab_base = readq_relaxed(smmu->base + ARM_SMMU_STRTAB_BASE);
+	if (strtab_base & ~(STRTAB_BASE_ADDR_MASK | STRTAB_BASE_RA))
+		return -EINVAL;
+
+	strtab_cfg = readl_relaxed(smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+	if (strtab_cfg & ~(STRTAB_BASE_CFG_FMT | STRTAB_BASE_CFG_SPLIT |
+			   STRTAB_BASE_CFG_LOG2SIZE))
+		return -EINVAL;
+
+	fmt = FIELD_GET(STRTAB_BASE_CFG_FMT, strtab_cfg);
+	split = FIELD_GET(STRTAB_BASE_CFG_SPLIT, strtab_cfg);
+	log2size = FIELD_GET(STRTAB_BASE_CFG_LOG2SIZE, strtab_cfg);
+	strtab_base &= STRTAB_BASE_ADDR_MASK;
+
+	switch (fmt) {
+	case STRTAB_BASE_CFG_FMT_LINEAR:
+		if (split)
+			return -EINVAL;
+		cfg->linear.num_ents = 1 << log2size;
+		strtab_size = cfg->linear.num_ents * sizeof(struct arm_smmu_ste);
+		cfg->linear.ste_dma = strtab_base;
+		ret = ___pkvm_host_donate_hyp_prot(strtab_base >> PAGE_SHIFT,
+						   PAGE_ALIGN(strtab_size) >> PAGE_SHIFT,
+						   false, prot);
+		if (ret)
+			return -EINVAL;
+		cfg->linear.table = hyp_phys_to_virt(strtab_base);
+		/* Disable all STEs */
+		memset(cfg->linear.table, 0, strtab_size);
+		break;
+	case STRTAB_BASE_CFG_FMT_2LVL:
+		if (split != STRTAB_SPLIT)
+			return -EINVAL;
+		cfg->l2.num_l1_ents = 1 << max(0, log2size - split);
+		strtab_size = cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1);
+		cfg->l2.l1_dma = strtab_base;
+		ret = ___pkvm_host_donate_hyp_prot(strtab_base >> PAGE_SHIFT,
+						   PAGE_ALIGN(strtab_size) >> PAGE_SHIFT,
+						   false, prot);
+		if (ret)
+			return -EINVAL;
+		cfg->l2.l1tab = hyp_phys_to_virt(strtab_base);
+		/* Disable all STEs */
+		memset(cfg->l2.l1tab, 0, strtab_size);
+		break;
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int ret;
@@ -278,6 +429,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		return ret;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		return ret;
+
 	return kvm_iommu_init_device(&smmu->iommu);
 }
 
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index 393a1a04edba..352c1b2dc72a 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -2,6 +2,7 @@
 #ifndef __KVM_ARM_SMMU_V3_H
 #define __KVM_ARM_SMMU_V3_H
 
+#include <asm/arm-smmu-v3-common.h>
 #include <asm/kvm_asm.h>
 #include <kvm/iommu.h>
 
@@ -22,6 +23,8 @@ struct hyp_arm_smmu_v3_device {
 	u32			cmdq_prod;
 	u64			*cmdq_base;
 	size_t			cmdq_log2size;
+	/* strtab_cfg.l2.l2ptrs is not used, instead computed from L1 */
+	struct arm_smmu_strtab_cfg strtab_cfg;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.47.0.338.g60cca15819-goog

