Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E9C20CCD3
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 17:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738605552; cv=none; b=XP13Rz3rtsIorTh5ocufAM0hFkCwTYhyT1FzRQok5XWKi1FmsSv2wmzEfJXJFukI7QKzdJ8pmqNgnrDsZ1BVs7GikF4724ctyXOk4OZHFWSKaja09d28gThlEFY+1T9lBnKO+OQBCzdGqcorvms4QQMElUb5zah25vAg5DFakHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738605552; c=relaxed/simple;
	bh=NYO3rGYKGq/65zSa8Yhb1oMdNzXKxEcXM0kEMGBQF7s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tYJOPFRwL/oKvdRahILdO94R9/KQAwYqyHeji3M5zAdF30trqjv3ATC+w/zlFiQcicBDYGzH+P+uB5AhhUGycUM5MFgwjK3w9J57vZ0kfjE8ISsSOdtPFOws3WAusxrllllYWLbuO5QgcLpPZISEE1ZMUEe+K7+tTC19DT5wuFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ScFHSdce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ScFHSdce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B1FC4CEE6
	for <kvmarm@lists.linux.dev>; Mon,  3 Feb 2025 17:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738605552;
	bh=NYO3rGYKGq/65zSa8Yhb1oMdNzXKxEcXM0kEMGBQF7s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ScFHSdcenZR6DywHshTaqb1ulLuClK6Kmsjg0kKsq/TNx2w0xVWjidA8AB3bRviGL
	 pjdDBwffIko+KU4zWAProCrXL+qIhJydME6h7zkiKAcBgaRC/At+8FHlf4GqsPR2bT
	 dun2aiGEvBEgj7av7JV/N+8pG2ACRCTpuQepJ2D3B7M6TIysDZgHdIH00xRItkH5Uv
	 Y0bc/Yr98ep+XHlbE5PToO3i56nJxr4+Ope5hz//Sbr9NZ2tRb5U6hZLJ8fqiO5CEQ
	 FSGgb4pJ6upJjiy4F0lWBU1PLwXq9UQxaXzHLijY1/nIlmycU9J4PdH2mGhRWwHkVY
	 Ya5lMIU7tYMsQ==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-ab68a4ab074so579941766b.0
        for <kvmarm@lists.linux.dev>; Mon, 03 Feb 2025 09:59:12 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXejctPugPTW7vBdOMHznhyMfZPDvU1Qh8LirmaZ6NUlRGxO7/P8gq1vFNFAppkm0YuTpDys7o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwokjkIpFlWF9Q3YuKSu92zU3OEHV+b7zV0d5xgDz4I/u7zgsxm
	juraq8bN2j/ZqojvA6xXmg1qcgPmh+6BD+zcMnBGT9sTc5J21SzI0tulQd9fN560xr3eKA9Te6C
	pXyBCLdXjULsZbwCoZTqy4ygLsw==
X-Google-Smtp-Source: AGHT+IEdsLtUTCFhHBHehWhnH6ZSoMj0S/ddfazkY+M9dxn8pQMohG371Wdb2XPTrDBitsdh5IeDSi12HsBdL64hegA=
X-Received: by 2002:a05:6402:4401:b0:5dc:5a51:cbfa with SMTP id
 4fb4d7f45d1cf-5dc5efa8a90mr65097835a12.6.1738605549059; Mon, 03 Feb 2025
 09:59:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org> <0415d354-0c44-4fff-b92b-b0f5c9c72b11@linaro.org>
In-Reply-To: <0415d354-0c44-4fff-b92b-b0f5c9c72b11@linaro.org>
From: Rob Herring <robh@kernel.org>
Date: Mon, 3 Feb 2025 11:58:57 -0600
X-Gmail-Original-Message-ID: <CAL_JsqKTNDQn9omG3g=6Rb4Nwt6hG9Gw7-VXL_fjQeEQmmtJQg@mail.gmail.com>
X-Gm-Features: AWEUYZmpJbb38ZsiZGdd1EV6YAMwGMfSI1aHcHN4BsePETXUlz6CpgVooGpAEog
Message-ID: <CAL_JsqKTNDQn9omG3g=6Rb4Nwt6hG9Gw7-VXL_fjQeEQmmtJQg@mail.gmail.com>
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

