Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08501192593
	for <kvmarm@lists.linux.dev>; Fri,  3 Jan 2025 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735918528; cv=none; b=XySbuPTeijXtAkzwpJcJqJCUpHv6B8+4G8yN41xDwJTIuj52/SDr3NLy1koGbZ3c41goby2ZyIQHiPi39T4PuKYDGsvn/mhmU/DpA3BKdBkCr7r/Jyq66IwMzS7zNTK19f3kyEDJVxrpbZWcmejpRgjcS/JL45Ll29JvE/6A1kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735918528; c=relaxed/simple;
	bh=vcCOxf9MjAm6R004BwmvpnBmn1ugdF3644CrfRERETA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JQphRWQMMvBxTieV5bcrV42cuvs/q6xlI6J5kxMdk9avoWYanHpEsBHImonlLc9m+xKlfdcuFHmG/QTQB17faKkfhpgYPHO1CVgpmbLJojg0x6lYrDTJSvpVQ6BE0PpyqS7h7JuTSBR/7HDJLcfvKmSltTOANV5ViQm55LZPoOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I/AszDTU; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I/AszDTU"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-43621d2dd4cso57365e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 Jan 2025 07:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1735918525; x=1736523325; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=7TAFKlJ6U7QCklm7PSgnN2whltr6YSbd0ouHsKVqiJ0=;
        b=I/AszDTUp6GYgFaa1bkY9aAM9HPQMXKcEehUCobNOTqRT9CUcBj6DG7wp36YUoF8oS
         fmyLaksj3GWeX1HXJZ0nHFIfIdkmqYKPNM6o0z3WIOggUwJ6ZU6ZEmJvNwato0TDNTtk
         74t1d1pLtO/W7e33eNFJi9EArAjM+xGmZxx7euIW7gmzMkMKqYdvKS3K54ZeCZbQquqy
         32OAH3jBFB6A9qehq/0IfQbMylI4ttQtSmInwctLF8zBhSuAH4ZOZWrF3vF4Iyyz1YYE
         zd87dtGa58Oz1bZKgfLbfqa/Z12XpskqA+E6bfaf8DZfmpol34GLBE2aUnjQBmEglzTA
         0TVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735918525; x=1736523325;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7TAFKlJ6U7QCklm7PSgnN2whltr6YSbd0ouHsKVqiJ0=;
        b=XPV0EkZJ7p/6In1r3N/g/+d1fYNlIuvjkpse3FI2mzDjuvC1+OStDXGMFsV0jgU65D
         Jhq0lfmFJDvrQSnf8gjMoxYkImfaSo8HTWuxygJ4p3bhNZUkltfI/hDa22K5RUca54KE
         964PTtgdnbY0MPkfhsAGHM57MMMTtMiW+UvTccaLpo1pVophMP5y/LlYa+K4P6c1+ZF/
         IMwuld9Tx5+s37FCQHB/ldedooSI9L5h846TnQG26+eFoCvT4dtM1KXYvXyjxE3ehE4j
         A9S/92M3IsbXMLYpXKNoUCcWPanqRUxdnwaHyd+5B8JXNN7YUWSroy9I9e4j1Yc7gG7K
         EgtA==
X-Forwarded-Encrypted: i=1; AJvYcCWsFHNbSe4yCaZbFoHC3Eup9TWXXhKT373xMLfF6unl432r4r3lVlfEP18g7gwJfz81FYEvqwE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnJd6dGa4KvJ6fz/x+j81wvvk26OmYA6wf3f1ygQCOfqCtVOx1
	YOota3RZA1VR2zfZAf48aespEtgKX7tBebXI21ORn6saum1kgKCU8LOpCTULwQ==
