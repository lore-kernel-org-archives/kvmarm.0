Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5BA6293B5E
	for <kvmarm@lists.linux.dev>; Tue,  5 Aug 2025 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754416677; cv=none; b=pdRrKTR9Bic9mWb/aoCjlRyuVEmUtRvVELFYv2uiq0SbsllMkpyzPtSAzTPaPlvDZnP+BRfl+GO85OvMdbAY/5isz+RvvKy90dBoMNOlS7Qox/M193/QfK9Hz1a3PrbBl9ZB+ecd0t+Sc89zimcKgapSQlKWZv80U1ckAbMU4co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754416677; c=relaxed/simple;
	bh=JZhU2+1vxgdXAz7jE/s8j1dlHcHijdbJfKTzDTT+BhA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rTy1+IfiWbQsoJ64aUk//LBAHC9eAhmyX8muoizZigTxcj7Kw0iy3gTY/WIiA4/Bw9wYAh+ZW6GYTDb9Vny7Ixui163s0LveBrtw5NlbxKE8W20cxZiNgY7cu7qEM4PfLxtjmpEOjnNu0czzQB0rhIiIBLhO74d1PUjaBOjTark=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=DCQjbIxc; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="DCQjbIxc"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-7e182e4171bso489565085a.3
        for <kvmarm@lists.linux.dev>; Tue, 05 Aug 2025 10:57:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1754416674; x=1755021474; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F9Lrb8raU1rOL/1BQQhDKfgxN9mYfLFp5sfiFKeG3uI=;
        b=DCQjbIxcHnOar2zg96l4TW5INi7JZb4KofDe39sCFaJoT3NveXBZKB/zkl7fKJ0mKo
         dXW6s4KX4JgVlSxMW5+/qzZ8o6EKtgA/7hGtbsSMAz+4Gm+Djh3LoLiHj2Fo8nc2UTWR
         xtkU2zfnOfp58RNuslPneg7OOq1CZOotV0XbC5n0Bl1/mXFbnEBzcuuCiSzbn6EeGY7u
         xC+kyt6vztqilb9seTV3ZmpFWP5omPUMFKUx+YsO8w3R1Zylfko+XqDxkeJaJCTOH8Hh
         nY8JdaLuPPMMdNP1jsFJM4VRWK7OTJP3LieFtr3yfhnjYoiWb7FJTWJ7jemWfyX0XBy5
         CLtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754416674; x=1755021474;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F9Lrb8raU1rOL/1BQQhDKfgxN9mYfLFp5sfiFKeG3uI=;
        b=YoIgKDgCIlbyqP53LAIAFs84H9tmTv1fvOb/fZvQml7PnHKFWhz1NFVcosl0oTZHwu
         uX1xugIpMvDCiwA0WYuA+gJdfdDKS8XYvE+6YXMDXRxpj36oLkZqlR2t0dCDwEsHC+R4
         5pcVWjGzq/AwAE21+Gx54RX19dMpruReTnvJRP4AiaG9wOnoDCB/YOeZ3fqrbk448Fc9
         NsvDsVPCi8SZxTlLH/hKjNj9DuBcMblpgM2icg7c8PUtIc6X/WSmLigWDlzBQUNSvG10
         SHgMX7ckB+fHybIhkzMZNNTAHxTV2S8isWiiqCugXmPAvp4xO8sGDdRZzQiVK0qdh8u/
         uRqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSjPo60z3bM2N/DfAVg4JjtQSc2TkyUMmg7lrdZL8WazhC6tJDhm3dt6E4FCodOMyHFwtu5+8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwAizDROdr2xxvSXTx/7d0xiEew01KqN2+PSDHelA57uVgzuNXe
	aqlUnEZcU6xeMujHdnMFKc1QmFCGadfTfRySlphpI3hCWdU1qU3g6fCiu9P8BCGb1Eo=
X-Gm-Gg: ASbGncudiXZFTOI+lnm4QBXqlOBEocMTNYgpCeDh0p0TWnvdOn5HgByhaorr6i0Q4jE
	/sMK4HmjcyoHd+kPMbRNCkZtL5Ey5Ul+QSTp84TnaGOXH54//S7B2k3S23cSf+nQwA8PIvGMd6f
	gdubulWUuxa2woSZvum/hndksb06wxBfX4kRslorJ039i/4RFdyBKa2CmcWtA3yLlzrCldBoeOB
	4SXvki4oYUkDcGJ6U6QyBH5ctsWZPQSLVUIvN+HRyv5wTgXeUF7KGk/Jn74+NH5oEuaZtx9Dnsz
	kzXt/0+A1giBZcR6YDFwtP144lJguYa7YArFZB6d7MGPO23xxb4j0rA+4s2VMNYavLsyZVoJzGx
	p1B3MD4ISyZYSuDizPU3ZrMWH1RrLez72jMp79RU6870xx8NImbNqpdtKEN+gQjAaDNgF
X-Google-Smtp-Source: AGHT+IGE5ERjj9D3VCjcEiKXdj9UhaaZiZPpSWlP7T6HKiKWYrHGgc5JWaH3dvBy9gtMCFsNCYW/Rg==
X-Received: by 2002:a05:620a:28ce:b0:7e6:9753:db16 with SMTP id af79cd13be357-7e814d03585mr36631185a.14.1754416674276;
        Tue, 05 Aug 2025 10:57:54 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7e7f7e277besm338203385a.57.2025.08.05.10.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Aug 2025 10:57:53 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1ujLv7-00000001Zhc-0EXt;
	Tue, 05 Aug 2025 14:57:53 -0300
