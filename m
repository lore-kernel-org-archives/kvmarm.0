Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2B8B14D701
	for <kvmarm@lists.linux.dev>; Tue,  7 May 2024 09:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715073442; cv=none; b=f1IfC3WxkFpARgw7UQEG8QpkJOIAM7q3/oV7NL6IhQ7QhISJrLzOfVIZw6V+BRPz5UBgrNJLjxaFqElKx3cxHMz1B0DZnGoErHR8wz8ZJfSNJ3L0rKOynMQHq2SFWphSMsiwjtVYYINGbTg89PsQfPSfxF5WaxX/qYuoqMi+TR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715073442; c=relaxed/simple;
	bh=xDAfi1FwVcw1hJGnK8mlsKUg2qK3IrhmusDaLnjmsOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=efDxWDX7Jz+W7uV9w0Eqg+uB3SRAmO7LzlZaGJPPeOE5Bon0Z3NaCMevSgO9RdZRUGrsWEhFCZwsoQYiVjLUyPTaM2DVU0zxb6EzmB/yCnwA716rthOPsDpzqHzIBUe7bDDY0Gfl8YAlM3uuzSh2vl0C8o/Vp4BPadKh/T5rQfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iNnTqv9+; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iNnTqv9+"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-418820e6effso40875e9.0
        for <kvmarm@lists.linux.dev>; Tue, 07 May 2024 02:17:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1715073438; x=1715678238; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ANuDqw0S/PQRyRd8MNS09imR727D3AyKqo3jQsOx02k=;
        b=iNnTqv9+BvBjxbHVaFTHwjDxV5ElZOZFEgnvp5G5D4CEBaGWWo0fCEwS76QTQYy5h1
         26+sJB7QMOZ4uM+l0zVfKc/U3YQhoS34MGZqQmFAXrBZopkRI5R5OJr3q/kcUUyWkjeL
         C5ADhAD0p8smsTJuo9diSt66O05/lurOepvP5xgjNt6sn9zZgwxQ0l1U+Em9t8Sr5+2D
         FfXh5AnQ9kuzMNBV5RR1NyEwerbmoD+KTq+339nXR3ynClzH9SYlxEgSCJxKjzjaSTIJ
         rcRTFnqbMJ/OBb1LMjegCEWToZDEGdBPs1Ks+awCq7JhEykUeXAtR4MgrNrgf/A+3Y5K
         T2UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715073438; x=1715678238;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ANuDqw0S/PQRyRd8MNS09imR727D3AyKqo3jQsOx02k=;
        b=aHwbRWKilDNIUhLgTiV54HnJCtJT7GBjg25fhLnXN1bm1pJmVSdcJvZirLjHysNUYk
         klTclrDor5fKS89nHVYhRw+yGmgh+9ZMt7ur7on0AUFyGk/S77JmQSYkgFjWkJRaRe5Y
         Y8UxmafYwfbuyM4r6x9d5en1jviiJN6BwpmPkIjSJNJpsDuNGh5AHO9iL7MP/pkNjF8p
         +sNp7qjHsr8CFmii2uoQ0KLTZIwH2p/lwqXSM1Xz6P+rcxNY5+EWwyBpym2NYR0xNZt1
         S57c1fpk3SxBoKOG7vFTYBKIa1vARVoPGJpiajQsYxRqMrtAjvRtO2Y/LCHY178HHND+
         dD7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSuyxl8IIowivWsOaI2hh8R3YnLlW/Vx75B72bzthP5YqvaPgBVQAYrOFjunXS9xOm4ivrqGJb525drXV1jE8MkAwWwMZ3
X-Gm-Message-State: AOJu0Yy2WOtrfhyhRiBPNsJPA6EucyQOoChsJjFQC3KyqqSYQ8+F8VWD
	bnz6/3rdbXnfEgMmYhiGfKNygFMNInNZ1hzFbnn/cUaAeqAOYOa35iq0RZ45KA==
X-Google-Smtp-Source: AGHT+IFWa2DxPUzXtMTAIuzZ6k+JU9PX5c/LNCxxDXptEavvPHor3Swu8oygcQw0lxjLZwMh7NnFug==
X-Received: by 2002:a05:600c:1c92:b0:41c:ab7:f9af with SMTP id 5b1f17b1804b1-41f3bdccb7dmr1044045e9.3.1715073438012;
        Tue, 07 May 2024 02:17:18 -0700 (PDT)
Received: from google.com (216.131.76.34.bc.googleusercontent.com. [34.76.131.216])
        by smtp.gmail.com with ESMTPSA id k5-20020a05600c1c8500b0041bab13cd74sm18931185wms.17.2024.05.07.02.17.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 May 2024 02:17:17 -0700 (PDT)
