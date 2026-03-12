Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454FE3B6BFE
	for <kvmarm@lists.linux.dev>; Thu, 12 Mar 2026 14:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773327323; cv=none; b=eFQpqfuUL1oRAngWalL9QW+bDmMy7tCc8PXMsHjwce6RZM8dPjT8NZJSknlNxFwsv8W05bJFf8hAtmDPvLSdPhTDPfFqf89tTBqF2I5ulRlblN/C05Dw8K4XMpJZfE4AKJ2/4iuEI8zhaBwKJu2o3bTDu1lK9NFznoD44sASzN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773327323; c=relaxed/simple;
	bh=m6Qmo0gP3oXxCHS+wcjEiwJDplmx7CuxPdGk8+2k4LE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=t8/DDPCz7XD5yVUrer7PmWH+3U+VkU1Ds7v+QUyH3sPMhkN4F7Jrz+QyIo1+3Ka4tmMfJ3nWMGln8yxJOQ38rBVNarWAuvwI9vW/R5Rq6j2LUlh7zw1iB1DStTbC+1VzWs4TuVAQdhZuINvrKC5Hqyq2gbt+78RCJ0HyNz706do=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kf6qxQVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kf6qxQVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41C4C4CEF7;
	Thu, 12 Mar 2026 14:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773327320;
	bh=m6Qmo0gP3oXxCHS+wcjEiwJDplmx7CuxPdGk8+2k4LE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kf6qxQVUftqO7qd5xpfmc8MZoRp4bdndg5u0xdUHHV+BWxHQQOUKpToXbUBONJ4tF
	 8UqeQuYpE6LTtpQYr2cuPYEnqf3wjG1ra3dtcjAEOAmTXNGGiQaNml75Y1BUuaV7if
	 9wAszBtVKHsxhF99BaDzRlT/RZCPLZIq5nZViKsD7AYF4NejQ9zp/wWZabQ0rJqURd
	 l11evCX2vBlzF2KnJeK24facUv8De3eZTKRvmNOUtrK+Cy0f5qm8OJj8x6Xcl0f7dL
	 qzBDXWwK/Sl7Ji3vPjCgd76ty/ssYjXg+RmR4M2LUIq2FXPAupUbzdtCkPob4vCqxP
	 34e8VBxihoTnw==
Date: Thu, 12 Mar 2026 14:55:15 +0000
From: Will Deacon <will@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Vladimir Murzin <vladimir.murzin@arm.com>,
	linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <abLT05Nq-9J-uBEY@willie-the-truck>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
 <aamT6-Mvr9nI1unq@willie-the-truck>
 <aarB3iv8963UDn5E@arm.com>
 <c4a302df-511b-40b2-97f2-06576748c999@arm.com>
 <abA6N6ctPoscIbBe@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abA6N6ctPoscIbBe@arm.com>

On Tue, Mar 10, 2026 at 03:35:19PM +0000, Catalin Marinas wrote:
> Thanks Vladimir,
> 
> On Mon, Mar 09, 2026 at 10:13:20AM +0000, Vladimir Murzin wrote:
> > On 3/6/26 12:00, Catalin Marinas wrote:
> > >>> @@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
> > >>>  	put_cpu_fpsimd_context();
> > >>>  }
> > >>>  
> > >>> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> > >>> +
> > >>> +/*
> > >>> + * SME/CME erratum handling
> > >>> + */
> > >>> +static cpumask_var_t sme_dvmsync_cpus;
> > >>> +static cpumask_var_t sme_active_cpus;
> > >>> +
> > >>> +void sme_set_active(unsigned int cpu)
> > >>> +{
> > >>> +	if (!cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> > >>> +		return;
> > >>> +	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
> > >>> +		return;
> > >>> +
> > >>> +	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
> > >>> +		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
> > >>> +
> > >>> +	cpumask_set_cpu(cpu, sme_active_cpus);
> > >>> +
> > >>> +	/*
> > >>> +	 * Ensure subsequent (SME) memory accesses are observed after the
> > >>> +	 * cpumask and the MMCF_SME_DVMSYNC flag setting.
> > >>> +	 */
> > >>> +	smp_mb();
> > >>
> > >> I can't convince myself that a DMB is enough here, as the whole issue
> > >> is that the SME memory accesses can be observed _after_ the TLB
> > >> invalidation. I'd have thought we'd need a DSB to ensure that the flag
> > >> updates are visible before the exception return.
> > > 
> > > This is only to ensure that the sme_active_cpus mask is observed before
> > > any SME accesses. The mask is later used to decide whether to send the
> > > IPI. We have something like this:
> > > 
> > > P0
> > > 	STSET	[sme_active_cpus]
> > > 	DMB
> > > 	SME access to [addr]
> > > 
> > > P1
> > > 	TLBI	[addr]
> > > 	DSB
> > > 	LDR	[sme_active_cpus]
> > > 	CBZ	out
> > > 	Do IPI
> > > out:
> > > 
> > > If P1 did not observe the STSET to [sme_active_cpus], P0 should have
> > > received and acknowledged the DVMSync before the STSET. Is your concern
> > > that P1 can observe the subsequent SME access but not the STSET?
> > > 
> > > No idea whether herd can model this (I only put this in TLA+ for the
> > > main logic check but it doesn't do subtle memory ordering).
> > 
> > JFYI, herd support for SME is still work-in-progress (specifically it misses
> > updates in cat), yet it can model VMSA.
> > 
> > IIUC, expectation here is that either
> > - P1 observes sme_active_cpus, so we have to do_IPI or
> > - P0 observes TLBI (say shutdown, so it must fault)
> > 
> > anything else is unexpected/forbidden.
> > 
> > AArch64 A
> > variant=vmsa
> > {
> >  int x=0;
> >  int active=0;
> > 
> >  0:X1=active;
> >  0:X3=x;
> > 
> >  1:X0=(valid:0);
> >  1:X1=PTE(x);
> >  1:X2=x;
> >  1:X3=active;
> >  
> > }
> >  P0                                 | P1                                            ;
> >  MOV W0,#1                          | STR X0,[X1]                                   ;
> >  STR W0,[X1] (* sme_active_cpus  *) | DSB ISH                                       ;
> >  DMB SY                             | LSR X9,X2,#12                                 ;
> >  LDR W2,[X3] (* access to [addr] *) | TLBI VAAE1IS,X9 (* [addr] *)                  ;
> >                                     | DSB ISH                                       ;
> >                                     | LDR W4,[X3]     (* sme_active_cpus *)         ;
> > 
> > exists ~(1:X4=1 \/ fault(P0,x))
> > 
> > Is that correct understanding? Have I missed anything?
> 
> Yes, I think that's correct. Another tweak specific to this erratum
> would be for P1 to do a store to x via another mapping after the
> TLBI+DSB and the P0 load should not see it.
> 
> Even with the CPU erratum, if the P1 DVMSync is received/acknowledged by
> P0 before its STR to sme_active_cpus, I don't see how the subsequent SME
> load would overtake the STR given the DMB. The erratum messed up the
> DVMSync acknowledgement, not the barriers.

I'm still finding this hard to reason about.

Why can't:

1. P0 translates its SME load and puts the valid translation into its TLB
2. P1 runs to completion, sees sme_active_cpus as 0 and so doesn't IPI
3. P0 writes to sme_active_cpus and then does the SME load using the
   translation from (1)

I guess it's diving into ugly corners of what the erratum actually is...

Will
