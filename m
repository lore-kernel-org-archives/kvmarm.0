Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6594F221703
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740580009; cv=none; b=K9Tb8YHdLyfKCqbnR/PBaSnAX1YIWKrUFeSMcFEj1Zxof35gZpWpfu87IEcQbs9G8Rp0uNDcW+7HswsHPEdODhW6dSnyH5hG0pRSVA8xQtDs5KLWTnRLpWHsXqCwW+phdeTVB0dA8ujYVPZdgVvAMG9eQPQ9rj1qPqf0a3i0PM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740580009; c=relaxed/simple;
	bh=y3IqYf4h8z56HMq1u4QOXDpo2lerEGe/MyAJAgUvtE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nfp1ucq9all/ytHk5ewc7ZoDrgfIhHIBgP8mmS17EmGeDI5WitPdFTbUETTrjp/Hnb5Zcv+q1JNv/z9tg1M568tECT5vwNFHBF1oexxMtnszNorcRbJzuwYXYZLvBe86kGk1YDrJ6OrOdnC2hXzgNNKDPnHzm2BC3QuIBtJtphg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Y3BTg4Zn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Y3BTg4Zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3A1C4CEE8
	for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 14:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740580009;
	bh=y3IqYf4h8z56HMq1u4QOXDpo2lerEGe/MyAJAgUvtE4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Y3BTg4ZnHmreh6smT8aoN1Ni2N5swrAc0/YGSMNKgGe3uR9C9/Kg57fTWg5A/C8Ot
	 c40AMaY4kSp+dPc5HK84o9hzSsphiium6fn0eiDJfeSJ70cA2P4O4m6q0s6mrj/U7K
	 t4vYS30jst6MmScs3jONjUU85/h5Ey66vntYUGxuV9HEP7WAS5AH4Aw8e5MhizhYzt
	 Oekiz5dxVZjrnvxz3p0mN5ELlto1beh+OS5m2sKOw1Zlod6jqNKO7BzHl/q2fDlY0T
	 Z9QJiofDQtTJxJ0ORJ3OaKBFBht4I5ych1ur+pt9pJs9NEBv0S5SGDppyVfK4R8Ehz
	 K8fwMeL2Jphog==
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5dedae49c63so12334273a12.0
        for <kvmarm@lists.linux.dev>; Wed, 26 Feb 2025 06:26:48 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVguyDAh5JJ68O6NCkuPThorN1MhhFqFXbaDeE1UNiigOseG2fKAH2C7fBL/akJijHzEfsV5co=@lists.linux.dev
X-Gm-Message-State: AOJu0YybqNLSheLMpra6XeavQ/1ixPQ4MYDKOZGkajUSX8c8LSfHRMxh
	rWmM3Uk88JS2sxKtOnp5Eo3eTOw/vvCjryW8IhZm64LTyBSG+tiORR3lON3Q9z1bpFDDLiwLvAZ
	UDBHyJ/7+grCCk72yXs7o5yq1Jw==
X-Google-Smtp-Source: AGHT+IFEgOvjT9GpNU3OvYcUgyXe7iQDfeTtmoajh3myllmUAgDUnbQ1OhXtxtPL0zlFSh5JV1Fe7myngUVyVm9/Sos=
X-Received: by 2002:a05:6402:280d:b0:5e4:a88a:64e with SMTP id
 4fb4d7f45d1cf-5e4a88a0790mr2752017a12.5.1740580007445; Wed, 26 Feb 2025
 06:26:47 -0800 (PST)
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
 <20250224180301.GI8144@e132581.arm.com> <Z72xMLsd37I6X_5-@J2N7QTR9R3>
 <20250225174803.GB1821331@e132581.arm.com> <Z74g2vUT9-KtlIvo@J2N7QTR9R3.cambridge.arm.com>
 <20250226134813.GC1821331@e132581.arm.com>
In-Reply-To: <20250226134813.GC1821331@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Wed, 26 Feb 2025 08:26:35 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJL_oqL2XwEiqMCz1KjYX8SwN3N+GkUBpVxKPc9GExh7A@mail.gmail.com>
X-Gm-Features: AQ5f1JqVAYg5qWj8-HHEGM0Q9ABD1QuYj5lJjYU40vjoEH_p54d6zfRA82nKqok
Message-ID: <CAL_JsqJL_oqL2XwEiqMCz1KjYX8SwN3N+GkUBpVxKPc9GExh7A@mail.gmail.com>
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

On Wed, Feb 26, 2025 at 7:48=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Tue, Feb 25, 2025 at 07:58:18PM +0000, Mark Rutland wrote:
> > On Tue, Feb 25, 2025 at 05:48:03PM +0000, Leo Yan wrote:
> > > On Tue, Feb 25, 2025 at 12:01:52PM +0000, Mark Rutland wrote:
> > >
> > > [...]
> > >
> > > > > > Critically, the brbe_enable() function merges the filters of al=
l
> > > > > > *active* events which have been installed into hardware. It doe=
s not
> > > > > > track all events which can be rotated, and the resulting filter=
 is not
