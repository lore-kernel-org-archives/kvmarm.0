Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEB1C405AC6
	for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 15:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774364744; cv=none; b=Z8sc71zjeu3S9ADnAPRE1lg7TxDCCqiLNeNQbjeskmogABqA8RJiKmOkBtqfv6rupAVt6bVa4hpnVF5BRnAqh64Q2t9eVZ8jfyKoo5sDahqwUk18bI3UZ2OFMT0FKDNKBwlLR4dcI4yyvChve4K1X0SUKGI4ehdhZt8Ty7ezQog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774364744; c=relaxed/simple;
	bh=O8P+TZRrxrEvgVcIPzX4mQiT9SPX7cc192URaBSZUAg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZIsIPxvkVIX6fVgTEvXaEMajULKJt3ZcUgbjktjBLuaLLswftg9/UpnIg1S3hIkaXHOgu4+awqFRz6qdiOyV+Ii9HQEJjKACZCBoQH3DZCVfqGGUkYL2hIjTTyj/pc9MKESlJAxgKLV7ZChzGsSp9+02V9er7+lqfSSQBMbf7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SI7HmmPM; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SI7HmmPM"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-485317b6bd0so64445e9.1
        for <kvmarm@lists.linux.dev>; Tue, 24 Mar 2026 08:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774364739; x=1774969539; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ptGMB7I5UZgWyMFfPZCZTiz7S0WJEUd1UA28PK4qTlU=;
        b=SI7HmmPMHH5u9SEvHAH3dHKmMJ55kp9KxPqiUo87aFE59sOsUsZR6OKlGbkIfAemz3
         tFugEu7wtjhKSPvcTbmAZ1srI1TF2EcphrSl5gphOHvP8Y5ynh/14vls0i1LZ3NLxo3H
         WV5j/Fjx2pFM86nSFizB1asKg+HdAmwrAu/EvbYg3ay348HLMr2h5w1BGSDx31YB+RzR
         uyo7dRtZrh/rG3wZCxaf17rSoXW/ns2wmxVZUojlTEWCpxZkP+6S05hXeyx25YOFU7rr
         A62usLYy2GeBBe9kqkahvA6bEkv4U0oh8iCxrsspSAR9urGEvgD22OPnjdHZl3iqd0He
         PaTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774364739; x=1774969539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptGMB7I5UZgWyMFfPZCZTiz7S0WJEUd1UA28PK4qTlU=;
        b=snesCQMLblLrNX/r4sIcJxsfS39F1vP0t1DZzFvIz095XTlpgPde4UxyR+dIafWfsU
         9CKYgIEXq8B2HzQSMWIc6AM0HLOSznY7IssxIsgUjosAp9SmnsVpzzyQ/tNDC9dS6O84
         YXkrehsmp6RzY3X+iSR7Lmv+YsjFILOeR8L0da1SAFNX2Ov+La2iMQInR69VDO+ahPj1
         qjQPFrPkyDhcFdOX7QjQW0EwnjqfoFp0nlhdUqq8PRhS3KP1722QSW9frEifsrtcNDJO
         qzBjWvfLJG1PUqWVSzH/TXXsUs8eug1aTTo1ZmqslpAZcdWo+PF97vpM+iyNdgNvRtPx
         zudg==
X-Gm-Message-State: AOJu0Yz3e7d85+bpkPVl69w+MeXofaIpWJ3e9tPvShCKlU1KB0cbFk7L
	8in6SR3hvBSaJNHSv9HmN+U/swm0nP9kECGmZlF/gNbkLm2rzHwK8afVHesKfLuNdg==
X-Gm-Gg: ATEYQzyxGf8e2U0RbI+GVPrTVVMVavtCv2imHAQlrbnDVrIphkANp0mopGVaVebaAYy
	BeYgz+4mLnFtsxyR9RF38fAOmL/9wNmJ561Oe8z8Oxr4if+on6FAFd5kvzK2RqsgRIyl6LGNhWW
	dpSjAv5sNnpVuMd8QUbwxfsoKb0dQoh1KiB9NjoW4i6N8xVjgI645+mvL0PFmv45tJBCqycCoev
	wi+zAXwozUXM1LmA9qM970GA9TP2rZvg1mjo7MOIxNlwuKxpLYo5I6c21hCP7crTcOFCu0VuKNL
	R21ydEVhllGsuPFHEdHJMcvWUxQDlbuhsxJabRVaEWf2OukXexKff/CUfmBUao8IXkNXmhguOju
	V3xGcbQ336uIKUJR9lYAkYnKuAA01yIzUWHOhL3I1AkXTlTEa9NHbYtuHZqIMy3clu8T0QoTnXo
	vVaLBE1N/ayQg22DnDBkgmv6r1zvsLdfNZLqFvpM8P5J53eQQuY5VxAJ2UfzWBGx1PQwA=
