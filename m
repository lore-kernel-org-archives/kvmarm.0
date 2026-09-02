Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A46147F77A
	for <kvmarm@lists.linux.dev>; Wed,  2 Sep 2026 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788351426; cv=none; b=gPq7U3yAdZ4gkxCigWYuRBF+JTCetV+j8Gr7SwLNn88KwQjSYVjHa8IWc/DxEFypS7L2zhLQ82YnhH904/TSqMHxAkBIw86si4GQKo7jsaVYoRCNfJHTlX3FW1T0+lP9bmTEv2+h4IPeiJMomAuKCHhLscUU1OeeKOK91AmR7us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788351426; c=relaxed/simple;
	bh=KiuQi7KyeiZxotF4pe9yz/R7uxutNRVzafURAOqLelg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tXTA98WL/0ijOr8jktUeWdzl0fIvq5722IkbdpNbIuDS7mtVg7p6y5j73nshLWa9As0VrMhE6QCebffLfk+VT8ca1k74T4aAb/1Z1SDJiZi5Dt30FIenfIEaqzoLhYW+SAXioESSrNbl1hH9NXC7NIyD2Tn5QC28f/sIYLuy3KQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=Z1aghS/I; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="Z1aghS/I"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52de50e77ffso10994731cf.2
        for <kvmarm@lists.linux.dev>; Wed, 02 Sep 2026 05:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1788351423; x=1788956223; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WlwW9UoqChuDQG8Ubc8yfsDP24EvYv1xxnKt9rNQ+co=;
        b=Z1aghS/IEorDIQpm+hZy5NzD2fWPVZIKZ74CiWUWo2itxR/kvjUEmJ8GOAhUNTVH3O
         Ndo0X0yV/f1DP15Uys4DggRMycJGh4I/DtjpkIM/Ov5HYRW/pJRvMh/iH/ZkDc0qekpM
         FZk3fGERMWwLqoJbjX3eus+F44WHqRvGr46qLhNR0Hv5xwRGKqdw1cr+VRx1GwUBYj8N
         MssndhvaLID+7Y1/Gp2q/VrnUJTtHWazXZ+RYC6XdTChR8zC5BUMcGBEWUF2lj6T8nft
         3GsEdVDNYPOxHsWVm427Ho/y5Nv0U8KjWTq1aIkH+pkfpY33CXEfMLuPnLZGTqoyiruf
         wzdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788351423; x=1788956223;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WlwW9UoqChuDQG8Ubc8yfsDP24EvYv1xxnKt9rNQ+co=;
        b=PTrEMYAFkCT8+BdXLB4RKbDkEsPZaip81tt8Qwj/78B/BRGPio33U348xtQhVvDiLI
         hxGiDy58pMTgYf7ZOnheyaH+MPWIOV4QjkHcvVHsoOCYj6HjXO6fP4DAtdukxhtyebAP
         cebLQ90S0S+4lOmht0aqbRHr6cO6ggJWdklCdCfvCrWmZvIh0Hgx3uoCE21fzPo9aKes
         EYm2Wu1luYH9dfUEV7p7w1F7Bfy7k6rsfOboxY3PV5KkLCDemAdmxmuFeQZ9okdBEatx
         FXSPmAgbDOSKomwGJX1bMUv3qU7LogMpgfPBDUQZ+25/9NTUpYkvm0pBYYhyss8qHQtj
         S21g==
X-Forwarded-Encrypted: i=1; AHgh+RqmjN//k4p6qX+sabMqEWhlltOGWX0wfmmi+xqch6zG2Lk+kOiMKfzRg34ynGKrURNB0YEfgxw=@lists.linux.dev
X-Gm-Message-State: AFuF++nViw0Vjf59qjEYkGz3d1ljCfh01mK0hDcmn9enSvtjeS2qnPv/
	SCewQvs+j1Kd3NjXMLHPsvu+v8rtCn1LUGasvaQlwtXE2AQxZobaCKQwr7wxC/StiBI=
X-Gm-Gg: AR+sD12rqm18wfYD+oyQLc6b5x7WKNcRHM9bJUbEGVMTO8VQB8/zPAjAM9aqOAx388W
	s837j357zGH3nx1dZ/n+l6RBfPz0RPEnNBhuLvIbCe+aVq6JATcpOQ4uZ2dPmtNSrLfcYGOVgh3
	pP4qeakQJIGql+PyWxCL+0jnbeaOLj+DjQNN2NH56fPXDh8l18vsE23T0XKI/B/eQAOrDJYgr08
	Co4ujTwtYtEMxMbdtk8sHBXtdQNSK2MsUSazs7m3Te5xl9/ibiiosG925A2d09MWBKjHoPBDP1r
	ZkDg+oe8eREGyb58cf6zdY7c79UoIsFSH46kbXc6rS4uClwC5QQN2iL2/vWgmYSBT46dItSRwO7
	e8+mgv9hcHIhcrtqGuiSqlmBhTAKBVk/ND3AoRs1yVevCst4/NGwIt7VjCVSPs/BiWY9VvAc8A0
	h9eKLiXnSJlNat6f5mtqs+BwkThd+4o5bK0oOtN3o58wZnL1iMRJgpv99h0VbduLs4zHhAXJQqp
	oWSRobbmd4kf7yDl61dVwgoBiRihRHXsSwRCN/IgUlnKQ==
