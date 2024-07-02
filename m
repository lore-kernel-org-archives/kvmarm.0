Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF561BBBD7;
	Tue,  2 Jul 2024 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719937188; cv=none; b=qJ4en0Sm/zhM1Qbiqk/0q6li55/n+vWS4/rQXdMmtX3ji4X1VpX4Fd+mO/cvLhl50JqxEnBwo5Ea5ivvoGFuiy1BaeU+ihO9tMMMlwUENKTA/8phbrionapytjSLXgJbxCNwpxMJ+dXa85F88YXdytOEz1uJYn0b5Ixk3UfqHac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719937188; c=relaxed/simple;
	bh=lVQmHI+LCB+7I2btTVAeudIE1E/R0zerK0QF7WkCDJg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ozOtPu5sbNM21XrUUesTwAmOqjvwCYiE/7lP3qAhYlwdAd+A8cOzVq0GY811QOCiOcn8n8v6jh9WE+hK4aTDZAUwnbg5h5Oa4tDDe2zH41DAfviCMV9+7MYVtLlsVJOJKIQIV+jsIsBnc5LPy6hZq7XWSHEABxW2FfVT7VxqYXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KFZN/teI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KFZN/teI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6965C116B1;
	Tue,  2 Jul 2024 16:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719937187;
	bh=lVQmHI+LCB+7I2btTVAeudIE1E/R0zerK0QF7WkCDJg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KFZN/teI9CkmW0iOWqSmXr/ZYdGvy+z/jP2qp+ujTEwwY4xzOjGY3b15+KbrRXlQ4
	 +Cxy33ZcFI90gE+8LtOphor/Iqn3TU6pCQ7ojazeBHMFkhxWasd2Bts5Ty7i75LSnu
	 +1LfDYpniU+5H+dDLj14xL+K26hfYqjNgipBlMEOoOFfdg01Cv8+ORHoDGs4+Pm1dg
	 cC2P+1KG5KIgkezBQLiR98sJ15yvnPB7hgK92wvYXZItkgfsYvNuYz7RAZH9XP4UdK
	 HjCRxp4GoLEGcnaZM2GrSN3SWHBQfkqAxEF8EhVitwV4QocRoS9UukgANWfn0m7eA0
	 hKssnf0roWL6g==
Date: Tue, 2 Jul 2024 17:19:40 +0100
From: Will Deacon <will@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>,
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
Message-ID: <20240702161940.GA4460@willie-the-truck>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-6-c9784b4f4065@kernel.org>
 <86ikxuir2k.wl-maz@kernel.org>
 <20240701135216.GD2250@willie-the-truck>
 <CAL_JsqKYstLZQy_VQTvg-285jj1mpH+4d9CVJ_1_iAus5_rTRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAL_JsqKYstLZQy_VQTvg-285jj1mpH+4d9CVJ_1_iAus5_rTRA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jul 01, 2024 at 09:49:29AM -0600, Rob Herring wrote:
> On Mon, Jul 1, 2024 at 7:52 AM Will Deacon <will@kernel.org> wrote:
> >
> > On Thu, Jun 27, 2024 at 12:05:23PM +0100, Marc Zyngier wrote:
> > > On Wed, 26 Jun 2024 23:32:30 +0100,
> > > "Rob Herring (Arm)" <robh@kernel.org> wrote:
> > > >
> > > > Xscale and Armv6 PMUs defined the cycle counter at 0 and event counters
> > > > starting at 1 and had 1:1 event index to counter numbering. On Armv7 and
> > > > later, this changed the cycle counter to 31 and event counters start at
> > > > 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> > > > and introduced an event index to counter conversion. The conversion uses
> > > > masking to convert from event index to a counter number. This operation
> > > > relies on having at most 32 counters so that the cycle counter index 0
> > > > can be transformed to counter number 31.
> > > >
> > > > Armv9.4 adds support for an additional fixed function counter
> > > > (instructions) which increases possible counters to more than 32, and
> > > > the conversion won't work anymore as a simple subtract and mask. The
> > > > primary reason for the translation (other than history) seems to be to
> > > > have a contiguous mask of counters 0-N. Keeping that would result in
> > > > more complicated index to counter conversions. Instead, store a mask of
> > > > available counters rather than just number of events. That provides more
> > > > information in addition to the number of events.
> > > >
> > > > No (intended) functional changes.
> > > >
> > > > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > >
> > > [...]
> > >
> > > > diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
> > > > index b3b34f6670cf..e5d6d204beab 100644
> > > > --- a/include/linux/perf/arm_pmu.h
> > > > +++ b/include/linux/perf/arm_pmu.h
> > > > @@ -96,7 +96,7 @@ struct arm_pmu {
> > > >     void            (*stop)(struct arm_pmu *);
> > > >     void            (*reset)(void *);
> > > >     int             (*map_event)(struct perf_event *event);
> > > > -   int             num_events;
> > > > +   DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
> > >
> > > I'm slightly worried by this, as this size is never used, let alone
> > > checked by the individual drivers. I can perfectly picture some new
> > > (non-architectural) PMU driver having more counters than that, and
> > > blindly setting bits outside of the allowed range.
> >
> > I tend to agree.
> >
> > > One way to make it a bit safer would be to add a helper replacing the
> > > various bitmap_set() calls, and enforcing that we never overflow this
> > > bitmap.
> >
> > Or perhaps wd could leave the 'num_events' field intact and allocate the
> > new bitmap dynamically?
> >
> > Rob -- what do you prefer? I think the rest of the series is ready to go.
> 
> I think the list of places we're initializing cntr_mask is short
> enough to check and additions to arm_pmu users are rare enough I would
> not be too worried about it.
> 
> If anything, I think the issue is with the bitmap API in that it has
> no bounds checking. I'm sure it will get on someone's radar to fix at
> some point.
> 
> But if we want to have something check, this is what I have:
> 
> static inline void armpmu_set_counter_mask(struct arm_pmu *pmu,
>                                           unsigned int start, unsigned int nr)
> {
>        if (WARN_ON(start + nr > ARMPMU_MAX_HWEVENTS))
>                return;
>        bitmap_set(pmu->cntr_mask, start, nr);
> }

Fair enough, for the sake of consistency, let's leave the series as-is
and we can add helpers for all the counter-bound structures later, if we
want to.

Will
