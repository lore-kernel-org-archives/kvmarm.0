Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 629C93A3E68
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634429; cv=none; b=rA8EfHpZuqrht0NGMzzp07L8LUfdfjvc5TELZJEmACrGXlr6sNSQSCN072XkI8/CuhvAzr0dmy/l/SpwLT9WQvBd9EnAl+nn1o7UIBz8UQK4+lH2/51PzPKvmUAu+tjIABLiyuRGWXv8ynHlPlEAVCGXYXOXA5pQAq1MQM0rCCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634429; c=relaxed/simple;
	bh=quyqCx4BwvJd/so0F7ehZxJ2/HYxSOs09XGpwJ1CpE8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hBVZfUnL0ChtJNq7YlqRk0hJXDPiTrLWKVXEX7f5+StQ6cWYuFh6ULPxtaJf3WfVV+OLzGkgHAtJXaRDHQeKSxJnYYd3sDF2/BunKZjLTpfgb7otwUZlQtKX0W2oKfIS0C8p7MgUTI1m4xFjNJy+2Ui/VpD6zLk8na9ZlQtMxzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Trs7tYaW; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Trs7tYaW"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-44b186b715aso175104f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634426; x=1778239226; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc4s6xiUZWCpOIz9PUIb3W8M/9lmR8q/3KHesYxyGwI=;
        b=Trs7tYaWN7AwWYW1GAzXZJ/30c9eVdpxyZIeYJi9Zr8GfeOUnmrT5Rf0BIYreDCRz/
         eQSu17ckkUDjdH7hs/7VLNq14jMjqGJs1g5Opc0NoBCR08Bwk6MIjzxmhycJ7zCWclOs
         Ulp3eRDZ3ugTAR4JIg1qkt82d0Xn3pykKtz6Roeg7ClCC8ZIn3Px/61tbCuBXdX64v1b
         R1mDNOmW/OU9WyTXzL2c7yuU665jyWB0qWx5uiBnHtlfAMlxxi+VzdQaOohcIJ2HUpFU
         7AeFSXMpiJyeGGjJchiH2vebBbItMa5nc5eKWfuvVn0SQf7v3oUA6xmclzPAUvTwo8se
         zizw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634426; x=1778239226;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Dc4s6xiUZWCpOIz9PUIb3W8M/9lmR8q/3KHesYxyGwI=;
        b=qJ7FYTJFrjcXOOzVB16Ee8mp+GpughJTIfDoRt4zd001NRK38oRXN2T45Qm7zWzrvg
         V5rX+qKweiCD/TAB3iQK09mJ72Nu4fFrb4t1Y19Zc16xJ1eUbZapDaHR4/ytDjQYKdCD
         fWCySQEpDzICbTkQ5fK9uZFDnrwoaMgCk3/SZTUMaqGrFveOI4byVR8kohSGgb5cEjs7
         UExDYFHCMsRRFKYCOfxy1BDhya/GJEQDYBYoDnEIm5cchSIdCRIWCP7QxJcXn9X2Nsg6
         Uii4B7+6r4BTmF51Ekda846kdNCDRZNp3oeJdb14TxIjUXOWou0PS9KO2LycZFWf3i/U
         Qdaw==
X-Forwarded-Encrypted: i=1; AFNElJ/9qH/WmgjRpPoGbfk98J1Zcpvsz9w1pJottEIaKUK7ee1cbqusv8p07LPUAg3O3EbKJWEMM6o=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLKL/9+zahdStGCBtV0qwU3JPRw9oJiaWtxxuLeYSyvHq7d5hO
	mEEtuI+gGTO6+RoMmIls0hSEbCwvbYt/ONj4vcrjuGr8dO4/mV3ZMuOdEZhxhsYblhP/3+r99G+
	kxDjRqZlCMVQQIQ==
X-Received: from wrnd1.prod.google.com ([2002:adf:e841:0:b0:43d:76ee:764])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:e11:b0:449:acdb:3009 with SMTP id ffacd0b85a97d-449acdb3074mr6506108f8f.6.1777634425669;
 Fri, 01 May 2026 04:20:25 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:21 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-20-smostafa@google.com>
Subject: [PATCH v6 19/25] iommu/arm-smmu-v3-kvm: Shadow STEs
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

Add STE emulation, when the host sends the CFGI_STE command.

