Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77BDF26618F
	for <kvmarm@lists.linux.dev>; Mon, 24 Feb 2025 18:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740420189; cv=none; b=HHS3qDYB8Wt7RaNNEe2dK5hitLlJvIr/T5ulcOAgEOuIq4C8MELz7llkYntZX1y1Id+DM4GOx591px5rGn9RpbZTXCjHGxYKrvafmmn3gu/60jvdxVIbspEHOVZvzOjIkzHjQnBkxo9CRNjHWlPsA6I8MNHAOr3xPLu9AWZvriQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740420189; c=relaxed/simple;
	bh=rUE/hQROradH9urjwJ+EoCG+n0ZEi4vngN2fnKmbyOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LvxtVtmIqcda6U3Jw+eAu00UlzjFolPB/81wpKxUFNe9uEqdAWqQYR6oNPqeGWPqHvbrN+DjJkctcAK4NMH0CFY8o+CVCioHOb4HGiPJsKQQJ6qcxzKF1/vnyt7EbYL9dDIn+XJcAeHOb9/cPe/AXIFTQIRlwvooXtlLV9kBk+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6A498152B;
	Mon, 24 Feb 2025 10:03:23 -0800 (PST)
Received: from localhost (e132581.arm.com [10.2.76.71])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 654EE3F5A1;
	Mon, 24 Feb 2025 10:03:06 -0800 (PST)
Date: Mon, 24 Feb 2025 18:03:01 +0000
From: Leo Yan <leo.yan@arm.com>
To: Mark Rutland <mark.rutland@arm.com>
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
Message-ID: <20250224180301.GI8144@e132581.arm.com>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com>
 <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>

On Mon, Feb 24, 2025 at 04:05:43PM +0000, Mark Rutland wrote:

[...]

> > > > Just a minor concern.  I don't see any handling for task migration.
> > > > E.g., for a task is migrated from one CPU to another CPU, I expect we
> > > > need to save and restore branch records based on BRBE injection.  So
> > > > far, the driver simply invalidates all records.
> > > >
> > > > I think this topic is very likely discussed before.  If this is the
> > > > case, please ignore my comment.  Except this, the code looks good
> > > > to me.
> > > 
> > > Not really discussed on the list, but that was present in v18 (though
> > > not functional because .sched_task() hook wasn't actually enabled) and
> > > Mark removed it. His work is here[1].The only comment was:
> > > 
> > > Note: saving/restoring at context-switch doesn't interact well with
> > > event rotation (e.g. if filters change)
> > 
> > In the brbe_enable() function, it "Merge the permitted branch filters
> > of all events".  Based on current implementation, all events share the
> > same branch filter.
> 
> Critically, the brbe_enable() function merges the filters of all
> *active* events which have been installed into hardware. It does not
> track all events which can be rotated, and the resulting filter is not
> the same -- it can change as a result of rotation.

In a perf session has multiple events, and events have different branch
filters, seems to me, a simple way is to return error for this case.

I would argue BRBE is an IP for recording branches per CPU wise, it does
not support recording for event wise.  If we can unify branch filter
within a perf session, would this be much easier for handling?

> > When event rotation happens, if without context switch, in theory we
> > should can directly use the branch record (no invalidation, no injection)
> > for all events.
> 
> No; that only works in *some* cases, and will produce incorrect results
> in others.
> 
> For example, consider filtering. Imagine a PMU with a single counter,
> and two events, where event-A filters for calls-and-returns and event-B
> filters for calls-only. When switching from event-A to event-B, it's
> theoretically possible to keep the existing records around, knowing that
> the returns can be filtered out later. When switching from event-B to
> event-A we cannot keep the existing records, since there are gaps
> whenever a return should have been recorded.

Seems to me, the problem is not caused by event rotation.  We need to
calculate a correct filter in the first place - the BRBE driver should
calculate a superset for all filters of events for a session.  Then,
generate branch record based event's specific filter.

> There are a number of cases of that shape given the set of configurable
> filters. In theory it's possible to retain those in some cases, but I
> don't think that the complexity is justified.
> 
> Similarly, whenever kernel branches are recorded it's necessary to drop
> the stale branches whenever branch recording is paused, as there's
> necessarily a blackout period and hence a gap in the records.

If we save BRBE record when a process is switched out and then restore
the record when a process is switched in, should we can keep a decent
branch record for performance profiling?

I understand it might be many things happen in the middle of a task
switching or migration, but it is fine for not recording branches during
the blackout period.  The missed branch records are not very helpful for
forming a flow for a profiled program itself, especially, if we
consider we will optimize userspace program in many cases.

> Do you think that you have a case where losing branches across rotation
> *really* matters?

I agreed that event rotation case might be rare and complex.  Please see
a comment below.

> > For a context-switch case, we need to save and re-inject branch record.
> > BRBE record sticks to a process context, no matter what events have been
> > enabled.
> 
> I had originally wanted to keep per-event records around, but it doesn't
> work in all cases. One reason events get discarded at context-switch
> time is that CPU-bound events can sample branches, and would
> mis-attribute stale userspace branches to the wrong context when
> switching tasks. There are explicit comments about this in
> amd_pmu_brs_sched_task() and intel_pmu_lbr_sched_task().
> 
> Given we discard records when reprogramming events, we *could* try to
> preserve events in some cases, but I suspect that as with the rotation
> case this'll be a lot of complexity for little gain. Note that as we
> discard events when enabling the PMU, we'd throw some task-bound records
> away anyway, and practically the gain would be limited to cpu-bound
> records.
> 
> Do you have a reason why you think we *must* keep events around?

Here I am really concerned are cases when a process is preempted or
migrated.  The driver doesn't save and restore branch records for these
cases, it just invalidates all records when a task is scheduled in.

As a result, if an event overflow is close to context switch, it is
likely to capture incomplete branch records.  For a userspace-only
tracing, it is risk to capture empty branch record after preemption
and migrations.

Thanks,
Leo
