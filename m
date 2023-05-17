Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6137B2A9C0
	for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 22:55:57 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-19a19778b09so585319fac.3
        for <kvmarm@lists.linux.dev>; Wed, 17 May 2023 15:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684364156; x=1686956156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=46QpodnGSfHclqw+wxHyKFNt8ooXzRh8RHIYqYrx2+k=;
        b=4+k/qgLfKUbMibjVom5X5UhnGbYr8SY7C4iqF+FjTJPLgxW+FBx+j8VsQMmRbh+LBM
         4HY/nqXerEYNVykQDDyUKEf1PkTanAbpYJIp+6CT/R0xIDDxnZcIeD0cTsct/n+fL2/h
         gIlyInibT0h0yvhStw/4gnW7b/RZCvz9SWM5wNrX9jexUtTLoi3zBHKDMpkQhjIvDpFJ
         CwfGqoDlAf9LQwz/r8jjolXlVq/B2Tn/FfGXbwOnVHffKYY935TCVkIj93Bw33pWsqe3
         1FmE1LGrNcQCwBuvA/GZyt4U2DHr4ZY8pslIiGPLv2es9DjvjwkhPWAW9XIJmIt+iSVI
         zBbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364156; x=1686956156;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=46QpodnGSfHclqw+wxHyKFNt8ooXzRh8RHIYqYrx2+k=;
        b=jQ251vn/C2MNkFPgbNxV5hyM0C1pA/nNpWVZTEv+mOKZNDOz+iaLkCWmMj7kKhCbWf
         nyft/GI64kRP96pXlWSyrJy+ML2k/WlF+rHD2jg17V9cWa4h90x2ap3+xJ3nP3jT3FXU
         EaM0SUGVlUvAGMuygSKmn8hsMyaidv/N/ZiTrILYfvYXKcrxe/5cdZqhheB0rvVCpQo+
         ElppYsOyLp66NLxLyjWhRuASlmyNyKgIco4XBEMGeYXaUyw14mfnMSUAIpZ6StpMB8Hm
         I+CmXJJd7NI1pvY+Xf/JiLDbILtBsN2/9u7boebVAgQ7XNw+b0GGTNbzMKwsfvR4ooeB
         svpQ==
X-Gm-Message-State: AC+VfDwlPN8JQa8MRcAmVcXltmuNJfkyCb4T6ZtrvSQSxyY/oJB7TeZY
	Gjf36YKjdnb62ma3M3qeOGhz6sb2VHnjN4BdLOYWAA==
X-Google-Smtp-Source: ACHHUZ6H1ghtK0PMEZjs5hL/HFrkQgf3pKsDKz0W5jSHZcWf9yXXh6vAhTaYH2vuFwwQF5OoI3Y71eqWqEXYN2I/B3E=
X-Received: by 2002:a05:6870:a891:b0:188:1195:5ec4 with SMTP id
 eb17-20020a056870a89100b0018811955ec4mr158820oab.40.1684364156311; Wed, 17
 May 2023 15:55:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230503171618.2020461-1-jingzhangos@google.com>
 <20230503171618.2020461-7-jingzhangos@google.com> <b64e5639b1b9bb5e5e4ff8eaa10554ae0d9a6016.camel@amazon.com>
In-Reply-To: <b64e5639b1b9bb5e5e4ff8eaa10554ae0d9a6016.camel@amazon.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Wed, 17 May 2023 15:55:44 -0700
Message-ID: <CAAdAUtibBVuMGhh9NEOxpEyMQ6bxde674ME+hHqERoT5hctETA@mail.gmail.com>
Subject: Re: [PATCH v8 6/6] KVM: arm64: Refactor writings for PMUVer/CSV2/CSV3
To: "Jitindar Singh, Suraj" <surajjs@amazon.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>, 
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "maz@kernel.org" <maz@kernel.org>, 
	"oupton@google.com" <oupton@google.com>, "james.morse@arm.com" <james.morse@arm.com>, 
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "rananta@google.com" <rananta@google.com>, 
	"tabba@google.com" <tabba@google.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, 
	"alexandru.elisei@arm.com" <alexandru.elisei@arm.com>, "will@kernel.org" <will@kernel.org>, 
	"reijiw@google.com" <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Suraj,