X-Received: by 2002:a05:600c:c16e:b0:485:5981:141b with SMTP id 5b1f17b1804b1-4870f598118mr927705e9.12.1774364738382;
        Tue, 24 Mar 2026 08:05:38 -0700 (PDT)
Received: from google.com (209.13.205.35.bc.googleusercontent.com. [35.205.13.209])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b646b0b0csm36743525f8f.15.2026.03.24.08.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 08:05:37 -0700 (PDT)
Date: Tue, 24 Mar 2026 15:05:34 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Vincent Donnefort <vdonnefort@google.com>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, android-kvm@google.com,
	catalin.marinas@arm.com, joey.gouly@arm.com, mark.rutland@arm.com,
	maz@kernel.org, oupton@kernel.org, suzuki.poulose@arm.com,
	tabba@google.com, will@kernel.org, yuzenghui@huawei.com
Subject: Re: [PATCH] KVM: arm64: Inject UNDEF when host is executing an smc
 with imm16 != 0
Message-ID: <acKoPpoicnQ7ZMBt@google.com>
References: <20260324135728.3532400-1-sebastianene@google.com>
 <acKacAd6aV32624m@google.com>
 <acKbLtb288sABYA4@google.com>
 <acKdHK1FbHM_-zdl@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acKdHK1FbHM_-zdl@google.com>

On Tue, Mar 24, 2026 at 02:18:04PM +0000, Vincent Donnefort wrote:
> On Tue, Mar 24, 2026 at 02:09:50PM +0000, Vincent Donnefort wrote:
> > On Tue, Mar 24, 2026 at 02:06:40PM +0000, Vincent Donnefort wrote:
> > > On Tue, Mar 24, 2026 at 01:57:28PM +0000, Sebastian Ene wrote:
> > > > The ARM Service Calling Convention (SMCCC) specifies that the function
> > > > identifier and parameters should be passed in registers, leaving the
> > > > 16-bit immediate field of the SMC instruction un-handled.
> > > > Currently, our pKVM handler ignores the immediate value, which could lead
> > > > to non-compliant software relying on implementation-defined behavior.
> > > > Enforce the host kernel running under pKVM to use an immediate value
> > > > of 0 by decoding the ISS from the ESR_EL2 and inject an undefined
> > > > instruction exception back to the caller.
> > > > 
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/hyp-main.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > index e7790097db93..ff6a90a4a4c7 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
> > > > @@ -756,13 +756,18 @@ static bool handle_host_mte(u64 esr)
> > > >  void handle_trap(struct kvm_cpu_context *host_ctxt)
> > > >  {
> > > >  	u64 esr = read_sysreg_el2(SYS_ESR);
> > > > +	u16 imm16;
> > > >  
> > > >  	switch (ESR_ELx_EC(esr)) {
> > > >  	case ESR_ELx_EC_HVC64:
> > > >  		handle_host_hcall(host_ctxt);
> > > >  		break;
> > > >  	case ESR_ELx_EC_SMC64:
> > > > -		handle_host_smc(host_ctxt);
> > > > +		imm16 = esr & U16_MAX;
> > > > +		if (!imm16)
> > > 
> > > if (ESR_ELx_xVC_IMM_MASK(esr)) ?
> > > 
> > > Also, I can't find void inject_undef64(void); I think you need a vcpu for that?
> > 
> > Ah my bad, handle_host_mte() introduced it!
> > 
> > > 
> > > > +			handle_host_smc(host_ctxt);
> > > > +		else
> > > > +			inject_undef64();
> 
> Could it be better to return SMCCC_RET_NOT_SUPPORTED?

Right, I will do that since it seems this is the correct approach.

> 
> > > >  		break;
> > > >  	case ESR_ELx_EC_IABT_LOW:
> > > >  	case ESR_ELx_EC_DABT_LOW:
> > > > -- 
> > > > 2.53.0.983.g0bb29b3bc5-goog
> > > > 

Thanks,
Sebastian

