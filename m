Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6C12E8B64
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 14:47:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781794074; cv=pass; b=YzybPilq7lBSTmx344yk31a52ANBwQIYgRN3Syt50Qc4yLmkB7hZqgLEcQMMPblJKKSfiT15VNayBvhlFrW41cLuF8ZHg8cbIsnvA99J0VnPyetn5baM1ZMDwmsKc6nd3zgCzHb9dDel8bXi+fuCDm4icgIyr0qoVngDCeNJ8cg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781794074; c=relaxed/simple;
	bh=LzQ/2P+hOP+suzGipZPy+apY9BEJgJZMJcc/piGvcxE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jk2kJDYT06/i4/0W9pEsKxOg9ZXv+bQm+YrjY+fOPpz+CzAkmcjUFr1TEModT7buuq7KOR1MkikB9jVIrIB7vkmtpf5SORI0v8fIu3Zl775cnhzoVMqFlUK254G3VdrcDVyoT2qbPhCDw3uH4FrSA3wMf1IaG0llbJdz9Pw0SIY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bx+4inOX; arc=pass smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bx+4inOX"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5ad4d840d43so7511e87.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 07:47:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781794069; cv=none;
        d=google.com; s=arc-20260327;
        b=TXZmdbfhDGnXq/hJMOflWte3WFPO+7/cG0wA7etoUG4U1znUlZJEs7O6GTPC0YBalP
         ACp0idBeRQ2b41zXAHOFDKHHWefOVPCB9Nmw2JAtfHcZW2WWDZ5Vl/JjRHpEiArWNZTz
         MJglvNn4gw7lXr5pz39l7jrIY92IKHMsA+3mZwBH4R8IFAX24WA7wOg306LSoYBRoy9F
         DbU3US/KCuhZBwCBM2H15N7mqo0rTv7ozrABhvdNbaiYApfGVfw1GToi0ii7ZnJ5dZdb
         BDERxN25khSYG+fXaN0pucokychcSAOpVgb+yUtbGzWdQ0LUtn5bJP6wTSC1bqKAw0DF
         We6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dmN9nS4vJ3TKXwg/LI1WEk/6tZyzDcctWdh0WqJnNg4=;
        fh=6hS9v4pnHqMTlaOnyy4JDUeIkRhTfNk7QI6Kq4+R9Rc=;
        b=oXSMia1173EKpleZ++pftFcHdxHjG83ul7Ln8+lAfSjq1wht68DVG2TfGkni9pMjnZ
         ua+QyH+vL/ojM5ll7/b/cK57tLjSVsxHHT17wFHkGbWoUxLkhR6ySIf8Eu49B3L8vwQ+
         qzcGZxrmmMvoX2q5ReUZMWSSnml6bocoqPyXpH/ErmEslIyLB54njDhU4/Mb6hbxkU2W
         SixJl3KaSiD1arl7TMC/yc1jpxMDD2ecvMb+d49QBj9931bJheCiF5Au1ulW44EOG5lK
         0E0p8dADlP4MOa3Ydr7/WQ+7OSXPPbIc4e8t2vvz6jFmYYgvwLCkIu+lnY1p6f25YjtS
         Wwvw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781794069; x=1782398869; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dmN9nS4vJ3TKXwg/LI1WEk/6tZyzDcctWdh0WqJnNg4=;
        b=Bx+4inOX87FQayAqGFN2YEY+dhjy7+/TWqhh1YoAfSmPBWsqrcGHx+og6toYwyUh3L
         AKNcVh3U381m9YbHWQBPFOHXTj5cC4CtP8U61SyWaT9/lubhFseuqo422zZ8K0B1fuuv
         UW6M4v7XgeX/5sUW2swYk/ATbs2iNdUciRIrPs/rngAkZZgspXTV5ZVCIIB8Wqkl8EYI
         JxdF0/q2kucOQB4MuvL4G4jzAXwMpwBQC0557cJCGcFLZYq2LsCQc4LweP1mKz3E3TD0
         mcLgaI3CzrTxxqJ353jyUrSPj2U0dV6I1uHq321g3NZdA5Gfd1WnEqCWXpQgLUnI/6yp
         S1ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781794069; x=1782398869;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dmN9nS4vJ3TKXwg/LI1WEk/6tZyzDcctWdh0WqJnNg4=;
        b=lYayfOIldxOLLin2z2yEhRtQKywVQkgvOH/wl65KgpfaFgN2ebgnCQrv1LRHEP0Ozb
         DeenAPU/9+cJWTdvm+Teu/avYrIA1keAaYH2/RJG/yxoe8rJzY4x2I6txQ142G21X+js
         32vp4ZLQjaef5OROzR41UAdGOjQGtl/1vPAQ3rR4C3/kEIOUOr2XlqVzotBSmHYqJmeI
         MG8C5wFpriSj4bI/M6ssh+l0Sh+VXPMp9YidblF/Y/oO1uR6imnQdzbp3Fa/NFte0+P1
         wmxgagX6fhUSFAZeVBP/pL3yQiTl+F+Mc9V/0hc5tPFPdX1iQasL81xqGif5NUg4QsQY
         LnGQ==
