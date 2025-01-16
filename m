Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0018222D4F3
	for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 19:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737054899; cv=none; b=T7ONWdDS7r0u7RJ/arPv40C4OLFDl6ON9skIGzXX5daTMTOvh3P9b738nJNQwdjE1JrypBFzDz6hRgRUOPQQOXM+Pvqon6WauzPFid4PrdAE1zVDzgyWEW1XUPROFP/yFJXlEzAV2wFn1ZKRo3x2U8eXnyXwTl6T3GIunA+2vOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737054899; c=relaxed/simple;
	bh=dup/sGyrKh9WqqpYdYZY3lMgQO3Ij2gIanBBEaZheHQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t+GwOxLXrsm5rhTd3adJMXm85pzidds89gK09rvYwJ8yFBHwOXHqDCj1GhvTxpgIhLlbEr3DwfaBNPO1qY1WwETKM2kRRUMXO6T7lvA6/PW43mj1vAO7WTwBmM/BqNIeP3QqZF8wGEle/SJ1l7PL4p+atVFrztpSJHMG6Hn4PRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=PlzGrg0a; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="PlzGrg0a"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6dccccd429eso13669716d6.3
        for <kvmarm@lists.linux.dev>; Thu, 16 Jan 2025 11:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737054897; x=1737659697; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OQt/5kPLKfcR/r6Q+UjR/d/646J1fzUVQYSmfGNoAZM=;
        b=PlzGrg0arGwn1+zixIkrlaDDzKOVwtPo7qE+/G4hRUZjwx7xItTRnBK1try4J8Uzg9
         yHhTP74QAoKxdREzqRLdu7FcXKUxM42ezDG0LVyVbBRYgmOqjfYFJgAFW1B2YZ9WKw2b
         xcoYIYreRQX8dfLLGrgcUTCv8IhDefaHTIBhCfn8g6FOYwz+nPOS551pAUwwjFFsUyQX
         dhUl012Z7OXDeN8gWVpjiTpL3KAuShkMre4/WSWpS/DqA1YsW+sIlyylZH3Xolin+sIV
         SbhWh3Lln+CgnmBZvwh5KZ079431i35feVw0nVVNrHfTxhU21tw+L+Scu1DP3epx4eHp
         OeNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737054897; x=1737659697;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OQt/5kPLKfcR/r6Q+UjR/d/646J1fzUVQYSmfGNoAZM=;
        b=fAd8Wp0iMD4dZhTr9NusD7rksGyNWUnpT2Dc+vgIs23TqabE9gQ600ImjFphga6TYK
         YQPUi1qhqKKDR+US/xK5wXFbxD6oaevS/mKJnV31i12gWOJC6wrOIoWAa2giwXEDn0Aw
         q0hNprKAZK+5MLW/De/1PuqN2nCMQgo37RL4pEPysBhzUwSn+DnjZSQ1J+DjIW/Bo/ua
         tFNkR0zG4C0lwzyQt5hXnXq2tpAeAzfAbGwWK7+BgUu3YbEfRWMteZ2kzapDMwDm/hBM
         x2id5NwImhjIdCjiCG+8WdZhBlXwy8WnO7jQdQ39IjXZkKOWb6wCpocJ+PIQZ7bRD+v8
         4EDw==
X-Forwarded-Encrypted: i=1; AJvYcCWsEq5fnz2BEcmHefQv5JAiqQ0/1A3lI/mqwoT+thbnG28Wo9D9A6BhFUNSpofUuinPa7w0EBI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZJW+2zwvX/6S6yVQ46yac9cVJAsEHsE788TvdYsIhOQAkOEbX
	v0p2lFJxyt19xiBycdVNXyW06P7nfYM2GoOfI/fCST5SGrSzcvLiFAc602S8TF4=
