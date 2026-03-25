Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6C6356A37
	for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 10:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774432885; cv=none; b=bIg6oZ8uQx45Y61M7qf+m4cJlEGXif8D3zBmQrTJiUQBGTCiZCwnvN10W2LOA8I8C6o5lpVAlNXAadjo14E/2YYR18HZaa+3NempgucuBYnjNtPmIc1Nc6XGhgy6PaN/tJRa/qyBQbP7TKhTvAvbpk8oVGzJbhUrNqPQJwnUTFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774432885; c=relaxed/simple;
	bh=zOWMXr61Cd5SZ+pQnysmLC4XfB2AfL19f1vOZp8DcQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5zluyRPd6puE9E8+s9oKNwsMkg5FkcgOfvW94JgNaHfQmTo+IkTEL3h6tum0u2JnpG5XgrdMcSCVt72TvFBzHJLslpYo3IGNUUIUmV0jY0vtLtNZC74Dp4eH70pIZdLMYasRnkYwad4LP2KsAeXfxSg1yisfICEyZLKPGPLeko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOnuZ8Zh; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOnuZ8Zh"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-486fb990b9eso67365e9.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Mar 2026 03:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774432883; x=1775037683; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VowsU1O7wvsqczMyYwJOpf4xbvaSsqz6CRDVGEe5gCQ=;
        b=eOnuZ8Zhq2cR9B07ZVFgOAan6gs/dS4lTH+AWXrGlBuYxjrn7zpqyCVQOVhEt5lec4
         /dqXLIrvMYLL3p3QPuFxiLRwzsltL4jFdh/ltWQY++zNw6C9plAQC+SfnGLr4OTs2tJq
         1a5tOxbdaFc4L5ye9h7rsaNaUrcnAJpz1RJNfaEifivJyuQtPOmeVR18nqj1BptTS/oB
         xes5ZjFhRbAxAtqKOHkyGIC1KHdArSESIAzCXcPOpnv26x8Q0WOfCg8VLIQi7cGLc0Sw
         /4hP8AxbyKTQMk5/WlHetIzKw5ZAYWL/yHKBTw3gL4P9D6RSyyWDXtVyTSDyCRBzAFGD
         E9Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774432883; x=1775037683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VowsU1O7wvsqczMyYwJOpf4xbvaSsqz6CRDVGEe5gCQ=;
        b=OeT/N7ee+JhLorDwAsuAW3FR3BmLcAPBolF5mLBWnCtCydxLRnChgMjgf0L5f/+YcD
         DGkxhRFqylb+OVkDBiPCJW3fjM+VKkhZ+j1I/v/Zp1T8/uaHelUj4zUdmOvaOkH38PsA
         8YnfGDP+VhgMtK6hANm93tLsucO69ImhsTkN2wq9JzFALjj1PFe4mYT4Pg+m/eObztxx
         ukaByeq0q2dswxz0LyUP4nPW1pNti3NY4b2cLGr6Z4J4SB3XuUjk4rgaxLq94Vtb0R1l
         /Ow7mrNXbAOMI0aO3Rlv88E1FdBR7CL9TgazhmXVHcRgTs+SCO38xKouRnRCuSEq82oQ
         tybg==
X-Gm-Message-State: AOJu0YxEeooZv2ZyMJnDeRFz0AcopFBbIhn8Y/GQuTIWlrl/cOFEt+z/
	LXv91t84IpUgmXyozNsSBmA0F0hAbU7KlRrrN2iXLDAfVMLB204KzrtToms5xxAieQ==
X-Gm-Gg: ATEYQzxfQsvh3Fcnmz3xL7YYEwPmEWYb47EwcohHew7WPAxqrK5CAd8wKldsZq8Uilz
	C7nhuPv6FIbPizNPzshH72GHdsb3KEGt8yWrFib92L2xbF9lFxzAzebG1j1xE9a4BvJmj0hfn33
	oLlvS0LRNmmk1yYmAz66MYdCciqS8L/jmDmcypbh4VbnO05c4XHt+d8umIJAc9SPj/tB1nGlw5l
	ZbRWClBtqUbRI2BG3qVOkj4uTinSwA2/dyapQiTyGI1QNmfcuFkohaTn4LNqJv834ZPuvYYV/PO
	8g2Gjfg/RMgcGGmCXMsgeKFYzJK8F/Y323klsLnkA9OhYnthXorYYTUT9YTgN1NlEvT28mtyCyL
	HcDRdxYUHPORt75DmTkvrX3OB4KF59KZLmUPcBUg+OGaPWtkHU2+r8W+ERECtdHmy00sqCpiGzu
	BQZYFd/16ZJZhYyvKX6ELuEZLeT4m57AK5Ld6UDGGB3tkY37RxpskIA0pJDDBjso/fg4A=
X-Received: by 2002:a05:600c:41c3:b0:480:4a7b:228 with SMTP id 5b1f17b1804b1-4871781da4cmr373535e9.1.1774432882386;
        Wed, 25 Mar 2026 03:01:22 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48711702191sm115863335e9.5.2026.03.25.03.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 03:01:21 -0700 (PDT)
Date: Wed, 25 Mar 2026 10:01:15 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Fuad Tabba <tabba@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	vdonnefort@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acOya6ZtAAbyOUfj@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
 <CA+EHjTycaE363WXD1f9ztYv9cTe9xeo-3FQ2Ep0aVO4592XGtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+EHjTycaE363WXD1f9ztYv9cTe9xeo-3FQ2Ep0aVO4592XGtQ@mail.gmail.com>

On Tue, Mar 24, 2026 at 03:13:51PM +0000, Fuad Tabba wrote:

Hi Fuad,

> Hi Seb,
> 
> On Tue, 24 Mar 2026 at 13:57, Sebastian Ene <sebastianene@google.com> wrote:
> >
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
> >         u64 esr = read_sysreg_el2(SYS_ESR);
> > +       u16 imm16;
> >
> >         switch (ESR_ELx_EC(esr)) {
> >         case ESR_ELx_EC_HVC64:
> >                 handle_host_hcall(host_ctxt);
> >                 break;
> >         case ESR_ELx_EC_SMC64:
> > -               handle_host_smc(host_ctxt);
> > +               imm16 = esr & U16_MAX;
> > +               if (!imm16)
> 
> Do we need to introduce a new variable for this? This isn't easier to read than:
> +               if (!(esr & U16_MAX))
> 
> Also, we have a mask for this: ESR_ELx_xVC_IMM_MASK , please use that instead


I will drop that variable and use the ESR_ELx_xVC_IMM_MASK as you pointed out.

> 
> Cheers,
> /fuad
> 
> 
> 
> > +                       handle_host_smc(host_ctxt);
> > +               else
> > +                       inject_undef64();
> >                 break;
> >         case ESR_ELx_EC_IABT_LOW:
> >         case ESR_ELx_EC_DABT_LOW:
> > --
> > 2.53.0.983.g0bb29b3bc5-goog
> >

Thanks,
Sebastian
