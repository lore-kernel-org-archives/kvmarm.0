Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A1721A3154
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773156925; cv=none; b=Xj/WCqVnMS637PBuat5YIsFV1wQRA3ECJ+tdmLW6BrX0aeMNrkDD2x3kDVSBKMbkOvhSqEfJU/cAxGTEP0KADAr3vuTEf2Sn95fPIOAQjeLBNXvZmm+yz0pCh7seuVNzdImqU6FhKm52/X4Ex9PWENGPYIgl22a6MS1dXs+QfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773156925; c=relaxed/simple;
	bh=wB2wW/RNmvEmSmYOnPMY862+4jKvG7jR+Q33pxCWHpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1DAuXN8TOksH5K/BrJ9j1L4gmiRS1/kxEpd+XrKuIX4Ui5EEfOw7HxvPV3lTtOzLuELT2zjgm984yxH8YfCzoCfzGUMckiB5xY7kSIYLdLm1xAAnKI5Yrbv2i3SbjbBtGWlFK7SwonL7U7yxEtBd55Aq0nWVaxei54DQKLcLys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 39A32169C;
	Tue, 10 Mar 2026 08:35:17 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B7A683F7BD;
	Tue, 10 Mar 2026 08:35:21 -0700 (PDT)
Date: Tue, 10 Mar 2026 15:35:19 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <abA6N6ctPoscIbBe@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
 <aamT6-Mvr9nI1unq@willie-the-truck>
 <aarB3iv8963UDn5E@arm.com>
 <c4a302df-511b-40b2-97f2-06576748c999@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4a302df-511b-40b2-97f2-06576748c999@arm.com>

Thanks Vladimir,

On Mon, Mar 09, 2026 at 10:13:20AM +0000, Vladimir Murzin wrote:
> On 3/6/26 12:00, Catalin Marinas wrote:
> >>> @@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
> >>>  	put_cpu_fpsimd_context();
> >>>  }
> >>>  
> >>> +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> >>> +
> >>> +/*
> >>> + * SME/CME erratum handling
> >>> + */
> >>> +static cpumask_var_t sme_dvmsync_cpus;
> >>> +static cpumask_var_t sme_active_cpus;
> >>> +
> >>> +void sme_set_active(unsigned int cpu)
> >>> +{
> >>> +	if (!cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> >>> +		return;
> >>> +	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
> >>> +		return;
> >>> +
> >>> +	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
> >>> +		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
> >>> +
> >>> +	cpumask_set_cpu(cpu, sme_active_cpus);
> >>> +
> >>> +	/*
> >>> +	 * Ensure subsequent (SME) memory accesses are observed after the
> >>> +	 * cpumask and the MMCF_SME_DVMSYNC flag setting.
> >>> +	 */
> >>> +	smp_mb();
> >>
> >> I can't convince myself that a DMB is enough here, as the whole issue
> >> is that the SME memory accesses can be observed _after_ the TLB
> >> invalidation. I'd have thought we'd need a DSB to ensure that the flag
> >> updates are visible before the exception return.
> > 
> > This is only to ensure that the sme_active_cpus mask is observed before
> > any SME accesses. The mask is later used to decide whether to send the
> > IPI. We have something like this:
> > 
> > P0
> > 	STSET	[sme_active_cpus]
> > 	DMB
> > 	SME access to [addr]
> > 
> > P1
> > 	TLBI	[addr]
> > 	DSB
> > 	LDR	[sme_active_cpus]
> > 	CBZ	out
> > 	Do IPI
> > out:
> > 
> > If P1 did not observe the STSET to [sme_active_cpus], P0 should have
> > received and acknowledged the DVMSync before the STSET. Is your concern
> > that P1 can observe the subsequent SME access but not the STSET?
> > 
> > No idea whether herd can model this (I only put this in TLA+ for the
> > main logic check but it doesn't do subtle memory ordering).
> 
> JFYI, herd support for SME is still work-in-progress (specifically it misses
> updates in cat), yet it can model VMSA.
> 
> IIUC, expectation here is that either
> - P1 observes sme_active_cpus, so we have to do_IPI or
> - P0 observes TLBI (say shutdown, so it must fault)
> 
> anything else is unexpected/forbidden.
> 
> AArch64 A
> variant=vmsa
> {
>  int x=0;
>  int active=0;
> 
>  0:X1=active;
>  0:X3=x;
> 
>  1:X0=(valid:0);
>  1:X1=PTE(x);
>  1:X2=x;
>  1:X3=active;
>  
> }
>  P0                                 | P1                                            ;
>  MOV W0,#1                          | STR X0,[X1]                                   ;
>  STR W0,[X1] (* sme_active_cpus  *) | DSB ISH                                       ;
>  DMB SY                             | LSR X9,X2,#12                                 ;
>  LDR W2,[X3] (* access to [addr] *) | TLBI VAAE1IS,X9 (* [addr] *)                  ;
>                                     | DSB ISH                                       ;
>                                     | LDR W4,[X3]     (* sme_active_cpus *)         ;
> 
> exists ~(1:X4=1 \/ fault(P0,x))
> 
> Is that correct understanding? Have I missed anything?

Yes, I think that's correct. Another tweak specific to this erratum
would be for P1 to do a store to x via another mapping after the
TLBI+DSB and the P0 load should not see it.

Even with the CPU erratum, if the P1 DVMSync is received/acknowledged by
P0 before its STR to sme_active_cpus, I don't see how the subsequent SME
load would overtake the STR given the DMB. The erratum messed up the
DVMSync acknowledgement, not the barriers.

-- 
Catalin
