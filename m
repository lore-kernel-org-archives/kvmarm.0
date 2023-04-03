Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3FDD33CF
	for <kvmarm@lists.linux.dev>; Mon,  3 Apr 2023 16:41:51 +0000 (UTC)
Received: by mail-lj1-f177.google.com with SMTP id a11so30998587lji.6
        for <kvmarm@lists.linux.dev>; Mon, 03 Apr 2023 09:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680540110; x=1683132110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WCavi4N7lQtSmbtPR96GmRyN9oGbU1CWSEaMmAfYOFk=;
        b=Bpxsj/EPXJBSk2pJrNpb/ecme2vHTk7FVSwNGGlI3X1rD91BpBZ7aRRHedK+XCxEWN
         FIBr2oLJlZjw2GKplq1GAOyrA2oH6mnKJxn9080mQqpzV4lRKhnKuBsOnlVLxenIB081
         +QnW2iM3CDQKGXJal38WhqiSiS+DTJBl0IOTVcfSUu5OA6IxmOx+dJHF0x+6as5lpNyC
         53Qpxj+Kq5dhPHNLs3bIUrbAZwf6vupR639KsVy2GPOgV+RTU2EDFQQE3/KdbrXHIV01
         856rm+Hho98ZpmutKOocKU18aTma0norDH/OKKgpOuVwj76uiIzBCg5b6PR+zZ6AeiyT
         yZaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680540110; x=1683132110;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WCavi4N7lQtSmbtPR96GmRyN9oGbU1CWSEaMmAfYOFk=;
        b=twvWRfuBVa6/56ctwTzGMhTJI6jEFwkOJxg45vMWKVC/OZopAq9mdppeulmkok+qhW
         tE8n1LeE3PFYBR4cEwMoUPbaTH942mt6pu1K0hlIPejE/9EfzVQXQjzH3gHexWAKhepZ
         eumOyVtXxS51eDFZ+1WvawGrDo+mzxGZMz5poBjF7hmxHQsqOGw85X7WoptuUO8nTZit
         z9v1Wyn4I83d5odivzVM5HqdoAJUlM1hLCZ4fDKZI3DqhbmFOZolWGPsXZLHW/un/vuY
         vlqamLOP90YYljCutDVJBgraVtd4GumRq0Qsu542cbR4uB8UhMFzBZJy/dMeiNxCiaOB
         fVQw==
X-Gm-Message-State: AAQBX9fqauK4B4g/4kQ3/FGP7PqyXcIWvyXV9EYiYATuB+Nfn/enJSyY
	0ig2Vjg9jp3PfF9ZO1neND6rM+vTeYgQCPJCtNPz8Q==
X-Google-Smtp-Source: AKy350aqaEfeMAyYsRokqUl0n0ZD1kFQJWJ+xAmyXbSZ5tqzcBrwqcjaPvQMcsmEpEWht0IpGdkJKw8RgguAzVjM2mA=
X-Received: by 2002:a2e:7312:0:b0:29a:a76a:194b with SMTP id
 o18-20020a2e7312000000b0029aa76a194bmr52187ljc.3.1680540109749; Mon, 03 Apr
 2023 09:41:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403132953.2069621-1-tabba@google.com> <86wn2tulav.wl-maz@kernel.org>
In-Reply-To: <86wn2tulav.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Mon, 3 Apr 2023 17:41:13 +0100
Message-ID: <CA+EHjTw_saZf_nMfaRHG+Bonc3KiFLEXNwJdaY=b-fWwe1V2dg@mail.gmail.com>
Subject: Re: [PATCH v4] KVM: arm64: Advertise ID_AA64PFR0_EL1.CSV2/3 to
 protected VMs
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, oupton@google.com, 
	will@kernel.org, pbonzini@redhat.com, james.morse@arm.com, 
	alexandru.elisei@arm.com, suzuki.poulose@arm.com, reijiw@google.com, 
	ricarkol@google.com, rananta@google.com, jingzhangos@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Apr 3, 2023 at 2:50=E2=80=AFPM Marc Zyngier <maz@kernel.org> wrote:
>
> On Mon, 03 Apr 2023 14:29:53 +0100,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > The existing pKVM code attempts to advertise CSV2/3 using values
> > initialized to 0, but never set. To advertise CSV2/3 to protected
> > guests, pass the CSV2/3 values to hyp when initializing hyp's
> > view of guests' ID_AA64PFR0_EL1.
> >
> > Similar to non-protected KVM, these are system-wide, rather than
> > per cpu, for simplicity.
> >
> > Fixes: 6c30bfb18d0b ("KVM: arm64: Add handlers for protected VM System =
Registers")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> >
> > ---
> >
> > Based on: 197b6b60ae7b (6.3-rc4)
> > Changes from V3: Fix masking to constrain CSV2/3 to 1 (Oliver).
> >
> >  arch/arm64/kvm/arm.c                          | 25 ++++++++++++++++++-
> >  .../arm64/kvm/hyp/include/nvhe/fixed_config.h |  5 +++-
> >  arch/arm64/kvm/hyp/nvhe/sys_regs.c            |  7 ------
> >  3 files changed, 28 insertions(+), 9 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 3bd732eaf087..04401c2851f8 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -1889,9 +1889,32 @@ static int __init do_pkvm_init(u32 hyp_va_bits)
> >       return ret;
> >  }
> >
> > +static u64 get_hyp_id_aa64pfr0_el1(void)
> > +{
> > +     u64 mask =3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > +                  ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > +
> > +     /*
> > +      * Track whether the system isn't affected by spectre/meltown in =
the
> > +      * hypervisor's view of id_aa64pfr0_el1, used for protected VMs.
> > +      * Although this is per-CPU, we make it global for simplicity, e.=
g., not
> > +      * to have to worry about vcpu migration.
> > +      *
> > +      * Unlike for non-protected VMs, userspace cannot override this f=
or
> > +      * protected VMs.
> > +      */
> > +     mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
> > +                        arm64_get_spectre_v2_state() =3D=3D SPECTRE_UN=
AFFECTED);
> > +
> > +     mask |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
> > +                        arm64_get_meltdown_state() =3D=3D SPECTRE_UNAF=
FECTED);
> > +
> > +     return read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1) & mask;
>
> I'm confused. PFR0.CSV2 is only set if the HW advertises it. But KVM
> should advertises it to guests if arm64_get_spectre_v2_state() reports
> "UNAFFECTED".
>
> In that later case, "read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1) &
> mask" will always leave CSV2 to 0. Same thing for CSV3.
>
> I'd expect something like:
>
>         u64 val =3D read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>
>         val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
>                  ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
>         val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2),
>                           arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNA=
FFECTED);
>         val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3),
>                           arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFF=
ECTED);
>
>         return val;
>
> Or did I read that completely wrong?

No, I missed the case where the hardware isn't unaffected and doesn't
advertise these bits. Your suggestion covers that and ensures that
pKVM behaves the same as non-protected KVM. I'll fix this and resend.

Thanks again!

/fuad

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
