Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87841361
	for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 08:37:12 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-403c653d934so5026301cf.2
        for <kvmarm@lists.linux.dev>; Thu, 20 Jul 2023 01:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689842231; x=1690447031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bNJv2VqvNlJG6tzgbT923d6RlXIIeEmPs4E3rYYx25g=;
        b=mUjMfllx2xLrK1oq/qNkNUb0wCDWKRwAAQ7euGqPsWIwC+UN4ojdTe9/zl0ZhWZhqM
         sfZZ+EiqR/WQfUs5zGmX/pjtOq2/eG8kxRn1ieuzCnrAUUhdR3ErzXkxJtOnp0VtAOP4
         oD0IjZ7WOcA9pbQ3T1gXuQa5ku3m6aCD13WzRbUy9MZ4ih61wWbA7qeyf+K67iE0IRtW
         8O3hktb0S+vQxlS51sGBFaWMFFnlTnA819nUB6xiW9rHak57sUZ+EyH2BOsrYfiXt34y
         3joHcUOwuoYDWTRcxlLwbP7W/6Cyzl/N+K90/WQVnrTskiJLeCv6KMVq49t5JD31stDC
         uLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689842231; x=1690447031;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bNJv2VqvNlJG6tzgbT923d6RlXIIeEmPs4E3rYYx25g=;
        b=DoO4FIRDCcIKgcdxTG1v5XeCK7Dbj6vKy4oTIgPpAJ7QwAx9qlEaExjfD7RCX/aLNU
         QEFJg/ia81lgzyzJFRWUZPiNsuGgz/KmaejkSPibz0KeDeQOVi42cDh6V61MfhJwTJGC
         DX6ypA19MFtlwsGec/OCJ8TmJEdnl2gSlqFeRG4VLXGhfsC18csou1czsR6ymBX5vefD
         tnnK51VA42gl/f/WodXMhHkeChzjxvhRu0nbGVlqUeHEcW5hTV5Vr4kDzg1fGExosA18
         FuPklmymD7pGDpykBeIVOyzNYTwn/mhNf1kKyQnszAg8/EOqvGtvbdDj+rg19HQ0vRRs
         O+Rw==
X-Gm-Message-State: ABy/qLZOFZavW9yzBQz7IWmqzKaMGf/6rVyjFd/WixeoaKZ3q/Kt7h4f
	4oc/ZptpePw17SNptcdrlT9J+kUAX96clmJGYBvTLQ==
X-Google-Smtp-Source: APBJJlF8tzzwiK2OFajTdUSE/XRqTHpusGROyrZMHc1BlgYuBJb4Qat5CairXTZVHUqmzkrENpFKwSpw24IFJ417tBg=
X-Received: by 2002:a05:622a:3c6:b0:402:8ecd:810f with SMTP id
 k6-20020a05622a03c600b004028ecd810fmr6516653qtx.40.1689842231158; Thu, 20 Jul
 2023 01:37:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230719150639.1968034-1-tabba@google.com> <20230719150639.1968034-3-tabba@google.com>
 <ZLgelCk3+W3YOpVx@linux.dev> <CA+EHjTx0O8H-59QJrTcuROtjwE1O0YgunsmHob32bEP2iSvEUw@mail.gmail.com>
In-Reply-To: <CA+EHjTx0O8H-59QJrTcuROtjwE1O0YgunsmHob32bEP2iSvEUw@mail.gmail.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 20 Jul 2023 09:36:35 +0100
Message-ID: <CA+EHjTzFOHgN1dsXw4+bL40FWn+eLV5V-9V0j-D+zzsC2QzCig@mail.gmail.com>
Subject: Re: [PATCH v1 2/5] KVM: arm64: Disable SME Traps for (h)VHE at setup
To: Oliver Upton <oliver.upton@linux.dev>
Cc: kvmarm@lists.linux.dev, maz@kernel.org, catalin.marinas@arm.com, 
	james.morse@arm.com, suzuki.poulose@arm.com, yuzenghui@huawei.com, 
	will@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Oliver,

On Thu, Jul 20, 2023 at 9:03=E2=80=AFAM Fuad Tabba <tabba@google.com> wrote=
:
>
> Hi Oliver,
>
>
> On Wed, Jul 19, 2023 at 6:34=E2=80=AFPM Oliver Upton <oliver.upton@linux.=
dev> wrote:
> >
> > On Wed, Jul 19, 2023 at 04:06:36PM +0100, Fuad Tabba wrote:
> > > Ensure that SME traps are disabled for (h)VHE when setting up
> > > EL2, as they are for nVHE.
> > >
> > > Signed-off-by: Fuad Tabba <tabba@google.com>
> > > ---
> > >  arch/arm64/include/asm/el2_setup.h | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > >
> > > diff --git a/arch/arm64/include/asm/el2_setup.h b/arch/arm64/include/=
asm/el2_setup.h
> > > index c106b31d776c..7001b6db3ccc 100644
> > > --- a/arch/arm64/include/asm/el2_setup.h
> > > +++ b/arch/arm64/include/asm/el2_setup.h
> > > @@ -292,9 +292,21 @@
> > >       check_override id_aa64pfr1, ID_AA64PFR1_EL1_SME_SHIFT, .Linit_s=
me_\@, .Lskip_sme_\@, x1, x2
> > >
> > >  .Linit_sme_\@:       /* SME register access and priority mapping */
> > > +     mrs     x1, hcr_el2
> > > +     and     x1, x1, #HCR_E2H
> > > +     cbz     x1, .Lcptr_nvhe_sme_\@
> >
> > Hmm.. Our test for hVHE is repeated enough times, it might make sense
> > for readability to wrap it up in a macro:
> >
> > .macro check_hvhe pass, fail, tmp
> >         mrs     \tmp, hcr_el2
> >         and     \tmp, \tmp, #HCR_E2H
> >         cbnz    \tmp, \pass
> >         b       \fail
> > .endm
> >
> > So long as we tolerate the additional word of bloat for the extra branc=
h
> > :)
>
> I did consider that, but went for less bloat. I'll wrap it in a macro
> for the respin though, and leave it up to the maintainers to decide
> which one to pick :D

Actually, with this macro I get the same desired effect without
affecting the emitted code:

/* Check if running in host at EL2 mode, i.e., (h)VHE. Jumps to fail if not=
. */
.macro __check_e2h fail, tmp
         mrs \tmp, hcr_el2
         and \tmp, \tmp, #HCR_E2H
         cbz \tmp, \fail
.endm

Unless someone disagrees, I will use this for the respin.

Cheers,
/fuad




>
> Cheers,
> /fuad
>
> >
> > > +     // (h)VHE case
> > > +     mrs     x0, cpacr_el1                   // Disable SME traps
> > > +     orr     x0, x0, #(CPACR_EL1_SMEN_EL0EN | CPACR_EL1_SMEN_EL1EN)
> > > +     msr     cpacr_el1, x0
> > > +     b       .Lskip_set_cptr_sme_\@
> > > +
> > > +.Lcptr_nvhe_sme_\@: // nVHE case
> > >       mrs     x0, cptr_el2                    // Disable SME traps
> > >       bic     x0, x0, #CPTR_EL2_TSM
> > >       msr     cptr_el2, x0
> > > +.Lskip_set_cptr_sme_\@:
> > >       isb
> > >
> > >       mrs     x1, sctlr_el2
> > > --
> > > 2.41.0.255.g8b1d071c50-goog
> > >
> >
> > --
> > Thanks,
> > Oliver
