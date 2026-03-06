Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE79E35F160
	for <kvmarm@lists.linux.dev>; Fri,  6 Mar 2026 12:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772798436; cv=none; b=oRanKVdZ2dEC5R7bDt2uIeHPJ/uDSdirHYwaqScHIuAX5HwgEVXWvEPqSAHWw5a8Smw349cAnH6IplMCRsWc+Cx/aU7xFzwE2MM9XCgHfcSVt261IHfC23HB5ejBSXsIL15vA/hcZALuMa5pB0hG3eNSGZNg+ZTrtCOlN3p25cc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772798436; c=relaxed/simple;
	bh=4I6zSgTurPfSiAJqdPmkFwFesmMAvdtlCKVqTkH0f+Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lHxKKy2z9TfmsTXStL5LDqEkqlLCG62deUqPjjsX1cE7v/8Veg/c/6auvI0y0jPEV1SIypNK/QfpC6hHxYQq3zNnPEuoGTjgf/+w4boDhSJYSz8hIBhxJ1v33eAMZXtAIfbnN6eiowxqH/pElVJh/Y/hibTqYC8sg9n7W3HhweU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A71B1655;
	Fri,  6 Mar 2026 04:00:28 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B16D53F836;
	Fri,  6 Mar 2026 04:00:32 -0800 (PST)
Date: Fri, 6 Mar 2026 12:00:30 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Sudeep Holla <sudeep.holla@kernel.org>,
	James Morse <james.morse@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/4] arm64: errata: Work around early CME DVMSync
 acknowledgement
Message-ID: <aarB3iv8963UDn5E@arm.com>
References: <20260302165801.3014607-1-catalin.marinas@arm.com>
 <20260302165801.3014607-4-catalin.marinas@arm.com>
 <aamT6-Mvr9nI1unq@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aamT6-Mvr9nI1unq@willie-the-truck>

On Thu, Mar 05, 2026 at 02:32:11PM +0000, Will Deacon wrote:
> On Mon, Mar 02, 2026 at 04:57:56PM +0000, Catalin Marinas wrote:
> > C1-Pro acknowledges DVMSync messages before completing the SME/CME
> > memory accesses. Work around this by issuing an IPI+DSB to the affected
> > CPUs if they are running in EL0 with SME enabled.
> 
> Just to make sure I understand the implications, but this _only_ applies
> to explicit memory accesses from the SME unit and not, for example, to
> page-table walks initiated by SME instructions?

Yes, only explicit accesses from the SME unit (CME).

