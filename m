Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1432C2B9B9
	for <kvmarm@lists.linux.dev>; Fri,  3 Oct 2025 13:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759499157; cv=none; b=C7OTO2OvAxJtYxqne/yNGQ9nTIWQaOrQEI7CHSZ8V64d7kcQORhPFMh+dvVA7dlU6MBulQQr/8CCgh/u5acMdzZ0vmELRtjlPbo901x03Dz9kArXiRm2sD0rWUwNCK1WgN0etYXOdHbh0jXMaDN2qam8DqMs0p+YUq2okd49s5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759499157; c=relaxed/simple;
	bh=lAOM2D3q+yPPPrqg95DoD4MK+sOaAd20YYEUkxw5gc0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MxU4hxSpxXbP3Nq7oscgNusylaneVlLQn7U4Fxz7N6H9EEd5rdn7N0brAUm+IBh0H7RxI3TQxFxHl4TuV7HacFkno5kx4nT8fYsLIqrd8aMeAXcjsJJC4fA0IV9EBNX9mvf0lyRwximOXTrPA0oX/47zniYT4NBTxJooCzi7cx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XlmaD7Mt; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XlmaD7Mt"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-3ed20bdfdffso2126157f8f.2
        for <kvmarm@lists.linux.dev>; Fri, 03 Oct 2025 06:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759499154; x=1760103954; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a7NnV3eqraDFqVYDcKFCeKin09qktano3eAT2xMof4Q=;
        b=XlmaD7MthRv3KxwP/YvNLgcTlylRWwkTq817nNNHqlalIQUcY53P4lu9ZiF3Ig8QpM
         fW7b+l9hn7t6ojH7GLktLVCQ/qrf22CwtHQ4ahNeW8dnGSjOrdvonuAC/MvkBIijl1cg
         tTSTzd6SIGwClKHHGc4tTKr2QkSQr7kYUcap656ivwzFVT392/J+BpsCaVraElC6JRqX
         ordurJybbThdYzhjjwFakVniX/7z2mn+JUuPfzEdAHL3ak8gQuoTsKSPDXqQsAqJ45R+
         jJ1qDM3JQ82NQ99BkbxtxAfuPl+HDo6vH6nOpgVGYIubA5SnklOn26J6uY/l8UB2GHiv
         8arg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759499154; x=1760103954;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7NnV3eqraDFqVYDcKFCeKin09qktano3eAT2xMof4Q=;
        b=fM3hnGa2fqg5qF9FUwqIPA9CgBmm2XSQS6oNPiyR8or/5/BWkVj/Ea4KDjj3ms026A
         YJv3eLjAnrt9211ItDaJxMw0d0p0M7cp7wCNJtEV13bJKkIs5xWfsVhjHlgNsmWt77Uh
         4VSv1cDgRAz6LWpuNlueffUe8MbFMMqMQ7s2L0CuNLr5ceeJt4F90jK8Tp1BW+zhBt14
         ruLNjnOgzUyPZrb7JF9aLdpUKqkbMUzV/gL+VPgU94BIngB7VHXcifDW8PKrEnFVXS+x
         JmX/UUmCthKENTXszPkcS6G3W6eyRRV8v2lRxKcq6pKNOF8NCVXa6jnxGbana7yDpRD7
         jsxg==
X-Forwarded-Encrypted: i=1; AJvYcCWkFEvaivyl1zHN1BBX4oATFVp6J/8r/ehTGJpbKpjEsp84TXe2keezpqQnDRhJkvUysHgnmvE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyWTiIlF1xtIOZb1AUxOHqphbSGGzpxD1ZKbA4Q3piThY5VXzD7
	uXvF8qrMPrusgOtDiRtZ+fwlZALiT64SmY5SxVD+npjUS3SQwUVFOclOArhHjLIvOw==
X-Gm-Gg: ASbGnct+7sBGf80PKwIabdX1p1Rsq/UUisJ87ZTfPcD4lKD+pu4FVGoVBbjgGmzfIDT
	s/m2EaZVbwizZ54CLLoqXubzBn4vE1KPi8HT0vw41jmGIzWXqHalWSCz5WfRJ4kOJ/ujmTfYauk
	nzW1mPqCbAbtzuSuSQCUctYuUT/fL0mBU1PcbBXg6CXc5BF8BcATIKNl6aHLKk8RNuHDlwoV2ZZ
	5z1s9ztMKTIAv6xKT05z24H66pgUffWjnWGgeYYeHSNc58QvO3MtF5ExVRbohpJKAEDSbP90o1r
	cRbraEQuGOYS4HtRGPwm63M+ZazKHIoN+XQLgpFfAoB/tIydlvFZM3Q8lT8ulndF+jO99b2tsYt
	6I/YZJzIjH5sCAkNeNveqSMgHUGLe1ekrg0OQuC1LQ3C2CEQdwj0Q8C5JA8GKzh5IxUWdzQzEy8
	rPBcW6aWPX0iAR1Q8yKyOyB6HBjxP50qMLn0YACQuRAw==
