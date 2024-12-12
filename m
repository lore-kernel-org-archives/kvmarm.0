Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF48223C50
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026698; cv=none; b=ohdgUmy4N4pRSNdwBThr0gWQjVXERO8nxHAA2J1903gkZ8lJuK/vg/gR8Rm20F9Ke69YKDCsbh2KhxaUHr9i2i/y/GW47UvVv8WogJ8sf/xVvi/Pc3SrkTByogZVc+ADcxgxibBVaGNeStn3YTxjXc/5z3epiVNHIVgKBTPaBIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026698; c=relaxed/simple;
	bh=p/qYAp+a0yQJRLOSye/K8aHYd6t+T9vmVjY6IoSMRKo=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=H1l0dvMCWEYn+MOiZquEZPKxAHwdseLuZ8CZGwz1iMdVlb24XqdCA1H/WWVfLleAOJ/5SM9I8HJ2NvWVUYHKxtaGc5WwHo/59rCUXOfh1yr5nGBweFt7GSMaBl9UB1trZb3ANwFuR3D46/grkRLnFZcuVwMSHaWq5jl81J+SgGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tIKpNa60; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tIKpNa60"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-434fe2b605eso5721065e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:04:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026694; x=1734631494; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wR1p8S8LwPyQNTvUjkaWT5KmeMMzb+jLodOVwCBm1UI=;
        b=tIKpNa60vO62s5GYZUrJiNsn/Xnian55amLB20iUqYLoV3H8tEEV0LHt9gzLItdlul
         uwMTIMox8V+o3XqTAt9wBPwZ6XDfZCqKOy08b/BapQdu7bToTCvQDJXFcnoXwc2bv+S5
         lDsOpf5vhM2iOtDmK5Jm0J+/3Y/qhgnvfccFbYqApBakj5s81zbPZn1DJ+QbQaYBIdAG
         tG5YTMFdDGxmcJc7j1I+RCRUk5fyedeF7lmoBurLwuYyDRKR7gAb7c+DeU3d85NM8e+T
         ohxL/1s3cppw6wadyK8M45knBNe+e/VbYzkVHN65Y16ynGgzBDgWt92FBOd5PNdPND9o
         hKdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026694; x=1734631494;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wR1p8S8LwPyQNTvUjkaWT5KmeMMzb+jLodOVwCBm1UI=;
        b=SPxPv8stW0uSLkLrSDnjvCoJNxGfOsAdk/uQYuhOyuu73UXX+0r1efHou+LK/aCR8Z
         DRWLrrCwua0gyX0Q2uQgf0+DskfYbmEwRD5S/eMW//BdIfbKXaE36aNWGakF2Ca6Pm32
         2OXVm8wqllxgx4Qu8TNDxOK/7blptrIyINWV373TJElppngEXshZLvDDIxCo9akw6+6P
         1oK3TbhND8QMcI38TF5BaeaP1ca9USXqki2rapu+1i0xjV2LOWN4jB/Ssz/dHMwu042F
         zU3P1dfq06GVI8Fl8+G5tWp2sleq87+sZ5XNpfG7gHjT60Rs+6/CiPY8UlKlYRbmw5xf
         D/sQ==
X-Forwarded-Encrypted: i=1; AJvYcCV88h2biz6qPCH5HQxN6aubMqpEbAtHCs946nGkU4gM3vGP65DC890HG11xF0c4e4i3MYLr+j4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn6jleN3QNxk8LIQJd80ara+z2R2u7k6moSNGBjzQjfTbz+53o
	IQ6bpz/A29AgrvLVR27F/MVbEeagV6MQfTiPyYTuEKrbwtRe5A27FNKlK1NJVP4VJbAcf4V1rJj
	4ANMIVoF6JQ==
X-Google-Smtp-Source: AGHT+IGngLUe7hTwqwYMuDaVTAngV7BbFyaM98e5ARjhrfPTg7ZpE0c7NHe9zxYUAMAR9O6PlwiwJtr/rnZAWw==
X-Received: from wmbjl5.prod.google.com ([2002:a05:600c:6a85:b0:434:f119:f1a])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b09:b0:436:1b7a:c0b4 with SMTP id 5b1f17b1804b1-4361c3454dbmr64162005e9.1.1734026694237;
 Thu, 12 Dec 2024 10:04:54 -0800 (PST)
Date: Thu, 12 Dec 2024 18:03:29 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-6-smostafa@google.com>
Subject: [RFC PATCH v2 05/58] iommu/arm-smmu-v3: Extract driver-specific bits
 from probe function
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

As we're about to share the arm_smmu_device_hw_probe() function with the
KVM driver, extract bits that are specific to the normal driver.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 737c5b882355..702863c94f91 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4167,7 +4167,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_MSI) {
 		smmu->features |= ARM_SMMU_FEAT_MSI;
-		if (coherent && !disable_msipolling)
+		if (coherent)
 			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
 	}
 
@@ -4316,11 +4316,6 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
@@ -4334,9 +4329,6 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	arm_smmu_device_iidr_probe(smmu);
 
-	if (arm_smmu_sva_supported(smmu))
-		smmu->features |= ARM_SMMU_FEAT_SVA;
-
 	dev_info(smmu->dev, "ias %lu-bit, oas %lu-bit (features 0x%08x)\n",
 		 smmu->ias, smmu->oas, smmu->features);
 	return 0;
@@ -4606,6 +4598,17 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (arm_smmu_sva_supported(smmu))
+		smmu->features |= ARM_SMMU_FEAT_SVA;
+
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
2.47.0.338.g60cca15819-goog

