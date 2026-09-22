Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED0C54937B
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082817; cv=none; b=At+fl6XwG2dbYPErET0lPzZYFLYZJDAMFvxRkYgJhgs+mYKf8cm5ohgtYN8KmKkLziRC20qNh/J714LH1fUJP/0JQuGBXcpKLrjVx2vugdTCDfqBeFCBSv2wTwu6i3UpuWIgpiciMRnIeooxedfXirypt/cUXmZveiDDIF78XpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082817; c=relaxed/simple;
	bh=4Xi0wtaqEaTFKZUyq2Lp3NNJ8/eZCvJ/BiEwWJVSVXU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=IBSNsqnt2Je1lMp6QLNcFWUcIq38geqRCLCiLINl9Kc6zy5xh4fa/2tlvNlq3OcNvoKfj1POysdeqUsqNrj/VN02/oKBXmEv7y2sEQeDa+aLN/Tzqbim8DcBYDfBiqzDIzeFq5oPrTkWk3YG4LBcZk2Ja3Zlvt4yL4TuJJW3SKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nI7NArIG; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nI7NArIG"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-49e6862e924so30328705e9.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082811; x=1790687611; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=F9PMzEjiJ1vwTgZJB8eazAtWv3EBcHfRpFBjFs7JWrw=;
        b=nI7NArIGGVfzY1t2O5qPmfLaM3IQFJPmnG0Bk+BNH6tahBp4HxYmqb+ae6RcQOLFDL
         v/xGZhLXqs0Mwg0lhmYeyG1+E5t/O6gqBoCofdGhoyudPjrR1/lzgFsGsbU32/bSlP7Z
         nLSoetabBhPCIpyTaJ8O7FtAR5SlSLwKI8D+XEykjHgG0384Vl/p3vaFNyCMkslx9dm4
         ib9r92Yq7VNAhUpywLYF237rqccP/oq7vrlSaXVx3t41KL5b15i6rHsmFidiFAc23vY+
         5woM8ntYYkGiT9kafpZiwoxMa6r0CSUEs0Ub7TUHZszny8MQclxliIPbkG6Sm+exfSlO
         y+qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082811; x=1790687611;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F9PMzEjiJ1vwTgZJB8eazAtWv3EBcHfRpFBjFs7JWrw=;
        b=etKrneYbrV4Q/9xN3WBAC9oiLbJ/mzKzn0be7GoT47b8GHmsBEmJtluJNbnsTYj7TO
         Z9pXQIYsk2YRvU6FM8YXz8wMp8sOsZfN8j348L1qA34fpXD6cm7f5Uj0oRSuE77mKiSs
         LBMVi2fum7aciea+p68/qLVteft8UkJY43TqhVSwVMJYMBcBODIUF2qdLUXUg2x9jCha
         qcHIXUVIOFEAs1QhDNUmytCXJmbUQNfv8/g+cSsUV/en75oebeR59HkEOYy2er0JlxMw
         fe+5QIblxuRIwCkwLn/aEm88pBA1FLIc3yY16+jQ+KuW6rSP4KAT0if6h4QMQNIGef0K
         e9dw==
X-Forwarded-Encrypted: i=1; AKwUvBwo3zF/zVgPek3TbldKjZyal+2Cm/pMmhfPWJMsxTYzzUwH7QR1Ih+G5Pf9bZa036avN4aGnKg=@lists.linux.dev
X-Gm-Message-State: AFuF++mflqbzFrLqVQ+XtLbUpw4oTeM/eQiPR9m25xAk0PpLkxEstTL0
	e6wsWvnhn1n6CwWCkpId9wPsNL9Tw6hhqRxfDiGRqmucDvZBzCa5DBBAqivPXnMru5PgpYCJrX+
	lcsBZIdz+QCbBxQ==
X-Received: from wmby2.prod.google.com ([2002:a05:600c:c042:b0:49e:65f1:a3ac])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6217:b0:49e:8418:389d with SMTP id 5b1f17b1804b1-49fc571423dmr176608555e9.9.1790082810451;
 Tue, 22 Sep 2026 06:13:30 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:56 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-24-smostafa@google.com>
Subject: [PATCH v8 23/25] iommu/arm-smmu-v3-kvm: Invalidate the SMMU TLBs
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Implement the io-pgtable flush ops, which invalidate the shadow stage-2
in every SMMU.

Range invalidation algorithm is based on Robin suggestion on the list
for the upstream kernel driver, where a 2 overlapping commands can
invalidate any range.

Invalidation needs the command queue, so track whether it is enabled in
cmdq_active. It is updated with hw_lock held once the CR0 write has been
acknowledged, so it cannot change under a concurrent invalidation. For
the same reason the host is not allowed to disable the command queue
while the SMMU is enabled, as the hypervisor would no longer be able to
invalidate. As invalidation is skipped while the command queue is off,
flush the TLBs every time the SMMU is enabled.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
Jason is currently reworking the TLB invalidation on the mailing
list it might be possible to reuse some of the code once landed.
---
 .../arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h    |   2 +
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 177 +++++++++++++++++-
 2 files changed, 176 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
