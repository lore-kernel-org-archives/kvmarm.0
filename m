Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7B3481FD1
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 20:09:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792094962; cv=none; b=nXqFPXeX/HmUnHyyjNvoMKVRVgbTtDeXsXXQn/CY6RFOh+Nkyh6nzhzu1JIc90E8nhe0FGUkW3bhSfJRLoeWYK9cNOOb/ulvLCfwmxr0v+SryBiYOJjknDo89IcaL4PkAjfOqlfIoi800dqDzKRrQ7D0wPw0wYYzgpMRQyTpIOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792094962; c=relaxed/simple;
	bh=r63L3owY7mfJ3h4aniiVL9LvB+bNIP+0KJVZO/Aww5U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=usjY2ZinHum/w7OS/Uz48QziRhpTp5J8rcUOpDyNYLusqSaxMZrcCmUEVZQe8dv6PtkG3fyHjyIqXIZg67u8jfXTC179+yXRdyhd4qFaZ9c8giSXn8ZPvbDjq1x2BhQYqeUzfmnDJ8Yv3wd8FGuc4R3uVcuOqQfn6Vj1ySntang=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MlvmTFrx; arc=none smtp.client-ip=209.85.128.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MlvmTFrx"
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4a17574b5easo17700735e9.2
        for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 13:09:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792094954; x=1792699754; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fvOl/hxvEkk8z+uVJIZLKJKVTrO3KToYAMaC4rC2vNA=;
        b=MlvmTFrxCVm6eQli2NViUCoBu6bMRt7g6tHgCx6W6BfHgt8xSZWbSkOslzMOR4l8+E
         IDRgxyNNXWngoQm1jUg+ViCn5i53pDNSoMXrYUgr4cJbpGEAm8pJxV9UswaRfm2PKD8L
         tq7M6FG3iqBEBo7VqTWzrBKyh2g/FXc0YtwWlfgTWuYJF9ti8yvwNcwJx/LU+6QzOJ9K
         8fZ/qpjRvJierlmr9k0TGMrtmz5g506CUjf+WnTZHHt+JPqL3zKq6fIctIjPUKuvZp64
         eIhDRidWCjLxEd30S5WLYxgTTxiWO8cgDT8EKhtVLAokpBbsCCvx6Y5ScwvqCRb2ymGW
         KfQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792094954; x=1792699754;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=fvOl/hxvEkk8z+uVJIZLKJKVTrO3KToYAMaC4rC2vNA=;
        b=Pm3CjbpDhbsKmIbdxAgXRDLupyGQD0Nzneifd5/AJJ7r3Q3rxTxNcstiCMt1a50bAz
         RVgdtt2vZ2ll9HfQwkCBOuvi4uRTHTFu7eHpQdIckjdbKie2Hn3JpboPtgkBrdoa3Sb9
         4t+ZBEoN+F8cwsN4Xtv1xJyc9J1m3kqczulSEEraBzru5SyfIJmV5LDzml2h9jsLkQz7
         ItKL3OdoVLZCfA0ZJvPFkkHydqm01srwuiv2ElTyFeeoLh82g9Urble9njIigAlNNskv
         VKO5H/ljkz/ZmxMB1xOsrKYi78l/kTvzKJdVJrHRkC5XYAWb7hQMEnk080lH3+G5kIt1
         lo8A==
X-Forwarded-Encrypted: i=1; AKwUvBziqcFPAXT7x+27t01AO7isRMhKZY8SPmSzD0yoZmgPGAq+L1kTjJDZidAipNSefA8/O7pNfVY=@lists.linux.dev
X-Gm-Message-State: AFq9FYICK0cvkMRG93pVAW9O7l0lrlMnWX6L7PrfGj/WKjiOCaFDGC9G
	t/s56Aedi7oA3xFIhK/hAv5hnX1WNFtrAFY8IqHmULWL7KXaQvJxtXxQXv3lckK+3+cJQCaF+MA
	2VaWKJlwa8IypBw==
X-Received: from wmbg12.prod.google.com ([2002:a05:600c:a40c:b0:49f:fd3d:3bd3])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e89:b0:4a0:12d7:4c88 with SMTP id 5b1f17b1804b1-4a18e4ac77amr453376685e9.30.1792094954389;
 Thu, 15 Oct 2026 13:09:14 -0700 (PDT)
