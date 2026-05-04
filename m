Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F6728DB49
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 12:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777896981; cv=none; b=u/aET7pRC5fHx3+ry2o1OoYorrVhlHbDacrlkdTTA/YuqEOIWjlQogBUuQ5kbQxlMW1e6V+93Cg7ud3ot2q+J+59hO7DOP/h0FlbMtENwQoaw48sK7R+TH3ORF4+DilK9KmfZAX7cD3MuroyLjLP2iQJq45tLIP0a0NC+pRLzzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777896981; c=relaxed/simple;
	bh=VveELzghzgx92/9Qy6YBiAz7Qpzrc96gg9l7rbe1IL4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QSiRxGlg4v9yJyeTUofgnj5PrLeEzTsYICWnFLdopgwAac5EsKVmwzNfhjTBrUUAVMpVzTiwkTSfO+oblWUWoViD2JLmIGafyKu2TifFNrcwqlxb0DAbHHe7RF9/GjguBrL/nwh5A9p4eZ2GZVNluNOe88LgtGhujMwDzL2vQIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dNRUfgEJ; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dNRUfgEJ"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891ad5c074so202685e9.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 05:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777896978; x=1778501778; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NU4R8Qu0lIhzaFVACH0M7ebEyvf+bx2epSGVPFsYcB0=;
        b=dNRUfgEJS3LPI5lRc8PMxiOEyLIT1le1Xk0PjLQtOY8RHWhNdCKPCVPA+XYk0cTtFi
         LIHUPpCwD+zeQ4QutUd0CXTYtoa8bVurkRwChCgEinPl0P9DDppAApyonIZE8qBy5IQU
         olGXIRnMXhyC6n03i8jcDRa4065NsdtNVpSD4ke0niaxTx8Bvqbsg2Mv1cRi1DtoaNte
         ERRvERAO4qj9laUBWYg7wZaL3oLtIIPMHD973XDtmivUnuMlCLMC+9kXGXSbznzGZ7qD
         QgZdtQHm7rEapMxXPpCc49a49FA2V0kRU5SeHbVViPMtgDUg/and0yWJtwTS5HhFlCm4
         cA4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777896978; x=1778501778;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NU4R8Qu0lIhzaFVACH0M7ebEyvf+bx2epSGVPFsYcB0=;
        b=H5uFdtrs6o1pikjgA4ZlaQ+r+RxipIifv/yXknZYUMRGOURj39FxyVFe7/ompraWO9
         6fOmj78E1ECBkr/LYkh6P3joTOockMrKBv1BOjq0EW4bTPWMUSRR5tw+45hH/lncgh6t
         iYH4ALlIQtQxoHvOkOwFPsSGA94A7j9+uJS3AwDIMYu1KAam0W+MYfWPAv8aVKm/FYDu
         GiMPpExIMzAkWsfBrB7PY2FeiyiQl4xOWGjlg6oggox0qdlvemxFqhscrOUqZqkJ9fs2
         0w+UnYdCe5uVACpTvdaeq9TYMeWqUxTkGPCBdrGJfcyxaMYSrea3uABrNWbMxnl4ZuCp
         9OYA==
X-Forwarded-Encrypted: i=1; AFNElJ/97P4rDP8Q9/rGnp7xCsxH+eVHrzwOMDpO6jTSxpG8YMv/ugAjFJI6ItW46vb8TrWwKG/DEgE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyZeFg5JabvhrkpWPjkHyrn9yN61XPbLg5wMcCV+jeyBOn8MXCU
	OLVolrUlVwHcKERrH+Vlss2nka4f1KbqNb2ovqHi85KZ4+8ZbBITCYhVJsy4nnGcYQ==
X-Gm-Gg: AeBDietBpN8vbii3uepfbMce7sEJ+yZbc64HxJpgyiMOGjsBxQe0I4ZLMIv91v5uK8Y
	xb6ZuQ2+Y5l5Rdjb94q7yIsvhuARRPstzcdG6IoAwMS+tJtU3vpHMnklBlGpZHchjbQl/5Hn3Wd
	IYfUkxhPM9uscoAUHPSwl/6X4N+5XuC8UgkBRTxzaJABaEMfylF6tC+aFQo6KQ5gApSVeX7K4Vw
	V/8Lo1D/2iptmoYmUzUQY3543Kn0QIaH+kj7sSM/bQht/bbRbBO84jFxKT7E9NLiLPnxUe+ukqP
	KJ8qKrBYtwZw9TSi1YOj1fUYuB8BObsuDyW5N/Jz4JQMs2gIfher4r95rrgHOpTz9WN/uwqeQHg
	wB9ukEb17DZsNWuQGdJoUfsi7TNxiUAlSA+vpn3T1bPV64NvI9ye8rI17rV0muGaHfFYGf0xZun
	hqpFtF0I/f6LLzCyFLKcsv6RX3qP+0bH5VcbroTX967R+OloEHGG589Es5HAoRGGScn2L3PWLSo
	FjORQ==
X-Received: by 2002:a05:600c:4e8d:b0:489:1ace:d0d3 with SMTP id 5b1f17b1804b1-48ac3159bbcmr153605e9.3.1777896977198;
        Mon, 04 May 2026 05:16:17 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-44a8ea7cf97sm29764334f8f.6.2026.05.04.05.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 05:16:16 -0700 (PDT)
Date: Mon, 4 May 2026 12:16:13 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <afiODW2sVMeOj3Ag@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501124716.GD6912@ziepe.ca>

On Fri, May 01, 2026 at 09:47:16AM -0300, Jason Gunthorpe wrote:
> On Fri, May 01, 2026 at 11:19:07AM +0000, Mostafa Saleh wrote:
> > Move parsing of IDRs to functions so that it can be re-used
> > +unsigned long smmu_idr5_to_pgsize(u32 reg)
> > +{
> > +	unsigned long pgsize_bitmap = 0;
> > +
> > +	if (reg & IDR5_GRAN64K)
> > +		pgsize_bitmap |= SZ_64K | SZ_512M;
> > +	if (reg & IDR5_GRAN16K)
> > +		pgsize_bitmap |= SZ_16K | SZ_32M;
> > +	if (reg & IDR5_GRAN4K)
> > +		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
> > +	return pgsize_bitmap;
> > +}
> 
> I think this should include:
> 
> > +	smmu->oas = smmu_idr5_to_oas(reg);
> > +	if (smmu->oas == 52)
> >  		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
> > -		break;
> 
> ie it should return the supported page sizes by inspecting all the
> idrs and don't leave this tricky bit to be open coded..

This way was easier as each function only returns one thing, otherwise
we have to pass stuff by address as we can’t pass the smmu struct as it
is not shared between the drivers.
But no strong opinion, I can change that.

Thanks,
Mostafa

> 
> Jason
