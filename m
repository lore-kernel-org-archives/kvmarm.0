Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9480C34C9B9
	for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 15:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761146512; cv=none; b=tivWsyrt+DTthX7EWCPWz+IKpxPtHo5079oMwdWtdquEAheVFCR5NLGlLZphONuUdr05Fhrw1vhw6fwC9MPIu536rzxcH1hXAOPikNLeR1WG0Qh6WRxFmejJhH+SzWAyPC2tCjUzGyD1H63lOjB2aejoGnWsE64J8/MDgjPr8fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761146512; c=relaxed/simple;
	bh=AEtA/oWhtAIGMkwlqzRLBsJV2/4Vi/QootOCgnUxP7k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sxC5+ybJWrEKY2XRNLF5VxtL8vD3OWGCZqZT9Uzr3yVy2dfrn4WI4m+Q5v/zLRtO2kp90XBAK8NfUBs3pvOa+g359Hqa3WUkucao6ccpGNmUbaLsV6LFbVcwTkqYKpWIGjCHANOSdS+hcNodz/PkYzpHTNqvNiKR+H/G5OmP/rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DQNUov0I; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DQNUov0I"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4710ff3ae81so26086015e9.0
        for <kvmarm@lists.linux.dev>; Wed, 22 Oct 2025 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761146505; x=1761751305; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=42ue3TfuagWkQ2V7EUMjj15D8DxB3zkbZ2dEcUmvfhI=;
        b=DQNUov0I/wPIEwKgOa4FMX0WarI/TbFn8qfA+bJlmy99I4b4yNCC/GzPCGCGBC9F4f
         hJG8qTwf4DKHu1pjk3Ool23+1KS+QoEOiYskEr8yGKRu8iCUOYF03BGQK7DmRxQc0SAr
         81sUM1aNl9+YfwjGQ4CdAD6guD7qRHyO2WPS+UuMwhICCU5LhuwCgF8IyM4JrQBrKJ2f
         95KkXZWBNUcNq7+2QFemiBCz9h+xDvGz8u/oitb64WlTU9cySJ+Nt9D1ATunHQHgPJVe
         CvQSs6Wu0EMcOA4Fbnh5lQZLATcrc31rkTnQBKqq5EfwKe3o8/nLYwL/PNGoXTTWkKsF
         DHWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761146505; x=1761751305;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=42ue3TfuagWkQ2V7EUMjj15D8DxB3zkbZ2dEcUmvfhI=;
        b=bF53tKUHQqV3hSTNMaJTFJ7afSyuon4y9AHKkSwAt7HaylQvhseLogmu+BLazqx4Bq
         6HAEMZPTMvjyEZhOmW7VfoDWkf7QVXxV0k8yFUKz4Iyd10srp1YuN8+pqoFfHgjBCTil
         GDp9OfhdX9POxiLTDO/L1ApVwUYQwLKnGuw12IgixWOV2kuJeQE9QmUGHpaxecG/X5Ax
         milxAFEoFGfSyLmc+3OJ4BDX4pZTnHVICOLLBuneDrZGwPOvB2V7V48TMRSnJ4VbUzin
         LKBp5LMnevJKCzXfz8ukSUczQWS9aUSWDGlKw+y9f+Bzek3KLpzK5nH5LG0nIrGsU5xe
         AR4A==
X-Forwarded-Encrypted: i=1; AJvYcCVECWh1unFZQkmn75u29RGo8yWglJv74U1wpFLo1dRTKqfnUtAK0qB5FAnjQqIa0890fGzspR0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxmxLn3Ls5FM61fHQoU7TO0isCDHNWoWy0c5VHftAunpHN38zw7
	CJxZtmVw97/nRrZm7CJnlaCCqmN4dn2qcbTzhH89/kNvkhBS12+qVX0TukBGvaMz5Q==
