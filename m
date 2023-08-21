Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB3F18AE1
	for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 23:28:45 +0000 (UTC)
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-4036bd4fff1so141381cf.0
        for <kvmarm@lists.linux.dev>; Mon, 21 Aug 2023 16:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692660524; x=1693265324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IoBEhjvPJ+4Pes6lEgQyI0U16mirdJerxMCR3Q7guss=;
        b=f0WeCnl9NJf5ZrugPiaggI0NoB8RDK3RvzwprG2GpDKuzeB0n0xTnHKgi4U7fUh7Ew
         KN4mIPJ1g7xDf1EmcvbWPHOZ3aH8LuXWVojSjmsHmLUTpCC/0L7mwqrXjOB/8bQDZqRi
         9Q8g+Lv6IEkqUDryKFO6l8rOM4FJUYwy2d6ECZGm/JsXgwT7z3rNGUujD1cxoSK4UGkR
         dz2BYDtqMv8SmNnAxbbze+v4bAn8ahLIyDUlJa4B3fdBtpdG6b17R/zQpAOQF9WD4muO
         8F9zRAxyY+zDc2WkIdTKoAUFg03rOu28uuYb+qRIMqkLBMGG2zGOPUJZp4/Tj+ws2tQP
         xHTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692660524; x=1693265324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IoBEhjvPJ+4Pes6lEgQyI0U16mirdJerxMCR3Q7guss=;
        b=DEzrfbdJHhgR9sgJ5sPFUoNn4OTUYTfDwNnghtP814qgVp6S+RfIL+5y0vhkFNv6R4
         0zQFRHwPbDg1i3d0wrg3L3ApGGCFRS/bNi/mOwW+I2rRtxoiL8mwL1ehQP2BfC0pJMTE
         ijDJ5vv2u8ibC4nx8YN5XGVDhiV9TlAKK6sVhVrK36K7ualLB0RB8/VPUyqlvvG4AFzc
         CHhlfJbyeQHtX/im47Mn7nd4pHkFi8/5RSLulNZyktbwTxIeYnuznDvTAhrwkWt8zo8q
         S57srRS0e+EWic2dGg0y4M22hG+zzDcF4Uc/6eAIOK1a7kpiRBL+IzwglhF4JL5E8CXX
         q84w==
X-Gm-Message-State: AOJu0YxvqaKWNXCC6i3kaTu7pJmPiBPdS+qxAU6bYOo6RDG8cwDZbkGC
	yS8AkcTZKopII+FEVfaJf3HVAjjQFIEXIfoQw2sSsQ==
X-Google-Smtp-Source: AGHT+IEMRUm9cMR18w9gI39+Eb2ucD+0SLYiYxfVZjaG9mM1N5KjchQtBgVqZyMt+fNHLmJ/tfAbBz2S7In3M7asVvg=
X-Received: by 2002:a05:622a:148a:b0:3ef:5f97:258f with SMTP id
 t10-20020a05622a148a00b003ef5f97258fmr119334qtx.16.1692660524057; Mon, 21 Aug
 2023 16:28:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230817003029.3073210-1-rananta@google.com> <20230817003029.3073210-9-rananta@google.com>
 <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com>
In-Reply-To: <6dc460d2-c7fb-e299-b0a3-55b43de31555@redhat.com>
From: Raghavendra Rao Ananta <rananta@google.com>
Date: Mon, 21 Aug 2023 16:28:32 -0700
Message-ID: <CAJHc60whpvOHYCFueqh0Q=SbmmeRBG_x90QOvX+vOun73ttjPA@mail.gmail.com>
Subject: Re: [PATCH v5 08/12] KVM: arm64: PMU: Allow userspace to limit
 PMCR_EL0.N for the guest
To: Shaoqin Huang <shahuang@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, James Morse <james.morse@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Jing Zhang <jingzhangos@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Colton Lewis <coltonlewis@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Shaoqin,

On Mon, Aug 21, 2023 at 5:12=E2=80=AFAM Shaoqin Huang <shahuang@redhat.com>=
 wrote:
