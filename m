Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FE46287272
	for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 17:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753725241; cv=none; b=lFfVs9g46j6I3VoYHAMb2PrIIhVLR2UcdIPcrSVpSLD+bWF4VO/ckGWjPWlM2kmvVTVhxng2Gms+Hw9BCoR6RYJpjQHzq3aGFIFHTxYuzb7hAfsWFFfs+3imv+yRipdbJgMioXtaJq7YtG9f1LpoLjlDoZtVi6TZmrSfrVvECAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753725241; c=relaxed/simple;
	bh=dZuFm4aYvdFluJX9FNUAGiiXkF8S/lCBo9ayHFv2W9Q=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=C989rjVXt09h5NJzc6gM25ZA9xafwwUu5lc5cNVYoxQRR/FrPjAbb2KM1CuTT1GM0dTGW+Akif2sJLOXybQYtkOVjjhTyYNM3XttZHXSl78AcKLmOhYfvzH4558YWWnZ8iOJDvD3mYEWnMB5NfKYzDZfBkec0Qj1C4MLPws4Mj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=X8kYmrmu; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="X8kYmrmu"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3a54a8a0122so2650720f8f.2
        for <kvmarm@lists.linux.dev>; Mon, 28 Jul 2025 10:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753725236; x=1754330036; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=f4x+9nZ8CfG6VcovabsfC73bcsU1B/P8cpgFWvcyCzc=;
        b=X8kYmrmuyyCJthTKdrgpHFvXY1x+L9ErSVsf0GKIz1IYAknZ+TjvRcRE4OEbY0kH4G
         /c5D8oYAPvMY5t75wKFtzM7KnzNLopUAZ0Q4o2iq8c/pqgv1xWgR/py5wMdcDz/XAsYn
         eXRBqE8TCqtqMoWrXJkPf/Duwz1SeXLFX64wOsECNLMPb+J7Kl0eDfW4utxBPI9+7OUi
         jNWDlYkmG6Uf1lNvi5B2Emtlpe6VhVgvMkJ39C9+82XJNdK7MXK1VBbD74zDgjiioDfB
         hK+tvhHGA7NLk3UQVOSzzJ03KcVzuYSW3JFFZ1giOsuBF3lxATKIgLmfdGHF8Ny5FVge
         zMcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753725236; x=1754330036;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f4x+9nZ8CfG6VcovabsfC73bcsU1B/P8cpgFWvcyCzc=;
        b=wujGUsmCbWQxTrodXrp9j6NIPL/qU7sFisb2V2GL2AIU6I5QScb+SihSsNdUqLMr73
         8WNTi2YVDPQBb5K4X3MTstXiGtc/v/3n31T4Py/7H8S/scdmNu1o7O3RM0JnbP3UeMfw
         yPCcNGrFqiiL+vbSmb/aVIGnfb9vJMCHz6KLfhuiaPHctle3wOJr6PrKzeh5yMVswMTX
         PhOJQT9oHjHNIILWTtpmamyW0sXIw91YDmpsrPIhRfJcXJRi8hMLp+SJbmS4nIbhbDM4
         VUr5MNn6p0nejiOYlh80Rr5FtT2+uTUGduGFL4vp0jwxPk/RWuM7VDgxXz86W6TF7Hns
         p3iw==
X-Forwarded-Encrypted: i=1; AJvYcCUwV0vvy8povFXOZLh8F2O+IehqZJL35deFyQl/qijc3YC3+J62G72kI381GUhgoyCpbp/GmrA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwXILQKX/M4KdfZGHv0jiG8oSjbR2KIS+FLBUKXdFRTImG+66CF
	8PfUpe0PAbZsqqzsoQ4aXU+HeAujCPVWIKqfVlvysRIzNuPtUPYW9ROJXIQxmSf5Orv0wToHzHc
	c23NCM4N0x4i3Vw==
