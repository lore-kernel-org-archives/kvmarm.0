Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9752BE043
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 16:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781799568; cv=none; b=n1W70WWxPZ3o7plHp34aRjZxqrpfjlIP/KXV/viTyOU/hZ7AEWZF8WlyyB4hVZFwKX53aIAoqfdTQHs/Om4wDIRSLqw5WIak9fuUSwBmguntOEPz+uHKfFQia3kpGYAqHPulTvTfMmVv1ESC1UtED0zv+JzdsVK2PmdB/j5jXKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781799568; c=relaxed/simple;
	bh=uzmUSZKJNxpvsYM+nwXF0RdLyej6el26bxG8gdr9KNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CBKvdfVMtgyeuqH3c8X5RIwsvpQplcJoApKAD7mTpX1P0sGJk7l/9jvGDddFAzMlSrPaCQAwqRpgq15P4wH1ipCxdy7HslSp2Hvxm2/tqd6oevzMJLjmqSTBNwx32TKMx+kT3eiJV0RX4u270c+Zyt/m8zxuB/Qoq45T1RA3zro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=gPOc8a4c; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="gPOc8a4c"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-46255b269c2so845404f8f.3
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 09:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781799566; x=1782404366; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5MNzaKBiFWGgNDTUfrZ2uI/mAEuS8g827vmh39Qo+Zo=;
        b=gPOc8a4c0oorA+a9s2gUiIBr1KZwz2eF5exJfHgvUq+aDrenH0OMqceYHTAHWKkZZr
         QWLTZQ5SBsX/lekR66WXB5Jt+0kg8dhEB0GRj0qSovCC1F+fmmgcW8cvtomvdaFKFJAU
         ltYoWnSBE78dJXBDFopHZPwYXQyRUg6Ov+lm1dczjCdIVhbbBh8IphATT8KUKxPUR8Fr
         ilZDafg8tFRfvEAeHXlIJtcU3lBQUjEFYdMKCthycmjzmt7VQah8E7B/ckwkp10YV0ZC
         dUFACuIfV+i9suNCh4Kf/5g0psrEc8nPAtbu0aeb+EUtYUt1LukWICp7cVBOKNRxOMNc
         NPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781799566; x=1782404366;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5MNzaKBiFWGgNDTUfrZ2uI/mAEuS8g827vmh39Qo+Zo=;
        b=Hf4odqyyMlhvx6mGNhWaNlRSdVG09Rksc/+FLBJSida3JAFWfh5RJibqKQXZ0VFOQ3
         0Wz6+gRbhv83z91kk8Yrw+Ua9rf4p1VztUBu9BOXZ4t1ThYZ55aQziWBULCahhhHA+vc
         Ae3Qti9Ctoz15kDsfZr1A8pPSG4YaCkr7YMwE4q1nQRRbEWSFZukAJewc8q4ZandvGBt
         uU3qyeA8d0PelAA2Jw9f3SrOaJYppAkd/FMeqUuZTH8xBz948k6qQF0/qJtn/ENsRi5C
         7wVAAhX8QhwOWNie8u/S/XKFF128cyQj066+MrnErg2meNjOVEw1udeL/64VgO9CLVMP
         HFkQ==
X-Forwarded-Encrypted: i=1; AFNElJ9YLTmt3XRfxW912RlKtOvSzFubHUZuGJ91huQKaixFa7um9UMQTVG8NKuaFaW/1cVvTEP6wm0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxijS4pugOZ6IA87qBhkTRoKPanRklPZKprDzbZPxPYl1gzTXtn
	visds9cwM+De/RXXdI2TPYzbU9Oo0fN+meVQVjONdAoMGVkP6/DA3eQPzTaDtIcu9w==
X-Gm-Gg: AfdE7ck/SqoKJ3MSuchNGlh8cgPRg5OJAP1YrCtqRxZxwON4Xs9pnCai0cnCE7lpcI5
	n4O1EA5A7Wfn0mAd0zuQ5T2UkhiDQ/qDni0LVYa2Z5XPzbuhlmv37VGXD2Y4mX97Jm+9LMcIO6Y
	Rh8ZfyrSiUiS+BgtFZ+PbaAiv7mwP7Fqnx5EHKR7uAjmmU5PQeXNz/LvtuWDZsQbkaPlaCCSbhq
	nHDoE93WDEkhlvgnqiGSiljT/zk4PzEOdkmFJ1GIJ5g/jx5h62CdECg0duGvg1OFGXNyLK/vqUX
	KTM7JqW4ty7/QXutRGIb2yn0ZNcJUwCSjvGVvw3phXeqcqLy4Ow1aP2ie9ypNTPtNN1lT4kZAnJ
	oobhSj2uthRRbO69BuL1dluuzYyqFV81ajKph0sLt/FsDDwyFt0nCmdEzdyunG05/zq0fw9ocYk
	KG02DbNO0PLRgrQ+nnCxzrnudOWxVXOGVPnsl344k+KC5+S6H0QdU9IVyE
X-Received: by 2002:a05:6000:2384:b0:464:1462:2286 with SMTP id ffacd0b85a97d-4650052fe2amr287936f8f.16.1781799565346;
        Thu, 18 Jun 2026 09:19:25 -0700 (PDT)
Received: from google.com (135.91.155.104.bc.googleusercontent.com. [104.155.91.135])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-46289c3b3a3sm16235705f8f.30.2026.06.18.09.19.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 09:19:24 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:19:20 +0100
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
Subject: Re: [PATCH v7 4/7] KVM: arm64: Fix bounds checking in
 do_ffa_mem_reclaim()
Message-ID: <ajQaiM7pIXzzl_vA@google.com>
References: <20260617145130.3729015-1-sebastianene@google.com>
 <20260617145130.3729015-5-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617145130.3729015-5-sebastianene@google.com>

On Wed, Jun 17, 2026 at 02:51:27PM +0000, Sebastian Ene wrote:
> From: Mostafa Saleh <smostafa@google.com>
> 
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
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

FTR, I believe the comment about composite_off in include/linux/arm_ffa.h is
incorrect. It is an offset to a ffa_composite_mem_region (not a
ffa_mem_region_addr_range)

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/hyp/nvhe/ffa.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> index 1af722771178..2d211661952e 100644
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
> @@ -636,11 +636,17 @@ static void do_ffa_mem_reclaim(struct arm_smccc_1_2_regs *res,
>  		ffa_rx_release(res);
>  	}
>  
> +	reg = (void *)buf + offset;
> +	if (offset + CONSTITUENTS_OFFSET(reg->addr_range_cnt) > len) {
> +		ret = FFA_RET_ABORTED;
> +		ffa_rx_release(res);
> +		goto out_unlock;
> +	}
> +
>  	ffa_mem_reclaim(res, handle_lo, handle_hi, flags);
>  	if (res->a0 != FFA_SUCCESS)
>  		goto out_unlock;
>  
> -	reg = (void *)buf + offset;
>  	/* If the SPMD was happy, then we should be too. */
>  	WARN_ON(ffa_host_unshare_ranges(reg->constituents,
>  					reg->addr_range_cnt));
> -- 
> 2.54.0.1136.gdb2ca164c4-goog
> 
