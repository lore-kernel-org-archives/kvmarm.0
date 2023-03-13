Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D7515CA
	for <kvmarm@lists.linux.dev>; Mon, 13 Mar 2023 04:13:22 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id qa18-20020a17090b4fd200b0023750b675f5so15647000pjb.3
        for <kvmarm@lists.linux.dev>; Sun, 12 Mar 2023 21:13:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678680801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9d29HNVv/mtH93nCPpIBpKbg6i8n20OjIXEbDsVv/Ck=;
        b=oQ2Y2P//6FC33/dHHWYMs+qwhmmgU6yQd8B9Up4ZOIriHmJ8YT5gbDVsEtYUXT/811
         /s2ttDtK2vuhgsjBuPHoi76ED5d9Yv9pBnQ6wk2lkcQ5IGd/+oV4U5S4Lch3OIdXNICA
         Er2jFcKb7SogYd1uRwC7STz7q1AWs8OD2xMvWKOFgcH8Jqy4AGW20cFyjw2/vz1DN+ir
         O2J8Na4/exAEFCjnPabv+NozEMn8U9MQFE1fJw3oMdBk04YaOgxWii78ME77FfxJFsOa
         dkRQ/2WfNFzY3vlW0UuijH5lqwTcnaLxf9eO7uMQRq6wxBzYASeL4LIMRf+30Y9Cxifm
         iRng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678680801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9d29HNVv/mtH93nCPpIBpKbg6i8n20OjIXEbDsVv/Ck=;
        b=c8qCuwXGl2qsyA8V90N9wio6JGI9G3gG9eSp2phodj3oVo1ctnVifB6G+af1EoRu6u
         bvLI7qOdRnyNrFU0e+VNSL+YFmsZomCjV04xLHofiN57EC9/SPSLJ71XXfnIOrWn61f1
         yzmjRsy9B1aUu+vwrZ3ummFLkGnhJVGbn0q9BKM/En4g9P0anzdeHB59hWoAdQOmYz6b
         UiBjVkZqjKQ0C8x885lWDqqY3S5IF6c5SVVUyCyteHYustpu5YQzJV+/67TRvxil1zq6
         E4T8GjkwwHdGzNDqmZ8InbzyyualwfKTrD9XMlOib3qWn8R1ay+YoLaAciyTgXNNOITL
         Qmww==
X-Gm-Message-State: AO0yUKWLQI/8DbLzV9gVWrYPTb3GzzJMAh44KomTz+Xb9579Uhzfybm1
	qgOA0y8Qf7cd2WH3xfDa9sefv14LkfzutRlljc6EOrbpUZYPqk7BbrgXYg==
X-Google-Smtp-Source: AK7set/PpUcE2K9JPmajZAFuI6t4TZ8xNrjEi/xAPgOMz3bhLrJQ+nPCEqYCsdB3HhCH0NfSwkOajsS1xi72dvi/oVs=
X-Received: by 2002:a17:903:280f:b0:19e:f660:81ee with SMTP id
 kp15-20020a170903280f00b0019ef66081eemr6069717plb.2.1678680801431; Sun, 12
 Mar 2023 21:13:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com>
 <20230228062246.1222387-5-jingzhangos@google.com> <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
 <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
In-Reply-To: <CAAdAUtiSfMUHwBmFwvSpo5TdsdSDiEQWqJacg7YNzU_8b+AkDw@mail.gmail.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Sun, 12 Mar 2023 21:13:05 -0700
Message-ID: <CAAeT=FzokuakbRG5U75zCbGzgB-DN17pq+MTLCH1+4iXL7vLHQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] KVM: arm64: Use per guest ID register for ID_AA64DFR0_EL1.PMUVer
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.linux.dev>, 
	ARMLinux <linux-arm-kernel@lists.infradead.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@google.com>, Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Fuad Tabba <tabba@google.com>, 
	Ricardo Koller <ricarkol@google.com>, Raghavendra Rao Ananta <rananta@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jing,

