Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A18199396
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 19:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740510255; cv=none; b=ssWpGk5demdvSjxD+HPpoyb3tRzqoTnnSKlqkqcVtQU0zcNcg7K2wwOpGUt4Q65BMA/xthYfY5EfoDivL+X+75oeIbawbSsEz4ilmp2K8vxCrgi79Sf2lCZYsWACJzQFij96Ip2i+ngd/zni7L6v0D7OkVQLKy0zTA44j86L2Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740510255; c=relaxed/simple;
	bh=wx9QBU6tAnYYzEaE8trWwMY6LtChTs+QPBWHOskxTn4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E283zmpT1SN9ov7jkzw2yumN81lBQzP0fdb/yyKa7ukXzr6KXIrZpeTzkW2xafKBZmXQnNDrVbMYRyhvmibSHP8WmZ19qDBhP699n6f12wjOT2isawrAxMDZ4QrLxf+Npqi7JMZUMWl1MU2DLTay1dSWg472ChrhGfKdN42oDK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NuK41+cu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NuK41+cu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BC81C4CEDD
	for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 19:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740510255;
	bh=wx9QBU6tAnYYzEaE8trWwMY6LtChTs+QPBWHOskxTn4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=NuK41+cuisBhgv68qrrFTmegIiuQQ4fGmRPyXfR1HhatqCON8eIfYmFhej6MHWORk
	 +Q95vz/0opiqOtIBbycCpiKUjLgCIFrHSXG+EjiiuOosxHz6SvZlqP0guZ5s1j7dG0
	 0e35f0SqSFh7hnLinpSEnO9UhaU2+cdXthav/tetooLdYdeZlHTX25mfF4fiuI8vzm
	 NSazbjJQwKMFn8oYWFN2wx4z1SBDYt8C8nZrtjk8+mYcTzFynuzZ7Yz+ocKdRNFjlE
	 tkx1vQbIAAET5yYzIlKqG2GGMDFSSVQtZoNUHdqicOzwrIiWnQ7i1ZbTJ+rDGlJkq9
	 diELxR40MH/Hw==
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abbae92be71so655114466b.2
        for <kvmarm@lists.linux.dev>; Tue, 25 Feb 2025 11:04:15 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXOXKRqo2BwpmGh9axVmYCvDgcwvkWrZxTnk6QkJuULAzgQUOf0l4CQuK8lu91gZQRXizsFp7U=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM5Bi0wu42gleNGHJQjnqVcHe5VmJZZ/aguGgUfhqfys7Y14+6
	6IXvUS2dki27cH4AAwjaMRS9kGIMXAHN5Nau8W1AhdjhJ1yEBFYcxFuDGJFNbxl/1O3C001ahGW
	u34rBYnJkqDjG35u63PWNn+NwDg==
X-Google-Smtp-Source: AGHT+IFar3mUfJFrfU/deMFPxUePXViU9VyVdcqCg6mKkuZ0S3VY/6Gk/ZI9rjPALypohCRcts86IPwkHDA1LjRRrSA=
X-Received: by 2002:a05:6402:34d5:b0:5e0:82a0:50ce with SMTP id
 4fb4d7f45d1cf-5e44ba424d9mr10074864a12.27.1740510253810; Tue, 25 Feb 2025
 11:04:13 -0800 (PST)
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
 <20250224180301.GI8144@e132581.arm.com> <Z72xMLsd37I6X_5-@J2N7QTR9R3> <20250225174803.GB1821331@e132581.arm.com>
In-Reply-To: <20250225174803.GB1821331@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 25 Feb 2025 13:04:01 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKyiUYXLBxr_5kKyojXLsdkoRivtntmzPq-kjWv2V+Y=w@mail.gmail.com>
X-Gm-Features: AQ5f1Jp6KAiLK5EIt7HxRu_fbcAPSrUpDqbcWrQjPWGul4dbIwchehQ5jnZ8SKs
Message-ID: <CAL_JsqKyiUYXLBxr_5kKyojXLsdkoRivtntmzPq-kjWv2V+Y=w@mail.gmail.com>
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

