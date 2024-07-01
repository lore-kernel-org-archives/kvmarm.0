Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60B8416CD07
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 15:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719847957; cv=none; b=ifm0Y0/wGI641tiD83hWWmbAWyGn2o2sQOtwzWNSo6FmpVhUCZafBffV9j6aCXXJ40sWBbK3NPYealvW+EGMbQtT/R3/yGtqyDjORSyX1y21hkwgfPkWJ3EEiuzWidArMn7wRN+/f5xwS5SARw3t374nDOACxoGNnIeHciga9uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719847957; c=relaxed/simple;
	bh=IVhApHVVrqzcpAGm2AOfwPzjOHsiNqREx+i5Ma5rj38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EKf2OvQPHXzeJiHwJAVp7039+ZFYDU4m2hWdKvV3V7pQPREjv7FBa2AI8s4XW25WmamCMVRMo3TU1i/a+GOLEsJM/ICNP7lGuYFFejDo4sjJFRpfEo342DkIUZ+GOwxoBbrQoju6TqhqQEoXXUUUvVAio1oZXwbD0LwWfQaKYek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 79F9B339;
	Mon,  1 Jul 2024 08:32:58 -0700 (PDT)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 670A53F73B;
	Mon,  1 Jul 2024 08:32:30 -0700 (PDT)
Date: Mon, 1 Jul 2024 16:32:25 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, "Rob Herring (Arm)" <robh@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Clark <james.clark@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 06/12] perf: arm_pmu: Remove event index to counter
 remapping
Message-ID: <ZoLMCS6sLUKHXUuU@J2N7QTR9R3>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-6-c9784b4f4065@kernel.org>
 <86ikxuir2k.wl-maz@kernel.org>
 <20240701135216.GD2250@willie-the-truck>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240701135216.GD2250@willie-the-truck>

On Mon, Jul 01, 2024 at 02:52:16PM +0100, Will Deacon wrote:
> On Thu, Jun 27, 2024 at 12:05:23PM +0100, Marc Zyngier wrote:
> > On Wed, 26 Jun 2024 23:32:30 +0100,
> > "Rob Herring (Arm)" <robh@kernel.org> wrote:
> > > 
> > > Xscale and Armv6 PMUs defined the cycle counter at 0 and event counters
> > > starting at 1 and had 1:1 event index to counter numbering. On Armv7 and
> > > later, this changed the cycle counter to 31 and event counters start at
> > > 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> > > and introduced an event index to counter conversion. The conversion uses
> > > masking to convert from event index to a counter number. This operation
> > > relies on having at most 32 counters so that the cycle counter index 0
> > > can be transformed to counter number 31.
> > > 
> > > Armv9.4 adds support for an additional fixed function counter
> > > (instructions) which increases possible counters to more than 32, and
> > > the conversion won't work anymore as a simple subtract and mask. The
> > > primary reason for the translation (other than history) seems to be to
> > > have a contiguous mask of counters 0-N. Keeping that would result in
> > > more complicated index to counter conversions. Instead, store a mask of
> > > available counters rather than just number of events. That provides more
> > > information in addition to the number of events.
> > > 
> > > No (intended) functional changes.
> > > 
> > > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > 
> > [...]
> > 
> > > diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> > > index b3b34f6670cf..e5d6d204beab 100644
> > > --- a/include/linux/perf/arm_pmu.h
> > > +++ b/include/linux/perf/arm_pmu.h
> > > @@ -96,7 +96,7 @@ struct arm_pmu {
> > >  	void		(*stop)(struct arm_pmu *);
> > >  	void		(*reset)(void *);
> > >  	int		(*map_event)(struct perf_event *event);
> > > -	int		num_events;
> > > +	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
> > 
> > I'm slightly worried by this, as this size is never used, let alone
> > checked by the individual drivers. I can perfectly picture some new
> > (non-architectural) PMU driver having more counters than that, and
> > blindly setting bits outside of the allowed range.
> 
> I tend to agree.

It's the same size as other bitmaps and arrays in struct arm_pmu, e.g.
the first two fields:

| struct pmu_hw_events {
|         /*  
|          * The events that are active on the PMU for the given index.
|          */
|         struct perf_event       *events[ARMPMU_MAX_HWEVENTS];
| 
|         /*  
|          * A 1 bit for an index indicates that the counter is being used for
|          * an event. A 0 means that the counter can be used.
|          */
|         DECLARE_BITMAP(used_mask, ARMPMU_MAX_HWEVENTS);

... so IMO it's fine as-is, since anything not bound by
ARMPMU_MAX_HWEVENTS would already be wrong today.

> > One way to make it a bit safer would be to add a helper replacing the
> > various bitmap_set() calls, and enforcing that we never overflow this
> > bitmap.
> 
> Or perhaps wd could leave the 'num_events' field intact and allocate the
> new bitmap dynamically?

I don't think we should allocate the bitmap dynamically, since then we'd
have to do likewise for all the other fields sized by
ARMPMU_MAX_HWEVENTS.

I'm not averse to a check when setting bits in the new cntr_mask (which
I guess would WARN() and not set the bit), but as above I think it's
fine as-is.

Mark.
