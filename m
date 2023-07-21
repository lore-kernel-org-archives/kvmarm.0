Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70331FB50
	for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 18:22:48 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-1b0419f758eso2115021fac.1
        for <kvmarm@lists.linux.dev>; Fri, 21 Jul 2023 11:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689963767; x=1690568567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GJ3WNMzLrH847WePOva6Ob7uoTuoZOqbP4jfDIKnBNo=;
        b=Axyb8i3BoLDCioPNaValzlc4F95GmtIvv/QzFfKtEaT8Oet/GPXsKU3ol17Ve3JjvR
         b7mBigDyE5Z06LbESk0w0px1PeEdtlQvCH/RpOZO80kswy6EravEvfyIbTBsmex7e/WW
         Vnb0bDTWntzaiY/LPkyMVNUp8Tnwak37BmLVP3mhsGPTPFZf/gCMOXThAnHLeLZpFShp
         /kgI2LfvuWyLjfatpXAR5RLTyIOzyxB6FjBv3GWkUqNh0N1ogvtoaXjSNSNrov5Aw7cQ
         zbOU+kx1c//oTp2WVZHzNwXUqsU5CtF++08wH7oXVKvLlcH/lrmHRUw2ThS30Y4GXpDM
         rNCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689963767; x=1690568567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GJ3WNMzLrH847WePOva6Ob7uoTuoZOqbP4jfDIKnBNo=;
        b=NL8VzgDz24TcMdv7Pm471D5bfFi/wgQSLaCg1EQCTlg8vwqCfr87GsWBeSRdxFfb9G
         UfIm0eGv3FbtrGOLmarwH8bf1k6Qht6EvUvdOqw1DpXK570bIMqGGwdhViPQXSgibOAU
         nx7QCX6PCVFDaYD6U7Y/v0ce93SuXoCkNWTe3d3k/DAslPxvKgpyCDjJ5nobqBis9jsM
         F2pKoj9z0BJCofjJLfxZvK3pyX4t7AHE5Y7nOUOkoqoueHcGi3sVOIBcbEkbOhIlU1FD
         R9gY2hog12zjtKAOASIFKW8B3QDQ+/x/pTLeq3UmiEaA5pTY/iN/6lSt2tpHFCBxEBYy
         ffyg==
X-Gm-Message-State: ABy/qLbWUKslpBVBrSw+Zwc10h0IHJP/dvbdD4LLzSNQTHUndnb4wkSY
	+gg8fx5UJ+9Ho+bskatnDPAdx3bbxHmqEAzT4dgHdA==
X-Google-Smtp-Source: APBJJlFNh59UipwB5jtZw+TGd/KGYtH0j+/tgS4WX0BkXzUFISZi6Lqv/qt04P5hXCtyxmErQlYNBij0Wpg2bpcnXbU=
X-Received: by 2002:a05:6870:e2c9:b0:1b0:49a7:c283 with SMTP id
 w9-20020a056870e2c900b001b049a7c283mr2035076oad.29.1689963767502; Fri, 21 Jul
 2023 11:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com> <87o7k77yn5.fsf@redhat.com>
 <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
 <87sf9h8xs0.fsf@redhat.com> <86r0p1txun.wl-maz@kernel.org>
In-Reply-To: <86r0p1txun.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Fri, 21 Jul 2023 11:22:35 -0700
Message-ID: <CAAdAUtjNW6Q+phGbc6jXWTERRhYo7E3H4Ws0iDSngc17Sac0uA@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: Cornelia Huck <cohuck@redhat.com>, KVM <kvm@vger.kernel.org>, 
	KVMARM <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Fri, Jul 21, 2023 at 2:31=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 21 Jul 2023 09:38:23 +0100,
