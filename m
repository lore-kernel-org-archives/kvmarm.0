Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365DC2101AD
	for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 11:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737545331; cv=none; b=jl+Z+uO73Zg5dZ6eIb5IXQMMR/VkZwAh6t/qOM6lcbntVG42hZBJEuqJvtBItRsMzocGZGAlsMLzYou+U+uYrrVvGcp4UoG3Znvq2Dq9BECq8fzMPcdW3qoMO+3ABXtslQZpjUd34d+TVGqTPx+Sn4Lhqe0zNoJZ+8OKpH1Iosw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737545331; c=relaxed/simple;
	bh=4fKUIomfAcgC02nsMlRRquKUlHaw7xCNWdY44C2mH3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbnA8tYYJd9GvPHDQpnvm0PuGQZ8FQeaSgGJJPwae2ciac5ezku1Rhj2z9GL85mf1UYuMqnq5dgT94hsiGf1l4yhPkIDXtwzSzURCvcKR4Z0+OP0m8Kw2XK34/Pxoym1pomkKuvDJQlayfvGxLTmzPuO4f5UI+EXCEYo18w4ma8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KFN1BTJJ; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KFN1BTJJ"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso50525e9.0
        for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 03:28:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737545327; x=1738150127; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CsNhBEt0dk+OxPbn5Xdlhe7W26EoJocfUoky1jHz1O0=;
        b=KFN1BTJJbXLpzlZi9wlwG/XfQJuNBC2JoQXSjOb/W1z3ilhqezkC/r74QkiA+Yz8Xa
         Jk/FpfuXWJW3dKdG8pMdMbYisjyziNzT94YMWmtDtU5Q5z13KbwzRv66Zeag+ISFExtI
         f4NIW/thJcZwQJbiR1OQ/yCagijDEdzSx2KpKEeQr80n7fj+84gTeWwoex3TaX/3mlMH
         1gYhe0d1uLqHTDPRIc7/c5P+oVsqHGk07eFLx+kAO4a6dRqnVA6IPiMM5L+mrBQ9dZJ7
         mOSpfavc2qIVrbD8Ow+ObUBaG0fLzIv393UU+sNVi1W0DSkH/XAGtkOb6spqBQBlZS+2
         o9Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737545327; x=1738150127;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CsNhBEt0dk+OxPbn5Xdlhe7W26EoJocfUoky1jHz1O0=;
        b=RwlcVe7SR3Ji9lg+0x9t/7UQ/WroPv5wNq7PmIJTbvtjzsVeXoZDxxxgwG/Two6H5m
         FSFwmIbVzj9lvqXmvsX3h6DuLs5MOddXfz/XtpjUOQbLQazaJuLrKI0G5/2JP9dyZr9B
         iCDp/xnbxWCxFsrcS2rm7ECuyZi4luTU/oj2CIDchlbCRsFAe5RRIcb7aHPAsF9w91if
         spoHWoUfKRk79ybdFCw0G4sWdytsx3Hcs3HDayE39y4sKAf5e4Q7acfNUbe5k+ttv2P3
         i1MEq+GUy60B7IjIbMqh84m3Z03kCdf+498qvPnZEtZTE9yn41sbaUzR4xITKFhUYrbe
         J8yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWRg7SmDAigW2GgjhmV808Td2NEf2uKiJ7JrUK500tzwdS6sAeZcXkwFhCvhLmyMr+6ie9RpOw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/JtxRwGrtrImG4Lyv52ZdPZDSUCR7zL9X2kmmQCVMFi+y+pep
	a203TbD/GmOoZ8UrPyQaOWTdNlUjJsBwJleJ6FvqSmecCwmLxh6uuGMj68jEBA==
X-Gm-Gg: ASbGncthAhsCvlAKul3ZvL31c+riQsX+V3U8y47EYSq1jrfhaKGrmE81L1sCzih1rWa
	0/BLSbd+Kvcbz3e4zERj6uqDxSPnH3kAZYZvSLVcaLjy4wnuEEi7T3tzcLWkyn9CJJEIoKTfcGY
	pO8SrVo+WV/Z5EI7lLPxFFpY6/Mh4+AqJszp8+s+czwjhJdPu3gL/9c0DvW3CLiHQGL1N6i80NV
	OvBu5TDDmfySc7d50g9wtKFoR3gBI8S6fQxG440E/ih1N7ZsCmig0MCZ/HRSPrkhLhAec/CYdv2
	ZdRHOSCLPneGqxf6MDSdadf1qiPObw==
X-Google-Smtp-Source: AGHT+IECuRWfKnePAPaGqtvOA0k5raSnulcZedW9oYouCa9keSSKkUoBJV4FBWh1VG9lH6tWjMpe+A==
X-Received: by 2002:a05:600c:1c96:b0:42c:9e35:cde6 with SMTP id 5b1f17b1804b1-438b218ae0dmr1070955e9.2.1737545327264;
        Wed, 22 Jan 2025 03:28:47 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-438b3124a14sm21260335e9.0.2025.01.22.03.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 03:28:46 -0800 (PST)
