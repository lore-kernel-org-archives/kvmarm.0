Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9FC23FD21
	for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 18:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026789; cv=none; b=URQLiqJ25pis7Va2rYxlVBMx/EEyYRf3m4mS7x3s17mV0dAULry0Eje81d2tejU5yjukTkII2wTH9PPoqaoeZR8wWSmhvkl6G0hgyyVhSUni8DKSVi0NbjN73uJUkL8F1IBztWDA7Tp9xJQOPnLU87rQ4T5gZL4+gAP7O+w5qPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026789; c=relaxed/simple;
	bh=G0Y3j7qNwPYaO8zC2Ubn9vdwuHDYyilOl1CNG+n4cbE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TM4+P/o2UDwunTW2kbrdaxw2/UTX3Dp2NmbFGqn5JeRI1F37vMnpkzo5S09iZGEDmoDsmZwTJzEepcp+SVhNDop1DuCVghj8J/D5XeW52fPW9vWYAh91Ta2uwFmoR0NhcncYKnK4rH7kQ/7I9TgdnHOzMydPyf4Q5U4SQFxPCZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=qdQ8ElIy; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="qdQ8ElIy"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-434efe65e62so5723195e9.3
        for <kvmarm@lists.linux.dev>; Thu, 12 Dec 2024 10:06:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734026786; x=1734631586; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=v5SVX+pTxiaENIFA7cNS8JIZZP5zL/TwARaJceYJqX8=;
        b=qdQ8ElIyeA6maXH0CYSf+FQf+i7UUUCaRoJfKPzRIrH+Zx/C4hkTePNTOO+CglmkXm
         hzYucT0jvF4mTLlfKcZaaHp04M0vnQihvKuhfT2khS8m82RnUaWifFPb08f/1Pd7bPRX
         RUrCppNlxjwi9U06e/ctYvIZO/igGTZKG0neC0imbrn6E7mUVoATNjLLT5VCf3W34bVv
         Dk91ZrUyhwwufBWHsAezTCsw1Jh7LkBspum7LjbISjcUHnjiOkNGS22SoCo066Kh+ugB
         7Vy1Q9RaOL29X1Dvhnw8NYIRdiT9f9/awQMNfjs+zD630Q6G4F1fdZsDxCpP2IGvfZq9
         vlig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026786; x=1734631586;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v5SVX+pTxiaENIFA7cNS8JIZZP5zL/TwARaJceYJqX8=;
        b=pk1kiG2dwc6+VCQ4b7oDCjqs0VsKo9XD7I/XWYakjQ15Nn6CElRitwfmuQ65JqdppL
         1SDz7effwl1Q4s8XCnFhwYMn/JMlVreshI1zNfdBgN1VHrNZ0HzI+7+8wN42XscWs0Iz
         Y3OVwOEaPSkV0pgwOs4NN/v9o7+jpVZSoasSo4xViNSvSD1MFGS3J7EQiZamtjpiy8t0
         mFaKBPejwDVc4VILSpNiLCr1V7Ld/ECjJP5JO42rSt2tH+CH8WGnI2PrqXFCs3notcOW
         AXXlZiJoQZPr9bcosglnJNGN8S9YCgzoKZt2k5OLRfI61Gg9rX+T3zGriGGFibCZBn4d
         uxNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWrCY/pahspbPtuPlIr99LUnWpECA+z3R6P+dKLr1/eochK9FGD239+HwYXcGzZY/ZuAFkiaZQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwfjYFGfHM5cFXR8uvbl5tOvKUoJhnI+0cUcg77lNVC79xRV2rA
	yFjwZsO2tEzheJcQ10MUOqm+eoLMFwE7oEvTj+Cv44elKCmoB6IuOSYtmfzmQiYBkD59C2uIcpw
	3xRMy+EAgxA==
