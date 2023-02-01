Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA80846E
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:44 +0000 (UTC)
Received: by mail-wr1-f54.google.com with SMTP id q5so17272263wrv.0
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k6RVVU/cDR30+b5v6ryQ9Qt2Qe/cZnMA4vlAa66b2Ys=;
        b=mu2lBA0BxxQukvTi9iYO7jhBZ8zYvtylLgUP8D/nnzbjtu9Fu04DCXo+9J1OplFloM
         2mj2s/TUMEjjGh7q8zbfwjap7eipolwiOV2dAJNt542PBtjSN3gAJiCFlbpAKAN8x236
         0URl9fMplXSkkpdd7gl6Id5htSLQPE1CjcYNrCeA6Fka/TxJwWHtJbfqwNRLX/svQ2S+
         B7OKZ2fBCpZKe2E0IftP4GTip2tljs8v5kjvZ8IbyV/HNVDtWAt58/uEsW1xrYXxPore
         SCYiHi/EwNvHSShyXk2rFhXByNJD7hnOTg0itBO2+7QQuUJF8kqLN/fplMCLxCQWJjPB
         r54g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k6RVVU/cDR30+b5v6ryQ9Qt2Qe/cZnMA4vlAa66b2Ys=;
        b=57gY0EEg5K/J7ksqEjnNr+xB5RPzQJmbTfY4rLGtbOKWsfbMiE9BBpi2YnGB/Zm64k
         eCdaGQcmpJWHc25m1Zmp886S4/shOwJuuPDWYhom1DxPIPTT3fQ48Fas1dHX74aAByq2
         hBmEsdatfj1yTZl0DI+LLDA71Nl9zI9vBJAtP047jXIoNcyIcOlJx23lqAAR/dwWtIyF
         iB+mIu4pjnEt8uCcNPy67aOaeOpR39v7Mswf529W6Q54pjLkcADnmLFE/x0VnSexjPPJ
         9v25WZE1xee0iBoerAH7eeet6ahiQJ2rsP5zy8+7ApmPcUvSCkIkA3aaifG/0d286yO6
         btCQ==
X-Gm-Message-State: AO0yUKUnrnl5oyoqBGuaHREzx9wSF1Ka57vXkqgLlMljG8QXsa4aQu5J
	Z0uwHAGH+DUowiFzpY5/kcxH1g==
X-Google-Smtp-Source: AK7set9KZvY706CH4tuKx5S8bX1dcbZP46wQLmL4WsIGvMixGthlW8NKXtzmya0mXpXaEnKYzEH3wA==
X-Received: by 2002:a5d:5e81:0:b0:2be:c41:4758 with SMTP id ck1-20020a5d5e81000000b002be0c414758mr2211733wrb.38.1675256383907;
        Wed, 01 Feb 2023 04:59:43 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:43 -0800 (PST)
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
Subject: [RFC PATCH 31/45] iommu/arm-smmu-v3: Move firmware probe to arm-smmu-v3-common
Date: Wed,  1 Feb 2023 12:53:15 +0000
Message-Id: <20230201125328.2186498-32-jean-philippe@linaro.org>
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

Move the FW probe functions to the common source, and take the
opportunity to clean up the 'bypass' behaviour a bit (see dc87a98db751
("iommu/arm-smmu: Fall back to global bypass"))

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |   4 +
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 107 ++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 106 +----------------
 3 files changed, 114 insertions(+), 103 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 8ab84282f62a..345aac378712 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -276,6 +276,10 @@ int arm_smmu_device_disable(struct arm_smmu_device *smmu);
 bool arm_smmu_capable(struct device *dev, enum iommu_cap cap);
 struct iommu_group *arm_smmu_device_group(struct device *dev);
 int arm_smmu_of_xlate(struct device *dev, struct of_phandle_args *args);
+
+struct platform_device;
+int arm_smmu_fw_probe(struct platform_device *pdev,
+		      struct arm_smmu_device *smmu, bool *bypass);
 int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu);
 int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
 			    struct arm_smmu_queue *q,
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index 9226971b6e53..4e945df5d64f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -1,10 +1,117 @@
 // SPDX-License-Identifier: GPL-2.0
+#include <linux/acpi.h>
 #include <linux/dma-mapping.h>
 #include <linux/iopoll.h>
+#include <linux/of.h>
+#include <linux/of_address.h>
+#include <linux/of_platform.h>
 #include <linux/pci.h>
 
 #include "arm-smmu-v3.h"
 
