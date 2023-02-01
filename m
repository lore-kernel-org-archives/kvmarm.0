Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C6263B2
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:41 +0000 (UTC)
Received: by mail-wr1-f43.google.com with SMTP id d14so17222183wrr.9
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFG9Kxksr5XAD5z+jpFTZuXE6wo3TJrZX1lzDDnThIE=;
        b=XQ5yAOTwtSa7tp94IvyGR3xbhNDZa61S076xE+WBkEiPX3SQP4glj9DnCIsmbfPs9u
         Dv/3/6PfyG17r2c8HIa6nD0O+f+gNGhig98UvWmqpUY/8RShjXUjJLI92xSWYug1OZO3
         3kEiXPlErhcHmP2p06hYJWhAkyifML7LCP9PNidG+f4pvYxjzmgP0H4h3YuqsoaHteEG
         ictCQ+A9VbTIiSFOTJ63N81XZv1l1qoUpOMgH3amdoEH7fyVhbf5znCxC0aewHVSCHd6
         hnQSC5sNzfLKD1m8mDLilOrn26EDOE+MdiQHvk5j7E73YHthY6eBH3PGRT2zeT+SQ78R
         mnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFG9Kxksr5XAD5z+jpFTZuXE6wo3TJrZX1lzDDnThIE=;
        b=6i4q+k4JT/5rzyKgSyG8z3LzdPmr0XtxAkY8tiGQPl39MvNtHx4EsV18ixi/50aXux
         /hOZpzdjk83Jp+oe2MktnSfbF0+CzZcJjhWLG9ibxIUKm8xFuBgsxVy0ZPpsGrYQrUgr
         156eoYnx7iDtuP50wBsyaK3dldqj8KAVygtp6ZMk6jvy19Ooe+jS76SmoujJk6688I1Q
         54mGAeWP486XJGXGYeAT9pwpY+q+GZ4E8gBrQS8IUmDjs5X7S/o1q2GZ0ShzO/rSi/cS
         tEkFwfB5Q7bUydIxfYur9YIJo+SddtbyBnyxwzMyXEGCMZDzAio6T95zsulAiECPqvHi
         rX+g==
X-Gm-Message-State: AO0yUKW7eXAa4qwnyPExyfwI9mfUh2GenWemgb/EmUWOh6j1ySpYbi2a
	RG53nTGPr5i07ZhqtcGnYLd9fw==
X-Google-Smtp-Source: AK7set/oRWkQRL/1T6Fw11ETCaloaCZVNgIY5U+8Bhq0XoWcFkzYXbslbxbBP9XnuIbhQiQhf0YVZg==
X-Received: by 2002:a05:6000:1706:b0:2bf:f2f2:7d68 with SMTP id n6-20020a056000170600b002bff2f27d68mr3107911wrc.21.1675256381425;
        Wed, 01 Feb 2023 04:59:41 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:41 -0800 (PST)
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
Subject: [RFC PATCH 28/45] iommu/arm-smmu-v3: Extract driver-specific bits from probe function
Date: Wed,  1 Feb 2023 12:53:12 +0000
Message-Id: <20230201125328.2186498-29-jean-philippe@linaro.org>
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

As we're about to share the arm_smmu_device_hw_probe() function with the
KVM driver, extract two bits that are specific to the normal driver.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 97d24ee5c14d..bcbd691ca96a 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3454,7 +3454,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_MSI) {
 		smmu->features |= ARM_SMMU_FEAT_MSI;
-		if (coherent && !disable_msipolling)
+		if (coherent)
 			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
 	}
 
@@ -3598,11 +3598,6 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 		smmu->oas = 48;
 	}
 
-	if (arm_smmu_ops.pgsize_bitmap == -1UL)
-		arm_smmu_ops.pgsize_bitmap = smmu->pgsize_bitmap;
-	else
-		arm_smmu_ops.pgsize_bitmap |= smmu->pgsize_bitmap;
-
 	/* Set the DMA mask for our table walker */
 	if (dma_set_mask_and_coherent(smmu->dev, DMA_BIT_MASK(smmu->oas)))
 		dev_warn(smmu->dev,
@@ -3803,6 +3798,14 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (disable_msipolling)
+		smmu->options &= ~ARM_SMMU_OPT_MSIPOLL;
+
+	if (arm_smmu_ops.pgsize_bitmap == -1UL)
+		arm_smmu_ops.pgsize_bitmap = smmu->pgsize_bitmap;
+	else
+		arm_smmu_ops.pgsize_bitmap |= smmu->pgsize_bitmap;
+
 	/* Initialise in-memory data structures */
 	ret = arm_smmu_init_structures(smmu);
 	if (ret)
-- 
2.39.0

