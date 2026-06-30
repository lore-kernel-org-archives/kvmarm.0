Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110B83672AA
	for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 09:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782813101; cv=none; b=TmV69ehzB+dZB+B1WUuAP5ifNiP8Q6TA7gbCwOo5VEzSNh9tJwtvjjiQ8KaQ0pdirx3zOIaBE24XKD76itb9yjvF9XWG46DAuDPMLgodQ4KBp9n/pK2l0cGIhoTRe11IIsXx3BM1d+55fV6W0buoOcfZxJ3hzFZc7a7ukKdyJlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782813101; c=relaxed/simple;
	bh=yb90SNjFBocihj8fiYGJqdyII0fOUVjjiJzpoUx4P1E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L7zoUQiRQY92gmToWeS/xZmOwpoCwvJRv4gZIapvx1P5sUPUXQI0J7DIEQiaz8d41e3+nd9aSmluvzgBEnWcYau52Y/B/XF8lyWTw2cOWh20L2BMNezpL7EpTjEnuAAhoKwByfPU/hAOJLNn6EnOIoljnYHoykGwDy/YKCkUrGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6odRqpn; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6odRqpn"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-493b8d99342so30235e9.1
        for <kvmarm@lists.linux.dev>; Tue, 30 Jun 2026 02:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782813098; x=1783417898; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RtSqH+WqtZAB5cklSCb440iNsoDcg75bAXjvEoBq+ok=;
        b=B6odRqpn7PM4iB1WqOefaoRYZoO1CkFZV8605CforxGy3KKeQ1YCKqnfpqCvjviszL
         FCaik82IG7e4Ns+oQZ1fk8ySS8Ua/kJ+cJoqw4wy4/gIwZGXy0BMYnguHp0NtZZcuBRX
         nf6qGPjJeIUtlU2g6gmcvz9VGbg/oCpx8+J8cUrzswincx9Q+AB8xY4UWcv5ytpdV3/E
         WHdtN0BJHrhAGd1qJz3AzlhUnGr1Q61ZKDWbb70eazr5L09QYoH2RkLq+R0nYibTxicC
         fEuVoG+h1UUNFHY4HqVeze/EiRdhnjlzBLC6n9mG+Nur+wv+SbOaZtnp7DzOrn0tiQ8y
         kehA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782813098; x=1783417898;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RtSqH+WqtZAB5cklSCb440iNsoDcg75bAXjvEoBq+ok=;
        b=pfclnIe1rPvFZDuhCIG+4UnGgLPuURSJMMIl+KUoSn6mdVcq4FhGu35we/GNFE8uWO
         NE5OryXCPRoxZN1lduUX6G86ewQ92tL/7qn/hM9IsSobxkFaAPi06Pv4/A02h52qMj/1
         BqLT+qmJN2PeqhZSGvl71bcxap6d3b6Ye7MHCgVKclfRR0GmcDMlpCnBieSIdLIUFUvL
         UPO4qU4Fe7hZKKTdPD1Kw1VPWjCHS3KUC/L6vuUNf1DYOBlfXcXKxQZZ3VWYIz1EqmNR
         vPWRBtKp57/+bVtD8REAtz4NIHCxjor3eOHZNE26UvyUiR+Rhqs65AhQkkDfLDa3llk1
         xFZA==
X-Forwarded-Encrypted: i=1; AFNElJ9tVZsZS/WiGkTgkR07NilB2LKZj6HnJjNiY6dkFWqIxXReN+B1N+MpCcbfcSf3Kg9a3/cSbSY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyV7Bt1IYsnq4dIiGi4tyoWWCGow/N24zfHxSOTSOFxlh6VyCW
	17B87WGYV5ZWfW+kqZzdPlQibhfyvRdEE7ZbeiqX5LfR54ke78Z1J6NJPXQIA3LuFw==
