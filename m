Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A4015A84E
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 16:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718037790; cv=none; b=tPPEDPCWi3PBJ6CFC5bJvFEWac89RB/h6WqvVkHfdIxDEWt3f49VeWCWZQKdYnIoxlGQTiRfSW1lT/0x14qI0gmJEYVVys2Bhs7Rh2zY6o/33xXI94bHnkMclyolTDeygeotQ8rJ1pKbdPfaSRW2Z4OCijJTQtCl0Ako7CrkeGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718037790; c=relaxed/simple;
	bh=usayfudDL15Ak+7O16vBuNWB2nVZsclVG4R2lRWLypI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hB6M1rxZpSBuaoMZOFsFqp5Yq2i7qQepN/Q3r5skWtofMXNuu2wklzX5Svj7n9pt5Rh1ZRjbcKVmDLlkKOogn4+Ttu4+lNth/YHNrZaG4yIo1sc21pqPPgLojN41PcWsMa+e+padpz9nSovJuXy1TAQkW+A0aChxoNhW42Jn2Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tnl9aG4z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tnl9aG4z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA31C4AF5F
	for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 16:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718037790;
	bh=usayfudDL15Ak+7O16vBuNWB2nVZsclVG4R2lRWLypI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tnl9aG4zS3SZQKIX7jsA3xVVvt/+KXo2r4y8CARZk8ZnXuNRvnCIYrqE1kpBBcVJQ
	 wJF1Mmb5ljFUHrQlPKNlBIPmfvtIQLlnkzUuIrlJHjIr3pNz8Mn4F34Gd83RsOK7WT
	 ScNHdKu4iK9kkDD9uDhIhU0p8Ndsirr+HB7TmrOWfXhYX48yXY5KiNbD5gAFoDVDLB
	 SErcM052ykP6CmKGt1puMHJ4hJME6yVYQvE8Us9mYbufiuX1DYvK1QysWp+rKF+5US
	 gHFXDFEzfDahY43b5xqiutZM2zGCk4p4ETgGOp8MlcqZyHCe9BPBIiH71mn3JhfW70
	 IUbccCkZBfvGg==
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-52bc274f438so205242e87.0
        for <kvmarm@lists.linux.dev>; Mon, 10 Jun 2024 09:43:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXQUC8pUgL58FRxyl9bre7iRYIDAq7cE8EAAua5m1ikFnk1j1WmhuZ0Rj3WKgbthZCiRsIcUwA3BjrcHXaK2qOODTZagMxp
X-Gm-Message-State: AOJu0Yz0mgmAin6wQWwYxW6m+qBF/tX1NzcEeAJOzYEjpNJ64vjJ0kQC
	UaN5W6Vn44PlDv5jaW0gUTjcSQg4foUNk34bq4LH0GQjzFRCH+Hs04nXHUccNcc2Kr1SqhQligF
	EGD58cjmACh7VpS2VrxzoT2C5Gw==
X-Google-Smtp-Source: AGHT+IFbSJGXfUAWn3yeFEE6Vt8lJf4yOwgaLpwSa7ZjrDzQesdqm4cl//megHluZarInI+M0d+bC18lY/X2TjLaXtE=
X-Received: by 2002:ac2:53a6:0:b0:52b:c0a5:eae8 with SMTP id
 2adb3069b0e04-52bc0a5eb76mr5189629e87.14.1718037788484; Mon, 10 Jun 2024
 09:43:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240607-arm-pmu-3-9-icntr-v1-0-c7bd2dceff3b@kernel.org>
 <20240607-arm-pmu-3-9-icntr-v1-3-c7bd2dceff3b@kernel.org> <ZmbZG-eaqE4NPcE3@J2N7QTR9R3>
In-Reply-To: <ZmbZG-eaqE4NPcE3@J2N7QTR9R3>
From: Rob Herring <robh@kernel.org>
Date: Mon, 10 Jun 2024 10:42:55 -0600
X-Gmail-Original-Message-ID: <CAL_JsqK5TT1usMUY1Eaxy6qyGoWLj5R8XRNG-L6h-1S3WQfkRg@mail.gmail.com>
Message-ID: <CAL_JsqK5TT1usMUY1Eaxy6qyGoWLj5R8XRNG-L6h-1S3WQfkRg@mail.gmail.com>
Subject: Re: [PATCH 3/9] perf: arm_pmu: Remove event index to counter remapping
To: Mark Rutland <mark.rutland@arm.com>
Cc: Russell King <linux@armlinux.org.uk>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>, 
	Ian Rogers <irogers@google.com>, Adrian Hunter <adrian.hunter@intel.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 4:44=E2=80=AFAM Mark Rutland <mark.rutland@arm.com>=
 wrote:
