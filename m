Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B14037475C
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 14:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781274154; cv=none; b=AeEkqgw9pPP1pdGO9dibNdiG3DsSn69f/lU9bRfSSbEcgHsp27/sJCyDKT4dDtRWOcnZ6axpwoRqQxueSiEsjtYexfC0VIlPSbYKhyZmBHAGxTIA0L4HiJXwOJjjNT1Mh0fWlBI4+XZbAtwP3KXVBczN3FPMmB+r2DED2fsGHUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781274154; c=relaxed/simple;
	bh=zHwPddHtZ+nAl0/u5z9/ESyAgx0+d2S2sHjzyMdqxQY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TNQfytW5F7fxkVNNZiRWCIPQ2EBbzj+M7p0EnZeOa7pRYt3jZ+pPO9uMtaNATpKWpriYYwnhlSxUZ6HD43i+mH0zSGN6m6OrHETNO9v7qktqjrSeuW+ThoYidOnCJDnUTGfh9QwqFu6WNgR6V6d82KgafOJC1fsmQPh68QQvEGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J6xAFop9; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J6xAFop9"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-490bd64ca95so70705e9.0
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 07:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781274151; x=1781878951; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U0u5FTqBTXNLLGdidnrnWIaCMVX09cl5M57gIDTlUfs=;
        b=J6xAFop98stcyrXduEGy9xMZN//neKqhuTEGc0+NIo/GIhY8FghrmH7XLCFEAMCC5r
         monaEfXHhbrEnaHFMLPM/JsX5dGpYdrPasmhEahRl8lY/Dt/k23BAHI15m30UKjwJFOR
         +Hw+S9/e2o+KmcDgu0UZrb4ZjgQGkzGaHRqgG9KtSB3ZthUMF3Rd5W6B+YUdabBtWv/g
         OPqqpt4J2ZadNo1wmJzG1bC95dskmmNRYwd72m3lieICNHYWO8zfG/T2VZsYEtIHkGzO
         kOfUgLE0Bqti39VLClrLBDYWA1uq56WjbGypSuO4YgsW9ONdXHTQnTv1U3gCs9vZ4rIP
         iXlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781274151; x=1781878951;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=U0u5FTqBTXNLLGdidnrnWIaCMVX09cl5M57gIDTlUfs=;
        b=Ni1+WUAjMwbNdndK9g0VxaZVchFNh7OXdVsATZCCWSJwynTmGTtuj7eMxXDMhYIXRl
         HPeCMcncz4fim2XmywMLU8AO7+c5kZEyx4KehKnj8fF/PeVjizdTApk47ZRiU70N2BhW
         ZfUglzX8l+RTsyHR8FOwOlNr/wzlGnhsRbpo9p7/xoyhcx7CpGuPXs3zUIaQwaqGZ/cn
         dYBlCO5Orx0O7dXaenMCKlHx7jPIWYdc9m8NfX/3scDPeU4eIAtb63st30hn9rqlRAu6
         SgL4teb2MKSjC2vwOzO6pQo/wB4OCavJn0hbB7L7FecCr0lHXiAEXiNryGghlmfQk1sq
         c9kw==
X-Forwarded-Encrypted: i=1; AFNElJ/iLdB/pWXKszUup9DfAtasqm3k8wtCcAVyB+elvtJoIjHXsKkyjMc+CuWnY5T+9xWCChORsOc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzhjB1T16DT+lW4/Cg7uE9u+Ym95YVD+0BBLd0EIwZPTNLCdiTe
	cPY27jHrLI1Wp6NkgUm8IT6IH5reDGZAFD5ibrEK0nERixXaHX5oIbyZFNi5HkGMaw==
