Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 743C43E5EF9
	for <kvmarm@lists.linux.dev>; Thu, 19 Mar 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773935151; cv=none; b=Bo4fGPUDCyGp5tPSqot4zVMR77TGCHncWdGrUG+E+5izyA3P+FUh1p+uWIHIWe3o/UjIbY2NaOt6IcQQOxD9ECCuZnxloMTfBT+dsFyl+YGazNvFB3467M2VQTIiO/iyn1dS4Dpf2W2K192iHI9eYpIKx0jAiKdHV6jeYJZWb/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773935151; c=relaxed/simple;
	bh=ZtKfn+KZ0/qFdWOP6ItpZvjUveLtMULge3Jphw4QCRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Nef1tfb950CXp9EHBVZS8uAkTLiBim9X39KSxlax7zlN8G61BN96CNXpRepVaU7h+KjWRFVRG/Iixt5pjT9zJlyT5yhEgomlSj+ua3kVWBi152UTS3XRmubbwYFnR+0RMnAthJY8syXKDMqBGuRhEiule76e/yfnc1U6/AXIr0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8DE81A25;
	Thu, 19 Mar 2026 08:45:43 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8954C3F778;
	Thu, 19 Mar 2026 08:45:48 -0700 (PDT)
Date: Thu, 19 Mar 2026 15:45:45 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <abwaKf3F0Ya3wyxl@arm.com>
References: <20260318191918.2653160-1-catalin.marinas@arm.com>
 <20260318191918.2653160-4-catalin.marinas@arm.com>
 <abv65n3fhvYDEez0@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abv65n3fhvYDEez0@willie-the-truck>

Hi Will,

Thanks for the review.

On Thu, Mar 19, 2026 at 01:32:22PM +0000, Will Deacon wrote:
> Are you planning to take this for 7.1 or would you like me to take it
> via for-next/fixes? I'm leaning towards the former so it can simmer in
> -next for a bit...

Yes, it makes sense.

> On Wed, Mar 18, 2026 at 07:19:15PM +0000, Catalin Marinas wrote:
> > C1-Pro acknowledges DVMSync messages before completing the SME/CME
> > memory accesses. Work around this by issuing an IPI to the affected CPUs
> > if they are running in EL0 with SME enabled.
> > 
> > Note that we avoid the local DSB in the IPI handler as the kernel runs
> > with SCTLR_EL1.IESB=1 This is sufficient to complete SME memory accesses
> > at EL0 on taking an exception to EL1. On the return to user path, no
> > barrier is necessary either. See the comment in sme_set_active() and the
> > more detailed explanation in the link below.
> 
> Missing link?

Ah, I eventually moved it to a comment in the code directly. I'll add it
here as well.

> > diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> > index 38dba5f7e4d2..f07cdb6ada08 100644
> > --- a/arch/arm64/Kconfig
> > +++ b/arch/arm64/Kconfig
> > @@ -1175,6 +1175,18 @@ config ARM64_ERRATUM_4311569
> >  
> >  	  If unsure, say Y.
> >  
> > +config ARM64_ERRATUM_SME_DVMSYNC
> 
> Any reason not to call this ARM64_ERRATUM_4193714 like we do for other
> hardware bugs?

Future-proofing, in case it becomes a feature ;).

I'll change it. I think when I started I didn't have the number (or did
not know where to look for it). I was too lazy to change it afterwards.

> > diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
> > index 1d2e33559bd5..129c29aa0fc4 100644
> > --- a/arch/arm64/include/asm/fpsimd.h
> > +++ b/arch/arm64/include/asm/fpsimd.h
> > @@ -428,6 +428,24 @@ static inline size_t sme_state_size(struct task_struct const *task)
> >  	return __sme_state_size(task_get_sme_vl(task));
> >  }
> >  
> > +void sme_enable_dvmsync(void);
> > +void sme_set_active(unsigned int cpu);
> > +void sme_clear_active(unsigned int cpu);
> > +
> > +static inline void sme_enter_from_user_mode(void)
> > +{
> > +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
> > +	    test_thread_flag(TIF_SME))
> > +		sme_clear_active(smp_processor_id());
> > +}
> > +
> > +static inline void sme_exit_to_user_mode(void)
> > +{
> > +	if (alternative_has_cap_unlikely(ARM64_WORKAROUND_SME_DVMSYNC) &&
> > +	    test_thread_flag(TIF_SME))
> > +		sme_set_active(smp_processor_id());
> > +}
> 
> nit: You could push smp_processor_id() down into sme_{set,clear}_active()
> since they are always called for the running CPU.

Yes, I can. What I had in mind from an API perspective was that the
caller knows preemption is disabled while the callee may not. But it's
only this caller, so fine by me with moving the smp_processor_id() to
those function.

If we ever add support for SME in guests with this erratum, we may
call the same function (not sure yet), just need to make sure preemption
is disabled or add a check. OTOH, I'd rather disable SME in guests
altogether for these CPUs.

I'll address the other points and repost next week.

Thanks.

-- 
Catalin