X-Google-Smtp-Source: AGHT+IHSna/pAUMpriFywfhuXQd4p7Z0BvqBnAxaoa4lXIc9lasdTGNcVYfL2Lq+5puAs9DWq8PJ6tvjCCUecw==
X-Received: from wmlf18.prod.google.com ([2002:a7b:c8d2:0:b0:434:9da4:2fa5])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4f92:b0:434:a1d3:a326 with SMTP id 5b1f17b1804b1-4361c346248mr58749665e9.6.1734026786073;
 Thu, 12 Dec 2024 10:06:26 -0800 (PST)
Date: Thu, 12 Dec 2024 18:04:13 +0000
In-Reply-To: <20241212180423.1578358-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20241212180423.1578358-1-smostafa@google.com>
X-Mailer: git-send-email 2.47.1.613.gc27f4b7a9f-goog
Message-ID: <20241212180423.1578358-50-smostafa@google.com>
Subject: [RFC PATCH v2 49/58] iommu/arm-smmu-v3-kvm: Add IOMMU ops
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

Add iommu_ops: attach_dev, release_device, probe_device, domain_alloc/
free, capable, and some other common ops with the kernel SMMUv3
driver: device_group, of_xlate, get_resv_regions.

Other ops as map/unmap and iova_to_phys added next.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 284 ++++++++++++++++++
 1 file changed, 284 insertions(+)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index dab2d59b5a88..071743f5acf9 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -7,6 +7,7 @@
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_mmu.h>
 
+#include <linux/arm-smccc.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
 
@@ -25,9 +26,26 @@ struct host_arm_smmu_device {
 #define smmu_to_host(_smmu) \
 	container_of(_smmu, struct host_arm_smmu_device, smmu);
 
+struct kvm_arm_smmu_master {
+	struct arm_smmu_device		*smmu;
+	struct device			*dev;
+	struct kvm_arm_smmu_domain      *domain;
+};
+
+struct kvm_arm_smmu_domain {
+	struct iommu_domain		domain;
+	struct arm_smmu_device		*smmu;
+	struct mutex			init_mutex;
+	pkvm_handle_t			id;
+};
+
+#define to_kvm_smmu_domain(_domain) \
+	container_of(_domain, struct kvm_arm_smmu_domain, domain)
+
 static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
+static DEFINE_IDA(kvm_arm_smmu_domain_ida);
 
 static int kvm_arm_smmu_topup_memcache(struct arm_smccc_res *res, gfp_t gfp)
 {
@@ -68,6 +86,267 @@ static int kvm_arm_smmu_topup_memcache(struct arm_smccc_res *res, gfp_t gfp)
 	__res.a1;							\
 })
 
