Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 570E839EF07
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634407; cv=none; b=guhs/yyAVx0s8TIBir3vuMuhSrYCR7HaZ5DhnET6PjPGzbV5PTVl/Vd/xE3pb6VclYdTEsXPmtWoQyVF36OdDcFeZMiJ8ObzP6eX3X4BdvFrJDc96Sq9XJbHF8hJ1Oz+HamcLmv495h47F4+9vn/m6oKVDHRZ4NcYznpZjq/6lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634407; c=relaxed/simple;
	bh=MJpO/a/WnHz3UIfcZbr2Jxww3GoG5+ijB8pjliAreDw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=V4mQGsTEyavq3k6ev9cq9F8gkU4bhcj0IUiZ7tmI/BWK5lydneo38I+1g0/nYL0EQewdck+Ani+bge32mdIym4MT7P7T1e+RhmZkCGdD2Mvip1NjWjySNgmi4cRycFt73OS6a9SsfX6XZUrPS63dbFxUehcGZSIYbcVBb1Hg0O4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b21CGixf; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b21CGixf"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43ff19e54beso1245307f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634404; x=1778239204; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=SvUMSgIU3B3ilTsGpCNLEttDMrzsuBUntqQsjjdex/k=;
        b=b21CGixfE8iR52sDC6ItJSsRoOqs7ZRWiYoA6EXlm9TFAkp7O6wQ08ZgCh0lc5f2GV
         HrUZGbOSqVRiBfztxcL1sdcM9R4YVWyF0ZfHaGG1Ju1cU+6eHvXCw3WcpOgu+oA/dM+p
         gST3cY9ZjxFeh6PDS8yY0qQ6t1tXk1ZZs+E1rK00XnOExP7FuaFlRObETMNlPoxyBZ3s
         9nwZ66/JmeE5KjVfDW1Nhiwh5OyMT6Ij8oqP4VAjLFMpKByiJZZ5Vz4UNiApqApxBhFI
         Qhm88tviY+BBO6f8OhHIhEjY66E+ST0gYiV493Hj8fukUfxIgzIMQSCjM68Z8wyFfN+l
         HK0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634404; x=1778239204;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SvUMSgIU3B3ilTsGpCNLEttDMrzsuBUntqQsjjdex/k=;
        b=rqJaOK2vr8kBxQwqqiK7M6Tpj+aMBX7tTuFC2fMD9RWtXiGfuR2ZmQL4+G4Ers30Px
         VF7FsnKh2JEB+7XptsNrzSiXd7jLjW3A32y1UeZecNMXomSSSe13pSZsgik6lHqnlkvf
         mVX8C10GvnVo9twAzaTU7E3BI5QFW8C3QDtio5wruVBg9/rAqMhQ64AhnVDN4WljebB6
         D4MrkU9OW4Q3xx2kgo0PLA+5OCeT64p3pe2mwliep8llFd25XMPoiCva5crkkFR3Q6TZ
         bnaVLIy1odVhJ33UluKNtbbOsWU9b9t51mvd9789V4RzYyALkO/pc2psIsYw7rY1Vhd6
         zbhQ==
X-Forwarded-Encrypted: i=1; AFNElJ9C/k2vk7E0WSnt7HdfprcZRK37SqSMWvG0y1JYV6w3A6giqnqKg3gUHxtds2GQo/wMnFcD+Jk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOpH5eFzzEW62kGhSMaaCY4iWVwxAQvhwl5KwDzuVw7YOkk9NW
	olwk3Ldi3eEcJ4h/BoqOU7HBsd7czwEPwC6KWGAfsyXtiUvsopp7Go/tHrxg7xn2NJSW2+vB7Ob
	N91LdOSxzRlkSYw==
X-Received: from wmoo5.prod.google.com ([2002:a05:600d:105:b0:488:9c2a:aeba])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e16:b0:48a:52ce:a4b1 with SMTP id 5b1f17b1804b1-48a8451cff6mr117057225e9.15.1777634403717;
 Fri, 01 May 2026 04:20:03 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:07 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-6-smostafa@google.com>
Subject: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common functions
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

Move parsing of IDRs to functions so that it can be re-used
from the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 110 +++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 112 +++---------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   5 +
 3 files changed, 130 insertions(+), 97 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
index 62744c8548a8..e6dd087e2999 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
@@ -112,3 +112,113 @@ int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent)
 
 	return 0;
 }
