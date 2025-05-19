Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B4B211A3C;
	Mon, 19 May 2025 21:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747691815; cv=none; b=RTDrj3PRhFJE28JPvEY0EdjAQxqWHtrkf1Jho2cu406JqsnXN9UWyVw3kkwrxiy1JLPx565ZbTj/g0TUVjAvJt8DFaRWz4oTtyLL77iMsjt21HIoWhOJIEYWkPipBUJF8sWnd9MpjAPc53F2fdeqsnA5OmGlbaXtawwyJyY9GTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747691815; c=relaxed/simple;
	bh=G/udjNOlZf5UZB0lntyyPqplVnxx+IfVlpycxwLSers=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mqH9KUl4d8T+CA1437T4xxELMxL92t9Nlwy9S1S1DYDtE6R8k+92Q8GDUrpW7wAXL2RTWryhRcP0YF+9zaOAPlErCPmvoWtz4lYfwSENoTa55J1IJqdHkmkD9Akc5wCPjpvAJNZ21DS2zj3R3i/191KRTx4E3SE4hoJaPPwEsEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nu7elZZO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nu7elZZO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6853C4CEE4;
	Mon, 19 May 2025 21:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747691813;
	bh=G/udjNOlZf5UZB0lntyyPqplVnxx+IfVlpycxwLSers=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nu7elZZO8YqPcuNtMtp5sqtcZInfD7DMrpPlmrSWymeWoZDVi8ldUf3dIg1UbBQGA
	 L3ctZKe1k5K6Rj8aZhmnWFijoqZ8XQ5NgZz7EchEHAaCx2N97S+QH+j2uxryCz7ca+
	 lrBbBeSw/rge4wYpIS2ETtVm8QVLMpMvzVprpwR9rEKbc6bKKZxJnHXnIc4kXFq+Ec
	 WykFkcGPTa6bmMM/Y5n9ssDikJ2HErrqV7ZEJYbRgOMrN7RomlXhxLcUR0e/9Z5KdJ
	 0XN6xz6yCWTEmgWZ0uzrrK0P2gi/ZXa+XB2j39ezM5be++R0hjGS0wy7wF92/wPTbU
	 i9rKjkEVOsXbQ==
Date: Mon, 19 May 2025 16:56:51 -0500
From: Rob Herring <robh@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Leo Yan <leo.yan@arm.com>, linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v21 4/4] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250519215651.GB2650608-robh@kernel.org>
References: <20250407-arm-brbe-v19-v21-0-ff187ff6c928@kernel.org>
 <20250407-arm-brbe-v19-v21-4-ff187ff6c928@kernel.org>
 <20250519150621.GA17177@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250519150621.GA17177@willie-the-truck>

On Mon, May 19, 2025 at 04:06:22PM +0100, Will Deacon wrote:
> Hey Rob,
> 
> On Mon, Apr 07, 2025 at 12:41:33PM -0500, Rob Herring (Arm) wrote:
> > From: Anshuman Khandual <anshuman.khandual@arm.com>
> > 
> > The ARMv9.2 architecture introduces the optional Branch Record Buffer
> > Extension (BRBE), which records information about branches as they are
> > executed into set of branch record registers. BRBE is similar to x86's
> > Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> > (BHRB).
> 
> Since you picked this up from v19, the driver has changed considerably
> and I presume you will be continuing to extend it in future as the
> architecture progresses. Perhaps having you listed as Author (and
> crucially, in git blame :p) with Anshuman as a Co-developed-by: would be
> more appropriate?

Shrug.

> > ---
> >  drivers/perf/Kconfig         |  11 +
> >  drivers/perf/Makefile        |   1 +
> >  drivers/perf/arm_brbe.c      | 802 +++++++++++++++++++++++++++++++++++++++++++
> >  drivers/perf/arm_brbe.h      |  47 +++
> >  drivers/perf/arm_pmu.c       |  15 +-
> >  drivers/perf/arm_pmuv3.c     | 129 ++++++-
> >  include/linux/perf/arm_pmu.h |   8 +
> >  7 files changed, 1006 insertions(+), 7 deletions(-)
> 
> Do you know if James Clark's tests [1] are going to be respun for the
> perf tool? It would be handy to have some way to test this new
> functionality.

Yes. I dropped them here because I've been told by Arnaldo in the past 
to send userspace stuff separately.

