Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68547D413
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 16:26:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707409570; cv=none; b=XhC/T4RG0giN1ssBV1cLuwwurfuUySB/T+LI9AOnUqto2SAkA56BG3Wdcj2MTkpck1jvdWega0PDiHyKobJeEDq3eoWKjNYat8RI7l53UcOUk5APv70fbe2OL+GWLISn6mNUOyKU6tG0QktjbVRkMbgpiG9GaNqcKyHrpwcLbDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707409570; c=relaxed/simple;
	bh=YBM/esLbu+mqy3ypJw2xlbujxachXFDL4rz2CqABACg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iK0MJU3HXSaAtVbDxJO9yoDW5n0I4FosCzi1AYUF2stQCxVhZQX9CG7UF6/Mw/zFJ9z8uhy4n4ocwnayFpSAu+HdTFiGQ8GMLg7+k6XFQ1jk4ECHkJXoxNq7YBtpuSy2gE2KnlYB2ofKqy2IsvDN95H+k8ONh1WKLNKRsOEoWck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kaJ94CvJ; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kaJ94CvJ"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-214ca209184so1251965fac.1
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 08:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707409567; x=1708014367; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uEuGXrzdCmYr9ISXm9wok5krFRzGj/Nfq5pKtnmjTpE=;
        b=kaJ94CvJoMupCKr4dkpoNPxG3wz+bkh2GD23wqUlOWfKTid9BJCZQpm23/O0/yezob
         4+16468IgPiVlNcjFWYBrL2jcbqaRysEdgnVfgKpFNjte127uLd4odCbXi++jEeuo9jR
         gSxf9R6rZrp0rWt1Sgsp6Eq7NCTBo5bL0Z+XjIN7OS4Qv78Zjx1Wkf42JcTaUAMGwCYb
         LYULMiIO076XRJx+4aE0fvYvCHgwaU08BSQiYvTrQXxBGTEINnP2erCEEGFQc2y3BN8D
         ZDPOQ86HgpnvgxT2OBU7vs9cPJ6G68J/VlSGErtJ48Y4VNnF5DkUFWze3UBrlJTOxHJS
         bS8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707409567; x=1708014367;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uEuGXrzdCmYr9ISXm9wok5krFRzGj/Nfq5pKtnmjTpE=;
        b=bOCM6OW+fV20uYZrVgGkY4fYMN4+Z4k4q5gt6BM33S5xrh3WOAY/s7Q6K9au7lZeEb
         IqCkTQnEgBOUO31Af6hjEhrtu6kNECuhVEwgnHDkXlJbAhVlpn7PWEP8+pB7FDBG7P0V
         yOWa362kC4EE52Jt1drPMMes+X9vChzm/OxsswBinTH8asK6B64M9kvTGk+e5wkryldp
         DQFe6l9hwkbuzYTSD8E4FrbfQIsvggPky3byTRKYsDx6dR1+yagVAwtUIQoPOmtgKyTh
         0AtAfFd02/Lwu54u78bfrkniH3hlM+XjMXOlc0eg3q5vVLP0TNTNuU2/LpJlrCHQW8E3
         cp8Q==
X-Gm-Message-State: AOJu0YwS51LdtWTtNk3oQ8G2lrI+hcmZnXlWbVNfS0F6pkLbtAAOTYs8
	pBCsS0Ux52HVJCoBfPHDFcZXq9IexmFQoTZq10igX+om8oGGCOQWXCD6+VYP/ss=
