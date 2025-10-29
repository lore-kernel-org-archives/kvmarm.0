Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B9D301494
	for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 10:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761733655; cv=none; b=GEeN2nsbEGZFnEZ7vmxacuz43CvtvKbkw6+5joS0eBwYsvONsYeOQVQu7wG9xcVuTnSWQO+UoFnHnNbfYzPtYtbwhlPE7u8urmnJVwzBgQ2CQVa3ytA06+ASnII8rhf70alvG6X8Hs5MAPkIW2jVxd7gUiIYCkHyZn6my4tlrpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761733655; c=relaxed/simple;
	bh=3wZ1AtNcLaqnW/LsJGF0b9O1btUD0rIr+5C9+r+Gpd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B03FYgoTfa6TsBOA4v4LkU2MlH0drpmbCJJ4yPex21TfvbNZWSn/Ntjon+nuQj5XmOMubOlebtCZoN6/yuXTtk/6vE2wbUKpl+AphgkT2PER0Ota4r/0WcPSqPh4brYQQ42a6pu/2FHFLubxKozlw9mhGSetiKVyQ8B63SK1Hf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eWcihlnt; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eWcihlnt"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so41415e9.1
        for <kvmarm@lists.linux.dev>; Wed, 29 Oct 2025 03:27:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761733651; x=1762338451; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=51XkTbr+6yxRjDoZdk3XOJ3OIVOjmWe3fG1xSTac55Y=;
        b=eWcihlntguvOB70QZG2qHqp1j4i8Pz5pBXanV3MwjumCBDswqITm/20lcsjy/C0qvG
         2H0bI65hT+v1eSufyJfYggGVw7cdgxC91C8EF3VSnsSvuDKl0aRMDR5L8cpD+fwnn3wU
         QMUHdnOsAoLOl39OiboL2JbzcApMp4niK82xs9m2jIjBABIXKChi3Gi/KF8SmF2gApvL
         og8we4U62uKBikpOBQoYN7sFYguUm3l0R0PmX+td7zNZBFVAdBm8Bo0vZVa1P8Am8u2u
         1Vnchi4zDZgu0gpsKfa9qyaG1A+xPVre2dGfcQD6AVHI96leRRni8e5huz4rYu7lN9e5
         1syw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761733651; x=1762338451;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=51XkTbr+6yxRjDoZdk3XOJ3OIVOjmWe3fG1xSTac55Y=;
        b=l62g/vpSpMfImI3XH9k9TzaaYOFgTVZqHLnAjFeKmi1I0akgAKG95dOsqs6y+aWb9g
         9t+kXgO3fm4KRFttE9/I3RKK9eDB+M5Y/x1y26YsizIjuVQYCrURJAT62PMuCpTieiJp
         n5lJSorIiNe0HgCDFrGJs1nh/OyQxwjzDiI/wYntazytNVQ7sBQbv84egaihyk7c4Wjz
         eBWL1t2PSCrfRPUVT1hDImKmoLwCm3fd4S/BTQ5Rj8PZc2d5z4+fFWO/K8KmZG4iOCjR
         5gnJDg+K6kgMJLsTdPO2aZ51mmhs/Qh38a46RRUkHpoFLIRTD+sF9S6C6FS3TjsQe5cg
         ERqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWicrBBinwMY1nZWZUDII2GqtwUKSYwHLXsPsMBUFoECw7E4gAXCKTck5iWAbifp/DNudZ/dUw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyFcqbs+lIkaLSF2z7uyPrW3amimNlK4Wx4LIqSdp/UuCFAj6+z
	haBaXfg0a6FwDQHJ9ArDMCGeTqLTpLcKnFj/0OW73ldeRBf3ALEdG93polrRAAu2uQ==
X-Gm-Gg: ASbGncvGp9UJQhwcBkkjbRNR/TNex6RUp/TW5gZZ9HRlyFe+QKCgzchj6bhjn1D7oWj
	+IblQzlfutfiSUixWRgtRl9qzG2D7P4vgdUeYkENGxQTeDICFFx2dPJ8GbsoNwu+6PTzHtP151U
	Y93b139hoFgs4XDDO+JBK+doAolPkzIHLlyZ4+JDKR8Ut8p7xVTiIldRq1IeB8RAQgCflDL01Fm
	3YRUUg9INSGQrP9wSA82s5+UAr6R/MzBhD8exlYtMi9S3m37mxYSoZLgBiZr0FZKLa4RK15X3jQ
	0Uiz34anlMJCIUnel0nzbrxT7xqe+WSLev8+XlUX8PEh4KATjmeIPMkiWl3tVjAqNpFai0YSo1w
	p69aApXAR2wps8Br4EMAa5xNMoHIHPVDMB8pIirtZfO4Dp8WYpQUxCc2e6c+cufYeZm7IOM9ZKb
	hxfdtBCYDVGMhcxPqx2xgpfEtwyWCiLV51hfqaJRm/qjdvMp4h5JahrTGrBA==