Date: Tue, 7 May 2024 09:17:15 +0000
From: Sebastian Ene <sebastianene@google.com>
To: Will Deacon <will@kernel.org>
Cc: catalin.marinas@arm.com, james.morse@arm.com, jean-philippe@linaro.org,
	maz@kernel.org, oliver.upton@linux.dev, qperret@google.com,
	qwandor@google.com, sudeep.holla@arm.com, suzuki.poulose@arm.com,
	tabba@google.com, yuzenghui@huawei.com, lpieralisi@kernel.org,
	kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org, kernel-team@android.com
Subject: Re: [PATCH 1/4] KVM: arm64: Trap FFA_VERSION host call in pKVM
Message-ID: <Zjnxmym0GLdzl0uR@google.com>
References: <20240418163025.1193763-2-sebastianene@google.com>
 <20240418163025.1193763-3-sebastianene@google.com>
 <20240503143937.GA18656@willie-the-truck>
 <ZjUCyGoptCcIoGpU@google.com>
 <20240503162114.GA18789@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503162114.GA18789@willie-the-truck>

On Fri, May 03, 2024 at 05:21:14PM +0100, Will Deacon wrote:
> On Fri, May 03, 2024 at 03:29:12PM +0000, Sebastian Ene wrote:
> > On Fri, May 03, 2024 at 03:39:38PM +0100, Will Deacon wrote:
> > > On Thu, Apr 18, 2024 at 04:30:23PM +0000, Sebastian Ene wrote:
> > > > The pKVM hypervisor initializes with FF-A version 1.0. Keep the
> > > > supported version inside the host structure and prevent the host
> > > > drivers from overwriting the FF-A version with an increased version.
> > > > Without trapping the call, the host drivers can negotiate a higher
> > > > version number with TEE which can result in a different memory layout
> > > > described during the memory sharing calls.
> > > > 
> > > > Signed-off-by: Sebastian Ene <sebastianene@google.com>
> > > > ---
> > > >  arch/arm64/kvm/hyp/nvhe/ffa.c | 43 ++++++++++++++++++++++++++++++++---
> > > >  1 file changed, 40 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/arch/arm64/kvm/hyp/nvhe/ffa.c b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > index 320f2eaa14a9..023712e8beeb 100644
> > > > --- a/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > +++ b/arch/arm64/kvm/hyp/nvhe/ffa.c
> > > > @@ -58,6 +58,7 @@ struct kvm_ffa_buffers {
> > > >  	hyp_spinlock_t lock;
> > > >  	void *tx;
> > > >  	void *rx;
> > > > +	u32 ffa_version;
> > > >  };
> > > 
> > > Why should this be part of 'struct kvm_ffa_buffers'? The host, proxy and
> > > Secure side will end up using the same version, so a simple global
> > > variable would suffice, no?
> > > 
> > I prefer keeping it here as we will have more clients in the future /
> > different VMs and each one of them will have its own version and its own
> > pair of buffers.
> 
> We can add that when we need to. Let's keep it simple for now, as the
> idea of the proxy having to support multiple versions of the spec at
> once sounds terrifying to me. I don't think we're going to want to
> re-marshall the data structures between the 1.0 and 1.1 formats, are we?
> 

I don't think we increase the complexity of the code by keeping this
argument in the structure. The code in nvhe/ffa.c supports marshalling
the structure as of [this
change](https://lore.kernel.org/r/20231005-ffa_v1-1_notif-v4-14-cddd3237809c@arm.com
) and that is why I was in favor of keeping the version where it belongs
to.