X-Google-Smtp-Source: AGHT+IHEcGaBNtRLEgrLbFu1sCv+GngpUjS6FT8VFiEziEh9X9S5+cHNVzY6D4c3XKvRcB+Nite3dg==
X-Received: by 2002:a05:6871:4009:b0:219:f2a3:d8ad with SMTP id kx9-20020a056871400900b00219f2a3d8admr2877587oab.42.1707409567035;
        Thu, 08 Feb 2024 08:26:07 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVpw2zU29fHt7MX61F7ZAet9NJsnC7/j5ovgqUH+vgWFOdJEoCDEN4Cm6/zORgxNNVNzeUjK62Qqfek2NqlAhKhdzZexbVc86AO72THL72VPkYSpzl6907QFQsG86oQfsZUH/c6NVbI9nuNtfGLUtPJTVCG+4pYvu+cy1qckYHnPwG/5IdLAxQ8JK6BnnWadYO/4BxGzMCyu8F/RTFP2I1gWRY/zfr+cFEzBg2MBGpG9R+Eh6dAkr6Tm2ZHhrzEDC0GuFeJ/WmPqrKOOeHRB1YTx+2Kgy9yKa4U3X+5RFS0SFPXMQV5ieWUV0sOqmYQlyqbl/ha1MQt2/bQxNoaFEA6vVxS3/Eh4ACoE92Gd3TSvVjmrtmnKDAf1dH2LIfudbc3WtQtSrGexx2IaVfKoXwZ0iw/0joFCLo=
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id h40-20020a056870172800b002199d8f9e2esm791993oae.19.2024.02.08.08.26.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 08:26:06 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rY7Dx-00F3Fa-PH;
	Thu, 08 Feb 2024 12:26:05 -0400
Date: Thu, 8 Feb 2024 12:26:05 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Cc: "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	Linuxarm <linuxarm@huawei.com>,
	"kevin.tian@intel.com" <kevin.tian@intel.com>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"will@kernel.org" <will@kernel.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: Re: [RFC PATCH v2 6/7] iommu/arm-smmu-v3: Use KVM VMID for s2 stage
Message-ID: <20240208162605.GU31743@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
 <20240208151837.35068-7-shameerali.kolothum.thodi@huawei.com>
 <20240208155915.GR31743@ziepe.ca>
 <8bfca4c5bfe7424691efdae0f686ece4@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bfca4c5bfe7424691efdae0f686ece4@huawei.com>

On Thu, Feb 08, 2024 at 04:14:07PM +0000, Shameerali Kolothum Thodi wrote:
> > >  #include <linux/of.h>
> > > @@ -2399,9 +2400,13 @@ int arm_smmu_domain_alloc_id(struct
> > arm_smmu_device *smmu,
> > >  	} else if (smmu_domain->stage == ARM_SMMU_DOMAIN_S2) {
> > >  		int vmid;
> > >
> > > -		/* Reserve VMID 0 for stage-2 bypass STEs */
> > > -		vmid = ida_alloc_range(&smmu->vmid_map, 1,
> > > -				       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
> > > +		if (smmu_domain->kvm) {
> > > +			vmid = kvm_pinned_vmid_get(smmu_domain->kvm);
> > > +		} else {
> > > +			/* Reserve VMID 0 for stage-2 bypass STEs */
> > > +			vmid = ida_alloc_range(&smmu->vmid_map, 1,
> > > +					       (1 << smmu->vmid_bits) - 1,
> > GFP_KERNEL);
> > > +		}
> > 
> > We cannot allow the two different STEs to be programmed with the same
> > VMID but different translations, so somehow the two allocators have to
> > work together.
> 
> My idea was, we only set smmu_domain->kvm in the nested parent case
> and that means SMMUv3 supports both S1 & S2. So all the non-nested domains
> are using S1.

Okay, that is what I was thinking to get to.

The logic needs to reflect this directly though:

/*
 * There can only be one allocator for VMIDs active at once. If BTM is
 * turned on then KVM's allocator always supplies the VMID, and the
 * VMID is matched by CPU invalidation of the KVM S2. Right now there
 * is no API to get an unused VMID from KVM so this also means BTM systems
 * cannot support S2 without an associated KVM.
 */
if ((smmu->feature & ARM_SMMU_FEAT_BTM)) {
   if (!smmu_domain->kvm)
      vmid = -EOPNOTSUPP;
   else
       vmid = kvm_pinned_vmid_get(smmu_domain->kvm);
} else {
	/* Reserve VMID 0 for stage-2 bypass STEs */
	vmid = ida_alloc_range(&smmu->vmid_map, 1,
		       (1 << smmu->vmid_bits) - 1, GFP_KERNEL);
}

(and matching change to the free side)

> This is what I was trying to do. But not sure we have systems out there where
> only S2  is supported and that may require a private VMID without KVM.

iommufd can ask for a nesting parent without supplying a KVM fd, which
would cause vmid aliasing between the two allocators. That needs to be
blocked as above

Jason
