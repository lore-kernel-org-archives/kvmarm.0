Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92FD6847C
	for <kvmarm@lists.linux.dev>; Wed,  1 Feb 2023 12:59:51 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id y1so17249766wru.2
        for <kvmarm@lists.linux.dev>; Wed, 01 Feb 2023 04:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ppIcOxQzodRq67gk6vKw3mDff3ka1nzGshTj/M9s6gU=;
        b=jleX4Kb9vHaIr5lr3vyl0Ub3ZcNhzpnouvv+CkIVbkNJVnc0SDvAllr6MV3fHIDyxp
         HvfH5UGfuu/bpRcz80AL19f4M3GEPxihj8njwygHsnorYLkgtjo1Z3NS62kWOgH2zTHV
         0U/nB5UVu3ZZjEvtjYSXztcQxEv9Hi/8sJZTXJ0ncrril9a/uQDtEjY2sPvL+FQsoSnW
         Egbx0iT4sfA73eaXrrvx14AhUCeSorSD+4t2nXZFKjuvPmNqcn/SOnAwYdSaCenhj8FT
         nHucTqtMxSGfOR7jEPyIY6rEJkfPkaaJACQi5k1t1pUO/sQR7OP5Zw5BlYpgnAou+q2t
         8LEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ppIcOxQzodRq67gk6vKw3mDff3ka1nzGshTj/M9s6gU=;
        b=KAI2i/q+aJOu/pcbF52J3O1lQUVb0JtwIEOD0V0+Vt51VOIc0gB9WG6yzS1aWO3m6b
         /sr/zT5MWanqlrNUArg7irAjYttVZz8NsjgPjoeXDfQm8ITOQxR+LAiR0d/aY0aGdVQV
         RpkxoICp/9fGxgNaxrBrB/34DketKjb2m7wLVIQI3y9JuapQntW+2YXgsQEtkQaLHi5l
         S6kVRYMAoYvxhcRf9KjtdctIGx+aC2wwGJf8tzwmeT05iBkpNmOecdU5KJpmBbhyHiU3
         Rys5rOUyz/CsN9NceqvoYmfUKCY4cRCbdlTrbjg8Sd8vRo1A/5z1suSeJwh2Q7k9iR9E
         4A9A==
X-Gm-Message-State: AO0yUKXi7yk48iPsfLKh0bEE0ZxdVYp+K5eeFG+CNDwVS+aHTZdjKnz+
	7EIh6h9mFp0gkgD/sT+VWsbDVg==
X-Google-Smtp-Source: AK7set/Dpmjc+ms2UJSfAaO5FJ8lpQvzo1k02M1aY0CKDkRuCMOGO3vtPrB8nDGmTEPQxkdrikrbJg==
X-Received: by 2002:a05:6000:15cd:b0:2bf:d8ed:ba46 with SMTP id y13-20020a05600015cd00b002bfd8edba46mr2767625wry.47.1675256391143;
        Wed, 01 Feb 2023 04:59:51 -0800 (PST)
Received: from localhost.localdomain (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id m15-20020a056000024f00b002bfae16ee2fsm17972811wrz.111.2023.02.01.04.59.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Feb 2023 04:59:50 -0800 (PST)
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
Subject: [RFC PATCH 40/45] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Date: Wed,  1 Feb 2023 12:53:24 +0000
Message-Id: <20230201125328.2186498-41-jean-philippe@linaro.org>
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

Forward alloc_domain(), attach_dev(), map_pages(), etc to the
hypervisor.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
---
 .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 330 +++++++++++++++++-
 1 file changed, 328 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
index 55489d56fb5b..930d78f6e29f 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
@@ -22,10 +22,28 @@ struct host_arm_smmu_device {
 #define smmu_to_host(_smmu) \
 	container_of(_smmu, struct host_arm_smmu_device, smmu);
 
+struct kvm_arm_smmu_master {
+	struct arm_smmu_device		*smmu;
+	struct device			*dev;
+	struct kvm_arm_smmu_domain	*domain;
+};
+
+struct kvm_arm_smmu_domain {
+	struct iommu_domain		domain;
+	struct arm_smmu_device		*smmu;
+	struct mutex			init_mutex;
+	unsigned long			pgd;
+	pkvm_handle_t			id;
+};
+
+#define to_kvm_smmu_domain(_domain) \
+	container_of(_domain, struct kvm_arm_smmu_domain, domain)
+
 static size_t				kvm_arm_smmu_cur;
 static size_t				kvm_arm_smmu_count;
 static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
 static struct kvm_hyp_iommu_memcache	*kvm_arm_smmu_memcache;
+static DEFINE_IDA(kvm_arm_smmu_domain_ida);
 
 static DEFINE_PER_CPU(local_lock_t, memcache_lock) =
 				INIT_LOCAL_LOCK(memcache_lock);
@@ -57,7 +75,6 @@ static void *kvm_arm_smmu_host_va(phys_addr_t pa)
 	return __va(pa);
 }
 
-__maybe_unused
 static int kvm_arm_smmu_topup_memcache(struct arm_smmu_device *smmu)
 {
 	struct kvm_hyp_memcache *mc;
@@ -74,7 +91,6 @@ static int kvm_arm_smmu_topup_memcache(struct arm_smmu_device *smmu)
 				     kvm_arm_smmu_host_pa, smmu);
 }
 