> > diff --git a/drivers/perf/Kconfig b/drivers/perf/Kconfig
> > index 4e268de351c4..3be60ff4236d 100644
> > --- a/drivers/perf/Kconfig
> > +++ b/drivers/perf/Kconfig
> > @@ -223,6 +223,17 @@ config ARM_SPE_PMU
> >  	  Extension, which provides periodic sampling of operations in
> >  	  the CPU pipeline and reports this via the perf AUX interface.
> >  
> > +config ARM64_BRBE
> > +	bool "Enable support for branch stack sampling using FEAT_BRBE"
> > +	depends on ARM_PMUV3 && ARM64
> > +	default y
> > +	help
> > +	  Enable perf support for Branch Record Buffer Extension (BRBE) which
> > +	  records all branches taken in an execution path. This supports some
> > +	  branch types and privilege based filtering. It captures additional
> > +	  relevant information such as cycle count, misprediction and branch
> > +	  type, branch privilege level etc.
> 
> It's a shame that this can't be modular, but I suppose the tight
> integration with the CPU PMU driver precludes that. Oh well.
> 
> > diff --git a/drivers/perf/arm_brbe.c b/drivers/perf/arm_brbe.c
> > new file mode 100644
> > index 000000000000..2f254bd40af3
> > --- /dev/null
> > +++ b/drivers/perf/arm_brbe.c
> 
> (The driver code looks fine to me but I'd like an Ack from Mark on the
> UAPI).
> 
> > diff --git a/drivers/perf/arm_pmu.c b/drivers/perf/arm_pmu.c
> > index 2f33e69a8caf..df9867c0dc57 100644
> > --- a/drivers/perf/arm_pmu.c
> > +++ b/drivers/perf/arm_pmu.c
> > @@ -99,7 +99,7 @@ static const struct pmu_irq_ops percpu_pmunmi_ops = {
> >  	.free_pmuirq = armpmu_free_percpu_pmunmi
> >  };
> >  
> > -static DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
> > +DEFINE_PER_CPU(struct arm_pmu *, cpu_armpmu);
> >  static DEFINE_PER_CPU(int, cpu_irq);
> >  static DEFINE_PER_CPU(const struct pmu_irq_ops *, cpu_irq_ops);
> >  
> > @@ -317,6 +317,11 @@ armpmu_del(struct perf_event *event, int flags)
> >  	struct hw_perf_event *hwc = &event->hw;
> >  	int idx = hwc->idx;
> >  
> > +	if (has_branch_stack(event)) {
> > +		hw_events->branch_users--;
> > +		perf_sched_cb_dec(event->pmu);
> > +	}
> 
> Shouldn't we decrement this *after* calling armpmu_stop()?

Logically, that would make more sense. It's all serialized by the perf 
core though, so we can't get .sched_task() during this.

> > +
> >  	armpmu_stop(event, PERF_EF_UPDATE);
> >  	hw_events->events[idx] = NULL;
> >  	armpmu->clear_event_idx(hw_events, event);
> 
> [...]
> 
> > +static int branch_records_alloc(struct arm_pmu *armpmu)
> > +{
> > +	struct perf_branch_stack *branch_stack_cpu;
> > +	struct perf_branch_stack __percpu *branch_stack;
> > +	size_t size = struct_size(branch_stack_cpu, entries, brbe_num_branch_records(armpmu));
> > +	int cpu;
> > +
> > +	branch_stack = __alloc_percpu_gfp(size, __alignof__(*branch_stack_cpu),
> > +					  GFP_KERNEL);
> > +	if (!branch_stack)
> > +		return -ENOMEM;
> > +
> > +	for_each_possible_cpu(cpu) {
> > +		struct pmu_hw_events *events_cpu;
> > +
> > +		events_cpu = per_cpu_ptr(armpmu->hw_events, cpu);
> > +		branch_stack_cpu = per_cpu_ptr(branch_stack, cpu);
> > +		events_cpu->branch_stack = branch_stack_cpu;
> > +	}
> > +	return 0;
> >  }
> 
> How does this work in a heterogeneous system? Shouldn't we at least
> scope the allocation to the CPUs associated with this PMU?

Leaks memory, that's how.

As a bonus, it could overrun some memory too if the record sizes are 
different though mostly overrunning into other BRBE buffers...

I think we just need to loop over cpu_pmu->supported_cpus and call 
kmalloc(). Since events_cpu is already percpu, we don't need a percpu 
allocation of the branch stack buffers.

I'm assuming it is safe to assume all CPUs either have BRBE or they 
don't? Different record sizes at least should work fine (other than the 
above issue). 

BTW, I was scratching my head how armpmu_alloc() works with 
for_each_possible_cpu(), but I guess the hotplug callbacks overwrite the 
events->percpu_pmu value. I think we could just remove the loop there. 
I'll investigate that.

Rob
