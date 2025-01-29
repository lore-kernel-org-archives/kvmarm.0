Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50E1418C31
	for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 12:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738152974; cv=none; b=tglfCH+wghTjz9RkAedBQm0LAUhyJWssM+qASqoIvyv9ti0jJVa2w3/C2Dv3qlk3rDMcP45bWh/xzaiY5JZWUY10NK670CVV0QnSPzKdvNeSrfgSG80mfxE3ZBzdINikmrD24YZVRToSMUUsZ2LyW2o232+6MjVgUDjUm6Rc0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738152974; c=relaxed/simple;
	bh=/baOjcO8BDS9wABFMnNMjlMdnguKi8ayu5Sr/AxFX8M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YlaXSmivwNCHMzbqXC8J4kkeBT4tLhQxMOCeGSEre46cjNekkA73VwAc2EFznyX4TbL6+72yjAsfE5EPKd5nMQtFDaKaQgFCwb1I5FaPTHId9kY7TxTsWl9O79sapPZWa4vCOVoClv2JJ/jHZ1p+JIMs2W9nld0ZBe5GPLB3Yms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WVzBACTX; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WVzBACTX"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-438d9c391fcso85175e9.0
        for <kvmarm@lists.linux.dev>; Wed, 29 Jan 2025 04:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738152970; x=1738757770; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=KsoV/LvY+nhEMjljzompPtNYOVC1vuKo/PhocupCgIA=;
        b=WVzBACTXRcVHxNlDl2H8O2lOyqFCGo/7qa/MBgKYeZ9J7EuTZNWnH/lIjnmeMLcdD2
         QYp8q4tMOEoq9+9m/5ie2FoomZglOXzQLO+RE+9Ddt7x7VZe5Czj2VBDP2J0wcmu7CeX
         FwctmiX5KnPQCeqxBl3L7ZyTcj+vJtj9Fty2UdCtfperAjJm6tsykWPkETHPKlGyKbBy
         CZj2eQLpA0AWpWEVU2GGZ3YxCcFtIEc0syjOv9wjnmex61oyjlUQsCP0RV3tXaQ0FWyN
         J8A2bIY3mVeXNDUiV0RK/Z4+4ideMKQQ4sjZnSmNfCziq16wdLXPqf3pd6GFmwETf3xu
         nI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738152970; x=1738757770;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KsoV/LvY+nhEMjljzompPtNYOVC1vuKo/PhocupCgIA=;
        b=CtWpPPlXVM3O0i97XMkrn88s8yKYItW+o3p1oXGUUf38f1m60xJpSJ8bfZM/oLRW0z
         Es+oIlX06wVASYryWOclLxD943PTCr+9SkLICzntOfi5zqYtdwhgpRXmzvPrHHlAPNTB
         1wiixTM9k7W/VN3OPqjpcA3IkrGNpt6b7WOC0BrZkCmH7d3zGvTokU3Mri6vAgT+3Xik
         GIACtcIFHgDfavBstZHotTC4B13AfoBZ70+ahzAyekFGryLJU0lc+IcwigT8SpCX9EMG
         0Q3H5jK7WwTK0jrHhVuLsRPyOBcMUPi03mP4HS3Yi2lAvpVuKkss11cjRoZXGPiOq1Zt
         6uGA==
X-Forwarded-Encrypted: i=1; AJvYcCVT7y32nMoSiFVLySo1osBET1edBOzSeUj/OmiffAkMNitiCZHA1kztoE27NS09poSajfY8xLw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywi0ruzbVC5wkvpIRgkUx/Iu2VSf0MgiJBuLxyWi85RsZOqS+4L
	ynj4NkwLpusLdX28pc7Nj15y6G/zxmo0JxVKLljfpNFoFYwBRa+f19GvGlcMgQ==
X-Gm-Gg: ASbGnctZnpbwY+1GhyfE8vfIoDs8CI1l4+Ns63BOdQZ9NOeMLxius3lIu7Ck2YesDOz
	7RyP0WPqDziqvGecyg3maUu6rSCXcMr4IFDeOCGJkGACUdZK3Kjm/y7U9hGX4W2kRUbycEXc0+k
	me3YyhVhmnmHdJ/seKXtZ4RL5fx7QMFIG19x8zP23CzuXK4TDksVAmhLc3UbOZPtEbJd+nAfzUF
	aRTTBRQ2DZj/mLTo7V+xWvO/WHDVY09PbHXEv/GNDI9SN3Edrh2+EhK5lB3Jz+8IO61ngqQdCHi
	EPjV3FaObiOJ4c4ncn/vA5rs2SGYNQ5ShD6dKc1mszcXjSCCouM=
X-Google-Smtp-Source: AGHT+IHdxx2hNjGazr2D3TklGqwL4KUAhuNB+hsGlC38PJET1VJkzQdQAU4y4v+hrBc5bwG0U2GAiA==
X-Received: by 2002:a7b:c3d8:0:b0:42c:9e35:cde6 with SMTP id 5b1f17b1804b1-438dc37d9aemr978295e9.2.1738152970287;
        Wed, 29 Jan 2025 04:16:10 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c3ec83e20sm10167480f8f.23.2025.01.29.04.16.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jan 2025 04:16:09 -0800 (PST)
Date: Wed, 29 Jan 2025 12:16:05 +0000
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
Message-ID: <Z5ocBVxDnqZVINXQ@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DQuNn3GoU1vYPV@google.com>
 <BN9PR11MB52760945FBCF542F77DCF4CA8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52760945FBCF542F77DCF4CA8CE02@BN9PR11MB5276.namprd11.prod.outlook.com>