X-Gm-Gg: ASbGncsvIRUQPUkWM8oJtyl/8QaCfHIGhWnT6dNvpkH8a+G0apoyxnegyM3ABRRcPQb
	gwsGRHhMxQCIdkWUCl1YwiJO4coXhaIiWJyGlkPfMP7zrmnP40/PK4LnAX/jXIm1fQFc2Jqxmzi
	FHWKvmMj9SI2yye2CA1YMUZATg8f3Yrcy/Vo0HcsCVi8HvqUS3VRsD1I0Tfy4oh+85cLfd0N8/d
	fOVsMeWvy1zZVjCZOjrpqedKYTMvsekMdVHTRbBB+FBz2hR1uvygGg6HGY0lYqUk8d5GS/4Reis
	Ub+ZjbSTsBSMKB3L0O+Tns2IkV1smA==
X-Google-Smtp-Source: AGHT+IEKLQFb6+AOsWzFxspuNmlLzUNEaMEFSc/MnRiIlEENEcAmYeVJMdkM047M2a18YZcxnlS9VA==
X-Received: by 2002:a05:6214:19c8:b0:6df:97a3:5e5a with SMTP id 6a1803df08f44-6df9b255d62mr623412166d6.28.1737054896839;
        Thu, 16 Jan 2025 11:14:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46e1030e8dbsm2636371cf.44.2025.01.16.11.14.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 11:14:55 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tYVKR-00000002xdV-1jHj;
	Thu, 16 Jan 2025 15:14:55 -0400
Date: Thu, 16 Jan 2025 15:14:55 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Mostafa Saleh <smostafa@google.com>,
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
Message-ID: <20250116191455.GC674319@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>

On Thu, Jan 16, 2025 at 06:39:31AM +0000, Tian, Kevin wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> > Sent: Wednesday, January 8, 2025 8:10 PM
> > 
> > On Thu, Jan 02, 2025 at 04:16:14PM -0400, Jason Gunthorpe wrote:
> > > On Fri, Dec 13, 2024 at 07:39:04PM +0000, Mostafa Saleh wrote:
> > > > Yeah, SVA is tricky, I guess for that we would have to use nesting,
> > > > but tbh, I don’t think it’s a deal breaker for now.
> > >
> > > Again, it depends what your actual use case for translation is inside
> > > the host/guest environments. It would be good to clearly spell this out..
> > > There are few drivers that directly manpulate the iommu_domains of a
> > > device. a few gpus, ath1x wireless, some tegra stuff, "venus". Which
> > > of those are you targetting?
> > >
> > 
> > Not sure I understand this point about manipulating domains.
> > AFAIK, SVA is not that common, including mobile spaces but I can be wrong,
> > that’s why it’s not a priority here.
> 
> Nested translation is required beyond SVA. A scenario which requires
> a vIOMMU and multiple device domains within the guest would like to
> embrace nesting. Especially for ARM vSMMU nesting is a must.

Right, if you need an iommu domain in the guest there are only three
mainstream ways to get this in Linux:
 1) Use the DMA API and have the iommu group be translating. This is
    optional in that the DMA API usually supports identity as an option.
 2) A driver directly calls iommu_paging_domain_alloc() and manually
    attaches it to some device, and does not use the DMA API. My list
    above of ath1x/etc are examples doing this
 3) Use VFIO

My remark to Mostafa is to be specific, which of the above do you want
to do in your mobile guest (and what driver exactly if #2) and why.

This will help inform what the performance profile looks like and
guide if nesting/para virt is appropriate.

> But I'm not sure that I got Jason's point about " there is no way to get
> SVA support with para-virtualization." virtio-iommu is a para-virtualized
> model and SVA support is in its plan. The main requirement is to pass
> the base pointer of the guest CPU page table to backend and PRI faults/
> responses back forth.

That's nesting, you have a full page table under the control of the
guest, and the guest needs to have a level of HW-specific
knowledge. It is just an alternative to using the native nesting
vIOMMU.

What I mean by "para-virtualization" is the guest does map/unmap calls
to the hypervisor and has no page tbale.

Jason
