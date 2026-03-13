Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A55351A681C
	for <kvmarm@lists.linux.dev>; Fri, 13 Mar 2026 15:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773417486; cv=none; b=LvZGMk7c5SOiO+Xz0WXTClYggkeuSCVdQa8MZTgaYBrnqCubPH0N+Of5ojFKwFHwaXrfjILl8eoLSm/t8jpNgNGVlfvl/AJ7dYrCD5vb2OluntcC+K8NlHmHMrxEFfLpgE6N253CqSoFCe4VcXUy/aX4kxqTNniTQ9I3Iw2yYyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773417486; c=relaxed/simple;
	bh=D5PZYTno7wOL/03mIkv0E+olwq3141aLAIhD7Irlnrs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P1MEcTdRUCz+i2Gv9qN7siryxjJsNt9GvpX1VeGtw7TyRcTm5G0VsqDrne5TCa+hfG094z7I8sWOj8PeZHWJTq8J2rr/SsQCGfXqGOM2gb+uc30u2yMhcBgGB119gwVvJ2xYPhWiGlPBkllBeOYR0GQd0OJepF9A1NehNMQmVWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbwkpZr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbwkpZr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1672CC19421;
	Fri, 13 Mar 2026 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773417486;
	bh=D5PZYTno7wOL/03mIkv0E+olwq3141aLAIhD7Irlnrs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XbwkpZr23ptn7RjEE1ds5M5eycyiQfArVY32wh34TPy0ZCw0IknmU11KovTOclJaq
	 mmEiJMMzLrCZ2+9CJU6qaEe8bCRtuH0KYq9IwADrH+0+bZLGMGpWW9E3y0OWvG1KnJ
	 f1orJ+SeoI1hJpAnLijhT39gszxlOYhtrCt00F3xNNZutL0b95lFJdvv/3KEdI+NGA
	 HTMKN7Oep24UfQJPVifqg20cEEQAXqU4vfQthysWK6URuyAe/pQLuYn9hNF2yOklGC
	 vFJj/2Czq6st4ipiOdasgaJtXALdXU32VNODpgVJ283iFEMPbcORYUeHFxtTZI0fmE
	 3Q3B/h9jm6whQ==
Date: Fri, 13 Mar 2026 15:58:00 +0000
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
Message-ID: <abQ0CKop8Sy3hqhC@willie-the-truck>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
 <aamT6-Mvr9nI1unq@willie-the-truck>
 <aarB3iv8963UDn5E@arm.com>
 <c4a302df-511b-40b2-97f2-06576748c999@arm.com>
 <abA6N6ctPoscIbBe@arm.com>
 <abLT05Nq-9J-uBEY@willie-the-truck>
 <abQx6Q_FJH92cjXj@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <abQx6Q_FJH92cjXj@arm.com>

