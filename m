Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF4A23A19A
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026760; cv=none; b=s9/w8996+Yjo8LU3HDP0J7E8O+eMM+HS/jII2Xa8T1u0A+IMqaQEnAIaZOEGSRKF3N5Xw4ernOFQBw4UeJcz+MRnnpSLUjeSsUgqIEzI0dXekTXIOJRy47NMIRnxvy0qJLKci/LWtEjwE07Pn1ubBPUkOtPYipqZB3I5ksZJn/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026760; c=relaxed/simple;
	bh=8rc7Pi4YaxBecpkzJ1/eshpS8yx8YiLTlVBllfNEJY8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=WEOjvPD1ao+6ul6PrduXkPcR55/2dQyk2ByVGSRiZUTcVJ/VyVIzhhYfn7t797JT2/ZElGVsy4cQ84cGo9WqAR+1ul/8wOa8fDzsqTJp7yDaBkeuo7Jdqf0jUrHoQ3kxA956ffXEx2n1zgWJHwCPqd7TKEya7JaNjqk+oWBbP3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3uSwPORU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3uSwPORU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434f387f346so5761635e9.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026757; x=1734631557; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8QA34SgI5l6ru2Xaln4SGQrGK9VCHx5ARJvOrkuc5JA=;
        b=3uSwPORU15u4LZFazQpXPZxG3yntTdZaInyF9ZH7AcQ8iAZYxlp/8fAFPpTvifrCLk
         LQwDf3NlVrsMwSE29tJMEhEwkPJSBF1AB7o+iEe4AslhE13MsVVrRpI12eVT74KqvI05
         A+urbESSLnbnl7SutZBuf3UzwanrN5loO41AIbnupg29pkQ7FRHf0Dug4Zd+sqtj6cbj
         h28ghhUKnzaq9VRPrHA3bUcmG1AsIt0d1ghnUIIk5ANEK/VMv6OFLTNfhgTL7/5RR2ms
         SbM00Qz8a3PqQnDeBhPtFN5Fp/YnzbHhllnn+jcZbtNEtJ6mPDe4NM58+ryHK40gp6lt
         YF6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026757; x=1734631557;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8QA34SgI5l6ru2Xaln4SGQrGK9VCHx5ARJvOrkuc5JA=;
        b=cIHa2j+IvxyPbWlE3IhX7uUXcqmsuWy8hSf8awKg0Xf9M2wZf2cxMADWGug4I0mafz
         q2ttxKxGnngOz9hUKzPCPeEr0ffJKJ1y2nx6rwW1SJZ6y7knLk76d62+9vZMXGoTePxm
         TE2bAeM57K3rwj7r/Dfys5yoIB5dUqdd/cNzkwxlavDwUhBtlVVVnQRqVRLkatjvky9/
         gQVMagZVLulxHS1vmBruueyaJ5jtuEQ0FY/an4qXZI5tfsKmnH1NgQZ78TxZZYhsaAHb
         hobIjcFptlGzsmtnd4ehEY7vcVrHyGo3t2xmUA4muKcKIgLfmLbkEO/jHiPWB2TLMtf1
         5iEg==
X-Forwarded-Encrypted: i=1; AJvYcCW/wMXDzPcPuD3Chc427VBC66x3Cu4fPhrspuJZBRLOYRZya7eLMgg/hda7u7kjsaqrtcvmrPQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxRnfSCEwzyqqTlOqrDg6pAF3rgG6in0KeDFCgJT1iTnPpjWfYR
	JFSfxtuUo0FJ1APXdp8Bbk8siNScZio1ci3N7X3s4XoVR2SgrY7ONtQEH+Ien0szAAsC8IR/gAb
	Vgqvu5vzALQ==
