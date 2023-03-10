Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0DC7B
	for <kvmarm@lists.linux.dev>; Fri, 10 Mar 2023 02:38:32 +0000 (UTC)
Received: by mail-oo1-f51.google.com with SMTP id p8-20020a4a3c48000000b0052527a9d5f0so603540oof.1
        for <kvmarm@lists.linux.dev>; Thu, 09 Mar 2023 18:38:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678415912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b7t6O2KMMq37bm277QLmLICEVEmQKxMNjlgWb5w3+Mc=;
        b=L4PRyvqDqpjIbp27s16BnckpH3CpPHu3ePaQhAp0IChSOt2J/srDDyzRbUZ82tyUji
         DDnnP14YPGgmehOgtlrJNOQQUM1xdfaTt37VcgR0Wfm1x4L+r5cl+wZTqEyYuLTxL7vQ
         lSumvGPvCs1YCgsDgEFAFU5evSViatfj9K6cv4YOkBdQnxzn0B4gMQnbF80U/VhILVCp
         GJGc250fixc8dtv5Xt4GBTQQlqrt/GLSSVDLDCjUPaKlmkKNQa23EcPOM3UTGEiRVLJq
         WBs4BbX1/pque32ZF1kr/ttjboDGkBxZkBUhkRx1Xk3GUIwUo6HKrHe/CsG+SsI2rNLV
         EzCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678415912;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b7t6O2KMMq37bm277QLmLICEVEmQKxMNjlgWb5w3+Mc=;
        b=Hernl18VNK+nhwCvXyUd8zQoh5Swcw+yJFhpTfLluftNHitCS9+npiw7+6Sb+GaqIi
         GFx4+RYS9BkAySTkKeOixjYb6Yn4unWVrjc/kzZ7s5kDRZpERX9MhTUsA9dj8wW2QfCO
         AHl4bRm112O8utZNcIiVXhfmIJKIeW+I0dikoZFR99YimrgT0RAqrIP/adZpDDZK5IRF
         KVQ4IZCMOmfyW2ogzUff+jCON4acjEW8DUDT0ooEWJ0zx0oddkLo4zEkip7xHKLZeTMk
         imDVv1/qnZcmBVID6QFwlbUpxffTdAO/slm1yDauyFTql/YrPB9IOSUsKl7vwHdlFt9W
         gsaw==
X-Gm-Message-State: AO0yUKUQ4aJSWLQ9twHTF+jUdY9rUXqDYEMG8cesLbEWPIWrXaNOWo3q
	RL68EqQucgYzyvahjeZepTfACNnuTT8fliCPBl+MEw==
X-Google-Smtp-Source: AK7set/JxI6W3C5rLL2FSpjcyauEWtR1JYgVg4F5BJZ5O1LIhvBBHv7xIPcNRRlokD0INeKbpkfd85FMD9vfRVZntzw=
X-Received: by 2002:a4a:bd92:0:b0:525:23cc:a28e with SMTP id
 k18-20020a4abd92000000b0052523cca28emr8252023oop.0.1678415911762; Thu, 09 Mar
 2023 18:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-5-jingzhangos@google.com> <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
In-Reply-To: <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Thu, 9 Mar 2023 18:38:19 -0800
Message-ID: <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To: Reiji Watanabe <reijiw@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Reiji,

On Wed, Mar 8, 2023 at 8:42 AM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google.c=
om> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++---
> >  arch/arm64/kvm/arm.c              |  6 ----
> >  arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-------
> >  include/kvm/arm_pmu.h             |  6 ++--
> >  4 files changed, 51 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm=
/kvm_host.h
> > index f64347eb77c2..effb61a9a855 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -218,6 +218,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > +       /*
> > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DE=
F
> > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF fr=
om
> > +        * userspace for VCPUs without PMU.
> > +        */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
> >
> >         unsigned long flags;
> >
> > @@ -230,11 +236,6 @@ struct kvm_arch {
> >
> >         cpumask_var_t supported_cpus;
> >
> > -       struct {
> > -               u8 imp:4;
> > -               u8 unimp:4;
> > -       } dfr0_pmuver;
> > -
> >         /* Hypercall features firmware registers' descriptor */
> >         struct kvm_smccc_features smccc_feat;
> >
> > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > index c78d68d011cb..fb2de2cb98cb 100644
> > --- a/arch/arm64/kvm/arm.c
> > +++ b/arch/arm64/kvm/arm.c
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned lon=
g type)
> >         kvm_arm_set_default_id_regs(kvm);
> >         kvm_arm_init_hypercalls(kvm);
> >
> > -       /*
> > -        * Initialise the default PMUver before there is a chance to
> > -        * create an actual PMU.
> > -        */
> > -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > -
> >         return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index 36859e4caf02..21ec8fc10d79 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >         if (kvm_vcpu_has_pmu(vcpu))
> > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > -
> > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver),
> > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags))
> > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > +       else
> > +               return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *v=
cpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATU=
RE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_P=
MUVer), pmuver);
> > +
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_M=
ASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfM=
on), pmuver);
>
> The pmuver must be converted to perfmon for ID_DFR0_EL1.
Yes, wil fix it.
>
> Also, I think those registers should be updated atomically, although PMUv=
er
> specified by userspace will be normally the same for all vCPUs with
> PMUv3 configured (I have the same comment for set_id_dfr0_el1()).
>
I think there is no race condition here. No corrupted data would be
set in the field, right?
>
> > +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(p=
erfmon);
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver=
(perfmon);
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_M=
ASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(
> > +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmo=
n_to_pmuver(perfmon));
>
> The perfmon value should be set for ID_DFR0_EL1 (not pmuver).
>
Sure, will fix it.
> > +
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATU=
RE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(
> > +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), per=
fmon_to_pmuver(perfmon));
> > +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >         }
> >
> >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > +
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_AA6=
4DFR0_EL1_PMUVer);
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                          kvm_arm_pmu_get_pmuver_limit());
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..eef67b7d9751 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu=
);
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                          =
 \
> > -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_V3=
P5)
> > +#define kvm_pmu_is_3p5(vcpu)                                          =
                         \
> > +       (kvm_vcpu_has_pmu(vcpu) &&                                     =
                         \
>
> What is the reason for adding this kvm_vcpu_has_pmu() checking ?
> I don't think this patch's changes necessitated this.
For the same VM, is it possible that some VCPUs would have PMU, but
some may not have?
That's why the kvm_vcpu_has_pmu is added here.
>
> > +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),         =
                         \
> > +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DFR=
0_EL1_PMUVer_V3P5)
> >
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >
> > --
> > 2.39.2.722.g9855ee24e9-goog
> >
> >
>
> Thank you,
> Reiji
Thanks,
Jing