X-Gm-Gg: AfdE7ckN8/iIRQXrXvzyLqCRsLwwf9usai9wqnhbIhvB4P6AqsNP53tmEXYUkKlRg5C
	HctFko+mBayG+gDmM4cIiBeDSt6uuLBvz55wxAYFs86SRlcuewdELVjiS1aGziiUGhEitCpIeCP
	aC05+Se/W6DRu7XGJC0PlT3Z1P1S3Arlv/6UurS22UTzQPPzVvmwIXt8GIJ/1lnyadZ+4jqPQ0b
	2ub1yt8oD/5fxidIspfALjkmgPHtf96RRMXry9IhzXrr4LhbjDQdLg1ry7cBaJ+E33Xfn6tHshu
	NBtUan+ImcyFaRuwelq81RQ0V5LKfSU71d9Qo2p7e31Wx6LmQAe5oM3IUFtBh9YXYpOSsBQO81I
	uK9dsfsMJq9GoIomn4DS+qhEQIWjDf41Q8lhtSbdrzR+k2NkJ/J3NFyQMimxf4HowMIKpB7ETx7
	VYlIXCjyrx01nvPngqd6EuqgwwCKWrn9LBGnR5DzjdjOFlrU1eDEdlqDVFLKw=
X-Received: by 2002:a05:600c:58d0:b0:493:adf3:d892 with SMTP id 5b1f17b1804b1-493bd76f95emr1505e9.3.1782813096603;
        Tue, 30 Jun 2026 02:51:36 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493bb4f174esm22907135e9.2.2026.06.30.02.51.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 02:51:36 -0700 (PDT)
Date: Tue, 30 Jun 2026 09:51:30 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 6/7] KVM: arm64: Ensure FFA ranges are page aligned
Message-ID: <akORop8Z9Levu9Sr@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-7-sebastianene@google.com>
 <ajQmN-UQD3uJJddJ@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajQmN-UQD3uJJddJ@google.com>

On Thu, Jun 18, 2026 at 06:09:11PM +0100, Vincent Donnefort wrote:
> On Wed, Jun 17, 2026 at 02:51:29PM +0000, Sebastian Ene wrote:
> > From: Mostafa Saleh <smostafa@google.com>
> > 
> > At the moment we only check that the size of the range is page
> > aligned, and truncate the address to the page boundary.
> > This make an assumption that TZ will do the same.
> > 
> > However, it might decide to use the extra offset of the neighbour
> > page at the end, which is valid under FFA if NS is using larger
> > page size.
> 

Hey Vincent,

> I failed to parse this 
> 
> But I see 
> 
> /* The base IPA of the constituent memory region, aligned to 4 kiB */ 
> 
> So it sounds fair to prevent oversharing when PAGE_SIZE > 4KiB
> 

I think the problem is when you have a mismatch between FFA_PAGE_SIZE
and the system PAGE_SIZE. We expect a fixed FFA_PAGE_SIZE of 4kb and
this is enforced by :
https://elixir.bootlin.com/linux/v7.1.2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L761

if FFA_PAGE_SIZE = 4kb and PAGE_SIZE = 16kb you can end up annotating more pages with FF-A then
needed when the range->address is unaligned.

It took me a while to understand this so I guess it is better to rephrase the commit msg.

> > 
> > Harden this check by also checking that the base address is aligned
> > and reject it otherwise.
> > 
> > Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
> > Signed-off-by: Mostafa Saleh <smostafa@google.com>
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> 
> Perhaps the commit description needs some improvement.
> 
> The rest looks good.
> 
> Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
> 
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 1a2abd0154c6..d7c5701d0584 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
> >  		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
> >  		u64 pfn = hyp_phys_to_pfn(range->address);
> >  
> > -		if (!PAGE_ALIGNED(sz))
> > +		if (!PAGE_ALIGNED(sz | range->address))
> >  			break;
> >  
> >  		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
> > @@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
> >  		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
> >  		u64 pfn = hyp_phys_to_pfn(range->address);
> >  
> > -		if (!PAGE_ALIGNED(sz))
> > +		if (!PAGE_ALIGNED(sz | range->address))
> >  			break;
> >  
> >  		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
> > -- 
> > 2.54.0.1136.gdb2ca164c4-goog
> > 

Thanks,
Sebastian
