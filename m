Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAD316F8F5
	for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 17:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737566278; cv=none; b=r9ONN2HYl59aQI3USLH9Y1vTRUNY1E9XPyNVYgTCHnHu/kAY+NzaQOfCyaWY9aps4Qqec/y9hyqO8UTJ874skUIb5YUn83rJ/2FcLjWIsBH7MpH/MFmNBLFGvj2L3lH1Bw6OEwa+rvwTMiiIJZO0BZKgMce7beEkdHpH7PVphuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737566278; c=relaxed/simple;
	bh=/lUAT6DC5qJzsUrTEn83i5l+5lpAvulwBd3TRcaxpsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TWVZXoF3UllXJjd1TPUmnJXrgXWtfk3lsNYAn2mTSDm7yspz1mdPT/F15xgRDrEJcfn9/pWTkC6nLrqbkgqr7sAgdtj/c7eBHQv2gin6l7/JZOOQ9jBRkIpt+C82hP3zZSblsUVo7j9rkuUYpvUgrzKmkQYJgb2yBzM9TXjq/q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HUX5qi9H; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HUX5qi9H"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4368a290e0dso58205e9.1
        for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 09:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737566275; x=1738171075; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rVn+04C2RZSnNCuyRNAtEoZLpXdVmoal+q/IITqcBxo=;
        b=HUX5qi9HlrXzW0jUkeNWz9hwUsN3mP36tRT8j1pm1ReMmU6mkRRqPQRkoFQmjtya6A
         3iqGNKrX/h5PV9hW5fff+4yOgOa6B9RVRG3cJ6rVYJaFxKjbcIBl/a73JN1gobbq7463
         Cy5KtP04noxG4IwKlLd/whQzCW5xjwRiBD2nUTQ06dUlJS3tT0Jy0CRBUCOx060tQZzn
         R6OmabzBg61B5iL10JxKQUVMP5XnCiXniV5qjBS0TT8eBrliHfambLzwtBnb8Hvzrt1e
         yoDmNGDOtYD/lFfRE3wT3qGF7dnmdAl0pMsEy5yENlUKdyNkeI11Anaes48+LaE7nYxl
         j08w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737566275; x=1738171075;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rVn+04C2RZSnNCuyRNAtEoZLpXdVmoal+q/IITqcBxo=;
        b=SLp5KEoHqQgIVvpKgWRrqcz+RDzcqjqm502Q2R+2klRbWtbVEHHe18rDfVhxvZj0PI
         0HTzRdWDcUTb/zi7wUuVH1U2YS/i5ayQVcdwCUfQA0cQZLaAeeSvXSwpmvQv4yIxgazM
         rzBAWHBl7NoBJx6a/3pxbe5sP55Y0QthedwWrFCzCDv2qvrbRKiMVkLtid1ba69DXOB5
         ZA1WwuhOIm6srRMnc59nWiw27EekdcmEs3JBA74u+p6UVu0XzppdfrqF1Ym/Ngyv7Fws
         kJbjRRZBz7gUHS5VGXjctnM8Jq0/9ARzM6EXphOiRLGRTqOouuYNSWbb6WK6U7MWBz7z
         oU5g==
X-Forwarded-Encrypted: i=1; AJvYcCU1NKZJ6qhmMT9RpXCbUCXQH076A2OYz2XSwjPA5CHsH2Vib8Fr/oabdNzNV8e4Ce/LnirP6lY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4noelXPyGkDmn0qi+h26e1Q/UgHftibHpl779xBOFrpEQkD2f
	lPvwMQbdJ+r0clpiaO92C/cA13JMAnA/cX3lbHOUa/gDhhT4910GHayx3HcvNg==
X-Gm-Gg: ASbGnctcrCE1nhl60rCRsBRBfGNj101FwunzyNPzkN/UKDrB5XHFzM9aYij0WcZ6gUF
	SZwr9SocsIqhb+VddTZPNLSKDhF9QQL8rvUFL9S7mmgYkM28v3JIKAwE85P1D1MZ3eNr0hV2ATl
	og+j3xN8OaOAKicmyN/K56YEw00MFyfGgE+wk4y34h6FLMW00TNhqiLj0aOAQzUQReLnipKbIoX
	crNSF8pbjbloB9aiBnf04QF6d3k/9bM65SfetRAc+5nc8s5YrNd8PmCSZ7NQiKtRfoKrR5jQRqF
	dZkyQbAnIhhVj30g7mgF55ludX8DJw==
X-Google-Smtp-Source: AGHT+IEcwSDzQsZnDZKS1v3rTQ17LH/kmqqhoYTY24yzjHG6NB2YOSFoasiucC8pKLaOn7Z5/gfrAw==
X-Received: by 2002:a05:600c:314a:b0:42b:a961:e51 with SMTP id 5b1f17b1804b1-438b214a8afmr1528605e9.0.1737566274993;
        Wed, 22 Jan 2025 09:17:54 -0800 (PST)
Received: from google.com (88.140.78.34.bc.googleusercontent.com. [34.78.140.88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38bf3214c5csm16835486f8f.8.2025.01.22.09.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 09:17:54 -0800 (PST)
Date: Wed, 22 Jan 2025 17:17:50 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
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
Message-ID: <Z5EoPhhU9mm9zNWB@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DQuNn3GoU1vYPV@google.com>
 <20250122162055.GV674319@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250122162055.GV674319@ziepe.ca>

On Wed, Jan 22, 2025 at 12:20:55PM -0400, Jason Gunthorpe wrote:
> On Wed, Jan 22, 2025 at 11:04:24AM +0000, Mostafa Saleh wrote:
> > AFAIK, the most common use cases would be:
> > - Devices using DMA API because it requires a lot of memory to be
> >   contiguous in IOVA, which is hard to do with identity
> 
> This is not a feature of the DMA API any driver should rely on .. Are
> you aware of one that does?
> 

I’d guess one example is media drivers, they usually need large contiguous
buffers, and would use for ex dma_alloc_coherent(), if the IOMMU is disabled or
bypassed, that means that the kernel has to find such contiguous size in the
physical address which can be impossible on devices with small memory as
mobile devices. Similarly.

I will look more into this while working on the patches to identity map
everything for v3, and I’d see what kind of issues I hit.

> > - Devices with security requirements/constraints to be isolated from the
> >   rest of the system, also using DMA API
> 
> This is real, but again, in a mobile context does this even exist? It isn't
> like there are external PCIe ports that need securing on a phone?

It’s not just about completely external devices, it’s a defence in depth
measure, where for example, network devices can be poked externally an
there have cases in the past where exploits were found[1], so some vendors
might have a policy to isolate such devices. Which I believe is a valid.

[1] https://lwn.net/ml/oss-security/20221013101046.GB20615@suse.de/

Thanks,
Mostafa

> 
> > - VFIO is something we are looking at the moment and have prototyped with
> >   pKVM, and it should be supported soon in Android (only for platform
> >   devices for now)
> 
> Yes, this makes sense
> 
> Jason