> > > > > > the same -- it can change as a result of rotation.
> > > > >
> > > > > In a perf session has multiple events, and events have different =
branch
> > > > > filters, seems to me, a simple way is to return error for this ca=
se.
> > > >
> > > > FWIW, I'd generally prefer to do that since it avoids a number of
> > > > horrible edge-cases and gets rid of the need to do SW filtering, wh=
ich
> > > > falls somewhere between "tricky" and "not entirely possible". Howev=
er,
> > > > that's not what LBR and others do, which is why we went with filter
> > > > merging.
> > > >
> > > > If folk on the tools side are happy with the kernel rejecting
> > > > conflicting events, then I'd be more than happy to do that. What I =
don't
> > > > want is that we start off with that approach and people immediately
> > > > start to complain that the BRBE driver rejects events that the LBR
> > > > driver accepts.
> > > >
> > > > See the last time this came up.
> > >
> > > Thanks for the shared links.  Based on the info, let's say we can hav=
e two
> > > cases:
> > >
> > >   Case 1: set different branch filters in a single perf session:
> > >
> > >     perf record -e armv8_pmuv3_0/r03,branch_type=3Dany_call/u \
> > >                 -e armv8_pmuv3_0/r04,branch_type=3Dany_ret/k ...
> > >
> > >   Case 2: set different branch filters in multiple perf sessions:
> > >
> > >     perf record -e armv8_pmuv3_0/r03,branch_type=3Dany_call/u ...
> > >
> > >     perf record -e armv8_pmuv3_0/r04,branch_type=3Dany_ret/k ...
> > >
> > > In my previous reply, I was suggesting that we should reject the case=
 1.
> >
> > Do you mean that the kernel should reject that, or that userspace shoul=
d
> > reject that.
>
> For the case 1, the userspace can reject it as it has sufficient info to
> detect mismatched filters by iterating event list.
>
> > As mentioned earlier, I am ok with the idea that we reject *scheduling*
> > events with mismatched filters, as we do for other resource conflicts.
> > That would necessarily mean rejecting *groups* of events with
> > inconsistent filters at open time.
>
> This rejects the case 2 in the PMU driver.
>
> > However, I do not think that we should reject indepenent events which
> > happen to have mismatched filters, regardless of whether they're opened
> > by the same "session".
>
> Can I understand "independent events" are events that are not in a event
> group?

Yes. The BRBE code has no concept of groups either.

> If independent events can have mismatched filters, the PMU driver can
> activate them simultaneously, this means the BRBE driver needs to merge
> the branch filters.  If so, I still see the complexity caused by this
> case.

That's exactly what the driver does. It's not even that complex. We
have the BRBFCR and BRBCR register values for each event and just have
to OR them together for the enabled events. For filtering we just
compare each branch record to a mask of the enabled branch types for
the event.

> > > IMO, it is not quite useful to configure different filters for events=
 in
> > > the same session, especially if this leads complexity in the driver d=
ue
> > > to the hardware limitation.
> >
> > I generally agree, but IIRC userspace does this today.
> >
> > > For case 2, when create a new session, if the perf tool can read out =
the
> > > current branch filter setting (e.g. via sysfs node) and give suggesti=
on
> > > what branch filter is compabile with existed sessions, seems to me, t=
his
> > > is a feasible solution.  My understanding this is a rare case, and a
> > > clear guidance for users would be sufficient if this happens.  (Maybe
> > > we can give recommendation for how to use BRBE in the perf doc).
> >
> > No. We are not going to expose *dynamic* information about the PMU
> > hardware via sysfs. This is not as simple as you make it out to be.
> > At any point in time there can be an arbitrary number of events open,
> > and some arbitrary subset currently scheduled.
>
> If so, the perf tool will miss info for checking the existed branch
> filter and defer to handle the mismatched filter error until the
> kernel reports the issue.
>
> > I agree that ideally this should be rare, though, and hence either of
> > the two options I have suggested thus far should handle that acceptably=
.
> >
> > > To be clear, an important factor is the trace modes with modifier 'u'
> > > (user) and 'k' (kernel) should be supported for different events and =
for
> > > different sessions.  In a mixed cases (some events are userspace only
> > > and some are kernel only), the BRBE driver needs to filter out branch
> > > records for specific mode when taking a sample.
> >
> > I hate to repeat myself, but the driver has *no concept whatsoever* of =
a
> > "session". It only knows:
> >
> > * Which events are currently active in hardware.
> >
> > * Which events have been grouped together.
> >
> > * Which events have been opened for a given task or CPU context.
> >
> > ... and *NONE* of those correspond directly to a "session" managed by
> > the userspace perf tool.
>
> Sorry for that.  After your reminder, I understood that the PMU driver
> has no knowledge for perf session.
>
> The description above does not refer to perf session.  As you said, the
> PMU driver has its own context to track active events, and it is
> possible that some active events might trace only user mode while others
> trace only kernel mode.  In this case, BRBE needs to be enabled for both
> user and kernel modes.  When capturing samples, the BRBE driver needs to
> filter out branch records based on a specific event for its
> corresponding mode.

That's exactly what the driver does.

> For better understanding, though we don't allow mismatched filters, I
> still think we should set both E0BRE and ExBRE bits if there are
> multiple active events with different modes.

That's exactly what the driver does.

> [...]
>
> > > I haven't done any experiments for this. If you think this is the way
> > > to move forward, I might do a prototype and get back to you to ensure=
 we
> > > don't run into any unexpected issues.
> >
> > What specifically are you proposing to prototype?
>
> I mean, in Linux perf, we can add code to check branch filters for
> opened events when creating a session and report an error for
> mismatching filters.  I would suggest we implement it specifically
> for Arm64 to avoid dispute with other archs.

There's not really any such thing as mismatching filters. There's no
mutually exclusive filters. The only effect having multiple events
enabling branch stack is you might run out of branch records sooner. A
CPU with a minimal number of branch records is going to have a similar
problem as will just enabling all branches on a single event. There's
not any way to fix that other than increasing the number of records or
adding a mechanism to the architecture to avoid dropping records.

Rob
