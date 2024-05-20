Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73848A2D
	for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 08:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716195256; cv=none; b=PF4phg6IQXk6Smr7FOyNSTS09MPgyO1hXUwsXejXeFR3A1YxLyhrlWquj3zT86JXMuy+q+OW0cWOwMHlq+XtpSHLunYcI/PzW1xYTXqV+UNTL+e95i3K0IBfgiUDJF2QPQ3L1EUVLrZE550Y6cfAQxAwarSiSfmARxu3GkPR1as=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716195256; c=relaxed/simple;
	bh=Hn/bJgs7CoBr9oJgpfWwkpbpVYB9K4Ahi5eFnJ3xiE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l1JGeMqQWjeBlcDipzk8moIWc4qliF14IRo6xdvXObsPzFUFmmKMGs5y9/9pnXCJFrsN9o54cvdeSI/p02Bfi6toObC61IGsyDqJyUXRTKv3LsRXeNn4qIkpJodFLQ0/zC/9uPHZGRIR6T6Te7jqvuLJZWVATneZNxAcogBCRAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OPp9aJw/; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OPp9aJw/"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47efc592d9fso326628137.0
        for <kvmarm@lists.linux.dev>; Mon, 20 May 2024 01:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716195254; x=1716800054; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sTmnkZjtCEAiCBviwaLAUM9+vdT6Q87kpPsgV1agRl4=;
        b=OPp9aJw/XL9wKi0L27roWiRWlaYGO3Uz9pcADCP6NsKk0hH/GAFBZIVkf42HxpoxkI
         zMZV98jZO91lNL8jj5G4+Kj3EjA0SUE85PT0mJqgbYSOagVUnXihY/ZVG9I71RaJ5sSK
         RxkHFIP64SA32cug4DTvf3Wz3pgl7NXhK56CTL+g+4qnOhWDeSS+eCk4TV1ywha3Fz6J
         KCZqhM4+l50wmsfs1j1621CRBlYE96cdqU0vHPJiT9rFw13Eih+GjY8H0HNTW9bYw0QB
         HOoojYZDyAyCj0/HLe1M8Mi+r6S840giOE8EGXA6vwmvXWrZ32Oty8WF0QV4k4Ty46R9
         uuKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716195254; x=1716800054;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sTmnkZjtCEAiCBviwaLAUM9+vdT6Q87kpPsgV1agRl4=;
        b=EFI7pk8yl5gF71g3lO1pGBqDqp0rXGlVERtO6YvZkOCAp9tqLH/NgyoA0mxIfyHIe6
         N7fxUAUdppt2hz8LJujqUd9TN4n8eYV2DHURrOoiyN79psT9Oo6lc8TXRQV/IgDNy0sk
         nkOmNjSorYdf/2ExDLvWDHn07oXETXB47AsKf+g/Xm2uv0BSgolYhvJINlpMRx9rqdyo
         pB+Z30EtYSKIXKQAWHoIjzwB7ri3/nsJ6nzh5sZvEv199PXGUzEqpKkVF13i7NpoyzCY
         YVLkT5WQ56VQXJoRVAU7BqUY9tGwXLCHuumvC+Uft2iYBVBNYKuu4fSsSAwmu3Htmzv5
         79Ew==
X-Forwarded-Encrypted: i=1; AJvYcCXjsv/9C+RR8wX+Wdp/MXDr1vuRHjvANoTd5RW88cOSjGhLPVICIpk3VNKCUNs+86/2wj1f6N+u5U66Fzj84GyoI1XMPjQH
X-Gm-Message-State: AOJu0Yzsx/Hn/eY7MjTzwIwiqnRnzITkPNCtffnU93qgw1uU84Q5ETzG
	H5hYPwPzB62EeXQhesTbA75/e1HJYA+tS0rIiSL01YPODT1+6Qv4W98W0ZAG+f+JWywhj9gPGun
	6HtOr0Ras/IFAmbB0eBRDzU0Hj5TuNdzMBmQB
X-Google-Smtp-Source: AGHT+IGukY4NCuQ57Jan8rXLAeIEceURgTo7GWVR5qRA1Ghy1D6QSe2qg13Zn1VHhnhlE07pEVBmuaagwNASu4J7NQ4=
X-Received: by 2002:a05:6102:32c5:b0:47a:42e6:ba69 with SMTP id
 ada2fe7eead31-48077e43be8mr29498076137.27.1716195254254; Mon, 20 May 2024
 01:54:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240517131814.719933-1-tabba@google.com> <20240517131814.719933-7-tabba@google.com>
 <ZkePS5jU6yEv6Nhp@linux.dev> <CA+EHjTzFkNiPzH47Y52cEPd+LzNSAmGHD45C0o8p2ejB6LKHKQ@mail.gmail.com>
 <87r0dw3o35.wl-maz@kernel.org>
In-Reply-To: <87r0dw3o35.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 20 May 2024 09:53:37 +0100
Message-ID: <CA+EHjTzG1=b+RaaoAjddUX=c13WBHDmngEUas5JgPcyZtgSC7w@mail.gmail.com>
Subject: Re: [PATCH v1 6/7] KVM: arm64: Eagerly restore host fpsimd/sve state
 in pKVM
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, May 20, 2024 at 9:05=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 20 May 2024 08:37:22 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Hi Oliver,
> >
> > On Fri, May 17, 2024 at 6:09=E2=80=AFPM Oliver Upton <oliver.upton@linu=
x.dev> wrote:
> > >
> > > Hi Fuad,
> > >
> > > On Fri, May 17, 2024 at 02:18:13PM +0100, Fuad Tabba wrote:
> > > >  static void kvm_hyp_save_fpsimd_host(struct kvm_vcpu *vcpu)
> > > >  {
> > > > -     __fpsimd_save_state(*host_data_ptr(fpsimd_state));
> > > > +     /*
> > > > +      * Non-protected kvm relies on the host restoring its sve sta=
te.
> > > > +      * Protected kvm restores the host's sve state as not to reve=
al that
> > > > +      * fpsimd was used by a guest nor leak upper sve bits.
> > > > +      */
> > > > +     if (unlikely(is_protected_kvm_enabled() && system_supports_sv=
e())) {
> > > > +             __hyp_sve_save_host();
> > > > +
> > > > +             /* Re-enable SVE traps for guests that do not support=
 it. */
> > > > +             if (!vcpu_has_sve(vcpu))
> > > > +                     sysreg_clear_set(cptr_el2, 0, CPTR_EL2_TZ);
> > >
> > > This doesn't account for hVHE. I wonder we'd be better off abstractin=
g
> > > CPTR_EL2 behind a helper wherever it gets used in nVHE and translate
> > > into the VHE-format behind the scenes:
> >
> > Right! Too many modes to keep track of :)
> >
> > Abstracting cptr_el2 would make things clearer and less error-prone.
> > I'll do that on the respin.
>
> If we're going with the conversion game, then I'd suggest you use the
> VHE format as the reference, and convert it to nVHE on the flight.
> That's for a few reasons:

Will do.

Cheers,
/fuad


>
> - like it or not, nVHE is going the way of the dodo. I love my v8.0
>   hardware to bits, but it sucks, and nVHE is now optional anyway.
>
> - Keeping everything in the VHE format helps drawing a parallel with
>   what is happening in the kernel (you grep for the same symbols).
>
> - One day, I hope to be able to rip any form of SVE/SME support out of
>   nVHE and only keep it for hVHE, because there is no ARMv8.0
>   implementations with these extensions (apart from SW models).  One
>   day...
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