X-Received: by 2002:ac8:5d49:0:b0:527:7a5b:ca67 with SMTP id d75a77b69052e-53036cc7263mr48464101cf.20.1788351423074;
        Wed, 02 Sep 2026 05:17:03 -0700 (PDT)
Received: from ziepe.ca (hlfxns010zw-159-2-239-150.pppoe-dynamic.high-speed.ns.bellaliant.net. [159.2.239.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53032ff4e90sm17590961cf.2.2026.09.02.05.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 05:17:01 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1x1jtk-0000000EB68-1U6I;
	Wed, 02 Sep 2026 09:17:00 -0300
Date: Wed, 2 Sep 2026 09:17:00 -0300
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
Message-ID: <20260902121700.GC2890729@ziepe.ca>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
 <20260427085344.941627-4-aneesh.kumar@kernel.org>
 <apM6dOHcEI2ztWS0@nvidia.com>
 <yq5a8q5lz5yn.fsf@kernel.org>
 <yq5aecfdnv4i.fsf@kernel.org>
 <20260901143445.GC56830@ziepe.ca>
 <yq5a8q5kkoz3.fsf@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5a8q5kkoz3.fsf@kernel.org>

On Wed, Sep 02, 2026 at 02:30:00PM +0530, Aneesh Kumar K.V wrote:
> Jason Gunthorpe <jgg@ziepe.ca> writes:
> 
> > On Tue, Sep 01, 2026 at 03:36:37PM +0530, Aneesh Kumar K.V wrote:
> >
> >> @@ -463,14 +460,13 @@
> >>  	vsmmu->vmid = s2_parent->s2_cfg.vmid;
> >>  
> >>  	if (viommu->type == IOMMU_VIOMMU_TYPE_ARM_SMMUV3) {
> >> +		if (arm_smmu_is_realm_viommu(viommu))
> >> +			return arm_realm_smmu_v3_init(viommu, user_data);
> >> +
> >
> > I think the realm vsmmu is going to require a different info struct
> > than the normal psmmu case, isn't it?
> >
> > If so it needs its own enum value.
> >
> > It would be nice to see a draft patch showing how the real vsmmu works
> > on top of the RMM spec for it. If we are using a viommu object then
> > non-vsmmu case should be identical just with an option in the info
> > struct to not create the vsmmu object.
> 
> Based on feedback on other emails in this thread, I have now implemented
> this without using a vdevice or viommu. This should make the CCA and
> non-CCA cases similar.

That wasn't the feedback. The feedback was to use the viommu and not
make a bunch of new stuff..

> +int arm_smmu_realm_tsm_bind(struct device *dev, struct kvm *kvm)
> +{
> +	struct arm_smmu_master *master = dev_iommu_priv_get(dev);
> +	int ret;
> +
> +	if (!kvm_is_realm(kvm))
> +		return 0;
> +
> +	ret = arm_realm_smmu_get(master->smmu);
> +	if (ret)
> +		return ret;
> +
> +	ret = arm_realm_smmu_stream_get(master);
> +	if (ret)
> +		arm_realm_smmu_put(master->smmu);
> +	return ret;

It still makes no sense this doesn't do the VDEV_CREATE too.

> iommufd_device_tsm_op_ioctl()
> 
> 	switch (cmd->type) {
> 	case IOMMU_DEVICE_TSM_BIND:
> 		if (!idev->tsm_iommu_bound && ops->tsm_bind) {
> 			if (WARN_ON_ONCE(!ops->tsm_unbind)) {
> 				ret = -EOPNOTSUPP;
> 				break;
> 			}
> 			ret = ops->tsm_bind(idev->dev, kvm);
> 			if (ret)
> 				break;
> 			idev->tsm_iommu_bound = true;
> 			iommu_bound = true;
> 		}
> 		ret = tsm_bind(idev->dev, kvm, cmd->tdi_id);

Yuk! Now this uAPI doesn't make any sense when you have an actual
viommu involved, we can't take tdi_id from userspace, it must come
from the vdevice.

I don't want two confusingly different flows, this stuff is hard
enough to keep straight.

Your first version was better, we just need to commit to using the
viommu for everyone on every arch and drop the the tsm_bind() API and
IOMMU_DEVICE_TSM_BIND interface.

The only draw back is the VMM has to manage a litte bit more.

Jason
