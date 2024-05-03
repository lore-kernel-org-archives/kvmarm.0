Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAFD34CE5
	for <kvmarm@lists.linux.dev>; Fri,  3 May 2024 15:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714750158; cv=none; b=lsT/h32HSkhDOpGrdLI8lH6o+8kiK6cCKTqZfz1z/tQXfTz+ItlFSTnMK8cLnsJhWLhQUmqa812G6vmzF1NehPYuMzooXNcVGxpiExrP1bV0Hg4qM9fqS24rTqwQrvgZQz5ySCDL3UUHuL9QeRL4kspAXerAAr6101aUTJt1aDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714750158; c=relaxed/simple;
	bh=6VzEpteiJCwyWHZ3JRqbvvu0CTz1bayEFn9tQlKrV9c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c8R5MYiCePpDLn3m2rdgw7rDApp66naLPKJQtEcR3L/5wHkRBre63u64reSxfWF9wB6WllTZvqOTw9JoX9mVfggE+NTzC6y+EQamkJ/xjlhtlFspVSPYv9mYZ2kHyUmInZjYFOiJSrxcrkRE4cAZllH7nI2P4EytnhQWcWkEJ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eBP6TU2w; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eBP6TU2w"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-41b48daaaf4so69745e9.0
        for <kvmarm@lists.linux.dev>; Fri, 03 May 2024 08:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714750155; x=1715354955; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JdeKXLmwOpYZ0RbFT9ZtQGKC2WTKqWCZd1KazXfzCOo=;
        b=eBP6TU2w0kAM5YOqgxyAnvFGY5hEHO5mNjpJ73HlTsG2NIog0ehIktqGxZecED1tuU
         qC7ZzHekd+LRELIUidKjBBQ1Vn5xPxT8WvSeJz8eUC95zXHxNiwuWG6NqhyV/XXY/fOc
         x3CQ+LK2RnOvcstuS2PyQ77jVqIva1vMpg+YlvlcZ1bQWYXAdhEd3CraJt13dBm9X6fw
         +Epk5hDeJbqBnel16q9PgGDPzdhf4w+fbTSXF2XLWIE+qqvpWIfAQlGeBycKhNJb4Olt
         Oz9Dz86f/pXDmsTLlSlZI3Gs2Q8XTTzI1KQeFn1XIYXXtf9kEq6Kapbam10ebM7wzEsv
         Hygw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714750155; x=1715354955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JdeKXLmwOpYZ0RbFT9ZtQGKC2WTKqWCZd1KazXfzCOo=;
        b=PzUbUYnKh/c4muOW/eX2krwzd9o76QPtafka5yWsv4SZ7AACk18VjtR+aYgSQC1q3I
         Kl1C14rWNcYVAhUAeMBMqgVSP7fyWMGBzWJC3L9a+oHbIdRN2MwlN9VT5wEvz/aWOidz
         4vLTI6zhdV3eTHneAyEOlodoZGGjjp5M3biVGzMp4CT8MVUDZFG/V5JZNBHh4R3FCnVC
         gw3Ep6jNB633BA116ZbDWqXHI7fML44h3YgqFFCQGDLyNo2kFXorY2LM0LZHoZadaQZK
         kuj89YPdCXVipGcr3BHW8vZt1r88CfDoGtwUyzWVanh/q4sbvWIfv402E3j2hpJ0byJN
         kyeg==
X-Forwarded-Encrypted: i=1; AJvYcCUSYvtQL/I/0aqLXYMVMOMhb5ZGrHm7Hc8zQJ9jvfRMESbVwFutjsaieZclbXri4YGTiHZcTpkFGQVK5/cvIWDLSlCsPQa9
X-Gm-Message-State: AOJu0YyIEFuXYtWYdhpb+0pn+9BPvYjN9bmOp4uu3J+1tPLMlMJdaWZr
	ydqRDGWmwH6VcdgQMZlV3ItmM+pZtspBtzMTJVuDDNSVwMyPzPGDL2RRSjQjkQ==
X-Google-Smtp-Source: AGHT+IFjXoILf96ERxLCwkweSq+7qACC3MvxOQoxACDo+E2WIpBq6N8yorxEawyLEqjx1LD+zYl/Nw==
X-Received: by 2002:a05:600c:46cf:b0:419:fa3c:fb46 with SMTP id 5b1f17b1804b1-41e1cf11b6dmr1529905e9.5.1714750154988;
        Fri, 03 May 2024 08:29:14 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id r12-20020a05600c458c00b0041bfa2171efsm5970563wmo.40.2024.05.03.08.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 May 2024 08:29:14 -0700 (PDT)
Date: Fri, 3 May 2024 15:29:12 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
Message-ID: <ZjUCyGoptCcIoGpU@google.com>
References: <20240418163025.1193763-2-sebastianene@google.com>
 <20240418163025.1193763-3-sebastianene@google.com>
 <20240503143937.GA18656@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503143937.GA18656@willie-the-truck>

