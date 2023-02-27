Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4768B628
	for <kvmarm@lists.linux.dev>; Mon, 27 Feb 2023 02:57:37 +0000 (UTC)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-172334d5c8aso6119275fac.8
        for <kvmarm@lists.linux.dev>; Sun, 26 Feb 2023 18:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FpFsj3ew/x/ritkNu2zWkCLb1cRFDdj63V3TKW7f8oM=;
        b=fOhSUQGoLFXBF7hMGQiQGBI3M2m+LtIbx8sNWltR1fxrLAik1+wP4KIVjGp8nS2gwt
         DiFUYt7w93pNNYzWGQsWnU2RG4MmptJGkJyvLO94yb7/302zqKUOAQk0xoVpdORMsKvh
         QhKRoxwdOq7DuoxutMmyIqkOAdQRHdKDnhdCRKEsycXnvTFtxDp6gYk4VmPOryjD/bpP
         aKMIg/Z3O/VqjPhrbQdc1LxAh+qIM7qBznwSxNEyafjwYYTt5mgtOJ4aZmR39nBCLWg6
         DY+JOpbB0MSYQduorly5TnHpLx3Xj1SxKffARKAe9lmlYu5aM/9p815XAAWcLv2wr9KH
         0LuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpFsj3ew/x/ritkNu2zWkCLb1cRFDdj63V3TKW7f8oM=;
        b=3hKxjCGB83RuPHcQ8te0Sg4yanWEOGZWk2HSuUpdd1MeDX4uOi/ss2uyUnd72E2hlF
         9I1179EtJ57rpdkV6W/0OndW5yqAGzJoL5J6/qGv7PqpLgBsPrWxcSxFMZXi+1qquukK
         Kme2TM4q2iJ/lPP4HAWBDdiH9t1yL5JUoTjo//OuPC1lu7sOCP9dcYc9DY8WXuEZbvtE
         nnalM7g3PWytZTdNpNqxwLbu+NXY1FzYt19b6n1rm0/V6BnR3/7q9jMXBIY7sNgHSVOX
         up3hO/056CEwblQ6FKKfQnnFy/6oaolNzAU1c7x3itKgeEG6xr9Gfxh9fZ6K+P3FZphX
         bUSA==
X-Gm-Message-State: AO0yUKWt/9hD/AuUJilg/Gfmgx7166ltQctG5v2M8bgzWeSUlbkA7zSp
	JOwIyichNjBcbf/TaXomAmf5R7QdHHtDr9rdf6jr/A==
X-Google-Smtp-Source: AK7set8rmvQzkN2d1qzmMbRL4MDd28eWwEi6kC+dilEaS3AK/F+lZPLdpDrMTLkNTr3zqljLc27sb7o6WDcYKqX9R+I=
X-Received: by 2002:a05:6870:715:b0:172:2b6d:e85f with SMTP id
 ea21-20020a056870071500b001722b6de85fmr3045945oab.11.1677466656098; Sun, 26
 Feb 2023 18:57:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230212215830.2975485-1-jingzhangos@google.com>
 <20230212215830.2975485-5-jingzhangos@google.com> <CAAeT=FxXNvkd4qg83oYciahbADGPSoHb+KYRfrCRWx2s43b7qA@mail.gmail.com>
In-Reply-To: <CAAeT=FxXNvkd4qg83oYciahbADGPSoHb+KYRfrCRWx2s43b7qA@mail.gmail.com>
From: Jing Zhang <jingzhangos@google.com>
Date: Sun, 26 Feb 2023 18:57:24 -0800
Message-ID: <CAAdAUthpDLRGcJdLZnbmEjKGXkHvGgYB3wZ3f6D1uai8QAqJjA@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To: Reiji Watanabe <reijiw@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Reiji,

