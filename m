Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F69A214236
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 15:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738681400; cv=none; b=hb5ZhMJdU5PDZw1y8w0GCh8+jkCRj3mh+7r5aOUIblHV4yh4NIEKVraKUOxsT1unrJxN0VV0EyzI4byOGKvp3NqEqLAiTM4CxrgP4EGRqTF1m2D9pBfsLfn0pIQBdkXAfAuzQk7EXmZjyEv8t7XKNRnB4Bhp3xZSTssWpj226w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738681400; c=relaxed/simple;
	bh=jhMkfQpqSwDaWVRZTXpkSW3tRYPATJt8Etvq7/EL84w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MR26aaajUUxPjluCYQcwh4mZAztBy8X5sLst6Mdg2HjoTEYR7wCZAWrs/VLGqBM5dbeFf1meRHVhHMlhNjjbMikDV7yRnvfV4y0AzGq/6F58uNw3otlQWw8RfRnxjT0veweJw7/hyAPVLaXYxzcTR4EA6k+zncJ3FyLg9j8DTMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iypti+lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iypti+lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08692C4CEE6
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 15:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738681400;
	bh=jhMkfQpqSwDaWVRZTXpkSW3tRYPATJt8Etvq7/EL84w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iypti+lwnmJGe8LHCVj2kHAJjkxS7DXSiN4A2ID7vUhakywz1tTrVEXcXVZvBR0Js
	 FlWc2eSQDUkdq6SlrDS8fyO+z2yPfJcnr3cwfz6mlfeDfTPDBcvaSojULHU1krEy+X
	 nyiTe6vaCjVQY1SU+uMBI6FqUfugWljFA39mbnLgjk+ZB/ObaSdX2wDXHMfgRINSVn
	 G+Qmu5qcL6x12bmDY+uiC2rE0EO+/duSQYaWi+uz7ppO/G2HsA6/+MAtlx/KbI7OLw
	 6siIXPbyakzxQitDgdrJNdGc2uXneRlui7LS55M0LDLfSf68jo11n2YBibdLn+sNB3
	 6St75/clRGSJA==
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d9837f201aso12501486a12.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 07:03:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVMiiWDDGuHY+rGjSuQbNuipZWXcJmoxMSzJhU599wU/VFSHgZgPeXRD5tswkeZmcMTU400K2k=@lists.linux.dev
X-Gm-Message-State: AOJu0YyyA1Sy/n+lymjPIYR7vW8uNfeIEOkVDxofTwDzivBlnQsR6keX
	lBNIZFNnoIvANAYEn/Kzn4Z3YfQIDoHouiBXbetsC8S1+zlv5FNh7lwVQzjZmfIuVIhDJP78fGs
	n33/Z7wxrZWqO4FHf3Fw5HO9qgA==
X-Google-Smtp-Source: AGHT+IENEURzLRNiZi1exSUbRsfLQACupPN2TVRIQ63la/qLnFqLYYnSvU9uAnVqq7GIU4IdYJDUrq0U8XwnGxM/A+A=
X-Received: by 2002:a05:6402:50d2:b0:5dc:742c:c8eb with SMTP id
 4fb4d7f45d1cf-5dcc14df237mr4013233a12.12.1738681398413; Tue, 04 Feb 2025
 07:03:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org> <0415d354-0c44-4fff-b92b-b0f5c9c72b11@linaro.org>
 <CAL_JsqKTNDQn9omG3g=6Rb4Nwt6hG9Gw7-VXL_fjQeEQmmtJQg@mail.gmail.com> <630f630d-241e-45f5-b449-243147fb888b@linaro.org>
In-Reply-To: <630f630d-241e-45f5-b449-243147fb888b@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Tue, 4 Feb 2025 09:03:07 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKY8MjD=iFf6MiT04WmCHYUxGtWG9JfX5-5fuG32F77qQ@mail.gmail.com>
X-Gm-Features: AWEUYZn07afytmkExOLqg36iepnudH1LwZEnJA4-1WkAzEuXWTMcnL9fgzBMWAs
Message-ID: <CAL_JsqKY8MjD=iFf6MiT04WmCHYUxGtWG9JfX5-5fuG32F77qQ@mail.gmail.com>
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: James Clark <james.clark@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 4, 2025 at 6:03=E2=80=AFAM James Clark <james.clark@linaro.org>=
 wrote:
