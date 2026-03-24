Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 143293DF017
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 14:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774361893; cv=none; b=Jg53n+ww/bSWf1DSBvIZ96wAaOevPUy5Pmus7k4e36+nao+ZHkP1abHQrIULnY+rtu7cD9fdPgjeeNZ/OG5ooijsKw0o1ZWB95UGCTjy6WyXz8mB5psrJ+UohyfL/p9W98mcOXOrwZ/ElbipFp34ZEZc0VpETX/22IpsYJHMdJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774361893; c=relaxed/simple;
	bh=wNg7nMM9lHxXeMq3N2T05s5+CgbX4+5G19QUI8C6PFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ne0k+A4N2WNfXqCTUwSFxwa5sEqxOt6ygNHaqzsTN3NmrYOiXZr+jbqmQiv/nULX/HHDhrL1GdWx/UEuJnY8SiEHNdJoenncF79rF3ta0Zpf65HJ4t7B5shPwPELZRIL+YarrScHU/2ktgt/QMscvgjB1Ff3sqgyeFVdpLTV/8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hi236lK9; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hi236lK9"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-486fb14227cso14057915e9.3
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 07:18:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774361889; x=1774966689; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YLMmL9VmQywy+Up0QoM5xuLhWibdytnU56bbqoy1KIg=;
        b=hi236lK9WYgto5cnJ/irCJHc9f5rDTgZ+f4loGXGDA0PaT07K/6sC8jnsAjmthSYVr
         Oc+J+iZFJRAm8CIXq2RAlwKr9hvbyVoAn9gyq6qVZENjRe7HyQotQCoEz4ZI6//23qYl
         Cz2sKd83pV7C+BRCV6inz4YDzqep4S1tHNI300i4MUCDN4chBCW9bRQMdC4cpsb0Inf1
         dwPr3xCodi+10jV20RnNgCQSIrdWS59xLLsMSZkCz0d027EAeXm0nx+VWC418Phn1th2
         0fk19IPxu323U78ILbTxjxl2noc5VHdPfRUgYD8o71ylTJKkV6oAPvkLEAJPQHJwXT2I
         OR7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774361889; x=1774966689;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YLMmL9VmQywy+Up0QoM5xuLhWibdytnU56bbqoy1KIg=;
        b=coKRDgXkFhzDhwNfx0QWUf7/meM5lXUS8l1goP3rk0p0NvDq4r1Qm2qYE+TV0jq6Fb
         mH3ZFeBYlhNrpD87qzQgtRcuxjwhYW9/SKOVbVCa1Mm0auLJsas8kLqFl/ejm0CdmNsA
         Ipm0eH11I+FImVpced4sYgOFh27pof9G6rdPkNx0etqP18TNVILrfbuFQl8/sH2rsfIr
         8qsFL/HtXfCj4d2ykGTYhUyYFkqHKMCQbVBMpx+n6Fy41h2JWh/R60MN5sL5NY7jKHj+
         gGT/InCOa14jNNan+4rdkakLZb3Q8AWc/6kKo0R6yhqdv1alZsN/bGRTeZ0n/McChqBm
         7HMQ==
X-Gm-Message-State: AOJu0Yz4+QaM/K3G1++9lnHuFpdo8Y1FtM3YqSZMhWVriSMR0FAwWynZ
	9BB4GOdjzuqP92z8RG9Jj86iHR0FCnczWyD+PkpGaI8uGFF6Q5pLf5BPkhfNQcysEQ==
X-Gm-Gg: ATEYQzzyCj31gnmAoGFI1kwT7A2WJWpGZe+kkff4hEX1aZ6fDZyoYsLmT7Z9vWSqj1g
	UQ6zI5XemqBePISwEJMtoNbe597g9uDtqBizTC6br3qKwQ9BQ4KrZQWO4CSS4lEABxuLij4565l
	5IrrWWigSv/uNdkFGGci+zSRtzrEDJ7ivXTQRR6QmEK0dARc1wRP3/IDwx16JSYdU9asLgqoSrp
	uBJI09K1KCwncmcaB8WFis5XvVNdLtg677GJ1+2dffuSUbCM2W1EnhQ0qRJAi891D2awr79IqMl
	+ksmIsBTSQfEfLYixzPdHJgkNy3FqYHQtJmCs63VlCfbAVR5Me0AC14M5ouIdBftVpI/jIW0fsU
	J9MbkbeLJa6dcK6Zvt55pdr97d96vPzzrZEx47lyHK7bN20o0BsMQ7f6bf0BjnOGXjSSLEZg2s1
	Z21+LrnMVaTmoxVQj8AzqY4dXwNt0+swvteyggEiJuJlaqZpBITM7SXXob7tWWq6aEjw3ifuCsp
	gfgWQ==
X-Received: by 2002:a05:600c:c167:b0:486:fab9:a578 with SMTP id 5b1f17b1804b1-486fedc3843mr249633765e9.11.1774361888913;
        Tue, 24 Mar 2026 07:18:08 -0700 (PDT)
Received: from google.com (198.115.140.34.bc.googleusercontent.com. [34.140.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-487117732a1sm48548215e9.15.2026.03.24.07.18.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 07:18:08 -0700 (PDT)
Date: Tue, 24 Mar 2026 14:18:04 +0000
From: Vincent Donnefort <vdonnefort@google.com>
To: Sebastian Ene <sebastianene@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKdHK1FbHM_-zdl@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
 <acKacAd6aV32624m@google.com>
 <acKbLtb288sABYA4@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKbLtb288sABYA4@google.com>

On Tue, Mar 24, 2026 at 02:09:50PM +0000, Vincent Donnefort wrote:
> On Tue, Mar 24, 2026 at 02:06:40PM +0000, Vincent Donnefort wrote:
> > On Tue, Mar 24, 2026 at 01:57:28PM +0000, Sebastian Ene wrote:
> > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > identifier and parameters should be passed in registers, leaving the
> > > 16-bit immediate field of the SMC instruction un-handled.
> > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > to non-compliant software relying on implementation-defined behavior.
> > > Enforce the host kernel running under pKVM to use an immediate value
> > > of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> > > instruction exception back to the caller.
> > > 
> > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > ---
> > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
> > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > index e7790097db93..ff6a90a4a4c7 100644
> > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > @@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
> > >  void handle_trap(struct kvm_cpu_context *host_ctxt)
> > >  {
> > >  	u64 esr = read_sysreg_el2(SYS_ESR);
> > > +	u16 imm16;
> > >  
> > >  	switch (ESR_ELx_EC(esr)) {
> > >  	case ESR_ELx_EC_HVC64:
> > >  		handle_host_hcall(host_ctxt);
> > >  		break;
> > >  	case ESR_ELx_EC_SMC64:
> > > -		handle_host_smc(host_ctxt);
> > > +		imm16 = esr & U16_MAX;
> > > +		if (!imm16)
> > 
> > if (ESR_ELx_xVC_IMM_MASK(esr)) ?
> > 
> > Also, I can't find void inject_undef64(void); I think you need a vcpu for that?
> 
> Ah my bad, handle_host_mte() introduced it!
> 
> > 
> > > +			handle_host_smc(host_ctxt);
> > > +		else
> > > +			inject_undef64();

Could it be better to return SMCCC_RET_NOT_SUPPORTED?

> > >  		break;
> > >  	case ESR_ELx_EC_IABT_LOW:
> > >  	case ESR_ELx_EC_DABT_LOW:
> > > -- 
> > > 2.53.0.983.g0bb29b3bc5-goog
> > > 
