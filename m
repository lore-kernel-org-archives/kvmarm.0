Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23013212B31
	for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 16:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737562859; cv=none; b=DAK0Ue40cdLIdexTSI8KIIHZVIvYHrtYHWv23rITmmuFo70g/MpxNkU4VJT4N2HsPbKT3YdggtzzxWK7AHof7YZldTVjQPJ8tGuBEXQjdvUn/vMRWwitFGMCj/l1BqA/kkY+unYKa5sxqvHBCjQcIXLidCF22fycRvFqKzHUXic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737562859; c=relaxed/simple;
	bh=P2EqU1UXlLpqlLpL3YBFhOiIS1vRxeXI/7MP+rcwyE8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uJw+Z9Ce3INiStC/37ithWIa7jEgwssVVG/kp/32Y8a2NDYU5o4WQM0IJOjzey9YqFvXOpgapgkdSnShcQdBNmrGwDAWqZGRnTE15KW6UnA6uodL5Aj1agBd6tkp6ds16CNtf4uYbTTOMf/ASYuQgoqcs/9fFtrEr9UYXoNJ4o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=ab5Sbocx; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="ab5Sbocx"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6d8ece4937fso54716486d6.2
        for <kvmarm@lists.linux.dev>; Wed, 22 Jan 2025 08:20:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1737562857; x=1738167657; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=T9hDFjf5DGvpzHigba5X0fDbl6l6sC1pecUGU0oUOE0=;
        b=ab5SbocxSz+gFl5RWbOC41teDo9Vh04WJdrtssB4GanMU6XhzPlYTF6IYjMk20afGd
         UM/YTe+cK8MWXbaRAZfopUve8Qt5VxUlDNCZuBuAysZ3qvMRrOxYlA0Yi07LYODHIr4Z
         rpatAY8fwMgeryeyPtwwvB9l65Alt27sjww5NKrhyv/ARhwtYHwPkvChS/kgo0uNHzLk
         EMeTyS3kmE4iYVTEof/cwcPAcKrU88uE1HLW/WDUZEMIxnRzIz6pyVJfbFKkAbZVtl9t
         uTca8nLDIZriU0gli9U7ZptHl241A7xwxYBg92YBJEVNSFzLNRcpI2NfWFm93/O+gab1
         /ZUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737562857; x=1738167657;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T9hDFjf5DGvpzHigba5X0fDbl6l6sC1pecUGU0oUOE0=;
        b=CUov/xwkV4AAClRyOcFEkfg7CatHRiS0Sq9oZUhX36G8WE4jBtF7az0MYI6m90iGai
         8xeo26OAl+4TGAURjat6EcWhp3NqHQN4hMTkKxg8QC43CU6iUJ7WAvWT51/uoReSePly
         yLi5L/kiBUKVUuPNqZh1T3bwi99WPSMRDOIro9ETtQUvc27XDrpRHpz9FjQl2xskNSIG
         FuCgBtDcqkiYvwsfl3bsfEB8YjGT054vnFL1TFNp13GOecB5hOJwsZO12R6wV5VjBt/k
         DmCvDXo5/NTL3qsASevJQ7b3BTb1VW11LxizwaAWE0RoCq7VPrGJ2/5yCrUfrw57svsW
         Wb9g==
X-Forwarded-Encrypted: i=1; AJvYcCV169hbZNy+TARs9Ml9QpLZN2hVIrnuv9Taf8EM8UUD7BXgjSUgQvIQp6RIubYl0PdeGKYsy0I=@lists.linux.dev
X-Gm-Message-State: AOJu0YySA+UX3LrLhUbHZh5A3SX6a7W9wZ5csiceaNRloLYYW4RgE8ZD
	xIIR/tRGV0Kss6iJkfAyB+rX2G1cg4ldFBQ3R6EiwNCNp0EFJ3T5Tr9+U4GPbiA=
X-Gm-Gg: ASbGnctKeRqo5wWxfNpY78APZQAggLYEFAsYtEz9C5jvpZA8+pLTmL7iVKvk/9na64p
	2IEpy6nlLNaK9YRAvn4WBrcuetVlvTX4474mBXb8AXrkf00LEGWeDeoBM47ZOtf0YN3npioSpFR
	U8IWvTjGRkg1gM0yeCvMz7l126AU7O7k7EFLaMzioUZvyqnia4qX3VZe/cNwCcjeTOhA8EbJkqf
	Y0ha/v/zNy51DROt/zpr41MzeKkx2ip5sy0y18yFxIhvim2G4wLk4SxhUT5FX3Ctrkzhj55YUTe
	D8pyRqXWUu9s/JlLA0akEl65eoItXigvUClMR4dTews=
X-Google-Smtp-Source: AGHT+IEO4sjsfZ98DUdmFnOpRcKd5hBontzItCkyvXoYAGu8ZhSlBVq4j7OqBMeWhGsiwNzwffbF2Q==
X-Received: by 2002:a0c:bf44:0:b0:6e1:f40c:b558 with SMTP id 6a1803df08f44-6e1f40cb631mr18093296d6.44.1737562856988;
        Wed, 22 Jan 2025 08:20:56 -0800 (PST)
Received: from ziepe.ca (hlfxns017vw-142-68-128-5.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.128.5])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e1afc23080sm61987686d6.54.2025.01.22.08.20.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2025 08:20:56 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1tadTL-00000003qLW-46Wn;
	Wed, 22 Jan 2025 12:20:55 -0400
Date: Wed, 22 Jan 2025 12:20:55 -0400
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
Message-ID: <20250122162055.GV674319@ziepe.ca>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212194119.GA4679@ziepe.ca>
 <Z1yNWI9lBNIZg6Le@google.com>
 <20250102201614.GA26854@ziepe.ca>
 <Z35rEeSVwfZVA9IF@google.com>
 <BN9PR11MB52767756EE35DA2359C351F08C1A2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20250116191455.GC674319@ziepe.ca>
 <BN9PR11MB52766732572A17627D16CBAC8C1B2@BN9PR11MB5276.namprd11.prod.outlook.com>
 <Z5DQuNn3GoU1vYPV@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z5DQuNn3GoU1vYPV@google.com>

On Wed, Jan 22, 2025 at 11:04:24AM +0000, Mostafa Saleh wrote:
> AFAIK, the most common use cases would be:
> - Devices using DMA API because it requires a lot of memory to be
>   contiguous in IOVA, which is hard to do with identity

This is not a feature of the DMA API any driver should rely on .. Are
you aware of one that does?

> - Devices with security requirements/constraints to be isolated from the
>   rest of the system, also using DMA API

This is real, but again, in a mobile context does this even exist? It isn't
like there are external PCIe ports that need securing on a phone?

> - VFIO is something we are looking at the moment and have prototyped with
>   pKVM, and it should be supported soon in Android (only for platform
>   devices for now)

Yes, this makes sense

Jason