X-Google-Smtp-Source: AGHT+IF16Jaf8i1Bw0pRdN0NDe/fPVVgR00KHWsUXu/7gcrg94xU+VGVHaEuKfgJTZsXm+cU714jOddkQJqMxQ==
X-Received: from wmsk11.prod.google.com ([2002:a05:600c:1c8b:b0:434:ef30:4be3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:6da6:0:b0:385:f220:f788 with SMTP id ffacd0b85a97d-387876c3257mr4098056f8f.48.1734026757027;
 Thu, 12 Dec 2024 10:05:57 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:59 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-36-smostafa@google.com>
Subject: [RFC PATCH v2 35/58] KVM: arm64: smmu-v3: Add attach_dev
From: Mostafa Saleh <smostafa@google.com>
To: iommu@lists.linux.dev, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org, 
	robin.murphy@arm.com, jean-philippe@linaro.org, jgg@ziepe.ca, 
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com, 
	tabba@google.com, danielmentz@google.com, tzukui@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Add attach_dev HVC code which handles both stage-1 and stage-2.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c | 244 +++++++++++++++++++-
 include/kvm/arm_smmu_v3.h                   |   4 +
 2 files changed, 242 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
index d58424e45e1d..a96eb6625c48 100644
--- a/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
+++ b/arch/arm64/kvm/hyp/nvhe/iommu/arm-smmu-v3.c
@@ -68,6 +68,11 @@ struct hyp_arm_smmu_v3_domain {
 	struct io_pgtable		*pgtable;
 };
 
+static struct hyp_arm_smmu_v3_device *to_smmu(struct kvm_hyp_iommu *iommu)
+{
+	return container_of(iommu, struct hyp_arm_smmu_v3_device, iommu);
+}
+
 static int smmu_write_cr0(struct hyp_arm_smmu_v3_device *smmu, u32 val)
 {
 	writel_relaxed(val, smmu->base + ARM_SMMU_CR0);
@@ -203,7 +208,6 @@ static int smmu_send_cmd(struct hyp_arm_smmu_v3_device *smmu,
 	return smmu_sync_cmd(smmu);
 }
 
-__maybe_unused
 static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 {
 	struct arm_smmu_cmdq_ent cmd = {
@@ -215,7 +219,6 @@ static int smmu_sync_ste(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 	return smmu_send_cmd(smmu, &cmd);
 }
 
-__maybe_unused
 static int smmu_sync_cd(struct hyp_arm_smmu_v3_device *smmu, u32 sid, u32 ssid)
 {
 	struct arm_smmu_cmdq_ent cmd = {
@@ -289,7 +292,6 @@ smmu_get_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 	return &cfg->linear.table[sid];
 }
 
-__maybe_unused
 static struct arm_smmu_ste *
 smmu_get_alloc_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 {
@@ -304,14 +306,12 @@ smmu_get_alloc_ste_ptr(struct hyp_arm_smmu_v3_device *smmu, u32 sid)
 	return smmu_get_ste_ptr(smmu, sid);
 }
 
-__maybe_unused
 static u64 *smmu_get_cd_ptr(u64 *cdtab, u32 ssid)
 {
 	/* Only linear supported for now. */
 	return cdtab + ssid * CTXDESC_CD_DWORDS;
 }
 
-__maybe_unused
 static u64 *smmu_alloc_cd(struct hyp_arm_smmu_v3_device *smmu, u32 pasid_bits)
 {
 	u64 *cd_table;
@@ -803,7 +803,6 @@ static void smmu_tlb_add_page(struct iommu_iotlb_gather *gather,
 		smmu_tlb_inv_range(cookie, iova, granule, granule, true);
 }
 
-__maybe_unused
 static const struct iommu_flush_ops smmu_tlb_ops = {
 	.tlb_flush_all	= smmu_tlb_flush_all,
 	.tlb_flush_walk = smmu_tlb_flush_walk,
@@ -821,6 +820,238 @@ static void smmu_iotlb_sync(struct kvm_hyp_iommu_domain *domain,
 	smmu_tlb_inv_range(domain, gather->start, size,  gather->pgsize, true);
 }
 
+static int smmu_domain_config_s2(struct kvm_hyp_iommu_domain *domain,
+				 struct arm_smmu_ste *ste)
+{
+	struct io_pgtable_cfg *cfg;
+	u64 ts, sl, ic, oc, sh, tg, ps;
+	struct hyp_arm_smmu_v3_domain *smmu_domain = domain->priv;
+
+	cfg = &smmu_domain->pgtable->cfg;
+	ps = cfg->arm_lpae_s2_cfg.vtcr.ps;
+	tg = cfg->arm_lpae_s2_cfg.vtcr.tg;
+	sh = cfg->arm_lpae_s2_cfg.vtcr.sh;
+	oc = cfg->arm_lpae_s2_cfg.vtcr.orgn;
+	ic = cfg->arm_lpae_s2_cfg.vtcr.irgn;
+	sl = cfg->arm_lpae_s2_cfg.vtcr.sl;
+	ts = cfg->arm_lpae_s2_cfg.vtcr.tsz;
+
+	ste->data[0] = STRTAB_STE_0_V |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S2_TRANS);
+	ste->data[1] = FIELD_PREP(STRTAB_STE_1_SHCFG, STRTAB_STE_1_SHCFG_INCOMING);
+	ste->data[2] = FIELD_PREP(STRTAB_STE_2_VTCR,
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2PS, ps) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2TG, tg) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2SH0, sh) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2OR0, oc) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2IR0, ic) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2SL0, sl) |
+			FIELD_PREP(STRTAB_STE_2_VTCR_S2T0SZ, ts)) |
+		 FIELD_PREP(STRTAB_STE_2_S2VMID, domain->domain_id) |
+		 STRTAB_STE_2_S2AA64 | STRTAB_STE_2_S2R;
+	ste->data[3] = cfg->arm_lpae_s2_cfg.vttbr & STRTAB_STE_3_S2TTB_MASK;
+
+	return 0;
+}
+
+static u64 *smmu_domain_config_s1_ste(struct hyp_arm_smmu_v3_device *smmu,
+				      u32 pasid_bits, struct arm_smmu_ste *ste)
+{
+	u64 *cd_table;
+
+	cd_table = smmu_alloc_cd(smmu, pasid_bits);
+	if (!cd_table)
+		return NULL;
+
+	ste->data[1] = FIELD_PREP(STRTAB_STE_1_S1DSS, STRTAB_STE_1_S1DSS_SSID0) |
+		FIELD_PREP(STRTAB_STE_1_S1CIR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1COR, STRTAB_STE_1_S1C_CACHE_WBRA) |
+		FIELD_PREP(STRTAB_STE_1_S1CSH, ARM_SMMU_SH_ISH);
+	ste->data[0] = ((u64)cd_table & STRTAB_STE_0_S1CTXPTR_MASK) |
+		FIELD_PREP(STRTAB_STE_0_CFG, STRTAB_STE_0_CFG_S1_TRANS) |
+		FIELD_PREP(STRTAB_STE_0_S1CDMAX, pasid_bits) |
+		FIELD_PREP(STRTAB_STE_0_S1FMT, STRTAB_STE_0_S1FMT_LINEAR) |
+		STRTAB_STE_0_V;
+
+	return cd_table;
+}
+
+/*
+ * This function handles configuration for pasid and non-pasid domains
+ * with the following assumptions:
+ * - pasid 0 always attached first, this should be the typicall flow
+ *   for the kernel where attach_dev is always called before set_dev_pasid.
+ *   In that case only pasid 0 is allowed to allocate memory for the CD,
+ *   and other pasids would expect to find the tabel.
+ * - pasid 0 is detached last, also guaranteed from the kernel.
+ */
+static int smmu_domain_config_s1(struct hyp_arm_smmu_v3_device *smmu,
+				 struct kvm_hyp_iommu_domain *domain,
+				 u32 sid, u32 pasid, u32 pasid_bits,
+				 struct arm_smmu_ste *ste)
+{
+	struct arm_smmu_ste *dst;
+	u64 val;
+	u64 *cd_entry, *cd_table;
+	struct io_pgtable_cfg *cfg;
+	struct hyp_arm_smmu_v3_domain *smmu_domain = domain->priv;
+
+	cfg = &smmu_domain->pgtable->cfg;
+	dst = smmu_get_ste_ptr(smmu, sid);
+	val = dst->data[0];
+
+	if (FIELD_GET(STRTAB_STE_0_CFG, val) == STRTAB_STE_0_CFG_S2_TRANS)
+		return -EBUSY;
+
+	if (pasid == 0) {
+		cd_table = smmu_domain_config_s1_ste(smmu, pasid_bits, ste);
+		if (!cd_table)
+			return -ENOMEM;
+	} else {
+		u32 nr_entries;
+
+		cd_table = (u64 *)(FIELD_GET(STRTAB_STE_0_S1CTXPTR_MASK, val) << 6);
+		if (!cd_table)
+			return -EINVAL;
+		nr_entries = 1 << FIELD_GET(STRTAB_STE_0_S1CDMAX, val);
+		if (pasid >= nr_entries)
+			return -E2BIG;
+	}
+
+	/* Write CD. */
+	cd_entry = smmu_get_cd_ptr(hyp_phys_to_virt((u64)cd_table), pasid);
+
+	/* CD already used by another device. */
+	if (cd_entry[0])
+		return -EBUSY;
+
+	cd_entry[1] = cpu_to_le64(cfg->arm_lpae_s1_cfg.ttbr & CTXDESC_CD_1_TTB0_MASK);
+	cd_entry[2] = 0;
+	cd_entry[3] = cpu_to_le64(cfg->arm_lpae_s1_cfg.mair);
+
+	/* STE is live. */
+	if (pasid)
+		smmu_sync_cd(smmu, sid, pasid);
+	val =  FIELD_PREP(CTXDESC_CD_0_TCR_T0SZ, cfg->arm_lpae_s1_cfg.tcr.tsz) |
+	       FIELD_PREP(CTXDESC_CD_0_TCR_TG0, cfg->arm_lpae_s1_cfg.tcr.tg) |
+	       FIELD_PREP(CTXDESC_CD_0_TCR_IRGN0, cfg->arm_lpae_s1_cfg.tcr.irgn) |
+	       FIELD_PREP(CTXDESC_CD_0_TCR_ORGN0, cfg->arm_lpae_s1_cfg.tcr.orgn) |
+	       FIELD_PREP(CTXDESC_CD_0_TCR_SH0, cfg->arm_lpae_s1_cfg.tcr.sh) |
+	       FIELD_PREP(CTXDESC_CD_0_TCR_IPS, cfg->arm_lpae_s1_cfg.tcr.ips) |
+	       CTXDESC_CD_0_TCR_EPD1 | CTXDESC_CD_0_AA64 |
+	       CTXDESC_CD_0_R | CTXDESC_CD_0_A |
+	       CTXDESC_CD_0_ASET |
+	       FIELD_PREP(CTXDESC_CD_0_ASID, domain->domain_id) |
+	       CTXDESC_CD_0_V;
+	WRITE_ONCE(cd_entry[0], cpu_to_le64(val));
+	/* STE is live. */
+	if (pasid)
+		smmu_sync_cd(smmu, sid, pasid);
+	return 0;
+}
+
+static int smmu_domain_finalise(struct hyp_arm_smmu_v3_device *smmu,
+				struct kvm_hyp_iommu_domain *domain)
+{
+	int ret;
+	struct io_pgtable_cfg cfg;
+	struct hyp_arm_smmu_v3_domain *smmu_domain = domain->priv;
+
+	if (smmu_domain->type == KVM_ARM_SMMU_DOMAIN_S1) {
+		size_t ias = (smmu->features & ARM_SMMU_FEAT_VAX) ? 52 : 48;
+
+		cfg = (struct io_pgtable_cfg) {
+			.fmt = ARM_64_LPAE_S1,
+			.pgsize_bitmap = smmu->pgsize_bitmap,
+			.ias = min_t(unsigned long, ias, VA_BITS),
+			.oas = smmu->ias,
+			.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
+			.tlb = &smmu_tlb_ops,
+		};
+	} else {
+		cfg = (struct io_pgtable_cfg) {
+			.fmt = ARM_64_LPAE_S2,
+			.pgsize_bitmap = smmu->pgsize_bitmap,
+			.ias = smmu->ias,
+			.oas = smmu->oas,
+			.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
+			.tlb = &smmu_tlb_ops,
+		};
+	}
+
+	hyp_spin_lock(&smmu_domain->pgt_lock);
+	smmu_domain->pgtable = kvm_arm_io_pgtable_alloc(&cfg, domain, &ret);
+	hyp_spin_unlock(&smmu_domain->pgt_lock);
+	return ret;
+}
+
+static int smmu_attach_dev(struct kvm_hyp_iommu *iommu, struct kvm_hyp_iommu_domain *domain,
+			   u32 sid, u32 pasid, u32 pasid_bits)
+{
+	int i;
+	int ret;
+	struct arm_smmu_ste *dst;
+	struct arm_smmu_ste ste = {};
+	struct hyp_arm_smmu_v3_device *smmu = to_smmu(iommu);
+	struct hyp_arm_smmu_v3_domain *smmu_domain = domain->priv;
+
+	kvm_iommu_lock(iommu);
+	dst = smmu_get_alloc_ste_ptr(smmu, sid);
+	if (!dst) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	if (smmu_domain->smmu && (smmu != smmu_domain->smmu)) {
+		ret = -EINVAL;
+		goto out_unlock;
+	}
+
+	if (!smmu_domain->pgtable) {
+		ret = smmu_domain_finalise(smmu, domain);
+		if (ret)
+			goto out_unlock;
+	}
+
+	if (smmu_domain->type == KVM_ARM_SMMU_DOMAIN_S2) {
+		/* Device already attached or pasid for s2. */
+		if (dst->data[0] || pasid) {
+			ret = -EBUSY;
+			goto out_unlock;
+		}
+		ret = smmu_domain_config_s2(domain, &ste);
+	} else {
+		/*
+		 * Allocate and config CD, and update CD if possible.
+		 */
+		pasid_bits = min(pasid_bits, smmu->ssid_bits);
+		ret = smmu_domain_config_s1(smmu, domain, sid, pasid,
+					    pasid_bits, &ste);
+	}
+	smmu_domain->smmu = smmu;
+	/* We don't update STEs for pasid domains. */
+	if (ret || pasid)
+		goto out_unlock;
+
+	/*
+	 * The SMMU may cache a disabled STE.
+	 * Initialize all fields, sync, then enable it.
+	 */
+	for (i = 1; i < STRTAB_STE_DWORDS; i++)
+		dst->data[i] = ste.data[i];
+
+	ret = smmu_sync_ste(smmu, sid);
+	if (ret)
+		goto out_unlock;
+
+	WRITE_ONCE(dst->data[0], ste.data[0]);
+	ret = smmu_sync_ste(smmu, sid);
+	WARN_ON(ret);
+out_unlock:
+	kvm_iommu_unlock(iommu);
+	return ret;
+}
+
 /* Shared with the kernel driver in EL1 */
 struct kvm_iommu_ops smmu_ops = {
 	.init				= smmu_init,
@@ -828,4 +1059,5 @@ struct kvm_iommu_ops smmu_ops = {
 	.alloc_domain			= smmu_alloc_domain,
 	.free_domain			= smmu_free_domain,
 	.iotlb_sync			= smmu_iotlb_sync,
+	.attach_dev			= smmu_attach_dev,
 };
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index ded98cbaebc1..e8616ec5a048 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -25,6 +25,10 @@ struct hyp_arm_smmu_v3_device {
 	size_t			cmdq_log2size;
 	/* strtab_cfg.l2.l2ptrs is not used, instead computed from L1 */
 	struct arm_smmu_strtab_cfg strtab_cfg;
+	size_t			oas;
+	size_t			ias;
+	size_t			pgsize_bitmap;
+	size_t			ssid_bits;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.47.0.338.g60cca15819-goog

