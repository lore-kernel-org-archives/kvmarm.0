Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2754336F439
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781280484; cv=none; b=m6XLVoXM7z7QRPM7vMzlGU/hM5R335MyiIJTGqzem6/+Y96IShC8XI4wT6OjJ1MCFA0s4Y/G+AKqO4VgiaYlAFHGMvxwZP1Bq+aMoY8Y0aRGvezEPTRRruk96ueatYj6S9jNbF5YiczkqZsikF+IcPDsOsEO8LK7nY1qTUO2V/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781280484; c=relaxed/simple;
	bh=+Vco8Dmdfgiaph1JQEXf8hi7Xz17MRwEMZYFFDnZWUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dKYujLrgy/wjJTHH8+s5MpZI7gtPeiQvuYfAVbcDlfszeQd81U8kDmi/P7E7u/x3ofgCx+8Duj48cj3Vpl+Tlih6az89kOLXxi8C4XGGgtN+il4Hley3HtYBaD/0hZVYLPjB7ABWrSyqY9y/y6j1yOhbzAqImKzVZpBMtqqAtw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CKCD57wF; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CKCD57wF"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-490bb5ad3bdso71315e9.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 09:08:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781280481; x=1781885281; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=eLOF6fP/rRJNscoDrzMxzXOITjjOmIqhXSUh0KfqXwE=;
        b=CKCD57wFB2GJrnkULnQetQSvIzRRdZDRxM4HHhfhTHhan7PoIWaAUOLD694QivCI/j
         Za6DsJP4zyZKGvHKFiTmbb9TQ1J+zLXLjNaxf0JwpcREPD/y02AQRI0bikrQapAPZvdT
         kbibQ6KfHnWc7NO2pCHoJ6q+BuhFLED7i1XwPCBv5TtAbRJhjPVbr6IeXzgP0iTxbWde
         ehDkfyyUedM8Ug5azD+V6Em0292yhobiXqn+RbQDLHBZieRffWgZ4K/82rDkazTKldhx
         pDTdNkIcDFFu48fS3OqVI5QRCpiG1+a/dYkG3ld3u7JPPRn8IPZHBOQSd37cM6tHSgeG
         XQYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781280481; x=1781885281;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eLOF6fP/rRJNscoDrzMxzXOITjjOmIqhXSUh0KfqXwE=;
        b=aLdJT5DxBjd7yo09l4esDeZ2BgfethjDafmTC620+8PMBlJBwiM5rEWE8Ht8dDiZBU
         StITF+bR6fQKsWLp/RY0qbFK1jhhk8fuzgmeaBFP6AFxBtdzs9z7E6ztD11iGItEuK49
         lpOekQJ+GxU+jCfniZ7vEdG3AwigPKCE89ZWwJW9iBY12fJKgTOIN3pLFQwzevfSHZcn
         VuMZ8z1fcdr5VCLN0ntr9uzpJ2keRCz8W/3l4KloWTNRcfdU3w7B+14S36gt0jgL5MT6
         3cryj+4bHaOpAPxlH/Q+WH+H+Sy4QLCEialyZKQPmqR9pPDC3P3dFvRAA5VPXIOIyPfJ
         H7pQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jk6M4Cy/rDCkfDEvGmDS9ntgPki1U7ZWUhZqxMDSZrRTm1oxrlZ3Xya2clMbVCgrohq9fSDk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwCcw+btZTSb3uUESn2R6rRFs5vrOrXQa5TOJW1JAH4OLiu8w96
	zwkQxNrji0rXesr9B3imTKIM3sURLnwRo09ZYOC1fA0zFr/REhOFUGTx+OrbiD8y4Q==
X-Gm-Gg: Acq92OF34anSrnJC0yV+iwGHwSdwdF+3ucgq5gthOfj8gElL3tsQdXcaFb/fg8l98B0
	CSzVUVPnpblsqcxBjd+HRMKZha9BcAJfxxmGodmzwYhbeCSohmHMttkQjVflx/j5TQyV8INQ2xV
	6vmgmv3TOw9TXcwavB7cm/JzNGbVxnTVucZ+MTagJPf9rpQGkLCznrcx7aszXFs+HFXBG9VFPt7
	Yo5H0j+opo9rsCIkjbVBcO2hKSMfPUu54XwFTwHcv0H29m1nzDHhpYGZ+hVP5NY9ni1+nA2kUke
	6l/mBm35q/TOHkMMyRrODNNI/XMuWk4qAfY5sKbfG/VWHwBltSk3mdzeCTiMgl+Sfznc97QBniH
	lzKz0h5N+7CvBrVe1uvNLgMM0zQb1c3Q0o+8PqSqpG/b+7efxJtIkudcHqRr0wQ//e/xA39StNe
	FsSnI8nIlmh6f98flL/u0lj8KP6oDSRzQ8fwAW7NoaPQ0WEPHatVVzIn+2XLe5BFnKWOvlNg==
X-Received: by 2002:a05:600d:6445:20b0:490:c2b6:de6b with SMTP id 5b1f17b1804b1-490ea5da36fmr1068545e9.12.1781280481013;
        Fri, 12 Jun 2026 09:08:01 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f1cdsm7389953f8f.11.2026.06.12.09.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 09:08:00 -0700 (PDT)
Date: Fri, 12 Jun 2026 16:07:56 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v6 6/6] KVM: arm64: Ensure FFA ranges are page aligned
Message-ID: <aiwu3EqWdviH5Rmo@google.com>
References: <20260527150236.1978655-1-smostafa@google.com>
 <20260527150236.1978655-7-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527150236.1978655-7-smostafa@google.com>

On Wed, May 27, 2026 at 03:02:36PM +0000, Mostafa Saleh wrote:

Hi Mostafa,

> At the moment we only check that the size of the range is page
> aligned, and truncate the address to the page boundary.
> This make an assumption that TZ will do the same.
> 
> However, it might decide to use the extra offset of the neighbour
> page at the end, which is valid under FFA if NS is using larger
> page size.
> 
> Harden this check by also checking that the base address is aligned
> and reject it otherwise.
> 
> Fixes: 436090001776 ("KVM: arm64: Handle FFA_MEM_SHARE calls from the host")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index a12e01883314..daf0e328c847 100644
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

Should we do the pfn assignment after the check ?

>  		if (__pkvm_host_share_ffa(pfn, sz / PAGE_SIZE))
> @@ -372,7 +372,7 @@ static u32 __ffa_host_unshare_ranges(struct ffa_mem_region_addr_range *ranges,
>  		u64 sz = (u64)range->pg_cnt * FFA_PAGE_SIZE;
>  		u64 pfn = hyp_phys_to_pfn(range->address);
>  
> -		if (!PAGE_ALIGNED(sz))
> +		if (!PAGE_ALIGNED(sz | range->address))
>  			break;
>  

The same here

>  		if (__pkvm_host_unshare_ffa(pfn, sz / PAGE_SIZE))
> -- 
> 2.54.0.746.g67dd491aae-goog
> 

Thanks,
Sebastian