>
> Hi Raghavendra,
>
> On 8/17/23 08:30, Raghavendra Rao Ananta wrote:
> > From: Reiji Watanabe <reijiw@google.com>
> >
> > KVM does not yet support userspace modifying PMCR_EL0.N (With
> > the previous patch, KVM ignores what is written by upserspace).
> > Add support userspace limiting PMCR_EL0.N.
> >
> > Disallow userspace to set PMCR_EL0.N to a value that is greater
> > than the host value (KVM_SET_ONE_REG will fail), as KVM doesn't
> > support more event counters than the host HW implements.
> > Although this is an ABI change, this change only affects
> > userspace setting PMCR_EL0.N to a larger value than the host.
> > As accesses to unadvertised event counters indices is CONSTRAINED
> > UNPREDICTABLE behavior, and PMCR_EL0.N was reset to the host value
> > on every vCPU reset before this series, I can't think of any
> > use case where a user space would do that.
> >
> > Also, ignore writes to read-only bits that are cleared on vCPU reset,
> > and RES{0,1} bits (including writable bits that KVM doesn't support
> > yet), as those bits shouldn't be modified (at least with
> > the current KVM).
> >
> > Signed-off-by: Reiji Watanabe <reijiw@google.com>
> > Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> > ---
> >   arch/arm64/include/asm/kvm_host.h |  3 ++
> >   arch/arm64/kvm/pmu-emul.c         |  1 +
> >   arch/arm64/kvm/sys_regs.c         | 49 +++++++++++++++++++++++++++++-=
-
> >   3 files changed, 51 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 0f2dbbe8f6a7e..c15ec365283d1 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -259,6 +259,9 @@ struct kvm_arch {
> >       /* PMCR_EL0.N value for the guest */
> >       u8 pmcr_n;
> >
> > +     /* Limit value of PMCR_EL0.N for the guest */
> > +     u8 pmcr_n_limit;
> > +
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >       struct maple_tree smccc_filter;
> > diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
> > index ce7de6bbdc967..39ad56a71ad20 100644
> > --- a/arch/arm64/kvm/pmu-emul.c
> > +++ b/arch/arm64/kvm/pmu-emul.c
> > @@ -896,6 +896,7 @@ int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_=
pmu *arm_pmu)
> >        * while the latter does not.
> >        */
> >       kvm->arch.pmcr_n =3D arm_pmu->num_events - 1;
> > +     kvm->arch.pmcr_n_limit =3D arm_pmu->num_events - 1;
> >
> >       return 0;
> >   }
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 2075901356c5b..c01d62afa7db4 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1086,6 +1086,51 @@ static int get_pmcr(struct kvm_vcpu *vcpu, const=
 struct sys_reg_desc *r,
> >       return 0;
> >   }
> >
> > +static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *=
r,
> > +                 u64 val)
> > +{
> > +     struct kvm *kvm =3D vcpu->kvm;
> > +     u64 new_n, mutable_mask;
> > +     int ret =3D 0;
> > +
> > +     new_n =3D FIELD_GET(ARMV8_PMU_PMCR_N, val);
> > +
> > +     mutex_lock(&kvm->arch.config_lock);
> > +     if (unlikely(new_n !=3D kvm->arch.pmcr_n)) {
> > +             /*
> > +              * The vCPU can't have more counters than the PMU
> > +              * hardware implements.
> > +              */
> > +             if (new_n <=3D kvm->arch.pmcr_n_limit)
> > +                     kvm->arch.pmcr_n =3D new_n;
> > +             else
> > +                     ret =3D -EINVAL;
> > +     }
>
> Since we have set the default value of pmcr_n, if we want to set a new
> pmcr_n, shouldn't it be a different value?
>
> So how about change the checking to:
>
> if (likely(new_n <=3D kvm->arch.pmcr_n_limit)
>         kvm->arch.pmcr_n =3D new_n;
> else
>         ret =3D -EINVAL;
>
> what do you think?
>
Sorry, I guess I didn't fully understand your suggestion. Are you
saying that it's 'likely' that userspace would configure the correct
value?

> > +     mutex_unlock(&kvm->arch.config_lock);
> > +     if (ret)
> > +             return ret;
> > +
> > +     /*
> > +      * Ignore writes to RES0 bits, read only bits that are cleared on
> > +      * vCPU reset, and writable bits that KVM doesn't support yet.
> > +      * (i.e. only PMCR.N and bits [7:0] are mutable from userspace)
> > +      * The LP bit is RES0 when FEAT_PMUv3p5 is not supported on the v=
CPU.
> > +      * But, we leave the bit as it is here, as the vCPU's PMUver migh=
t
> > +      * be changed later (NOTE: the bit will be cleared on first vCPU =
run
> > +      * if necessary).
> > +      */
> > +     mutable_mask =3D (ARMV8_PMU_PMCR_MASK | ARMV8_PMU_PMCR_N);
> > +     val &=3D mutable_mask;
> > +     val |=3D (__vcpu_sys_reg(vcpu, r->reg) & ~mutable_mask);
> > +
> > +     /* The LC bit is RES1 when AArch32 is not supported */
> > +     if (!kvm_supports_32bit_el0())
> > +             val |=3D ARMV8_PMU_PMCR_LC;
> > +
> > +     __vcpu_sys_reg(vcpu, r->reg) =3D val;
> > +     return 0;
> > +}
> > +
> >   /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in o=
ne go */
> >   #define DBG_BCR_BVR_WCR_WVR_EL1(n)                                  \
> >       { SYS_DESC(SYS_DBGBVRn_EL1(n)),                                 \
> > @@ -2147,8 +2192,8 @@ static const struct sys_reg_desc sys_reg_descs[] =
=3D {
> >       { SYS_DESC(SYS_CTR_EL0), access_ctr },
> >       { SYS_DESC(SYS_SVCR), undef_access },
> >
> > -     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr,
> > -       .reset =3D reset_pmcr, .reg =3D PMCR_EL0, .get_user =3D get_pmc=
r },
> > +     { PMU_SYS_REG(PMCR_EL0), .access =3D access_pmcr, .reset =3D rese=
t_pmcr,
> > +       .reg =3D PMCR_EL0, .get_user =3D get_pmcr, .set_user =3D set_pm=
cr },
>
> A little confusing, since the PMU_SYS_REG() defines the default
> visibility which is pmu_visibility can return REG_HIDDEN, the set_user
> to pmcr will be blocked, how can it being set?
>
> Maybe I lose some details.
>
pmu_visibility() returns REG_HIDDEN only if userspace has not added
support for PMUv3 via KVM_ARM_PREFERRED_TARGET ioctl. Else, it should
return 0, and give access.

Thank you.
Raghavendra

> Thanks,
> Shaoqin
>
> >       { PMU_SYS_REG(PMCNTENSET_EL0),
> >         .access =3D access_pmcnten, .reg =3D PMCNTENSET_EL0 },
> >       { PMU_SYS_REG(PMCNTENCLR_EL0),
>
> --
> Shaoqin
>
