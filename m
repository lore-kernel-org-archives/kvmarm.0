Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2247818A6D7
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738772167; cv=none; b=NnNp1fU7f3vzb7fcq+JaFmP1mcYOxobv1uQ1zuOvm68sFaKoloI1jVuF7pvxSl7N/OglqnyN8v/xOE+57Qzus6dfA7meBU+v72qxfhlUQ1251Ky29fWwBCUO2WCwQi0Y8+/pQe0qUdfGcsgF/TdtlEejmKqvYE3T25fHLa//PcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738772167; c=relaxed/simple;
	bh=zb/iX4Cf+0Jzol0g4P79TQLGHW78nLKS0momp3r6Gsg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OtLBYWYbMaqyM1AO/XF/AJklsNwrv0Kz1Om3L9Ent157rGE9lAgtL+RlJKUHHnxt2nrMwGT3xESGMEw3EJ6ADA/0R80Ohlxq0LbwqOfkifDLHPWY2EgFetuZ/ueMBqnKWGVNDYf2OvqkvBL7AGadnAstu8cIvK1+ujH5j7CHZmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=htWNq/qq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="htWNq/qq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F353CC4CED6
	for <kvmarm@lists.linux.dev>; Wed,  5 Feb 2025 16:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738772167;
	bh=zb/iX4Cf+0Jzol0g4P79TQLGHW78nLKS0momp3r6Gsg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=htWNq/qqQKRHbPxlhkjEc9yURkuuV7MOIpK6DIoK+fxKZZ0/H3OdNbk1nrMtqVcIV
	 wpv14TwYYMZY4wWzj6D26D2EkiWY6SBoSUQNLd3xobZdsNHF8OXwD1Ka3YiAo0TPik
	 YwFYWL0dtsmtQRE4xVFPTJbzwE/zUl+GSkndE8m0+OD0VCAnjo5QDoBPP7AmoQH7IQ
	 6tgmf5uQmt2HZ5Jmi0Jy2C1ZP513Nuo9qV2TSlGzbQr9dcLcFoexJHmvybho38ukas
	 7csNv/zJ7AHSeC13suKRFBV3OqEh6xy6wnqMgf2txe5bP2I3zBBsONYtit8hUpljdK
	 bCZuHMA/+T9yg==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5dcea5d8f16so384319a12.2
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 08:16:06 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUafFFMFGctyN0/20mykHK4EQZg5VAw9JxizIYATyW9wA8ISFHtGedPETHIS7t7MFTnwd29YjQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxdDNW0WTBJ+Fd0iXyoirNuFyBdAx1jOshlf3DyeqhplaeiBixV
	PLvIrv42QevA/JYK6i51FkYdCUQOoRfjHBgakXWKhV7bUGkp7chkKi/iE4xkn9RsfoqlFMiQoG5
	/+PZbiGEJkHID0PzNd0IsRiBEtw==
X-Google-Smtp-Source: AGHT+IF47XQkSGXjWRrqSSirUPlUOCBjYFDjH0/GAFZRbqnMaUXk4XT8o2qq8MuQTNdO8oVrfaizAVU50e2YjSe04BM=
X-Received: by 2002:a05:6402:4342:b0:5db:68ce:2125 with SMTP id
 4fb4d7f45d1cf-5dcdb717867mr3836131a12.14.1738772165454; Wed, 05 Feb 2025
 08:16:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org> <0415d354-0c44-4fff-b92b-b0f5c9c72b11@linaro.org>
 <CAL_JsqKTNDQn9omG3g=6Rb4Nwt6hG9Gw7-VXL_fjQeEQmmtJQg@mail.gmail.com>
 <630f630d-241e-45f5-b449-243147fb888b@linaro.org> <CAL_JsqKY8MjD=iFf6MiT04WmCHYUxGtWG9JfX5-5fuG32F77qQ@mail.gmail.com>
 <3c7e1ce0-9a5d-43fb-9767-8e4ca92a450d@linaro.org>
