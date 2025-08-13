Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2B12EA491
	for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 13:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755093169; cv=none; b=SErwyNYlUle9MWmArQPyoG6YVNtqsRUgRHbSSz181trghMVjlq1MY4vo4KMztzAD7z3egvviG19O+3WWRkor/hDxGVqOXSxI2fvFbB5MHz5Inj0/T3glk8UIBS3faBPxQIkD/Zq6AvwFFj5IDRQF5cij7T7GpuW9y/xTrt9OTwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755093169; c=relaxed/simple;
	bh=6A5JsvcYaRafCCx67GMvT6tCp9o44qh5Djgvwpo+HDg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ijKUKsGwuPILVJcQ9iy3U+WzH2EnXTI5og8mYdWyqYMKQv3AD5eEV42f2RtaRvB7QZYJDF56Ox3gkbPByioBTtZ+Zh+FmBz5816wZxOBNQ47fZ+TuTXKILAvMXtYqfJo1Oz77V0l42ONh22jqHOcGYHDOznADL+La8i3jC9PJvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zISxliuA; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zISxliuA"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-459fc675d11so56765e9.1
        for <kvmarm@lists.linux.dev>; Wed, 13 Aug 2025 06:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755093166; x=1755697966; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yRh53LhwzwIVu2CoRYc8EdlqoIGtiq5RV6ngg5LPmCE=;
        b=zISxliuA9V05JpcQngr+ASz388wWXzGXz2s556L9I1vX4C4WmCCJGrS3a51+jYTH4m
         IkImfTmdV38PNpbyYoaypooCvsI/VAf2DAkAEImQMGpQ1HkRlob4PjFHFkr5PPkWSJZT
         43U3kikw0vwDCCUgrm8tlMwQgTwIjIRoINldQaEwRRXRwkag44yPAe2iCJaL2G0VWSoe
         G71i9vHj9TbSyQACmU3rencqLUvf9alvZCtlfrW2GF5FPFRKujCVK5q5hq3Eof7cRbqZ
         wO1sYTnyWM1/RlViskPC7nNVTk9ewB51jbOKRmASsqGrPdu6cmRauaEaCWCmLmGuVvjw
         Y52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755093166; x=1755697966;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yRh53LhwzwIVu2CoRYc8EdlqoIGtiq5RV6ngg5LPmCE=;
        b=rssLUe5YnduC/m/kEmgNCWqEH/j0viwSRefrAIc6uuFeXR18Jkiu3BCc3sPDpLr51C
         6o1eyxX+F9a0ePUw91UD1AIMFzXRp+u6Mnou0W6orHnAlWw9clJQjWqIY5FFvNu5PC+G
         EYDGwqx0QuK/wFAC8z6Z0N2yehbJqcHrSmGiPdHTELpmBLlYCeYjRQxJgleV0rFiFlN0
         8WgHJRAz1m46PNefR+ADiJSbngb6PaNnVengXSfkCmEbu0xhSl2Fah4gLsAC00r48VL5
         WVJTTivxXjzoz21wOv0/kpu/uZL9Q2FQet5UBLZlLHzr5O1ROmp7w//2LteGVfwZD95f
         Ba+g==
X-Forwarded-Encrypted: i=1; AJvYcCVUQ8eBmNp662XJapqsaeDVyt1Ti9cHhNXzWXCX9v7SGBmGPgUtmF+NLOpsOCHou4ImhamCxAk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOB8N4VhQdNsfrMjyA0O1kM8vsvsG+1L+8ru/AcjzAqMiWJBuX
	oBSXsie+XybvGChWRatrH9gcOao9tqzyn+E62KXv77WECcAtBHykKwsRB76OESlgFw==
X-Gm-Gg: ASbGnculqeoKDbuP9yTOWhrNgK+El95dJWvUz6NMjYYtsWDQ2pe1vRjRB50Vfu3N/d5
	mnHMkYqJsN7TDU7Ig4k2OYKwKlYr9rvtPphU/C4C5SM7xlTgscPnuNNcveVJpG34WnA3nzg8YcD
	AtIq2fGcw+Nn6m3ECLgB6xSkogJhVGDBm2mpGNGI/RPxPYugKuYz1OYV8QZtsKxFsQADRrgbXk9
	xC+C2gjhbtzmW0FMGq2uROaa7toz/0/R1TwbTSwRIhDuwHrSfK1AxjyyQGmMlH8LnxoYTdreIeK
	MtD89jbesPUx8CemzTGOmD3F+mj7E4F/3p+yt2Hj5+okeKE0yu4DVPouRSWy7xuFZjRuV52gS+K
	cdt27g1sb0YZDfIpf88X8FAEqSKU1j5PISn1CLAXLr9Lnd0kIY6HnCBnDj2PUoeCq1qJIVIkSXK
	SM
X-Google-Smtp-Source: AGHT+IFChMgXbcY7CfRuwbBbzu+f+Z+kFs7pTSJpSto9E0MCkZ9ZxRMPiVmiGbuQ06PfA2dGw4w1jg==
X-Received: by 2002:a05:600c:4e53:b0:450:cb25:ead with SMTP id 5b1f17b1804b1-45a16e80868mr1336535e9.7.1755093166147;
        Wed, 13 Aug 2025 06:52:46 -0700 (PDT)
