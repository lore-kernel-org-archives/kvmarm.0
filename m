Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BAA33F4DD6
	for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 12:43:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781527385; cv=pass; b=Vz7y7Nsv0d8kVCuGfRBd4ICKKJtEdRyvBsPKU4YZI1NUUYzfzpZFOx7Qun0uUeUO7uVQmrCaftyVdjYa2VU8zNIfAIY6hk1PGjwIQqp/eXulJUOVf0QEb9wKn3iOwjQwxYIDVQgWzpbmpSF3/1BwFBWedwT/0bQWg17tNDI3MvY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781527385; c=relaxed/simple;
	bh=Bw9yLChPYY8XYNoz0p+T9zcVRoabwdPf/QVDPf9nI34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oAhll/8W1SCYXyTFfxU4cEk495UZomnHSZHdsCup2bR88vwBudu4/EyZvN0aEr9ufnnV9JnMgiYJSsp2THGyyBNeWo8vMBArzuQlahbpXHvrgI1rwzl71p0VGomXirXP7HpFlre/RLLBQQdHzjMe8GWautCQkr67qorVsUFR/xg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ePXdnS1a; arc=pass smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ePXdnS1a"
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51765531803so62601cf.0
        for <kvmarm@lists.linux.dev>; Mon, 15 Jun 2026 05:43:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781527381; cv=none;
        d=google.com; s=arc-20240605;
        b=iR0w634JyrYFHj69PHaUU4ZJblTDWT66owAXnTf+ttbeh/xoOQrXtuZUVqAhLM+wMU
         tRMJ34Sz5Ge6c6MA35GMi4WA56MH1B32T4dqakXNcU2B7ADQGaxbXo8ZtfJGd/Zvd3AU
         jdMsXawiw2QV218+hDMcWQIi8mGzvzROnnphrCHLw0+Ankh3gzqcANepTph/RIRdzWby
         WWCXMJnlsP8FzV1LWT3BPklSWiAA1hc+FLr2AswuoStNR/DxLHZoiaRpqspaZI8/DuQr
         8EvJGMWe+xK+4WTcXYQF3Eg59qEX8iGsa0VMMHul07yBSFNdH9/W5UpoSdrhcNBx7cAT
         2Jyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6RinZ6UVRLzqeCskT7I+XyHLStsWE+0zve+ajaQieeo=;
        fh=yJ9rJtB6TAjKjc9/D08d/lu4OZEIZyaWIZwlSvToRBI=;
        b=f0V496axkvKeIxZS11guWfMPnYshGWrl2A8F71RC3Lu/VKdp6HXyq5RfQdQYSB/+bq
         dXRxExs25SFL8kRr/K2MtsJMd2C6pXi5J0nEJZOpbmTpgd0f2qtNpn+ldGnwSu6gO+PF
         jFnCFu0cz/oG72LDbR1+yIoJXSBHbVhXpIm0O/w65O76+Ou6D/gRcdXpTXpC5rRgWI3x
         Q8WGe/CjgV6rB4zSEK7JDUj0w3K2yFuH31T0J99rjGmiLdUGFYsW/8A4i+U01gfSLwMe
         nlA05YU8tAs4i5pjiSUQEiBUssF2McYUYJ44BN5VB+EC2E7YPklrtrGtBcUQmfrVOcjg
         +YdA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781527381; x=1782132181; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6RinZ6UVRLzqeCskT7I+XyHLStsWE+0zve+ajaQieeo=;
        b=ePXdnS1abGdotB4EFVNEsCmzxVchAP5NmJmeOJenTlVX4l9OATfLOyEP70O9Hv8xzO
         ii2dvBAEVoXblAFQC/IXxRgz4mR/YwEhxqvjavNq6g6D+nvis8n9eggVNl83MfaS2hvt
         G+Gd/MskI9LlH0oA5We2+ip64twjX5e22rWzAy0BTIBh35sojQstrcpFo/NFmeaIBLHF
         7TyZa/3Yzoqnql+yGboPakSsPlkrZVyUex8bq80453JGlOazOipMY/N9II3Df/asQ35L
         dDHgvVS/21Qu19DZqNDaWPGIHAV5jg8y3pLl5foPc378x3j6LcxldGkpaNPE6eQ/lSlm
         3sBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781527381; x=1782132181;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6RinZ6UVRLzqeCskT7I+XyHLStsWE+0zve+ajaQieeo=;
        b=BQdMhimbgPt07MjksVo2fwhtr8WTNsVck4MHgfOGLkk7Jeb8KlAuSPSn21uousi2sD
         rydsblIuXK98R6RYmz6oduIUmia9HO7EJF+sQoHXWq+mo7LUCjRs7RnQI6Y8VfRqKEwz
         Zm1ofT+1PPgpec1Ez0aHZw3mv7Kx68mBpyJnP7gksmgRLolcGCVFfcsEhzua/d33ejYu
         KeSJ8jqYBgQGnCmDr90D7JjW4SPA554EHWyAGYEvingpvEn+SPEYuVrqv99OG+KGqy9w
         rAew9PrwQbs6ev1bzf879UsHIktri0DwfpvgTWBtQE1z+YP8fhh74eEop8P4k1tsXUTi
         d+tQ==
X-Forwarded-Encrypted: i=1; AFNElJ9VNaFfWeZmpegqmHWqrXaP03dOc6qGE+mU2q33J7TYkV8ypqqYv7V4ENkOBLAgbwLfRpCVwOc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJEbOsLDMi+1OW8Dog0/H9dYNqB679G/HTkc/44rQS260buSTW
	LuE3T05rlTxboLcj5xs5Go6qW0/3pkS3+q3B5cuEh3qs0mPoDa7SkJ4Cw62z1n4zNnRlsURnv+Z
	XkjxaDg5Nb78dGUHuKoLi47dBdHyca7crZi4yK9lYhuC7SDKxUu4Cvl0o0V4=
