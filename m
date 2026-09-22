Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A95E551981
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 13:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790082808; cv=none; b=CJx7i3wv9Pt+tJqTVfh0NM3GFtY7xoipfWpL/p8bfGbcEBxQWXeJJ0pZWDsbzPTDCY82vkCMGRlQoaiPgrequ9LaYYat9OQbYJmJfEWxJ0qA20qDc+JmM0uf+wxIJDjCivkE/zuVEADD4NXaGJ9J7oLJqEfXGKMliZQqZ1XoaG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790082808; c=relaxed/simple;
	bh=SDlatHrQDm3u2/GILmSmdipnZmcn0kcwzdwaLFS/+sA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=fe7jvj4EF1Fn9SpEgGi5gOctCHYH5qsUBSj/gigIibM620Zspop13zvsnZ+T5qRcMGPxWnHyIhtNcl3ag9ESIN1SvQbtspVb0iy4p2xl2Hl9SmCVJK7akbFDL+pRZ1sIhunUM2ypr5bZ15uS5DrBhi8YgTp3fV4ohqZUgbMIsfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kNIxbZ4f; arc=none smtp.client-ip=209.85.128.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kNIxbZ4f"
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49e64b80b94so30067965e9.3
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 06:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790082802; x=1790687602; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=00AhV3k+li4lYucaDcO3o5UE2oHbgVQJ9mR0kZROZeQ=;
        b=kNIxbZ4fDZ77AENm6lw2WD149Ebpbs1REak1kqYUD/8orF6MnmwdQBBMvGwOg8l0+q
         HGIKq/DYJ9Jnog1Hgl5OSSEHCzD5W9Re/AvHA7I+tZq7ledhZ8QnTuAHe1CiyDfQ+VmF
         I8qr7zGDRrhN2JLFvZWW2hf2NUh2EixAjwmYXDdBN/FjAkDsog/DInaVqRaggUKPY3Tu
         6PJf5W72AeGlOquHi38i53a3r//WZVUFMb3tTcZ9djw3Ji8ELg+brVUFLdeMEgaT3nMN
         6HokPsM12R3Qaf0H/v1a/Y4ydtuMCHzBbxrzqlWEZTyLmzIdCYdhCSTMv5D9rbJd3yrg
         lgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790082802; x=1790687602;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=00AhV3k+li4lYucaDcO3o5UE2oHbgVQJ9mR0kZROZeQ=;
        b=Xx3ldksmAnclaukdC0naKiQJ1K53xUseIWwW7o59e9otzgzpFstdHND2/jNX1I1FfW
         +bWc5gnsYtlwP1+vwFFvCI2k3L3PQ869axWyQGM/XcZllFEbww1MfX4QCZz3tidNRyPN
         DXro3V6BJOVj/Kz7xlo/9hvGz4KRPnZE4Yqc5gxn19SZZ0NTWPQANLdFOa5YfMKvF0eH
         wMXReKJ3Zhp6VvoGaExmDOgugwde/y8kHSeWGTqhYykfcSTwMqjFrARqvQ4CvYt09bSc
         4ywhTcurlf2tbX42s+cav7wtzQq9cnRnPoElW6KJAMS0goZzPu+n2PIPvs0pX1Hyuj2K
         ByBA==
X-Forwarded-Encrypted: i=1; AKwUvBz4g1HHqu9/ZW/22HHJTIZ2dI++DsYyVO20tAVXXGX++zVtygZ/2ohY+NrYyT7v30FUgQB/0i0=@lists.linux.dev
X-Gm-Message-State: AFuF++naE55uU2nHAtl7p4AU3dK5N6anHS8choohR0FroPoBh3qOipjE
	LoBWOAmMtxn5TjeGNvG2y2qnKJG0WA6WlVhzopFN44f2tZAjRct0ZEwA/NmXCd6HEnW5bGsLcDE
	ZeaPSVXexEJh9WA==