On Thu, Mar 9, 2023 at 6:38=E2=80=AFPM Jing Zhang <jingzhangos@google.com> =
wrote:
>
> Hi Reiji,
>
> On Wed, Mar 8, 2023 at 8:42 AM Reiji Watanabe <reijiw@google.com> wrote:
> >
> > Hi Jing,
> >
> > On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google=
.com> wrote:
> > >
> > > With per guest ID registers, PMUver settings from userspace
> > > can be stored in its corresponding ID register.
> > >
> > > No functional change intended.
> > >
> > > Signed-off-by: Jing Zhang <jingzhangos@google.com>
> > > ---
> > >  arch/arm64/include/asm/kvm_host.h | 11 ++++---
> > >  arch/arm64/kvm/arm.c              |  6 ----
> > >  arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-----=
--
> > >  include/kvm/arm_pmu.h             |  6 ++--
> > >  4 files changed, 51 insertions(+), 24 deletions(-)
> > >
> > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/a=
sm/kvm_host.h
> > > index f64347eb77c2..effb61a9a855 100644
> > > --- a/arch/arm64/include/asm/kvm_host.h
> > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > @@ -218,6 +218,12 @@ struct kvm_arch {
> > >  #define KVM_ARCH_FLAG_EL1_32BIT                                4
> > >         /* PSCI SYSTEM_SUSPEND enabled for the guest */
> > >  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> > > +       /*
> > > +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_=
DEF
> > > +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF =
from
> > > +        * userspace for VCPUs without PMU.
> > > +        */
> > > +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
> > >
> > >         unsigned long flags;
> > >
> > > @@ -230,11 +236,6 @@ struct kvm_arch {
> > >
> > >         cpumask_var_t supported_cpus;
> > >
> > > -       struct {
> > > -               u8 imp:4;
> > > -               u8 unimp:4;
> > > -       } dfr0_pmuver;
> > > -
> > >         /* Hypercall features firmware registers' descriptor */
> > >         struct kvm_smccc_features smccc_feat;
> > >
> > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > index c78d68d011cb..fb2de2cb98cb 100644
> > > --- a/arch/arm64/kvm/arm.c
> > > +++ b/arch/arm64/kvm/arm.c
> > > @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned l=
ong type)
> > >         kvm_arm_set_default_id_regs(kvm);
> > >         kvm_arm_init_hypercalls(kvm);
> > >
> > > -       /*
> > > -        * Initialise the default PMUver before there is a chance to
> > > -        * create an actual PMU.
> > > -        */
> > > -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> > > -
> > >         return 0;
> > >
> > >  err_free_cpumask:
> > > diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> > > index 36859e4caf02..21ec8fc10d79 100644
> > > --- a/arch/arm64/kvm/id_regs.c
> > > +++ b/arch/arm64/kvm/id_regs.c
> > > @@ -21,9 +21,12 @@
> > >  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
> > >  {
> > >         if (kvm_vcpu_has_pmu(vcpu))
> > > -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> > > -
> > > -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> > > +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_P=
MUVer),
> > > +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)=
);
> > > +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags))
> > > +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> > > +       else
> > > +               return 0;
> > >  }
> > >
> > >  static u8 perfmon_to_pmuver(u8 perfmon)
> > > @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu =
*vcpu,
> > >         if (val)
> > >                 return -EINVAL;
> > >
> > > -       if (valid_pmu)
> > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> > > -       else
> > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> > > +       if (valid_pmu) {
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEA=
TURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1=
_PMUVer), pmuver);
> > > +
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_DFR0_EL1_PerfMon);
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> > > +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_Per=
fMon), pmuver);
> >
> > The pmuver must be converted to perfmon for ID_DFR0_EL1.
> Yes, wil fix it.
> >
> > Also, I think those registers should be updated atomically, although PM=
Uver
> > specified by userspace will be normally the same for all vCPUs with
> > PMUv3 configured (I have the same comment for set_id_dfr0_el1()).
> >
> I think there is no race condition here. No corrupted data would be
> set in the field, right?

If userspace tries to set inconsistent values of PMUver/Perfmon
for vCPUs with vPMU configured at the same time, PMUver and Perfmon
won't be consistent even with this KVM code.
It won't be sane userspace though :)

> >
> > > +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > > +       } else {
> > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags);
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcp=
u,
> > >         if (val)
> > >                 return -EINVAL;
> > >
> > > -       if (valid_pmu)
> > > -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver=
(perfmon);
> > > -       else
> > > -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuv=
er(perfmon);
> > > +       if (valid_pmu) {
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_DFR0_EL1_PerfMon);
> > > +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(
> > > +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perf=
mon_to_pmuver(perfmon));
> >
> > The perfmon value should be set for ID_DFR0_EL1 (not pmuver).
> >
> Sure, will fix it.
> > > +
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEA=
TURE_MASK(ID_AA64DFR0_EL1_PMUVer);
> > > +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP=
(
> > > +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), p=
erfmon_to_pmuver(perfmon));
> > > +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> > > +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kv=
m->arch.flags);
> > > +       } else {
> > > +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->=
kvm->arch.flags);
> > > +       }
> > >
> > >         return 0;
> > >  }
> > > @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm=
)
> > >         }
> > >
> > >         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> > > +
> > > +       /*
> > > +        * Initialise the default PMUver before there is a chance to
> > > +        * create an actual PMU.
> > > +        */
> > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_A=
A64DFR0_EL1_PMUVer);
> > > +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> > > +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer)=
,
> > > +                          kvm_arm_pmu_get_pmuver_limit());
> > >  }
> > > diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> > > index 628775334d5e..eef67b7d9751 100644
> > > --- a/include/kvm/arm_pmu.h
> > > +++ b/include/kvm/arm_pmu.h
> > > @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vc=
pu);
> > >  /*
> > >   * Evaluates as true when emulating PMUv3p5, and false otherwise.
> > >   */
> > > -#define kvm_pmu_is_3p5(vcpu)                                        =
   \
> > > -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_=
V3P5)
> > > +#define kvm_pmu_is_3p5(vcpu)                                        =
                           \
> > > +       (kvm_vcpu_has_pmu(vcpu) &&                                   =
                           \
> >
> > What is the reason for adding this kvm_vcpu_has_pmu() checking ?
> > I don't think this patch's changes necessitated this.
> For the same VM, is it possible that some VCPUs would have PMU, but
> some may not have?
> That's why the kvm_vcpu_has_pmu is added here.

Yes, it's possible. But, it doesn't appear that this patch or any
patches in the series adds a code that newly uses the macro.
I believe this macro is always used for the vCPUs with vPMU
configured currently.
Did you find a case where this is used for vCPUs with no vPMU ?

If this change tries to address an existing issue, I think it would
be nicer to fix this in a separate patch. Or it would be helpful
if you could add an explanation in the commit log at least.

Thank you,
Reiji
