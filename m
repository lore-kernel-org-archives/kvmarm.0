Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEB81DDC1D
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 17:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781802561; cv=none; b=oPo4pzcIT/kwjYPyt4AiLD+JijdkXqPYqimNmFNDt/TVLHzeu0OGjjG+zgynV3xTBrFz8YHazIzGIky6kQFSzy5lnJLxneJo8znSYeptOa4DHHv5hot1/a60F3AfUPMbU48+CBWRQYuvj0sHKT7RYXBdu6/Ncm3bA3llRME2QGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781802561; c=relaxed/simple;
	bh=/mCzhgbQYuE891O0eWLlpWbYinEKlouXuNO+3ntuMGQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ctaj1NysnxwzWiYUgN1GBhx/yt0rwGZKQKJZvuUxFiA1sSpKmqhN7XfXmmaUdlJCHaQ9Nyx1+cnFK1ADUjKbDBVU0/54A1xVlM3u7wYhhtRdC29s0JZ2HH561ATeIPxIwFArJU2U1PU4ALx01v/LlOWECE+s68vDqktWmPI592k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EHWyFrUV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EHWyFrUV"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso23167465e9.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 10:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781802558; x=1782407358; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QdkuOGLUlQ7bxWy9OnUbmcuGQ3e2VCJK+CUYR+keUTk=;
        b=EHWyFrUVXy987PDKf55eZ3/hC+eteeflf2INTHIvavPQY/0XW9rewuT4DgyhvLznzo
         owWHs8ELy1xRREmfiWpAN5U3COP65/jtxPe3KtHuZK6CspNO7bawWLOGobSRQ12f0X9F
         PbiS3smitoPq9nPXr0GwYJE1zVEbok/UQ5Q69p+WQ4/WfYiwWBL41hT41Dkvz0kpRfyt
         NjYWqN7zJIyy+Hmr8+wo7iqXoahjeDZZ/08dH+LhbGXvefDFPQmvkBa/s53lbOlUYwfS
         ik1EZbfE8ikmpF1Z4AXQmXFQZCQrsBMsL1gY1Tqx7YwhE6lCccY4d8U+csd1S7WNJ0Gf
         B6dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781802558; x=1782407358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QdkuOGLUlQ7bxWy9OnUbmcuGQ3e2VCJK+CUYR+keUTk=;
        b=QC656blnwb7E2sYUOW/eBvKsNZSEZDFcLGIEQhKJTJKRD7MH6lYBKmSP3inEtj+OwG
         JhJWjEguID5QSq138Y0Lizr7VxxhLpRRUQktuwU9AibWX6Qu0BaF+vaYF/wy1+pKbRBg
         g3oGP+jQqj//1jQqR6MwiNUBYJq+q3XHfCaFj7kfQVfpb35deNhJLKMA6njnAcrecWOJ
         Wqns93rcdzMYPqHvL6BsAmIUDH/663c4fJxgPV2K8VnqF/relrhL1tmKvDh6r3vbHZNW
         WsIk2Otv9eSjzXUPSpmk+9vOeaCDqYgYk5EZNOce1VFzCNz7aq48IZ/IjErsWjU+QPsX
         zVNw==
X-Forwarded-Encrypted: i=1; AFNElJ+cIEKk4FYXyTDJWBM1ViaC9iDstYkilNj2Mq0xvNZOWBnbix5eywGo+UndSjCAjnlNaN8e49E=@lists.linux.dev
X-Gm-Message-State: AOJu0YyldJKqgUkBXWq9goAHT1UQgtfe//6Q1SU/7uTIiWr2ZxSPwH41
	E+tNEXLfMD1NZO4ziWS3L00m84kRdfRgVSJrKn9HQNKltpMDFmMdk49lBsh747wDmg==
X-Gm-Gg: AfdE7cl0MByDxbKhgIsdhd2UQNDyUokH2zlp572hnFwdf/ZiwIwjEaD6s8d+M8p/nfN
	QSjT8Q6l8cZv8b4qVJtvnLX+LxCbF3TO7yIpB+F0baU2WEwkT4v+5XssmP9KQokOU0b5aRyYzY7
	51YZya62+WiZkrjtaymJG6wbNQlddF9aKdW0pqfWm+TVzEVEQVekd/7L47hbrDSiEdu0pqY1d9n
	h8K8f/s6FinwR2mEW3zeBpXkP6djHvCs2vitQnboEnbsLO/VNJFOPJOr1MJw+2vecob3F3h7CQm
	2Z594eLvQzFnTRbxfi+tIdlLbMiaahvjmSqXuIQa8H71T5Bx5b7BWMT5NWBCaMcevpKXE9I54sd
	+HyylTHmN/WTgEJoh4HbKpQEdT4khlBdn8ThFJkRkFbd2o846TMtX0UrBmbgvbUKrn4pB//NNuL
	IL0o0ZYIrRPDh48uXfV/C1ybq+QJNqT9jHXLrfV4lwQ3r+7WvBZCKfeFXf
X-Received: by 2002:a05:600c:4ec6:b0:490:3cf0:8d81 with SMTP id 5b1f17b1804b1-492381864b5mr67892175e9.13.1781802557213;
        Thu, 18 Jun 2026 10:09:17 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4923ff8a712sm1949215e9.13.2026.06.18.10.09.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 10:09:15 -0700 (PDT)
Date: Thu, 18 Jun 2026 18:09:11 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: catalin.marinas@arm.com, oupton@kernel.org, sudeep.holla@kernel.org,
	will@kernel.org, jens.wiklander@linaro.org, joey.gouly@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	maz@kernel.org, mrigendra.chaubey@gmail.com,
	op-tee@lists.trustedfirmware.org, perlarsen@google.com,
	seiden@linux.ibm.com, smostafa@google.com, sumit.garg@kernel.org,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v7 6/7] KVM: arm64: Ensure FFA ranges are page aligned
Message-ID: <ajQmN-UQD3uJJddJ@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-7-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617145130.3729015-7-sebastianene@google.com>

On Wed, Jun 17, 2026 at 02:51:29PM +0000, Sebastian Ene wrote:
> From: Mostafa Saleh <smostafa@google.com>
> 
> At the moment we only check that the size of the range is page
> aligned, and truncate the address to the page boundary.
> This make an assumption that TZ will do the same.
> 
> However, it might decide to use the extra offset of the neighbour
> page at the end, which is valid under FFA if NS is using larger
> page size.

I failed to parse this 

But I see 

/* The base IPA of the constituent memory region, aligned to 4 kiB */ 

So it sounds fair to prevent oversharing when PAGE_SIZE > 4KiB

> 
> Harden this check by also checking that the base address is aligned
> and reject it otherwise.
> 
> Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

Perhaps the commit description needs some improvement.

The rest looks good.

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1a2abd0154c6..d7c5701d0584 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -352,7 +352,7 @@ static u32 __ffa_host_share_ranges(struct ffa_mem_region_addr_range *ranges,
>  		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
>  		u64 pfn = hyp_phys_to_pfn(range->address);
>  
> -		if (!PAGE_ALIGNED(sz))
> +		if (!PAGE_ALIGNED(sz | range->address))
>  			break;
>  
>  		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
> @@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
>  		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
>  		u64 pfn = hyp_phys_to_pfn(range->address);
>  
> -		if (!PAGE_ALIGNED(sz))
> +		if (!PAGE_ALIGNED(sz | range->address))
>  			break;
>  
>  		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
