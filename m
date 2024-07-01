Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A0071494CE;
	Mon,  1 Jul 2024 13:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719841944; cv=none; b=Bu81+yMSZXnSu9iiU2imsy3wNHuA3n4vYVBqZopoTGyPNhEkApusNKX98BMy/pKqEnXgvda7daHeBCV46xCE0M86HXd6vPbjhcz6WSo+tCzzvJcBwkhj5S30EkWnB8DZFoLa3i8rknMKuB1iwstfX3lsSiGe5VwY9QGUNRd8n3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719841944; c=relaxed/simple;
	bh=9oMe0zzAooHD779ju56VF3sNjUtqOksjJ2v3RCSlPZY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eal47H3Ar+8tRfGHddvYNFpdHipEt9O6ojYPBTBMAiI+RvbzXjYsdE9b4W+EFddwjWh/2FGqTylCUmLdWy/7YMdhgmttaOkOpNEqWt3LClmIQWJ8KiE8u9mCy0EzqeURxFHNIjZlqc5dPpcp0iYX4w0erS4TqH9HQZ6VgIhCHOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QkKnz8Mx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QkKnz8Mx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166F3C116B1;
	Mon,  1 Jul 2024 13:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719841943;
	bh=9oMe0zzAooHD779ju56VF3sNjUtqOksjJ2v3RCSlPZY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QkKnz8Mx4IFgeqCOxqdYy/HO2YOSEqV169/HMVTU2nA/QL8nq5cUM/LhvBQjescmH
	 zCHh+7wgTbNXz5jKetAPn72ivN35ppJMm/lKAHjIlUhbzK1+FHpl7mZOXCgIa7KFOs
	 l+npOy54MWI6MGpBxNaEifvHGAS8BreAs3O34Q4E2S116LwwxWbc6sp48p6ydViSsE
	 CueSmmPL21Ajvlu8200LUqTyhFuMezX7pG5wnP2xBYNLPbO85XbXQfTWN5rCk1w+aK
	 38awLD+hqR9pNRdHIFxBlGhlZ5fpPZ5cq5QhAySrQuY0bjPlo56o2S+/7Dy3VQwEc1
	 cA9GB9f2PC/HA==
Date: Mon, 1 Jul 2024 14:52:16 +0100
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: "Rob Herring (Arm)" <robh@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
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
Message-ID: <20240701135216.GD2250@willie-the-truck>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-6-c9784b4f4065@kernel.org>
 <86ikxuir2k.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ikxuir2k.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Jun 27, 2024 at 12:05:23PM +0100, Marc Zyngier wrote:
> On Wed, 26 Jun 2024 23:32:30 +0100,
> "Rob Herring (Arm)" <robh@kernel.org> wrote:
> > 
> > Xscale and Armv6 PMUs defined the cycle counter at 0 and event counters
> > starting at 1 and had 1:1 event index to counter numbering. On Armv7 and
> > later, this changed the cycle counter to 31 and event counters start at
> > 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> > and introduced an event index to counter conversion. The conversion uses
> > masking to convert from event index to a counter number. This operation
> > relies on having at most 32 counters so that the cycle counter index 0
> > can be transformed to counter number 31.
> > 
> > Armv9.4 adds support for an additional fixed function counter
> > (instructions) which increases possible counters to more than 32, and
> > the conversion won't work anymore as a simple subtract and mask. The
> > primary reason for the translation (other than history) seems to be to
> > have a contiguous mask of counters 0-N. Keeping that would result in
> > more complicated index to counter conversions. Instead, store a mask of
> > available counters rather than just number of events. That provides more
> > information in addition to the number of events.
> > 
> > No (intended) functional changes.
> > 
> > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> 
> [...]
> 
> > diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> > index b3b34f6670cf..e5d6d204beab 100644
> > --- a/include/linux/perf/arm_pmu.h
> > +++ b/include/linux/perf/arm_pmu.h
> > @@ -96,7 +96,7 @@ struct arm_pmu {
> >  	void		(*stop)(struct arm_pmu *);
> >  	void		(*reset)(void *);
> >  	int		(*map_event)(struct perf_event *event);
> > -	int		num_events;
> > +	DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
> 
> I'm slightly worried by this, as this size is never used, let alone
> checked by the individual drivers. I can perfectly picture some new
> (non-architectural) PMU driver having more counters than that, and
> blindly setting bits outside of the allowed range.

I tend to agree.

> One way to make it a bit safer would be to add a helper replacing the
> various bitmap_set() calls, and enforcing that we never overflow this
> bitmap.

Or perhaps wd could leave the 'num_events' field intact and allocate the
new bitmap dynamically?

Rob -- what do you prefer? I think the rest of the series is ready to go.

Will
