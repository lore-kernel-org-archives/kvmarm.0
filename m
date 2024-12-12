Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26D0223EA77
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026775; cv=none; b=O+W+RE7+/ucy/SXgP/i+RPdK8kJc6BrUdJEIeUWAuNFyPTUTzBFsaS/hvEISC7SjokhGSb7PLrgaqph8YxiZHbJ4fGUeaQHahFIfmFqdwLwEpQPIQMwKGV5rhVBVweRUEFiylnP+FBdc2zU7lqyL5F0tEha++TmiFJaR6svWFpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026775; c=relaxed/simple;
	bh=8EtCY8V7X3ycV5JM9rJ11+gKlTambbtPDkoVVyt+M/8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uv1sC5kHwX6GgOxlh3yMaUvVPaecOdMWY8bMMprE0EbgU/BGS3+kztR7aJPuUCjtE+yjtv3YiEfpG8QxIWbJHqNS1EB5BnjWbvyAGyxZAKk1/MlAM8WU0YAF96lB5kSnO89Dpei7hHmNGOqcLCCiLL+qGJUg/oZTupIK5UICn7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Jd5YpyhX; arc=none smtp.client-ip=209.85.221.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Jd5YpyhX"
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-385e00ebb16so382603f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026772; x=1734631572; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mH2sHDIHNxX5nvm0uCAa4ZRouYkSHZdk/Fqj9806/G4=;
        b=Jd5YpyhXPrQjIzDSGvMhMrJLn3r9rTumzSGlz8VFshp89qmMjpY+r7uqOVTmg9l8OD
         0Bx2pEVZUnwOXo7f9rp+jgVhO0jOM4nWytvivc5jGxVsAIuEpY6lhwu0tLwQfEZtiX16
         tyy9FoOTFgUdigbJC2CdpEr9tbDUtsUIHAPWoa4l6vfHnK51Xo+06OAvD09Gj1cZwCTt
         MPCI7JwiUx08QBSQHCjImmYh5nXPkAkHmOS8wxb57mEdk3KwhdYkNOJVbhf9WvJiV58q
         FMN1xk5XSD9H9bWs6SU4y8FN15/We4fMi7VWXWFdU9oo7F5BUnz994ATeESohJvucfeD
         UrHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026772; x=1734631572;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mH2sHDIHNxX5nvm0uCAa4ZRouYkSHZdk/Fqj9806/G4=;
        b=vsV12QHonKLqgBR4RbaxSvcBPCCvpwnae7jFDNxxnnfhDFoUjEqLUL+M/6n+gUU5dL
         86cd+O1cHxfEzs2SIXa2n70kzokRPQCjYJ6dZenquY8tPOGmKebQIWrDIFjrKShUtYnZ
         jx18EUbPTlO5KrII2fwCx24cHcjukqZja3/IwpXpzNS1ESp5OgEQVffLta4nSp0VjIx2
         BIYvXX5sSsqeUR9iL3LmvnoWkMEwRT8rqUojfs21gdZgA6znZZK+Loj99BWHFdFW7wRT
         kdWvEtR3xW2WscKNFVJGfqES1euiNGZMYoC9ZcacjsLk7GU/VjZuEIa6UeFuSyZwzzMo
         1KHA==
X-Forwarded-Encrypted: i=1; AJvYcCX+kyCWUaxnyqMUi2FjkR+A504ZiseXHnRlWuD068aC/grV0tTJBl7qeGYpzuuF0WFZApUP3L8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0n+2lEEamLMW+Q7dQA5vHfl6lNKbAQC9boTWPtW1/d9EDiCyd
	hEJAv7sjbuzmCQ4YelIBjRByChyZ82+QFEZhKdmHI9xCb3D2gxBwWBgbH8C9iFWY8cMrNSoMMmB
	hfHqabPlAhQ==
X-Google-Smtp-Source: AGHT+IHYgcere8DY5zEOS+VqEf+/VNdzFtnyb9Z2He5v/bXnj5TKjXPCmvJhIeCirHysNJOzaHefewW8JahNgA==
X-Received: from wmgg16.prod.google.com ([2002:a05:600d:10:b0:434:a7ee:3c40])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:584b:0:b0:385:df84:8496 with SMTP id ffacd0b85a97d-3864ce4b01fmr5749345f8f.3.1734026771740;
 Thu, 12 Dec 2024 10:06:11 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:06 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-43-smostafa@google.com>
Subject: [RFC PATCH v2 42/58] iommu/arm-smmu-v3-kvm: Add host driver for pKVM
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

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Under protected KVM (pKVM), the host does not have access to guest or
hypervisor memory. This means that devices owned by the host must be
isolated by the SMMU, and the hypervisor is in charge of the SMMU.

Introduce the host component that replaces the normal SMMUv3 driver when
pKVM is enabled, and sends configuration and requests to the actual
driver running in the hypervisor (EL2).

Rather than rely on regular driver probe, pKVM directly calls
kvm_arm_smmu_v3_init(), which synchronously finds all SMMUs and hands
them to the hypervisor. If the regular driver is enabled, it will not
find any free SMMU to drive once it gets probed.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  6 ++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 64 +++++++++++++++++++
 2 files changed, 70 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 515a84f14783..7a182adbebc1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -6,3 +6,9 @@ arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
 
 obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
+
+obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
+ccflags-$(CONFIG_ARM_SMMU_V3_PKVM) += -Iarch/arm64/kvm/
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
+arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..8cea33d15e08
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,64 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_mmu.h>
+
+#include <linux/of_platform.h>
+#include <linux/platform_device.h>
+
+#include <kvm/arm_smmu_v3.h>
+
+#include "arm-smmu-v3.h"
+
+extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
+
+static int kvm_arm_smmu_probe(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+static void kvm_arm_smmu_remove(struct platform_device *pdev)
+{
+}
+
+static const struct of_device_id arm_smmu_of_match[] = {
+	{ .compatible = "arm,smmu-v3", },
+	{ },
+};
+
+static struct platform_driver kvm_arm_smmu_driver = {
+	.driver = {
+		.name = "kvm-arm-smmu-v3",
+		.of_match_table = arm_smmu_of_match,
+	},
+	.remove = kvm_arm_smmu_remove,
+};
+
+static int kvm_arm_smmu_v3_init_drv(void)
+{
+	return platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
+}
+
+static void kvm_arm_smmu_v3_remove_drv(void)
+{
+	platform_driver_unregister(&kvm_arm_smmu_driver);
+}
+
+struct kvm_iommu_driver kvm_smmu_v3_ops = {
+	.init_driver = kvm_arm_smmu_v3_init_drv,
+	.remove_driver = kvm_arm_smmu_v3_remove_drv,
+};
+
+static int kvm_arm_smmu_v3_register(void)
+{
+	if (!is_protected_kvm_enabled())
+		return 0;
+
+	return kvm_iommu_register_driver(&kvm_smmu_v3_ops,
+					kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
+};
+
+core_initcall(kvm_arm_smmu_v3_register);
-- 
2.47.0.338.g60cca15819-goog

