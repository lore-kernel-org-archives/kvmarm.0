Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5AB32B118
	for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781619851; cv=none; b=gEJT+f34necplttb4Z5WqTSG/vauq7GKdffNhou1Ito54hOKo1cX5lNomOC2LJmV1LARmG6qKO42AsW1FePvjc9UipR1JfOZsMqHRXBrFBFV3l4MVZICXfVwwKceuGbCEgzz5f56Px63CWabi1R6kQoK7q10eclNPWY9hj27S/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781619851; c=relaxed/simple;
	bh=dP/dL49CLEk7mlnb97NtOWJfS1vkC06UrxTdvbR+S+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b/skNu0SPj4Yo3HHDGJwjtASZHLf4OpH5+bQmsMDC3h06nz+xRucUmNg60e9Zi9zAUUCo2BRq+KTWhPl9OswzbYmmEcpGZBN9fzO4QjI1Z0Mk5bUenVMiKGxcxRImub7z8t45Zh1KSeFGU7RlMluq3vu2LymsQ4Jha6DdifIPxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=VxrfJ/zV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="VxrfJ/zV"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b23c828aso46615e9.1
        for <kvmarm@lists.linux.dev>; Tue, 16 Jun 2026 07:24:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781619848; x=1782224648; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOKKIBOjWpb4LV8H7itJJDiddCX5oAvi130926on9HY=;
        b=VxrfJ/zVRjHAhW5ng0h1KFn6Wqsodfarw0euttF0ovl1aUdYEMQ84RTmZ6ceoPjwqC
         /6vp61jmCKvIaTe4vyYPQMvQiq2uoNKxBMhw8IFvIEXHjX4AGjfM7/NPEhiZ+v4f0N8x
         gdx29KRa3WzgufYcXpARUL8/eAlC8KhJPbTKINzaOqcK+LRCorr+/KmAagzVOfIWCLmg
         GD8rxdh3oCORkopKQtOBYxgmPS680hG9LDDDh6CECyiK89mKc16vaT/R6EcoujcTFmYL
         mhUdLUI3nMLyqebyQNMvwuu3k/mLp2BLQADxNLL7uqUKeyis+ZLMq6vi3uNYout3Ta/N
         74dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781619848; x=1782224648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mOKKIBOjWpb4LV8H7itJJDiddCX5oAvi130926on9HY=;
        b=kc2sDCOZxL/9aw5WLiraqqUjhY+NAiAqvNlGnIaUaelbxP+gsPmohFoVfSIyw+k0nk
         231MiZBTC6e4bZBUUStzHK+WNRuPXJ+AjA758M/E0qXPZHZdEQJiyr7KijtGHh9g0R6K
         W5uWsEpQbzMQQ/DCNfgIa28Zz5Mo7z/8RRlcPfjZy/OP3yTxJi+suio7JyhJpAiHO/3C
         yjkVXC/7wLIrsPba5CuVrZZDXN0T7C9LLgeKiOUJcmiWgvYwBjLTjpW7o/CJjzxu5h9J
         pFYQethWiEYoUvGqjhbXfpqO88S/bqSrHVtBPwPskm999/QLtbvZacz1whfdY4tHdac0
         fEOw==
X-Forwarded-Encrypted: i=1; AFNElJ+SsY9oEBEw+JT2Sc5LJrs6bhd/5Wwmtn8NqNFyJhH1gBGfsxzH1ErfjmT4sjTo1etepL+tAiE=@lists.linux.dev
X-Gm-Message-State: AOJu0YybbOxgmrvZTU4xvf9KnoE/RXZxxjk1L9eTVR8B1dUd/wjiuDX2
	zVaQta8tKlXwuAzz/Mv8pmwMIAwgMgeE2RqeUv8MMRx/zJIrDaeDUyDJcvXAD9z6Nw==
X-Gm-Gg: Acq92OF6tb4faPj3PaTHr97URkG/mnvwjULTfMdj657/2CMucyvSK+MpmU4K04uJGYp
	E/CoGyaROQbBrDxqIRUMzB1fR93iF4tt9e9dpVwGVXm2ojGQCL3/FP5Zg1PBD1oUOl/0zhIHYAd
	NsRR4hzjIyexPZn1C4K5qZTrBv23TEnL4cCt8eVpa/AQBXZEE6xQuUOmaycPwKobLkUz0XluvmI
	ksPrsp6CV0f3ZH65CfupcVzw6mQ16yMrPX7F2jjqRcLeT6tU4hhTx1xlE3DExlXwHG98DiSBxo6
	CGEt/7jHbFRjhxL4+mssvr3mqBAWu2c+kF8tJO2b8T8pqrhfw67Mm1R0aUzhvPm7h0hQMvVFet7
	65CmEYogWSBz3Twi++qdI8XJ2/4aollB7JseIu7bz2k6oJTtbj/WhiQZBilLQAXgaveY0+byaku
	vYJgx4QBTKulXmMhhizBW/ETuRs6C2fDLkOKB7c20tWJaEWKy6uNhyySZb2gbmRmqiFKbvUA==
