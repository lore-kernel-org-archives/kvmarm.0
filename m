Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419C335BCC
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405323; cv=none; b=OPvExtwS5+5X17+Nl8vR6YFoJz0tiOMTyNLOppcUDFZl+ioK7ETYOTVETJRhNzdjSBs5bRWfTRabCJZhcYOzXKTvjGKVbXv2uumB6L/l+vlO28AoGJuUjbeLYQ+8gLMKCIHhii6RtW2JDe1zw9YaqiC26hOvmWpanG+lqFzpmI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405323; c=relaxed/simple;
	bh=INcTJzS700s05ZGwDrQtXEsdidTABqC6bRW5Y2ydOoI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sdLF40tqBEtF5TZsIv+p7jQ0e49faAI1kXdaT76Tzv2BmEBewgg1ZuHjqsc8LaSXkSXplcpF7fNXkVEKzr2URpmXlx0U65J0zfmNmJ67EerJY64kxU5/8MkVRaztPYRmioaKru4WXwF5ayJEvDWN+IhoSQhUiDSAJSjkM2XPKeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bQS3szry; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bQS3szry"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-b735efd650fso515445366b.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405319; x=1764010119; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6trFz58Gu4UJEu1ThwWz2XtrxsLtl476+uXL3Pe7jcQ=;
        b=bQS3szryJjnDjLnE+uKWlItSvV3U3MHLtx7F89xQ+p3h6wm3NhQiVtAf0kwkiTnxRd
         C7ZuuZhxLZ/ZGO9CH5XH56h6L6cmm6XYPPW8q0q66s9ny37QcNVyMcoN/rKPBI6bwIO4
         Td7+pYpTy3dNyntSXKnoziyQ3sP3HJke6TeBN0KQIf8bIYtTgc8VkZD0TzFY2rLwB23r
         /Xk2VcS8xgtMzAeY32qp2Hg4XSaHd9B6XkiOm5u6ggyIATywy/cps4T6bAl55bz62SZb
         K6+6KIvC7gNhUj5CdXg7RrJ/GzPjmu/jIdOl9/T5lPFa4OZMhDQeAOLEJjW3Zq3rZycF
         f+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405319; x=1764010119;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6trFz58Gu4UJEu1ThwWz2XtrxsLtl476+uXL3Pe7jcQ=;
        b=o3NKSgCLsInCgPLHta2/kQGeXVrqNK/Cw1RjYCrC32Y/Y+oDadkBYsRnSIAjF32+JE
         qzqDr2tirkkh//6IVwIwySvU/iboK2QVAbP0zATm5xXxcZfiMi0eGMeHpEfOMwWQ9+K0
         XDZPMFDcx8213Aso4bs8orpve0ppSp9RKvdQ5WBWXPyxsAft7IMMxnCWxorC2iB6ltiw
         rJNqf2W2ODucYDk9IoOiaNvOGbZp+L3CWOSGh6g50bPq+cmbYMOrWQjB9Ka20t1Qyfez
         3Fwx8e6GD1T89/bu5cQHiVbXv1YghfWzWwiMr/pwB2Lj2UMjAwkKqwJxmr7jRFw91a8e
         m6VA==
X-Forwarded-Encrypted: i=1; AJvYcCWf64R5u9I3zkBVN3Vj9OYcmkXmi+eS6dnos5GxU8bGzulsd/saobD7dd1EX8c6JhiF5LhTK0o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5i4zT+D8gOgBC3t6XoypwMj2ElTLOi/3AwtXMlWK4qDlRD/JD
	L2sLXgpM2MVGSWmT0/zywU2nuX/zQSGhfDpvA+VD0Mn9595c/IznhM5lBoM+ZPsfYk1RNuQRhQo
	jk75PXizeoiMEUw==
X-Google-Smtp-Source: AGHT+IE3+viO3srJHAcHB3c5RRKlLg8klxOmp1l9jNQ0CtxcTZZi09dcfnPoyGFkFEx9s/uAX82FyaMdOVjXZg==
X-Received: from ejsr3.prod.google.com ([2002:a17:906:7fc3:b0:b6d:5546:e475])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:3c90:b0:b70:b077:b94b with SMTP id a640c23a62f3a-b7367b99c79mr1398956966b.43.1763405318837;
 Mon, 17 Nov 2025 10:48:38 -0800 (PST)
Date: Mon, 17 Nov 2025 18:48:00 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-14-smostafa@google.com>
Subject: [PATCH v5 13/27] iommu/arm-smmu-v3-kvm: Add the kernel driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

A platform driver is created to probe the SMMUs, which then creates
aux devices for the emulated SMMUs.

Then the driver registers with KVM.

Next, the SMMUv3 driver will probed the aux devices.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  1 +
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 91 +++++++++++++++++++
 2 files changed, 92 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index c9ce392e6d31..c3fc5c4a4a1e 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -4,5 +4,6 @@ arm_smmu_v3-y := arm-smmu-v3.o arm-smmu-v3-common-lib.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_IOMMUFD) += arm-smmu-v3-iommufd.o
 arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
+arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_PKVM) += arm-smmu-v3-kvm.o
 
 obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..ca12560639c5
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,91 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_mmu.h>
+#include <asm/kvm_pkvm.h>
+
+#include <linux/auxiliary_bus.h>
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include "arm-smmu-v3.h"
+#include "pkvm/arm_smmu_v3.h"
+
+extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
+
+static size_t smmu_hyp_pgt_pages(void)
+{
+	/*
+	 * SMMUv3 uses the same format as stage-2 and hence have the same memory
+	 * requirements, we add extra 500 pages for L2 ste.
+	 */
+	if (of_find_compatible_node(NULL, NULL, "arm,smmu-v3"))
+		return host_s2_pgtable_pages() + 500;
+	return 0;
+}
+
+static struct platform_driver smmuv3_nesting_driver;
+static int smmuv3_nesting_probe(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int kvm_arm_smmu_v3_register(void)
+{
+	size_t nr_pages = smmu_hyp_pgt_pages();
+	int ret;
+
+	if (!is_protected_kvm_enabled() || !nr_pages)
+		return 0;
+
+	ret = platform_driver_probe(&smmuv3_nesting_driver, smmuv3_nesting_probe);
+	if (ret)
+		return ret;
+
+	return kvm_iommu_register_driver(kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))),
+					 nr_pages);
+};
+
+static int smmu_create_aux_device(struct device *dev, void *data)
+{
+	static int dev_id;
+	struct auxiliary_device *auxdev;
+
+	auxdev = __devm_auxiliary_device_create(dev, "protected_kvm",
+						"smmu_v3_emu", NULL, dev_id++);
+	if (!auxdev)
+		return -ENODEV;
+
+	auxdev->dev.parent = dev;
+
+	return 0;
+}
+
+static struct platform_driver smmuv3_nesting_driver;
+static int kvm_arm_smmu_v3_post_init(void)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	WARN_ON(driver_for_each_device(&smmuv3_nesting_driver.driver, NULL,
+				       NULL, smmu_create_aux_device));
+
+	return 0;
+}
+
+static const struct of_device_id smmuv3_nested_of_match[] = {
+	{ .compatible = "arm,smmu-v3", },
+	{ },
+};
+
+static struct platform_driver smmuv3_nesting_driver = {
+	.driver = {
+		.name = "smmuv3-nesting",
+		.of_match_table = smmuv3_nested_of_match,
+	},
+};
+late_initcall(kvm_arm_smmu_v3_post_init);
+subsys_initcall(kvm_arm_smmu_v3_register);
-- 
2.52.0.rc1.455.g30608eb744-goog

