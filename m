Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8030321170E
	for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 11:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737543874; cv=none; b=ZCdRdgkOi7cViVpIjzJXIH860Cwi1YlJrJkxvRltvw4O2Xr3e6O7erw7GIClZwIHSQPub1NVXEV+e6dg4S7bpIhVBmyfMDA/gTN3ed1swjx7GQ5yPEqBKZmhScKGH2I6CJGPHwtbO8hZFRPKTpd1aebVD2wkCGQjAmE3Ufq/CVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737543874; c=relaxed/simple;
	bh=utqVEO5I67Qn1SxggtlBg2uyccJsm9B3vF55yUEBW0Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuISGqvGSOtj8Vxf9afhjxb60lPUa0TjsuYe+6CCT0DRBMLH9r+wNFkjKdlGUojpAqMdR4SVu9yFTBSZtUNkLgxYRzS/XOQkaIYJ2CM2zL2HCLhaOHvblinCEsTdXzMaVflAPVAeMBQ5GAxUPlBiFa0OAjaGkemVH5/Wu/fN5Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MBEDRsmS; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MBEDRsmS"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso49415e9.0
        for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 03:04:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737543871; x=1738148671; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6x8SiYYYUQFFMCokfouR/mswZBMHq350sgLQtsTuQB0=;
        b=MBEDRsmSuyy9VX32l8GdWBJEHNd9FLTUtT8vI59mYnkgeQOKmRwdgx5biwSwpcNuOz
         zikBAOgZlrfSiXoQnQYMvLqUNfOcL0IHebCiJYe55C1YlCEAEo5HXsAlgyuqyU1PnuJl
         tQ9MHlpZlZpexAzYCk/mZnErWcpsoxIcsQ1F0JSJef+ZYWbotvgb5upXO0JAzL2Py6ar
         86RYYu77RzKwJxFm9InS9EW+RXcfKdXPeUKzQBEG6MizCxpEsG9DQqm+vxtvdvcX0NfE
         LEVi6j5mAyhcGOCXabLfLqMQ/jQ8JhFnI4wVQz+z0UqYP0l+eWMzJt2UuQOSW0nxLuUH
         GM7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737543871; x=1738148671;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6x8SiYYYUQFFMCokfouR/mswZBMHq350sgLQtsTuQB0=;
        b=hyRZSgTT3Ec9dQgwg58X0KhyqA6M44uahbcT7+rcrsExJiUceF2J/4kVuY5Gye2uM6
         vzP/FfuDNi10ml+TTCXCrKfEDEHdphLjzFN6RSuzmIe+VerPKJP5NX2bHO29OhOnbt78
         BrrHtpCC6eKK72w/aTxq7Zu+hBE8ohpocZsmLTEU43C/y/Pk4YLwO4vaWh1gv9xmDlKZ
         Am816+GFgmgK1l6iSW2ZOJUed3fJu8SDo/VXJCseJ1sokIafkoOrHC3cB8gP3wdHuukp
         EgSp7zZRiyUR3HZbH3bw1U2Qi8WsuWo65vkMF5q3LDl0ShjcX21LwNxYa6Jlyxyi4LX1
         +riA==
X-Forwarded-Encrypted: i=1; AJvYcCXl9ucjz2A2uRay0VZj1nHIHP3iYf2v8ue/uW7nBu7bW4k20vXMQr9NJxpLZYKVVT11eDBYhik=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtFJDaE2+04hgGKelaP6+rTak2nmcEpZdeEwpTIQoNk0+Bg4ZT
	1fT+klNl6J3J3OAUiYJlhjr5lJgokI6xPRkkjoVQ/Fg63pNeL7lpBme5Ja6pTw==
X-Gm-Gg: ASbGnctkq5QGxdAYoTfdTQCVrTm6r5tBtID/oT8Z1N6l2m1+xJwPoXh2Ldf3yrNJG3o
	i3MlPOVU/Ujh4YBoa53pzsww0CrKivt2SrlTHwrvsK8ENYqcOJpwqCJMoiDYq2CjPEwuA9dyC8t
	MIR6ZLTh5CIWGpABIV5s52o0sOeAXcFLCHVJ0IOcBI1++DCkyVV3gho9a3V3rYAoJ9ffs1cOlK1
	DNPGCCAHE14bJW5Ltj/DdxwdttX+pVXmSFUcBx/KWdDu98y/MHag3pEuYPvx4ui00jvmrMCga8C
	6cGIwGn95YoXT6gxFgkBAsbt6pyQYQ==
X-Google-Smtp-Source: AGHT+IHCcPrZhJYSQbULZrw9Pp5790wT0aW6WD0dYCBGNGReHretNQSCRXdvXPT2A8uBJ9bQ0Dv2SQ==
X-Received: by 2002:a05:600c:1d8f:b0:436:ed00:9e3 with SMTP id 5b1f17b1804b1-438b21c931dmr1151165e9.6.1737543870607;
        Wed, 22 Jan 2025 03:04:30 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3221baasm16122838f8f.35.2025.01.22.03.04.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 03:04:30 -0800 (PST)