X-Google-Smtp-Source: AGHT+IEBJ4FZzMDcwCGDKN8xa1GdqdMhp4/1Mi4gQZ55PlpVVoMDB120scDJ9kcLF/kTOLPAggxTyBmxwWLxVQ==
X-Received: from wmbgw7.prod.google.com ([2002:a05:600c:8507:b0:456:293d:55c5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:138c:b0:456:43c:dcdc with SMTP id 5b1f17b1804b1-458852502eamr42122365e9.33.1753725235777;
 Mon, 28 Jul 2025 10:53:55 -0700 (PDT)
Date: Mon, 28 Jul 2025 17:53:14 +0000
In-Reply-To: <20250728175316.3706196-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250728175316.3706196-1-smostafa@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250728175316.3706196-28-smostafa@google.com>
Subject: [PATCH v3 27/29] iommu/arm-smmu-v3-kvm: Pass a list of SMMU devices
 to the hypervisor
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

Build a list of devices and donate the page to the hypervisor. At this
point the host is trusted and this would be a good opportunity to
provide more information about the system.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 182 +++++++++++++++++-
 1 file changed, 179 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 73c0150bdc81..2fa56ddfbdab 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -13,9 +13,119 @@
 
 extern struct kvm_iommu_ops kvm_nvhe_sym(smmu_ops);
 
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
+static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
+{
+	unsigned int required_features =
+		ARM_SMMU_FEAT_TT_LE |
+		ARM_SMMU_FEAT_TRANS_S2;
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
-	return -ENOSYS;
+	int ret;
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
+	ret = arm_smmu_fw_probe(pdev, smmu);
+	if (ret)
+		return ret;
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
+	if (!kvm_arm_smmu_validate_features(smmu))
+		return -ENODEV;
+
+	platform_set_drvdata(pdev, smmu);
+
+	/* Hypervisor parameters */
+	hyp_smmu->cmdq = smmu->cmdq.q;
+	hyp_smmu->strtab_cfg = smmu->strtab_cfg;
+	hyp_smmu->pgsize_bitmap = smmu->pgsize_bitmap;
+	hyp_smmu->oas = smmu->oas;
+	hyp_smmu->ias = smmu->ias;
+	hyp_smmu->mmio_addr = ioaddr;
+	hyp_smmu->mmio_size = size;
+	hyp_smmu->features = smmu->features;
+	kvm_arm_smmu_cur++;
+
+	return 0;
 }
 
 static void kvm_arm_smmu_remove(struct platform_device *pdev)
@@ -35,9 +145,62 @@ static struct platform_driver kvm_arm_smmu_driver = {
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
 static int kvm_arm_smmu_v3_init_drv(void)
 {
-	return platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
+	int ret;
+
+	ret = platform_driver_probe(&kvm_arm_smmu_driver, kvm_arm_smmu_probe);
+	if (ret)
+		goto err_free;
+
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
+	kvm_hyp_arm_smmu_v3_smmus = kvm_arm_smmu_array;
+	kvm_hyp_arm_smmu_v3_count = kvm_arm_smmu_count;
+	return 0;
+
+err_free:
+	kvm_arm_smmu_array_free();
+	return ret;
 }
 
 static void kvm_arm_smmu_v3_remove_drv(void)
@@ -52,11 +215,24 @@ struct kvm_iommu_driver kvm_smmu_v3_ops = {
 
 static int kvm_arm_smmu_v3_register(void)
 {
+	int ret;
+
 	if (!is_protected_kvm_enabled())
 		return 0;
 
-	return kvm_iommu_register_driver(&kvm_smmu_v3_ops,
+	/*
+	 * Only one KVM IOMMU driver can be registered, so only call the
+	 * register function if any SMMUv3 exists on the platform.
+	 */
+	ret = kvm_arm_smmu_array_alloc();
+	if (ret || !kvm_arm_smmu_count)
+		return ret;
+
+	ret = kvm_iommu_register_driver(&kvm_smmu_v3_ops,
 					kern_hyp_va(lm_alias(&kvm_nvhe_sym(smmu_ops))));
+	if (ret)
+		kvm_arm_smmu_array_free();
+	return ret;
 };
 
 core_initcall(kvm_arm_smmu_v3_register);
-- 
2.50.1.552.g942d659e1b-goog