X-Google-Smtp-Source: AGHT+IEavx1XQVkYuSWqBefYKiu6P3uDkj7db45yOXEIBwP67t8LkAcoTa6xCOF8nZoREgj6u0pW7g==
X-Received: by 2002:a05:6000:616:b0:3ea:bccc:2a2c with SMTP id ffacd0b85a97d-4256713edf9mr2335026f8f.11.1759499154166;
        Fri, 03 Oct 2025 06:45:54 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f01a0sm8064916f8f.48.2025.10.03.06.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Oct 2025 06:45:53 -0700 (PDT)
Date: Fri, 3 Oct 2025 14:45:50 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, joey.gouly@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org, qperret@google.com,
	sebastianene@google.com, keirf@google.com,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v2] KVM: arm64: Check range args for pKVM mem transitions
Message-ID: <aN_TjloudttqBUtf@google.com>
References: <20250919155056.2648137-1-vdonnefort@google.com>
 <87plbkxcvv.wl-maz@kernel.org>
 <aNG417MneSKBxyn8@google.com>
 <aNHcxAJXHeS2T7TH@linux.dev>
 <aNJmA-1ZlikW2Knw@google.com>
 <86plb7ync9.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86plb7ync9.wl-maz@kernel.org>

[...]

> > > > > > +static bool check_range_args(u64 start, u64 nr_pages, u64 *size)
> > > > > > +{
> > > > > > +	if (check_mul_overflow(nr_pages, PAGE_SIZE, size))
> > > > > > +		return false;
> > > > > > +
> > > > > > +	return start < (start + *size);
> > > > > 
> > > > > I will echo Oliver's concern on v1: you probably want to convert the
> > > > > boundary check to be inclusive of the end of the range. Otherwise, a
> > > > > range that ends at the top of the 64bit range will be represented as
> > > > > 0, and fail the  check despite being perfectly valid.
> > > > 
> > > > Do you mean allowing something like start == 0xfffffffffffff000 and size ==
> > > > 4096?
> > > 
> > > Yes, this is what I was alluding to on v1.
> > > 
> > > > But I guess that would still put all the following checks using "addr + size" at
> > > > risk. Also, I believe even the code in pgtable.c wouldn't support a such range
> > > > as it is also using a u64 end boundary.
> > > 
> > > I'm not sure I follow. Ranges are pretty commonly expressed as a range
> > > terminated by an exclusive value. This just hasn't been an issue yet as
> > > the page table code is only ever dealing with TTBR0 or VTTBR
> > > translations.
> > 
> > If I do exclude the end boundary, evading checks would be as simple as making
> > sure we overflow the end boundary?
> > 
> > e.g. __pkvm_host_share_guest(phys = 0xfffffffffffff000, size = 4096) 
> > 
> >         check_range_allowed_memory(phys, phys + size) /* nop */
> > 	....
> > 	for_each_hyp_page(page, phys, size) {  /* nop */
> >                ...
> > 	} 
> > 	...
> > 	/* Install a valid mapping to phys */
> > 	kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys, ...) 
> 
> Why shouldn't this be as simple as this:
> 
> static bool check_range_args(u64 start, u64 nr_pages, u64 *size)
> {
> 	if (check_mul_overflow(nr_pages, PAGE_SIZE, size))
> 		return false;
> 
> 	return start < (start + *size - 1);
> }
> 
> which correctly deals with the boundary issue?

I am concerned about allowing ranges that will still overflow "phys + size".

e.g. phys=0xfffffffffffff000 and size=4096 would pass check_range_args().

But in __pkvm_host_share_guest() that would mean:

  bypassing check_range_allowed_memory()
  bypassing for_each_hyp_page()

  but installing a valid mapping to phys with:
   kvm_pgtable_stage2_map(&vm->pgt, ipa, size, phys, ...) 


> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