X-Gm-Gg: ASbGncuxp4A2xCsYVWsTHCuuKYCA8r41HjsqM0nnd4zWmol+LGcK/8Z+ARZMCt5MNhz
	ay+vW1js9no6QlWxrDCx5sUVj3puYcDYKUNShlw2xia7kxLIvE2HWMY6opzmSAgiZY/t+/tOvTS
	FqVaFSfpVuo5w/RX06Wm4ZbS523NjuDOK8sxuztQhv3OKJA0dVctB4+zuf+U5vdwPggwfmF19Lb
	il/N0fQA8Vjw4DYenmJB8VOm7c5Vp3u3My1eW0WjoFCNTvPqMZTFUPmWNSExAOxRjML/HiDFHOe
	ZudfPITuKn5dUI3pG5MagEuSe+8NXg8DOGDe1dDXZSbEdVOmZ+DAwQdcYSZhzfBzwAoloxxbfu5
	Ew0ABvvmap12vXuCVBXc1dPXevhQk93oPa9cRElqxRcBKb+0Uzy8C21/o1Zj0/pQDJj2VZ8ybDH
	Q1uGGhbkGDlSdG9bxckA/tqD1wSV6dZRAaWIFWOTEz
X-Google-Smtp-Source: AGHT+IEnnK8G84/RCGIcEvbmU2iJ6PJ59Y6J0A2B+/Z8jT2K1jKw12A1VxcO8AZhiMzei5pC8Fi4cw==
X-Received: by 2002:a05:600c:4f95:b0:46e:345d:dfde with SMTP id 5b1f17b1804b1-471178ac017mr140699355e9.16.1761146505106;
        Wed, 22 Oct 2025 08:21:45 -0700 (PDT)
Received: from google.com (218.131.22.34.bc.googleusercontent.com. [34.22.131.218])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b97f8sm25217515f8f.36.2025.10.22.08.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Oct 2025 08:21:44 -0700 (PDT)
Date: Wed, 22 Oct 2025 16:21:41 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, will@kernel.org,
	catalin.marinas@arm.com, suzuki.poulose@arm.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, joey.gouly@arm.com, ayrton@google.com,
	yuzenghui@huawei.com, qperret@google.com, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: Check the untrusted offset in FF-A memory
 share
Message-ID: <aPj2hTXbGUseUqhE@google.com>
References: <20251017075710.2605118-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251017075710.2605118-1-sebastianene@google.com>

On Fri, Oct 17, 2025 at 07:57:10AM +0000, Sebastian Ene wrote:
> Verify the offset to prevent OOB access in the hypervisor

I believe that would be just a read, so probably it would be difficult to use
this to compromise anything, except crashing the system?

> FF-A buffer in case an untrusted large enough value
> [U32_MAX - sizeof(struct ffa_composite_mem_region) + 1, U32_MAX]
> is set from the host kernel.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 4e16f9b96f63..58b7d0c477d7 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -479,7 +479,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
>  	struct ffa_mem_region *buf;
> -	u32 offset, nr_ranges;
> +	u32 offset, nr_ranges, checked_offset;
>  	int ret = 0;
>  
>  	if (addr_mbz || npages_mbz || fraglen > len ||
> @@ -516,7 +516,12 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  		goto out_unlock;
>  	}
>  
> -	if (fraglen < offset + sizeof(struct ffa_composite_mem_region)) {
> +	if (check_add_overflow(offset, sizeof(struct ffa_composite_mem_region), &checked_offset)) {
> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	if (fraglen < checked_offset) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
>  		goto out_unlock;
>  

Perhaps this could be easier to reason about by moving this check with the nr_ranges?

        reg = (void *)buf + offset;
        if ((void *)reg->constituents > (void *)buf + fraglen) {
                ret = FFA_RET_INVALID_PARAMETERS;
                goto out_unlock;
        }
 
        nr_ranges = ((void *)buf + fraglen) - (void *)reg->constituents;
        if (nr_ranges % sizeof(reg->constituents[0])) {
                ret = FFA_RET_INVALID_PARAMETERS;

}
> -- 
> 2.51.0.858.gf9c4a03a3a-goog
> 
