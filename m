Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E469225A52
	for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 12:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733920700; cv=none; b=nuuKbLU8ZpVllti8kPKzRbTtUxw8tSNzyODGLxJ6214Ez/NkDh6kntMrkbk5hZQ5Mp2xc5yPZQaHGIotXQCQdsDF4yNs0rUYBXSSbsn44ulxJDl0vfdjugPQFCuroX3iwwEzy75m2LXwq1P2aeGEEQeXQtXkBZo9ChgZIJmehP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733920700; c=relaxed/simple;
	bh=d8QwBI5WuN/+dH4l3O0PLt+SRsNxppzG4OgEwivjAdQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r8oFD9AkfAM0vzruvNurVQJrzVThqdN6ZPswXJ1t7sA9XYMwCTs11vGQEFr/TtzLF7+3OAx1oD+xfuYp5bzezmi14k/McIQojEbxqFxaWo9h2xaBUjo/6TWw7zwAgaGREDlWvGv7cAXb3Uv9E4id5954+p+Mh3oBuA1VVioEIJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mPyj/H/f; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mPyj/H/f"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa69251292dso548237766b.2
        for <kvmarm@lists.linux.dev>; Wed, 11 Dec 2024 04:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1733920697; x=1734525497; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4/2Xaa3Dzt+5ztTkftxM7MuahK+LJjUTZ502uY5Dxyc=;
        b=mPyj/H/f7gCp71Ef3U1EgpBhQTXuh2u2RI7yyCwFIln9coLYQGbbNk7TFNP0lHu0jn
         jf/CqU/z//g1LlQ0QFnMvb+x+b0ivaYPzrnlk6JgbUVaDLhUPQOuQ97wRb+a+39eckDc
         lnDsfBE8v88J3426ODpq/08sdIbOROKiPN45IirJjnunAuFo69x1qUi4RYNWBgJ8QRV9
         QSDNbK4Gon+97DCrMNFXt5k6mAPQFnusej5W9JWpW0wjPDy/Ox77yy7kGcrnMd9n/xuN
         QLZm38FAWS2sQPhwXTjqD6bii42rP8X5XXQbDCv4QlehGv4JVUOmoTqV28HYotp5OrQM
         wQlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733920697; x=1734525497;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/2Xaa3Dzt+5ztTkftxM7MuahK+LJjUTZ502uY5Dxyc=;
        b=pDHj1/e5gYtbP3XECWKNzW8ouf1+kNSec4LehmhJH091goWUsQTPARazpNBVHqJIXQ
         Xolz66ZDkHYrTMUycBENjiADkYjlmOyqxPUlLEBKZ0x7hbhR/OLDt91pIHa70228kZtM
         Mocf68IyAH0MoTFi8v/+2OxUlBtcFnHB6GkSbcv/SUNLGbWMH06BtHjVNClH1g40piJy
         TWr5o+xDTPI0dcI+6ry84mVtblBw4D1kEAYNRGIb67n/L+h0ODRASneQQ63H+UedwjBx
         5UAuSHLBCqtSFDqGG0YhRrY/C9moAnu1Dmh/TNP9Aja4x2eebSeeMJ2xgc5ozd3WZk61
         1oCQ==
X-Gm-Message-State: AOJu0YzZSipUGLZBgkET9KXz1JUFNbQazrn/5SDPCY0cl/gCnPo3pMZk
	B7EKWqUCt2EcWeYhTdzNzfS/851G6+iFpK8WQMnXoFQHbX6+aSfI9jIbevSLBA==
X-Gm-Gg: ASbGncuyD9nYvYxEJ55Lk4x5zvwHrnuP7BP3a8a/sIvjBRl/u2qbjhA77XYBWPkmOzm
	88ncSKXwnWvwOWy/GmHcOyO4Vn8PjMEqRmelTkH4kb33/5/PQIrkYM7rijsBCOXC34tNeu0LKrG
	F19eQZGrW1pCz+y6ozvI+kYruU2WoZl2u9vfJ7eCOj42VUGGyIvdfJY6sKrd68Lp4QAk7XFQn4k
	AvitLn8Hoa8jd7K5tDpr8rl+YC8/WxdHzU2gTY7Lrw19CLU+4lh/m7puvkIcV+ksEcKRxuOSdeK
	E0+xR6SMDK/v
X-Google-Smtp-Source: AGHT+IH5ipgPbbdkuBNOvIujiXUCRr4dV1jLAa3zBl9FrLSEGeuaXMb+t2LT4GmatSEIkAmek7cOMQ==
X-Received: by 2002:a17:906:2921:b0:aa6:33cf:b389 with SMTP id a640c23a62f3a-aa6b11f648dmr209782166b.34.1733920696526;
        Wed, 11 Dec 2024 04:38:16 -0800 (PST)
Received: from google.com (61.134.90.34.bc.googleusercontent.com. [34.90.134.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa6a7e199aasm214057766b.28.2024.12.11.04.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2024 04:38:16 -0800 (PST)
Date: Wed, 11 Dec 2024 12:38:13 +0000
From: Quentin Perret <qperret@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oliver.upton@linux.dev, james.clark@linaro.org,
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com,
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org,
	kristina.martsenko@arm.com
Subject: Re: [PATCH v4 09/14] KVM: arm64: Remove redundant setting of HCR_EL2
 trap bit
Message-ID: <Z1mHtVJ4f7_N_wk4@google.com>
References: <20241202154742.3611749-1-tabba@google.com>
 <20241202154742.3611749-10-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241202154742.3611749-10-tabba@google.com>

On Monday 02 Dec 2024 at 15:47:36 (+0000), Fuad Tabba wrote:
> In hVHE mode, HCR_E2H should be set for both protected and
> non-protected VMs. Since commit 23c9d58cb458 ("KVM: arm64: Fix

I'm not finding that sha upstream, in which branch is it?

> initializing traps in protected mode"), this has been fixed, and
> the setting of the flag here is redundant.
> 
> Signed-off-by: Fuad Tabba <tabba@google.com>
> ---
>  arch/arm64/kvm/hyp/nvhe/pkvm.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> index ffa500b500f2..cede527a59d4 100644
> --- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
> +++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
> @@ -57,9 +57,6 @@ static void pvm_init_traps_hcr(struct kvm_vcpu *vcpu)
>  	/* No support for AArch32. */
>  	val |= HCR_RW;
>  
> -	if (has_hvhe())
> -		val |= HCR_E2H;
> -
>  	/*
>  	 * Always trap:
>  	 * - Feature id registers: to control features exposed to guests
> -- 
> 2.47.0.338.g60cca15819-goog
> 
