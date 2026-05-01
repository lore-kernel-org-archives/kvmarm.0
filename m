Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E09E3A1E81
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634427; cv=none; b=eWvFk/9vYBM16u8MZR7bkwUBk7Vma4ImTAMhrjw4CtiVUB/44s9FdU8O20u/tzwPiTgbLPznyOImIi5iJKkNnvUhLFpfd47svJW8Wsy7x/niSnpPx97YK9FUxx96dI2pPTgl8NgYl4QENjkLG7+Aeot6TbB/Dk6lBJkTLjrCr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634427; c=relaxed/simple;
	bh=EUQFrcZsstiOOzdonmOjv2zocRlqE5cRVJsvTbS1jvs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uUw3JHn/H4z//aypo9yh5ugYnJHBgmfLZLGGFIlLi8xNB+aVOCzgDT9G2e2mur+rH1mCLoG8+fxlaro4KLmaxZp8xvzwULqXvZfY6oRKVJglhZhvAZGKmt8QlrMAnXWarrj4AIWoxlnM71vvqrU9LP0wKJXZIMZ/irIivNhRj1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F/9A2BXg; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F/9A2BXg"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44696b11265so2033716f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634424; x=1778239224; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9dQBaHVEA8R39nVXfDncsPbJ/+uAVI3QDhXt4O/6+ME=;
        b=F/9A2BXgvx7er9RNJUZwbHi92FPD3a8xLra7hxi/cY8soekG8j6xF9QY+c+hyzpZlZ
         WB47fmB0j3lR9WzBX///gpHe5xaxFwimuHQVp0vQ19RDQPJ8b/2Ly2N5GQIATzD0RlHz
         6gbEg+vT5T4D8r5AKXQQi8eb6RLWbzOJ9FN0cYsKFft3ivtc9eTazTFdROH1WofT95DQ
         DnIdexnY9Or5CihpN6j3fh0E9Yz1Gbdh7+zC5uKc9H5WB2YEFOA5pblAUYriCtJ+xXzx
         H+bWwtIKRmlzg4sJlm8NSHzqEFDtXPdtK6rgcIAcQYtSsfVj3zRob0/ZS1fhadKBxRER
         IXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634424; x=1778239224;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=9dQBaHVEA8R39nVXfDncsPbJ/+uAVI3QDhXt4O/6+ME=;
        b=c6L07ux31HbgImkCYKON6vxo7mFaSCdUYCcXA71wfdhZWfjNbviggUW9PYXRbGGHV2
         5TwftEqcs6ZS+MAUhGKoEmr9iCzsJHoZZ/TnGYVGrU4xCntMrwEYX6kU2jzt5NadhVDw
         DEDdQT0qv3ioTW6Gpd5OuxuHqEl7nyyYFRSxq7Qldv+ejJDvOHBGR3aMzELwWlkzzqym
         CAxWJLGxLANxE1jEoxouu8gK7ZhHxnxHLqQgSmpLFrlmmTYPkdaZbXpGq+e1MSXA7t2T
         f1fh62te8vxeo8WsjDmUGfX4HAu8JE8/b1sSkXvqT7+kR+P+fiJZedXXlDl3oCBIlM0z
         v9XA==
X-Forwarded-Encrypted: i=1; AFNElJ9krQnXj2nxOWNmWxQEtINZYicH3WqoqdSW6wVQcEvtxYYN6sFZBjLTpCoyCqcfRCywl+G06/k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyuuy1NqAK5uNHcsNWuWYx2v25/wqIj9HGSZw5xI79DjMJGYUp+
	lOv5Pz7y8o5tTuLQQwcd6bwcHknmJJfgvlSuCvoL0dCRgpsDPzJVFefF0iU57vVZXFz9+RFpDZi
	8QWhaSejo/UPaLA==
X-Received: from wroj14.prod.google.com ([2002:adf:f00e:0:b0:440:62c9:5fd4])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:adf:fc50:0:b0:449:e8c0:fd58 with SMTP id ffacd0b85a97d-449e8c0fe50mr5501396f8f.27.1777634423506;
 Fri, 01 May 2026 04:20:23 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:19 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-18-smostafa@google.com>
