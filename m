Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D361F935
	for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 18:35:51 +0000 (UTC)
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-19f1f11d268so3197373fac.2
        for <kvmarm@lists.linux.dev>; Tue, 30 May 2023 11:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685471751; x=1688063751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCZbrLX+1YAZmyeFZSoE93bVjqRrbAvOTH7aP1FNohI=;
        b=crs6HqROuNaq6gmwSzr8KFL6hfCU0WqYXvVXrTKgo5RktHg0+F9GGK5b13nI2n46+s
         90fJUpCujcatCGD4oI38/gh4pxOlnAXuE5UWHDCDgacz0gGUdfU/qE2asHkPMRR2Bcrc
         4jaaEcGZxcJOBAkQKeuUVgSmTp6shWCF8Vj3ixAbf/IvqU0JOiWUvm4pmnnu4cQT8Txk
         MyLMM42X/wrFtAQQgRVZNlcQh8FiiBZSUy0nf0Xb72pdTYWTvtHQgHky85acshgQM+dt
         mno5wATYBv4CAHnjgHi/EqHZ3OumFWV0+gNuApn8ZUfEs1nlqRpsEHz38eJyedVEU0bu
         +8vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685471751; x=1688063751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCZbrLX+1YAZmyeFZSoE93bVjqRrbAvOTH7aP1FNohI=;
        b=AooM8VfToJV/MJtysDsk+AXaMdNTDJH3PmtmtiTE1GPnCxt04se5alG9pzLBL+/OI8
         coFRQaQwymVw5cg7CCZv5NaxvDy0ZuZlCo++DFm0BCIZ8n1AugIA0RBzyml4Ko63Gh8/
         e4pWEPI50JQgmuU4LVbi1bpVMoyQtAPuJ7mJh9o3l5DqrpMR7SGtbkjLCbJzHHFV+f1l
         KgqXdUb6YrdrgTGD2ThB0RpQp6pv+zAemqQdsEVxyjoTkLdGcR67aQfKTJkXHXjcpv55
         h9KXBKnfxq8A1PXkOVJyLiPtFzHaCVq4KZX0h807jhFCsOpH9/CBDW4jThoBLbmLXhlE
         2NUA==
X-Gm-Message-State: AC+VfDxEUQ1f/gpgs57qSObd++Fi1vRzVlKC84EEi19ILgOtBrDyjRgh
	B/FCmiJz9T2IGgloNSqbLTMJrjpW59CxJyrsAsRDLw==
X-Google-Smtp-Source: ACHHUZ4JqxDHOObZjQ6uTlhx0gypGz4ELB2nk4E8CBivt1ecp0XbWTJTsPUoDvqMew45rJ+C62g9XcscLcNlwB7YeTM=
X-Received: by 2002:a05:6870:c814:b0:187:de63:1343 with SMTP id
 ee20-20020a056870c81400b00187de631343mr1245125oab.9.1685471750988; Tue, 30
 May 2023 11:35:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522221835.957419-1-jingzhangos@google.com>
 <20230522221835.957419-4-jingzhangos@google.com> <87r0r0ohh0.wl-maz@kernel.org>