index ffc57182e57e..534d329661cf 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3-hyp.h
@@ -29,6 +29,7 @@
  * @cmdq_host		Host view of the CMDQ, only q_base and llq used.
  * @cmdq_max_shift	Max shift for the CMDQ probed from HW.
  * @cr0			Last value of CR0
+ * @cmdq_active		Is SMMU HW cmdq usable, protected by hw_lock
  * @host_ste_cfg	Host stream table config
  * @host_ste_base	Host stream table base
  * @strtab_cfg		Stream table as seen by HW
@@ -57,6 +58,7 @@ struct hyp_arm_smmu_v3_device {
 	struct arm_smmu_queue	cmdq_host;
 	u32			cmdq_max_shift;
 	u32			cr0;
+	bool			cmdq_active;
 	dma_addr_t		strtab_dma;
 	size_t			strtab_size;
 	u64			host_ste_cfg;
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 6f0ea3a4e48d..5417a5c2bf58 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -207,7 +207,6 @@ static int smmu_sync_cmd(struct hyp_arm_smmu_v3_device *smmu)
 			 smmu_cmdq_empty(&smmu->cmdq));
 }
 
-__maybe_unused
 static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 			 struct arm_smmu_cmd *cmd)
 {
@@ -221,17 +220,139 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
+static int smmu_tlb_inv_vmid(struct hyp_arm_smmu_v3_device *smmu)
+{
+	struct arm_smmu_cmd cmd = arm_smmu_make_cmd_op(CMDQ_OP_TLBI_S12_VMALL);
+
+	return smmu_send_cmd(smmu, &cmd);
+}
+
+static int smmu_tlb_range_inv_cmd(struct hyp_arm_smmu_v3_device *smmu,
+				  struct arm_smmu_cmd *cmd,
+				  unsigned long start, unsigned int num,
+				  unsigned int scale, u8 ttl, bool leaf)
+{
+	size_t tg = __ffs(idmap_pgtable->cfg.pgsize_bitmap);
+	u8 tg_enc = arm_smmu_tlb_inv_tg_enc(tg);
+
+	cmd->data[0] |= arm_smmu_tlb_inv_range_enc(num, scale);
+	cmd->data[1] = arm_smmu_tlb_inv_addr(start, leaf, ttl, tg_enc);
+	return smmu_add_cmd(smmu, cmd);
+}
+
+static int __smmu_tlb_inv_range(struct hyp_arm_smmu_v3_device *smmu,
+				struct arm_smmu_cmd *cmd,
+				unsigned long iova, size_t size, size_t granule,
+				bool leaf)
+{
+	size_t tg = __ffs(idmap_pgtable->cfg.pgsize_bitmap);
+	unsigned long n = size >> tg;
+	unsigned long second_start;
+	u64 data0 = cmd->data[0];
+	unsigned int num, scale;
+	u8 ttl;
+	int ret;
+
+	/* Only leaf invalidations know the level, non-leaf must use TTL=0. */
+	ttl = leaf ? arm_smmu_tlb_inv_ttl(granule, tg) : 0;
+	scale = fls64((n - 1) / 32);
+	/* Scale is up to 5 bits. */
+	if (scale > 31)
+		return smmu_tlb_inv_vmid(smmu);
+
+	num = n >> scale;
+	ret = smmu_tlb_range_inv_cmd(smmu, cmd, iova, num, scale, ttl, leaf);
+	if (ret)
+		return ret;
+
+	n -= (unsigned long)num << scale;
+	if (n) {
+		scale = fls64((n - 1) / 32);
+		num = DIV_ROUND_UP(n, 1UL << scale);
+		second_start = iova + size - ((unsigned long)num << (scale + tg));
+
+		cmd->data[0] = data0;
+		ret = smmu_tlb_range_inv_cmd(smmu, cmd, second_start, num, scale, 0, leaf);
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
+	/* See arm_smmu_inv_size_too_big() */
+	if (size >= (1UL << (ilog2(granule) - 3)) * granule)
+		return smmu_tlb_inv_vmid(smmu);
+
+	for (; iova < end; iova += granule) {
+		cmd->data[1] = arm_smmu_tlb_inv_addr(iova, leaf, 0, 0);
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
@@ -718,6 +839,33 @@ static int smmu_update_ste_shadow(struct hyp_arm_smmu_v3_device *smmu, bool enab
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
@@ -725,6 +873,8 @@ static void smmu_emulate_enable(struct hyp_arm_smmu_v3_device *smmu)
 		return;
 
 	WARN_ON(smmu_update_ste_shadow(smmu, true));
+	/* Clean the TLBs each time the SMMU is enabled. */
+	WARN_ON(smmu_flush_all_tlb(smmu));
 }
 
 static void smmu_emulate_disable(struct hyp_arm_smmu_v3_device *smmu)
@@ -745,6 +895,13 @@ static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 
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
@@ -1020,6 +1177,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
-- 
2.55.0.1082.g2b9226bbc0-goog