On Tue, Feb 25, 2025 at 11:48=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Tue, Feb 25, 2025 at 12:01:52PM +0000, Mark Rutland wrote:
>
> [...]
>
> > > > Critically, the brbe_enable() function merges the filters of all
> > > > *active* events which have been installed into hardware. It does no=
t
> > > > track all events which can be rotated, and the resulting filter is =
not
> > > > the same -- it can change as a result of rotation.
> > >
> > > In a perf session has multiple events, and events have different bran=
ch
> > > filters, seems to me, a simple way is to return error for this case.
> >
> > FWIW, I'd generally prefer to do that since it avoids a number of
> > horrible edge-cases and gets rid of the need to do SW filtering, which
> > falls somewhere between "tricky" and "not entirely possible". However,
> > that's not what LBR and others do, which is why we went with filter
> > merging.
> >
> > If folk on the tools side are happy with the kernel rejecting
> > conflicting events, then I'd be more than happy to do that. What I don'=
t
> > want is that we start off with that approach and people immediately
> > start to complain that the BRBE driver rejects events that the LBR
> > driver accepts.
> >
> > See the last time this came up.
>
> Thanks for the shared links.  Based on the info, let's say we can have tw=
o
> cases:
>
>   Case 1: set different branch filters in a single perf session:
>
>     perf record -e armv8_pmuv3_0/r03,branch_type=3Dany_call/u \
>                 -e armv8_pmuv3_0/r04,branch_type=3Dany_ret/k ...
>
>   Case 2: set different branch filters in multiple perf sessions:
>
>     perf record -e armv8_pmuv3_0/r03,branch_type=3Dany_call/u ...
>
>     perf record -e armv8_pmuv3_0/r04,branch_type=3Dany_ret/k ...
>
> In my previous reply, I was suggesting that we should reject the case 1.

The driver cannot distinguish those 2 cases.

> IMO, it is not quite useful to configure different filters for events in
> the same session, especially if this leads complexity in the driver due
> to the hardware limitation.
>
> For case 2, when create a new session, if the perf tool can read out the
> current branch filter setting (e.g. via sysfs node) and give suggestion
> what branch filter is compabile with existed sessions, seems to me, this
> is a feasible solution.  My understanding this is a rare case, and a
> clear guidance for users would be sufficient if this happens.  (Maybe
> we can give recommendation for how to use BRBE in the perf doc).

First, I don't think anything currently in sysfs for PMU changes based
on current PMU usage. It is all static features. So you just added a
2nd control interface in addition to the syscall/ioctl interface. It
is also totally racy. As soon as you read sysfs, the information could
be out of date because an event was added or removed.

Second, that is completely different from how x86 works. Folks don't
want to know how to use BRBE. They want to do perf branch stack
recording like they already do on existing platforms. That's what has
been implemented here with the behavior as close as possible even for
corner cases that seem questionable. For the userspace counter access
support, folks were upset that it has to be explicitly enabled (in
sysctl) and requested (in a configX bit) when you don't on x86. People
notice and care if the behavior is different.

> To be clear, an important factor is the trace modes with modifier 'u'
> (user) and 'k' (kernel) should be supported for different events and for
> different sessions.  In a mixed cases (some events are userspace only
> and some are kernel only), the BRBE driver needs to filter out branch
> records for specific mode when taking a sample.
>
> > > If we can unify branch filter within a perf session, would this be
> > > much easier for handling?
> >
> > Do you mean if the perf tool ensured that all events in a given session
> > had the same filter? From the kernel's PoV there's no such thing as a
> > "perf session", and I'm not sure whether you're suggesting doing that i=
n
> > userspace or withing the kernel.
>
> My understanding is this would be not difficult to do such kind checking
> in the tool.  E.g., the perf tool can iterate every event and check the
> branch filter and detect incompabile issue.

You could detect that in perf tool, but you can never do it in every
tool because anyone can write their own.

> > Doing that in the perf tool would certianly make a stronger argument fo=
r
> > the kernel taking the "reject conflicting branch filters" option.
> >
> > Doing that within the kernel isn't really possible.
>
> As said above, if the BRBE driver can provide a knob in sysfs to indicate
> what is the current branch filter in the existed sessions, this would be
> helpful for the tool to do the checking and remind users.
>
> I haven't done any experiments for this. If you think this is the way
> to move forward, I might do a prototype and get back to you to ensure we
> don't run into any unexpected issues.

I don't think anyone does. I think this whole discussion has gone into
the weeds.

Rob