On Fri, Feb 24, 2023 at 6:36 PM Reiji Watanabe <reijiw@google.com> wrote:
>
> Hi Jing,
>
> On Sun, Feb 12, 2023 at 1:58 PM Jing Zhang <jingzhangos@google.com> wrote:
> >
> > With per guest ID registers, PMUver settings from userspace
> > can be stored in its corresponding ID register.
> >
> > No functional change intended.
> >
> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > ---
> >  arch/arm64/include/asm/kvm_host.h | 11 ++++----
> >  arch/arm64/kvm/arm.c              |  6 -----
> >  arch/arm64/kvm/id_regs.c          | 44 +++++++++++++++++++++++--------
> >  include/kvm/arm_pmu.h             |  6 +++--
> >  4 files changed, 43 insertions(+), 24 deletions(-)
> >
> > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > index f64347eb77c2..effb61a9a855 100644
> > --- a/arch/arm64/include/asm/kvm_host.h
> > +++ b/arch/arm64/include/asm/kvm_host.h
> > @@ -218,6 +218,12 @@ struct kvm_arch {
> >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > +       /*
> > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> > +        * userspace for VCPUs without PMU.
> > +        */
> > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU
>
> As Oliver suggested, it might be better to not expose IMPDEF PMU
> (but expose as 0), since it is not effectively supported by KVM.
> (We need to be careful not to have migration from old KVM fail though)
>
>
Since that change is not related to writable ID register change
itself, I'd prefer to have that change in a separate commit or post.
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
> > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> >         kvm_arm_set_default_id_regs(kvm);
> >         kvm_arm_init_hypercalls(kvm);
> >
> > -       /*
> > -        * Initialise the default PMUver before there is a chance to
> > -        * create an actual PMU.
> > -        */
> > -       kvm->arch.dfr0_pmuver.imp = kvm_arm_pmu_get_pmuver_limit();
> > -
> >         return 0;
> >
> >  err_free_cpumask:
> > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > index bc4c408a43eb..14ae03a1d8d0 100644
> > --- a/arch/arm64/kvm/id_regs.c
> > +++ b/arch/arm64/kvm/id_regs.c
> > @@ -21,9 +21,12 @@
> >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> >  {
> >         if (kvm_vcpu_has_pmu(vcpu))
> > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > -
> > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags))
> > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > +       else
> > +               return 0;
> >  }
> >
> >  static u8 perfmon_to_pmuver(u8 perfmon)
> > @@ -267,10 +270,15 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp = pmuver;
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp = pmuver;
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), pmuver);
>
> The original code keeps ID_AA64DFR0_EL1.PMUVer and ID_DFR0_EL1.PerfMon
> values consistent (if one of them is update, the other one is also
> updated accordingly).  To keep the same behavior, shouldn't we update
> the other one as well when one of them is updated ?
>
Yes, will do that to keep the values consistent.
> Thank you,
> Reiji
>
>
> > +       } else if (pmuver == ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -307,10 +315,15 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
> >         if (val)
> >                 return -EINVAL;
> >
> > -       if (valid_pmu)
> > -               vcpu->kvm->arch.dfr0_pmuver.imp = perfmon_to_pmuver(perfmon);
> > -       else
> > -               vcpu->kvm->arch.dfr0_pmuver.unimp = perfmon_to_pmuver(perfmon);
> > +       if (valid_pmu) {
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon);
> > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=
> > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_to_pmuver(perfmon));
> > +       } else if (perfmon == ID_DFR0_EL1_PerfMon_IMPDEF) {
> > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       } else {
> > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->arch.flags);
> > +       }
> >
> >         return 0;
> >  }
> > @@ -534,4 +547,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
> >         }
> >
> >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) = val;
> > +
> > +       /*
> > +        * Initialise the default PMUver before there is a chance to
> > +        * create an actual PMU.
> > +        */
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &= ~ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=
> > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> > +                          kvm_arm_pmu_get_pmuver_limit());
> >  }
> > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > index 628775334d5e..eef67b7d9751 100644
> > --- a/include/kvm/arm_pmu.h
> > +++ b/include/kvm/arm_pmu.h
> > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
> >  /*
> >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> >   */
> > -#define kvm_pmu_is_3p5(vcpu)                                           \
> > -       (vcpu->kvm->arch.dfr0_pmuver.imp >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> > +#define kvm_pmu_is_3p5(vcpu)                                                                   \
> > +       (kvm_vcpu_has_pmu(vcpu) &&                                                              \
> > +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),                                  \
> > +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >= ID_AA64DFR0_EL1_PMUVer_V3P5)
> >
> >  u8 kvm_arm_pmu_get_pmuver_limit(void);
> >
> > --
> > 2.39.1.581.gbfd45094c4-goog
> >

Thanks,
Jing
