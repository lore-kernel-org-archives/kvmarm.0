Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D0925FA13
	for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 13:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764078877; cv=none; b=Ruaj6crjYNzxnnifO7hgxpP/bcyR2p8DdkR4p825iKqEMJXET7y31hb1SqvHK9kmDq8NuD9x/EU9fjcsMS1N755dfiglaLEYS3MLSQofN//ZwEJfwoCI8HyvK5XHuox+TTAXzMre4C4MzsiZ3OUsrQthHvRBlfKXqKUZUb5/HXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764078877; c=relaxed/simple;
	bh=B3H+0D7ZbCrKVPPn1gTOAmQ4fVsyYKUcEB2BnNTAB6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZntfhDySHQsqfmxlTv6N/bm0E2ONas47zPRvR3zfPG6TDQyjQ4O8p0K4dEbTnPBMqonVfrTjxAhqeB30jhSRX9AWvbe4Y3NQIcJicJyRhD1wA9MQn8Bvp4bg5Gy8k9bJD6d7VfiJvE/XwjLXkZuJx+iJfzNH1FoITtMet3EasdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f5zQoML/; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f5zQoML/"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-640c1fda178so9186980a12.1
        for <kvmarm@lists.linux.dev>; Tue, 25 Nov 2025 05:54:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764078874; x=1764683674; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=li1WfcmqjtXPdjeerPuuC1oso8LxzzKitkh3QfY2DDk=;
        b=f5zQoML/BKYpljI9QkuhHqdWdENHgbLOy9OPVGR6+m2Trhtd9wjxrlexTn7XfCA2GZ
         iI/bx7zppN54iSkK5I+CVzHbduXFCOzq0x0nUwBLa4+t1MVWdt+xzhiOM1MOLLar+y3P
         bKae5WrMOFhBg9jLODIT2q1QCkQDQh7YyGFkFtf+PViymwZoBJZNmas6wosLTePDPv5W
         Oiv7rPcAgxW5cY2VNwYrFrbuhsMJ2XalhJmKtXGVRIxT7hx25y+3Eio0vnldhYRVuevA
         N7U2rScIP5UvNWzsLE/x1Z/5VErW4WimoRGNldhxZ4qfr42Zx1OcrUe3HtwpCpP6qbXV
         ZOIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764078874; x=1764683674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=li1WfcmqjtXPdjeerPuuC1oso8LxzzKitkh3QfY2DDk=;
        b=HlZfv97loQWydfL24qG97P644/e9LuOoMqJfIH2J0UCUwJBqLVqHgIQFzy0HtHvuuN
         /p/7gxnGYef/nKTA0iEB6DSDXbxQ6A1QxT7X+4888wrBBuGIEwHYB7NPatmNUQQ3R10Q
         e50s4D9h7D/lpGataT3P7aqIEkzR7eFaomwpwx+e74ONojcL/4dQECzqf6NYGSVSqVZ1
         R7i/LJWis/pmPVP7nid9QnTh+MbH77AUDCTJKUG7o6C70Nh5qgCT0vI1GsEdDtk0NB2M
         grc3jEjkI5wt36s1YdRtMbaHbu/M1RiNjXmG29Brb7zU+oaJpZP/+iYmZEWF1PhCwNLl
         y7Ew==
X-Forwarded-Encrypted: i=1; AJvYcCUb2scXYe7pX6Cj0BNkB/9KCviD+mf01AElWWBLwHNm5Rch2/Zey8TtHfuhSJF5OpKplsG6ho0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxDm11+oK4Oy0/6AqZiNt/aMA8SuuPOIC567bNZLDQHhOjyS6qU
	kiQw5GfnUWiM4xJ2gBLpbrV1nvUEYfzG8HdACGuTQ6B1/Z82rJRqynTsJE6aQYlOWBQurEXbZvI
	HoWY0JQxQfAhC8Nt/uOSvM29HmVvVCT/BC3dKXuOW
