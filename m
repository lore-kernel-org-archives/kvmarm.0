Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C5D20B21
	for <kvmarm@lists.linux.dev>; Wed, 25 Oct 2023 12:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mwa.re
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mwa.re
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mwa.re header.i=@mwa.re header.b="d8LhC7s6"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2c5087d19a6so82638281fa.0
        for <kvmarm@lists.linux.dev>; Wed, 25 Oct 2023 05:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mwa.re; s=google; t=1698235946; x=1698840746; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmQirNixdBVLhzipjmpOh2DK+B144w1ZHT/Th2x89pQ=;
        b=d8LhC7s6E5Ur66G5zRiQLXaP15Qzz5yv9SXEsJTiucDJ4YHkEnFEJbIllfuEjyxf3u
         lk8Qptb40hef+B6I5fEROokqyCPcZmKeeMsd0pmeV8J9c73DTLqbzxfAaGVPygdNICBa
         uROWwGIVaEPO6cGBj6pspQVk22YPlV7uAzCsjQFlsMREbIeu88ljapjxuUljqFapDjvn
         fUn4HLjq4E65nbSo9Lvzj3hxl/xvfeW1ni9iIP0HNLsRo1jl2rvZZTgVQrUGM583q+gI
         jccYULNwvr+dFc0mn1V87kTHVfBx7c143Ksv/ZX4AX0M7rrCHdmwzBlWmT2j1Vvngc9J
         NkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698235946; x=1698840746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bmQirNixdBVLhzipjmpOh2DK+B144w1ZHT/Th2x89pQ=;
        b=be1JICRukzGbRtXktHSuaCS//ewWtS8Y5izdVDBDGeQldLj/Ax6DkcFi8GsZYXQdjN
         m3T2Ckom9vPFWfYkLtIPn01lSWttxpMvq8oE8857PQdso9LFU2SMHX4jp5HC+ebRNACw
         bFEBUJZGB/x/a2jfuMpNyIxiK9d5xjqwyqUBKxg9F6+3yjhu7AmCDYOcpzwPOuGbFbTd
         Q6pT2dzuERl3eTYni2aSNH0TLBqK5qzlCewCuMVvjIuVOs49TwOKl62YU8hs6xVcQh9x
         +ojxzZDR7NpxYAOWblQIDnAHvSyot2u/DS1bJIB4mI+bPxjd57rg6DxdLsf1fK/8BAyP
         lgfA==
X-Gm-Message-State: AOJu0YxMTG4iMQWKUBRM/8V5JUlziFXHsgvlDwt34a7M2MuwzVrCbDoC
	UPepT8l/8pu3jeVyVywuH4PlDIC/c18jyUglk9I3bg==
X-Google-Smtp-Source: AGHT+IG77TRnbAc5NHxWAToEdv8/60zE5lZkK8dST9jN7Z8I43Q0SHcqnOjXF3cDU1eg/WjvcPXDaMvx+eZ7Rp9b440=
X-Received: by 2002:a2e:b911:0:b0:2c5:2132:24f5 with SMTP id
 b17-20020a2eb911000000b002c5213224f5mr9609306ljb.53.1698235945658; Wed, 25
 Oct 2023 05:12:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <CANi1PHhzk80HvwQbBM46gpJ6_AA_P6+m5Jo0Nuy_MAdA4C2BhQ@mail.gmail.com>
 <87ttql5aq7.wl-maz@kernel.org>
In-Reply-To: <87ttql5aq7.wl-maz@kernel.org>
From: Jan Henrik Weinstock <jan@mwa.re>
Date: Wed, 25 Oct 2023 14:12:14 +0200
Message-ID: <CANi1PHieGooO0DK=6BPwq0UknHzsn9QM3rFQkh3HLMfWxDseUQ@mail.gmail.com>
Subject: Re: KVM exit to userspace on WFI
To: Marc Zyngier <maz@kernel.org>
Cc: oliver.upton@linux.dev, james.morse@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, will@kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, =?UTF-8?Q?Lukas_J=C3=BCnger?= <lukas@mwa.re>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

Thanks for your feedback. I understand that request_interrupt_window
is not to be used. I assume a setting a flag is a better way,
something similar to KVM_ARCH_FLAG_RETURN_NISV_IO_ABORT_TO_USER, e.g.
KVM_ARCH_FLAG_WFX_EXIT_TO_USER.

I will also check that WFx traps are always enabled while this mode is
active to make sure userspace does not get blocked/scheduled out.

The reason for this is that we cannot have the thread that executes
KVM_RUN to be blocked or scheduled out whenever it hits a WFI.
Nop-WFIs are not a problem, since the PE will just continue executing
instructions, which is fine. We are currently using a timeout signal
that kicks KVM_RUN back into userspace, but we are seeing a lot of
time wasted because our KVM thread hangs in WFI/WFEs. It would be
better if we could just return from KVM_RUN immediately if the thread
would otherwise be blocked.

Thanks
Jan

Am Fr., 20. Okt. 2023 um 21:56 Uhr schrieb Marc Zyngier <maz@kernel.org>:
>
> Hi Jan,
>
> On Fri, 20 Oct 2023 19:45:05 +0100,
> Jan Henrik Weinstock <jan@mwa.re> wrote:
> >
> > Hi all,
> >
> > I am looking for a way to have KVM_RUN exit back to userspace once the
> > vcpu encounters a WFI. It seems the kvm_run->request_interrupt_window
> > flag is currently ignored by arm64.
>
> Well, that's consistent with arm64 not being an x86 implementation. We
> can inject interrupts any time, and there is no notion of "interrupt
> window".
>
> > So my solution thus far is to
> > patch kvm_handle_wfx in arch/arm64/kvm/handle_exit.c and return to
> > userspace with KVM_EXIT_IRQ_WINDOW_OPEN - working example attached.
> > Any chance to get this (or something similar) mainline?
>
> Certainly not as such. For start, this won't hit all WFIs, but only
> those that actively trap. And we don't even *try* to trap WFx in a
> number of cases (vcpu alone in its run queue and/or direct injection).
> There isn't even any guarantee that WFx is anything other than a NOP
> (it is architecturally only a hint), in which case no trap applies.
>
> So your "working example" really isn't one, as the architecture
> doesn't give you a way to do what you're asking for. If you want to
> cause an exit, writing to 'immediate_exit' and delivering a signal is
> the way.
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
