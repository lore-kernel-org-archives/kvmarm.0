Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A712021ABAF
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 15:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740497723; cv=none; b=cKCgYT5ZcM4W9nNlmJ7n9TGd7afHBU1TTFi/2F0N3ChTQkOu+v6+veAcqKHWFn++Lh2ebQR8InXeNgRoRFLKgchtmrKf/OAqb167Gnm2xdsDkBDN6BOeta8AUeSKIjHog9RdK8I1RW5rvLO55w4+HD+8nhj0fTe147hZfWt40v8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740497723; c=relaxed/simple;
	bh=XItyUEZepBSi+iNDaSIT9S/Mq6Xh426aEX3xchTQv4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=e640nWYMQIlVmhhvLjHNatdTXM380s2YxiyB3RkxWUy704Xb3Py8LvRDaxQIfn7VsaVDXUMPu3BgwyLP6BxQN1JuRHEIZ4oeMxbxTxQYYKX4SdEeh4F0nxE5vlxQYg6T0kCfM4xIO7yGZomzq/Ww5RxK6iKVPsFp7DN+UROCZfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MacJrO2+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MacJrO2+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429F5C4CEEC
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 15:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740497723;
	bh=XItyUEZepBSi+iNDaSIT9S/Mq6Xh426aEX3xchTQv4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MacJrO2+ftUHpyu1YUk3rA0JXXCu9Qww0QjDsWQIY2Eg5Z3EJ+uYMDEcIMLXjRY8z
	 yS5ELmu5jINaiK0034HiA131r2iKw6sCPKLB9vKr+XkcT1h/z9z2ZrSdLtfJEN/dxV
	 tvJJLTlJwglsFIKrLbNV9UPnfgF7Yy1IQXT3Jjn0Uo2c+elJvM+/IDeKgf7mfgtov7
	 L7TqPtFDJvZF1DPMoDnmVqfYwRl3vDg/gE0xt6mLfdNX7E5wxNw6terDqAeMAu2QWr
	 9WpIDLcIFeMGRx7QTH+nmEQODtBCovzodoZhl/dGfNrKj+dqRgpaeDWtAkJgqRRaLT
	 mE/HtNPBy+j1Q==
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-5dedd4782c6so10700343a12.3
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 07:35:23 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXYm1C+vTYJQQbaDtLNq4T3vUgJ64+F28zw8yzqLainlo6UWPUNA7B6r6oIfCGJe5N2VS5uF8U=@lists.linux.dev
X-Gm-Message-State: AOJu0YwejNjMT2WJ4dB0S7XeLiDUBmO3Lad7/5KeHJTOjwf2QzXrRXYo
	DFHqzF/Ir+AfZIvUZIxxLBmX7xxQq0VedrbW4gGx2CfBOwFaXol8N7AEQsk/KXuEB8vakko+yQ+
	OCicNNF7fIzhGJyQIK7GUuwM4Hg==
X-Google-Smtp-Source: AGHT+IG3W78BIijkWq7Fyxr+xyyGetXy3PWKs3KsePxUk1BA+35b6sqYHWgJT8HK9oC/8GAmOY2QdyNYtk6IUss22yk=
X-Received: by 2002:a05:6402:3587:b0:5de:3c29:e834 with SMTP id
 4fb4d7f45d1cf-5e44b7635damr3926277a12.27.1740497721673; Tue, 25 Feb 2025
 07:35:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250218-arm-brbe-v19-v20-0-4e9922fc2e8e@kernel.org>
 <20250218-arm-brbe-v19-v20-11-4e9922fc2e8e@kernel.org> <20250224122507.GE8144@e132581.arm.com>
 <CAL_Jsq+0fZ2uasgAam7qGTdCeDBQxXeyL-J1_suyxy6GE_ERTg@mail.gmail.com>
 <20250224140317.GF8144@e132581.arm.com> <Z7yY19UtSnND5KTl@J2N7QTR9R3.cambridge.arm.com>
 <20250224180301.GI8144@e132581.arm.com> <CAL_JsqKNad6eEBerUOco=SDWxdp6dgRD3FDrSt5OpGQYwwstSg@mail.gmail.com>
 <20250225123813.GA1821331@e132581.arm.com>
