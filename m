Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E955A48C401
	for <kvmarm@lists.linux.dev>; Tue,  5 May 2026 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777998469; cv=none; b=igPWQE95EA//Hl58v1GODMmtWHmAKVVUDz12uM3e2DylOBF+LyPYWXeqKfNRtX65ExNnpvEB6eBfjtuGVwns0fyhcCsOjCs6T+OeEdwJ9p7Y0fuUSWnJnnh552qrSR/Zacoq9vnX8GlN4sAUvVX3PqZcLFNcyozevk/ZCHpyV08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777998469; c=relaxed/simple;
	bh=ZnXDTKUdX5lnq5iIdjYvuqdBQPDY6gB1BWd6/IRhYGk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FKre4hnJDMod3CF9TUe1ELpL88i9Vbiukx+inFssOT/d50aBLvEgPwhxe/BkVwqNKS6FK4Ryx0F41dETCorE3UPnNbulWk+SpqK4b1Qk7Mnx1mSscRSRwbvWfIs8vKKUOL98UQ5tw5zZMlT0tTFCTWRhj96klo3HCtRxs2ap1tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=l//dWF6F; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="l//dWF6F"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-48909558b3aso59729835e9.0
        for <kvmarm@lists.linux.dev>; Tue, 05 May 2026 09:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777998466; x=1778603266; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=psW2zn2RKA7mDVnr8upNFQH0mArJi5iuTG1xm14kmUs=;
        b=l//dWF6FaXROlsmFhJrP2Yes6Z3Zh2aaiIsUG7tTG+Pe15i699FWuX91LRX7s7HdFZ
         g+YP8SoMu/bOFrdrUMdoDD3I9xpQuez0X9YX4zXmNM3ASi7Ygg10rb2lxvlIEX64Kovn
         QQP1MEGuNEGaRyemPIjliJrTqiQzrss40vaS9EkEdFRV7Sf4mlCD8bDkSPMPr8NkBohi
         Rz5uxzeBH7z3chEpCN7GwV769fAjyR84hjRRv1WjDOCtxcw7pUQoNCZfKYDUAc0f9wCK
         oAmX6iPiPeNMkDypXoeIJWkt0J3ghlzoBZUOexW8FAfCC0Kz8TxWynsi0hfr0GNkXyp8
         351A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777998466; x=1778603266;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=psW2zn2RKA7mDVnr8upNFQH0mArJi5iuTG1xm14kmUs=;
        b=NvFd/X9BPWMGD+NIGOBPQNUGgxEZSqcgKbE8a9lktXJmlkSa4X4PA5BWewFF8HRc3W
         hQ99YurykM8Sg55GgK+9egLwA95gFYXvGLe3LwKBcXQM951BSOrfFhW+mQW2w7lYFlT9
         8xHpPs/z/I8Or/zYi2WrtJsiXCzkUipRQdX65Iiinu+YRKAg70NuUkYwukQIGO3ul9Zm
         gB+QTT8jqA7gAKvrawSGCG1Hk48TCDhOHJ48diwtUB7CqypBuGD9oZP9gOE+H3XZhRht
         Ku0/y04PTnVvrQhskCLIZ5WTg7q1bObMJtBcjQ0rYPF+6AkJ2mXE1l+GAaKA1D5iNEmT
         km4w==
X-Forwarded-Encrypted: i=1; AFNElJ86NEfOUOhTffXpYEL4C3pawJBYV9FHrbmYE1pY1bMR83WWm5Vrn9aZyjqYGgAcNGwSl7Pcl8A=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYgdUGqZ4WE3FG0wxPpEaik/RFbbtvEiQhn+ucTMTfWh6uYK+f
	WU4H+n7YIylaWwiohlfciJhkHTgzT45w9BFsAbSyqGbYR3yShpztciyJI8LCZOSR48k=
X-Gm-Gg: AeBDietu4d03va76UwvOvE2labGw0xqKfmEYAqQDGsV9QUd0u2Jk+bZXnORLExJ5Bz+
	znUYrWFy7Ky7FHgXKlNqCIavTo0fidNP/dNrtAhsr3kB4AYAFufnmaFEiDXg5vjFSp3DUJqeBwi
	uv2trjyA7DJY1sZjNjVm6eh0e0YdKxxv4/3vcXDUUUnxV8MhZwemJZz9WZ3D6zHFmb2e7iDY902
	c6pEgrbyP2vIb4g5XhuggdgVpMfY7PkX0qsAahdd/GGZdLP90YKgfHNP9kcqeDu+R4OA8QQSuvo
	bLaNoAJc5YOWPQzh0ZNY0mvGF1BFZDf6fSdVFDK3Saup9UmY68OLLu6muMbZhSEJsxi3wPs7wdh
	FJ1ryvqk2tDbfikKaQ2tkaCVr1UvdwQXrJvbrAjP9OSz9Xqs8Abv2JvraOnBPwUTO/yqwlVKWvM
	jIUzFmDUo=
X-Received: by 2002:a05:600c:3544:b0:489:1d23:4524 with SMTP id 5b1f17b1804b1-48e51a6229fmr2708455e9.5.1777998466365;
        Tue, 05 May 2026 09:27:46 -0700 (PDT)
Received: from ziepe.ca ([213.147.98.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a8ebb3dc1sm381506775e9.14.2026.05.05.09.27.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 09:27:45 -0700 (PDT)
Received: from jgg by jggl with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1wKIcb-000AO7-2w;
	Tue, 05 May 2026 13:27:45 -0300
Date: Tue, 5 May 2026 13:27:45 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 05/25] iommu/arm-smmu-v3: Move IDR parsing to common
 functions
Message-ID: <afoagb/wVBJD1IX+@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
 <20260501124716.GD6912@ziepe.ca>
 <afiODW2sVMeOj3Ag@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <afiODW2sVMeOj3Ag@google.com>

On Mon, May 04, 2026 at 12:16:13PM +0000, Mostafa Saleh wrote:
> On Fri, May 01, 2026 at 09:47:16AM -0300, Jason Gunthorpe wrote:
> > On Fri, May 01, 2026 at 11:19:07AM +0000, Mostafa Saleh wrote:
> > > Move parsing of IDRs to functions so that it can be re-used
> > > +unsigned long smmu_idr5_to_pgsize(u32 reg)
> > > +{
> > > +	unsigned long pgsize_bitmap = 0;
> > > +
> > > +	if (reg & IDR5_GRAN64K)
> > > +		pgsize_bitmap |= SZ_64K | SZ_512M;
> > > +	if (reg & IDR5_GRAN16K)
> > > +		pgsize_bitmap |= SZ_16K | SZ_32M;
> > > +	if (reg & IDR5_GRAN4K)
> > > +		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
> > > +	return pgsize_bitmap;
> > > +}
> > 
> > I think this should include:
> > 
> > > +	smmu->oas = smmu_idr5_to_oas(reg);
> > > +	if (smmu->oas == 52)
> > >  		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
> > > -		break;
> > 
> > ie it should return the supported page sizes by inspecting all the
> > idrs and don't leave this tricky bit to be open coded..
> 
> This way was easier as each function only returns one thing, otherwise
> we have to pass stuff by address as we can’t pass the smmu struct as it
> is not shared between the drivers.
> But no strong opinion, I can change that.

Could you share the struct? With multi-compilation you do get two
structs with the same name and different layout, it is OK?

That would give a cleaner setup too because you can just shove all
this into a function and have it setup the same struct which is more a
copy and paste than break up into little functions?

Jason
