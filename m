Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C37E328C5BC
	for <kvmarm@lists.linux.dev>; Wed,  6 Aug 2025 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754489443; cv=none; b=Mt1Ol0cOk3zr7c32yEsIKDa0Syc9EKy28UqgZypDQEreTA6rRycgm4kloW0iHk28RkfvcRswFnNHCtWOuf9888FEI3T3tRtHQqDnI1RTdnb94dptSbbUIem/vpQeOlHXANKhQeuyFr6zqighLyyFuTKa7Pe+zAGe84KRf8oDXz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754489443; c=relaxed/simple;
	bh=mI4po3rtq8bTqDBPQ2/M/FfMHfYJAJgg+g3qJhjf+sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nWwtUeJo43e075rL/NwWtdO3l+98Af+m0LWE6smJ9M6xUj1AdsMnvo21BItfb57xk1XAwfYoLUbhj8t4yP2x8Z8Z9Tosqlu8j5Xm+C+YT0gnJ+/bkIQW7h29Og1IX56azThdTDjj++yq56Dm5pjUwzJ3WrD2cD3iXxQ6eMr71Lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IQkf1rXx; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IQkf1rXx"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459e497776cso90505e9.0
        for <kvmarm@lists.linux.dev>; Wed, 06 Aug 2025 07:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754489440; x=1755094240; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=S8t5HFUqc+uUOq+DP418Q40OKNx1R/fQImmMod37+pg=;
        b=IQkf1rXx8wGgDpUMUQLVww2trvQtrYWF4DWqh8mDXhpO7jXat2TBc83PYMnbyIwPZX
         +grCy6hy53z1kVGVy4lKOPk7r3c7pTHVmk5gy6L9jeRruXNDWopRbt5QfYy9E4wy/zU8
         Vj4rMLLSRjsSdOw8KId/vkVWNf6d5tzQ9pCZRcDBUnACWh4+NROENoEIACydiPs3F7yv
         JALMSJ8LtEkz2owYCQ95dyRlYg2LgrzMOVQrXsesyIazqiPbRvy7SC55nENWoT7WSKTI
         ZYic3zWfKZXYHdpareZSC6a4ofSivSaZtAKSFYxUxROs2kMcxLn4zJ7UiP0Q3ntDaVj4
         kmpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754489440; x=1755094240;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S8t5HFUqc+uUOq+DP418Q40OKNx1R/fQImmMod37+pg=;
        b=UdTNGX+Uxen2KfattQzKcwyrMN/ug0WhYgzyYJrpXD3FaNyygaqTgJetuiGeKDK2h5
         CBQ4/rqA7CAuu1sukue4TGd970NBlZv8Osjui7pnFuEvCaZXO+0szCR2zDqRDSSfQY0c
         KnB4L4jAanw/pZ1u6IIRinLvqcZ0BoBs/T8Kpsn51hcy2p07KNFXEsLKdz597BdX3UBu
         EbKudrLvD7J1l+XXf2vSkjf5PwMz9t6Ep/GNFsTDvHYiQLO+AIaZOfEHo7C9WhlaNzAj
         /LAnL7dVgI3hazTgJBtjeEYxp5KQMQM6mA677Iad6rI/q3NHRkrzMjW06yABNfPa/diQ
         KQMA==
X-Forwarded-Encrypted: i=1; AJvYcCVbh1Bgf+RFC+FalkaG4r9VHtuH2zo2Q6bsiVzQN5BxMTU+8+oowbs6aSi9Ax3wVM0XMT1VWtA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjF3NJ6c8YwLU9jbtZfzNUZmCYWm7wZBXHx4cddX1VxQ0Etni1
	srj2L4yzMsxzEuRg1XSblHYESK78lQzX5GMzcUno/wKujoZlyvWeL/7UC3gF+yUshg==