X-Gm-Gg: ASbGncsSLACQ1cCbrnyNsMg5OoM4He3Lb/KahnDew/p1gAHWnXyEwhhPU9c9Bn1Hhw8
	4aIeIClc9S3sPZ7rJy00SZON/pFAx81fTOBJwHJTf+TiHzage2mZPETpCqE24E5El25Ap2bGPCg
	5JHHYdUCv9wkET43MF2hTW+0R0PVI5xGD42tPaWczldMqzMO8o9GgtMwxAQpbQ06/lU6KfnMo1B
	lL1UDXHdveQACFev3i8tkfAmgpsD94fKeSRfb/OJDp/ytZVy/wqjuHYEu6kdMplzL1nhEFfvI8P
	JRWBsrlCalM4aoUZ6CHs0A==
X-Google-Smtp-Source: AGHT+IG6ASkGgvx/czvWoBu15bAdU7NpFOJSdMwjauSXrxJSakaQkNLc3nt+MghcZXQKiAwaDYQ8MHy93c2Td2xetAY=
X-Received: by 2002:a05:6402:27d2:b0:643:60b6:3eed with SMTP id
 4fb4d7f45d1cf-64555d0b0e8mr13479658a12.31.1764078873467; Tue, 25 Nov 2025
 05:54:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251114-pkvm_init_noffa-v1-1-87a82e87c345@google.com>
 <86y0nyqoy9.wl-maz@kernel.org> <CACF_fqmWwtuF_7+OJ2rUPvDJzs4ubJO6XCf6N9cW2-AABSx_NQ@mail.gmail.com>
 <86ms4br2dz.wl-maz@kernel.org>
In-Reply-To: <86ms4br2dz.wl-maz@kernel.org>
From: =?UTF-8?Q?Kornel_Dul=C4=99ba?= <korneld@google.com>
Date: Tue, 25 Nov 2025 14:54:21 +0100
X-Gm-Features: AWmQ_bkZGORaLGGQv90fi0qZIysVcT6wfv18GG47eL_bs8jumfSYM6eCm-h-Fcw
Message-ID: <CACF_fq=PwSucRBYCu7A7HvcZiGss49UQipERfmk0X84-gj5ZNw@mail.gmail.com>
Subject: Re: [PATCH] KVM: arm64: Fix error checking for FFA_VERSION
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Bartlomiej Grzesik <bgrzesik@google.com>, Tomasz Nowicki <tnowicki@google.com>, 
	Sebastian Ene <sebastianene@google.com>, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2025 at 2:22=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 24 Nov 2025 11:49:08 +0000,
> Kornel Dul=C4=99ba <korneld@google.com> wrote:
> >
> > On Sat, Nov 22, 2025 at 12:36=E2=80=AFPM Marc Zyngier <maz@kernel.org> =
wrote:
> > >
> > > On Fri, 14 Nov 2025 11:11:53 +0000,
> > > "=3D?utf-8?q?Kornel_Dul=3DC4=3D99ba?=3D" <korneld@google.com> wrote:
> > > >
> > > > According to section 13.2 of the DEN0077 FF-A specification, when
> > > > firmware does not support the requested version, it should reply wi=
th
> > > > FFA_RET_NOT_SUPPORTED(-1). Table 13.6 specifies the type of the err=
or
> > > > code as int32.
> > > > Currently, the error checking logic compares the unsigned long retu=
rn
> > > > value it got from the SMC layer, against a "-1" literal. This fails=
 due
