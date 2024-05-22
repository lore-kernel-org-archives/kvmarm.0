Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C2BA17FE
	for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716385740; cv=none; b=jOQvcTgqyXkLrGiInD4i1qQqXmytZ+lNLHpdiy2CggkAKgPxoQOHADHFmZcQiGAXJAG1x6JFlc5sT6rVEQEl+O24uUyKm3SXD0JH+HK0NiEWjG4FwlwxdA2ZAVd1Pss6OjiYBaqYL4zI3RCFCNUmVOYm+gpsu0zzIgC7va8Rshs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716385740; c=relaxed/simple;
	bh=wwGgluyrfeK2bhcGtpXyEq5CTVIGrtzAwcpgKyZ2GRw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M9904IIYf80RTiHnLzKmEmjfOLupbtRL+9i604Yzppfz3O54CUMCV3l+DQLewpWRh7nL/6dLo38zMYmMJZ+W6BTvAiBT+rY7+NAt+vO1nNjeMfV2ng40lbXtcNjZ2ILsS7LKZM+sB+Fv0Vho2RfhbJaq4vPBg81n93p39I/cd64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NqaU9Jpu; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NqaU9Jpu"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7f74cca5a2bso274777241.3
        for <kvmarm@lists.linux.dev>; Wed, 22 May 2024 06:48:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1716385737; x=1716990537; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+wc1/rMP5F1WUYkuy4cEyG99+xs+lalgAVwKCQhPby8=;
        b=NqaU9Jpu2DW3oXncGZiIQr3Zrp2SDQTJXMB51SAkgI9SjimTBoikshyKv/+PGDnLH9
         t8sTiJv/fIajSaC9wo6rz5rmXuHJoLwa3mKPBWPDDSqD5gD6Hh8ifGOirHfvIo46xVs3
         MVcoiuUscFasHH649e/CBMMrVfwS3hMN09/0YPSYjbzycAFf5ySt9gPQybDO5X0zvFWA
         qf2MTb2KReFc2etY3mQm2+sDXLa2+bEJsnp2My8eP0BFfTRF7WIAv5nGt9lJEcNViIbG
         yKkfex8OFcYQ/3BFgwCm+bUzlLed8EOMi04RSJW4p0CcI1BNzW0UY87wVp+M0NL8p9+B
         KDeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716385737; x=1716990537;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+wc1/rMP5F1WUYkuy4cEyG99+xs+lalgAVwKCQhPby8=;
        b=DqFLQFLfkz6ArZX6cMYTA/2fKi7HxXJ/twbFJ2PxFYyi1BM1jQrT9lBIWM5yo0GldQ
         zQembbj7V362sLXEFFbMT0XtEOQF1AYDbGskmKjjNqUboOh5AY9ersRTqcj5oN2gFnYs
         FDHO5qXicqb5eMflLUKWKDbkDFP3vrVuWYcuEo3/SAHcpiCUsY3wYLNDcxyYYZDYejfu
         444+uaZuZOhIKTPmnQy4NMGyDV+Mh+J2wZJ2sjvd9l09zBIKIWXlg3GhQ0TEDEEUqHCX
         yos/FnyS+Mndri0wT7k8520N/9SHMflUYt0MFlUQrQFj2egPlEcsy1yPjGyrtiul3gyx
         K4Fw==
X-Gm-Message-State: AOJu0Yz+1yH8WRK7Uam73+aFzKwdbQF7lIqtQUedjhm7BAWxoBb4uPu8
	smiSJolzDNYWs+yqmeCPgs2QPVfRxPwaVRUtU42SYTBiyH3a40GC9V+5z53GRiSpxnoc88QCSB/
	sw2YE+pQEpNKAfVCIjIRrZCB7KsiqXqvoX/en
X-Google-Smtp-Source: AGHT+IHqT9UJCxmfe7J5ZWY5ZYMvudamAICU1bPJe85OLiowfAB4Bfh68kmyb8NRkZywxbpTZ28LQ8V5Y7OXO5bYi5k=
X-Received: by 2002:a05:6102:3f0f:b0:47e:f1f1:d052 with SMTP id
 ada2fe7eead31-4890a2c6ab7mr2124810137.33.1716385737074; Wed, 22 May 2024
 06:48:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240521163720.3812851-1-tabba@google.com> <20240521163720.3812851-3-tabba@google.com>
 <86seyana8x.wl-maz@kernel.org>