X-Gm-Gg: ASbGncuDfvUf2BMYCKmD7EbYbjhWFPJ+4uwWaiq5RW/Swvb1fhMKSdqRgrOS4D9Q3cH
	FgLfjWgMi6dh+6M6gklrxNpZPl5uChQKJGPgiOf7MSO9Ggph96N07TjGkU0WriGW6MdSf9nSAnx
	G35ofpcN81Xwemm3QpqvBwLm5E3nWNfx43n36qJgAF/elz4/wNgWM1eQjh8QQ7jWuBriCDSPooW
	DcIam0Ac74rwfbCOkt/5KUd4WMGB/mxluFpibs4LOfAs5j62KcN7Y2wGYj1jVTaq+KlDvQcugyr
	otGEpX7/hQ2HNaYhwBwmbsCo3Pmgdm6XrpQPZpLZCjv+ctYrBTzSsFifCqBmxVcXXH+wDO5SaFc
	wgjD82EURYPT4ubmK7ln2LYOWMhe/kyOv9RExJWWvV8USGZJFEkq8b1+89qpIWa0PxQ==
X-Google-Smtp-Source: AGHT+IHFwOHplPeniFX/OYHA6MsJidP9FSVHfWws6kd04FRGtTTr89FlkYU0XPDUkpq8hanIQWmrxQ==
X-Received: by 2002:a05:600c:1f10:b0:456:e94:466c with SMTP id 5b1f17b1804b1-459e74b4543mr1411575e9.3.1754489439774;
        Wed, 06 Aug 2025 07:10:39 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459e5843021sm58288915e9.3.2025.08.06.07.10.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Aug 2025 07:10:38 -0700 (PDT)
Date: Wed, 6 Aug 2025 14:10:35 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <aJNiW48DdXIAFz8r@google.com>
References: <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250805175753.GY26511@ziepe.ca>

On Tue, Aug 05, 2025 at 02:57:53PM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 04, 2025 at 02:41:31PM +0000, Mostafa Saleh wrote:
> > > Are you saying the event queue is left behind for the kernel? How does
> > > that work if it doesn't have access to the registers?
> > 
> > The evtq itself will be owned by the kernel, However, MMIO access would be
> > trapped and emulated, here the PoC for part-2 of this series (as mentioned in
> > the cover letter) This is very close to how nesting will work.
> > https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-smmu-v3-part-2/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c#744
> 
> Oh weird, but Ok.
> 
> > > In other words you have two cleanly seperate concerns here, an "pkvm
> > > iommu subsystem" that lets pkvm control iommu HW - and the current
> > > "iommu subsystem" that lets the kernel control iommu HW. The same
> > > driver should not register to both.
> > > 
> > 
> > I am not sure how that would work exactly, for example how would probe_device
> > work, xlate... in a generic way?
> 
> Well, I think it is not so bad actually.
> 
> You just need to call iommu_device_register
> 
> 	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);
> 
> Where 'dev' is always the smmu struct device, even if your current
> probing driver is not the smmu device. That will capture all the iommu
> activity the ACPI/DT says is linked to that dev.
> 
> From there you just make a normal small iommu driver with no
> connection back to the SMMUv3.
> 
> Eg you could spawn an aux device from smmuv3 to do this with a far
> cleaner separation.
> 
> xlate is just calling iommu_fwspec_add_ids() it is one line.

I am not sure I understand, the SMMU driver will register its IOMMU
ops to probe the devices, then faux devices would also register
IOMMU ops for the KVM HVCs?
But that means that all DMA operations would still go through the
SMMU one?

