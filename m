Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A43D8486
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:49 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id k16so12616255wms.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DAR858KRQvKPg9d8btbK56RFwJ6U3P1FOrADuTdQSiU=;
        b=Ggyb3+Q97jwaq1nLUdEGCN/DmIa9T+TVIlNdQsa9leOlAfSvRNt1uXcyTN1GD+135G
         R77p3qJrpFcF9f5i8a0xPRilpSW6r6jSZeWNj5JfGc7ve7E9J0dCL9QoWw6rHLjBJhMA
         l+yjZVQR/gIfvs29AwC7zMLP2kmS34HW6UiaOlED2PTNOSPOcLJa65+ozh4XI3tOYbPh
         ybxXFnOfIvQ2gh3mm+WWi1Y5RYjUZY9QPb3v90eB/lCy2CilYg/1B9N+AZKXfR+eNB76
         cmC8MG7IxBkKv/RY7OILPUPSV/AOHj4cLG9vAlzQqkHcuLxlwSO5PajbdTbxsob4IR/y
         QfLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DAR858KRQvKPg9d8btbK56RFwJ6U3P1FOrADuTdQSiU=;
        b=Tw6jqmz1mKSwvcaq/q7JDI9cF/sBOJR8dXQX0eQPU/HUg81eoydsGxP9nbC6BpLUTw
         Evr8Rhg/T+H8icwbTjm6ZWu8RA7rMbCdadjorYdCkwuQ1Hpmg9IRepccGUUShZxQFDEp
         zFEhpEv0iTBCdxjQXv1ISF/MAByVldMkrPDXO6Di3zX8K7WE1oeY46ceJnP7or+0lSo1
         IpZTzRz6A1UwoA2tlSEUGsbInKIZIExVpJU4X5gi602kTNRjbCb/gAlJv2RdNvXchfvW
         31C1ugQYlTLBDj+IJn2cLysdYxhXH2vm8xzPdUnPXzUO9ckyzJtlwzPGS+z7OAfTUIku
         ClZA==
X-Gm-Message-State: AO0yUKW5jaIGVFOytw3aCIO6yz7PDs7b5cPK611UcfOFk8gomeSHErR1
	i6yd0x8l/YZ0L7UQJ3IZFMbupQ==
X-Google-Smtp-Source: AK7set+iGCoWOT606yNywkv2PHuH9O8/l5rQaiMO8pv3IURPxlu09QCKUnSrv4mv91hqJwJ7knQZYQ==
X-Received: by 2002:a05:600c:4f07:b0:3da:fd06:a6f1 with SMTP id l7-20020a05600c4f0700b003dafd06a6f1mr1937037wmq.31.1675256388617;
        Wed, 01 Feb 2023 04:59:48 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:48 -0800 (PST)
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
Subject: [RFC PATCH 37/45] iommu/arm-smmu-v3-kvm: Allocate structures and reset device
Date: Wed,  1 Feb 2023 12:53:21 +0000
Message-Id: <20230201125328.2186498-38-jean-philippe@linaro.org>
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

Allocate the structures that will be shared between hypervisor and SMMU:
command queue and stream table. Install them in the MMIO registers,
along with some configuration bits. After hyp initialization, the host
won't have access to those pages anymore.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 2cc632f6b256..8808890f4dc0 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -14,6 +14,7 @@
 struct host_arm_smmu_device {
 	struct arm_smmu_device		smmu;
 	pkvm_handle_t			id;
+	u32				boot_gbpa;
 };
 
 #define smmu_to_host(_smmu) \
@@ -76,6 +77,38 @@ static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 	return true;
 }
 
+static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
+{
+	int ret;
+	u32 reg;
+	struct arm_smmu_device *smmu = &host_smmu->smmu;
+
+	reg = readl_relaxed(smmu->base + ARM_SMMU_CR0);
+	if (reg & CR0_SMMUEN)
+		dev_warn(smmu->dev, "SMMU currently enabled! Resetting...\n");
+
+	/* Disable bypass */
+	host_smmu->boot_gbpa = readl_relaxed(smmu->base + ARM_SMMU_GBPA);
+	ret = arm_smmu_update_gbpa(smmu, GBPA_ABORT, 0);
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_device_disable(smmu);
+	if (ret)
+		return ret;
+
+	/* Stream table */
+	writeq_relaxed(smmu->strtab_cfg.strtab_base,
+		       smmu->base + ARM_SMMU_STRTAB_BASE);
+	writel_relaxed(smmu->strtab_cfg.strtab_base_cfg,
+		       smmu->base + ARM_SMMU_STRTAB_BASE_CFG);
+
+	/* Command queue */
+	writeq_relaxed(smmu->cmdq.q.q_base, smmu->base + ARM_SMMU_CMDQ_BASE);
+
+	return 0;
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -124,6 +157,20 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (!kvm_arm_smmu_validate_features(smmu))
 		return -ENODEV;
 
+	ret = arm_smmu_init_one_queue(smmu, &smmu->cmdq.q, smmu->base,
+				      ARM_SMMU_CMDQ_PROD, ARM_SMMU_CMDQ_CONS,
+				      CMDQ_ENT_DWORDS, "cmdq");
+	if (ret)
+		return ret;
+
+	ret = arm_smmu_init_strtab(smmu);
+	if (ret)
+		return ret;
+
+	ret = kvm_arm_smmu_device_reset(host_smmu);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, host_smmu);
 
 	/* Hypervisor parameters */
@@ -137,6 +184,15 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 
 static int kvm_arm_smmu_remove(struct platform_device *pdev)
 {
+	struct host_arm_smmu_device *host_smmu = platform_get_drvdata(pdev);
+	struct arm_smmu_device *smmu = &host_smmu->smmu;
+
+	/*
+	 * There was an error during hypervisor setup. The hyp driver may
+	 * have already enabled the device, so disable it.
+	 */
+	arm_smmu_device_disable(smmu);
+	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
 	return 0;
 }
 
-- 
2.39.0

