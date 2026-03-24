Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A53943FE357
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 14:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774363324; cv=none; b=T5F8y8MBpiDlqc+RUXBJVa3dZLrMGjJkfYtYcOyyuvqqnl4vxPYIf/83TWrKtyBYPhhY/t0A+sGipXZB6FRYInIErTL0g5cbGPB0cWPurkGMdEBxgKwXS/gY5aHvDoDVD1AoCZxH4sYjydj7EC2dZ1qa0E1g3iGoFlJ7ZAYI2GE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774363324; c=relaxed/simple;
	bh=E4zjjo8iv0G1bhz4bnn2Tfxy9XKsaj1cvPVt39yIrQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gb7aqUihUDYDDlwhfYa0qKQgiwDqnyW/kDjQHsaXfC2OfK7H/S+XjYppuswDYXzv0Yi04cHCPWD863vlOVwjg6NN7GTapicNVEp10DCAaKDPdzZHwVLah03RCObCja8106+J/uMg3HahBfxFyRGW6Dcyexq5Tko6gPLELleB0+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XVpdXm53; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XVpdXm53"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso75995e9.0
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 07:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774363321; x=1774968121; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=R9azy4441Z9htuSU+O0vgMgPqnPm0TMDTgfr4iB1vDg=;
        b=XVpdXm53X0UFLFdki7nO/9zq/StpObceEdjxcq897g3QbwnUJBG+FkEGPiHboYfpIT
         MrIQ/sEACEyvgPle489keAudMQy/hxdbLyQIjPq2Nsm4rMqm3V5J/ghgxcVnTmpLkJlG
         rEyUsbg4ngLu9jNG68U8SE9yAEL0fcljAMAj44fIjHw7RLyc4m38XV2OLONOj8sKGCOI
         wLEEfhJxikXb+JpEVnFRWpJNtRXQ93jEbWYAm0uP7W7clWjWi15262uPUfwOVWpvIS5n
         I+ft7XH0G/IiTbnjtZeyAhabFKwR7EZFFGgTqEk8AZoFIsvOxzWH5HrRfmoe0q34g/Ml
         Cg3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774363321; x=1774968121;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R9azy4441Z9htuSU+O0vgMgPqnPm0TMDTgfr4iB1vDg=;
        b=gRJAVoAgmhq9JJWXLLB3OwxzbpFRcB8GP2YLp17gVjRPEt8VgWieYgFBWkwx27TSXr
         f1k9ey+P+9QbSxkZpPiz1PkV2MciRuUSQJvhKFuBgbpx14GHvEy/aNe98JqyYgjKzGCy
         lx7OT5d6Vdpt6lDHmO/JyzO01AOoQmMMwNG5h8EAQQU8tx8yEO6EGdpwtdTdXd86D4Tu
         tRDIXNhgUdfuD6XUXx5WESESkLwXQQ6s4suZP+jmeI7Ztv+7jD0rF2l7d5WVVHdQZDwn
         kIuKlndcyEhI1b7OYi1leEr6MYlmU+H8ni8lI4uYIa4t8T9cuXGxgFsTsnSAI1OB6zPL
         ACwA==
X-Gm-Message-State: AOJu0Yy3FVtaulQ4GTUpeIIsD/q2QZyNrwFQfgBZkWXJl/dXJLc6bBNd
	pw6nMlEgmeB8ZLKd1iQAefOgaI+SVjKtFWxSVVorAMbWdvvgoDyWJD0BSwWZMoGA2Q==
X-Gm-Gg: ATEYQzycD+SYWUpZ0KTY7Ts9nQdXVfbACHsdKgWqS5lPkFVO4+s3BctKBHBYQ8jKSTA
	ln5gJ+8JK9twqV70zo0DqKlhAMcsZQQSXAOAU7EkQ+kwJxmF4BkZnQzlxNoL8PFH4qNa+wJQImA
	pRzj8pHyddWKiuzUVNWie1f8IN2tWdKSDc9xt++RaHm2y+v0YvO0FWHlpOvysun32BnrCCvMoDE
	BWvhWn/xBGrO9lFm1VZjOuHVRGL1R1IZoKvXDv0gx5SkYuB7/JLe97sTTHvMMVot+h5p0dwIXuW
	s/eIp/KTSqwuhNp/BNKJqmo3F0J2nb4/ZaGagZxOCv9mn/7b741NxncU1JEF888q/7jbRGY2CMI
	ks8um1GBaae9htK93pZhkJSU5PK7/YirH3IGa8QKfU8DA1yPHG+KKHWdv1VPxBKkXDqeeCC6m9s
	1/Lqtt23nOmy3YIrcPZ5zF/CPvmnOior0OYAQ3ZZERzZko8SdNrAUD6taLbJQyzvs+U4b161B2q
	pzcLw==
X-Received: by 2002:a05:600c:4e0e:b0:486:fbd9:b22c with SMTP id 5b1f17b1804b1-4870f59993dmr1066435e9.16.1774363320437;
        Tue, 24 Mar 2026 07:42:00 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64711f58sm39757790f8f.29.2026.03.24.07.41.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:41:59 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:41:56 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKitObzn6jrO205@google.com>
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

Hi Vincent,

> if (ESR_ELx_xVC_IMM_MASK(esr)) ?

Yes we can use this instead.

> 
> Also, I can't find void inject_undef64(void); I think you need a vcpu for that?
> 

Right, there is one version that does that.

> > +			handle_host_smc(host_ctxt);
> > +		else
> > +			inject_undef64();
> >  		break;
> >  	case ESR_ELx_EC_IABT_LOW:
> >  	case ESR_ELx_EC_DABT_LOW:
> > -- 
> > 2.53.0.983.g0bb29b3bc5-goog
> > 

Thanks,
Sebastian
