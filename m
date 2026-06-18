Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CBC292B2E
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 16:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781801792; cv=none; b=PynAO42rehz13m8ylsJUgKH1+txlfK6EzuoaN1JbsITvyYuHW0Yh7SRAOq9KkgqZXs4JsTGSHZwD79SOarD83f1HDsEDDs7LCk898xzFua5OYt9pHHZ1LhSygCf6hw4U25ui0mVsCdVGzjCJNEAr57alFnycQDanXoERe6rKbFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781801792; c=relaxed/simple;
	bh=UpeUIUHNDvq4wZict7iVU/9egJyKDT4wEJN5nl33azY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qFSSild9ujcwMEw801/jkVPEqa2l2bd04EFG21UjZxyXsgk6EMgKmM3l4QXcnVE/EyjNcBbPODRd9pmAvGsjwzCJfqXT+ZFu0a92CQ8Lbq/7LaY9o4pQrfWEtgBAUlNaTgwLRJmzo412HiK7tTuJ/mviXwHh82Lp+nSqRe02WD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VIuwbj7w; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VIuwbj7w"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4645995069bso606367f8f.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781801789; x=1782406589; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FYHUL+Y9sDYt/84sbmqrw+bMmVqlzQNkmZJ6A0M/j4w=;
        b=VIuwbj7wM7SLkcFr3jjSv/pHQDttQExelmmNHOCQF+Y8k8eKUky/C3UD4RNi+htGq9
         JuTTuh7HR4Lx5ChvgHmq4Rmph9RQ2HIWJqIyQ21iICq1CmX73FRUaNRCMOHAb8uqTM6S
         2IwXwIk6jYRZYsi31PmD+C/Mc4xwChDptz6mb4ADWkL6k54X+c/PQyzlxkFoz/sbb4qz
         iMgHcUCxOuyFJgj9Pn/MioTzOpEt9W0rfuRhSvAA5cPiWlJuDyROrWM2kVTufBRLdceX
         iQWRGPyoqj3EKwQ1KREUZOOSQsoz0bcYvmDMO7Q/2VCxGP04Zp/URMudmeAMw1kkoyWG
         2jYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781801789; x=1782406589;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FYHUL+Y9sDYt/84sbmqrw+bMmVqlzQNkmZJ6A0M/j4w=;
        b=jAsIJ3Ayv3DdayYNUu53qxG0ZeUA5uTOXJczmlilfoIMNW9ULPIkwoSko0Bs30WJYY
         pSNedNjRz+c9nWD3VIkZblNIBv01HlFLCJFgPTz1sMTP6TBJZfMBEOP0Jt7+oJxDXy4A
         ogzqqqodFH0Ja8Y6zAMaSw5DPrZ3HZej1AS3VKjd9LZLu0YWfgQYbXHszGTP0wM9d6dB
         JjHDORkgw9gezweEuRDbkc3XK4cNC+yGVD8NI7iNhpfLDvxZNfyBKKDK9fcIXHpbMCrj
         jdasPUozhvBhhYG2hLoIBtLW+qsF/NDJrW993bhCVYgsuDO0OVbkpL8HziI8Q8DcKCLN
         tEiQ==
X-Forwarded-Encrypted: i=1; AFNElJ845X0RKejfbZq4sr9F+xo4NKutrsiwAD2ifZvhnu5iKBuejLQERhKWB4EZKMHV6ZYy4zD962k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5nK3YovG0FUh/4wZp+2icBbR2UrTv93sJAqhBuNuX62Q7AyRy
	zo05hG2pLyWpra9cxFr2yZ3NwPx/jylhTMcIQef5TYjZ6BxX34Nd/fyqffL9J0zAXg==
X-Gm-Gg: AfdE7ckgRDH6YpN21pubUYF5qteFMdqjzpHam0Korlds1oVq82Hk19dUhr4tgWCTS/k
	ts9mvXZ8e0NS/cezP8IlicK18k37W0E2hslYAmRKiYb0G0qoISLjeisPbIDfOmJrCpEemsnJ7RH
	N0SVuPw2NgYvhaOXgVrwOPQeVhBtRvjWqOGf0Tff4W7vsa8u+PMlOqLPWk0qPn6a2XyCy1AtvqT
	BRo8Jcz0sT+u2uaB6Opz0fsbs+f/23niCfcr/n5Sl2IzHUJl3K6+gPrzbWWm0je6LBqCcy7zC0F
	CHw81c2o8qrrtqP4CUpfyQsHwCjRM7XHyRqTZfCpNFZt2Uz14odvo4+HDgAH6FpY/k56kOqmWCD
	rtERtjzrF85QSsno/vZON1YLJtMDM5iDKR9hgbrTXNT8bANAfOZ9YDLXt+09qa3dVH6OccHQ+7b
	I1aiVQODGP4AxzOLazSAYZOCvNzfZFlLTC/BLsdNnXo/+ppIWTbtXUDDyR
