Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9261E1024
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 12:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777639639; cv=none; b=sKxRQYYMMGrjCT96kqx/++Jgm7yC9K3p/yWRdLjl2N1jEEaFiDmobJ1OFwqZW3Jj+6MCgSZFK0g31tivdFsIXQCWoWdANWjtEYUizLzXj1m0hon3s1PWym8nxqOTuqOHyYhQIgikDYBWm+1jU3sCw23T+y4FuzCKQAr28GcCx64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777639639; c=relaxed/simple;
	bh=GVbC+W+06USeQejyjxxvPv8joUkpomif/D7x44Gf73U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f96Ngwjm5zF4P8Gc3/XonbHMsIkLBGBO6uB97qQf+ENYk20yCSgmPJ0t6SbTDkhVkDOGNoI/z5X4SrjGJciKUUqAhLVr5JJgy68Xbi6G/gbS4cQdLy+kNRVJpxLKQ8T5kYt2ThqJHXbhDI9/cNtTLH9nAgIGlGmjr84uyKPiczc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=kTE/yRWU; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="kTE/yRWU"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-899d6b7b073so19228246d6.2
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 05:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1777639637; x=1778244437; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J6VnYrS4OpoYLvnXY1t3ZH4F+GKUvLaqlaowydMT7CM=;
        b=kTE/yRWUkvxNvJ5gMheESjt5qsK2+6p6/5HEFmAJjqnVTjy9jNtmXPqAISIKDpeLXE
         lsV7bSYJvONsevOuxKLEp1llykKGjy5qjJTEqQFXyOu1D+y3Rels0KKa/3nx52JPk58B
         DJAa9LxB0EbPCb+K9zHgwCZm+SU4w8lDfL2+ZJEdm19zD8NyLT5az8vW1/z15U9Jn6UI
         /YjpqKHj74/RqNxP3JenCUDGDYdjALJmhRXWKswqK9VhIVLX2tr5TZZb5nChl1jrfF28
         Cr7PgcUj5rZPCS5ePpRMS+PquRf6vZJ6/nY+KF7sfTdcXJphSvr3oBsz2YUgNLFS+aPe
         HhEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777639637; x=1778244437;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J6VnYrS4OpoYLvnXY1t3ZH4F+GKUvLaqlaowydMT7CM=;
        b=oy1mRjmruab8KPtKBU4KBwI4qrqkZptEBfctf9BVNk4eOLIholGUBJ5ZxZ4g6OEqll
         hgYPal69ZOjZ76gXQmkZ+vzY7LntuXUEmBiPh15JltjAZ+B7cd+MFV8Fb0699vYYBjfr
         /v5e6SNs2W24h6ARiQKg6weaev9bOvDLb5I6FDceBD2ehedc+hSJ5nL2j9KgWZ4qVeNf
         7UGEqbKjcPTwQXNw6VP+QWkHsRgW/D8afVEpx/J3tMLazU5Sl3DSxcdF+cnD/BlMxomC
         XxZSpPkn4onXeoNSPAbdvxLAs18PacHlo0Y/zr8TQpI5irmdkGp/Foby5PVx/nHgBGQb
         xI+w==
X-Forwarded-Encrypted: i=1; AFNElJ8SoQANFQQ6R//88umME8YG50Jl8Nw/VQZFcKTlDN7DUSlQqx7jV2TgWHeHVLz6NjhRRshC59E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwnHEWljIr814PZJavzePpXTZhYj0xQgTH/idTIWocJvC2W6+Iw
	ZF+POhi2NTtITeW7KIQsywGGo3mznU3UuMwcqfNsxiwCmmQDOrdd6Mgp9DIMkYyowlk=
X-Gm-Gg: AeBDietQ8uz/P57YhBRXtWt6EeAD2HV19thDy0SDuPUbGONrFZ3mGTdORv3lXmoVZ/h
	hO58o5o4kmrsqAwvKbKoki3Sry/fNShQ9qPGzv4SO2k7bNqGcXBPk6rY4zhKHyx6aPpFGHORJ1u
	jVO2turv+DeXMTLfPNYOytM51ZEL5cLsNXgudUhB7+hZ9wOO1KuLlVs33OPGCpti47HApwRtI9d
	3gPowS3++trugSm/cpy1K5avbcDnj1qWUXFuDNLV5XbTsRSJhB968c52874dnPf0Or8g9isZmdj
	vf/glguN89i8rRo8/xxBIY+QdoS06gA+fyghEui3FxZmbjKGUteVUM1PkmzU1TY6gmPZZmtnGZY
	hgjkuj4xMIEtqomGUQSig+TcRlwWFGAlO2Lwt5FAqTqweGWE9DMJI9lNL2rNyFfXriZ3DGQVvJF
	DaemgT+mEpsQkvMhXd0XB6p+p5sfb1lLgrvZTB9H5cEt9kt/lXoJ3lFTuP5xQGaqDFFCG+9TGuU
	Sw3yYftdw8WNwKF
X-Received: by 2002:ad4:5769:0:b0:8a1:34df:bbe3 with SMTP id 6a1803df08f44-8b3fe795fb9mr109078226d6.28.1777639637543;
        Fri, 01 May 2026 05:47:17 -0700 (PDT)
Received: from ziepe.ca (crbknf0213w-47-54-130-67.pppoe-dynamic.high-speed.nl.bellaliant.net. [47.54.130.67])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b53c0e6d72sm25671376d6.26.2026.05.01.05.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 05:47:17 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wInH2-000000059zk-2EQo;
	Fri, 01 May 2026 09:47:16 -0300
Date: Fri, 1 May 2026 09:47:16 -0300
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
Message-ID: <20260501124716.GD6912@ziepe.ca>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-6-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501111928.259252-6-smostafa@google.com>

On Fri, May 01, 2026 at 11:19:07AM +0000, Mostafa Saleh wrote:
> Move parsing of IDRs to functions so that it can be re-used
> +unsigned long smmu_idr5_to_pgsize(u32 reg)
> +{
> +	unsigned long pgsize_bitmap = 0;
> +
> +	if (reg & IDR5_GRAN64K)
> +		pgsize_bitmap |= SZ_64K | SZ_512M;
> +	if (reg & IDR5_GRAN16K)
> +		pgsize_bitmap |= SZ_16K | SZ_32M;
> +	if (reg & IDR5_GRAN4K)
> +		pgsize_bitmap |= SZ_4K | SZ_2M | SZ_1G;
> +	return pgsize_bitmap;
> +}

I think this should include:

> +	smmu->oas = smmu_idr5_to_oas(reg);
> +	if (smmu->oas == 52)
>  		smmu->pgsize_bitmap |= 1ULL << 42; /* 4TB */
> -		break;

ie it should return the supported page sizes by inspecting all the
idrs and don't leave this tricky bit to be open coded..

Jason
