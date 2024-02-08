Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216E27BAE3
	for <kvmarm@lists.linux.dev>; Thu,  8 Feb 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707406536; cv=none; b=eduNitWPEvsZ2mClkakWf4GpIPUbVxVLNiKWd00y2q1jEvxvkhYN32EbOdoyr1SqoehAXztDJrbT6fuk17WWwuEJMTt73XMQUeTLdmqsUkNE39bM9o3KluLukp7VZcUUSjYAyf9kCSGfzRsI+Bn4a/CwqqRGS7U45BeWLf7GMTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707406536; c=relaxed/simple;
	bh=5k4+6lWQFa+6xEZ+TB8+vk/3241zK8Iyr9Y7sz2SrBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Hq4BV4WtIpSc+bpPTx5t+AVe2iXxyMHGnDZVJOLwzfBDTWB9Z3KoWq49XYpa6pnB9HS+zA69E9+bfvTZ0bbD24bqQGsjGrGtWOsEDienetOcfIWrCH0ZJZkUvq3SBI4yNUgLpY5DNSE8Qxzz+LPaZyB2lb0XR/t0+c9XUXKQslQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=M4lTKDFR; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="M4lTKDFR"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6e12f8506ccso886111a34.2
        for <kvmarm@lists.linux.dev>; Thu, 08 Feb 2024 07:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1707406534; x=1708011334; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=064MaGMoo/si5yM8XfpFSqAgMAn25mABgpc11yvT/RQ=;
        b=M4lTKDFRL46WEvCYMVj0GkIjUvDkDGfHIY+HlXYt5cp1Vz0nAECsIUlSAyFhrHbjdl
         57fDaDkZxwhdGTg6Mv9M1LajfKxbBmJxgoBGAMJBpBcVlohhAQ4hrOZLxrYHKBtcTyXu
         ivZwr66D/UG7Sg5NoC6X6XLPUxHpt3vyTuP69ctrY5vwpZEhTNYPaQdwTvVoHF1Hpz/n
         9H/SDe8lzXJYQHuoM8p1WzK6SDG46G/VluAe2/aBwtuforHR8gevKKVh6G3m6rwuDDDo
         u6LaMtP0xq50Xl0l3va08gKLzNrgpT2Xpt58WXNWrmYp6DAb8E2Vs9+LnEjFldBY+jWw
         xZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707406534; x=1708011334;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=064MaGMoo/si5yM8XfpFSqAgMAn25mABgpc11yvT/RQ=;
        b=hackF6apSE/RWZSXATu9GuDoPgxNH/D5K3GJlua3lK3HeXY6O4oGoNFypclRzy5GtW
         fXOfon2ugk9ayhYuyuvJfAmBp0+QcZU6AXk2TzKmrNk/DDoAR2QaiiR8wVCiL9i5iFrm
         Y64WucEXFGwSPPJNS//SFOvabOlPh91e2gn+d5GrzUOyuvDmUS27n/Hv/MkFuV48T324
         J6cDS++Z1dvRx0PyacTi7w1q5luRCJRrGodMIpQbG2tBK+uQs0egPDOYuS40PMIM2dgm
         9B0MXkkgOGb8sN/2NxP3f73rJBhphEjlAVwrSGO97cXq6SQ8n2XynhJnZgb00Xc1NdJu
         qOMg==
X-Gm-Message-State: AOJu0YwGxnBD1LjhmkIvI9UskfuFrve8NNjapQ/gMtsGEeDFAOiSWRu9
	dfw5UQuYpa3kwmfOiN7Ml4eJy5xd9fGALdqG7FsfA/R4Xi/tWjhxV73U/ev7XG8=