In-Reply-To: <3c7e1ce0-9a5d-43fb-9767-8e4ca92a450d@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Wed, 5 Feb 2025 10:15:54 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKHGROJa1EW94iy1XzCadEst-hPWZY2BmxKgMB93nDp4w@mail.gmail.com>
X-Gm-Features: AWEUYZmD0GhWsXkOM4VInQT6jDCLQRcl1WRNEY-U-AEgGQ8zURnAJv3OUj_QUT4
Message-ID: <CAL_JsqKHGROJa1EW94iy1XzCadEst-hPWZY2BmxKgMB93nDp4w@mail.gmail.com>
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: James Clark <james.clark@linaro.org>, Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 5, 2025 at 8:38=E2=80=AFAM James Clark <james.clark@linaro.org>=
 wrote:
> On 04/02/2025 3:03 pm, Rob Herring wrote:
> > On Tue, Feb 4, 2025 at 6:03=E2=80=AFAM James Clark <james.clark@linaro.=
org> wrote:
> >> On 03/02/2025 5:58 pm, Rob Herring wrote:
> >>> On Mon, Feb 3, 2025 at 10:53=E2=80=AFAM James Clark <james.clark@lina=
ro.org> wrote:
> >>>> On 03/02/2025 12:43 am, Rob Herring (Arm) wrote:
> >>>>> From: Anshuman Khandual <anshuman.khandual@arm.com>
> >>>>>
> >>>>> The ARMv9.2 architecture introduces the optional Branch Record Buff=
er
> >>>>> Extension (BRBE), which records information about branches as they =
are
> >>>>> executed into set of branch record registers. BRBE is similar to x8=
6's
> >>>>> Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffe=
r
> >>>>> (BHRB).
> >
> > [...]
> >
> >>>>> +     /*
> >>>>> +      * Require that the event filter and branch filter permission=
s match.
> >>>>> +      *
> >>>>> +      * The event and branch permissions can only mismatch if the =
user set
> >>>>> +      * at least one of the privilege branch filters in PERF_SAMPL=
E_BRANCH_PLM_ALL.
> >>>>> +      * Otherwise, the core will set the branch sample permissions=
 in
> >>>>> +      * perf_copy_attr().
> >>>>> +      */
> >>>>> +     if ((event->attr.exclude_user !=3D !(branch_type & PERF_SAMPL=
E_BRANCH_USER)) ||
> >>>>> +         (event->attr.exclude_kernel !=3D !(branch_type & PERF_SAM=
PLE_BRANCH_KERNEL)) ||
> >>>>
> >>>> I don't think this one is right. By default perf_copy_attr() copies =
the
> >>>> exclude_ settings into the branch settings so this works, but if the
> >>>> user sets any _less_ permissive branch setting this fails. For examp=
le:
> >>>>
> >>>>     # perf record -j any,u -- true
> >>>>     Error:
> >>>>     cycles:PH: PMU Hardware or event type doesn't support branch sta=
ck
> >>>>     sampling.
> >>>>
> >>>> Here we want the default sampling permissions (exclude_kernel =3D=3D=
 0,
> >>>> exclude_user =3D=3D 0), but only user branch records, which doesn't =
match.
> >>>> It should be allowed because it doesn't include anything that we're =
not
> >>>> allowed to see.
> >>>
> >>> I know it is allowed(on x86), but why would we want that? If you do
> >>> something even more restricted:
> >>>
> >>> perf record -e cycles:k -j any,u -- true
> >>>
> >>> That's allowed on x86 and gives you samples with user addresses. But
> >>> all the events happened in the kernel. How does that make any sense?
> >>>
> >>> I suppose in your example, we could avoid attaching branch stack on
> >>> samples from the kernel. However, given how my example works, I'm
> >>> pretty sure that's not what x86 does.
> >>>
> >>> There's also combinations that are allowed, but record no samples.
> >>> Though I think that was with guest events. I've gone with reject
> >>> non-sense combinations as much as possible. We can easily remove thos=
e
> >>> restrictions later if needed. Changing the behavior later (for the
> >>> same configuration) wouldn't be good.
> >>>
> >>>
> >>
> >> Rejecting ones that produce no samples is fair enough, but my example
> >> does produce samples. To answer the question "why would we want that?"=
,
> >> nothing major, but there are a few small reasons:
> >>
> >>    * Perf includes both user and kernel by default, so the shortest
> >>      command to only gather user branches doesn't work (-j any,u)
> >>    * The test already checks for branch stack support like this, so ol=
d
> >>      Perf test versions don't work
> >
> > I would be more concerned about this one except that *we* wrote that
> > test. (I'm not sure why we wrote a new test rather than adapting
> > record_lbr.sh...)
> >
>
> record_lbr.sh was added 6 months ago, test_brstack.sh 3 years ago so
> it's the other way around.

Sigh...

> Although record_lbr.sh also tests --call-graph and --stitch-lbr as well,
> so I think it's fine for test_brstack.sh to test only --branch-filter
> options at the lowest level.
>
> Looking at that test though I see there is a capability
> "/sys/devices/cpu/caps/branches". I'm wondering whether we should be
> adding that on the Arm PMU for BRBE?

I noticed that too. I suppose we should. Though I suppose that could
give weird results if userspace is expecting LBR. Adding that would
make record_lbr.sh run and then the LBR callgraph test is going to
fail.

> Ignoring the tests, the man pages (and some pages on the internet) give
> this example: "--branch-filter any_ret,u,k". This doesn't work either
> because it doesn't match the default exclude_hv option. It just seems a
> bit awkward and incompatible to me, for not much gain.
>
> >>    * You might only be optimising userspace, but still interested in t=
he
> >>      proportion of time spent or particular place in the kernel
> >
> > How do you see that? It looks completely misleading to me. 'perf
> > report' seems to only list branch stack addresses in this case. There
> > doesn't seem to be any matching of the event address to branch stack
> > addresses.
> >
>
> Perf script will show everything with all it's various options, or
> --branch-history on perf report will show both too. Also there are tools
> other than Perf, AutoFDO seems like something that BRBE can be used with.
>
> >>    * Consistency with existing implementations and for people porting
> >>      existing tools to Arm
> >>    * It doesn't cost anything to support it (I think we just
> >>      only check if exclude_* is set rather than !=3D)
> >>    * Permissions checks should be handled by the core code so that
> >>      they're consistent
> >>    * What's the point of separate branch filters anyway if they always
> >>      have to match the event filter?
> >
> > IDK, I wish someone could tell me. I don't see the usecase for them
> > being mismatched.
> >
> > In any case, I don't care too much one way or the other what we do
> > here. If everyone thinks we should relax this, then that's fine with
> > me.
> >
>
> Seeing the branch history from userspace that led up to a certain thing
> in the kernel happening doesn't seem like that much of an edge case to
> me. If you always have to have both on then you lose the userspace
> branch history because the buffer isn't that big and gets overwritten.

