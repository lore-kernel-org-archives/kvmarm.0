Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2810391845
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 19:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788377432; cv=none; b=mnrpUUKk0r2GZXRtpV2PLRHkogR4BMtd6iLmDEratku+J3spVHV6alRgWlDsPQt5EQzh1ER/XXk9pFhddRQ5liCg2BFhHyNZdwA/UWT1wjfHyPrh5nodK7byuvdIxxVBDjEsZsSYbHYQJA4peRNeHHxhJrEtxgkwNG7qlFObhMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788377432; c=relaxed/simple;
	bh=QPIN/gKPbaSLDSkUlr0NinR5rDcxPaXfaMpm7jSHSJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AsC8o7hjQ3cSwsMIxN1JOx+r4cCefjMQDYRmhZyCSTyX+MCc1H26hYpmFfR8T3k1reGzx1HBjWkJMqv0DvUJXcBt3vDovDGRIV+oo+cm/OJE7yR61e8dV97uKkT3thbE69uuMZ8t6KXxs86vgTmJUZM4k1R+yAnJZlE6m42mwAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=OUylpBqm; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="OUylpBqm"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-529a1ee0e62so16077841cf.2
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 12:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788377417; x=1788982217; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sEAeYa5lQ0rcwMSktfey6PB78GVtQgWknQk9cva6fPk=;
        b=OUylpBqmyNV3/EKAouvzgQF4W8ZVpixtgrvHsn221AKRfhqX0bgWn/IyutiraPEBBl
         siAtWvKDYif6KSGPWrRb+d4wEYL+IABt4jg+CPVBsWvDN5ZH+5arMqbow+KDC35klBpJ
         tREPXAcdbBKrVazonriRiXI2AzZ1b17eYkRqSd+RBPQvbe+N/9eNWduAKmYKvUsrCzI/
         nAKw+WxCudhxmbIXeBCSsBhIWnXpc84ormepoEsoswnaFjmG1mWlrQFKvbYoXP+BRXBC
         Dlhv2GwR9xtLqVQd08E1fKhRhQEQ6+RivFG9zNz9pDw/PRWtTND9rBe+lr7QDgJT+Fh4
         Nz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788377417; x=1788982217;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sEAeYa5lQ0rcwMSktfey6PB78GVtQgWknQk9cva6fPk=;
        b=E25UCntGfuxVpPoSRA4Q23aXLoEF/a9E6tKTfTSJULrpbXSOEgpDktmjoQXcpqNgEX
         s3KJs03lKyz1I5dff/ySAhmuDOIbHwjM1XyoqHR+SzaloKwQRapo46avxTBqZCEvGDRc
         vpWW2Gfm1LG0KvVBwsuBCmq1F8WGqKXQaVsUsrkdEMmf4yRdsNYsL7z/88xym7u016Qw
         /zvKJOKMknjRiX0gcPO7qysqLzgXXwyFMFn9v14B3w1DuiLiPBl9fJgx8Si6/cdC6uf8
         ilJ/S4ST5ONwmVTE6nfVGiNao/jJS7lK16N/WbsbHkNLmR/P/B6pQjzb11KYTmUkSE/K
         vFLw==
X-Forwarded-Encrypted: i=1; AKwUvBz/6miKauq2yyhL3GckUZqGUis+RThkznWI/VEJ6lnkFoJFKGEn6+kY1GVbgRghqPQeMq53UU4=@lists.linux.dev
X-Gm-Message-State: AFuF++lcESjuLfclaXZNFlTh/i6rrR88hYLvC4cAJIxMN7wnH1XFG7p0
	DO8rox752fIZFDQzAN2RQo2XZoxy0V72rV6HzdPc5nHU/8wSN54gMLLq1s6jg/hgx48=
X-Gm-Gg: AYBFou2OZVXwB7Qv2w2W0HDY/ZI30ELbEvAqGgSKuaePt65QWafNZ6T6QxRoiRCiwSq
	BmGFMYkGSriYvazcD9CKHzyuWuR9oVS0eRsSYg9V8Q3NpOCHtVPiooN+9Sw2LEb27ZLmipvNnLb
	AsEyiEcn8h9+khb8TvzicfgXsT0g1w6HLlNapoYtYxPQwHP4Z6YHL1u0TVYyVhhn8ej8F6zwrlA
	CRZK3MSt50FksfoqdXNO3jC3F3cFwqBN/8bSfqtxPHyEx0EoVuRy0QgKeb4xI/Z7qryyHbjoKxN
	IlF4+u9V4hKiGJZO184BGnMFIuRKyPK5Lvmq+MJXQmR2YMxM7tlkRutz7F6gIoBNK1BVnFO7XrI
	UeVfO9W8JzwrQW5yqN09Rn6tLbXhHWqkawu6tlnyT/51SEIv8eW/tqWGpWSdRuST1CiCVunQJ0h
	4GynQRk2qL1e88IPtbtfUwKJxidbuBfM/dsIJ+9UcWprOXIBabfmbwo4kRn++xjaAfUX99Vaet2
	nbTDEVPwR8F0oBnBgUln3O+katJgxNvbhWl90tsYDmclvzCBoCk585H