X-Gm-Gg: Acq92OGtVk+p9Hc9baYmDbRX9Q0MzC2USe5sig+HCZe46mwSVonLLJ6bsmwDnDF9HAx
	OVTV6887JGwhT/v5x5JNB7w3TquHBcA0WHZXq31aGcVxDlm1FxNTdC3ccmZWolymJtpYIe4MKI0
	/rzh3/AmeWg4OUvxGO3wyJsxJQgItplgDHAqOutrtrZnFwhyLj7jtXAPtdfaYAP05c0LK0KfZKf
	t11O3mbAxxiYiiG4Qcw2Ru51G7Z1ItIaiMwjzs+c03CscuOJkdx5BulpbEux8vk1WkpbI3YXBbw
	jr2w47/0PTnZDJu+5UF0wmqePfVuMLLqwlI0BhgV8JSjXQfsfoJea8/Jqzcb9H8ZC2LC/2nBgjb
	pVW6N0tptxqoZXtLCU8QQOgY+27+rQNU69ZqWeoNgsnM9ilfzXlovC1GZbv5y/oX73Sot8KcsdT
	z4mCUZor6ZEjQZvLmnY9u7E9LJkWJ5op6YxuV7BzgwczFE5YEQaIrw8uKU6xXTOi1j1qBp+A==
X-Received: by 2002:a05:600c:6b62:b0:485:1a54:9407 with SMTP id 5b1f17b1804b1-490ea5204ffmr1201925e9.0.1781274150414;
        Fri, 12 Jun 2026 07:22:30 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7db9c6sm71157125e9.8.2026.06.12.07.22.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Jun 2026 07:22:29 -0700 (PDT)
Date: Fri, 12 Jun 2026 14:22:25 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: op-tee@lists.trustedfirmware.org, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, joey.gouly@arm.com,
	suzuki.poulose@arm.com, catalin.marinas@arm.com,
	jens.wiklander@linaro.org, sumit.garg@kernel.org,
	vdonnefort@google.com, sudeep.holla@kernel.org
Subject: Re: [PATCH v6 4/6] KVM: arm64: Fix bounds checking in
 do_ffa_mem_reclaim()
Message-ID: <aiwWIRS-l-SS-wcK@google.com>
References: <20260527150236.1978655-1-smostafa@google.com>
 <20260527150236.1978655-5-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527150236.1978655-5-smostafa@google.com>

On Wed, May 27, 2026 at 03:02:34PM +0000, Mostafa Saleh wrote:
> Sashiko (locally) reports out of bound write possiblity if SPMD
> returns an invalid data.
> 
> While SPMD is considered trusted, pKVM does some basic checks,
> for offset to be less than or equal len.
> 
> However, that is incorrect as even if the offset is smaller than
> len pKVM can still access out of bound memory in the next
> ffa_host_unshare_ranges().
> 
> Split this check into 2:
> 1- Check that the fixed portion of the descriptor fits.
> 2- After getting reg, check the variable array size addr_range_cnt
>    fits.
> 
> Also, drop the WARN_ONs as that will panic the kernel and in the
> next checks there are no WARNs, so that makes it consistent.
> 
> Fixes: 0a9f15fd5674 ("KVM: arm64: pkvm: Add support for fragmented FF-A descriptors")
> Signed-off-by: Mostafa Saleh <smostafa@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..b6cf9ad82e12 100644
> --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> @@ -607,8 +607,8 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  	 * check that we end up with something that doesn't look _completely_
>  	 * bogus.
>  	 */
> -	if (WARN_ON(offset > len ||
> -		    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE)) {
> +	if (offset + CONSTITUENTS_OFFSET(0) > len ||
> +	    fraglen > KVM_FFA_MBOX_NR_PAGES * PAGE_SIZE) {
>  		ret = FFA_RET_ABORTED;
>  		ffa_rx_release(res);
>  		goto out_unlock;
> @@ -641,6 +641,11 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  		goto out_unlock;
>  
>  	reg = (void *)buf + offset;
> +	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
> +		ret = FFA_RET_ABORTED;
> +		goto out_unlock;
> +	}
> +

I wonder if we should do this check first and then mem_reclaim, the rational being that if the check fails
the page will be lost forever.

```
	reg = (void *)buf + offset;                                                                                                                                                                            
	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {                                                                                                                                         
		ret = FFA_RET_ABORTED;                                                                                                                                                                         
		goto out_unlock;                                                                                                                                                                               
	}

	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);                                                                                                                                                    
	if (res->a0 != FFA_SUCCESS)                                                                                                                                                                           
		goto out_unlock; 
```                                                                                                                                                                                                      

>  	/* If the SPMD was happy, then we should be too. */
>  	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
>  					reg->addr_range_cnt));
> -- 
> 2.54.0.746.g67dd491aae-goog
>

Sebastian 
