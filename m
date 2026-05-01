Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AA539E18C
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634422; cv=none; b=HW+ZYhPA2+dJMTWNS7tP5B8IHVVug/IeUhOYrCqmnMWFfxi4AsYhbf98rr5a9BLtOLmPl9afX2y335T6qBasJ/7gmLTtCMGmC5g4CHBSxANgQktn7CNW510zUpoWu1z+t33+5B9mJyXMd9dRr8sMSXdl8O5ucqkx4H26Uc2hneE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634422; c=relaxed/simple;
	bh=dtlBVLOo14YOqCmNNvP1AMUdNnEW7NiQxpiFymghyvU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MlvpLvcrL696OElVMdGeHvcmW5ffLKsYNrXRfTBYOAUosbQNgSEkE9ull+bUeeovoLgfaJ0urEKSlNBIpib4V+K7iCbpKmP9U+rEpqvg5/h8bgJS/Q59GvQ2IqQujjkufOH0QAwNF9z7OPwmupWwoCAAbgDf+uDamEacGeUIt8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=YeOTp+0F; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="YeOTp+0F"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-44b2b38648eso186661f8f.3
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634417; x=1778239217; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UU83Oeb4MDmTny3jalsI86VqzD8OKMnbSWGrcxMKTpA=;
        b=YeOTp+0Fybj0NhVkAfcHohu4f5kOq+269lvpfzdbBH4LRUcLKv69IUDOd0BtZ6sh06
         /pcQh4c7NPgQjluqYnKeqQUCwvmF0+Aku7nF+KINNlNyNaRWmw1HSVxtfSz7rdhmelXk
         xUy31TkjZc6MMIMf/MBpDOT5FfZAvJJrC9wySqtHEncsAvBI2Elh7yWQdygKqWatMJy5
         mAQpQAvh6X0sD/0EfHE7hprHQ4c6gYGrOS+4c7LRdQG5jF/LGYFCkSQx5OxxOQmAmrTx
         ajzSitZ0RjTryioPBc4sXS0moZt/ci1uHfsRgj+ceulZO3ybyvhPLW4bNU2WGVULYbdO
         qxVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634417; x=1778239217;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UU83Oeb4MDmTny3jalsI86VqzD8OKMnbSWGrcxMKTpA=;
        b=ioFMJgNgXUHtlYP3WzDWdt47NUVxACGD8xegBk1S56uSxuB6YXHQ/mxtV1QwlU1K5P
         ULR9XRD1+RbiPKuldbrbhiOm9xhbbcDatla1/TT1SeAaTFs0Py98MKRsirntp0HWMkDg
         8HJfi3z49f+ftcNg28WMw01dLAm9mKTCs7elY5L3OXTPQwL7BcaYUYHIchyfUid8nWxr
         1KBFGIepirRQy/PZnOQ41AuOkY5f9MtI0Ew7HUpDExWBypjpha01t8kngr0D0EzPK3XH
         slpAksZx3Hc3DV6BBIclZu4EAmXJQ83RueQgu+BXV1GcunribNpc+YqErOHpNY9VZ70R
         1WOQ==
X-Forwarded-Encrypted: i=1; AFNElJ9u+UqsB6P/qSdaRedfdmOxOQ7khizK/zZHI6j6K2qmUGeMbpLvIkKohzQy4ZFk313dfXjVCAE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwYBVlv6SgPUBGsq/3O7pchfM8NjC1B0mkW1Rmis7oDfdgIdw1d
	YiKMx3XXzpG9pTHDnh2h3NUQV1wlSsO3i6/XcdQhCg+htk2lXqOnB+ujpgswDPwrtOEH6Z69pvb
	ZdkgGLIsdbvM/+g==
X-Received: from wrtx8.prod.google.com ([2002:a5d:60c8:0:b0:43d:7331:91da])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6995:b0:483:709e:f238 with SMTP id 5b1f17b1804b1-48a8ebab77emr40681985e9.29.1777634416769;
 Fri, 01 May 2026 04:20:16 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:15 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-14-smostafa@google.com>
Subject: [PATCH v6 13/25] iommu/arm-smmu-v3-kvm: Probe SMMU HW
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

Probe SMMU features from the IDR register space, most of
the logic is common with the kernel.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   |  6 --
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  6 ++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 78 +++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  |  6 ++
 4 files changed, 90 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 61e6ab364086..157acde0436d 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4738,12 +4738,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu)
 	return 0;
 }
 
