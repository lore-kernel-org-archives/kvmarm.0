Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BBE92153CB
	for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 19:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737573380; cv=none; b=nwqLLCE85HzKntVmoKwl7nKr8rW0aMLH0XQ8C9RAWCQeXPpHHu7nGPV9ZJPDjwo9NMXcvTN1yyp9KR4aBW5WBqE1QexEq+ffKHSpio2e/u2F+TXwW/sbFBUgZUQMpEj9lQheK0s5+HYlpoqiKVQi+Y6rw69S1WSe39zrvLG5Sic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737573380; c=relaxed/simple;
	bh=ypor4M9x+5rBi3kT3us8u3pNrx4D7wwuDpCyujcgFdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OjjkdYGmjp9eIrfINA6k1sLakYTUoJWOghDkjOuSUKM6RAUBY7nv+mX5b+yJS4evRhJ58NvIs39z8Q0PNEiphDLe2iKUERa9waUBYYCD58DMXEe5DXASTamgRaHIJ6ryUxRavBp6SDVLCYvgX2GeGv1lN1wQvv6SBFK3w7Poekw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=TY3EWZtG; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="TY3EWZtG"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7b6eeff1fdfso2938385a.2
        for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 11:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737573377; x=1738178177; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=StBs1yybCW0ddI0aiXdemem+T65OMsy4WM+BdrXHgOE=;
        b=TY3EWZtG5dAxu7DUoi0lOw4VYtFVyvUNXA06LPXRUbp5AxBUiy225ir3QArhn5dsG1
         ZBpFjgGr03Q9BrHb0Ny8n7RQ+qgdi8Y34xqO92aY/x0iENrQHrN3pmAwC5MyFtxk1Nud
         xHmm4NF96wOJf/znEfUjVi/7IVvDrxGQPyPDM0NIs9jOkbnWvlgOHgPNXDhitvDvFI9T
         5j3vQZ9UetLu8CZx+8SMX+/MkoqUQDS/30pn/8jYsWhoixWNYZJMhrlkCzdLX26x+g0h
         dZdRfGmRVIJ8r12BS6sR7p/ez6xNC0JIdPuBb+2j0HFBwhoRhRCMWl0ikIIOMPMzuMbC
         k3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737573377; x=1738178177;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=StBs1yybCW0ddI0aiXdemem+T65OMsy4WM+BdrXHgOE=;
        b=L8ZaS/nBLJqBhVeUGkoM1i+dVwpbNZ4grko/C7MCNpXiyFzmRQIWFKlPm3BZPxmYxr
         TiY2Ku1Pnp9jg1OajVc6j54JWy3uR3buw6zWUOcfMSmUnHMGx4NnJLZbxxu75Khl7oHo
         f3aNAM2w27nyTspfNiqRVwboVY5F+F0kheFqPiYKlgehVs5PvRyAvCx8D+C99vbJ2j2M
         nz92WCvGX3XlLJ3hAc4skXTEjUXEQRDyJeaxfdKPTiYeAUAB5OiauHrv1LfXgvFkz0Iy
         zZpBWjI22T4ArorOxpydiMNQ2ZMl9hLXeEN5RphdNMdS/1tq0lhvb9INyf1SzNQ9dxXl
         4tww==
X-Forwarded-Encrypted: i=1; AJvYcCVJHHDuL3khZ8n3GLyGHaw7pqpZi96YDPgPY8wgokB11srmNBeig4Ke3YRMrt4G8juFGTAFJCg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyOh4HY4wd1acM4AqjRPvghXw0sFbbe1oIdxQueZcJ4OBSsJzwr
	fyTruCVoWcag0hbsGUieXanH0vHfqVqjpZ4qtF5xV0DNa2RF3flJ3pkMMz+LJgM=
X-Gm-Gg: ASbGncsuAqogF8fatnOCZzfJ6t9qG5N9haT1VKW1cqcPm4r9dtItfjSObjmhOWqljzG
	ybKOcgX12ObA7HfNFnVaG40Qx3Z+BHc5LBo+8WOcPk8rhJ229gRkcEI7m3D5cOJUnb0ErhH1IzQ
	DKUELoLFzYdNOkWEqY+xTVmzBnK8QPSxSdL28bRdCLhc0e5wMaOH1qUiw1KjCgn4+exIdVymPib
	BiWxXF0gwe+jf1y9UsbeJMMx5VCF2HhDMrzo+f+z9kqv+GElyxgflQfSmR0qrQlVlncxVeG/N9x
	u4nU3R48hAPVY2IWljcMQpsZ78jsSggXpV8et8og9z4=
X-Google-Smtp-Source: AGHT+IFVrl9HtlsCxgPAX2pD8bZ64h5nRxXoX/dvVQ3V1TgnXiLnupfnJHpYt7QXTpYGl54zFfzQXg==
X-Received: by 2002:a05:620a:601a:b0:7b6:d632:37be with SMTP id af79cd13be357-7be6320bebcmr3861755385a.4.1737573377534;
        Wed, 22 Jan 2025 11:16:17 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7be8b26abedsm123129785a.34.2025.01.22.11.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 11:16:16 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tagD2-000000042qJ-1azx;
	Wed, 22 Jan 2025 15:16:16 -0400
Date: Wed, 22 Jan 2025 15:16:16 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: "Tian, Kevin" <kevin.tian@intel.com>,
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
Message-ID: <20250122191616.GW674319@ziepe.ca>
References: <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DQuNn3GoU1vYPV@google.com>
 <20250122162055.GV674319@ziepe.ca>
 <Z5EoPhhU9mm9zNWB@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Z5EoPhhU9mm9zNWB@google.com>

On Wed, Jan 22, 2025 at 05:17:50PM +0000, Mostafa Saleh wrote:
> On Wed, Jan 22, 2025 at 12:20:55PM -0400, Jason Gunthorpe wrote:
> > On Wed, Jan 22, 2025 at 11:04:24AM +0000, Mostafa Saleh wrote:
> > > AFAIK, the most common use cases would be:
> > > - Devices using DMA API because it requires a lot of memory to be
> > >   contiguous in IOVA, which is hard to do with identity
> > 
> > This is not a feature of the DMA API any driver should rely on .. Are
> > you aware of one that does?
> > 
> 
> I’d guess one example is media drivers, they usually need large contiguous
> buffers, and would use for ex dma_alloc_coherent(), if the IOMMU is disabled or
> bypassed, that means that the kernel has to find such contiguous size in the
> physical address which can be impossible on devices with small memory as
> mobile devices. Similarly.

I see, that make sense

> It’s not just about completely external devices, it’s a defence in depth
> measure, where for example, network devices can be poked externally an
> there have cases in the past where exploits were found[1], so some vendors
> might have a policy to isolate such devices. Which I believe is a valid.

The performance cost of doing isolation like that with networking is
probably prohibitive with paravirt..

Jason
