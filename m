Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD6633CEB5
	for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 23:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765926501; cv=none; b=rdkHVVOMiXVWmW7lcwga6jDe+KVtlI6OVwk1jM3jk2wX8SJBj4npx/BPMwE8jmhGqpEU2NLG3G8oTQWST3wHRV9NRaBDcKOoTvzKvnEPyXa6QmrXTRxEYrpJ3lcgED+7UXfacqThLmqZpKmPN7BsP83qSkhXRY7qqwFnLnmLHDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765926501; c=relaxed/simple;
	bh=LwZNqfOuoiJ6sUVjJ5q/voOJVJp/rjqb6MA2e4MaQeA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kQui2dra8rf+XsmOJMHdTMZ5mJTGwIvG8illnm1boO3YYeID9OpyC78O8REyqwZ045w2v9/fB53h1jbbkj6lqBro2jlzUL0mVPkoaFahQ0OZl5yR5hNzmCkAb8PEc+mf3XJNxXv1OadVol1NgcxGxaJz9ggK/E/uGlYpt1nG75k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yNkFD/HJ; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yNkFD/HJ"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-477a1c8cc47so26325e9.0
        for <kvmarm@lists.linux.dev>; Tue, 16 Dec 2025 15:08:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765926498; x=1766531298; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fEnKjDj9pQFaCr4EZmae2jNEPFVNmbflp2ZNa+r+P+Y=;
        b=yNkFD/HJ183WtBUvp4bN2Dn3SlMw1tdkVAc5E7a81WWdHLnxEKGMlZxIsjVgVYU5+c
         HE7VKyizElnvods5776ixY0KJPJD4UPe7b6QZwjgskIIHbE1fUdzNsgv8+zkDB2ISH4P
         pK/wTxZLQEAkNvWxhNKdpfqmeeym/Tfa0lcClLzOe0dXNgbA5dIUCZO0UGD6Dbac28Yf
         q8FMn2tz7JaXZJpp4l6AhHYqU56JtqpEiQGUqCXEau64zPxFxoNCkACGlPzPY0I3dwok
         9qmUdDAVuTh2Z5qCDxbsEQrHtS5wwJRZJ/nIygMRW1QE88GLz8YFZYaXOlijl5jl+TB3
         lQ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765926498; x=1766531298;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fEnKjDj9pQFaCr4EZmae2jNEPFVNmbflp2ZNa+r+P+Y=;
        b=LY03v4AMwJoSP8jJ12G1Iueluent71mfZjh8ymwk3RJvhXbT0ByfaNt+yiFrTi6NoJ
         tlGJeiit8IC3gYUzwBl1EOHBgvcC07ChiBYr6UrQ6QgO0saSSTtH8eHAhULXmBeZVs36
         kavvfLBr26fySgdwTVv9P8hXryWPnGqACa4tZvwUoWwZkPyJmcV/cjOQc/xTfAnamhC8
         c8aqI/ZfVSxVtG8m0wH0HNC5AlZo2enxXR+ARjNXlCEdBSCdNgx9wgjLZsgVQcvLEwup
         sXdkkQxcNmYsNYRpjXw3wJp8Ly33K7ZWYSJ9KdYnBcR3ynoiyYhQK4TM9/txDw5Yi7Zy
         4PPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXpSNr03fSZ/+XdfxbbTbUpXr52L2ydcSN9baUJLMo+wio8C19yC6XRqSNRp9rp1O4EoI3MbM0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzXXKrNVZYP/j29vq+IbuyithHdIJOrIUCjZPCPBUayY9uSjZIB
	BN+GK6CuITojmiX6Slsn68lyweroSHJ0idgzuH6YW5/HUaqKa9oQhvjeshXvsJ0S+A==
X-Gm-Gg: AY/fxX7iE8mCY3gGmdJRjpjEQiyeindBo8QOOyHrfNjrnJRAakcZOy/YTAbl7N8+Mvk
	tTLoWBkTjafI6+eo1pCFyY4sus+n5MvfEKPBvbd2buvUKR1PbhLdG4iR9Jafa7IBq46z9Obt3MM
	MJUgrWWuFfNmVtwJGNZG1A1+oHWz/aqnEM9uH9eMQk2YvZj7DUxMt4roM28jSmCHoCs0bi/mCva
	XPkgSBxRZcbo3XVk7ttSs5vVSnvth6tOxKouqNjg951DJANuBoG7vLB6REEtyOksoNcNxEAMRf7
	JEo7qTGkW67Da99f6iquVINqJa6PZo7Sc9tYm6M9fa18CpvXn0afMck+Jo49G76AVtEOcjHZH08
	tto/N855DukYaYoqepcRqxfNtDlplqeOBLSGfOhQ9b7DwhASVx4/sSbdGd2fma+xdjN9gNiztFf
	O5WuLPrSheinOqZARLMiEvOteTnSf29//L2W3fwpCFCDQSiv6LUUsDCJ+LWOTOxlQ=
X-Google-Smtp-Source: AGHT+IG7LwUc1KusrGX+ZA2zOk94gnfIHzqutaEubqj6+XSKrKArOVejMGxCukQG8Efn/eVNuyxG+Q==
X-Received: by 2002:a05:600c:4b99:b0:477:255c:bea8 with SMTP id 5b1f17b1804b1-47bdd2b0bfamr45995e9.7.1765926498247;
        Tue, 16 Dec 2025 15:08:18 -0800 (PST)
Received: from google.com (170.226.195.35.bc.googleusercontent.com. [35.195.226.170])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47bdc2355d7sm11409285e9.14.2025.12.16.15.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 15:08:17 -0800 (PST)
Date: Tue, 16 Dec 2025 23:08:14 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com,
	qperret@google.com, tabba@google.com
Subject: Re: [PATCH v5 04/27] iommu/io-pgtable-arm: Factor kernel specific
 code out
Message-ID: <aUHmXkdehGGYX5Mg@google.com>
References: <20251117184815.1027271-1-smostafa@google.com>
 <20251117184815.1027271-5-smostafa@google.com>
 <20251128164541.GA812105@ziepe.ca>
 <aTw2x1UlldJGVA4Y@google.com>
 <20251216005834.GC31492@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216005834.GC31492@ziepe.ca>

On Mon, Dec 15, 2025 at 08:58:34PM -0400, Jason Gunthorpe wrote:
> On Fri, Dec 12, 2025 at 03:37:43PM +0000, Mostafa Saleh wrote:
> > On Fri, Nov 28, 2025 at 12:45:41PM -0400, Jason Gunthorpe wrote:
> > > On Mon, Nov 17, 2025 at 06:47:51PM +0000, Mostafa Saleh wrote:
> > > > Some of the used APIs are only part of the kernel and are not
> > > > available in the hypervisor, factor those out:
> > > > - alloc/free memory
> > > 
> > > Why not provide the iommu-pages API for the hypervisor environment?
> > > 
> > > Same for virt_to_phys, that could be moved into an iommu-pages wrapper
> > > too..
> > 
> > I guess that's possible, but then we would have to stub dma_map/unmap,
> > which might a bit ugly. I will look more into it.
> 
> I am hoping to drop the dma_map/unmap and replace it with an arch
> cache flush call directly since the code is no longer modular and
> relying on the DMA API will have some problems with a future patch
> series I'm expecting..
> 

I see, I always wondered about that, it's because CMO are not exported
for modules, I can look more into it and send a separate clean up.

Thanks,
Mostafa

> Jason