Date: Wed, 22 Jan 2025 11:04:24 +0000
From: Mostafa Saleh <smostafa@google.com>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>,
	"iommu@lists.linux.dev" <iommu@lists.linux.dev>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>,
	"maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"robdclark@gmail.com" <robdclark@gmail.com>,
	"joro@8bytes.org" <joro@8bytes.org>,
	"robin.murphy@arm.com" <robin.murphy@arm.com>,
	"jean-philippe@linaro.org" <jean-philippe@linaro.org>,
	"nicolinc@nvidia.com" <nicolinc@nvidia.com>,
	"vdonnefort@google.com" <vdonnefort@google.com>,
	"qperret@google.com" <qperret@google.com>,
	"tabba@google.com" <tabba@google.com>,
	"danielmentz@google.com" <danielmentz@google.com>,
	"tzukui@google.com" <tzukui@google.com>
Subject: Re: [RFC PATCH v2 00/58] KVM: Arm SMMUv3 driver for pKVM
Message-ID: <Z5DQuNn3GoU1vYPV@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>

On Fri, Jan 17, 2025 at 06:57:12AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Friday, January 17, 2025 3:15 AM
> > 
> > On Thu, Jan 16, 2025 at 06:39:31AM +0000, Tian, Kevin wrote:
> > > > From: Mostafa Saleh <smostafa@google.com>
> > > > Sent: Wednesday, January 8, 2025 8:10 PM
> > > >
> > > > On Thu, Jan 02, 2025 at 04:16:14PM -0400, Jason Gunthorpe wrote:
> > > > > On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> > > > > > Yeah, SVA is tricky, I guess for that we would have to use nesting,
> > > > > > but tbh, I don’t think it’s a deal breaker for now.
> > > > >
> > > > > Again, it depends what your actual use case for translation is inside
> > > > > the host/guest environments. It would be good to clearly spell this out..
> > > > > There are few drivers that directly manpulate the iommu_domains of a
> > > > > device. a few gpus, ath1x wireless, some tegra stuff, "venus". Which
> > > > > of those are you targetting?
> > > > >
> > > >
> > > > Not sure I understand this point about manipulating domains.
> > > > AFAIK, SVA is not that common, including mobile spaces but I can be
> > wrong,
> > > > that’s why it’s not a priority here.
> > >
> > > Nested translation is required beyond SVA. A scenario which requires
> > > a vIOMMU and multiple device domains within the guest would like to
> > > embrace nesting. Especially for ARM vSMMU nesting is a must.

We can still do para-virtualization for guests the same way we do for the
host and use a single stage IOMMU.

> > 
> > Right, if you need an iommu domain in the guest there are only three
> > mainstream ways to get this in Linux:
> >  1) Use the DMA API and have the iommu group be translating. This is
> >     optional in that the DMA API usually supports identity as an option.
> >  2) A driver directly calls iommu_paging_domain_alloc() and manually
> >     attaches it to some device, and does not use the DMA API. My list
> >     above of ath1x/etc are examples doing this
> >  3) Use VFIO
> > 
> > My remark to Mostafa is to be specific, which of the above do you want
> > to do in your mobile guest (and what driver exactly if #2) and why.
> > 
> > This will help inform what the performance profile looks like and
> > guide if nesting/para virt is appropriate.
> 

AFAIK, the most common use cases would be:
- Devices using DMA API because it requires a lot of memory to be
  contiguous in IOVA, which is hard to do with identity
- Devices with security requirements/constraints to be isolated from the
  rest of the system, also using DMA API
- VFIO is something we are looking at the moment and have prototyped with
  pKVM, and it should be supported soon in Android (only for platform
  devices for now)

> Yeah that part would be critical to help decide which route to pursue
> first. Even when all options might be required in the end when pKVM
> is scaled to more scenarios, as you mentioned in another mail, a staging
> approach would be much preferrable to evolve.

I agree that would probably be the case. I will work on more staging
approach for v3, mostly without the pv part as Jason suggested.

> 
> The pros/cons between nesting/para virt is clear - more static the 
> mapping is, more gain from the para approach due to less paging 
> walking and smaller tlb footprint, while vice versa nesting performs
> much better by avoiding frequent para calls on page table mgmt. 😊

I am also working to get the numbers for both cases so we know
the order of magnitude of each case, as I guess it won't be as clear
for large systems with many DMA initiators what approach is best.


Thanks,
Mostafa

> 
> > 
> > > But I'm not sure that I got Jason's point about " there is no way to get
> > > SVA support with para-virtualization." virtio-iommu is a para-virtualized
> > > model and SVA support is in its plan. The main requirement is to pass
> > > the base pointer of the guest CPU page table to backend and PRI faults/
> > > responses back forth.
> > 
> > That's nesting, you have a full page table under the control of the
> > guest, and the guest needs to have a level of HW-specific
> > knowledge. It is just an alternative to using the native nesting
> > vIOMMU.
> > 
> > What I mean by "para-virtualization" is the guest does map/unmap calls
> > to the hypervisor and has no page tbale.
> > 
> 
> Yes, that should never happen for SVA.