>
>
>
> On 03/02/2025 5:58 pm, Rob Herring wrote:
> > On Mon, Feb 3, 2025 at 10:53=E2=80=AFAM James Clark <james.clark@linaro=
.org> wrote:
> >>
> >>
> >>
> >> On 03/02/2025 12:43 am, Rob Herring (Arm) wrote:
> >>> From: Anshuman Khandual <anshuman.khandual@arm.com>
> >>>
> >>> The ARMv9.2 architecture introduces the optional Branch Record Buffer
> >>> Extension (BRBE), which records information about branches as they ar=
e
> >>> executed into set of branch record registers. BRBE is similar to x86'=
s
> >>> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> >>> (BHRB).

[...]

> >>> +     /*
> >>> +      * Require that the event filter and branch filter permissions =
match.
> >>> +      *
> >>> +      * The event and branch permissions can only mismatch if the us=
er set
> >>> +      * at least one of the privilege branch filters in PERF_SAMPLE_=
BRANCH_PLM_ALL.
> >>> +      * Otherwise, the core will set the branch sample permissions i=
n
> >>> +      * perf_copy_attr().
> >>> +      */
> >>> +     if ((event->attr.exclude_user !=3D !(branch_type & PERF_SAMPLE_=
BRANCH_USER)) ||
> >>> +         (event->attr.exclude_kernel !=3D !(branch_type & PERF_SAMPL=
E_BRANCH_KERNEL)) ||
> >>
> >> I don't think this one is right. By default perf_copy_attr() copies th=
e
> >> exclude_ settings into the branch settings so this works, but if the
> >> user sets any _less_ permissive branch setting this fails. For example=
:
> >>
> >>    # perf record -j any,u -- true
> >>    Error:
> >>    cycles:PH: PMU Hardware or event type doesn't support branch stack
> >>    sampling.
> >>
> >> Here we want the default sampling permissions (exclude_kernel =3D=3D 0=
,
> >> exclude_user =3D=3D 0), but only user branch records, which doesn't ma=
tch.
> >> It should be allowed because it doesn't include anything that we're no=
t
> >> allowed to see.
> >
> > I know it is allowed(on x86), but why would we want that? If you do
> > something even more restricted:
> >
> > perf record -e cycles:k -j any,u -- true
> >
> > That's allowed on x86 and gives you samples with user addresses. But
> > all the events happened in the kernel. How does that make any sense?
> >
> > I suppose in your example, we could avoid attaching branch stack on
> > samples from the kernel. However, given how my example works, I'm
> > pretty sure that's not what x86 does.
> >
> > There's also combinations that are allowed, but record no samples.
> > Though I think that was with guest events. I've gone with reject
> > non-sense combinations as much as possible. We can easily remove those
> > restrictions later if needed. Changing the behavior later (for the
> > same configuration) wouldn't be good.
> >
> >
>
> Rejecting ones that produce no samples is fair enough, but my example
> does produce samples. To answer the question "why would we want that?",
> nothing major, but there are a few small reasons:
>
>   * Perf includes both user and kernel by default, so the shortest
>     command to only gather user branches doesn't work (-j any,u)
>   * The test already checks for branch stack support like this, so old
>     Perf test versions don't work

I would be more concerned about this one except that *we* wrote that
test. (I'm not sure why we wrote a new test rather than adapting
record_lbr.sh...)

>   * You might only be optimising userspace, but still interested in the
>     proportion of time spent or particular place in the kernel

How do you see that? It looks completely misleading to me. 'perf
report' seems to only list branch stack addresses in this case. There
doesn't seem to be any matching of the event address to branch stack
addresses.

>   * Consistency with existing implementations and for people porting
>     existing tools to Arm
>   * It doesn't cost anything to support it (I think we just
>     only check if exclude_* is set rather than !=3D)
>   * Permissions checks should be handled by the core code so that
>     they're consistent
>   * What's the point of separate branch filters anyway if they always
>     have to match the event filter?

IDK, I wish someone could tell me. I don't see the usecase for them
being mismatched.

In any case, I don't care too much one way or the other what we do
here. If everyone thinks we should relax this, then that's fine with
me.

