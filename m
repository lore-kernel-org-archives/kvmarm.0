Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE70315CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 03:35:03 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id kb15so10636315pjb.1
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 20:35:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678678503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8b0WhK8vmfgLUxQMk/eTDiK5Km4ElMB+CW7ekOSktw=;
        b=UI2j7kOxEIcMON0OFYjBjv4HbsUo6ky4Jc7WVZANhbpNuUX/vx8IX2OSLAor1cfimy
         9z4jZajcCcdDq0PhoccbU8mXIkOXcHx2LNykaZK9F1q48ZpvebWLzp2JHFmohyDpFJpG
         f0+rePacUSHA6HUY+9dLcrmEgia4fCX65Uj5oXIlUr2ShIVoktgXEEDTzt4sb9bCYi1a
         THfBpsHmldHZbcf8UImoHCagJaIc2c6ScakEro2NvGYYt8AmpNGkLWvzsCjYx9SW436S
         B3GHcDC8xhXuaDDvOYWph/LuFDkChMgFHgrDxvR2jtpmNSBzlNK7exlVPwpigJoOwbkR
         mRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678678503;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8b0WhK8vmfgLUxQMk/eTDiK5Km4ElMB+CW7ekOSktw=;
        b=dPOrr9OAWNzQQ2PGlVdmP+iyRg7E85ucZomyUGl6ERhq/V8/l0qxCsa6tqRDotECtE
         jbU50qWj7G29iJwuhCBxQdMW5LmzikpvkNfwpTDHbPEOzLDnH7MtUCA1VrhPfUOXrN8/
         cF469NLFk2a6noG8pCqrPCv0HBQLhoiRRSINqqnRUbp+AO7z+NCcaGcUWcPDkQeZClTn
         72m0jPZPEuRjxznz/aU162Ux4mCEd5Wx0PYzTsIeIbIw6V+OW3Y4ENmhaAEWvd+ekMet
         R0jasgIYG/1c/FdGM0ubFV+8m363Jntn3QvHxw7e5kaa5bl63oSEqKk1Re3A1+CgULri
         qWmg==
X-Gm-Message-State: AO0yUKWj7ktawQ1bhIXupJGI+ymtFAg2MTRNi7YkAFmriPzTTuZZHBRN
	UXcBPK8Q0EWQFgRdC7xr7pg9QatI1I5rwigk+d1koA==
X-Google-Smtp-Source: AK7set+ZYwGulAFTlGElUo5y1U5AO9QzS5d1rkxFf+xh7M7NuFyE3ozmdH71T9UqFQSC06M2dN0/bogbUzkgVc+Hyjs=
X-Received: by 2002:a17:90a:ba03:b0:230:b842:143e with SMTP id
 s3-20020a17090aba0300b00230b842143emr11836291pjr.6.1678678503167; Sun, 12 Mar
 2023 20:35:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230302055033.3081456-1-reijiw@google.com> <20230302055033.3081456-3-reijiw@google.com>
 <87y1o23tfx.wl-maz@kernel.org>
In-Reply-To: <87y1o23tfx.wl-maz@kernel.org>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 20:34:46 -0700
Message-ID: <CAAeT=FxiYjPyFcvDKWVHhkksDd8FQtq8Nwz3bgWygNwitFsGHQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM: arm64: PMU: Don't save PMCR_EL0.{C,P} for the vCPU
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev, kvm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Ricardo Koller <ricarkol@google.com>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Will Deacon <will@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Sun, Mar 12, 2023 at 8:01=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Thu, 02 Mar 2023 05:50:33 +0000,
> Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Presently, when a guest writes 1 to PMCR_EL0.{C,P}, which is WO/RAZ,
> > KVM saves the register value, including these bits.
> > When userspace reads the register using KVM_GET_ONE_REG, KVM returns
> > the saved register value as it is (the saved value might have these
> > bits set).  This could result in userspace setting these bits on the
> > destination during migration.  Consequently, KVM may end up resetting
> > the vPMU counter registers (PMCCNTR_EL0 and/or PMEVCNTR<n>_EL0) to
> > zero on the first KVM_RUN after migration.
> >
> > Fix this by not saving those bits when a guest writes 1 to those bits.
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > ---
> >  arch/arm64/kvm/pmu-emul.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index 24908400e190..a5a0a9811ddb 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -538,7 +538,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64=
 val)
> >       if (!kvm_pmu_is_3p5(vcpu))
> >               val &=3D ~ARMV8_PMU_PMCR_LP;
> >
> > -     __vcpu_sys_reg(vcpu, PMCR_EL0) =3D val;
> > +     /* The reset bits don't indicate any state, and shouldn't be save=
d. */
> > +     __vcpu_sys_reg(vcpu, PMCR_EL0) =3D
> > +                             val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR=
_P);
>
> nit: assignment on a single line, please.

Yes, I fixed it in v2!

>
> With that,
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>

Thank you!
Reiji