-#define IIDR_IMPLEMENTER_ARM		0x43b
-#define IIDR_PRODUCTID_ARM_MMU_600	0x483
-#define IIDR_PRODUCTID_ARM_MMU_700	0x487
-#define IIDR_PRODUCTID_ARM_MMU_L1	0x48a
-#define IIDR_PRODUCTID_ARM_MMU_S3	0x498
-
 static void arm_smmu_device_iidr_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 64618299d03a..f904f4d19609 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -84,6 +84,12 @@ struct arm_vsmmu;
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
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
index 9afc314d0acc..d9945db9e102 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -10,6 +10,7 @@
 #include <nvhe/mem_protect.h>
 
 #include "arm_smmu_v3.h"
+#include "../arm-smmu-v3.h"
 
 size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
 struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
@@ -26,6 +27,77 @@ static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
 	smmu->base = NULL;
 }
 
+static bool smmu_nesting_supported(struct hyp_arm_smmu_v3_device *smmu)
+{
+	unsigned int implementer, productid, variant, revision;
+	u32 reg;
+
+	if (!(smmu->features & ARM_SMMU_FEAT_TRANS_S1) ||
+	    !(smmu->features & ARM_SMMU_FEAT_TRANS_S2))
+		return false;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IIDR);
+	implementer = FIELD_GET(IIDR_IMPLEMENTER, reg);
+	productid = FIELD_GET(IIDR_PRODUCTID, reg);
+	variant = FIELD_GET(IIDR_VARIANT, reg);
+	revision = FIELD_GET(IIDR_REVISION, reg);
+
+	if (implementer != IIDR_IMPLEMENTER_ARM)
+		return true;
+
+	if (productid == IIDR_PRODUCTID_ARM_MMU_600)
+		return variant >= 2;
+	else if (productid == IIDR_PRODUCTID_ARM_MMU_700)
+		return !(variant < 1 || revision < 1);
+
+	return true;
+}
+
+/*
+ * Mini-probe and validation for the hypervisor.
+ */
+static int smmu_probe(struct hyp_arm_smmu_v3_device *smmu)
+{
+	u32 reg;
+
+	/* Similar to the kernel, rely on firmware override. */
+	if (!(smmu->features & ARM_SMMU_FEAT_COHERENCY))
+		return -EINVAL;
+
+	/* IDR0 */
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR0);
+
+	smmu->features |= smmu_idr0_features(reg);
+	if (!smmu_nesting_supported(smmu))
+		return -ENXIO;
+
+	if (!(smmu->features & (ARM_SMMU_FEAT_TT_LE | ARM_SMMU_FEAT_TT_BE)))
+		return -ENXIO;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR1);
+	if (reg & (IDR1_TABLES_PRESET | IDR1_QUEUES_PRESET | IDR1_REL))
+		return -EINVAL;
+
+	smmu->sid_bits = FIELD_GET(IDR1_SIDSIZE, reg);
+	/* Follows the kernel logic */
+	if (smmu->sid_bits <= STRTAB_SPLIT)
+		smmu->features &= ~ARM_SMMU_FEAT_2_LVL_STRTAB;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
+	smmu->features |= smmu_idr3_features(reg);
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_IDR5);
+	smmu->pgsize_bitmap = smmu_idr5_to_pgsize(reg);
+
+	smmu->oas = smmu_idr5_to_oas(reg);
+	if (smmu->oas == 52)
+		smmu->pgsize_bitmap |= 1ULL << 42;
+	else if (!smmu->oas)
+		smmu->oas = 48;
+
+	return 0;
+}
+
 static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 {
 	unsigned long haddr;
@@ -39,8 +111,14 @@ static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
 		return ret;
 
 	smmu->base = (void __iomem *)haddr;
+	ret = smmu_probe(smmu);
+	if (ret)
+		goto out_ret;
 
 	return 0;
+out_ret:
+	smmu_deinit_device(smmu);
+	return ret;
 }
 
 /* Called while is the host is still trusted. */
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
index 744ee2b7f0b4..82b84673e85b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -12,12 +12,18 @@
  *
  * Other members are filled and used at runtime by the SMMU driver.
  * @base		Virtual address of SMMU registers
+ * @oas			PA size
+ * @pgsize_bitmap	Supported page sizes
+ * @sid_bits		Max number of SID bits supported
  */
 struct hyp_arm_smmu_v3_device {
 	phys_addr_t		mmio_addr;
 	size_t			mmio_size;
 	void __iomem		*base;
 	u32			features;
+	unsigned long		oas;
+	unsigned long		pgsize_bitmap;
+	unsigned int		sid_bits;
 };
 
 extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
-- 
2.54.0.545.g6539524ca2-goog