+struct arm_smmu_option_prop {
+	u32 opt;
+	const char *prop;
+};
+
+static struct arm_smmu_option_prop arm_smmu_options[] = {
+	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
+	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
+	{ 0, NULL},
+};
+
+static void parse_driver_options(struct arm_smmu_device *smmu)
+{
+	int i = 0;
+
+	do {
+		if (of_property_read_bool(smmu->dev->of_node,
+						arm_smmu_options[i].prop)) {
+			smmu->options |= arm_smmu_options[i].opt;
+			dev_notice(smmu->dev, "option %s\n",
+				arm_smmu_options[i].prop);
+		}
+	} while (arm_smmu_options[++i].opt);
+}
+
+static int arm_smmu_device_dt_probe(struct platform_device *pdev,
+				    struct arm_smmu_device *smmu,
+				    bool *bypass)
+{
+	struct device *dev = &pdev->dev;
+	u32 cells;
+
+	*bypass = true;
+	if (of_property_read_u32(dev->of_node, "#iommu-cells", &cells))
+		dev_err(dev, "missing #iommu-cells property\n");
+	else if (cells != 1)
+		dev_err(dev, "invalid #iommu-cells value (%d)\n", cells);
+	else
+		*bypass = false;
+
+	parse_driver_options(smmu);
+
+	if (of_dma_is_coherent(dev->of_node))
+		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
+
+	return 0;
+}
+
+#ifdef CONFIG_ACPI
+static void acpi_smmu_get_options(u32 model, struct arm_smmu_device *smmu)
+{
+	switch (model) {
+	case ACPI_IORT_SMMU_V3_CAVIUM_CN99XX:
+		smmu->options |= ARM_SMMU_OPT_PAGE0_REGS_ONLY;
+		break;
+	case ACPI_IORT_SMMU_V3_HISILICON_HI161X:
+		smmu->options |= ARM_SMMU_OPT_SKIP_PREFETCH;
+		break;
+	}
+
+	dev_notice(smmu->dev, "option mask 0x%x\n", smmu->options);
+}
+
+static int arm_smmu_device_acpi_probe(struct platform_device *pdev,
+				      struct arm_smmu_device *smmu,
+				      bool *bypass)
+{
+	struct acpi_iort_smmu_v3 *iort_smmu;
+	struct device *dev = smmu->dev;
+	struct acpi_iort_node *node;
+
+	node = *(struct acpi_iort_node **)dev_get_platdata(dev);
+
+	/* Retrieve SMMUv3 specific data */
+	iort_smmu = (struct acpi_iort_smmu_v3 *)node->node_data;
+
+	acpi_smmu_get_options(iort_smmu->model, smmu);
+
+	if (iort_smmu->flags & ACPI_IORT_SMMU_V3_COHACC_OVERRIDE)
+		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
+
+	*bypass = false;
+	return 0;
+}
+
+#else
+static inline int arm_smmu_device_acpi_probe(struct platform_device *pdev,
+					     struct arm_smmu_device *smmu,
+					     bool *bypass)
+{
+	return -ENODEV;
+}
+#endif
+
+int arm_smmu_fw_probe(struct platform_device *pdev,
+		      struct arm_smmu_device *smmu, bool *bypass)
+{
+	if (smmu->dev->of_node)
+		return arm_smmu_device_dt_probe(pdev, smmu, bypass);
+	else
+		return arm_smmu_device_acpi_probe(pdev, smmu, bypass);
+}
+
 int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 2baaf064a324..7cb171304953 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -9,7 +9,6 @@
  * This driver is powered by bad coffee and bombay mix.
  */
 
-#include <linux/acpi.h>
 #include <linux/acpi_iort.h>
 #include <linux/bitops.h>
 #include <linux/crash_dump.h>
@@ -19,9 +18,6 @@
 #include <linux/io-pgtable.h>
 #include <linux/module.h>
 #include <linux/msi.h>
-#include <linux/of.h>
-#include <linux/of_address.h>
-#include <linux/of_platform.h>
 #include <linux/pci-ats.h>
 #include <linux/platform_device.h>
 
@@ -64,11 +60,6 @@ static phys_addr_t arm_smmu_msi_cfg[ARM_SMMU_MAX_MSIS][3] = {
 	},
 };
 
-struct arm_smmu_option_prop {
-	u32 opt;
-	const char *prop;
-};
-
 DEFINE_XARRAY_ALLOC1(arm_smmu_asid_xa);
 DEFINE_MUTEX(arm_smmu_asid_lock);
 
