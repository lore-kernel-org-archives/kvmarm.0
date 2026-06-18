Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0CE369990
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 15:03:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781795038; cv=pass; b=LbeNE3GJsxfvw+XoPDDhstvkp0qdmlG91in/zhyCyThV3dEJ6sLMbCVTV4v4KRygDMrGwkNTEyFaYSouYQUGKFo5yClxmcoMd13CP/43+H/U50mjGO9uzBXNAhS5IAQCCrvo+ogmGy1emrnpUiCY63eqCCr6wWjuxNPgzdsjbak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781795038; c=relaxed/simple;
	bh=CreuZGAyA2yXdYiyynjJMmkbAI8xobOWPuumYFkB2SY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqVqJwnm9OiigPEK1NI7ORHZZrF+FCOlJ+i9jJ5/FRLvvl+h9mo+KvwlgdSa5VEj2nWDgw2BUb+bpZR3vsdC4s3AhAISzqmpX8sUIw55dcV8W4d9TSfZvwyZFU5pX8ImxHAm3v/iLlcAFfmQ/wYqDAOmGJN3LEW9k87Iz8mbdMs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=s65esCUj; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="s65esCUj"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ad4d840d43so7703e87.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 08:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781795035; cv=none;
        d=google.com; s=arc-20260327;
        b=eAghhAEZKhNOsdOSYxsup+HFN6y/0Ma26JznZPa64T8WueJgZFgKbKswKiHmyC+9QS
         rXN6oNEMyEi87lqa4d1yrPVHUECKCeE0AE0x9HanE+XERPn/gUoWuKwT44TYdoRYH1gM
         2fs5oP5RWIAJL5yB0lPw+iJ2Cs5DIslAhc/UmQ6ipNosIsMkwjWdO0iQDFP4ds5ICJO1
         /Ts5q8TKnPN5vrUsodhQiLrievAVFOZDGTsLzJQJ+iw6TdwWXUU0pmYT6t9KZiy76Yji
         RXx5qCymYVMITKeGpCN0fXwP6FYiR1oGbM9ZTZOfa3LP2dQqNkYJB/yzBsiwV/pxeg7j
         ewBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pkfEGlJK0eWAtoOzL9Uv+iGzEXyPiPqwMky2LM9WWSQ=;
        fh=DSKuzP0vL/udqsp+w3hpJOpxi/gGMzMW1B5oBGTK8XU=;
        b=BheXQqnPGR2buNztlFqo/1p2hgW3q6UGbscYRGnom9rvl1++2xdqKAEySYvtPgMeco
         PXbJBkGPWKGnDchHoWM3JVhLQ5OaWybTU9Ai8aZySEm7WkUFjd0+5uAqXtVnF/U0X/Wv
         iaw2Iwd4tW+Te+ZRY6jGT583RENY/IY0MiSCwl8epGlp+YjKMqA4bntp4S/eDVf3A+MN
         xlBNwB5uFDqULYt3QgsaK6In3JdeHanPDNV6ZZnRovMRRzOZ/H8YtOtW/8fDIbkWMJM6
         Ek0+QMsjbNkzqUJXEhptNDsop3KxC1ioFWWvPjpnMCux3IFuBbDpIyg+eu9E836gXnv2
         ISWQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781795035; x=1782399835; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pkfEGlJK0eWAtoOzL9Uv+iGzEXyPiPqwMky2LM9WWSQ=;
        b=s65esCUjpGrV3TnESinThcUZdNiEar1mvUr55rVraPGBNmBMAwGp6MSYdcUr9rYMs5
         rkX+apZgioctke4Dm3qjiaxyK4rJ8R3QqIcQrtYKp9dKVs85q6K6St3licdeg2f/iZ9e
         xWsA76U6BV1gXLU8TMhlD2RG9z5jUOcH8+juah5QGlvMqs3yonK2yQPAOrdnXgLPHLHz
         3O1G5wGjrIi3BnsxJisiJ6pFh1rk0vPycBAf/v8Tjo6mn83m7QDP7/LaBnx/6bHr/4EX
         CzBUNEfJ1JQVMqWUdDrArAQDrVP2OK1DzCvf07EkM7/jKMLGf2fFapM8yvWIi1ZsAcU1
         ZFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781795035; x=1782399835;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pkfEGlJK0eWAtoOzL9Uv+iGzEXyPiPqwMky2LM9WWSQ=;
        b=h0bx9StS8JB0JBX9+8YitfrEc3oZbY9bU+9pjLGdtbJdoBvA/gye28tkK5zsi6jT3V
         zPvKBmHwDFhfuF47C2E8I+O/BSBYWczWX7J1J6Ex4iH9BELmrh5gPiybU6KLCUdLTG7t
         Lt2tK49utfy9fvaPpTWF54mSvtPckyYagmPTVznBZj8/LHqbebEGEo709yLBsmK8WL09
         EnVJmd7EtctV4jgRx9pw0Ww8KqesDT++wRU8UCFQjmVwqO0IwSSZcki3v+/LwBczaE3o
         56XOIh3q03OyODmzMPPmtvJLr5e5ru5G3s00PkEnlbOklv45eUuClveWXg40GiHZso1+
         vaRw==
