Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4EB478E57
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116781; cv=none; b=DXuI1iDY6652vwXxV/RjFzRMVItNThvOR255Ec8MSh8ARIzB1wju9gxWwsKyD3apdtLc9ZGWQsQTiqzAdLqyn3vlxQFG2I6JojO3bIN5a0siLTklDUcBpD2aP5azuCKMxzxGdjSnehVmsVxM9VGWU+oHV7hvBPGYOLuujpfUfDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116781; c=relaxed/simple;
	bh=7psO0ivKckhYkqo2jOqG+o3dj9A5xFsGWXBUAqXdSWM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bkUjyC5ZerXRvcBbGDUtBlR1Vg/ogLi1i2+8dey19OPwR9vrL/AUEHRFDvD9O6dn/i11pOsIn08tbHfcTvaXbB8gFVeXnOSLKKnPN+YviNpxs2623dbq33Pkyxkbz0b5NZYF+MNbc2AhNb8RGwOdli8SU7mzyVgeaJ9zl+ltr5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LBvvQy/5; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LBvvQy/5"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493fa6e28a7so30673075e9.1
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116776; x=1784721576; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3arABq/LbCnYkg13T0a9RWMUKBWAd4ICzVlPWgUKHjA=;
        b=LBvvQy/5bj0rqmBoffCklipNFmFDQC4MvP+hE0ZLhPCAyPJPQPxiI9ohTF4TsxBbA6
         y+D+zXZU9zxQxhaJeR+Dq8EipyJsRKxmelApuuqjDp/IM80DHEMSDN6qW6Q466me6psb
         7RzI+JRn6Za3HJrWbU95JOpjwcihgwb50FCHhJwwstayjcb+XdStEv/dgQI/T1I2vwAj
         RX5Hn35uZOnXGKbeRdOYlXv1PMTR79ZqsfgkZM6oio3LrQ4jQzrYtE6RmQyUz0syyCjp
         RJcU0yd4Ao4jXBwE9AtQ09n5GiWBHj/yaA/oiadDf28/o1xaP98miSXWEzkCJxyOXStV
         0O3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116776; x=1784721576;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3arABq/LbCnYkg13T0a9RWMUKBWAd4ICzVlPWgUKHjA=;
        b=NjNbzq6yF2INDuFNHBC2AT/kWjv2jGZvpDbx2vGZHDtA1mXkAVWoCUed6hUggdkvhR
         KceyKoGfSr8bH8MB+LPpsJ6IqV3JiR/8SacN7hE63evCT0m8HW7UdMFOvl+m5ee2ZwNm
         uaxw0kHkEDzDKsUGAE9X8M+8zDOpGeoDNOV+juShyZ2l7PfwO32DW0gfxzZRt9okIA2c
         Y1Wa2A8480EHr26zW1PHWzIjwdAxSu2ku4t7m/1SDvhr3JKUiGJHbWld6inNgRf/62h2
         GdxI3lwejVa8UZf4Vg6tziZXLbNqpSVPT2acMlPze4vpjWSPtFyGK5ZcQJk/ImPsxn1E
         zZ/A==
X-Forwarded-Encrypted: i=1; AHgh+RrbYsSxic0UfSwjbStisou2OFY3ltjlDGF3YJlZnHP/P3FBZXrAxxJL2Oqtu7yNRgyDWBiPfvQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1A7sJqdRUNQwpCDlmVnajvLxH13OWbf2/O/TNLjRP9q+znugd
	WQ1SsFnNOHoM03FgERtY43xHdWD2HiY7x5BoSKj345Qy0VTM+ytP/dbgnsnmJUHFM2afkHL4kBo
	TBXGG2i45Ymc9bw==
X-Received: from wmbdx5.prod.google.com ([2002:a05:600c:63c5:b0:493:f781:b52f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:6446:20b0:493:e034:a3b5 with SMTP id 5b1f17b1804b1-4953c27ab18mr21837125e9.24.1784116776358;
 Wed, 15 Jul 2026 04:59:36 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:59 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-19-smostafa@google.com>
Subject: [PATCH v7 18/24] iommu/arm-smmu-v3-kvm: Shadow STEs
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

Copy the STE as is to the shadow owned by the hypervisor, in the
next patch, stage-2 page table will be attached.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 127 +++++++++++++++++-
 1 file changed, 121 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 3b133f24b4ca..fba3b3e15780 100644
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
@@ -283,6 +286,94 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
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
+	for (i = 0 ; i < STRTAB_STE_DWORDS ; ++i)
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
+			l2table = pkvm_iommu_donate_pages(get_order(sizeof(*l2table)));
+			if (!l2table)
+				return -ENOMEM;
+			arm_smmu_write_strtab_l1_desc(&l1tab[l1_idx], hyp_virt_to_phys(l2table));
+		}
+		l2ptr = hyp_phys_to_virt(le64_to_cpu(l1tab[l1_idx].l2ptr) &
+				STRTAB_L1_DESC_L2PTR_MASK);
+		hyp_ste_ptr = &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
+	}
+
+	for (i = 0 ; i < STRTAB_STE_DWORDS ; ++i)
+		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);
+	return 0;
+}
+
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
@@ -396,8 +487,24 @@ static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *comman
 
 	switch (type) {
 	case CMDQ_OP_CFGI_STE:
-		/* TBD: SHADOW_STE*/
+	{
+		u32 leaf = FIELD_GET(CMDQ_CFGI_1_LEAF, command[1]);
+		u32 sid = FIELD_GET(CMDQ_CFGI_0_SID, command[0]);
+		bool ret;
+
+		/*
+		 * If STE update is required flush the CMDQ and drop the lock as that
+		 * might require to update the host page table and aquire its lock.
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
@@ -608,25 +715,33 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
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
2.55.0.141.g00534a21ce-goog