> 
> > same for other ops. We can make some of these
> > functions (hypercalls wrappers) in a separate file. 
> 
> What other ops are you worried about?
> 
> static struct iommu_ops arm_smmu_ops = {
> 	.identity_domain	= &arm_smmu_identity_domain,
> 	.blocked_domain		= &arm_smmu_blocked_domain,
> 	.release_device		= arm_smmu_release_device,
> 	.domain_alloc_paging_flags = arm_smmu_domain_alloc_paging_flags,
> 
> 	^^ Those are all your new domain type that does the hypercalls
> 
> 	.probe_device		= arm_smmu_probe_device,
> 	.get_resv_regions	= arm_smmu_get_resv_regions,
> 
>   	^^ These are pretty empty
> 
> 	.device_group		= arm_smmu_device_group,
> 	.of_xlate		= arm_smmu_of_xlate,
> 
>         ^^ Common code
> 
> Don't need these:
> 
> 	.capable		= arm_smmu_capable,
> 	.hw_info		= arm_smmu_hw_info,
> 	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
> 	.page_response		= arm_smmu_page_response,
> 	.def_domain_type	= arm_smmu_def_domain_type,
> 	.get_viommu_size	= arm_smmu_get_viommu_size,
> 	.viommu_init		= arm_vsmmu_init,
> 	.user_pasid_table	= 1,
> 	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
> 	.owner			= THIS_MODULE,

Makes sense, thanks for the detailed explanation.

> 
> > Also I am not sure how that
> > looks from the kernel perspective (do we have 2 struct devices per SMMU?)
> 
> I think you'd want to have pkvm bound to the physical struct device
> and then spawn new faux, aux or something devices for the virtualized
> IOMMUs that probes the new paravirt driver. This driver would be fully
> self contained.

I think it’s hard to reason about this as 2 devices, from my pov it seems
that the pKVM HVCs are a library that can be part of separate common file,
then called from drivers. (with common ops)
Instead of having extra complexity of 2 drivers (KVM and IOMMU PV).
However, I can see the value of that as it totally abstracts the iommu ops
outside the device specific code, I will give it more thought.
But it feels that might be more suitable for a full fledged PV
implementation (as in RFC v1 and v2).

> 
> > I think we are on the same page about how that will look at the end.
> > For nesting there will be a pKVM driver (as mentioned in the cover letter)
> > to probe register the SMMUs, then it will unbind itself to let the
> > current
> 
> That sounds a little freaky to me. I guess it can be made to work, and
> is maybe the best option, but if this is the longterm plan then
> starting out with a non-iommu subsystem pkvm driver seems like a good
> idea.
> 
> Today the pkvm driver would do enough to boot up pkvm in this limited
> mode, and maybe you have some small code duplications with the iommu
> driver. It forks off a aux device to create the para-virt pkvm iommu
> subsystem driver.
> 
> Tomorrow you further shrink down the pkvm driver and remove the
> para-virt driver, then just somehow bind/unbind the pkvm one at early
> boot.
> 
> Minimal changes to the existing smmu driver in either case.
> 
> > Then the hypervisor driver will use trap and emulate to handle SMMU access
> > to the MMIO, providing an architecturally accurate SMMUv3 emualation, and
> > it will not register iommu_ops.
> 
> Well, it registers normal smmuv3 ops only, I think you mean.

I mean when nesting is added, the arm-smmu-v3-kvm, will not call
“iommu_device_register”

> 
> > So, I will happily drop the hypercalls and the iommu_ops from this series,
> > if there is a better way to enlighten the hypervisor about the SIDs to be
> > in identity.
> 
> The iommu ops are a reasonable and appropriate way to do this.
> 
> But since pkvm is all so special anyhow maybe you could hook
> pci_enable_device() and do your identity hypercall there? Do you
> already trap the config write to catch Bus Master Enable? Can pkvm
> just set identity when BME=1 and ABORT when BME=0?

pKVM doesn’t trap actual device access, also we have to support
platform devices, so it would be better to rely on existing
abstractions as “probe_device”


I had an offline discussion with Will and Robin and they believe it might
be better if we get rid of the kernel KVM SMMUv3 driver at all, and just
rely on ARM_SMMU_V3 + extra hooks, so there is a single driver managing
the SMMUs in the system.
This way we don’t need to split current SMMUv3 or have different IOMMU ops,
and reduces some of the duplication, also that avoids the need for a fake device.

Then we have an extra file for KVM with some of the hooks (similar to the
hooks in arm_smmu_impl_ops we have for tegra)

And that might be more suitable for nesting also, to avoid the bind/unbind flow.

I will investigate that and if feasible I will send v4 (hopefully
shortly) based on this idea, otherwise I will see if we can separate
KVM code and SMMU bootstrap code.


Thanks,
Mostafa

> 
> Jason