In-Reply-To: <86seyana8x.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Wed, 22 May 2024 14:48:19 +0100
Message-ID: <CA+EHjTxyhytsiN93kJ46Hi-OVa1Z4qsH6_RAbm-WKVeDfZ5w8g@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: arm64: Abstract set/clear of CPTR_EL2 bits
 behind helper
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, 
	will@kernel.org, qperret@google.com, seanjc@google.com, 
	alexandru.elisei@arm.com, catalin.marinas@arm.com, philmd@linaro.org, 
	james.morse@arm.com, suzuki.poulose@arm.com, oliver.upton@linux.dev, 
	mark.rutland@arm.com, broonie@kernel.org, joey.gouly@arm.com, 
	rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, May 21, 2024 at 10:08=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Tue, 21 May 2024 17:37:15 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The same traps controlled by CPTR_EL2 or CPACR_EL1 need to be
> > toggled in different parts of the code, but the exact bits and
> > their polarity differ between these two formats and the mode
> > (vhe/nvhe/hvhe).
> >
> > To reduce the amount of duplicated code and the chance of getting
> > the wrong bit/polarity or missing a field, abstract the set/clear
> > of CPTR_EL2 bits behind a helper.
> >
> > Since (h)VHE is the way of the future, use the CPACR_EL1 format,
> > which is a subset of the VHE CPTR_EL2, as a reference.
> >
> > No functional change intended.
> >
> > Suggested-by: Oliver Upton <oliver.upton@linux.dev>
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_emulate.h    | 34 +++++++++++++++++++++++++
> >  arch/arm64/kvm/hyp/include/hyp/switch.h | 17 +++----------
> >  arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  6 +----
> >  3 files changed, 39 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/=
asm/kvm_emulate.h
> > index 501e3e019c93..74837d1762e5 100644
> > --- a/arch/arm64/include/asm/kvm_emulate.h
> > +++ b/arch/arm64/include/asm/kvm_emulate.h
> > @@ -557,6 +557,40 @@ static __always_inline void kvm_incr_pc(struct kvm=
_vcpu *vcpu)
> >               vcpu_set_flag((v), e);                                  \
> >       } while (0)
> >
> > +
> > +static inline void __cptr_clear_set_nvhe(u64 cpacr_clr, u64 cpacr_set)
> > +{
> > +     u64 clr =3D 0, set =3D 0;
> > +
> > +     if (cpacr_clr & CPACR_ELx_FPEN)
> > +             set |=3D CPTR_EL2_TFP;
> > +     if (cpacr_clr & CPACR_ELx_ZEN)
> > +             set |=3D CPTR_EL2_TZ;
> > +     if (cpacr_clr & CPACR_ELx_SMEN)
>
> These 3 fields are actually pairs of bits. Can we have a compile-time
> check that both bits are set?

Yes.

> > +             set |=3D CPTR_EL2_TSM;
> > +     if (cpacr_clr & CPACR_ELx_TTA)
> > +             clr |=3D CPTR_EL2_TTA;
>
> How about TCPAC, TAM, and E0POE?

CPTR_EL2 (nvhe) doesn't have an equivalent to E0POE. Should I have a
compile time check that it's not cleared at all (since it has negative
polarity), or a runtime check for that only for nvhe?

As for TCPAC, TAM, they're not defined under the CPACR bits, but they
are in CPTR_EL2, which is what CPACR refers to in VHE. I will handle
them, but should I rename cpacr_to_cptr() to cptr_vhe_to_nvhe()?