> > > > to a type mismatch: the literal is extended to 64 bits, whereas the
> > > > register contains only 32 bits of ones(0x00000000ffffffff).
> > > > Consequently, hyp_ffa_init misinterprets the "-1" return value as a=
n
> > > > invalid FF-A version. This prevents pKVM initialization on devices =
where
> > > > FF-A is not supported in firmware.
> > >
> > > Is this statement accurate? I regularly boot KVM in protected mode in
> > > environments that really cannot be suspected of implementing FF-A
> > > (there is no EL3 to start with). And yet I don't see any failure of
> > > the sort.
> > >
> > > Please clarify the circumstances this is triggered.
> >
> > I do have EL3 enabled, but the FF-A itself is not implemented.
> >
> > Without this change kvm initialization fails with the following:
> >
> > [    0.946776][    T1] kvm [1]: nv: 554 coarse grained trap handlers
> > [    0.952880][    T1] kvm [1]: nv: 669 fine grained trap handlers
> > [    0.958813][    T1] kvm [1]: IPA Size Limit: 44 bits
> > (...)
> > [    1.034089][    T1] kvm [1]: Failed to init hyp memory protection
> > [    1.041213][    T1] kvm [1]: error initializing Hyp mode: -95
>
> [    0.045492] kvm [1]: nv: 568 coarse grained trap handlers
> [    0.045860] kvm [1]: nv: 664 fine grained trap handlers
> [    0.046194] kvm [1]: IPA Size Limit: 42 bits
> [    0.220184] kvm [1]: GICv3: no GICV resource entry
> [    0.220525] kvm [1]: disabling GICv2 emulation
> [    0.220852] kvm [1]: GIC system register CPU interface enabled
> [    0.221264] kvm [1]: vgic interrupt IRQ9
> [    0.221565] kvm [1]: Protected hVHE mode initialized successfully
>
> Ergo, it works here without FFA (this is in a nested guest that is not
> exposed anything but PSCI in the FW emulation).

I think this all boils down to how the error code is set in reply to
the FFA_VERSION SMC. In the do_ffa_version function in this file, the
return value is set with no casts: "res->a0 =3D FFA_RET_NOT_SUPPORTED;".
Since res->a0 is an unsigned long and `FFA_RET_NOT_SUPPORTED` is a
(-1) literal, the latter will get promoted resulting in res->a0 being
set to 0xffs.
At the same time any implementation that returns "0x00000000ffffffff"
will still be compliant with the FF-A spec, while triggering the bug
I'm trying to fix here.

>
> > I managed to narrow this down to the FFA version check by examining
> > all of the places in kvm initialization logic where -EOPNOTSUPP is
> > returned. Since printing anything in this part of the code is somewhat
> > problematic I replaced =E2=80=9Creturn -EOPNOTSUPP=E2=80=9D with =E2=80=
=9Creturn res.s0=E2=80=9D to
> > examine the problematic register value:
> >
> > [1.041229][    T1] kvm [1]: error initializing Hyp mode: -1
> >
> > Note that the return code itself is cast to int before being printed.
> > Then a colleague of mine recommended looking into the arm_ffa driver.
> > (=E2=80=9Cdrivers/firmware/arm_ffa/driver.c=E2=80=9D) There I found tha=
t in the
> > ffa_version_check function, the return value from the SMC call is cast
> > to s32 before being checked for errors.
> > I did the same in the kvm initialization logic, which is how this
> > patch was created. Furthermore I also examined the FF-A
> > specification(DEN0077), where the error code value type is specified
> > as int32.
> > With this change applied I can now see that kvm is up and running:
> >
> > [    0.946839][    T1] kvm [1]: nv: 554 coarse grained trap handlers
> > [    0.952940][    T1] kvm [1]: nv: 669 fine grained trap handlers
> > [    0.958867][    T1] kvm [1]: IPA Size Limit: 44 bits
> > (...)
> > [    1.061717][    T1] kvm [1]: Protected hVHE mode initialized success=
fully
> >
> > The /dev/kvm file is also there.
>
> I don't dispute the bug. I dispute the assertion that the absence of
> FFA triggers it. So either your testing environment influences the
> behaviour, or you have extra patches that also change the behaviour,
> or something else.

To be completely transparent I stumbled upon this using the android
fork of the kernel, but I don't think that matters here at all.
On my device all cores start in EL2, so the problematic SMC call
should go straight to the FW. I believe that the FW sets the a0
register to "0x00000000ffffffff", indicating that FF-A is not
available. This behavior is actually what the FF-A spec says should be
done, so this is not a case of broken FW.
At the same time it does trigger a bug in the error checking logic,
which I described above.
