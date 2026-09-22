Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3549E3F8891;
	Tue, 22 Sep 2026 07:13:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790061197; cv=none; b=kXbVy0lawFk80XTqLb2v5yryNLuW4VVBfctQEvW85QDI8aMt5gu8LDFrSN1JaEkYHbdXgUCGT/4FQLtQyJ3ZkRXSp55LnyJb+3HsdKPRCoFkTpGwcBoz90SVcWMlt7BXywDMSAsVIaAppb6561lMWUFRZThv0ARjqdLCrCW5YZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790061197; c=relaxed/simple;
	bh=mlayVz0V7aPD2wE6PbmbnCpG4oHkQsLETp4hup0nDgM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f84q3M7d1uMU40wh34ROGO/j2swKSV8YqHrMnnBijTuAdcPCn+8hlUt7HbntRAoA2CgiBuIdpa7XpQs8hXB0XsOEjw+QoEYWorN17nUHVGXeoNJCIFcdNe2hiFJTVm7MR3CDOLduYnEhqBEohtcnbYbCLo6EZ5x7HSdT+WunWs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P+7JvEYj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P+7JvEYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C751F000FF;
	Tue, 22 Sep 2026 07:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790061195;
	bh=sRwTrkid3uQM5FeM0Pz4CL0alnduswwIJiSRU5wvFwY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P+7JvEYjJtG1vXB90kpFEVo51kIY0xbJDUSYDbyIT/lHqm/Fw+upJ83czHVjjOe4S
	 kIfMiu2fPRhLRlnRvt2Na5/2d3DrdhzpBbuUOQUQgUdE8yEkYCYlsyfuCnP7DCMG7l
	 cPV+JcRvArYJxcjgsjAh9l0nmBTyeQxLMqfVd3d7Cp1Al1ZlDrc7N2/pnxQGagzD52
	 RDUDGEVspXpvzvbsg3que7RkhUOPR5gOe9hpaT64JhbC9wxnki4OPkXJNwJbn91K5M
	 ZlAg72YdESsyBms8xEi/ceRkBOG+/yTtHP9fCmpFRGQ3PA2dt61R4PvsI8fgZBC7Re
	 MVw+Am7F96Hng==
Date: Tue, 22 Sep 2026 00:13:14 -0700
From: Oliver Upton <oupton@kernel.org>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Cc: sashiko-reviews@lists.linux.dev, kvm@vger.kernel.org,
	Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Subject: Re: [PATCH v11 19/21] KVM: arm64: PMU: Implement fixed-counters-only
 emulation
Message-ID: <arIqigtOgVjQlaSG@kernel.org>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920-hybrid-v11-19-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
 <20260920114038.06BFF1F000FF@smtp.kernel.org>
 <0d065881-3d12-4750-973d-5ff6f3e10a91@rsg.ci.i.u-tokyo.ac.jp>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d065881-3d12-4750-973d-5ff6f3e10a91@rsg.ci.i.u-tokyo.ac.jp>

On Tue, Sep 22, 2026 at 02:59:04PM +0900, Akihiko Odaki wrote:
> On 2026/09/20 20:40, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> > - [High] kvm: arm64: PMU: host DoS via unprivileged user triggering TAINT_CPU_OUT_OF_SPEC
> > --
> > 
> > commit d0f716fd067877dc7eca2170bb877659746aae89
> > Author: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
> > KVM: arm64: PMU: Implement fixed-counters-only emulation
> > 
> > This commit adds a PMUv3 emulation mode that exposes only fixed event
> > counters to the guest. It recreates the underlying host perf event dynamically
> > if the vCPU thread migrates to a different physical CPU. If the destination
> > CPU lacks a registered PMU implementation, it warns and adds a kernel taint.
> > 
> > > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > > --- a/arch/arm64/kvm/pmu-emul.c
> > > +++ b/arch/arm64/kvm/pmu-emul.c
> > [ ... ]
> > > @@ -811,6 +812,32 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
> > >   	pmc->perf_event = event;
> > >   }
> > > +/**
> > > + * kvm_pmu_create_perf_event - create a perf event for a counter
> > > + * @pmc: Counter context
> > > + */
> > > +static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc)
> > > +{
> > > +	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
> > > +	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
> > > +
> > > +	if (kvm_pmu_fixed_counters_only(vcpu->kvm)) {
> > > +		do {
> > > +			arm_pmu = kvm_pmu_probe_armpmu(READ_ONCE(vcpu->cpu));
> > > +
> > > +			if (!arm_pmu) {
> > > +				pr_warn_once("kvm: Unsupported PMU variation detected.\n");
> > > +				add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK);
> > 
> > [Severity: High]
> > Can this allow an unprivileged user to intentionally crash the host?
> > 
> > An unprivileged user could create a VM with fixed-counters-only enabled,
> > and then use sched_setaffinity to force the vCPU thread to migrate
> > to a physical CPU that does not have a probed PMU (like an asymmetric core or
> > late-added CPU).
> > 
> > When the vCPU runs, kvm_pmu_create_perf_event() will detect the missing
> > PMU and call add_taint(TAINT_CPU_OUT_OF_SPEC, LOCKDEP_STILL_OK). If the host
> > is configured with panic_on_taint enabled, this triggers a direct kernel
> > panic.
> > 
> > Is there a way to return an error to userspace instead of adding a taint
> > based on user-controlled thread affinity?
> 
> The commit message currently says:
> 
> > Registered pPMUs must cover every CPU on which fixed-counters-only
> > emulation runs.
> 
> This wording may suggest that partial PMU coverage is supported, with
> userspace responsible for keeping vCPUs on covered CPUs. Under that
> interpretation, returning an error so userspace can adjust affinity
> would make sense.
> 
> The intended requirement, however, is that registered pPMUs cover every
> CPU. We do not intend to add complexity to either KVM or userspace to
> support partial coverage. The taint indicates an unsupported host
> configuration.
> 
> If another revision is needed, I will remove "on which
> fixed-counters-only emulation runs" to make that requirement explicit.
> 
> I believe all other concerns raised by reviewers and Sashiko have now
> been addressed.

Yeah, folks that use panic_on_warn and panic_on_taint get to suffer the
consequences. So please ignore the Sashiko feedback here.

Thanks,
Oliver
