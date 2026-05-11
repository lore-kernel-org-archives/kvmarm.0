Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF9B36D9EA
	for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778498214; cv=none; b=TzXS8iL+DJHl4I/n8bfku73XzN9SvVt8Nz4DjkJ4ZO9I1fF3ajtJuK7KOEXsBjSsiZGfu8ju+V6I1kWwJf0Ec7Ve/sLBrF65erGCp7slteixz6kSism7aXyjuv3czyP3N9Xv/TDx8jVA++Juww6oS/bWEWg8DVozkHiH/+wrqmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778498214; c=relaxed/simple;
	bh=aWrmuPCEUpNW6pyyMCyT3Ev0vO66QbU8APlpujnwPUQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PyECEdV57cPn2UjqgBlvdr8EcRccQtUY0LrfgFzxTvps410IWEC9OKSSP8fT9vy7RLeaQThnenfLVcZ/tF562M6Es3VBC9XpitgepmrCgCIlAZuYyype7XhS6ByTKHJmAwIB/iGZkdp5IUgfYGlufvEkuF0hhFQiSpXKslarqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SQznqZCi; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SQznqZCi"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-488940ccfa6so305e9.1
        for <kvmarm@lists.linux.dev>; Mon, 11 May 2026 04:16:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778498211; x=1779103011; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mjFxAsYJ767LfglQAiic8pmf/v4fVUq2j4oVrXIto5c=;
        b=SQznqZCi8mv+rE6qlz33SVquPCr58Znloijir/WGQKn3ZjhLL3+wPQseXtvqDndBNI
         WoHutkhimaz9TayCb+Xjwrwc0L4ZNsPkFkmievdJ2m+dNmmd7gvb3khTces1/bIAbmak
         7F/+Y07lZqXr6NlwJNJAhjUMyJMKXIplHu52GQEb3mz8w2/+S1jutU22mccQsCC8XmBg
         jlLc5mheZCp249taZ8dNdXvEZuyaxraDHqjcA0ET3vcjhATYM+t2Lf1ih9Jck24pdQ+L
         I9lZukb2FS/T1B/gRUuk13/HiYfeUEcG2W2zhcdVlpvxaEwiN2Gqb7c1DS8qOBZxKh/C
         +c7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778498211; x=1779103011;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mjFxAsYJ767LfglQAiic8pmf/v4fVUq2j4oVrXIto5c=;
        b=EdAXp5igjZVkqmNT0Y19QH7pBaYWL9UkqK1iK2MS8hGLlUqgyXS+nDYtPcphdqteiJ
         1Qnx6vEWZHaszg/k4nIGYo355r5l7hw3N67BpgCUUwJ2b0rQPiM+qj9x8ooSPpa3qZMz
         UdxhaxFvar4iBUR+VDjUTjGPw0cQCXmgy8LJpkPd7vbk++Dt4bUYm7yOENLc6KPJvjmO
         2Ns7eth1SoL/v/KTHaaxRMGXFsVMA7+9FxPdwNoh9FBccMiyXgQeForAV35+kSNDaD/w
         tHUKc+BUOwOUlsfgGNJja3SemmnzHmYmMk/I8SiZ5cXCnuhdVkIhHKTc6R/NfXRUvCH2
         87zg==
X-Forwarded-Encrypted: i=1; AFNElJ+AU0BbXOwXx4tGCe+bGw6Cvz0TM0/rhzbYo3LQdde44/15c5Iytkzxym+qQVGpcjkuP4ChBaU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6qzXdwgXnNgkTUBUtQx7vcpvAwJ6Xqt84dnkcwkKg56Tt2klo
	nIwzRm5g+lGustpgpWi3hsAchpMtlm4BAxyEjMh3vCYV2HMBlU7E06xvBPNRNblFQw==
