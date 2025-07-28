Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C15A278E63
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725222; cv=none; b=nPwqXmxAIRPRc4VSEqFGevvyOM+zqyM06TS7DI6ecmK1LM8/Pe7TqvBfAcZCsMDVpCaA4hZR+6LZEc9DprJaICGw+qEIYLyEGLYEID7Uq7URtVxXYowNUHBFS5J8aJ/nJu7eQ4xQzlPQzI6lZHGQNRCN6VgeUNn7JgRggUacoaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725222; c=relaxed/simple;
	bh=cc4qIV7R4IboXoEryrgrWSTN4pA0n7UvacWmOG9Xt0g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lLIRUa2wwv1PZ64ohoutIvsi9pLkPGVT87aseGrkH2ucLpirAvdBWw5qJcKxAk0pfOa6DkcoHBOR6dPtYp3nxHeCVMAwXOJAnOdN99ULbphu98vtuRwLUgsdyC2hUlRGErxU1gFCBDcTFp5CgvhrDN2ZZ7eTyBa/1grdycBi/vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=34baE3kK; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="34baE3kK"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-607c239c7f0so4391645a12.3
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725218; x=1754330018; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R18CRwRipna7yM1UAYryO2eun2b5lSz7TequZZhl+Fo=;
        b=34baE3kKFxgSiBnZwIlapgFG7VWygl5wPYjQbFPF7asQusRHqt+5zBWlSS1yQgNt2e
         Q0bf+a6jfoyCopDN9QbGzD2jGsCfK1/VZZzs26ktzy8OX7V/Z6WMChspZQgoC6zuB2as
         OmJgogNoUGgwnFQXF5uT2+B7DifEHQ5m0kkfU2mSgKSFRN91vHpogDfT3WC9L+3JDslo
         95FMT1kJV+KiXfOM53T6qy8M1CnB+xGNoPftXpwu9XUFyGtA1X+63T+cpnbCAQiL0PiW
         iQnszATz0m2NuHkPGChAj00VkmaNT4jaQjBMiLmWhzsXtg7wCurOhs0Y7DseSOgz5UK/
         3n4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725218; x=1754330018;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R18CRwRipna7yM1UAYryO2eun2b5lSz7TequZZhl+Fo=;
        b=XJpZU5HOe4zP/KsMrQB+k1shNqpW1LxORKJWA8DYMzhGo3Wbkksm+v+FL8nJKazDnL
         NdaGX0CswnBI7FhCWU3mG4iH5v+bwRsWWTHH/Nc6OZ4FUiBqFLTCpNiArXuq8IedQjrV
         5EmbEdA7hrvmXuw4TqFZSqY2tTTyxdfX0N5iG6Ez6nI1Wsno5/c09KuX56dp+D+1euZ1
         UClBBv2QqHOKJJthhiyEDvyVaKtb6YpPyYZgSqj4fE04YQifjU5BZUMGo2JJNJ7Tsr3J
         rRvBI3mWekfWjHAXndmqEJKDdv9PvVW16hRg/Uilk1M4UtKfCi0EuIAnv98+f7dhLC8y
         lXrQ==
X-Forwarded-Encrypted: i=1; AJvYcCUjeK2mRr1KbTN3cGwPRmxRxRo0Je/+lAQF2Vw4RH5Ioy0nH0kYi6J9xbf7sQHVfX70F/aiPag=@lists.linux.dev
X-Gm-Message-State: AOJu0YwvmfTJh33GfGBup9FfsIcpf0582QBYf+YQEw8eqWC9A+vlNbAC
	2Fo6CE0KOwmoC1bOOiJxVqOCL0MN1LP7FGrsejTmPL5ihJLTwB/fRB+jq1B4V31DLVoinEGI8OY
	Gka7aFJEX8+ihUg==
X-Google-Smtp-Source: AGHT+IGIrNMQeE/kWCI/brr7kS87BOY/bq6CCQ1xjchC98i6bmhfhF9J/7LevHBGbUwRoLbmWwCwzxtv61jC5A==
X-Received: from eddf14.prod.google.com ([2002:a05:6402:354e:b0:612:c149:d25d])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:268f:b0:60c:9d90:93c7 with SMTP id 4fb4d7f45d1cf-614f1f12240mr12562721a12.34.1753725217591;
 Mon, 28 Jul 2025 10:53:37 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:52:54 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-8-smostafa@google.com>
Subject: [PATCH v3 07/29] iommu/arm-smmu-v3: Extract driver-specific bits from
 probe function
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

As we're about to share the arm_smmu_device_hw_probe() function with the
KVM driver, extract bits that are specific to the normal driver.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index 10cc6dc26b7b..801b792dda36 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -4353,7 +4353,7 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	if (reg & IDR0_MSI) {
 		smmu->features |= ARM_SMMU_FEAT_MSI;
-		if (coherent && !disable_msipolling)
+		if (coherent)
 			smmu->options |= ARM_SMMU_OPT_MSIPOLL;
 	}
 
@@ -4504,11 +4504,6 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
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
@@ -4522,9 +4517,6 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
 
 	arm_smmu_device_iidr_probe(smmu);
 
-	if (arm_smmu_sva_supported(smmu))
-		smmu->features |= ARM_SMMU_FEAT_SVA;
-
 	dev_info(smmu->dev, "ias %lu-bit, oas %lu-bit (features 0x%08x)\n",
 		 smmu->ias, smmu->oas, smmu->features);
 	return 0;
@@ -4794,6 +4786,17 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
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
2.50.1.552.g942d659e1b-goog