X-Received: by 2002:a05:600c:8217:b0:492:3d05:5639 with SMTP id 5b1f17b1804b1-4923f6a949dmr6700535e9.36.1781801788773;
        Thu, 18 Jun 2026 09:56:28 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4650b67a33csm153604f8f.17.2026.06.18.09.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 09:56:28 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:56:24 +0100
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
Subject: Re: [PATCH v7 5/7] KVM: arm64: Validate the offset to the mem access
 descriptor
Message-ID: <ajQjOH9Cjk1UqdT-@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617145130.3729015-6-sebastianene@google.com>

On Wed, Jun 17, 2026 at 02:51:28PM +0000, Sebastian Ene wrote:
> Prevent the pKVM hypervisor from making assumptions that the
> endpoint memory access descriptor (EMAD) comes right after the
> FF-A memory region header.
> Prior to FF-A version 1.1 the header of the memory region
> didn't contain an offset to the endpoint memory access descriptor.
> The layout of a memory transaction looks like this from 1.1 onward:
> Type | Field name | Offset
> [ Header | ffa_mem_region  | 0
>   EMAD 1 | ffa_mem_region_attributes) | ffa_mem_region.ep_mem_offset
> ]
> Verify that the offset to the first endpoint memory access descriptor
> is within the mailbox buffer bounds.
> 
> Also, fix one hardcoded sizeof(struct ffa_mem_region_attributes) that
> should be replaced ffa_emad_size_get() for compatibility with FFA v1.0.
> 
> Fixes: 42fb33dde42b ("KVM: arm64: Use FF-A 1.1 with pKVM")
> Signed-off-by: Sebastian Ene <sebastianene@google.com>
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 29 +++++++++++++++++++++--------
>  1 file changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 2d211661952e..1a2abd0154c6 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -476,11 +476,14 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	DECLARE_REG(u32, fraglen, ctxt, 2);
>  	DECLARE_REG(u64, addr_mbz, ctxt, 3);
>  	DECLARE_REG(u32, npages_mbz, ctxt, 4);
> +	u32 offset, nr_ranges, checked_offset, em_mem_access_off;
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
>  	struct ffa_mem_region *buf;
> -	u32 offset, nr_ranges, checked_offset;
>  	int ret = 0;
> +	size_t mem_region_len = !FFA_MEM_REGION_HAS_EP_MEM_OFFSET(hyp_ffa_version) ?
> +		offsetof(struct ffa_mem_region, ep_mem_offset) :
> +		sizeof(struct ffa_mem_region);
>  
>  	if (addr_mbz || npages_mbz || fraglen > len ||
>  	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
> @@ -488,8 +491,7 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  		goto out;
>  	}
>  
> -	if (fraglen < sizeof(struct ffa_mem_region) +
> -		      sizeof(struct ffa_mem_region_attributes)) {
> +	if (fraglen < mem_region_len + ffa_emad_size_get(hyp_ffa_version)) {

Can't we replace mem_region_len with ffa_mem_desc_offset()? that pretty much
looks like the same thing.


>  		ret = FFA_RET_INVALID_PARAMETERS;
>  		goto out;
>  	}
> @@ -508,8 +510,13 @@ static void __do_ffa_mem_xfer(const u64 func_id,
>  	buf = hyp_buffers.tx;
>  	memcpy(buf, host_buffers.tx, fraglen);
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {

This check looks like ffa_mem_desc_offset() with count to 1.


> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	if (!offset || buf->ep_count != 1 || buf->sender_id != HOST_FFA_ID) {
>  		ret = FFA_RET_INVALID_PARAMETERS;
> @@ -574,9 +581,9 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	DECLARE_REG(u32, handle_lo, ctxt, 1);
>  	DECLARE_REG(u32, handle_hi, ctxt, 2);
>  	DECLARE_REG(u32, flags, ctxt, 3);
> +	u32 offset, len, fraglen, fragoff, em_mem_access_off;
>  	struct ffa_mem_region_attributes *ep_mem_access;
>  	struct ffa_composite_mem_region *reg;
> -	u32 offset, len, fraglen, fragoff;
>  	struct ffa_mem_region *buf;
>  	int ret = 0;
>  	u64 handle;
> @@ -599,8 +606,14 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	len = res->a1;
>  	fraglen = res->a2;
>  
> -	ep_mem_access = (void *)buf +
> -			ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	em_mem_access_off = ffa_mem_desc_offset(buf, 0, hyp_ffa_version);
> +	if ((u64)em_mem_access_off + ffa_emad_size_get(hyp_ffa_version) > fraglen) {

ditto. ffa_mem_desc_offset()

> +		ret = FFA_RET_INVALID_PARAMETERS;
> +		ffa_rx_release(res);
> +		goto out_unlock;
> +	}
> +
> +	ep_mem_access = (void *)buf + em_mem_access_off;
>  	offset = ep_mem_access->composite_off;
>  	/*
>  	 * We can trust the SPMD to get this right, but let's at least
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