In-Reply-To: <87r0r0ohh0.wl-maz@kernel.org>
From: Jing Zhang <jingzhangos@google.com>
Date: Tue, 30 May 2023 11:35:39 -0700
Message-ID: <CAAdAUtg=5+yPTZR91arKf2cuRzsugwoa_rUbjanmnqcYZ1RScg@mail.gmail.com>
Subject: Re: [PATCH v10 3/5] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To: Marc Zyngier <maz@kernel.org>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Oliver Upton <oupton@google.com>, 
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, James Morse <james.morse@arm.com>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Fuad Tabba <tabba@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, May 28, 2023 at 3:53=E2=80=AFAM Marc Zyngier <maz@kernel.org> wrote=
:
>
> On Mon, 22 May 2023 23:18:33 +0100,
> Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h |  12 ++--
> >  arch/arm64/kvm/arm.c              |   6 --
> >  arch/arm64/kvm/sys_regs.c         | 100 ++++++++++++++++++++++++------
> >  include/kvm/arm_pmu.h             |   5 +-
> >  4 files changed, 92 insertions(+), 31 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index 8a2fde6c04c4..7b0f43373dbe 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -246,6 +246,13 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_TIMER_PPIS_IMMUTABLE           7
> >       /* SMCCC filter initialized for the VM */
> >  #define KVM_ARCH_FLAG_SMCCC_FILTER_CONFIGURED                8
> > +     /*
> > +      * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > +      * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > +      * userspace for VCPUs without PMU.
> > +      */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU           9
> > +
> >       unsigned long flags;
> >
> >       /*
> > @@ -257,11 +264,6 @@ struct kvm_arch {
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
> >       struct maple_tree smccc_filter;
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index 5114521ace60..ca18c09ccf82 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -148,12 +148,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >       kvm_arm_init_hypercalls(kvm);
> >       kvm_arm_init_id_regs(kvm);
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
> > diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> > index 9fb1c2f8f5a5..84d9e4baa4f8 100644
> > --- a/arch/arm64/kvm/sys_regs.c
> > +++ b/arch/arm64/kvm/sys_regs.c
> > @@ -1178,9 +1178,12 @@ static bool access_arch_timer(struct kvm_vcpu *v=
cpu,
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >       if (kvm_vcpu_has_pmu(vcpu))
> > -             return vcpu->kvm->arch.dfr0_pmuver.imp;
> > +             return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVe=
r),
> > +                              IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +     else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags))
> > +             return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> >
> > -     return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +     return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -1403,8 +1406,12 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *=
vcpu,
> >                              const struct sys_reg_desc *rd,
> >                              u64 val)
> >  {
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > +     u64 old_val =3D read_id_reg(vcpu, rd);
> >       u8 pmuver, host_pmuver;
> > +     u64 new_val =3D val;
> >       bool valid_pmu;
> > +     int ret =3D 0;
> >
> >       host_pmuver =3D kvm_arm_pmu_get_pmuver_limit();
> >
> > @@ -1424,26 +1431,51 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu =
*vcpu,
> >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> >               return -EINVAL;
> >
> > +     mutex_lock(&arch->config_lock);
> >       /* We can only differ with PMUver, and anything else is an error =
*/
> > -     val ^=3D read_id_reg(vcpu, rd);
> > +     val ^=3D old_val;
> >       val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > -     if (val)
> > -             return -EINVAL;
> > +     if (val) {
> > +             ret =3D -EINVAL;
> > +             goto out;
> > +     }
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > +     /* Only allow userspace to change the idregs before VM running */
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             if (new_val !=3D old_val)
> > +                     ret =3D -EBUSY;
> > +     } else {
> > +             if (valid_pmu) {
> > +                     val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > +                     val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +                     val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, =
pmuver);
> > +                     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +
> > +                     val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > +                     val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +                     val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, pmu=
ver_to_perfmon(pmuver));
> > +                     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +             } else {
> > +                     assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &v=
cpu->kvm->arch.flags,
> > +                                pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_I=
MP_DEF);
> > +             }
> > +     }
> >
> > -     return 0;
> > +out:
> > +     mutex_unlock(&arch->config_lock);
> > +     return ret;
> >  }
> >
> >  static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >                          const struct sys_reg_desc *rd,
> >                          u64 val)
> >  {
> > +     struct kvm_arch *arch =3D &vcpu->kvm->arch;
> > +     u64 old_val =3D read_id_reg(vcpu, rd);
> >       u8 perfmon, host_perfmon;
> > +     u64 new_val =3D val;
> >       bool valid_pmu;
> > +     int ret =3D 0;
> >
> >       host_perfmon =3D pmuver_to_perfmon(kvm_arm_pmu_get_pmuver_limit()=
);
> >
> > @@ -1464,18 +1496,39 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> >       if (kvm_vcpu_has_pmu(vcpu) !=3D valid_pmu)
> >               return -EINVAL;
> >
> > +     mutex_lock(&arch->config_lock);
> >       /* We can only differ with PerfMon, and anything else is an error=
 */
> > -     val ^=3D read_id_reg(vcpu, rd);
> > +     val ^=3D old_val;
> >       val &=3D ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > -     if (val)
> > -             return -EINVAL;
> > +     if (val) {
> > +             ret =3D -EINVAL;
> > +             goto out;
> > +     }
> >
> > -     if (valid_pmu)
> > -             vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(per=
fmon);
> > -     else
> > -             vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver(p=
erfmon);
> > +     /* Only allow userspace to change the idregs before VM running */
> > +     if (kvm_vm_has_ran_once(vcpu->kvm)) {
> > +             if (new_val !=3D old_val)
> > +                     ret =3D -EBUSY;
> > +     } else {
> > +             if (valid_pmu) {
> > +                     val =3D IDREG(vcpu->kvm, SYS_ID_DFR0_EL1);
> > +                     val &=3D ~ID_DFR0_EL1_PerfMon_MASK;
> > +                     val |=3D FIELD_PREP(ID_DFR0_EL1_PerfMon_MASK, per=
fmon);
> > +                     IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) =3D val;
> > +
> > +                     val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);
> > +                     val &=3D ~ID_AA64DFR0_EL1_PMUVer_MASK;
> > +                     val |=3D FIELD_PREP(ID_AA64DFR0_EL1_PMUVer_MASK, =
perfmon_to_pmuver(perfmon));
> > +                     IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> > +             } else {
> > +                     assign_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &v=
cpu->kvm->arch.flags,
> > +                                perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMP=
DEF);
> > +             }
> > +     }
>
> This is the exact same code as for aa64fdr0. Make it a helper, please.
Will do.
>
> >
> > -     return 0;
> > +out:
> > +     mutex_unlock(&arch->config_lock);
> > +     return ret;
> >  }
> >
> >  /*
> > @@ -3422,6 +3475,17 @@ void kvm_arm_init_id_regs(struct kvm *kvm)
> >       }
> >
> >       IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > +     /*
> > +      * Initialise the default PMUver before there is a chance to
> > +      * create an actual PMU.
> > +      */
> > +     val =3D IDREG(kvm, SYS_ID_AA64DFR0_EL1);
> > +
> > +     val &=3D ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +     val |=3D FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                       kvm_arm_pmu_get_pmuver_limit());
> > +
> > +     IDREG(kvm, SYS_ID_AA64DFR0_EL1) =3D val;
> >  }
> >
> >  int __init kvm_sys_reg_table_init(void)
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 1a6a695ca67a..8d70dbdc1e0a 100644
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
> > +                 IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DF=
R0_EL1_PMUVer_V3P5)
>
> This is getting unreadable. How about something like:
>
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 8d70dbdc1e0a..ecb55d87fa36 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -92,9 +92,13 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  /*
>   * Evaluates as true when emulating PMUv3p5, and false otherwise.
>   */
> -#define kvm_pmu_is_3p5(vcpu)                                            =
                       \
> -        (FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),          =
                       \
> -                   IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DF=
R0_EL1_PMUVer_V3P5)
> +#define kvm_pmu_is_3p5(vcpu)   ({                                      \
> +       u64 val =3D IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1);               =
 \
> +       u8 v;                                                           \
> +                                                                       \
> +       v =3D FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), val);=
 \
> +       v >=3D ID_AA64DFR0_EL1_PMUVer_V3P5;                              =
 \
> +})
>
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
Sure, will use your suggestion.
>
> Thanks,
>
>         M.
>
> --
> Without deviation from the norm, progress is not possible.

Thanks,
Jing