+static struct platform_driver kvm_arm_smmu_driver;
+
+static struct arm_smmu_device *
+kvm_arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
+{
+	struct device *dev;
+
+	dev = driver_find_device_by_fwnode(&kvm_arm_smmu_driver.driver, fwnode);
+	put_device(dev);
+	return dev ? dev_get_drvdata(dev) : NULL;
+}
+
+static struct iommu_ops kvm_arm_smmu_ops;
+
+static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
+{
+	struct arm_smmu_device *smmu;
+	struct kvm_arm_smmu_master *master;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+
+	if (WARN_ON_ONCE(dev_iommu_priv_get(dev)))
+		return ERR_PTR(-EBUSY);
+
+	smmu = kvm_arm_smmu_get_by_fwnode(fwspec->iommu_fwnode);
+	if (!smmu)
+		return ERR_PTR(-ENODEV);
+
+	master = kzalloc(sizeof(*master), GFP_KERNEL);
+	if (!master)
+		return ERR_PTR(-ENOMEM);
+
+	master->dev = dev;
+	master->smmu = smmu;
+	dev_iommu_priv_set(dev, master);
+
+	return &smmu->iommu;
+}
+
+static struct iommu_domain *kvm_arm_smmu_domain_alloc(unsigned type)
+{
+	struct kvm_arm_smmu_domain *kvm_smmu_domain;
+
+	/*
+	 * We don't support
+	 * - IOMMU_DOMAIN_DMA_FQ because lazy unmap would clash with memory
+	 *   donation to guests.
+	 * - IOMMU_DOMAIN_IDENTITY: Requires a stage-2 only transparent domain.
+	 */
+	if (type != IOMMU_DOMAIN_DMA &&
+	    type != IOMMU_DOMAIN_UNMANAGED)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	kvm_smmu_domain = kzalloc(sizeof(*kvm_smmu_domain), GFP_KERNEL);
+	if (!kvm_smmu_domain)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&kvm_smmu_domain->init_mutex);
+
+	return &kvm_smmu_domain->domain;
+}
+
+static int kvm_arm_smmu_domain_finalize(struct kvm_arm_smmu_domain *kvm_smmu_domain,
+					struct kvm_arm_smmu_master *master)
+{
+	int ret = 0;
+	struct arm_smmu_device *smmu = master->smmu;
+	unsigned int max_domains;
+	enum kvm_arm_smmu_domain_type type;
+	struct io_pgtable_cfg cfg;
+	unsigned long ias;
+
+	if (kvm_smmu_domain->smmu && (kvm_smmu_domain->smmu != smmu))
+		return -EINVAL;
+
+	if (kvm_smmu_domain->smmu)
+		return 0;
+	/* Default to stage-1. */
+	if (smmu->features & ARM_SMMU_FEAT_TRANS_S1) {
+		ias = (smmu->features & ARM_SMMU_FEAT_VAX) ? 52 : 48;
+		cfg = (struct io_pgtable_cfg) {
+			.fmt = ARM_64_LPAE_S1,
+			.pgsize_bitmap = smmu->pgsize_bitmap,
+			.ias = min_t(unsigned long, ias, VA_BITS),
+			.oas = smmu->ias,
+			.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
+		};
+		ret = io_pgtable_configure(&cfg);
+		if (ret)
+			return ret;
+
+		type = KVM_ARM_SMMU_DOMAIN_S1;
+		kvm_smmu_domain->domain.pgsize_bitmap = cfg.pgsize_bitmap;
+		kvm_smmu_domain->domain.geometry.aperture_end = (1UL << cfg.ias) - 1;
+		max_domains = 1 << smmu->asid_bits;
+	} else {
+		cfg = (struct io_pgtable_cfg) {
+			.fmt = ARM_64_LPAE_S2,
+			.pgsize_bitmap = smmu->pgsize_bitmap,
+			.ias = smmu->ias,
+			.oas = smmu->oas,
+			.coherent_walk = smmu->features & ARM_SMMU_FEAT_COHERENCY,
+		};
+		ret = io_pgtable_configure(&cfg);
+		if (ret)
+			return ret;
+
+		type = KVM_ARM_SMMU_DOMAIN_S2;
+		kvm_smmu_domain->domain.pgsize_bitmap = cfg.pgsize_bitmap;
+		kvm_smmu_domain->domain.geometry.aperture_end = (1UL << cfg.ias) - 1;
+		max_domains = 1 << smmu->vmid_bits;
+	}
+	kvm_smmu_domain->domain.geometry.force_aperture = true;
+
+	/*
+	 * The hypervisor uses the domain_id for asid/vmid so it has to be
+	 * unique, and it has to be in range of this smmu, which can be
+	 * either 8 or 16 bits.
+	 */
+	ret = ida_alloc_range(&kvm_arm_smmu_domain_ida, 0,
+			      min(KVM_IOMMU_MAX_DOMAINS, max_domains), GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+
+	kvm_smmu_domain->id = ret;
+
+	ret = kvm_call_hyp_nvhe_mc(__pkvm_host_iommu_alloc_domain,
+				   kvm_smmu_domain->id, type);
+	if (ret) {
+		ida_free(&kvm_arm_smmu_domain_ida, kvm_smmu_domain->id);
+		return ret;
+	}
+
+	kvm_smmu_domain->smmu = smmu;
+	return 0;
+}
+
+static void kvm_arm_smmu_domain_free(struct iommu_domain *domain)
+{
+	int ret;
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
+
+	if (smmu) {
+		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_free_domain, kvm_smmu_domain->id);
+		ida_free(&kvm_arm_smmu_domain_ida, kvm_smmu_domain->id);
+	}
+	kfree(kvm_smmu_domain);
+}
+
+static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
+				   struct kvm_arm_smmu_master *master)
+{
+	int i, ret;
+	struct arm_smmu_device *smmu = &host_smmu->smmu;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
+	struct kvm_arm_smmu_domain *domain = master->domain;
+
+	if (!domain)
+		return 0;
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		int sid = fwspec->ids[i];
+
+		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_detach_dev,
+					host_smmu->id, domain->id, sid, 0);
+		if (ret) {
+			dev_err(smmu->dev, "cannot detach device %s (0x%x): %d\n",
+				dev_name(master->dev), sid, ret);
+			break;
+		}
+	}
+
+	master->domain = NULL;
+
+	return ret;
+}
+
+static void kvm_arm_smmu_release_device(struct device *dev)
+{
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(master->smmu);
+
+	kvm_arm_smmu_detach_dev(host_smmu, master);
+	kfree(master);
+	iommu_fwspec_free(dev);
+}
+
+static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
+{
+	int i, ret;
+	struct arm_smmu_device *smmu;
+	struct host_arm_smmu_device *host_smmu;
+	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+
+	if (!master)
+		return -ENODEV;
+
+	smmu = master->smmu;
+	host_smmu = smmu_to_host(smmu);
+
+	ret = kvm_arm_smmu_detach_dev(host_smmu, master);
+	if (ret)
+		return ret;
+
+	mutex_lock(&kvm_smmu_domain->init_mutex);
+	ret = kvm_arm_smmu_domain_finalize(kvm_smmu_domain, master);
+	mutex_unlock(&kvm_smmu_domain->init_mutex);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		int sid = fwspec->ids[i];
+
+		ret = kvm_call_hyp_nvhe_mc(__pkvm_host_iommu_attach_dev,
+					   host_smmu->id, kvm_smmu_domain->id,
+					   sid, 0, 0);
+		if (ret) {
+			dev_err(smmu->dev, "cannot attach device %s (0x%x): %d\n",
+				dev_name(dev), sid, ret);
+			goto out_ret;
+		}
+	}
+	master->domain = kvm_smmu_domain;
+
+out_ret:
+	if (ret)
+		kvm_arm_smmu_detach_dev(host_smmu, master);
+	return ret;
+}
+
+static bool kvm_arm_smmu_capable(struct device *dev, enum iommu_cap cap)
+{
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	switch (cap) {
+	case IOMMU_CAP_CACHE_COHERENCY:
+		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
+	case IOMMU_CAP_NOEXEC:
+	default:
+		return false;
+	}
+}
+
+static struct iommu_ops kvm_arm_smmu_ops = {
+	.capable		= kvm_arm_smmu_capable,
+	.device_group		= arm_smmu_device_group,
+	.of_xlate		= arm_smmu_of_xlate,
+	.get_resv_regions	= arm_smmu_get_resv_regions,
+	.probe_device		= kvm_arm_smmu_probe_device,
+	.release_device		= kvm_arm_smmu_release_device,
+	.domain_alloc		= kvm_arm_smmu_domain_alloc,
+	.pgsize_bitmap		= -1UL,
+	.owner			= THIS_MODULE,
+	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.attach_dev	= kvm_arm_smmu_attach_dev,
+		.free		= kvm_arm_smmu_domain_free,
+	}
+};
+
 static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 {
 	unsigned int required_features =
@@ -183,6 +462,11 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (!kvm_arm_smmu_validate_features(smmu))
 		return -ENODEV;
 
+	if (kvm_arm_smmu_ops.pgsize_bitmap == -1UL)
+		kvm_arm_smmu_ops.pgsize_bitmap = smmu->pgsize_bitmap;
+	else
+		kvm_arm_smmu_ops.pgsize_bitmap |= smmu->pgsize_bitmap;
+
 	ret = arm_smmu_init_one_queue(smmu, &smmu->cmdq.q, smmu->base,
 				      ARM_SMMU_CMDQ_PROD, ARM_SMMU_CMDQ_CONS,
 				      CMDQ_ENT_DWORDS, "cmdq");
-- 
2.47.0.338.g60cca15819-goog