+
+u32 smmu_idr0_features(u32 reg)
+{
+	u32 features = 0;
+
+	/* 2-level structures */
+	if (FIELD_GET(IDR0_ST_LVL, reg) == IDR0_ST_LVL_2LVL)
+		features |= ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	if (reg & IDR0_CD2L)
+		features |= ARM_SMMU_FEAT_2_LVL_CDTAB;
+
+	/*
+	 * Translation table endianness.
+	 * We currently require the same endianness as the CPU, but this
+	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 */
+	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
+	case IDR0_TTENDIAN_MIXED:
+		features |= ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE;
+		break;
+#ifdef __BIG_ENDIAN
+	case IDR0_TTENDIAN_BE:
+		features |= ARM_SMMU_FEAT_TT_BE;
+		break;
+#else
+	case IDR0_TTENDIAN_LE:
+		features |= ARM_SMMU_FEAT_TT_LE;
+		break;
+#endif
+	}
+
+	/* Boolean feature flags */
+	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
+		features |= ARM_SMMU_FEAT_PRI;
+
+	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
+		features |= ARM_SMMU_FEAT_ATS;
+
+	if (reg & IDR0_SEV)
+		features |= ARM_SMMU_FEAT_SEV;
+
+	if (reg & IDR0_MSI)
+		features |= ARM_SMMU_FEAT_MSI;
+
+	if (reg & IDR0_HYP)
+		features |= ARM_SMMU_FEAT_HYP;
+
+	switch (FIELD_GET(IDR0_STALL_MODEL, reg)) {
+	case IDR0_STALL_MODEL_FORCE:
+		features |= ARM_SMMU_FEAT_STALL_FORCE;
+		fallthrough;
+	case IDR0_STALL_MODEL_STALL:
+		features |= ARM_SMMU_FEAT_STALLS;
+	}
+
+	if (reg & IDR0_S1P)
+		features |= ARM_SMMU_FEAT_TRANS_S1;
+
+	if (reg & IDR0_S2P)
+		features |= ARM_SMMU_FEAT_TRANS_S2;
+
+	return features;
+}
+
+u32 smmu_idr3_features(u32 reg)
+{
+	u32 features = 0;
+
+	if (FIELD_GET(IDR3_RIL, reg))
+		features |= ARM_SMMU_FEAT_RANGE_INV;
+	if (FIELD_GET(IDR3_FWB, reg))
+		features |= ARM_SMMU_FEAT_S2FWB;
+
+	return features;
+}
+
+u32 smmu_idr5_to_oas(u32 reg)
+{
+	switch (FIELD_GET(IDR5_OAS, reg)) {
+	case IDR5_OAS_32_BIT:
+		return 32;
+	case IDR5_OAS_36_BIT:
+		return 36;
+	case IDR5_OAS_40_BIT:
+		return 40;
+	case IDR5_OAS_42_BIT:
+		return 42;
+	case IDR5_OAS_44_BIT:
+		return 44;
+	case IDR5_OAS_48_BIT:
+		return 48;
+	case IDR5_OAS_52_BIT:
+		return 52;
+	}
+	return 0;
+}
+
+unsigned long smmu_idr5_to_pgsize(u32 reg)
+{
+	unsigned long pgsize_bitmap = 0;
+
+	if (reg & IDR5_GRAN64K)
+		pgsize_bitmap |= SZ_64K | SZ_512M;
+	if (reg & IDR5_GRAN16K)
+		pgsize_bitmap |= SZ_16K | SZ_32M;
+	if (reg & IDR5_GRAN4K)
+		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
+	return pgsize_bitmap;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index c22832d26495..96d5e7f80ce7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4815,57 +4815,17 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	/* IDR0 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
 
-	/* 2-level structures */
-	if (FIELD_GET(IDR0_ST_LVL, reg) == IDR0_ST_LVL_2LVL)
-		smmu->features |= ARM_SMMU_FEAT_2_LVL_STRTAB;
-
-	if (reg & IDR0_CD2L)
-		smmu->features |= ARM_SMMU_FEAT_2_LVL_CDTAB;
-
-	/*
-	 * Translation table endianness.
-	 * We currently require the same endianness as the CPU, but this
-	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
-	 */
-	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
-	case IDR0_TTENDIAN_MIXED:
-		smmu->features |= ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE;
-		break;
-#ifdef __BIG_ENDIAN
-	case IDR0_TTENDIAN_BE:
-		smmu->features |= ARM_SMMU_FEAT_TT_BE;
-		break;
-#else
-	case IDR0_TTENDIAN_LE:
-		smmu->features |= ARM_SMMU_FEAT_TT_LE;
-		break;
-#endif
-	default:
+	smmu->features |= smmu_idr0_features(reg);
+	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE))) {
 		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
 		return -ENXIO;
 	}
