Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98CFD3D3BF
	for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 16:27:49 +0000 (UTC)
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4009fdc224dso113925e9.1
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 09:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695227268; x=1695832068; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=njyOLWMC/R6znj/bfqrW6FNgzFV5qfokOi6wslrb4o4=;
        b=j+T1HpOOYPSSB504e33O50FeUtadVrcGWndSCWCEdiwvjL9Lur/zGP+0vETXa/3vyy
         sSwUx+5g1v4RIZVdNSJscT1YYYf+JE6ZQSuXA0P/HmAY3eRpHn6hrV59TDvt8Yzr5pFj
         YtM+CdlxE4nWAxBG7ZZIrVBcHFmmYgUD92kMolc6fWE+K19vP7wzDAP+aO52AZbgB50b
         NCqB3MulkxO2JQnfU7BaPfGn+KpfQEoo1LlDAEVXeDdSh8TvVzqQLvhuilAUl+NwEraq
         GzvAzc134gG8c05xXYrQ0otj69gxyueLmA5opdnGc3dr2KmqOyNaUg6mC68L7EHwk0GX
         Lyaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695227268; x=1695832068;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njyOLWMC/R6znj/bfqrW6FNgzFV5qfokOi6wslrb4o4=;
        b=jPbGSX5qEqiowzD3HOcaAxlyt4VfJ82GqZ1bZzTt57GFux5bDeluRelRrSmSAPDBwR
         nLUu1yMKM+JnPk1W0x3oXcdcmhtOe8Btgs5vYgOfZmGVng+xnPUIY2zA3fLVdYGEp1+7
         q3jrj+5Rj7srEFtNRVr3/3gML3EDkpzmM2Gs5mk4l6rSQr150QBkVaBrjM8YN8hctDkG
         jPRz/BeZ9punm//6JFhmtOX1d78f7OhdYbD9AV9pfCI0LISWdE1EeXzQk8tLm9KuL7ZZ
         7wg6QEnlfq3TUXrQvRrBiC6Up6FT5G4ViTDGChOeR94vkByou7BUZNzxJZZ9Z3lzwovc
         awHg==
X-Gm-Message-State: AOJu0YzBFn3/6J7mq91R5cxNfYP0GjlUnLS9FjwnxDg1c+oJRyYEjiPR
	tNuB/r23vxr96+655NqNO0/pyA==
X-Google-Smtp-Source: AGHT+IEP/Rm1cLtvXtvuc+t2hn95b8IOkefA1eJWtusCzvVV3LB+oDwO/IxVXFR2+K+i2CCFK6Db7g==
X-Received: by 2002:a05:600c:5119:b0:3fe:ef25:8b86 with SMTP id o25-20020a05600c511900b003feef258b86mr116046wms.4.1695227267585;
        Wed, 20 Sep 2023 09:27:47 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id c3-20020a056000104300b003197869bcd7sm18975762wrx.13.2023.09.20.09.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Sep 2023 09:27:46 -0700 (PDT)
Date: Wed, 20 Sep 2023 16:27:41 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 40/45] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <ZQsdfcCaeQSn2pzQ@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-41-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230201125328.2186498-41-jean-philippe@linaro.org>