X-Received: from wmqy9.prod.google.com ([2002:a05:600c:3649:b0:49c:d3c6:97b4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:4441:10b0:49f:ce78:3572 with SMTP id 5b1f17b1804b1-49fce783674mr94578205e9.35.1790082802190;
 Tue, 22 Sep 2026 06:13:22 -0700 (PDT)
Date: Tue, 22 Sep 2026 13:12:49 +0000
In-Reply-To: <20260922131259.2975334-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260922131259.2975334-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260922131259.2975334-17-smostafa@google.com>
Subject: [PATCH v8 16/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
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

Don't allow access to the command queue from the host:
- ARM_SMMU_CMDQ_BASE: Only allowed to be written when CMDQ is disabled, we
  use it to keep track of the host command queue base.
  Reads return the saved value.
- ARM_SMMU_CMDQ_PROD: Writes trigger command queue emulation which sanitise
  and filters the whole range. Reads returns the host copy.
- ARM_SMMU_CMDQ_CONS: Writes move the sw copy of the cons, but the host
  can't skip commands once submitted. Reads return the emulated value and
  the error bits in the actual cons.

Also add emulation for IDR1.CMDQS to return the hypervisor command queue
size which can be equal to or smaller to the HW size.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 151 +++++++++++++++++-
 1 file changed, 146 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 38b8ecc5cc10..8c67e348f4a3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -111,7 +111,6 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t size)
 	return 0;
 }
 
-__maybe_unused
 static bool smmu_cmdq_has_space(struct arm_smmu_queue *cmdq, u32 n)
 {
 	struct arm_smmu_ll_queue *llq = &cmdq->llq;
@@ -340,6 +339,105 @@ static int smmu_init(void)
 	return ret;
 }
 
+static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *command)
+{
+	u64 type = FIELD_GET(CMDQ_0_OP, command[0]);
+
+	switch (type) {
+	case CMDQ_OP_CFGI_STE:
+		/* TBD: SHADOW_STE*/
+		break;
+	case CMDQ_OP_CFGI_ALL:
+	{
+		/*
+		 * Linux doesn't use range STE invalidation, and only use this
+		 * for CFGI_ALL, which is done on reset and not on an new STE
+		 * being used.
+		 * Although, this is not architectural we rely on the current Linux
+		 * implementation.
+		 */
+		if ((FIELD_GET(CMDQ_CFGI_1_RANGE, command[1]) != 31))
+			return true;
+		break;
+	}
+	case CMDQ_OP_TLBI_NH_ASID:
+	case CMDQ_OP_TLBI_NH_VA:
+	case CMDQ_OP_TLBI_NH_ALL:
+	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
+	{
+		/* Only allow VMID = 0 */
+		if (FIELD_GET(CMDQ_TLBI_0_VMID, command[0]) != 0)
+			return true;
+		break;
+	}
+	case CMDQ_OP_PREFETCH_CFG:
+	case CMDQ_OP_CFGI_CD:
+	case CMDQ_OP_CFGI_CD_ALL:
+	case CMDQ_OP_TLBI_NSNH_ALL:
+	case CMDQ_OP_PRI_RESP:
+	case CMDQ_OP_RESUME:
+		break;
+	case CMDQ_OP_CMD_SYNC:
+		if (FIELD_GET(CMDQ_SYNC_0_CS, command[0]) == CMDQ_SYNC_0_CS_IRQ) {
+			/* Do not allow MSI */
+			command[0] &= ~CMDQ_SYNC_0_CS;
+			command[0] |= FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
+			command[1] &= ~CMDQ_SYNC_1_MSIADDR_MASK;
+		}
+		break;
+	default:
+		/* Deny unknown commands */
+		return true;
+	}
+
+	return false;
+}
+
+static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 *host_cmdq = hyp_phys_to_virt(smmu->cmdq_host.base_dma);
+	bool use_wfe = smmu->features & ARM_SMMU_FEAT_SEV;
+	u64 cmd[CMDQ_ENT_DWORDS];
+	int idx, ret;
+	u32 pending;
+	bool skip;
+
+	if (!is_cmdq_enabled(smmu))
+		return 0;
+
+	pending = (1 << (smmu->cmdq_host.llq.max_n_shift)) - queue_space(&smmu->cmdq_host.llq);
+
+	hyp_spin_lock(&smmu->hw_lock);
+	/* Wait for the command queue to have some space. */
+	ret = smmu_wait(use_wfe, smmu_cmdq_has_space(&smmu->cmdq, pending));
+	if (ret) {
+		hyp_spin_unlock(&smmu->hw_lock);
+		return ret;
+	}
+
+	while (pending--) {
+		int i;
+
+		idx = Q_IDX(&smmu->cmdq_host.llq, smmu->cmdq_host.llq.cons);
+		queue_inc_cons(&smmu->cmdq_host.llq);
+
+		/* Copy the command to local buffer avoiding TOCTOU */
+		for (i = 0; i < CMDQ_ENT_DWORDS; ++i)
+			cmd[i] = le64_to_cpu(READ_ONCE(host_cmdq[idx * CMDQ_ENT_DWORDS + i]));
+
+		skip = smmu_filter_command(smmu, cmd);
+		if (WARN_ON(skip))
+			continue;
+		smmu_add_cmd_raw(smmu, cmd);
+	}
+
+	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
+
+	ret = smmu_wait(use_wfe, smmu_cmdq_empty(&smmu->cmdq));
+	hyp_spin_unlock(&smmu->hw_lock);
+	return ret;
+}
+
 static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u32 shift = smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