X-Google-Smtp-Source: AGHT+IHuVau2G0UuBl3prEZp0ydGLt/dYdINZBXPXoGNuifQ7pOnZtYfO4h4b5txLycmHt2t2J0Cew==
X-Received: by 2002:a05:6870:4706:b0:219:953a:61c with SMTP id b6-20020a056870470600b00219953a061cmr10681555oaq.44.1707406533938;
        Thu, 08 Feb 2024 07:35:33 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCViSi+RR+f6+zW0uN9ZcndDah1h70ecKjPbq1oTGKABAwDxT61LUvzXHFAK43AS0yx4eOD1LSCD41+LVpwcfOS7DTnz5SoSnfavpLOPJLWZ7UGmWbunErsxzI/jpnMwmUwQQy8hN7wbWrkVhvS2JPBmQSxkfET0s7HHx8ZI82zgfS4EkpSxRSCPQI53/48wY7GKGZQMzsM156pVBJyIsebUGGGlsYBDquij2f3xE5V5PTDwTC56gCoj+2E5R+UhlBi+VrMPagbw1ARxsNnacdB0WXPr67ZQ6S+wt7K+zoFtSF29nmo8dnsFWFpfRWsdg5U47ohAJsULVlqX+P48wNvIR9t4vOtr5WamQ/U/KxMfrF60arJi+czsdzBgQL35EmDUig8fuHOAIruI6+4ivFvCZdecdP1hgkA=
Received: from ziepe.ca (hlfxns017vw-142-68-80-239.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.80.239])
        by smtp.gmail.com with ESMTPSA id d9-20020a056830138900b006e13c3274c2sm580143otq.8.2024.02.08.07.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Feb 2024 07:35:33 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1rY6R2-00EsNe-EW;
	Thu, 08 Feb 2024 11:35:32 -0400
Date: Thu, 8 Feb 2024 11:35:32 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Cc: kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linuxarm@huawei.com,
	kevin.tian@intel.com, alex.williamson@redhat.com, maz@kernel.org,
	oliver.upton@linux.dev, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, jonathan.cameron@huawei.com
Subject: Re: [RFC PATCH v2 0/7] iommu/arm-smmu-v3: Use pinned KVM VMID for
 stage 2
Message-ID: <20240208153532.GO31743@ziepe.ca>
References: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240208151837.35068-1-shameerali.kolothum.thodi@huawei.com>

On Thu, Feb 08, 2024 at 03:18:30PM +0000, Shameer Kolothum wrote:
> Hi,
> 
> On an ARM64 system with a SMMUv3 implementation that fully supports
> Broadcast TLB Maintenance(BTM) feature as part of the Distributed
> Virtual Memory(DVM) protocol, the CPU TLB invalidate instructions are
> received by SMMUv3. This is very useful when the SMMUv3 shares the
> page tables with the CPU(eg: Guest SVA use case). For this to work,
> the SMMUv3 must use the same VMID that is allocated by KVM to configure
> the nested stage 2(S2) translations.

Ah so you are going all the way and looking to enable BTM within a
vSVA environment too?

> An earlier proposal sent out[1] a while back resulted in changing the
> ARM64/KVM VMID allocator similar to the ASID allocator to make it
> better suited for this.
> 
> This RFC adds,
>  -Support for pinned KVM VMID.
>  -Support associating KVM pointer and iommufd ctx.
>  -Changes to domain_alloc_user() to receive a kvm pointer.
>  -Configure SMMUV3 S2 using KVM VMID
>  -Finally enable BTM only if SMMUV3 supports S1 translation. This
>   is to make sure that PAGING domains always use S1 and S2 is only
>   used for nested domains with a valid KVM. The idea is to make sure
>   when BTM is enabled in Guest, we use KVM VMID for S2.
> 
> Not sure I miss any explicit TLB invalidations with any use case
> that may configure a S2 with a private VMID that matches a KVM
> one.
> 
> This is based on Jason's ongoing SMMUv3 refactor series[2].

I'm glad to see this, thank you for finishing the BTM stuff!

If someone is using it I wonder if we need to get a more solid answer
on the races with invalidation an ASID reassign.. I added some notes
in comments in part 2 after I audited all of it.

Jason
