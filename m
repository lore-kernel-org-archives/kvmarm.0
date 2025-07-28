Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 975C82853F8
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725235; cv=none; b=G8zvGv2dqKrKrRqxNKZuJ0uXqzOfJY8NIBT0halXZhxjiZ3r5Xbh8kh3HmmtCH/g98sBIZsJJ5GgOWDW7VurZMRqqJSwIOTqQ5FL+1FgZVIJYZy43B1Ysy7ibS2U7FG1+o7oky+1bj1uotjVgMVh7TgmXCt9YScvMUyrM5u2oJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725235; c=relaxed/simple;
	bh=+pifKQr5Qh4NMurqKawmpfa05NihZwVLx0NY9kl4hVw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=W/YzVOWxXxhe8wN+X2yepL/ZcMFwWhl4cdQ5YqpYb8A6gDsoG9CPX8wx7zluGdnYpC+WOOzYX/EKdGVxun7GKcCSUXnjxJEzD59TaNof61L2JCaprSpIRJNz0IFbGgfqJNuCMDEwTXWs1e6s/65xeclAvntc1f8SsfiEZ3n9nms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rQOnrkz5; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rQOnrkz5"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-456175dba68so28133065e9.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725230; x=1754330030; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l5usyBMYtPhEtq515HRsyRf5iQD/7LGEqXNtQxILf1Y=;
        b=rQOnrkz5PbhF03m3hDbC5A1XY7uU++KNXj/ErDrRJUPv3aCvTH6mgL9tzwl33aLosR
         PmDL6luRqXIdVZmJSJnv7tCRKg0pOPdOdJaD7k7bjn4BERyQ4RNe+27lcWgZrIxxcwUB
         Xemrfvtd9ABNTJchC0LURNEgCjbyaqkROkk/+GEAcEBXUDeVpV1D4RNngqCAZaHNebn4
         004aUS9y5/t7bzt4JlMISH+gbTIni3BAFCsrkaE3w/BISvezbb0hOc50lWbM4DJ24hcY
         R/kawHQAj56gHPg4H8AO6EUN66cMCJvWwMIi1ASyW2IgleAkYZ9y/nIUzlEglETtV2rF
         bb9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725231; x=1754330031;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l5usyBMYtPhEtq515HRsyRf5iQD/7LGEqXNtQxILf1Y=;
        b=SkD8Vj2+D4Ls3EHpTPte9FmJ2pUe0+NQybmAbNk+oDGu0Uv1wssfG9BgZi7mTItJv+
         oKSanpviAXmX5K5SchnlhqI8W2W2tInY2doA4TEv3ETL69R9P8/P823lamuvFLF75LS0
         pv911Mhf4gdB97Rz8ILeFf2RNS9mMM7KMKXZXC5QIZT4VvLgFCKRQKCoIVB7zrI2G013
         TnA/Tp0V5IWZd1ua1eZ37wn4gCxrNPnsHTjIeXXlROufBaMLmlBO3BwZjHo4voP6VjZE
         kp96yUxfHoR0RDskjMQAalK++ZOyu8leGOYRMmKAZwtU/qnYrC/G1agPoNgN1DydQd8B
         R59w==
X-Forwarded-Encrypted: i=1; AJvYcCX0zrOTS/zM0FXRXZxyqYhzbvWiglBbsnRYlWpcrxmgPBQZIAMgLZ6qTL1lna3uYhJT/jbKC5k=@lists.linux.dev
X-Gm-Message-State: AOJu0YwNbeABEqVbvjUAqouZp43mb7Ohm4F7sQ2WPqirREj/wo0Nf/RP
	BPc2ebpde7vUR5iDhiSK/b71V9a03ng5Sce5pkkBwBYzKBr3aZPaSVZNAIn6Xs03jxMvrjuYDko
	CF4zTcff3dWLRHw==
X-Google-Smtp-Source: AGHT+IEOasiCkaHWORBz/kHZ+SsH5TCiId9F4oswqdHG41LqtBvjent3B9CKHId8hskBgKaxbm/Ao9Q5mfQBGA==
X-Received: from wmsd5.prod.google.com ([2002:a05:600c:3ac5:b0:456:134a:a210])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d24:b0:455:de98:c504 with SMTP id 5b1f17b1804b1-4588b5fb608mr28234885e9.0.1753725230800;
 Mon, 28 Jul 2025 10:53:50 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:08 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-22-smostafa@google.com>
Subject: [PATCH v3 21/29] iommu/arm-smmu-v3-kvm: Setup stream table
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Map the stream table allocated by the host into the hypervisor address
space. When the host mappings are finalized, the table is unmapped from
the host. Depending on the host configuration, the stream table may have
one or two levels. Populate the level-2 stream table lazily.

Also, add accessors for STEs.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common.h      |  16 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  16 ---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 102 +++++++++++++++++-
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |   2 +
 4 files changed, 119 insertions(+), 17 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
index ab6db8b4b9f2..a24fdbdaeb74 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.h
@@ -499,6 +499,22 @@ struct arm_smmu_queue {
 					 Q_IDX(&((q)->llq), p) *	\
 					 (q)->ent_dwords)
 
