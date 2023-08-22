Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53E692B55A
	for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 18:35:25 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2bcc331f942so23280781fa.0
        for <kvmarm@lists.linux.dev>; Tue, 22 Aug 2023 11:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692729323; x=1693334123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZG8/FKpT+5ZMPFMf3XneVJf41+qrLWykYFB8Mroi2p0=;
        b=hBOpE32r3X0stLup3zJ47ajL9A3rBNXNiV3E6065k2zRuMHXcc2qeRBznkkK9jaVlb
         mXHE0QjQdww7Behkc6OxdFIf79q2MJ4L7RsubvntRwLmQnrrTg1cT9d8pyUw8qEi7p+M
         yAzFTIwy12LM9c0cAPQfJVXbFSoRjKC+wdHLqGUpWgRWR+CCZMQ1BNAeqK2Tt+qbp7mo
         LWTevvOk3ZEX9tUbJCPVTITMasMl/xdUVcqC1wnYRdfb62QxaOAMrlIbz+0/JUHLmN83
         4Fb0fNRNj2UgpPrcZpJ5BzlF8o1ZEyoC+NWiug6323PwBztsFF7/er0oLVx2e8iLR3uF
         zg8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692729323; x=1693334123;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZG8/FKpT+5ZMPFMf3XneVJf41+qrLWykYFB8Mroi2p0=;
        b=XgsrLrFLQMTY+B4h/8ujLxj+aATZq9McXUAjwbSztuiPpBqd6aB7QcAjJnI9m9H+n2
         w2L5zKzc7fyiMzJ+MkmOFsy8CJZZC98WtRAMdnIKpaN5HtBPwftHWqEC7TjdKmoLE6eP
         e72ccNrKAQjvKjtoMB89OXdYCc2cgBRfpGxoTPOI1/uCXlo5DItywzvok0sCs+pOLser
         z4U4Mfcwh33QrC1uau1Rg0DF0gQWWqXBsSGFqC1eJMybUajFflhZRc5aPD65VbAJRu6f
         aLzwEp4y2tQB35RMMbgyrDo0jwfLnbWNnhmT4b1x6rTzX7HLxz8nDY2zmAa99FwVYO/U
         BzmA==
X-Gm-Message-State: AOJu0Yyq0PdfqyZvOn5kvrHMfC/RaApm2F/I+aZE4p2EogFVIhwYiI4t
	HSnpCjZI1agm+KAUaW66hQorHXa5LwKpFGOCKDG0ag==
X-Google-Smtp-Source: AGHT+IHLjbjdpPtuGDgzItCHCjngA7+Qq5HGzx0ZodQ01Ijp53K1+QI7cmm5rC7QJqm8zCwp9G/pj+yHfDMxXCsrv2g=
X-Received: by 2002:a2e:2e06:0:b0:2b6:d0fa:7023 with SMTP id
 u6-20020a2e2e06000000b002b6d0fa7023mr3893380lju.24.1692729322972; Tue, 22 Aug
 2023 11:35:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821212243.491660-1-jingzhangos@google.com>
 <20230821212243.491660-6-jingzhangos@google.com> <878ra3pndw.wl-maz@kernel.org>
In-Reply-To: <878ra3pndw.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 22 Aug 2023 11:35:12 -0700
Message-ID: <CAAdAUti8qSf0PVnWkp4Jua-te6i0cjQKJm=8dt5vWqT0Q6w4iQ@mail.gmail.com>
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

On Tue, Aug 22, 2023 at 12:06=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrot=
e:
>
> On Mon, 21 Aug 2023 22:22:37 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > All valid fields in ID_AA64DFR0_EL1 and ID_DFR0_EL1 are writable
> > from userspace with this change.
> > RES0 fields and those fields hidden by KVM are not writable.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/kvm/sys_regs.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index afade7186675..20fc38bad4e8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1931,6 +1931,8 @@ static bool access_spsr(struct kvm_vcpu *vcpu,
> >       return true;
> >  }
> >
> > +#define ID_AA64DFR0_EL1_RES0_MASK (GENMASK(59, 56) | GENMASK(27, 24) |=
 GENMASK(19, 16))
> > +
> >  /*
> >   * Architected system registers.
> >   * Important: Must be sorted ascending by Op0, Op1, CRn, CRm, Op2
> > @@ -2006,7 +2008,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .set_user =3D set_id_dfr0_el1,
> >         .visibility =3D aa32_id_visibility,
> >         .reset =3D read_sanitised_id_dfr0_el1,
> > -       .val =3D ID_DFR0_EL1_PerfMon_MASK, },
> > +       .val =3D GENMASK(31, 0), },
>
> Can you *please* look at the register and realise that we *don't*
> support writing to the whole of the low 32 bits? What does it mean to
> allow selecting the M-profile debug? Or the memory-mapped trace?
>
> You are advertising a lot of crap to userspace, and that's definitely
> not on.
>
> >       ID_HIDDEN(ID_AFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR0_EL1),
> >       AA32_ID_SANITISED(ID_MMFR1_EL1),
> > @@ -2055,7 +2057,7 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >         .get_user =3D get_id_reg,
> >         .set_user =3D set_id_aa64dfr0_el1,
> >         .reset =3D read_sanitised_id_aa64dfr0_el1,
> > -       .val =3D ID_AA64DFR0_EL1_PMUVer_MASK, },
> > +       .val =3D ~(ID_AA64DFR0_EL1_PMSVer_MASK | ID_AA64DFR0_EL1_RES0_M=
ASK), },
>
> And it is the same thing here. Where is the handling code to deal with
> variable breakpoint numbers? Oh wait, there is none. Really, the only
> thing we support writing to are the PMU and Debug versions. And
> nothing else.
>
> What does it mean for userspace? Either the write will be denied
> despite being advertised a writable field (remember the first patch of
> the series???), or we'll blindly accept the write and further ignore
> the requested values. Do you really think any of this is acceptable?
>
> This is the *9th* version of this series, and we're still battling
> over some extremely basic userspace issues... I don't think we can
> merge this series as is stands.

I removed sanity checks across multiple fields after the discussion
here: https://lore.kernel.org/all/ZKRC80hb4hXwW8WK@thinky-boi/
I might have misunderstood the discussion. I thought we'd let VMM do
more complete sanity checks.

>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Jing