Subject: [PATCH v6 17/25] iommu/arm-smmu-v3-kvm: Emulate CMDQ for host
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
Content-Transfer-Encoding: quoted-printable

Don=E2=80=99t allow access to the command queue from the host:
- ARM_SMMU_CMDQ_BASE: Only allowed to be written when CMDQ is disabled, we
  use it to keep track of the host command queue base.
  Reads return the saved value.
- ARM_SMMU_CMDQ_PROD: Writes trigger command queue emulation which sanitise
  and filters the whole range. Reads returns the host copy.
- ARM_SMMU_CMDQ_CONS: Writes move the sw copy of the cons, but the host
  can=E2=80=99t skip commands once submitted. Reads return the emulated val=
ue and
  the error bits in the actual cons.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 128 +++++++++++++++++-
 1 file changed, 124 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iom=
mu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index aac455599728..1633a3cf8a3b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -100,7 +100,6 @@ static int smmu_unshare_pages(phys_addr_t addr, size_t =
size)
 	return 0;
 }
=20
-__maybe_unused
 static bool smmu_cmdq_has_space(struct arm_smmu_queue *cmdq, u32 n)
 {
 	struct arm_smmu_ll_queue *llq =3D &cmdq->llq;
@@ -351,6 +350,92 @@ static int smmu_init(void)
 	return ret;
 }