Date: Thu, 15 Oct 2026 20:08:34 +0000
In-Reply-To: <20261015200903.2735565-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20261015200903.2735565-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
Message-ID: <20261015200903.2735565-4-smostafa@google.com>
Subject: [PATCH v9 03/25] iommu/arm-smmu-v3: Move IDR parsing to common functions
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	nicolinc@nvidia.com, Mostafa Saleh <smostafa@google.com>, Jason Gunthorpe <jgg@nvidia.com>
Content-Type: text/plain; charset="UTF-8"

The hypervisor SMMUv3 driver needs the same IDR0, IDR3, IDR5 and IIDR
parsing as the kernel driver, plus the IDR1 checks it depends on
(embedded implementation, ATTR_TYPES_OVR, StreamID size). Move them to
arm-smmu-v3-common-lib.c, which will be built for both, and the IIDR
implementer and product IDs to arm-smmu-v3.h.

The two drivers use different device structs, so the shared code is
written against ARM_SMMU_OBJ, which each compilation unit defines. The
kernel maps it to struct arm_smmu_device. Static asserts check that the
fields the shared code uses exist with the expected types.

The validity checks stay with the parsing. dev_err() and dev_info()
become arm_smmu_err() and arm_smmu_info(), defined per world next to
ARM_SMMU_OBJ, as the hypervisor cannot print to the console. The
disable_msipolling module parameter is passed as an argument so the
hypervisor can opt out, and cpus_have_cap() becomes
cpus_have_final_cap(), which the hypervisor can use.

