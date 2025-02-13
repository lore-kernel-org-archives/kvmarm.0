Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E9D1C863C
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 17:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739466843; cv=none; b=FObS6mY2StcM+NdIuD3u1LpEYefP3lW4aq44kN8MJrv33bWUOoYaxxHzLPUuymOn+IgTfHniKSCD0XdBEmqHRD7Zkjct3bteSTFe3m1ZAvfieZ2ToeV5k/Ji7EKqp1xDIw8HLUiyuzJVE/h/cpMO2bcjJtHnva/KQA+eoenn30I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739466843; c=relaxed/simple;
	bh=c5kpCmM/AUe0gxWM0ksdx93Irwzp3MjKsc8taJMFDkk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lO8MxYfadUqHJv7BAuQuDaB9ZJ54CVEGY0Vg09Y474b0WbSAxV5hXXHvE0hz6crCjnQfWotI2GU5HHClmz1mAinQ/EomQF7eDzxWdARqJGFgX/4vkm0pMIMtxPxdMu6JoFph9cFqmMpWLLSNpAeveY2TKRsNToep5cHGhomm7W8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VfsLGCVq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VfsLGCVq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D20C4AF09
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 17:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739466842;
	bh=c5kpCmM/AUe0gxWM0ksdx93Irwzp3MjKsc8taJMFDkk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VfsLGCVqcnvsz0EPdvO/D1d9L7HWoG9sBA+WrxnRRxQfjSfihFRkvreaFRvRRTKyc
	 T1Ml9RQ+KkPSVOC0sMPwwtGCINxRdZvohregL0RYui2+LL9BRWNH6wiNV8niVyjluN
	 LAz5PSyYyqh05V6STGXAf9maWUrTaqRlzKGmM0EBj2AFJLfrI8aljuDgDFe9/MJeqU
	 CzGabrkbRDo7Ag7oAwuW5ZiG+NwnZbU3y/I13/6a6Mxzyh0jHScQZaDwO78cTIf5Uv
	 pWi25M1o6osC7Pt00ERpTa+5xO8olPgpxqeTotApd+FfFQGxDq2+Zl+v76j4wJfeJR
	 PQxXyqv5eDKOQ==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab7ee6f54faso132066466b.2
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 09:14:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX9qeqazPvel/Z82eM/sVCtZZnnxsy+BnuOpR3toB3JaEUGhF5eGcamuvXpDwMTDQqa/ZNTig0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7hACkME9iq5p+TI2j+m7LOYAgtKmcEimfpASdDvC7R2+YPIAF
	aK0GGanJ+pLwWtYRSBp8+FPT8vLJpTvlEKZy4ny2piSKe64/i9jQq+tRXdmKiT9IoM4HO6eGGie
	WgcuEqzsJnL8gHMwsl6hXczVOnw==
X-Google-Smtp-Source: AGHT+IGLiNgkbdSgKYJxLv9yLc1GoCVMmMj+s80I6QXFJXsr3H3G985MmMlHVjvY6J6a3cMlBPrls5p737/5XQ9g0aM=
X-Received: by 2002:a05:6402:5285:b0:5dc:5a51:cbfa with SMTP id
 4fb4d7f45d1cf-5dec9d2c185mr11085898a12.6.1739466841112; Thu, 13 Feb 2025
 09:14:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250202-arm-brbe-v19-v19-0-1c1300802385@kernel.org>
 <20250202-arm-brbe-v19-v19-11-1c1300802385@kernel.org> <20250213161628.GF235556@e132581.arm.com>
In-Reply-To: <20250213161628.GF235556@e132581.arm.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 13 Feb 2025 11:13:49 -0600
X-Gmail-Original-Message-ID: <CAL_Jsq+VmfibMVdh+9DxqU5Axiv_zMiznAh8_umFB1J2y8reig@mail.gmail.com>
X-Gm-Features: AWEUYZl-h3OwTWUMTokpITINNaXk1-oL6xdH92FmLUNnd48obarnwJfoMpDQhGA
Message-ID: <CAL_Jsq+VmfibMVdh+9DxqU5Axiv_zMiznAh8_umFB1J2y8reig@mail.gmail.com>
Subject: Re: [PATCH v19 11/11] perf: arm_pmuv3: Add support for the Branch
 Record Buffer Extension (BRBE)
