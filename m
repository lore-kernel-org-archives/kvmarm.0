Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5466E191F8E
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 10:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730196038; cv=none; b=BMad/aFsEm92irVN5Y0MPYNAgHnYyBnWE+wc5Xz0b4A/9mIoe1gWHMr+FCT+9Ao9FzxQeWE1zajQ3ed7pGspvt+rE5myo97d8qjG7vq0b0EgCeXqJjko8f3gy+992lEBnsOOEiwU7kqsHZiQ4RNJxL2AkvSMJ9hnxC9P6PSIads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730196038; c=relaxed/simple;
	bh=vIPXjsUqI6HisFaD5e3T1+6vU/Ckcl0BQpGw086P6gw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yb+LqwzELKptv+sysb51nO+KR9/AGh2twkn6uBUQ31vuYvrk/CgZwy2MdsVzyk0bofuFRw/MgLtZS7P881sL3uaNDOFkMppi1dhkQW5jjWgeVdloCLyE/6BkLsXu7j2E1PNSSWzogY4DTyiMe68Tn2oCgitipQdwvJubWhw3e7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=r5oVdXS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r5oVdXS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D793CC4CEE9
	for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 10:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730196037;
	bh=vIPXjsUqI6HisFaD5e3T1+6vU/Ckcl0BQpGw086P6gw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r5oVdXS2qDFrk0zGrBIuIYpNIMczvbDpQR4E7MxBwzN1F/CRhI6JoCm2IguLSqewX
	 I2HROIIK156/2zApIHmud0fsFq1Ug42+7k9/pFYpfTcZK6SuZRSSoYeBU+To10ILyS
	 8BzmD7rek3bcjC1x9ZxJ2Mo6PvLni3NomvOEnczcTFVvZVmN7IuFxoUN7BBGz8ADCk
	 o6IpKR1LXwn58foeOdO80SYTmS3Cb9SvJ/lO7HlKTzu3G3FFCevUehd89cDYMKD3gg
	 HuwbhPpKazec5ljLPd+LvD8Kq4Dbyki866w4gGVrMoyuPFiX2j52WT3JpGvNbpqflq
	 lGmrC54yI3gUw==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2f7657f9f62so44940271fa.3
        for <kvmarm@lists.linux.dev>; Tue, 29 Oct 2024 03:00:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXcEaYBpXjOj00TvdVtSm52PP5FtMBNorcm0zGfLfVppOj9MOsieoGSJS1Lwt2S2yokhdKhcSE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzc1r3xoqADWIV2NSyp9knqxRsOA3Q6+OjZmWRm6hHEN2UeVmJS
	EVA+q74e2U5RudAs6W/8UsmiGXxEIjLn5oDf7qAeUxowOeG7SayU6qGmzkkJ2rbmK7iDzF4CgyC
	oXC3GLqXXcuX1Upyj8rKEnT77uKo=
X-Google-Smtp-Source: AGHT+IEv2f7Ljf5pVqXirJwrfDfhMrJaZsnX3FjHVnAe45g6dbvPnMbZ194jmmjiIFlWMdevuzci9mGXdnuc0ENnVSs=
X-Received: by 2002:a05:651c:2209:b0:2ef:17f7:6e1d with SMTP id
 38308e7fff4ca-2fcbdf689acmr49293801fa.4.1730196036055; Tue, 29 Oct 2024
 03:00:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <mb61p4j4wwlap.fsf@kernel.org> <86ed4031zh.wl-maz@kernel.org>
 <CAMj1kXEX2TLdYCn3C-AXhfhjOe6cuzOmd0h5MbgXnzi7Q94T3w@mail.gmail.com> <86bjz32q2q.wl-maz@kernel.org>
In-Reply-To: <86bjz32q2q.wl-maz@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 29 Oct 2024 11:00:24 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFLRruq1gv+oiSz_LrfCt3j5ftv78prkxKV62tCXe0KVg@mail.gmail.com>
Message-ID: <CAMj1kXFLRruq1gv+oiSz_LrfCt3j5ftv78prkxKV62tCXe0KVg@mail.gmail.com>
Subject: Re: Supporting KVM_GUESTDBG_BLOCKIRQ or something similar on ARM64
To: Marc Zyngier <maz@kernel.org>
Cc: puranjay@kernel.org, Arnd Bergmann <arnd@arndb.de>, Arnd Bergmann <arnd@kernel.org>, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Sumit Garg <sumit.garg@linaro.org>, 
	puranjay12@gmail.com, Oliver Upton <oliver.upton@linux.dev>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Joey Gouly <joey.gouly@arm.com>, 
	Zenghui Yu <zenghui.yu@linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Oct 2024 at 10:53, Marc Zyngier <maz@kernel.org> wrote:
>
> On Tue, 29 Oct 2024 08:52:41 +0000,
> Ard Biesheuvel <ardb@kernel.org> wrote:
> >
> > On Mon, 28 Oct 2024 at 12:23, Marc Zyngier <maz@kernel.org> wrote:
> > >
> > > > Let's start a discussion about what needs to be done to support this on
> > > > arm64.
> > >
> > > A good start would be to define the semantics of such a flag:
> > >
> > > - what should it affect? the vcpu you are single-stepping? all vcpu?
> > >
> > > - should userspace to know that interrupts are pending?
> > >
> > > - should this result in any effect on the guest's view of time?
> > >
> > > - what of interactions on the rest of the system (such as devices)?
> > >
> >
> > Sorry to give a handwavy answer here, but approaching this from a
> > usability PoV (like what Puranjay is doing), it is really about
> > adhering to the principle of least surprise for the user.
> >
> > So in that sense, it is not really about blocking IRQs at all, as long
> > as we step over them rather than into them. How that is achieved is
> > not that relevant from the user PoV, and maybe KVM_GUESTDBG_BLOCKIRQ
> > is not the right solution for ARM at all.
>
> I definitely sympathise with the goal, but there is no simple way to
> let interrupts through while stepping (which is what your "step over"
> implies):
>
> - the hypervisor (in general) doesn't interact with the guest delivery
>   and handling of interrupts -- this is either very opaque (list
>   registers) or completely invisible (direct injection)
>
> - replacing the step with a breakpoint after the stepped instruction
>   requires us to decode the guest instructions to handle branching
>   effects
>

Yeah, and we still want to take non-IRQ/FIQ exceptions, so this does
not seem feasible to me.

> One possible mechanism would be to:
>
> - while stepping, add breakpoints to the interrupt vectors for the EL
>   we are stepping (3 breakpoints for any of the 4 possible exception
>   groups),
>
> - when any interrupt breakpoint hits, clear all 3, place a breakpoint
>   on the instruction that was about to be single-stepped (pointed to
>   by SPSR)
>
> - run to completion, until the breakpoint hits
>
> - disable the breakpoint, reinstall the previous 3 interrupt
>   breakpoints
>
> - single-step, rinse, repeat
>
> But then I'm asking myself the question: why is this KVM's job? It
> seems to me that this is what an external debugger would do when
> interacting with HW on bare metal.
>
> So can we implement this as part of the debugger's state machine?
>

Which debugger is that? The GDB stub in QEMU?

Setting a one-shot breakpoint on the address in SPSR when taking an
IRQ exception seems like a reasonable approach to me.
