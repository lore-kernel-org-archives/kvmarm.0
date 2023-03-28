Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8ACBA20
	for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 20:20:18 +0000 (UTC)
Received: by mail-oi1-f172.google.com with SMTP id r14so4270684oiw.12
        for <kvmarm@lists.linux.dev>; Tue, 28 Mar 2023 13:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680034817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JMJ0lbEpieVn3cFA01bO8crqPoJkdQ18ysyignOhrQw=;
        b=EUWAPwEw0uX5nRyZVK97z2um0A2DhMJNZtrphCfxDbAv42agAYocC+yUdvnuK3ugtU
         yM+nM24zDm75RqhCEKVZR/UMjGwaQZ8RgvVhz/4xKx32czYG9LJj+jRqmybWHVd7Mnxl
         s8h8JXz/OWbG1iOtb/OS32V4Dt0Qh+1Dxiqeedt6iWntwMuQoSFVlrG/hianT2aZ8A7z
         YEN2q+zcsU1+haAyd8HgL+g7TnHgqtQR4qJnzxe+dbI3ojXtqzzXlz//UzYdHQqmc0Ij
         dkkfVrHd6qgvypmByQtnLIEPrfuPPFy+WKr9umbfczQfaJSRet6plb1aERfuHT/d2t2t
         a8Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680034817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JMJ0lbEpieVn3cFA01bO8crqPoJkdQ18ysyignOhrQw=;
        b=WZtu6as8cSrEBtoS7cMWPlzAi8yAmoC2hxv0mx6VVIvga8GPBLfuVdyqGe3o6sRFKT
         moZS/O3gEne9McjCa0o5mvpE6VYdBvz0fWKbjjGqxWnHtBjRHNnvHNDlrRHOugxbPjUd
         dhc04IJIQ9QNI6zfcY8mi4W2Yjm1HWHEBaalfmDa6TuQDCPHRzt13YqKSrZaUX6cBTnS
         OU762svYw4MlCTbCnmL+vHcgy4LVXd+jIPXQ6IeHxJmzBtxgp1r5UYmqy0suyYjrTb7i
         9ChKao/qTwtZivo/rkSGgwUqKvjLs81cD78IjSCH1ryx/lgJL52+V4G4W/z4PgXa/FA7
         DbWA==
X-Gm-Message-State: AO0yUKU6gSzjzzKKVtR8b1MYPP691IskeqhNSrbqcVAAv4TYNG7KZA1/
	6XXgHwnO2n1e2RXLrbXUb55ia6arj2eYbJbU/nrS1w==
X-Google-Smtp-Source: AK7set+8l3qe+kAGJeQH0GX8il8uSe8QJGkiP5c1aVYloAJeyFJO19YEOK5KAOHvw27vwu+xwnp9BSY0S0GT+GW6A6Q=
X-Received: by 2002:aca:d05:0:b0:386:a120:4fdc with SMTP id
 5-20020aca0d05000000b00386a1204fdcmr4200022oin.8.1680034817533; Tue, 28 Mar
 2023 13:20:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230317050637.766317-1-jingzhangos@google.com>
 <20230317050637.766317-5-jingzhangos@google.com> <86y1niwk83.wl-maz@kernel.org>