To: Leo Yan <leo.yan@arm.com>
Cc: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	James Clark <james.clark@linaro.org>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 10:16=E2=80=AFAM Leo Yan <leo.yan@arm.com> wrote:
>
> On Sun, Feb 02, 2025 at 06:43:05PM -0600, Rob Herring (Arm) wrote:
>
> [...]
>
> > +void brbe_enable(const struct arm_pmu *arm_pmu)
> > +{
> > +       struct pmu_hw_events *cpuc =3D this_cpu_ptr(arm_pmu->hw_events)=
;
> > +       u64 brbfcr =3D 0, brbcr =3D 0;
> > +
> > +       /*
> > +        * Merge the permitted branch filters of all events.
> > +        */
> > +       for (int i =3D 0; i < ARMPMU_MAX_HWEVENTS; i++) {
> > +               struct perf_event *event =3D cpuc->events[i];
> > +
> > +               if (event && has_branch_stack(event)) {
> > +                       brbfcr |=3D event->hw.branch_reg.config;
> > +                       brbcr |=3D event->hw.extra_reg.config;
> > +               }
> > +       }
> > +
> > +       /*
> > +        * If the record buffer contains any branches, we've already re=
ad them
> > +        * out and don't want to read them again.
> > +        * No need to sync as we're already stopped.
> > +        */
> > +       brbe_invalidate_nosync();
> > +       isb(); // Make sure invalidate takes effect before enabling
> > +
> > +       /*
> > +        * In VHE mode with MDCR_EL2.HPMN set to PMCR_EL0.N, the counte=
rs are
> > +        * controlled by BRBCR_EL1 rather than BRBCR_EL2 (which writes =
to
> > +        * BRBCR_EL1 are redirected to). Use the same value for both re=
gister
> > +        * except keep EL1 and EL0 recording disabled in guests.
> > +        */
> > +       if (is_kernel_in_hyp_mode())
> > +               write_sysreg_s(brbcr & ~(BRBCR_ELx_ExBRE | BRBCR_ELx_E0=
BRE), SYS_BRBCR_EL12);
> > +       write_sysreg_s(brbcr, SYS_BRBCR_EL1);
> > +       isb(); // Ensure BRBCR_ELx settings take effect before unpausin=
g
> > +
> > +       write_sysreg_s(brbfcr, SYS_BRBFCR_EL1);
>
> Seems to me, it is weird that first enable recording (BRBCR), then set
> control register BRBFCR.  And the writing SYS_BRBFCR_EL1 not guarded
> by a barrier is also a bit concerned.

We are always disabled (paused) when we enter brbe_enable(). So the
last thing we do is unpause. The only ordering we care about after
writing SYS_BRBFCR_EL1 is writing PMCR which has an isb before it is
written.

> > +}
> > +
> > +void brbe_disable(void)
> > +{
> > +       /*
> > +        * No need for synchronization here as synchronization in PMCR =
write
> > +        * ensures ordering and in the interrupt handler this is a NOP =
as
> > +        * we're already paused.
> > +        */
> > +       write_sysreg_s(BRBFCR_EL1_PAUSED, SYS_BRBFCR_EL1);
>
> Maybe the Arm ARM causes the confusion for the description of the
> PAUSED bit, I read it as this bit is a status bit to indicate
> branch recording is paused.

I agree, but I tested that writing it sets the bit (on FVP). Rule
RSRJND says s/w clears the bit to unpause, so it is definitely
writeable. While it doesn't say anything explicitly about s/w setting
the bit, there is no definition in the Arm ARM of a 'write 0 to clear'
only bit while there are W1C and W1S definitions.

> > +}
> > +
> > +static const int brbe_type_to_perf_type_map[BRBINFx_EL1_TYPE_DEBUG_EXI=
T + 1][2] =3D {
> > +       [BRBINFx_EL1_TYPE_DIRECT_UNCOND] =3D { PERF_BR_UNCOND, 0 },
> > +       [BRBINFx_EL1_TYPE_INDIRECT] =3D { PERF_BR_IND, 0 },
> > +       [BRBINFx_EL1_TYPE_DIRECT_LINK] =3D { PERF_BR_CALL, 0 },
> > +       [BRBINFx_EL1_TYPE_INDIRECT_LINK] =3D { PERF_BR_IND_CALL, 0 },
> > +       [BRBINFx_EL1_TYPE_RET] =3D { PERF_BR_RET, 0 },
> > +       [BRBINFx_EL1_TYPE_DIRECT_COND] =3D { PERF_BR_COND, 0 },
> > +       [BRBINFx_EL1_TYPE_CALL] =3D { PERF_BR_CALL, 0 },
> > +       [BRBINFx_EL1_TYPE_ERET] =3D { PERF_BR_ERET, 0 },
> > +       [BRBINFx_EL1_TYPE_IRQ] =3D { PERF_BR_IRQ, 0 },
>
> I saw this table cannot reflect the complete branch type.  We might
> need to consider to extend the perf branch flags later.
>
> If the 'new_type' is always zero, it is not necessary to maintain a
> array with two items (the second one is always 0).

I'm adding the new_type's back in the next version.

>
> > +};
> > +
> > +static void brbe_set_perf_entry_type(struct perf_branch_entry *entry, =
u64 brbinf)
> > +{
> > +       int brbe_type =3D brbinf_get_type(brbinf);
> > +
> > +       if (brbe_type <=3D BRBINFx_EL1_TYPE_DEBUG_EXIT) {
> > +               const int *br_type =3D brbe_type_to_perf_type_map[brbe_=
type];
> > +
> > +               entry->type =3D br_type[0];
> > +               entry->new_type =3D br_type[1];
> > +       }
> > +}
> > +
> > +static int brbinf_get_perf_priv(u64 brbinf)
> > +{
> > +       int brbe_el =3D brbinf_get_el(brbinf);
> > +
> > +       switch (brbe_el) {
> > +       case BRBINFx_EL1_EL_EL0:
> > +               return PERF_BR_PRIV_USER;
> > +       case BRBINFx_EL1_EL_EL1:
> > +               return PERF_BR_PRIV_KERNEL;
> > +       case BRBINFx_EL1_EL_EL2:
> > +               if (is_kernel_in_hyp_mode())
> > +                       return PERF_BR_PRIV_KERNEL;
> > +               return PERF_BR_PRIV_HV;
> > +       default:
> > +               pr_warn_once("%d - unknown branch privilege captured\n"=
, brbe_el);
> > +               return PERF_BR_PRIV_UNKNOWN;
> > +       }
> > +}
> > +
> > +static void capture_brbe_flags(struct perf_branch_entry *entry,
> > +                              const struct perf_event *event,
> > +                              u64 brbinf)
> > +{
> > +       brbe_set_perf_entry_type(entry, brbinf);
> > +
> > +       if (!branch_sample_no_cycles(event))
> > +               entry->cycles =3D brbinf_get_cycles(brbinf);
> > +
> > +       if (!branch_sample_no_flags(event)) {
> > +               /* Mispredict info is available for source only and com=
plete branch records. */
> > +               if (!brbe_record_is_target_only(brbinf)) {
> > +                       entry->mispred =3D brbinf_get_mispredict(brbinf=
);
> > +                       entry->predicted =3D !entry->mispred;
> > +               }
> > +
> > +               /*
> > +                * Currently TME feature is neither implemented in any =
hardware
> > +                * nor it is being supported in the kernel. Just warn h=
ere once
> > +                * if TME related information shows up rather unexpecte=
dly.
> > +                */
> > +               if (brbinf_get_lastfailed(brbinf) || brbinf_get_in_tx(b=
rbinf))
> > +                       pr_warn_once("Unknown transaction states\n");
>
> If the branch is in transaction, we can set:
>
>   entry->in_tx =3D 1;

We actively don't want to support the feature. The comment there is
from Mark's feedback on a prior version.

>
> > +       }
> > +
> > +       /*
> > +        * Branch privilege level is available for target only and comp=
lete
> > +        * branch records.
> > +        */
> > +       if (!brbe_record_is_source_only(brbinf))
> > +               entry->priv =3D brbinf_get_perf_priv(brbinf);
>
> This logic is not quite right.  In theory, if we check with above
> condition (!brbe_record_is_source_only(brbinf)), it might be the
> case both source and target are not valid.

We never get here if the record is not valid. A valid record must have
at least 1 address valid.

I could merge capture_brbe_flags() into perf_entry_from_brbe_regset().
There's not much reason to have a separate function.

Rob
