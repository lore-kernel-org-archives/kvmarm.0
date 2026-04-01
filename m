Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52249175A8D
	for <kvmarm@lists.linux.dev>; Wed,  1 Apr 2026 17:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775064127; cv=none; b=P7ucDte/9Mvho+vbsAo1NJ40oBAongfefz/xVvCvRrSmj/VjN5Kpkq79QghMdpDt3WZKva9nq8padaA/f6HoTa4kpUsOv8E34JCZzA+11ErXcdHHpHR2PTn92RhkXPv6R3e/66Vkh6mi5qWxbW8/yTCSdTFANn4ugTPrOBQpLyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775064127; c=relaxed/simple;
	bh=nfIssJp3sCyDprMsLOWWWTbEWvePk4WAb6EMj+ncKmk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XgUtlSl/6i52URXF3FGPXMq5V8P6b5v2h7JjLxGNUUufw65lAintwDZ5hXlMVI5Ji426iT+Nn6LrNsqbnqJtt4w6sP2Oznoo4tkuXN5I13+oKjekaovLPz4gggj7xVZKpEv1NlR9wJRDAW3ChCD7B0SJq96mM2pIfmEt80EbeOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OVYGnEV3; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OVYGnEV3"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4888939d2c3so4065e9.1
        for <kvmarm@lists.linux.dev>; Wed, 01 Apr 2026 10:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775064125; x=1775668925; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8FK7OAZJnMRvfLsIQNwvSj1elKc0MV4FPgcgTqTFOq0=;
        b=OVYGnEV31RhFn1jahA8TNgAQwZIgIbmjw0KINHK4RuH7mS7F2iCzNMFv7YUbUYFtyQ
         hdlO6tCBIFGFyQr1ELfTkrSYPfJeGT6/mAhyyZEsIsApoMZaqCUANFwz2yAqe/0yGyy8
         Lw3Bemnd3cq5kKhXvTcsz28EsE3Y11svGMNgZyDVo4qgamRZBBI772jgvv90N1wIxwtW
         KXwSuC0/R0cNTTpgdiZRVEBa/fHMAZZbDYyiarJpcZ0Q4BJMmnpoxMHSogIYICUe80OT
         kVQvDLChIVsrSNL3Y+ij1KiuJJz2sbR1xxS+OyQbfqm12R7904Z6oYCI4QeyBcSN6A9t
         oqtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775064125; x=1775668925;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8FK7OAZJnMRvfLsIQNwvSj1elKc0MV4FPgcgTqTFOq0=;
        b=B+zKWK/uQqIdiIlhXV7hFG5JYu2mMIkjSQShlklD75BUMR+9BvBMJ0NpHMdA9mdQIj
         0D2cNB6aXkCGyhHHhb2VkiqVnBDXPZV/rMvtgopo9cKE3nZ4feD1GJ78dBv3Xhp1lPbO
         eRdogXQOyc6fcx1laPf0/lCUgNV9rztGJIGli+YIm6Lasj/7oLtMfZZpXI4VmabgBr0G
         GooBMnhg7/3cnrkspgNde7anKaRBQw9xAYMXgKKybCebOyq/aYwge6xCOTUvt4U/X8GJ
         u6q9+JgCgWJncteNXm2rJp+Y0WaIfJL7zEhkccQ3viLKgRIr3oSrfQ11eaQ4EaeP1ON/
         /b/w==
X-Forwarded-Encrypted: i=1; AJvYcCVXHVtYVYOKRNlNm4WvRGvOtwbOQKB4DgPz4nh45mBi+aZqI/EleXZhmd4NZFVJ8Rk+bXJKxYk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywhqp5fAb6sSP3XpLeD2Uv+vwwLeoKFNIRoaW/V2z4jH+nqCXT1
	sgQBHnatdB5372VnzgEEEnlQvWm4XICEGEpbQYGS1H0o4J4BCJVMf4jpZ+MeWujGzA==
X-Gm-Gg: ATEYQzwMHKuaCbFdCMdh2WDDnwdmz1EPn/2fIlKeLxaRAywi2h/DRuMCyLpp1pXfhBM
	vZUvjtxGfsnsitgjF2jGP+Z9yPKOW3JK1HyoJv15+z83i/bm/DlmUNf/VObcx8OXuEfLoYsoKgY
	xFGXBh3mimMeQkqhOM7UrfvaBE1SMNulXpK2ynManXnLUtqtj7Ia9VXUeb+gVPZHVmJZioEWBsA
	SjUVmlyba+jrnut/iyRYTC1BjewG7re/GbILwJDTvZ5nZhbbKdtH8jvAt8EPBUTR8WUmAzK6CzK
	BuiRNJuePGvFg2gcjTejXX6rQSJ4m4DrLif0kGp0IK+pxauHW4ZZmC/Q+GBGTXNkMX4E3pv6rZy
	KHpyk85w8dirZMoGOb+36SSZxxXo8INMU1k8KWdMjV3Xpl/j1bfXFm/UcGyfGnwSjLYhpOxmATu
	CjOrly5BPvv+W0ZOSw+ZR0Nszvtm2PF/RPrc0XAXNMYHmZlL6O1cLRC6NGBu/KimEVKB0=
X-Received: by 2002:a05:600c:d8:b0:486:fd5a:18db with SMTP id 5b1f17b1804b1-4888b7a1471mr37475e9.11.1775064124308;
        Wed, 01 Apr 2026 10:22:04 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4887c8ee2d3sm49918275e9.32.2026.04.01.10.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2026 10:22:03 -0700 (PDT)
Date: Wed, 1 Apr 2026 17:21:58 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: catalin.marinas@arm.com, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	android-kvm@google.com, joey.gouly@arm.com, korneld@google.com,
	mrigendra.chaubey@gmail.com, oupton@kernel.org,
	perlarsen@google.com, suzuki.poulose@arm.com, will@kernel.org,
	yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Pass a 64bit function-id in the SMC handlers
Message-ID: <ac1UNj7Z1uVL4Nf6@google.com>
References: <20260401123201.389906-1-sebastianene@google.com>
 <86341e4to0.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86341e4to0.wl-maz@kernel.org>

On Wed, Apr 01, 2026 at 03:55:11PM +0100, Marc Zyngier wrote:
> On Wed, 01 Apr 2026 13:32:01 +0100,
> Sebastian Ene <sebastianene@google.com> wrote:
> > 
> > Make the SMC handlers accept a 64bit value for the function-id to keep
> > it uniform with the rest of the code and prevent a u64 -> u32 -> u64
> > conversion as it currently happens when we handle PSCI.
> 
> That seems overly creative. The spec says (2.5, from ARM DEN 0028 1.6
> G):

I'm not plannig to be *overly creative*. Thanks for pointing out the ARM
spec.

> 
> "The Function Identifier is passed on W0 on every SMC and HVC
> call. Its 32-bit integer value indicates which function is being
> requested by the caller. It is always passed as the first argument to
> every SMC or HVC call in R0 or W0."
> 
> which indicates that it is *always* a 32bit value.
> 
> So if you have a 64bit value somewhere, *that* should be fixed, not
> propagated arbitrarily.

If you have a non SMCCC call that happen to have the first 32-bits of
the function-id matching either PSCI or FF-A you will end up handling
them instead of forwarding it to Trustzone because func_id is declared as:

DECLARE_REG(u64, func_id, host_ctxt, 0);

> 
> Thanks,
> 
> 	M.
>
> -- 
> Without deviation from the norm, progress is not possible.


Thanks,
Sebastian
