Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83DBF287256
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725239; cv=none; b=kO1hvXRSd/Ycv3uE6+QMC0OdXwIu7/GrfUJ+ZzCY+X5Ti/G2R+M4pD/xZc4psNa2mZKpmqE9mo+0GP1eNCEfzpbuA77Zhro+ydscUVCMqYfBBauJVnLXsHzW5bLz4GnapXVCHsf+xGvTzda+CLFiPPDsyt0OqRC9a761fg0IoEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725239; c=relaxed/simple;
	bh=iUs5IYsMWkLk6VlZyy4ix/qQHrmwQZUCPsP3fDnxiUg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=hHR3wT1yVHuOAU/JSE/KriDNv1/PVMKcAQxeSPXTqIx3WSqTW6DdoIhXPhmZCW/SXbEvXjLvXs07On2xaMk5MCgiUK4euCxHrdEP9G3vqg9TEISInhtn3QjwEgeaA5lUvL0iIeTAd286YS8fq4UZjl59idsNJrGZgBBnAibm938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KNZs7Qku; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KNZs7Qku"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3b7865dc367so986745f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725235; x=1754330035; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xnVOsxgU67R0nV/fO8T4bnA6x+CirofbbwX52wOtcVg=;
        b=KNZs7QkuDs3iWp+ub6eRSvD4TyW/9wOtT9RtLTwZRS8GWu+3V1J/wMNqUHno3v2fl4
         wTbLd6tdUWqm9rRfMuKhnoosU9/cehQlETKBgfRGbiwA5xRTe39/W/3TgvYoTllI79qp
         XuX+km71wmUul4RPqlyL5IhNzI1XdbphSNnMkvFF1Tga4EKurRyTSnk88L7V30aQz1ff
         JywRhUPGNdLqJiyRjljjQbM+ahUm1rHdyZC1Yh98r6OSQJxyWw2Q1p9JqxJtBsyXVoDN
         kJatycMKuHzr02kOk4cA9Q3mAJzQTpR4h70n3IJOlCy25Z5mosskmt0uHUuYxIqPGTf7
         4xpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725235; x=1754330035;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnVOsxgU67R0nV/fO8T4bnA6x+CirofbbwX52wOtcVg=;
        b=sbcYuum81kueyHzX0huIR0CjNS9uXPfAIVoPH2kAxuFq3kJGmUauJoknSHvRlrXFCy
         V/jIfoH8rJ3lUcRu3NpR6QWzxjjQWl2SaOvnrCShQQImJiIFek0156PSJq29Y6og1dTg
         q41jHS1ZYY4ObAMsSGl8I8GYxYHQJcvzGwTses+Oss0AGlOQG+mDDv62YNP9KTt8DmvR
         Jtq+ZNFJw0Bb+Or7lT+RAwyC2iDK5wIWWGmqmj4xhE/+Au87xwItA5V1eJG52nIiHrFy
         OxBXvLpwErFtUs8K6t2baifmRXzjv12L0VdoiJhWgsl6k+JWQ+Nl69hA/I+23mELoZn3
         T6vg==
X-Forwarded-Encrypted: i=1; AJvYcCVVaotvqy40SYbKFonYslBj61Gk4xrTibe8GgoWNB4np6FIqhnAudnaoxkjs+Tdyz/XlbCU/Ew=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0ktsrXGwYfTDMdV5GbAysVF7nErwIgTCEUOVA+QOG0rg/FmvK
	ZJzsM3xGRA1V6mz4eUMw9XnBMWR5q6C2/fVkMRnAKWmN8zsRk+7xGhJ/cAFWVeF7AmYwoneBb1w
	e8g1jhcBv7oJVEg==
X-Google-Smtp-Source: AGHT+IGnl/hQ8HSC/Tho/ut7229jQGE40+OgRIcPIDPwy4KsZJSVzNmlFutAK2C03YtagjdgRV48tnX6dLo2CA==
X-Received: from wmpz20.prod.google.com ([2002:a05:600c:a14:b0:442:dc75:51ef])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d89:0:b0:3a0:9dfc:da4 with SMTP id ffacd0b85a97d-3b776787c79mr7873948f8f.42.1753725234757;
 Mon, 28 Jul 2025 10:53:54 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:13 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-27-smostafa@google.com>
Subject: [PATCH v3 26/29] iommu/arm-smmu-v3-kvm: Add host driver for pKVM
From: Mostafa Saleh <smostafa@google.com>
To: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, robin.murphy@arm.com, jean-philippe@linaro.org, 
	qperret@google.com, tabba@google.com, jgg@ziepe.ca, mark.rutland@arm.com, 
	praan@google.com, Mostafa Saleh <smostafa@google.com>
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
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  5 ++
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 62 +++++++++++++++++++
 2 files changed, 67 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index 16be1249000a..6829860f2ce3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -7,3 +7,8 @@ arm_smmu_v3-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-$(CONFIG_TEGRA241_CMDQV) += tegra241-cmdqv.o
 
 obj-$(CONFIG_ARM_SMMU_V3_KUNIT_TEST) += arm-smmu-v3-test.o
+
+obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
+arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..73c0150bdc81
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_mmu.h>
+
+#include <linux/of_platform.h>
+
+#include "arm-smmu-v3.h"
+#include "pkvm/arm_smmu_v3.h"
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
2.50.1.552.g942d659e1b-goog

