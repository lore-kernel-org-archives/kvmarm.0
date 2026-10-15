Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8F8595736
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094985; cv=none; b=Jf27Vzw05/JQB3coxGu2WY5JQz92izq16wvYxHa9L4wFGyI1RQtB2/UW4jcLefHzw9y+t5a2zCtrBU7rFDhwUaJTMmKGwBaFWLRUqyG7IIg5NAfWwLE+YYZs1FSFiSagIl3EiWgrKn4EnAdfcAdmUf4GlDxx9I98HlhKeUjsy54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094985; c=relaxed/simple;
	bh=pax5OLPSUo+ZBv6oi2uayg8Bdmkx6QpeOtfiynqJo64=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=L8zxZhQYdAFDYLqGzF2BMlQ141y59glzrW9CV3BePfuxEd0nd+8R2Lh3XiTZlJ9hiIZG+mCnZRg2wYU+iAVxTS1oPH8z5b0wXgHgw6bURnlePG0hXHQ/EFUGfFbeoFRMXhXQX6gJF+WEZIfANmSLLdPcFnVe/+h5I3WnzxmkXZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NFBmqvrO; arc=none smtp.client-ip=209.85.208.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NFBmqvrO"
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-6b1f4e5c747so2463875a12.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094979; x=1792699779; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9VVZGlsZIqsR8XCbbkxUjFMNMhFH8B9fEpFvm5P7Qik=;
        b=NFBmqvrOlf1pZJQMY+/9JAj2x8nl5QFwGtx3bsNL1b+W1FTIlQdz0FFfGHY97BlGm/
         jlCsbt4iXMmaWnUDimU+trVMVXYp4sazGT3M+Ol8eBMNyc/iHvCrn4B3iUkQn/XXCFf3
         ct5D4R/zu0+HgFbjBLhu3+3Ojm0QMNiqn+qzoDyETKEHTcy5I95Ge/QvrDl2DegWA4+U
         OOSazK2VjoQ+ZOsaUlboVyVXKngTtpXiEzWsfr+t97e5CfAv/LMCzuqtRZgnT1hxYjpt
         0yI7ZR3e8M/evuCskhdIuptGFuy9Ku592pBQSllPbwwCn4hPSpJ8NSWiNusVCn+TvAL9
         KIyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094979; x=1792699779;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9VVZGlsZIqsR8XCbbkxUjFMNMhFH8B9fEpFvm5P7Qik=;
        b=JxMcxHOTR7q6I0TEBSx9bakGLdMJbh1lApFwp74Tu3tV+P+ZiH1VFvzOd2zqXtk378
         6moI3qoGYVpANiWguR60mun9n2sFBB0tYfJWrUT1rhbvS+HqAqoAJ/NxIq92asZmFajy
         U88EDb4kwN5lm/Y++GqGXdcW56+SU/ozSC9V7Fisn2f+Womw8QGbLrK8HiY8rYIdCw8f
         TdsBEHSUZmNvJIxZBPR+dlGdaFvDDcvx+X2cpNtujmVY3+XzxfAta+kiAKtd8qEWSRBm
         3Wg65hbU0qAKySpbKNUj9Naym50EuKIOQhciozNLrwsh6qjmGspmhjhjLBxmOHpmERgS
         bjRg==
X-Forwarded-Encrypted: i=1; AKwUvBzpiKQWwBXfGTOBUwOJjSj3vJlq4HwitXGT5frUNG69Z2BeTEnd9HTHl5avC69KYVxjKVBC73k=@lists.linux.dev
X-Gm-Message-State: AFq9FYJCF+yrAGbBXrvHLB9TWsD58jily8Rgy0VE4jvyurnYonbfViwT
	2w0f2huMnt2GwfyAC5GG+V+K6dXFgQ2EM8mYWdu4LurbB241soCjoJX1HTxzvVohkeDhoFWyn/0
	tcx/YNCZVFSK3gQ==
X-Received: from edze9.prod.google.com ([2002:a05:6402:1909:b0:6ae:201f:ff33])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2498:b0:6aa:ee55:a650 with SMTP id 4fb4d7f45d1cf-6b17c27c6e1mr15665392a12.37.1792094979040;
 Thu, 15 Oct 2026 13:09:39 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:54 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-24-smostafa@google.com>
Subject: [PATCH v9 23/25] iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement the io-pgtable tlb ops, which invalidate the shadow stage-2
in every SMMU.

The range invalidation commands come from arm_smmu_tlbi_calc_range()
in the common lib, SMMUs without range invalidation get one command per
entry.
The hypervisor also needs to invaldiate all of S1 after S2 invalidations
by IPA to invalidate combined entries.