X-Gm-Gg: Acq92OEoh4l/xM1UfOxRVNY3qMKxs610+rRh9NAVXCMUr43qntlt9tmnoehbMXagjK1
	ZB12rCIfx51eA1SH3z6NV2ZhiwXri6GGrAZq3TlVjjyNAo+Tg0D/rRhS6h6RkipDG35xH2LSfPT
	bQS10jn4lY4qS1thTN9WmqLsjtWBeW/AaPvKbTSa+Xxz9K/nU2rQzwd+7L2JUyqIUn9fUq3Pa+t
	Xuv+k537dbQKc7S61iYq1BAAiDps/onskMdiUZ4eSPKy0U3sZm05ru/Omhf/9fycVb83H0Ra93y
	rq+d/Hts
X-Received: by 2002:a05:622a:4f:b0:517:6488:904a with SMTP id
 d75a77b69052e-5198752b4damr1402741cf.20.1781527380134; Mon, 15 Jun 2026
 05:43:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260614163336.3490925-5-tabba@google.com> <20260614164547.D398B1F000E9@smtp.kernel.org>
In-Reply-To: <20260614164547.D398B1F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 15 Jun 2026 13:42:23 +0100
X-Gm-Features: AVVi8Cdrb9YQfLGPkc6Ljw1y0SYp8HnSvtrsJjbiTklgs9sQgOb93MYz_1Urvhg
Message-ID: <CA+EHjTwHoveK6FT0CGcKuj97aUaHpv7vk=DQjRxT9c6UkkSeoA@mail.gmail.com>
Subject: Re: [PATCH 4/7] KVM: arm64: Set IL for injected FPAC exceptions
 during ERET emulation
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, kvmarm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 14 Jun 2026 at 17:45, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Incorrect Emulation of Illegal Exception Return corrupts ELR_EL2=
 and may cause spurious Instruction Aborts
> --
>
> commit 56bc216de713f5bf0e45ff5ad97580cbdc7eeb66
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Set IL for injected FPAC exceptions during ERET emulation
>
> This commit fixes the FPAC syndrome constructed during nested ERET
> emulation to include the IL bit. It ensures that the IL bit is set to 1
> for ERET and its authenticated variants, which are always 32-bit A64
> instructions.
>
> > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-n=
ested.c
> > --- a/arch/arm64/kvm/emulate-nested.c
> > +++ b/arch/arm64/kvm/emulate-nested.c
> > @@ -2777,7 +2777,7 @@ void kvm_emulate_nested_eret(struct kvm_vcpu *vcp=
u)
> >                */
> >               if (kvm_has_pauth(vcpu->kvm, FPACCOMBINE) && !(spsr & PSR=
_IL_BIT)) {
> >                       esr &=3D ESR_ELx_ERET_ISS_ERETA;
> > -                     esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_F=
PAC);
> > +                     esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_F=
PAC) | ESR_ELx_IL;
> >                       kvm_inject_nested_sync(vcpu, esr);
> >                       return;
> >               }
> >       }
> >
> >       preempt_disable();
> >       vcpu_set_flag(vcpu, IN_NESTED_ERET);
> >       kvm_arch_vcpu_put(vcpu);
> >
> >       if (!esr_iss_is_eretax(esr))
> >               elr =3D __vcpu_sys_reg(vcpu, ELR_EL2);
> >
> >       trace_kvm_nested_eret(vcpu, elr, spsr);
> >
> >       *vcpu_pc(vcpu) =3D elr;
> >       *vcpu_cpsr(vcpu) =3D spsr;
>
> [Severity: High]
> This is a pre-existing issue, but does setting the PC to the target addre=
ss
> here cause issues when an illegal exception return is detected?
>
> If kvm_check_illegal_exception_return() previously detected an illegal re=
turn
> and set PSR_IL_BIT in spsr, kvm_emulate_nested_eret() unconditionally
> advances the guest PC to the ERET target address (elr) and returns to the
> guest, relying on hardware to generate the Illegal Execution State except=
ion.
>
> Wouldn't the hardware then save the target address into the guest's ELR_E=
L2
> instead of the faulting ERET address, corrupting the architectural state?
>
> Additionally, since the hardware fetches the instruction at the target ad=
dress
> using the guest EL2 translation regime before execution, an unmapped or
> unexecutable target address could trigger an Instruction Abort instead of=
 the
> required Illegal Execution State exception, per ARM ARM D1.8.2.
>
> Could this result in the guest hypervisor receiving a spurious Instructio=
n
> Abort for an EL1/EL0 address?

Not a bug. On an illegal exception return, the Arm ARM specifies that
PC is set to ELR_ELx unconditionally. The subsequent Illegal Execution
State exception is taken at the target PC, so ELR_ELx is saved with
the target address. This is architecturally correct.

Similarly, an Instruction Abort at an unmapped target would take
priority over the Illegal Execution State exception, which is also
correct behavior.

One thing I noticed while looking at this:
kvm_check_illegal_exception_return() preserves {N,Z,C,V,D,A,I,F} from
the current PSTATE, but the Arm ARM says these should come from
SPSR_ELx on an illegal exception return (EL and SP are unchanged, but
the flags and masks are taken from SPSR). PAN and ALLINT should also
come from SPSR_ELx if their respective features are implemented.

Marc, is the current behavior intentional, or should we be
constructing PSTATE from the original SPSR_EL2 for those fields?

Cheers,
/fuad

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260614163336.34=
90925-1-tabba@google.com?part=3D4