-
-	/* Boolean feature flags */
-	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
-		smmu->features |= ARM_SMMU_FEAT_PRI;
-
-	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
-		smmu->features |= ARM_SMMU_FEAT_ATS;
-
-	if (reg & IDR0_SEV)
-		smmu->features |= ARM_SMMU_FEAT_SEV;
-
-	if (reg & IDR0_MSI) {
-		smmu->features |= ARM_SMMU_FEAT_MSI;
-		if (coherent && !disable_msipolling)
-			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
-	}
-
-	if (reg & IDR0_HYP) {
-		smmu->features |= ARM_SMMU_FEAT_HYP;
-		if (cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
-			smmu->features |= ARM_SMMU_FEAT_E2H;
-	}
+	if (coherent && !disable_msipolling &&
+	    smmu->features & ARM_SMMU_FEAT_MSI)
+		smmu->options |= ARM_SMMU_OPT_MSIPOLL;
+	if (smmu->features & ARM_SMMU_FEAT_HYP &&
+	    cpus_have_cap(ARM64_HAS_VIRT_HOST_EXTN))
+		smmu->features |= ARM_SMMU_FEAT_E2H;
 
 	arm_smmu_get_httu(smmu, reg);
 
@@ -4877,21 +4837,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 		dev_warn(smmu->dev, "IDR0.COHACC overridden by FW configuration (%s)\n",
 			 str_true_false(coherent));
 
-	switch (FIELD_GET(IDR0_STALL_MODEL, reg)) {
-	case IDR0_STALL_MODEL_FORCE:
-		smmu->features |= ARM_SMMU_FEAT_STALL_FORCE;
-		fallthrough;
-	case IDR0_STALL_MODEL_STALL:
-		smmu->features |= ARM_SMMU_FEAT_STALLS;
-	}
-
-	if (reg & IDR0_S1P)
-		smmu->features |= ARM_SMMU_FEAT_TRANS_S1;
-
-	if (reg & IDR0_S2P)
-		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
-
-	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
+	if (!(smmu->features & (ARM_SMMU_FEAT_TRANS_S1 | ARM_SMMU_FEAT_TRANS_S2))) {
 		dev_err(smmu->dev, "no translation support!\n");
 		return -ENXIO;
 	}
@@ -4950,10 +4896,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-	if (FIELD_GET(IDR3_RIL, reg))
-		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
-	if (FIELD_GET(IDR3_FWB, reg))
-		smmu->features |= ARM_SMMU_FEAT_S2FWB;
+	smmu->features |= smmu_idr3_features(reg);
 
 	if (FIELD_GET(IDR3_BBM, reg) == 2)
 		smmu->features |= ARM_SMMU_FEAT_BBML2;
@@ -4965,43 +4908,18 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
 
 	/* Page sizes */
-	if (reg & IDR5_GRAN64K)
-		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
-	if (reg & IDR5_GRAN16K)
-		smmu->pgsize_bitmap |= SZ_16K | SZ_32M;
-	if (reg & IDR5_GRAN4K)
-		smmu->pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
+	smmu->pgsize_bitmap = smmu_idr5_to_pgsize(reg);
 
 	/* Input address size */
 	if (FIELD_GET(IDR5_VAX, reg) == IDR5_VAX_52_BIT)
 		smmu->features |= ARM_SMMU_FEAT_VAX;
 
-	/* Output address size */
-	switch (FIELD_GET(IDR5_OAS, reg)) {
-	case IDR5_OAS_32_BIT:
-		smmu->oas = 32;
-		break;
-	case IDR5_OAS_36_BIT:
-		smmu->oas = 36;
-		break;
-	case IDR5_OAS_40_BIT:
-		smmu->oas = 40;
-		break;
-	case IDR5_OAS_42_BIT:
-		smmu->oas = 42;
-		break;
-	case IDR5_OAS_44_BIT:
-		smmu->oas = 44;
-		break;
-	case IDR5_OAS_52_BIT:
-		smmu->oas = 52;
+	smmu->oas = smmu_idr5_to_oas(reg);
+	if (smmu->oas == 52)
 		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
-		break;
-	default:
+	else if (!smmu->oas) {
 		dev_info(smmu->dev,
-			"unknown output address size. Truncating to 48-bit\n");
-		fallthrough;
-	case IDR5_OAS_48_BIT:
+			 "unknown output address size. Truncating to 48-bit\n");
 		smmu->oas = 48;
 	}
 
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 7be41dbe5aaa..64618299d03a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -1144,6 +1144,11 @@ int arm_smmu_cmdq_issue_cmdlist(struct arm_smmu_device *smmu,
 				bool sync);
 int arm_smmu_cmdq_build_cmd(u64 *cmd, struct arm_smmu_cmdq_ent *ent);
 
+u32 smmu_idr0_features(u32 reg);
+u32 smmu_idr3_features(u32 reg);
+u32 smmu_idr5_to_oas(u32 reg);
+unsigned long smmu_idr5_to_pgsize(u32 reg);
+
 /* Queue functions shared between kernel and hyp. */
 static inline bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
 {
-- 
2.54.0.545.g6539524ca2-goog

