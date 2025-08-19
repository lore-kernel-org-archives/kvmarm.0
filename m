Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241ED35083D
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 21:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755640356; cv=none; b=owD7R/cEVpEaRCP9W6DHgcbBctnFVFl+rVq7DscbvhKF0J2zrW0SnUYT8QSIS8XVY+Xe3y7gJ8OrxC5BXvR1SaiyOT1nS6nkdgMPDPy/CdOyLzIcrjZIOzi6c0kAQ1+yiZCaLa0rgq3BfpY+apjWnEZ29Cog/uc1TcW0jEIvpEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755640356; c=relaxed/simple;
	bh=gY7xXY2zsrLp/8by2WZLyKzu8vPZW0iFJI4dE5BSgNE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KreCWvRKBbKg356E9Nt8qGf0JQEO4X+Xy4AOCsDqc4Tw3yScCZbTGGPU+CbD0mqXNK7Ru2wXoqHFGhgN35jiZt4EJ3KfEhBxuDKa+8SHrMOtMHMkVu+UKIgXIU9uiDJ3gwyFl7fNwC3gPea8aMnz5HkX/x5InD27UzyYAttfpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iEMpcNJm; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iEMpcNJm"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-afcb7a4132eso406014966b.3
        for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 14:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755640351; x=1756245151; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=aD+G81Z9oxnwqUIpqodF/OdO7i2K2AUH5qGZ1B3RDBI=;
        b=iEMpcNJmbqsqCcwHLAZWHa2KBmmkXPMYQKb7kcZwxUG5MDk+9XChdTfGyJ6+PYnfMr
         yc2EL+ty0gXAd5cGFk9yR+/08j67BehXwXnunljRm0Twj8rPn9B7/hE45kbZBBaMUcS4
         69OLtQDmJTumIkpZ+qlTP7mCT+Xvz/KFv2YWo1LAsYdNdWAsD+7kxSilpmJ2SFonQY8U
         31Ltctqk06cV7W6j046r/tvsXjk5dKZom4a10bqnCBLu4GB8YP9DHAqomjMHSLoXgif5
         aMfiz/QWtcLfUYYQyMAvSazLzAiWD/I+zfHpvTZJnaNNKECOgPCkAT6g7k6SB+VMYW0+
         uWWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755640351; x=1756245151;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aD+G81Z9oxnwqUIpqodF/OdO7i2K2AUH5qGZ1B3RDBI=;
        b=cTNGWM8/PtzI417gObodBYv3x0YFfKx8J48sitSB0luq/PxeWP+E9Wex3A7/sLBLTN
         qnQl90aOZSBXUE9aI5owVcHh/xZ6QhVXINnKyBMzpWADg0gj3LhWa6lOrt29V/TQdDTt
         dmmOROQqTa2mImaX4qVUj4XkO97lmqpAeMiUzkhX1+bjWOPObS4ZXlSFgJ0N8C2IPQNQ
         gl2gI2nEFgs1SV+6M9ulrP8u6aV/tDq3SZAOuHUUnGSKhAnVSiI1WNxlwsw8oi3UVwKp
         YzDc3C6QQaU6KA1nVjeKozVd7RVCyAnwq2rCT5Vz1i8yrglJsWy1+ImE7BoaTp9jWAb/
         2AEA==
X-Forwarded-Encrypted: i=1; AJvYcCWzFsPsvSEe54d6zfpnZzWWu5MApbvCJkyaYjbvlSWdzKD1dP9CMxd9D3Sd0Qb+YZSnUGHKTL4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxT04QTQol1DtgvwcXvHT7zFQce4fxUTYTRvsadl8xKiccki0b3
	skra5nOxKaCZZlUkkLLS+HW36CgS3QHh2OJdLOdxipGxdSvPvXF15YgevVufgCn3if7zyGgx06M
	I8ZuNgNElCJwX3w==
X-Google-Smtp-Source: AGHT+IER6S3IHefQc1j2cX6131Dk1oXUA4oF1GAkycdxrs/phTvQWDjEc8Kuq1XUg+nr2Cpuhr0CZkidIrgNsA==
X-Received: from ejcvh5.prod.google.com ([2002:a17:907:d385:b0:ae0:b29b:51a2])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:8459:b0:af9:a2cb:f1a1 with SMTP id a640c23a62f3a-afdf01a8374mr29365866b.38.1755640351521;
 Tue, 19 Aug 2025 14:52:31 -0700 (PDT)
Date: Tue, 19 Aug 2025 21:51:36 +0000
In-Reply-To: <20250819215156.2494305-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250819215156.2494305-1-smostafa@google.com>
X-Mailer: git-send-email 2.51.0.rc1.167.g924127e9c0-goog
Message-ID: <20250819215156.2494305-9-smostafa@google.com>
Subject: [PATCH v4 08/28] iommu/arm-smmu-v3: Move IDR parsing to common functions
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Move parsing of IDRs to functions so that it can be re-used
from the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 112 +++-----------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 111 +++++++++++++++++++
 2 files changed, 126 insertions(+), 97 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 41820a9180f4..10ca07c6dbe9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4112,57 +4112,17 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
+	if (FIELD_GET(IDR0_TTENDIAN, reg) == IDR0_TTENDIAN_RESERVED) {
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
 
@@ -4174,21 +4134,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
@@ -4253,10 +4199,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-	if (FIELD_GET(IDR3_RIL, reg))
-		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
-	if (FIELD_GET(IDR3_FWB, reg))
-		smmu->features |= ARM_SMMU_FEAT_S2FWB;
+	smmu->features |= smmu_idr3_features(reg);
 
 	/* IDR5 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
@@ -4265,43 +4208,18 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
index a222fb7ef2ec..8ffcc2e32474 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -26,6 +26,7 @@ struct arm_smmu_device;
 #define IDR0_STALL_MODEL_FORCE		2
 #define IDR0_TTENDIAN			GENMASK(22, 21)
 #define IDR0_TTENDIAN_MIXED		0
+#define IDR0_TTENDIAN_RESERVED	1
 #define IDR0_TTENDIAN_LE		2
 #define IDR0_TTENDIAN_BE		3
 #define IDR0_CD2L			(1 << 19)
@@ -1042,6 +1043,116 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
 	WRITE_ONCE(dst->l2ptr, cpu_to_le64(val));
 }
 
+static inline u32 smmu_idr0_features(u32 reg)
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
+static inline u32 smmu_idr3_features(u32 reg)
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
+static inline u32 smmu_idr5_to_oas(u32 reg)
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
+static inline unsigned long smmu_idr5_to_pgsize(u32 reg)
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
+
 /**
  * arm_smmu_tlb_inv_build - Create a range invalidation command
  * @cmd: Base command initialized with OPCODE (S1, S2..), vmid and asid.
-- 
2.51.0.rc1.167.g924127e9c0-goog

