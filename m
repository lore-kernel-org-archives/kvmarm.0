Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACA863CF
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:45 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id t7so8870431wrp.5
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+zOq2rLtD1YPFldzTAQlw7NyDrjfoS45oyn9F6B1b8s=;
        b=aNGPAFo2QKGeiRP5S5IH7xD7mskfsJdtbRW+20Bv+RmyiyxyCq2QbNzd/p4ud8dL71
         2clglqcQlUZsX+DdlDGVOeXwo4LKP8WX8Ta0Mg2gbAN2H4dvoVB84P8hg2hapAAqUcZw
         BYYg8mMY1ePI+J8iL2xyozLfJc+Nim3Tx9NkA26QTNpDAMx6xebA044v+p2gqibEx2Wh
         7nOUuQHMLK8yf2LC4uW6bNg5hP4vzKvP6/p4NEyyU5mrCgrSfBiS/wvn/dTXWM2dIRIs
         eTJq3Xd+YQsEF/IsVuqdRrdKTkxT1Rwuut/DLKd18BdqyKdS74/8xQEtN6nWCXLvagsu
         ypSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+zOq2rLtD1YPFldzTAQlw7NyDrjfoS45oyn9F6B1b8s=;
        b=4dJGPU+dZX/SD2Bg3J46XnQc+DaFkQRFKYW2PJUzG8oJ7J0BamsYExMidO3Gt9xYW+
         SzcrWE5MGa2XvTx4ZMiickAiNRcB83t8mXW5A6EeAURmKx4f6fs9vO/wHy/nc6A/xwul
         7QgbTYXqihitYONKg/rnIKtjifb0jZ465mKK+UqyMGJ8zIyhhbD4JpjuzqCZ9L9vGqIB
         b9YKiXUMhfmGtj6yG+sy7IvMNsa1jrMiJcu1hcdBKCU98FESnYrshQYbtsuS8+OSKfz/
         bqzb0wu0emhGZ/GqLh8UoSR4eUKTFXWIXm6S+sHcGvqhLSMf1U7Tt/aU++KHCOh64PtC
         eUNw==
X-Gm-Message-State: AO0yUKVcpaV8tTHW/sSXMF+V0ZSMRRQg/Df0MFuYicx/zfHIzxNhHXwz
	TGc0J9cXDaLBhMLbgBGtgvaZTw==
X-Google-Smtp-Source: AK7set9KtmjqqwgFLZB2FNx7zyl09FQwFd6hG2Sf0+3Gpskf/K+qKqsqUvXHqew395vtDLCSbNyrtA==
X-Received: by 2002:a05:6000:1706:b0:2be:5366:8cdf with SMTP id n6-20020a056000170600b002be53668cdfmr2833558wrc.20.1675256384693;
        Wed, 01 Feb 2023 04:59:44 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:44 -0800 (PST)
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
Subject: [RFC PATCH 32/45] iommu/arm-smmu-v3: Move IOMMU registration to arm-smmu-v3-common.c
Date: Wed,  1 Feb 2023 12:53:16 +0000
Message-Id: <20230201125328.2186498-33-jean-philippe@linaro.org>
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

The KVM driver will need to implement a few IOMMU ops, so move the
helpers to arm-smmu-v3-common.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h   |  4 +++
 .../arm/arm-smmu-v3/arm-smmu-v3-common.c      | 34 +++++++++++++++++++
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c   | 17 ++--------
 3 files changed, 40 insertions(+), 15 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
index 345aac378712..87034da361ca 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h
@@ -290,6 +290,10 @@ int arm_smmu_init_one_queue(struct arm_smmu_device *smmu,
 int arm_smmu_init_l2_strtab(struct arm_smmu_device *smmu, u32 sid);
 int arm_smmu_init_strtab(struct arm_smmu_device *smmu);
 
+int arm_smmu_register_iommu(struct arm_smmu_device *smmu,
+			    struct iommu_ops *ops, phys_addr_t ioaddr);
+void arm_smmu_unregister_iommu(struct arm_smmu_device *smmu);
+
 int arm_smmu_write_ctx_desc(struct arm_smmu_domain *smmu_domain, int ssid,
 			    struct arm_smmu_ctx_desc *cd);
 void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
index 4e945df5d64f..7faf28c5a8b4 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-common.c
@@ -112,6 +112,13 @@ int arm_smmu_fw_probe(struct platform_device *pdev,
 		return arm_smmu_device_acpi_probe(pdev, smmu, bypass);
 }
 
+#ifdef CONFIG_ARM_SMMU_V3_SVA
+bool __weak arm_smmu_sva_supported(struct arm_smmu_device *smmu)
+{
+	return false;
+}
+#endif
+
 int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 {
 	u32 reg;
@@ -591,3 +598,30 @@ int arm_smmu_init_strtab(struct arm_smmu_device *smmu)
 	set_bit(0, smmu->vmid_map);
 	return 0;
 }
+
+int arm_smmu_register_iommu(struct arm_smmu_device *smmu,
+			    struct iommu_ops *ops, phys_addr_t ioaddr)
+{
+	int ret;
+	struct device *dev = smmu->dev;
+
+	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
+				     "smmu3.%pa", &ioaddr);
+	if (ret)
+		return ret;
+
+	ret = iommu_device_register(&smmu->iommu, ops, dev);
+	if (ret) {
+		dev_err(dev, "Failed to register iommu\n");
+		iommu_device_sysfs_remove(&smmu->iommu);
+		return ret;
+	}
+
+	return 0;
+}
+
+void arm_smmu_unregister_iommu(struct arm_smmu_device *smmu)
+{
+	iommu_device_unregister(&smmu->iommu);
+	iommu_device_sysfs_remove(&smmu->iommu);
+}
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 7cb171304953..a972c00700cc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3257,27 +3257,14 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 		return ret;
 
 	/* And we're up. Go go go! */
-	ret = iommu_device_sysfs_add(&smmu->iommu, dev, NULL,
-				     "smmu3.%pa", &ioaddr);
-	if (ret)
-		return ret;
-
-	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
-	if (ret) {
-		dev_err(dev, "Failed to register iommu\n");
-		iommu_device_sysfs_remove(&smmu->iommu);
-		return ret;
-	}
-
-	return 0;
+	return arm_smmu_register_iommu(smmu, &arm_smmu_ops, ioaddr);
 }
 
 static int arm_smmu_device_remove(struct platform_device *pdev)
 {
 	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
 
-	iommu_device_unregister(&smmu->iommu);
-	iommu_device_sysfs_remove(&smmu->iommu);
+	arm_smmu_unregister_iommu(smmu);
 	arm_smmu_device_disable(smmu);
 	iopf_queue_free(smmu->evtq.iopf);
 
-- 
2.39.0