> > > > @@ -640,6 +641,39 @@ static bool do_ffa_features(struct arm_smccc_res *res,
> > > >  	return true;
> > > >  }
> > > >  
> > > > +static void do_ffa_version(struct arm_smccc_res *res,
> > > > +			   struct kvm_cpu_context *ctxt)
> > > > +{
> > > > +	DECLARE_REG(u32, ffa_req_version, ctxt, 1);
> > > > +	u32 current_version;
> > > > +
> > > > +	hyp_spin_lock(&host_buffers.lock);
> > > 
> > > Why do you need to take the lock for this?
> > > 
> > 
> > Because we interpret the host buffer content based on the version that we
> > end up setting here and each time we are accessing these buffers we are
> > protected by this lock.
> 
> I think that's indicative of a broader issue, though, which is that you
> allow for the version to be re-negotiated at runtime. The spec doesn't
> allow that and I don't think we should either.
> 

The spec talks about interopeartion in case two versions (x,y) and (a,b)
want to talk: 

- given the pairs (x,y) and (a,b) x=major, y=minor if x == a and y > b
  the versions are incompatible until y downgrades its version such that
  y <= b.

From this I drew the conclusion that the spec allows the re-negotiation
at runtime, please let me know if you see things differently.

> > > > +	/*
> > > > +	 * If the client driver tries to downgrade the version, we need to ask
> > > > +	 * first if TEE supports it.
> > > > +	 */
> > > > +	if (FFA_MINOR_VERSION(ffa_req_version) < FFA_MINOR_VERSION(current_version)) {
> > > 
> > > Similarly here, I don't think 'current_version' is what we should expose.
> > > Rather, we should be returning the highest version that the proxy
> > > supports in the host, which is 1.0 at this point in the patch series.
> > 
> > We already report the highest version that the proxy supports on line:
> > `res->a0 = current_version;`
> > 
> > 'current_version' is assigned during proxy initialization.
> > This check allows us to downgrade the supported ffa_version if the Host
> > requested it and only if TF-A supports it.
> 
> I don't think we want the host negotiating directly with the Secure side,
> though, do we? 'current_version' is initialised to whatever the Secure
> side gives us, so if we had something like:
> 
>   1. Proxy initialises, issues FFA_VERSION(1.0)

This will save 1.0 in host_buffers.ffa_version

>   2. Secure implements 1.2 and so returns 1.2 but remains in 1.0
>      compatability mode for the data structure formats.

Ack.

>   3. The host issues FFA_VERSION(1.1)

The call is trapped and we verify if the requested version
(FFA_VERSION(1.1) is smaller than our current_version saved in step 1.

Given that is not smaller we only reply with our current supported
version which is FFA_VERSION(1.0) and we return to the host.

>   4. The code above then issues FFA_VERSION(1.1) to Secure and it
>      switches over to the 1.1 data structures

This was happening prior to my patch, so in a way this patch is a bugfix.
We get this behavior without trapping and interpretting
of the FFA_VERSION API.

> 
> Did I get that right?
> 
> I really think we need to settle on a single version for the host,
> hypervisor and Secure and then stick with it following a single
> negotiation stage.
> 
> > > > +		arm_smccc_1_1_smc(FFA_VERSION, ffa_req_version, 0,
> > > > +				  0, 0, 0, 0, 0,
> > > > +				  res);
> > > 
> > > Hmm, I'm struggling to see how this is supposed to work per the spec.
> > > The FF-A spec says:
> > > 
> > >   | ... negotiation of the version must happen before an invocation of
> > >   | any other FF-A ABI.
> > 
> > I think that is a bit vague in my opinion but what I get is that the first call
> > executed should always be the get version ff-a call.
> > 
> > > 
> > > and:
> > > 
> > >   | Once the caller invokes any FF-A ABI other than FFA_VERSION, the
> > >   | version negotiation phase is complete.
> > >   |
> > >   | Once an FF-A version has been negotiated between a caller and a
> > >   | callee, the version may not be changed for the lifetime of the
> > >   | calling component. The callee must treat the negotiated version as
> > >   | the only supported version for any subsequent interactions with the
> > >   | caller.> 
> > > So by the time we get here, we've already settled on our version with
> > > the Secure side and the host cannot downgrade.
> > 
> > At this stage I think the spec didn't take into account that there can be a hypervisor
> > in between.
> 
> Well, that's what the spec says and I think we need to follow it. I can
> well imagine that the Secure side won't allow the version to be
> re-negotiated on the fly and I don't think we'd want that in the proxy,
> either.
> 
> > > That's a bit rubbish if you ask me, but I think it means we'll have to
> > > defer some of the proxy initialisation until the host calls FFA_VERSION,
> > > at which point we'll need to negotiate a common version between the host,
> > > the proxy and Secure. Once we've done that, our FFA_VERSION handler will
> > > just return that negotiated version.
> > 
> > We are already doing this when the ARM driver is built as an external
> > module. If it is not as an external module and is builtin we have a
> > bigger issue because it loads before pKVM at subsys_initcall. This means
> > that we won't trap FFA_MAP* and other setup calls.
> 
> Sorry, I don't follow. hyp_ffa_init() issues FFA_FEATURES immediately
> after FFA_VERSION, so we terminate the negotiation right away.

Sorry I confused you, I am afraid I was trying to desribe a different issue
here which is related to how early the ARM FF-A driver initializes when
is builtin - it is before the hypervisor proxy is installed.

> 
> Will
> 
> To unsubscribe from this group and stop receiving emails from it, send an email to kernel-team+unsubscribe@android.com.
> 

Thank you,
Seb

