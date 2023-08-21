Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB134320F
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 17:37:58 +0000 (UTC)
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2b9b5ee9c5aso57600871fa.1
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 10:37:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692639476; x=1693244276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7okh5cvhwnlmOxK+/Z3A9I3seXSXeBzNclCnymMRoEM=;
        b=JaDE8RAjX1+JUIrgBZ97U+V4RthvwRFPv6SgdZS3i1eNjzCrj/twl0v6E/EcvUqMUF
         us49XyDth0tI6Cgw5HbTMX8nXgMBNPoDU1T/zcIaGdJqOQaFuqfvaoJinqAbht7htShQ
         GWLcFTSR6amMsuC7E3innMSGeS7TYNF2kFdVCjlie8bcNf4947vqc0ufOm+mdujYiZrD
         jheq7sQa1LAxi2/XzTGvVGJ/DoTvjVMAOo7c5QDFFeLz2btUvhUCliQcwjAqCSnpVkpz
         U+r7ePnfuLL7sqSkPuV4rGUs+m9BAlNOXYQh5UCIxAGcVcZ4I4g544BAyqvyGHFNd9Vr
         62Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692639476; x=1693244276;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7okh5cvhwnlmOxK+/Z3A9I3seXSXeBzNclCnymMRoEM=;
        b=Ht2u5YZmvrs2X78YTeaS97heXqdpf9zjb69fyc4ftVNGF1ed1sU87b8gXjcq/6kUrc
         yyvz5fKUzlewx9zobL+pl11zq8gzVi7OSj598ZReCmGYhlyztmVOXrH3CbHwhvgpqE1I
         C2emLIJFodYhk/ZMoVhs6Qh2Foe5mKi0QC6GWW7EoH/BmwyMnXprzOiULOCuaB9pCVLy
         cVys2tjQ4SleF+I5a9EMIzWnE+AUxa2pqzH8gcUpgvVzKkaLRXq99FrqRq6iw5Tz7OLE
         GxUYuUQAHPL6BvEuyqljHQF6Ufy53e6oNDSfhD+NkwPy07XFWPYiwm1b/C11M6weJm0A
         8Pcg==
X-Gm-Message-State: AOJu0YzAo39R4GOE5j7v9JE8r3oc28JugwLxOUDWXjoVN9X7d7zv3N3P
	9yvH9azGzYFs5j97xiHdikAJpgRq6/drvMMR2OXjfg==
X-Google-Smtp-Source: AGHT+IEsySuciEjUJJT9kSv7k1wphPuG1Rrg8bBGkcdN3O/Ew8oRCE9wRTnB/Y0XqHDRZEsP5CKesfakYf6SLZe3+Bk=
X-Received: by 2002:a2e:b1c4:0:b0:2b9:3883:a765 with SMTP id
 e4-20020a2eb1c4000000b002b93883a765mr5492471lja.31.1692639476432; Mon, 21 Aug
 2023 10:37:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230807162210.2528230-1-jingzhangos@google.com>
 <20230807162210.2528230-6-jingzhangos@google.com> <86r0o1fzdm.wl-maz@kernel.org>
In-Reply-To: <86r0o1fzdm.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Mon, 21 Aug 2023 10:37:44 -0700
Message-ID: <CAAdAUtjN3AYT2ARip20Xjom-V01WA2S_Y78WCfng2LHrRy08Rw@mail.gmail.com>
Subject: Re: [PATCH v8 05/11] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>, 
	Cornelia Huck <cohuck@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Thu, Aug 17, 2023 at 8:43=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 07 Aug 2023 17:22:03 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from usrespace with this change.
>
> nit: userspace
>

Fixed.

> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index afade7186675..5f6c2be12e44 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2006,7 +2006,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(63, 0), },
>
> For obvious reasons, this cannot be a 64 bit mask...
>
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2055,7 +2055,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D GENMASK(63, 0), },
>
> What is the actual justification to go from "only the PMU version is
> writable" to "everything is writable"?
>
> Also, what about the RES0 fields?

You're right. We should not mark RES0 fields and those fields KVM hide
from userspace as writable.
So, I think all the other fields can be writable?

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
