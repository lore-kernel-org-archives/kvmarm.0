Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 757C63E9F7D
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 12:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781786434; cv=pass; b=DNUuMhrnpRGY9VHDQv0m3B3bzgHLOQNFbG2jUyB8r75xMzvp1ODpg7fb9SRZM9au59nxtzvXV/u1QRKM+TS6uxaw/D1xlb8zUqG0cQCkkN43kxq2csX1qKiFCwEoQakl1OlKxJZJzP6kIORc/EY/XAPbrQwmOHITqpCHMOObrXU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781786434; c=relaxed/simple;
	bh=JqFkPU1YZUUNdIgywwnabymVpfE0mxsplSqN/m5Xf3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NMAwIGpq9d9VJKjUA9UpbHAQDyWjSDAPEvfFjqn4xo+x75Qc1Rv+oACZFxAaDaZz2E0GUPDsZtfKtDmftoOB5ASacMqaEN9x1MKIu3XWbt9mk3AzQKH8HyxWCIXSGpeupDbJ0B4CmLwuVfov/PKVc24WsiullRa5K/DjpPUr9FU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oSKuz4Hh; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oSKuz4Hh"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5ad4c101545so7630e87.0
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 05:40:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781786432; cv=none;
        d=google.com; s=arc-20260327;
        b=rFA0uM9qxy/1miy6CyvHEljXW5U/2QJgDTXMCl6IO8HdiNPLC3S/628bLONn5GPZ9U
         +XN9EfkFU0gRpNOIamUjodPV6frW6ebFGfDi1TSNhsty+Nh5GqX7l5TD6au9Op3Q+usO
         91DJ6UCg+0jibf/suSkKl7pkXjfLC/km6ZLLo4Vbt7eGL/x3NRWOXFnU1xaZGCv89EJd
         XKar72BQNajs0h8AfCg1o/e/0+gMds6s/UpE7qwbRb+ISPHovoAXLQQXm8HXnBRliupF
         vSVKTNIEL7Ytwf/74xSv43Nr6E4hUeM+O6wXfXUrSur5fQV30g6MbAAoE3y25yMAFGgG
         3sPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=es6GlwL6osuLablGLUc5m02djaejDGTzvORgair7I8g=;
        fh=HhTV4G5+xnJ3thQDc6cpcOYMN3AitX7qB0zPfKB89LY=;
        b=ebVfmlCVFsZBg4i+iAvG6ofd+WO1B8Gf3aUPNqgChzJ05gLJnAldXB9ttvGdisCfWT
         UAWyGAb+0VXFNXRE8HYmJNZ5hQaQhgOIq7sltMZs+gr1CYJvhz0wm4PTTth1M+QraErs
         mqhVYa+uDdk3HqXR8iGJ96Q4TJUPjLMpgOGznV5hAWhb++DaQmq7iTrD/1Zg43PbNnrB
         7xtunHm4IwafyJK9szRaILpkEWGttrr/blQBbzlm86ve2j0j7BFwfpaaCkfzmenSuDHE
         s8+EhMHnqwjGKhjYyIwmulvUdCT34e3Y3N6B5ZLT5cGYzn7EXzbnPQQDmDX4jVMx/Cjb
         DV9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781786432; x=1782391232; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=es6GlwL6osuLablGLUc5m02djaejDGTzvORgair7I8g=;
        b=oSKuz4Hh/iABuzdS46OU7Axm0D6o/fICyZsZG3Bz48QnU654VNN90iEHFQEvK13aSm
         kTlaxJmdes9NeY+Zt6IpBVBWPRP5G1DquzsH49mR3k0lFc9Dz4j79CNIMVxgMKflTz0J
         9LVixCqx4OsNHgf6K4aK5SfwBYljFXi8YJwZjjYbPeelOzOA2ujWLcd2Di2ll32eRSAl
         2f+FAHBh3dXODybzAfvArZKxdZEdQdxJIXesO4zJ8f5YcvqixGhpzmvpWPlOT1G5vXap
         /s+raOMpyY1gqoUxJte6hS86CrsafIB2O99ghnIa21/Z+HscuURtJo8h7DJB/l/mfsJG
         SPsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781786432; x=1782391232;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=es6GlwL6osuLablGLUc5m02djaejDGTzvORgair7I8g=;
        b=mn2lgqDdwZynzoh7gne3Xn5kxjr/qXWeVu3R6xr85mFvhFjcmfdjdq7E2MaUlPPYaY
         5Q3hCGCrKodmKRqATfm1LPuPkwP0Hya4GNvATNWlGSVU/jVZtepEMeRgW4h++MF7mZtX
         5bhNzkDYV2y3SSHLJsg2CHjin4zwsFvgoQ6p9IX6o7BOSYPzlKJp9ZO9Icw3AE+JCrXC
         6wt3Wh+u6bhup3/bnKXVgBggbXefqll5sHTol0mQAuLJjmV/9daOH4gfDNxKXj+EMpnI
         Euw3PEJjzbVE+rHh70ZfOKda18opINAUH+/HjkUWPvDsf7ygnUn2Xc5XY6JNW74sd4Jc
         BntQ==