@@ -381,18 +479,51 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		 */
 		mask = read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP | IDR0_ATS);
 		break;
-	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		/*
+		 * Although allowed to use smaller size, we rely on the SMMUv3 driver
+		 * using 64-bit store instruction for simplicity.
+		 */
+		if (len != sizeof(u64))
+			break;
 		if (is_write) {
 			/* Not allowed by the architecture */
 			if (is_cmdq_enabled(smmu))
 				break;
 			smmu->cmdq_host.q_base = val;
+			goto out_ret;
+		} else {
+			val = smmu->cmdq_host.q_base;
+			goto out_update_regs;
 		}
-		mask = read_write;
-		break;
 	case ARM_SMMU_CMDQ_PROD:
+		if (len != sizeof(u32))
+			break;
+		if (is_write) {
+			smmu->cmdq_host.llq.prod = val;
+			WARN_ON(smmu_emulate_cmdq_insert(smmu));
+			goto out_ret;
+		} else {
+			val = smmu->cmdq_host.llq.prod;
+			goto out_update_regs;
+		}
 	case ARM_SMMU_CMDQ_CONS:
+		if (len != sizeof(u32))
+			break;
+		if (is_write) {
+			if (WARN_ON(is_cmdq_enabled(smmu)))
+				break;
+
+			smmu->cmdq_host.llq.cons = val;
+			goto out_ret;
+		} else {
+			/* Propagate errors back to the host.*/
+			u32 cons = readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
+
+			val = smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
+			goto out_update_regs;
+		}
+	/* Passthrough the register access for bisectability, handled later */
 	case ARM_SMMU_STRTAB_BASE:
 	case ARM_SMMU_STRTAB_BASE_CFG:
 	case ARM_SMMU_GBPA:
@@ -468,10 +599,20 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_device *smmu,
 		mask = read_write;
 		break;
 	/* Allowed RO 32 bit registers. */
+	case ARM_SMMU_IDR1:
+		if (len != sizeof(u32))
+			break;
+		/* Cap CMDQS to the shadow queue size. */
+		if (!is_write) {
+			val = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+			val &= ~IDR1_CMDQS;
+			val |= FIELD_PREP(IDR1_CMDQS, smmu->cmdq.llq.max_n_shift);
+			goto out_update_regs;
+		}
+	fallthrough;
 	case ARM_SMMU_IIDR:
 	case ARM_SMMU_IDR5:
 	case ARM_SMMU_IDR3:
-	case ARM_SMMU_IDR1:
 	case ARM_SMMU_GERROR:
 		if (len != sizeof(u32))
 			break;
-- 
2.55.0.1082.g2b9226bbc0-goog

