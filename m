Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB1EC433F5
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 20:12:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EDFC49F55;
	Thu,  7 Apr 2022 16:12:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RlU9ut5qF+eF; Thu,  7 Apr 2022 16:12:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9620F49E46;
	Thu,  7 Apr 2022 16:12:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A2C249E2B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 16:12:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tgrbvcEwCGZn for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 16:12:48 -0400 (EDT)
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com
 [209.85.166.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3731940B80
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 16:12:48 -0400 (EDT)
Received: by mail-io1-f52.google.com with SMTP id x4so8199670iop.7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 07 Apr 2022 13:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=sJRTozuXZn5+Q6veTiT+vzqfmgVSoHWXITOn1w2myow=;
 b=RxWOQY6KdgZaMEREMmfvE+CHxxieSSZNnxM2rFqPA0wSomNEou/Wa41qEFdJrCgNBv
 mZMq+So5tvvc1z8AtFY0XOyYfDfkFyk/ATSy9gVS1xHEs08u2icaao6NvoGdifTFGX2K
 4aRjMyFoIyU+SpQHQnHNigfrqzsuy/pkifoWHm5T22FWKP6G1zUU0qOztPNrj9xf4eWE
 MNLwoFjPwjyGXziejWrnvWsS/9RYLAEVsciBrKFO3dtGoj65Li7YCkGt1/583UJVvCNW
 Ypnx2L+220K4kKmx8apWVq6mw3fupO782neBDOLI74pZAr16sCL5vY2HcDUodmzC9QK5
 E6/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:from:to:cc:subject:message-id:references
 :mime-version:content-disposition:in-reply-to;
 bh=sJRTozuXZn5+Q6veTiT+vzqfmgVSoHWXITOn1w2myow=;
 b=QDbeJxhCzHPBBWDvuSCNrqb9OVidDt+gLd451i1MP14L3NRuNmdzWDYQp2uVtpjYAa
 DcsqSAr24EAtotp51VX5YsyHZJqIdiMa09Cs5Qf8VL6lyD+p23UlGlbRDN3D5MMk+t0x
 Pdd+rsdxrMxXMX96yIn5vpg+0gQOqFd7vXQeHfE3FLERnkQVYwnocrem0uezSJXztkmo
 hs68WpDzFDIrv+pGPAD+x7c/R5uSBRZ58y4D43612JO1n0CMndGAtsFoEeI2jKq2rvIF
 1TTaIup/dtax3OWGcFizimWdY2oYC8KepyOEbK0UE/Ubz6CgUmlDq8sti17zm0znoS7F
 wc7A==
X-Gm-Message-State: AOAM530Dc1bQPJEr4c0no85+BhHe3FsttMTo580izgxGRBZxR/UdpQgs
 8IdBNLlr3CK4ORDSTapr/ov4dg==
X-Google-Smtp-Source: ABdhPJyqXm9YX9vTJiNnxSBcA8ph2PFU3mlGYEK10zOmON/8Ld6MPO1USArTjmiQeR6sNjczH9IqqA==
X-Received: by 2002:a05:6638:358a:b0:323:cbda:73c0 with SMTP id
 v10-20020a056638358a00b00323cbda73c0mr8182773jal.136.1649362367188; 
 Thu, 07 Apr 2022 13:12:47 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com.
 [34.68.225.194]) by smtp.gmail.com with ESMTPSA id
 y17-20020a92d0d1000000b002ca8027016bsm939371ila.45.2022.04.07.13.12.46
 (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
 Thu, 07 Apr 2022 13:12:46 -0700 (PDT)
Date: Thu, 7 Apr 2022 20:12:43 +0000
From: Oliver Upton <oupton@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Wire up CP15 feature registers to
 their AArch64 equivalents
Message-ID: <Yk9Fu7+CSeiqGO78@google.com>
References: <20220401010832.3425787-1-oupton@google.com>
 <20220401010832.3425787-2-oupton@google.com>
 <87lewib68f.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87lewib68f.wl-maz@kernel.org>
Cc: kvm@vger.kernel.org, Peter Shier <pshier@google.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Marc,

On Wed, Apr 06, 2022 at 04:07:28PM +0100, Marc Zyngier wrote:
> > +	/*
> > +	 * All registers where CRm > 3 are known to be UNKNOWN/RAZ from AArch32.
> > +	 * Avoid conflicting with future expansion of AArch64 feature registers
> > +	 * and simply treat them as RAZ here.
> > +	 */
> > +	if (params->CRm > 3)
> > +		params->regval = 0;
> > +	else
> > +		ret = emulate_sys_reg(vcpu, params);
> > +
> > +	vcpu_set_reg(vcpu, Rt, params->regval);
> 
> It feels odd to update Rt without checking whether the read has
> succeeded. In your case, this is harmless, but would break with the
> approach I'm outlining below.
> 

A total kludge to avoid yet another level of indentation :) I'll go
about this the right way next spin.

