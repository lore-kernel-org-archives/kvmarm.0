Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6006C15B0EE
	for <kvmarm@lists.linux.dev>; Wed, 20 Nov 2024 08:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732092895; cv=none; b=O0Qob1cnW4HMDqeRWr2NMICWfFa8b/YQ6bplKvBVzsYR1M+Ms7HH6av0yVLDlwpyb2QEAJj2OHpEAWDvytAZZYaRq49scLLrfPNkPiinnqKXcWO+qjl+E3NRsOsqPp46iNGBWJH6T6l2lrxf3SueOoFIVgf6rzDyddabKc5kolo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732092895; c=relaxed/simple;
	bh=LfMo2cEqvHZ9x7PhnWh/JZKBUrkwYUpuHPZSomJ/hnM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZEfqqN0nFOYA+uni/QSlgAOTBaSj/BnYjclTdfPkaKThMFXtfCPa1tI5Yhcl8O3SnUs07XOEw/PCq2DbD6/Q3P9FkjtLgzan69PIWn2U0PqXWiRcHkFpZcrkbOt/eYItYo5kFNjetcZzzRq9rHF33SQ72eSG0FiC7IRn7qLRYpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pdCrUObP; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pdCrUObP"
Date: Wed, 20 Nov 2024 08:54:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1732092890;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=RheJA6sG1cm4qnLiHRiw/h+fvItUU8aK6SaT9Pbg0s0=;
	b=pdCrUObPtL1+PjMhucNNpDQ7XCTqxu7D0ck5MJpoQyyO1c1xqGl2+vS8FjF0PLEl1vdysL
	iPLHbao/wzLpzGxl0W/tjq1I0oCyauvfC/az0cb/g+zuRx6L0HiLsgU6ffTwnGc3Pj8PRI
	u0Isa8kGc5KyyQwKTZ3ipBSkHfhfjZM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mingwei Zhang <mizhang@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Ananta <rananta@google.com>
Subject: Re: [PATCH v2 2/2] KVM: arm64: Use MDCR_EL2.HPME to evaluate
 overflow of hyp counters
Message-ID: <Zz2j1SEnH8OSrl5t@linux.dev>
References: <20241120005230.2335682-1-oliver.upton@linux.dev>
 <20241120005230.2335682-3-oliver.upton@linux.dev>
 <86ttc2uwox.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ttc2uwox.wl-maz@kernel.org>
X-Migadu-Flow: FLOW_OUT

On Wed, Nov 20, 2024 at 08:38:22AM +0000, Marc Zyngier wrote:
> On Wed, 20 Nov 2024 00:52:30 +0000, Oliver Upton <oliver.upton@linux.dev> wrote:
> > +/*
> > + * Returns the PMU overflow state, which is true if there exists an event
> > + * counter where the values of the global enable control, PMOVSSET_EL0[n], and
> > + * PMINTENSET_EL1[n] are all 1.
> > + */
> > +static bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
> >  {
> > -	u64 reg = 0;
> > +	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> >  
> > -	if ((kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E)) {
> > -		reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
> > -		reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> > -	}
> > +	reg &= __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
> > +
> > +	/*
> > +	 * PMCR_EL0.E is the global enable control for event counters available
> > +	 * to EL0 and EL1.
> > +	 */
> > +	if (!(kvm_vcpu_read_pmcr(vcpu) & ARMV8_PMU_PMCR_E))
> > +		reg &= kvm_pmu_hyp_counter_mask(vcpu);
> 
> So if the PMU is disabled at EL1, we remove the cycle counter from the
> list of counters that are considered for an overflow.
> 
> I don't think that's what you really want.

That's how it is written though, no? My understanding is that the fixed
counters are never reserved by EL2:

"""
The PE signals a request for:

[...]

 - The cycle counter, when the values of PMCR_EL0.E, PMOVSSET[31] and
   PMINTENSET[31] are all 1
"""

PMUOverflowCondition() and PMUCounterIsHyp() seem to match this too.
Unless I can't read, which happens a lot.

-- 
Thanks,
Oliver
