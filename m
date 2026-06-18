Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1964F280A5A
	for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 14:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781793717; cv=pass; b=P6rRo2lo37pqJhNdGlT+i/xbleIq0wntvcccYzgHlZi9s39/c6IFHx0k4r/vLazDXJozcWT+VvpUU94t9flbMNKGJcrN5ggSPhC8RWaOrU/W03ivIAQqy7Mg0uqWRYLr0F9vRugSQOwJ1/mh47vY1hMvZxoKpsE8vIMQoSb6vPo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781793717; c=relaxed/simple;
	bh=6jAMPAUU7NxAHfo3CqmuOs+a1P+DBOmdpSJ3YXon3gE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JRq8PBK3b74lV5iFsp8zRtFsz5cIej37jI8aH5ExD9jU36NxDOft12zhUaA0sjWtNd63TjVYIGqPluIRDs5exrpZZZAmFtU/f09cNmCYVnlcIyeUOPvcWvFdAeyW0BSZkCsDLUkEKyZdO0srusa2a6jKZl4B0lqD0paPViksQSc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TL9lxz6e; arc=pass smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TL9lxz6e"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5ad4d840d43so7268e87.1
        for <kvmarm@lists.linux.dev>; Thu, 18 Jun 2026 07:41:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781793714; cv=none;
        d=google.com; s=arc-20260327;
        b=EnDPx/pkrusDD59H6GRwHdpmn18/kcdoLl8oX6FdoVHqpltzhg3Kvq8qBE4bVAA4Qy
         ika2HuYewu9U8QhQDk3Ns6L6Y+LambIr9aWedMjm8+f8ckz3dlIqkb48VtmRfXuK93l5
         eECXASP8NFvR/LEsqrWJ3DZUn9ZxI2JdUyeTOJ0cPcW+forcM7zw+fn62wJKMZxqJF7b
         qK+phH1E44IeVDjEaUN/jj3ITw1AAUbD+llrOzPX1h2VMNsAyoqrVx85hEDKMjgcFzog
         wW0hY9iiuQzzacsR/EFTr02f+p3Cg+ccf4eifc2KrZZz/vho31tGi2JxYcZGoNaxZdrV
         ILgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cyv7WmAzvj3n/08dSdKcTP0+sZKN+JUNiB8NClmfTJ8=;
        fh=4Xn3ig0HNZly+RyCQnyQpoa4N4eMsKR4/adFZfizPqs=;
        b=Hyl94TOj0mDQVTrCNkhS6BGb7alhnqYL2zJpEm2LUPKC5y4Kr7jT17835ZtrlgcVku
         5d4b0UuQmdtuJDfv9Ih3oUztYdxaTz9Iihg/jYgTqpZCQxgc7Xiru9enLXC8Xdyigdi+
         2hcEnK0xSTZC7bsxJUMNeIJGg+08V6uMMno11s1mF6HTkPyel5tx3Ku7CjCGlJEaqfTL
         tWJyWSF0ZgdCbZPGkYT6Em41Yc1SIjTnEROcisIqigVkSAVNoVNY4JAOsZXb9FD+HcVE
         vvvKLFJfYIe1+uIaa7/0T7Xwxrou17WGOzMDaBmK5Es7gt073JD9tc0leom3ZWZhFM6s
         APVw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781793714; x=1782398514; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cyv7WmAzvj3n/08dSdKcTP0+sZKN+JUNiB8NClmfTJ8=;
        b=TL9lxz6eLPxTxzLvqeTdvG0YejlLfimR8VsEGyPUQd9Fgnmm5roOa7e0fubnYlz9l/
         Vsresp70RgCwDVQgBVAufR7fGJyykTlQHlye+7xRwa+kgEkpQgHTnCamW6GPR4d5BRjZ
         usghkHaJjZ/4PxTS1co3Zxvt/y2VbJ0YZfgoWaSHvuE72D8jukpj7r4viP2Kq4gJ7onU
         TJhHDETcgZPUzwkXpl6nf73v6rrJrZh24YY7LnxrnFFHGnCxxap56iLuTedomfmawOcm
         EP9JJvDSRxuFLwix3wBqsqm7zqG1G1/XpRLKTyt5bkOniMwNYfWpk2FPrt11nVhUK7vO
         V/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781793714; x=1782398514;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cyv7WmAzvj3n/08dSdKcTP0+sZKN+JUNiB8NClmfTJ8=;
        b=QCTCconvtWgrW+c4xFLu2KvJWz0Wd1BcAHdhuQoImG3veCyFzrawH9ycqD4+Ai0fbP
         3WBl2gKcgkba9EZfyO1cqGhG7wBSNXHke8ul/sK2uoDVwhO0zS9O/8bdfLibba+qHr23
         3iL7ra76E/YkEoq7O9DO5mpnlWFES5Jm8qA+ubVgezuBvPn6YBNeeFLEsLr5aJEG/SfX
         hrrViidcLdxC3jkB2XV76VbKs4cE7UYPN1oS2pD8aUrRURVEMrM5xhs15L3V98oPABn+
         5O5sbUkt4tAcoii0VOfzkBpzUcelzkG65uJVc5rVSfj/vSaTklNZsN9B2f8Ul/FpCjdi
         T5nA==
