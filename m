Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348D117BB16
	for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 10:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725013581; cv=none; b=hf9kfuPosnT/Fy6jG3CCtiyz5VjFUvSl3Suejec3oZxFG+/nRlpUe3ZDVqpKqy3FxtLxD/3nMkmFTyktZUZ3hiRBUT9GRN2q6XbdqAdXKAmeGkDxKupmWmYutacH+QVQlfQW/ZQkW0URMJEUnS/MmNHgsk1P3qLxZkARBA2MC7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725013581; c=relaxed/simple;
	bh=WQ99LJYivjNjc/YxBFt3pqsTi3RuoGAipkdSws+qEm8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NdVMlegWbT8tMv4UBjyKjW+6y6szbI/LWz6UtIdzFRy3EgrACuCtacrMqFEnb/yMgg67msBd89BER+lQlUJpiLYj+D/3Rb7r09u2XYQXsnGpzpFV28thOKFQDo4C8k+jT9YWeQr3Gw4EwCaLEY4mMq2MwVbMFy8jIq2MStmsCWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GDozSoZ2; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GDozSoZ2"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-428243f928fso18499895e9.0
        for <kvmarm@lists.linux.dev>; Fri, 30 Aug 2024 03:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725013578; x=1725618378; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wn4eD9yWatFflL2/3CKv6e2tbHrAQe8FmHkt92+sPt4=;
        b=GDozSoZ2zeCIoLJIY9XbRxxgX3c/gKIt2Prr2CsP7WHThknpE7I+6QGETnEsX5RkDO
         mkuD+kfPOS/HKWLV8SUtky1uGBDORG59kWbNEWU2OCl/9Eo27B5sC4Xn6MeA6+hgtnKd
         0rLCdu6TSY8sWwGIxzIEv/4nU8Q6P/agfs2H5ixG1OjfCGzFWyZyjgonvMKJ0+zAuEjm
         fnGQ4ikfj2toS02GEY3AkCiso8SVkrVEXTQ/P0b4YVCDM4bCQdpdhzT9IppKrqvxpTDY
         473fE9z5v2oExbBzX8TL+us7J8AV2PW9Sflaq6KYMoK681Yg64WiD037/fu+NMm1/9+d
         MGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725013578; x=1725618378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wn4eD9yWatFflL2/3CKv6e2tbHrAQe8FmHkt92+sPt4=;
        b=QTYAJhY8Fvmzc/b3kq9+69oc5s+p3dMoMS9gexZU6laUpjAsvM6SukSQ/iWmQh9DfN
         uZxOGDc5JkZZOjIalfz7I7mfn2N2n2MYn391ceNLgvE/auAqsWuPeqEPZpQ8WT6nunDx
         6wzEeU9cXTYIgrs5gx1uNPI8LLor2LunbnzJeCwMaRDW8U035hkpNvL8LAE03Tcsb0hm
         VU+iOODxDTG5Ked8U0nrencVkQV1Y8WnkCBBloBO35WHuUnrVaH4TsEWSCjePFBtt7jL
         m4mRSL49+9ITstbhLDG+LIPRvfCXZoWMje1eqVfV7o9XtBHv9fq/QmzsgtqxlwU9qw68
         +KVQ==
X-Forwarded-Encrypted: i=1; AJvYcCX3/KI9EdtsdjVxPlYtvFLExBzvSEWLx8tQ6HjKbNLkf0rZ8QHaBHymdg1hZAA6QLgJBqlsTsU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1bTvCD/fAuE77qw6zBar9EKQ9k/lZ0qQaIVrOuqjtas80ovSS
	vUcTh1yPCtjyKWpCh7ZY0zXLMBmuRSvCTC/RFOrPLKKQO3nDqOdwQ2EXb4QhJw==
X-Google-Smtp-Source: AGHT+IHI/5ydMtgQPWhtQcchOILEP7cSDqvBil+uOoViRI+AG38bTMnFmDMcZTINUD1xJvmzIZz6LQ==
X-Received: by 2002:a05:600c:3b10:b0:426:6ed5:fcb with SMTP id 5b1f17b1804b1-42bb01ae1fbmr57292825e9.4.1725013577995;
        Fri, 30 Aug 2024 03:26:17 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42ba7b4271fsm70580775e9.29.2024.08.30.03.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Aug 2024 03:26:17 -0700 (PDT)
Date: Fri, 30 Aug 2024 11:26:12 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: akpm@linux-foundation.org, alexghiti@rivosinc.com, ankita@nvidia.com,
	ardb@kernel.org, catalin.marinas@arm.com,
	christophe.leroy@csgroup.eu, james.morse@arm.com,
	mark.rutland@arm.com, maz@kernel.org, oliver.upton@linux.dev,
	rananta@google.com, ryan.roberts@arm.com, shahuang@redhat.com,
	suzuki.poulose@arm.com, will@kernel.org, yuzenghui@huawei.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH v9 5/5] KVM: arm64: Introduce the PTDUMP_STAGE2_DEBUGFS
 config
Message-ID: <ZtGeRNhMv1f3M2lh@google.com>
References: <20240827084549.45731-1-sebastianene@google.com>
 <20240827084549.45731-6-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240827084549.45731-6-sebastianene@google.com>

On Tue, Aug 27, 2024 at 08:45:48AM +0000, Sebastian Ene wrote:
> When this config is enabled, it exposes the stage-2 pagetable layout
> through a debugfs file.
> 
> Signed-off-by: Sebastian Ene <sebastianene@google.com>

It doesn't feel like having a separated patch for Kconfig brings anything and
I would have squashed it with the previous change.

Otherwise:

Reviewed-by: Vincent Donnefort <vdonnefort@google.com>

> ---
>  arch/arm64/kvm/Kconfig | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 8304eb342be9..ead632ad01b4 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -66,4 +66,21 @@ config PROTECTED_NVHE_STACKTRACE
>  
>  	  If unsure, or not using protected nVHE (pKVM), say N.
>  
> +config PTDUMP_STAGE2_DEBUGFS
> +	bool "Present the stage-2 pagetables to debugfs"
> +	depends on KVM
> +	depends on DEBUG_KERNEL
> +	depends on DEBUG_FS
> +	depends on GENERIC_PTDUMP
> +	select PTDUMP_CORE
> +	default n
> +	help
> +	  Say Y here if you want to show the stage-2 kernel pagetables
> +	  layout in a debugfs file. This information is only useful for kernel developers
> +	  who are working in architecture specific areas of the kernel.
> +	  It is probably not a good idea to enable this feature in a production
> +	  kernel.
> +
> +	  If in doubt, say N.
> +
>  endif # VIRTUALIZATION
> -- 
> 2.46.0.295.g3b9ea8a38a-goog
> 
