Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9747ECC2
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116788; cv=none; b=QcCEXNc3+OvHAUJq2yB9nVc7tmeRdg16c0w0Bai1BDPHcttrzlu4twSaohUMRdDpsW7B/3tHN6GoQWOSZCfGJtmxRrCQLucR3yBte5UvqROJJhOHS00VsAbT/rMkmWef2IkbgeNzhoDcZrGkRGE0gvFOfBts5g/QDvZji+H58ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116788; c=relaxed/simple;
	bh=fhQT+JAbH2Qy2Y5/pbDfbmISq0pN5McJ8TxGoZqW/QI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Fi5Ci56e1H+z9QeAz/LewlErNk3M3fyWIsG82FFLC7KqKCuM/k4w0lZLxH+rhATUolUrtVajdZO1+oE+4uL8OzGpI+wH94Ad83AfTikYC6f6AZOTKQuyDX8jsMmTQkLSCp6rIe7NRvGAbaa0/Y94DJotRZjAnGoqZXb9xT9Lpyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TX/BQgJ1; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TX/BQgJ1"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-698ac7678f1so5281963a12.3
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116783; x=1784721583; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UCxykfAjLEYMMvCVcdT1GfjF39XVffctpOWmsmN/ev4=;
        b=TX/BQgJ1ynkXf1PhdhoYwesns1vaJcOGzyf11i9YDng8WflpjcjYT2OqRtyKbCHe4n
         3IZ8BV2lTK+J4l6mSc3VCimyyg6D/UvLBKJ55416dq84tIva1YyIH54dc25vKZE+5Idp
         Ar+WSSwDiNTVkoFYeIV9MLgxen32QpDKPeu+NIa5OJdMeE7oFSweTyp9Mn1iuYWmGsDB
         GPn/uOE6Fvcd1rWl43MdLgdj1pViFG89L4UpGTtRvHTdr0yuKzbEunVJcnlR79zi/ToX
         FY/htLZVuKi2wvyLuG2/o/15wXWVaajLMDfZYGumb4tYVt0U6/k6+lvH5P1n+SJEwDzZ
         y31w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116783; x=1784721583;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UCxykfAjLEYMMvCVcdT1GfjF39XVffctpOWmsmN/ev4=;
        b=TpEOZwk2Qhi4baZdTIH+eXE9gXLD/n2ODvuJA8pasy2fD256vtL2hlOyp/I3tqTDZf
         H4SR0fXAVmAYdZwAqk2L6whj6mv3Vd1YRtsA6CGReqZDYrbHYQQP7zvZoTpfSU5M9564
         5Y4LX4OZ30yJhd16H5BFcQFbedESrZ3MdpZfjjAwvm3+QrjU5tfCZsfi/gUQYCA6+fAY
         1ZZKKCVq64DFNKjvsmTNtZLc9KljdLpqEtC5pfLu6JqYx6U3NPMDoMHP9BevuZorJ0Ms
         ioSp2g79Fn6ILU3GpHVRD+juroqEHwveVkHv+VwHrvF8O4kDB/AXMY+o4sab4i0UClXM
         UfGA==
X-Forwarded-Encrypted: i=1; AHgh+Rrk5C3Z3FXFp1375eAL8m4S9Vdr06JLM0DIEgmcxFf+OuBAxCuFNkLpKxaA00G7/8GUzGVFO08=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4BHbR/MQYHWOghNxrC5Ou877ikqfVKdJlezyAS28TVpAdoIPo
	gqHuPbDD6hmIBsapuxg55BeLL+D34s6d1b7HYEQegioAyolkOkbM4XzViaItcCdTfVlle0W8Wtf
	iucarLGfhKlMWsQ==
X-Received: from edvw11.prod.google.com ([2002:a05:6402:128b:b0:69c:79d3:df42])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:a292:20b0:69c:76c6:9bef with SMTP id 4fb4d7f45d1cf-69e197771femr873479a12.10.1784116782673;
 Wed, 15 Jul 2026 04:59:42 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:59:04 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-24-smostafa@google.com>