@@ -78,26 +69,6 @@ DEFINE_MUTEX(arm_smmu_asid_lock);
  */
 struct arm_smmu_ctx_desc quiet_cd = { 0 };
 
-static struct arm_smmu_option_prop arm_smmu_options[] = {
-	{ ARM_SMMU_OPT_SKIP_PREFETCH, "hisilicon,broken-prefetch-cmd" },
-	{ ARM_SMMU_OPT_PAGE0_REGS_ONLY, "cavium,cn9900-broken-page1-regspace"},
-	{ 0, NULL},
-};
-
-static void parse_driver_options(struct arm_smmu_device *smmu)
-{
-	int i = 0;
-
-	do {
-		if (of_property_read_bool(smmu->dev->of_node,
-						arm_smmu_options[i].prop)) {
-			smmu->options |= arm_smmu_options[i].opt;
-			dev_notice(smmu->dev, "option %s\n",
-				arm_smmu_options[i].prop);
-		}
-	} while (arm_smmu_options[++i].opt);
-}
-
 /* Low-level queue manipulation functions */
 static bool queue_has_space(struct arm_smmu_ll_queue *q, u32 n)
 {
@@ -3147,70 +3118,6 @@ static int arm_smmu_device_reset(struct arm_smmu_device *smmu, bool bypass)
 	return 0;
 }
 
-#ifdef CONFIG_ACPI
-static void acpi_smmu_get_options(u32 model, struct arm_smmu_device *smmu)
-{
-	switch (model) {
-	case ACPI_IORT_SMMU_V3_CAVIUM_CN99XX:
-		smmu->options |= ARM_SMMU_OPT_PAGE0_REGS_ONLY;
-		break;
-	case ACPI_IORT_SMMU_V3_HISILICON_HI161X:
-		smmu->options |= ARM_SMMU_OPT_SKIP_PREFETCH;
-		break;
-	}
-
-	dev_notice(smmu->dev, "option mask 0x%x\n", smmu->options);
-}
-
-static int arm_smmu_device_acpi_probe(struct platform_device *pdev,
-				      struct arm_smmu_device *smmu)
-{
-	struct acpi_iort_smmu_v3 *iort_smmu;
-	struct device *dev = smmu->dev;
-	struct acpi_iort_node *node;
-
-	node = *(struct acpi_iort_node **)dev_get_platdata(dev);
-
-	/* Retrieve SMMUv3 specific data */
-	iort_smmu = (struct acpi_iort_smmu_v3 *)node->node_data;
-
-	acpi_smmu_get_options(iort_smmu->model, smmu);
-
-	if (iort_smmu->flags & ACPI_IORT_SMMU_V3_COHACC_OVERRIDE)
-		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
-
-	return 0;
-}
-#else
-static inline int arm_smmu_device_acpi_probe(struct platform_device *pdev,
-					     struct arm_smmu_device *smmu)
-{
-	return -ENODEV;
-}
-#endif
-
-static int arm_smmu_device_dt_probe(struct platform_device *pdev,
-				    struct arm_smmu_device *smmu)
-{
-	struct device *dev = &pdev->dev;
-	u32 cells;
-	int ret = -EINVAL;
-
-	if (of_property_read_u32(dev->of_node, "#iommu-cells", &cells))
-		dev_err(dev, "missing #iommu-cells property\n");
-	else if (cells != 1)
-		dev_err(dev, "invalid #iommu-cells value (%d)\n", cells);
-	else
-		ret = 0;
-
-	parse_driver_options(smmu);
-
-	if (of_dma_is_coherent(dev->of_node))
-		smmu->features |= ARM_SMMU_FEAT_COHERENCY;
-
-	return ret;
-}
-
 static unsigned long arm_smmu_resource_size(struct arm_smmu_device *smmu)
 {
 	if (smmu->options & ARM_SMMU_OPT_PAGE0_REGS_ONLY)
@@ -3271,16 +3178,9 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	smmu->dev = dev;
 
-	if (dev->of_node) {
-		ret = arm_smmu_device_dt_probe(pdev, smmu);
-	} else {
-		ret = arm_smmu_device_acpi_probe(pdev, smmu);
-		if (ret == -ENODEV)
-			return ret;
-	}
-
-	/* Set bypass mode according to firmware probing result */
-	bypass = !!ret;
+	ret = arm_smmu_fw_probe(pdev, smmu, &bypass);
+	if (ret)
+		return ret;
 
 	/* Base address */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-- 
2.39.0