On Fri, May 03, 2024 at 03:39:38PM +0100, Will Deacon wrote:

Hello Will,

> Hi Seb,
> 
> On Thu, Apr 18, 2024 at 04:30:23PM +0000, Sebastian Ene wrote:
> > The pKVM hypervisor initializes with FF-A version 1.0. Keep the
> > supported version inside the host structure and prevent the host
> > drivers from overwriting the FF-A version with an increased version.
> > Without trapping the call, the host drivers can negotiate a higher
> > version number with TEE which can result in a different memory layout
> > described during the memory sharing calls.
> > 
> > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > ---
> >  arch/arm64/kvm/hyp/nvhe/ffa.c | 43 ++++++++++++++++++++++++++++++++---
> >  1 file changed, 40 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > index 320f2eaa14a9..023712e8beeb 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > @@ -58,6 +58,7 @@ struct kvm_ffa_buffers {
> >  	hyp_spinlock_t lock;
> >  	void *tx;
> >  	void *rx;
> > +	u32 ffa_version;
> >  };
> 
> Why should this be part of 'struct kvm_ffa_buffers'? The host, proxy and
> Secure side will end up using the same version, so a simple global
> variable would suffice, no?
> 

I prefer keeping it here as we will have more clients in the future /
different VMs and each one of them will have its own version and its own
pair of buffers.

> >  /*
> > @@ -640,6 +641,39 @@ static bool do_ffa_features(struct arm_smccc_res *res,
> >  	return true;
> >  }
> >  
> > +static void do_ffa_version(struct arm_smccc_res *res,
> > +			   struct kvm_cpu_context *ctxt)
> > +{
> > +	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
> > +	u32 current_version;
> > +
> > +	hyp_spin_lock(&host_buffers.lock);
> 
> Why do you need to take the lock for this?
> 

Because we interpret the host buffer content based on the version that we
end up setting here and each time we are accessing these buffers we are
protected by this lock.

> > +	current_version = host_buffers.ffa_version;
> > +	if (FFA_MAJOR_VERSION(ffa_req_version) != FFA_MAJOR_VERSION(current_version)) {
> > +		res->a0 = FFA_RET_NOT_SUPPORTED;
> > +		goto unlock;
> > +	}
> 
> We won't have probed the proxy if the Secure side doesn't support 1.x
> so I think you should just do:
> 
>   if (FFA_MAJOR_VERSION(ffa_req_version) != 1)
> 	...
>

Ack.

> > +	/*
> > +	 * If the client driver tries to downgrade the version, we need to ask
> > +	 * first if TEE supports it.
> > +	 */
> > +	if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(current_version)) {
> 
> Similarly here, I don't think 'current_version' is what we should expose.
> Rather, we should be returning the highest version that the proxy
> supports in the host, which is 1.0 at this point in the patch series.

We already report the highest version that the proxy supports on line:
`res->a0 = current_version;`

'current_version' is assigned during proxy initialization.
This check allows us to downgrade the supported ffa_version if the Host
requested it and only if TF-A supports it.

> 
> > +		arm_smccc_1_1_smc(FFA_VERSION, ffa_req_version, 0,
> > +				  0, 0, 0, 0, 0,
> > +				  res);
> 
> Hmm, I'm struggling to see how this is supposed to work per the spec.
> The FF-A spec says:
> 
>   | ... negotiation of the version must happen before an invocation of
>   | any other FF-A ABI.

I think that is a bit vague in my opinion but what I get is that the first call
executed should always be the get version ff-a call.

> 
> and:
> 
>   | Once the caller invokes any FF-A ABI other than FFA_VERSION, the
>   | version negotiation phase is complete.
>   |
>   | Once an FF-A version has been negotiated between a caller and a
>   | callee, the version may not be changed for the lifetime of the
>   | calling component. The callee must treat the negotiated version as
>   | the only supported version for any subsequent interactions with the
>   | caller.> 
> So by the time we get here, we've already settled on our version with
> the Secure side and the host cannot downgrade.

At this stage I think the spec didn't take into account that there can be a hypervisor
in between.

> 
> That's a bit rubbish if you ask me, but I think it means we'll have to
> defer some of the proxy initialisation until the host calls FFA_VERSION,
> at which point we'll need to negotiate a common version between the host,
> the proxy and Secure. Once we've done that, our FFA_VERSION handler will
> just return that negotiated version.

We are already doing this when the ARM driver is built as an external
module. If it is not as an external module and is builtin we have a
bigger issue because it loads before pKVM at subsys_initcall. This means
that we won't trap FFA_MAP* and other setup calls.

> 
> Will
> 

Thank you,
Seb


> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 
