Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6339923EC08
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026781; cv=none; b=ML/oG3W8pqrq218MqwRol34zAcf1LtmHaYxmv7KDWurVqFVN99p9VrrTi/U1l7lujKHalvX+M6IqTlbMA6UF+7q1xNuocBHtbpaEXzNkfoYtb6K9QRiY3GNA+a+ovd47+Qf2qviKhTHCrmUAR/GPhQ4iuHKwMR/TeqTRvG7RUbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026781; c=relaxed/simple;
	bh=6PX44nPStYCYZZD1cKcooZ6ZGWZjsxFQTSKNYP8ifRQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=MoUqzC4xdsxc5uezmyWysa7470TN6Rgf9xSFb29fFIRe6riihrCBtt+faVyr1A/QgkCFbigCcCIrfS5i08SfaDzMPRBOWGZuWbXHnF02WcUB+5DncvkS6UtuqX38Wv7LfgeTbLTZPYN6EA81ZGnXgULiLBEBbufsWi/U6pPVHsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IREWpnik; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IREWpnik"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4359eb032c9so7205245e9.2
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026778; x=1734631578; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri+r7pwRuSGuwjoUtH68VlyYId/xYJ7bbwqqbgxE7o0=;
        b=IREWpnikBR1m5E5KKIieJFp8Uw9k/+5DaH7NlhSzHZyJEa7YkBnwGaVCr/85rck2DN
         LQm4WwAibO1G7NNVWMHt0GIbR0RD5k1/ycqXFJU65FFo+xyxi64KRfm5SgTV4ezRva+9
         zvg5qS390D4bERNKqyssAvwc7f8u0boMrl6diu/Zvw6oXT0UtqkXaAFFlzepedNYfJV3
         7BEBvuY2fTrZXoUHu0Fl4+0LQWTFeDOUvXoXMWjMkYfa5gPlwtkGsr4R6Az16yVvgyvx
         qBPjI1nkK3ZK6lq0jkZLeX/ulMOW1ccJaMr3imotJzEDKynlnRojcVZnWbMEpbQctzpP
         pZ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026778; x=1734631578;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ri+r7pwRuSGuwjoUtH68VlyYId/xYJ7bbwqqbgxE7o0=;
        b=qCjcjNfpR0J0Iwk73a9oNFHrubDTLH4oIB3l/7H6fpYVs3m3kptXCwFn63+yiddbCy
         hz4KtH7naSXN1oUIacJUvM2Qioh8xPqdfVayj3cFhFSlF1uYSAZipnkh4RqzH27p2DKr
         a8o5yFzt8YAS0e5dC/sO9HIHl1b1KteXAg0ZOENV5SMklP7Nv1RMxFZLb0N0oqXC18aU
         sPTZtlszTi0exxdSuIH2ipymvyMpE8BLbOUPglOAXiySnEaiQzhDsUoL5Y7MQx2prPp8
         RwOHf9ZRsy4c0Tbqlj30cY687fxNdwGUvhlDmN2n0tD6a7Z91/1E1sLq/OTV/ZEirbWz
         eBfg==
X-Forwarded-Encrypted: i=1; AJvYcCWOYWAZtjcqWQU9CSmoEFYtobFTD2RBzmawqeofzR/mFHi7WMER5WUgCJRWlyTEJI2VfbbtQw4=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFxvhFQNuBp49DRs3wCRdLiPMYpQDJUqWChjN8r30V9Jq+glp5
	NxI6EX1GDMh4fGPL2j9jompPS3RGO+VO8qhws0rOrd6NdG3IKUMvpVMEB+6p+ter/SovYYIDIuZ
	gkX3FI7dn1Q==
X-Google-Smtp-Source: AGHT+IFK/W90GGrvF5ugVo4Ngg6I8Ho4ihHIM4uN2vyaRLD/UUIi5+Bgx5fKDHT7GWhU2g/J1RsFzA2778KxoA==
X-Received: from wmdi8.prod.google.com ([2002:a05:600c:2908:b0:434:a0d3:2d57])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:548a:b0:436:17e4:ad4c with SMTP id 5b1f17b1804b1-43622823c62mr35176435e9.6.1734026778111;
 Thu, 12 Dec 2024 10:06:18 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:09 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-46-smostafa@google.com>
Subject: [RFC PATCH v2 45/58] iommu/arm-smmu-v3-kvm: Allocate structures and
 reset device
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

Allocate the structures that will be shared between hypervisor and SMMU:
command queue and stream table. Install them in the MMIO registers,
along with some configuration bits. After hyp initialization, the host
won't have access to those pages anymore.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 53 +++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 4b0c9ff6e7f1..e4a5bdc830bc 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -18,6 +18,7 @@ extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 struct host_arm_smmu_device {
 	struct arm_smmu_device		smmu;
 	pkvm_handle_t			id;
+	u32				boot_gbpa;
 };
 
 #define smmu_to_host(_smmu) \
@@ -66,6 +67,35 @@ static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
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
+	arm_smmu_write_strtab(smmu);
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
@@ -113,6 +143,20 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
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
 	platform_set_drvdata(pdev, smmu);
 
 	/* Hypervisor parameters */
@@ -129,6 +173,15 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 
 static void kvm_arm_smmu_remove(struct platform_device *pdev)
 {
+	struct arm_smmu_device *smmu = platform_get_drvdata(pdev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	/*
+	 * There was an error during hypervisor setup. The hyp driver may
+	 * have already enabled the device, so disable it.
+	 */
+	arm_smmu_device_disable(smmu);
+	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
 }
 
 static const struct of_device_id arm_smmu_of_match[] = {
-- 
2.47.0.338.g60cca15819-goog