X-Gm-Gg: Acq92OEPIAjNxUn/SxQ2elvVBSY++2c1138nC5qill6YkUTgo/6cgrQy9grVUgJJF6E
	feHPH+JM4gwQnJ0tJn0aLCcD7dTGiwsEBI7TQpuKe8/KWoHbFU1doqIvAEWBYvLfq6192WHiXaM
	Yv3bk/omjh4t0rbFh2Shpt9LcgeUWyM6LGJzTo/A0nWb1hWS+TKT35vyUeWr9aEPTV1kiQSwGig
	oaM3kNHKos7K0g75FkaD+X3f2DZ0lTt+yJvP/7CLEXTRpXRBBbXiZbXv+4blDaW+jiuT7vDJLyz
	y+AeBX4uxc3p5acCb7xIhhDixirWZl7xy9K0gSvzr8vilrZLwLerqgZVRiIt0Yql33sQp4MS1TK
	utsfBXtCq8+wOgkt3V5+VEVLyWb+hTav/034qD1L+eGILVvEzqAufLH0kAXB5wUsWhHgMj00rrh
	4oiK4+bbWo8FbZs7vVVO8tD4EWzA/JoqOd8BbXBNQ3hHQEg1A4UQBht3ZrIul6RxJCOYk=
X-Received: by 2002:a05:600c:c3db:10b0:48a:5d55:c194 with SMTP id 5b1f17b1804b1-48e6f507bc1mr1377065e9.7.1778498211122;
        Mon, 11 May 2026 04:16:51 -0700 (PDT)
Received: from google.com (8.181.38.34.bc.googleusercontent.com. [34.38.181.8])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4548eb75c29sm24522316f8f.9.2026.05.11.04.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 04:16:50 -0700 (PDT)
Date: Mon, 11 May 2026 11:16:47 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, iommu@lists.linux.dev,
	catalin.marinas@arm.com, will@kernel.org, maz@kernel.org,
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org,
	mark.rutland@arm.com, qperret@google.com, tabba@google.com,
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com
Subject: Re: [PATCH v6 06/25] iommu/io-pgtable-arm: Rework to use the
 iommu-pages API
Message-ID: <agG6n4CeuIMD57G1@google.com>
References: <20260501111928.259252-1-smostafa@google.com>
 <20260501111928.259252-7-smostafa@google.com>
 <20260501122424.GA6912@ziepe.ca>
 <afiO2WL4ILGfmUui@google.com>
 <20260509232155.GH9285@ziepe.ca>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260509232155.GH9285@ziepe.ca>

On Sat, May 09, 2026 at 08:21:55PM -0300, Jason Gunthorpe wrote:
> On Mon, May 04, 2026 at 12:19:37PM +0000, Mostafa Saleh wrote:
> > > So.. I suggest you update it to use the iommu_pages API, #ifdef out
> > > the allocator so the pkvm pkvm doesn't need to deal with it. Then
> > > compile a special iommu-pages for the pkvm side presenting the same
> > > API.
> > 
> > I see, we still need to leave the DMA-API calls for the custom config,
> > as I am not sure if it can use pages not backed by the vmemmap, I
> > pushed that into a separate function so it’s easily compiled out.
> 
> Yeah..
> 
> > Without this patch, now it looks like:
> 
> Seems reasonable, and then i'd probably just put something like
>    #define dma_map(...)
>    #define dma_umap(...)
> 
> To effectively take it out of the pkvm build
> 
> Then have a pkvm compile of iommu-pages to provide the functions in a
> pkvm compatible way. I guess you can't actually fully do this, but
> can do enough to support this file at least.
> 
> > > You should have a pkvm shim header that provides
> > > kmalloc/kfree/virt_to_phys in the normal way and just #include that in
> > > io-pgtable when doing a pkvm build instead of hacking up all the code.
> > 
> > Ok, I can do that in another change, but I believe it's better to
> > change the usage in this file to arm_lpae_*(virt_to_phys...) so it's
> > clear which parts are intended for that.
> 
> IDK, why? virt_to_phys() is part of the iommu-pages API, I'd just
> leave it.. If you want to narrow it then #define it for pkvm when
> compiling this file..

It is not going to be part of the iommu-pages API, I meant in
io-pgtable-arm, we will use something arm_lpae_virt_to_phys()...
which is then implemented differently for pkvm.

Thanks,
Mostafa

> 
> Jason
