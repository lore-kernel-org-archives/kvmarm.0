Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C1847E
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:46 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id q5so17272381wrv.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hw6sl7oFDdNkKrpSvS4DEk1bWbFMgLKs0ATS0rkQZn8=;
        b=CbNaDaiXaXT6GtrdMMULs+E/jbHUR9HhPSILUa/OiUR34pmTwRsBPOIgtXkdjKO84s
         +tBqu2DpS6al0V7yB61IKnv+b10H2hGIu4mSo23kyjfta6kIjuixhQP0x0rEXX/18oY/
         5a/qIg/aGsRb8qL3tZ5QXMBb/MUc2X2+EhILxj2/ZHfc71FDOYtuWVdYCb75H7I2xGt3
         dVv+kvRgOm9tSJFfaFFV6aj2whuG6A6473t88RFMCqgBbAoY2Ueaw7+cCeyrj/MBwuAd
         9KMQAhZOpmADWbMrzT36SQbCGLLON1lZWw1KneZXadbfVjbmMX8sVoqte7988sXYtrPm
         mEqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hw6sl7oFDdNkKrpSvS4DEk1bWbFMgLKs0ATS0rkQZn8=;
        b=uX7rDYKL9TZbnoHqMnljcEZppocXZMf9OqTkD06YmcwN+DfuS5Jn0VMNHg0/CZoVtd
         4UxhK8vLRnpi/RliHFk4EzyruFncvkyNM8jit8omAYux2wWKfwrP+HAz06g/BRet9pbK
         yFNGw/AkcaN3OSEmCYW2odhT8E75I5KKoQXjQdBqom94xTbRfRF4BhVtmfrNuSLXZSys
         dclS5SPXW3cKNpLJ68gt6vFG6zswOo1JNJpBBSWSNNRFcKFEiQcS5+E5Jzc03THKZ+W9
         fnmEiKDOn6Dwaqd0ZDBGuA0xPcIADtvNa0fmvoRuO1rxsf17QYbfgQWHOcOBE5H4LLQK
         tu6A==
X-Gm-Message-State: AO0yUKVBBdY1DhOBwVSfCKSM/ZYvyUGdC/0B3UCQVoq2Z9F3kz1Mt7jk
	71wVg6lRlfCkHaCocX4+qD4OUA==
X-Google-Smtp-Source: AK7set+Pwyjpj/A8PSxsfEiu2UEOKeiweKmB/2zupayUhYBIdKRAMAWRGCPU2Xjlg1Qgye4T4MctNQ==
X-Received: by 2002:a5d:6110:0:b0:2bf:b9a4:f688 with SMTP id v16-20020a5d6110000000b002bfb9a4f688mr2377259wrt.23.1675256386278;
        Wed, 01 Feb 2023 04:59:46 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:45 -0800 (PST)
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: maz@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	joro@8bytes.org
Cc: robin.murphy@arm.com,
	james.morse@arm.com,
	suzuki.poulose@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	smostafa@google.com,
	dbrazdil@google.com,
	ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	iommu@lists.linux.dev,
	Jean-Philippe Brucker <jean-philippe@linaro.org>
Subject: [RFC PATCH 34/45] iommu/arm-smmu-v3: Add host driver for pKVM
Date: Wed,  1 Feb 2023 12:53:18 +0000
Message-Id: <20230201125328.2186498-35-jean-philippe@linaro.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230201125328.2186498-1-jean-philippe@linaro.org>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 drivers/iommu/arm/arm-smmu-v3/Makefile        |  5 ++
 include/kvm/arm_smmu_v3.h                     | 14 +++++
 arch/arm64/kvm/arm.c                          | 18 +++++-
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 58 +++++++++++++++++++
 4 files changed, 94 insertions(+), 1 deletion(-)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c

diff --git a/drivers/iommu/arm/arm-smmu-v3/Makefile b/drivers/iommu/arm/arm-smmu-v3/Makefile
index c4fcc796213c..a90b97d8bae3 100644
--- a/drivers/iommu/arm/arm-smmu-v3/Makefile
+++ b/drivers/iommu/arm/arm-smmu-v3/Makefile
@@ -4,3 +4,8 @@ arm_smmu_v3-objs-y += arm-smmu-v3.o
 arm_smmu_v3-objs-y += arm-smmu-v3-common.o
 arm_smmu_v3-objs-$(CONFIG_ARM_SMMU_V3_SVA) += arm-smmu-v3-sva.o
 arm_smmu_v3-objs := $(arm_smmu_v3-objs-y)
