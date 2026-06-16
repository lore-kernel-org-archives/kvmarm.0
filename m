Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385A33845CD
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781620215; cv=none; b=V3yxFLRp3AhwouVm4M3q8O9cPXvfh5oaUuSadmVQaqvwq5uKUqpmdXjeD86BWx2GzRMI0KwdaRVlVotvKG9CY+1v2XVe0tAFbdX45Gjx07mYF84uKT6Sujtm0zYvS4mm/HfX3cVqfV5YWbuwazw/HxG5yEifzp8EIokQi+hipDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781620215; c=relaxed/simple;
	bh=Pvc8JNK+ktSQxPOt78l79kkSMj1nVhMZrB5rdUQSrPM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUa80xvRruwYz+BseKu7TfZvrnyJaEsDqFv6DQDzwbO5NCXeUsWzP0Jsf7jcOhpUNTSOxqDy6JulAsSeNq6orxFPGjJLXGmaY4mDYavKslV6RS3VhA0F5BL/0szLr8RBjMlCirM3+43l0zggC5IL065JsUUXT5baNPzw7t+gd8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Q4tz+uCm; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Q4tz+uCm"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b23c828aso47395e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 07:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781620211; x=1782225011; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sxF4JdKLz/47JU+Sn8F0zfHSo7R8CT604WZzC5dB9aI=;
        b=Q4tz+uCmnvbDb4tTFcm9i1T4+D7Qy8ar+6x24PufOlfSKT5pslO0SgBWTtMRtd+u/l
         /GEVXFocWM8gwRp6sHpZLnOw83heOVOg5iuiWOYnLixH7qd8G1gxPRCnCAWTMmsP/BfW
         eRZPRExqysc7M4ZF46kLwLyUFd5Cc/VDjNKp+4y4jn0btBDiDoEOxAlnIZbbTouA7KUv
         uSwTc/k+sv2/aDVwGOMeauadu5zDIikDzET5W6L/53IRgxs5l0/K49XFdFKrxlcOKc5x
         Geig27Qam9NX42OB84m3zyogVw77xy+VgFUK6FDMdt4G+IkZrN9D1Q4eHy1VhII0J47P
         5Xtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781620211; x=1782225011;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sxF4JdKLz/47JU+Sn8F0zfHSo7R8CT604WZzC5dB9aI=;
        b=gEKO1CdAJT0yhnyy9tiLtqAkRyxwYxrsNLKrXWCIC/WQlUHc6qljqimIKiE7cbleEb
         hUfyZDmmTYFtcJADifIelBLM16M3l28pGyq4zMHv8gvaHU179HE4v5VcCm25GfKmCKGC
         BMWEJwxCqU7T4GKoYFMI0KEd/YlyoDT2etdSlGeo9Tg1G2urUP6628M9d/eEk/UoXnOy
         BmIWHrFscml2xdhWCmQq14LeAqZ++bJU8WrqxRJuBhCbA3iZWF/HzkaB2FQ4/ID68peG
         iq2HgvTih5oE/gmoPfqE+yZPSzZ9WbWxTJgTKaPCbxdMLBmhQloXx9RZb3mpPljlWIy0
         SSow==
X-Forwarded-Encrypted: i=1; AFNElJ83EgLYwVMObPRb6u/LU/D/iFaSwi6WtxqgNEb4wHFpcPkLnX5h7WbLmgpJHkhRrVJwKbilPvw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyxHQXxufjpcr5N9TX0S6NViXFA7t3m6QaVTzfO3sTqdvY3HCqt
	1lrZWmMiyfzawaCqYdjfnV8Lm3We8wIfDl197Lv3Kj40HSe2f0lNOM2VS93SOTwdRg==
