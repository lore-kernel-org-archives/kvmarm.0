Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B354342517
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405338; cv=none; b=VLVMiJKIfrBaDRZ9PZzqdXjwisaVeuVUamIf5IncYMD1FlW0oVEBlQV0MLy77ciu1tlfo491Z63+/RWVxHoleBMhNwIqil83JNwbYoOz/mQRoLdOdvLz/qKfTATTsNMW9WtS5sCMs8rQ7i2Fwh3Owg55jxPONGXwIxvmbQH+BUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405338; c=relaxed/simple;
	bh=U01zuPmHBR4NpjwfbFt/lTc1f2okLAeIr+T5ztn4mi4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=rFFzxHzkPksYze0xNMSbhZ7hoz0lBxPVEmpzSOERlFp6h6iu6YZDxrCyCmZ6GxLeI1ur/NK3GME6dd3YQ7VpwU+X0RiOnRLvG0MW3A1AZ50CgH1biFJv8y/oCYEu0KFg4A4Y4fiyS/c55rmKB16GfXJls3cMUtgxE5JRRxiN4RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rzcwYY5p; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rzcwYY5p"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-477a0ddd1d4so12504755e9.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405333; x=1764010133; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Yqv9vt6rYdUcUmbSADKPrtDVgWOjgzH7G7qmk1O24d8=;
        b=rzcwYY5pHRshkvIXAlSGrPjV+hyD6CzPxuUHw9NvB9+WKYiVX5ceO+2zAAu3/WraIY
         LpZAQe1C+Erf/oCWYApSRriwJR/AfsDHFSOodH4+oDNFhLSu89aLW1jyIbnm1d0IolR6
         tIiPg04WFspOqwJlDn5T1/jYskGOsziXPxrwqtcFvUY9R+x6iuaGkV+rl47j3C6QN5oE
         Q86oF6vfR+G1ZHvV7X6ZlH2p7YyG8FEN3OjGrhN2f+8U58jbBwRF93MH++ZrH4dRmTPG
         VRBz978FPbp5N2QlIVZU71UWyEevujIFw2ipj+FoYDwka/o2lB99eqAYylPcBYszT6T8
         ac/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405333; x=1764010133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Yqv9vt6rYdUcUmbSADKPrtDVgWOjgzH7G7qmk1O24d8=;
        b=NyPO7EOkCgMUSuYUU1b0UQ4Cf021HyPIZP5IIYgCyK11AX/QLyQAUesJCWp7QlFnss
         OUSXskP0jaEfi0QIvnBv4PeksohavHimzoXFd0ZcJaT94S58sU9AriJ5lwbBt5cX4rY5
         LttB0Qf1a5TDXKasRvntNPdMLV/+HrDa+qI0ZTys5bgsLPUG0OQz+supE6rfqeLpUFPt
         nPtVcwiXwPd0HzNMCJZtWBTbM96Q3IAOLUA018e/Qt9OtP8i4aeY4w90ZptJ1UPMtS1z
         +IRpQgVV5wHo+gLWB6hNqweXK8y3YjwGl6FlVAg7SEWLwEoW0CP93lfJw7nkZiAfqghY
         PfOg==
X-Forwarded-Encrypted: i=1; AJvYcCVsNDWTamaP7mz3Uuf6DQwn6ctr7v+XFOmq7H9xMwiiG6disF1y209aJOYoVlD+yhgaN+7Nn50=@lists.linux.dev
X-Gm-Message-State: AOJu0YzVmeMuR+gHFhhQzkMYoHGsSxbYCCmj/z7FE50X/89lbv845Trj
	brC2+MBFMN+MWytLwFXuV/6Jah5SAeVyNUcDSVUkZgvyu8W22wRdjbVDmZ8qa3hhTB8zPyVW+T4
	qe6Osc3AxvHrX1A==
X-Google-Smtp-Source: AGHT+IFKuKQmQwETqVMo5V4rZDWAjfD2WAPxG29C33FYX0labdGr2WvGuWsAPiA9DtRuNjEGIDoqy8Foar2wTg==
X-Received: from wmqy12.prod.google.com ([2002:a05:600c:364c:b0:477:9aa2:7d50])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d15:b0:477:9bfc:dcb6 with SMTP id 5b1f17b1804b1-4779bfcde09mr72288665e9.14.1763405333101;
 Mon, 17 Nov 2025 10:48:53 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:14 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-28-smostafa@google.com>
