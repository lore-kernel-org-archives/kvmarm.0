Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4A63266B40
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 12:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740487101; cv=none; b=vFhJPzNweFVgaYAwfDxnvj+XpoNNG7FjPCXbxEf60AScgpBKvyVKK999prgzdSGFkfbgo0KCwdOA1yd+tENMgO9Ldz1Q8SltZ5RdcdzYISXFPtsCMaDXfcRDMJsDeYFNE12s5cUkLKhnTx9gCE4xoFJYGoRaJXczoYQOwv3YSko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740487101; c=relaxed/simple;
	bh=cJZ5YmdR1SNkMG2yDAirWyRRhI6uMk/du0JqcX+TaQo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bAdKAfB3mDAkz3iK6ORhPH+xIoKXeuuvi8afqLkhYF/Wg6ZFnAp53q1aGcOvReEwGzCc0JdQTW+aoGyHZ/taJTYdHdDR8iZKIBPal2ma0y6RxKP9bROYuvN7JqJhDBH3oFmCajFVg7Lch+cGpfqPz8bR5ExiMQyneimF9GRDoeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3FAB3152B;
	Tue, 25 Feb 2025 04:38:35 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 813053F6A8;
	Tue, 25 Feb 2025 04:38:18 -0800 (PST)
Date: Tue, 25 Feb 2025 12:38:13 +0000
From: Leo Yan <leo.yan@arm.com>
To: Rob Herring <robh@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [PATCH v20 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
Message-ID: <20250225123813.GA1821331@e132581.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com>
 <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
 <20250224180301.GI8144@e132581.arm.com>
 <CAL_JsqKNad6eEBerUOco=SDWxdp6dgRD3FDrSt5OpGQYwwstSg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKNad6eEBerUOco=SDWxdp6dgRD3FDrSt5OpGQYwwstSg@mail.gmail.com>

On Mon, Feb 24, 2025 at 07:31:52PM -0600, Rob Herring wrote:

[...]

> > > > When event rotation happens, if without context switch, in theory we
> > > > should can directly use the branch record (no invalidation, no injection)
> > > > for all events.
> > >
> > > No; that only works in *some* cases, and will produce incorrect results
> > > in others.
> > >
> > > For example, consider filtering. Imagine a PMU with a single counter,
> > > and two events, where event-A filters for calls-and-returns and event-B
> > > filters for calls-only. When switching from event-A to event-B, it's
> > > theoretically possible to keep the existing records around, knowing that
> > > the returns can be filtered out later. When switching from event-B to
> > > event-A we cannot keep the existing records, since there are gaps
> > > whenever a return should have been recorded.
> >
> > Seems to me, the problem is not caused by event rotation.  We need to
> > calculate a correct filter in the first place - the BRBE driver should
> > calculate a superset for all filters of events for a session.  Then,
> > generate branch record based event's specific filter.
> 
> The driver doesn't have enough information. If it is told to schedule
> event A, it doesn't know anything about event B. It could in theory
> try to remember event B if event B had already been scheduled, but it
> never knows when event B is gone.

E.g., I tried below command for enabling 10 events in a perf session:

  perf record -e armv9_nevis/r04/ -e armv9_nevis/r05/ \
              -e armv9_nevis/r06/ -e armv9_nevis/r07/ \
              -e armv9_nevis/r08/ -e armv9_nevis/r09/ \
              -e armv9_nevis/r10/ -e armv9_nevis/r11/ \
              -e armv9_nevis/r12/ -e armv9_nevis/r13/ \
              -- sleep 1

For Arm PMU, the flow below is invoked for every event on every
affinied CPU in initialization phase:

  armpmu_event_init() {
    armv8pmu_set_event_filter();
  }

Shouldn't we calculate a superset branch filter for all events, store
it into a per-CPU data structure and then apply the filter on BRBE?

> > > There are a number of cases of that shape given the set of configurable
> > > filters. In theory it's possible to retain those in some cases, but I
> > > don't think that the complexity is justified.
> > >
> > > Similarly, whenever kernel branches are recorded it's necessary to drop
> > > the stale branches whenever branch recording is paused, as there's
> > > necessarily a blackout period and hence a gap in the records.
> >
> > If we save BRBE record when a process is switched out and then restore
> > the record when a process is switched in, should we can keep a decent
> > branch record for performance profiling?
> 
> Keep in mind that there's only 64 branches recorded at most. How many
> branches in a context switch plus reconfiguring the PMU? Not a small
> percentage of 64 I think. In traces where freeze on overflow was not
> working (there's an example in v18), just the interrupt entry until
> BRBE was stopped was a significant part of the trace. A context switch
> is going to be similar.

That is true for kernel mode enabled tracing.  But we will have no
such kind noises for userspace only mode tracing.

[...]

> > > Do you have a reason why you think we *must* keep events around?
> >
> > Here I am really concerned are cases when a process is preempted or
> > migrated.  The driver doesn't save and restore branch records for these
> > cases, it just invalidates all records when a task is scheduled in.
> >
> > As a result, if an event overflow is close to context switch, it is
> > likely to capture incomplete branch records.  For a userspace-only
> > tracing, it is risk to capture empty branch record after preemption
> > and migrations.
> 
> There's the same risk if something else is recording kernel branches
> when you are recording userspace only. I think the user has to be
> aware if other things like context switches are perturbing their data.

I am confused for the decription above.  Does it refer to branch
recording cross different sessions?  It is fine for me that the branch
data is interleaved by different sessions (e.g. one is global tracing
and another is only per-thread tracing).

We might need to consider an intact branch record for the single perf
session case.  E.g. if userspace program calls:

    func_a -> func_b -> func_c

In a case for only userspace tracing, we will have no chance to preserve
the call sequence of these functions after the program is switched out.

Thanks,
Leo
