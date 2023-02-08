Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE7E6AAD
	for <kvmarm@lists.linux.dev>; Wed,  8 Feb 2023 18:14:00 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id j29-20020a05600c1c1d00b003dc52fed235so2144657wms.1
        for <kvmarm@lists.linux.dev>; Wed, 08 Feb 2023 10:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oNJ5A3Ty5RfOKwP8A4xFJY7FSfGB/+iloYR7QbcT/J0=;
        b=tPPumiWuxG18xygNw4FK0EC/9i0SlArRYVm8XVz+xbCsKxKyTyHH3G+ERjs6QfMkx6
         J9OYXNCJrJEojy834HuLxkS6roBvba1/335LtM9yXYtR0BI8HbI3thpf13rivvDi5yS0
         +fZPID2IrFjhM+crXC8BUwK7orWbpNmjBq1l/PfGaEfVLlMW5of6BZE8h9DM4VnndHLM
         hp7V8fY8zAD44kWr/XfKY5C/L9Iv+5Owjtxou57FKabjB9gpn0Jsbahf/c3H2ZcJRHyS
         nKfvLaz0mpDbIQZhIldBcQYuQwd5YVlqA7F3jyjKj7ujfIumo0p0TP4ksGVemNOi1b92
         1hLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oNJ5A3Ty5RfOKwP8A4xFJY7FSfGB/+iloYR7QbcT/J0=;
        b=eEUvA1xJGgQtyTOautzW2HoysdU3QwPQQ5GIFo+jFLYV+uevdQ/rOOQgytir60Q/fs
         sK168m6HKkMA3o9v3lUKgjiITCSbZWf3CTA6oOY8vJfkgRqcmN74EDk13HDApHC0+Qui
         Fol/4JwsFbch4aehVl9D63fRqO/HdZz8qul2vCkEPvU4uPJv0UFiU8zGbR23qzg26I+c
         HeynyqT14/sb0mC4MLMVnu5W3o4ouiV4/aC+I3ezitB7djl+UuWXn/rdxf2qjgUPPioc
         UBSuHVZoubiYV/pYrWVSuJ3x56vTvIFcRqSatnCHW4he6y3Q97KHyqZDmJTTAaYPbzPU
         7J1A==
X-Gm-Message-State: AO0yUKU8bL7dSqAGJM9lNvRescy1Uznw139zYsATYDTVV3F7Hooi3Crn
	xR8vCPk6MyzPAg2CPqu+jzB2uQ==
X-Google-Smtp-Source: AK7set/FUZ0IfMXjf96cZNS3VVO6zWq0Zr59wZ0J4YA0HIR9cXoqhXRPOG7bzj93/0UwEF7UBzxIXQ==
X-Received: by 2002:a05:600c:3088:b0:3df:f860:3089 with SMTP id g8-20020a05600c308800b003dff8603089mr8205057wmn.32.1675880039093;
        Wed, 08 Feb 2023 10:13:59 -0800 (PST)
Received: from myrica (054592b0.skybroadband.com. [5.69.146.176])
        by smtp.gmail.com with ESMTPSA id g16-20020a05600c4ed000b003dfee43863fsm3058502wmq.26.2023.02.08.10.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 10:13:58 -0800 (PST)
Date: Wed, 8 Feb 2023 18:13:53 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: maz@kernel.org, catalin.marinas@arm.com, will@kernel.org,
	joro@8bytes.org, robin.murphy@arm.com, james.morse@arm.com,
	suzuki.poulose@arm.com, oliver.upton@linux.dev,
	yuzenghui@huawei.com, dbrazdil@google.com, ryan.roberts@arm.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	iommu@lists.linux.dev
Subject: Re: [RFC PATCH 40/45] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <Y+PmYQg7mCJNL/Uz@myrica>
References: <20230201125328.2186498-1-jean-philippe@linaro.org>
 <20230201125328.2186498-41-jean-philippe@linaro.org>
 <Y+JQg6LSvm5qo3bI@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y+JQg6LSvm5qo3bI@google.com>

On Tue, Feb 07, 2023 at 01:22:11PM +0000, Mostafa Saleh wrote:
> > +static struct iommu_domain *kvm_arm_smmu_domain_alloc(unsigned type)
> > +{
> > +	struct kvm_arm_smmu_domain *kvm_smmu_domain;
> > +
> > +	/*
> > +	 * We don't support
> > +	 * - IOMMU_DOMAIN_IDENTITY because we rely on the host telling the
> > +	 *   hypervisor which pages are used for DMA.
> > +	 * - IOMMU_DOMAIN_DMA_FQ because lazy unmap would clash with memory
> > +	 *   donation to guests.
> > +	 */
> > +	if (type != IOMMU_DOMAIN_DMA &&
> > +	    type != IOMMU_DOMAIN_UNMANAGED)
> > +		return NULL;
> > +
> > +	kvm_smmu_domain = kzalloc(sizeof(*kvm_smmu_domain), GFP_KERNEL);
> > +	if (!kvm_smmu_domain)
> > +		return NULL;
> > +
> > +	mutex_init(&kvm_smmu_domain->init_mutex);
> > +
> > +	return &kvm_smmu_domain->domain;
> > +}
> > +
> > +static int kvm_arm_smmu_domain_finalize(struct kvm_arm_smmu_domain *kvm_smmu_domain,
> > +					struct kvm_arm_smmu_master *master)
> > +{
> > +	int ret = 0;
> > +	struct page *p;
> > +	unsigned long pgd;
> > +	struct arm_smmu_device *smmu = master->smmu;
> > +	struct host_arm_smmu_device *host_smmu = smmu_to_host(smmu);
> > +
> > +	if (kvm_smmu_domain->smmu) {
> > +		if (kvm_smmu_domain->smmu != smmu)
> > +			return -EINVAL;
> > +		return 0;
> > +	}
> > +
> > +	ret = ida_alloc_range(&kvm_arm_smmu_domain_ida, 0, 1 << smmu->vmid_bits,
> > +			      GFP_KERNEL);
> > +	if (ret < 0)
> > +		return ret;
> > +	kvm_smmu_domain->id = ret;
> > +
> > +	/*
> > +	 * PGD allocation does not use the memcache because it may be of higher
> > +	 * order when concatenated.
> > +	 */
> > +	p = alloc_pages_node(dev_to_node(smmu->dev), GFP_KERNEL | __GFP_ZERO,
> > +			     host_smmu->pgd_order);
> > +	if (!p)
> > +		return -ENOMEM;
> > +
> > +	pgd = (unsigned long)page_to_virt(p);
> > +
> > +	local_lock_irq(&memcache_lock);
> > +	ret = kvm_call_hyp_nvhe_mc(smmu, __pkvm_host_iommu_alloc_domain,
> > +				   host_smmu->id, kvm_smmu_domain->id, pgd);
> 
> What is the idea of postponing this HVC to attach and don’t call it in
> alloc_domain HVC?

Yes ideally this HVC would be in kvm_arm_smmu_domain_alloc() above, but
due to the way the IOMMU API works at the moment, that function doesn't
take a context parameter. So we don't know which SMMU this will be for,
which is problematic. We don't know which page table formats are
supported, how many VMIDs, how to allocate memory for the page tables
(which NUMA node is the SMMU on, can it access high physical addresses or
does it need special allocations?)

I think there are plans to add a context to domain_alloc(), but at the
moment IOMMU drivers complete the domain allocation in attach().

Thanks,
Jean
