Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B08D111D
	for <kvmarm@lists.linux.dev>; Sun, 27 Aug 2023 19:32:13 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-4ff882397ecso3792668e87.3
        for <kvmarm@lists.linux.dev>; Sun, 27 Aug 2023 12:32:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693164731; x=1693769531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z/MBlS5jJ6jjoZlLcPQIEqYt3hZ2JHvlatx9SMUr0Ps=;
        b=J2OSsLR1nwmfWDm2tmxvo5xPT7PeLWCNEEYKdEyt7NLpZhzFXgjC/0TWbzJLkdd+dA
         kaHq0nRhKhExyscn2m2XDPBrh5I/GSMo+Tmq50grhNkDsQ2xzZAig7R/nqzDSulxtQoe
         5swtcoEHEnClRf2SmAotbK35z9drsUaxnLWs0UXNXBWVsfGGWAP0MtDZUuyze4bk15NF
         tpMfIVy7/3/4D93Wunqdr/lQWtPrVp/f5kZ31/1SAvLh8BFRR7Ha6ZAUYWhoVjcYf1Vg
         TYfyhdnPIiU1o/jveuIfQ/NLtNuqEbEwzHJT5wKDMRnTd3FUHmUst+tGhpXmykJ40we4
         iO3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693164731; x=1693769531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z/MBlS5jJ6jjoZlLcPQIEqYt3hZ2JHvlatx9SMUr0Ps=;
        b=cNfjWc/mPpwJ+plz8WsSptvuyZm0ECy5evueRdUM6Rt3s7ZNicPdWtYj99o5hVWQ4e
         sKrDApzd3AnJskcR2ZR51RzE6LHeWe3tupqonCcNIbp330uX762SBrSHHUMo75lik5Yi
         KYnOBtTAtTVjRzKvJR3lCFmoLHhlRdJGi1nT6QYOCCb0dH/MnD94cNfvAjDc0GFxc7lJ
         xcoBIvdi4iIUlL7yrlJby8gb2E6yY6Lwbz2r27kWC1plqC7qTNIWjcu21pt5PZMTXBMH
         uUc8YhyFb52S0u9th14Y3aHvAO0LpoKpPbHDrOO6uUjhaB95+3KwQcoiuzBpdnAg+kNg
         x8Wg==
X-Gm-Message-State: AOJu0YxC8T8GQo+4Dw31UFZulFFsQvK2DEpJ94SKl5glkhcXPFCohn9c
	NOugkxAKdwaVLbgJy60gqHirTjZrlcmxideAYCXwvg==
X-Google-Smtp-Source: AGHT+IEk8IVz7X20eoWgRs8RfBcId72R1Gk0/oK298rH6tojKEkA0RmVaOhWFz7sv42H1xdb6aTjSM76rQJI1s/ODrs=
X-Received: by 2002:ac2:5e35:0:b0:500:94c3:8e3b with SMTP id
 o21-20020ac25e35000000b0050094c38e3bmr9043804lfg.57.1693164731128; Sun, 27
 Aug 2023 12:32:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
 <20230821212243.491660-6-jingzhangos@google.com> <878ra3pndw.wl-maz@kernel.org>
 <CAAdAUti8qSf0PVnWkp4Jua-te6i0cjQKJm=8dt5vWqT0Q6w4iQ@mail.gmail.com> <86a5uef55n.wl-maz@kernel.org>
In-Reply-To: <86a5uef55n.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Sun, 27 Aug 2023 12:31:59 -0700
Message-ID: <CAAdAUtiNeVrPxThddhFPNNWjyf1hebYkXugdfV2K8LNnT0yaQg@mail.gmail.com>
Subject: Re: [PATCH v9 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>, Shaoqin Huang <shahuang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sat, Aug 26, 2023 at 3:51=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 22 Aug 2023 19:35:12 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > Hi Marc,
> >
> > On Tue, Aug 22, 2023 at 12:06=E2=80=AFAM Marc Zyngier <maz@kernel.org> =
wrote:
> > >
> > > On Mon, 21 Aug 2023 22:22:37 +0100,
> > > Jing Zhang <jingzhangos@google.com> wrote:
> > > >
> > > > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > > > from userspace with this change.
> > > > RES0 fields and those fields hidden by KVM are not writable.
> > > >
> > > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > > ---
> > > >  arch/arm64/kvm/sys_regs.c | 6 ++++--
> > > >  1 file changed, 4 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > > > index afade7186675..20fc38bad4e8 100644
> > > > --- a/arch/arm64/kvm/sys_regs.c
> > > > +++ b/arch/arm64/kvm/sys_regs.c
> > > > @@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu=
,
> > > >       return true;
> > > >  }
> > > >
> > > > +#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 2=
4) | GENMASK(19, 16))
> > > > +
> > > >  /*
> > > >   * Architected system registers.
> > > >   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> > > > @@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_desc=
s[] =3D {
> > > >         .set_user =3D set_id_dfr0_el1,
> > > >         .visibility =3D aa32_id_visibility,
> > > >         .reset =3D read_sanitised_id_dfr0_el1,
> > > > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > > > +       .val =3D GENMASK(31, 0), },
> > >
> > > Can you *please* look at the register and realise that we *don't*
> > > support writing to the whole of the low 32 bits? What does it mean to
> > > allow selecting the M-profile debug? Or the memory-mapped trace?
> > >
> > > You are advertising a lot of crap to userspace, and that's definitely
> > > not on.
> > >
> > > >       ID_HIDDEN(ID_AFR0_EL1),
> > > >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > > >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > > > @@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_desc=
s[] =3D {
> > > >         .get_user =3D get_id_reg,
> > > >         .set_user =3D set_id_aa64dfr0_el1,
> > > >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > > > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > > > +       .val =3D ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RE=
S0_MASK), },
> > >
> > > And it is the same thing here. Where is the handling code to deal wit=
h
> > > variable breakpoint numbers? Oh wait, there is none. Really, the only
> > > thing we support writing to are the PMU and Debug versions. And
> > > nothing else.
> > >
> > > What does it mean for userspace? Either the write will be denied
> > > despite being advertised a writable field (remember the first patch o=
f
> > > the series???), or we'll blindly accept the write and further ignore
> > > the requested values. Do you really think any of this is acceptable?
> > >
> > > This is the *9th* version of this series, and we're still battling
> > > over some extremely basic userspace issues... I don't think we can
> > > merge this series as is stands.
> >
> > I removed sanity checks across multiple fields after the discussion
> > here: https://lore.kernel.org/all/ZKRC80hb4hXwW8WK@thinky-boi/
> > I might have misunderstood the discussion. I thought we'd let VMM do
> > more complete sanity checks.
>
> The problem is that you don't even have a statement about how this is
> supposed to be handled. What are the rules? How can the VMM author
> *know*?
>
> That's my real issue with this series: at no point do we state when an
> ID register can be written, what are the rules that must be followed,
> where is the split in responsibility between KVM and the VMM, and what
> is the expected behaviour when the VMM exposes something that is
> completely outlandish to the guest (such as the M-profile debug).
>
> Do you see the issue? We can always fix the code. But once we've
> exposed that to userspace, there is no going back. And I really want
> everybody's buy-in on that front, including the VMM people.

Understood.
Looks like it would be less complicated to have KVM do all the sanity
checks to determine if a feature field is configured correctly.
The determination can be done by following rules:
1. Architecture constraints from ARM ARM.
2. KVM constraints. (Those features not exposed by KVM should be read-only)
3. VCPU features. (The write mask needs to be determined on-the-fly)

Thanks,
Jing

>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
