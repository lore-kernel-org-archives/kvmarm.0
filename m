Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CBCB2F90C9
	for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 19:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775850970; cv=none; b=W7dr0E9Xv7VoKyoYBA7MobDAqUEmVl9+fiA9Nj+2R6i6uEzzA+e2pbCzN5cyaKN1VvTFfS/pj05DWplDDeP2ftJr0qFN6HsJfGCKk6jYcu9/mt6JIJWVUFSn//ugIo48K6cTm2RV/34L/HqVdF7mxggGIYtXL36cppJhWmGXq54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775850970; c=relaxed/simple;
	bh=J0+sK84ErorCVePEnHFFFb37BgkU1ZRXvWCpuLHsgvM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7KuJhNBZ+j58GH41LoAfo/pFADaAeIB1J5xPp4ZQARdvdVmksef1efprJ8U+VSHMJR36URQsYoAHg5FNVh+QcOXmA7/nI/WsV3Z8AII/cT8fhG+/Eg6sdzjf4BhStRRad53oxLeMCy54OHI5fWyrSnOLw0Uo4GWE3I/HwJStxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CHo2CDvE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CHo2CDvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF123C19424
	for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775850969;
	bh=J0+sK84ErorCVePEnHFFFb37BgkU1ZRXvWCpuLHsgvM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CHo2CDvEDJ9Wj2N1sKK31epsC08zCEBjdeXDTusPmXw1yl2botjxwYxIY8CRgYnD5
	 9Q9PlEg+1n3yt7BrrQAirnlq59pbWIOzuFXzIT1jSAwMp63w+6GKoKBC3GWYx88Aap
	 wzLxor8Wlcfw4QaZpqph87BeiNprI2NAJPP6/MHzYDksikWPjqaMsDTG1lfz8dbFWH
	 51UfqKsd28sDcwTbti+aGsfcyUwiL49lLiHHwZx7dkdawLpZQZqkYqjGiTGUw5XRVu
	 +Zzq3spa/ugvIlJChYsNApJSPGwCBr5HT72G+87X5iAnq9bPLZAecTd9J1l6cB1Y3s
	 zytfYCiRp7RsQ==
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-670af4fc2f1so1099705a12.1
        for <kvmarm@lists.linux.dev>; Fri, 10 Apr 2026 12:56:09 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXy6FRBWuvl1IfkDpj+qIn2Qfw8gUb8aMw5H4M2z4VW2HSLM8z2BUJ5A7h03bfyvpW7cJZJlTc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzLNg4Dny2dcZlQ6AoQOtjStKzhKKRHEVw/OFZq8GsFtKuyRlss
	TtPCN6hGsp+kadbAsJ5RGN97Ur2yWbGDvfldhRpemGV7c5EsdTc22WJZMu+Tmjmp0QXVaPnk41T
	H6GbDtF2ZHQ2bZbxVZbO21RcLVoCSPg==
X-Received: by 2002:a05:6402:a21b:10b0:670:8b30:a8a5 with SMTP id
 4fb4d7f45d1cf-6708b30a916mr1683630a12.17.1775850968328; Fri, 10 Apr 2026
 12:56:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241216040831.2448257-1-anshuman.khandual@arm.com>
 <20241216040831.2448257-8-anshuman.khandual@arm.com> <Z2AH1SN5CipWkkE4@J2N7QTR9R3>
 <20260331225800.GA2082670-robh@kernel.org> <ac5G8e4zWTdicDBs@J2N7QTR9R3>
 <CAL_JsqLEBJ7Ok9TngWTqjaWY_LJCPtronv8=gnm=J0FymDKLCg@mail.gmail.com> <adeE4MD0RgapI8aL@J2N7QTR9R3>