X-Gm-Gg: ASbGncup202Sfhi1PjipjcJy3Xd7ycvHLowDE3B6Lw9V6M7J93K71eeitKM5Sm0mgNa
	39xkeH9VWld89ai4IGHulOn+1QWD6MeL73U1K2Z799Xo36O6qB/Xia3/WEJWTHsEECe7HN0sbqM
	1dZ+DUJcxUVf+NR7rXD2PXNao/yeVtg34CaYx4AABXywNry4MVw6jXMecu0FTo10BzlHwUr2AS9
	Z+ofVG5v67n6oVdUFY+CNnFlfpusIx/PH6q/bOWnTbXdtRnwjOCT97T3e+5L/GFqlpoU6vtRpFz
	xoatXL4XnjIpnW+1YIg=
X-Google-Smtp-Source: AGHT+IFYpv295mC4BjSl9FSXlia/fjrHlkEb0FIGQ5Me85JthE8z4rdE+//UhwlzrKWnZRqRsAmKQA==
X-Received: by 2002:a05:600c:5788:b0:434:9e1d:44ef with SMTP id 5b1f17b1804b1-436ccb413f2mr875415e9.7.1735918525147;
        Fri, 03 Jan 2025 07:35:25 -0800 (PST)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38a1c832b32sm40339218f8f.23.2025.01.03.07.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2025 07:35:24 -0800 (PST)
Date: Fri, 3 Jan 2025 15:35:20 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Robin Murphy <robin.murphy@arm.com>, iommu@lists.linux.dev,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
	will@kernel.org, maz@kernel.org, oliver.upton@linux.dev,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	robdclark@gmail.com, joro@8bytes.org, jean-philippe@linaro.org,
	nicolinc@nvidia.com, vdonnefort@google.com, qperret@google.com,
	tabba@google.com, danielmentz@google.com, tzukui@google.com
Subject: Re: [RFC PATCH v2 55/58] drivers/iommu: Add deferred map_sg
 operations
Message-ID: <Z3gDuPe5C1Uj7y4m@google.com>
References: <20241212180423.1578358-1-smostafa@google.com>
 <20241212180423.1578358-56-smostafa@google.com>
 <ce4c8db4-4895-426b-8d9d-97dc5d74fbc4@arm.com>
 <Z2Qshft8lQjI-x7c@google.com>
 <20250102201831.GB26854@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250102201831.GB26854@ziepe.ca>

On Thu, Jan 02, 2025 at 04:18:31PM -0400, Jason Gunthorpe wrote:
> On Thu, Dec 19, 2024 at 02:24:05PM +0000, Mostafa Saleh wrote:
> > I had a quick look now at s390, and it seems a bit different as they only
> > notify the hypervisor about the iova range being changed, and don’t need
> > to provide iova->paddr mapping which pKVM does.
> 
> Can you explain this statement some more. It seems strange to me, why
> would the pkvm side, which has it's own page table, need to be be told
> about the iova->paddr during range unmapping requests - and why would
> the host/guest side have to unnecessarily store this information?

No, it doesn’t need to be told about the paddr on unmapping.

The problem is as follows;
- With the current IOMMU API, an iommu_map_sg() function ends up looping on
  iommu_map() which is very slow as map is a hypercall and there is a lot of
  context switching.
- So, we add a map_sg hypercall, instead of consuming the kernel scatterlist
  which duplicates logic and can be complicated to do. A new iommu operation is
  added add_deferred_map_sg(), where at iommu_map_sg() instead of calling
  iommu_map() it calls add_deferred_map_sg() to add mapping, and 2 other new ops
  also added to create and consume a sg request which comes from a single iommu_map_sg().

The drawback of this approach is that it adds 3 new iommu_ops with a bit of niche
semantics, which for now only used by this driver.

An alternative approach as Robin suggested, is to treat all iommu_map as sg map,
and when the driver gets the iotlb_sync_map() call it can just issue the hypercall,
however this call only provides the IOVA range, which requires extra work or locking
as mentioned in the thread, and as Robin mentioned s390 doing something similar,
I was highlighting that in their driver, this call only notifies the hypervisor
about an IOVA and not an actual pv map as pKVM, so it much simpler in their case.

Thanks,
Mostafa
> 
> Jason