On Fri, Mar 13, 2026 at 03:48:57PM +0000, Catalin Marinas wrote:
> On Thu, Mar 12, 2026 at 02:55:15PM +0000, Will Deacon wrote:
> > On Tue, Mar 10, 2026 at 03:35:19PM +0000, Catalin Marinas wrote:
> > > On Mon, Mar 09, 2026 at 10:13:20AM +0000, Vladimir Murzin wrote:
> > > > On 3/6/26 12:00, Catalin Marinas wrote:
> > > > >>> @@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
> > > > >>>  	put_cpu_fpsimd_context();
> > > > >>>  }
> > > > >>>  
> > > > >>> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> > > > >>> +
> > > > >>> +/*
> > > > >>> + * SME/CME erratum handling
> > > > >>> + */
> > > > >>> +static cpumask_var_t sme_dvmsync_cpus;
> > > > >>> +static cpumask_var_t sme_active_cpus;
> > > > >>> +
> > > > >>> +void sme_set_active(unsigned int cpu)
> > > > >>> +{
> > > > >>> +	if (!cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> > > > >>> +		return;
> > > > >>> +	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
> > > > >>> +		return;
> > > > >>> +
> > > > >>> +	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
> > > > >>> +		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
> > > > >>> +
> > > > >>> +	cpumask_set_cpu(cpu, sme_active_cpus);
> > > > >>> +
> > > > >>> +	/*
> > > > >>> +	 * Ensure subsequent (SME) memory accesses are observed after the
> > > > >>> +	 * cpumask and the MMCF_SME_DVMSYNC flag setting.
> > > > >>> +	 */
> > > > >>> +	smp_mb();
> > > > >>
> > > > >> I can't convince myself that a DMB is enough here, as the whole issue
> > > > >> is that the SME memory accesses can be observed _after_ the TLB
> > > > >> invalidation. I'd have thought we'd need a DSB to ensure that the flag
> > > > >> updates are visible before the exception return.
> > > > > 
> > > > > This is only to ensure that the sme_active_cpus mask is observed before
> > > > > any SME accesses. The mask is later used to decide whether to send the
> > > > > IPI. We have something like this:
> > > > > 
> > > > > P0
> > > > > 	STSET	[sme_active_cpus]
> > > > > 	DMB
> > > > > 	SME access to [addr]
> > > > > 
> > > > > P1
> > > > > 	TLBI	[addr]
> > > > > 	DSB
> > > > > 	LDR	[sme_active_cpus]
> > > > > 	CBZ	out
> > > > > 	Do IPI
> > > > > out:
> > > > > 
> > > > > If P1 did not observe the STSET to [sme_active_cpus], P0 should have
> > > > > received and acknowledged the DVMSync before the STSET. Is your concern
> > > > > that P1 can observe the subsequent SME access but not the STSET?
> > > > > 
> > > > > No idea whether herd can model this (I only put this in TLA+ for the
> > > > > main logic check but it doesn't do subtle memory ordering).
> > > > 
> > > > JFYI, herd support for SME is still work-in-progress (specifically it misses
> > > > updates in cat), yet it can model VMSA.
> > > > 
> > > > IIUC, expectation here is that either
> > > > - P1 observes sme_active_cpus, so we have to do_IPI or
> > > > - P0 observes TLBI (say shutdown, so it must fault)
> > > > 
> > > > anything else is unexpected/forbidden.
> > > > 
> > > > AArch64 A
> > > > variant=vmsa
> > > > {
> > > >  int x=0;
> > > >  int active=0;
> > > > 
> > > >  0:X1=active;
> > > >  0:X3=x;
> > > > 
> > > >  1:X0=(valid:0);
> > > >  1:X1=PTE(x);
> > > >  1:X2=x;
> > > >  1:X3=active;
> > > >  
> > > > }
> > > >  P0                                 | P1                                            ;
> > > >  MOV W0,#1                          | STR X0,[X1]                                   ;
> > > >  STR W0,[X1] (* sme_active_cpus  *) | DSB ISH                                       ;
> > > >  DMB SY                             | LSR X9,X2,#12                                 ;
> > > >  LDR W2,[X3] (* access to [addr] *) | TLBI VAAE1IS,X9 (* [addr] *)                  ;
> > > >                                     | DSB ISH                                       ;
> > > >                                     | LDR W4,[X3]     (* sme_active_cpus *)         ;
> > > > 
> > > > exists ~(1:X4=1 \/ fault(P0,x))
> > > > 
> > > > Is that correct understanding? Have I missed anything?
> > > 
> > > Yes, I think that's correct. Another tweak specific to this erratum
> > > would be for P1 to do a store to x via another mapping after the
> > > TLBI+DSB and the P0 load should not see it.
> > > 
> > > Even with the CPU erratum, if the P1 DVMSync is received/acknowledged by
> > > P0 before its STR to sme_active_cpus, I don't see how the subsequent SME
> > > load would overtake the STR given the DMB. The erratum messed up the
> > > DVMSync acknowledgement, not the barriers.
> > 
> > I'm still finding this hard to reason about.
> > 
> > Why can't:
> > 
> > 1. P0 translates its SME load and puts the valid translation into its TLB
> > 2. P1 runs to completion, sees sme_active_cpus as 0 and so doesn't IPI
> > 3. P0 writes to sme_active_cpus and then does the SME load using the
> >    translation from (1)
> > 
> > I guess it's diving into ugly corners of what the erratum actually is...
> 
> From discussing with the microarchitects at the time, a DMB ISH was
> sufficient on the ERET path. Whether they thought about your scenario,
> not sure. Memory ordering isn't broken by this bug, only the DVMSync
> acknowledgement not waiting for the CME unit (shared by multiple CPUs)
> to complete an in-flight memory access. My assumption is that step (1)
> won't actually start until the STR in (3) is issued and this would
> include the TLB lookup.

Maybe, but that sounds slow...

> Anyway, I'll ask them again to be sure.

Thanks.

If you're speaking to them, it might also be worth asking whether or not
the exception return alone is sufficient (given that we run with IESB=1).

Will