No functional change intended.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |   2 +-
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.c  | 240 ++++++++++++++++++
 .../arm/arm-smmu-v3/arm-smmu-v3-common-lib.h  |  39 +++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 220 +---------------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   6 +
 5 files changed, 297 insertions(+), 210 deletions(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 493a659cc66b..c9ce392e6d31 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 obj-$(CONFIG_ARM_SMMU_V3) += arm_smmu_v3.o
-arm_smmu_v3-y := arm-smmu-v3.o
+arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-lib.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
new file mode 100644
index 000000000000..22467aaca191
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.c
@@ -0,0 +1,240 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2015 ARM Limited
+ * Arm SMMUv3 driver functions shared with hypervisor.
+ */
+
+#include <asm/cpufeature.h>
+
+#include "arm-smmu-v3.h"
+#include "arm-smmu-v3-common-lib.h"
+
+void arm_smmu_device_iidr_probe(ARM_SMMU_OBJ *smmu)
+{
+	u32 reg;
+	unsigned int implementer, productid, variant, revision;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
+	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
+	productid = FIELD_GET(IIDR_PRODUCTID, reg);
+	variant = FIELD_GET(IIDR_VARIANT, reg);
+	revision = FIELD_GET(IIDR_REVISION, reg);
+
+	switch (implementer) {
+	case IIDR_IMPLEMENTER_ARM:
+		switch (productid) {
+		case IIDR_PRODUCTID_ARM_MMU_600:
+			/* Arm erratum 1076982 */
+			if (variant == 0 && revision <= 2)
+				smmu->features &= ~ARM_SMMU_FEAT_SEV;
+			/* Arm erratum 1209401 */
+			if (variant < 2)
+				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
+			break;
+		case IIDR_PRODUCTID_ARM_MMU_700:
+			/* Many errata... */
+			smmu->features &= ~ARM_SMMU_FEAT_BTM;
+			if (variant < 1 || revision < 1) {
+				/* Arm erratum 2812531 */
+				smmu->options |= ARM_SMMU_OPT_CMDQ_FORCE_SYNC;
+				/* Arm errata 2268618, 2812531 */
+				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
+			}
+			/* Arm errata 3777127 */
+			smmu->options |= ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
+			break;
+		case IIDR_PRODUCTID_ARM_MMU_L1:
+			/* Arm errata 3878312 */
+			smmu->features &= ~ARM_SMMU_FEAT_BTM;
+			break;
+		case IIDR_PRODUCTID_ARM_MMU_S3:
+			/* Arm errata 3995052 */
+			smmu->features &= ~ARM_SMMU_FEAT_BTM;
+			/* Arm errata 3673557 */
+			if (variant < 1 || (variant == 1 && revision < 1))
+				smmu->options |=
+					ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
+			break;
+		}
+		break;
+	}
+}
+
+int arm_smmu_device_idr0_probe(ARM_SMMU_OBJ *smmu, bool disable_msipolling,
+			       u32 *idr0)
+{
+	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	u32 reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
+
+	/* 2-level structures */
+	if (FIELD_GET(IDR0_ST_LVL, reg) == IDR0_ST_LVL_2LVL)
+		smmu->features |= ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	if (reg & IDR0_CD2L)
+		smmu->features |= ARM_SMMU_FEAT_2_LVL_CDTAB;
+
+	/*
+	 * Translation table endianness.
+	 * We currently require the same endianness as the CPU, but this
+	 * could be changed later by adding a new IO_PGTABLE_QUIRK.
+	 */
+	switch (FIELD_GET(IDR0_TTENDIAN, reg)) {
+	case IDR0_TTENDIAN_MIXED:
+		smmu->features |= ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE;
+		break;
+#ifdef __BIG_ENDIAN
+	case IDR0_TTENDIAN_BE:
+		smmu->features |= ARM_SMMU_FEAT_TT_BE;
+		break;
+#else
+	case IDR0_TTENDIAN_LE:
+		smmu->features |= ARM_SMMU_FEAT_TT_LE;
+		break;
+#endif
+	default:
+		arm_smmu_err(smmu, "unknown/unsupported TT endianness!\n");
+		return -ENXIO;
+	}
+
+	/* Boolean feature flags */
+	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
+		smmu->features |= ARM_SMMU_FEAT_PRI;
+
+	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
+		smmu->features |= ARM_SMMU_FEAT_ATS;
+
+	if (reg & IDR0_SEV)
+		smmu->features |= ARM_SMMU_FEAT_SEV;
+
+	if (reg & IDR0_MSI) {
+		smmu->features |= ARM_SMMU_FEAT_MSI;
+		if (coherent && !disable_msipolling)
+			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
+	}
+
+	if (reg & IDR0_HYP) {
+		smmu->features |= ARM_SMMU_FEAT_HYP;
+		if (cpus_have_final_cap(ARM64_HAS_VIRT_HOST_EXTN))
+			smmu->features |= ARM_SMMU_FEAT_E2H;
+	}
+
+	switch (FIELD_GET(IDR0_STALL_MODEL, reg)) {
+	case IDR0_STALL_MODEL_FORCE:
+		smmu->features |= ARM_SMMU_FEAT_STALL_FORCE;
+		fallthrough;
+	case IDR0_STALL_MODEL_STALL:
+		smmu->features |= ARM_SMMU_FEAT_STALLS;
+	}
+
+	if (reg & IDR0_S1P)
+		smmu->features |= ARM_SMMU_FEAT_TRANS_S1;
+
+	if (reg & IDR0_S2P)
+		smmu->features |= ARM_SMMU_FEAT_TRANS_S2;
+
+	if (!(reg & (IDR0_S1P | IDR0_S2P))) {
+		arm_smmu_err(smmu, "no translation support!\n");
+		return -ENXIO;
+	}
+
+	/* We only support the AArch64 table format at present */
+	if (!(FIELD_GET(IDR0_TTF, reg) & IDR0_TTF_AARCH64)) {
+		arm_smmu_err(smmu, "AArch64 table format not supported!\n");
+		return -ENXIO;
+	}
+
+	if ((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
+	    (smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		smmu->features |= ARM_SMMU_FEAT_NESTING;
+
+	*idr0 = reg;
+	return 0;
+}
+
+int arm_smmu_device_idr1_probe(ARM_SMMU_OBJ *smmu, u32 *idr1)
+{
+	u32 reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+
+	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL)) {
+		arm_smmu_err(smmu, "embedded implementation not supported\n");
+		return -ENXIO;
+	}
+
+	if (reg & IDR1_ATTR_TYPES_OVR)
+		smmu->features |= ARM_SMMU_FEAT_ATTR_TYPES_OVR;
+
+	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+
+	/*
+	 * If the SMMU supports fewer bits than would fill a single L2 stream
+	 * table, use a linear table instead.
+	 */
+	if (smmu->sid_bits <= STRTAB_SPLIT)
+		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	*idr1 = reg;
+	return 0;
+}
+
+void arm_smmu_device_idr3_probe(ARM_SMMU_OBJ *smmu)
+{
+	u32 reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+
+	if (FIELD_GET(IDR3_RIL, reg))
+		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
+	if (FIELD_GET(IDR3_FWB, reg))
+		smmu->features |= ARM_SMMU_FEAT_S2FWB;
+	if (FIELD_GET(IDR3_BBM, reg) == 2)
+		smmu->features |= ARM_SMMU_FEAT_BBML2;
+}
+
+u32 arm_smmu_device_idr5_probe(ARM_SMMU_OBJ *smmu)
+{
+	u32 reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+
+	if (reg & IDR5_DS)
+		smmu->features |= ARM_SMMU_FEAT_DS;
+
+	/* Page sizes */
+	if (reg & IDR5_GRAN64K)
+		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
+	if (reg & IDR5_GRAN16K)
+		smmu->pgsize_bitmap |= SZ_16K | SZ_32M;
+	if (reg & IDR5_GRAN4K)
+		smmu->pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
+
+	/* Input address size */
+	if (FIELD_GET(IDR5_VAX, reg) == IDR5_VAX_52_BIT)
+		smmu->features |= ARM_SMMU_FEAT_VAX;
+
+	/* Output address size */
+	switch (FIELD_GET(IDR5_OAS, reg)) {
+	case IDR5_OAS_32_BIT:
+		smmu->oas = 32;
+		break;
+	case IDR5_OAS_36_BIT:
+		smmu->oas = 36;
+		break;
+	case IDR5_OAS_40_BIT:
+		smmu->oas = 40;
+		break;
+	case IDR5_OAS_42_BIT:
+		smmu->oas = 42;
+		break;
+	case IDR5_OAS_44_BIT:
+		smmu->oas = 44;
+		break;
+	case IDR5_OAS_52_BIT:
+		smmu->oas = 52;
+		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
+		break;
+	default:
+		arm_smmu_info(smmu,
+			      "unknown output address size. Truncating to 48-bit\n");
+		fallthrough;
+	case IDR5_OAS_48_BIT:
+		smmu->oas = 48;
+	}
+
+	return reg;
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
new file mode 100644
index 000000000000..926a84b11a82
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common-lib.h
@@ -0,0 +1,39 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef __ARM_SMMU_V3_COMMON_LIB_H
+#define __ARM_SMMU_V3_COMMON_LIB_H
+
+#include <linux/build_bug.h>
+#include <linux/compiler_types.h>
+#include <linux/kernel.h>
+
+/*
+ * The IDR probe functions are shared by the kernel and the hypervisor drivers,
+ * which define ARM_SMMU_OBJ, arm_smmu_err() and arm_smmu_info() differently.
+ * Ensure the fields used by them are defined and have the correct types.
+ */
+#ifndef __KVM_NVHE_HYPERVISOR__
+#include <linux/device.h>
+
+#include "arm-smmu-v3.h"
+
+typedef struct arm_smmu_device ARM_SMMU_OBJ;
+
+#define arm_smmu_err(smmu, fmt, ...)	dev_err((smmu)->dev, fmt, ##__VA_ARGS__)
+#define arm_smmu_info(smmu, fmt, ...)	dev_info((smmu)->dev, fmt, ##__VA_ARGS__)
+#endif
+
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, features), u32));
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, options), u32));
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, oas), unsigned long));
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, pgsize_bitmap), unsigned long));
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, base), void __iomem *));
+static_assert(__same_type(typeof_member(ARM_SMMU_OBJ, sid_bits), unsigned int));
+
+void arm_smmu_device_iidr_probe(ARM_SMMU_OBJ *smmu);
+int arm_smmu_device_idr0_probe(ARM_SMMU_OBJ *smmu, bool disable_msipolling,
+			       u32 *idr0);
+int arm_smmu_device_idr1_probe(ARM_SMMU_OBJ *smmu, u32 *idr1);
+void arm_smmu_device_idr3_probe(ARM_SMMU_OBJ *smmu);
+u32 arm_smmu_device_idr5_probe(ARM_SMMU_OBJ *smmu);
+
+#endif /* __ARM_SMMU_V3_COMMON_LIB_H */
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 101ece0e38d3..8cbf1e7354e2 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -33,6 +33,7 @@
 #include <uapi/linux/iommufd.h>
 
 #include "arm-smmu-v3.h"