=20
+static bool smmu_filter_command(struct hyp_arm_smmu_v3_device *smmu, u64 *=
command)
+{
+	u64 command0 =3D le64_to_cpu(command[0]);
+	u64 command1 =3D le64_to_cpu(command[1]);
+	u64 type =3D FIELD_GET(CMDQ_0_OP, command0);
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
+		if ((FIELD_GET(CMDQ_CFGI_1_RANGE, command1) !=3D 31))
+			return true;
+		break;
+	}
+	case CMDQ_OP_TLBI_NH_ASID:
+	case CMDQ_OP_TLBI_NH_VA:
+	case 0x13: /* CMD_TLBI_NH_VAA: Not used by Linux */
+	{
+		/* Only allow VMID =3D 0 */
+		if (FIELD_GET(CMDQ_TLBI_0_VMID, command0) !=3D 0)
+			return true;
+		break;
+	}
+	case 0x10: /* CMD_TLBI_NH_ALL: Not used by Linux */
+	case CMDQ_OP_TLBI_EL2_ALL:
+	case CMDQ_OP_TLBI_EL2_VA:
+	case CMDQ_OP_TLBI_EL2_ASID:
+	case CMDQ_OP_TLBI_S12_VMALL:
+	case CMDQ_OP_TLBI_S2_IPA:
+	case 0x23: /* CMD_TLBI_EL2_VAA: Not used by Linux */
+		return true;
+	case CMDQ_OP_CMD_SYNC:
+		if (FIELD_GET(CMDQ_SYNC_0_CS, command0) =3D=3D CMDQ_SYNC_0_CS_IRQ) {
+			/* Allow it, but let the host timeout, as this should never happen. */
+			command0 &=3D ~CMDQ_SYNC_0_CS;
+			command0 |=3D FIELD_PREP(CMDQ_SYNC_0_CS, CMDQ_SYNC_0_CS_SEV);
+			command1 &=3D ~CMDQ_SYNC_1_MSIADDR_MASK;
+		}
+		break;
+	}
+
+	return false;
+}
+
+static int smmu_emulate_cmdq_insert(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u64 *host_cmdq =3D hyp_phys_to_virt(smmu->cmdq_host.q_base & Q_BASE_ADDR_=
MASK);
+	bool use_wfe =3D smmu->features & ARM_SMMU_FEAT_SEV, skip;
+	u64 cmd[CMDQ_ENT_DWORDS];
+	int idx, ret;
+	u32 space;
+
+	if (!is_cmdq_enabled(smmu))
+		return 0;
+
+	space =3D (1 << (smmu->cmdq_host.llq.max_n_shift)) - queue_space(&smmu->c=
mdq_host.llq);
+	/* Wait for the command queue to have some space. */
+	ret =3D smmu_wait(use_wfe, smmu_cmdq_has_space(&smmu->cmdq, space));
+	if (ret)
+		return ret;
+
+	while (space--) {
+		idx =3D Q_IDX(&smmu->cmdq_host.llq, smmu->cmdq_host.llq.cons);
+		queue_inc_cons(&smmu->cmdq_host.llq);
+
+		memcpy(cmd, &host_cmdq[idx * CMDQ_ENT_DWORDS], CMDQ_ENT_DWORDS << 3);
+		skip =3D smmu_filter_command(smmu, cmd);
+		if (WARN_ON(skip))
+			continue;
+		smmu_add_cmd_raw(smmu, cmd);
+	}
+
+	writel(smmu->cmdq.llq.prod, smmu->cmdq.prod_reg);
+
+	return smmu_wait(use_wfe, smmu_cmdq_empty(&smmu->cmdq));
+}
+
 static void smmu_emulate_cmdq_enable(struct hyp_arm_smmu_v3_device *smmu)
 {
 	u32 shift =3D smmu->cmdq_host.q_base & Q_BASE_LOG2SIZE;
@@ -388,18 +473,51 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_d=
evice *smmu,
 		/* Clear stage-2 support, hide MSI to avoid write back to cmdq */
 		mask =3D read_only & ~(IDR0_S2P | IDR0_VMID16 | IDR0_MSI | IDR0_HYP);
 		break;
-	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_CMDQ_BASE:
+		/*
+		 * Although allowed to use smaller size, we rely on the SMMUv3 driver
+		 * using 64-bit store instruction for simplicity.
+		 */
+		if (len !=3D sizeof(u64))
+			break;
 		if (is_write) {
 			/* Not allowed by the architecture */
 			if (WARN_ON(is_cmdq_enabled(smmu)))
 				break;
 			smmu->cmdq_host.q_base =3D val;
+			goto out_ret;
+		} else {
+			val =3D smmu->cmdq_host.q_base;
+			goto out_update_regs;
 		}
-		mask =3D read_write;
-		break;
 	case ARM_SMMU_CMDQ_PROD:
+		if (len !=3D sizeof(u32))
+			break;
+		if (is_write) {
+			smmu->cmdq_host.llq.prod =3D val;
+			WARN_ON(smmu_emulate_cmdq_insert(smmu));
+			goto out_ret;
+		} else {
+			val =3D smmu->cmdq_host.llq.prod;
+			goto out_update_regs;
+		}
 	case ARM_SMMU_CMDQ_CONS:
+		if (len !=3D sizeof(u32))
+			break;
+		if (is_write) {
+			if (WARN_ON(is_cmdq_enabled(smmu)))
+				break;
+
+			smmu->cmdq_host.llq.cons =3D val;
+			goto out_ret;
+		} else {
+			/* Propagate errors back to the host.*/
+			u32 cons =3D readl_relaxed(smmu->base + ARM_SMMU_CMDQ_CONS);
+
+			val =3D smmu->cmdq_host.llq.cons | (CMDQ_CONS_ERR & cons);
+			goto out_update_regs;
+		}
+	/* Passthrough the register access for bisectiblity, handled later */
 	case ARM_SMMU_STRTAB_BASE:
 	case ARM_SMMU_STRTAB_BASE_CFG:
 	case ARM_SMMU_GBPA:
@@ -495,6 +613,8 @@ static bool smmu_dabt_device(struct hyp_arm_smmu_v3_dev=
ice *smmu,
 		val =3D readq_relaxed(smmu->base + off) & mask;
 	else
 		val =3D readl_relaxed(smmu->base + off) & mask;
+
+out_update_regs:
 	/*
 	 * Device might be read senstive, so do it but ignore writing
 	 * back for xzr.
--=20
2.54.0.545.g6539524ca2-goog