Received: from google.com (110.121.148.146.bc.googleusercontent.com. [146.148.121.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45a1a537193sm3359695e9.21.2025.08.13.06.52.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Aug 2025 06:52:45 -0700 (PDT)
Date: Wed, 13 Aug 2025 13:52:42 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, iommu@lists.linux.dev,
	maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, robin.murphy@arm.com,
	jean-philippe@linaro.org, qperret@google.com, tabba@google.com,
	mark.rutland@arm.com, praan@google.com
Subject: Re: [PATCH v3 29/29] iommu/arm-smmu-v3-kvm: Add IOMMU ops
Message-ID: <aJyYquSQl_OfNDA-@google.com>
References: <aIurlx5QzEtjpFLd@google.com>
 <20250801185930.GH26511@ziepe.ca>
 <aJDGm02ihZyrBalY@google.com>
 <20250805175753.GY26511@ziepe.ca>
 <aJNiW48DdXIAFz8r@google.com>
 <20250811185523.GG377696@ziepe.ca>
 <aJsXkidmcSl3jUJP@google.com>
 <20250812121056.GB599331@ziepe.ca>
 <aJs1dMiomjtxVwl4@google.com>
 <20250812134808.GC599331@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250812134808.GC599331@ziepe.ca>

On Tue, Aug 12, 2025 at 10:48:08AM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 12, 2025 at 12:37:08PM +0000, Mostafa Saleh wrote:
> > I see, but most of the code in KVM mode is exactly the same as in the
> > current driver, as the driver is not HW agnostic (unlike virtio-iommu).
> > In fact it does almost everything, and just delegates
> > attach_identity/blocked to the hypervisor.
> 
> How is that possible? the kvm driver for smmuv3 should be very
> different than the iommu subsystem driver. That seemed to be what this
> series was showing.. Even the memory allocations and page table code
> were all modified?
> 
> This delta seems to only get bigger as you move on toward having full
> emulation in the hypervisor.
> 
> So, I'm confused what is being shared here and why are we trying so
> hard to force two different things to share some unclear amount of
> code?
> 

Originally, this series from v1-v3(currently), just split the common
code (SMMUv3 and io-pgtable) to separate files and added a new driver
so it was a clear boundary.

But, I started re-working the series as I mentioned based on the feedback
to have KVM as mode in the driver.

IMO, there is a value in either approaches (single or 2 drivers), a
single driver is less intrusive to the current driver as it doesn't do
any splitting, and just add few hooks.

As I mentioned I open to both, not trying to force anything :)

> > In addition, with no standard iommu-binding, this driver has to be
> > enlightened somehow about how to deal with device operations.
> > 
> > As mentioned before, when nesting is added, many of the hooks will be
> > removed anyway as KVM would rely on trap and emulate instead of HVCs.
> > 
> > Otherwise, we can skip this series and I can post nesting directly
> > (which would be a relatively bigger one), that probably would rely
> > on the same concept of the driver bootstrapping the hypervisor driver.
> 
> I think you end up with the same design I am suggesting here, it is
> nonsense to have one smmu driver when it is actually split into two
> instances where one is running inside the protected world and one is
> the normal iommu subsystem driver. That's not just bootstrapping, that
> is two full instances running in parallel that are really very
> different things.

But they don’t do the same thing? they collaborate to configure the IOMMUs.
That’s how the kernel boots, it starts as one object then splits between
EL1 and EL2, which runs in parallel. At run time KVM will decide if it
runs fully in EL2 or in split mode and either do function calls or
hypercalls. It makes sense for KVM drivers to follow the same model.
See kvm_call_* for example.

> 
> > I am generally open to any path to move this forward, as Robin and
> > Will originally suggested the KVM mode in the upstream driver approach,
> > what do you think?
> 
> Well, I'd like to see you succeed here too, but it these series are
> very big and seem a pretty invasive. I'm very keen we are still able
> to support the smmuv3 driver in all the non-pkvm configurations
> without hassle, and I don't want to become blocked on inscrutible pkvm
> problems because we have decided to share a few lines of code..

Makes sense, but making changes is part of evolving the driver, for
example attaching devices looks nothing at the moment as 3 years ago
when I started working on this.
Many of the cmdq code has been reworked for tegra which is not part of
the SMMUv3 architecture.

IMHO, we can’t just reject changes because it’s invasive, or some people
doesn't care about it.

Instead based on maintainability of new changes and whether it makes
sense or not.

> 
> Are you sure there isn't some inbetween you can do that allows getting
> to the full emulation of smmuv3 without so much churn to existing
> code?
> 
> This is why I prefer adding new stuff that you then just erase vs
> mangling the existing drivers potentially forever..
> 

What I can do is to hold back v4, and I can revive my nesting patches,
it doesn’t need any hooks in iommu_ops nor hypercalls.

However, the tricky part would be the probe, as the hypervisor has to know
about the SMMUs before the kernel doesn’t any anything significant with,
but the same time we don't to repeat the probe path.

If that goes well, I can post something next week with nesting instead
of the current approach.

Thanks,
Mostafa

> Jason