In-Reply-To: <adeE4MD0RgapI8aL@J2N7QTR9R3>
From: Rob Herring <robh@kernel.org>
Date: Fri, 10 Apr 2026 14:55:55 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+=3CKrUDcdgSHFaSGgvnh9ZxTGEBTRLkwrYgzQ=frOdg@mail.gmail.com>
X-Gm-Features: AQROBzA5KLZDDNcMFHPCHSCcvUxzxdbsbT_tKeErp7FMHwVLiJT0a7YPMt7UER0
Message-ID: <CAL_Jsq+=3CKrUDcdgSHFaSGgvnh9ZxTGEBTRLkwrYgzQ=frOdg@mail.gmail.com>
Subject: Re: [PATCH V3 7/7] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 9, 2026 at 5:52=E2=80=AFAM Mark Rutland <mark.rutland@arm.com> =
wrote:
>
> On Thu, Apr 02, 2026 at 12:46:56PM -0500, Rob Herring wrote:
> > On Thu, Apr 2, 2026 at 5:37=E2=80=AFAM Mark Rutland <mark.rutland@arm.c=
om> wrote:
> > >
> > > On Tue, Mar 31, 2026 at 05:58:00PM -0500, Rob Herring wrote:
> > > > On Mon, Dec 16, 2024 at 10:58:29AM +0000, Mark Rutland wrote:
> > > > > On Mon, Dec 16, 2024 at 09:38:31AM +0530, Anshuman Khandual wrote=
:
> > > That said, the use of 'bp_per_reg' looks suspect given their
> > > arch_install_hw_breakpoint() and arch_uninstall_hw_breakpoint() modif=
y
> > > that non-atomically.
> >
> > You don't believe the comment saying counter->ctx->lock is held?
>
> Sorry, my concern here was that hw_breakpoint_handler() (which cannot
> hold the lock) consumes bp_per_reg[], and could race with the non-atomic
> modification in arch_install_hw_breakpoint() or
> arch_uninstall_hw_breakpoint().
>
> I've sent a more elaborate mail to x86 folk, with that and another issue
> caused by taking a breakpoint under arch_uninstall_hw_breakpoint():
>
>   https://lore.kernel.org/lkml/adZWmPW8S9Y2pwkv@J2N7QTR9R3.cambridge.arm.=
com/
>
> I think we have a similar latent issue where we can take an breakpoint
> or watchpoint ad infinitum, described in more detail at the end of this
> mail.
>
> [...]
>
> > > > > | What prevents a race with an exception handler? e.g.
> > > > > |
> > > > > | * Does the structure of the code prevent that somehow?
> > > >
> > > > If you can't set a breakpoint/watchpoint in NOKPROBE_SYMBOL() annot=
ated
> > > > code, you can't race.
> > >
> > > As above, I agree (with caveats), but I couldn't spot where this is
> > > enforced.
> > >
> > > > However, there's no such annotation for data. It looks like the ker=
nel
> > > > policy is "don't do that" or disable all breakpoints/watchpoints.
> > >
> > > If we have to transiently disable watchpoints/breakpoints when
> > > manipulating the relevant HW registers, that sounds fine to me.
> >
> > For wp/bp_on_reg, the ordering is 'data access, h/w accesses'. I think
> > we just need a barrier to enforce that ordering so the data access
> > (and then watchpoint) don't trigger in the middle of the h/w accesses.
>
> I assume that by 'h/w accesses' you mean MSRs to the system registers
> controlling breakpoints/watchpoints. Ordering-wise, I don't believe
> memory barriers are necessary here (explain in more detail below).
> However, I also think there's a latent issue here that might bite us
> with the new banking, described at the end of this mail.
>
> Both breakpoint and watchpoint exceptions are synchronous, meanning that
> they can only be taken from the specific instruction that triggered
> them.  However, updates to the watchpoint control registers *do* need a
> context synchronization event before they're guarnateed to take effect.
>
> For a sequence:
>
>     // Initially:
>     // - MDSCR, MDCR, DAIF.D permit debug exceptions at CurrentEL
>     // - No watchpoints enabled
>
>     0x000:  LDR <val>, [<addr>]
>     0x004:  MSR DBGWVR<n>_EL1, <addr>
>     0x008:  MSR DBGWCR<n>_EL1, <configure_and_enable>
>     0x010:  LDR <val>, [<addr>]
>     0x014:  ISB
>     0x018:  LDR <val>, [<addr>]
>
> ... we know:
>
>     (a) The LDR at 0x000 *cannot* trigger the watchpoint.