In-Reply-To: <20250225123813.GA1821331@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 25 Feb 2025 09:35:09 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ4cSGVjkBqU9uZdB2gjF6FyfQaD=jmcqEamEoqWLYGaQ@mail.gmail.com>
X-Gm-Features: AQ5f1Jo1RJnU8UBv-NkgDA5mYeZ3KtlYf8lNMthdII-jEnwh4DVqd7qs9q-S8Hk
Message-ID: <CAL_JsqJ4cSGVjkBqU9uZdB2gjF6FyfQaD=jmcqEamEoqWLYGaQ@mail.gmail.com>
Subject: Re: [PATCH v20 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: Leo Yan <leo.yan@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 25, 2025 at 6:38=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Mon, Feb 24, 2025 at 07:31:52PM -0600, Rob Herring wrote:
>
> [...]
>
> > > > > When event rotation happens, if without context switch, in theory=
 we
> > > > > should can directly use the branch record (no invalidation, no in=
jection)
> > > > > for all events.
> > > >
> > > > No; that only works in *some* cases, and will produce incorrect res=
ults
> > > > in others.
> > > >
> > > > For example, consider filtering. Imagine a PMU with a single counte=
r,
> > > > and two events, where event-A filters for calls-and-returns and eve=
nt-B
> > > > filters for calls-only. When switching from event-A to event-B, it'=
s
> > > > theoretically possible to keep the existing records around, knowing=
 that
> > > > the returns can be filtered out later. When switching from event-B =
to
> > > > event-A we cannot keep the existing records, since there are gaps
> > > > whenever a return should have been recorded.
> > >
> > > Seems to me, the problem is not caused by event rotation.  We need to
> > > calculate a correct filter in the first place - the BRBE driver shoul=
d
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

That function is passed *1* event. It is not intended to go looking at
all events or muck with any global state. Could we go poking around
all the data structures? Probably, it's C and data structures are
often not opaque when they should be, so that wouldn't be a good idea.
If you think it is, I'd recommend you stay away from Rust.

Furthermore, an event here may not actually be enabled. A user could
open 2 events and handle them as mutually exclusive continuously
disabling one and enabling the other. If the branch filters that they
want are not overlapping, we'd be reducing our effective branch record
size. Maximizing the size seems much more important to me than keeping
some branches in a few corner cases.

> Shouldn't we calculate a superset branch filter for all events, store
> it into a per-CPU data structure and then apply the filter on BRBE?

Suppose we do that, what happens when a 2nd session (as Mark pointed
out, sessions only exist in the perf tool, not the kernel) adds more
events. We configured the filters and now we have to change them
again. So we have to invalidate the branch record. It's the same thing
with event rotation (though less frequent (probably)).

> > > > There are a number of cases of that shape given the set of configur=
able
> > > > filters. In theory it's possible to retain those in some cases, but=
 I
> > > > don't think that the complexity is justified.
> > > >
> > > > Similarly, whenever kernel branches are recorded it's necessary to =
drop
> > > > the stale branches whenever branch recording is paused, as there's
> > > > necessarily a blackout period and hence a gap in the records.
> > >
> > > If we save BRBE record when a process is switched out and then restor=
e
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
>
> [...]
>
> > > > Do you have a reason why you think we *must* keep events around?
> > >
> > > Here I am really concerned are cases when a process is preempted or
> > > migrated.  The driver doesn't save and restore branch records for the=
se
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
>
> We might need to consider an intact branch record for the single perf
> session case.  E.g. if userspace program calls:
>
>     func_a -> func_b -> func_c
>
> In a case for only userspace tracing, we will have no chance to preserve
> the call sequence of these functions after the program is switched out.

So you miss the few times that happens in a context switch. But we are
sampling and all/most of the other samples are going to be fine. How
much is that really going to affect your profile?

Rob