> Some of these things could be fixed in Perf, but not in older versions.
> Even if we can't think of a real use case now, it doesn't sound like the
> driver should be so restrictive of an option that doesn't do any harm.
>
> >> This also makes the Perf branch test skip because it uses
> >> any,save_type,u to see if BRBE exists.
> >
> > Yes, I plan to update that if we keep this behavior.
> >
> >>> +         (!is_kernel_in_hyp_mode() &&
> >>> +          (event->attr.exclude_hv !=3D !(branch_type & PERF_SAMPLE_B=
RANCH_HV))))
> >>> +             return false;
> >>> +
> >>> +     event->hw.branch_reg.config =3D branch_type_to_brbfcr(event->at=
tr.branch_sample_type);
> >>> +     event->hw.extra_reg.config =3D branch_type_to_brbcr(event->attr=
.branch_sample_type);
> >>> +
> >>> +     return true;
> >>> +}
> >>> +
> >> [...]
> >>> +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_E=
XIT + 1][2] =3D {
> >>> +     [BRBINFx_EL1_TYPE_DIRECT_UNCOND] =3D { PERF_BR_UNCOND, 0 },
> >>
> >> Does the second field go into 'new_type'? They all seem to be zero so
> >> I'm not sure why new_type isn't ignored instead of having it mapped.
> >
> > Well, left over from when all the Arm specific types were supported.
> > So yeah, that can be simplified.
> >
> >>> +     [BRBINFx_EL1_TYPE_INDIRECT] =3D { PERF_BR_IND, 0 },
> >>> +     [BRBINFx_EL1_TYPE_DIRECT_LINK] =3D { PERF_BR_CALL, 0 },
> >>> +     [BRBINFx_EL1_TYPE_INDIRECT_LINK] =3D { PERF_BR_IND_CALL, 0 },
> >>> +     [BRBINFx_EL1_TYPE_RET] =3D { PERF_BR_RET, 0 },
> >>> +     [BRBINFx_EL1_TYPE_DIRECT_COND] =3D { PERF_BR_COND, 0 },
> >>> +     [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_CALL, 0 },
> >>> +     [BRBINFx_EL1_TYPE_ERET] =3D { PERF_BR_ERET, 0 },
> >>> +     [BRBINFx_EL1_TYPE_IRQ] =3D { PERF_BR_IRQ, 0 },
> >>
> >> How do ones that don't map to anything appear in Perf? For example
> >> BRBINFx_EL1_TYPE_TRAP is missing, and the test that was attached to th=
e
> >> previous versions fails because it doesn't see the trap that jumps to
> >> the kernel, but it does still see the ERET back to userspace:
> >>
> >>     [unknown]/trap_bench+0x20/-/-/-/0/ERET/-
> >>
> >> In older versions we'd also have BRBINFx_EL1_TYPE_TRAP mapping to
> >> PERF_BR_SYSCALL so you could see it go into the kernel before the retu=
rn:
> >>
> >>     trap_bench+0x1C/[unknown]/-/-/-/0/SYSCALL/-
> >>     [unknown]/trap_bench+0x20/-/-/-/0/ERET/-
> >
> > My read of that was we should see a CALL in this case. Whether SVC
> > generates a TRAP or CALL depends on HFGITR_EL2.SVC_EL0 (table D18-2).
> > I assumed "SVC due to HFGITR_EL2.SVC_EL0" means when SVC_EL0 is set
> > (and set has additional conditions). We have SVC_EL0 cleared, so that
> > should be a CALL. Maybe the FVP has this wrong?
> >
>
> The test is doing this rather than a syscall:
>
>    asm("mrs %0, ID_AA64ISAR0_EL1" : "=3Dr" (val));   /* TRAP + ERET */
>
> So I think trap is right. Whether that should be mapped to SYSCALL or
> some other branch type I don't know, but the point is that it's missing n=
ow.

We aren't supporting any of the Arm specific traps/exceptions. One
reason is for consistency with x86 like you just argued for. The only
exception types supported are syscall and IRQ. Part of the issue is
there is no userspace control over enabling all the extra Arm ones.
There's no way to say enable all branches except debug, fault, etc.
exceptions. If we want to support these, I think there should be user
control over enabling them. But that can come later if there's any
demand for them.

Rob
