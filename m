Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2006A277023
	for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 18:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747418602; cv=none; b=NUOHoo2Gt4A6wp8ouHaf+AMvzWKoYzFhtfG6yGzTPysl8bXBI0vXlhAbZq7sj3Yqt8hEF0tRdTbYmeY2O1Ym1L9+kOXUgL1aLKaoEh8Djd4h6UiMu/p/BFoy+FOlz/oZdqJ7aKKrRV14Dy7EpBgd2LVRD9R0mH2yGFCGl3FL1t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747418602; c=relaxed/simple;
	bh=QwHSSZaz008TktgLseIpVKn/WtCsa93KH8iOr30Ak3w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BsDTyV858kwaQUD065f7wUeoZWDRM5SGB93ApLY/m2FboUdxXBtoIF2PuN4kZW50FbXEEYqOMDrbQLyUmtMlpehxkGrQY0gghoTKPLjauMIsQ/o5w7wMoZXcuPLa29ge+I8vpuipSs1DGoG0zSY8E/shm/+p+Ah4cEO+fDdv7Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jo0Drx92; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jo0Drx92"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-441d1ed82dbso23022215e9.0
        for <kvmarm@lists.linux.dev>; Fri, 16 May 2025 11:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1747418599; x=1748023399; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6K4DAi8oh2JImogQbX7MYeT2JhKWy+PA/O4SxBmk53g=;
        b=jo0Drx92bOafTiRg4GEaF99lrHbRBAOYWfsX9T2ZCPVihnEOCOSRUSGhYphbdtW7Ku
         4Hakc4iLqw6Md1wu7Y5tCXJe7q9NpJuA77NGcJUgt6OXkWcQbMNUBu/qTceFEFyTAd3A
         wsc2FMmxpOGkTNv4EwDZcLVN3je33jNGbY1TO8zmaWH7zECVQuLHVrm4xhVurBOj0SiL
         vxgywreeS3WIYre0PjOA0X+Wd6lpA3kMBpy9ulIQNg/BBfcZkxjNDM+g0+pClmnXffBk
         dOZthKtZ9s71dhvDS/Ote6+QnQmw/amR1fb63pOPgqJOb7ifQWOMOpODAhp/JZQZm30Q
         QVzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747418599; x=1748023399;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6K4DAi8oh2JImogQbX7MYeT2JhKWy+PA/O4SxBmk53g=;
        b=BBoXGYjxKtLJLS8jF103Utm8TF8mTA6Q1HP+e4jMHQoUV+63JMFr8ZHtWALOBS6NQU
         gAFMgS9kX5DThTqv+irfFn3BpqaS4pofJOK6cSwIFB6nuwunK36FZYsbEOtVTnKxCu4C
         nc18W5p6xL1UVRe5rmC6J88Au5SxMONS3oC0WcPkyGrPsj2oTBQdgNkMZdShTwam313c
         cpsfH6oP0iozUawKHkOwOcMtl5HgPfsvBq2rjZbRWkjePTJWm9q02ouDVA0zGVbaa+63
         1jzoQYg/FkkiKkd1FX8sfDq1BVHoQENNxZKKl1+IaUO7acGXiMMdwDTSz1/m2J8ERQSm
         BEtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWdpjkokEeQV0msIZetevgYqhQ0rMPXUSKysIWK0LjQRx221P8ike5CaSJWem5+Cwk73IeJT5k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5Ul+j8HSC+voU0dv4A3ZhaEmdcR+90HOFEvy3DShsZS5rdsHA
	UxwtW5OdFfpZyyJfSAMwacdsaVo2ryk0A+3qayc6zduqxt+f16cw/dPt9vm0mu9c4g==
X-Gm-Gg: ASbGncvCaGzx9k/75qVhcK9tmhJRtFuV5plykxRFIa7TADML4li7g/KIztZ8t8+ff8Z
	6psB3CPFx0gddLYYKVLbOHgKh3o2yB/ERX78onKAFzSDAGR2iH/EFQrHW4BWw9x71PYwuSQe4RR
	oEssl9xFZgl25r49jcqkU1XYqjt7sw/mR4pP9fTQq78B7RnjaI65lIKTgIj0FP+5IHXZ1qYjQOD
	tFu14brVaPtfy4728fXWLg8MG6B8lQ7phFUj2vNkZffXSaDB4GoLE2+Wya35c6ityEouSKfSWQ8
	Y2W8J8IASGUmG2DD5rYEoP6Mi6M+pTS5DpXTn3SBSWxcJTYRuaswqk3eMWnL2iWGMrfpzEKTo0l
	n8wBYbqjYGjDj8ZqJ
X-Google-Smtp-Source: AGHT+IFQSsiI9vrwradpXzloXrnGaAlmo3vSdM82TZe2t7ORRAfPE4k7Pcg48JUAfkH5OLuMwkRHsQ==
X-Received: by 2002:a05:600c:1c18:b0:43d:40b0:5b with SMTP id 5b1f17b1804b1-442fd6607eamr37352735e9.25.1747418599028;
        Fri, 16 May 2025 11:03:19 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-442f3380539sm118985205e9.16.2025.05.16.11.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 May 2025 11:03:18 -0700 (PDT)
Date: Fri, 16 May 2025 19:03:14 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org,
	qperret@google.com, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-team@android.com
Subject: Re: [PATCH v4 10/10] KVM: arm64: np-guest CMOs with PMD_SIZE fixmap
Message-ID: <aCd94sBdThAj6jT9@google.com>
References: <20250509131706.2336138-1-vdonnefort@google.com>
 <20250509131706.2336138-11-vdonnefort@google.com>
 <864ixkfynk.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <864ixkfynk.wl-maz@kernel.org>

> > +}
> > +
> >  static void clean_dcache_guest_page(void *va, size_t size)
> >  {
> >  	WARN_ON(!PAGE_ALIGNED(size));
> >  
> >  	while (size) {
> > -		__clean_dcache_guest_page(hyp_fixmap_map(__hyp_pa(va)),
> > -					  PAGE_SIZE);
> > -		hyp_fixmap_unmap();
> > -		va += PAGE_SIZE;
> > -		size -= PAGE_SIZE;
> > +		size_t fixmap_size = size == PMD_SIZE ? size : PAGE_SIZE;
> > +		void *addr = __fixmap_guest_page(va, &fixmap_size);
> > +
> > +		__clean_dcache_guest_page(addr, fixmap_size);
> > +		__fixunmap_guest_page(fixmap_size);
> > +
> > +		size -= fixmap_size;
> > +		va += fixmap_size;
> 
> Can this ever be called with a *multiple* of PMD_SIZE? In this case
> you'd still end-up doing PAGE_SIZEd-bite CMOs until there is only
> PMD_SIZE left, ruining the optimisation.
> 
> I think this needs fixing.

So this can be only called with size either equal to PAGE_SIZE or PMD_SIZE. I
wasn't sure if it was worth to make it more generic than it needs.

But like for the first patch, I can make it more future-proof by handling size >
PMD_SIZE.

> 
> >  	}
> >  }
> >

[...]