X-Forwarded-Encrypted: i=1; AFNElJ9q+c3Rci/UiX60LJSLK4b/7gwaMeQI2dDZ2xISOgPk2CQexiy6iRCIon8bGRC59PZ8auacGbM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+qJtef5qgAMoEX998DgyIgfsfw5z47kM+bYQ4V+fCASSriklp
	fEuAGGcIzfxcsLKje2ZLafbRdy/wuWHKgDBpKHscElRgssL26BZrUToa0+0UuEqkUFlJiGNmcvR
	s56ZuMapzTi8P1YQZWOgKg9U8DwbEtkQAE3qiroVj
X-Gm-Gg: AfdE7cnyW6R+H5oiV+Ywm1izAUQcMSa/9eToftNCh+mFTEUL2TOP+ygJxLyXX0SU5QX
	3pAJCtiherwlmlT6QX7pxi48frOeqG14u5CufyxPQADNhi6pmL++u1gUs8l+hI29SzMzVGwj5q/
	vRR9LJJI2H621V3uURrMdhlBow0hPkZDJ/9PAQvqNu9uZYeK4AqSslWDKd62YVl+uAHm5weepKL
	AtzeLLLOnKCL83VfYCVFKmmDvBCa0qWONP9LEMUyPz1qcnBLgy3dkABAiru7SZOuS3EQ0kIMw==
X-Received: by 2002:a05:6512:2254:b0:5a1:43ca:1ff5 with SMTP id
 2adb3069b0e04-5ad4ee99ce0mr156755e87.3.1781794068379; Thu, 18 Jun 2026
 07:47:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com> <20260618121643.4105064-4-tabba@google.com>
 <20260618122921.F224E1F000E9@smtp.kernel.org>
In-Reply-To: <20260618122921.F224E1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 15:47:09 +0100
X-Gm-Features: AVVi8CfxFGxHU2xBsoMAmS5XZRDUWTuQLVUDaNJBJNQ9Q3veP4V7v9kkWA_RbOc
Message-ID: <CA+EHjTyX7+n_F85PnScTZeqQChh9m16PwGUr5QNEjiRDOuHpSg@mail.gmail.com>
Subject: Re: [PATCH v2 3/7] KVM: arm64: Unconditionally set IL for injected
 abort exceptions
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2026 at 13:29, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] Unconditional IL=3D1 in inject_abt64() creates invalid ESR state=
 for Address Size faults.
> --
>
> commit 5d93cc0ddb43cdfa88e555d446e07e55b7334637
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Unconditionally set IL for injected abort exceptions
>
> This commit unconditionally sets the ESR_ELx_IL bit to 1 for injected
> aborts, assuming the FSC is always EXTABT or SEA_TTW.
>
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_faul=
t.c
> > index 9dfae1bcdf992..444d219b02174 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
>
> [ ... ]
>
> > @@ -138,11 +138,10 @@ static void inject_abt64(struct kvm_vcpu *vcpu, b=
ool is_iabt, unsigned long addr
> >               pend_sync_exception(vcpu);
> >
> >       /*
> > -      * Build an {i,d}abort, depending on the level and the
> > -      * instruction set. Report an external synchronous abort.
> > +      * Build an {i,d}abort, depending on the level.
> > +      * Report an external synchronous abort.
> >        */
> > -     if (kvm_vcpu_trap_il_is32bit(vcpu))
> > -             esr |=3D ESR_ELx_IL;
> > +     esr |=3D ESR_ELx_IL;
>
> [Severity: High]
> Does this unconditional setting of IL=3D1 cause an architecturally invali=
d
> syndrome for Address Size faults?
>
> If a guest executing in AArch32 EL0 issues a 16-bit instruction (such as =
a
> 16-bit LDR) that triggers a Stage-2 Address Size fault, the IL bit should
> accurately reflect the size of the trapped instruction (0 for 16-bit).
>
> Looking at kvm_inject_size_fault(), it injects the abort by calling
> inject_abt64() via the __kvm_inject_sea() call chain, and then modifies t=
he
> FSC to 0 (Address Size Fault):
>
> arch/arm64/kvm/inject_fault.c:kvm_inject_size_fault() {
>     ...
>     /* inject_abt64() forces IL=3D1 earlier in the call chain */
>     ...
>     esr &=3D ~GENMASK_ULL(5, 0);
>     vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
>     ...
> }
>
> Will KVM now inject the Address Size fault with IL=3D1 instead of IL=3D0,
> potentially causing the guest OS exception handler to incorrectly advance
> the Program Counter by 4 bytes instead of 2 during fault unwinding?

See https://lore.kernel.org/all/CA+EHjTyiyCNV40z82=3DYTTMrx3BoR5gn5uh-xP80g=
FxX2PSUMAg@mail.gmail.com/

>
> >
> >       /*
> >        * Here, the guest runs in AArch64 mode when in EL1. If we get
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.41=
05064-1-tabba@google.com?part=3D3