> > @@ -575,6 +576,14 @@ static const struct midr_range erratum_spec_ssbs_list[] = {
> >  };
> >  #endif
> >  
> > +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> > +static void cpu_enable_sme_dvmsync(const struct arm64_cpu_capabilities *__unused)
> > +{
> > +	if (this_cpu_has_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> > +		sme_enable_dvmsync();
> > +}
> > +#endif
> > +
> >  #ifdef CONFIG_AMPERE_ERRATUM_AC03_CPU_38
> >  static const struct midr_range erratum_ac03_cpu_38_list[] = {
> >  	MIDR_ALL_VERSIONS(MIDR_AMPERE1),
> > @@ -901,6 +910,16 @@ const struct arm64_cpu_capabilities arm64_errata[] = {
> >  		.matches = need_arm_si_l1_workaround_4311569,
> >  	},
> >  #endif
> > +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> > +	{
> > +		.desc = "C1-Pro SME DVMSync early acknowledgement",
> > +		.capability = ARM64_WORKAROUND_SME_DVMSYNC,
> > +		.cpu_enable = cpu_enable_sme_dvmsync,
> > +		/* C1-Pro r0p0 - r1p2 (the latter only when REVIDR_EL1[0]==0 */
> > +		ERRATA_MIDR_RANGE(MIDR_C1_PRO, 0, 0, 1, 2),
> > +		MIDR_FIXED(MIDR_CPU_VAR_REV(1, 2), BIT(0)),
> > +	},
> > +#endif
> 
> An alternative to this workaround is just to disable SME entirely, perhaps
> by passing 'arm64.nosme' on the cmdline. Maybe we should disable the
> workaround in that case?

Good point, the workaround isn't necessary if the SME is off. I can add
an extra check, though given that no-one would run in user-space with
TIF_SME, the overhead is only in the sme_active_cpus mask checking.

> > @@ -1358,6 +1360,85 @@ void do_sve_acc(unsigned long esr, struct pt_regs *regs)
> >  	put_cpu_fpsimd_context();
> >  }
> >  
> > +#ifdef CONFIG_ARM64_ERRATUM_SME_DVMSYNC
> > +
> > +/*
> > + * SME/CME erratum handling
> > + */
> > +static cpumask_var_t sme_dvmsync_cpus;
> > +static cpumask_var_t sme_active_cpus;
> > +
> > +void sme_set_active(unsigned int cpu)
> > +{
> > +	if (!cpus_have_final_cap(ARM64_WORKAROUND_SME_DVMSYNC))
> > +		return;
> > +	if (!cpumask_test_cpu(cpu, sme_dvmsync_cpus))
> > +		return;
> > +
> > +	if (!test_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags))
> > +		set_bit(ilog2(MMCF_SME_DVMSYNC), &current->mm->context.flags);
> > +
> > +	cpumask_set_cpu(cpu, sme_active_cpus);
> > +
> > +	/*
> > +	 * Ensure subsequent (SME) memory accesses are observed after the
> > +	 * cpumask and the MMCF_SME_DVMSYNC flag setting.
> > +	 */
> > +	smp_mb();
> 
> I can't convince myself that a DMB is enough here, as the whole issue
> is that the SME memory accesses can be observed _after_ the TLB
> invalidation. I'd have thought we'd need a DSB to ensure that the flag
> updates are visible before the exception return.

This is only to ensure that the sme_active_cpus mask is observed before
any SME accesses. The mask is later used to decide whether to send the
IPI. We have something like this:

P0
	STSET	[sme_active_cpus]
	DMB
	SME access to [addr]

P1
	TLBI	[addr]
	DSB
	LDR	[sme_active_cpus]
	CBZ	out
	Do IPI
out:

If P1 did not observe the STSET to [sme_active_cpus], P0 should have
received and acknowledged the DVMSync before the STSET. Is your concern
that P1 can observe the subsequent SME access but not the STSET?

No idea whether herd can model this (I only put this in TLA+ for the
main logic check but it doesn't do subtle memory ordering).

> > +void sme_do_dvmsync(void)
> > +{
> > +	/*
> > +	 * This is called from the TLB maintenance functions after the DSB ISH
> > +	 * to send hardware DVMSync message. If this CPU sees the mask as
> > +	 * empty, the remote CPU executing sme_set_active() would have seen
> > +	 * the DVMSync and no IPI required.
> > +	 */
> > +	if (cpumask_empty(sme_active_cpus))
> > +		return;
> > +
> > +	preempt_disable();
> > +	smp_call_function_many(sme_active_cpus, sme_dvmsync_ipi, NULL, true);
> > +	preempt_enable();
> > +}
> 
> Why do we care about all CPUs using SME, rather than limiting it to the
> set of CPUs using SME with the mm we've invalidated? This looks like it
> will result in unnecessary cross-calls when multiple tasks are using SME
> (especially as the mm flag is only cleared on fork).

Yes, it's a possibility but I traded it for simplicity. We also have the
TTU case where we don't have an mm and we don't want to broadcast to all
CPUs either, hence an sme_active_cpus mask. As I just replied on patch
2, for the TLB batching we wouldn't be able to use a cpumask in the
batching structure since, per the ordering above, we need the DVMSync
before checking if/where to send the IPI to.

For the typical TLBI (not TTU), we can track a per-mm mask passed down
to this function (I have patches doing this but it didn't make a
significant difference in benchmarks). However, for upstream we may want
to use mm_cpumask() for something else in the future (FEAT_TLBID; work
in progress), so we should probably add a different mask. Well, C1-Pro
doesn't support FEAT_TLBID, so we could disable the workaround and use
the same mm_cpumask(); it just gets messier.

We can keep the sme_active_cpus for the TTU case and easily add a
cpumask for the other TLBI cases where we have the mm. Is it worth it? I
don't think so if the only SME apps are some benchmarks ;).

(for the Android backports I did not want to break KMI by expanding
kernel data structures; of course, not a concern for mainline but the
only users of this workaround are likely to be using GKI than upstream)

-- 
Catalin
