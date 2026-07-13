Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1020E3B5E10
	for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 08:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783931686; cv=none; b=sWJJp5uJDg7lLVlQIHUnF/Nis7hTMgRUOA6F7ydhcEJmjZ18rG37qN4ICngOX8O/Wk+NDxDZrliB7MF5cKL1hHaUX0YY2wFNs+pqQ15qY5GvPUPIaDiHjijYKaGMQ+oNEVog6jaoK2scj9zN8OVVTlMqxSEtSzcuaWWNjea8pVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783931686; c=relaxed/simple;
	bh=wJFyum8OzWxEFOauuOZPm9XZ/v8c5PZ6ZjXZToOK3Kk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nzh2/aK9eTp6FRzj/3usChrUqKw6uK3ItwG1DtYh7r63WLru89/1fv/VxHZjOXmTaq3j9GVP0mc2WmnzGxwgUZwZkDVGeCLm3kyizB0XU8KHG2zHXq8OsqCviSyJ+Gpe02hDisofUs64tjBJuXtPDLvB28MC1obrD79qz0VqXaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XCyLve8Y; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XCyLve8Y"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-475cb71a4ebso2811317f8f.0
        for <kvmarm@lists.linux.dev>; Mon, 13 Jul 2026 01:34:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783931678; x=1784536478; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IORCMjoCzaHOJmqaTllBN0mOSKfFshqyOTA44CSojUk=;
        b=XCyLve8YDfDe1q946RbWnngCS2KWqbWfonHPFmcmin5HbP2wYKZboNzVFe4EURmYgW
         jRjgnkZggr7RF6zgCzRLo17nvyQAyX7i6Huft170sWUVKLEs1tm3IvkzGZAy1sDNOzUr
         lzJfhtejsiTA2ObaTS3V/ryD+scvL09TfR/JaxR4GJWdDeYZFmqFegkRilRyUZCecNWx
         +DPvGOLPrSRNsNgssxGIO7yO4BaBJ5bSFXJ2aicdK8s0IXasMfq9lbfLXaK9rqI4fRtP
         hnEQu8mCJoiJvu8+iKLO0dTsC6UKpzgH5y5yJWpGhFc1FlnQNSE6ZzL2clUoZ0lWuuNB
         Dl0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783931678; x=1784536478;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IORCMjoCzaHOJmqaTllBN0mOSKfFshqyOTA44CSojUk=;
        b=DoRWBjeGEd4mR4UGALMj0+QkNJePYzJ9vNO9N0GN902a4NYF17QU2dlwIV+qFvSB0t
         cl0THaD/ZfkjxuC53Ugtd16+caBLO+UtG22KTvJBs1KzmPOW4X+C/6OcslZA2UM0w1RD
         LUYjDKHVUikjnDavWGCn0BUwUQTLFSXfXcK60nWg+2ZM0orAUSYcxCe+8pqQpPGybqfW
         GyVsME4lac5Mh3/1cAw9y8pagXoCogK9C5ySVdkUtBoQu4+srq4zElPpS1dSwXSdblU4
         ngTCatGDnanvcRusARdzRhMAdFZqzAUxvrhOUsMGrQIU0sqgHpupt1MoKE5Jcpi0w4KU
         ZLrA==
X-Forwarded-Encrypted: i=1; AHgh+RpMmzx3Yq4Ri8/RUlfNrg3VEfGnOOZrSikF7W5R/M3fj91ZFIJleT8DCgzRkW7pUT+mN3/f8JU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzSmcKuEl9b0GBrh71/bF21bAEXxziU9QBNFPL7LqzzEpV23nYU
	1aL9SMeSP62mPIscWqviAVANNw71XaFwFOtRIpV7pWJk6Z71hgdWeR5hzA4SS/cYcQ==
X-Gm-Gg: AfdE7cmla22VEAitNG6+qanKb7XYJgRFSFUF34pddwW0SycXThDspbxrAFDEFj5ZUq8
	Ed68uO0hVsBt4BvyMVNMOL4d5s7Ncz1Asbw1zGag3GS+nr+zVkMRaiJQSNfoprsjPtTO/PZ27xo
	2YKkW9D5kW3q5AaX+wIAqPipoPEQlQ2vEPpfT/VIqozOkzDmjf+pxszxH/QZOW2c7JRowgiAXFk
	N91jY7XqRvp1xM8XIZycjaUfp3k35+8I1qRwhbe4FYgtIf7YWy62rks666fqifOaTv5xGg/rSKr
	cBGKtjYewjXGbWIkeJRcN+vqrDXwCW5o8Bta3SyY40HO1Zrru/TniNHAVTpmdaP2FXKaFMYW26q
	LcZuBEcoSCfTtos3+xHHDCzva7Gb0q1LhCKUODXNZZJuCyiU8mxNblGxgBapKmLD76uH94Z2uqy
	8RUcC/rNs1+ZGomkThewKGwrlbE3jQPXd5L6E/U3wLlpYnHnxDXbo=
X-Received: by 2002:a05:6000:2907:b0:470:2fb1:3dbc with SMTP id ffacd0b85a97d-47f2dce7c3emr9513923f8f.35.1783931677010;
        Mon, 13 Jul 2026 01:34:37 -0700 (PDT)
