Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9E4F3FAE07
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 14:09:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361398; cv=none; b=WHfW6x7BNzUos3v/Gu9zzdO8AHwpb9+dN13pahhMpP1m3o0c1+OkIeKmwEeLrmGy3lezGTatDVXrbydcTJpZmHJzQeWJcJbmzO6quEAEQpRMCuOQ3Ium5FkGcsZfWL8/wYuLkftUWPUo9glhydtoNhCyhRc3VaWa59v2DvaKqGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361398; c=relaxed/simple;
	bh=4+y5I6IOKnlryBOWxlKFSero7k0psB62OJhw3COE4yc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ErOzbtgE+YYN1NZTmWEt0bJIjauIAspzJjfLLSyLITptVV/ycxCZRd7ECWNKglLoT4AvlUgPMGfuEso/GPgk5CNBj8dREDwPNTc/y9DAKADz5PioIyimT32xWE8LZdBYmTqGDL976yT+wkjMqwKBrDdSutI8eFJ91u9aov3YtRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OvhBSpuX; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OvhBSpuX"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-486fe36cfabso21974175e9.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 07:09:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774361395; x=1774966195; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tZ4LSksyFg1Xo3cRrPoFB7zz76+M0JIYSoezHnjgfsE=;
        b=OvhBSpuX3oXrdok41hdmrbROJbgZt8NFQmPObVaWDefTXmsrS03EJyQFHIqqTG6cWx
         JvRJ6/Li7GomluR+JPAaldt/mscD36xMIEKHvD+bs5hex39K3tMcQQIqLa8NPvZzP+i1
         xmjw9SzMf5GRYvpoidy/9e4gg63K/Uynr1k+vVoORd38rstvtApu8CnD6LK3X0+SAXVu
         zauN1dXxFe1lO2Hy1NIMFfRacZt21nxPYD5ycA+9wwqJ/BLLOYbEC6dxfkR5I16ZNn2u
         QGGmLP+cfEA5jZxSoLVsvDdhYBHPoPWwVyRerkl5NUUOHyJyjT7MPoTwOuS0B65lX10/
         rX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774361395; x=1774966195;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tZ4LSksyFg1Xo3cRrPoFB7zz76+M0JIYSoezHnjgfsE=;
        b=K5ERMD/aQ91AYmKT981grACQOut4rxLXtCuHFgZSAcq2VAiBz8mkuluHMZuvNXvL4f
         8w3uQQffj43QNLTqs4kz3hZeMNb6jaVlvC8Hlr5gy1RGer/NVxg0ZG1TNYmY15aNiWiQ
         lELIz4WHeLBNTvEQecY6dGG/2YpaOpaf0r6IEH5+jIV41TGvsOIRXud+vX731zFNrtnR
         mzK4Dvl2tJSdMg4juAU59S2xnR23jfSIA9yqALigQ6Z2Pk2/anufBpw/uQYm8xoaqo7d
         K71goxagIAXwjVPCVrEhePHNAP5mQ6sidKJtj3L5WKMCnp1g2pYWYduegwflh12jk8Ux
         HN9w==
X-Gm-Message-State: AOJu0YyyWdB8sVSXLA8kPG6db3ayjfd3E5FpOJXJDrGWnu7OElNWOF/X
	gZamu8TTo0iTpM+g0MsDRB+eOpQ1V4ZMJ8hhmdFYRRwyuq1GIQPeNbEywJCBX/3H8Q==
X-Gm-Gg: ATEYQzzhgHWld7PZ1XFjN5U6E+LsrWCFnb+BoRowvlg4Tt0pPZtwvsa/OA7nigzD4Ml
	U5yYQzP7v5DUBkLpShgBzaaxmlEoT9mRXuG28dzfqJDpboC8SJjQ3I72HPAZ8DI8GW7I1al9uGO
	+dXFT39oUQzs0zh3xLe34uNPm49mW+dfDMb939281rVKFFnWn0PNcQdroXNkEWS6+MfRz2nnfd7
	cosr7ZqVNrrxbh3kB7f/fwmpZIpSmumQcDfIDZDraeIT5nc+Gm4O2hEspkGVZcv3Z5ikrosvq9D
	GUeQ4Zh24Kbzq468H7RQGsbYMNmSG0yX+ddi0vx5vU25azi5l2vslKCqPjIEiHn7C6DT8uDYc1s
	MrFBN6sHWoLFuYaOslDkesP9XZRK2kfQ9JprcYgcaYS5JwdJLizeqFrcdOui+nsGoYp5ldm9mbj
	gMX1HBu+/BLZ7UJiVJbVlOj1DRTxZh8dnq2lqdWR6m5mnIyu5iQTbykzczGDa90FcTL5c=
X-Received: by 2002:a05:600c:1d02:b0:487:12c:e7ea with SMTP id 5b1f17b1804b1-4870f1f40f8mr51547485e9.5.1774361394440;
        Tue, 24 Mar 2026 07:09:54 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871105c799sm24855475e9.20.2026.03.24.07.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:09:53 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:09:50 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKbLtb288sABYA4@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
 <acKacAd6aV32624m@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKacAd6aV32624m@google.com>

On Tue, Mar 24, 2026 at 02:06:40PM +0000, Vincent Donnefort wrote:
> On Tue, Mar 24, 2026 at 01:57:28PM +0000, Sebastian Ene wrote:
> > The ARM Service Calling Convention (SMCCC) specifies that the function
> > identifier and parameters should be passed in registers, leaving the
> > 16-bit immediate field of the SMC instruction un-handled.
> > Currently, our pKVM handler ignores the immediate value, which could lead
> > to non-compliant software relying on implementation-defined behavior.
> > Enforce the host kernel running under pKVM to use an immediate value
> > of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> > instruction exception back to the caller.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > index e7790097db93..ff6a90a4a4c7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > @@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
> >  void handle_trap(struct kvm_cpu_context *host_ctxt)
> >  {
> >  	u64 esr = read_sysreg_el2(SYS_ESR);
> > +	u16 imm16;
> >  
> >  	switch (ESR_ELx_EC(esr)) {
> >  	case ESR_ELx_EC_HVC64:
> >  		handle_host_hcall(host_ctxt);
> >  		break;
> >  	case ESR_ELx_EC_SMC64:
> > -		handle_host_smc(host_ctxt);
> > +		imm16 = esr & U16_MAX;
> > +		if (!imm16)
> 
> if (ESR_ELx_xVC_IMM_MASK(esr)) ?
> 
> Also, I can't find void inject_undef64(void); I think you need a vcpu for that?

Ah my bad, handle_host_mte() introduced it!

> 
> > +			handle_host_smc(host_ctxt);
> > +		else
> > +			inject_undef64();
> >  		break;
> >  	case ESR_ELx_EC_IABT_LOW:
> >  	case ESR_ELx_EC_DABT_LOW:
> > -- 
> > 2.53.0.983.g0bb29b3bc5-goog
> > 