Invalidation needs the command queue, so track whether it is enabled in
cmdq_active. It is updated with hw_lock held once the CR0 write has been
acknowledged, so it cannot change under a concurrent invalidation. For
the same reason the host is not allowed to disable the command queue
while the SMMU is enabled, as the hypervisor would no longer be able to
invalidate. As invalidation is skipped while the command queue is off,
flush the TLBs every time the SMMU is enabled.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c    | 156 +++++++++++++++++-
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |   2 +
 2 files changed, 155 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
index 75b2b1477a4f..01f23fce6be5 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.c
@@ -209,7 +209,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 	return smmu_wait(false, smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmd *cmd)
 {
@@ -223,17 +222,118 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static int smmu_tlb_inv_vmid(struct hyp_arm_smmu_v3_device *smmu)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_TLBI_S12_VMALL);
+
+	return smmu_send_cmd(smmu, &cmd);
+}
+
+static int __smmu_tlb_inv_range(struct hyp_arm_smmu_v3_device *smmu,
+				struct arm_smmu_cmd *cmd,
+				unsigned long iova, size_t size, size_t granule,
+				bool leaf)
+{
+	struct arm_smmu_tlbi tlbi = {
+		.iova = iova,
+		.size = size,
+		.iopte_size = granule,
+		.tgsz_lg2 = __ffs(idmap_pgtable->cfg.pgsize_bitmap),
+		.leaf_only = leaf,
+	};
+	unsigned int i;
+	int ret;
+
+	arm_smmu_tlbi_calc_range(&tlbi, false);
+	if (tlbi.range.use_full_inv)
+		return smmu_tlb_inv_vmid(smmu);
+
+	for (i = 0; i < tlbi.range.num_cmds; i++) {
+		struct arm_smmu_cmd range_cmd = tlbi.range.cmds[i];
+
+		range_cmd.data[0] |= cmd->data[0];
+		ret = smmu_add_cmd(smmu, &range_cmd);
+		if (ret)
+			return ret;
+	}
+
+	return smmu_sync_cmd(smmu);
+}
+
+static int __smmu_tlb_inv_range_pages(struct hyp_arm_smmu_v3_device *smmu,
+				      struct arm_smmu_cmd *cmd,
+				      unsigned long iova, size_t size, size_t granule,
+				      bool leaf)
+{
+	unsigned long end = iova + size;
+	int ret;
+
+	/* Same threshold as arm_smmu_tlbi_calc_single(). */
+	if (size / granule > 512)
+		return smmu_tlb_inv_vmid(smmu);
+
+	for (; iova < end; iova += granule) {
+		cmd->data[1] = FIELD_PREP(CMDQ_TLBI_1_LEAF, leaf) |
+			       (iova & ~GENMASK_U64(11, 0));
+		ret = smmu_add_cmd(smmu, cmd);
+		if (ret)
+			return ret;
+	}
+
+	return smmu_sync_cmd(smmu);
+}
+
+static int smmu_tlb_inv_range_smmu(struct hyp_arm_smmu_v3_device *smmu,
+				   unsigned long iova, size_t size, size_t granule,
+				   bool leaf)
+{
+	struct arm_smmu_cmd cmd_s1 = arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NH_ALL);
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_TLBI_S2_IPA);
+	int ret;
+
+	if (smmu->features & ARM_SMMU_FEAT_RANGE_INV)
+		ret = __smmu_tlb_inv_range(smmu, &cmd, iova, size, granule, leaf);
+	else
+		ret = __smmu_tlb_inv_range_pages(smmu, &cmd, iova, size, granule, leaf);
+	if (ret)
+		return ret;
+
+	return smmu_send_cmd(smmu, &cmd_s1);
+}
+
+static void smmu_tlb_inv_range(unsigned long iova, size_t size, size_t granule,
+			       bool leaf)
+{
+	struct hyp_arm_smmu_v3_device *smmu;
+
+	for_each_smmu(smmu) {
+		hyp_spin_lock(&smmu->hw_lock);
+		/*
+		 * Don't bother if CMDQ is disabled, this would be useful for the case
+		 * when RPM is supported to avoid touching the SMMU MMIO when disabled.
+		 * The hypervisor also asserts CMDQEN is enabled before the SMMU is
+		 * enabled. As otherwise the host can prevent the hypervisor from doing
+		 * TLB invalidations.
+		 * When the SMMU is re-enabled the hypervisor cleans the TLBs.
+		 */
+		if (smmu->cmdq_active)
+			WARN_ON(smmu_tlb_inv_range_smmu(smmu, iova, size,
+							granule, leaf));
+		hyp_spin_unlock(&smmu->hw_lock);
+	}
+}
+
 static void smmu_tlb_flush_walk(unsigned long iova, size_t size,
 				size_t granule, void *cookie)
 {
-	/* TBD: Invalidate the range in all the SMMUs. */
+	smmu_tlb_inv_range(iova, size, granule, false);
 }
 
 static void smmu_tlb_add_page(struct iommu_iotlb_gather *gather,
 			      unsigned long iova, size_t granule,
 			      void *cookie)
 {
-	/* TBD: Invalidate the granule in all the SMMUs. */
+	smmu_tlb_inv_range(iova, granule, granule, true);
 }
 
 static const struct iommu_flush_ops smmu_tlb_ops = {
@@ -721,6 +821,33 @@ static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enab
 	return smmu_unshare_pages(strtab_host_base(smmu), size);
 }
 
