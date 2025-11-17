Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB61A33344D
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405317; cv=none; b=dmwMKcWmdFVajxkyzQh0YLICvoLx715t4N01mYgayrnePRBtfd9RKOHca6DLvzxMUHYG/+N5D/ELL2rlRVhabRAYob/N5tOfS3gcCy+WGlbIgIVMR2K+cQbs+C4fP4c2nKGI0z6penycri1nUd4W15c+2VlMt03iXKjLYlWTWcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405317; c=relaxed/simple;
	bh=oi0/lM+aBLYJf/HQK6DC0wmk8f5QQK92GHXZnx6nFfk=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FCwZAOukKSojCzyEGNe+jIEkPiAxTUx72zZgqgCb9tDE8qNLqFGUp9Ci+jJctGwYTSMI/edkWEdijvxsS7P0tnMjJ73N8B1YgeEo/6KnTX+YxX7D0IFUEFyV1wIwJ8vfB6QKqFkNp/Hcri88FKo0o4nMVr2ViDmwI+b1ydewUdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l/haWbzt; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l/haWbzt"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b7336ad128cso589862066b.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405313; x=1764010113; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=0hiT3u+aBwqtTyR01nuzLNZMiaS7VflcHmUp2NLVpzk=;
        b=l/haWbztGEA8BTCHSW/c95XZt+iln8tJ+H1mX4IF7634ErLfgm2EjPldI8aWynN0uL
         P2sS3ObvBUtbBewUq8HjQ/6nem1njENKuxsdXqv/dfil5BIS9X6hSQW6FOSJwNO03vMj
         3HG6GuhBnilTBTevdDSOYBQrwc73pVhQVE+MHxfogQWkkEoDGATgkMSajUrspcBfnsak
         3oIZ5B1Dwe7+06vKjxfd0hH6+zQtJqyQj+fldG4yYZFj6wPYx5sylzaTQIzfFCjBZ0Ap
         6vz5EUwPtE39w4hUesMj8pDJ1K3F8lyjqc60QW0tFWX9hjT6nLOdVLprOGqUomtiUtK5
         svHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405313; x=1764010113;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0hiT3u+aBwqtTyR01nuzLNZMiaS7VflcHmUp2NLVpzk=;
        b=Nzh2Fa8PRYPj2ajPNFpZpJHpN8kUBY5Ic5IZKuo5CKP8UG80Wd/oi2e86ncVbv+M/v
         owCNd1evPUMdk3DknSHeXZDnCxmhEmlJc5I6xpsZTUiswgyPgaOqa5Y7R1fd+VoHe+gZ
         yeGVHHIcLPNITnsszQe7NsvVy91lBsv5bNxGEN6JzK50KqeybJ4VIBKoJg8+XUsV2WXA
         ZXoiQ54qUGCFKpmyi6MZlA5eR8ESC3sZpsJ1BXaY6qeX3q0I4IvxKV8zYqZB00amZhAW
         WD+jNQ+TEzU1nvlq+/gB1+4NyfBnKglZMDpc6WGM0Il3Xv2TmBpP8w1A6UTZrBF0UKZd
         LV2w==
X-Forwarded-Encrypted: i=1; AJvYcCVGNEAVstcF/h1L39Ry+GCCCo2JfIs6X1JQ7G6R0h9b4QNHUonoiHn1sulsTRv+T5B0IC3VCaE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIrjSwxIdz8EcuXI2jsfuekdGnPec/2dxiiZMiJ8i2TWSwCPDO
	kJlc7wDCKuPo0TCM3xjj2ILt0LZur4nWGAktKMZdH+z/05BWyGYFjFazidCEqdV9t9aUuKkGsPl
	fNHYX0sHX2iQIFA==
X-Google-Smtp-Source: AGHT+IFYRIXgsXNF82x3u/Gk1+ZyU3/lN7ti3VErqwwIPcz3ByOxhGpblAT8LR3u4vT/vVdR5di2euXFrcpalg==
X-Received: from ejclk7.prod.google.com ([2002:a17:907:1787:b0:b73:7130:388f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:94ca:b0:b73:709e:a20a with SMTP id a640c23a62f3a-b73709ea300mr1129061466b.47.1763405313254;
 Mon, 17 Nov 2025 10:48:33 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:54 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-8-smostafa@google.com>
Subject: [PATCH v5 07/27] iommu/arm-smmu-v3: Move IDR parsing to common functions
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

Move parsing of IDRs to functions so that it can be re-used
from the hypervisor.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 112 +++-----------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h | 111 +++++++++++++++++++
 2 files changed, 126 insertions(+), 97 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f6c3eeb4ecea..7b1bd0658910 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4109,57 +4109,17 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
 
@@ -4171,21 +4131,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
@@ -4250,10 +4196,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	/* IDR3 */
 	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-	if (FIELD_GET(IDR3_RIL, reg))
-		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
-	if (FIELD_GET(IDR3_FWB, reg))
-		smmu->features |= ARM_SMMU_FEAT_S2FWB;
+	smmu->features |= smmu_idr3_features(reg);
 
 	if (FIELD_GET(IDR3_BBM, reg) == 2)
 		smmu->features |= ARM_SMMU_FEAT_BBML2;
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
index 4a59b4d39c4f..309194ceebe7 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -27,6 +27,7 @@ struct arm_vsmmu;
 #define IDR0_STALL_MODEL_FORCE		2
 #define IDR0_TTENDIAN			GENMASK(22, 21)
 #define IDR0_TTENDIAN_MIXED		0
+#define IDR0_TTENDIAN_RESERVED	1
 #define IDR0_TTENDIAN_LE		2
 #define IDR0_TTENDIAN_BE		3
 #define IDR0_CD2L			(1 << 19)
@@ -1072,6 +1073,116 @@ static inline void arm_smmu_write_strtab_l1_desc(struct arm_smmu_strtab_l1 *dst,
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
2.52.0.rc1.455.g30608eb744-goog