+
+obj-$(CONFIG_ARM_SMMU_V3_PKVM) += arm_smmu_v3_kvm.o
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-kvm.o
+arm_smmu_v3_kvm-objs-y += arm-smmu-v3-common.o
+arm_smmu_v3_kvm-objs := $(arm_smmu_v3_kvm-objs-y)
diff --git a/include/kvm/arm_smmu_v3.h b/include/kvm/arm_smmu_v3.h
index ed139b0e9612..373b915b6661 100644
--- a/include/kvm/arm_smmu_v3.h
+++ b/include/kvm/arm_smmu_v3.h
@@ -40,4 +40,18 @@ extern struct hyp_arm_smmu_v3_device *kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_smmus);
 
 #endif /* CONFIG_ARM_SMMU_V3_PKVM */
 
+#ifndef __KVM_NVHE_HYPERVISOR__
+# if IS_ENABLED(CONFIG_ARM_SMMU_V3_PKVM)
+int kvm_arm_smmu_v3_init(unsigned int *count);
+void kvm_arm_smmu_v3_remove(void);
+
+# else /* CONFIG_ARM_SMMU_V3_PKVM */
+static inline int kvm_arm_smmu_v3_init(unsigned int *count)
+{
+	return -ENODEV;
+}
+static void kvm_arm_smmu_v3_remove(void) {}
+# endif /* CONFIG_ARM_SMMU_V3_PKVM */
+#endif /* __KVM_NVHE_HYPERVISOR__ */
+
 #endif /* __KVM_ARM_SMMU_V3_H */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 31faae76d519..a4cd09fc4abf 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -44,6 +44,7 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_pmu.h>
 #include <kvm/arm_psci.h>
+#include <kvm/arm_smmu_v3.h>
 
 static enum kvm_mode kvm_mode = KVM_MODE_DEFAULT;
 DEFINE_STATIC_KEY_FALSE(kvm_protected_mode_initialized);
@@ -1901,11 +1902,26 @@ static bool init_psci_relay(void)
 
 static int init_stage2_iommu(void)
 {
-	return KVM_IOMMU_DRIVER_NONE;
+	int ret;
+	unsigned int smmu_count;
+
+	ret = kvm_arm_smmu_v3_init(&smmu_count);
+	if (ret)
+		return ret;
+	else if (!smmu_count)
+		return KVM_IOMMU_DRIVER_NONE;
+	return KVM_IOMMU_DRIVER_SMMUV3;
 }
 
 static void remove_stage2_iommu(enum kvm_iommu_driver iommu)
 {
+	switch (iommu) {
+	case KVM_IOMMU_DRIVER_SMMUV3:
+		kvm_arm_smmu_v3_remove();
+		break;
+	default:
+		break;
+	}
 }
 
 static int init_subsystems(void)
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
new file mode 100644
index 000000000000..4092da8050ef
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -0,0 +1,58 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM host driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <linux/of_platform.h>
+
+#include <kvm/arm_smmu_v3.h>
+
+#include "arm-smmu-v3.h"
+
+static int kvm_arm_smmu_probe(struct platform_device *pdev)
+{
+	return -ENOSYS;
+}
+
+static int kvm_arm_smmu_remove(struct platform_device *pdev)
+{
+	return 0;
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
+/**
+ * kvm_arm_smmu_v3_init() - Reserve the SMMUv3 for KVM
+ * @count: on success, number of SMMUs successfully initialized
+ *
+ * Return 0 if all present SMMUv3 were probed successfully, or an error.
+ *   If no SMMU was found, return 0, with a count of 0.
+ */
+int kvm_arm_smmu_v3_init(unsigned int *count)
+{
+	int ret;
+
+	ret = platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
+	if (ret)
+		return ret;
+
+	*count = 0;
+	return 0;
+}
+
+void kvm_arm_smmu_v3_remove(void)
+{
+	platform_driver_unregister(&kvm_arm_smmu_driver);
+}
-- 
2.39.0