+struct arm_smmu_strtab_cfg {
+	union {
+		struct {
+			struct arm_smmu_ste *table;
+			dma_addr_t ste_dma;
+			unsigned int num_ents;
+		} linear;
+		struct {
+			struct arm_smmu_strtab_l1 *l1tab;
+			struct arm_smmu_strtab_l2 **l2ptrs;
+			dma_addr_t l1_dma;
+			unsigned int num_l1_ents;
+		} l2;
+	};
+};
+
 static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 						 dma_addr_t l2ptr_dma)
 {
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index f9a496e0bd94..480463ec118a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -232,22 +232,6 @@ struct arm_smmu_s2_cfg {
 	u16				vmid;
 };
 
-struct arm_smmu_strtab_cfg {
-	union {
-		struct {
-			struct arm_smmu_ste *table;
-			dma_addr_t ste_dma;
-			unsigned int num_ents;
-		} linear;
-		struct {
-			struct arm_smmu_strtab_l1 *l1tab;
-			struct arm_smmu_strtab_l2 **l2ptrs;
-			dma_addr_t l1_dma;
-			unsigned int num_l1_ents;
-		} l2;
-	};
-};
-
 struct arm_smmu_impl_ops {
 	int (*device_reset)(struct arm_smmu_device *smmu);
 	void (*device_remove)(struct arm_smmu_device *smmu);
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index c3d67c603619..74e6dfb53528 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -119,7 +119,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait_event(smmu, smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmdq_ent *cmd)
 {
@@ -131,6 +130,80 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+__maybe_unused
+static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, unsigned long ste)
+{
+	struct arm_smmu_cmdq_ent cmd = {
+		.opcode = CMDQ_OP_CFGI_STE,
+		.cfgi.sid = sid,
+		.cfgi.leaf = true,
+	};
+
+	/*
+	 * In case of 2 level STEs, L2 is allocated as cacheable, so flush it everytime
+	 * we update the STE.
+	 */
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY) &&
+	    (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB))
+		kvm_flush_dcache_to_poc(ste, sizeof(struct arm_smmu_ste));
+	return smmu_send_cmd(smmu, &cmd);
+}
+
+static int smmu_alloc_l2_strtab(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_strtab_l1 *l1_desc;
+	struct arm_smmu_strtab_l2 *l2table;
+
+	l1_desc = &cfg->l2.l1tab[arm_smmu_strtab_l1_idx(sid)];
+	if (l1_desc->l2ptr)
+		return 0;
+
+	l2table = kvm_iommu_donate_pages(get_order(sizeof(*l2table)));
+	if (!l2table)
+		return -ENOMEM;
+
+	arm_smmu_write_strtab_l1_desc(l1_desc, hyp_virt_to_phys(l2table));
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		kvm_flush_dcache_to_poc(l1_desc, sizeof(*l1_desc));
+	return 0;
+}
+
+static struct arm_smmu_ste *
+smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		u32 l1_idx = arm_smmu_strtab_l1_idx(sid);
+		struct arm_smmu_strtab_l2 *l2ptr;
+
+		if (l1_idx >= cfg->l2.num_l1_ents)
+			return NULL;
+		l2ptr = hyp_phys_to_virt(cfg->l2.l1tab[l1_idx].l2ptr & STRTAB_L1_DESC_L2PTR_MASK);
+		/* Two-level walk */
+		return &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+
+	if (sid >= cfg->linear.num_ents)
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
+		if (ret)
+			return NULL;
+	}
+	return smmu_get_ste_ptr(smmu, sid);
+}
+
 static int smmu_init_registers(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u64 val, old;
@@ -205,6 +278,29 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
+{
+	size_t strtab_size;
+	u64 strtab_base;
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	enum kvm_pgtable_prot prot = PAGE_HYP;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		prot |= KVM_PGTABLE_PROT_NORMAL_NC;
+
+	if (smmu->features & ARM_SMMU_FEAT_2_LVL_STRTAB) {
+		strtab_size = PAGE_ALIGN(cfg->l2.num_l1_ents * sizeof(struct arm_smmu_strtab_l1));
+		strtab_base = (u64)cfg->l2.l1_dma;
+		cfg->linear.table = hyp_phys_to_virt(strtab_base);
+	} else {
+		strtab_size = PAGE_ALIGN(cfg->linear.num_ents * sizeof(struct arm_smmu_ste));
+		strtab_base = (u64)cfg->linear.ste_dma;
+		cfg->l2.l1tab = hyp_phys_to_virt(strtab_base);
+	}
+	return ___pkvm_host_donate_hyp(hyp_phys_to_pfn(strtab_base),
+				       strtab_size >> PAGE_SHIFT, prot);
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	int i;
@@ -233,6 +329,10 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 	if (ret)
 		goto out_err;
 
+	ret = smmu_init_strtab(smmu);
+	if (ret)
+		goto out_err;
+
 	return ret;
 
 out_err:
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index f639312cf295..d188537545b1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -13,6 +13,7 @@
  * @base		Virtual address of SMMU registers
  * @features		SMMUv3 features as defined in arm-smmu-v3-common.h
  * @cmdq		CMDQ queue struct
+ * @strtab_cfg		stream table config, strtab_cfg.l2.l2ptrs is not used
  * Other members are filled and used at runtime by the SMMU driver.
  */
 struct hyp_arm_smmu_v3_device {
@@ -21,6 +22,7 @@ struct hyp_arm_smmu_v3_device {
 	void __iomem		*base;
 	unsigned long		features;
 	struct arm_smmu_queue	cmdq;
+	struct arm_smmu_strtab_cfg strtab_cfg;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.50.1.552.g942d659e1b-goog