On Mon, Feb 3, 2025 at 10:53=E2=80=AFAM James Clark <james.clark@linaro.org=
> wrote:
>
>
>
> On 03/02/2025 12:43 am, Rob Herring (Arm) wrote:
> > From: Anshuman Khandual <anshuman.khandual@arm.com>
> >
> > The ARMv9.2 architecture introduces the optional Branch Record Buffer
> > Extension (BRBE), which records information about branches as they are
> > executed into set of branch record registers. BRBE is similar to x86's
> > Last Branch Record (LBR) and PowerPC's Branch History Rolling Buffer
> > (BHRB).
> >
> > BRBE supports filtering by exception level and can filter just the
> > source or target address if excluded to avoid leaking privileged
> > addresses. The h/w filter would be sufficient except when there are
> > multiple events with disjoint filtering requirements. In this case, BRB=
E
> > is configured with a union of all the events' desired branches, and the=
n
> > the recorded branches are filtered based on each event's filter. For
> > example, with one event capturing kernel events and another event
> > capturing user events, BRBE will be configured to capture both kernel
> > and user branches. When handling event overflow, the branch records hav=
e
> > to be filtered by software to only include kernel or user branch
> > addresses for that event. In contrast, x86 simply configures LBR using
> > the last installed event which seems broken.
> >
> > The event and branch exception level filtering are separately
> > controlled. On x86, it is possible to request filtering which is
> > disjoint (e.g. kernel only event with user only branches). It is also
> > possible on x86 to configure branch filter such that no branches are
> > ever recorded (e.g. -j save_type). For BRBE, events with mismatched
> > exception level filtering or a configuration that will result in no
> > samples are rejected. This can be relaxed in the future if such a need
> > arises.
> >
> > The handling of KVM guests is similar to the above. On x86, branch
> > recording is always disabled when a guest is running. However,
> > requesting branch recording in guests is allowed. The guest events are
> > recorded, but the resulting branches are all from the host. For BRBE,
> > branch recording is similarly disabled when guest is running. In
> > addition, events with branch recording and "exclude_host" set are
> > rejected. Requiring "exclude_guest" to be set did not work. The default
> > for the perf tool does set "exclude_guest" if no exception level
> > options are specified. However, specifying kernel or user defaults to
> > including both host and guest. In this case, only host branches are
> > recorded.
> >
> > BRBE can support some additional exception, FIQ, and debug branch
> > types, but they are not supported currently. There's no control in the
> > perf ABI to enable/disable these branch types, so they could only be
> > enabled for the 'any' filter which might be undesired or unexpected.
> > The other architectures don't have any support similar events (at least
> > with perf). These can be added in the future if there is demand by
> > adding additional specific filter types.
> >
> > BRBE records are invalidated whenever events are reconfigured, a new
> > task is scheduled in, or after recording is paused (and the records
> > have been recorded for the event). The architecture allows branch
> > records to be invalidated by the PE under implementation defined
> > conditions. It is expected that these conditions are rare.
> >
> > Cc: Catalin Marinas <catalin.marinas@arm.com>
> > Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> > Co-developed-by: Mark Rutland <mark.rutland@arm.com>
> > Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> > Co-developed-by: Rob Herring (Arm) <robh@kernel.org>
> > Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> > ---
> > v19:
> > - Drop saving of branch records when task scheduled out. (Mark)
> > - Got rid of added armpmu ops. All BRBE support contained within pmuv3
> >    code.
> > - Dropped armpmu.num_branch_records as reg_brbidr has same info.
> > - Make sched_task() callback actually get called. Enabling requires a
> >    call to perf_sched_cb_inc().
> > - Fix freeze on overflow for VHE
> > - The cycle counter doesn't freeze BRBE on overflow, so avoid assigning
> >    it when BRBE is enabled.
> > - Drop all the Arm specific exception branches. Not a clear need for
> >    them.
> > - Simplify enable/disable to avoid RMW and document ISBs needed
> > - Fix handling of branch 'cycles' reading. CC field is
> >    mantissa/exponent, not an integer.
> > - Save BRBFCR and BRBCR settings in event->hw.branch_reg.config and
> >    event->hw.extra_reg.config to avoid recalculating the register value
> >    each time the event is installed.
> > - Rework s/w filtering to better match h/w filtering
> > - Reject events with disjoint event filter and branch filter
> > - Reject events if exclude_host is set
> >
> > v18: https://lore.kernel.org/all/20240613061731.3109448-6-anshuman.khan=
dual@arm.com/
> > ---
> >   drivers/perf/Kconfig         |  11 +
> >   drivers/perf/Makefile        |   1 +
> >   drivers/perf/arm_brbe.c      | 794 ++++++++++++++++++++++++++++++++++=
+++++++++
> >   drivers/perf/arm_brbe.h      |  47 +++
> >   drivers/perf/arm_pmu.c       |  15 +-
> >   drivers/perf/arm_pmuv3.c     |  87 ++++-
> >   include/linux/perf/arm_pmu.h |   8 +
> >   7 files changed, 958 insertions(+), 5 deletions(-)
> >
> [...]
> > +bool brbe_branch_attr_valid(struct perf_event *event)
> > +{
> > +     u64 branch_type =3D event->attr.branch_sample_type;
> > +
> > +     /*
> > +      * Ensure both perf branch filter allowed and exclude
> > +      * masks are always in sync with the generic perf ABI.
> > +      */
> > +     BUILD_BUG_ON(BRBE_PERF_BRANCH_FILTERS !=3D (PERF_SAMPLE_BRANCH_MA=
X - 1));
> > +
> > +     if (branch_type & BRBE_EXCLUDE_BRANCH_FILTERS) {
> > +             pr_debug_once("requested branch filter not supported 0x%l=
lx\n", branch_type);
> > +             return false;
> > +     }
> > +
> > +     /* Ensure at least 1 branch type is enabled */
> > +     if (!(branch_type & BRBE_ALLOWED_BRANCH_TYPES)) {
> > +             pr_debug_once("no branch type enabled 0x%llx\n", branch_t=
ype);
> > +             return false;
> > +     }
> > +
> > +     /*
> > +      * No branches are recorded in guests nor nVHE hypervisors, so
> > +      * excluding the host or both kernel and user is invalid.
> > +      *
> > +      * Ideally we'd just require exclude_guest and exclude_hv, but se=
tting
> > +      * event filters with perf for kernel or user don't set exclude_g=
uest.
> > +      * So effectively, exclude_guest and exclude_hv are ignored.
> > +      */
> > +     if (event->attr.exclude_host || (event->attr.exclude_user && even=
t->attr.exclude_kernel))
> > +             return false;
>
> Is there a reason to do the pr_debugs for the two cases above, but not
> for the remaining ones? Seems like it should be all or nothing.

Shrug. Anshuman wrote the pr_debugs. I wrote this part. Honestly, I
don't know why you'd want them only once if they are gated off by
debug. I guess since other cases of rejecting events outside this
function have pr_debug() we should do the same here.

> > +
> > +     /*
> > +      * Require that the event filter and branch filter permissions ma=
tch.
> > +      *
> > +      * The event and branch permissions can only mismatch if the user=
 set
> > +      * at least one of the privilege branch filters in PERF_SAMPLE_BR=
ANCH_PLM_ALL.
> > +      * Otherwise, the core will set the branch sample permissions in
> > +      * perf_copy_attr().
> > +      */
> > +     if ((event->attr.exclude_user !=3D !(branch_type & PERF_SAMPLE_BR=
ANCH_USER)) ||
> > +         (event->attr.exclude_kernel !=3D !(branch_type & PERF_SAMPLE_=
BRANCH_KERNEL)) ||
>
> I don't think this one is right. By default perf_copy_attr() copies the
> exclude_ settings into the branch settings so this works, but if the
> user sets any _less_ permissive branch setting this fails. For example:
>
>   # perf record -j any,u -- true
>   Error:
>   cycles:PH: PMU Hardware or event type doesn't support branch stack
>   sampling.
>
> Here we want the default sampling permissions (exclude_kernel =3D=3D 0,
> exclude_user =3D=3D 0), but only user branch records, which doesn't match=
.
> It should be allowed because it doesn't include anything that we're not
> allowed to see.

I know it is allowed(on x86), but why would we want that? If you do
something even more restricted:

perf record -e cycles:k -j any,u -- true

That's allowed on x86 and gives you samples with user addresses. But
all the events happened in the kernel. How does that make any sense?

I suppose in your example, we could avoid attaching branch stack on
samples from the kernel. However, given how my example works, I'm
pretty sure that's not what x86 does.

There's also combinations that are allowed, but record no samples.
Though I think that was with guest events. I've gone with reject
non-sense combinations as much as possible. We can easily remove those
restrictions later if needed. Changing the behavior later (for the
same configuration) wouldn't be good.


> This also makes the Perf branch test skip because it uses
> any,save_type,u to see if BRBE exists.

Yes, I plan to update that if we keep this behavior.

> > +         (!is_kernel_in_hyp_mode() &&
> > +          (event->attr.exclude_hv !=3D !(branch_type & PERF_SAMPLE_BRA=
NCH_HV))))
> > +             return false;
> > +
> > +     event->hw.branch_reg.config =3D branch_type_to_brbfcr(event->attr=
.branch_sample_type);
> > +     event->hw.extra_reg.config =3D branch_type_to_brbcr(event->attr.b=
ranch_sample_type);
> > +
> > +     return true;
> > +}
> > +
> [...]
> > +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXI=
T + 1][2] =3D {
> > +     [BRBINFx_EL1_TYPE_DIRECT_UNCOND] =3D { PERF_BR_UNCOND, 0 },
>
> Does the second field go into 'new_type'? They all seem to be zero so
> I'm not sure why new_type isn't ignored instead of having it mapped.

Well, left over from when all the Arm specific types were supported.
So yeah, that can be simplified.

> > +     [BRBINFx_EL1_TYPE_INDIRECT] =3D { PERF_BR_IND, 0 },
> > +     [BRBINFx_EL1_TYPE_DIRECT_LINK] =3D { PERF_BR_CALL, 0 },
> > +     [BRBINFx_EL1_TYPE_INDIRECT_LINK] =3D { PERF_BR_IND_CALL, 0 },
> > +     [BRBINFx_EL1_TYPE_RET] =3D { PERF_BR_RET, 0 },
> > +     [BRBINFx_EL1_TYPE_DIRECT_COND] =3D { PERF_BR_COND, 0 },
> > +     [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_CALL, 0 },
> > +     [BRBINFx_EL1_TYPE_ERET] =3D { PERF_BR_ERET, 0 },
> > +     [BRBINFx_EL1_TYPE_IRQ] =3D { PERF_BR_IRQ, 0 },
>
> How do ones that don't map to anything appear in Perf? For example
> BRBINFx_EL1_TYPE_TRAP is missing, and the test that was attached to the
> previous versions fails because it doesn't see the trap that jumps to
> the kernel, but it does still see the ERET back to userspace:
>
>    [unknown]/trap_bench+0x20/-/-/-/0/ERET/-
>
> In older versions we'd also have BRBINFx_EL1_TYPE_TRAP mapping to
> PERF_BR_SYSCALL so you could see it go into the kernel before the return:
>
>    trap_bench+0x1C/[unknown]/-/-/-/0/SYSCALL/-
>    [unknown]/trap_bench+0x20/-/-/-/0/ERET/-

My read of that was we should see a CALL in this case. Whether SVC
generates a TRAP or CALL depends on HFGITR_EL2.SVC_EL0 (table D18-2).
I assumed "SVC due to HFGITR_EL2.SVC_EL0" means when SVC_EL0 is set
(and set has additional conditions). We have SVC_EL0 cleared, so that
should be a CALL. Maybe the FVP has this wrong?

> > +};
> > +
> > +static void brbe_set_perf_entry_type(struct perf_branch_entry *entry, =
u64 brbinf)
> > +{
> > +     int brbe_type =3D brbinf_get_type(brbinf);
> > +
> > +     if (brbe_type <=3D BRBINFx_EL1_TYPE_DEBUG_EXIT) {
> > +             const int *br_type =3D brbe_type_to_perf_type_map[brbe_ty=
pe];
> > +
> > +             entry->type =3D br_type[0];
> > +             entry->new_type =3D br_type[1];
> > +     }
> > +}
> > +
>
> [...]
>
> > +     if (branch_sample & PERF_SAMPLE_BRANCH_ANY_RETURN) {
> > +             set_bit(PERF_BR_RET, event_type_mask);
> > +
> > +             if (!event->attr.exclude_kernel)
> > +                     set_bit(PERF_BR_ERET, event_type_mask);
>
> You could argue that ERET should be included even if exclude_kernel is
> set, otherwise you miss the point that you returned to in userspace and
> leave a gap in the program flow. See the trap and eret example above.
>
> It looks like we still have the zeroing of the kernel address in this
> version if we only have userspace priviledge, so it should be fine to
> show the ERET and the target address.

Yes, agreed.

Rob