>
> On Fri, Jun 07, 2024 at 02:31:28PM -0600, Rob Herring (Arm) wrote:
> > Xscale and Armv6 PMUs defined the cycle counter at 0 and event counters
> > starting at 1 and had 1:1 event index to counter numbering. On Armv7 an=
d
> > later, this changed the cycle counter to 31 and event counters start at
> > 0. The drivers for Armv7 and PMUv3 kept the old event index numbering
> > and introduced an event index to counter conversion. The conversion use=
s
> > masking to convert from event index to a counter number. This operation
> > relies on having at most 32 counters so that the cycle counter index 0
> > can be transformed to counter number 31.

[...]

> > @@ -783,7 +767,7 @@ static void armv8pmu_enable_user_access(struct arm_=
pmu *cpu_pmu)
> >       struct pmu_hw_events *cpuc =3D this_cpu_ptr(cpu_pmu->hw_events);
> >
> >       /* Clear any unused counters to avoid leaking their contents */
> > -     for_each_clear_bit(i, cpuc->used_mask, cpu_pmu->num_events) {
> > +     for_each_clear_bit(i, cpuc->used_mask, ARMPMU_MAX_HWEVENTS) {
> >               if (i =3D=3D ARMV8_IDX_CYCLE_COUNTER)
> >                       write_pmccntr(0);
> >               else
>
> IIUC this will now hit all unimplemented counters; e.g. for N counters th=
e body
> will run for counters N..31, and the else case has:
>
>         armv8pmu_write_evcntr(i, 0);
>
> ... where the resulting write to PMEVCNTR<n>_EL0 for unimplemented
> counters is CONSTRAINED UNPREDICTABLE and might be UNDEFINED.
>
> We can fix that with for_each_andnot_bit(), e.g.

Good catch. Fixed.

>
>         for_each_andnot_bit(i, cpu_pmu->cntr_mask, cpuc->used_mask,
>                             ARMPMU_MAX_HWEVENTS) {
>                 if (i =3D=3D ARMV8_IDX_CYCLE_COUNTER)
>                         write_pmccntr(0);
>                 else
>                          armv8pmu_write_evcntr(i, 0);
>         }
>
> [...]
>
> > @@ -905,7 +889,7 @@ static int armv8pmu_get_single_idx(struct pmu_hw_ev=
ents *cpuc,
> >  {
> >       int idx;
> >
> > -     for (idx =3D ARMV8_IDX_COUNTER0; idx < cpu_pmu->num_events; idx++=
) {
> > +     for_each_set_bit(idx, cpu_pmu->cntr_mask, 31) {
> >               if (!test_and_set_bit(idx, cpuc->used_mask))
> >                       return idx;
> >       }
> > @@ -921,7 +905,9 @@ static int armv8pmu_get_chain_idx(struct pmu_hw_eve=
nts *cpuc,
> >        * Chaining requires two consecutive event counters, where
> >        * the lower idx must be even.
> >        */
> > -     for (idx =3D ARMV8_IDX_COUNTER0 + 1; idx < cpu_pmu->num_events; i=
dx +=3D 2) {
> > +     for_each_set_bit(idx, cpu_pmu->cntr_mask, 31) {
> > +             if (!(idx & 0x1))
> > +                     continue;
> >               if (!test_and_set_bit(idx, cpuc->used_mask)) {
> >                       /* Check if the preceding even counter is availab=
le */
> >                       if (!test_and_set_bit(idx - 1, cpuc->used_mask))
>
> It would be nice to replace those instances of '31' with something
> indicating that this was only covering the generic/programmable
> counters, but I wasn't able to come up with a nice mnemonic for that.
> The best I could think of was:
>
> #define ARMV8_MAX_NR_GENERIC_COUNTERS 31
>
> Maybe it makes sense to define that along with ARMV8_IDX_CYCLE_COUNTER.

I've got nothing better. :) I think there's a few other spots that can use =
this.

[...]

> >       /* Read the nb of CNTx counters supported from PMNC */
> > -     *nb_cnt =3D (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMN=
C_N_MASK;
> > +     nb_cnt =3D (armv7_pmnc_read() >> ARMV7_PMNC_N_SHIFT) & ARMV7_PMNC=
_N_MASK;
> > +     bitmap_set(cpu_pmu->cntr_mask, 0, nb_cnt);
> >
> >       /* Add the CPU cycles counter */
> > -     *nb_cnt +=3D 1;
> > +     bitmap_set(cpu_pmu->cntr_mask, ARMV7_IDX_CYCLE_COUNTER, 1);
>
> This can be:
>
>         set_bit(cpu_pmu->cntr_mask, ARMV7_IDX_CYCLE_COUNTER);
>
> ... and likewise for the PMUv3 version.

Indeed. The documentation in bitmap.h is not clear that greater than 1
unsigned long # of bits works given it says there set_bit() is just
"*addr |=3D bit". I guess I don't use bitops enough...

Rob
