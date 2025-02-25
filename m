Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AEAA14A4E9
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 12:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740484920; cv=none; b=ngS6c9GYJVEc2NrpLWunEJASZvFDPwN7asJ2ae7BlTGC8AR5qywZVCJT5BTa3CvaVYHIMvGV/OGWmNMgirvfhd8QTRaunDCnd0UzVV3d37yriNAA13M+BlSt9ndCDpgPRuiequEna4ivYMBJhMt6Fg0D63HinrX5Kyu0hMBUXwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740484920; c=relaxed/simple;
	bh=SWp3WrvX79X3ktWHCJ8Pf4Tx4DFOq4UVMg8Vp0BxCOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gncTZqGPycuIcM4wTiVTA2KiOYxzC+m27rx5F3+g9UF9efktjJnhH+C/xq27l9jMYnpFZySEoYY2Je3YOXxBuNlm20IWiZSc6j9MiUwQuaeGop+zendegZZhpSfNBYq6OJa5VXUVwU/n4KT+2IYE4aQYNcq+F2cX3hP08X95SAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F372D152B;
	Tue, 25 Feb 2025 04:02:14 -0800 (PST)
Received: from J2N7QTR9R3 (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 730B23F6A8;
	Tue, 25 Feb 2025 04:01:55 -0800 (PST)
Date: Tue, 25 Feb 2025 12:01:52 +0000
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
Message-ID: <Z72xMLsd37I6X_5-@J2N7QTR9R3>
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org>
 <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com>
 <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
 <20250224180301.GI8144@e132581.arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250224180301.GI8144@e132581.arm.com>

On Mon, Feb 24, 2025 at 06:03:01PM +0000, Leo Yan wrote:
> On Mon, Feb 24, 2025 at 04:05:43PM +0000, Mark Rutland wrote:
> 
> [...]
> 
> > > > > Just a minor concern.  I don't see any handling for task migration.
> > > > > E.g., for a task is migrated from one CPU to another CPU, I expect we
> > > > > need to save and restore branch records based on BRBE injection.  So
> > > > > far, the driver simply invalidates all records.
> > > > >
> > > > > I think this topic is very likely discussed before.  If this is the
> > > > > case, please ignore my comment.  Except this, the code looks good
> > > > > to me.
> > > > 
> > > > Not really discussed on the list, but that was present in v18 (though
> > > > not functional because .sched_task() hook wasn't actually enabled) and
> > > > Mark removed it. His work is here[1].The only comment was:
> > > > 
> > > > Note: saving/restoring at context-switch doesn't interact well with
> > > > event rotation (e.g. if filters change)
> > > 
> > > In the brbe_enable() function, it "Merge the permitted branch filters
> > > of all events".  Based on current implementation, all events share the
> > > same branch filter.
> > 
> > Critically, the brbe_enable() function merges the filters of all
> > *active* events which have been installed into hardware. It does not
> > track all events which can be rotated, and the resulting filter is not
> > the same -- it can change as a result of rotation.
> 
> In a perf session has multiple events, and events have different branch
> filters, seems to me, a simple way is to return error for this case.

FWIW, I'd generally prefer to do that since it avoids a number of
horrible edge-cases and gets rid of the need to do SW filtering, which
falls somewhere between "tricky" and "not entirely possible". However,
that's not what LBR and others do, which is why we went with filter
merging.

If folk on the tools side are happy with the kernel rejecting
conflicting events, then I'd be more than happy to do that. What I don't
want is that we start off with that approach and people immediately
start to complain that the BRBE driver rejects events that the LBR
driver accepts.

See the last time this came up:

  https://lore.kernel.org/linux-arm-kernel/Zli6Ot0TwK3Qy-ee@J2N7QTR9R3/
  https://lore.kernel.org/linux-arm-kernel/ZlnKFFwv9612V81h@J2N7QTR9R3/

> I would argue BRBE is an IP for recording branches per CPU wise, it does
> not support recording for event wise.

Yes, there is a mismatch between the hardware and the perf ABI.

> If we can unify branch filter within a perf session, would this be
> much easier for handling?

Do you mean if the perf tool ensured that all events in a given session
had the same filter? From the kernel's PoV there's no such thing as a
"perf session", and I'm not sure whether you're suggesting doing that in
userspace or withing the kernel.

Doing that in the perf tool would certianly make a stronger argument for
the kernel taking the "reject conflicting branch filters" option.

Doing that within the kernel isn't really possible.

> > > When event rotation happens, if without context switch, in theory we
> > > should can directly use the branch record (no invalidation, no injection)
> > > for all events.
> > 
> > No; that only works in *some* cases, and will produce incorrect results
> > in others.
> > 
> > For example, consider filtering. Imagine a PMU with a single counter,
> > and two events, where event-A filters for calls-and-returns and event-B
> > filters for calls-only. When switching from event-A to event-B, it's
> > theoretically possible to keep the existing records around, knowing that
> > the returns can be filtered out later. When switching from event-B to
> > event-A we cannot keep the existing records, since there are gaps
> > whenever a return should have been recorded.
> 
> Seems to me, the problem is not caused by event rotation.  We need to
> calculate a correct filter in the first place - the BRBE driver should
> calculate a superset for all filters of events for a session.  Then,
> generate branch record based event's specific filter.

From the kernel's PoV there is no such thing as a perf session, and the
branch filters are per-event per the perf ABI.

We only really have two options:

(1) Reject conflicting filters when scheduling events. At event open
    time we have ot check whether an entire group is actually
    schedulable.

(2) Merge filters when scheduling events, and then filter out
    branches which don't match a particular event's filters when reading
    the branches.

> > There are a number of cases of that shape given the set of configurable
> > filters. In theory it's possible to retain those in some cases, but I
> > don't think that the complexity is justified.
> > 
> > Similarly, whenever kernel branches are recorded it's necessary to drop
> > the stale branches whenever branch recording is paused, as there's
> > necessarily a blackout period and hence a gap in the records.
> 
> If we save BRBE record when a process is switched out and then restore
> the record when a process is switched in, should we can keep a decent
> branch record for performance profiling?

I cannot parse this question. What are you trying to suggest here?

> I understand it might be many things happen in the middle of a task
> switching or migration, but it is fine for not recording branches during
> the blackout period.  The missed branch records are not very helpful for
> forming a flow for a profiled program itself, especially, if we
> consider we will optimize userspace program in many cases.

Just to be clear, you're talking about userspace specifically, right?

There are users that want a contiguous set of branches, which is what
hardware tries to guarantee, and that's what LBR tries to gaurantee
today, so I don't think that we can say gaps are always fine.

If we want a "give me as many arbitrary samples branches as possible,
with arbitrary potential gaps" option, I'm not necessarily opposed to
that, but I do not think that should be the default behaviour.

> > Do you think that you have a case where losing branches across rotation
> > *really* matters?
> 
> I agreed that event rotation case might be rare and complex.  Please see
> a comment below.
> 
> > > For a context-switch case, we need to save and re-inject branch record.
> > > BRBE record sticks to a process context, no matter what events have been
> > > enabled.
> > 
> > I had originally wanted to keep per-event records around, but it doesn't
> > work in all cases. One reason events get discarded at context-switch
> > time is that CPU-bound events can sample branches, and would
> > mis-attribute stale userspace branches to the wrong context when
> > switching tasks. There are explicit comments about this in
> > amd_pmu_brs_sched_task() and intel_pmu_lbr_sched_task().
> > 
> > Given we discard records when reprogramming events, we *could* try to
> > preserve events in some cases, but I suspect that as with the rotation
> > case this'll be a lot of complexity for little gain. Note that as we
> > discard events when enabling the PMU, we'd throw some task-bound records
> > away anyway, and practically the gain would be limited to cpu-bound
> > records.
> > 
> > Do you have a reason why you think we *must* keep events around?
> 
> Here I am really concerned are cases when a process is preempted or
> migrated.  The driver doesn't save and restore branch records for these
> cases, it just invalidates all records when a task is scheduled in.
> 
> As a result, if an event overflow is close to context switch, it is
> likely to capture incomplete branch records.  For a userspace-only
> tracing, it is risk to capture empty branch record after preemption
> and migrations.

Yes, and I was initially concerned about that, but is that really a
problem? So long as the event period doesn't *always* coincide with
preemption you'll get records from other samples anyway.

While I agree this is a theoretical concern, I don't think its of
practical importance. This discarding happens on x86 *today* with LBR,
and (AFAICT) there hav been no complaints. Note that the LBR logic to
save/restore records for task contexts is only done for user callstack
recording, which BRBE does not support.

Regardless, there's still the problematic interaction with event
rotation; you cannot save/restore the records safely here if events (and
the relevant filters) can change between the save and restore.

Discarding here is significantly simpler, and correct.

Mark.