Date: Tue, 5 Aug 2025 14:57:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <20250805175753.GY26511@ziepe.ca>
References: <20250728175316.3706196-1-smostafa@google.com>
 <20250728175316.3706196-30-smostafa@google.com>
 <20250730144253.GM26511@ziepe.ca>
 <aIo1ImP7R7VhRpVE@google.com>
 <20250730164752.GO26511@ziepe.ca>
 <aIt67bOzp6XS_yO-@google.com>
 <20250731165757.GZ26511@ziepe.ca>
 <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJDGm02ihZyrBalY@google.com>

On Mon, Aug 04, 2025 at 02:41:31PM +0000, Mostafa Saleh wrote:
> > Are you saying the event queue is left behind for the kernel? How does
> > that work if it doesn't have access to the registers?
> 
> The evtq itself will be owned by the kernel, However, MMIO access would be
> trapped and emulated, here the PoC for part-2 of this series (as mentioned in
> the cover letter) This is very close to how nesting will work.
> https://android-kvm.googlesource.com/linux/+/refs/heads/for-upstream/pkvm-smmu-v3-part-2/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c#744

Oh weird, but Ok.

> > In other words you have two cleanly seperate concerns here, an "pkvm
> > iommu subsystem" that lets pkvm control iommu HW - and the current
> > "iommu subsystem" that lets the kernel control iommu HW. The same
> > driver should not register to both.
> > 
> 
> I am not sure how that would work exactly, for example how would probe_device
> work, xlate... in a generic way?

Well, I think it is not so bad actually.

You just need to call iommu_device_register

	ret = iommu_device_register(&smmu->iommu, &arm_smmu_ops, dev);

Where 'dev' is always the smmu struct device, even if your current
probing driver is not the smmu device. That will capture all the iommu
activity the ACPI/DT says is linked to that dev.

From there you just make a normal small iommu driver with no
connection back to the SMMUv3.

Eg you could spawn an aux device from smmuv3 to do this with a far
cleaner separation.

xlate is just calling iommu_fwspec_add_ids() it is one line.

> same for other ops. We can make some of these
> functions (hypercalls wrappers) in a separate file. 

What other ops are you worried about?

static struct iommu_ops arm_smmu_ops = {
	.identity_domain	= &arm_smmu_identity_domain,
	.blocked_domain		= &arm_smmu_blocked_domain,
	.release_device		= arm_smmu_release_device,
	.domain_alloc_paging_flags = arm_smmu_domain_alloc_paging_flags,

	^^ Those are all your new domain type that does the hypercalls

	.probe_device		= arm_smmu_probe_device,
	.get_resv_regions	= arm_smmu_get_resv_regions,

  	^^ These are pretty empty

	.device_group		= arm_smmu_device_group,
	.of_xlate		= arm_smmu_of_xlate,

        ^^ Common code

Don't need these:

	.capable		= arm_smmu_capable,
	.hw_info		= arm_smmu_hw_info,
	.domain_alloc_sva       = arm_smmu_sva_domain_alloc,
	.page_response		= arm_smmu_page_response,
	.def_domain_type	= arm_smmu_def_domain_type,
	.get_viommu_size	= arm_smmu_get_viommu_size,
	.viommu_init		= arm_vsmmu_init,
	.user_pasid_table	= 1,
	.pgsize_bitmap		= -1UL, /* Restricted during device attach */
	.owner			= THIS_MODULE,

> Also I am not sure how that
> looks from the kernel perspective (do we have 2 struct devices per SMMU?)

I think you'd want to have pkvm bound to the physical struct device
and then spawn new faux, aux or something devices for the virtualized
IOMMUs that probes the new paravirt driver. This driver would be fully
self contained.

> I think we are on the same page about how that will look at the end.
> For nesting there will be a pKVM driver (as mentioned in the cover letter)
> to probe register the SMMUs, then it will unbind itself to let the
> current

That sounds a little freaky to me. I guess it can be made to work, and
is maybe the best option, but if this is the longterm plan then
starting out with a non-iommu subsystem pkvm driver seems like a good
idea.

Today the pkvm driver would do enough to boot up pkvm in this limited
mode, and maybe you have some small code duplications with the iommu
driver. It forks off a aux device to create the para-virt pkvm iommu
subsystem driver.

Tomorrow you further shrink down the pkvm driver and remove the
para-virt driver, then just somehow bind/unbind the pkvm one at early
boot.

Minimal changes to the existing smmu driver in either case.

> Then the hypervisor driver will use trap and emulate to handle SMMU access
> to the MMIO, providing an architecturally accurate SMMUv3 emualation, and
> it will not register iommu_ops.

Well, it registers normal smmuv3 ops only, I think you mean.

> So, I will happily drop the hypercalls and the iommu_ops from this series,
> if there is a better way to enlighten the hypervisor about the SIDs to be
> in identity.

The iommu ops are a reasonable and appropriate way to do this.

But since pkvm is all so special anyhow maybe you could hook
pci_enable_device() and do your identity hypercall there? Do you
already trap the config write to catch Bus Master Enable? Can pkvm
just set identity when BME=1 and ABORT when BME=0?

Jason
