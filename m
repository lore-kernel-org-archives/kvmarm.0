Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CAC1DC9BB
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 19:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740512820; cv=none; b=E64W+4OvYk9X5AfcV14NveQlbiZNPFSupJEGWLZgHxffoDLAzWmmNg7a5uxh1fR7Jaj3N7Pkgxkg3Lt7xBnstqQjZQBBC2CL/DsShXhIAdtjFhNUQa8D6Z1Ijf4/96FnTZihDQ8Q298u8PZy+2P218y3iVmGLmO2NBjwrL0UXpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740512820; c=relaxed/simple;
	bh=Yzp6lKg+7SjzmD6dfCLSBo9k8WYw3TmI0cYZCPNUKn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LAQx0WVU+yob1lyR5qo3j2wKiViHK2CP+mP3BEJh065W6kosYryYFPx4al+fKHNOu+TchjPCDAheS2LTT0VY6j51uzI4AhsEnbsc6TWfS+BLBL32b4aqLpuy+gGKhtLgGYpM7xzQAlcGaq2wnBYkfrzjSfuGWTwKCe5rWuy6kJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 43906152B;
	Tue, 25 Feb 2025 11:47:14 -0800 (PST)
Received: from J2N7QTR9R3.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E65263F5A1;
	Tue, 25 Feb 2025 11:46:55 -0800 (PST)
Date: Tue, 25 Feb 2025 19:46:53 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Leo Yan <leo.yan@arm.com>
Cc: Rob Herring <robh@kernel.org>, Will Deacon <will@kernel.org>,
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
Message-ID: <Z74eLRTcVym4sMqh@J2N7QTR9R3.cambridge.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com>
 <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
 <20250224180301.GI8144@e132581.arm.com>
 <CAL_JsqKNad6eEBerUOco=SDWxdp6dgRD3FDrSt5OpGQYwwstSg@mail.gmail.com>
 <20250225123813.GA1821331@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225123813.GA1821331@e132581.arm.com>

On Tue, Feb 25, 2025 at 12:38:13PM +0000, Leo Yan wrote:
> On Mon, Feb 24, 2025 at 07:31:52PM -0600, Rob Herring wrote:
> 
> [...]
> 
> > > > > When event rotation happens, if without context switch, in theory we
> > > > > should can directly use the branch record (no invalidation, no injection)
> > > > > for all events.
> > > >
> > > > No; that only works in *some* cases, and will produce incorrect results
> > > > in others.
> > > >
> > > > For example, consider filtering. Imagine a PMU with a single counter,
> > > > and two events, where event-A filters for calls-and-returns and event-B
> > > > filters for calls-only. When switching from event-A to event-B, it's
> > > > theoretically possible to keep the existing records around, knowing that
> > > > the returns can be filtered out later. When switching from event-B to
> > > > event-A we cannot keep the existing records, since there are gaps
> > > > whenever a return should have been recorded.
> > >
> > > Seems to me, the problem is not caused by event rotation.  We need to
> > > calculate a correct filter in the first place - the BRBE driver should
> > > calculate a superset for all filters of events for a session.  Then,
> > > generate branch record based event's specific filter.
> > 
> > The driver doesn't have enough information. If it is told to schedule
> > event A, it doesn't know anything about event B. It could in theory
> > try to remember event B if event B had already been scheduled, but it
> > never knows when event B is gone.
> 
> E.g., I tried below command for enabling 10 events in a perf session:
> 
>   perf record -e armv9_nevis/r04/ -e armv9_nevis/r05/ \
>               -e armv9_nevis/r06/ -e armv9_nevis/r07/ \
>               -e armv9_nevis/r08/ -e armv9_nevis/r09/ \
>               -e armv9_nevis/r10/ -e armv9_nevis/r11/ \
>               -e armv9_nevis/r12/ -e armv9_nevis/r13/ \
>               -- sleep 1
> 
> For Arm PMU, the flow below is invoked for every event on every
> affinied CPU in initialization phase:
> 
>   armpmu_event_init() {
>     armv8pmu_set_event_filter();
>   }
> 
> Shouldn't we calculate a superset branch filter for all events, store
> it into a per-CPU data structure and then apply the filter on BRBE?