On Wed, May 17, 2023 at 3:00=E2=80=AFPM Jitindar Singh, Suraj
<surajjs@amazon.com> wrote:
>
> On Wed, 2023-05-03 at 17:16 +0000, Jing Zhang wrote:
> > Refactor writings for ID_AA64PFR0_EL1.[CSV2|CSV3],
> > ID_AA64DFR0_EL1.PMUVer and ID_DFR0_ELF.PerfMon based on utilities
> > introduced by ID register descriptor array.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/cpufeature.h |   1 +
> >  arch/arm64/kernel/cpufeature.c      |   2 +-
> >  arch/arm64/kvm/id_regs.c            | 361 ++++++++++++++++++--------
> > --
> >  3 files changed, 242 insertions(+), 122 deletions(-)
> >
> >
>
> [ SNIP ]
>
> >
> > +static u64 read_sanitised_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> > +                                         const struct sys_reg_desc
> > *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * The default is to expose CSV2 =3D=3D 1 if the HW isn't
> > affected.
> > +        * Although this is a per-CPU feature, we make it global
> > because
> > +        * asymmetric systems are just a nuisance.
> > +        *
> > +        * Userspace can override this as long as it doesn't promise
> > +        * the impossible.
> > +        */
> > +       if (arm64_get_spectre_v2_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2);
> > +               val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2), 1);
> > +       }
> > +       if (arm64_get_meltdown_state() =3D=3D SPECTRE_UNAFFECTED) {
> > +               val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3);
> > +               val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3), 1);
> > +       }
> > +
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_AMU);
> > +
> > +       return val;
> > +}
> > +
> >  static int set_id_aa64pfr0_el1(struct kvm_vcpu *vcpu,
> >                                const struct sys_reg_desc *rd,
> >                                u64 val)
> >  {
> > -       struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > -       u64 sval =3D val;
> >         u8 csv2, csv3;
> > -       int ret =3D 0;
> >
> >         /*
> >          * Allow AA64PFR0_EL1.CSV2 to be set from userspace as long
> > as
> > @@ -226,26 +338,30 @@ static int set_id_aa64pfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         if (csv3 > 1 || (csv3 && arm64_get_meltdown_state() !=3D
> > SPECTRE_UNAFFECTED))
> >                 return -EINVAL;
>
> Can't we remove the checking of csv[23] here as it will be checked by
> arm64_check_features()?
>
> i.e. in arm64_check_features() we will load the "limit" value from the
> "reset" function (read_sanitised_id_aa64pfr0_el1()) which has csv[23]
> set appropriately and limit it to a safe value basically performing the
> same check as we are here.
The limit and the check here might be different if like
arm64_get_meltdown_state() is not SPECTRE_UNAFFECTED.
i.e. if we remove the check here, theoretically, the csv3 can be set a
value greater 1 if arm64_get_meltdown_state() is not
SPECTRE_UNAFFECTED.
>
> >
> > -       mutex_lock(&arch->config_lock);
> > -       /* We can only differ with CSV[23], and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV2) |
> > -                ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_CSV3));
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > +       return set_id_reg(vcpu, rd, val);
> > +}
> >
> > -       /* Only allow userspace to change the idregs before VM
> > running */
> > -       if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > -                       ret =3D -EBUSY;
> > -       } else {
> > -               IDREG(vcpu->kvm, reg_to_encoding(rd)) =3D sval;
> > -       }
> > -out:
> > -       mutex_unlock(&arch->config_lock);
> > -       return ret;
> > +static u64 read_sanitised_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                         const struct sys_reg_desc
> > *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /* Limit debug to ARMv8.0 */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer);
> > +       val |=3D
> > FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_DebugVer), 6);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                         kvm_arm_pmu_get_pmuver_limit());
> > +       /* Hide SPE from guests */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMSVer);
> > +
> > +       return val;
> >  }
> >
> >  static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> > @@ -255,7 +371,6 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >         struct kvm_arch *arch =3D &vcpu->kvm->arch;
> >         u8 pmuver, host_pmuver;
> >         bool valid_pmu;
> > -       u64 sval =3D val;
> >         int ret =3D 0;
> >
> >         host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> > @@ -277,40 +392,61 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >                 return -EINVAL;
> >
> >         mutex_lock(&arch->config_lock);
> > -       /* We can only differ with PMUver, and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > -
> >         /* Only allow userspace to change the idregs before VM
> > running */
> >         if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > +               if (val !=3D read_id_reg(vcpu, rd))
> >                         ret =3D -EBUSY;
> > -       } else {
> > -               if (valid_pmu) {
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > -                       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > -                       val |=3D
> > FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, pmuver);
> > -                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > -
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > -                       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > -                       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > pmuver_to_perfmon(pmuver));
> > -                       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > -               } else {
> > -
> >                        assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > &vcpu->kvm->arch.flags,
> > -                                  pmuver =3D=3D
> > ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
> > -               }
> > +               goto out;
> > +       }
> > +
> > +       if (!valid_pmu) {
> > +               /*
> > +                * Ignore the PMUVer filed in @val. The PMUVer would
>
> Nit s/filed/field
Will fix.
>
> > be determined
> > +                * by arch flags bit
> > KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > +                */
> > +               pmuver =3D FIELD_GET(ID_AA64DFR0_EL1_PMUVer_MASK,
> > +                                  IDREG(vcpu->kvm,
> > SYS_ID_AA64DFR0_EL1));
> > +               val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +               val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > pmuver);
> >         }
> >
> > +       ret =3D arm64_check_features(vcpu, rd, val);
> > +       if (ret)
> > +               goto out;
> > +
> > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +
> > +       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > +       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > pmuver_to_perfmon(pmuver));
> > +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +
> > +       if (!valid_pmu)
> > +               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-
> > >kvm->arch.flags,
> > +                          pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF=
);
> > +
> >  out:
> >         mutex_unlock(&arch->config_lock);
> >         return ret;
> >  }
> >
> > +static u64 read_sanitised_id_dfr0_el1(struct kvm_vcpu *vcpu,
> > +                                     const struct sys_reg_desc *rd)
> > +{
> > +       u64 val;
> > +       u32 id =3D reg_to_encoding(rd);
> > +
> > +       val =3D read_sanitised_ftr_reg(id);
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +       val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon),
> > kvm_arm_pmu_get_pmuver_limit());
> > +
> > +       return val;
> > +}
> > +
> >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >                            const struct sys_reg_desc *rd,
> >                            u64 val)
> > @@ -318,7 +454,6 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         struct kvm_arch *arch =3D &vcpu->kvm->arch;
> >         u8 perfmon, host_perfmon;
> >         bool valid_pmu;
> > -       u64 sval =3D val;
> >         int ret =3D 0;
> >
> >         host_perfmon =3D
> > pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit());
> > @@ -341,35 +476,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu
> > *vcpu,
> >                 return -EINVAL;
> >
> >         mutex_lock(&arch->config_lock);
> > -       /* We can only differ with PerfMon, and anything else is an
> > error */
> > -       val ^=3D read_id_reg(vcpu, rd);
> > -       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > -       if (val) {
> > -               ret =3D -EINVAL;
> > -               goto out;
> > -       }
> > -
> >         /* Only allow userspace to change the idregs before VM
> > running */
> >         if (test_bit(KVM_ARCH_FLAG_HAS_RAN_ONCE, &vcpu->kvm-
> > >arch.flags)) {
> > -               if (sval !=3D read_id_reg(vcpu, rd))
> > +               if (val !=3D read_id_reg(vcpu, rd))
> >                         ret =3D -EBUSY;
> > -       } else {
> > -               if (valid_pmu) {
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > -                       val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > -                       val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK,
> > perfmon);
> > -                       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > -
> > -                       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > -                       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > -                       val |=3D
> > FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, perfmon_to_pmuver(perfmon));
> > -                       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > -               } else {
> > -
> >                        assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > &vcpu->kvm->arch.flags,
> > -                                  perfmon =3D=3D
> > ID_DFR0_EL1_PerfMon_IMPDEF);
> > -               }
> > +               goto out;
> > +       }
> > +
> > +       if (!valid_pmu) {
> > +               /*
> > +                * Ignore the PerfMon filed in @val. The PerfMon
>
> Nit s/filed/field
Thanks, will fix it.
>
> > would be determined
> > +                * by arch flags bit
> > KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU,
> > +                */
> > +               perfmon =3D FIELD_GET(ID_DFR0_EL1_PerfMon_MASK,
> > +                                   IDREG(vcpu->kvm,
> > SYS_ID_DFR0_EL1));
> > +               val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +               val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, perfmon);
> >         }
> >
> > +       ret =3D arm64_check_features(vcpu, rd, val);
> > +       if (ret)
> > +               goto out;
> > +
> > +       IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +
> > +       val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > +       val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +       val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK,
> > perfmon_to_pmuver(perfmon));
> > +       IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +
> > +       if (!valid_pmu)
> > +               assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu-
> > >kvm->arch.flags,
> > +                          perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF);
> > +
> >  out:
> >         mutex_unlock(&arch->config_lock);
> >         return ret;
>
> Otherwise looks good!
>
> Thanks,
> Suraj

Thanks,
Jing
