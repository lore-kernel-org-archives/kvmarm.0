Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDD5847C
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:47 +0000 (UTC)
Received: by mail-wr1-f53.google.com with SMTP id q10so17233677wrm.4
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Dh/SuicpAUNOw64qrqjagLAfYYRP7GDUICNSAPWkEY=;
        b=sXyiSrRhQ03FjrQeAHXjhFoy/QwVyYKEscKoUYb3OZRIaH21HsrZEtSD5AL7zuiIFV
         vDmfHFdxA8m9jWRbzQBklMRmgEyQ8+yrurctzwyqsImPtLAcqi2b+RXEPT6gAqI7QsND
         +2RffjhJqi6hLIOeiiX9cDf5HGfIXxluoUmwfM5XmIHifSZEe86EmJPHIsdVqVX6OOzg
         e1uI55R5fQEInMR7Q4YM0Y6z0F2RxFH8mM5Slfd91Sypx3NOF0Hf+r9f59c975D6zMRc
         mL3qqvwrhHy14hSMyfJGg5gGthQWrjaqR0dYTk08kP4fcqUHPg0Bbxxmk0MaT4GaZEDO
         x2jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Dh/SuicpAUNOw64qrqjagLAfYYRP7GDUICNSAPWkEY=;
        b=h8PO2QrrJ6upBjrDnZAPhTpPlH840QmHqx1yIm91vkvvkA5061fRfQEmiKN2/qMyFy
         aQcIQ1thxxzAZ3FR78A+nFFN2DxYlwVnJf83TthLH0wjq0WmkoUFWrFRaMZylam3TQMA
         o3Gr+rqfKSDeDPPrpE42WIBMGq1MtRdyqa9F3iqIDKZuGkmeAEvoi9xluK8lZqkVAbCB
         t74/5J5QjDRPUPONX997fyQ5TcZlR647JeIC6hOONCB5zUIjdhbeUiY7BAzpm4PKJ1Fj
         dJheC8WvNjCpm1qyL+oBYrKkXLURib42yeC8bJl3l4XlLMWN6b2U/LXdvnIuhpMvFogG
         oWOw==
X-Gm-Message-State: AO0yUKUozA8oXZYQ8/LS51YlTpjKiJAdkdNAnJYae7pUBr6wFTAPaQ3r
	XJaZCvthi5ucczDRKFDxYz1+VA==
X-Google-Smtp-Source: AK7set+68/Lq7+7dw7L5pKpw0HIza+anyCOmSfiVtB5lzEVXRlZZF1Y8GjmD8XI2Ho4LfqXQo9439g==
X-Received: by 2002:a5d:5092:0:b0:2bf:c753:573f with SMTP id a18-20020a5d5092000000b002bfc753573fmr1910182wrt.24.1675256387073;
        Wed, 01 Feb 2023 04:59:47 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:46 -0800 (PST)
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
Subject: [RFC PATCH 35/45] iommu/arm-smmu-v3-kvm: Pass a list of SMMU devices to the hypervisor
Date: Wed,  1 Feb 2023 12:53:19 +0000
Message-Id: <20230201125328.2186498-36-jean-philippe@linaro.org>
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

Build a list of devices and donate the page to the hypervisor. At this
point the host is trusted and this would be a good opportunity to
provide more information about the system. For example, which devices
are owned by the host (perhaps via the VMID and SW bits in the stream
table, although we populate the stream table lazily at the moment.)

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 123 +++++++++++++++++-
 1 file changed, 120 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 4092da8050ef..1e0daf9ea4ac 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -4,15 +4,78 @@
  *
  * Copyright (C) 2022 Linaro Ltd.
  */
+#include <asm/kvm_mmu.h>
 #include <linux/of_platform.h>
 
 #include <kvm/arm_smmu_v3.h>
 
 #include "arm-smmu-v3.h"
 
