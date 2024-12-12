Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57A7023DEA6
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026780; cv=none; b=P0ZzuPLl8gsLSS4kmNCN6hvSLzANBxOUMKkvlsGZtuQA0GxkwXG3pZcqFZseGGylEDH2OpR2tcKXBk8r+YKCbGMaV5lfiu5FgDrxr2YKP3tCDnczdnI6XoMMBK5bgKHK1O1d5ammSDKNAOQzw/gpMn879Til5tTy3bYF79IQaz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026780; c=relaxed/simple;
	bh=nldh58rc77hsjw5gSEOSIIELaTF6Cfi2Rvy9VG/QlTM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i+QiKocLZr4lElAhhrq1H110bSJjd99qvjTEUJtiDvMexbdrMH3Jixlr7eMjqQd66tWbd0jF4IAWF1itdRXyt6s7XeL/eQcPbXo0kPRfJ+UfZ4p0/R+5loksj/rZ94fCtElOZHlZH8G9i1l9Ou1Xt0KSWj6bzNO1LjtcjVxowi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=D0stwn9D; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="D0stwn9D"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3878ad4bf8cso624972f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026776; x=1734631576; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=iyTqVJhMppnYdv5NSdPsxpiQh63AvYUQ+byd2sEa6to=;
        b=D0stwn9Dc4sdvduOnQ+M+d4dGlDgnqM0EUjRR/XnMjsOAHa0avx2ac+oQ7tEdG1jzv
         IoVMPZlo0uZ91cG1QwuYClfMhm2Uom5h0Uyf+RDf+MwXNslmSO7B3KFFmZsdphYv/MRD
         5f71ztqW9ezU0uUJvdebTCf03bbFsx1SBDXdl7REzAoPv1CnpLfJSQ/kiI0S2Q0RYtPv
         3vcdIJLFTAXw5FiMq3e5hi+eDyUDffaH+hfcgkwseCLBMuK41wcPS6VG/sSxFlmLJnQ8
         PWtun2x/7RtIVhdsYV1VtvE5WPJCStS3FwJVhcSYoi93KEEHYbNBOYtMLs7rwwhaK2fk
         uU0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026776; x=1734631576;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iyTqVJhMppnYdv5NSdPsxpiQh63AvYUQ+byd2sEa6to=;
        b=LDGYLDcSu5mXaWlx4ucu1oBnKhAYn5tu4OwhxdVA5cmQjjeMBW1cbvmKOLpU9Wss7S
         h6wTOee5lTvD52rCVmwUAw2duHeJ5LySXjY571LsWVbgrxmYfNSJHt/UcdB3AcagC4KR
         CWUF+cbRkYySKq/LGZWYUxPs6OGqoL+eJCZA0wgOaz0TtSZpvIbLo11LrKwSeUBv6npA
         E6D23duw2RNYWd2MJTFZ39l8n77cYwjKvF/gJLWKRcXAA4kd9b+rGR7K2tJM61+ZsdnM
         PiIO/KUFom4iT5pGrZ++5pzi1gd+gKeaCvnOjMejuHwVitg2suYSovGXYFPrDY48qeOz
         AR8w==
X-Forwarded-Encrypted: i=1; AJvYcCWfFULlLpnDhWv1hcxU+vqyfPrCurR8zoWadVCXj+8IpoMqARmpDOFSbN3qQAVNbU6beJHJNkA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyKsMAxZRs1oBCQ9AJNvABvz//DpFXWKfoTYG5xsPHUnjOb18Rv
	zfewn/ex65Osn2z+4S5X7M34sMA6IUZWrjoXP3VNul7l/n8aHSlwurL93de39HZSjBWwDgrzJX/
	OK1463RVMIA==
X-Google-Smtp-Source: AGHT+IFG8WA1Z2ObHa4JSTh7ZOJd26fn3uY6Vzk1iSlEnJuugWr6UhUgo2xrrDlr60JHvwlglh6D+X+h9Bswrg==
X-Received: from wmgf12.prod.google.com ([2002:a05:600c:154c:b0:42c:bfc2:aa72])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:64af:0:b0:385:f7ea:eb86 with SMTP id ffacd0b85a97d-38787685119mr4003192f8f.7.1734026775884;
 Thu, 12 Dec 2024 10:06:15 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:08 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-45-smostafa@google.com>
Subject: [RFC PATCH v2 44/58] iommu/arm-smmu-v3-kvm: Validate device features
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

The KVM hypervisor driver supports a small subset of features. Ensure
the implementation is compatible, and disable some unused features.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index e2d9bd97ddc5..4b0c9ff6e7f1 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -27,6 +27,45 @@ static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
 
+static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
+{
+	unsigned int required_features =
+		ARM_SMMU_FEAT_TT_LE;
+	unsigned int forbidden_features =
+		ARM_SMMU_FEAT_STALL_FORCE;
+	unsigned int keep_features =
+		ARM_SMMU_FEAT_2_LVL_STRTAB	|
+		ARM_SMMU_FEAT_2_LVL_CDTAB	|
+		ARM_SMMU_FEAT_TT_LE		|
+		ARM_SMMU_FEAT_SEV		|
+		ARM_SMMU_FEAT_COHERENCY		|
+		ARM_SMMU_FEAT_TRANS_S1		|
+		ARM_SMMU_FEAT_TRANS_S2		|
+		ARM_SMMU_FEAT_VAX		|
+		ARM_SMMU_FEAT_RANGE_INV;
+
+	if (smmu->options & ARM_SMMU_OPT_PAGE0_REGS_ONLY) {
+		dev_err(smmu->dev, "unsupported layout\n");
+		return false;
+	}
+
+	if ((smmu->features & required_features) != required_features) {
+		dev_err(smmu->dev, "missing features 0x%x\n",
+			required_features & ~smmu->features);
+		return false;
+	}
+
+	if (smmu->features & forbidden_features) {
+		dev_err(smmu->dev, "features 0x%x forbidden\n",
+			smmu->features & forbidden_features);
+		return false;
+	}
+
+	smmu->features &= keep_features;
+
+	return true;
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -71,6 +110,9 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	if (!kvm_arm_smmu_validate_features(smmu))
+		return -ENODEV;
+
 	platform_set_drvdata(pdev, smmu);
 
 	/* Hypervisor parameters */
@@ -79,6 +121,7 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	hyp_smmu->ias = smmu->ias;
 	hyp_smmu->mmio_addr = ioaddr;
 	hyp_smmu->mmio_size = size;
+	hyp_smmu->features = smmu->features;
 	kvm_arm_smmu_cur++;
 
 	return arm_smmu_register_iommu(smmu, &kvm_arm_smmu_ops, ioaddr);
-- 
2.47.0.338.g60cca15819-goog

