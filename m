Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834F92CA7
	for <kvmarm@lists.linux.dev>; Tue,  7 Feb 2023 13:22:28 +0000 (UTC)
Received: by mail-wm1-f44.google.com with SMTP id m16-20020a05600c3b1000b003dc4050c94aso11435829wms.4
        for <kvmarm@lists.linux.dev>; Tue, 07 Feb 2023 05:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DmG0oP0jdngyUKgYcjaptk5vYfZ/R4S7PIcAd8oeqrQ=;
        b=SGwV1UPTmtV9D68A4KpWjnxeqipKdh43Ty6CtZ5ddbBl4/fbQ18vGo7mrEgZNjd9Lc
         CPPpCrN8NrKZe5g1g8BwvPTmw39lLd3df9n4PcIt3E7woToKwLNVbRpFfAOJj1TeO1Ke
         Xpji/IS1PY/rMjsJozfuuQsWiRbBSjon4KIGA9izVMUhypfVR2Kh5i+PHh3AiJyp2Sir
         vrRyF4BDrY5GuI5ikVEX9TanSXdn+HQNICVGCfkRvSrMoiJrXz0vJpz7Q/oOhpgSdSGw
         CQFYL8PHzTpJZdHIV8C7WvTl6F+/aM4sgGjbvqEHnfcVbTxUZJ4IGKBkPLRkp4myGayN
         ag6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DmG0oP0jdngyUKgYcjaptk5vYfZ/R4S7PIcAd8oeqrQ=;
        b=Ok+4EjqsVrYNUn7A1377ntxAXeOIjGxTqc11QVAWoEPSyziFBMXh4kC/+/AZv4sn7I
         rHET5jcWio8a0CAy1SLabeJIDJcmqqBDTghsSjc0BDqUAayGeNo7HGENidDbHrW3+yua
         FZZhY3FunSAY6RyW2jHyciK2jxr8cyC27yv61b2b6xkYPnnWNG3FkiNHwKmM5NfWdIeT
         C8/yg5ppKsX6NOJ6gqM7jtHUhFIoxSV6wZlsnvYDA9Sn4KDMfdvSYkq7+K08uqJkJpYZ
         Gq9Ggl4LsFBbY4c8ZrFcJUIqg/xezzSpgUAdjuumzuAmUybZ9w3KbmnN9VVBTNEVhrda
         aqjg==
X-Gm-Message-State: AO0yUKUKGCdllw7fwIcKalY843xKfmkWNzBlQoRUq5ZJC4r/9mhYwHxp
	Jr0yJQo7Nf4SWJlQZ+oxmL0XOg==
X-Google-Smtp-Source: AK7set8Y7adxJAATCa0j4WAgSzuYHo5STmlFSoz/qZFgFBmAZIpJXjK6wAq9BVawjwfjyonR0eZxew==
X-Received: by 2002:a05:600c:4f54:b0:3df:f3cb:e8cb with SMTP id m20-20020a05600c4f5400b003dff3cbe8cbmr169314wmq.4.1675776146729;
        Tue, 07 Feb 2023 05:22:26 -0800 (PST)
Received: from google.com (44.232.78.34.bc.googleusercontent.com. [34.78.232.44])
        by smtp.gmail.com with ESMTPSA id f9-20020a05600c44c900b003dc4fd6e624sm7065522wmo.19.2023.02.07.05.22.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 05:22:26 -0800 (PST)
Date: Tue, 7 Feb 2023 13:22:11 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 40/45] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <Y+JQg6LSvm5qo3bI@google.com>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-41-jean-philippe@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230201125328.2186498-41-jean-philippe@linaro.org>

Hi Jean,

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

What is the idea of postponing this HVC to attach and don’t call it in
alloc_domain HVC?

Thanks,
Mostafa