Copy the STE as is to the shadow owned by the hypervisor, in the
next patch, stage-2 page table will be attached.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 114 +++++++++++++++++-
 1 file changed, 108 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index d15c9e5aa998..d92811ef2af5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -23,6 +23,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 #define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
 #define strtab_l1_size(smmu)	((1UL << (strtab_log2size(smmu) - strtab_split(smmu))) * \
 				 (sizeof(struct arm_smmu_strtab_l1)))
+#define strtab_hyp_base(smmu)	((smmu)->features & ARM_SMMU_FEAT_2_LVL_STRTAB ? \
+				 (u64 *)(smmu)->strtab_cfg.l2.l1tab :\
+				 (u64 *)(smmu)->strtab_cfg.linear.table)
 
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
@@ -305,6 +308,91 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_get_host_l2_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid,
+				struct arm_smmu_ste *host_ste_out)
+{
+	u64 *host_ste_base = hyp_phys_to_virt(strtab_host_base(smmu));
+	struct arm_smmu_strtab_l1 host_l1_desc;
+	struct arm_smmu_strtab_l2 *l2ptr;
+	phys_addr_t host_l2_tab;
+	int ret;
+
+	host_l1_desc.l2ptr = le64_to_cpu(READ_ONCE(host_ste_base[arm_smmu_strtab_l1_idx(sid)]));
+	if (!(host_l1_desc.l2ptr & STRTAB_L1_DESC_SPAN))
+		return -EINVAL;
+
+	host_l2_tab = host_l1_desc.l2ptr & STRTAB_L1_DESC_L2PTR_MASK;
+	/* Share and pin the table before accessing it. */
+	ret = smmu_share_pages(host_l2_tab, sizeof(struct arm_smmu_strtab_l2));
+	if (ret)
+		return ret;
+
+	l2ptr = hyp_phys_to_virt(host_l2_tab);
+	memcpy(host_ste_out, &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)],
+	       STRTAB_STE_DWORDS << 3);
+	WARN_ON(smmu_unshare_pages(host_l2_tab, sizeof(struct arm_smmu_strtab_l2)));
+	return 0;
+}
+
+static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool leaf)
+{
+	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
+	struct arm_smmu_ste *hyp_ste_ptr, *host_ste_ptr, host_ste_copy;
+	u64 *hyp_ste_base = strtab_hyp_base(smmu);
+	int ret;
+
+	/*
+	 * Linux only uses leaf = 1, when leaf is 0, we need to verify that this
+	 * is a 2 level table and reshadow of l2.
+	 * Also, we rely on Linux only issuing CFGI_STE to attach a device when
+	 * the SMMU is enabled.
+	 */
+	if (!leaf || !is_smmu_enabled(smmu) ||
+		(sid >= (1UL << strtab_log2size(smmu))))
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
+		if (!l1tab[l1_idx].l2ptr) {
+			struct arm_smmu_strtab_l2 *l2table;
+
+			/* No hypervisor entry, first time the L2 is populated. */
+			l2table = kvm_iommu_donate_pages(get_order(sizeof(*l2table)));
+			if (!l2table)
+				return -ENOMEM;
+			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2table));
+		}
+		l2ptr = hyp_phys_to_virt(le64_to_cpu(l1tab[l1_idx].l2ptr) &
+				STRTAB_L1_DESC_L2PTR_MASK);
+		hyp_ste_ptr = &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+
+	memcpy(hyp_ste_ptr->data, host_ste_ptr->data, STRTAB_STE_DWORDS << 3);
+
+	return 0;
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -419,8 +507,14 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
 	switch (type) {
 	case CMDQ_OP_CFGI_STE:
-		/* TBD: SHADOW_STE*/
+	{
+		u32 sid = FIELD_GET(CMDQ_CFGI_0_SID, command[0]);
+		u32 leaf = FIELD_GET(CMDQ_CFGI_1_LEAF, command[1]);
+
+		if (smmu_reshadow_ste(smmu, sid, leaf))
+			return true;
 		break;
+	}
 	case CMDQ_OP_CFGI_ALL:
 	{
 		/*
@@ -618,25 +712,33 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			val = smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
 			goto out_update_regs;
 		}
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_STRTAB_BASE:
+		if (len != sizeof(u64))
+			break;
 		if (is_write) {
 			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
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
 			/* Must only be written when SMMU_CR0.SMMUEN == 0.*/
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
+	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
-- 
2.54.0.545.g6539524ca2-goog