Okay, let's drop this check...

> >> Some of these things could be fixed in Perf, but not in older versions=
.
> >> Even if we can't think of a real use case now, it doesn't sound like t=
he
> >> driver should be so restrictive of an option that doesn't do any harm.
> >>
> >>>> This also makes the Perf branch test skip because it uses
> >>>> any,save_type,u to see if BRBE exists.
> >>>
> >>> Yes, I plan to update that if we keep this behavior.
> >>>
> >>>>> +         (!is_kernel_in_hyp_mode() &&
> >>>>> +          (event->attr.exclude_hv !=3D !(branch_type & PERF_SAMPLE=
_BRANCH_HV))))
> >>>>> +             return false;
> >>>>> +
> >>>>> +     event->hw.branch_reg.config =3D branch_type_to_brbfcr(event->=
attr.branch_sample_type);
> >>>>> +     event->hw.extra_reg.config =3D branch_type_to_brbcr(event->at=
tr.branch_sample_type);
> >>>>> +
> >>>>> +     return true;
> >>>>> +}
> >>>>> +
> >>>> [...]
> >>>>> +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG=
_EXIT + 1][2] =3D {
> >>>>> +     [BRBINFx_EL1_TYPE_DIRECT_UNCOND] =3D { PERF_BR_UNCOND, 0 },
> >>>>
> >>>> Does the second field go into 'new_type'? They all seem to be zero s=
o
> >>>> I'm not sure why new_type isn't ignored instead of having it mapped.
> >>>
> >>> Well, left over from when all the Arm specific types were supported.
> >>> So yeah, that can be simplified.
> >>>
> >>>>> +     [BRBINFx_EL1_TYPE_INDIRECT] =3D { PERF_BR_IND, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_DIRECT_LINK] =3D { PERF_BR_CALL, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_INDIRECT_LINK] =3D { PERF_BR_IND_CALL, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_RET] =3D { PERF_BR_RET, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_DIRECT_COND] =3D { PERF_BR_COND, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_CALL, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_ERET] =3D { PERF_BR_ERET, 0 },
> >>>>> +     [BRBINFx_EL1_TYPE_IRQ] =3D { PERF_BR_IRQ, 0 },
> >>>>
> >>>> How do ones that don't map to anything appear in Perf? For example
> >>>> BRBINFx_EL1_TYPE_TRAP is missing, and the test that was attached to =
the
> >>>> previous versions fails because it doesn't see the trap that jumps t=
o
> >>>> the kernel, but it does still see the ERET back to userspace:
> >>>>
> >>>>      [unknown]/trap_bench+0x20/-/-/-/0/ERET/-
> >>>>
> >>>> In older versions we'd also have BRBINFx_EL1_TYPE_TRAP mapping to
> >>>> PERF_BR_SYSCALL so you could see it go into the kernel before the re=
turn:
> >>>>
> >>>>      trap_bench+0x1C/[unknown]/-/-/-/0/SYSCALL/-
> >>>>      [unknown]/trap_bench+0x20/-/-/-/0/ERET/-
> >>>
> >>> My read of that was we should see a CALL in this case. Whether SVC
> >>> generates a TRAP or CALL depends on HFGITR_EL2.SVC_EL0 (table D18-2).
> >>> I assumed "SVC due to HFGITR_EL2.SVC_EL0" means when SVC_EL0 is set
> >>> (and set has additional conditions). We have SVC_EL0 cleared, so that
> >>> should be a CALL. Maybe the FVP has this wrong?
> >>>
> >>
> >> The test is doing this rather than a syscall:
> >>
> >>     asm("mrs %0, ID_AA64ISAR0_EL1" : "=3Dr" (val));   /* TRAP + ERET *=
/
> >>
> >> So I think trap is right. Whether that should be mapped to SYSCALL or
> >> some other branch type I don't know, but the point is that it's missin=
g now.
> >
> > We aren't supporting any of the Arm specific traps/exceptions. One
> > reason is for consistency with x86 like you just argued for. The only
>
> Does x86 leave holes in the program flow though, or is it complete? IMO
> it makes it harder for tools to make sense of the branch buffer if there
> are things like an ERET with no previous trap to match it up to.

I'll have to test that. x86 has SYSRET for "syscall return". We added
ERET which maps to x86 interrupt return. So I guess x86 only records
syscalls and their returns. There's also "sw interrupt" on x86 which
gets mapped to PERF_BR_UNKNOWN. I don't think there's any way for us
to distinguish a syscall return from any other exception return.

> > exception types supported are syscall and IRQ. Part of the issue is
> > there is no userspace control over enabling all the extra Arm ones.
> > There's no way to say enable all branches except debug, fault, etc.
> > exceptions. If we want to support these, I think there should be user
> > control over enabling them. But that can come later if there's any
> > demand for them.
> >
> > Rob
>
> In this patchset we enable PERF_BR_IRQ with PERF_SAMPLE_BRANCH_ANY,
> without any way to selectively disable it. I would assume trap could be
> done with the same option.

If I was designing the interface, I would make PERF_BR_IRQ separately
controllable. But we're kind of stuck with what x86 did. I suppose we
could add a negative 'noirq' option.

Are you of the opinion that we should enable everything or some subset
of them? There's basically inst/data/algn faults, FIQ, SError, and
debug. The debug ones seem questionable to me, or at least ones you'd
want to opt-in for. For FIQ, if that's used by secure world, do we
want non-secure world recording when FIQs happen? Could the timing of
those be used maliciously?

> If we're filtering some of them out it might be worth documenting that
> "PERF_SAMPLE_BRANCH_ANY" doesn't actually mean 'any' branch type on Arm,
> and some types are recorded but discarded out before sending to userspace=
.
>
> There could be some confusion when there are partially filled or empty
> branch buffers, and the reason wouldn't be that there weren't any
> branches recorded, but they were all filtered out even with the 'any'
> option.

Fair enough. I think we need Mark to chime in here. He was questioning
the need for these.

Rob
