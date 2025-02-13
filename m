Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3143B156237
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 17:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739468737; cv=none; b=s88xKOU8JNZn9S51wk8zZ319klsom3bnAKjMybnJY+lrwCH/hNh/VKO4HCUhBGdJqCOPbRjP/oLDM1XF2ndl867Q8MjD9yMkYR+kM10ujpk73phgvvMSCMVAnN20/Q7SS1j90c2G/Puv//h20lFzojh4gdDK/eIxEVJiXS9BbyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739468737; c=relaxed/simple;
	bh=sukV6k51DNSlBKIQdTonT1QfJeZstAGnIOitdYPlDMw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DG1aEljg5AkcfuMxtfPjDOekprq3QVtfm+Rr4PqPA/Em7COYbkE0QcJglSiZxMa9DNLga2uQXROcB6cu2dUw7sBr+k+HKpIpXiy5ULgQaIaJN9icRUMtyrsPmfgzB7zxXE3mmdv9mnelBsHcuXZ1m/lapLYXPq9PcH4fGkPZYOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1C1FC113E;
	Thu, 13 Feb 2025 09:45:56 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 17F2A3F5A1;
	Thu, 13 Feb 2025 09:45:34 -0800 (PST)
Date: Thu, 13 Feb 2025 17:45:30 +0000
From: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	James Clark <james.clark@linaro.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250213174530.GH235556@e132581.arm.com>
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org>
 <20250213161628.GF235556@e132581.arm.com>
 <CAL_Jsq+VmfibMVdh+9DxqU5Axiv_zMiznAh8_umFB1J2y8reig@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+VmfibMVdh+9DxqU5Axiv_zMiznAh8_umFB1J2y8reig@mail.gmail.com>

On Thu, Feb 13, 2025 at 11:13:49AM -0600, Rob Herring wrote:

[...]

> > > +void brbe_enable(const struct arm_pmu *arm_pmu)
> > > +{
> > > +       struct pmu_hw_events *cpuc = this_cpu_ptr(arm_pmu->hw_events);
> > > +       u64 brbfcr = 0, brbcr = 0;
> > > +
> > > +       /*
> > > +        * Merge the permitted branch filters of all events.
> > > +        */
> > > +       for (int i = 0; i < ARMPMU_MAX_HWEVENTS; i++) {
> > > +               struct perf_event *event = cpuc->events[i];
> > > +
> > > +               if (event && has_branch_stack(event)) {
> > > +                       brbfcr |= event->hw.branch_reg.config;
> > > +                       brbcr |= event->hw.extra_reg.config;
> > > +               }
> > > +       }
> > > +
> > > +       /*
> > > +        * If the record buffer contains any branches, we've already read them
> > > +        * out and don't want to read them again.
> > > +        * No need to sync as we're already stopped.
> > > +        */
> > > +       brbe_invalidate_nosync();
> > > +       isb(); // Make sure invalidate takes effect before enabling
> > > +
> > > +       /*
> > > +        * In VHE mode with MDCR_EL2.HPMN set to PMCR_EL0.N, the counters are
> > > +        * controlled by BRBCR_EL1 rather than BRBCR_EL2 (which writes to
> > > +        * BRBCR_EL1 are redirected to). Use the same value for both register
> > > +        * except keep EL1 and EL0 recording disabled in guests.
> > > +        */
> > > +       if (is_kernel_in_hyp_mode())
> > > +               write_sysreg_s(brbcr & ~(BRBCR_ELx_ExBRE | BRBCR_ELx_E0BRE), SYS_BRBCR_EL12);
> > > +       write_sysreg_s(brbcr, SYS_BRBCR_EL1);
> > > +       isb(); // Ensure BRBCR_ELx settings take effect before unpausing
> > > +
> > > +       write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
> >
> > Seems to me, it is weird that first enable recording (BRBCR), then set
> > control register BRBFCR.  And the writing SYS_BRBFCR_EL1 not guarded
> > by a barrier is also a bit concerned.
> 
> We are always disabled (paused) when we enter brbe_enable(). So the
> last thing we do is unpause. The only ordering we care about after
> writing SYS_BRBFCR_EL1 is writing PMCR which has an isb before it is
> written.

Maybe it is good to add a comment to record the info.

Thanks,
Leo