> Cornelia Huck <cohuck@redhat.com> wrote:
> >
> > On Thu, Jul 20 2023, Jing Zhang <jingzhangos@google.com> wrote:
> >
> > > Hi Cornelia,
> > >
> > > On Thu, Jul 20, 2023 at 1:52=E2=80=AFAM Cornelia Huck <cohuck@redhat.=
com> wrote:
> > >>
> > >> On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:
> > >>
> > >> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > >> > from usrespace with this change.
> > >>
> > >> Typo: s/usrespace/userspace/
> > > Thanks.
> > >>
> > >> >
> > >> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > >> > ---
> > >> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> > >> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >> >
> > >> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > >> > index 053d8057ff1e..f33aec83f1b4 100644
> > >> > --- a/arch/arm64/kvm/sys_regs.c
> > >> > +++ b/arch/arm64/kvm/sys_regs.c
> > >> > @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_des=
cs[] =3D {
> > >> >         .set_user =3D set_id_dfr0_el1,
> > >> >         .visibility =3D aa32_id_visibility,
> > >> >         .reset =3D read_sanitised_id_dfr0_el1,
> > >> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > >> > +       .val =3D GENMASK(63, 0), },
> > >> >       ID_HIDDEN(ID_AFR0_EL1),
> > >> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> > >> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > >> > @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_des=
cs[] =3D {
> > >> >         .get_user =3D get_id_reg,
> > >> >         .set_user =3D set_id_aa64dfr0_el1,
> > >> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > >> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > >> > +       .val =3D GENMASK(63, 0), },
> > >> >       ID_SANITISED(ID_AA64DFR1_EL1),
> > >> >       ID_UNALLOCATED(5,2),
> > >> >       ID_UNALLOCATED(5,3),
> > >>
> > >> How does userspace find out whether a given id reg is actually writa=
ble,
> > >> other than trying to write to it?
> > >>
> > > No mechanism was provided to userspace to discover if a given idreg o=
r
> > > any fields of a given idreg is writable. The write to a readonly idre=
g
> > > can also succeed (write ignored) without any error if what's written
> > > is exactly the same as what the idreg holds or if it is a write to
> > > AArch32 idregs on an AArch64-only system.
> >
> > Hm, I'm not sure that's a good thing for the cases where we want to
> > support mix-and-match userspace and kernels. Userspace may want to know
> > upfront whether it can actually tweak the contents of an idreg or not
> > (for example, in the context of using CPU models for compatibility), so
> > that it can reject or warn about certain configurations that may not
> > turn out as the user expects.
> >
> > > Not sure if it is worth adding an API to return the writable mask for
> > > idregs, since we want to enable the writable for all allocated
> > > unhidden idregs eventually.
> >
> > We'd enable any new idregs for writing from the start in the future, I
> > guess?
> >
> > I see two approaches here:
> > - add an API to get a list of idregs with their writable masks
> > - add a capability "you can write to all idregs whatever you'd expect t=
o
> >   be able to write there architecture wise", which would require to add
> >   support for all idregs prior to exposing that cap
> >
> > The second option would be the easier one (if we don't manage to break
> > it in the future :)
>
> I'm not sure the last option is even possible. The architecture keeps
> allocating new ID registers in the op0=3D=3D3, op1=3D=3D{0, 1, 3}, CRn=3D=
=3D0,
> CRm=3D=3D{0-7}, op2=3D=3D{0-7} space, so fields that were RES0 until then
> start having a non-0 value.
For now, the per VM ID emulated ID registers support only covers space
for op0=3D=3D3, op1=3D=3D0, CRn=3D=3D0, CRm=3D=3D{1-7}, op2=3D=3D{0-8}. For=
 others, mask
value of 0 would be returned in the new ioctl.
>
> This could lead to a situation where you move from a system that
> didn't know about ID_AA64MMFR6_EL1.XYZ to a system that advertises it,
> and for which the XYZ instruction has another behaviour. Bad things
> follow.
>
> My preference would be a single ioctl that returns the full list of
> writeable masks in the ID reg range. It is big, but not crazy big
> (1536 bytes, if I haven't messed up), and includes the non ID_*_EL1
> sysreg such as MPIDR_EL1, CTR_EL1, SMIDR_EL1.
Just want to double confirm that would the ioclt return the list of
only writable masks, not the list of {idreg_name, mask} pair? So, the
VMM will need to index idreg's writable mask by op1, CRm, op2?
>
> It would allow the VMM to actively write zeroes to any writable ID
> register it doesn't know about, or for which it doesn't have anything
> to restore. It is also relatively future proof, as it covers
> *everything* the architecture has provisioned for the future (by the
> time that space is exhausted, I hope none of us will still be involved
> with this crap).
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
>
Thanks,
Jing
