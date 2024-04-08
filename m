Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68CEA79F0
	for <kvmarm@lists.linux.dev>; Mon,  8 Apr 2024 13:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583630; cv=none; b=OhRkhCRkt8S4oQqSaauWr4I8/m6baHnGHSVAt9OtLCAbegmOfcyzgO+vNqppKVtk7Iqror/D5rPHmgbgNJNLGuZjFgMaEDeORKVT9erqHejeI8bC2OJ1YtB+KZu2MUO0GCp6RjpwUNDUpIdflwlgs0omPlaAbtyY3kbcPSAoHLs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583630; c=relaxed/simple;
	bh=dR+0jqaPSAvDKq4m66ryYYJfphedVhWR3WPfiQuhuhY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rxAiP4rR4+Kdqs7fbmC3TvSAyQv2dXIoLkXcsaxxzt+0JR9JGNODJCb+ctMKLugNhYuVnIdtEKjeOZ25lOTFgb/it3hleZ0gds5o88KaTyucxFS0eMXtq1RS3VwxC8GnEpE8LE9dyjuX/KXqJ3bR/teQSISdRlal6HXV0UhcIRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WdyAbnAQ; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WdyAbnAQ"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-47a0bebeacaso217537137.0
        for <kvmarm@lists.linux.dev>; Mon, 08 Apr 2024 06:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1712583627; x=1713188427; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0QDCH9D7ZF5XfRFehRJVjao3N0rIYbXQnhCHeVWzziI=;
        b=WdyAbnAQwWwL7wXZuKCvOLMSiLH1w2mv3utK2IT/7dtEH9enrgTpZnfhcP3Yo+ZZPV
         BbEwdWSZVy5Rvqzm+fo9waqbzlPOHXjM14ZeAzSG0Q7uSGhGSAshqcAx4DXKFQsMtrFv
         4247GiBwqc2v3H5+xl6J/N4lCedBaQj8Autn+kiOgV6I11ZXrsUwLKdgaHrJvTqUqqi8
         v5qMxkKr39nWSgiLW2bzUaLhZzO5yhjI+7mpP479fXtVbiptKm44TIyFQ4xNKyflAZIO
         8Deb8KWFcJNkfx0MFAODafmvXoBegQ3B3qfRBt2zCufVb7ojePXfhPJEf2GlYc6dvSlC
         t0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712583627; x=1713188427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0QDCH9D7ZF5XfRFehRJVjao3N0rIYbXQnhCHeVWzziI=;
        b=pOgWgsyUAubPy2gA82Sxu/5vIHVmA2jEEc5ASq/CKQDTYIYZZ7z9ppTdGs8eiS+jMD
         EfKkNn1oTf6ZPPL3gE/lm+QcBULqK8sUYh0NKddfJz2+TbO4XZ/h3XSGvijBmgRwmmL5
         5fPxS8NiDeVlbWXvScU8PJxJYHqMj8BYhii8OyHYcq0iK2vF310qCInyF5UdVZG5payy
         r8FIlyhHXH3bfShaFD1cxpzskZbSJ+KB2TBc5Oec5UDjob0voyE5O1uo3A+ZRyGc2NGU
         xyF5L3Y/4xJRHHxMTowXllhmSGvGAqPy9wcLoklh0uiBZvaeNmf04wwEZlJsSu2EOYis
         DR4w==
X-Gm-Message-State: AOJu0YzATvIsqjv4AE8bp8MDKOLAVENdRmu46iYkMN8YjeapLXK4Dt69
	HyJVzt33RwB5yinKmVBlEQVX2V9w9M3+nfeH6vc855itOvJfoOeqRhiTfzwDCDO0/kbUaVcE0jP
	fprVuGyyaGEt/thvjdg2K/NXXroVMriNVj2Ds
X-Google-Smtp-Source: AGHT+IGuiQPde1BK04FQsmHTiQmM3voBpiN8sJwZItXSR4FjWEV9Ux0NWTI4ULimj2dp59cAgBQADXu2kchjLRhCYnI=
X-Received: by 2002:a05:6102:3f4c:b0:479:d6fd:39e7 with SMTP id
 l12-20020a0561023f4c00b00479d6fd39e7mr8698833vsv.28.1712583626929; Mon, 08
 Apr 2024 06:40:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240327173531.1379685-1-tabba@google.com> <20240327173531.1379685-3-tabba@google.com>
 <865xwstiao.wl-maz@kernel.org>