X-Forwarded-Encrypted: i=1; AFNElJ9RIIo0sPFZFzMYmA4yogvYWU0fujMGY/z+3eBhmA7yfATx3SKzd62eJnsX62egFgbfm+6oMbo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwF8slugR8ObFgnDb/VnCmBDPmIaUX7DPLUgXxr2u+PctkX6DQP
	F0bU2Qb14fwljaOkEA5CHSBUAtzqUfo4hdyciek8L7oyeBYp+8FKY1VgoFQ3OkzpPIPif+QUMzz
	5Z4Luq8vW0OHzDriWSIGl7EMHpBVgFzukxUCPaQeq68KoWADYwY4ZEtLg
X-Gm-Gg: AfdE7cm9rIfKpYwxdEPYgXLAgEYIzkX7aOB+HP164dvkVNM+D27Q6dDvlDNqxJmm04i
	/rc7TO3GjpsFSL5beGj6snSyI5m0BUVTGWSn/RITuTJTScVc0IxFFr0vMiShTBKT9bRBrVZkojn
	PdOagqDN0gCT+9cFOPbh5MaWSA4P8qB3QvgIiph+/8tHEFM1crgJLFsnpQHAGw33I/kON83RhX6
	UYOl0dbhF3XEqoIslZNTeZ4lEafyAe7K8R/xDx3cyA8pF66dmTmtTRsW+OrAbGpiR2Dvt9qeg==
X-Received: by 2002:a05:6512:3193:b0:5aa:4c72:8732 with SMTP id
 2adb3069b0e04-5ad4db9bc41mr182457e87.10.1781793713788; Thu, 18 Jun 2026
 07:41:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260618121643.4105064-1-tabba@google.com> <20260618121643.4105064-3-tabba@google.com>
 <20260618123043.5D1C21F000E9@smtp.kernel.org>
In-Reply-To: <20260618123043.5D1C21F000E9@smtp.kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 18 Jun 2026 15:41:14 +0100
X-Gm-Features: AVVi8Cf0GaVcwzO4o9AsKmalolh1Ixou3PwA9WCiyR5ufBQEFXD4fRAnHT5wNkA
Message-ID: <CA+EHjTyiyCNV40z82=YTTMrx3BoR5gn5uh-xP80gFxX2PSUMAg@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Unconditionally set IL for injected
 undefined exceptions
To: sashiko-reviews@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev, 
	Oliver Upton <oupton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jun 2026 at 13:30, <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Nested SError exception injection silently drops the ESR_EL2 val=
