Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 898561946F
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 17:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mwa.re
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mwa.re
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mwa.re header.i=@mwa.re header.b="L5llUmOv"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-507d1cc0538so3227824e87.2
        for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 10:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mwa.re; s=google; t=1698428515; x=1699033315; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zl9xOdOypts4WvQdyS7jVbRn41c2NCajV1vwM0e7soo=;
        b=L5llUmOvoU6nZZgrBQ32r7XU4xLX9CNkke5lySS6OJ/xdeB2hW+JUNI0XlLvs5XVN+
         3DUt7/cDwNFrkRbhZqbl3JYLg2qPN872rL7SA3htYywRTfApDKOBOF1UAKivlDYmgdru
         5uGnDbsvxTtLOh1QSPJYnG9Z9Ick/CX17VPCMPZ5MMHdM4btb1UlkCVGXLV/chqoZJ0p
         sbHIuveELoaEUYsDzjyj4qWadC0Cf70U5fHexvt/1mFvqXD9PbY4u/24mLKbFkddmA9O
         GGRIunucVDcY7TQfL358r0vsx+WRhPXEm7opKEpI6kksNDchIUs29jOSs65iWLJipw7U
         SzDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698428515; x=1699033315;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zl9xOdOypts4WvQdyS7jVbRn41c2NCajV1vwM0e7soo=;
        b=FF76Gm6Su+cjG12aOanL4Lbbq0SBkts0boH0+wWzDQgzl9CwDNSV43EP9+9XM2fenB
         /ME9eTIl+RJN00V7d0tw4Y7vuiz3/kD2kHwNCi7+BT4J/nCQ0V5o4uvHxXUsGrOUl4g8
         YZ76rwYcTkvSWg0emGvX0S1eR6rvNRf2jow2NylqQWKiE3NSe2rLF3rO7AT7UqtxP7IC
         5jtbscahLvSzM3PuTUVKFj/HYwxu79Fnby7ouozA7TVPP21mxDzwQXX4dyeyHpi2i+gU
         hP2DLV6vMnBfB0UajrTZavpsZ6dRGD9LwTkPiccp7NG2+hbUvxablRHXN+rlWT6iVuez
         olew==
X-Gm-Message-State: AOJu0YyWXUuDtLw5TL61PHdZOJZEIIMtdl9Py5bKNSGYf9hIh9vx9WWm
	EDYsOPqmqTpQJ5iFjjolqSLm+kZLZPd6nnp1kP4axw==
X-Google-Smtp-Source: AGHT+IFHRMYL4gdEZHBAtJc+AHbUz15+hTrEB000BnqewEz2QhmjMoLFLieXWb0l5S9dAxYJMOtNQSEd0QJsAJXcobs=
X-Received: by 2002:a05:6512:282c:b0:508:2022:7738 with SMTP id
 cf44-20020a056512282c00b0050820227738mr2385452lfb.19.1698428515297; Fri, 27
 Oct 2023 10:41:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANi1PHhzk80HvwQbBM46gpJ6_AA_P6+m5Jo0Nuy_MAdA4C2BhQ@mail.gmail.com>
 <87ttql5aq7.wl-maz@kernel.org> <CANi1PHieGooO0DK=6BPwq0UknHzsn9QM3rFQkh3HLMfWxDseUQ@mail.gmail.com>
 <86cyx250w9.wl-maz@kernel.org>
In-Reply-To: <86cyx250w9.wl-maz@kernel.org>
From: Jan Henrik Weinstock <jan@mwa.re>
Date: Fri, 27 Oct 2023 19:41:44 +0200
Message-ID: <CANi1PHjAwLWAq9EW7r5Yh_xbvPiJMsq8342JwAGafz1d1NUhSA@mail.gmail.com>
Subject: Re: KVM exit to userspace on WFI
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, =?UTF-8?Q?Lukas_J=C3=BCnger?= <lukas@mwa.re>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

the basic idea behind this is to have a (single-threaded) execution loop,
something like this:

vcpu-thread:    vcpu-run | process-io-devices | vcpu-run | process-io...
                         ^
                  WFX or timeout

We switch to simulating IO devices whenever the vcpu is idle (wfi) or excee=
ds
a certain budget of instructions (counted via pmu). Our fallback currently =
is
to kick the vcpu out of its execution using a signal (via a timeout/alarm).=
 But
of course, if the cpu is stuck at a wfi, we are wasting a lot of time.

I understand that the proposed behavior is not desirable for most use cases=
,
which is why I suggest locking it behind a flag, e.g.
KVM_ARCH_FLAG_WFX_EXIT_TO_USER.


Am Mi., 25. Okt. 2023 um 14:42 Uhr schrieb Marc Zyngier <maz@kernel.org>:
>
> On Wed, 25 Oct 2023 13:12:14 +0100,
> Jan Henrik Weinstock <jan@mwa.re> wrote:
> >
> > Hi Marc,
> >
> > Thanks for your feedback. I understand that request_interrupt_window
> > is not to be used. I assume a setting a flag is a better way,
> > something similar to KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER, e.g.
> > KVM_ARCH_FLAG_WFX_EXIT_TO_USER.
> >
> > I will also check that WFx traps are always enabled while this mode is
> > active to make sure userspace does not get blocked/scheduled out.
>
> Why would that be an acceptable behaviour?
>
> > The reason for this is that we cannot have the thread that executes
> > KVM_RUN to be blocked or scheduled out whenever it hits a WFI.
>
> Why? If that's not acceptable, how do you even cope with the basic
> preemption?
>
> > Nop-WFIs are not a problem, since the PE will just continue executing
> > instructions, which is fine. We are currently using a timeout signal
> > that kicks KVM_RUN back into userspace, but we are seeing a lot of
> > time wasted because our KVM thread hangs in WFI/WFEs. It would be
> > better if we could just return from KVM_RUN immediately if the thread
> > would otherwise be blocked.
>
> On the face of it, this makes little sense:
>
> - While in userspace, no interrupt source that normally delivered
>   without any userpsace intervention will be blocked (timers,
>   VLPIs...). I cannot how this can be a good idea.
>
> - Trapping WFE is an important scheduling hint, and returning to
>   userspace defeats it. Contended spinlocks, for example, will be even
>   slower to acquire.
>
> I'm sure you have a particular use case for such a degraded behaviour,
> but since you are not describing it, I'm not at all inclined to
> actively break KVM's performance and scalability.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.



--=20
Dr.-Ing. Jan Henrik Weinstock
Managing Director

MachineWare GmbH | www.machineware.de
H=C3=BChnermarkt 19, 52062 Aachen, Germany
Amtsgericht Aachen HRB25734

Gesch=C3=A4ftsf=C3=BChrung
Lukas J=C3=BCnger
Dr.-Ing. Jan Henrik Weinstock