Subject: [PATCH v5 27/27] iommu/arm-smmu-v3-kvm: Enable nesting
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Now, as the hypervisor controls the command queue, stream table,
and shadows the stage-2 page table.
Enable stage-2 in case the host puts an STE in bypass or stage-1.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 75 ++++++++++++++++++-
 1 file changed, 74 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index f0075f9a0947..3e451cef937c 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -371,6 +371,46 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static void smmu_attach_stage_2(struct arm_smmu_ste *ste)
+{
+	unsigned long vttbr;
+	unsigned long ts, sl, ic, oc, sh, tg, ps;
+	unsigned long cfg;
+	struct io_pgtable_cfg *pgt_cfg =  &idmap_pgtable->cfg;
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, ste->data[0]);
+	if (!FIELD_GET(STRTAB_STE_0_V, ste->data[0]) ||
+	    (cfg == STRTAB_STE_0_CFG_ABORT))
+		return;
+	/* S2 is not advertised, that should never be attempted. */
+	if (WARN_ON(cfg == STRTAB_STE_0_CFG_NESTED))
+		return;
+	vttbr = pgt_cfg->arm_lpae_s2_cfg.vttbr;
+	ps = pgt_cfg->arm_lpae_s2_cfg.vtcr.ps;
+	tg = pgt_cfg->arm_lpae_s2_cfg.vtcr.tg;
+	sh = pgt_cfg->arm_lpae_s2_cfg.vtcr.sh;
+	oc = pgt_cfg->arm_lpae_s2_cfg.vtcr.orgn;
+	ic = pgt_cfg->arm_lpae_s2_cfg.vtcr.irgn;
+	sl = pgt_cfg->arm_lpae_s2_cfg.vtcr.sl;
+	ts = pgt_cfg->arm_lpae_s2_cfg.vtcr.tsz;
+
+	ste->data[1] |= FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING);
+	/* The host shouldn't write dwords 2 and 3, overwrite them. */
+	ste->data[2] = FIELD_PREP(STRTAB_STE_2_VTCR,
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, ps) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, tg) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, sh) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, oc) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, ic) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, sl) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, ts)) |
+		 FIELD_PREP(STRTAB_STE_2_S2VMID, 0) |
+		 STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2R;
+	ste->data[3] = vttbr & STRTAB_STE_3_S2TTB_MASK;
+	/* Convert S1 => nested and bypass => S2 */
+	ste->data[0] |= FIELD_PREP(STRTAB_STE_0_CFG, cfg | BIT(1));
+}
+
 /* Get an STE for a stream table base. */
 static struct arm_smmu_ste *smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu,
 					     u32 sid, u64 *strtab)
@@ -426,6 +466,15 @@ static void smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
 	u64 *hyp_ste_base = strtab_hyp_base(smmu);
 	struct arm_smmu_ste *host_ste_ptr = smmu_get_ste_ptr(smmu, sid, host_ste_base);
 	struct arm_smmu_ste *hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
+	struct arm_smmu_ste target = {};
+	struct arm_smmu_cmdq_ent cfgi_cmd = {
+		.opcode	= CMDQ_OP_CFGI_STE,
+		.cfgi	= {
+			.sid	= sid,
+			.leaf	= true,
+		},
+	};
+	int i;
 
 	/*
 	 * Linux only uses leaf = 1, when leaf is 0, we need to verify that this
@@ -441,8 +490,32 @@ static void smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
 		hyp_ste_ptr = smmu_get_ste_ptr(smmu, sid, hyp_ste_base);
 	}
 
-	smmu_copy_from_host(smmu, hyp_ste_ptr->data, host_ste_ptr->data,
+	smmu_copy_from_host(smmu, target.data, host_ste_ptr->data,
 			    STRTAB_STE_DWORDS << 3);
+	/*
+	 * Typically, STE update is done as the following
+	 * 1- Write last 7 dwords, while STE is invalid
+	 * 2- CFGI
+	 * 3- Write first dword, making STE valid
+	 * 4- CFGI
+	 * As the SMMU MUST at least load 64 bits atomically
+	 * that gurantees that there is no race between writing
+	 * the STE and the CFGI where the SMMU observes parts
+	 * of the STE.
+	 * In the shadow we update the STE to enable nested translation,
+	 * which requires updating first 4 dwords.
+	 * That is only done if the STE is valid and not in abort.
+	 * Which means it happens at step 4)
+	 * So we need to also write the last 7 dwords and send CFGI
+	 * before writing the first dword.
+	 * There is no need for last CFGI as it's done next.
+	 */
+	smmu_attach_stage_2(&target);
+	for (i = 1; i < STRTAB_STE_DWORDS; i++)
+		WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
+
+	WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
+	WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
 }
 
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
-- 
2.52.0.rc1.455.g30608eb744-goog