X-Gm-Gg: Acq92OGSR46TaKvcTS/lCcsRR0+10MyG5rMfx0PnYVY/gdloVeAHZWFfKX59+HLV017
	G8TDdPTqSGj0EKF4L4skTRhpXTHSvBK4gth8wHGb3lO/hclDsrUfwfs2XSKmsiaxFN5/hdxQkTx
	U28DYlrDuSWhPhUbv6OmovHCB0natvhgsr+6kAFrGqxqrpYURZ6pxpuYBh8HtTZ4J5+F5D++Phn
	5VUOvCQze3Wmzf4y0VrCEGhoAZhkCC4wN795ueU3b6/55XtA+vjpFvWInspRNt6h2RR+y+DQpOG
	z968kzADUXtbOhKwflxhq3yWCutDJkE8jOf4YzzsgYenBFZ4tpYKa2tFI8SAgoMN+lYkaSlKZQI
	EDvDI5ocBwlzykn4uuVqO5eO3jhDPixcdyHmn5WYD+H3r3Ft+ka82Q1XAPm41bWextK8TfAMiHc
	ux4p7RqGeO+gbwJub2pfbVJSyATyWRTq3m1YearSpDx8s4syCTPeT+/PdomxBHvBJ6jiDhvg==
X-Received: by 2002:a05:600c:6dce:b0:490:ae08:1150 with SMTP id 5b1f17b1804b1-4922ffad1c8mr1143425e9.4.1781620210848;
        Tue, 16 Jun 2026 07:30:10 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2d933esm44203626f8f.33.2026.06.16.07.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:30:10 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:30:06 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 3/7] KVM: arm64: Support FFA_NOTIFICATION_BIND in host
 handler
Message-ID: <ajFd7jPk9mqw2NX5@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-6-sebastianene@google.com>
 <ajFKRFj8vp_KqrNc@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFKRFj8vp_KqrNc@google.com>

On Tue, Jun 16, 2026 at 02:06:12PM +0100, Vincent Donnefort wrote:
> On Tue, Jun 16, 2026 at 10:54:12AM +0000, Sebastian Ene wrote:
> > Verify the arguments of the FF-A notification bind call and forward the
> > message to Trustzone.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 32 +++++++++++++++++++++++++++++++-
> >  1 file changed, 31 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index dc7496ec295f..3d8ed829f558 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -42,6 +42,8 @@
> >   */
> >  #define HOST_FFA_ID	0
> >  
> > +#define FFA_NOTIF_SENDER_ENDP_MASK	GENMASK(31, 16)
> > +
> >  /*
> >   * A buffer to hold the maximum descriptor size we can see from the host,
> >   * which is required when the SPMD returns a fragmented FFA_MEM_RETRIEVE_RESP
> > @@ -713,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_BIND:
> >  	case FFA_NOTIFICATION_UNBIND:
> >  	case FFA_NOTIFICATION_SET:
> >  	case FFA_NOTIFICATION_GET:
> > @@ -929,6 +930,32 @@ static void do_ffa_notif_bitmap(struct arm_smccc_1_2_regs *res,
> >  	hyp_smccc_1_2_smc(args, res);
> >  }
> >  
> > +static void do_ffa_notif_bind(struct arm_smccc_1_2_regs *res,
> > +			      struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, endp_id, ctxt, 1);
> > +	DECLARE_REG(u32, flags, ctxt, 2);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 5)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (FIELD_GET(FFA_NOTIF_SENDER_ENDP_MASK, endp_id) != HOST_FFA_ID) {
> 
> "A Receiver uses the FFA_NOTIFICATION_BIND interface to bind one or more
> notifications to the Sender"
> 
> Does that mean that if the host issues a FFA_NOTIFICATION_BIND it is the
> "Receiver" and not the "Sender"? 
> 
> (Same for unbind)
> 

This means that we will have to check the ID of the receiver and not the
sender. Thanks for pointing out, I will add this to unbind as well.

> 
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	if (flags > 1) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	args = (void *)&ctxt->regs.regs[0];
> > +	hyp_smccc_1_2_smc(args, res);
> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -991,6 +1018,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_NOTIFICATION_BITMAP_DESTROY:
> >  		do_ffa_notif_bitmap(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_BIND:
> > +		do_ffa_notif_bind(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1136.gdb2ca164c4-goog
> > 

Sebastian
