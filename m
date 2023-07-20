Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851632FA20
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 16:39:29 +0000 (UTC)
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-1b012c3ce43so765481fac.3
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 09:39:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689871168; x=1690475968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hbkr9MsN6GS2zP4ChfBB/zC7lOL9scc+qhxb4xXFEHY=;
        b=ZsFDGq8cH/dWXxvB9jnW7BB7gCWULwMCvXTzzuLeSz638a3+G9S2UqX/8cmrYcLzN0
         yvN+TMD76I2EYK0SX1EecmKJmCSn73KXdzTdxnZpEds3ttSrnvy/yeu62hWo01qPw8pq
         rxUf41TPQ7f0ZU98Dun0XYO9XulNM5WTTdq9SYdP0Bnl4izB0mNiHltWfH9F+2ASloM9
         dXgh0o8j6e8Nx0+gNnetSdWpBNiRagMqlHoqGcgcE3ykUzYsrj+9Z9Cip/cDdzgsuWoO
         yM1GYpZAHvwxUrEtih8bv+jp2JLPruSUnsHd12qWtMTjdaHr07WiGTOaq9DvlNfSqIYI
         dFKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689871168; x=1690475968;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hbkr9MsN6GS2zP4ChfBB/zC7lOL9scc+qhxb4xXFEHY=;
        b=QCkrM46F2ReUat5o6BPBVvpayTr33WYmfzOS3peOYd06Z9Rfqy/xguQTuVBRM81L5s
         dRt9wB97FACN640xkZ7W2+dEU0lFw6fA9Uq/NIed4/ntHAQ3rR1GMIXpLOfxm8YPl68v
         FQrNYMD/hMZCCb6INx+LwrxfiNMAtkGjVWbAUcVokuwOP4WuQ3O1gMNZtmJo/HTepitX
         JuFe9zV/sg7gtP+bwn+pNwc7pw6AFiMfvkz7EJRg7t8punVm+d4c+k3XdrtHvfkxlrC7
         15nWJOR3nYApxKojUjQAe3DhhhozuXAVB2jk2C6LiXJGbG2AayqJYF8TuExvZX9EYhuk
         8NtQ==
X-Gm-Message-State: ABy/qLaR1SZQ6lGir44BYxYymmSumm5IUm+XdtDsAMyxy6OM7zrMg+G8
	MdPirChBT6B1BPHRp74Ml7uMY4ZAJyM0BFQSc8JPYA==
X-Google-Smtp-Source: APBJJlFzGdOrTTow2+txRV2Vh5nCFjfKe7odZM806Rr1bFcCUvl0DLCd/EZzsZ/T53f5OmkGfZ+OZ09Q8fMBdMsSS0Q=
X-Received: by 2002:a05:6870:f68e:b0:1b0:649f:e68a with SMTP id
 el14-20020a056870f68e00b001b0649fe68amr24733oab.25.1689871168307; Thu, 20 Jul
 2023 09:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230718164522.3498236-1-jingzhangos@google.com>
 <20230718164522.3498236-4-jingzhangos@google.com> <87o7k77yn5.fsf@redhat.com>
In-Reply-To: <87o7k77yn5.fsf@redhat.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 20 Jul 2023 09:39:15 -0700
Message-ID: <CAAdAUthM6JJ0tEqWELcW48E235EbcjZQSDLF9OQUZ_kUtqh3Ng@mail.gmail.com>
Subject: Re: [PATCH v6 3/6] KVM: arm64: Enable writable for ID_AA64DFR0_EL1
 and ID_DFR0_EL1
To: Cornelia Huck <cohuck@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Will Deacon <will@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>, Suraj Jitindar Singh <surajjs@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Cornelia,

On Thu, Jul 20, 2023 at 1:52=E2=80=AFAM Cornelia Huck <cohuck@redhat.com> w=
rote:
>
> On Tue, Jul 18 2023, Jing Zhang <jingzhangos@google.com> wrote:
>
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from usrespace with this change.
>
> Typo: s/usrespace/userspace/
Thanks.
>
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 053d8057ff1e..f33aec83f1b4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -2008,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2057,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D GENMASK(63, 0), },
> >       ID_SANITISED(ID_AA64DFR1_EL1),
> >       ID_UNALLOCATED(5,2),
> >       ID_UNALLOCATED(5,3),
>
> How does userspace find out whether a given id reg is actually writable,
> other than trying to write to it?
>
No mechanism was provided to userspace to discover if a given idreg or
any fields of a given idreg is writable. The write to a readonly idreg
can also succeed (write ignored) without any error if what's written
is exactly the same as what the idreg holds or if it is a write to
AArch32 idregs on an AArch64-only system.
Not sure if it is worth adding an API to return the writable mask for
idregs, since we want to enable the writable for all allocated
unhidden idregs eventually.

Thanks,
Jing
