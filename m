Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF86654B1B8
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082810; cv=none; b=rvcvJA+XINvWmCQquwQCC87154xiO5IPOj0mGMzzg1v2P5sjEugKYVP9+BUpvPjNmxWhxaHZlcAVs7BrlRPIbWXK0XB60muXBN+xw3eCpk5jvQVZ0jn6b1X84/cvv6lk5ixv8jPkIswaZqzGxsH//qxri/jzOJUvlRzG0LKJoFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082810; c=relaxed/simple;
	bh=BmMSrhluolb6Av9guAg0Y9lbw2f/ziZAkRd5YJsY8PU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TJ59q7gsNLdPcKg2nEBPaAV+kL/ZwjeWTzrjNicNtovhIR0Vk6HVb+KpMVRXUwkxAhET6FQ1c1Fbhj4uAqE22SJGo8dLekDEwQqyV9BTQNyQJosZxMmI6wO6WRLq6W9gw9E/kzUiwfFnXSZBAQvHjKb19rrZt6FHo+iM51XmIMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=enGiUeD1; arc=none smtp.client-ip=209.85.221.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="enGiUeD1"
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-4870ee5618aso2693237f8f.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082804; x=1790687604; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VNp5S66G25hEx/lXvBHBQ4zrD/Jw7dlUu7oI6jfC/Cc=;
        b=enGiUeD1ne30v7J21SpFcasxnrjOO/Az0mgSHsEbBcQSUO1Swvkf3/yhfnY2wOg307
         Cq9jlAEmX/+NibaWXalgbBurIeDf0rMKquQzc85oR8JnBehoIABrFFybfA0QiTJkS5FA
         j9xcB6X4CoqS+Xb0HdX/yw3528L2yzNFxkknFlKWhA8nMtaMuyYG0JT4kP5k9Bt1rJuP
         1v9aQtZ/ZzON74FdD15gK6NGAK8Xt3a5YbMuhwfp3DIYpjbHZXsalVIFft88rraWmPDP
         /ACEq5v6e0zk62NS1OBHrPEl2LPxgSTwWWI/Brkem0JMXcBga8grVGSE43YIDt3e+MN9
         9N1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082804; x=1790687604;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VNp5S66G25hEx/lXvBHBQ4zrD/Jw7dlUu7oI6jfC/Cc=;
        b=EqdLDqM5+vwyL4DmmFvQYv5DPRuDTV7B1DUmTybdwGVrZ7hCwI7PatwfuL9FDNufI+
         eGccmwiboUsihNBIEt/ZfLHE3N+Kizv3YG8n6xON5slxRGjAul288BmOu8/nFUtU2wd8
         T8vPfJVt8/mkX7uZOgpgaF2bqJIVG+g6Z4Nwy9Rlr41MYuQCJQUfKPtfpLhcdja1GtMT
         uHtDPQoHHD5J7BZS+NKm4f6W98gThcfacZMSRdcmLfL608Sli3H1hHe0q94vvdyGIKMh
         QzTQaDmF0aQRK3FynAWt2ZX1ACtqPcOE9w7BlM5oqK2my7ipIxVnZG7J7mmrWoJr53x0
         h/gw==
X-Forwarded-Encrypted: i=1; AKwUvByWXQw7cwcZWEIS1HjxE7aN+cIxNgO1nnv8go+HTpV8PUZkLaf95AuRb1J7/ddlum9lvxjAxEs=@lists.linux.dev
X-Gm-Message-State: AFuF++kyTQnGx/L0/uEM4ZOgmF8CpKMy2gW2/NIrJ2KnpT7saATTxQoZ
	6J6CKz65yl7FZuqSOKsYJMuR0tDh9crSE6ZWS+AQy68nl4rGy/CkQoVRDjuSSld14cyBs6BtvPh
	Dnl4NSy3NbhQhBg==
X-Received: from wmbg12.prod.google.com ([2002:a05:600c:a40c:b0:499:bc15:b29b])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:34c7:b0:49c:ff8d:b548 with SMTP id 5b1f17b1804b1-49fc5726cfcmr270659405e9.11.1790082804465;
 Tue, 22 Sep 2026 06:13:24 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:51 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-19-smostafa@google.com>
Subject: [PATCH v8 18/25] iommu/arm-smmu-v3-kvm: Shadow STEs
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

Add STE emulation, when the host sends the CFGI_STE command.

Copy the STE as is to the shadow owned by the hypervisor,
which is the one seen by HW.
In the next patch, stage-2 page table will be attached.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 124 +++++++++++++++++-
 1 file changed, 118 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 54049b8b1363..cb9aa7e4a394 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -24,6 +24,9 @@ struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
 #define strtab_split(smmu)	(FIELD_GET(STRTAB_BASE_CFG_SPLIT, (smmu)->host_ste_cfg))
 #define strtab_l1_size(smmu)	((1UL << (strtab_log2size(smmu) - strtab_split(smmu))) * \
 				 (sizeof(struct arm_smmu_strtab_l1)))
+#define strtab_hyp_base(smmu)	((smmu)->features & ARM_SMMU_FEAT_2_LVL_STRTAB ? \
+				 (u64 *)(smmu)->strtab_cfg.l2.l1tab :\
+				 (u64 *)(smmu)->strtab_cfg.linear.table)
 
 #define for_each_smmu(smmu) \
 	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
@@ -287,6 +290,91 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
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
@@ -406,8 +494,24 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
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
@@ -624,25 +728,33 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 			val = smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
 			goto out_update_regs;
 		}
-	/* Passthrough the register access for bisectability, handled later */
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
+	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_GBPA:
 		mask = read_write;
 		break;
-- 
2.55.0.1082.g2b9226bbc0-goog