X-Received: by 2002:a05:622a:4113:b0:51c:2135:b00a with SMTP id d75a77b69052e-53036d7218fmr97850401cf.40.1788377416278;
        Wed, 02 Sep 2026 12:30:16 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9eec8099sm25200306d6.30.2026.09.02.12.30.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:30:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1qf0-0000000Ez4Y-3Ck6;
	Wed, 02 Sep 2026 16:30:14 -0300
Date: Wed, 2 Sep 2026 16:30:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Nicolin Chen <nicolinc@nvidia.com>, linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>, Xu Yilun <yilun.xu@linux.intel.com>
Subject: Re: [RFC PATCH v4 03/16] iommu/arm-smmu-v3: Add initial pSMMU realm
 viommu plumbing
Message-ID: <20260902193014.GF2890729@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
 <20260902121700.GC2890729@ziepe.ca>
 <yq5aik4nztdt.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aik4nztdt.fsf@kernel.org>

On Wed, Sep 02, 2026 at 06:45:42PM +0530, Aneesh Kumar K.V wrote:

> To reiterate, for this configuration:
> 
> - The viommu will use a stage-1 bypass configuration.
> - A new IOMMU_VIOMMU_TYPE_ARM_REALM_SMMUV3 type will create the viommu.
>   The psmmu will be activated at this point to avoid creating psmmu
>   objects early. We will reference-count it to ensure that the same
>   psmmu is shared across realm guests.
> - Creating a vdevice will invoke SMC_RMI_PSMMU_ST_L2_CREATE.
> 
> I am unclear about the vdev_create suggestion. Creating a vdevice
> requires an RD, which is created later in the flow above. How do you
> suggest linking vdevice_alloc to vdev_create?

I was thinking we'd make sure the KVM is associated with the viommu
and/or possibly the S2 domain. That was always sort of broadly the
idea in this space. There are several topics unrelated to CC that
needed this.
In any case, when you create the iommufd viommu you should also do
VSMMU_CREATE which needs the RD. It seems reasonable to assume the RD
is available during vdevice create.

[There is an aside here I will mention: several other use cases need
this idea of an "external" domain where the HWPT would be created but
not controlled by iommufd or the iommu subsystem. Xen and Hyperv for
example. There is probably some merit in thinking more about exactly
what the nested parent domain should be for this viommu, but it isn't
critical.]

> From the RMM's perspective, the sequence is as follows:
>
> viommu alloc
>
> [   rmm ] SMC_RMI_PSMMU_ACTIVATE            2b400000 8819bb000 > RMI_INCOMPLETE 0 10008
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 881bac098 1 > RMI_INCOMPLETE 2 10004
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 881bac098 1 > RMI_INCOMPLETE 1 10004
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 881bac098 1 > RMI_INCOMPLETE 1 0
> [   rmm ] L1 StrTab: PA 0x881baa000 VA 0x80003c0000 size 0x2000
> [   rmm ] CMDQ: PA 0x88066a000 VA 0x80003c2000
> [   rmm ] EVTQ: PA 0x8815c5000 VA 0x80003c3000
> [   rmm ] PSMMU 0x2b400000 activated
> [   rmm ]       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
>
> [   rmm ] SMC_RMI_PSMMU_ST_L2_CREATE        2b400000 300 > RMI_INCOMPLETE 0 10004
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 881bac098 1 > RMI_INCOMPLETE 1 0
> [   rmm ] smmu->strtab_base[12] 0x0 @0x80003c0060
> [   rmm ] L1STD[12] 0x8819bb007 for SID 0x300: L2 table VA 0x80003d0000 PA 0x8819bb000
> [   rmm ]       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0

What was this one for during viommu alloc?

> vdevice alloc
> 
> [   rmm ] SMC_RMI_PSMMU_ST_L2_CREATE        2b400000 200 > RMI_INCOMPLETE 0 10004
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 882648098 1 > RMI_INCOMPLETE 1 0
> [   rmm ] smmu->strtab_base[8] 0x0 @0x80003c0040
> [   rmm ] L1STD[8] 0x882506007 for SID 0x200: L2 table VA 0x80003cc000 PA 0x882506000
> [   rmm ]       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0
> 
> RD gets allocated here
> 
> [   rmm ] SMC_RMI_REALM_CREATE              881b03000 8819a1000 > RMI_INCOMPLETE 0 24
> [   rmm ]       SMC_RMI_OP_MEM_DONATE       0 881605098 9 > RMI_INCOMPLETE 9 0
> [   rmm ]       SMC_RMI_OP_CONTINUE         0 0 > RMI_SUCCESS 0 0

Why? The VMM needs to create the kvm before starting the iommu stuff.

I would expect that KVM knows it is going to a realm very early on? I
had assumed the RD would also be created early by KVM?

What triggers RD creation? Why can't the VMM do it earlier?

Your followup said:
  - The realm is created during viommu allocation, ensuring that the
    vSMMU can be created here.

Do you mean the SMMUv3 driver triggers RD creation? That feels
wrong. Did you mean the VMM just does it earlier?

The draft in the next message looks promising, did you discover any
other gotchas when exploring it?

When you repost this can you take some care to explain the general
idea of this modelling in the commit messages so AMD and Intel can
confirm they can use it for both their non-viommu and viommu cases?

Thanks,
Jason