X-Forwarded-Encrypted: i=1; AFNElJ84SD1L/x8ShBuJYQBOD/oQRtzR7EkEGqm4oOyR1CyU1d0cpJ/YYeeUfFJqwFqLoe+dkdOQU1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YwV+mKj/SDIepwvzMxcinPmMgakTOSKqlr6DZw/wV/DH7U8du+G
	9NZ3sz4VDPuvsVOvHB6ilDA5ePwqZs3JTqUesJEjTP21Rl88ZxETFyD7nQ8DVbz47auSIVTvSEl
	tyjQf9TaMbia3hYGOkbNDnOmuY6DlCjarVFpxYJtX
X-Gm-Gg: AfdE7cmvq9g+gMo1+OaBVi3kyb5Ot+82nEnX4ad39ChnvHRbSq7aIveOPMBHhjw5DmD
	wPwqoL3zYCsaXTP6ESnza725HC+UwA5cXzLb3vdSQds5mKGYm5bkvv1CYcTdnCeG6KWJzKXqFhP
	5SGFN5Orsm0J2nK424x2ycJaEe67Ci2WSflYc2IKvG/RTa+tbuBlr3K5p82zB201JMFI53fWWfR
	lKQZh16igMTJS5KFjhg3jyz++Q+WNykphZ9gEeGixcVdJjfMRl4ATaD3Jng4LeAaoddDIAmCw==
X-Received: by 2002:a05:6512:3ca1:b0:5ad:4a8f:58ed with SMTP id
 2adb3069b0e04-5ad4ee99865mr137935e87.7.1781795034214; Thu, 18 Jun 2026
 08:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com> <20260618121643.4105064-6-tabba@google.com>
 <20260618123251.260FC1F000E9@smtp.kernel.org>
In-Reply-To: <20260618123251.260FC1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 16:03:15 +0100
X-Gm-Features: AVVi8CcBLEeWh6pfNQLq6GQzYuMrd-zkTAwW9UqiCtrJbRvUWK0UwMXDM5aAgoU
Message-ID: <CA+EHjTyJUrHZJiM9e2r20_1JLzWQg-+TAr9g720njugLMWTpGw@mail.gmail.com>
Subject: Re: [PATCH v2 5/7] KVM: arm64: Set IL for emulated SError injection
To: sashiko-reviews@lists.linux.dev
Cc: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2026 at 13:32, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] kvm_inject_nested_sea() passes an Instruction/Data Abort EC inst=
ead of an SError EC when FEAT_EASE converts a Synchronous External Abort in=
to an SError.

Not a bug. EASE does not convert the exception to an SError. It only
changes the vector offset. The EC remains the original abort EC. The
non-nested path in inject_abt64() does the same thing. FAR_EL2 is also
correct since the exception is still a synchronous abort.

> - [High] The constructed ESR for a nested SError is discarded during inje=
ction because kvm_inject_el2_exception() never writes it to the guest's ESR=
_EL2.

https://lore.kernel.org/all/20260615131116.390977-1-tabba@google.com/

Thanks,
/fuad

> --
>
> commit da891cfcd9b452feacd8b631f8c20dae39b009fc
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Set IL for emulated SError injection
>
> kvm_inject_serror_esr() constructs an SError syndrome without IL. The
> architecture mandates IL=3D1 for SError unconditionally.
>
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_faul=
t.c
> > index 444d219b02174..d6c4fc16f8795 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -381,7 +381,7 @@ int kvm_inject_serror_esr(struct kvm_vcpu *vcpu, u6=
4 esr)
> >        */
> >       if (!serror_is_masked(vcpu)) {
> >               pend_serror_exception(vcpu);
> > -             esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
> > +             esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR) |=
 ESR_ELx_IL;
> >               vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
> >               return 1;
> >       }
>
> [Severity: High]
> This isn't a bug introduced by this patch, but while reviewing this SErro=
r
> injection logic, I noticed an issue in how ESR is constructed for nested
> SErrors. When SCTLR2_ELx.EASE is set and a Synchronous External Abort is
> converted to an SError, does kvm_inject_nested_sea() pass an incorrect
> Exception Class?
>
> In arch/arm64/kvm/emulate-nested.c:kvm_inject_nested_sea():
>
>         if (__vcpu_sys_reg(vcpu, SCTLR2_EL2) & SCTLR2_EL1_EASE)
>                 return kvm_inject_nested(vcpu, esr, except_type_serror);
>
> The esr variable retains the previously constructed IABT/DABT Exception
> Class instead of being reconstructed with ESR_ELx_EC_SERROR. Does this
> present an invalid syndrome to the nested guest hypervisor, since the
> architecture mandates that ESR_ELx.EC must be 0x2F (SError) when an
> External abort is treated as an SError?
>
> Also, does this unconditionally update FAR_EL2, which is architecturally
> incorrect for an SError?
>
> [Severity: High]
> This is also a pre-existing issue, but there appears to be a problem wher=
e
> the constructed ESR for a nested SError is discarded during injection. Do=
es
> kvm_inject_el2_exception() fail to write the esr_el2 argument to ESR_EL2?
>
> In arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception():
>
>         case except_type_serror:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
>                 break;
>
> Unlike the synchronous exception case, the esr_el2 argument isn't written
> to the guest's ESR_EL2. Since the downstream exception entry path
> enter_exception64() does not write ESR_ELx, does this result in the neste=
d
> guest hypervisor receiving an SError with a stale, unmodified ESR_EL2?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.41=
05064-1-tabba@google.com?part=3D5