+#include "arm-smmu-v3-common-lib.h"
 #include "../../dma-iommu.h"
 
 static bool disable_msipolling;
@@ -5168,63 +5169,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	return 0;
 }
 
-#define IIDR_IMPLEMENTER_ARM		0x43b
-#define IIDR_PRODUCTID_ARM_MMU_600	0x483
-#define IIDR_PRODUCTID_ARM_MMU_700	0x487
-#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
-#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
-
-static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
-{
-	u32 reg;
-	unsigned int implementer, productid, variant, revision;
-
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
-	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
-	productid = FIELD_GET(IIDR_PRODUCTID, reg);
-	variant = FIELD_GET(IIDR_VARIANT, reg);
-	revision = FIELD_GET(IIDR_REVISION, reg);
-
-	switch (implementer) {
-	case IIDR_IMPLEMENTER_ARM:
-		switch (productid) {
-		case IIDR_PRODUCTID_ARM_MMU_600:
-			/* Arm erratum 1076982 */
-			if (variant == 0 && revision <= 2)
-				smmu->features &= ~ARM_SMMU_FEAT_SEV;
-			/* Arm erratum 1209401 */
-			if (variant < 2)
-				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
-			break;
-		case IIDR_PRODUCTID_ARM_MMU_700:
-			/* Many errata... */
-			smmu->features &= ~ARM_SMMU_FEAT_BTM;
-			if (variant < 1 || revision < 1) {
-				/* Arm erratum 2812531 */
-				smmu->options |= ARM_SMMU_OPT_CMDQ_FORCE_SYNC;
-				/* Arm errata 2268618, 2812531 */
-				smmu->features &= ~ARM_SMMU_FEAT_NESTING;
-			}
-			/* Arm errata 3777127 */
-			smmu->options |= ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
-			break;
-		case IIDR_PRODUCTID_ARM_MMU_L1:
-			/* Arm errata 3878312 */
-			smmu->features &= ~ARM_SMMU_FEAT_BTM;
-			break;
-		case IIDR_PRODUCTID_ARM_MMU_S3:
-			/* Arm errata 3995052 */
-			smmu->features &= ~ARM_SMMU_FEAT_BTM;
-			/* Arm errata 3673557 */
-			if (variant < 1 || (variant == 1 && revision < 1))
-				smmu->options |=
-					ARM_SMMU_OPT_FULL_CONT_RANGE_INV;
-			break;
-		}
-		break;
-	}
-}
-
 static void arm_smmu_get_httu(struct arm_smmu_device *smmu, u32 reg)
 {
 	u32 fw_features = smmu->features & (ARM_SMMU_FEAT_HA | ARM_SMMU_FEAT_HD |
@@ -5255,61 +5199,12 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
 	bool coherent = smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	int ret;
 
 	/* IDR0 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
-
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
-		dev_err(smmu->dev, "unknown/unsupported TT endianness!\n");
-		return -ENXIO;
-	}
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
+	ret = arm_smmu_device_idr0_probe(smmu, disable_msipolling, &reg);
+	if (ret)
+		return ret;
 
 	arm_smmu_get_httu(smmu, reg);
 
@@ -5321,44 +5216,14 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
-		dev_err(smmu->dev, "no translation support!\n");
-		return -ENXIO;
-	}
-
-	/* We only support the AArch64 table format at present */
-	if (!(FIELD_GET(IDR0_TTF, reg) & IDR0_TTF_AARCH64)) {
-		dev_err(smmu->dev, "AArch64 table format not supported!\n");
-		return -ENXIO;
-	}
-
 	/* ASID/VMID sizes */
 	smmu->asid_bits = reg & IDR0_ASID16 ? 16 : 8;
 	smmu->vmid_bits = reg & IDR0_VMID16 ? 16 : 8;
 
 	/* IDR1 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
-	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL)) {
-		dev_err(smmu->dev, "embedded implementation not supported\n");
-		return -ENXIO;
-	}
-
-	if (reg & IDR1_ATTR_TYPES_OVR)
-		smmu->features |= ARM_SMMU_FEAT_ATTR_TYPES_OVR;
+	ret = arm_smmu_device_idr1_probe(smmu, &reg);
+	if (ret)
+		return ret;
 
 	if ((smmu->options & ARM_SMMU_OPT_OVR_INSTCFG_DATA) &&
 	    !(reg & IDR1_ATTR_PERMS_OVR)) {
@@ -5385,87 +5250,24 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 	smmu->priq.q.llq.max_n_shift =
 		arm_smmu_priq_max_n_shift(FIELD_GET(IDR1_PRIQS, reg));
 
-	/* SID/SSID sizes */
+	/* SSID size */
 	smmu->ssid_bits = FIELD_GET(IDR1_SSIDSIZE, reg);
-	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
 	smmu->iommu.max_pasids = 1UL << smmu->ssid_bits;
 
-	/*
-	 * If the SMMU supports fewer bits than would fill a single L2 stream
-	 * table, use a linear table instead.
-	 */
-	if (smmu->sid_bits <= STRTAB_SPLIT)
-		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
-
 	/* IDR3 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
-	if (FIELD_GET(IDR3_RIL, reg))
-		smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
-	if (FIELD_GET(IDR3_FWB, reg))
-		smmu->features |= ARM_SMMU_FEAT_S2FWB;
-
-	if (FIELD_GET(IDR3_BBM, reg) == 2)
-		smmu->features |= ARM_SMMU_FEAT_BBML2;
+	arm_smmu_device_idr3_probe(smmu);
 
 	/* IDR5 */
-	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+	reg = arm_smmu_device_idr5_probe(smmu);
 
 	/* Maximum number of outstanding stalls */
 	smmu->evtq.max_stalls = FIELD_GET(IDR5_STALL_MAX, reg);
 
-	if (reg & IDR5_DS)
-		smmu->features |= ARM_SMMU_FEAT_DS;
-
-	/* Page sizes */
-	if (reg & IDR5_GRAN64K)
-		smmu->pgsize_bitmap |= SZ_64K | SZ_512M;
-	if (reg & IDR5_GRAN16K)
-		smmu->pgsize_bitmap |= SZ_16K | SZ_32M;
-	if (reg & IDR5_GRAN4K)
-		smmu->pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
-
-	/* Input address size */
-	if (FIELD_GET(IDR5_VAX, reg) == IDR5_VAX_52_BIT)
-		smmu->features |= ARM_SMMU_FEAT_VAX;
-
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
-		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
-		break;
-	default:
-		dev_info(smmu->dev,
-			"unknown output address size. Truncating to 48-bit\n");
-		fallthrough;
-	case IDR5_OAS_48_BIT:
-		smmu->oas = 48;
-	}
-
 	/* Set the DMA mask for our table walker */
 	if (dma_set_mask_and_coherent(smmu->dev, DMA_BIT_MASK(smmu->oas)))
 		dev_warn(smmu->dev,
 			 "failed to set DMA mask for table walker\n");
 
-	if ((smmu->features & ARM_SMMU_FEAT_TRANS_S1) &&
-	    (smmu->features & ARM_SMMU_FEAT_TRANS_S2))
-		smmu->features |= ARM_SMMU_FEAT_NESTING;
-
 	arm_smmu_device_iidr_probe(smmu);
 
 	if (arm_smmu_sva_supported(smmu))
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8c8957831286..bc4c25421835 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -87,6 +87,12 @@ struct arm_vsmmu;
 #define IIDR_REVISION			GENMASK(15, 12)
 #define IIDR_IMPLEMENTER		GENMASK(11, 0)
 
+#define IIDR_IMPLEMENTER_ARM		0x43b
+#define IIDR_PRODUCTID_ARM_MMU_600	0x483
+#define IIDR_PRODUCTID_ARM_MMU_700	0x487
+#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
+#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
+
 #define ARM_SMMU_AIDR			0x1C
 
 #define ARM_SMMU_CR0			0x20
-- 
2.56.0.176.g3575e65682-goog