-__maybe_unused
 static void kvm_arm_smmu_reclaim_memcache(void)
 {
 	struct kvm_hyp_memcache *mc;
@@ -101,6 +117,299 @@ static void kvm_arm_smmu_reclaim_memcache(void)
 	__ret;							\
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
+	if (!fwspec || fwspec->ops != &kvm_arm_smmu_ops)
+		return ERR_PTR(-ENODEV);
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
+static void kvm_arm_smmu_release_device(struct device *dev)
+{
+	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
+
+	kfree(master);
+	iommu_fwspec_free(dev);
+}
+
+static struct iommu_domain *kvm_arm_smmu_domain_alloc(unsigned type)
+{
+	struct kvm_arm_smmu_domain *kvm_smmu_domain;
+
+	/*
+	 * We don't support
+	 * - IOMMU_DOMAIN_IDENTITY because we rely on the host telling the
+	 *   hypervisor which pages are used for DMA.
+	 * - IOMMU_DOMAIN_DMA_FQ because lazy unmap would clash with memory
+	 *   donation to guests.
+	 */
+	if (type != IOMMU_DOMAIN_DMA &&
+	    type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
+	kvm_smmu_domain = kzalloc(sizeof(*kvm_smmu_domain), GFP_KERNEL);
+	if (!kvm_smmu_domain)
+		return NULL;
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
+	struct page *p;
+	unsigned long pgd;
+	struct arm_smmu_device *smmu = master->smmu;
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	if (kvm_smmu_domain->smmu) {
+		if (kvm_smmu_domain->smmu != smmu)
+			return -EINVAL;
+		return 0;
+	}
+
+	ret = ida_alloc_range(&kvm_arm_smmu_domain_ida, 0, 1 << smmu->vmid_bits,
+			      GFP_KERNEL);
+	if (ret < 0)
+		return ret;
+	kvm_smmu_domain->id = ret;
+
+	/*
+	 * PGD allocation does not use the memcache because it may be of higher
+	 * order when concatenated.
+	 */
+	p = alloc_pages_node(dev_to_node(smmu->dev), GFP_KERNEL | __GFP_ZERO,
+			     host_smmu->pgd_order);
+	if (!p)
+		return -ENOMEM;
+
+	pgd = (unsigned long)page_to_virt(p);
+
+	local_lock_irq(&memcache_lock);
+	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_alloc_domain,
+				   host_smmu->id, kvm_smmu_domain->id, pgd);
+	local_unlock_irq(&memcache_lock);
+	if (ret)
+		goto err_free;
+
+	kvm_smmu_domain->domain.pgsize_bitmap = smmu->pgsize_bitmap;
+	kvm_smmu_domain->domain.geometry.aperture_end = (1UL << smmu->ias) - 1;
+	kvm_smmu_domain->domain.geometry.force_aperture = true;
+	kvm_smmu_domain->smmu = smmu;
+	kvm_smmu_domain->pgd = pgd;
+
+	return 0;
+
+err_free:
+	free_pages(pgd, host_smmu->pgd_order);
+	ida_free(&kvm_arm_smmu_domain_ida, kvm_smmu_domain->id);
+	return ret;
+}
+
+static void kvm_arm_smmu_domain_free(struct iommu_domain *domain)
+{
+	int ret;
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
+
+	if (smmu) {
+		struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_free_domain,
+					host_smmu->id, kvm_smmu_domain->id);
+		/*
+		 * On failure, leak the pgd because it probably hasn't been
+		 * reclaimed by the host.
+		 */
+		if (!WARN_ON(ret))
+			free_pages(kvm_smmu_domain->pgd, host_smmu->pgd_order);
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
+
+	if (!master->domain)
+		return 0;
+
+	for (i = 0; i < fwspec->num_ids; i++) {
+		int sid = fwspec->ids[i];
+
+		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_detach_dev,
+					host_smmu->id, master->domain->id, sid);
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
+static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain,
+				   struct device *dev)
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
+	local_lock_irq(&memcache_lock);
+	for (i = 0; i < fwspec->num_ids; i++) {
+		int sid = fwspec->ids[i];
+
+		ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_attach_dev,
+					   host_smmu->id, kvm_smmu_domain->id,
+					   sid);
+		if (ret) {
+			dev_err(smmu->dev, "cannot attach device %s (0x%x): %d\n",
+				dev_name(dev), sid, ret);
+			goto out_unlock;
+		}
+	}
+	master->domain = kvm_smmu_domain;
+
+out_unlock:
+	if (ret)
+		kvm_arm_smmu_detach_dev(host_smmu, master);
+	local_unlock_irq(&memcache_lock);
+	return ret;
+}
+
+static int kvm_arm_smmu_map_pages(struct iommu_domain *domain,
+				  unsigned long iova, phys_addr_t paddr,
+				  size_t pgsize, size_t pgcount, int prot,
+				  gfp_t gfp, size_t *mapped)
+{
+	int ret;
+	unsigned long irqflags;
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	local_lock_irqsave(&memcache_lock, irqflags);
+	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_map_pages,
+				   host_smmu->id, kvm_smmu_domain->id, iova,
+				   paddr, pgsize, pgcount, prot);
+	local_unlock_irqrestore(&memcache_lock, irqflags);
+	if (ret)
+		return ret;
+
+	*mapped = pgsize * pgcount;
+	return 0;
+}
+
+static size_t kvm_arm_smmu_unmap_pages(struct iommu_domain *domain,
+				       unsigned long iova, size_t pgsize,
+				       size_t pgcount,
+				       struct iommu_iotlb_gather *iotlb_gather)
+{
+	int ret;
+	unsigned long irqflags;
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
+
+	local_lock_irqsave(&memcache_lock, irqflags);
+	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_unmap_pages,
+				   host_smmu->id, kvm_smmu_domain->id, iova,
+				   pgsize, pgcount);
+	local_unlock_irqrestore(&memcache_lock, irqflags);
+
+	return ret ? 0 : pgsize * pgcount;
+}
+
+static phys_addr_t kvm_arm_smmu_iova_to_phys(struct iommu_domain *domain,
+					     dma_addr_t iova)
+{
+	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
+	struct host_arm_smmu_device *host_smmu = smmu_to_host(kvm_smmu_domain->smmu);
+
+	return kvm_call_hyp_nvhe(__pkvm_host_iommu_iova_to_phys, host_smmu->id,
+				 kvm_smmu_domain->id, iova);
+}
+
+static struct iommu_ops kvm_arm_smmu_ops = {
+	.capable		= arm_smmu_capable,
+	.device_group		= arm_smmu_device_group,
+	.of_xlate		= arm_smmu_of_xlate,
+	.probe_device		= kvm_arm_smmu_probe_device,
+	.release_device		= kvm_arm_smmu_release_device,
+	.domain_alloc		= kvm_arm_smmu_domain_alloc,
+	.owner			= THIS_MODULE,
+	.default_domain_ops = &(const struct iommu_domain_ops) {
+		.attach_dev	= kvm_arm_smmu_attach_dev,
+		.free		= kvm_arm_smmu_domain_free,
+		.map_pages	= kvm_arm_smmu_map_pages,
+		.unmap_pages	= kvm_arm_smmu_unmap_pages,
+		.iova_to_phys	= kvm_arm_smmu_iova_to_phys,
+	}
+};
+
 static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
 {
 	unsigned long oas;
@@ -186,6 +495,12 @@ static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
 	return 0;
 }
 