On Wed, Feb 01, 2023 at 12:53:24PM +0000, Jean-Philippe Brucker wrote:
> Forward alloc_domain(), attach_dev(), map_pages(), etc to the
> hypervisor.
> 
> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
> ---
>  .../iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c   | 330 +++++++++++++++++-
>  1 file changed, 328 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> index 55489d56fb5b..930d78f6e29f 100644
> --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-kvm.c
> @@ -22,10 +22,28 @@ struct host_arm_smmu_device {
>  #define smmu_to_host(_smmu) \
>  	container_of(_smmu, struct host_arm_smmu_device, smmu);
>  
> +struct kvm_arm_smmu_master {
> +	struct arm_smmu_device		*smmu;
> +	struct device			*dev;
> +	struct kvm_arm_smmu_domain	*domain;
> +};
> +
> +struct kvm_arm_smmu_domain {
> +	struct iommu_domain		domain;
> +	struct arm_smmu_device		*smmu;
> +	struct mutex			init_mutex;
> +	unsigned long			pgd;
> +	pkvm_handle_t			id;
> +};
> +
> +#define to_kvm_smmu_domain(_domain) \
> +	container_of(_domain, struct kvm_arm_smmu_domain, domain)
> +
>  static size_t				kvm_arm_smmu_cur;
>  static size_t				kvm_arm_smmu_count;
>  static struct hyp_arm_smmu_v3_device	*kvm_arm_smmu_array;
>  static struct kvm_hyp_iommu_memcache	*kvm_arm_smmu_memcache;
> +static DEFINE_IDA(kvm_arm_smmu_domain_ida);
>  
>  static DEFINE_PER_CPU(local_lock_t, memcache_lock) =
>  				INIT_LOCAL_LOCK(memcache_lock);
> @@ -57,7 +75,6 @@ static void *kvm_arm_smmu_host_va(phys_addr_t pa)
>  	return __va(pa);
>  }
>  
> -__maybe_unused
>  static int kvm_arm_smmu_topup_memcache(struct arm_smmu_device *smmu)
>  {
>  	struct kvm_hyp_memcache *mc;
> @@ -74,7 +91,6 @@ static int kvm_arm_smmu_topup_memcache(struct arm_smmu_device *smmu)
>  				     kvm_arm_smmu_host_pa, smmu);
>  }
>  
> -__maybe_unused
>  static void kvm_arm_smmu_reclaim_memcache(void)
>  {
>  	struct kvm_hyp_memcache *mc;
> @@ -101,6 +117,299 @@ static void kvm_arm_smmu_reclaim_memcache(void)
>  	__ret;							\
>  })
>  
> +static struct platform_driver kvm_arm_smmu_driver;
> +
> +static struct arm_smmu_device *
> +kvm_arm_smmu_get_by_fwnode(struct fwnode_handle *fwnode)
> +{
> +	struct device *dev;
> +
> +	dev = driver_find_device_by_fwnode(&kvm_arm_smmu_driver.driver, fwnode);
> +	put_device(dev);
> +	return dev ? dev_get_drvdata(dev) : NULL;
> +}
> +
> +static struct iommu_ops kvm_arm_smmu_ops;
> +
> +static struct iommu_device *kvm_arm_smmu_probe_device(struct device *dev)
> +{
> +	struct arm_smmu_device *smmu;
> +	struct kvm_arm_smmu_master *master;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +
> +	if (!fwspec || fwspec->ops != &kvm_arm_smmu_ops)
> +		return ERR_PTR(-ENODEV);
> +
> +	if (WARN_ON_ONCE(dev_iommu_priv_get(dev)))
> +		return ERR_PTR(-EBUSY);
> +
> +	smmu = kvm_arm_smmu_get_by_fwnode(fwspec->iommu_fwnode);
> +	if (!smmu)
> +		return ERR_PTR(-ENODEV);
> +
> +	master = kzalloc(sizeof(*master), GFP_KERNEL);
> +	if (!master)
> +		return ERR_PTR(-ENOMEM);
> +
> +	master->dev = dev;
> +	master->smmu = smmu;
> +	dev_iommu_priv_set(dev, master);
> +
> +	return &smmu->iommu;
> +}
> +
> +static void kvm_arm_smmu_release_device(struct device *dev)
> +{
> +	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
> +
> +	kfree(master);
> +	iommu_fwspec_free(dev);
> +}
> +
> +static struct iommu_domain *kvm_arm_smmu_domain_alloc(unsigned type)
> +{
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain;
> +
> +	/*
> +	 * We don't support
> +	 * - IOMMU_DOMAIN_IDENTITY because we rely on the host telling the
> +	 *   hypervisor which pages are used for DMA.
> +	 * - IOMMU_DOMAIN_DMA_FQ because lazy unmap would clash with memory
> +	 *   donation to guests.
> +	 */
> +	if (type != IOMMU_DOMAIN_DMA &&
> +	    type != IOMMU_DOMAIN_UNMANAGED)
> +		return NULL;
> +
> +	kvm_smmu_domain = kzalloc(sizeof(*kvm_smmu_domain), GFP_KERNEL);
> +	if (!kvm_smmu_domain)
> +		return NULL;
> +
> +	mutex_init(&kvm_smmu_domain->init_mutex);
> +
> +	return &kvm_smmu_domain->domain;
> +}
> +
> +static int kvm_arm_smmu_domain_finalize(struct kvm_arm_smmu_domain *kvm_smmu_domain,
> +					struct kvm_arm_smmu_master *master)
> +{
> +	int ret = 0;
> +	struct page *p;
> +	unsigned long pgd;
> +	struct arm_smmu_device *smmu = master->smmu;
> +	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> +
> +	if (kvm_smmu_domain->smmu) {
> +		if (kvm_smmu_domain->smmu != smmu)
> +			return -EINVAL;
> +		return 0;
> +	}
> +
> +	ret = ida_alloc_range(&kvm_arm_smmu_domain_ida, 0, 1 << smmu->vmid_bits,
> +			      GFP_KERNEL);
> +	if (ret < 0)
> +		return ret;
> +	kvm_smmu_domain->id = ret;
> +
> +	/*
> +	 * PGD allocation does not use the memcache because it may be of higher
> +	 * order when concatenated.
> +	 */
> +	p = alloc_pages_node(dev_to_node(smmu->dev), GFP_KERNEL | __GFP_ZERO,
> +			     host_smmu->pgd_order);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	pgd = (unsigned long)page_to_virt(p);
> +
> +	local_lock_irq(&memcache_lock);
> +	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_alloc_domain,
> +				   host_smmu->id, kvm_smmu_domain->id, pgd);
> +	local_unlock_irq(&memcache_lock);
> +	if (ret)
> +		goto err_free;
> +
> +	kvm_smmu_domain->domain.pgsize_bitmap = smmu->pgsize_bitmap;
> +	kvm_smmu_domain->domain.geometry.aperture_end = (1UL << smmu->ias) - 1;
> +	kvm_smmu_domain->domain.geometry.force_aperture = true;
> +	kvm_smmu_domain->smmu = smmu;
> +	kvm_smmu_domain->pgd = pgd;
> +
> +	return 0;
> +
> +err_free:
> +	free_pages(pgd, host_smmu->pgd_order);
> +	ida_free(&kvm_arm_smmu_domain_ida, kvm_smmu_domain->id);
> +	return ret;
> +}
> +
> +static void kvm_arm_smmu_domain_free(struct iommu_domain *domain)
> +{
> +	int ret;
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
> +
> +	if (smmu) {
> +		struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> +
> +		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_free_domain,
> +					host_smmu->id, kvm_smmu_domain->id);
> +		/*
> +		 * On failure, leak the pgd because it probably hasn't been
> +		 * reclaimed by the host.
> +		 */
> +		if (!WARN_ON(ret))
> +			free_pages(kvm_smmu_domain->pgd, host_smmu->pgd_order);
I believe this doube-free the pgd in case of attatch_dev fails, as it
would try to free it their also (in kvm_arm_smmu_domain_finalize).

I think this is right place to free the pgd.

> +		ida_free(&kvm_arm_smmu_domain_ida, kvm_smmu_domain->id);
> +	}
> +	kfree(kvm_smmu_domain);
> +}
> +
> +static int kvm_arm_smmu_detach_dev(struct host_arm_smmu_device *host_smmu,
> +				   struct kvm_arm_smmu_master *master)
> +{
> +	int i, ret;
> +	struct arm_smmu_device *smmu = &host_smmu->smmu;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(master->dev);
> +
> +	if (!master->domain)
> +		return 0;
> +
> +	for (i = 0; i < fwspec->num_ids; i++) {
> +		int sid = fwspec->ids[i];
> +
> +		ret = kvm_call_hyp_nvhe(__pkvm_host_iommu_detach_dev,
> +					host_smmu->id, master->domain->id, sid);
> +		if (ret) {
> +			dev_err(smmu->dev, "cannot detach device %s (0x%x): %d\n",
> +				dev_name(master->dev), sid, ret);
> +			break;
> +		}
> +	}
> +
> +	master->domain = NULL;
> +
> +	return ret;
> +}
> +
> +static int kvm_arm_smmu_attach_dev(struct iommu_domain *domain,
> +				   struct device *dev)
> +{
> +	int i, ret;
> +	struct arm_smmu_device *smmu;
> +	struct host_arm_smmu_device *host_smmu;
> +	struct iommu_fwspec *fwspec = dev_iommu_fwspec_get(dev);
> +	struct kvm_arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> +
> +	if (!master)
> +		return -ENODEV;
> +
> +	smmu = master->smmu;
> +	host_smmu = smmu_to_host(smmu);
> +
> +	ret = kvm_arm_smmu_detach_dev(host_smmu, master);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&kvm_smmu_domain->init_mutex);
> +	ret = kvm_arm_smmu_domain_finalize(kvm_smmu_domain, master);
> +	mutex_unlock(&kvm_smmu_domain->init_mutex);
> +	if (ret)
> +		return ret;
> +
> +	local_lock_irq(&memcache_lock);
> +	for (i = 0; i < fwspec->num_ids; i++) {
> +		int sid = fwspec->ids[i];
> +
> +		ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_attach_dev,
> +					   host_smmu->id, kvm_smmu_domain->id,
> +					   sid);
> +		if (ret) {
> +			dev_err(smmu->dev, "cannot attach device %s (0x%x): %d\n",
> +				dev_name(dev), sid, ret);
> +			goto out_unlock;
> +		}
> +	}
> +	master->domain = kvm_smmu_domain;
> +
> +out_unlock:
> +	if (ret)
> +		kvm_arm_smmu_detach_dev(host_smmu, master);
> +	local_unlock_irq(&memcache_lock);
> +	return ret;
> +}
> +
> +static int kvm_arm_smmu_map_pages(struct iommu_domain *domain,
> +				  unsigned long iova, phys_addr_t paddr,
> +				  size_t pgsize, size_t pgcount, int prot,
> +				  gfp_t gfp, size_t *mapped)
> +{
> +	int ret;
> +	unsigned long irqflags;
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
> +	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> +
> +	local_lock_irqsave(&memcache_lock, irqflags);
> +	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_map_pages,
> +				   host_smmu->id, kvm_smmu_domain->id, iova,
> +				   paddr, pgsize, pgcount, prot);
> +	local_unlock_irqrestore(&memcache_lock, irqflags);
> +	if (ret)
> +		return ret;
> +
> +	*mapped = pgsize * pgcount;
> +	return 0;
> +}
> +
> +static size_t kvm_arm_smmu_unmap_pages(struct iommu_domain *domain,
> +				       unsigned long iova, size_t pgsize,
> +				       size_t pgcount,
> +				       struct iommu_iotlb_gather *iotlb_gather)
> +{
> +	int ret;
> +	unsigned long irqflags;
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> +	struct arm_smmu_device *smmu = kvm_smmu_domain->smmu;
> +	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> +
> +	local_lock_irqsave(&memcache_lock, irqflags);
> +	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_unmap_pages,
> +				   host_smmu->id, kvm_smmu_domain->id, iova,
> +				   pgsize, pgcount);
> +	local_unlock_irqrestore(&memcache_lock, irqflags);
> +
> +	return ret ? 0 : pgsize * pgcount;
> +}
> +
> +static phys_addr_t kvm_arm_smmu_iova_to_phys(struct iommu_domain *domain,
> +					     dma_addr_t iova)
> +{
> +	struct kvm_arm_smmu_domain *kvm_smmu_domain = to_kvm_smmu_domain(domain);
> +	struct host_arm_smmu_device *host_smmu = smmu_to_host(kvm_smmu_domain->smmu);
> +
> +	return kvm_call_hyp_nvhe(__pkvm_host_iommu_iova_to_phys, host_smmu->id,
> +				 kvm_smmu_domain->id, iova);
> +}
> +
> +static struct iommu_ops kvm_arm_smmu_ops = {
> +	.capable		= arm_smmu_capable,
> +	.device_group		= arm_smmu_device_group,
> +	.of_xlate		= arm_smmu_of_xlate,
> +	.probe_device		= kvm_arm_smmu_probe_device,
> +	.release_device		= kvm_arm_smmu_release_device,
> +	.domain_alloc		= kvm_arm_smmu_domain_alloc,
> +	.owner			= THIS_MODULE,
> +	.default_domain_ops = &(const struct iommu_domain_ops) {
> +		.attach_dev	= kvm_arm_smmu_attach_dev,
> +		.free		= kvm_arm_smmu_domain_free,
> +		.map_pages	= kvm_arm_smmu_map_pages,
> +		.unmap_pages	= kvm_arm_smmu_unmap_pages,
> +		.iova_to_phys	= kvm_arm_smmu_iova_to_phys,
> +	}
> +};
> +
>  static bool kvm_arm_smmu_validate_features(struct arm_smmu_device *smmu)
>  {
>  	unsigned long oas;
> @@ -186,6 +495,12 @@ static int kvm_arm_smmu_device_reset(struct host_arm_smmu_device *host_smmu)
>  	return 0;
>  }
>  
> +static void *kvm_arm_smmu_alloc_domains(struct arm_smmu_device *smmu)
> +{
> +	return (void *)devm_get_free_pages(smmu->dev, GFP_KERNEL | __GFP_ZERO,
> +					   get_order(KVM_IOMMU_DOMAINS_ROOT_SIZE));
> +}
> +
>  static int kvm_arm_smmu_probe(struct platform_device *pdev)
>  {
>  	int ret;
> @@ -274,6 +589,16 @@ static int kvm_arm_smmu_probe(struct platform_device *pdev)
>  	if (ret)
>  		return ret;
>  
> +	hyp_smmu->iommu.domains = kvm_arm_smmu_alloc_domains(smmu);
> +	if (!hyp_smmu->iommu.domains)
> +		return -ENOMEM;
> +
> +	hyp_smmu->iommu.nr_domains = 1 << smmu->vmid_bits;
> +
> +	ret = arm_smmu_register_iommu(smmu, &kvm_arm_smmu_ops, ioaddr);
> +	if (ret)
> +		return ret;
> +
>  	platform_set_drvdata(pdev, host_smmu);
>  
>  	/* Hypervisor parameters */
> @@ -296,6 +621,7 @@ static int kvm_arm_smmu_remove(struct platform_device *pdev)
>  	 * There was an error during hypervisor setup. The hyp driver may
>  	 * have already enabled the device, so disable it.
>  	 */
> +	arm_smmu_unregister_iommu(smmu);
>  	arm_smmu_device_disable(smmu);
>  	arm_smmu_update_gbpa(smmu, host_smmu->boot_gbpa, GBPA_ABORT);
>  	return 0;
> -- 
> 2.39.0
> 
>
Thanks,
Mostafa