Should we? No.

*NONE* of the events in your example are CPU-bound, and the call to
armpmu_event_init() can happen on an arbitrary CPU which the relevant
event never actually runs on, while other unrelated events may run on
that CPU.

It makes no sense for armv8pmu_set_event_filter() to write to a per-cpu
structure. That's purely there to determine what the filters *should* be
when *that specific event* is programmed into hardware.

As Rob and I have pointed out already, the *only* thing that can be
relevant to deciding the configuration of HW filtering is the set of
events which are *active* on that CPU.

> > > > There are a number of cases of that shape given the set of configurable
> > > > filters. In theory it's possible to retain those in some cases, but I
> > > > don't think that the complexity is justified.
> > > >
> > > > Similarly, whenever kernel branches are recorded it's necessary to drop
> > > > the stale branches whenever branch recording is paused, as there's
> > > > necessarily a blackout period and hence a gap in the records.
> > >
> > > If we save BRBE record when a process is switched out and then restore
> > > the record when a process is switched in, should we can keep a decent
> > > branch record for performance profiling?
> > 
> > Keep in mind that there's only 64 branches recorded at most. How many
> > branches in a context switch plus reconfiguring the PMU? Not a small
> > percentage of 64 I think. In traces where freeze on overflow was not
> > working (there's an example in v18), just the interrupt entry until
> > BRBE was stopped was a significant part of the trace. A context switch
> > is going to be similar.
> 
> That is true for kernel mode enabled tracing.  But we will have no
> such kind noises for userspace only mode tracing.

As mentioned elsewhere, it's not a problem for x86, so why is it
magically a problem for arm64?

> > > > Do you have a reason why you think we *must* keep events around?
> > >
> > > Here I am really concerned are cases when a process is preempted or
> > > migrated.  The driver doesn't save and restore branch records for these
> > > cases, it just invalidates all records when a task is scheduled in.
> > >
> > > As a result, if an event overflow is close to context switch, it is
> > > likely to capture incomplete branch records.  For a userspace-only
> > > tracing, it is risk to capture empty branch record after preemption
> > > and migrations.
> > 
> > There's the same risk if something else is recording kernel branches
> > when you are recording userspace only. I think the user has to be
> > aware if other things like context switches are perturbing their data.
> 
> I am confused for the decription above.  Does it refer to branch
> recording cross different sessions?  It is fine for me that the branch
> data is interleaved by different sessions (e.g. one is global tracing
> and another is only per-thread tracing).

Imagine that there's an existing process with some pid ${PID}, and
concurrently, the following commands are run, either by the same user or
different users with appropriate permissions:

	# Trying to record user branches only
	perf record -j any,u -e cycles -p ${PID}

	# Trying to record kernel branches only
	perf record -j any,k -e cycles -p ${PID}

Whatever you do, the task trying to record user branches only will lose
some records:

* If we make the events mutually exclusive, the branches will only be
  recorded when the user event is installed.

* If we merge the HW filters and later apply a SW filter, it's very
  likely that kernel branches taken after exception entry have filled
  all the records, and there are no user branches left to sample.

> We might need to consider an intact branch record for the single perf
> session case.  E.g. if userspace program calls:
> 
>     func_a -> func_b -> func_c
> 
> In a case for only userspace tracing, we will have no chance to preserve
> the call sequence of these functions after the program is switched out.

If those functions are small, it's very likely that they'll all be in
the branch history. If they're so large that they're not executed in one
scheduling quantum, do you expect them to fall within the same event
period?

I think that you're making a big deal out of an edge case that doesn't
matter much in practice.

Mark.