Date: Wed, 22 Jan 2025 11:28:42 +0000
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
Message-ID: <Z5DWag7ZKCPl1Eje@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52760686ABB3145E44BAD95A8C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>

Hi Kevin,

On Thu, Jan 16, 2025 at 08:51:11AM +0000, Tian, Kevin wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> > Sent: Wednesday, January 8, 2025 8:10 PM
> > 
> > On Thu, Jan 02, 2025 at 04:16:14PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> > > > I am open to any suggestions, but I believe any solution considered for
> > > > merge, should have enough features to be usable on actual systems
> > (translating
> > > > IOMMU can be used for example) so either para-virt as this series or full
> > > > nesting as the PoC above (or maybe both?), which IMO comes down to
> > the
> > > > trade-off mentioned above.
> > >
> > > IMHO no, you can have a completely usable solution without host/guest
> > > controlled translation. This is equivilant to a bare metal system with
> > > no IOMMU HW. This exists and is still broadly useful. The majority of
> > > cloud VMs out there are in this configuration.
> > >
> > > That is the simplest/smallest thing to start with. Adding host/guest
> > > controlled translation is a build-on-top excercise that seems to have
> > > a lot of options and people may end up wanting to do all of them.
> > >
> > > I don't think you need to show that host/guest controlled translation
> > > is possible to make progress, of course it is possible. Just getting
> > > to the point where pkvm can own the SMMU HW and provide DMA
> > isolation
> > > between all of it's direct host/guest is a good step.
> > 
> > My plan was basically:
> > 1) Finish and send nested SMMUv3 as RFC, with more insights about
> >    performance and complexity trade-offs of both approaches.
> > 
> > 2) Discuss next steps for the upstream solution in an upcoming conference
> >    (like LPC or earlier if possible) and work on upstreaming it.
> > 
> > 3) Work on guest device passthrough and IOMMU support.
> > 
> > I am open to gradually upstream this as you mentioned where as a first
> > step pKVM would establish DMA isolation without translation for host,
> > that should be enough to have functional pKVM and run protected
> > workloads.
> 
> Does that approach assume starting from a full-fledged SMMU driver 
> inside pKVM or do we still expect the host to enumerate/initialize
> the hw (but skip any translation) so the pKVM part can focus only
> on managing translation?

I have been thinking about this, and I think most of the initialization
won’t be changed, and we would do any possible initialization in the
kernel avoiding complexity in the hypervisor (parsing
device-tree/acpi...) also that makes code re-use easier if both drivers
do that in the kernel space.

> 
> I'm curious about the burden of maintaining another IOMMU
> subsystem under the KVM directory. It's not built into the host kernel
> image, but hosted in the same kernel repo. This series tried to
> reduce the duplication via io-pgtable-arm but still considerable 
> duplication exists (~2000LOC in pKVM). The would be very confusing
> moving forward and hard to maintain e.g. ensure bugs fixed in
> both sides.

KVM IOMMU subsystem is very different from the one kernel, it’s about
paravirtualtion and abstraction, I tried my best to make sure all
possible code can be re-used by splitting arm-smmu-v3-common.c and
io-pgtable-arm-common.c and even re-using iommu_iotlb_gather from the
iommu code.
So my guess, there won't be much of that effort as there is no
duplication in logic.

I am still thinking about how v3 will look like, but as mentioned I am
inclined to Jason’s suggestion to reduce the series and remove the
paravirtualtion stuff and only establish DMA isolation as a starting point.
That will remove a lot of code from the KVM IOMMU for now, but we'd
need to address that later.
And we can build on top of this code either a para-virtual approach or
nested-emulation one.

> 
> The CPU side is a different story. iiuc KVM-ARM is a split driver model 
> from day one for nVHE. It's kept even for VHE with difference only
> on using hypercall vs using direct function call. pKVM is added 
> incrementally on top of nVHE hence it's natural to maintain the
>  pKVM logic in the kernel repo. No duplication.
> 
> But there is no such thing in the IOMMU side. Probably we'd want to
> try reusing the entire IOMMU sub-system in pKVM if it's agreed
> to use full-fledged drivers in pKVM. Or if continuing the split-driver
> model should we try splitting the existing drivers into two parts then
> connecting two together via function call on native and via hypercall
> in pKVM (similar to how KVM-ARM does)?

For the IOMMU KVM code, it’s quite different from the kernel one and serves
different purposes, so there is no logic duplication there.
The idea to use hypercalls/function calls in some places for VHE/nVHE,
doesn’t really translate here, as already the driver is abstracted by
iommu_ops, unlike KVM which has one code base for everything, as I
mentioned in another reply, we can standardize the hypercall part of the
kernel driver into a an IOMMU agnostic file (as virtio-iommu) and the
KVM SMMUv3 kernel driver would ony be responsible for initialization,
that should be the closest to the split model in nVHE.

Also, pKVM have some different code path in the kernel, for example pKVM
has a different mem abort handler, different initialization (pkvm.c)

Thanks,
Mostafa

> 
> Thanks
> Kevin