+struct host_arm_smmu_device {
+	struct arm_smmu_device		smmu;
+	pkvm_handle_t			id;
+};
+
+#define smmu_to_host(_smmu) \
+	container_of(_smmu, struct host_arm_smmu_device, smmu);
+
+static size_t				kvm_arm_smmu_cur;
+static size_t				kvm_arm_smmu_count;
+static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
-	return -ENOSYS;
+	int ret;
+	bool bypass;
+	size_t size;
+	phys_addr_t ioaddr;
+	struct resource *res;
+	struct arm_smmu_device *smmu;
+	struct device *dev = &pdev->dev;
+	struct host_arm_smmu_device *host_smmu;
+	struct hyp_arm_smmu_v3_device *hyp_smmu;
+
+	if (kvm_arm_smmu_cur >= kvm_arm_smmu_count)
+		return -ENOSPC;
+
+	hyp_smmu = &kvm_arm_smmu_array[kvm_arm_smmu_cur];
+
+	host_smmu = devm_kzalloc(dev, sizeof(*host_smmu), GFP_KERNEL);
+	if (!host_smmu)
+		return -ENOMEM;
+
+	smmu = &host_smmu->smmu;
+	smmu->dev = dev;
+
+	ret = arm_smmu_fw_probe(pdev, smmu, &bypass);
+	if (ret || bypass)
+		return ret ?: -EINVAL;
+
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	size = resource_size(res);
+	if (size < SZ_128K) {
+		dev_err(dev, "unsupported MMIO region size (%pr)\n", res);
+		return -EINVAL;
+	}
+	ioaddr = res->start;
+	host_smmu->id = kvm_arm_smmu_cur;
+
+	smmu->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(smmu->base))
+		return PTR_ERR(smmu->base);
+
+	ret = arm_smmu_device_hw_probe(smmu);
+	if (ret)
+		return ret;
+
+	platform_set_drvdata(pdev, host_smmu);
+
+	/* Hypervisor parameters */
+	hyp_smmu->mmio_addr = ioaddr;
+	hyp_smmu->mmio_size = size;
+	kvm_arm_smmu_cur++;
+
+	return 0;
 }
 
 static int kvm_arm_smmu_remove(struct platform_device *pdev)
@@ -33,6 +96,36 @@ static struct platform_driver kvm_arm_smmu_driver = {
 	.remove = kvm_arm_smmu_remove,
 };
 
+static int kvm_arm_smmu_array_alloc(void)
+{
+	int smmu_order;
+	struct device_node *np;
+
+	kvm_arm_smmu_count = 0;
+	for_each_compatible_node(np, NULL, "arm,smmu-v3")
+		kvm_arm_smmu_count++;
+
+	if (!kvm_arm_smmu_count)
+		return 0;
+
+	/* Allocate the parameter list shared with the hypervisor */
+	smmu_order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
+	kvm_arm_smmu_array = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO,
+						      smmu_order);
+	if (!kvm_arm_smmu_array)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void kvm_arm_smmu_array_free(void)
+{
+	int order;
+
+	order = get_order(kvm_arm_smmu_count * sizeof(*kvm_arm_smmu_array));
+	free_pages((unsigned long)kvm_arm_smmu_array, order);
+}
+
 /**
  * kvm_arm_smmu_v3_init() - Reserve the SMMUv3 for KVM
  * @count: on success, number of SMMUs successfully initialized
@@ -44,12 +137,36 @@ int kvm_arm_smmu_v3_init(unsigned int *count)
 {
 	int ret;
 
+	/*
+	 * Check whether any device owned by the host is behind an SMMU.
+	 */
+	ret = kvm_arm_smmu_array_alloc();
+	*count = kvm_arm_smmu_count;
+	if (ret || !kvm_arm_smmu_count)
+		return ret;
+
 	ret = platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
 	if (ret)
-		return ret;
+		goto err_free;
 
-	*count = 0;
+	if (kvm_arm_smmu_cur != kvm_arm_smmu_count) {
+		/* A device exists but failed to probe */
+		ret = -EUNATCH;
+		goto err_free;
+	}
+
+	/*
+	 * These variables are stored in the nVHE image, and won't be accessible
+	 * after KVM initialization. Ownership of kvm_arm_smmu_array will be
+	 * transferred to the hypervisor as well.
+	 */
+	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_arm_smmu_array);
+	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_count;
 	return 0;
+
+err_free:
+	kvm_arm_smmu_array_free();
+	return ret;
 }
 
 void kvm_arm_smmu_v3_remove(void)
-- 
2.39.0

