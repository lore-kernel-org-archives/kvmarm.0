Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05158486
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:50 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id h12so17213613wrv.10
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YMChfuBGSkCRdEX7dXsLebM7lClmVnVl8CvGgr6HzRY=;
        b=srCsWRWYFUxl5KjOXa87GRxFlT6IkdbliPebR7kMfam6aaIU88cEBhi5qgJreiVImp
         oDINu2/MTn+O5qImdl6mtgdhDF/BEWTZy+UMXvQ7hsnYPbNCqogwRCRIpeyrKuNkcTIE
         pfqCS5kzvG+HrVW0OllEqKe+t2Znov5jY1F8RGXQyMDLGHxiCIZKM5Fx57gp+UhhluH6
         W6kq1D/CTZP3THYxNmReLiFFFesMewDb9B/9HcV4Za6MSn3WuaR6Q8sW5L3Y0p4lHZ1X
         CaEJa6OYiT6noSUV7s0lOcfcPVytx8h2idueowJNA4xzccdmCgvBAh7+Yc6VkyLgHGvx
         ggmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YMChfuBGSkCRdEX7dXsLebM7lClmVnVl8CvGgr6HzRY=;
        b=pm7st8b4vXuWaMyLPKJRRXKNk1MnxmZiAAUa2Q+0MVzT+gvHmrSGoGm4tnLhyeSLRu
         uzgquKSsNh2SIiHj5n5c78kUEKsm129UuKrjKADCnf8MwPoJhy2jvXCDUPcm6d6lHIOn
         CmUgT5x9yq+MSuf67+IosGl2pjpMlGbQqRdMwGT7YXg4/zD7WERbG07z85NjuvK5DAes
         SgiKY1fntAdl9t9dDV78IUp+Q87TiDE9aNfjZ1R71/ylJQoT40ZDSIs1XylBQ7oIWNrp
         PfT25F6D7Lqe29Nd4Ry9p+k2I+7k4VIfZgBRn6w9JOWYBM0oMOvks50dq8PSj6JkUdC3
         Vpzw==
X-Gm-Message-State: AO0yUKUXN9xctNb5lPqTSHZMoAS6PN1GbZ05bO15SWhkaruHdafgkMpC
	HrdpePvYNqcAoSkzpRz/SXgkvQ==
X-Google-Smtp-Source: AK7set8WgL+UDWIXb0NySo6GmdM6brHPe1cx2lexpL4QuzIoR1sXY+vgwT5LNEovfuXVdncaE2W8cg==
X-Received: by 2002:a05:6000:613:b0:2bf:d937:3589 with SMTP id bn19-20020a056000061300b002bfd9373589mr6629086wrb.14.1675256390366;
        Wed, 01 Feb 2023 04:59:50 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:49 -0800 (PST)
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
Subject: [RFC PATCH 39/45] iommu/arm-smmu-v3-kvm: Initialize page table configuration
Date: Wed,  1 Feb 2023 12:53:23 +0000
Message-Id: <20230201125328.2186498-40-jean-philippe@linaro.org>
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

Prepare the stage-2 I/O page table configuration that will be used by
the hypervisor driver.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 755c77bc0417..55489d56fb5b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -16,6 +16,7 @@ struct host_arm_smmu_device {
 	struct arm_smmu_device		smmu;
 	pkvm_handle_t			id;
 	u32				boot_gbpa;
+	unsigned int			pgd_order;
 };
 
 #define smmu_to_host(_smmu) \
@@ -192,6 +193,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	size_t size;
 	phys_addr_t ioaddr;
 	struct resource *res;
+	struct io_pgtable_cfg cfg;
 	struct arm_smmu_device *smmu;
 	struct device *dev = &pdev->dev;
 	struct host_arm_smmu_device *host_smmu;
@@ -233,6 +235,31 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (!kvm_arm_smmu_validate_features(smmu))
 		return -ENODEV;
 
+	/*
+	 * Stage-1 should be easy to support, though we do need to allocate a
+	 * context descriptor table.
+	 */
+	cfg = (struct io_pgtable_cfg) {
+		.fmt = ARM_64_LPAE_S2,
+		.pgsize_bitmap = smmu->pgsize_bitmap,
+		.ias = smmu->ias,
+		.oas = smmu->oas,
+		.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
+	};
+
+	/*
+	 * Choose the page and address size. Compute the PGD size and number of
+	 * levels as well, so we know how much memory to pre-allocate.
+	 */
+	ret = io_pgtable_configure(&cfg, &size);
+	if (ret)
+		return ret;
+
+	host_smmu->pgd_order = get_order(size);
+	smmu->pgsize_bitmap = cfg.pgsize_bitmap;
+	smmu->ias = cfg.ias;
+	smmu->oas = cfg.oas;
+
 	ret = arm_smmu_init_one_queue(smmu, &smmu->cmdq.q, smmu->base,
 				      ARM_SMMU_CMDQ_PROD, ARM_SMMU_CMDQ_CONS,
 				      CMDQ_ENT_DWORDS, "cmdq");
@@ -253,6 +280,8 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	hyp_smmu->mmio_addr = ioaddr;
 	hyp_smmu->mmio_size = size;
 	hyp_smmu->features = smmu->features;
+	hyp_smmu->iommu.pgtable_cfg = cfg;
+
 	kvm_arm_smmu_cur++;
 
 	return 0;
-- 
2.39.0