X-Gm-Message-State: AOJu0YyG56PR7ZqQbwMMZwOXS22yT4MhGhUMd5ifeh72OaazqmVsuf77
	gk4XDFtNkFsBXcHg1djevO9NKeu10VHEu/uVU5bxiG833LJn64d9YNmc4eDVZC7I7A2fLtRVaLq
	am654ev6DGrKzVT8jk5QruXTAgHGd6SLbOjWgMX26
X-Gm-Gg: AfdE7cnelWPCSXKB+vUMTLuGkJCvd9zmd7sUm93b2dF4rzGmQyiD4gsacHfqw/RPvkc
	aFElmMT3p4QeXyNwBRH4bf/Nkxj22Zko561jYf/RaboqGYnW0/ngJAJiI9tMZZyEkI/xte7+XnO
	anZSc3CbtA339zQ7zY5vvBpzXCE53eryV2/sFimBHu9ZHL2GyPkJjen2N1i6any8gN2vIcZof6y
	nykCSE1XGe0qKlTLRLbk1jlM6545I3vOYlthwmpUs+ajmBImIzl6IH4yQYvQkL7kmps1MpTbA==
X-Received: by 2002:a05:6512:2311:b0:5aa:4cb8:f0c2 with SMTP id
 2adb3069b0e04-5ad4ee99a95mr112116e87.5.1781786431136; Thu, 18 Jun 2026
 05:40:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com> <20260618121643.4105064-5-tabba@google.com>
 <20260618122808.1369D1F000E9@smtp.kernel.org>
In-Reply-To: <20260618122808.1369D1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 13:39:51 +0100
X-Gm-Features: AVVi8CcSxX3F_Uu_x91vSo9hvTOCvFtzAm8VGZt4D2A01B0rqw5n6I26pCsSV_w
Message-ID: <CA+EHjTwc5VR62V0BkXwZZT6ys-Q5RkSXLTku3b==0qG4k7VxGw@mail.gmail.com>
Subject: Re: [PATCH v2 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
To: sashiko-reviews@lists.linux.dev
Cc: kvmarm@lists.linux.dev, Oliver Upton <oupton@kernel.org>, 
	Marc Zyngier <maz@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2026 at 13:28, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] The constructed FPAC exception syndrome incorrectly maps the ERE=
T ISS encoding directly to the FPAC ISS encoding, resulting in malformed IS=
S[2:0] bits being injected into the guest.
> --
>
> commit 27996a8004c4285e2d114067b3fc644f3f649d64
> Author: Fuad Tabba <tabba@google.com>
> KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation
>
> This commit sets the IL (Instruction Length) bit for the FPAC syndrome
> constructed during nested ERET emulation. Since ERET and its authenticate=
d
> variants are always A64 32-bit instructions, the IL bit must be set to 1.
>
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-n=
ested.c
> > index dba7ced74ca5e..b74369e9ad7ff 100644
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2776,7 +2776,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcp=
u)
> >                * ERET handling, and the guest will have a little surpri=
se.
> >                */
> >               if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR=
_IL_BIT)) {
> > -                     esr &=3D ESR_ELx_ERET_ISS_ERETA;
> > +                     esr &=3D (ESR_ELx_ERET_ISS_ERETA | ESR_ELx_IL);
>
> [Severity: High]
> This isn't a bug introduced by this patch, but does this mapping of the E=
RET
> ISS to the FPAC ISS result in malformed ISS[2:0] bits being injected into
> the guest?
>
> For an ERET trap (EC=3D0x1A), ISS[0] indicates the key used (0 for ERETAA=
,
> 1 for ERETAB). For an FPAC exception (EC=3D0x1C), ISS[0] is the Instructi=
on
> Type (must be 1 for a branch/return instruction), and ISS[2:1] indicates
> the Authentication Key.
>
> By retaining the ERET ISS[0] bit and clearing the rest, it appears KVM
> inadvertently maps the ERET key type directly into the FPAC Instruction
> Type bit, while leaving the FPAC key type (ISS[2:1]) always at 00.
>
> Consequently, wouldn't ERETAA be injected with an FPAC ISS of 0 (wrong
> instruction type), and ERETAB get an FPAC ISS of 1 (wrong key type)?

The FPAC (EC=3D0x1C) ISS encoding is two bits, not three:

  ISS[0] (BnA): 0 =3D A-key, 1 =3D B-key
  ISS[1] (DnI): 0 =3D Instruction key, 1 =3D Data key

The mask (ESR_ELx_ERET_ISS_ERETA =3D 0x1) keeps ISS[0], which has the
same A-vs-B semantics in both the ERET and FPAC encodings, and clears
ISS[1], giving DnI=3D0 (Instruction key), which is correct since
ERETAA/ERETAB always use instruction keys.

Thanks,
/fuad


>
> >                       esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_F=
PAC);
> >                       kvm_inject_nested_sync(vcpu, esr);
> >                       return;
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.41=
05064-1-tabba@google.com?part=3D4