ue.
> --
>
> commit e7d1337c1e8d6db55c7b9ce2682f4c52e85c3f44
> Author: Fuad Tabba <tabba@google.com>
>
> KVM: arm64: Unconditionally set IL for injected undefined exceptions
>
> This commit simplifies the inject_undef64() exception injection path by
> unconditionally setting the IL bit, as the architecture mandates IL=3D1 f=
or
> EC=3D0 (Unknown).
>
> > diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_faul=
t.c
> > index 89982bd3345f6..9dfae1bcdf992 100644
> > --- a/arch/arm64/kvm/inject_fault.c
> > +++ b/arch/arm64/kvm/inject_fault.c
> > @@ -170,14 +170,7 @@ void kvm_inject_sync(struct kvm_vcpu *vcpu, u64 es=
r)
> >
> >  static void inject_undef64(struct kvm_vcpu *vcpu)
> >  {
> > -     u64 esr =3D (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
> > -
> > -     /*
> > -      * Build an unknown exception, depending on the instruction
> > -      * set.
> > -      */
> > -     if (kvm_vcpu_trap_il_is32bit(vcpu))
> > -             esr |=3D ESR_ELx_IL;
> > +     u64 esr =3D (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT) | ESR_ELx_IL=
;
> >
> >       kvm_inject_sync(vcpu, esr);
> >  }
>
> [Severity: High]
> This isn't a bug introduced by this patch, but while reviewing the except=
ion
> injection changes, I noticed a pre-existing issue in the nested SError
> injection path.
>
> In arch/arm64/kvm/emulate-nested.c, kvm_inject_nested_serror() constructs
> the ESR for the nested SError and passes it down to kvm_inject_nested():
>
> arch/arm64/kvm/emulate-nested.c:kvm_inject_nested_serror() {
>         ...
>         esr |=3D FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_SERROR);
>         return kvm_inject_nested(vcpu, esr, except_type_serror);
> }
>
> However, when this esr reaches kvm_inject_el2_exception(), the value is
> silently discarded:
>
> arch/arm64/kvm/emulate-nested.c:kvm_inject_el2_exception() {
>         ...
>         switch (type) {
>         case except_type_sync:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SYNC);
>                 vcpu_write_sys_reg(vcpu, esr_el2, ESR_EL2);
>                 break;
>         case except_type_irq:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_IRQ);
>                 break;
>         case except_type_serror:
>                 kvm_pend_exception(vcpu, EXCEPT_AA64_EL2_SERR);
>                 break;
>         ...
> }
>
> Because the except_type_serror case breaks without writing esr_el2 to
> ESR_EL2 (unlike the except_type_sync case), the constructed syndrome is
> completely dropped.
>
> Since enter_exception64() does not dynamically update ESR_ELx, will the
> guest hypervisor observe a stale ESR_EL2 when handling the injected SErro=
r?
>
> Could this cause the guest to misinterpret the error, potentially leading
> to incorrect functional behavior or a guest panic?

IL=3D1 is correct here. The architecture mandates IL=3D1 for any
Instruction Abort unconditionally, and for any Data Abort where ISV=3D0
(ARM ARM, ESR_ELx IL bit definition). IL only reflects the faulting
instruction length when ISV=3D1.

This function never sets ISV. The FSC is always EXTABT or SEA_TTW, and
FEAT_RAS mandates ISV=3D0 for any synchronous external abort. The
Address Size Fault case (kvm_inject_size_fault overwriting FSC to 0)
also has ISV=3D0 since address size faults are detected during
translation table walks with no valid instruction syndrome.

The old code copying IL from the hardware trap ESR was the bug: it
produced IL=3D0 for a 16-bit Thumb instruction, which is wrong for an
ISV=3D0 data abort.

Cheers,
/fuad


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260618121643.41=
05064-1-tabba@google.com?part=3D2
