Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD3E372B2C
	for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 09:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774863668; cv=none; b=A+tb1/rKY9ANEJBLVbQbD3k7aS0r5A8NRFdr+NP4+5afVsLaRHFQi6tILORyOC/6Afl4CLJr/FW/fcJv/L79fIcqF0UcX42sm3Zv9djlyUC2B9EghChWlxKtOIZVcxOz+IuahBENhVTaIRP9ixlaXXFQSU1Na9oiNbhHnexYkLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774863668; c=relaxed/simple;
	bh=z4lDoyrwIQfXoh05jn3lKF2DCTkvjwaG2w5l2u1YWNg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z3HdyvnnDx5Ocg2ke4xRLIcG7r7CzwqC/2TjmZSamcIod+zgooMXzl3WUvgJRcPEZvxepLXsKzUZp96Vv383FDr4+3E55r2Y1esjZ11SsJe4ykCKMKni396LyKLFwi61R67l1OJxYTRK3U6FN55bj9Pm/oEFeOhWtmh4IswFOWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dFXKmpNS; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dFXKmpNS"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a2ad56dbb2so2293437e87.3
        for <kvmarm@lists.linux.dev>; Mon, 30 Mar 2026 02:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774863666; x=1775468466; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zZNGZDhto4jkAxNh9++YfrnwQanqMAXiu2o8XL7KzB8=;
        b=dFXKmpNSDZn4Q4Rp43Jsh+oVv52yo6b8tdYuQNYw7YmehrXQcxexydS3zYENMmyjwe
         gDtwYk4YDIQ8+9uiKKFoZMX+zsEJthp/W+jXrnsyqXHhODhoGh7FvS+k+6SmnxQf+mRf
         ffPsVcjNDsmb9unt34sT2iZv628wnqGyuWNCq5tUDy8ta39C4ZsNUuF3dIHf+HSsc3DT
         8K2h3fz8L92P10Q7VbHvKqGkrDHswbZw/ls4zRyo0oaF8Owh2WF/xEHvaEYGiEhfu5gX
         56phWake0dJzMghEd0Jb1bXpnpLwHF5QhI3ssr+t9QjUZO5w1xUCZLdoOJQjn6/raqOO
         TUiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774863666; x=1775468466;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zZNGZDhto4jkAxNh9++YfrnwQanqMAXiu2o8XL7KzB8=;
        b=FNuqByrth5lU65fwPmUlzVDTqysI9b8BfGFa0B2nVh+cYxoj2dFET9TwsIbCXwFmhs
         QLIvIbNLQOQ4BSeCL1K4896FYXeECE8K0d30k1Zt6v47z16av7CeRuTtp0ai8hoPGXVi
         eybClHrtEIQMxR1eB5/PPXYO0pyFnIRteezE0oHDDoN/0bUhocuwcSQtBztUHdBzZuGr
         PWju2eySluO3naSm/2RLyuz6K+l+mGAPyh6PtqBSHnglm8rvadA/4QUCjGh8N3h35LN8
         e5Xrl5CN3RaOtKysA+6XfWNhpLSRD8FNl64EQkxNQgWcWORZ72EhrL6sf2Chrg8+be21
         FX9w==
X-Forwarded-Encrypted: i=1; AJvYcCWj8zYcPOlFn7nFfbbKoRwV/7XRw/cnMBxEdI8UewCgf5z5KOnuG7w/86zFhH105eDl4wQL48w=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkEHrtCCwOmVOR9Pmi2FEKvefYyPmeyefp+ZDHFORGbICGW7wY
	2wjBYdWkicO5gKqzqEtvGEdqGjnfYn96oiijSEK7ImCGgVIX6ErS5Tv7QJ61cteXHA==
