Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5631079F0
	for <kvmarm@lists.linux.dev>; Wed,  8 Mar 2023 16:42:51 +0000 (UTC)
Received: by mail-pf1-f170.google.com with SMTP id x7so8651043pff.7
        for <kvmarm@lists.linux.dev>; Wed, 08 Mar 2023 08:42:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678293771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jyRnKyecrW7vP/Tu61lZO3sKDddw2/r4+Uv90AznIc=;
        b=ESXZfwiSuVBdhkOLNrz71N9bDHs0hhd51WOwRLhF7te+E6KfNSD57BgmXOytxBg2Kg
         5kJDR53Z2zTnkFizQVesgQEuLe7LNz1OZERCxvlcA9uLeITIF8X+mxBtzYDGUccpCgyY
         AeTO53tYK78bx0RyTm1JlN6dHhhSyrtR9UG3HXiDK1T9WvEX9W9FmRb48cEfrktKe5HJ
         ESUzrBIDsSebJy+Pg4+Mp0u9cFuB5oPK8Vvd+VoLM+8C7lLAEMNihayp5jQjfhqoZ9d4
         Ety7PPV+cap23G1uzK787clmDPTiDOgJwtfYBOJHwEjFGa87GF6fN5Fsz/iDe3CN177Y
         9zYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678293771;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jyRnKyecrW7vP/Tu61lZO3sKDddw2/r4+Uv90AznIc=;
        b=r+CH0ErQv70gJBzlqY3fLIyBbdctpmZXUf1TyPjvXZW+txSoUHjH5+94l1ettOTrDe
         vDqjWb7syirHiL9xGkEE236iQBGJHOGgLerA+bSQudhLidUX8HIoSue75765/fTeEnGx
         F2SfKvIrigVMwoslZns85Wi8ozOQxOCFOrF/usi+z6iFQdYAj0BFMNVd4tf3Y00zu1sz
         OaDmJIDbObl0HF3P+2IqDMt/6rzg6qrssMW1Q689F8mkms+uF6XbZrXh3Fw0xvmEnCCL
         Ww0wSw0NygUDTD1SQVSGwjFNrukSaQ4xnHditUVngdGRn+0QEoYwnveSqgYN6cNwMnhE
         pSpQ==
X-Gm-Message-State: AO0yUKV+XnAEUHK1kKG4nO4DI0OIhEYEWyLud77N3voGubgo4rlVseuT
	IYEYvt7gIBU9T+wOV1bMSwllitKXN6CFdpnMf7nsGw==
X-Google-Smtp-Source: AK7set99AJCec8w5hkQZHk7IsFNbM2llBM/sMMjJoECvz07OciAnFzUmj2WxnzqIRWz7xpJWnHUHQbwXO4oQvyLnSG0=
X-Received: by 2002:a63:3c52:0:b0:502:f4c6:3992 with SMTP id
 i18-20020a633c52000000b00502f4c63992mr6915852pgn.4.1678293770456; Wed, 08 Mar
 2023 08:42:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230228062246.1222387-1-jingzhangos@google.com> <20230228062246.1222387-5-jingzhangos@google.com>
In-Reply-To: <20230228062246.1222387-5-jingzhangos@google.com>
From: Reiji Watanabe <reijiw@google.com>
Date: Wed, 8 Mar 2023 08:42:34 -0800
Message-ID: <CAAeT=Fzm_O-fbk2+jCExtnk7x4XXO1UwiviMmn0BU53A7Ea9WQ@mail.gmail.com>
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

On Mon, Feb 27, 2023 at 10:23=E2=80=AFPM Jing Zhang <jingzhangos@google.com=
> wrote:
>
> With per guest ID registers, PMUver settings from userspace
> can be stored in its corresponding ID register.
>
> No functional change intended.
>
> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h | 11 ++++---
>  arch/arm64/kvm/arm.c              |  6 ----
>  arch/arm64/kvm/id_regs.c          | 52 ++++++++++++++++++++++++-------
>  include/kvm/arm_pmu.h             |  6 ++--
>  4 files changed, 51 insertions(+), 24 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/k=
vm_host.h
> index f64347eb77c2..effb61a9a855 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -218,6 +218,12 @@ struct kvm_arch {
>  #define KVM_ARCH_FLAG_EL1_32BIT                                4
>         /* PSCI SYSTEM_SUSPEND enabled for the guest */
>  #define KVM_ARCH_FLAG_SYSTEM_SUSPEND_ENABLED           5
> +       /*
> +        * AA64DFR0_EL1.PMUver was set as ID_AA64DFR0_EL1_PMUVer_IMP_DEF
> +        * or DFR0_EL1.PerfMon was set as ID_DFR0_EL1_PerfMon_IMPDEF from
> +        * userspace for VCPUs without PMU.
> +        */
> +#define KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU             6
>
>         unsigned long flags;
>
> @@ -230,11 +236,6 @@ struct kvm_arch {
>
>         cpumask_var_t supported_cpus;
>
> -       struct {
> -               u8 imp:4;
> -               u8 unimp:4;
> -       } dfr0_pmuver;
> -
>         /* Hypercall features firmware registers' descriptor */
>         struct kvm_smccc_features smccc_feat;
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index c78d68d011cb..fb2de2cb98cb 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -138,12 +138,6 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long =
type)
>         kvm_arm_set_default_id_regs(kvm);
>         kvm_arm_init_hypercalls(kvm);
>
> -       /*
> -        * Initialise the default PMUver before there is a chance to
> -        * create an actual PMU.
> -        */
> -       kvm->arch.dfr0_pmuver.imp =3D kvm_arm_pmu_get_pmuver_limit();
> -
>         return 0;
>
>  err_free_cpumask:
> diff --git a/arch/arm64/kvm/id_regs.c b/arch/arm64/kvm/id_regs.c
> index 36859e4caf02..21ec8fc10d79 100644
> --- a/arch/arm64/kvm/id_regs.c
> +++ b/arch/arm64/kvm/id_regs.c
> @@ -21,9 +21,12 @@
>  static u8 vcpu_pmuver(const struct kvm_vcpu *vcpu)
>  {
>         if (kvm_vcpu_has_pmu(vcpu))
> -               return vcpu->kvm->arch.dfr0_pmuver.imp;
> -
> -       return vcpu->kvm->arch.dfr0_pmuver.unimp;
> +               return FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVe=
r),
> +                               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1));
> +       else if (test_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags))
> +               return ID_AA64DFR0_EL1_PMUVer_IMP_DEF;
> +       else
> +               return 0;
>  }
>
>  static u8 perfmon_to_pmuver(u8 perfmon)
> @@ -256,10 +259,19 @@ static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcp=
u,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp =3D pmuver;
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D pmuver;
> +       if (valid_pmu) {
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_AA64DFR0_EL1_PMUVer);
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D
> +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMU=
Ver), pmuver);
> +
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_MAS=
K(ID_DFR0_EL1_PerfMon);
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D
> +                       FIELD_PREP(ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon=
), pmuver);

