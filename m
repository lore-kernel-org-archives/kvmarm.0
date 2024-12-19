Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348681FCCF3
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 14:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734618254; cv=none; b=UZswf2H8XHHnldjbGEC1TaYNCQpL+ChxRq7xtmgkccVCiBt1xpugJduT/fQk9vW8xYNMCJQegvoAzb5Nheq+j+vutof3B4zdRGCaEDMFwRR4PjQVnpqcun/J5UaSod6itM6Vny8dYU7oE1KG9bMbxLHSR6Yzd/7GlrtQIR0YnfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734618254; c=relaxed/simple;
	bh=BPob3r66xo8dFDNqEidWe3lsaIV/5JdDt3161Tki7hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pd3wgY4uI7UUkbBCXngQ4AMAfJ9L8xwv4IyrT6MAAiima9K+S5C7MtU/W+XevvJ8lK8EeyDhdDGtj6a7qTgGpr7DZjnp2nC0kro+b1ZfHmXIJZ6jEK+l96qtagXyaqKhIanTf+JbNeA0ZUu8+3iJ9v3fCR+PRf8OWk2eJ47jOvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DViSgdh0; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DViSgdh0"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-435b0df5dbdso58065e9.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 06:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1734618250; x=1735223050; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0mF0heT2EsQndTEIg+1n0gHprFJ8BxQdp0xOf3Xlv8A=;
        b=DViSgdh0chanOYst07qZnk2sVHOmpw8ILDgYi569+sG7+WFtg0yPanLUwTGnKNMmjo
         QFTiyiCn4BSewRyR5S4dNNoGAHu/ZccphCuddpYRsw/T3WeYAviphU1j5N+/HSCsk+Mo
         PTSqA/Psi6U4Kai8W/4OhiwFM3JzmIifo9Wkgvo8+WYP7RnT7KMqYJshAY5mcYBTDEZj
         R8fJdrjt+vCsJRj95vE0F+QZeMdD/6ds1YidTWHxD07YOUHwW9Nl05VOh1HY8DQ7G7AL
         wNnq+CqE+3qauqrXFXed83u2vz3FtcrAGqdfGZi4V0GMiJiVc4oIzOO94Nbfs5p8u7Vp
         t8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734618250; x=1735223050;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0mF0heT2EsQndTEIg+1n0gHprFJ8BxQdp0xOf3Xlv8A=;
        b=lzOwOD7RqGrtIVpzD40WFZCgFvoM2TjP4Cs3tB6/2S48+4GyS6v9gm/mK5riiSRmms
         g4ea8K+43PADS+2MFkgb/is0CaxKZHoie76f7SATsdvhA/JEJyK8s8Qx6S2RUDJGaPjq
         vWKZY7UTYmfAy3NLPepMBS5maVhvVv1koB/mQ7vTediiVNN3UxHZDT5FzsIg1ZkQ4O+C
         /iVReoytG5zEwHV9/JLGOApZUYn/pmrPdFa9VLWF3Xytuau3ny6HT2pe3f5cRXmEnyom
         r1/A9CQrd/NuVK89BbwIWdjK8c9GBxZUmLUruQcFHuOR+XTLQqpSb4SeLQszmq927xU4
         paFg==
X-Forwarded-Encrypted: i=1; AJvYcCU3hf8lpIOhIiB8zom3SHnRhqmIXwwAvuGHpR/Scn+0WyhM0QNrtv49RjfyVfY3xFcBegvy+Kc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyF/QYQXqO1Ax06Vdno1G1S5sL7uB32ERLCFiMlf+kMVfDgYFJ4
	fx9GreL0PkIdyplkti+fU1fnR3zJcCDKpl7iq40igmokMFGx+zRAPFqWCVTNyA==
X-Gm-Gg: ASbGncvw8fPwhUM+tBBrfzBYDghic1mX/6rIpE2VO6b7lmBPEXfkv36xgC80o0qVEC5
	YWJLsl+wPIYNaagJtD7yFZfHL39MfmHZJBX7A9S1ILG6chLvkP2EabWAjmpCm4T9QMNHLc534xh
	vw6uJNexntcvEv0AYkN5g2OeoxZUjIff5Aa7bB/+32TUufJNbdgZroNudN9Wl/mIAQZchAW4qTp
	Agr25NCu/yctMplqBe9rYDl8FlB0iinlB8wUf6XF6YQEHmOC3w7vwYuru8u0bIXuBOB/Ba/FwLx
	0A1Vf3LVvUsiAeepHl8=