X-Received: by 2002:a05:600c:c3db:20b0:490:c2b7:5551 with SMTP id 5b1f17b1804b1-49230894f68mr920755e9.13.1781619847684;
        Tue, 16 Jun 2026 07:24:07 -0700 (PDT)
Received: from google.com (143.11.148.146.bc.googleusercontent.com. [146.148.11.143])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26392esm44203678f8f.3.2026.06.16.07.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2026 07:24:07 -0700 (PDT)
Date: Tue, 16 Jun 2026 14:24:03 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: catalin.marinas@arm.com, maz@kernel.org, oupton@kernel.org,
	will@kernel.org, joey.gouly@arm.com, korneld@google.com,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	mrigendra.chaubey@gmail.com, perlarsen@google.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com
Subject: Re: [PATCH v3 6/7] KVM: arm64: Support FFA_NOTIFICATION_GET in host
 handler
Message-ID: <ajFcg37mjtT4jt5M@google.com>
References: <20260616105417.2578670-1-sebastianene@google.com>
 <20260616105417.2578670-9-sebastianene@google.com>
 <ajFPIhMGsjqAbtN7@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajFPIhMGsjqAbtN7@google.com>

On Tue, Jun 16, 2026 at 02:26:58PM +0100, Vincent Donnefort wrote:
> On Tue, Jun 16, 2026 at 10:54:15AM +0000, Sebastian Ene wrote:
> > Allow FF-A notification GET messages to be proxied from the pKVM
> > hypervisor to Trustzone and enforce MBZ/SBZ fields.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 24 +++++++++++++++++++++++-
> >  1 file changed, 23 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index fcfaa441770d..549250ff8f82 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -715,7 +715,6 @@ static bool ffa_call_supported(u64 func_id)
> >  	case FFA_MEM_DONATE:
> >  	case FFA_MEM_RETRIEVE_REQ:
> >         /* Optional notification interfaces added in FF-A 1.1 */
> > -	case FFA_NOTIFICATION_GET:
> >  	case FFA_NOTIFICATION_INFO_GET:
> >  	/* Optional interfaces added in FF-A 1.2 */
> >  	case FFA_MSG_SEND_DIRECT_REQ2:		/* Optional per 7.5.1 */
> > @@ -1001,6 +1000,26 @@ static void do_ffa_notif_set(struct arm_smccc_1_2_regs *res,
> >  	arm_smccc_1_2_smc(args, res);
> >  }
> >  
> > +static void do_ffa_notif_get(struct arm_smccc_1_2_regs *res,
> > +			     struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, flags, ctxt, 2);
> > +	struct arm_smccc_1_2_regs *args;
> > +
> > +	if (ffa_check_unused_args_sbz(ctxt, 3)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> 
> Shall we check that the endpoint ID is HOST_FFA_ID here?
> 

Yes we can add this check

> > +
> > +	if (flags & GENMASK(31, 4)) {
> > +		ffa_to_smccc_res(res, FFA_RET_INVALID_PARAMETERS);
> > +		return;
> > +	}
> > +
> > +	args = (void *)&ctxt->regs.regs[0];
> > +	arm_smccc_1_2_smc(args, res);
> > +}
> > +
> >  bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  {
> >  	struct arm_smccc_1_2_regs res;
> > @@ -1072,6 +1091,9 @@ bool kvm_host_ffa_handler(struct kvm_cpu_context *host_ctxt, u32 func_id)
> >  	case FFA_NOTIFICATION_SET:
> >  		do_ffa_notif_set(&res, host_ctxt);
> >  		goto out_handled;
> > +	case FFA_NOTIFICATION_GET:
> > +		do_ffa_notif_get(&res, host_ctxt);
> > +		goto out_handled;
> >  	}
> >  
> >  	if (ffa_call_supported(func_id))
> > -- 
> > 2.54.0.1136.gdb2ca164c4-goog
> > 