On Thu, Jan 23, 2025 at 08:13:34AM +0000, Tian, Kevin wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> > Sent: Wednesday, January 22, 2025 7:04 PM
> > 
> > On Fri, Jan 17, 2025 at 06:57:12AM +0000, Tian, Kevin wrote:
> > > > From: Jason Gunthorpe <jgg@ziepe.ca>
> > > > Sent: Friday, January 17, 2025 3:15 AM
> > > >
> > > > On Thu, Jan 16, 2025 at 06:39:31AM +0000, Tian, Kevin wrote:
> > > > > > From: Mostafa Saleh <smostafa@google.com>
> > > > > > Sent: Wednesday, January 8, 2025 8:10 PM
> > > > > >
> > > > > > On Thu, Jan 02, 2025 at 04:16:14PM -0400, Jason Gunthorpe wrote:
> > > > > > > On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> > > > > > > > Yeah, SVA is tricky, I guess for that we would have to use nesting,
> > > > > > > > but tbh, I don’t think it’s a deal breaker for now.
> > > > > > >
> > > > > > > Again, it depends what your actual use case for translation is inside
> > > > > > > the host/guest environments. It would be good to clearly spell this
> > out..
> > > > > > > There are few drivers that directly manpulate the iommu_domains
> > of a
> > > > > > > device. a few gpus, ath1x wireless, some tegra stuff, "venus". Which
> > > > > > > of those are you targetting?
> > > > > > >
> > > > > >
> > > > > > Not sure I understand this point about manipulating domains.
> > > > > > AFAIK, SVA is not that common, including mobile spaces but I can be
> > > > wrong,
> > > > > > that’s why it’s not a priority here.
> > > > >
> > > > > Nested translation is required beyond SVA. A scenario which requires
> > > > > a vIOMMU and multiple device domains within the guest would like to
> > > > > embrace nesting. Especially for ARM vSMMU nesting is a must.
> > 
> > We can still do para-virtualization for guests the same way we do for the
> > host and use a single stage IOMMU.
> 
> same way but both require a nested setup.
> 
> In concept there are two layers of address translations: GVA->GPA via
> guest page table, and GPA->HPA via pKVM page table.
> 
> The difference between host/guest is just on the GPA mapping. For host
> it's 1:1 with additional hardening for which portion can be mapped and
> which cannot. For guest it's non-identical with the mapping established
> from the host.
> 
> A nested translation naturally fits that conceptual layers.
> 
> Using a single-stage IOMMU means you need to combine two layers
> into one layer i.e. GVA->HPA by removing GPA. Then you have to
> paravirt guest page table so every guest PTE change is intercepted
> to replace GPA with HPA.
> 
> Doing so completely kills the benefit of SVA, which is why Jason said
> a no-go.

I agree, this can’t work with SVA, in order to make that work we would
need some new para-virt operation to install the S1 table, and the
hypervisor has to configure the device in nested translation.

But, for guests that doesn’t need SVA, they can just use single-stage
para-virt (like virtio-iommu)

> 
> > 
> > > >
> > > > Right, if you need an iommu domain in the guest there are only three
> > > > mainstream ways to get this in Linux:
> > > >  1) Use the DMA API and have the iommu group be translating. This is
> > > >     optional in that the DMA API usually supports identity as an option.
> > > >  2) A driver directly calls iommu_paging_domain_alloc() and manually
> > > >     attaches it to some device, and does not use the DMA API. My list
> > > >     above of ath1x/etc are examples doing this
> > > >  3) Use VFIO
> > > >
> > > > My remark to Mostafa is to be specific, which of the above do you want
> > > > to do in your mobile guest (and what driver exactly if #2) and why.
> > > >
> > > > This will help inform what the performance profile looks like and
> > > > guide if nesting/para virt is appropriate.
> > >
> > 
> > AFAIK, the most common use cases would be:
> > - Devices using DMA API because it requires a lot of memory to be
> >   contiguous in IOVA, which is hard to do with identity
> > - Devices with security requirements/constraints to be isolated from the
> >   rest of the system, also using DMA API
> > - VFIO is something we are looking at the moment and have prototyped with
> >   pKVM, and it should be supported soon in Android (only for platform
> >   devices for now)
> 
> what really matters is the frequency of map/unmap.
Yes, though it differs between devices/systems :/ that’s why I reckon we
would need both on the long term. However, starting with some benchmarks
for these cases can help to understand the magnitude of both solutions
and prioritise which one is more suitable to start with for upstream.

Thanks,
Mostafa
> 
> > 
> > > Yeah that part would be critical to help decide which route to pursue
> > > first. Even when all options might be required in the end when pKVM
> > > is scaled to more scenarios, as you mentioned in another mail, a staging
> > > approach would be much preferrable to evolve.
> > 
> > I agree that would probably be the case. I will work on more staging
> > approach for v3, mostly without the pv part as Jason suggested.
> > 
> > >
> > > The pros/cons between nesting/para virt is clear - more static the
> > > mapping is, more gain from the para approach due to less paging
> > > walking and smaller tlb footprint, while vice versa nesting performs
> > > much better by avoiding frequent para calls on page table mgmt. 😊
> > 
> > I am also working to get the numbers for both cases so we know
> > the order of magnitude of each case, as I guess it won't be as clear
> > for large systems with many DMA initiators what approach is best.
> > 
> > 
> 
> That'd be great!