X-Google-Smtp-Source: AGHT+IFPdnsOq4Xdu3lmcHrohZg3ZaDg9fAxDEjwde7d0y24seJ+Gf3Cv6GehVm5ybmSKZZ/QDT42w==
X-Received: by 2002:a05:600c:1c21:b0:436:186e:13a6 with SMTP id 5b1f17b1804b1-4365e6f26b9mr1380595e9.6.1734618250380;
        Thu, 19 Dec 2024 06:24:10 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c829235sm1658623f8f.15.2024.12.19.06.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2024 06:24:09 -0800 (PST)
Date: Thu, 19 Dec 2024 14:24:05 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: iommu@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, robdclark@gmail.com, joro@8bytes.org,
	jean-philippe@linaro.org, jgg@ziepe.ca, nicolinc@nvidia.com,
	vdonnefort@google.com, qperret@google.com, tabba@google.com,
	danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 55/58] drivers/iommu: Add deferred map_sg
 operations
Message-ID: <Z2Qshft8lQjI-x7c@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-56-smostafa@google.com>
 <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>

Hi Robin,

On Thu, Dec 19, 2024 at 12:48:27PM +0000, Robin Murphy wrote:
> On 2024-12-12 6:04 pm, Mostafa Saleh wrote:
> > With pKVM SMMUv3 driver which para-virtualizes the IOMMU in the
> > hypervisor, has an extra overhead with map_sg, as it loops over
> > iommu_map, and for each map requires context switching, disabling
> > interrupts...
> > 
> > Instead, add an new domain operations:
> > - alloc_cookie_sg: Allocate a new sg deferred cookie
> > - add_deferred_map_sg: Add a mapping to the cookie
> > - consume_deferred_map_sg: Consume and release the cookie
> > 
> > Alternativly, we can pass the sg list as is. However, this would
> > duplicate some of the logic and it would make more sense to
> > conolidate all the sg list parsing for IOMMU drivers in one place.
> 
> But why bother with fiddly overly-specific machinery at all when you can
> already make ->map_pages asynchronous and consolidate the expensive part
> into ->iotlb_sync_map in general, like s390 does?

This was my initial idea too. But I believe there is no enough context in
iotlb_sync_map, so we either have to create a per-domain deferred_map list
which is synced on any iotlb_sync_map, but that would require to lock the
map operation, hence impacting concurrency.

Or we have to use some complex logic to extract context from iotlb_sync_map,
(something like range iova tree in map and then on sync we can retrieve that)
That’s why I proposed this approach, where the IOMMU subsystem by design is
aware of the semantics and “helps” by providing the right data structures/calls.

I had a quick look now at s390, and it seems a bit different as they only
notify the hypervisor about the iova range being changed, and don’t need
to provide iova->paddr mapping which pKVM does.