Received: from google.com (137.69.77.34.bc.googleusercontent.com. [34.77.69.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa039ad21sm83093111f8f.20.2026.07.13.01.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:34:36 -0700 (PDT)
Date: Mon, 13 Jul 2026 09:34:32 +0100
From: Vincent Donnefort <vdonnefort@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-kernel@vger.kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	maz@kernel.org, oupton@kernel.org, seiden@linux.ibm.com,
	joey.gouly@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com,
	catalin.marinas@arm.com, will@kernel.org
Subject: Re: [PATCH] KVM: arm64: Avoid naming collision in tracing
Message-ID: <alSjGAqmB7HX1jYB@google.com>
References: <20260712153835.2264905-1-smostafa@google.com>
 <CA+EHjTxN1fcBVRi+yK18UgReGsX8Evu1GsijSQC61dY3XrjCtw@mail.gmail.com>
 <alPox2BDk4Il0s9t@google.com>
 <CA+EHjTzvzcV8Cxw+VHK9Fxv7Y-7m84XbzUFU+4sXZXNrM8y7dw@mail.gmail.com>
 <alSdr9wNyyPiHmbt@google.com>
 <alShO27MLsNqgBws@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alShO27MLsNqgBws@google.com>

On Mon, Jul 13, 2026 at 08:26:35AM +0000, Mostafa Saleh wrote:
> On Mon, Jul 13, 2026 at 09:11:27AM +0100, Vincent Donnefort wrote:
> > [...]
> > 
> > > >
> > > > > > I did not add Fixes tag as this is currently dormant and not breaking
> > > > > > anything.
> > > > > > ---
> > > > > >  arch/arm64/kvm/hyp/include/nvhe/clock.h | 8 ++++----
> > > > > >  arch/arm64/kvm/hyp/nvhe/clock.c         | 4 ++--
> > > > > >  arch/arm64/kvm/hyp/nvhe/trace.c         | 4 ++--
> > > > > >  3 files changed, 8 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > index 9f429f5c0664..c2ccd0e8bf22 100644
> > > > > > --- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > +++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
> > > > > > @@ -6,11 +6,11 @@
> > > > > >  #include <asm/kvm_hyp.h>
> > > > > >
> > > > > >  #ifdef CONFIG_NVHE_EL2_TRACING
> > > > > > -void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > -u64 trace_clock(void);
> > > > > > +void hyp_trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
> > > > > > +u64 hyp_trace_clock(void);
> > > > >
> > > > > hyp_trace_clock overlaps the host side: arch/arm64/kvm/hyp_trace.c
> > > > > already has a struct hyp_trace_clock and static helpers
> > > > > hyp_trace_clock_enable() / hyp_trace_clock_show() for the debugfs view
> > > > > of the same clock. No actual collision, so this is only a readability
> > > > > point, but a reader grepping hyp_trace_clock now gets two unrelated
> > > > > things. Maybe you'd want to consider a different name, but naming is
> > > > > hard :)
> > 
> > If we were to rename: the clock is a "hyp_clock" so probably trace_hyp_clock()
> > is the right thing here.
> > 
> > while the "hyp_trace_" is the prefix for hyp_trace.c file content.
> > 
> > Although I would like to see why we pull trace_clock() from the kernel into EL2.
> > That bit sounds wrong and if we have a way around perhaps that's better?
> 
> Most include path look like this:
> In file included from ./include/linux/ftrace.h:11,
>                  from ./include/linux/kprobes.h:28,
>                  from ./include/linux/kgdb.h:17,
>                  from ./arch/arm64/include/asm/cacheflush.h:11,
>                  from ./include/linux/cacheflush.h:5,
>                  from ./include/linux/highmem.h:8,
>                  from ./include/linux/bvec.h:10,
>                  from ./include/linux/blk_types.h:10,
>                  from ./include/linux/writeback.h:13,
>                  from ./include/linux/memcontrol.h:23,
>                  from ./include/linux/resume_user_mode.h:8,
>                  from ./include/linux/entry-virt.h:6,
>                  from ./include/linux/kvm_host.h:5,
> 
> Although, some files have ./arch/arm64/include/asm/cacheflush.h
> directly.

Ha sad, no way around that... 

So about trace_hyp_clock() / trace_hyp_clock_update() ?

> 
> Thanks,
> Mostafa
> 
> > 
> > > >
> > > > Yes, that shouldn't be a problem,  I just added hyp_ prefix, but I
> > > > am ok with any suggestions!
> > > 
> > > Didn't I say naming is hard? :) How about, el2_? Not really happy with
> > > that either tbh... but can't think of a better one...
> > > 
> > > /fuad
> > > 
> > > >
> > > > Thanks,
> > > > Mostafa
> > > >
> > > > >
> > > > > Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
> > > > > Tested-by: Fuad Tabba < fuad.tabba@linux.dev>
> > > > >
> > > > > Test: builds fine with the different config enables.
> > > > >
> > > > > Cheers,
> > > > > /fuad
