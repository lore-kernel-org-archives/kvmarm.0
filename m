Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA0F1A2541
	for <kvmarm@lists.linux.dev>; Thu, 19 Dec 2024 18:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734631233; cv=none; b=eal0Lfvx0Rl7Yoo73M8Xp+QSw5Lx3oFURtnXVYOQPZ5I1yWtmbBO0NYYwsh9MBGZTLguhNhPlkHvI55fCjXcTRjJPoUEMtwcenKPusg1cUYxNNbabQ8A5KruzQVHCaQwUXWzTZ9vpC2Z6mIZWBqhtZE90xxgvmvAk7zdHg2k4Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734631233; c=relaxed/simple;
	bh=Ik9ilDqzlZi04w0XI4iZPeRl831EgOFTBdme0lMBhxA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WOCces/vc71StGaf759fYbqkQb+tjZBzoO76rO56sgKXYO+AqZ1kyI/+3XO8YjuNYZU3432YnoUuoOWMrg46/BR29RPKLyM/6DPxyPmEdoGY7BaRNyY/vGaBHAreYlzwULwSvbn8PhZ6a74m3eFSinpwbsXpVy/g8wBqexQqR+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=f2F+kiVV; arc=none smtp.client-ip=95.215.58.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="f2F+kiVV"
Date: Thu, 19 Dec 2024 10:00:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1734631229;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T+KW5Z1SyjnwC2CV1KePHdgbc9vFX6WqdnGxoiX2XlQ=;
	b=f2F+kiVV81s0egQBc1Suh5x3DpT1qpgURzOe4Z280N+7Mqr7tFk4lmJWA1PaXu/LOoqvYW
	dkxk30BNebH6B3ejDpO4Sg9onFCmQp56yEzuYWk1nsnIFH8PIELYTcko1UNvWYzO2JYpYG
	M8H5zaWyAcuKkrlSwVSm2bpslHpxAN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	James Clark <james.clark@linaro.org>
Subject: Re: [PATCH v3 12/16] KVM: arm64: Compute MDCR_EL2 at vcpu_load()
Message-ID: <Z2RfONQgWszZBBJx@linux.dev>
References: <20241209180926.2161373-1-oliver.upton@linux.dev>
 <20241209180926.2161373-13-oliver.upton@linux.dev>
 <86ed24rg0h.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ed24rg0h.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 18, 2024 at 06:40:46PM +0000, Marc Zyngier wrote:
> On Mon, 09 Dec 2024 18:09:22 +0000,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > @@ -288,6 +270,12 @@ void kvm_debug_set_guest_ownership(struct kvm_vcpu *vcpu)
> >  
> >  	WARN_ON_ONCE(vcpu->arch.debug_owner == VCPU_DEBUG_GUEST_OWNED);
> >  	vcpu->arch.debug_owner = VCPU_DEBUG_GUEST_OWNED;
> > +
> > +	preempt_disable();
> > +	kvm_arm_setup_mdcr_el2(vcpu);
> > +	if (has_vhe())
> > +		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
> > +	preempt_enable();
> 
> I'm not confident that the preemption_disable() does anything.
> Specially given that it doesn't include setting the ownership as part
> of the critical section. So if that works at it is now, then the
> critical section is pointless.

We use percpu data to construct mdcr_el2, so disabling preemption
ensures that we use the right copy + stick mdcr in the right CPU.

But point taken about guest ownership, nothing stops preemption from
blowing away the GUEST_OWNED state.

> I also find it rather fragile that we have multiple places where we
> write MDCR_EL2, and I would love this to go for good. Any idea?

Totally agree, that was at least one of the motivators for this series
originally. For v4 I'm planning to hoist the preempt_disable() + programming
of MDCR_EL2 into kvm_arm_setup_mdcr_el2(), which would be shared w/
vcpu_load() and hide the details of how MDCR gets set up.

I still want us to have a way of reconfiguring MDCR_EL2 on the fly to
lazily restore the debug registers without going through an entire
put/load. I'm thinking that eventually we can do the same thing for the
PMU when Colton + co have partitioned PMU support worked out.

-- 
Thanks,
Oliver