The pmuver must be converted to perfmon for ID_DFR0_EL1.

Also, I think those registers should be updated atomically, although PMUver
specified by userspace will be normally the same for all vCPUs with
PMUv3 configured (I have the same comment for set_id_dfr0_el1()).


> +       } else if (pmuver =3D=3D ID_AA64DFR0_EL1_PMUVer_IMP_DEF) {
> +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> +       } else {
> +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> +       }
>
>         return 0;
>  }
> @@ -296,10 +308,19 @@ static int set_id_dfr0_el1(struct kvm_vcpu *vcpu,
>         if (val)
>                 return -EINVAL;
>
> -       if (valid_pmu)
> -               vcpu->kvm->arch.dfr0_pmuver.imp =3D perfmon_to_pmuver(per=
fmon);
> -       else
> -               vcpu->kvm->arch.dfr0_pmuver.unimp =3D perfmon_to_pmuver(p=
erfmon);
> +       if (valid_pmu) {
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) &=3D ~ARM64_FEATURE_MAS=
K(ID_DFR0_EL1_PerfMon);
> +               IDREG(vcpu->kvm, SYS_ID_DFR0_EL1) |=3D FIELD_PREP(
> +                       ARM64_FEATURE_MASK(ID_DFR0_EL1_PerfMon), perfmon_=
to_pmuver(perfmon));

The perfmon value should be set for ID_DFR0_EL1 (not pmuver).

> +
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE=
_MASK(ID_AA64DFR0_EL1_PMUVer);
> +               IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1) |=3D FIELD_PREP(
> +                       ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer), perfm=
on_to_pmuver(perfmon));
> +       } else if (perfmon =3D=3D ID_DFR0_EL1_PerfMon_IMPDEF) {
> +               set_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm->a=
rch.flags);
> +       } else {
> +               clear_bit(KVM_ARCH_FLAG_VCPU_HAS_IMP_DEF_PMU, &vcpu->kvm-=
>arch.flags);
> +       }
>
>         return 0;
>  }
> @@ -543,4 +564,13 @@ void kvm_arm_set_default_id_regs(struct kvm *kvm)
>         }
>
>         IDREG(kvm, SYS_ID_AA64PFR0_EL1) =3D val;
> +
> +       /*
> +        * Initialise the default PMUver before there is a chance to
> +        * create an actual PMU.
> +        */
> +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) &=3D ~ARM64_FEATURE_MASK(ID_AA64D=
FR0_EL1_PMUVer);
> +       IDREG(kvm, SYS_ID_AA64DFR0_EL1) |=3D
> +               FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),
> +                          kvm_arm_pmu_get_pmuver_limit());
>  }
> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
> index 628775334d5e..eef67b7d9751 100644
> --- a/include/kvm/arm_pmu.h
> +++ b/include/kvm/arm_pmu.h
> @@ -92,8 +92,10 @@ void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
>  /*
>   * Evaluates as true when emulating PMUv3p5, and false otherwise.
>   */
> -#define kvm_pmu_is_3p5(vcpu)                                           \
> -       (vcpu->kvm->arch.dfr0_pmuver.imp >=3D ID_AA64DFR0_EL1_PMUVer_V3P5=
)
> +#define kvm_pmu_is_3p5(vcpu)                                            =
                       \
> +       (kvm_vcpu_has_pmu(vcpu) &&                                       =
                       \

What is the reason for adding this kvm_vcpu_has_pmu() checking ?
I don't think this patch's changes necessitated this.

> +        FIELD_GET(ARM64_FEATURE_MASK(ID_AA64DFR0_EL1_PMUVer),           =
                       \
> +                IDREG(vcpu->kvm, SYS_ID_AA64DFR0_EL1)) >=3D ID_AA64DFR0_=
EL1_PMUVer_V3P5)
>
>  u8 kvm_arm_pmu_get_pmuver_limit(void);
>
> --
> 2.39.2.722.g9855ee24e9-goog
>
>

Thank you,
Reiji