Subject: [PATCH v7 23/24] iommu/arm-smmu-v3-kvm: Enable nesting
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

Now, as the hypervisor controls the command queue, stream table,
and shadows the stage-2 page table.
Enable stage-2 in case the host puts an STE in bypass or stage-1.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 109 ++++++++++++++++--
 1 file changed, 102 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index f30757dd9b11..4625240a5de2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -380,6 +380,59 @@ static int smmu_init_cmdq(struct hyp_arm_smmu_v3_device *smmu)
 	return 0;
 }
 
+static int smmu_attach_stage_2(struct arm_smmu_ste *ste)
+{
+	unsigned long vttbr;
+	unsigned long ts, sl, ic, oc, sh, tg, ps;
+	unsigned long cfg;
+	struct io_pgtable_cfg *pgt_cfg =  &idmap_pgtable->cfg;
+
+	cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(ste->data[0]));
+	if (!FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(ste->data[0])) ||
+	    (cfg == STRTAB_STE_0_CFG_ABORT)) {
+		ste->data[2] = 0;
+		ste->data[3] = 0;
+		return 0;
+	}
+	/* S2 is not advertised, that should never be attempted. */
+	if (cfg == STRTAB_STE_0_CFG_NESTED)
+		return -EINVAL;
+	vttbr = pgt_cfg->arm_lpae_s2_cfg.vttbr;
+	ps = pgt_cfg->arm_lpae_s2_cfg.vtcr.ps;
+	tg = pgt_cfg->arm_lpae_s2_cfg.vtcr.tg;
+	sh = pgt_cfg->arm_lpae_s2_cfg.vtcr.sh;
+	oc = pgt_cfg->arm_lpae_s2_cfg.vtcr.orgn;
+	ic = pgt_cfg->arm_lpae_s2_cfg.vtcr.irgn;
+	sl = pgt_cfg->arm_lpae_s2_cfg.vtcr.sl;
+	ts = pgt_cfg->arm_lpae_s2_cfg.vtcr.tsz;
+
+	ste->data[1] &= ~cpu_to_le64(STRTAB_STE_1_SHCFG);
+	ste->data[1] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING));
+
+	ste->data[1] &= ~cpu_to_le64(STRTAB_STE_1_EATS | STRTAB_STE_1_S2FWB);
+
+	/* The host shouldn't write dwords 2 and 3, overwrite them. */
+	ste->data[2] = cpu_to_le64(FIELD_PREP(STRTAB_STE_2_VTCR,
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, ps) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, tg) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, sh) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, oc) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, ic) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, sl) |
+				  FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, ts)) |
+		 FIELD_PREP(STRTAB_STE_2_S2VMID, 0) |
+		 STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2R |
+ #ifdef __BIG_ENDIAN
+		STRTAB_STE_2_S2ENDI |
+#endif
+		STRTAB_STE_2_S2PTW);
+
+	ste->data[3] = cpu_to_le64(vttbr & STRTAB_STE_3_S2TTB_MASK);
+	/* Convert S1 => nested and bypass => S2 */
+	ste->data[0] |= cpu_to_le64(FIELD_PREP(STRTAB_STE_0_CFG, cfg | BIT(1)));
+	return 0;
+}
+
 static int smmu_get_host_l2_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid,
 				struct arm_smmu_ste *host_ste_out)
 {
@@ -412,8 +465,12 @@ static int smmu_get_host_l2_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid,
 static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool leaf)
 {
 	struct arm_smmu_strtab_cfg *cfg = &smmu->strtab_cfg;
-	struct arm_smmu_ste *hyp_ste_ptr, *host_ste_ptr, host_ste_copy;
+	struct arm_smmu_ste *hyp_ste_ptr;
 	u64 *hyp_ste_base = strtab_hyp_base(smmu);
+	struct arm_smmu_ste target = {};
+	struct arm_smmu_cmd cfgi_cmd = arm_smmu_make_cmd_cfgi_ste(sid, true);
+	bool cur_valid, target_valid;
+	u32 target_cfg;
 	int ret, i;
 
 	/*
@@ -435,7 +492,7 @@ static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
 			return -E2BIG;
 
 		hyp_ste_ptr = &hyp_table[sid];
-		host_ste_ptr = &host_table[sid];
+		memcpy(target.data, host_table[sid].data, STRTAB_STE_DWORDS << 3);
 	} else {
 		struct arm_smmu_strtab_l1 *l1tab = (struct arm_smmu_strtab_l1 *)hyp_ste_base;
 		u32 l1_idx = arm_smmu_strtab_l1_idx(sid);
@@ -444,8 +501,7 @@ static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
 		if (l1_idx >= cfg->l2.num_l1_ents)
 			return -E2BIG;
 
-		host_ste_ptr = &host_ste_copy;
-		ret = smmu_get_host_l2_ste(smmu, sid, host_ste_ptr);
+		ret = smmu_get_host_l2_ste(smmu, sid, &target);
 		if (ret)
 			return ret;
 
@@ -463,9 +519,48 @@ static int smmu_reshadow_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid, bool
 		hyp_ste_ptr = &l2ptr->stes[arm_smmu_strtab_l2_idx(sid)];
 	}
 
-	for (i = 0 ; i < STRTAB_STE_DWORDS ; ++i)
-		WRITE_ONCE(hyp_ste_ptr->data[i], host_ste_ptr->data[i]);
-	return 0;
+	/*
+	 * Summary of each host emulated state vs real HW.
+	 * |	Host	|	HW	|
+	 * ==============================
+	 * |	V=0	|	V=0	|
+	 * |	Abort	|	Abort	|
+	 * |	Bypass	|	S2	|
+	 * |	S1	|	S1+S2	|
+	 *
+	 * For the host, any V=0 transition is not hitless, all other permutations of
+	 * (abort, bypass, S1) transitions are hitless.
+	 * For the HW state, any V=0 transition is not hitless, as all the S2 config is
+	 * always the same (ttbr, vtcr...), all other transitions should be hitless too.
+	 * However, the host is not trusted, which means that any V=0 <=> V=1 transitions
+	 * or any transition to an abort STE we need to enforce writing order of the STE
+	 * dword 0 and add CFGI.
+	 * Otherwise, we write the STE in the opposite order to cover cases from abort
+	 * to S2 or nested.
+	 */
+	ret = smmu_attach_stage_2(&target);
+	if (ret)
+		return ret;
+	hyp_spin_lock(&smmu->hw_lock);
+	cur_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(hyp_ste_ptr->data[0]));
+	target_cfg = FIELD_GET(STRTAB_STE_0_CFG, le64_to_cpu(target.data[0]));
+	target_valid = FIELD_GET(STRTAB_STE_0_V, le64_to_cpu(target.data[0]));
+	if ((cur_valid && !target_valid) ||
+	    (target_cfg == STRTAB_STE_0_CFG_ABORT)) {
+		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
+		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
+		for (i = 1; i < STRTAB_STE_DWORDS; i++)
+			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
+	} else {
+		for (i = 1; i < STRTAB_STE_DWORDS; i++)
+			WRITE_ONCE(hyp_ste_ptr->data[i], target.data[i]);
+		WARN_ON(smmu_send_cmd(smmu, &cfgi_cmd));
+		WRITE_ONCE(hyp_ste_ptr->data[0], target.data[0]);
+	}
+
+	ret = smmu_send_cmd(smmu, &cfgi_cmd);
+	hyp_spin_unlock(&smmu->hw_lock);
+	return ret;
 }
 
 static int smmu_init_strtab(struct hyp_arm_smmu_v3_device *smmu)
-- 
2.55.0.141.g00534a21ce-goog