In-Reply-To: <865xwstiao.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 8 Apr 2024 14:39:50 +0100
Message-ID: <CA+EHjTxUpUyrfqwOPpRBNRWuaWivceMdoUX_prZYdCo-0-yfnQ@mail.gmail.com>
Subject: Re: [PATCH v1 02/44] KVM: arm64: Use enum instead of helper for
 checking FP-state
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, will@kernel.org, qperret@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 8, 2024 at 8:39=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote:
>
> On Wed, 27 Mar 2024 17:34:49 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > Before the conversion of the various FP-state booleans into an
> > enum representing the state, this helper may have clarified
> > things. Since the introduction of the enum, the helper obfuscates
> > rather than clarifies. This also makes the code consistent with
> > other parts that check the FP-state.
> >
> > No functional change intended.
> >
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 6 ------
> >  arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
> >  arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
> >  3 files changed, 2 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/h=
yp/include/hyp/switch.h
> > index e3fcf8c4d5b4..1a6dfd035531 100644
> > --- a/arch/arm64/kvm/hyp/include/hyp/switch.h
> > +++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
> > @@ -39,12 +39,6 @@ struct kvm_exception_table_entry {
> >  extern struct kvm_exception_table_entry __start___kvm_ex_table;
> >  extern struct kvm_exception_table_entry __stop___kvm_ex_table;
> >
> > -/* Check whether the FP regs are owned by the guest */
> > -static inline bool guest_owns_fp_regs(struct kvm_vcpu *vcpu)
> > -{
> > -     return vcpu->arch.fp_state =3D=3D FP_STATE_GUEST_OWNED;
> > -}
> > -
> >  /* Save the 32-bit only FPSIMD system register state */
> >  static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
> >  {
> > diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe=
/switch.c
> > index c50f8459e4fc..2a0b0d6da7c7 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/nvhe/switch.c
> > @@ -53,7 +53,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >                       val |=3D CPTR_EL2_TSM;
> >       }
> >
> > -     if (!guest_owns_fp_regs(vcpu)) {
> > +     if (vcpu->arch.fp_state !=3D FP_STATE_GUEST_OWNED) {
> >               if (has_hvhe())
> >                       val &=3D ~(CPACR_EL1_FPEN_EL0EN | CPACR_EL1_FPEN_=
EL1EN |
> >                                CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1E=
N);
> > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/s=
witch.c
> > index 1581df6aec87..e9197f086137 100644
> > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > @@ -75,7 +75,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
> >
> >       val |=3D CPTR_EL2_TAM;
> >
> > -     if (guest_owns_fp_regs(vcpu)) {
> > +     if (vcpu->arch.fp_state =3D=3D FP_STATE_GUEST_OWNED) {
> >               if (vcpu_has_sve(vcpu))
> >                       val |=3D CPACR_EL1_ZEN_EL0EN | CPACR_EL1_ZEN_EL1E=
N;
> >       } else {
>
> I'm not sure this buys us much. If anything, it makes moving the data
> around more difficult (see [1]).
>
> Overall, asking whether the vcpu owns the FP state seems a natural
> question, and I would have expected this helper to be generalised
> instead of being dropped.
>
> Could you please elaborate on this?

It is more that this wasn't really being used much, and the reason
that this helper was created to begin with was that the state was
maintained between two booleans rather than an enum. With the enum,
doing a check wasn't that much harder.

That said, looking at [1], I see your point. Generalizing the helper
is likely to make other code more readable. I'll drop this patch on
the respin, and see if it's worth doing the generalization as you
suggest.

Thanks,
/fuad

> Thanks,
>
>         M.
>
> [1] https://lore.kernel.org/all/20240322170945.3292593-6-maz@kernel.org/
>
> --
> Without deviation from the norm, progress is not possible.