In-Reply-To: <86y1niwk83.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 28 Mar 2023 13:20:06 -0700
Message-ID: <CAAdAUtirFM-+uZvmahYJpTmpBDURDkM-R1Wg0yvm6-mwSkLS+g@mail.gmail.com>
Subject: Re: [PATCH v4 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Marc,

On Mon, Mar 27, 2023 at 3:40=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Fri, 17 Mar 2023 05:06:35 +0000,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 +++---
> >  arch/arm64/kvm/arm.c              |  6 ---
> >  arch/arm64/kvm/id_regs.c          | 61 +++++++++++++++++++++++++------
> >  include/kvm/arm_pmu.h             |  5 ++-
> >  4 files changed, 59 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index e926ea91a73c..102860ba896d 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -218,6 +218,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                              4
> >       /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED         5
> > +     /*
> > +      * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > +      * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > +      * userspace for VCPUs without PMU.
> > +      */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU           6
> >
> >       unsigned long flags;
> >
> > @@ -230,11 +236,6 @@ struct kvm_arch {
> >
> >       cpumask_var_t supported_cpus;
> >
> > -     struct {
> > -             u8 imp:4;
> > -             u8 unimp:4;
> > -     } dfr0_pmuver;
> > -
> >       /* Hypercall features firmware registers' descriptor */
> >       struct kvm_smccc_features smccc_feat;
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c78d68d011cb..fb2de2cb98cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >       kvm_arm_set_default_id_regs(kvm);
> >       kvm_arm_init_hypercalls(kvm);
> >
> > -     /*
> > -      * Initialise the default PMUver before there is a chance to
> > -      * create an actual PMU.
> > -      */
> > -     kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > -
> >       return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index b60ca1058301..3a87a3d2390d 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > -             return vcpu->kvm->arch.dfr0_pmuver.imp;
> > -
> > -     return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +             return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVe=
r),
> > +                             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_=
AA64DFR0_EL1)]);
> > +     else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags))
> > +             return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > +     else
> > +             return 0;
>
> Drop the pointless elses.
Will do.
>
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -256,10 +259,23 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
> >       if (val)
> >               return -EINVAL;
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > +     if (valid_pmu) {
> > +             mutex_lock(&vcpu->kvm->lock);
>
> Bingo!
>
Will fix it.
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
=3D
> > +                     ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
=3D
> > +                     FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver), pmuver);
> > +
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=3D
> > +                     ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |=3D =
FIELD_PREP(
> > +                             ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), =
pmuver_to_perfmon(pmuver));
> > +             mutex_unlock(&vcpu->kvm->lock);
> > +     } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +             set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> > +     } else {
> > +             clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +     }
>
> The last two cases are better written as:
>
>         assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.f=
lags,
>                    pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF);
>
Will do.
> >
> >       return 0;
> >  }
> > @@ -296,10 +312,23 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >       if (val)
> >               return -EINVAL;
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(per=
fmon);
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver(p=
erfmon);
> > +     if (valid_pmu) {
> > +             mutex_lock(&vcpu->kvm->lock);
>
> Same here (lock inversion)
Will fix it.
>
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] &=3D
> > +                     ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_DFR0_EL1)] |=3D =
FIELD_PREP(
> > +                     ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon)=
;
> > +
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=
=3D
> > +                     ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +             vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=
=3D FIELD_PREP(
> > +                     ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfm=
on_to_pmuver(perfmon));
> > +             mutex_unlock(&vcpu->kvm->lock);
> > +     } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > +             set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> > +     } else {
> > +             clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +     }
>
> Same here (assign_bit).
Will do.
> >
> >       return 0;
> >  }
> > @@ -543,4 +572,14 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >       }
> >
> >       kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64PFR0_EL1)] =3D val;
> > +
> > +     /*
> > +      * Initialise the default PMUver before there is a chance to
> > +      * create an actual PMU.
> > +      */
> > +     kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] &=3D
> > +             ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +     kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)] |=3D
> > +             FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                        kvm_arm_pmu_get_pmuver_limit());
>
> Please put these assignments on a single line...
Will do.
>
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..51c7f3e7bdde 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,9 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu)=
;
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                         \
> > -     (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_V3P5=
)
> > +#define kvm_pmu_is_3p5(vcpu)                                          =
                       \
> > +      (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),          =
                       \
> > +              vcpu->kvm->arch.id_regs[IDREG_IDX(SYS_ID_AA64DFR0_EL1)])=
 >=3D ID_AA64DFR0_EL1_PMUVer_V3P5)
>
> I'll stop mentioning the need for accessors...
Will fix it.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