X-Google-Smtp-Source: AGHT+IFpaQKCalYnjuLKmUHFSWvCchMH8++STvYUFO8XIcwGgMjADJ7NW+YIN5UXP+K6GoePivht9A==
X-Received: by 2002:a05:600c:245:b0:45f:2e6d:c9ee with SMTP id 5b1f17b1804b1-47721016cc6mr823485e9.6.1761733651168;
        Wed, 29 Oct 2025 03:27:31 -0700 (PDT)
Received: from google.com (177.112.205.35.bc.googleusercontent.com. [35.205.112.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-429952b7a94sm30414651f8f.5.2025.10.29.03.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 03:27:30 -0700 (PDT)
Date: Wed, 29 Oct 2025 10:27:27 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	catalin.marinas@arm.com, suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, joey.gouly@arm.com, ayrton@google.com,
	yuzenghui@huawei.com, qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Check the untrusted offset in FF-A memory
 share
Message-ID: <aQHsD0MnZYSTDOf8@google.com>
References: <20251017075710.2605118-1-sebastianene@google.com>
 <aPj2hTXbGUseUqhE@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPj2hTXbGUseUqhE@google.com>

On Wed, Oct 22, 2025 at 04:21:41PM +0100, Vincent Donnefort wrote:
> On Fri, Oct 17, 2025 at 07:57:10AM +0000, Sebastian Ene wrote:
> > Verify the offset to prevent OOB access in the hypervisor
> 
> I believe that would be just a read, so probably it would be difficult to use
> this to compromise anything, except crashing the system?

The simplest way is to crash the system but a more advanced one might
lead to a confused deputy attack:

1. Use the original bug to trigger the overflow of the offset variable
which bypasses this check:
https://elixir.bootlin.com/linux/v6.18-rc2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L519

2. Use the host_share_hyp from the host to create a mapping in the hyp
address space so that : reg from reg = (void *)buf + offset; points to
memory mapped in the hyp address space & controlled from the host.

3. Make the __ffa_host_share_ranges fail (since we control the content of
the reg) to trigger the recovery mechanism for __ffa_host_unshare_ranges
(https://elixir.bootlin.com/linux/v6.18-rc2/source/arch/arm64/kvm/hyp/nvhe/ffa.c#L392)
and replace the content of the reg with pages that we want to remove the
host stage-2 FF-A annotation from.

With step(3) we can remove the host stage-2 FF-A annotation from pages
without having to invoke the FF-A reclaim mechanism. This allows a
confused deputy attack because the pages can be given to another entity
after the annotation is removed (eg. given to a protected VM).

> 
> > FF-A buffer in case an untrusted large enough value
> > [U32_MAX - sizeof(struct ffa_composite_mem_region) + 1, U32_MAX]
> > is set from the host kernel.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 4e16f9b96f63..58b7d0c477d7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >  	struct ffa_mem_region_attributes *ep_mem_access;
> >  	struct ffa_composite_mem_region *reg;
> >  	struct ffa_mem_region *buf;
> > -	u32 offset, nr_ranges;
> > +	u32 offset, nr_ranges, checked_offset;
> >  	int ret = 0;
> >  
> >  	if (addr_mbz || npages_mbz || fraglen > len ||
> > @@ -516,7 +516,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
> >  		goto out_unlock;
> >  	}
> >  
> > -	if (fraglen < offset + sizeof(struct ffa_composite_mem_region)) {
> > +	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
> > +		ret = FFA_RET_INVALID_PARAMETERS;
> > +		goto out_unlock;
> > +	}
> > +
> > +	if (fraglen < checked_offset) {
> >  		ret = FFA_RET_INVALID_PARAMETERS;
> >  		goto out_unlock;
> >  
> 
> Perhaps this could be easier to reason about by moving this check with the nr_ranges?

I found it a bit more clear to use the helper on the offset variable, I
would like to keep it in this way if you are ok with this.


> 
>         reg = (void *)buf + offset;
>         if ((void *)reg->constituents > (void *)buf + fraglen) {
>                 ret = FFA_RET_INVALID_PARAMETERS;
>                 goto out_unlock;
>         }
>  
>         nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
>         if (nr_ranges % sizeof(reg->constituents[0])) {
>                 ret = FFA_RET_INVALID_PARAMETERS;
> 

Thanks,
Sebastian

> }
> > -- 
> > 2.51.0.858.gf9c4a03a3a-goog
> > 