+static void *kvm_arm_smmu_alloc_domains(struct arm_smmu_device *smmu)
+{
+	return (void *)devm_get_free_pages(smmu->dev, GFP_KERNEL | __GFP_ZERO,
+					   get_order(KVM_IOMMU_DOMAINS_ROOT_SIZE));
+}
+
 static int kvm_arm_smmu_probe(struct platform_device *pdev)
 {
 	int ret;
@@ -274,6 +589,16 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	hyp_smmu->iommu.domains = kvm_arm_smmu_alloc_domains(smmu);
+	if (!hyp_smmu->iommu.domains)
+		return -ENOMEM;
+
+	hyp_smmu->iommu.nr_domains = 1 << smmu->vmid_bits;
+
+	ret = arm_smmu_register_iommu(smmu, &kvm_arm_smmu_ops, ioaddr);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, host_smmu);
 
 	/* Hypervisor parameters */
@@ -296,6 +621,7 @@ static int kvm_arm_smmu_remove(struct platform_device *pdev)
 	 * There was an error during hypervisor setup. The hyp driver may
 	 * have already enabled the device, so disable it.
 	 */
+	arm_smmu_unregister_iommu(smmu);
 	arm_smmu_device_disable(smmu);
 	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
 	return 0;
-- 
2.39.0