Thanks,
Mostafa
> 
> Thanks,
> Robin.
> 
> > virtio-iommu is another IOMMU that can benfit from this, but it
> > would need to have a new operation that standerdize passing
> > an sglist based on these ops.
> > 
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > ---
> >   drivers/iommu/iommu.c | 53 +++++++++++++++++++++++++++++++++++++++++--
> >   include/linux/iommu.h | 19 ++++++++++++++++
> >   2 files changed, 70 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index 83c8e617a2c5..3a3c48631dd6 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -2608,6 +2608,37 @@ size_t iommu_unmap_fast(struct iommu_domain *domain,
> >   }
> >   EXPORT_SYMBOL_GPL(iommu_unmap_fast);
> > +static int __iommu_add_sg(struct iommu_map_cookie_sg *cookie_sg,
> > +			  unsigned long iova, phys_addr_t paddr, size_t size)
> > +{
> > +	struct iommu_domain *domain = cookie_sg->domain;
> > +	const struct iommu_domain_ops *ops = domain->ops;
> > +	unsigned int min_pagesz;
> > +	size_t pgsize, count;
> > +
> > +	if (unlikely(!(domain->type & __IOMMU_DOMAIN_PAGING)))
> > +		return -EINVAL;
> > +
> > +	if (WARN_ON(domain->pgsize_bitmap == 0UL))
> > +		return -ENODEV;
> > +
> > +	/* find out the minimum page size supported */
> > +	min_pagesz = 1 << __ffs(domain->pgsize_bitmap);
> > +
> > +	/*
> > +	 * both the virtual address and the physical one, as well as
> > +	 * the size of the mapping, must be aligned (at least) to the
> > +	 * size of the smallest page supported by the hardware
> > +	 */
> > +	if (!IS_ALIGNED(iova | paddr | size, min_pagesz)) {
> > +		pr_err("unaligned: iova 0x%lx pa %pa size 0x%zx min_pagesz 0x%x\n",
> > +		       iova, &paddr, size, min_pagesz);
> > +		return -EINVAL;
> > +	}
> > +	pgsize = iommu_pgsize(domain, iova, paddr, size, &count);
> > +	return ops->add_deferred_map_sg(cookie_sg, paddr, pgsize, count);
> > +}
> > +
> >   ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
> >   		     struct scatterlist *sg, unsigned int nents, int prot,
> >   		     gfp_t gfp)
> > @@ -2617,6 +2648,9 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
> >   	phys_addr_t start;
> >   	unsigned int i = 0;
> >   	int ret;
> > +	bool deferred_sg = ops->alloc_cookie_sg && ops->add_deferred_map_sg &&
> > +			   ops->consume_deferred_map_sg;
> > +	struct iommu_map_cookie_sg *cookie_sg;
> >   	might_sleep_if(gfpflags_allow_blocking(gfp));
> > @@ -2625,12 +2659,24 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
> >   				__GFP_HIGHMEM)))
> >   		return -EINVAL;
> > +	if (deferred_sg) {
> > +		cookie_sg = ops->alloc_cookie_sg(iova, prot, nents, gfp);
> > +		if (!cookie_sg) {
> > +			pr_err("iommu: failed alloc cookie\n");
> > +			return -ENOMEM;
> > +		}
> > +		cookie_sg->domain = domain;
> > +	}
> > +
> >   	while (i <= nents) {
> >   		phys_addr_t s_phys = sg_phys(sg);
> >   		if (len && s_phys != start + len) {
> > -			ret = __iommu_map(domain, iova + mapped, start,
> > -					len, prot, gfp);
> > +			if (deferred_sg)
> > +				ret = __iommu_add_sg(cookie_sg, iova + mapped, start, len);
> > +			else
> > +				ret = __iommu_map(domain, iova + mapped, start,
> > +						  len, prot, gfp);
> >   			if (ret)
> >   				goto out_err;
> > @@ -2654,6 +2700,9 @@ ssize_t iommu_map_sg(struct iommu_domain *domain, unsigned long iova,
> >   			sg = sg_next(sg);
> >   	}
> > +	if (deferred_sg)
> > +		ops->consume_deferred_map_sg(cookie_sg);
> > +
> >   	if (ops->iotlb_sync_map) {
> >   		ret = ops->iotlb_sync_map(domain, iova, mapped);
> >   		if (ret)
> > diff --git a/include/linux/iommu.h b/include/linux/iommu.h
> > index c75877044185..5e60ac349228 100644
> > --- a/include/linux/iommu.h
> > +++ b/include/linux/iommu.h
> > @@ -601,6 +601,14 @@ struct iommu_ops {
> >   	u8 user_pasid_table:1;
> >   };
> > +/**
> > + * struct iommu_map_cookie_sg - Cookie for a deferred map sg
> > + * @domain: Domain for the sg lit
> > + */
> > +struct iommu_map_cookie_sg {
> > +	struct iommu_domain *domain;
> > +};
> > +
> >   /**
> >    * struct iommu_domain_ops - domain specific operations
> >    * @attach_dev: attach an iommu domain to a device
> > @@ -638,6 +646,11 @@ struct iommu_ops {
> >    * @enable_nesting: Enable nesting
> >    * @set_pgtable_quirks: Set io page table quirks (IO_PGTABLE_QUIRK_*)
> >    * @free: Release the domain after use.
> > + * @alloc_cookie_sg: Allocate a cookie that would be used to create
> > + *		     a sg list, filled from the next functions
> > + * @add_deferred_map_sg: Add a mapping to a cookie of a sg list.
> > + * @consume_deferred_map_sg: Consume the sg list as now all mappings are added,
> > + *			     it should also release the cookie as it's not used.
> >    */
> >   struct iommu_domain_ops {
> >   	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
> > @@ -668,6 +681,12 @@ struct iommu_domain_ops {
> >   				  unsigned long quirks);
> >   	void (*free)(struct iommu_domain *domain);
> > +
> > +	struct iommu_map_cookie_sg *(*alloc_cookie_sg)(unsigned long iova, int prot,
> > +						       unsigned int nents, gfp_t gfp);
> > +	int (*add_deferred_map_sg)(struct iommu_map_cookie_sg *cookie,
> > +				   phys_addr_t paddr, size_t pgsize, size_t pgcount);
> > +	int (*consume_deferred_map_sg)(struct iommu_map_cookie_sg *cookie);
> >   };
> >   /**
> 
