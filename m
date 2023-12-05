Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com [209.85.219.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA9E59B5F
	for <kvmarm@lists.linux.dev>; Tue,  5 Dec 2023 11:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QWv2Bl+k"
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-d9caf5cc948so3834398276.0
        for <kvmarm@lists.linux.dev>; Tue, 05 Dec 2023 03:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701776953; x=1702381753; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9RIXOTY8N1Sf+XTL65qiqMC1xJCtrrgjQeLQxSj1Ur8=;
        b=QWv2Bl+k1HFAaPPburlnieVILIEBu6w1Zs2BOwXiHHjXg/Dk9NQBzcmaD9rwzE03/s
         sv3Rh4LpwlTp4cO/OEsskKIE+nLCRrfayRlvyjW+UrXWwIog5/rwpyw6ZlqyfVJ7q9un
         mXJ0nf1OAlOhXRYlIR4HkWJk07K/RDjCw/Z4XG35S4YR0yrwtivgA/3qm5WjFnvdGJpN
         zn+AbviG6UqTr6VAWY5n7NlGo3t1ZOhMXo6MJObbOsngwxLRp8kfDQIFVyGKDzDpgI9v
         ySz2YUGzXVY85Jgj8Xav3+6NjkvHYj8OzoX7XU5KuAcRoDh0Pd2/sq9UPrGrxAfcG6Jj
         sRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701776953; x=1702381753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9RIXOTY8N1Sf+XTL65qiqMC1xJCtrrgjQeLQxSj1Ur8=;
        b=TtATx4zyeLakNIH7ckfKk35uq82wMvrs7rommr7czBx0NbUuq30+ETF7/McwhTqsu0
         242i7XCk6pzwH7ISonXnCBPhKk3NSgRfaU6Q69f3PddOf4CANlxjLjZYo/3dy5D6wvNU
         eyEnJSyeH/cBHRPPfkb3abQXYBr0p9PkZMiaq93C9oqcXTHRwiATsOYWy26L0AzSSjOo
         OP3M6FDMsqPZhxMbCUk4YjqU5j6n+tkwDn1zaXltbrFytuEdFmFMeTTDWkRu8P4wtQ00
         2kBnbGA+shmQyj/9z7k2YNuXMt4FEFy5MdzR6OCad5FC/Hn5sc95cYe2GpMU+lOeIMJG
         gQ6Q==
X-Gm-Message-State: AOJu0YwSvRLaZkXlmDRjENTqzHTi4T+B3YhLMMEsvHUEXnYYV0q0T00E
	ymK6rCtX2+q++V0WWma6I/8GPk91OpIUNIApFHXW3Q==
X-Google-Smtp-Source: AGHT+IHyAAfa5sVL3van3e3XPeN7/D5V8TQXYHwAqYxm7mt/gTCU60QNTsETWXFScWVvFbJ3k/MIEIO2IpntOOS53mE=
X-Received: by 2002:a05:6902:30b:b0:db9:82b6:5c39 with SMTP id
 b11-20020a056902030b00b00db982b65c39mr1113710ybs.45.1701776952601; Tue, 05
 Dec 2023 03:49:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205102248.1915895-1-tabba@google.com> <20231205102248.1915895-2-tabba@google.com>
 <86edg0c2w1.wl-maz@kernel.org>
In-Reply-To: <86edg0c2w1.wl-maz@kernel.org>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 5 Dec 2023 11:48:35 +0000
Message-ID: <CA+EHjTwEkmRCRJsBkwv9nYzcfBPdAApXoFQBVViM3uF2FbsEig@mail.gmail.com>
Subject: Re: [PATCH v1 1/6] KVM: arm64: Update and fix FGT register masks
To: Marc Zyngier <maz@kernel.org>
Cc: kvmarm@lists.linux.dev, oliver.upton@linux.dev, james.morse@arm.com, 
	suzuki.poulose@arm.com, yuzenghui@huawei.com, catalin.marinas@arm.com, 
	will@kernel.org, eric.auger@redhat.com, jingzhangos@google.com, 
	joey.gouly@arm.com, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Tue, Dec 5, 2023 at 11:20=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Tue, 05 Dec 2023 10:22:43 +0000,
> Fuad Tabba <tabba@google.com> wrote:
> >
> > New trap bits have been defined in the latest Arm Architecture
> > System Registers xml specification [*]. Moreover, the existing
> > definitions of some of the mask and the res0 bits overlap, which
>
> nit: s/res0/RES0/

Ack

> > could be wrong, confusing, or potentially both.
> >
> > Update the bits to represent the latest spec (as of this patch),
> > and ensure that the existing bits are consistent.
> >
> > [*] https://developer.arm.com/downloads/-/exploration-tools
>
> Please indicate which version of the XML you are referring to (it
> changes on average every 3 months).

Ack

> >
> > Fixes: 0fd76865006d ("KVM: arm64: Add nPIR{E0}_EL1 to HFG traps")
> > Signed-off-by: Fuad Tabba <tabba@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_arm.h | 39 ++++++++++++++++++++------------
> >  1 file changed, 24 insertions(+), 15 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/=
kvm_arm.h
> > index b85f46a73e21..b1061647e837 100644
> > --- a/arch/arm64/include/asm/kvm_arm.h
> > +++ b/arch/arm64/include/asm/kvm_arm.h
> > @@ -344,36 +344,45 @@
> >   * Once we get to a point where the two describe the same thing, we'll
> >   * merge the definitions. One day.
> >   */
> > -#define __HFGRTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51))
> > +#define __HFGRTR_EL2_RES0    BIT(51)
>
> If we are now using the current architectural definition for RES0, can
> we please move over to the generated values, as indicated in the above
> comment?

I'd missed the generated definitions. I thought that the comment was
referring to the read and write version of the registers. Will fix
that.

> >  #define __HFGRTR_EL2_MASK    GENMASK(49, 0)
> > -#define __HFGRTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(=
50))
> > +#define __HFGRTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
> >
> > -#define __HFGWTR_EL2_RES0    (GENMASK(63, 56) | GENMASK(53, 51) |    \
> > -                              BIT(46) | BIT(42) | BIT(40) | BIT(28) | =
\
> > -                              GENMASK(26, 25) | BIT(21) | BIT(18) |  \
> > +#define __HFGWTR_EL2_RES0    (BIT(51) | BIT(46) | BIT(42) | BIT(40) | =
\
> > +                              BIT(28) | GENMASK(26, 25) | BIT(21) | BI=
T(18) | \
> >                                GENMASK(15, 14) | GENMASK(10, 9) | BIT(2=
))
> > -#define __HFGWTR_EL2_MASK    GENMASK(49, 0)
> > -#define __HFGWTR_EL2_nMASK   (GENMASK(58, 57) | GENMASK(55, 54) | BIT(=
50))
> > +#define __HFGWTR_EL2_MASK    (GENMASK(49, 47) | GENMASK(45, 43) | \
> > +                              BIT(41) | GENMASK(39, 29) | BIT(27) | \
> > +                              GENMASK(24, 22) | GENMASK(20, 19) | \
> > +                              GENMASK(17, 16) | GENMASK(13, 11) | \
> > +                              GENMASK(8, 3) | GENMASK(1, 0))
> > +#define __HFGWTR_EL2_nMASK   (GENMASK(63, 52) | BIT(50))
> >
> > -#define __HFGITR_EL2_RES0    GENMASK(63, 57)
> > -#define __HFGITR_EL2_MASK    GENMASK(54, 0)
> > -#define __HFGITR_EL2_nMASK   GENMASK(56, 55)
> > +#define __HFGITR_EL2_RES0    (BIT(63) | BIT(61))
> > +#define __HFGITR_EL2_MASK    (BIT(62) | BIT(60) | GENMASK(54, 0))
> > +#define __HFGITR_EL2_nMASK   GENMASK(59, 55)
> >
> >  #define __HDFGRTR_EL2_RES0   (BIT(49) | BIT(42) | GENMASK(39, 38) |  \
> >                                GENMASK(21, 20) | BIT(8))
> > -#define __HDFGRTR_EL2_MASK   ~__HDFGRTR_EL2_nMASK
> > +#define __HDFGRTR_EL2_MASK   (BIT(63) | GENMASK(58, 50) | GENMASK(48, =
43) | \
> > +                              GENMASK(41, 40) | GENMASK(37, 22) | \
> > +                              GENMASK(19, 9) | GENMASK(7, 0))
> >  #define __HDFGRTR_EL2_nMASK  GENMASK(62, 59)
> >
> >  #define __HDFGWTR_EL2_RES0   (BIT(63) | GENMASK(59, 58) | BIT(51) | BI=
T(47) | \
> >                                BIT(43) | GENMASK(40, 38) | BIT(34) | BI=
T(30) | \
> >                                BIT(22) | BIT(9) | BIT(6))
> > -#define __HDFGWTR_EL2_MASK   ~__HDFGWTR_EL2_nMASK
> > +#define __HDFGWTR_EL2_MASK   (GENMASK(57, 52) | GENMASK(50, 48) | \
> > +                              GENMASK(46, 44) | GENMASK(42, 41) | \
> > +                              GENMASK(37, 35) | GENMASK(33, 31) | \
> > +                              GENMASK(29, 23) | GENMASK(21, 10) | \
> > +                              GENMASK(8, 7) | GENMASK(5, 0))
> >  #define __HDFGWTR_EL2_nMASK  GENMASK(62, 60)
> >
> >  /* Similar definitions for HCRX_EL2 */
> > -#define __HCRX_EL2_RES0              (GENMASK(63, 16) | GENMASK(13, 12=
))
> > -#define __HCRX_EL2_MASK              (0)
> > -#define __HCRX_EL2_nMASK     (GENMASK(15, 14) | GENMASK(4, 0))
> > +#define __HCRX_EL2_RES0         (GENMASK(63, 25) | GENMASK(13, 12))
> > +#define __HCRX_EL2_MASK              (BIT(6))
> > +#define __HCRX_EL2_nMASK     (GENMASK(24, 14) | GENMASK(11, 7) | GENMA=
SK(5, 0))
> >
> >  /* Hyp Prefetch Fault Address Register (HPFAR/HDFAR) */
> >  #define HPFAR_MASK   (~UL(0xf))
>
> The main driver for not following the latest and greatest version
> published in the architecture (including the FGT2 stuff) was to limit
> the amount of work we need to do in NV.
>
> Can you please update the FGT tables in emulated-nested.c so that we
> have a matching description of the added bits? This also overlaps with
> the work Joey is doing on POE, so there is scope for collaboration
> between you two here.

Will do.

Cheers,
/fuad

> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.
