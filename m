Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DCFA16D4C0
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 15:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719848984; cv=none; b=sE3oULdir/3r0ykws8k/1mTDPThf98dmTSJimTW4v6nLDLip68N2YtSdZSOmGlV9UBgBBh2blm8ijhbagnwtKoyCFm2Tt+HsGLSboiVba+gflpzubisdv2zCCQfnmbN1eSK41Bc5+FXdE4s1LCFG44vQ5mAC5TjMQZZGozHwAcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719848984; c=relaxed/simple;
	bh=FzHTzl2pM6bEFmyfIXnvBqB/szvNEUaYJUNet+Yhy60=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DLViBdiBDvDZsIRmlYupqS+ojmP24LcWy41F7i2ucohcjeTRdf3gyCWgw0lMQDr6NHgMDtMEpR8A+3emZW2umD6xkHFa44ee6hM3AmtgFqAmdLNBk8MIMEVep7MVzvX93vTae5HseyV0tCDEgBeDMdhV+7NnN5wtWSCWbGpw8iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dn16aWsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dn16aWsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C48C2BD10
	for <kvmarm@lists.linux.dev>; Mon,  1 Jul 2024 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719848984;
	bh=FzHTzl2pM6bEFmyfIXnvBqB/szvNEUaYJUNet+Yhy60=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dn16aWsHxZ9zj7/LYdbd5j4PuGmEiTb82mRlxgr9353O/WgDP33tFDSXkUEjYCQYV
	 pnFprls6ofsRKYpZ+nbFVXJwoZ+KnB6yhVUMiHSrPMNMCJ+CthPL6YkXefL6VL8o+P
	 59wZTA6KDLwuj+LSkp7YfT7oBNXQqvMgHNFDa54UDgrqJxU9UR/heu+9wXE3DPSDka
	 ztQJhN42TQEMnFxSqtIOLGayWTGclfhEo7XFIQAt/RfshICT8Nrasf+xHuzFQvYRLC
	 kDRRqZQMqG14k+lxNwSgymYqDvjnjWCnyT38lBTvJBdpyB+iPH518l0x9lWaJaoH6D
	 mfoDXTCZ5gmIg==
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-52cdb0d816bso3157405e87.1
        for <kvmarm@lists.linux.dev>; Mon, 01 Jul 2024 08:49:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXovxnbP29SSpc423V0fC0ahAdc6YqzSjV6GJNO/1QTGNugZ0my3dwgyGYOpxjaIdWvxvYcZWfVSu7xcX6vGOVVoQbY9eiE
X-Gm-Message-State: AOJu0Yx6cJOyvO7SwyJGTn9tq6k+XfjbGhLCUEpIZr2Iob3PBv3o7OF+
	Q8QB2kGSJ0IbH7qAbKGYMY/t73R/OwouhxRQPlqvzEz16gbF0QeZfsNZBRMza5l4ccyNCpRFBMZ
	yi2kv813NmICHFmhhZyJpPS1Qxw==
X-Google-Smtp-Source: AGHT+IFDs+WM61neTl4W+/aa13iIaRUE/ScfGZW3qLo405X2mESySA3ctabmSZLxw4Jh7wo4i87xPoxH8UwNbBkhmvg=
X-Received: by 2002:a05:6512:3ca9:b0:52e:8161:4ce6 with SMTP id
 2adb3069b0e04-52e825cb693mr1822851e87.25.1719848982454; Mon, 01 Jul 2024
 08:49:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
 <20240626-arm-pmu-3-9-icntr-v2-6-c9784b4f4065@kernel.org> <86ikxuir2k.wl-maz@kernel.org>
 <20240701135216.GD2250@willie-the-truck>
In-Reply-To: <20240701135216.GD2250@willie-the-truck>
From: Rob Herring <robh@kernel.org>
Date: Mon, 1 Jul 2024 09:49:29 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKYstLZQy_VQTvg-285jj1mpH+4d9CVJ_1_iAus5_rTRA@mail.gmail.com>
Message-ID: <CAL_JsqKYstLZQy_VQTvg-285jj1mpH+4d9CVJ_1_iAus5_rTRA@mail.gmail.com>
Subject: Re: [PATCH v2 06/12] perf: arm_pmu: Remove event index to counter remapping
To: Will Deacon <will@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, Russell King <linux@armlinux.org.uk>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, James Clark <james.clark@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 1, 2024 at 7:52=E2=80=AFAM Will Deacon <will@kernel.org> wrote:
>
> On Thu, Jun 27, 2024 at 12:05:23PM +0100, Marc Zyngier wrote:
> > On Wed, 26 Jun 2024 23:32:30 +0100,
> > "Rob Herring (Arm)" <robh@kernel.org> wrote:
> > >
> > > Xscale and Armv6 PMUs defined the cycle counter at 0 and event counte=
rs
> > > starting at 1 and had 1:1 event index to counter numbering. On Armv7 =
and
> > > later, this changed the cycle counter to 31 and event counters start =
at
> > > 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> > > and introduced an event index to counter conversion. The conversion u=
ses
> > > masking to convert from event index to a counter number. This operati=
on
> > > relies on having at most 32 counters so that the cycle counter index =
0
> > > can be transformed to counter number 31.
> > >
> > > Armv9.4 adds support for an additional fixed function counter
> > > (instructions) which increases possible counters to more than 32, and
> > > the conversion won't work anymore as a simple subtract and mask. The
> > > primary reason for the translation (other than history) seems to be t=
o
> > > have a contiguous mask of counters 0-N. Keeping that would result in
> > > more complicated index to counter conversions. Instead, store a mask =
of
> > > available counters rather than just number of events. That provides m=
ore
> > > information in addition to the number of events.
> > >
> > > No (intended) functional changes.
> > >
> > > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> >
> > [...]
> >
> > > diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pm=
u.h
> > > index b3b34f6670cf..e5d6d204beab 100644
> > > --- a/include/linux/perf/arm_pmu.h
> > > +++ b/include/linux/perf/arm_pmu.h
> > > @@ -96,7 +96,7 @@ struct arm_pmu {
> > >     void            (*stop)(struct arm_pmu *);
> > >     void            (*reset)(void *);
> > >     int             (*map_event)(struct perf_event *event);
> > > -   int             num_events;
> > > +   DECLARE_BITMAP(cntr_mask, ARMPMU_MAX_HWEVENTS);
> >
> > I'm slightly worried by this, as this size is never used, let alone
> > checked by the individual drivers. I can perfectly picture some new
> > (non-architectural) PMU driver having more counters than that, and
> > blindly setting bits outside of the allowed range.
>
> I tend to agree.
>
> > One way to make it a bit safer would be to add a helper replacing the
> > various bitmap_set() calls, and enforcing that we never overflow this
> > bitmap.
>
> Or perhaps wd could leave the 'num_events' field intact and allocate the
> new bitmap dynamically?
>
> Rob -- what do you prefer? I think the rest of the series is ready to go.

I think the list of places we're initializing cntr_mask is short
enough to check and additions to arm_pmu users are rare enough I would
not be too worried about it.

If anything, I think the issue is with the bitmap API in that it has
no bounds checking. I'm sure it will get on someone's radar to fix at
some point.

But if we want to have something check, this is what I have:

static inline void armpmu_set_counter_mask(struct arm_pmu *pmu,
                                          unsigned int start, unsigned int =
nr)
{
       if (WARN_ON(start + nr > ARMPMU_MAX_HWEVENTS))
               return;
       bitmap_set(pmu->cntr_mask, start, nr);
}

Rob