>
> > +
> > +     if (cpacr_set & CPACR_ELx_FPEN)
> > +             clr |=3D CPTR_EL2_TFP;
> > +     if (cpacr_set & CPACR_ELx_ZEN)
> > +             clr |=3D CPTR_EL2_TZ;
> > +     if (cpacr_set & CPACR_ELx_SMEN)
> > +             clr |=3D CPTR_EL2_TSM;
> > +     if (cpacr_set & CPACR_ELx_TTA)
> > +             set |=3D CPTR_EL2_TTA;
>
> The duplication is pretty unfortunate. Having a single helper that
> translate a register layout into another would be better.
> > +
> > +     sysreg_clear_set(cptr_el2, clr, set);
>
> And omit this...
>
> > +}
> > +
> > +static inline void cpacr_clear_set(u64 clr, u64 set)
> > +{
> > +        if (has_vhe() || has_hvhe())
> > +                sysreg_clear_set(cpacr_el1, clr, set);
> > +        else
> > +                __cptr_clear_set_nvhe(clr, set);
>
> So that this could read as:
>
>         sysreg_clear_set(cptr_el2, cpacr_to_cptr(clr), cpacr_to_cptr(set)=
);

I don't know how this could work with only one function/macro, while
covering all the fields. The problem is that the polarity of these
bits vary: some have the same polarity between CPACR/CPTR. and others
have the opposite polarity. Therefore, the conversion to `clr` is
different from the conversion to `set`.

Say we need to clear both CPACR_ELx_FPEN and CPACR_ELx_TTA. The
problem is that CPACR_ELx_FPEN has the opposite polarity as
CPTR_EL2_TFP, whereas CPACR_ELx_TTA has the same polarity as
CPTR_EL2_TTA (different position though).

What would cpacr_to_cptr() return that would work in the code you propose:
sysreg_clear_set(cptr_el2,
cpacr_to_cptr(CPACR_ELx_FPEN|CPACR_ELx_TTA), cpacr_to_cptr(0));

Desired result:
sysreg_clear_set(cptr_el2, CPTR_EL2_TTA, CPTR_EL2_TFP);

I can make it work with two functions/macros:
__cpacr_to_cptr_clear(clr, set) and __cpacr_to_cptr_set(clr, set) -->
sysreg_clear_set(cptr_el2, __cpacr_to_cptr_clear(clr, set),
__cpacr_to_cptr_set(clr, set));

Unfortunately this doesn't get rid of the duplication, but it might be
tidier (I converted them to macros to add compile-time checks later):

+#define __cpacr_to_cptr_clr(clr, set)                                  \
+       ({                                                              \
+               u64 cptr =3D 0;                                           \
+                                                                       \
+               if ((set) & CPACR_ELx_FPEN)                             \
+                       cptr |=3D CPTR_EL2_TFP;                           \
+               if ((set) & CPACR_ELx_ZEN)                              \
+                       cptr |=3D CPTR_EL2_TZ;                            \
+               if ((set) & CPACR_ELx_SMEN)                             \
+                       cptr |=3D CPTR_EL2_TSM;                           \
+               if ((clr) & CPACR_ELx_TTA)                              \
+                       cptr |=3D CPTR_EL2_TTA;                           \
+               if ((clr) & CPTR_EL2_TAM)                               \
+                       cptr |=3D CPTR_EL2_TAM;                           \
+               if ((clr) & CPTR_EL2_TCPAC)                             \
+                       cptr |=3D CPTR_EL2_TCPAC;                         \
+                                                                       \
+               cptr;                                                   \
+       })
+
+#define __cpacr_to_cptr_set(clr, set)                                  \
+       ({                                                              \
+               u64 cptr =3D 0;                                           \
+                                                                       \
+               if ((clr) & CPACR_ELx_FPEN)                             \
+                       cptr |=3D CPTR_EL2_TFP;                           \
+               if ((clr) & CPACR_ELx_ZEN)                              \
+                       cptr |=3D CPTR_EL2_TZ;                            \
+               if ((clr) & CPACR_ELx_SMEN)                             \
+                       cptr |=3D CPTR_EL2_TSM;                           \
+               if ((set) & CPACR_ELx_TTA)                              \
+                       cptr |=3D CPTR_EL2_TTA;                           \
+               if ((set) & CPTR_EL2_TAM)                               \
+                       cptr |=3D CPTR_EL2_TAM;                           \
+               if ((set) & CPTR_EL2_TCPAC)                             \
+                       cptr |=3D CPTR_EL2_TCPAC;                         \
+                                                                       \
+               cptr;                                                   \
+       })
+
+#define cpacr_clear_set(clr, set)                                      \
+       do {                                                            \
+               if (has_vhe() || has_hvhe())                            \
+                       sysreg_clear_set(cpacr_el1, clr, set);          \
+               else                                                    \
+                       sysreg_clear_set(cptr_el2,                      \
+                                        __cpacr_to_cptr_clr(clr, set), \
+                                        __cpacr_to_cptr_set(clr, set));\
+       } while (0)

What do you think?

Cheers,
/fuad






> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