+static int smmu_flush_all_tlb(struct hyp_arm_smmu_v3_device *smmu)
+{
+	int ret;
+	u32 cr0;
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_TLBI_NSNH_ALL);
+
+	hyp_spin_lock(&smmu->hw_lock);
+	/*
+	 * This must be called when the SMMU is getting enabled.
+	 * First enable the cmdq and then invalidate the TLB.
+	 */
+	cr0 = readl_relaxed(smmu->base + ARM_SMMU_CR0);
+	if (!(cr0 & CR0_CMDQEN)) {
+		cr0 |= CR0_CMDQEN;
+		writel_relaxed(cr0, smmu->base + ARM_SMMU_CR0);
+		ret = smmu_wait(false, readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == cr0);
+		if (ret) {
+			hyp_spin_unlock(&smmu->hw_lock);
+			return ret;
+		}
+	}
+
+	ret = smmu_send_cmd(smmu, &cmd);
+	hyp_spin_unlock(&smmu->hw_lock);
+	return ret;
+}
+
 static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
 {
 	/* Enabling SMMU without CMDQ, means TLB invalidation won't work. */
@@ -728,6 +855,8 @@ static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
 		return;
 
 	WARN_ON(smmu_update_ste_shadow(smmu, true));
+	/* Clean the TLBs each time the SMMU is enabled. */
+	WARN_ON(smmu_flush_all_tlb(smmu));
 }
 
 static void smmu_emulate_disable(struct hyp_arm_smmu_v3_device *smmu)
@@ -748,6 +877,13 @@ static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 
 static void smmu_emulate_cmdq_disable(struct hyp_arm_smmu_v3_device *smmu)
 {
+	/*
+	 * We can not enable the SMMU if the CMDQ is disabled and similarly
+	 * we can not disable the CMDQ if the SMMU is enabled, as that can
+	 * lead to stale TLBs.
+	 */
+	WARN_ON(is_smmu_enabled(smmu));
+
 	WARN_ON(smmu_unshare_pages(smmu->cmdq_host.base_dma,
 				   cmdq_size(&smmu->cmdq_host)));
 }
@@ -1033,6 +1169,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		else
 			writel_relaxed(val & mask, smmu->base + off);
 
+		/*
+		 * Make sure writes to CR0 are immediately observed, that is important
+		 * when synchronizing with TLB invalidation as reading CR0 is not enough
+		 * to deduce the SMMU state, and we have to enforce the ack with the
+		 * hw_lock acquired.
+		 */
+		if (off == ARM_SMMU_CR0) {
+			u32 cr0 = val;
+
+			WARN_ON(smmu_wait(false,
+					  readl_relaxed(smmu->base + ARM_SMMU_CR0ACK) == cr0));
+			smmu->cmdq_active = !!(cr0 & CR0_CMDQEN);
+		}
+
 		hyp_spin_unlock(&smmu->hw_lock);
 		return true;
 	}
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index 2fb478e9233a..9ccee7fb710f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -27,6 +27,7 @@
  * @cmdq_host:		Host view of the CMDQ, only q_base, base_dma and llq used
  * @cmdq_max_shift:	Max shift for the CMDQ probed from HW
  * @cr0:		Last value of CR0
+ * @cmdq_active:	CMDQEN as acknowledged by the hardware, under hw_lock
  * @host_ste_cfg:	Host stream table config
  * @host_ste_base:	Host stream table base
  * @strtab_cfg:		Stream table config as seen by HW
@@ -60,6 +61,7 @@ struct hyp_arm_smmu_v3_device {
 	struct arm_smmu_queue	cmdq_host;
 	u32			cmdq_max_shift;
 	u32			cr0;
+	bool			cmdq_active;
 	dma_addr_t		strtab_dma;
 	size_t			strtab_size;
 	u64			host_ste_cfg;
-- 
2.56.0.176.g3575e65682-goog