Why not? Can't the LDR complete after the MSR? Is ordering ensured
between those? Surely the watchpoint triggers on completion of the
load and that wouldn't stall the PE from doing the MSR(s)?

>     (b) The LDR at 0x010 *might* trigger the matchpoint.
>     (c) The LDR at 0x018 *must* trigger the watchpoint.
>
> For C code, we can enforce this order with barrier(), e.g.
>
>         val =3D *addr;
>         barrier();
>         write_sysreg(addr, DBGWVR<n>_EL1);
>         write_sysreg(configure_and_enable, DBGWCR<n>_EL1);
>         isb();
>
> ... where the compiler cannot re-order the memory access (or
> write_sysreg(), or isb()) across the barrier(), and as isb() has a
> memory clobber, the same is true for isb().
>
> Likewise, for the inverse sequence:
>
>     // Initially:
>     // - MDSCR, MDCR, DAIF.D permit debug exceptions at CurrentEL
>     // - Watchpoint configured and enabled for <addr>
>
>     0x100:  LDR <val>, [<addr>]
>     0x104:  MSR DBGWCR<n>_EL1, <disable>
>     0x108:  LDR <val>, [<addr>]
>     0x110:  ISB
>     0x114:  LDR <val>, [<addr>]
>
> ... we know:
>
>     (a) The LDR at 0x100 *must* trigger the watchpoint.
>     (b) The LDR at 0x108 *might* trigger the watchpoint.
>     (c) The LDR at 0x114 *cannot* trigger the watchpoint.
>
> > Any guidance on the flavor of dsb here? (And is there any guarantee
> > that the access is visible to the watchpoint h/w after a dsb
> > completes?)
>
> Hopefully the above was sufficient?
>
> As mentioned above, I think we have a latent issue where we can take a
> breakpoint or watchpoint under arch_uninstall_hw_breakpoint(), where we
> have:
>
>     arch_uninstall_hw_breakpoint(bp) {
>         ...
>         hw_breakpoint_control(bp, HW_BREAKPOINT_UNINSTALL) {
>             ...
>             hw_breakpoint_slot_setup(slots, max_slots, bp, HW_BREAKPOINT_=
UNINSTALL) {
>                  ...
>                  *slot =3D NULL;
>                  ...
>             }
>             ...
>             write_wb_reg(ctrl_reg, i, 0) {
>                 ...
>                 write_sysreg(0, ...);
>                 isb();
>                 ...
>             }
>         }
>     }
>
> The HW breakpoint/watchpoint associated with 'bp' could be triggered
> between setting '*slot' to NULL and the ISB. If that happens, then
> do_breakpoint() won't find 'bp', and will return *without* disabling the
> HW breakpoint or attempting to step.
>
> If that first exception was taken *before* the MSR in write_sysreg(),
> then nothing has changed, and the breakpoint/watchpoint will then be
> taken again ad infinitum.
>
> If that first exception was taken *after* the MSR in write_sysreg(), the
> context synchronization provided by exception entry/return will prevent
> it from being taken again.
>
> Building v6.19 and testing (with pseudo-NMI enabled):
>
> | #  grep write_wb_reg /proc/kallsyms
> | ffff80008004b980 t write_wb_reg
> | # ./perf-6.19 stat -a -C 1 -e 'mem:0xffff80008004b980/4:xk' true

I'll give it a try with v4, but that should be prevented with my
changes to exclude kprobe regions.

Rob