> > +	return ret;
> > +}
> > +
> > +/**
> > + * kvm_is_cp15_id_reg() - Returns true if the specified CP15 register is an
> > + *			  AArch32 ID register.
> > + * @params: the system register access parameters
> > + *
> > + * Note that CP15 ID registers where CRm=0 are excluded from this check. The
> > + * only register trapped in the CRm=0 range is CTR, which is already handled in
> > + * the cp15 register table.
> 
> There is also the fact that CTR_EL0 has Op1=3 while CTR has Op1=0,
> which prevents it from fitting in your scheme.
> 
> > + */
> > +static inline bool kvm_is_cp15_id_reg(struct sys_reg_params *params)
> > +{
> > +	return params->CRn == 0 && params->Op1 == 0 && params->CRm != 0;
> > +}
> > +
> >  /**
> >   * kvm_handle_cp_32 -- handles a mrc/mcr trap on a guest CP14/CP15 access
> >   * @vcpu: The VCPU pointer
> > @@ -2360,6 +2421,13 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
> >  	params.Op1 = (esr >> 14) & 0x7;
> >  	params.Op2 = (esr >> 17) & 0x7;
> >  
> > +	/*
> > +	 * Certain AArch32 ID registers are handled by rerouting to the AArch64
> > +	 * system register table.
> > +	 */
> > +	if (ESR_ELx_EC(esr) == ESR_ELx_EC_CP15_32 && kvm_is_cp15_id_reg(&params))
> > +		return kvm_emulate_cp15_id_reg(vcpu, &params);
> 
> I think this is a bit ugly. We reach this point from a function that
> was cp15-specific, and now we are reconstructing the context. I'd
> rather this is moved to kvm_handle_cp15_32(), and treated there
> (untested):
>

Completely agree, hoisting this would be much more elegant.

> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 7b45c040cc27..a071d89ace92 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -2350,28 +2350,21 @@ static int kvm_handle_cp_64(struct kvm_vcpu *vcpu,
>   * @run:  The kvm_run struct
>   */
>  static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
> +			    struct sys_reg_params *params,
>  			    const struct sys_reg_desc *global,
>  			    size_t nr_global)
>  {
> -	struct sys_reg_params params;
> -	u32 esr = kvm_vcpu_get_esr(vcpu);
>  	int Rt  = kvm_vcpu_sys_get_rt(vcpu);
>  
> -	params.CRm = (esr >> 1) & 0xf;
> -	params.regval = vcpu_get_reg(vcpu, Rt);
> -	params.is_write = ((esr & 1) == 0);
> -	params.CRn = (esr >> 10) & 0xf;
> -	params.Op0 = 0;
> -	params.Op1 = (esr >> 14) & 0x7;
> -	params.Op2 = (esr >> 17) & 0x7;
> +	params->regval = vcpu_get_reg(vcpu, Rt);
>  
> -	if (!emulate_cp(vcpu, &params, global, nr_global)) {
> -		if (!params.is_write)
> -			vcpu_set_reg(vcpu, Rt, params.regval);
> +	if (!emulate_cp(vcpu, params, global, nr_global)) {
> +		if (!params->is_write)
> +			vcpu_set_reg(vcpu, Rt, params->regval);
>  		return 1;
>  	}
>  
> -	unhandled_cp_access(vcpu, &params);
> +	unhandled_cp_access(vcpu, params);
>  	return 1;
>  }
>  
> @@ -2382,7 +2375,14 @@ int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
>  
>  int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
> +	struct sys_reg_params params;
> +
> +	params = esr_cp1x_32_to_params(kvm_vcpu_get_esr(vcpu));
> +
> +	if (params.Op1 == 0 && params.CRn == 0 && params.CRm)
> +		return kvm_emulate_cp15_id_reg(vcpu, &params);
> +
> +	return kvm_handle_cp_32(vcpu, &params, cp15_regs, ARRAY_SIZE(cp15_regs));
>  }
>  
>  int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
> @@ -2392,7 +2392,11 @@ int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
>  
>  int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
>  {
> -	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
> +	struct sys_reg_params params;
> +
> +	params = esr_cp1x_32_to_params(kvm_vcpu_get_esr(vcpu));
> +
> +	return kvm_handle_cp_32(vcpu, &params, cp14_regs, ARRAY_SIZE(cp14_regs));
>  }
>  
>  static bool is_imp_def_sys_reg(struct sys_reg_params *params)
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index cc0cc95a0280..fd4b2bb8c782 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -35,6 +35,13 @@ struct sys_reg_params {
>  				  .Op2 = ((esr) >> 17) & 0x7,                  \
>  				  .is_write = !((esr) & 1) })
>  
> +#define esr_cp1x_32_to_params(esr)					       \
> +	((struct sys_reg_params){ .Op1 = ((esr) >> 14) & 0x7,                  \
> +				  .CRn = ((esr) >> 10) & 0xf,                  \
> +				  .CRm = ((esr) >> 1) & 0xf,                   \
> +				  .Op2 = ((esr) >> 17) & 0x7,                  \
> +				  .is_write = !((esr) & 1) })
> +
>  struct sys_reg_desc {
>  	/* Sysreg string for debug */
>  	const char *name;
> 
> 
> What do you think?

Way better. Your suggested patch looks correct, I'll fold all of this
together and test it out. Thanks for the suggestions :)

--
Best,
Oliver
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