X-Gm-Gg: ATEYQzw4kdqWDBIPP3SsggVOSUqnMcFAwvJnepsCrg8XYSbMHpju6P/YmedT/w9fX0Q
	ZCUPXPBe8vBYodKcLE5/5gi/xYDMD4VMkKZ9/P+ihh8o/MPyrJ8rsIRAJOuPma4vUcCblDZzoNE
	rYrqcOVo4YiAj7PkUjrjEGq8Xm276JrObZHAb6ZQPAwAS/+ECcrEi/2LcuW/Zy2qrW+zGsWj/RJ
	9ob0Tr0+PX4vQggF6u/O3JoCZaYyI8qL0F3f1npTNu6+o9SJItH1jq3JEPqjK7IDL6uKSVrLiIk
	+uTy2r/XZt/X+dicKEE6cbRYuGj1M3M/jiM/xqlGnUoYYMXzuNi6dvEy4cVzVlBCBxunJJdLrod
	VTG93jM3OzvXsIgqqsjs+n99wW/g/sHXjxHzCRmVdSxu5hmvLZIGS6TccGj++x/Cjpy1+KQID5Y
	4HeswbkQ8pwu02qGakYnhMW9MGiSo7dpSG7kXDBgBSjxxT48Xe4JCYe11yQdB+PozGVA==
X-Received: by 2002:a05:6512:3f0c:b0:5a2:7a31:9194 with SMTP id 2adb3069b0e04-5a2ab80d971mr3942218e87.19.1774863664954;
        Mon, 30 Mar 2026 02:41:04 -0700 (PDT)
Received: from google.com (27.69.88.34.bc.googleusercontent.com. [34.88.69.27])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a2b145f1dfsm1563489e87.79.2026.03.30.02.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2026 02:41:04 -0700 (PDT)
Date: Mon, 30 Mar 2026 09:41:01 +0000
From: Quentin Perret <qperret@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: maz@kernel.org, oliver.upton@linux.dev, joey.gouly@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, kernel-team@android.com
Subject: Re: [PATCH] KVM: arm64: pkvm: Rollback refcount on hyp share/unshare
 error
Message-ID: <acpCq1qZCMFqocs3@google.com>
References: <20260324172757.2147153-1-vdonnefort@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260324172757.2147153-1-vdonnefort@google.com>

Hey Vincent,

On Tuesday 24 Mar 2026 at 17:27:57 (+0000), Vincent Donnefort wrote:
> If one of the HVC __pkvm_host_share_hyp or __pkvm_host_unshare_hyp fails,
> rollback the refcount to ensure the hyp_shared_pfns tracking reflects
> the actual sharing status.

If any of these hypercalls fail I think we're still in trouble as
kvm_{un}share_hyp() work on multi-page ranges and we could leak pages in
a borked state if we fail halfway through. And failing any of these
hypercalls is also sign of a bigger problem somewhere else so I wasn't
too worried.

But if we're going to fix this properly, I'd suggest also improving the
error handling in kvm_share_hyp(). 'Fixing' kvm_unshare_hyp() is a bit
harder because we must tell the caller to leak the data structure that
was shared I presume, so maybe we just keep the WARN and cross our
fingers :)

Cheers,
Quentin

> Signed-off-by: Vincent Donnefort <vdonnefort@google.com>
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 17d64a1e11e5..0fb41d2c8b44 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -493,11 +493,17 @@ static int share_pfn_hyp(u64 pfn)
>  		goto unlock;
>  	}
>  
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> +	if (ret) {
> +		kfree(this);
> +		goto unlock;
> +	}
> +
>  	this->pfn = pfn;
>  	this->count = 1;
>  	rb_link_node(&this->node, parent, node);
>  	rb_insert_color(&this->node, &hyp_shared_pfns);
> -	ret = kvm_call_hyp_nvhe(__pkvm_host_share_hyp, pfn);
> +
>  unlock:
>  	mutex_unlock(&hyp_shared_pfns_lock);
>  
> @@ -521,9 +527,15 @@ static int unshare_pfn_hyp(u64 pfn)
>  	if (this->count)
>  		goto unlock;
>  
> +	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> +	if (ret) {
> +		this->count++;
> +		goto unlock;
> +	}
> +
>  	rb_erase(&this->node, &hyp_shared_pfns);
>  	kfree(this);
> -	ret = kvm_call_hyp_nvhe(__pkvm_host_unshare_hyp, pfn);
> +
>  unlock:
>  	mutex_unlock(&hyp_shared_pfns_lock);
>  
> 
> base-commit: c369299895a591d96745d6492d4888259b004a9e
> -- 
> 2.53.0.1018.g2bb0e51243-goog
> 
